Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41376 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728265AbfAHPAi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Jan 2019 10:00:38 -0500
Received: by mail-pg1-f193.google.com with SMTP id m1so1840861pgq.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Jan 2019 07:00:35 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v2 6/6] trace-cmd: Add VM kernel tracing using vsock socket for transport
Date: Tue,  8 Jan 2019 17:00:15 +0200
Message-Id: <20190108150015.21327-7-kaslevs@vmware.com>
In-Reply-To: <20190108150015.21327-1-kaslevs@vmware.com>
References: <20190108150015.21327-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

To test, start a VM and assign it a valid (> 2) unused CID:

    you@host # qemu-system-x86_64 \
        -name guest2 --uuid 7edfdf4a-cb9e-11e8-b38a-173b58342476 \
        -m 4096 -boot d -enable-kvm -smp 3 -net nic -net user -hda $HOME/vm/guest2.img \
        -device vhost-vsock-pci,id=vhost-vsock-pci0,guest-cid=3

and start `trace-cmd agent` on the guest as root:

     you@guest2 # trace-cmd agent

Finally, start `trace-cmd record` on the host (running as root is only necessary
if the host will be traced too):

     you@host $ trace-cmd record -A guest2 -e irq -e sched

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |  19 +
 tracecmd/trace-agent.c         | 228 ++++++++++
 tracecmd/trace-cmd.c           |   1 +
 tracecmd/trace-record.c        | 733 ++++++++++++++++++++++++++++-----
 tracecmd/trace-usage.c         |  11 +-
 6 files changed, 895 insertions(+), 98 deletions(-)
 create mode 100644 tracecmd/trace-agent.c

diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 3a11024..6f2e405 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -17,6 +17,7 @@ TRACE_CMD_OBJS += trace-record.o
 TRACE_CMD_OBJS += trace-read.o
 TRACE_CMD_OBJS += trace-split.o
 TRACE_CMD_OBJS += trace-listen.o
+TRACE_CMD_OBJS += trace-agent.o
 TRACE_CMD_OBJS += trace-stack.o
 TRACE_CMD_OBJS += trace-hist.o
 TRACE_CMD_OBJS += trace-mem.o
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index a1a06e9..5072d8e 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -12,6 +12,8 @@
 #include "trace-cmd.h"
 #include "event-utils.h"
 
+#define TRACE_AGENT_DEFAULT_PORT	823
+
 extern int debug;
 extern int quiet;
 
@@ -64,6 +66,8 @@ void trace_split(int argc, char **argv);
 
 void trace_listen(int argc, char **argv);
 
+void trace_agent(int argc, char **argv);
+
 void trace_restore(int argc, char **argv);
 
 void trace_clear(int argc, char **argv);
@@ -88,6 +92,10 @@ void trace_list(int argc, char **argv);
 
 void trace_usage(int argc, char **argv);
 
+int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
+		       int cpus, int *fds,
+		       int argc, char **argv);
+
 struct hook_list;
 
 void trace_init_profile(struct tracecmd_input *handle, struct hook_list *hooks,
@@ -149,6 +157,8 @@ char *strstrip(char *str);
 enum buffer_instance_flags {
 	BUFFER_FL_KEEP		= 1 << 0,
 	BUFFER_FL_PROFILE	= 1 << 1,
+	BUFFER_FL_GUEST		= 1 << 2,
+	BUFFER_FL_AGENT		= 1 << 3,
 };
 
 struct func_list {
@@ -174,6 +184,7 @@ struct buffer_instance {
 	struct func_list	*notrace_funcs;
 
 	const char		*clock;
+	int			*client_ports;
 
 	struct trace_seq	*s_save;
 	struct trace_seq	*s_print;
@@ -188,6 +199,14 @@ struct buffer_instance {
 	int			tracing_on_fd;
 	int			buffer_size;
 	int			cpu_count;
+
+	int			argc;
+	char			**argv;
+	int			argv_cap;
+
+	int			cid;
+	int			port;
+	int			*fds;
 };
 
 extern struct buffer_instance top_instance;
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
new file mode 100644
index 0000000..b34d757
--- /dev/null
+++ b/tracecmd/trace-agent.c
@@ -0,0 +1,228 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2018 VMware Inc, Slavomir Kaslev <kaslevs@vmware.com>
+ *
+ * based on prior implementation by Yoshihiro Yunomae
+ * Copyright (C) 2013 Hitachi, Ltd.
+ * Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <getopt.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/ioctl.h>
+#include <sys/socket.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include <linux/vm_sockets.h>
+
+#include "trace-local.h"
+#include "trace-msg.h"
+
+static int make_vsock(unsigned port)
+{
+	struct sockaddr_vm addr = {
+		.svm_family = AF_VSOCK,
+		.svm_cid = VMADDR_CID_ANY,
+		.svm_port = port,
+	};
+	int sd;
+
+	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
+	if (sd < 0)
+		return -1;
+
+	setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &(int){1}, sizeof(int));
+
+	if (bind(sd, (struct sockaddr *)&addr, sizeof(addr)))
+		return -1;
+
+	if (listen(sd, SOMAXCONN))
+		return -1;
+
+	return sd;
+}
+
+static int get_vsock_port(int sd)
+{
+	struct sockaddr_vm addr;
+	socklen_t addr_len = sizeof(addr);
+
+	if (getsockname(sd, (struct sockaddr *)&addr, &addr_len))
+		return -1;
+
+	if (addr.svm_family != AF_VSOCK)
+		return -1;
+
+	return addr.svm_port;
+}
+
+static void make_vsocks(int nr, int **fds, int **ports)
+{
+	int i, fd, port;
+
+	*fds = calloc(nr, sizeof(*fds));
+	*ports = calloc(nr, sizeof(*ports));
+	if (!*fds || !*ports)
+		die("Failed to allocate memory");
+
+	for (i = 0; i < nr; i++) {
+		fd = make_vsock(VMADDR_PORT_ANY);
+		if (fd < 0)
+			die("Failed to open vsock socket");
+
+		port = get_vsock_port(fd);
+		if (port < 0)
+			die("Failed to get vsock socket address");
+
+		(*fds)[i] = fd;
+		(*ports)[i] = port;
+	}
+}
+
+static void free_vsocks(int nr, int *fds, int *ports)
+{
+	int i;
+
+	for (i = 0; i < nr; i++)
+		close(fds[i]);
+	free(fds);
+	free(ports);
+}
+
+static void agent_handle(int sd, int nr_cpus, int page_size)
+{
+	struct tracecmd_msg_handle *msg_handle;
+	int *fds, *ports;
+	char **argv = NULL;
+	int argc = 0;
+
+	msg_handle = tracecmd_msg_handle_alloc(sd, TRACECMD_MSG_FL_CLIENT);
+	if (!msg_handle)
+		die("Failed to allocate message handle");
+
+	if (tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv))
+		die("Failed to receive trace request");
+
+	make_vsocks(nr_cpus, &fds, &ports);
+
+	if (tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, page_size, ports))
+		die("Failed to send trace response");
+
+	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv);
+
+	free_vsocks(nr_cpus, fds, ports);
+	free(argv[0]);
+	free(argv);
+	tracecmd_msg_handle_close(msg_handle);
+	exit(0);
+}
+
+static volatile pid_t handler_pid;
+
+static void handle_sigchld(int sig)
+{
+	int wstatus;
+	pid_t pid;
+
+	for (;;) {
+		pid = waitpid(-1, &wstatus, WNOHANG);
+		if (pid <= 0)
+			break;
+
+		if (pid == handler_pid)
+			handler_pid = 0;
+	}
+}
+
+static void agent_serve(unsigned port)
+{
+	int sd, cd, nr_cpus;
+	pid_t pid;
+
+	signal(SIGCHLD, handle_sigchld);
+
+	nr_cpus = count_cpus();
+	page_size = getpagesize();
+
+	sd = make_vsock(port);
+	if (sd < 0)
+		die("Failed to open vsock socket");
+
+	for (;;) {
+		cd = accept(sd, NULL, NULL);
+		if (cd < 0) {
+			if (errno == EINTR)
+				continue;
+			die("accept");
+		}
+
+		if (handler_pid)
+			goto busy;
+
+		pid = fork();
+		if (pid == 0) {
+			signal(SIGCHLD, SIG_DFL);
+			agent_handle(cd, nr_cpus, page_size);
+		}
+		if (pid > 0)
+			handler_pid = pid;
+
+	busy:
+		close(cd);
+	}
+
+	close(sd);
+	signal(SIGCHLD, SIG_DFL);
+}
+
+void trace_agent(int argc, char **argv)
+{
+	bool do_daemon = false;
+	unsigned port = TRACE_AGENT_DEFAULT_PORT;
+
+	if (argc < 2)
+		usage(argv);
+
+	if (strcmp(argv[1], "agent") != 0)
+		usage(argv);
+
+	for (;;) {
+		int c, option_index = 0;
+		static struct option long_options[] = {
+			{"port", required_argument, NULL, 'p'},
+			{"help", no_argument, NULL, '?'},
+			{NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long(argc-1, argv+1, "+hp:D",
+				long_options, &option_index);
+		if (c == -1)
+			break;
+		switch (c) {
+		case 'h':
+			usage(argv);
+			break;
+		case 'p':
+			port = atoi(optarg);
+			break;
+		case 'D':
+			do_daemon = true;
+			break;
+		default:
+			usage(argv);
+		}
+	}
+
+	if ((argc - optind) >= 2)
+		usage(argv);
+
+	if (do_daemon && daemon(1, 0))
+		die("daemon");
+
+	agent_serve(port);
+}
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 797b303..2d4fc1b 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -83,6 +83,7 @@ struct command commands[] = {
 	{"hist", trace_hist},
 	{"mem", trace_mem},
 	{"listen", trace_listen},
+	{"agent", trace_agent},
 	{"split", trace_split},
 	{"restore", trace_restore},
 	{"stack", trace_stack},
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e45a1f8..1783875 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -32,6 +32,7 @@
 #include <errno.h>
 #include <limits.h>
 #include <libgen.h>
+#include <linux/vm_sockets.h>
 
 #include "trace-local.h"
 #include "trace-msg.h"
@@ -73,8 +74,6 @@ static int buffers;
 static int clear_function_filters;
 
 static char *host;
-static int *client_ports;
-static int sfd;
 
 /* Max size to let a per cpu file get */
 static int max_kb;
@@ -170,6 +169,15 @@ static struct tracecmd_recorder *recorder;
 
 static int ignore_event_not_found = 0;
 
+static inline size_t grow_cap(size_t old_cap)
+{
+	size_t cap = 3 * old_cap / 2;
+
+	if (cap < 16)
+		cap = 16;
+	return cap;
+}
+
 static inline int is_top_instance(struct buffer_instance *instance)
 {
 	return instance == &top_instance;
@@ -190,6 +198,36 @@ enum {
 	RESET_HIGH_PRIO		= 100000,
 };
 
+enum trace_cmd {
+	CMD_extract,
+	CMD_start,
+	CMD_stream,
+	CMD_profile,
+	CMD_record,
+	CMD_record_agent,
+};
+
+struct common_record_context {
+	enum trace_cmd curr_cmd;
+	struct buffer_instance *instance;
+	const char *output;
+	char *date2ts;
+	char *max_graph_depth;
+	int data_flags;
+
+	int record_all;
+	int total_disable;
+	int disable;
+	int events;
+	int global;
+	int filtered;
+	int date;
+	int manual;
+	int topt;
+	int do_child;
+	int run_command;
+};
+
 static void add_reset_file(const char *file, const char *val, int prio)
 {
 	struct reset_file *reset;
@@ -487,6 +525,36 @@ static char *get_temp_file(struct buffer_instance *instance, int cpu)
 	return file;
 }
 
+static char *get_guest_file(const char *file, const char *guest)
+{
+	size_t guest_len = strlen(guest);
+	size_t file_len = strlen(file);
+	size_t base_len, idx = 0;
+	const char *p;
+	char *out;
+
+	out = malloc(file_len + guest_len + 2 /* dash and \0 */);
+	if (!out)
+		return NULL;
+
+	p = strrchr(file, '.');
+	if (p && p != file)
+		base_len = p - file;
+	else
+		base_len = file_len;
+
+	memcpy(out, file, base_len);
+	idx += base_len;
+	out[idx++] = '-';
+	memcpy(out + idx, guest, guest_len);
+	idx += guest_len;
+	memcpy(out + idx, p, file_len - base_len);
+	idx += file_len - base_len;
+	out[idx] = '\0';
+
+	return out;
+}
+
 static void put_temp_file(char *file)
 {
 	free(file);
@@ -592,6 +660,16 @@ static void delete_thread_data(void)
 	}
 }
 
+static void tell_guests_to_stop(void)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance) {
+		if (instance->flags & BUFFER_FL_GUEST)
+			tracecmd_msg_handle_close(instance->msg_handle);
+	}
+}
+
 static void stop_threads(enum trace_type type)
 {
 	struct timeval tv = { 0, 0 };
@@ -601,6 +679,8 @@ static void stop_threads(enum trace_type type)
 	if (!recorder_threads)
 		return;
 
+	tell_guests_to_stop();
+
 	/* Tell all threads to finish up */
 	for (i = 0; i < recorder_threads; i++) {
 		if (pids[i].pid > 0) {
@@ -750,6 +830,9 @@ static void __clear_trace(struct buffer_instance *instance)
 	FILE *fp;
 	char *path;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	/* reset the trace */
 	path = get_instance_file(instance, "trace");
 	fp = fopen(path, "w");
@@ -1233,6 +1316,9 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 	char *path;
 	char zero = '0';
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	path = get_instance_file(instance, "current_tracer");
 	fp = fopen(path, "w");
 	if (!fp) {
@@ -1329,6 +1415,9 @@ static void disable_func_stack_trace_instance(struct buffer_instance *instance)
 	int size;
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	path = get_instance_file(instance, "current_tracer");
 	ret = stat(path, &st);
 	tracecmd_put_tracing_file(path);
@@ -1522,6 +1611,9 @@ reset_events_instance(struct buffer_instance *instance)
 	int i;
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	if (use_old_event_method()) {
 		/* old way only had top instance */
 		if (!is_top_instance(instance))
@@ -1873,6 +1965,9 @@ static void write_tracing_on(struct buffer_instance *instance, int on)
 	int ret;
 	int fd;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	fd = open_tracing_on(instance);
 	if (fd < 0)
 		return;
@@ -1892,6 +1987,9 @@ static int read_tracing_on(struct buffer_instance *instance)
 	char buf[10];
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return -1;
+
 	fd = open_tracing_on(instance);
 	if (fd < 0)
 		return fd;
@@ -2125,6 +2223,9 @@ static void set_mask(struct buffer_instance *instance)
 	int fd;
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	if (!instance->cpumask)
 		return;
 
@@ -2155,6 +2256,9 @@ static void enable_events(struct buffer_instance *instance)
 {
 	struct event_list *event;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	for (event = instance->events; event; event = event->next) {
 		if (!event->neg)
 			update_event(event, event->filter, 0, '1');
@@ -2178,6 +2282,9 @@ static void set_clock(struct buffer_instance *instance)
 	char *content;
 	char *str;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	if (!instance->clock)
 		return;
 
@@ -2207,6 +2314,9 @@ static void set_max_graph_depth(struct buffer_instance *instance, char *max_grap
 	char *path;
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	path = get_instance_file(instance, "max_graph_depth");
 	reset_save_file(path, RESET_DEFAULT_PRIO);
 	tracecmd_put_tracing_file(path);
@@ -2432,6 +2542,9 @@ static void expand_event_instance(struct buffer_instance *instance)
 	struct event_list *compressed_list = instance->events;
 	struct event_list *event;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	reset_event_list(instance);
 
 	while (compressed_list) {
@@ -2507,14 +2620,14 @@ static void flush(int sig)
 		tracecmd_stop_recording(recorder);
 }
 
-static void connect_port(int cpu)
+static int connect_port(const char *host, unsigned port)
 {
 	struct addrinfo hints;
 	struct addrinfo *results, *rp;
-	int s;
+	int s, sfd;
 	char buf[BUFSIZ];
 
-	snprintf(buf, BUFSIZ, "%d", client_ports[cpu]);
+	snprintf(buf, BUFSIZ, "%d", port);
 
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family = AF_UNSPEC;
@@ -2541,7 +2654,182 @@ static void connect_port(int cpu)
 
 	freeaddrinfo(results);
 
-	client_ports[cpu] = sfd;
+	return sfd;
+}
+
+static int open_vsock(unsigned cid, unsigned port)
+{
+	struct sockaddr_vm addr = {
+		.svm_family = AF_VSOCK,
+		.svm_cid = cid,
+		.svm_port = port,
+	};
+	int sd;
+
+	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
+	if (sd < 0)
+		return -1;
+
+	if (connect(sd, (struct sockaddr *)&addr, sizeof(addr)))
+		return -1;
+
+	return sd;
+}
+
+static int do_accept(int sd)
+{
+	int cd;
+
+	for (;;) {
+		cd = accept(sd, NULL, NULL);
+		if (cd < 0) {
+			if (errno == EINTR)
+				continue;
+			die("accept");
+		}
+
+		return cd;
+	}
+
+	return -1;
+}
+
+static bool is_digits(const char *s)
+{
+	const char *p;
+
+	for (p = s; *p; p++)
+		if (!isdigit(*p))
+			return false;
+
+	return true;
+}
+
+struct guest {
+	char *name;
+	int cid;
+	int pid;
+};
+
+static size_t guests_cap, guests_len;
+static struct guest *guests;
+
+static char *get_qemu_guest_name(char *arg)
+{
+	char *tok, *end = arg;
+
+	while ((tok = strsep(&end, ","))) {
+		if (strncmp(tok, "guest=", 6) == 0)
+			return tok + 6;
+	}
+
+	return arg;
+}
+
+static void read_qemu_guests(void)
+{
+	static bool initialized = false;
+	struct dirent *entry;
+	char path[PATH_MAX];
+	DIR *dir;
+
+	if (initialized)
+		return;
+
+	initialized = true;
+	dir = opendir("/proc");
+	if (!dir)
+		die("opendir");
+
+	for (entry = readdir(dir); entry; entry = readdir(dir)) {
+		bool is_qemu = false, last_was_name = false;
+		struct guest guest = {};
+		char *p, *arg = NULL;
+		size_t arg_size = 0;
+		FILE *f;
+
+		if (!(entry->d_type == DT_DIR && is_digits(entry->d_name)))
+			continue;
+
+		guest.pid = atoi(entry->d_name);
+		snprintf(path, sizeof(path), "/proc/%s/cmdline", entry->d_name);
+		f = fopen(path, "r");
+		if (!f)
+			continue;
+
+		while (getdelim(&arg, &arg_size, 0, f) != -1) {
+			if (!is_qemu && strstr(arg, "qemu-system-")) {
+				is_qemu = true;
+				continue;
+			}
+
+			if (!is_qemu)
+				continue;
+
+			if (strcmp(arg, "-name") == 0) {
+				last_was_name = true;
+				continue;
+			}
+
+			if (last_was_name) {
+				guest.name = strdup(get_qemu_guest_name(arg));
+				last_was_name = false;
+				continue;
+			}
+
+			p = strstr(arg, "guest-cid=");
+			if (p) {
+				guest.cid = atoi(p + 10);
+				continue;
+			}
+		}
+
+		if (is_qemu) {
+			if (guests_cap == guests_len) {
+				guests_cap = grow_cap(guests_cap);
+				guests = realloc(guests,
+						 guests_cap * sizeof(*guests));
+			}
+			guests[guests_len++] = guest;
+		}
+
+		free(arg);
+		fclose(f);
+	}
+
+	closedir(dir);
+}
+
+static char *parse_guest_name(char *guest, int *cid, int *port)
+{
+	size_t i;
+	char *p;
+
+	*port = -1;
+	p = strrchr(guest, ':');
+	if (p) {
+		*p = '\0';
+		*port = atoi(p + 1);
+	}
+
+	*cid = -1;
+	p = strrchr(guest, '@');
+	if (p) {
+		*p = '\0';
+		*cid = atoi(p + 1);
+	} else if (is_digits(guest))
+		*cid = atoi(guest);
+
+	read_qemu_guests();
+	for (i = 0; i < guests_len; i++) {
+		if ((*cid > 0 && *cid == guests[i].cid) ||
+		    strcmp(guest, guests[i].name) == 0) {
+			*cid = guests[i].cid;
+			return guests[i].name;
+		}
+	}
+
+	return guest;
 }
 
 static void set_prio(int prio)
@@ -2588,6 +2876,16 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 	struct tracecmd_recorder *record;
 	char *path;
 
+	if (instance->flags & BUFFER_FL_GUEST) {
+		int sd;
+
+		sd = open_vsock(instance->cid, instance->client_ports[cpu]);
+		if (sd < 0)
+			die("Failed to connect to agent");
+
+		return tracecmd_create_recorder_virt(file, cpu, sd);
+	}
+
 	if (brass)
 		return create_recorder_instance_pipe(instance, cpu, brass);
 
@@ -2612,7 +2910,7 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 {
 	long ret;
 	char *file;
-	int pid;
+	pid_t pid;
 
 	if (type != TRACE_TYPE_EXTRACT) {
 		signal(SIGUSR1, flush);
@@ -2631,19 +2929,26 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 		instance->cpu_count = 0;
 	}
 
-	if (client_ports) {
-		char *path;
+	if ((instance->client_ports && !(instance->flags & BUFFER_FL_GUEST)) ||
+	    (instance->flags & BUFFER_FL_AGENT)) {
+		unsigned flags = recorder_flags;
+		char *path = NULL;
+		int fd;
 
-		connect_port(cpu);
-		if (instance->name)
+		if (instance->flags & BUFFER_FL_AGENT) {
+			fd = do_accept(instance->fds[cpu]);
+			flags |= TRACECMD_RECORD_NOSPLICE;
+		} else {
+			fd = connect_port(host, instance->client_ports[cpu]);
+		}
+		if (fd < 0)
+			die("Failed connecting to client");
+		if (instance->name && !(instance->flags & BUFFER_FL_AGENT))
 			path = get_instance_dir(instance);
 		else
 			path = tracecmd_find_tracing_dir();
-		recorder = tracecmd_create_buffer_recorder_fd(client_ports[cpu],
-							      cpu, recorder_flags,
-							      path);
-		if (instance->name)
-			tracecmd_put_tracing_file(path);
+		recorder = tracecmd_create_buffer_recorder_fd(fd, cpu, flags, path);
+		tracecmd_put_tracing_file(path);
 	} else {
 		file = get_temp_file(instance, cpu);
 		recorder = create_recorder_instance(instance, file, cpu, brass);
@@ -2681,7 +2986,8 @@ static void check_first_msg_from_server(struct tracecmd_msg_handle *msg_handle)
 		die("server not tracecmd server");
 }
 
-static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
+static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle,
+					 int **client_ports)
 {
 	char buf[BUFSIZ];
 	ssize_t n;
@@ -2724,8 +3030,8 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
 		/* No options */
 		write(msg_handle->fd, "0", 2);
 
-	client_ports = malloc(sizeof(int) * local_cpu_count);
-	if (!client_ports)
+	*client_ports = malloc(sizeof(int) * local_cpu_count);
+	if (!*client_ports)
 		die("Failed to allocate client ports for %d cpus", local_cpu_count);
 
 	/*
@@ -2743,13 +3049,14 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
 		if (i == BUFSIZ)
 			die("read bad port number");
 		buf[i] = 0;
-		client_ports[cpu] = atoi(buf);
+		(*client_ports)[cpu] = atoi(buf);
 	}
 }
 
-static void communicate_with_listener_v3(struct tracecmd_msg_handle *msg_handle)
+static void communicate_with_listener_v3(struct tracecmd_msg_handle *msg_handle,
+					 int **client_ports)
 {
-	if (tracecmd_msg_send_init_data(msg_handle, &client_ports) < 0)
+	if (tracecmd_msg_send_init_data(msg_handle, client_ports) < 0)
 		die("Cannot communicate with server");
 }
 
@@ -2800,7 +3107,7 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 	}
 }
 
-static struct tracecmd_msg_handle *setup_network(void)
+static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instance)
 {
 	struct tracecmd_msg_handle *msg_handle = NULL;
 	struct addrinfo hints;
@@ -2870,29 +3177,29 @@ again:
 			close(sfd);
 			goto again;
 		}
-		communicate_with_listener_v3(msg_handle);
+		communicate_with_listener_v3(msg_handle, &instance->client_ports);
 	}
 
 	if (msg_handle->version == V1_PROTOCOL)
-		communicate_with_listener_v1(msg_handle);
+		communicate_with_listener_v1(msg_handle, &instance->client_ports);
 
 	return msg_handle;
 }
 
-static void add_options(struct tracecmd_output *handle, char *date2ts, int flags);
+static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx);
 
 static struct tracecmd_msg_handle *
-setup_connection(struct buffer_instance *instance, char *date2ts, int flags)
+setup_connection(struct buffer_instance *instance, struct common_record_context *ctx)
 {
 	struct tracecmd_msg_handle *msg_handle;
 	struct tracecmd_output *network_handle;
 
-	msg_handle = setup_network();
+	msg_handle = setup_network(instance);
 
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
 		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
-		add_options(network_handle, date2ts, flags);
+		add_options(network_handle, ctx);
 		tracecmd_write_cpus(network_handle, instance->cpu_count);
 		tracecmd_write_options(network_handle);
 		tracecmd_msg_finish_sending_data(msg_handle);
@@ -2911,32 +3218,99 @@ static void finish_network(struct tracecmd_msg_handle *msg_handle)
 	if (msg_handle->version == V3_PROTOCOL)
 		tracecmd_msg_send_close_msg(msg_handle);
 	tracecmd_msg_handle_close(msg_handle);
-	free(host);
 }
 
-void start_threads(enum trace_type type, int global, char *date2ts, int flags)
+static void connect_to_agent(struct buffer_instance *instance)
+{
+	struct tracecmd_msg_handle *msg_handle;
+	int sd, nr_cpus, page_size, *ports;
+
+	sd = open_vsock(instance->cid, instance->port);
+	if (sd < 0)
+		die("Failed to connect to vsock socket @%d:%d",
+		    instance->cid, instance->port);
+
+	msg_handle = tracecmd_msg_handle_alloc(sd, TRACECMD_MSG_FL_SERVER);
+	if (!msg_handle)
+		die("Failed to allocate message handle");
+
+	if (tracecmd_msg_send_trace_req(msg_handle, instance->argc, instance->argv))
+		die("Failed to send trace request");
+
+	if (tracecmd_msg_recv_trace_resp(msg_handle, &nr_cpus, &page_size, &ports))
+		die("Failed to receive trace response");
+
+	instance->client_ports = ports;
+	instance->cpu_count = nr_cpus;
+
+	/* the msg_handle now points to the guest fd */
+	instance->msg_handle = msg_handle;
+}
+
+static void setup_guest(struct buffer_instance *instance)
+{
+	struct tracecmd_msg_handle *msg_handle = instance->msg_handle;
+	char *file;
+	int fd;
+
+	/* Create a place to store the guest meta data */
+	file = get_guest_file(output_file, instance->name);
+	if (!file)
+		die("Failed to allocate memory");
+
+	fd = open(file, O_CREAT|O_WRONLY|O_TRUNC, 0644);
+	put_temp_file(file);
+	if (fd < 0)
+		die("Failed to open", file);
+
+	/* Start reading the fds here */
+	if (tracecmd_msg_read_data(msg_handle, fd))
+		die("Failed receiving metadata");
+	close(fd);
+}
+
+static void setup_agent(struct buffer_instance *instance, struct common_record_context *ctx)
+{
+	struct tracecmd_output *network_handle;
+
+	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
+						     listed_events);
+	add_options(network_handle, ctx);
+	tracecmd_write_cpus(network_handle, instance->cpu_count);
+	tracecmd_write_options(network_handle);
+	tracecmd_msg_finish_sending_data(instance->msg_handle);
+	instance->network_handle = network_handle;
+}
+
+void start_threads(enum trace_type type, struct common_record_context *ctx)
 {
 	struct buffer_instance *instance;
-	int *brass = NULL;
 	int total_cpu_count = 0;
 	int i = 0;
 	int ret;
 
-	for_all_instances(instance)
+	for_all_instances(instance) {
+		/* Start the connection now to find out how many CPUs we need */
+		if (instance->flags & BUFFER_FL_GUEST)
+			connect_to_agent(instance);
 		total_cpu_count += instance->cpu_count;
+	}
 
 	/* make a thread for every CPU we have */
-	pids = malloc(sizeof(*pids) * total_cpu_count * (buffers + 1));
+	pids = calloc(total_cpu_count * (buffers + 1), sizeof(*pids));
 	if (!pids)
-		die("Failed to allocat pids for %d cpus", total_cpu_count);
-
-	memset(pids, 0, sizeof(*pids) * total_cpu_count * (buffers + 1));
+		die("Failed to allocate pids for %d cpus", total_cpu_count);
 
 	for_all_instances(instance) {
+		int *brass = NULL;
 		int x, pid;
 
-		if (host) {
-			instance->msg_handle = setup_connection(instance, date2ts, flags);
+		if (instance->flags & BUFFER_FL_AGENT) {
+			setup_agent(instance, ctx);
+		} else if (instance->flags & BUFFER_FL_GUEST) {
+			setup_guest(instance);
+		} else if (host) {
+			instance->msg_handle = setup_connection(instance, ctx);
 			if (!instance->msg_handle)
 				die("Failed to make connection");
 		}
@@ -2951,7 +3325,7 @@ void start_threads(enum trace_type type, int global, char *date2ts, int flags)
 								   brass[0],
 								   instance->cpu_count,
 								   hooks, handle_init,
-								   global);
+								   ctx->global);
 				if (!pids[i].stream)
 					die("Creating stream for %d", i);
 			} else
@@ -3075,13 +3449,14 @@ static void print_stat(struct buffer_instance *instance)
 {
 	int cpu;
 
+	if (quiet)
+		return;
+
 	if (!is_top_instance(instance))
-		if (!quiet)
-			printf("\nBuffer: %s\n\n", instance->name);
+		printf("\nBuffer: %s\n\n", instance->name);
 
 	for (cpu = 0; cpu < instance->cpu_count; cpu++)
-		if (!quiet)
-			trace_seq_do_printf(&instance->s_print[cpu]);
+		trace_seq_do_printf(&instance->s_print[cpu]);
 }
 
 enum {
@@ -3090,27 +3465,64 @@ enum {
 	DATA_FL_OFFSET		= 2,
 };
 
-static void add_options(struct tracecmd_output *handle, char *date2ts, int flags)
+static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
 {
 	int type = 0;
 
-	if (date2ts) {
-		if (flags & DATA_FL_DATE)
+	if (ctx->date2ts) {
+		if (ctx->data_flags & DATA_FL_DATE)
 			type = TRACECMD_OPTION_DATE;
-		else if (flags & DATA_FL_OFFSET)
+		else if (ctx->data_flags & DATA_FL_OFFSET)
 			type = TRACECMD_OPTION_OFFSET;
 	}
 
 	if (type)
-		tracecmd_add_option(handle, type, strlen(date2ts)+1, date2ts);
+		tracecmd_add_option(handle, type, strlen(ctx->date2ts)+1, ctx->date2ts);
 
 	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
 	add_option_hooks(handle);
 	add_uname(handle);
+}
+
+static void write_guest_file(struct buffer_instance *instance)
+{
+	struct tracecmd_output *handle;
+	int cpu_count = instance->cpu_count;
+	char *file;
+	char **temp_files;
+	int i, fd;
+
+	file = get_guest_file(output_file, instance->name);
+	fd = open(file, O_RDWR);
+	if (fd < 0)
+		die("error opening %s", file);
+	put_temp_file(file);
+
+	handle = tracecmd_get_output_handle_fd(fd);
+	if (!handle)
+		die("error writing to %s", file);
+
+	temp_files = malloc(sizeof(*temp_files) * cpu_count);
+	if (!temp_files)
+		die("failed to allocate temp_files for %d cpus",
+		    cpu_count);
+
+	for (i = 0; i < cpu_count; i++) {
+		temp_files[i] = get_temp_file(instance, i);
+		if (!temp_files[i])
+			die("failed to allocate memory");
+	}
+
+	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files) < 0)
+		die("failed to write CPU data");
+	tracecmd_output_close(handle);
 
+	for (i = 0; i < cpu_count; i++)
+		put_temp_file(temp_files[i]);
+	free(temp_files);
 }
 
-static void record_data(char *date2ts, int flags)
+static void record_data(struct common_record_context *ctx)
 {
 	struct tracecmd_option **buffer_options;
 	struct tracecmd_output *handle;
@@ -3121,7 +3533,9 @@ static void record_data(char *date2ts, int flags)
 	int i;
 
 	for_all_instances(instance) {
-		if (instance->msg_handle)
+		if (instance->flags & BUFFER_FL_GUEST)
+			write_guest_file(instance);
+		else if (host && instance->msg_handle)
 			finish_network(instance->msg_handle);
 		else
 			local = true;
@@ -3165,7 +3579,7 @@ static void record_data(char *date2ts, int flags)
 		if (!handle)
 			die("Error creating output file");
 
-		add_options(handle, date2ts, flags);
+		add_options(handle, ctx);
 
 		/* Only record the top instance under TRACECMD_OPTION_CPUSTAT*/
 		if (!no_top_instance() && !top_instance.msg_handle) {
@@ -3305,6 +3719,9 @@ static void set_funcs(struct buffer_instance *instance)
 	int set_notrace = 0;
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	ret = write_func_file(instance, "set_ftrace_filter", &instance->filter_funcs);
 	if (ret < 0)
 		die("set_ftrace_filter does not exist. Can not filter functions");
@@ -3600,6 +4017,9 @@ static void set_buffer_size_instance(struct buffer_instance *instance)
 	int ret;
 	int fd;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	if (!buffer_size)
 		return;
 
@@ -3797,6 +4217,9 @@ static void make_instances(void)
 	int ret;
 
 	for_each_instance(instance) {
+		if (instance->flags & BUFFER_FL_GUEST)
+			continue;
+
 		path = get_instance_dir(instance);
 		ret = stat(path, &st);
 		if (ret < 0) {
@@ -3818,7 +4241,7 @@ void tracecmd_remove_instances(void)
 
 	for_each_instance(instance) {
 		/* Only delete what we created */
-		if (instance->flags & BUFFER_FL_KEEP)
+		if (instance->flags & (BUFFER_FL_KEEP | BUFFER_FL_GUEST))
 			continue;
 		if (instance->tracing_on_fd > 0) {
 			close(instance->tracing_on_fd);
@@ -3900,7 +4323,7 @@ static void check_function_plugin(void)
 
 static int __check_doing_something(struct buffer_instance *instance)
 {
-	return (instance->flags & BUFFER_FL_PROFILE) ||
+	return (instance->flags & (BUFFER_FL_PROFILE | BUFFER_FL_GUEST)) ||
 		instance->plugin || instance->events;
 }
 
@@ -3922,6 +4345,9 @@ update_plugin_instance(struct buffer_instance *instance,
 {
 	const char *plugin = instance->plugin;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	if (!plugin)
 		return;
 
@@ -4021,6 +4447,9 @@ static void record_stats(void)
 	int cpu;
 
 	for_all_instances(instance) {
+		if (instance->flags & BUFFER_FL_GUEST)
+			continue;
+
 		s_save = instance->s_save;
 		s_print = instance->s_print;
 		for (cpu = 0; cpu < instance->cpu_count; cpu++) {
@@ -4047,6 +4476,9 @@ static void destroy_stats(void)
 	int cpu;
 
 	for_all_instances(instance) {
+		if (instance->flags & BUFFER_FL_GUEST)
+			continue;
+
 		for (cpu = 0; cpu < instance->cpu_count; cpu++) {
 			trace_seq_destroy(&instance->s_save[cpu]);
 			trace_seq_destroy(&instance->s_print[cpu]);
@@ -4321,6 +4753,7 @@ void trace_stop(int argc, char **argv)
 		c = getopt(argc-1, argv+1, "hatB:");
 		if (c == -1)
 			break;
+
 		switch (c) {
 		case 'h':
 			usage(argv);
@@ -4467,35 +4900,6 @@ void trace_reset(int argc, char **argv)
 	exit(0);
 }
 
-enum trace_cmd {
-	CMD_extract,
-	CMD_start,
-	CMD_stream,
-	CMD_profile,
-	CMD_record
-};
-
-struct common_record_context {
-	enum trace_cmd curr_cmd;
-	struct buffer_instance *instance;
-	const char *output;
-	char *date2ts;
-	char *max_graph_depth;
-	int data_flags;
-
-	int record_all;
-	int total_disable;
-	int disable;
-	int events;
-	int global;
-	int filtered;
-	int date;
-	int manual;
-	int topt;
-	int do_child;
-	int run_command;
-};
-
 static void init_common_record_context(struct common_record_context *ctx,
 				       enum trace_cmd curr_cmd)
 {
@@ -4512,6 +4916,60 @@ static void init_common_record_context(struct common_record_context *ctx,
 #define IS_STREAM(ctx) ((ctx)->curr_cmd == CMD_stream)
 #define IS_PROFILE(ctx) ((ctx)->curr_cmd == CMD_profile)
 #define IS_RECORD(ctx) ((ctx)->curr_cmd == CMD_record)
+#define IS_AGENT(ctx) ((ctx)->curr_cmd == CMD_record_agent)
+
+static void add_argv(struct buffer_instance *instance, char *arg)
+{
+	if (instance->argv_cap == instance->argc) {
+		instance->argv_cap = grow_cap(instance->argv_cap);
+		instance->argv = realloc(instance->argv,
+					 instance->argv_cap * sizeof(char *));
+		if (!instance->argv)
+			die("Can not allocate buffer args");
+	}
+	instance->argv[instance->argc] = arg;
+	instance->argc++;
+}
+
+static void add_arg(struct buffer_instance *instance,
+		    int c, const char *opts,
+		    struct option *long_options, char *optarg)
+{
+	char *ptr;
+	char *arg;
+	int ret;
+	int i;
+
+	/* Short or long arg */
+	if (!(c & 0x80)) {
+		ret = asprintf(&arg, "-%c", c);
+		if (ret < 0)
+			die("Can not allocate argument");
+		ptr = strstr(opts, arg+1);
+		if (!ptr)
+			return; /* Not found? */
+		add_argv(instance, arg);
+		if (ptr[1] == ':')
+			add_argv(instance, optarg);
+		return;
+	}
+	for (i = 0; long_options[i].name; i++) {
+		if (c == long_options[i].val) {
+			ret = asprintf(&arg, "--%s", long_options[i].name);
+			if (ret < 0)
+				die("Can not allocate argument");
+			add_argv(instance, arg);
+			if (long_options[i].has_arg) {
+				arg = strdup(optarg);
+				if (!arg)
+					die("Can not allocate arguments");
+				add_argv(instance, arg);
+				return;
+			}
+		}
+	}
+	/* Not found? */
+}
 
 static void parse_record_options(int argc,
 				 char **argv,
@@ -4553,10 +5011,20 @@ static void parse_record_options(int argc,
 		if (IS_EXTRACT(ctx))
 			opts = "+haf:Fp:co:O:sr:g:l:n:P:N:tb:B:ksiT";
 		else
-			opts = "+hae:f:Fp:cC:dDGo:O:s:r:vg:l:n:P:N:tb:R:B:ksSiTm:M:H:q";
+			opts = "+hae:f:FA:p:cC:dDGo:O:s:r:vg:l:n:P:N:tb:R:B:ksSiTm:M:H:q";
 		c = getopt_long (argc-1, argv+1, opts, long_options, &option_index);
 		if (c == -1)
 			break;
+
+		/*
+		 * If the current instance is to record a guest, then save
+		 * all the arguments for this instance.
+		 */
+		if (c != 'B' && c != 'A' && ctx->instance->flags & BUFFER_FL_GUEST) {
+			add_arg(ctx->instance, c, opts, long_options, optarg);
+			continue;
+		}
+
 		switch (c) {
 		case 'h':
 			usage(argv);
@@ -4609,6 +5077,26 @@ static void parse_record_options(int argc,
 			add_trigger(event, optarg);
 			break;
 
+		case 'A': {
+			char *name = NULL;
+			int cid = -1, port = -1;
+
+			if (!IS_RECORD(ctx))
+				die("-A is only allowed for record operations");
+
+			name = parse_guest_name(optarg, &cid, &port);
+			if (!name || cid == -1)
+				die("guest %s not found", optarg);
+			if (port == -1)
+				port = TRACE_AGENT_DEFAULT_PORT;
+
+			ctx->instance = create_instance(name);
+			ctx->instance->flags |= BUFFER_FL_GUEST;
+			ctx->instance->cid = cid;
+			ctx->instance->port = port;
+			add_instance(ctx->instance, 0);
+			break;
+		}
 		case 'F':
 			test_set_event_pid();
 			filter_task = 1;
@@ -4679,6 +5167,8 @@ static void parse_record_options(int argc,
 			ctx->disable = 1;
 			break;
 		case 'o':
+			if (IS_AGENT(ctx))
+				die("-o incompatible with agent recording");
 			if (host)
 				die("-o incompatible with -N");
 			if (IS_START(ctx))
@@ -4740,6 +5230,8 @@ static void parse_record_options(int argc,
 		case 'N':
 			if (!IS_RECORD(ctx))
 				die("-N only available with record");
+			if (IS_AGENT(ctx))
+				die("-N incompatible with agent recording");
 			if (ctx->output)
 				die("-N incompatible with -o");
 			host = optarg;
@@ -4866,7 +5358,8 @@ static enum trace_type get_trace_cmd_type(enum trace_cmd cmd)
 		{CMD_stream, TRACE_TYPE_STREAM},
 		{CMD_extract, TRACE_TYPE_EXTRACT},
 		{CMD_profile, TRACE_TYPE_STREAM},
-		{CMD_start, TRACE_TYPE_START}
+		{CMD_start, TRACE_TYPE_START},
+		{CMD_record_agent, TRACE_TYPE_RECORD}
 	};
 
 	for (int i = 0; i < ARRAY_SIZE(trace_type_per_command); i++) {
@@ -4898,6 +5391,8 @@ static void finalize_record_trace(struct common_record_context *ctx)
 		if (instance->flags & BUFFER_FL_KEEP)
 			write_tracing_on(instance,
 					 instance->tracing_on_init_val);
+		if (instance->flags & BUFFER_FL_AGENT)
+			tracecmd_output_close(instance->network_handle);
 	}
 
 	if (host)
@@ -4932,7 +5427,6 @@ static void record_trace(int argc, char **argv,
 
 	/* Save the state of tracing_on before starting */
 	for_all_instances(instance) {
-
 		if (!ctx->manual && instance->flags & BUFFER_FL_PROFILE)
 			enable_profile(instance);
 
@@ -4949,14 +5443,16 @@ static void record_trace(int argc, char **argv,
 
 	page_size = getpagesize();
 
-	fset = set_ftrace(!ctx->disable, ctx->total_disable);
+	if (!(ctx->instance->flags & BUFFER_FL_GUEST))
+		fset = set_ftrace(!ctx->disable, ctx->total_disable);
 	tracecmd_disable_all_tracing(1);
 
 	for_all_instances(instance)
 		set_clock(instance);
 
 	/* Record records the date first */
-	if (IS_RECORD(ctx) && ctx->date)
+	if (((IS_RECORD(ctx) && !(ctx->instance->flags & BUFFER_FL_GUEST)) ||
+	     IS_AGENT(ctx)) && ctx->date)
 		ctx->date2ts = get_date_to_ts();
 
 	for_all_instances(instance) {
@@ -4984,16 +5480,20 @@ static void record_trace(int argc, char **argv,
 	if (type & (TRACE_TYPE_RECORD | TRACE_TYPE_STREAM)) {
 		signal(SIGINT, finish);
 		if (!latency)
-			start_threads(type, ctx->global, ctx->date2ts, ctx->data_flags);
+			start_threads(type, ctx);
 	} else {
 		update_task_filter();
 		tracecmd_enable_tracing();
 		exit(0);
 	}
 
-	if (ctx->run_command)
+	if (ctx->run_command) {
 		run_cmd(type, (argc - optind) - 1, &argv[optind + 1]);
-	else {
+	} else if (ctx->instance && (ctx->instance->flags & BUFFER_FL_AGENT)) {
+		update_task_filter();
+		tracecmd_enable_tracing();
+		tracecmd_msg_wait_close(ctx->instance->msg_handle);
+	} else {
 		update_task_filter();
 		tracecmd_enable_tracing();
 		/* We don't ptrace ourself */
@@ -5014,11 +5514,13 @@ static void record_trace(int argc, char **argv,
 	if (!keep)
 		tracecmd_disable_all_tracing(0);
 
-	if (IS_RECORD(ctx)) {
-		record_data(ctx->date2ts, ctx->data_flags);
-		delete_thread_data();
-	} else
-		print_stats();
+	if (!IS_AGENT(ctx)) {
+		if (IS_RECORD(ctx)) {
+			record_data(ctx);
+			delete_thread_data();
+		} else
+			print_stats();
+	}
 
 	destroy_stats();
 	finalize_record_trace(ctx);
@@ -5095,7 +5597,7 @@ void trace_extract(int argc, char **argv)
 		ctx.date2ts = get_date_to_ts();
 	}
 
-	record_data(ctx.date2ts, ctx.data_flags);
+	record_data(&ctx);
 	delete_thread_data();
 	destroy_stats();
 	finalize_record_trace(&ctx);
@@ -5148,3 +5650,40 @@ void trace_record(int argc, char **argv)
 	record_trace(argc, argv, &ctx);
 	exit(0);
 }
+
+int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
+		       int cpus, int *fds,
+		       int argc, char **argv)
+{
+	struct common_record_context ctx;
+	char **argv_plus;
+
+	/* Reset optind for getopt_long */
+	optind = 1;
+	/*
+	 * argc is the number of elements in argv, but we need to convert
+	 * argc and argv into "trace-cmd", "record", argv.
+	 * where argc needs to grow by two.
+	 */
+	argv_plus = calloc(argc + 2, sizeof(char *));
+	if (!argv_plus)
+		return -ENOMEM;
+
+	argv_plus[0] = "trace-cmd";
+	argv_plus[1] = "record";
+	memcpy(argv_plus + 2, argv, argc * sizeof(char *));
+	argc += 2;
+
+	parse_record_options(argc, argv_plus, CMD_record_agent, &ctx);
+	if (ctx.run_command)
+		return -EINVAL;
+
+	ctx.instance->fds = fds;
+	ctx.instance->flags |= BUFFER_FL_AGENT;
+	ctx.instance->msg_handle = msg_handle;
+	msg_handle->version = V3_PROTOCOL;
+	record_trace(argc, argv, &ctx);
+
+	free(argv_plus);
+	return 0;
+}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 9ea1906..db8389d 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -231,11 +231,20 @@ static struct usage_help usage_help[] = {
 		"listen on a network socket for trace clients",
 		" %s listen -p port[-D][-o file][-d dir][-l logfile]\n"
 		"          Creates a socket to listen for clients.\n"
-		"          -D create it in daemon mode.\n"
+		"          -p port number to listen on.\n"
+		"          -D run in daemon mode.\n"
 		"          -o file name to use for clients.\n"
 		"          -d directory to store client files.\n"
 		"          -l logfile to write messages to.\n"
 	},
+	{
+		"agent",
+		"listen on a vsock socket for trace clients",
+		" %s agent -p port[-D]\n"
+		"          Creates a vsock socket to listen for clients.\n"
+		"          -p port number to listen on.\n"
+		"          -D run in daemon mode.\n"
+	},
 	{
 		"list",
 		"list the available events, plugins or options",
-- 
2.19.1
