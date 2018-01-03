Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751181AbeACRxi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:38 -0500
Message-Id: <20180103175337.131092115@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 16/38] trace-cmd: Remove mulitplexer tracecmd_msg_create()
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0016-trace-cmd-Remove-mulitplexer-tracecmd_msg_create.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The multiplexer function tracecmd_msg_create() was confusing, as it required
all creation of messages to go through it, instead of being created where
they are used. By removing this function and creating each msg where they
are used, it will allow the msg protocol to scale.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 46 +++++++---------------------------------------
 1 file changed, 7 insertions(+), 39 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index 5c55eae8f4b3..69d1cd19f0ac 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -226,31 +226,6 @@ static void tracecmd_msg_init(u32 cmd, struct tracecmd_msg *msg)
 	msg->hdr.size = htonl(MSG_HDR_LEN);
 }
 
-static int tracecmd_msg_create(u32 cmd, struct tracecmd_msg *msg)
-{
-	int ret = 0;
-
-	if (cmd > MSG_FINMETA) {
-		plog("Unsupported command: %d\n", cmd);
-		return -EINVAL;
-	}
-
-	tracecmd_msg_init(cmd, msg);
-
-	switch (cmd) {
-	case MSG_TINIT:
-		return make_tinit(msg);
-	case MSG_RINIT:
-		return make_rinit(msg);
-	case MSG_CLOSE:
-	case MSG_SENDMETA: /* meta data is not stored here. */
-	case MSG_FINMETA:
-		break;
-	}
-
-	return ret;
-}
-
 static void msg_free(struct tracecmd_msg *msg)
 {
 	int cmd = ntohl(msg->hdr.cmd);
@@ -425,7 +400,8 @@ int tracecmd_msg_send_init_data(int fd)
 	int i, cpus;
 	int ret;
 
-	ret = tracecmd_msg_create(MSG_TINIT, &send_msg);
+	tracecmd_msg_init(MSG_TINIT, &send_msg);
+	ret = make_tinit(&send_msg);
 	if (ret < 0)
 		return ret;
 
@@ -552,7 +528,8 @@ int tracecmd_msg_send_port_array(int fd, int total_cpus, int *ports)
 	cpu_count = total_cpus;
 	port_array = ports;
 
-	ret = tracecmd_msg_create(MSG_RINIT, &msg);
+	tracecmd_msg_init(MSG_RINIT, &msg);
+	ret = make_rinit(&msg);
 	if (ret < 0)
 		return ret;
 
@@ -566,12 +543,8 @@ int tracecmd_msg_send_port_array(int fd, int total_cpus, int *ports)
 void tracecmd_msg_send_close_msg(void)
 {
 	struct tracecmd_msg msg;
-	int ret;
-
-	ret = tracecmd_msg_create(MSG_CLOSE, &msg);
-	if (ret < 0)
-		return;
 
+	tracecmd_msg_init(MSG_CLOSE, &msg);
 	tracecmd_msg_send(psfd, &msg);
 }
 
@@ -582,9 +555,7 @@ int tracecmd_msg_metadata_send(int fd, const char *buf, int size)
 	int ret;
 	int count = 0;
 
-	ret = tracecmd_msg_create(MSG_SENDMETA, &msg);
-	if (ret < 0)
-		return ret;
+	tracecmd_msg_init(MSG_SENDMETA, &msg);
 
 	msg.buf = malloc(MSG_META_MAX_LEN);
 	if (!msg.buf)
@@ -619,10 +590,7 @@ int tracecmd_msg_finish_sending_metadata(int fd)
 	struct tracecmd_msg msg;
 	int ret;
 
-	ret = tracecmd_msg_create(MSG_FINMETA, &msg);
-	if (ret < 0)
-		return ret;
-
+	tracecmd_msg_init(MSG_FINMETA, &msg);
 	ret = tracecmd_msg_send(fd, &msg);
 	if (ret < 0)
 		return ret;
-- 
2.13.2
