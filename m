Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7133C433FE
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 18:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbiDQSgg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Apr 2022 14:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234792AbiDQSge (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Apr 2022 14:36:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FC51C92E
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 11:33:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F159A60C83
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 18:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2B1C385A9;
        Sun, 17 Apr 2022 18:33:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ng9id-004NGZ-Of;
        Sun, 17 Apr 2022 14:33:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 4/5] trace-cmd listen: Add vsocket usage
Date:   Sun, 17 Apr 2022 14:33:53 -0400
Message-Id: <20220417183354.1042657-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220417183354.1042657-1-rostedt@goodmis.org>
References: <20220417183354.1042657-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

As vsockets are slightly faster than TCP connections, and act the same,
there's no reason to not use them for the listen command.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |   1 +
 lib/trace-cmd/trace-msg.c                     |  15 +-
 tracecmd/include/trace-local.h                |   3 +
 tracecmd/trace-listen.c                       | 143 ++++++++++++++----
 tracecmd/trace-record.c                       |  79 +++++++++-
 5 files changed, 202 insertions(+), 39 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 45ae1dded66d..f68d17bb8e1d 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -374,6 +374,7 @@ long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
 
 enum tracecmd_msg_flags {
 	TRACECMD_MSG_FL_USE_TCP		= 1 << 0,
+	TRACECMD_MSG_FL_USE_VSOCK	= 1 << 1,
 };
 
 /* for both client and server */
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 726e9424c8fd..6cf74f9b1c99 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -214,10 +214,14 @@ static int make_tinit(struct tracecmd_msg_handle *msg_handle,
 	int opt_num = 0;
 	int data_size = 0;
 
-	if (msg_handle->flags & TRACECMD_MSG_FL_USE_TCP) {
+	if (msg_handle->flags & (TRACECMD_MSG_FL_USE_TCP |
+				 TRACECMD_MSG_FL_USE_VSOCK)) {
+		msg->buf = msg_handle->flags & TRACECMD_MSG_FL_USE_TCP ?
+			strdup("tcp") : strdup("vsock");
+		if (!msg->buf)
+			return -1;
 		opt_num++;
-		msg->buf = strdup("tcp");
-		data_size += 4;
+		data_size += strlen(msg->buf) + 1;
 	}
 
 	msg->tinit.cpus = htonl(cpu_count);
@@ -566,11 +570,14 @@ out:
 static bool process_option(struct tracecmd_msg_handle *msg_handle,
 			   const char *opt)
 {
-	/* currently the only option we have is to use TCP */
 	if (strcmp(opt, "tcp") == 0) {
 		msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
 		return true;
 	}
+	if (strcmp(opt, "vsock") == 0) {
+		msg_handle->flags |= TRACECMD_MSG_FL_USE_VSOCK;
+		return true;
+	}
 	return false;
 }
 
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index d23cbf24cc06..aa1cb8d939bd 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -45,6 +45,7 @@ int trace_set_verbose(char *level);
 enum port_type {
 	USE_UDP,
 	USE_TCP,
+	USE_VSOCK
 };
 
 struct pid_record_data {
@@ -343,6 +344,8 @@ int trace_make_vsock(unsigned int port);
 int trace_get_vsock_port(int sd, unsigned int *port);
 int trace_open_vsock(unsigned int cid, unsigned int port);
 
+int get_local_cid(unsigned int *cid);
+
 char *trace_get_guest_file(const char *file, const char *guest);
 
 #ifdef VSOCK
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index a5d4ec64f77c..2338173fc8a6 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -19,6 +19,10 @@
 #include <signal.h>
 #include <errno.h>
 
+#ifdef VSOCK
+#include <linux/vm_sockets.h>
+#endif
+
 #include "trace-local.h"
 #include "trace-msg.h"
 
@@ -34,6 +38,8 @@ static char *output_dir;
 static char *default_output_file = "trace";
 static char *output_file;
 
+static bool use_vsock;
+
 static int backlog = 5;
 
 static int do_daemon;
@@ -141,7 +147,11 @@ static int process_child(int sfd, const char *host, const char *port,
 			 int cpu, int page_size, enum port_type type)
 {
 	struct sockaddr_storage peer_addr;
-	socklen_t peer_addr_len;
+#ifdef VSOCK
+	struct sockaddr_vm vm_addr;
+#endif
+	struct sockaddr *addr;
+	socklen_t addr_len;
 	char buf[page_size];
 	char *tempfile;
 	int left;
@@ -161,10 +171,20 @@ static int process_child(int sfd, const char *host, const char *port,
 		pdie("creating %s", tempfile);
 
 	if (type == USE_TCP) {
+		addr = (struct sockaddr *)&peer_addr;
+		addr_len = sizeof(peer_addr);
+#ifdef VSOCK
+	} else if (type == USE_VSOCK) {
+		addr = (struct sockaddr *)&vm_addr;
+		addr_len = sizeof(vm_addr);
+#endif
+	}
+
+	if (type == USE_TCP || type == USE_VSOCK) {
 		if (listen(sfd, backlog) < 0)
 			pdie("listen");
-		peer_addr_len = sizeof(peer_addr);
-		cfd = accept(sfd, (struct sockaddr *)&peer_addr, &peer_addr_len);
+
+		cfd = accept(sfd, addr, &addr_len);
 		if (cfd < 0 && errno == EINTR)
 			goto done;
 		if (cfd < 0)
@@ -202,6 +222,18 @@ static int process_child(int sfd, const char *host, const char *port,
 	exit(0);
 }
 
+static int setup_vsock_port(int start_port, int *sfd)
+{
+	int sd;
+
+	sd = trace_vsock_make(start_port);
+	if (sd < 0)
+		return -errno;
+	*sfd = sd;
+
+	return start_port;
+}
+
 #define START_PORT_SEARCH 1500
 #define MAX_PORT_SEARCH 6000
 
@@ -213,6 +245,8 @@ static int bind_a_port(int start_port, int *sfd, enum port_type type)
 	int s;
 	int num_port = start_port;
 
+	if (type == USE_VSOCK)
+		return setup_vsock_port(start_port, sfd);
  again:
 	snprintf(buf, BUFSIZ, "%d", num_port);
 
@@ -478,6 +512,8 @@ static int *create_all_readers(const char *node, const char *port,
 
 	if (msg_handle->flags & TRACECMD_MSG_FL_USE_TCP)
 		port_type = USE_TCP;
+	else if (msg_handle->flags & TRACECMD_MSG_FL_USE_VSOCK)
+		port_type = USE_VSOCK;
 
 	port_array = malloc(sizeof(*port_array) * cpus);
 	if (!port_array)
@@ -700,8 +736,8 @@ static int do_fork(int cfd)
 	return 0;
 }
 
-static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
-			  socklen_t peer_addr_len)
+static int do_connection(int cfd, struct sockaddr *addr,
+			  socklen_t addr_len)
 {
 	struct tracecmd_msg_handle *msg_handle;
 	char host[NI_MAXHOST], service[NI_MAXSERV];
@@ -714,17 +750,25 @@ static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
 
 	msg_handle = tracecmd_msg_handle_alloc(cfd, 0);
 
-	s = getnameinfo((struct sockaddr *)peer_addr, peer_addr_len,
-			host, NI_MAXHOST,
-			service, NI_MAXSERV, NI_NUMERICSERV);
-
-	if (s == 0)
-		tracecmd_plog("Connected with %s:%s\n", host, service);
-	else {
-		tracecmd_plog("Error with getnameinfo: %s\n", gai_strerror(s));
-		close(cfd);
-		tracecmd_msg_handle_close(msg_handle);
-		return -1;
+	if (use_vsock) {
+#ifdef VSOCK
+		struct sockaddr_vm *vm_addr = (struct sockaddr_vm *)addr;
+		snprintf(host, NI_MAXHOST, "V%d", vm_addr->svm_cid);
+		snprintf(service, NI_MAXSERV, "%d", vm_addr->svm_port);
+#endif
+	} else {
+		s = getnameinfo((struct sockaddr *)addr, addr_len,
+				host, NI_MAXHOST,
+				service, NI_MAXSERV, NI_NUMERICSERV);
+
+		if (s == 0)
+			tracecmd_plog("Connected with %s:%s\n", host, service);
+		else {
+			tracecmd_plog("Error with getnameinfo: %s\n", gai_strerror(s));
+			close(cfd);
+			tracecmd_msg_handle_close(msg_handle);
+			return -1;
+		}
 	}
 
 	process_client(msg_handle, host, service);
@@ -816,14 +860,25 @@ static void clean_up(void)
 static void do_accept_loop(int sfd)
 {
 	struct sockaddr_storage peer_addr;
-	socklen_t peer_addr_len;
+#ifdef VSOCK
+	struct sockaddr_vm vm_addr;
+#endif
+	struct sockaddr *addr;
+	socklen_t addr_len;
 	int cfd, pid;
 
-	peer_addr_len = sizeof(peer_addr);
+	if (use_vsock) {
+#ifdef VSOCK
+		addr = (struct sockaddr *)&vm_addr;
+		addr_len = sizeof(vm_addr);
+#endif
+	} else {
+		addr = (struct sockaddr *)&peer_addr;
+		addr_len = sizeof(peer_addr);
+	}
 
 	do {
-		cfd = accept(sfd, (struct sockaddr *)&peer_addr,
-			     &peer_addr_len);
+		cfd = accept(sfd, addr, &addr_len);
 		if (cfd < 0 && errno == EINTR) {
 			clean_up();
 			continue;
@@ -831,7 +886,7 @@ static void do_accept_loop(int sfd)
 		if (cfd < 0)
 			pdie("connecting");
 
-		pid = do_connection(cfd, &peer_addr, peer_addr_len);
+		pid = do_connection(cfd, addr, addr_len);
 		if (pid > 0)
 			add_process(pid);
 
@@ -866,17 +921,28 @@ static void sigstub(int sig)
 {
 }
 
-static void do_listen(char *port)
+static int get_vsock(const char *port)
+{
+	unsigned int cid;
+	int sd;
+
+	sd = trace_vsock_make(atoi(port));
+	if (sd < 0)
+		return sd;
+
+	cid = trace_vsock_local_cid();
+	if (cid >= 0)
+		printf("listening on @%u:%s\n", cid, port);
+
+	return sd;
+}
+
+static int get_network(char *port)
 {
 	struct addrinfo hints;
 	struct addrinfo *result, *rp;
 	int sfd, s;
 
-	if (!tracecmd_get_debug())
-		signal_setup(SIGCHLD, sigstub);
-
-	make_pid_file();
-
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family = AF_UNSPEC;
 	hints.ai_socktype = SOCK_STREAM;
@@ -903,6 +969,24 @@ static void do_listen(char *port)
 
 	freeaddrinfo(result);
 
+	return sfd;
+}
+
+static void do_listen(char *port)
+{
+	int sfd;
+
+	if (!tracecmd_get_debug())
+		signal_setup(SIGCHLD, sigstub);
+
+	make_pid_file();
+
+	if (use_vsock)
+		sfd = get_vsock(port);
+	else
+		sfd = get_network(port);
+
+
 	if (listen(sfd, backlog) < 0)
 		pdie("listen");
 
@@ -949,7 +1033,7 @@ void trace_listen(int argc, char **argv)
 			{NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long (argc-1, argv+1, "+hp:o:d:l:D",
+		c = getopt_long (argc-1, argv+1, "+hp:Vo:d:l:D",
 			long_options, &option_index);
 		if (c == -1)
 			break;
@@ -963,6 +1047,9 @@ void trace_listen(int argc, char **argv)
 		case 'd':
 			output_dir = optarg;
 			break;
+		case 'V':
+			use_vsock = true;
+			break;
 		case 'o':
 			output_file = optarg;
 			break;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 022a024c665b..674ec2c3ba65 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3128,6 +3128,9 @@ static int connect_port(const char *host, unsigned int port)
 
 	snprintf(buf, BUFSIZ, "%u", port);
 
+	if (port_type == USE_VSOCK)
+		return trace_vsock_open(atoi(host), port);
+
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family = AF_UNSPEC;
 	hints.ai_socktype = port_type == USE_TCP ? SOCK_STREAM : SOCK_DGRAM;
@@ -3531,9 +3534,30 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 	}
 }
 
-static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instance)
+static int connect_vsock(char *vhost)
+{
+	char *cid;
+	char *port;
+	char *p;
+	int sd;
+
+	host = strdup(vhost);
+	if (!host)
+		die("alloctating server");
+
+	cid = strtok_r(host, ":", &p);
+	port = strtok_r(NULL, "", &p);
+
+	if (!port)
+		die("vsocket must have format of 'CID:PORT'");
+
+	sd = trace_vsock_open(atoi(cid), atoi(port));
+
+	return sd;
+}
+
+static int connect_ip(char *thost)
 {
-	struct tracecmd_msg_handle *msg_handle = NULL;
 	struct addrinfo hints;
 	struct addrinfo *result, *rp;
 	int sfd, s;
@@ -3545,10 +3569,10 @@ static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instanc
 		server = strdup("localhost");
 		if (!server)
 			die("alloctating server");
-		port = host;
+		port = thost;
 		host = server;
 	} else {
-		host = strdup(host);
+		host = strdup(thost);
 		if (!host)
 			die("alloctating server");
 		server = strtok_r(host, ":", &p);
@@ -3559,7 +3583,6 @@ static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instanc
 	hints.ai_family = AF_UNSPEC;
 	hints.ai_socktype = SOCK_STREAM;
 
-again:
 	s = getaddrinfo(server, port, &hints, &result);
 	if (s != 0)
 		die("getaddrinfo: %s", gai_strerror(s));
@@ -3580,6 +3603,26 @@ again:
 
 	freeaddrinfo(result);
 
+	return sfd;
+}
+
+static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instance)
+{
+	struct tracecmd_msg_handle *msg_handle = NULL;
+	int sfd;
+
+again:
+	switch (port_type) {
+	case USE_VSOCK:
+		sfd = connect_vsock(host);
+		break;
+	default:
+		sfd = connect_ip(host);
+	}
+
+	if (sfd < 0)
+		return NULL;
+
 	if (msg_handle) {
 		msg_handle->fd = sfd;
 	} else {
@@ -3591,14 +3634,23 @@ again:
 		msg_handle->version = V3_PROTOCOL;
 	}
 
-	if (port_type == USE_TCP)
+	switch (port_type) {
+	case USE_TCP:
 		msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
+		break;
+	case USE_VSOCK:
+		msg_handle->flags |= TRACECMD_MSG_FL_USE_VSOCK;
+		break;
+	default:
+		break;
+	}
 
 	if (msg_handle->version == V3_PROTOCOL) {
 		check_protocol_version(msg_handle);
 		if (msg_handle->version == V1_PROTOCOL) {
 			/* reconnect to the server for using the v1 protocol */
 			close(sfd);
+			free(host);
 			goto again;
 		}
 		communicate_with_listener_v3(msg_handle, &instance->client_ports);
@@ -3649,6 +3701,8 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 	int ret;
 
 	msg_handle = setup_network(instance);
+	if (!msg_handle)
+		die("Failed to make connection");
 
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
@@ -6159,7 +6213,7 @@ static void parse_record_options(int argc,
 		if (IS_EXTRACT(ctx))
 			opts = "+haf:Fp:co:O:sr:g:l:n:P:N:tb:B:ksiT";
 		else
-			opts = "+hae:f:FA:p:cC:dDGo:O:s:r:vg:l:n:P:N:tb:R:B:ksSiTm:M:H:q";
+			opts = "+hae:f:FA:p:cC:dDGo:O:s:r:V:vg:l:n:P:N:tb:R:B:ksSiTm:M:H:q";
 		c = getopt_long (argc-1, argv+1, opts, long_options, &option_index);
 		if (c == -1)
 			break;
@@ -6451,6 +6505,17 @@ static void parse_record_options(int argc,
 				die("-N incompatible with -o");
 			host = optarg;
 			break;
+		case 'V':
+			cmd_check_die(ctx, CMD_set, *(argv+1), "-V");
+			if (!IS_RECORD(ctx))
+				die("-V only available with record");
+			if (IS_RECORD_AGENT(ctx))
+				die("-V incompatible with agent recording");
+			if (ctx->output)
+				die("-V incompatible with -o");
+			host = optarg;
+			port_type = USE_VSOCK;
+			break;
 		case 'm':
 			if (max_kb)
 				die("-m can only be specified once");
-- 
2.35.1

