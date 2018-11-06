Return-Path: <SRS0=lo60=NR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37926 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388800AbeKGAYv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Nov 2018 19:24:51 -0500
Received: by mail-wr1-f67.google.com with SMTP id d10-v6so13858050wrs.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Nov 2018 06:59:10 -0800 (PST)
From: kaslevs@vmware.com
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] Add VM kernel tracing using VSOCK socket for transport
Date: Tue,  6 Nov 2018 16:59:02 +0200
Message-Id: <20181106145902.13301-1-kaslevs@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Slavomir Kaslev <kaslevs@vmware.com>

To test, start a VM and assign it a valid (> 2) unused CID:

    you@host # qemu-system-x86_64 \
        -name guest2 --uuid 7edfdf4a-cb9e-11e8-b38a-173b58342476 \
        -m 4096 -boot d -enable-kvm -smp 3 -net nic -net user -hda $HOME/vm/guest2.img \
        -fsdev local,id=host,path=$HOME,security_model=mapped \
        -device virtio-9p-pci,fsdev=host,mount_tag=host \
        -device virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x6 \
        -chardev pipe,id=charchannel1,path=/var/lib/test/fifo0 \
        -device virtserialport,bus=virtio-serial0.0,nr=3,chardev=charchannel1,id=channel1,name=fifo0 \
        -device vhost-vsock-pci,id=vhost-vsock-pci0,guest-cid=3

and start `trace-cmd agent` on the guest as root:

     you@guest2 # trace-cmd agent

Finally, start `trace-cmd record` on the host (running as root is only necessary
if the host will be traced too):

     you@host $ trace-cmd record -A guest2 -e irq -e sched

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h  |  14 +
 lib/trace-cmd/trace-input.c    |   2 +-
 lib/trace-cmd/trace-recorder.c |  53 ++-
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |  19 +
 tracecmd/trace-agent.c         | 229 ++++++++++++
 tracecmd/trace-cmd.c           |   1 +
 tracecmd/trace-msg.c           | 219 ++++++++++-
 tracecmd/trace-record.c        | 666 ++++++++++++++++++++++++++++++---
 tracecmd/trace-usage.c         |  11 +-
 10 files changed, 1140 insertions(+), 75 deletions(-)
 create mode 100644 tracecmd/trace-agent.c

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 684ddb7..896fa4f 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -271,6 +271,7 @@ enum {
 void tracecmd_free_recorder(struct tracecmd_recorder *recorder);
 struct tracecmd_recorder *tracecmd_create_recorder(const char *file, int cpu, unsigned flags);
 struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned flags);
+struct tracecmd_recorder *tracecmd_create_recorder_virt(const char *file, int cpu, int trace_fd);
 struct tracecmd_recorder *tracecmd_create_recorder_maxkb(const char *file, int cpu, unsigned flags, int maxkb);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, const char *buffer);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, const char *buffer);
@@ -325,10 +326,23 @@ void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
 				 int *ports);
+int tracecmd_msg_read_metadata(struct tracecmd_msg_handle *msg_handle, int ofd);
 int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int ofd);
 bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
 void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
 
+int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
+				int argc, char **argv);
+int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
+				int *argc, char ***argv);
+
+int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
+				 int nr_cpus, int page_size, int *ports);
+int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
+				 int *nr_cpus, int *page_size, int **ports);
+
+int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle);
+
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index d70c110..7a8cbde 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2603,7 +2603,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
 {
 	struct tracecmd_input *handle;
 	char test[] = { 23, 8, 68 };
-    unsigned int page_size;
+	unsigned int page_size;
 	char *version;
 	char buf[BUFSIZ];
 
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 5331925..497f752 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -148,16 +148,22 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 	recorder->fd1 = fd;
 	recorder->fd2 = fd2;
 
-	if (flags & TRACECMD_RECORD_SNAPSHOT)
-		ret = asprintf(&path, "%s/per_cpu/cpu%d/snapshot_raw", buffer, cpu);
-	else
-		ret = asprintf(&path, "%s/per_cpu/cpu%d/trace_pipe_raw", buffer, cpu);
-	if (ret < 0)
-		goto out_free;
+	if (buffer) {
+		if (flags & TRACECMD_RECORD_SNAPSHOT)
+			ret = asprintf(&path, "%s/per_cpu/cpu%d/snapshot_raw",
+				       buffer, cpu);
+		else
+			ret = asprintf(&path, "%s/per_cpu/cpu%d/trace_pipe_raw",
+				       buffer, cpu);
+		if (ret < 0)
+			goto out_free;
+
+		recorder->trace_fd = open(path, O_RDONLY);
+		free(path);
 
-	recorder->trace_fd = open(path, O_RDONLY);
-	if (recorder->trace_fd < 0)
-		goto out_free;
+		if (recorder->trace_fd < 0)
+			goto out_free;
+	}
 
 	if ((recorder->flags & TRACECMD_RECORD_NOSPLICE) == 0) {
 		ret = pipe(recorder->brass);
@@ -177,13 +183,9 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 		recorder->pipe_size = pipe_size;
 	}
 
-	free(path);
-
 	return recorder;
 
  out_free:
-	free(path);
-
 	tracecmd_free_recorder(recorder);
 	return NULL;
 }
@@ -194,8 +196,9 @@ tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, const char *
 	return tracecmd_create_buffer_recorder_fd2(fd, -1, cpu, flags, buffer, 0);
 }
 
-struct tracecmd_recorder *
-tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, const char *buffer)
+static struct tracecmd_recorder *
+__tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
+				  const char *buffer)
 {
 	struct tracecmd_recorder *recorder;
 	int fd;
@@ -258,6 +261,26 @@ tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags,
 	goto out;
 }
 
+struct tracecmd_recorder *
+tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
+				const char *buffer)
+{
+	return __tracecmd_create_buffer_recorder(file, cpu, flags, buffer);
+}
+
+struct tracecmd_recorder *
+tracecmd_create_recorder_virt(const char *file, int cpu, int trace_fd)
+{
+	struct tracecmd_recorder *recorder;
+
+	recorder = __tracecmd_create_buffer_recorder(
+		file, cpu, TRACECMD_RECORD_NOSPLICE, NULL);
+	if (recorder)
+		recorder->trace_fd = trace_fd;
+
+	return recorder;
+}
+
 struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned flags)
 {
 	const char *tracing;
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
index 0000000..d1aa42a
--- /dev/null
+++ b/tracecmd/trace-agent.c
@@ -0,0 +1,229 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2018 VMware Inc, Slavomir Kaslev <kaslevs@vmware.com>
+ *
+ * partially based on prior implementation by Yoshihiro Yunomae
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
+		die("socket");
+
+	setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &(int){1}, sizeof(int));
+
+	if (bind(sd, (struct sockaddr *)&addr, sizeof(addr)))
+		die("bind");
+
+	if (listen(sd, SOMAXCONN))
+		die("listen");
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
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 8e1226b..bf3c081 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -16,6 +16,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdarg.h>
+#include <string.h>
 #include <unistd.h>
 #include <arpa/inet.h>
 #include <sys/types.h>
@@ -61,6 +62,12 @@ static inline void dprint(const char *fmt, ...)
 #define MIN_META_SIZE	(sizeof(struct tracecmd_msg_header) + \
 			 sizeof(struct tracecmd_msg_meta))
 
+#define MIN_TRACE_REQ_SIZE	(sizeof(struct tracecmd_msg_header) + \
+				 sizeof(struct tracecmd_msg_trace_req))
+
+#define MIN_TRACE_RESP_SIZE	(sizeof(struct tracecmd_msg_header) + \
+				 sizeof(struct tracecmd_msg_trace_resp))
+
 unsigned int page_size;
 
 struct tracecmd_msg_server {
@@ -98,6 +105,16 @@ struct tracecmd_msg_meta {
 	be32 size;
 } __attribute__((packed));
 
+struct tracecmd_msg_trace_req {
+	be32 flags;
+	be32 argc;
+} __attribute__((packed));
+
+struct tracecmd_msg_trace_resp {
+	be32 cpus;
+	be32 page_size;
+} __attribute__((packed));
+
 struct tracecmd_msg_header {
 	be32	size;
 	be32	cmd;
@@ -106,8 +123,8 @@ struct tracecmd_msg_header {
 #define MSG_MAP						\
 	C(UNUSED_0,	0,	-1),			\
 	C(CLOSE,	1,	0),			\
-	C(USUSED_2,	2,	-1),			\
-	C(UNUSED_3,	3,	-1),			\
+	C(TRACE_REQ,	2,	MIN_TRACE_REQ_SIZE),	\
+	C(TRACE_RESP,	3,	MIN_TRACE_RESP_SIZE),	\
 	C(TINIT,	4,	MIN_TINIT_SIZE),	\
 	C(RINIT,	5,	MIN_RINIT_SIZE),	\
 	C(SENDMETA,	6,	MIN_META_SIZE),		\
@@ -143,6 +160,8 @@ struct tracecmd_msg {
 		struct tracecmd_msg_tinit	tinit;
 		struct tracecmd_msg_rinit	rinit;
 		struct tracecmd_msg_meta	meta;
+		struct tracecmd_msg_trace_req	trace_req;
+		struct tracecmd_msg_trace_resp	trace_resp;
 	};
 	union {
 		struct tracecmd_msg_opt		*opt;
@@ -650,7 +669,7 @@ int tracecmd_msg_finish_sending_metadata(struct tracecmd_msg_handle *msg_handle)
 	return 0;
 }
 
-int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int ofd)
+int tracecmd_msg_read_metadata(struct tracecmd_msg_handle *msg_handle, int ofd)
 {
 	struct tracecmd_msg msg;
 	u32 t, n, cmd;
@@ -688,8 +707,28 @@ int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int of
 			t -= s;
 			s = n - t;
 		} while (t);
+
+		msg_free(&msg);
 	} while (cmd == MSG_SENDMETA);
 
+	return 0;
+
+error:
+	error_operation_for_server(&msg);
+	msg_free(&msg);
+	return ret;
+}
+
+int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int ofd)
+{
+	struct tracecmd_msg msg;
+	u32 cmd;
+	int ret;
+
+	ret = tracecmd_msg_read_metadata(msg_handle, ofd);
+	if (ret)
+		goto error;
+
 	/* check the finish message of the client */
 	while (!tracecmd_msg_done(msg_handle)) {
 		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
@@ -707,11 +746,185 @@ int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int of
 			ret = -EINVAL;
 			goto error;
 		}
+
+		msg_free(&msg);
 	}
 
 	return 0;
 
 error:
 	error_operation_for_server(&msg);
+	msg_free(&msg);
+	return ret;
+}
+
+static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv)
+{
+	size_t args_size = 0;
+	char *p;
+	int i;
+
+	for (i = 0; i < argc; i++)
+		args_size += strlen(argv[i]) + 1;
+
+	msg->hdr.size = htonl(MIN_TRACE_REQ_SIZE + args_size);
+
+	if (!args_size)
+		return 0;
+
+	msg->trace_req.argc = htonl(argc);
+	msg->buf = malloc(args_size);
+	if (!msg->buf)
+		return -ENOMEM;
+
+	p = msg->buf;
+	for (i = 0; i < argc; i++)
+		p = stpcpy(p, argv[i]) + 1;
+
+	return 0;
+}
+
+int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
+				int argc, char **argv)
+{
+	struct tracecmd_msg msg;
+	int ret;
+
+	tracecmd_msg_init(MSG_TRACE_REQ, &msg);
+	ret = make_trace_req(&msg, argc, argv);
+	if (ret)
+		return ret;
+
+	return tracecmd_msg_send(msg_handle->fd, &msg);
+}
+
+ /*
+  * NOTE: On success, the returned `argv` should be freed with:
+  *     free(argv[0]);
+  *     free(argv);
+  */
+int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
+				int *argc, char ***argv)
+{
+	struct tracecmd_msg msg;
+	char *p, *buf_end;
+	size_t buf_len;
+	int i, ret;
+
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+	if (ret < 0)
+		return ret;
+
+	if (ntohl(msg.hdr.cmd) != MSG_TRACE_REQ)
+		goto out;
+
+	if (ntohl(msg.trace_req.argc) < 0)
+		goto out;
+
+	buf_len = ntohl(msg.hdr.size) - MIN_TRACE_REQ_SIZE;
+	buf_end = (char *)msg.buf + buf_len;
+	p = msg.buf;
+	*argc = ntohl(msg.trace_req.argc);
+	*argv = calloc(*argc, sizeof(**argv));
+	for (i = 0; i < *argc; i++) {
+		if (p >= buf_end) {
+			ret = -1;
+			free(*argv);
+			goto out;
+		}
+
+		(*argv)[i] = p;
+		p = strchr(p, '\0');
+		p++;
+	}
+
+	ret = 0;
+	msg.buf = NULL;
+
+out:
+	msg_free(&msg);
+	return ret;
+}
+
+static int make_trace_resp(struct tracecmd_msg *msg,
+			   int page_size, int nr_cpus, int *ports)
+{
+	int i;
+
+	msg->hdr.size = htonl(MIN_TRACE_RESP_SIZE + sizeof(*ports) * nr_cpus);
+	msg->trace_resp.cpus = htonl(nr_cpus);
+	msg->trace_resp.page_size = htonl(page_size);
+
+	msg->port_array = calloc(nr_cpus, sizeof(*ports));
+	if (!msg->port_array)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_cpus; i++)
+		msg->port_array[i] = htonl(ports[i]);
+
+	return 0;
+}
+
+int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
+				 int nr_cpus, int page_size, int *ports)
+{
+	struct tracecmd_msg msg;
+	int ret;
+
+	tracecmd_msg_init(MSG_TRACE_RESP, &msg);
+	ret = make_trace_resp(&msg, page_size, nr_cpus, ports);
+	if (ret < 0)
+		return ret;
+
+	return tracecmd_msg_send(msg_handle->fd, &msg);
+}
+
+int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
+				 int *nr_cpus, int *page_size, int **ports)
+{
+	struct tracecmd_msg msg;
+	size_t buf_len;
+	int i, ret;
+
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+	if (ret < 0)
+		return ret;
+
+	if (ntohl(msg.hdr.cmd) != MSG_TRACE_RESP) {
+		ret = -1;
+		goto out;
+	}
+
+	buf_len = ntohl(msg.hdr.size) - MIN_TRACE_RESP_SIZE;
+	if (buf_len <= 0 ||
+	    buf_len != sizeof(*msg.port_array) * ntohl(msg.trace_resp.cpus)) {
+		ret = -1;
+		goto out;
+	}
+
+	*nr_cpus = ntohl(msg.trace_resp.cpus);
+	*page_size = ntohl(msg.trace_resp.page_size);
+	*ports = calloc(*nr_cpus, sizeof(**ports));
+	for (i = 0; i < *nr_cpus; i++)
+		(*ports)[i] = ntohl(msg.port_array[i]);
+
+	ret = 0;
+
+out:
+	msg_free(&msg);
 	return ret;
 }
+
+int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle)
+{
+	char buf[BUFSIZ];
+	int ret;
+
+	for (;;) {
+		ret = read(msg_handle->fd, buf, sizeof(buf));
+		if (ret <= 0)
+			return ret;
+	}
+
+	return -1;
+}
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 6dd2ac0..ab490f5 100644
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
@@ -487,6 +495,63 @@ static char *get_temp_file(struct buffer_instance *instance, int cpu)
 	return file;
 }
 
+static char *get_meta_data_temp_file(struct buffer_instance *instance)
+{
+	const char *name = instance->name;
+	char *file = NULL;
+	int ret;
+
+	if (name)
+		ret = asprintf(&file, "%s.%s.meta", output_file, name);
+	else
+		ret = asprintf(&file, "%s.meta", output_file);
+
+	if (ret < 0)
+		die("Failed to allocate temp file");
+
+	return file;
+}
+
+static char *get_guest_file(const char *file, const char *guest)
+{
+	const char *ptr;
+	char *output;
+	int glen = strlen(guest);
+	int len = strlen(file);
+	int idx = 0;
+
+	output = malloc(len + glen + 2 /* dash and nul */);
+	if (!output)
+		return NULL;
+
+	ptr = file + (len - 1);
+	while (ptr > file && *ptr != '.')
+		ptr--;
+	if (*ptr == '.') {
+		if (ptr > file) {
+			idx = ptr - file;
+			memcpy(output, file, idx);
+			output[idx++] = '-';
+		}
+	} else {
+		idx = len;
+		memcpy(output, file, idx);
+		output[idx++] = '-';
+	}
+	memcpy(output + idx, guest, glen);
+	idx += glen;
+
+	if (*ptr == '.') {
+		len -= ptr - file;
+		memcpy(output + idx, ptr, len);
+		idx += len;
+	}
+
+	output[idx] = '\0';
+
+	return output;
+}
+
 static void put_temp_file(char *file)
 {
 	free(file);
@@ -592,6 +657,16 @@ static void delete_thread_data(void)
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
@@ -601,6 +676,8 @@ static void stop_threads(enum trace_type type)
 	if (!recorder_threads)
 		return;
 
+	tell_guests_to_stop();
+
 	/* Tell all threads to finish up */
 	for (i = 0; i < recorder_threads; i++) {
 		if (pids[i].pid > 0) {
@@ -750,6 +827,9 @@ static void __clear_trace(struct buffer_instance *instance)
 	FILE *fp;
 	char *path;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	/* reset the trace */
 	path = get_instance_file(instance, "trace");
 	fp = fopen(path, "w");
@@ -1233,6 +1313,9 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 	char *path;
 	char zero = '0';
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	path = get_instance_file(instance, "current_tracer");
 	fp = fopen(path, "w");
 	if (!fp) {
@@ -1329,6 +1412,9 @@ static void disable_func_stack_trace_instance(struct buffer_instance *instance)
 	int size;
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	path = get_instance_file(instance, "current_tracer");
 	ret = stat(path, &st);
 	tracecmd_put_tracing_file(path);
@@ -1522,6 +1608,9 @@ reset_events_instance(struct buffer_instance *instance)
 	int i;
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	if (use_old_event_method()) {
 		/* old way only had top instance */
 		if (!is_top_instance(instance))
@@ -1873,6 +1962,9 @@ static void write_tracing_on(struct buffer_instance *instance, int on)
 	int ret;
 	int fd;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	fd = open_tracing_on(instance);
 	if (fd < 0)
 		return;
@@ -1892,6 +1984,9 @@ static int read_tracing_on(struct buffer_instance *instance)
 	char buf[10];
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return -1;
+
 	fd = open_tracing_on(instance);
 	if (fd < 0)
 		return fd;
@@ -2125,6 +2220,9 @@ static void set_mask(struct buffer_instance *instance)
 	int fd;
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	if (!instance->cpumask)
 		return;
 
@@ -2155,6 +2253,9 @@ static void enable_events(struct buffer_instance *instance)
 {
 	struct event_list *event;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	for (event = instance->events; event; event = event->next) {
 		if (!event->neg)
 			update_event(event, event->filter, 0, '1');
@@ -2178,6 +2279,9 @@ static void set_clock(struct buffer_instance *instance)
 	char *content;
 	char *str;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	if (!instance->clock)
 		return;
 
@@ -2207,6 +2311,9 @@ static void set_max_graph_depth(struct buffer_instance *instance, char *max_grap
 	char *path;
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	path = get_instance_file(instance, "max_graph_depth");
 	reset_save_file(path, RESET_DEFAULT_PRIO);
 	tracecmd_put_tracing_file(path);
@@ -2432,6 +2539,9 @@ static void expand_event_instance(struct buffer_instance *instance)
 	struct event_list *compressed_list = instance->events;
 	struct event_list *event;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	reset_event_list(instance);
 
 	while (compressed_list) {
@@ -2507,14 +2617,14 @@ static void flush(int sig)
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
@@ -2541,7 +2651,170 @@ static void connect_port(int cpu)
 
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
+				guest.name = strdup(arg);
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
@@ -2588,6 +2861,16 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
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
 
@@ -2612,7 +2895,7 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 {
 	long ret;
 	char *file;
-	int pid;
+	pid_t pid;
 
 	if (type != TRACE_TYPE_EXTRACT) {
 		signal(SIGUSR1, flush);
@@ -2631,19 +2914,26 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
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
@@ -2681,7 +2971,8 @@ static void check_first_msg_from_server(struct tracecmd_msg_handle *msg_handle)
 		die("server not tracecmd server");
 }
 
-static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
+static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle,
+					 int **client_ports)
 {
 	char buf[BUFSIZ];
 	ssize_t n;
@@ -2724,8 +3015,8 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
 		/* No options */
 		write(msg_handle->fd, "0", 2);
 
-	client_ports = malloc(sizeof(int) * local_cpu_count);
-	if (!client_ports)
+	*client_ports = malloc(sizeof(int) * local_cpu_count);
+	if (!*client_ports)
 		die("Failed to allocate client ports for %d cpus", local_cpu_count);
 
 	/*
@@ -2743,13 +3034,14 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
 		if (i == BUFSIZ)
 			die("read bad port number");
 		buf[i] = 0;
-		client_ports[cpu] = atoi(buf);
+		(*client_ports)[cpu] = atoi(buf);
 	}
 }
 
-static void communicate_with_listener_v2(struct tracecmd_msg_handle *msg_handle)
+static void communicate_with_listener_v2(struct tracecmd_msg_handle *msg_handle,
+					 int **client_ports)
 {
-	if (tracecmd_msg_send_init_data(msg_handle, &client_ports) < 0)
+	if (tracecmd_msg_send_init_data(msg_handle, client_ports) < 0)
 		die("Cannot communicate with server");
 }
 
@@ -2798,7 +3090,7 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 	}
 }
 
-static struct tracecmd_msg_handle *setup_network(void)
+static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instance)
 {
 	struct tracecmd_msg_handle *msg_handle = NULL;
 	struct addrinfo hints;
@@ -2868,11 +3160,11 @@ again:
 			close(sfd);
 			goto again;
 		}
-		communicate_with_listener_v2(msg_handle);
+		communicate_with_listener_v2(msg_handle, &instance->client_ports);
 	}
 
 	if (msg_handle->version == V1_PROTOCOL)
-		communicate_with_listener_v1(msg_handle);
+		communicate_with_listener_v1(msg_handle, &instance->client_ports);
 
 	return msg_handle;
 }
@@ -2883,7 +3175,7 @@ setup_connection(struct buffer_instance *instance)
 	struct tracecmd_msg_handle *msg_handle;
 	struct tracecmd_output *network_handle;
 
-	msg_handle = setup_network();
+	msg_handle = setup_network(instance);
 
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V2_PROTOCOL) {
@@ -2904,32 +3196,95 @@ static void finish_network(struct tracecmd_msg_handle *msg_handle)
 	if (msg_handle->version == V2_PROTOCOL)
 		tracecmd_msg_send_close_msg(msg_handle);
 	tracecmd_msg_handle_close(msg_handle);
-	free(host);
+}
+
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
+		die("Failed to receive trace request");
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
+	file = get_meta_data_temp_file(instance);
+	if (!file)
+		die("Failed to allocate memory");
+
+	fd = open(file, O_WRONLY|O_CREAT, 0644);
+	put_temp_file(file);
+	if (fd < 0)
+		die("Failed to open", file);
+
+	/* Start reading the fds here */
+	if (tracecmd_msg_read_metadata(msg_handle, fd))
+		die("Failed receiving metadata");
+}
+
+static void setup_agent(struct buffer_instance *instance)
+{
+	struct tracecmd_output *network_handle;
+
+	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
+						     listed_events);
+	tracecmd_msg_finish_sending_metadata(instance->msg_handle);
+	instance->network_handle = network_handle;
 }
 
 void start_threads(enum trace_type type, int global)
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
-			instance->msg_handle = setup_connection(instance);
+		if (instance->flags & BUFFER_FL_AGENT) {
+			setup_agent(instance);
+		} else if (instance->flags & BUFFER_FL_GUEST) {
+			setup_guest(instance);
+		} else if (host) {
+			setup_connection(instance);
 			if (!instance->msg_handle)
 				die("Failed to make connection");
 		}
@@ -3068,13 +3423,14 @@ static void print_stat(struct buffer_instance *instance)
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
@@ -3083,6 +3439,50 @@ enum {
 	DATA_FL_OFFSET		= 2,
 };
 
+static void write_guest_file(struct buffer_instance *instance)
+{
+	struct tracecmd_output *handle;
+	struct tracecmd_input *ihandle;
+	int cpu_count = instance->cpu_count;
+	char **temp_files;
+	char *file;
+	int i;
+
+	file = get_meta_data_temp_file(instance);
+	ihandle = tracecmd_alloc(file);
+	if (!ihandle)
+		die("error reading file %s", file);
+	/* make sure headers are ok */
+	if (tracecmd_read_headers(ihandle) < 0)
+		die("error reading file %s headers", file);
+	unlink(file);
+	put_temp_file(file);
+
+	file = get_guest_file(output_file, instance->name);
+	handle = tracecmd_copy(ihandle, file);
+	tracecmd_close(ihandle);
+
+	if (!handle)
+		die("error writing to %s", file);
+	put_temp_file(file);
+
+	temp_files = malloc(sizeof(*temp_files) * cpu_count);
+	if (!temp_files)
+		die("Failed to allocate temp_files for %d cpus",
+		    cpu_count);
+
+	for (i = 0; i < cpu_count; i++)
+		temp_files[i] = get_temp_file(instance, i);
+
+	tracecmd_append_cpu_data(handle, cpu_count, temp_files);
+
+	for (i = 0; i < cpu_count; i++)
+		put_temp_file(temp_files[i]);
+
+	free(temp_files);
+	tracecmd_output_close(handle);
+}
+
 static void record_data(char *date2ts, int flags)
 {
 	struct tracecmd_option **buffer_options;
@@ -3094,7 +3494,9 @@ static void record_data(char *date2ts, int flags)
 	int i;
 
 	for_all_instances(instance) {
-		if (instance->msg_handle)
+		if (instance->flags & BUFFER_FL_GUEST)
+			write_guest_file(instance);
+		else if (host && instance->msg_handle)
 			finish_network(instance->msg_handle);
 		else
 			local = true;
@@ -3296,6 +3698,9 @@ static void set_funcs(struct buffer_instance *instance)
 	int set_notrace = 0;
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	ret = write_func_file(instance, "set_ftrace_filter", &instance->filter_funcs);
 	if (ret < 0)
 		die("set_ftrace_filter does not exist. Can not filter functions");
@@ -3590,6 +3995,9 @@ static void set_buffer_size_instance(struct buffer_instance *instance)
 	int ret;
 	int fd;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	if (!buffer_size)
 		return;
 
@@ -3787,6 +4195,9 @@ static void make_instances(void)
 	int ret;
 
 	for_each_instance(instance) {
+		if (instance->flags & BUFFER_FL_GUEST)
+			continue;
+
 		path = get_instance_dir(instance);
 		ret = stat(path, &st);
 		if (ret < 0) {
@@ -3808,7 +4219,7 @@ void tracecmd_remove_instances(void)
 
 	for_each_instance(instance) {
 		/* Only delete what we created */
-		if (instance->flags & BUFFER_FL_KEEP)
+		if (instance->flags & (BUFFER_FL_KEEP | BUFFER_FL_GUEST))
 			continue;
 		if (instance->tracing_on_fd > 0) {
 			close(instance->tracing_on_fd);
@@ -3890,7 +4301,7 @@ static void check_function_plugin(void)
 
 static int __check_doing_something(struct buffer_instance *instance)
 {
-	return (instance->flags & BUFFER_FL_PROFILE) ||
+	return (instance->flags & (BUFFER_FL_PROFILE | BUFFER_FL_GUEST)) ||
 		instance->plugin || instance->events;
 }
 
@@ -3912,6 +4323,9 @@ update_plugin_instance(struct buffer_instance *instance,
 {
 	const char *plugin = instance->plugin;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	if (!plugin)
 		return;
 
@@ -4011,6 +4425,9 @@ static void record_stats(void)
 	int cpu;
 
 	for_all_instances(instance) {
+		if (instance->flags & BUFFER_FL_GUEST)
+			continue;
+
 		s_save = instance->s_save;
 		s_print = instance->s_print;
 		for (cpu = 0; cpu < instance->cpu_count; cpu++) {
@@ -4037,6 +4454,9 @@ static void destroy_stats(void)
 	int cpu;
 
 	for_all_instances(instance) {
+		if (instance->flags & BUFFER_FL_GUEST)
+			continue;
+
 		for (cpu = 0; cpu < instance->cpu_count; cpu++) {
 			trace_seq_destroy(&instance->s_save[cpu]);
 			trace_seq_destroy(&instance->s_print[cpu]);
@@ -4311,6 +4731,7 @@ void trace_stop(int argc, char **argv)
 		c = getopt(argc-1, argv+1, "hatB:");
 		if (c == -1)
 			break;
+
 		switch (c) {
 		case 'h':
 			usage(argv);
@@ -4462,7 +4883,8 @@ enum trace_cmd {
 	CMD_start,
 	CMD_stream,
 	CMD_profile,
-	CMD_record
+	CMD_record,
+	CMD_record_agent,
 };
 
 struct common_record_context {
@@ -4502,6 +4924,60 @@ static void init_common_record_context(struct common_record_context *ctx,
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
@@ -4543,10 +5019,20 @@ static void parse_record_options(int argc,
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
@@ -4599,6 +5085,26 @@ static void parse_record_options(int argc,
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
@@ -4669,6 +5175,8 @@ static void parse_record_options(int argc,
 			ctx->disable = 1;
 			break;
 		case 'o':
+			if (IS_AGENT(ctx))
+				die("-o incompatible with agent recording");
 			if (host)
 				die("-o incompatible with -N");
 			if (IS_START(ctx))
@@ -4730,6 +5238,8 @@ static void parse_record_options(int argc,
 		case 'N':
 			if (!IS_RECORD(ctx))
 				die("-N only available with record");
+			if (IS_AGENT(ctx))
+				die("-N incompatible with agent recording");
 			if (ctx->output)
 				die("-N incompatible with -o");
 			host = optarg;
@@ -4856,7 +5366,8 @@ static enum trace_type get_trace_cmd_type(enum trace_cmd cmd)
 		{CMD_stream, TRACE_TYPE_STREAM},
 		{CMD_extract, TRACE_TYPE_EXTRACT},
 		{CMD_profile, TRACE_TYPE_STREAM},
-		{CMD_start, TRACE_TYPE_START}
+		{CMD_start, TRACE_TYPE_START},
+		{CMD_record_agent, TRACE_TYPE_RECORD}
 	};
 
 	for (int i = 0; i < ARRAY_SIZE(trace_type_per_command); i++) {
@@ -4888,6 +5399,8 @@ static void finalize_record_trace(struct common_record_context *ctx)
 		if (instance->flags & BUFFER_FL_KEEP)
 			write_tracing_on(instance,
 					 instance->tracing_on_init_val);
+		if (instance->flags & BUFFER_FL_AGENT)
+			tracecmd_output_close(instance->network_handle);
 	}
 
 	if (host)
@@ -4922,7 +5435,6 @@ static void record_trace(int argc, char **argv,
 
 	/* Save the state of tracing_on before starting */
 	for_all_instances(instance) {
-
 		if (!ctx->manual && instance->flags & BUFFER_FL_PROFILE)
 			enable_profile(instance);
 
@@ -4939,14 +5451,15 @@ static void record_trace(int argc, char **argv,
 
 	page_size = getpagesize();
 
-	fset = set_ftrace(!ctx->disable, ctx->total_disable);
+	if (!(ctx->instance->flags & BUFFER_FL_GUEST))
+		fset = set_ftrace(!ctx->disable, ctx->total_disable);
 	tracecmd_disable_all_tracing(1);
 
 	for_all_instances(instance)
 		set_clock(instance);
 
 	/* Record records the date first */
-	if (IS_RECORD(ctx) && ctx->date)
+	if ((IS_RECORD(ctx) || IS_AGENT(ctx)) && ctx->date)
 		ctx->date2ts = get_date_to_ts();
 
 	for_all_instances(instance) {
@@ -4981,9 +5494,13 @@ static void record_trace(int argc, char **argv,
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
@@ -5004,11 +5521,13 @@ static void record_trace(int argc, char **argv,
 	if (!keep)
 		tracecmd_disable_all_tracing(0);
 
-	if (IS_RECORD(ctx)) {
-		record_data(ctx->date2ts, ctx->data_flags);
-		delete_thread_data();
-	} else
-		print_stats();
+	if (!IS_AGENT(ctx)) {
+		if (IS_RECORD(ctx)) {
+			record_data(ctx->date2ts, ctx->data_flags);
+			delete_thread_data();
+		} else
+			print_stats();
+	}
 
 	destroy_stats();
 	finalize_record_trace(ctx);
@@ -5138,3 +5657,40 @@ void trace_record(int argc, char **argv)
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
+	msg_handle->version = V2_PROTOCOL;
+	record_trace(argc, argv, &ctx);
+
+	free(argv_plus);
+	return 0;
+}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 10f737b..731d462 100644
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
 		"          -d diretory to store client files.\n"
 		"          -l logfile to write messages to.\n"
 	},
+	{
+		"agent",
+		"listen on a VSOCK socket for trace clients",
+		" %s agent -p port[-D]\n"
+		"          Creates a VSOCK socket to listen for clients.\n"
+		"          -p port number to listen on.\n"
+		"          -D run in daemon mode.\n"
+	},
 	{
 		"list",
 		"list the available events, plugins or options",
-- 
2.17.1
