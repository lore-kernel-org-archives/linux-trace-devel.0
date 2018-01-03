Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751219AbeACRxj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:39 -0500
Message-Id: <20180103175338.252565708@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 24/38] trace-cmd msg: Add debug prints of messages sent and received
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0024-trace-cmd-msg-Add-debug-prints-of-messages-sent-and-.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When debug is enabled, show send and recevied messages of trace-cmd listen
and record as they communicate with each other.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/trace-msg.c b/trace-msg.c
index 4c564eb28f31..94004f4641be 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -29,6 +29,7 @@
 #include <stddef.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdarg.h>
 #include <unistd.h>
 #include <arpa/inet.h>
 #include <sys/types.h>
@@ -41,6 +42,18 @@
 typedef __u32 u32;
 typedef __be32 be32;
 
+static inline void dprint(const char *fmt, ...)
+{
+	va_list ap;
+
+	if (!debug)
+		return;
+
+	va_start(ap, fmt);
+	vprintf(fmt, ap);
+	va_end(ap);
+}
+
 /* Two (4k) pages is the max transfer for now */
 #define MSG_MAX_LEN			8192
 
@@ -119,6 +132,18 @@ enum tracecmd_msg_cmd {
 
 static be32 msg_min_sizes[] = { MSG_MAP };
 
+#undef C
+#define C(a,b,c)	#a
+
+static const char *msg_names[] = { MSG_MAP };
+
+static const char *cmd_to_name(int cmd)
+{
+	if (cmd <= MSG_FINMETA)
+		return msg_names[cmd];
+	return "Unkown";
+}
+
 struct tracecmd_msg {
 	struct tracecmd_msg_header		hdr;
 	union {
@@ -144,6 +169,8 @@ static int msg_write(int fd, struct tracecmd_msg *msg)
 	if (cmd > MSG_FINMETA)
 		return -EINVAL;
 
+	dprint("msg send: %d (%s)\n", cmd, cmd_to_name(cmd));
+
 	size = msg_min_sizes[cmd];
 	if (!size)
 		size = ntohl(msg->hdr.size);
@@ -309,6 +336,9 @@ static int tracecmd_msg_recv(int fd, struct tracecmd_msg *msg)
 	if (ret < 0)
 		return ret;
 
+	dprint("msg received: %d (%s)\n",
+	       ntohl(msg->hdr.cmd), cmd_to_name(ntohl(msg->hdr.cmd)));
+
 	size = ntohl(msg->hdr.size);
 	if (size > MSG_MAX_LEN)
 		/* too big */
-- 
2.13.2
