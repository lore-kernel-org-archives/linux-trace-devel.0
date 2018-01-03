Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751048AbeACRxj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:39 -0500
Message-Id: <20180103175338.406336678@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 25/38] trace-cmd msg: Move the saved closing fd to the caller
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0025-trace-cmd-msg-Move-the-saved-closing-fd-to-the-calle.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of having a static variable that gets set to whatever file
descriptor is passed to tracecmd_msg_finish_sending_metadata() to be closed
with tracecmd_send_close_msg(), have that saved by the caller. As I can
imagine lots of nasty bugs happening later on with this side effect fd
saving. If the caller controls what file descriptor gets closed, it will be
more transparent for later development.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-cmd.h    | 2 +-
 trace-msg.c    | 8 ++------
 trace-record.c | 7 +++++--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/trace-cmd.h b/trace-cmd.h
index 635b5a58dfe9..7e182779e78b 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -300,7 +300,7 @@ void tracecmd_enable_tracing(void);
 int tracecmd_msg_send_init_data(int fd, int total_cpus, int **client_ports);
 int tracecmd_msg_metadata_send(int fd, const char *buf, int size);
 int tracecmd_msg_finish_sending_metadata(int fd);
-void tracecmd_msg_send_close_msg(void);
+void tracecmd_msg_send_close_msg(int fd);
 
 /* for server */
 int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize);
diff --git a/trace-msg.c b/trace-msg.c
index 94004f4641be..aaeec06b82e3 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -79,7 +79,6 @@ static inline void dprint(const char *fmt, ...)
 bool use_tcp;
 
 /* for client */
-static int psfd;
 unsigned int page_size;
 
 /* for server */
@@ -545,12 +544,12 @@ int tracecmd_msg_send_port_array(int fd, int total_cpus, int *ports)
 	return 0;
 }
 
-void tracecmd_msg_send_close_msg(void)
+void tracecmd_msg_send_close_msg(int fd)
 {
 	struct tracecmd_msg msg;
 
 	tracecmd_msg_init(MSG_CLOSE, &msg);
-	tracecmd_msg_send(psfd, &msg);
+	tracecmd_msg_send(fd, &msg);
 }
 
 int tracecmd_msg_metadata_send(int fd, const char *buf, int size)
@@ -599,9 +598,6 @@ int tracecmd_msg_finish_sending_metadata(int fd)
 	ret = tracecmd_msg_send(fd, &msg);
 	if (ret < 0)
 		return ret;
-
-	/* psfd will be used for closing */
-	psfd = fd;
 	return 0;
 }
 
diff --git a/trace-record.c b/trace-record.c
index 6b8bb89e4e0d..e9e2976f1a94 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -90,6 +90,7 @@ static int clear_function_filters;
 static char *host;
 static int *client_ports;
 static int sfd;
+static int psfd;
 static struct tracecmd_output *network_handle;
 
 /* Max size to let a per cpu file get */
@@ -2870,8 +2871,10 @@ again:
 	network_handle = tracecmd_create_init_fd_glob(sfd, listed_events,
 						      proto_ver == V2_PROTOCOL);
 
-	if (proto_ver == V2_PROTOCOL)
+	if (proto_ver == V2_PROTOCOL) {
+		psfd = sfd; /* used for closing */
 		tracecmd_msg_finish_sending_metadata(sfd);
+	}
 
 	/* OK, we are all set, let'r rip! */
 }
@@ -2879,7 +2882,7 @@ again:
 static void finish_network(void)
 {
 	if (proto_ver == V2_PROTOCOL)
-		tracecmd_msg_send_close_msg();
+		tracecmd_msg_send_close_msg(psfd);
 	close(sfd);
 	free(host);
 }
-- 
2.13.2
