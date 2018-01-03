Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbeACRxh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:37 -0500
Message-Id: <20180103175336.568757781@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 12/38] trace-cmd: Use an array to map msg types and min sizes
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0012-trace-cmd-Use-an-array-to-map-msg-types-and-min-size.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of using a switch statement, use an array to map the msg types to
the min sizes they have. If they do not have dynamically allocated data to
send, the size is simply zero, and the msg->size is used.

This incorporates a macro tuple to map the types and sizes, and will be
extended in the future for anything else that needs to be done.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 53 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index b265947027ce..2583660a7496 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -96,19 +96,33 @@ struct tracecmd_msg_meta {
 	be32 size;
 } __attribute__((packed));
 
-enum tracecmd_msg_cmd {
-	MSG_CLOSE	= 1,
-	MSG_TINIT	= 4,
-	MSG_RINIT	= 5,
-	MSG_SENDMETA	= 6,
-	MSG_FINMETA	= 7,
-};
-
 struct tracecmd_msg_header {
 	be32	size;
 	be32	cmd;
 } __attribute__((packed));
 
+#define MSG_MAP						\
+	C(UNUSED_0,	0,	-1),			\
+	C(CLOSE,	1,	0),			\
+	C(USUSED_2,	2,	-1),			\
+	C(UNUSED_3,	3,	-1),			\
+	C(TINIT,	4,	MIN_TINIT_SIZE),	\
+	C(RINIT,	5,	MIN_RINIT_SIZE),	\
+	C(SENDMETA,	6,	MIN_META_SIZE),		\
+	C(FINMETA,	7,	0),
+
+#undef C
+#define C(a,b,c)	MSG_##a = b
+
+enum tracecmd_msg_cmd {
+	MSG_MAP
+};
+
+#undef C
+#define C(a,b,c)	c
+
+static be32 msg_min_sizes[] = { MSG_MAP };
+
 struct tracecmd_msg {
 	struct tracecmd_msg_header		hdr;
 	union {
@@ -139,21 +153,18 @@ static int msg_write(int fd, struct tracecmd_msg *msg, int size)
 
 static ssize_t msg_do_write_check(int fd, struct tracecmd_msg *msg)
 {
+	int size;
 	int ret;
+	int cmd = ntohl(msg->hdr.cmd);
 
-	switch (ntohl(msg->hdr.cmd)) {
-	case MSG_TINIT:
-		ret = msg_write(fd, msg, MIN_TINIT_SIZE);
-		break;
-	case MSG_RINIT:
-		ret = msg_write(fd, msg, MIN_RINIT_SIZE);
-		break;
-	case MSG_SENDMETA:
-		ret = msg_write(fd, msg, MIN_META_SIZE);
-		break;
-	default:
-		ret = __do_write_check(fd, msg, ntohl(msg->hdr.size));
-	}
+	if (cmd > MSG_FINMETA)
+		return -EINVAL;
+
+	size = msg_min_sizes[cmd];
+	if (!size)
+		size = ntohl(msg->hdr.size);
+
+	ret = msg_write(fd, msg, size);
 
 	return ret;
 }
-- 
2.13.2
