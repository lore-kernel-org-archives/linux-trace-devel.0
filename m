Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751131AbeACRxh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:37 -0500
Message-Id: <20180103175336.060949341@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 09/38] trace-cmd: Move size and cmd in tracecmd_msg into its own header
 struct
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0009-trace-cmd-Move-size-and-cmd-in-tracecmd_msg-into-its.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Move the size and cmd fields of the structure tracecmd_msg into its own
header. This will allow us to remove the individual pointers that exist in
the anonymous union of the tracecmd_msg structure into their own union. But
that will require the individual msg types size defines changing. That
change will be simplified if the header is separate.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 63 ++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index 09202d930ace..2e4a9bfb1d64 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -44,8 +44,7 @@ typedef __be32 be32;
 /* Two (4k) pages is the max transfer for now */
 #define MSG_MAX_LEN			8192
 
-					/* size + cmd */
-#define MSG_HDR_LEN			((sizeof(be32)) + (sizeof(be32)))
+#define MSG_HDR_LEN			sizeof(struct tracecmd_msg_header)
 
 #define MSG_DATA_LEN			(MSG_MAX_LEN - MSG_HDR_LEN)
 
@@ -105,13 +104,17 @@ enum tracecmd_msg_cmd {
 	MSG_FINMETA	= 7,
 };
 
+struct tracecmd_msg_header {
+	be32	size;
+	be32	cmd;
+} __attribute__((packed));
+
 struct tracecmd_msg {
-	be32 size;
-	be32 cmd;
+	struct tracecmd_msg_header		hdr;
 	union {
-		struct tracecmd_msg_tinit tinit;
-		struct tracecmd_msg_rinit rinit;
-		struct tracecmd_msg_meta meta;
+		struct tracecmd_msg_tinit	tinit;
+		struct tracecmd_msg_rinit	rinit;
+		struct tracecmd_msg_meta	meta;
 	};
 } __attribute__((packed));
 
@@ -124,16 +127,16 @@ static int msg_write(int fd, struct tracecmd_msg *msg, int size, void *addr)
 	ret = __do_write_check(fd, msg, size);
 	if (ret < 0)
 		return ret;
-	if (ntohl(msg->size) <= size)
+	if (ntohl(msg->hdr.size) <= size)
 		return 0;
-	return __do_write_check(fd, addr, ntohl(msg->size) - size);
+	return __do_write_check(fd, addr, ntohl(msg->hdr.size) - size);
 }
 
 static ssize_t msg_do_write_check(int fd, struct tracecmd_msg *msg)
 {
 	int ret;
 
-	switch (ntohl(msg->cmd)) {
+	switch (ntohl(msg->hdr.cmd)) {
 	case MSG_TINIT:
 		ret = msg_write(fd, msg, MIN_TINIT_SIZE, msg->tinit.opt);
 		break;
@@ -144,7 +147,7 @@ static ssize_t msg_do_write_check(int fd, struct tracecmd_msg *msg)
 		ret = msg_write(fd, msg, MIN_META_SIZE, msg->meta.buf);
 		break;
 	default:
-		ret = __do_write_check(fd, msg, ntohl(msg->size));
+		ret = __do_write_check(fd, msg, ntohl(msg->hdr.size));
 	}
 
 	return ret;
@@ -175,7 +178,7 @@ static int make_tinit(struct tracecmd_msg *msg)
 	msg->tinit.page_size = htonl(page_size);
 	msg->tinit.opt_num = htonl(opt_num);
 
-	msg->size = htonl(size);
+	msg->hdr.size = htonl(size);
 
 	return 0;
 }
@@ -204,7 +207,7 @@ static int make_rinit(struct tracecmd_msg *msg)
 		ptr++;
 	}
 
-	msg->size = htonl(size);
+	msg->hdr.size = htonl(size);
 
 	return 0;
 }
@@ -219,7 +222,7 @@ static int tracecmd_msg_create(u32 cmd, struct tracecmd_msg *msg)
 	}
 
 	memset(msg, 0, sizeof(*msg));
-	msg->cmd = htonl(cmd);
+	msg->hdr.cmd = htonl(cmd);
 
 	switch (cmd) {
 	case MSG_TINIT:
@@ -232,14 +235,14 @@ static int tracecmd_msg_create(u32 cmd, struct tracecmd_msg *msg)
 		break;
 	}
 
-	msg->size = htonl(MSG_HDR_LEN);
+	msg->hdr.size = htonl(MSG_HDR_LEN);
 
 	return ret;
 }
 
 static void msg_free(struct tracecmd_msg *msg)
 {
-	switch (ntohl(msg->cmd)) {
+	switch (ntohl(msg->hdr.cmd)) {
 	case MSG_TINIT:
 		free(msg->tinit.opt);
 		break;
@@ -306,11 +309,11 @@ static int msg_read_extra(int fd, void *buf, int *n,
 
 static int tracecmd_msg_read_extra(int fd, struct tracecmd_msg *msg, int *n)
 {
-	int size = ntohl(msg->size);
+	int size = ntohl(msg->hdr.size);
 	int rsize;
 	int ret;
 
-	switch (ntohl(msg->cmd)) {
+	switch (ntohl(msg->hdr.cmd)) {
 	case MSG_TINIT:
 		msg->tinit.opt = NULL;
 
@@ -353,7 +356,7 @@ static int tracecmd_msg_recv(int fd, struct tracecmd_msg *msg)
 	if (ret < 0)
 		return ret;
 
-	size = ntohl(msg->size);
+	size = ntohl(msg->hdr.size);
 	if (size > MSG_MAX_LEN)
 		/* too big */
 		goto error;
@@ -403,7 +406,7 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg *msg)
 		return ret;
 	}
 
-	cmd = ntohl(msg->cmd);
+	cmd = ntohl(msg->hdr.cmd);
 	if (cmd == MSG_CLOSE)
 		return -ECONNABORTED;
 
@@ -454,9 +457,9 @@ static void error_operation_for_server(struct tracecmd_msg *msg)
 {
 	u32 cmd;
 
-	cmd = ntohl(msg->cmd);
+	cmd = ntohl(msg->hdr.cmd);
 
-	warning("Message: cmd=%d size=%d\n", cmd, ntohl(msg->size));
+	warning("Message: cmd=%d size=%d\n", cmd, ntohl(msg->hdr.size));
 }
 
 #define MAX_OPTION_SIZE 4096
@@ -478,7 +481,7 @@ int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize)
 		return ret;
 	}
 
-	cmd = ntohl(msg.cmd);
+	cmd = ntohl(msg.hdr.cmd);
 	if (cmd != MSG_TINIT) {
 		ret = -EINVAL;
 		goto error;
@@ -500,7 +503,7 @@ int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize)
 
 	options = ntohl(msg.tinit.opt_num);
 	for (i = 0; i < options; i++) {
-		if (size + sizeof(*opt) > ntohl(msg.size)) {
+		if (size + sizeof(*opt) > ntohl(msg.hdr.size)) {
 			plog("Not enough message for options\n");
 			ret = -EINVAL;
 			goto error;
@@ -508,7 +511,7 @@ int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize)
 		opt = (void *)msg.tinit.opt + offset;
 		offset += ntohl(opt->size);
 		size += ntohl(opt->size);
-		if (ntohl(msg.size) < size) {
+		if (ntohl(msg.hdr.size) < size) {
 			plog("Not enough message for options\n");
 			ret = -EINVAL;
 			goto error;
@@ -583,7 +586,7 @@ int tracecmd_msg_metadata_send(int fd, const char *buf, int size)
 		return -ENOMEM;
 
 	msg.meta.size = htonl(MSG_META_MAX_LEN);
-	msg.size = htonl(MIN_META_SIZE + MSG_META_MAX_LEN);
+	msg.hdr.size = htonl(MIN_META_SIZE + MSG_META_MAX_LEN);
 
 	n = size;
 	do {
@@ -592,7 +595,7 @@ int tracecmd_msg_metadata_send(int fd, const char *buf, int size)
 			n -= MSG_META_MAX_LEN;
 			count += MSG_META_MAX_LEN;
 		} else {
-			msg.size = htonl(MIN_META_SIZE + n);
+			msg.hdr.size = htonl(MIN_META_SIZE + n);
 			msg.meta.size = htonl(n);
 			memcpy(msg.meta.buf, buf+count, n);
 			n = 0;
@@ -641,7 +644,7 @@ int tracecmd_msg_collect_metadata(int ifd, int ofd)
 			return ret;
 		}
 
-		cmd = ntohl(msg.cmd);
+		cmd = ntohl(msg.hdr.cmd);
 		if (cmd == MSG_FINMETA) {
 			/* Finish receiving meta data */
 			break;
@@ -672,12 +675,12 @@ int tracecmd_msg_collect_metadata(int ifd, int ofd)
 			return ret;
 		}
 
-		cmd = ntohl(msg.cmd);
+		cmd = ntohl(msg.hdr.cmd);
 		if (cmd == MSG_CLOSE)
 			/* Finish this connection */
 			break;
 		else {
-			warning("Not accept the message %d", ntohl(msg.cmd));
+			warning("Not accept the message %d", ntohl(msg.hdr.cmd));
 			ret = -EINVAL;
 			goto error;
 		}
-- 
2.13.2
