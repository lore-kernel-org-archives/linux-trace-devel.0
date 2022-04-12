Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EEB0C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Apr 2022 04:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345874AbiDLEaK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345601AbiDLEaJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 00:30:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71B032991
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Apr 2022 21:27:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 628A461792
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Apr 2022 04:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9715EC385A6;
        Tue, 12 Apr 2022 04:27:51 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ne886-003VeL-Ja;
        Tue, 12 Apr 2022 00:27:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/4] trace-cmd listen: Add vsocket usage
Date:   Tue, 12 Apr 2022 00:27:39 -0400
Message-Id: <20220412042739.836516-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412042739.836516-1-rostedt@goodmis.org>
References: <20220412042739.836516-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

As vsockets are slightly faster than TCP connections, and act the same,
there's no reason to not use them for the listen command.

Add trace-cmd listen -V and trace-cmd record -V to use vsockets instead of
communicating with normal networking.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |   1 +
 lib/trace-cmd/trace-msg.c                     |  15 +-
 tracecmd/include/trace-local.h                |   3 +
 tracecmd/trace-agent.c                        |   2 +-
 tracecmd/trace-listen.c                       | 141 ++++++++++++++----
 tracecmd/trace-record.c                       |  83 ++++++++++-
 6 files changed, 205 insertions(+), 40 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 69343765c5ff..bd20451fda5b 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -374,6 +374,7 @@ long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
 
 enum tracecmd_msg_flags {
 	TRACECMD_MSG_FL_USE_TCP		= 1 << 0,
+	TRACECMD_MSG_FL_USE_VSOCK	= 1 << 1,
 };
 
 /* for both client and server */
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 03b853e4368b..3d0190c9adec 100644
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
index 30119a33574b..7b33f009ac95 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -44,6 +44,7 @@ int trace_set_verbose(char *level);
 enum port_type {
 	USE_UDP,
 	USE_TCP,
+	USE_VSOCK
 };
 
 struct pid_record_data {
@@ -342,6 +343,8 @@ int trace_make_vsock(unsigned int port);
 int trace_get_vsock_port(int sd, unsigned int *port);
 int trace_open_vsock(unsigned int cid, unsigned int port);
 
+int get_local_cid(unsigned int *cid);
+
 char *trace_get_guest_file(const char *file, const char *guest);
 
 /* No longer in event-utils.h */
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index a46feea3d3c7..406c9db3dce5 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -26,7 +26,7 @@
 
 #define GET_LOCAL_CID	0x7b9
 
-static int get_local_cid(unsigned int *cid)
+int get_local_cid(unsigned int *cid)
 {
 	int fd, ret = 0;
 
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index a5d4ec64f77c..fd171bdd7aa4 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -19,6 +19,8 @@
 #include <signal.h>
 #include <errno.h>
 
+#include <linux/vm_sockets.h>
+
 #include "trace-local.h"
 #include "trace-msg.h"
 
@@ -34,6 +36,8 @@ static char *output_dir;
 static char *default_output_file = "trace";
 static char *output_file;
 
+static bool use_vsock;
+
 static int backlog = 5;
 
 static int do_daemon;
@@ -141,7 +145,9 @@ static int process_child(int sfd, const char *host, const char *port,
 			 int cpu, int page_size, enum port_type type)
 {
 	struct sockaddr_storage peer_addr;
-	socklen_t peer_addr_len;
+	struct sockaddr_vm vm_addr;
+	struct sockaddr *addr;
+	socklen_t addr_len;
 	char buf[page_size];
 	char *tempfile;
 	int left;
@@ -161,10 +167,18 @@ static int process_child(int sfd, const char *host, const char *port,
 		pdie("creating %s", tempfile);
 
 	if (type == USE_TCP) {
+		addr = (struct sockaddr *)&peer_addr;
+		addr_len = sizeof(peer_addr);
+	} else if (type == USE_VSOCK) {
+		addr = (struct sockaddr *)&vm_addr;
+		addr_len = sizeof(vm_addr);
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
@@ -202,6 +216,29 @@ static int process_child(int sfd, const char *host, const char *port,
 	exit(0);
 }
 
+static int setup_vsock_port(int start_port, int *sfd)
+{
+	struct sockaddr_vm addr = {
+		.svm_family = AF_VSOCK,
+		.svm_cid = VMADDR_CID_ANY,
+		.svm_port = start_port,
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
+	*sfd = sd;
+
+	return start_port;
+}
+
 #define START_PORT_SEARCH 1500
 #define MAX_PORT_SEARCH 6000
 
@@ -213,6 +250,8 @@ static int bind_a_port(int start_port, int *sfd, enum port_type type)
 	int s;
 	int num_port = start_port;
 
+	if (type == USE_VSOCK)
+		return setup_vsock_port(start_port, sfd);
  again:
 	snprintf(buf, BUFSIZ, "%d", num_port);
 
@@ -478,6 +517,8 @@ static int *create_all_readers(const char *node, const char *port,
 
 	if (msg_handle->flags & TRACECMD_MSG_FL_USE_TCP)
 		port_type = USE_TCP;
+	else if (msg_handle->flags & TRACECMD_MSG_FL_USE_VSOCK)
+		port_type = USE_VSOCK;
 
 	port_array = malloc(sizeof(*port_array) * cpus);
 	if (!port_array)
@@ -700,8 +741,8 @@ static int do_fork(int cfd)
 	return 0;
 }
 
-static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
-			  socklen_t peer_addr_len)
+static int do_connection(int cfd, struct sockaddr *addr,
+			  socklen_t addr_len)
 {
 	struct tracecmd_msg_handle *msg_handle;
 	char host[NI_MAXHOST], service[NI_MAXSERV];
@@ -714,17 +755,23 @@ static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
 
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
+		struct sockaddr_vm *vm_addr = (struct sockaddr_vm *)addr;
+		snprintf(host, NI_MAXHOST, "V%d", vm_addr->svm_cid);
+		snprintf(service, NI_MAXSERV, "%d", vm_addr->svm_port);
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
@@ -816,14 +863,21 @@ static void clean_up(void)
 static void do_accept_loop(int sfd)
 {
 	struct sockaddr_storage peer_addr;
-	socklen_t peer_addr_len;
+	struct sockaddr_vm vm_addr;
+	struct sockaddr *addr;
+	socklen_t addr_len;
 	int cfd, pid;
 
-	peer_addr_len = sizeof(peer_addr);
+	if (use_vsock) {
+		addr = (struct sockaddr *)&vm_addr;
+		addr_len = sizeof(vm_addr);
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
@@ -831,7 +885,7 @@ static void do_accept_loop(int sfd)
 		if (cfd < 0)
 			pdie("connecting");
 
-		pid = do_connection(cfd, &peer_addr, peer_addr_len);
+		pid = do_connection(cfd, addr, addr_len);
 		if (pid > 0)
 			add_process(pid);
 
@@ -866,17 +920,27 @@ static void sigstub(int sig)
 {
 }
 
-static void do_listen(char *port)
+static int get_vsock(const char *port)
+{
+	unsigned int cid;
+	int sd;
+
+	sd = trace_make_vsock(atoi(port));
+	if (sd < 0)
+		return sd;
+
+	if (!get_local_cid(&cid))
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
@@ -903,6 +967,24 @@ static void do_listen(char *port)
 
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
 
@@ -949,7 +1031,7 @@ void trace_listen(int argc, char **argv)
 			{NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long (argc-1, argv+1, "+hp:o:d:l:D",
+		c = getopt_long (argc-1, argv+1, "+hp:Vo:d:l:D",
 			long_options, &option_index);
 		if (c == -1)
 			break;
@@ -963,6 +1045,9 @@ void trace_listen(int argc, char **argv)
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
index bff3620dcd8c..d20df48e9179 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3122,6 +3122,8 @@ static void finish(int sig)
 	finished = 1;
 }
 
+int trace_open_vsock(unsigned int cid, unsigned int port);
+
 static int connect_port(const char *host, unsigned int port)
 {
 	struct addrinfo hints;
@@ -3131,6 +3133,9 @@ static int connect_port(const char *host, unsigned int port)
 
 	snprintf(buf, BUFSIZ, "%u", port);
 
+	if (port_type == USE_VSOCK)
+		return trace_open_vsock(atoi(host), port);
+
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family = AF_UNSPEC;
 	hints.ai_socktype = port_type == USE_TCP ? SOCK_STREAM : SOCK_DGRAM;
@@ -3610,11 +3615,33 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
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
+	sd = trace_open_vsock(atoi(cid), atoi(port));
+
+	return sd;
+}
+
+static int connect_ip(char *host)
 {
-	struct tracecmd_msg_handle *msg_handle = NULL;
 	struct addrinfo hints;
 	struct addrinfo *result, *rp;
+	char *thost = NULL;
 	int sfd, s;
 	char *server;
 	char *port;
@@ -3627,8 +3654,8 @@ static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instanc
 		port = host;
 		host = server;
 	} else {
-		host = strdup(host);
-		if (!host)
+		thost = strdup(host);
+		if (!thost)
 			die("alloctating server");
 		server = strtok_r(host, ":", &p);
 		port = strtok_r(NULL, ":", &p);
@@ -3638,7 +3665,6 @@ static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instanc
 	hints.ai_family = AF_UNSPEC;
 	hints.ai_socktype = SOCK_STREAM;
 
-again:
 	s = getaddrinfo(server, port, &hints, &result);
 	if (s != 0)
 		die("getaddrinfo: %s", gai_strerror(s));
@@ -3658,6 +3684,27 @@ again:
 		die("Can not connect to %s:%s", server, port);
 
 	freeaddrinfo(result);
+	free(thost);
+
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
 
 	if (msg_handle) {
 		msg_handle->fd = sfd;
@@ -3670,14 +3717,23 @@ again:
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
@@ -3728,6 +3784,8 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 	int ret;
 
 	msg_handle = setup_network(instance);
+	if (!msg_handle)
+		die("Failed to make connection");
 
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
@@ -6233,7 +6291,7 @@ static void parse_record_options(int argc,
 		if (IS_EXTRACT(ctx))
 			opts = "+haf:Fp:co:O:sr:g:l:n:P:N:tb:B:ksiT";
 		else
-			opts = "+hae:f:FA:p:cC:dDGo:O:s:r:vg:l:n:P:N:tb:R:B:ksSiTm:M:H:q";
+			opts = "+hae:f:FA:p:cC:dDGo:O:s:r:V:vg:l:n:P:N:tb:R:B:ksSiTm:M:H:q";
 		c = getopt_long (argc-1, argv+1, opts, long_options, &option_index);
 		if (c == -1)
 			break;
@@ -6525,6 +6583,17 @@ static void parse_record_options(int argc,
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

