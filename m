Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbeACRxh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:37 -0500
Message-Id: <20180103175336.206860207@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 10/38] trace-cmd: Move the tracecmd_msg pointers into their own union
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0010-trace-cmd-Move-the-tracecmd_msg-pointers-into-their-.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Move out the pointers in the tracecmd_msg individual type structures into
their own union. This will simplify the msg management, as sending and
freeing the extra pointers can be done the same for all types of messages.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 63 +++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 34 insertions(+), 29 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index 2e4a9bfb1d64..2e61b297151f 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -52,12 +52,15 @@ typedef __be32 be32;
 #define MSG_META_MAX_LEN		(MSG_MAX_LEN - MIN_META_SIZE)
 
 
-#define MIN_TINIT_SIZE	offsetof(struct tracecmd_msg, tinit.opt)
+#define MIN_TINIT_SIZE	(sizeof(struct tracecmd_msg_header) + \
+			 sizeof(struct tracecmd_msg_tinit))
 
 /* Not really the minimum, but I couldn't think of a better name */
-#define MIN_RINIT_SIZE offsetof(struct tracecmd_msg, rinit.port_array)
+#define MIN_RINIT_SIZE	(sizeof(struct tracecmd_msg_header) + \
+			 sizeof(struct tracecmd_msg_rinit))
 
-#define MIN_META_SIZE 	offsetof(struct tracecmd_msg, meta.buf)
+#define MIN_META_SIZE	(sizeof(struct tracecmd_msg_header) + \
+			 sizeof(struct tracecmd_msg_meta))
 
 /* for both client and server */
 bool use_tcp;
@@ -83,17 +86,14 @@ struct tracecmd_msg_tinit {
 	be32 cpus;
 	be32 page_size;
 	be32 opt_num;
-	struct tracecmd_msg_opt *opt;
 } __attribute__((packed));
 
 struct tracecmd_msg_rinit {
 	be32 cpus;
-	be32 *port_array;
 } __attribute__((packed));
 
 struct tracecmd_msg_meta {
 	be32 size;
-	void *buf;
 } __attribute__((packed));
 
 enum tracecmd_msg_cmd {
@@ -116,6 +116,11 @@ struct tracecmd_msg {
 		struct tracecmd_msg_rinit	rinit;
 		struct tracecmd_msg_meta	meta;
 	};
+	union {
+		struct tracecmd_msg_opt		*opt;
+		be32				*port_array;
+		void				*buf;
+	};
 } __attribute__((packed));
 
 struct tracecmd_msg *errmsg;
@@ -138,13 +143,13 @@ static ssize_t msg_do_write_check(int fd, struct tracecmd_msg *msg)
 
 	switch (ntohl(msg->hdr.cmd)) {
 	case MSG_TINIT:
-		ret = msg_write(fd, msg, MIN_TINIT_SIZE, msg->tinit.opt);
+		ret = msg_write(fd, msg, MIN_TINIT_SIZE, msg->opt);
 		break;
 	case MSG_RINIT:
-		ret = msg_write(fd, msg, MIN_RINIT_SIZE, msg->rinit.port_array);
+		ret = msg_write(fd, msg, MIN_RINIT_SIZE, msg->port_array);
 		break;
 	case MSG_SENDMETA:
-		ret = msg_write(fd, msg, MIN_META_SIZE, msg->meta.buf);
+		ret = msg_write(fd, msg, MIN_META_SIZE, msg->buf);
 		break;
 	default:
 		ret = __do_write_check(fd, msg, ntohl(msg->hdr.size));
@@ -170,7 +175,7 @@ static int make_tinit(struct tracecmd_msg *msg)
 			return -ENOMEM;
 		opt->size = htonl(sizeof(*opt));
 		opt->opt_cmd = htonl(MSGOPT_USETCP);
-		msg->tinit.opt = opt;
+		msg->opt = opt;
 		size += sizeof(*opt);
 	}
 
@@ -192,13 +197,13 @@ static int make_rinit(struct tracecmd_msg *msg)
 
 	msg->rinit.cpus = htonl(cpu_count);
 
-	msg->rinit.port_array = malloc(sizeof(*port_array) * cpu_count);
-	if (!msg->rinit.port_array)
+	msg->port_array = malloc(sizeof(*port_array) * cpu_count);
+	if (!msg->port_array)
 		return -ENOMEM;
 
 	size += sizeof(*port_array) * cpu_count;
 
-	ptr = msg->rinit.port_array;
+	ptr = msg->port_array;
 
 	for (i = 0; i < cpu_count; i++) {
 		/* + rrqports->cpus or rrqports->port_array[i] */
@@ -244,13 +249,13 @@ static void msg_free(struct tracecmd_msg *msg)
 {
 	switch (ntohl(msg->hdr.cmd)) {
 	case MSG_TINIT:
-		free(msg->tinit.opt);
+		free(msg->opt);
 		break;
 	case MSG_RINIT:
-		free(msg->rinit.port_array);
+		free(msg->port_array);
 		break;
 	case MSG_SENDMETA:
-		free(msg->meta.buf);
+		free(msg->buf);
 		break;
 	}
 }
@@ -315,7 +320,7 @@ static int tracecmd_msg_read_extra(int fd, struct tracecmd_msg *msg, int *n)
 
 	switch (ntohl(msg->hdr.cmd)) {
 	case MSG_TINIT:
-		msg->tinit.opt = NULL;
+		msg->opt = NULL;
 
 		rsize = MIN_TINIT_SIZE - *n;
 
@@ -325,19 +330,19 @@ static int tracecmd_msg_read_extra(int fd, struct tracecmd_msg *msg, int *n)
 
 		if (size > *n) {
 			size -= *n;
-			msg->tinit.opt = malloc(size);
-			if (!msg->tinit.opt)
+			msg->opt = malloc(size);
+			if (!msg->opt)
 				return -ENOMEM;
 			*n = 0;
-			return msg_read(fd, msg->tinit.opt, size, n);
+			return msg_read(fd, msg->opt, size, n);
 		}
 		return 0;
 	case MSG_RINIT:
 		return msg_read_extra(fd, msg, n, size, MIN_RINIT_SIZE,
-				      (void **)&msg->rinit.port_array);
+				      (void **)&msg->port_array);
 	case MSG_SENDMETA:
 		return msg_read_extra(fd, msg, n, size, MIN_META_SIZE,
-				      (void **)&msg->meta.buf);
+				      (void **)&msg->buf);
 	}
 
 	return msg_read(fd, msg, size - MSG_HDR_LEN, n);
@@ -435,7 +440,7 @@ int tracecmd_msg_send_init_data(int fd)
 	cpus = ntohl(recv_msg.rinit.cpus);
 	client_ports = malloc_or_die(sizeof(int) * cpus);
 	for (i = 0; i < cpus; i++)
-		client_ports[i] = ntohl(recv_msg.rinit.port_array[i]);
+		client_ports[i] = ntohl(recv_msg.port_array[i]);
 
 	/* Next, send meta data */
 	send_metadata = true;
@@ -508,7 +513,7 @@ int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize)
 			ret = -EINVAL;
 			goto error;
 		}
-		opt = (void *)msg.tinit.opt + offset;
+		opt = (void *)msg.opt + offset;
 		offset += ntohl(opt->size);
 		size += ntohl(opt->size);
 		if (ntohl(msg.hdr.size) < size) {
@@ -581,8 +586,8 @@ int tracecmd_msg_metadata_send(int fd, const char *buf, int size)
 	if (ret < 0)
 		return ret;
 
-	msg.meta.buf = malloc(MSG_META_MAX_LEN);
-	if (!msg.meta.buf)
+	msg.buf = malloc(MSG_META_MAX_LEN);
+	if (!msg.buf)
 		return -ENOMEM;
 
 	msg.meta.size = htonl(MSG_META_MAX_LEN);
@@ -591,13 +596,13 @@ int tracecmd_msg_metadata_send(int fd, const char *buf, int size)
 	n = size;
 	do {
 		if (n > MSG_META_MAX_LEN) {
-			memcpy(msg.meta.buf, buf+count, MSG_META_MAX_LEN);
+			memcpy(msg.buf, buf+count, MSG_META_MAX_LEN);
 			n -= MSG_META_MAX_LEN;
 			count += MSG_META_MAX_LEN;
 		} else {
 			msg.hdr.size = htonl(MIN_META_SIZE + n);
 			msg.meta.size = htonl(n);
-			memcpy(msg.meta.buf, buf+count, n);
+			memcpy(msg.buf, buf+count, n);
 			n = 0;
 		}
 		ret = msg_do_write_check(fd, &msg);
@@ -655,7 +660,7 @@ int tracecmd_msg_collect_metadata(int ifd, int ofd)
 		t = n;
 		s = 0;
 		do {
-			s = write(ofd, msg.meta.buf+s, t);
+			s = write(ofd, msg.buf+s, t);
 			if (s < 0) {
 				if (errno == EINTR)
 					continue;
-- 
2.13.2
