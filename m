Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751048AbeACRxh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:37 -0500
Message-Id: <20180103175335.917290427@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 08/38] trace-cmd: Remove unused structure tracecmd_msg_error
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0008-trace-cmd-Remove-unused-structure-tracecmd_msg_error.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The structure tracecmd_msg_error is not used, remove it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index 5e941ed9829e..09202d930ace 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -97,16 +97,6 @@ struct tracecmd_msg_meta {
 	void *buf;
 } __attribute__((packed));
 
-struct tracecmd_msg_error {
-	be32 size;
-	be32 cmd;
-	union {
-		struct tracecmd_msg_tinit tinit;
-		struct tracecmd_msg_rinit rinit;
-		struct tracecmd_msg_meta meta;
-	} data;
-} __attribute__((packed));
-
 enum tracecmd_msg_cmd {
 	MSG_CLOSE	= 1,
 	MSG_TINIT	= 4,
@@ -122,7 +112,6 @@ struct tracecmd_msg {
 		struct tracecmd_msg_tinit tinit;
 		struct tracecmd_msg_rinit rinit;
 		struct tracecmd_msg_meta meta;
-		struct tracecmd_msg_error err;
 	};
 } __attribute__((packed));
 
-- 
2.13.2
