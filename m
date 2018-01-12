Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:49926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965003AbeALSJc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 13:09:32 -0500
Message-Id: <20180112180930.472825624@goodmis.org>
Date: Fri, 12 Jan 2018 13:08:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vladislav Valtchev <vladislav.valtchev@gmail.com>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 2/3] trace-cmd msg: Set the min size of a message on init
References: <20180112180847.372748598@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-trace-cmd-msg-Set-the-min-size-of-a-message-on-init.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As there exist a map for the minimum sizes of messages, we can use that to
set up the minimum size of messages during init of the msg_handle.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 trace-msg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/trace-msg.c b/trace-msg.c
index 6f3d878a067f..8b87858f3f2b 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -255,7 +255,10 @@ static void tracecmd_msg_init(u32 cmd, struct tracecmd_msg *msg)
 {
 	memset(msg, 0, sizeof(*msg));
 	msg->hdr.cmd = htonl(cmd);
-	msg->hdr.size = htonl(MSG_HDR_LEN);
+	if (!msg_min_sizes[cmd])
+		msg->hdr.size = htonl(MSG_HDR_LEN);
+	else
+		msg->hdr.size = htonl(msg_min_sizes[cmd]);
 }
 
 static void msg_free(struct tracecmd_msg *msg)
-- 
2.13.2
