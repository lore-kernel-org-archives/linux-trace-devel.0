Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbeACRxh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:37 -0500
Message-Id: <20180103175335.758268195@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 07/38] trace-cmd: Turn tracecmd_msg data into an anonymous union
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0007-trace-cmd-Turn-tracecmd_msg-data-into-an-anonymous-u.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The data union in the tracecmd_msg structure does not need a name. Turn it
into an anonymous union, and this will simplify the code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 76 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index 4d462f999a4d..5e941ed9829e 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -53,12 +53,12 @@ typedef __be32 be32;
 #define MSG_META_MAX_LEN		(MSG_MAX_LEN - MIN_META_SIZE)
 
 
-#define MIN_TINIT_SIZE	offsetof(struct tracecmd_msg, data.tinit.opt)
+#define MIN_TINIT_SIZE	offsetof(struct tracecmd_msg, tinit.opt)
 
 /* Not really the minimum, but I couldn't think of a better name */
-#define MIN_RINIT_SIZE offsetof(struct tracecmd_msg, data.rinit.port_array)
+#define MIN_RINIT_SIZE offsetof(struct tracecmd_msg, rinit.port_array)
 
-#define MIN_META_SIZE 	offsetof(struct tracecmd_msg, data.meta.buf)
+#define MIN_META_SIZE 	offsetof(struct tracecmd_msg, meta.buf)
 
 /* for both client and server */
 bool use_tcp;
@@ -123,7 +123,7 @@ struct tracecmd_msg {
 		struct tracecmd_msg_rinit rinit;
 		struct tracecmd_msg_meta meta;
 		struct tracecmd_msg_error err;
-	} data;
+	};
 } __attribute__((packed));
 
 struct tracecmd_msg *errmsg;
@@ -146,13 +146,13 @@ static ssize_t msg_do_write_check(int fd, struct tracecmd_msg *msg)
 
 	switch (ntohl(msg->cmd)) {
 	case MSG_TINIT:
-		ret = msg_write(fd, msg, MIN_TINIT_SIZE, msg->data.tinit.opt);
+		ret = msg_write(fd, msg, MIN_TINIT_SIZE, msg->tinit.opt);
 		break;
 	case MSG_RINIT:
-		ret = msg_write(fd, msg, MIN_RINIT_SIZE, msg->data.rinit.port_array);
+		ret = msg_write(fd, msg, MIN_RINIT_SIZE, msg->rinit.port_array);
 		break;
 	case MSG_SENDMETA:
-		ret = msg_write(fd, msg, MIN_META_SIZE, msg->data.meta.buf);
+		ret = msg_write(fd, msg, MIN_META_SIZE, msg->meta.buf);
 		break;
 	default:
 		ret = __do_write_check(fd, msg, ntohl(msg->size));
@@ -178,13 +178,13 @@ static int make_tinit(struct tracecmd_msg *msg)
 			return -ENOMEM;
 		opt->size = htonl(sizeof(*opt));
 		opt->opt_cmd = htonl(MSGOPT_USETCP);
-		msg->data.tinit.opt = opt;
+		msg->tinit.opt = opt;
 		size += sizeof(*opt);
 	}
 
-	msg->data.tinit.cpus = htonl(cpu_count);
-	msg->data.tinit.page_size = htonl(page_size);
-	msg->data.tinit.opt_num = htonl(opt_num);
+	msg->tinit.cpus = htonl(cpu_count);
+	msg->tinit.page_size = htonl(page_size);
+	msg->tinit.opt_num = htonl(opt_num);
 
 	msg->size = htonl(size);
 
@@ -198,15 +198,15 @@ static int make_rinit(struct tracecmd_msg *msg)
 	be32 port;
 	int i;
 
-	msg->data.rinit.cpus = htonl(cpu_count);
+	msg->rinit.cpus = htonl(cpu_count);
 
-	msg->data.rinit.port_array = malloc(sizeof(*port_array) * cpu_count);
-	if (!msg->data.rinit.port_array)
+	msg->rinit.port_array = malloc(sizeof(*port_array) * cpu_count);
+	if (!msg->rinit.port_array)
 		return -ENOMEM;
 
 	size += sizeof(*port_array) * cpu_count;
 
-	ptr = msg->data.rinit.port_array;
+	ptr = msg->rinit.port_array;
 
 	for (i = 0; i < cpu_count; i++) {
 		/* + rrqports->cpus or rrqports->port_array[i] */
@@ -252,13 +252,13 @@ static void msg_free(struct tracecmd_msg *msg)
 {
 	switch (ntohl(msg->cmd)) {
 	case MSG_TINIT:
-		free(msg->data.tinit.opt);
+		free(msg->tinit.opt);
 		break;
 	case MSG_RINIT:
-		free(msg->data.rinit.port_array);
+		free(msg->rinit.port_array);
 		break;
 	case MSG_SENDMETA:
-		free(msg->data.meta.buf);
+		free(msg->meta.buf);
 		break;
 	}
 }
@@ -323,7 +323,7 @@ static int tracecmd_msg_read_extra(int fd, struct tracecmd_msg *msg, int *n)
 
 	switch (ntohl(msg->cmd)) {
 	case MSG_TINIT:
-		msg->data.tinit.opt = NULL;
+		msg->tinit.opt = NULL;
 
 		rsize = MIN_TINIT_SIZE - *n;
 
@@ -333,19 +333,19 @@ static int tracecmd_msg_read_extra(int fd, struct tracecmd_msg *msg, int *n)
 
 		if (size > *n) {
 			size -= *n;
-			msg->data.tinit.opt = malloc(size);
-			if (!msg->data.tinit.opt)
+			msg->tinit.opt = malloc(size);
+			if (!msg->tinit.opt)
 				return -ENOMEM;
 			*n = 0;
-			return msg_read(fd, msg->data.tinit.opt, size, n);
+			return msg_read(fd, msg->tinit.opt, size, n);
 		}
 		return 0;
 	case MSG_RINIT:
 		return msg_read_extra(fd, msg, n, size, MIN_RINIT_SIZE,
-				      (void **)&msg->data.rinit.port_array);
+				      (void **)&msg->rinit.port_array);
 	case MSG_SENDMETA:
 		return msg_read_extra(fd, msg, n, size, MIN_META_SIZE,
-				      (void **)&msg->data.meta.buf);
+				      (void **)&msg->meta.buf);
 	}
 
 	return msg_read(fd, msg, size - MSG_HDR_LEN, n);
@@ -440,10 +440,10 @@ int tracecmd_msg_send_init_data(int fd)
 	if (ret < 0)
 		return ret;
 
-	cpus = ntohl(recv_msg.data.rinit.cpus);
+	cpus = ntohl(recv_msg.rinit.cpus);
 	client_ports = malloc_or_die(sizeof(int) * cpus);
 	for (i = 0; i < cpus; i++)
-		client_ports[i] = ntohl(recv_msg.data.rinit.port_array[i]);
+		client_ports[i] = ntohl(recv_msg.rinit.port_array[i]);
 
 	/* Next, send meta data */
 	send_metadata = true;
@@ -495,28 +495,28 @@ int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize)
 		goto error;
 	}
 
-	*cpus = ntohl(msg.data.tinit.cpus);
+	*cpus = ntohl(msg.tinit.cpus);
 	plog("cpus=%d\n", *cpus);
 	if (*cpus < 0) {
 		ret = -EINVAL;
 		goto error;
 	}
 
-	*pagesize = ntohl(msg.data.tinit.page_size);
+	*pagesize = ntohl(msg.tinit.page_size);
 	plog("pagesize=%d\n", *pagesize);
 	if (*pagesize <= 0) {
 		ret = -EINVAL;
 		goto error;
 	}
 
-	options = ntohl(msg.data.tinit.opt_num);
+	options = ntohl(msg.tinit.opt_num);
 	for (i = 0; i < options; i++) {
 		if (size + sizeof(*opt) > ntohl(msg.size)) {
 			plog("Not enough message for options\n");
 			ret = -EINVAL;
 			goto error;
 		}
-		opt = (void *)msg.data.tinit.opt + offset;
+		opt = (void *)msg.tinit.opt + offset;
 		offset += ntohl(opt->size);
 		size += ntohl(opt->size);
 		if (ntohl(msg.size) < size) {
@@ -589,23 +589,23 @@ int tracecmd_msg_metadata_send(int fd, const char *buf, int size)
 	if (ret < 0)
 		return ret;
 
-	msg.data.meta.buf = malloc(MSG_META_MAX_LEN);
-	if (!msg.data.meta.buf)
+	msg.meta.buf = malloc(MSG_META_MAX_LEN);
+	if (!msg.meta.buf)
 		return -ENOMEM;
 
-	msg.data.meta.size = htonl(MSG_META_MAX_LEN);
+	msg.meta.size = htonl(MSG_META_MAX_LEN);
 	msg.size = htonl(MIN_META_SIZE + MSG_META_MAX_LEN);
 
 	n = size;
 	do {
 		if (n > MSG_META_MAX_LEN) {
-			memcpy(msg.data.meta.buf, buf+count, MSG_META_MAX_LEN);
+			memcpy(msg.meta.buf, buf+count, MSG_META_MAX_LEN);
 			n -= MSG_META_MAX_LEN;
 			count += MSG_META_MAX_LEN;
 		} else {
 			msg.size = htonl(MIN_META_SIZE + n);
-			msg.data.meta.size = htonl(n);
-			memcpy(msg.data.meta.buf, buf+count, n);
+			msg.meta.size = htonl(n);
+			memcpy(msg.meta.buf, buf+count, n);
 			n = 0;
 		}
 		ret = msg_do_write_check(fd, &msg);
@@ -659,11 +659,11 @@ int tracecmd_msg_collect_metadata(int ifd, int ofd)
 		} else if (cmd != MSG_SENDMETA)
 			goto error;
 
-		n = ntohl(msg.data.meta.size);
+		n = ntohl(msg.meta.size);
 		t = n;
 		s = 0;
 		do {
-			s = write(ofd, msg.data.meta.buf+s, t);
+			s = write(ofd, msg.meta.buf+s, t);
 			if (s < 0) {
 				if (errno == EINTR)
 					continue;
-- 
2.13.2
