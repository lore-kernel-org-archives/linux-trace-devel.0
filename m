Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751024AbeACRxi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:38 -0500
Message-Id: <20180103175336.845166833@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 14/38] trace-cmd: Simplify msg_free() by using min sizes
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0014-trace-cmd-Simplify-msg_free-by-using-min-sizes.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

msg_free() only needs to free the extra data pointer if the min_size for the
command is something greater than zero.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index 943eaa5bf15c..406f44105470 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -249,17 +249,11 @@ static int tracecmd_msg_create(u32 cmd, struct tracecmd_msg *msg)
 
 static void msg_free(struct tracecmd_msg *msg)
 {
-	switch (ntohl(msg->hdr.cmd)) {
-	case MSG_TINIT:
-		free(msg->opt);
-		break;
-	case MSG_RINIT:
-		free(msg->port_array);
-		break;
-	case MSG_SENDMETA:
+	int cmd = ntohl(msg->hdr.cmd);
+
+	/* If a min size is defined, then the buf needs to be freed */
+	if (cmd < MSG_FINMETA && (msg_min_sizes[cmd] > 0))
 		free(msg->buf);
-		break;
-	}
 }
 
 static int tracecmd_msg_send(int fd, struct tracecmd_msg *msg)
-- 
2.13.2
