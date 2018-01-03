Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbeACRxi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:38 -0500
Message-Id: <20180103175336.700364408@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 13/38] trace-cmd: Merge msg_do_write_check() into msg_write()
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0013-trace-cmd-Merge-msg_do_write_check-into-msg_write.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

msg_do_write_check() is the only caller of msg_write(). They are small
enough not to be two separate functions. As msg_write() is a easier name,
merge msg_do_write_check() into msg_write() and have all the callers of
msg_do_write_check() call msg_write() instead.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index 2583660a7496..943eaa5bf15c 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -139,23 +139,11 @@ struct tracecmd_msg {
 
 struct tracecmd_msg *errmsg;
 
-static int msg_write(int fd, struct tracecmd_msg *msg, int size)
-{
-	int ret;
-
-	ret = __do_write_check(fd, msg, size);
-	if (ret < 0)
-		return ret;
-	if (ntohl(msg->hdr.size) <= size)
-		return 0;
-	return __do_write_check(fd, msg->buf, ntohl(msg->hdr.size) - size);
-}
-
-static ssize_t msg_do_write_check(int fd, struct tracecmd_msg *msg)
+static int msg_write(int fd, struct tracecmd_msg *msg)
 {
+	int cmd = ntohl(msg->hdr.cmd);
 	int size;
 	int ret;
-	int cmd = ntohl(msg->hdr.cmd);
 
 	if (cmd > MSG_FINMETA)
 		return -EINVAL;
@@ -164,9 +152,12 @@ static ssize_t msg_do_write_check(int fd, struct tracecmd_msg *msg)
 	if (!size)
 		size = ntohl(msg->hdr.size);
 
-	ret = msg_write(fd, msg, size);
-
-	return ret;
+	ret = __do_write_check(fd, msg, size);
+	if (ret < 0)
+		return ret;
+	if (ntohl(msg->hdr.size) <= size)
+		return 0;
+	return __do_write_check(fd, msg->buf, ntohl(msg->hdr.size) - size);
 }
 
 enum msg_opt_command {
@@ -275,7 +266,7 @@ static int tracecmd_msg_send(int fd, struct tracecmd_msg *msg)
 {
 	int ret = 0;
 
-	ret = msg_do_write_check(fd, msg);
+	ret = msg_write(fd, msg);
 	if (ret < 0)
 		ret = -ECOMM;
 
@@ -616,7 +607,7 @@ int tracecmd_msg_metadata_send(int fd, const char *buf, int size)
 			memcpy(msg.buf, buf+count, n);
 			n = 0;
 		}
-		ret = msg_do_write_check(fd, &msg);
+		ret = msg_write(fd, &msg);
 		if (ret < 0)
 			break;
 	} while (n);
-- 
2.13.2
