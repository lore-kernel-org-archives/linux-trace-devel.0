Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751232AbeACRxk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:40 -0500
Message-Id: <20180103175339.084944880@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 29/38] trace-cmd: Remove global use_tcp variable
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0029-trace-cmd-Remove-global-use_tcp-variable.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In order to have trace-listen be able to do a handshake before the fork, it
can not have a use_tcp variables. Turn use_tcp as a flag in msg_handle.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-cmd.h    |  2 ++
 trace-listen.c | 25 +++++++++++++------------
 trace-msg.c    | 18 ++++++++----------
 trace-msg.h    |  4 ----
 trace-record.c |  6 ++++++
 5 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/trace-cmd.h b/trace-cmd.h
index 2fe4b208c561..30badbd47cc6 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -303,11 +303,13 @@ void tracecmd_enable_tracing(void);
 enum tracecmd_msg_bits {
 	TRACECMD_MSG_BIT_CLIENT		= 0,
 	TRACECMD_MSG_BIT_SERVER		= 1,
+	TRACECMD_MSG_BIT_USE_TCP	= 2,
 };
 
 enum tracecmd_msg_flags {
 	TRACECMD_MSG_FL_CLIENT		= (1 << TRACECMD_MSG_BIT_CLIENT),
 	TRACECMD_MSG_FL_SERVER		= (1 << TRACECMD_MSG_BIT_SERVER),
+	TRACECMD_MSG_FL_USE_TCP		= (1 << TRACECMD_MSG_BIT_USE_TCP),
 };
 
 /* for both client and server */
diff --git a/trace-listen.c b/trace-listen.c
index 2e17839cffec..a1e35ef19761 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -112,11 +112,11 @@ static int read_string(int fd, char *buf, size_t size)
 	return i;
 }
 
-static int process_option(char *option)
+static int process_option(struct tracecmd_msg_handle *msg_handle, char *option)
 {
 	/* currently the only option we have is to us TCP */
 	if (strcmp(option, "TCP") == 0) {
-		use_tcp = 1;
+		msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
 		return 1;
 	}
 	return 0;
@@ -225,7 +225,7 @@ void pdie(const char *fmt, ...)
 }
 
 static int process_udp_child(int sfd, const char *host, const char *port,
-			     int cpu, int page_size)
+			     int cpu, int page_size, int use_tcp)
 {
 	struct sockaddr_storage peer_addr;
 	socklen_t peer_addr_len;
@@ -292,7 +292,7 @@ static int process_udp_child(int sfd, const char *host, const char *port,
 #define START_PORT_SEARCH 1500
 #define MAX_PORT_SEARCH 6000
 
-static int udp_bind_a_port(int start_port, int *sfd)
+static int udp_bind_a_port(int start_port, int *sfd, int use_tcp)
 {
 	struct addrinfo hints;
 	struct addrinfo *result, *rp;
@@ -337,7 +337,7 @@ static int udp_bind_a_port(int start_port, int *sfd)
 }
 
 static void fork_udp_reader(int sfd, const char *node, const char *port,
-			    int *pid, int cpu, int pagesize)
+			    int *pid, int cpu, int pagesize, int use_tcp)
 {
 	int ret;
 
@@ -347,7 +347,7 @@ static void fork_udp_reader(int sfd, const char *node, const char *port,
 		pdie("creating udp reader");
 
 	if (!*pid) {
-		ret = process_udp_child(sfd, node, port, cpu, pagesize);
+		ret = process_udp_child(sfd, node, port, cpu, pagesize, use_tcp);
 		if (ret < 0)
 			pdie("Problem with udp reader %d", ret);
 	}
@@ -356,7 +356,7 @@ static void fork_udp_reader(int sfd, const char *node, const char *port,
 }
 
 static int open_udp(const char *node, const char *port, int *pid,
-		    int cpu, int pagesize, int start_port)
+		    int cpu, int pagesize, int start_port, int use_tcp)
 {
 	int sfd;
 	int num_port;
@@ -365,11 +365,11 @@ static int open_udp(const char *node, const char *port, int *pid,
 	 * udp_bind_a_port() currently does not return an error, but if that
 	 * changes in the future, we have a check for it now.
 	 */
-	num_port = udp_bind_a_port(start_port, &sfd);
+	num_port = udp_bind_a_port(start_port, &sfd, use_tcp);
 	if (num_port < 0)
 		return num_port;
 
-	fork_udp_reader(sfd, node, port, pid, cpu, pagesize);
+	fork_udp_reader(sfd, node, port, pid, cpu, pagesize, use_tcp);
 
 	return num_port;
 }
@@ -495,7 +495,7 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle,
 				s = size - t;
 			} while (t);
 
-			s = process_option(option);
+			s = process_option(msg_handle, option);
 			free(option);
 			/* do we understand this option? */
 			ret = -EINVAL;
@@ -504,7 +504,7 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle,
 		}
 	}
 
-	if (use_tcp)
+	if (msg_handle->flags & TRACECMD_MSG_FL_USE_TCP)
 		plog("Using TCP for live connection\n");
 
 	ret = 0;
@@ -547,6 +547,7 @@ static void destroy_all_readers(int cpus, int *pid_array, const char *node,
 static int *create_all_readers(int cpus, const char *node, const char *port,
 			       int pagesize, struct tracecmd_msg_handle *msg_handle)
 {
+	int use_tcp = msg_handle->flags & TRACECMD_MSG_FL_USE_TCP;
 	char buf[BUFSIZ];
 	int *port_array;
 	int *pid_array;
@@ -572,7 +573,7 @@ static int *create_all_readers(int cpus, const char *node, const char *port,
 	/* Now create a UDP port for each CPU */
 	for (cpu = 0; cpu < cpus; cpu++) {
 		udp_port = open_udp(node, port, &pid, cpu,
-				    pagesize, start_port);
+				    pagesize, start_port, use_tcp);
 		if (udp_port < 0)
 			goto out_free;
 		port_array[cpu] = udp_port;
diff --git a/trace-msg.c b/trace-msg.c
index 9b01197574da..0d564c4aee32 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -75,10 +75,6 @@ static inline void dprint(const char *fmt, ...)
 #define MIN_META_SIZE	(sizeof(struct tracecmd_msg_header) + \
 			 sizeof(struct tracecmd_msg_meta))
 
-/* for both client and server */
-bool use_tcp;
-
-/* for client */
 unsigned int page_size;
 
 struct tracecmd_msg_server {
@@ -198,13 +194,14 @@ enum msg_opt_command {
 	MSGOPT_USETCP = 1,
 };
 
-static int make_tinit(struct tracecmd_msg *msg, int total_cpus)
+static int make_tinit(struct tracecmd_msg_handle *msg_handle,
+		      struct tracecmd_msg *msg, int total_cpus)
 {
 	struct tracecmd_msg_opt *opt;
 	int opt_num = 0;
 	int size = MIN_TINIT_SIZE;
 
-	if (use_tcp) {
+	if (msg_handle->flags & TRACECMD_MSG_FL_USE_TCP) {
 		opt_num++;
 		opt = malloc(sizeof(*opt));
 		if (!opt)
@@ -434,7 +431,7 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 	*client_ports = NULL;
 
 	tracecmd_msg_init(MSG_TINIT, &send_msg);
-	ret = make_tinit(&send_msg, total_cpus);
+	ret = make_tinit(msg_handle, &send_msg, total_cpus);
 	if (ret < 0)
 		return ret;
 
@@ -459,11 +456,12 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 	return 0;
 }
 
-static bool process_option(struct tracecmd_msg_opt *opt)
+static bool process_option(struct tracecmd_msg_handle *msg_handle,
+			   struct tracecmd_msg_opt *opt)
 {
 	/* currently the only option we have is to us TCP */
 	if (ntohl(opt->opt_cmd) == MSGOPT_USETCP) {
-		use_tcp = true;
+		msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
 		return true;
 	}
 	return false;
@@ -539,7 +537,7 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle,
 			ret = -EINVAL;
 			goto error;
 		}
-		s = process_option(opt);
+		s = process_option(msg_handle, opt);
 		/* do we understand this option? */
 		if (!s) {
 			plog("Cannot understand(%d:%d:%d)\n",
diff --git a/trace-msg.h b/trace-msg.h
index da563ea55c85..bfd065c06324 100644
--- a/trace-msg.h
+++ b/trace-msg.h
@@ -10,10 +10,6 @@
 #define V1_PROTOCOL	1
 #define V2_PROTOCOL	2
 
-/* for both client and server */
-extern bool use_tcp;
-
-/* for client */
 extern unsigned int page_size;
 
 void plog(const char *fmt, ...);
diff --git a/trace-record.c b/trace-record.c
index 3decb57a9a6c..9512fd9853ad 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -95,6 +95,8 @@ static struct tracecmd_output *network_handle;
 /* Max size to let a per cpu file get */
 static int max_kb;
 
+static bool use_tcp;
+
 static int do_ptrace;
 
 static int filter_task;
@@ -2719,6 +2721,7 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
 	if (page_size >= UDP_MAX_PACKET) {
 		warning("page size too big for UDP using TCP in live read");
 		use_tcp = 1;
+		msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
 	}
 
 	if (use_tcp) {
@@ -2859,6 +2862,9 @@ again:
 	if (!msg_handle)
 		die("Failed to allocate message handle");
 
+	if (use_tcp)
+		msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
+
 	if (proto_ver == V2_PROTOCOL) {
 		check_protocol_version(msg_handle);
 		if (proto_ver == V1_PROTOCOL) {
-- 
2.13.2
