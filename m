Return-Path: <SRS0=R/5S=OM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46082 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbeLCQJz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 3 Dec 2018 11:09:55 -0500
Received: by mail-wr1-f68.google.com with SMTP id l9so12767258wrt.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 03 Dec 2018 08:09:47 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Bump protocol version to v3
Date: Mon,  3 Dec 2018 18:09:36 +0200
Message-Id: <20181203160937.5285-2-kaslevs@vmware.com>
In-Reply-To: <20181203160937.5285-1-kaslevs@vmware.com>
References: <20181203160937.5285-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch bumps trace-cmd protocol to v3 while keeping backward compatibility
by falling back to v1.

The new protocol works similarly to v2 but allows future extension of commands
by saving the command size on the wire and having the client on the other side
to only read the bits it understands.
---
 include/trace-cmd/trace-cmd.h |   6 +-
 tracecmd/include/trace-msg.h  |   6 +-
 tracecmd/trace-listen.c       |  30 +++---
 tracecmd/trace-msg.c          | 187 +++++++++++++++-------------------
 tracecmd/trace-output.c       |   2 +-
 tracecmd/trace-record.c       |  26 ++---
 6 files changed, 119 insertions(+), 138 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 684ddb7..7cce592 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -316,16 +316,16 @@ void tracecmd_msg_handle_close(struct tracecmd_msg_handle *msg_handle);
 /* for clients */
 int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 				int **client_ports);
-int tracecmd_msg_metadata_send(struct tracecmd_msg_handle *msg_handle,
+int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 			       const char *buf, int size);
-int tracecmd_msg_finish_sending_metadata(struct tracecmd_msg_handle *msg_handle);
+int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle);
 void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
 
 /* for server */
 int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
 				 int *ports);
-int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int ofd);
+int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd);
 bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
 void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
 
diff --git a/tracecmd/include/trace-msg.h b/tracecmd/include/trace-msg.h
index bfd065c..b7fe10b 100644
--- a/tracecmd/include/trace-msg.h
+++ b/tracecmd/include/trace-msg.h
@@ -4,11 +4,11 @@
 #include <stdbool.h>
 
 #define UDP_MAX_PACKET	(65536 - 20)
-#define V2_MAGIC	"677768\0"
-#define V2_CPU		"-1V2"
+#define V3_MAGIC	"766679\0"
+#define V3_CPU		"-1V3"
 
 #define V1_PROTOCOL	1
-#define V2_PROTOCOL	2
+#define V3_PROTOCOL	3
 
 extern unsigned int page_size;
 
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 5727c0e..6760bd4 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -366,7 +366,7 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle)
 
 	/* Is the client using the new protocol? */
 	if (cpus == -1) {
-		if (memcmp(buf, V2_CPU, n) != 0) {
+		if (memcmp(buf, V3_CPU, n) != 0) {
 			/* If it did not send a version, then bail */
 			if (memcmp(buf, "-1V", 3)) {
 				plog("Unknown string %s\n", buf);
@@ -382,27 +382,29 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle)
 			}
 			free(last_proto);
 			last_proto = malloc(n + 1);
-			if (last_proto) {
-				memcpy(last_proto, buf, n);
-				last_proto[n] = 0;
-			}
+			if (!last_proto)
+				return -ENOMEM;
+
+			memcpy(last_proto, buf, n);
+			last_proto[n] = 0;
+
 			/* Return the highest protocol we can use */
-			write(fd, "V2", 3);
+			write(fd, "V3", 3);
 			goto try_again;
 		}
 
-		/* Let the client know we use v2 protocol */
-		write(fd, "V2", 3);
+		/* Let the client know we use v3 protocol */
+		write(fd, "V3", 3);
 
 		/* read the rest of dummy data */
-		n = read(fd, buf, sizeof(V2_MAGIC));
-		if (memcmp(buf, V2_MAGIC, n) != 0)
+		n = read(fd, buf, sizeof(V3_MAGIC));
+		if (memcmp(buf, V3_MAGIC, n) != 0)
 			goto out;
 
 		/* We're off! */
 		write(fd, "OK", 2);
 
-		msg_handle->version = V2_PROTOCOL;
+		msg_handle->version = V3_PROTOCOL;
 
 		/* read the CPU count, the page size, and options */
 		if ((pagesize = tracecmd_msg_initial_setting(msg_handle)) < 0)
@@ -557,7 +559,7 @@ static int *create_all_readers(const char *node, const char *port,
 		start_port = udp_port + 1;
 	}
 
-	if (msg_handle->version == V2_PROTOCOL) {
+	if (msg_handle->version == V3_PROTOCOL) {
 		/* send set of port numbers to the client */
 		if (tracecmd_msg_send_port_array(msg_handle, port_array) < 0) {
 			plog("Failed sending port array\n");
@@ -674,8 +676,8 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
 	stop_msg_handle = msg_handle;
 
 	/* Now we are ready to start reading data from the client */
-	if (msg_handle->version == V2_PROTOCOL)
-		tracecmd_msg_collect_metadata(msg_handle, ofd);
+	if (msg_handle->version == V3_PROTOCOL)
+		tracecmd_msg_collect_data(msg_handle, ofd);
 	else
 		collect_metadata_from_client(msg_handle, ofd);
 
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 8e1226b..fa700c3 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -45,21 +45,7 @@ static inline void dprint(const char *fmt, ...)
 
 #define MSG_HDR_LEN			sizeof(struct tracecmd_msg_header)
 
-#define MSG_DATA_LEN			(MSG_MAX_LEN - MSG_HDR_LEN)
-
-					/* - header size for error msg */
-#define MSG_META_MAX_LEN		(MSG_MAX_LEN - MIN_META_SIZE)
-
-
-#define MIN_TINIT_SIZE	(sizeof(struct tracecmd_msg_header) + \
-			 sizeof(struct tracecmd_msg_tinit))
-
-/* Not really the minimum, but I couldn't think of a better name */
-#define MIN_RINIT_SIZE	(sizeof(struct tracecmd_msg_header) + \
-			 sizeof(struct tracecmd_msg_rinit))
-
-#define MIN_META_SIZE	(sizeof(struct tracecmd_msg_header) + \
-			 sizeof(struct tracecmd_msg_meta))
+#define MSG_MAX_DATA_LEN		(MSG_MAX_LEN - MSG_HDR_LEN)
 
 unsigned int page_size;
 
@@ -81,8 +67,7 @@ make_server(struct tracecmd_msg_handle *msg_handle)
 struct tracecmd_msg_opt {
 	be32 size;
 	be32 opt_cmd;
-	be32 padding;	/* for backward compatibility */
-};
+} __attribute__((packed));
 
 struct tracecmd_msg_tinit {
 	be32 cpus;
@@ -94,36 +79,31 @@ struct tracecmd_msg_rinit {
 	be32 cpus;
 } __attribute__((packed));
 
-struct tracecmd_msg_meta {
-	be32 size;
-} __attribute__((packed));
-
 struct tracecmd_msg_header {
 	be32	size;
 	be32	cmd;
+	be32	cmd_size;
 } __attribute__((packed));
 
-#define MSG_MAP						\
-	C(UNUSED_0,	0,	-1),			\
-	C(CLOSE,	1,	0),			\
-	C(USUSED_2,	2,	-1),			\
-	C(UNUSED_3,	3,	-1),			\
-	C(TINIT,	4,	MIN_TINIT_SIZE),	\
-	C(RINIT,	5,	MIN_RINIT_SIZE),	\
-	C(SENDMETA,	6,	MIN_META_SIZE),		\
-	C(FINMETA,	7,	0),
+#define MSG_MAP								\
+	C(CLOSE,	0,	0),					\
+	C(TINIT,	1,	sizeof(struct tracecmd_msg_tinit)),	\
+	C(RINIT,	2,	sizeof(struct tracecmd_msg_rinit)),	\
+	C(SEND_DATA,	3,	0),					\
+	C(FIN_DATA,	4,	0),
 
 #undef C
 #define C(a,b,c)	MSG_##a = b
 
 enum tracecmd_msg_cmd {
 	MSG_MAP
+	MSG_NR_COMMANDS
 };
 
 #undef C
 #define C(a,b,c)	c
 
-static be32 msg_min_sizes[] = { MSG_MAP };
+static be32 msg_cmd_sizes[] = { MSG_MAP };
 
 #undef C
 #define C(a,b,c)	#a
@@ -132,9 +112,9 @@ static const char *msg_names[] = { MSG_MAP };
 
 static const char *cmd_to_name(int cmd)
 {
-	if (cmd <= MSG_FINMETA)
-		return msg_names[cmd];
-	return "Unkown";
+	if (cmd < 0 || cmd >= MSG_NR_COMMANDS)
+		return "Unknown";
+	return msg_names[cmd];
 }
 
 struct tracecmd_msg {
@@ -142,7 +122,6 @@ struct tracecmd_msg {
 	union {
 		struct tracecmd_msg_tinit	tinit;
 		struct tracecmd_msg_rinit	rinit;
-		struct tracecmd_msg_meta	meta;
 	};
 	union {
 		struct tracecmd_msg_opt		*opt;
@@ -156,24 +135,27 @@ struct tracecmd_msg *errmsg;
 static int msg_write(int fd, struct tracecmd_msg *msg)
 {
 	int cmd = ntohl(msg->hdr.cmd);
-	int size;
+	int msg_size, data_size;
 	int ret;
 
-	if (cmd > MSG_FINMETA)
+	if (cmd < 0 || cmd >= MSG_NR_COMMANDS)
 		return -EINVAL;
 
 	dprint("msg send: %d (%s)\n", cmd, cmd_to_name(cmd));
 
-	size = msg_min_sizes[cmd];
-	if (!size)
-		size = ntohl(msg->hdr.size);
+	msg_size = MSG_HDR_LEN + ntohl(msg->hdr.cmd_size);
+	data_size = ntohl(msg->hdr.size) - msg_size;
+	if (data_size < 0)
+		return -EINVAL;
 
-	ret = __do_write_check(fd, msg, size);
+	ret = __do_write_check(fd, msg, msg_size);
 	if (ret < 0)
 		return ret;
-	if (ntohl(msg->hdr.size) <= size)
+
+	if (!data_size)
 		return 0;
-	return __do_write_check(fd, msg->buf, ntohl(msg->hdr.size) - size);
+
+	return __do_write_check(fd, msg->buf, data_size);
 }
 
 enum msg_opt_command {
@@ -186,7 +168,7 @@ static int make_tinit(struct tracecmd_msg_handle *msg_handle,
 	struct tracecmd_msg_opt *opt;
 	int cpu_count = msg_handle->cpu_count;
 	int opt_num = 0;
-	int size = MIN_TINIT_SIZE;
+	int size = MSG_HDR_LEN + sizeof(struct tracecmd_msg_tinit);
 
 	if (msg_handle->flags & TRACECMD_MSG_FL_USE_TCP) {
 		opt_num++;
@@ -204,15 +186,14 @@ static int make_tinit(struct tracecmd_msg_handle *msg_handle,
 	msg->tinit.opt_num = htonl(opt_num);
 
 	msg->hdr.size = htonl(size);
+	msg->hdr.cmd_size = htonl(sizeof(struct tracecmd_msg_tinit));
 
 	return 0;
 }
 
 static int make_rinit(struct tracecmd_msg *msg, int total_cpus, int *ports)
 {
-	int size = MIN_RINIT_SIZE;
-	be32 *ptr;
-	be32 port;
+	int size = MSG_HDR_LEN + sizeof(struct tracecmd_msg_rinit);
 	int i;
 
 	msg->rinit.cpus = htonl(total_cpus);
@@ -223,16 +204,11 @@ static int make_rinit(struct tracecmd_msg *msg, int total_cpus, int *ports)
 
 	size += sizeof(*ports) * total_cpus;
 
-	ptr = msg->port_array;
-
-	for (i = 0; i < total_cpus; i++) {
-		/* + rrqports->cpus or rrqports->port_array[i] */
-		port = htonl(ports[i]);
-		*ptr = port;
-		ptr++;
-	}
+	for (i = 0; i < total_cpus; i++)
+		msg->port_array[i] = htonl(ports[i]);
 
 	msg->hdr.size = htonl(size);
+	msg->hdr.cmd_size = htonl(sizeof(struct tracecmd_msg_rinit));
 
 	return 0;
 }
@@ -240,21 +216,13 @@ static int make_rinit(struct tracecmd_msg *msg, int total_cpus, int *ports)
 static void tracecmd_msg_init(u32 cmd, struct tracecmd_msg *msg)
 {
 	memset(msg, 0, sizeof(*msg));
+	msg->hdr.size = htonl(MSG_HDR_LEN);
 	msg->hdr.cmd = htonl(cmd);
-	if (!msg_min_sizes[cmd])
-		msg->hdr.size = htonl(MSG_HDR_LEN);
-	else
-		msg->hdr.size = htonl(msg_min_sizes[cmd]);
 }
 
 static void msg_free(struct tracecmd_msg *msg)
 {
-	int cmd = ntohl(msg->hdr.cmd);
-
-	/* If a min size is defined, then the buf needs to be freed */
-	if (cmd < MSG_FINMETA && (msg_min_sizes[cmd] > 0))
-		free(msg->buf);
-
+	free(msg->buf);
 	memset(msg, 0, sizeof(*msg));
 }
 
@@ -293,29 +261,42 @@ static int msg_read(int fd, void *buf, u32 size, int *n)
 static int msg_read_extra(int fd, struct tracecmd_msg *msg,
 			  int *n, int size)
 {
-	u32 cmd;
-	int rsize;
+	int cmd, cmd_size, m, rsize;
 	int ret;
 
 	cmd = ntohl(msg->hdr.cmd);
-	if (cmd > MSG_FINMETA)
+	if (cmd < 0 || cmd >= MSG_NR_COMMANDS)
 		return -EINVAL;
 
-	rsize = msg_min_sizes[cmd] - *n;
-	if (rsize <= 0)
-		return 0;
+	cmd_size = ntohl(msg->hdr.cmd_size);
+	if (cmd_size < 0)
+		return -EINVAL;
 
-	ret = msg_read(fd, msg, rsize, n);
-	if (ret < 0)
-		return ret;
+	if (cmd_size > 0) {
+		m = *n;
+		rsize = cmd_size;
+		if (rsize > msg_cmd_sizes[cmd])
+			rsize = msg_cmd_sizes[cmd];
+
+		ret = msg_read(fd, msg, rsize, &m);
+		if (ret < 0)
+			return ret;
+	}
+
+	*n += cmd_size;
 
 	if (size > *n) {
 		size -= *n;
 		msg->buf = malloc(size);
 		if (!msg->buf)
 			return -ENOMEM;
-		*n = 0;
-		return msg_read(fd, msg->buf, size, n);
+
+		m = 0;
+		ret = msg_read(fd, msg->buf, size, &m);
+		if (ret < 0)
+			return ret;
+
+		*n += m;
 	}
 
 	return 0;
@@ -503,7 +484,7 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 	int cpus;
 	int ret;
 	int offset = 0;
-	u32 size = MIN_TINIT_SIZE;
+	u32 size = MSG_HDR_LEN + sizeof(struct tracecmd_msg_tinit);
 	u32 cmd;
 
 	ret = tracecmd_msg_recv_wait(msg_handle->fd, &msg);
@@ -599,8 +580,8 @@ void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle)
 	tracecmd_msg_send(msg_handle->fd, &msg);
 }
 
-int tracecmd_msg_metadata_send(struct tracecmd_msg_handle *msg_handle,
-			       const char *buf, int size)
+int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
+			   const char *buf, int size)
 {
 	struct tracecmd_msg msg;
 	int fd = msg_handle->fd;
@@ -608,56 +589,54 @@ int tracecmd_msg_metadata_send(struct tracecmd_msg_handle *msg_handle,
 	int ret;
 	int count = 0;
 
-	tracecmd_msg_init(MSG_SENDMETA, &msg);
+	tracecmd_msg_init(MSG_SEND_DATA, &msg);
 
-	msg.buf = malloc(MSG_META_MAX_LEN);
+	msg.buf = malloc(MSG_MAX_DATA_LEN);
 	if (!msg.buf)
 		return -ENOMEM;
 
-	msg.meta.size = htonl(MSG_META_MAX_LEN);
-	msg.hdr.size = htonl(MIN_META_SIZE + MSG_META_MAX_LEN);
+	msg.hdr.size = htonl(MSG_MAX_LEN);
 
 	n = size;
-	do {
-		if (n > MSG_META_MAX_LEN) {
-			memcpy(msg.buf, buf+count, MSG_META_MAX_LEN);
-			n -= MSG_META_MAX_LEN;
-			count += MSG_META_MAX_LEN;
+	while (n) {
+		if (n > MSG_MAX_DATA_LEN) {
+			memcpy(msg.buf, buf + count, MSG_MAX_DATA_LEN);
+			n -= MSG_MAX_DATA_LEN;
+			count += MSG_MAX_DATA_LEN;
 		} else {
-			msg.hdr.size = htonl(MIN_META_SIZE + n);
-			msg.meta.size = htonl(n);
-			memcpy(msg.buf, buf+count, n);
+			msg.hdr.size = htonl(MSG_HDR_LEN + n);
+			memcpy(msg.buf, buf + count, n);
 			n = 0;
 		}
 		ret = msg_write(fd, &msg);
 		if (ret < 0)
 			break;
-	} while (n);
+	}
 
 	msg_free(&msg);
 	return ret;
 }
 
-int tracecmd_msg_finish_sending_metadata(struct tracecmd_msg_handle *msg_handle)
+int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle)
 {
 	struct tracecmd_msg msg;
 	int ret;
 
-	tracecmd_msg_init(MSG_FINMETA, &msg);
+	tracecmd_msg_init(MSG_FIN_DATA, &msg);
 	ret = tracecmd_msg_send(msg_handle->fd, &msg);
 	if (ret < 0)
 		return ret;
 	return 0;
 }
 
-int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int ofd)
+int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 {
 	struct tracecmd_msg msg;
-	u32 t, n, cmd;
+	int t, n, cmd;
 	ssize_t s;
 	int ret;
 
-	do {
+	for (;;) {
 		ret = tracecmd_msg_recv_wait(msg_handle->fd, &msg);
 		if (ret < 0) {
 			if (ret == -ETIMEDOUT)
@@ -668,16 +647,16 @@ int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int of
 		}
 
 		cmd = ntohl(msg.hdr.cmd);
-		if (cmd == MSG_FINMETA) {
-			/* Finish receiving meta data */
+		if (cmd == MSG_FIN_DATA) {
+			/* Finish receiving data */
 			break;
-		} else if (cmd != MSG_SENDMETA)
+		} else if (cmd != MSG_SEND_DATA)
 			goto error;
 
-		n = ntohl(msg.meta.size);
+		n = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
 		t = n;
 		s = 0;
-		do {
+		while (t > 0) {
 			s = write(ofd, msg.buf+s, t);
 			if (s < 0) {
 				if (errno == EINTR)
@@ -687,8 +666,8 @@ int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int of
 			}
 			t -= s;
 			s = n - t;
-		} while (t);
-	} while (cmd == MSG_SENDMETA);
+		}
+	}
 
 	/* check the finish message of the client */
 	while (!tracecmd_msg_done(msg_handle)) {
diff --git a/tracecmd/trace-output.c b/tracecmd/trace-output.c
index 99493e6..78a8fe6 100644
--- a/tracecmd/trace-output.c
+++ b/tracecmd/trace-output.c
@@ -74,7 +74,7 @@ static stsize_t
 do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
 {
 	if (handle->msg_handle)
-		return tracecmd_msg_metadata_send(handle->msg_handle, data, size);
+		return tracecmd_msg_data_send(handle->msg_handle, data, size);
 
 	return __do_write_check(handle->fd, data, size);
 }
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 038b231..eb3ce4e 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2747,7 +2747,7 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
 	}
 }
 
-static void communicate_with_listener_v2(struct tracecmd_msg_handle *msg_handle)
+static void communicate_with_listener_v3(struct tracecmd_msg_handle *msg_handle)
 {
 	if (tracecmd_msg_send_init_data(msg_handle, &client_ports) < 0)
 		die("Cannot communicate with server");
@@ -2764,8 +2764,8 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 	/*
 	 * Write the protocol version, the magic number, and the dummy
 	 * option(0) (in ASCII). The client understands whether the client
-	 * uses the v2 protocol or not by checking a reply message from the
-	 * server. If the message is "V2", the server uses v2 protocol. On the
+	 * uses the v3 protocol or not by checking a reply message from the
+	 * server. If the message is "V3", the server uses v3 protocol. On the
 	 * other hands, if the message is just number strings, the server
 	 * returned port numbers. So, in that time, the client understands the
 	 * server uses the v1 protocol. However, the old server tells the
@@ -2773,7 +2773,7 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 	 * So, we add the dummy number (the magic number and 0 option) to the
 	 * first client message.
 	 */
-	write(fd, V2_CPU, sizeof(V2_CPU));
+	write(fd, V3_CPU, sizeof(V3_CPU));
 
 	buf[0] = 0;
 
@@ -2785,10 +2785,10 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 		msg_handle->version = V1_PROTOCOL;
 		plog("Use the v1 protocol\n");
 	} else {
-		if (memcmp(buf, "V2", n) != 0)
+		if (memcmp(buf, "V3", n) != 0)
 			die("Cannot handle the protocol %s", buf);
-		/* OK, let's use v2 protocol */
-		write(fd, V2_MAGIC, sizeof(V2_MAGIC));
+		/* OK, let's use v3 protocol */
+		write(fd, V3_MAGIC, sizeof(V3_MAGIC));
 
 		n = read(fd, buf, BUFSIZ - 1);
 		if (n != 2 || memcmp(buf, "OK", 2) != 0) {
@@ -2857,20 +2857,20 @@ again:
 			die("Failed to allocate message handle");
 
 		msg_handle->cpu_count = local_cpu_count;
-		msg_handle->version = V2_PROTOCOL;
+		msg_handle->version = V3_PROTOCOL;
 	}
 
 	if (use_tcp)
 		msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
 
-	if (msg_handle->version == V2_PROTOCOL) {
+	if (msg_handle->version == V3_PROTOCOL) {
 		check_protocol_version(msg_handle);
 		if (msg_handle->version == V1_PROTOCOL) {
 			/* reconnect to the server for using the v1 protocol */
 			close(sfd);
 			goto again;
 		}
-		communicate_with_listener_v2(msg_handle);
+		communicate_with_listener_v3(msg_handle);
 	}
 
 	if (msg_handle->version == V1_PROTOCOL)
@@ -2888,9 +2888,9 @@ setup_connection(struct buffer_instance *instance)
 	msg_handle = setup_network();
 
 	/* Now create the handle through this socket */
-	if (msg_handle->version == V2_PROTOCOL) {
+	if (msg_handle->version == V3_PROTOCOL) {
 		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
-		tracecmd_msg_finish_sending_metadata(msg_handle);
+		tracecmd_msg_finish_sending_data(msg_handle);
 	} else
 		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
 							      listed_events);
@@ -2903,7 +2903,7 @@ setup_connection(struct buffer_instance *instance)
 
 static void finish_network(struct tracecmd_msg_handle *msg_handle)
 {
-	if (msg_handle->version == V2_PROTOCOL)
+	if (msg_handle->version == V3_PROTOCOL)
 		tracecmd_msg_send_close_msg(msg_handle);
 	tracecmd_msg_handle_close(msg_handle);
 	free(host);
-- 
2.19.1
