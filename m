Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97DBBC468B0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F74821479
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TMiejmsy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbfFROpP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:45:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46210 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729042AbfFROpO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:45:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so14271873wrw.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qfLIYrVfIPqiORKLvYQZzqdRfngeBC4/UIOOAejefTQ=;
        b=TMiejmsyzuSOvcgO2FbXcPYOtuC1q0fQy1cLuGbyfAuZlAdCJSnB8OTqEp6/LgpQGw
         YXRHPu1RT1gVCRP+9/lrottfr2/xx5AE4+Nvayrbs50GyA2ZHtumfaw8OzH9NvtU2U8X
         J1m+EQTDNqmRfk3p98s0ZxQ8IUqBLkBlsTZ6riRLwXgv+qkaDh7LpvBD/NvwDB2QyOC4
         7UcIMa3DU7lOxRFZxTKvXA5YTsx+6CEoCXsJeeOImLAnHsPUGQUDqQUY9lUKQgpnSeNy
         RA6vhPUJWyBy/A60oQPTHvU62QlLZ7Kb386lUZREAjKJnaOXqxSEBjj6Otm2uFEOb3/M
         v1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qfLIYrVfIPqiORKLvYQZzqdRfngeBC4/UIOOAejefTQ=;
        b=BYhFn72FPa79zD5y8mDIJN/aJWZ5Jb6+Xyp+AtUqDWtdzSeWsb8BXJd29ay1NFJIEN
         n++2pCOEvDMSph2RFzw82ykCSxR0vGSmB9Ofgae24wADvihuvKhzvBawH1kjK9hFfJ6d
         apwgg94miGQXQ9Fged6O6JNErE/CWAMbS9PGzir5r8hsA8Xk2I0i7SnV4KtHDjti90MO
         tb7B65gdpR+KC7YjrHbQ0AyHFQjU5TrQC9xr1iWRJN0RRfJSLWNci1V9Y1y1wJGuRtBA
         knP4NWuEvDvXEWVGUGHM9gpW1MtDX0ZuQfnN3r3pED7l+H7oAf92bXl47B1L+PvfwC5E
         cuvg==
X-Gm-Message-State: APjAAAUUoGJRZzX83eDmW3yv5JsGQV2PJk84wt6x6eAtf/MKt9Wx02kn
        NR3aFc++TpOVCF7LCcWiMjo5vKo=
X-Google-Smtp-Source: APXvYqwPp6Abxvg5KUvodZApgBDDV0EVzfMp/T8ohAMXHmbRHor+vqTqjakQFigbIfJwYkmFpHCy6A==
X-Received: by 2002:a5d:6050:: with SMTP id j16mr12267308wrt.20.1560869108316;
        Tue, 18 Jun 2019 07:45:08 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r3sm17686071wrr.61.2019.06.18.07.45.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:45:07 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 06/13] trace-cmd: Add VM kernel tracing over vsockets transport
Date:   Tue, 18 Jun 2019 17:44:48 +0300
Message-Id: <20190618144455.3954-7-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
References: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Slavomir Kaslev <kaslevs@vmware.com>

This patch adds VM tracing over vsockets. The new `trace-cmd agent` command
needs run on each guest we want to trace:

     you@guest2 # trace-cmd agent

Then `trace-cmd record` on the host can collect data from both the host and
several guests simultaneously:

     you@host $ trace-cmd record -A guest1 -e irq -e sched \
                                 -A guest2 -p function -e all

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 lib/trace-cmd/trace-recorder.c |  20 +-
 tracecmd/Makefile              |   4 +
 tracecmd/include/trace-local.h |  16 +
 tracecmd/trace-agent.c         | 263 ++++++++++++++
 tracecmd/trace-cmd.c           |   3 +
 tracecmd/trace-record.c        | 606 ++++++++++++++++++++++++++++++---
 tracecmd/trace-usage.c         |  13 +-
 7 files changed, 873 insertions(+), 52 deletions(-)
 create mode 100644 tracecmd/trace-agent.c

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 0ea7a87..d57a5d6 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -382,11 +382,11 @@ static long splice_data(struct tracecmd_recorder *recorder)
 	read = splice(recorder->trace_fd, NULL, recorder->brass[1], NULL,
 		      recorder->pipe_size, SPLICE_F_MOVE);
 	if (read < 0) {
-		if (errno != EAGAIN && errno != EINTR) {
-			warning("recorder error in splice input");
-			return -1;
-		}
-		return 0;
+		if (errno == EAGAIN || errno == EINTR || errno == ENOTCONN)
+			return 0;
+
+		warning("recorder error in splice input");
+		return -1;
 	} else if (read == 0)
 		return 0;
 
@@ -421,11 +421,11 @@ static long read_data(struct tracecmd_recorder *recorder)
 
 	r = read(recorder->trace_fd, buf, recorder->page_size);
 	if (r < 0) {
-		if (errno != EAGAIN && errno != EINTR) {
-			warning("recorder error in read output");
-			return -1;
-		}
-		return 0;
+		if (errno == EAGAIN || errno == EINTR || errno == ENOTCONN)
+			return 0;
+
+		warning("recorder error in read input");
+		return -1;
 	}
 
 	left = r;
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index bcd437a..a2c0a76 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -33,6 +33,10 @@ TRACE_CMD_OBJS += trace-output.o
 TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-msg.o
 
+ifeq ($(VSOCK_DEFINED), 1)
+TRACE_CMD_OBJS += trace-agent.o
+endif
+
 ALL_OBJS := $(TRACE_CMD_OBJS:%.o=$(bdir)/%.o)
 
 all_objs := $(sort $(ALL_OBJS))
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 302f749..2872747 100644
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
@@ -176,6 +184,7 @@ struct buffer_instance {
 	struct func_list	*notrace_funcs;
 
 	const char		*clock;
+	unsigned int		*client_ports;
 
 	struct trace_seq	*s_save;
 	struct trace_seq	*s_print;
@@ -192,6 +201,13 @@ struct buffer_instance {
 	int			tracing_on_fd;
 	int			buffer_size;
 	int			cpu_count;
+
+	int			argc;
+	char			**argv;
+
+	unsigned int		cid;
+	unsigned int		port;
+	int			*fds;
 };
 
 extern struct buffer_instance top_instance;
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
new file mode 100644
index 0000000..e1dfddf
--- /dev/null
+++ b/tracecmd/trace-agent.c
@@ -0,0 +1,263 @@
+// SPDX-License-Identifier: GPL-2.0
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
+#define GET_LOCAL_CID	0x7b9
+
+static int get_local_cid(unsigned int *cid)
+{
+	int fd, ret = 0;
+
+	fd = open("/dev/vsock", O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	if (ioctl(fd, GET_LOCAL_CID, cid))
+		ret = -errno;
+
+	close(fd);
+	return ret;
+}
+
+static int make_vsock(unsigned int port)
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
+		return -errno;
+
+	setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &(int){1}, sizeof(int));
+
+	if (bind(sd, (struct sockaddr *)&addr, sizeof(addr)))
+		return -errno;
+
+	if (listen(sd, SOMAXCONN))
+		return -errno;
+
+	return sd;
+}
+
+static int get_vsock_port(int sd, unsigned int *port)
+{
+	struct sockaddr_vm addr;
+	socklen_t addr_len = sizeof(addr);
+
+	if (getsockname(sd, (struct sockaddr *)&addr, &addr_len))
+		return -errno;
+
+	if (addr.svm_family != AF_VSOCK)
+		return -errno;
+
+	if (port)
+		*port = addr.svm_port;
+
+	return 0;
+}
+
+static void make_vsocks(int nr, int *fds, unsigned int *ports)
+{
+	unsigned int port;
+	int i, fd, ret;
+
+	for (i = 0; i < nr; i++) {
+		fd = make_vsock(VMADDR_PORT_ANY);
+		if (fd < 0)
+			die("Failed to open vsocket");
+
+		ret = get_vsock_port(fd, &port);
+		if (ret < 0)
+			die("Failed to get vsocket address");
+
+		fds[i] = fd;
+		ports[i] = port;
+	}
+}
+
+static void agent_handle(int sd, int nr_cpus, int page_size)
+{
+	struct tracecmd_msg_handle *msg_handle;
+	unsigned int *ports;
+	char **argv = NULL;
+	int argc = 0;
+	int *fds;
+	int ret;
+
+	fds = calloc(nr_cpus, sizeof(*fds));
+	ports = calloc(nr_cpus, sizeof(*ports));
+	if (!fds || !ports)
+		die("Failed to allocate memory");
+
+	msg_handle = tracecmd_msg_handle_alloc(sd, 0);
+	if (!msg_handle)
+		die("Failed to allocate message handle");
+
+	ret = tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv);
+	if (ret < 0)
+		die("Failed to receive trace request");
+
+	make_vsocks(nr_cpus, fds, ports);
+
+	ret = tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, page_size, ports);
+	if (ret < 0)
+		die("Failed to send trace response");
+
+	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv);
+
+	free(argv[0]);
+	free(argv);
+	free(ports);
+	free(fds);
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
+static pid_t do_fork()
+{
+	/* in debug mode, we do not fork off children */
+	if (debug)
+		return 0;
+
+	return fork();
+}
+
+static void agent_serve(unsigned int port)
+{
+	int sd, cd, nr_cpus;
+	unsigned int cid;
+	pid_t pid;
+
+	signal(SIGCHLD, handle_sigchld);
+
+	nr_cpus = count_cpus();
+	page_size = getpagesize();
+
+	sd = make_vsock(port);
+	if (sd < 0)
+		die("Failed to open vsocket");
+
+	if (!get_local_cid(&cid))
+		printf("listening on @%u:%u\n", cid, port);
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
+		pid = do_fork();
+		if (pid == 0) {
+			close(sd);
+			signal(SIGCHLD, SIG_DFL);
+			agent_handle(cd, nr_cpus, page_size);
+		}
+		if (pid > 0)
+			handler_pid = pid;
+
+busy:
+		close(cd);
+	}
+}
+
+enum {
+	DO_DEBUG	= 255
+};
+
+void trace_agent(int argc, char **argv)
+{
+	bool do_daemon = false;
+	unsigned int port = TRACE_AGENT_DEFAULT_PORT;
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
+			{"debug", no_argument, NULL, DO_DEBUG},
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
+		case DO_DEBUG:
+			debug = true;
+			break;
+		default:
+			usage(argv);
+		}
+	}
+
+	if (optind < argc-1)
+		usage(argv);
+
+	if (do_daemon && daemon(1, 0))
+		die("daemon");
+
+	agent_serve(port);
+}
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 797b303..3ae5e2e 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -83,6 +83,9 @@ struct command commands[] = {
 	{"hist", trace_hist},
 	{"mem", trace_mem},
 	{"listen", trace_listen},
+#ifdef VSOCK
+	{"agent", trace_agent},
+#endif
 	{"split", trace_split},
 	{"restore", trace_restore},
 	{"stack", trace_stack},
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4198db7..dfad8f2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -33,6 +33,9 @@
 #include <errno.h>
 #include <limits.h>
 #include <libgen.h>
+#ifdef VSOCK
+#include <linux/vm_sockets.h>
+#endif
 
 #include "version.h"
 #include "trace-local.h"
@@ -75,8 +78,6 @@ static int buffers;
 static int clear_function_filters;
 
 static char *host;
-static unsigned int *client_ports;
-static int sfd;
 
 /* Max size to let a per cpu file get */
 static int max_kb;
@@ -521,6 +522,22 @@ static char *get_temp_file(struct buffer_instance *instance, int cpu)
 	return file;
 }
 
+static char *get_guest_file(const char *file, const char *guest)
+{
+	const char *p;
+	char *out = NULL;
+	int base_len;
+
+	p = strrchr(file, '.');
+	if (p && p != file)
+		base_len = p - file;
+	else
+		base_len = strlen(file);
+
+	asprintf(&out, "%.*s-%s%s", base_len, file, guest, file + base_len);
+	return out;
+}
+
 static void put_temp_file(char *file)
 {
 	free(file);
@@ -626,6 +643,25 @@ static void delete_thread_data(void)
 	}
 }
 
+static void tell_guests_to_stop(void)
+{
+	struct buffer_instance *instance;
+
+	/* Send close message to guests */
+	for_all_instances(instance) {
+		if (is_guest(instance))
+			tracecmd_msg_send_close_msg(instance->msg_handle);
+	}
+
+	/* Wait for guests to acknowledge */
+	for_all_instances(instance) {
+		if (is_guest(instance)) {
+			tracecmd_msg_wait_close_resp(instance->msg_handle);
+			tracecmd_msg_handle_close(instance->msg_handle);
+		}
+	}
+}
+
 static void stop_threads(enum trace_type type)
 {
 	int ret;
@@ -647,6 +683,11 @@ static void stop_threads(enum trace_type type)
 			ret = trace_stream_read(pids, recorder_threads, NULL);
 		} while (ret > 0);
 	}
+}
+
+static void wait_threads()
+{
+	int i;
 
 	for (i = 0; i < recorder_threads; i++) {
 		if (pids[i].pid > 0) {
@@ -2618,14 +2659,14 @@ static void flush(int sig)
 		tracecmd_stop_recording(recorder);
 }
 
-static void connect_port(int cpu)
+static int connect_port(const char *host, unsigned int port)
 {
 	struct addrinfo hints;
 	struct addrinfo *results, *rp;
-	int s;
+	int s, sfd;
 	char buf[BUFSIZ];
 
-	snprintf(buf, BUFSIZ, "%u", client_ports[cpu]);
+	snprintf(buf, BUFSIZ, "%u", port);
 
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family = AF_UNSPEC;
@@ -2652,7 +2693,190 @@ static void connect_port(int cpu)
 
 	freeaddrinfo(results);
 
-	client_ports[cpu] = sfd;
+	return sfd;
+}
+
+#ifdef VSOCK
+static int open_vsock(unsigned int cid, unsigned int port)
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
+#else
+static inline int open_vsock(unsigned int cid, unsigned int port)
+{
+	die("vsock is not supported");
+	return -1;
+}
+#endif
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
+static struct guest *guests;
+static size_t guests_len;
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
+	static bool initialized;
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
+		die("Can not open /proc");
+
+	while ((entry = readdir(dir))) {
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
+		if (!is_qemu)
+			goto next;
+
+		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
+		if (!guests)
+			die("Can not allocate guest buffer");
+		guests[guests_len++] = guest;
+
+next:
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
@@ -2699,6 +2923,17 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 	struct tracecmd_recorder *record;
 	char *path;
 
+	if (is_guest(instance)) {
+		int fd;
+
+		fd = open_vsock(instance->cid, instance->client_ports[cpu]);
+		if (fd < 0)
+			die("Failed to connect to agent");
+
+		return tracecmd_create_recorder_virt(
+			file, cpu, recorder_flags | TRACECMD_RECORD_NOSPLICE, fd);
+	}
+
 	if (brass)
 		return create_recorder_instance_pipe(instance, cpu, brass);
 
@@ -2723,7 +2958,7 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 {
 	long ret;
 	char *file;
-	int pid;
+	pid_t pid;
 
 	if (type != TRACE_TYPE_EXTRACT) {
 		signal(SIGUSR1, flush);
@@ -2742,19 +2977,23 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 		instance->cpu_count = 0;
 	}
 
-	if (client_ports) {
-		char *path;
+	if ((instance->client_ports && !is_guest(instance)) || is_agent(instance)) {
+		unsigned int flags = recorder_flags;
+		char *path = NULL;
+		int fd;
 
-		connect_port(cpu);
-		if (instance->name)
+		if (is_agent(instance))
+			fd = do_accept(instance->fds[cpu]);
+		else
+			fd = connect_port(host, instance->client_ports[cpu]);
+		if (fd < 0)
+			die("Failed connecting to client");
+		if (instance->name && !is_agent(instance))
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
@@ -2792,7 +3031,8 @@ static void check_first_msg_from_server(struct tracecmd_msg_handle *msg_handle)
 		die("server not tracecmd server");
 }
 
-static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
+static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle,
+					 unsigned int **client_ports)
 {
 	char buf[BUFSIZ];
 	ssize_t n;
@@ -2835,8 +3075,8 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
 		/* No options */
 		write(msg_handle->fd, "0", 2);
 
-	client_ports = malloc(local_cpu_count * sizeof(*client_ports));
-	if (!client_ports)
+	*client_ports = malloc(local_cpu_count * sizeof(*client_ports));
+	if (!*client_ports)
 		die("Failed to allocate client ports for %d cpus", local_cpu_count);
 
 	/*
@@ -2854,13 +3094,14 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
 		if (i == BUFSIZ)
 			die("read bad port number");
 		buf[i] = 0;
-		client_ports[cpu] = atoi(buf);
+		(*client_ports)[cpu] = atoi(buf);
 	}
 }
 
-static void communicate_with_listener_v3(struct tracecmd_msg_handle *msg_handle)
+static void communicate_with_listener_v3(struct tracecmd_msg_handle *msg_handle,
+					 unsigned int **client_ports)
 {
-	if (tracecmd_msg_send_init_data(msg_handle, &client_ports) < 0)
+	if (tracecmd_msg_send_init_data(msg_handle, client_ports) < 0)
 		die("Cannot communicate with server");
 }
 
@@ -2911,7 +3152,7 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 	}
 }
 
-static struct tracecmd_msg_handle *setup_network(void)
+static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instance)
 {
 	struct tracecmd_msg_handle *msg_handle = NULL;
 	struct addrinfo hints;
@@ -2981,11 +3222,11 @@ again:
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
@@ -2998,7 +3239,7 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 	struct tracecmd_msg_handle *msg_handle;
 	struct tracecmd_output *network_handle;
 
-	msg_handle = setup_network();
+	msg_handle = setup_network(instance);
 
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
@@ -3025,28 +3266,99 @@ static void finish_network(struct tracecmd_msg_handle *msg_handle)
 	free(host);
 }
 
+static void connect_to_agent(struct buffer_instance *instance)
+{
+	struct tracecmd_msg_handle *msg_handle;
+	int sd, ret, nr_cpus, page_size;
+	unsigned int *ports;
+
+	sd = open_vsock(instance->cid, instance->port);
+	if (sd < 0)
+		die("Failed to connect to vsocket @%u:%u",
+		    instance->cid, instance->port);
+
+	msg_handle = tracecmd_msg_handle_alloc(sd, 0);
+	if (!msg_handle)
+		die("Failed to allocate message handle");
+
+	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc, instance->argv);
+	if (ret < 0)
+		die("Failed to send trace request");
+
+	ret = tracecmd_msg_recv_trace_resp(msg_handle, &nr_cpus, &page_size, &ports);
+	if (ret < 0)
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
+	/* Start reading tracing metadata */
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
 void start_threads(enum trace_type type, struct common_record_context *ctx)
 {
 	struct buffer_instance *instance;
-	int *brass = NULL;
 	int total_cpu_count = 0;
 	int i = 0;
 	int ret;
 
-	for_all_instances(instance)
+	for_all_instances(instance) {
+		/* Start the connection now to find out how many CPUs we need */
+		if (is_guest(instance))
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
+		if (is_agent(instance)) {
+			setup_agent(instance, ctx);
+		} else if (is_guest(instance)) {
+			setup_guest(instance);
+		} else if (host) {
 			instance->msg_handle = setup_connection(instance, ctx);
 			if (!instance->msg_handle)
 				die("Failed to make connection");
@@ -3235,6 +3547,44 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 	add_version(handle);
 }
 
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
+
+	for (i = 0; i < cpu_count; i++)
+		put_temp_file(temp_files[i]);
+	free(temp_files);
+}
+
 static void record_data(struct common_record_context *ctx)
 {
 	struct tracecmd_option **buffer_options;
@@ -3246,7 +3596,9 @@ static void record_data(struct common_record_context *ctx)
 	int i;
 
 	for_all_instances(instance) {
-		if (instance->msg_handle)
+		if (is_guest(instance))
+			write_guest_file(instance);
+		else if (host && instance->msg_handle)
 			finish_network(instance->msg_handle);
 		else
 			local = true;
@@ -4478,6 +4830,7 @@ void trace_stop(int argc, char **argv)
 		c = getopt(argc-1, argv+1, "hatB:");
 		if (c == -1)
 			break;
+
 		switch (c) {
 		case 'h':
 			usage(argv);
@@ -4646,6 +4999,65 @@ static void init_common_record_context(struct common_record_context *ctx,
 #define IS_STREAM(ctx) ((ctx)->curr_cmd == CMD_stream)
 #define IS_PROFILE(ctx) ((ctx)->curr_cmd == CMD_profile)
 #define IS_RECORD(ctx) ((ctx)->curr_cmd == CMD_record)
+#define IS_RECORD_AGENT(ctx) ((ctx)->curr_cmd == CMD_record_agent)
+
+static void add_argv(struct buffer_instance *instance, char *arg, bool prepend)
+{
+	instance->argv = realloc(instance->argv,
+				 (instance->argc + 1) * sizeof(char *));
+	if (!instance->argv)
+		die("Can not allocate instance args");
+	if (prepend) {
+		memmove(instance->argv + 1, instance->argv,
+			instance->argc * sizeof(*instance->argv));
+		instance->argv[0] = arg;
+	} else {
+		instance->argv[instance->argc] = arg;
+	}
+	instance->argc++;
+}
+
+static void add_arg(struct buffer_instance *instance,
+		    int c, const char *opts,
+		    struct option *long_options, char *optarg)
+{
+	char *ptr, *arg;
+	int i, ret;
+
+	/* Short or long arg */
+	if (!(c & 0x80)) {
+		ptr = strchr(opts, c);
+		if (!ptr)
+			return; /* Not found? */
+		ret = asprintf(&arg, "-%c", c);
+		if (ret < 0)
+			die("Can not allocate argument");
+		add_argv(instance, arg, false);
+		if (ptr[1] == ':') {
+			arg = strdup(optarg);
+			if (!arg)
+				die("Can not allocate arguments");
+			add_argv(instance, arg, false);
+		}
+		return;
+	}
+	for (i = 0; long_options[i].name; i++) {
+		if (c != long_options[i].val)
+			continue;
+		ret = asprintf(&arg, "--%s", long_options[i].name);
+		if (ret < 0)
+			die("Can not allocate argument");
+		add_argv(instance, arg, false);
+		if (long_options[i].has_arg) {
+			arg = strdup(optarg);
+			if (!arg)
+				die("Can not allocate arguments");
+			add_argv(instance, arg, false);
+		}
+		return;
+	}
+	/* Not found? */
+}
 
 static void parse_record_options(int argc,
 				 char **argv,
@@ -4659,6 +5071,7 @@ static void parse_record_options(int argc,
 	char *pids;
 	char *pid;
 	char *sav;
+	int name_counter = 0;
 	int neg_event = 0;
 
 	init_common_record_context(ctx, curr_cmd);
@@ -4688,10 +5101,20 @@ static void parse_record_options(int argc,
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
+		if (c != 'B' && c != 'A' && is_guest(ctx->instance)) {
+			add_arg(ctx->instance, c, opts, long_options, optarg);
+			continue;
+		}
+
 		switch (c) {
 		case 'h':
 			usage(argv);
@@ -4744,6 +5167,28 @@ static void parse_record_options(int argc,
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
+			if (cid == -1)
+				die("guest %s not found", optarg);
+			if (port == -1)
+				port = TRACE_AGENT_DEFAULT_PORT;
+			if (!name || !*name)
+				asprintf(&name, "unnamed-%d", name_counter++);
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
@@ -4814,6 +5259,8 @@ static void parse_record_options(int argc,
 			ctx->disable = 1;
 			break;
 		case 'o':
+			if (IS_RECORD_AGENT(ctx))
+				die("-o incompatible with agent recording");
 			if (host)
 				die("-o incompatible with -N");
 			if (IS_START(ctx))
@@ -4875,6 +5322,8 @@ static void parse_record_options(int argc,
 		case 'N':
 			if (!IS_RECORD(ctx))
 				die("-N only available with record");
+			if (IS_RECORD_AGENT(ctx))
+				die("-N incompatible with agent recording");
 			if (ctx->output)
 				die("-N incompatible with -o");
 			host = optarg;
@@ -4974,6 +5423,16 @@ static void parse_record_options(int argc,
 		}
 	}
 
+	/* If --date is specified, prepend it to all guest VM flags */
+	if (ctx->date) {
+		struct buffer_instance *instance;
+
+		for_all_instances(instance) {
+			if (is_guest(instance))
+				add_argv(instance, "--date", true);
+		}
+	}
+
 	if (!ctx->filtered && ctx->instance->filter_mod)
 		add_func(&ctx->instance->filter_funcs,
 			 ctx->instance->filter_mod, "*");
@@ -5004,7 +5463,8 @@ static enum trace_type get_trace_cmd_type(enum trace_cmd cmd)
 		{CMD_stream, TRACE_TYPE_STREAM},
 		{CMD_extract, TRACE_TYPE_EXTRACT},
 		{CMD_profile, TRACE_TYPE_STREAM},
-		{CMD_start, TRACE_TYPE_START}
+		{CMD_start, TRACE_TYPE_START},
+		{CMD_record_agent, TRACE_TYPE_RECORD}
 	};
 
 	for (int i = 0; i < ARRAY_SIZE(trace_type_per_command); i++) {
@@ -5036,12 +5496,30 @@ static void finalize_record_trace(struct common_record_context *ctx)
 		if (instance->flags & BUFFER_FL_KEEP)
 			write_tracing_on(instance,
 					 instance->tracing_on_init_val);
+		if (is_agent(instance)) {
+			tracecmd_msg_send_close_resp_msg(instance->msg_handle);
+			tracecmd_output_close(instance->network_handle);
+		}
 	}
 
 	if (host)
 		tracecmd_output_close(ctx->instance->network_handle);
 }
 
+static bool has_local_instances(void)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance) {
+		if (is_guest(instance))
+			continue;
+		if (host && instance->msg_handle)
+			continue;
+		return true;
+	}
+	return false;
+}
+
 /*
  * This function contains common code for the following commands:
  * record, start, stream, profile.
@@ -5070,7 +5548,6 @@ static void record_trace(int argc, char **argv,
 
 	/* Save the state of tracing_on before starting */
 	for_all_instances(instance) {
-
 		if (!ctx->manual && instance->flags & BUFFER_FL_PROFILE)
 			enable_profile(instance);
 
@@ -5087,14 +5564,16 @@ static void record_trace(int argc, char **argv,
 
 	page_size = getpagesize();
 
-	fset = set_ftrace(!ctx->disable, ctx->total_disable);
+	if (!is_guest(ctx->instance))
+		fset = set_ftrace(!ctx->disable, ctx->total_disable);
 	tracecmd_disable_all_tracing(1);
 
 	for_all_instances(instance)
 		set_clock(instance);
 
 	/* Record records the date first */
-	if (IS_RECORD(ctx) && ctx->date)
+	if (ctx->date &&
+	    ((IS_RECORD(ctx) && has_local_instances()) || IS_RECORD_AGENT(ctx)))
 		ctx->date2ts = get_date_to_ts();
 
 	for_all_instances(instance) {
@@ -5131,9 +5610,13 @@ static void record_trace(int argc, char **argv,
 		exit(0);
 	}
 
-	if (ctx->run_command)
+	if (ctx->run_command) {
 		run_cmd(type, (argc - optind) - 1, &argv[optind + 1]);
-	else {
+	} else if (ctx->instance && is_agent(ctx->instance)) {
+		update_task_filter();
+		tracecmd_enable_tracing();
+		tracecmd_msg_wait_close(ctx->instance->msg_handle);
+	} else {
 		update_task_filter();
 		tracecmd_enable_tracing();
 		/* We don't ptrace ourself */
@@ -5145,6 +5628,7 @@ static void record_trace(int argc, char **argv,
 			trace_or_sleep(type);
 	}
 
+	tell_guests_to_stop();
 	tracecmd_disable_tracing();
 	if (!latency)
 		stop_threads(type);
@@ -5154,6 +5638,9 @@ static void record_trace(int argc, char **argv,
 	if (!keep)
 		tracecmd_disable_all_tracing(0);
 
+	if (!latency)
+		wait_threads();
+
 	if (IS_RECORD(ctx)) {
 		record_data(ctx);
 		delete_thread_data();
@@ -5290,3 +5777,40 @@ void trace_record(int argc, char **argv)
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
+	memmove(argv_plus + 2, argv, argc * sizeof(char *));
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
index 406384c..da34ea2 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -233,11 +233,22 @@ static struct usage_help usage_help[] = {
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
+#ifdef VSOCK
+	{
+		"agent",
+		"listen on a vsocket for trace clients",
+		" %s agent -p port[-D]\n"
+		"          Creates a vsocket to listen for clients.\n"
+		"          -p port number to listen on.\n"
+		"          -D run in daemon mode.\n"
+	},
+#endif
 	{
 		"list",
 		"list the available events, plugins or options",
-- 
2.20.1

