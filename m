Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751096AbeACRxh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:37 -0500
Message-Id: <20180103175335.611564144@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 06/38] trace-cmd: Move tracecmd_msg_send_and_wait_for_msg() into its only
 user
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0006-trace-cmd-Move-tracecmd_msg_send_and_wait_for_msg-in.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

tracecmd_msg_send_and_wait_for_msg() is a static function that is only used
once. Since multiplexing the send code is complex and really each msg type
should be processed at where it is used instead of a multiplexer, open code
this send function in its only user.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index df45526600c5..4d462f999a4d 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -421,41 +421,29 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg *msg)
 	return 0;
 }
 
-static int tracecmd_msg_send_and_wait_for_msg(int fd, u32 cmd,
-					      struct tracecmd_msg *recv_msg)
+int tracecmd_msg_send_init_data(int fd)
 {
-	struct tracecmd_msg msg;
+	struct tracecmd_msg send_msg;
+	struct tracecmd_msg recv_msg;
+	int i, cpus;
 	int ret;
 
-	ret = tracecmd_msg_create(cmd, &msg);
-	if (ret < 0)
-		return ret;
-
-	ret = tracecmd_msg_send(fd, &msg);
+	ret = tracecmd_msg_create(MSG_TINIT, &send_msg);
 	if (ret < 0)
 		return ret;
 
-	ret = tracecmd_msg_wait_for_msg(fd, recv_msg);
+	ret = tracecmd_msg_send(fd, &send_msg);
 	if (ret < 0)
 		return ret;
 
-	return 0;
-}
-
-int tracecmd_msg_send_init_data(int fd)
-{
-	struct tracecmd_msg msg;
-	int i, cpus;
-	int ret;
-
-	ret = tracecmd_msg_send_and_wait_for_msg(fd, MSG_TINIT, &msg);
+	ret = tracecmd_msg_wait_for_msg(fd, &recv_msg);
 	if (ret < 0)
 		return ret;
 
-	cpus = ntohl(msg.data.rinit.cpus);
+	cpus = ntohl(recv_msg.data.rinit.cpus);
 	client_ports = malloc_or_die(sizeof(int) * cpus);
 	for (i = 0; i < cpus; i++)
-		client_ports[i] = ntohl(msg.data.rinit.port_array[i]);
+		client_ports[i] = ntohl(recv_msg.data.rinit.port_array[i]);
 
 	/* Next, send meta data */
 	send_metadata = true;
-- 
2.13.2
