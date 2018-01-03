Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751131AbeACRxk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:40 -0500
Message-Id: <20180103175338.836951140@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 28/38] trace-cmd msg: Add server structure of msg_handler
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0028-trace-cmd-msg-Add-server-structure-of-msg_handler.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Have a server descriptor that is passed around. Currently, it only holds the
"done" variable to tell when the server is finished.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-cmd.h    |  2 ++
 trace-listen.c | 20 +++++++++++++++++---
 trace-msg.c    | 32 +++++++++++++++++++++++++++++---
 trace-msg.h    |  3 ---
 4 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/trace-cmd.h b/trace-cmd.h
index 0fce54baea5b..2fe4b208c561 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -336,6 +336,8 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle,
 int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
 				 int total_cpus, int *ports);
 int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int ofd);
+bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
+void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
 
 /* --- Plugin handling --- */
 extern struct pevent_plugin_option trace_ftrace_options[];
diff --git a/trace-listen.c b/trace-listen.c
index d5379b36a85e..2e17839cffec 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -55,6 +55,10 @@ static int proto_ver;
 
 static int do_daemon;
 
+/* Used for signaling INT to finish */
+static struct tracecmd_msg_handle *stop_msg_handle;
+static bool done;
+
 #define  TEMP_FILE_STR "%s.%s:%s.cpu%d", output_file, host, port, cpu
 static char *get_temp_file(const char *host, const char *port, int cpu)
 {
@@ -140,6 +144,8 @@ void tracecmd_msg_handle_close(struct tracecmd_msg_handle *msg_handle)
 
 static void finish(int sig)
 {
+	if (stop_msg_handle)
+		tracecmd_msg_set_done(stop_msg_handle);
 	done = true;
 }
 
@@ -602,10 +608,13 @@ static int *create_all_readers(int cpus, const char *node, const char *port,
 	return NULL;
 }
 
-static void collect_metadata_from_client(int ifd, int ofd)
+static void
+collect_metadata_from_client(struct tracecmd_msg_handle *msg_handle,
+			     int ofd)
 {
 	char buf[BUFSIZ];
 	int n, s, t;
+	int ifd = msg_handle->fd;
 
 	do {
 		n = read(ifd, buf, BUFSIZ);
@@ -626,7 +635,7 @@ static void collect_metadata_from_client(int ifd, int ofd)
 			t -= s;
 			s = n - t;
 		} while (t);
-	} while (n > 0 && !done);
+	} while (n > 0 && !tracecmd_msg_done(msg_handle));
 }
 
 static void stop_all_readers(int cpus, int *pid_array)
@@ -686,11 +695,16 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
 	if (!pid_array)
 		return -ENOMEM;
 
+	/* on signal stop this msg */
+	stop_msg_handle = msg_handle;
+
 	/* Now we are ready to start reading data from the client */
 	if (proto_ver == V2_PROTOCOL)
 		tracecmd_msg_collect_metadata(msg_handle, ofd);
 	else
-		collect_metadata_from_client(msg_handle->fd, ofd);
+		collect_metadata_from_client(msg_handle, ofd);
+
+	stop_msg_handle = NULL;
 
 	/* wait a little to let our readers finish reading */
 	sleep(1);
diff --git a/trace-msg.c b/trace-msg.c
index 7c93ff3b3ff3..9b01197574da 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -81,8 +81,20 @@ bool use_tcp;
 /* for client */
 unsigned int page_size;
 
-/* for server */
-bool done;
+struct tracecmd_msg_server {
+	struct tracecmd_msg_handle handle;
+	int			done;
+};
+
+static struct tracecmd_msg_server *
+make_server(struct tracecmd_msg_handle *msg_handle)
+{
+	if (!(msg_handle->flags & TRACECMD_MSG_FL_SERVER)) {
+		plog("Message handle not of type server\n");
+		return NULL;
+	}
+	return (struct tracecmd_msg_server *)msg_handle;
+}
 
 struct tracecmd_msg_opt {
 	be32 size;
@@ -357,6 +369,20 @@ error:
 #define MSG_WAIT_MSEC	5000
 static int msg_wait_to = MSG_WAIT_MSEC;
 
+bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle)
+{
+	struct tracecmd_msg_server *msg_server = make_server(msg_handle);
+
+	return (volatile int)msg_server->done;
+}
+
+void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle)
+{
+	struct tracecmd_msg_server *msg_server = make_server(msg_handle);
+
+	msg_server->done = true;
+}
+
 /*
  * A return value of 0 indicates time-out
  */
@@ -648,7 +674,7 @@ int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int of
 	} while (cmd == MSG_SENDMETA);
 
 	/* check the finish message of the client */
-	while (!done) {
+	while (!tracecmd_msg_done(msg_handle)) {
 		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
 		if (ret < 0) {
 			warning("reading client");
diff --git a/trace-msg.h b/trace-msg.h
index 7f6a146aeb10..da563ea55c85 100644
--- a/trace-msg.h
+++ b/trace-msg.h
@@ -16,9 +16,6 @@ extern bool use_tcp;
 /* for client */
 extern unsigned int page_size;
 
-/* for server */
-extern bool done;
-
 void plog(const char *fmt, ...);
 void pdie(const char *fmt, ...);
 
-- 
2.13.2
