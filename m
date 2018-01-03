Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751040AbeACRxi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:38 -0500
Message-Id: <20180103175337.273434016@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 17/38] trace-cmd: Simplify msg_read_extra()
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0017-trace-cmd-Simplify-msg_read_extra.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

With the extra data pointers all in the same location in tracecmd_msg
structure, and with the min_size command mapping, there's no reason to
multiplex the receiving of messages. Read the header first, then determine
by the cmd the min size to read. If more is needed, then allocate to the
generic buffer which will fill in all the other pointers.

This allows us to remove tracecmd_msg_read_extra() and use just
msg_read_extra() in its stead.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 67 +++++++++++++++++++------------------------------------------
 1 file changed, 21 insertions(+), 46 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index 69d1cd19f0ac..ff89c4478f6f 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -267,60 +267,35 @@ static int msg_read(int fd, void *buf, u32 size, int *n)
 	return 0;
 }
 
-static int msg_read_extra(int fd, void *buf, int *n,
-			  int size, int min_size, void **addr)
+static int msg_read_extra(int fd, struct tracecmd_msg *msg,
+			  int *n, int size)
 {
+	u32 cmd;
 	int rsize;
 	int ret;
 
-	rsize = min_size - *n;
-	ret = msg_read(fd, buf, rsize, n);
-	if (ret < 0)
-		return ret;
-	size -= *n;
-	if (size < 0)
-		return -ENOMSG;
-	*addr = malloc(size);
-	if (!*addr)
-		return -ENOMEM;
-	*n = 0;
-	return msg_read(fd, *addr, size, n);
-}
-
-static int tracecmd_msg_read_extra(int fd, struct tracecmd_msg *msg, int *n)
-{
-	int size = ntohl(msg->hdr.size);
-	int rsize;
-	int ret;
-
-	switch (ntohl(msg->hdr.cmd)) {
-	case MSG_TINIT:
-		msg->opt = NULL;
+	cmd = ntohl(msg->hdr.cmd);
+	if (cmd > MSG_FINMETA)
+		return -EINVAL;
 
-		rsize = MIN_TINIT_SIZE - *n;
+	rsize = msg_min_sizes[cmd] - *n;
+	if (rsize <= 0)
+		return 0;
 
-		ret = msg_read(fd, msg, rsize, n);
-		if (ret < 0)
-			return ret;
+	ret = msg_read(fd, msg, rsize, n);
+	if (ret < 0)
+		return ret;
 
-		if (size > *n) {
-			size -= *n;
-			msg->opt = malloc(size);
-			if (!msg->opt)
-				return -ENOMEM;
-			*n = 0;
-			return msg_read(fd, msg->opt, size, n);
-		}
-		return 0;
-	case MSG_RINIT:
-		return msg_read_extra(fd, msg, n, size, MIN_RINIT_SIZE,
-				      (void **)&msg->port_array);
-	case MSG_SENDMETA:
-		return msg_read_extra(fd, msg, n, size, MIN_META_SIZE,
-				      (void **)&msg->buf);
+	if (size > *n) {
+		size -= *n;
+		msg->buf = malloc(size);
+		if (!msg->buf)
+			return -ENOMEM;
+		*n = 0;
+		return msg_read(fd, msg->buf, size, n);
 	}
 
-	return msg_read(fd, msg, size - MSG_HDR_LEN, n);
+	return 0;
 }
 
 /*
@@ -344,7 +319,7 @@ static int tracecmd_msg_recv(int fd, struct tracecmd_msg *msg)
 		/* too small */
 		goto error;
 	else if (size > MSG_HDR_LEN)
-		return tracecmd_msg_read_extra(fd, msg, &n);
+		return msg_read_extra(fd, msg, &n, size);
 
 	return 0;
 error:
-- 
2.13.2
