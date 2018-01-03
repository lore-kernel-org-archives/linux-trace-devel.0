Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751241AbeACRxk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:40 -0500
Message-Id: <20180103175339.488423180@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 32/38] tracecmd listen: Have pagesize passed as return not parameter
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0032-tracecmd-listen-Have-pagesize-passed-as-return-not-p.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Return pagesize as the return function and not as a pointer that is passed
by reference. This will simplify the modification of the process_client()
code to let the listener do a handshake before forking.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-cmd.h    |  3 +--
 trace-listen.c | 23 +++++++++++++----------
 trace-msg.c    | 12 ++++++------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/trace-cmd.h b/trace-cmd.h
index 1204bb307431..ca030fc0df01 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -335,8 +335,7 @@ int tracecmd_msg_finish_sending_metadata(struct tracecmd_msg_handle *msg_handle)
 void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
 
 /* for server */
-int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle,
-				 int *pagesize);
+int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
 				 int *ports);
 int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int ofd);
diff --git a/trace-listen.c b/trace-listen.c
index c7c0afc5bbee..52021af9e574 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -372,12 +372,12 @@ static int open_udp(const char *node, const char *port, int *pid,
 	return num_port;
 }
 
-static int communicate_with_client(struct tracecmd_msg_handle *msg_handle,
-				   int *pagesize)
+static int communicate_with_client(struct tracecmd_msg_handle *msg_handle)
 {
 	char *last_proto = NULL;
 	char buf[BUFSIZ];
 	char *option;
+	int pagesize = 0;
 	int options;
 	int size;
 	int cpus;
@@ -438,7 +438,7 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle,
 		msg_handle->version = V2_PROTOCOL;
 
 		/* read the CPU count, the page size, and options */
-		if (tracecmd_msg_initial_setting(msg_handle, pagesize) < 0)
+		if ((pagesize = tracecmd_msg_initial_setting(msg_handle)) < 0)
 			goto out;
 	} else {
 		/* The client is using the v1 protocol */
@@ -455,10 +455,10 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle,
 			/** ERROR **/
 			goto out;
 
-		*pagesize = atoi(buf);
+		pagesize = atoi(buf);
 
-		plog("pagesize=%d\n", *pagesize);
-		if (*pagesize <= 0)
+		plog("pagesize=%d\n", pagesize);
+		if (pagesize <= 0)
 			goto out;
 
 		/* Now the number of options */
@@ -508,7 +508,7 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle,
 	if (msg_handle->flags & TRACECMD_MSG_FL_USE_TCP)
 		plog("Using TCP for live connection\n");
 
-	ret = 0;
+	ret = pagesize;
  out:
 	free(last_proto);
 
@@ -558,6 +558,9 @@ static int *create_all_readers(const char *node, const char *port,
 	int cpu;
 	int pid;
 
+	if (!pagesize)
+		return NULL;
+
 	port_array = malloc(sizeof(int) * cpus);
 	if (!port_array)
 		return NULL;
@@ -688,9 +691,9 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
 	int ofd;
 	int ret;
 
-	ret = communicate_with_client(msg_handle, &pagesize);
-	if (ret < 0)
-		return ret;
+	pagesize = communicate_with_client(msg_handle);
+	if (pagesize < 0)
+		return pagesize;
 
 	ofd = create_client_file(node, port);
 
diff --git a/trace-msg.c b/trace-msg.c
index 55fb2e8baabb..a439c8f030a4 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -478,11 +478,11 @@ static void error_operation_for_server(struct tracecmd_msg *msg)
 
 #define MAX_OPTION_SIZE 4096
 
-int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle,
-				 int *pagesize)
+int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 {
 	struct tracecmd_msg_opt *opt;
 	struct tracecmd_msg msg;
+	int pagesize;
 	int options, i, s;
 	int cpus;
 	int ret;
@@ -512,9 +512,9 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle,
 
 	msg_handle->cpu_count = cpus;
 
-	*pagesize = ntohl(msg.tinit.page_size);
-	plog("pagesize=%d\n", *pagesize);
-	if (*pagesize <= 0) {
+	pagesize = ntohl(msg.tinit.page_size);
+	plog("pagesize=%d\n", pagesize);
+	if (pagesize <= 0) {
 		ret = -EINVAL;
 		goto error;
 	}
@@ -550,7 +550,7 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle,
 		}
 	}
 
-	return 0;
+	return pagesize;
 
 error:
 	error_operation_for_server(&msg);
-- 
2.13.2
