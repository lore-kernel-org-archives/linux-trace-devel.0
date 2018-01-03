Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751235AbeACRxk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:40 -0500
Message-Id: <20180103175339.371012628@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 31/38] tracecmd: Clean up handling of cpu_count
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0031-tracecmd-Clean-up-handling-of-cpu_count.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of passing around a pointer to a cpus variable, have the
msg_handle->cpu_count set up when the total cpus are discovered.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-cmd.h    |  7 ++++---
 trace-listen.c | 26 ++++++++++++++++----------
 trace-msg.c    | 15 +++++++++------
 3 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/trace-cmd.h b/trace-cmd.h
index 526634fd674b..1204bb307431 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -315,7 +315,8 @@ enum tracecmd_msg_flags {
 /* for both client and server */
 struct tracecmd_msg_handle {
 	int			fd;
-	int			version;	/* Current protocol version */
+	short			cpu_count;
+	short			version;	/* Current protocol version */
 	unsigned long		flags;
 };
 
@@ -335,9 +336,9 @@ void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
 
 /* for server */
 int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle,
-				 int *cpus, int *pagesize);
+				 int *pagesize);
 int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
-				 int total_cpus, int *ports);
+				 int *ports);
 int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int ofd);
 bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
 void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
diff --git a/trace-listen.c b/trace-listen.c
index 93cae4c793fa..c7c0afc5bbee 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -373,13 +373,14 @@ static int open_udp(const char *node, const char *port, int *pid,
 }
 
 static int communicate_with_client(struct tracecmd_msg_handle *msg_handle,
-				   int *cpus, int *pagesize)
+				   int *pagesize)
 {
 	char *last_proto = NULL;
 	char buf[BUFSIZ];
 	char *option;
 	int options;
 	int size;
+	int cpus;
 	int n, s, t, i;
 	int ret = -EINVAL;
 	int fd = msg_handle->fd;
@@ -394,10 +395,10 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle,
 		/** ERROR **/
 		return -EINVAL;
 
-	*cpus = atoi(buf);
+	cpus = atoi(buf);
 
 	/* Is the client using the new protocol? */
-	if (*cpus == -1) {
+	if (cpus == -1) {
 		if (memcmp(buf, V2_CPU, n) != 0) {
 			/* If it did not send a version, then bail */
 			if (memcmp(buf, "-1V", 3)) {
@@ -437,15 +438,17 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle,
 		msg_handle->version = V2_PROTOCOL;
 
 		/* read the CPU count, the page size, and options */
-		if (tracecmd_msg_initial_setting(msg_handle, cpus, pagesize) < 0)
+		if (tracecmd_msg_initial_setting(msg_handle, pagesize) < 0)
 			goto out;
 	} else {
 		/* The client is using the v1 protocol */
 
-		plog("cpus=%d\n", *cpus);
-		if (*cpus < 0)
+		plog("cpus=%d\n", cpus);
+		if (cpus < 0)
 			goto out;
 
+		msg_handle->cpu_count = cpus;
+
 		/* next read the page size */
 		n = read_string(fd, buf, BUFSIZ);
 		if (n == BUFSIZ)
@@ -542,7 +545,7 @@ static void destroy_all_readers(int cpus, int *pid_array, const char *node,
 	free(pid_array);
 }
 
-static int *create_all_readers(int cpus, const char *node, const char *port,
+static int *create_all_readers(const char *node, const char *port,
 			       int pagesize, struct tracecmd_msg_handle *msg_handle)
 {
 	int use_tcp = msg_handle->flags & TRACECMD_MSG_FL_USE_TCP;
@@ -551,6 +554,7 @@ static int *create_all_readers(int cpus, const char *node, const char *port,
 	int *pid_array;
 	int start_port;
 	int udp_port;
+	int cpus = msg_handle->cpu_count;
 	int cpu;
 	int pid;
 
@@ -585,7 +589,7 @@ static int *create_all_readers(int cpus, const char *node, const char *port,
 
 	if (msg_handle->version == V2_PROTOCOL) {
 		/* send set of port numbers to the client */
-		if (tracecmd_msg_send_port_array(msg_handle, cpus, port_array) < 0) {
+		if (tracecmd_msg_send_port_array(msg_handle, port_array) < 0) {
 			plog("Failed sending port array\n");
 			goto out_free;
 		}
@@ -684,13 +688,13 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
 	int ofd;
 	int ret;
 
-	ret = communicate_with_client(msg_handle, &cpus, &pagesize);
+	ret = communicate_with_client(msg_handle, &pagesize);
 	if (ret < 0)
 		return ret;
 
 	ofd = create_client_file(node, port);
 
-	pid_array = create_all_readers(cpus, node, port, pagesize, msg_handle);
+	pid_array = create_all_readers(node, port, pagesize, msg_handle);
 	if (!pid_array)
 		return -ENOMEM;
 
@@ -708,6 +712,8 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
 	/* wait a little to let our readers finish reading */
 	sleep(1);
 
+	cpus = msg_handle->cpu_count;
+
 	/* stop our readers */
 	stop_all_readers(cpus, pid_array);
 
diff --git a/trace-msg.c b/trace-msg.c
index 0d564c4aee32..55fb2e8baabb 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -479,11 +479,12 @@ static void error_operation_for_server(struct tracecmd_msg *msg)
 #define MAX_OPTION_SIZE 4096
 
 int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle,
-				 int *cpus, int *pagesize)
+				 int *pagesize)
 {
 	struct tracecmd_msg_opt *opt;
 	struct tracecmd_msg msg;
 	int options, i, s;
+	int cpus;
 	int ret;
 	int offset = 0;
 	u32 size = MIN_TINIT_SIZE;
@@ -502,13 +503,15 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle,
 		goto error;
 	}
 
-	*cpus = ntohl(msg.tinit.cpus);
-	plog("cpus=%d\n", *cpus);
-	if (*cpus < 0) {
+	cpus = ntohl(msg.tinit.cpus);
+	plog("cpus=%d\n", cpus);
+	if (cpus < 0) {
 		ret = -EINVAL;
 		goto error;
 	}
 
+	msg_handle->cpu_count = cpus;
+
 	*pagesize = ntohl(msg.tinit.page_size);
 	plog("pagesize=%d\n", *pagesize);
 	if (*pagesize <= 0) {
@@ -555,13 +558,13 @@ error:
 }
 
 int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
-				 int total_cpus, int *ports)
+				 int *ports)
 {
 	struct tracecmd_msg msg;
 	int ret;
 
 	tracecmd_msg_init(MSG_RINIT, &msg);
-	ret = make_rinit(&msg, total_cpus, ports);
+	ret = make_rinit(&msg, msg_handle->cpu_count, ports);
 	if (ret < 0)
 		return ret;
 
-- 
2.13.2
