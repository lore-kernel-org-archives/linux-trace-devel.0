Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751185AbeACRxi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:38 -0500
Message-Id: <20180103175337.414061220@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 18/38] trace-cmd: Have msg_free() zero out msg contents
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0018-trace-cmd-Have-msg_free-zero-out-msg-contents.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When msg_free() is called, the msg contents should never be used after that.
To ensure that it does not contain residual data, have msg_free() zero out
the msg before returning.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/trace-msg.c b/trace-msg.c
index ff89c4478f6f..e1abbbb99bb4 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -233,6 +233,8 @@ static void msg_free(struct tracecmd_msg *msg)
 	/* If a min size is defined, then the buf needs to be freed */
 	if (cmd < MSG_FINMETA && (msg_min_sizes[cmd] > 0))
 		free(msg->buf);
+
+	memset(msg, 0, sizeof(*msg));
 }
 
 static int tracecmd_msg_send(int fd, struct tracecmd_msg *msg)
-- 
2.13.2
