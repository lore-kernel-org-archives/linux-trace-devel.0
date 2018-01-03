Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751160AbeACRxi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:38 -0500
Message-Id: <20180103175336.982581934@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 15/38] trace-cmd: Add tracecmd_msg_init() helper function
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0015-trace-cmd-Add-tracecmd_msg_init-helper-function.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

We will eventually be getting rid of tracecmd_msg_create() multiplexer and
having separate functions for creating different msg types. This will
require having a generic tracecmd_msg_init() to initialize the msg to a
default state.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index 406f44105470..5c55eae8f4b3 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -219,6 +219,13 @@ static int make_rinit(struct tracecmd_msg *msg)
 	return 0;
 }
 
+static void tracecmd_msg_init(u32 cmd, struct tracecmd_msg *msg)
+{
+	memset(msg, 0, sizeof(*msg));
+	msg->hdr.cmd = htonl(cmd);
+	msg->hdr.size = htonl(MSG_HDR_LEN);
+}
+
 static int tracecmd_msg_create(u32 cmd, struct tracecmd_msg *msg)
 {
 	int ret = 0;
@@ -228,8 +235,7 @@ static int tracecmd_msg_create(u32 cmd, struct tracecmd_msg *msg)
 		return -EINVAL;
 	}
 
-	memset(msg, 0, sizeof(*msg));
-	msg->hdr.cmd = htonl(cmd);
+	tracecmd_msg_init(cmd, msg);
 
 	switch (cmd) {
 	case MSG_TINIT:
@@ -242,8 +248,6 @@ static int tracecmd_msg_create(u32 cmd, struct tracecmd_msg *msg)
 		break;
 	}
 
-	msg->hdr.size = htonl(MSG_HDR_LEN);
-
 	return ret;
 }
 
-- 
2.13.2
