Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751037AbeACRxh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:37 -0500
Message-Id: <20180103175336.432569244@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 11/38] trace-cmd: Just use the buf field for sending pointers
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0011-trace-cmd-Just-use-the-buf-field-for-sending-pointer.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Now that all the pointers in the tracemd_msg structure are in the same
location, we can use the generic void *buf field to send out all the data in
msg_write(). No need to use different fields.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index 2e61b297151f..b265947027ce 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -125,7 +125,7 @@ struct tracecmd_msg {
 
 struct tracecmd_msg *errmsg;
 
-static int msg_write(int fd, struct tracecmd_msg *msg, int size, void *addr)
+static int msg_write(int fd, struct tracecmd_msg *msg, int size)
 {
 	int ret;
 
@@ -134,7 +134,7 @@ static int msg_write(int fd, struct tracecmd_msg *msg, int size, void *addr)
 		return ret;
 	if (ntohl(msg->hdr.size) <= size)
 		return 0;
-	return __do_write_check(fd, addr, ntohl(msg->hdr.size) - size);
+	return __do_write_check(fd, msg->buf, ntohl(msg->hdr.size) - size);
 }
 
 static ssize_t msg_do_write_check(int fd, struct tracecmd_msg *msg)
@@ -143,13 +143,13 @@ static ssize_t msg_do_write_check(int fd, struct tracecmd_msg *msg)
 
 	switch (ntohl(msg->hdr.cmd)) {
 	case MSG_TINIT:
-		ret = msg_write(fd, msg, MIN_TINIT_SIZE, msg->opt);
+		ret = msg_write(fd, msg, MIN_TINIT_SIZE);
 		break;
 	case MSG_RINIT:
-		ret = msg_write(fd, msg, MIN_RINIT_SIZE, msg->port_array);
+		ret = msg_write(fd, msg, MIN_RINIT_SIZE);
 		break;
 	case MSG_SENDMETA:
-		ret = msg_write(fd, msg, MIN_META_SIZE, msg->buf);
+		ret = msg_write(fd, msg, MIN_META_SIZE);
 		break;
 	default:
 		ret = __do_write_check(fd, msg, ntohl(msg->hdr.size));
-- 
2.13.2
