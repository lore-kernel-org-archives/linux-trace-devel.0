Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751091AbeACRxh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:37 -0500
Message-Id: <20180103175335.474703052@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 05/38] trace-cmd: Remove the creating of msg out of tracecmd_msg_send()
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-trace-cmd-Remove-the-creating-of-msg-out-of-tracecmd.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The creation of different types is getting confusing within the
tracecmd_msg_send(). In order to split it up, we first must take the
creation of the msg out of it. This will allow us to create specific msg
types where they are used, instead of having tracecmd_msg_send() and other
functions do the multiplexing.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 56 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 19 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index a171179c3606..df45526600c5 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -224,6 +224,11 @@ static int tracecmd_msg_create(u32 cmd, struct tracecmd_msg *msg)
 {
 	int ret = 0;
 
+	if (cmd > MSG_FINMETA) {
+		plog("Unsupported command: %d\n", cmd);
+		return -EINVAL;
+	}
+
 	memset(msg, 0, sizeof(*msg));
 	msg->cmd = htonl(cmd);
 
@@ -258,25 +263,15 @@ static void msg_free(struct tracecmd_msg *msg)
 	}
 }
 
-static int tracecmd_msg_send(int fd, u32 cmd)
+static int tracecmd_msg_send(int fd, struct tracecmd_msg *msg)
 {
-	struct tracecmd_msg msg;
 	int ret = 0;
 
-	if (cmd > MSG_FINMETA) {
-		plog("Unsupported command: %d\n", cmd);
-		return -EINVAL;
-	}
-
-	ret = tracecmd_msg_create(cmd, &msg);
-	if (ret < 0)
-		return ret;
-
-	ret = msg_do_write_check(fd, &msg);
+	ret = msg_do_write_check(fd, msg);
 	if (ret < 0)
 		ret = -ECOMM;
 
-	msg_free(&msg);
+	msg_free(msg);
 
 	return ret;
 }
@@ -426,15 +421,21 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg *msg)
 	return 0;
 }
 
-static int tracecmd_msg_send_and_wait_for_msg(int fd, u32 cmd, struct tracecmd_msg *msg)
+static int tracecmd_msg_send_and_wait_for_msg(int fd, u32 cmd,
+					      struct tracecmd_msg *recv_msg)
 {
+	struct tracecmd_msg msg;
 	int ret;
 
-	ret = tracecmd_msg_send(fd, cmd);
+	ret = tracecmd_msg_create(cmd, &msg);
 	if (ret < 0)
 		return ret;
 
-	ret = tracecmd_msg_wait_for_msg(fd, msg);
+	ret = tracecmd_msg_send(fd, &msg);
+	if (ret < 0)
+		return ret;
+
+	ret = tracecmd_msg_wait_for_msg(fd, recv_msg);
 	if (ret < 0)
 		return ret;
 
@@ -560,12 +561,17 @@ error:
 
 int tracecmd_msg_send_port_array(int fd, int total_cpus, int *ports)
 {
+	struct tracecmd_msg msg;
 	int ret;
 
 	cpu_count = total_cpus;
 	port_array = ports;
 
-	ret = tracecmd_msg_send(fd, MSG_RINIT);
+	ret = tracecmd_msg_create(MSG_RINIT, &msg);
+	if (ret < 0)
+		return ret;
+
+	ret = tracecmd_msg_send(fd, &msg);
 	if (ret < 0)
 		return ret;
 
@@ -574,7 +580,14 @@ int tracecmd_msg_send_port_array(int fd, int total_cpus, int *ports)
 
 void tracecmd_msg_send_close_msg(void)
 {
-	tracecmd_msg_send(psfd, MSG_CLOSE);
+	struct tracecmd_msg msg;
+	int ret;
+
+	ret = tracecmd_msg_create(MSG_CLOSE, &msg);
+	if (ret < 0)
+		return;
+
+	tracecmd_msg_send(psfd, &msg);
 }
 
 int tracecmd_msg_metadata_send(int fd, const char *buf, int size)
@@ -618,9 +631,14 @@ int tracecmd_msg_metadata_send(int fd, const char *buf, int size)
 
 int tracecmd_msg_finish_sending_metadata(int fd)
 {
+	struct tracecmd_msg msg;
 	int ret;
 
-	ret = tracecmd_msg_send(fd, MSG_FINMETA);
+	ret = tracecmd_msg_create(MSG_FINMETA, &msg);
+	if (ret < 0)
+		return ret;
+
+	ret = tracecmd_msg_send(fd, &msg);
 	if (ret < 0)
 		return ret;
 
-- 
2.13.2
