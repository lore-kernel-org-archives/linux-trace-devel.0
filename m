Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33639 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729709AbeLNN6D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 08:58:03 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so5559136wrr.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Dec 2018 05:58:01 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v4 3/3] trace-cmd: Bump protocol version to v3
Date: Fri, 14 Dec 2018 15:57:49 +0200
Message-Id: <20181214135749.12328-4-kaslevs@vmware.com>
In-Reply-To: <20181214135749.12328-1-kaslevs@vmware.com>
References: <20181214135749.12328-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch bumps trace-cmd protocol to v3 while keeping backward compatibility
by falling back to v1.

The new protocol works similarly to v2 but allows future extension of commands
by saving the command size on the wire and having the client on the other side
to only read the bytes it understands.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/include/trace-msg.h |   6 +-
 tracecmd/trace-listen.c      |   6 +-
 tracecmd/trace-msg.c         | 190 +++++++++++++++--------------------
 tracecmd/trace-record.c      |  10 +-
 4 files changed, 92 insertions(+), 120 deletions(-)

diff --git a/tracecmd/include/trace-msg.h b/tracecmd/include/trace-msg.h
index 722548a..b7fe10b 100644
--- a/tracecmd/include/trace-msg.h
+++ b/tracecmd/include/trace-msg.h
@@ -4,11 +4,11 @@
 #include <stdbool.h>
 
 #define UDP_MAX_PACKET	(65536 - 20)
-#define V3_MAGIC	"677768\0"
-#define V3_CPU		"-1V2"
+#define V3_MAGIC	"766679\0"
+#define V3_CPU		"-1V3"
 
 #define V1_PROTOCOL	1
-#define V3_PROTOCOL	2
+#define V3_PROTOCOL	3
 
 extern unsigned int page_size;
 
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 57151ba..8394b0f 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -387,12 +387,12 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle)
 				last_proto[n] = 0;
 			}
 			/* Return the highest protocol we can use */
-			write(fd, "V2", 3);
+			write(fd, "V3", 3);
 			goto try_again;
 		}
 
 		/* Let the client know we use v3 protocol */
-		write(fd, "V2", 3);
+		write(fd, "V3", 3);
 
 		/* read the rest of dummy data */
 		n = read(fd, buf, sizeof(V3_MAGIC));
@@ -705,7 +705,7 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
 	sleep(1);
 
 	ret = put_together_file(cpus, ofd, node, port,
-				msg_handle->version != 3);
+				msg_handle->version != V3_PROTOCOL);
 
 	destroy_all_readers(cpus, pid_array, node, port);
 
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index b496935..6b69a65 100644
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
+	int data_size = 0;
 
 	if (msg_handle->flags & TRACECMD_MSG_FL_USE_TCP) {
 		opt_num++;
@@ -196,43 +178,31 @@ static int make_tinit(struct tracecmd_msg_handle *msg_handle,
 		opt->size = htonl(sizeof(*opt));
 		opt->opt_cmd = htonl(MSGOPT_USETCP);
 		msg->opt = opt;
-		size += sizeof(*opt);
+		data_size += sizeof(*opt);
 	}
 
 	msg->tinit.cpus = htonl(cpu_count);
 	msg->tinit.page_size = htonl(page_size);
 	msg->tinit.opt_num = htonl(opt_num);
 
-	msg->hdr.size = htonl(size);
+	msg->hdr.size = htonl(ntohl(msg->hdr.size) + data_size);
 
 	return 0;
 }
 
-static int make_rinit(struct tracecmd_msg *msg, int total_cpus, int *ports)
+static int make_rinit(struct tracecmd_msg *msg, int cpus, int *ports)
 {
-	int size = MIN_RINIT_SIZE;
-	be32 *ptr;
-	be32 port;
 	int i;
 
-	msg->rinit.cpus = htonl(total_cpus);
-
-	msg->port_array = malloc(sizeof(*ports) * total_cpus);
+	msg->rinit.cpus = htonl(cpus);
+	msg->port_array = malloc(sizeof(*ports) * cpus);
 	if (!msg->port_array)
 		return -ENOMEM;
 
-	size += sizeof(*ports) * total_cpus;
-
-	ptr = msg->port_array;
-
-	for (i = 0; i < total_cpus; i++) {
-		/* + rrqports->cpus or rrqports->port_array[i] */
-		port = htonl(ports[i]);
-		*ptr = port;
-		ptr++;
-	}
+	for (i = 0; i < cpus; i++)
+		msg->port_array[i] = htonl(ports[i]);
 
-	msg->hdr.size = htonl(size);
+	msg->hdr.size = htonl(ntohl(msg->hdr.size) + sizeof(*ports) * cpus);
 
 	return 0;
 }
@@ -240,21 +210,14 @@ static int make_rinit(struct tracecmd_msg *msg, int total_cpus, int *ports)
 static void tracecmd_msg_init(u32 cmd, struct tracecmd_msg *msg)
 {
 	memset(msg, 0, sizeof(*msg));
+	msg->hdr.size = htonl(MSG_HDR_LEN + msg_cmd_sizes[cmd]);
 	msg->hdr.cmd = htonl(cmd);
-	if (!msg_min_sizes[cmd])
-		msg->hdr.size = htonl(MSG_HDR_LEN);
-	else
-		msg->hdr.size = htonl(msg_min_sizes[cmd]);
+	msg->hdr.cmd_size = htonl(msg_cmd_sizes[cmd]);
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
 
@@ -290,30 +253,42 @@ static int msg_read(int fd, void *buf, u32 size, int *n)
 	return 0;
 }
 
+static char scratch_buf[MSG_MAX_LEN];
+
 static int msg_read_extra(int fd, struct tracecmd_msg *msg,
 			  int *n, int size)
 {
-	u32 cmd;
-	int rsize;
+	int cmd, cmd_size, rsize;
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
+		rsize = cmd_size;
+		if (rsize > msg_cmd_sizes[cmd])
+			rsize = msg_cmd_sizes[cmd];
+
+		ret = msg_read(fd, msg, rsize, n);
+		if (ret < 0)
+			return ret;
+
+		ret = msg_read(fd, scratch_buf, cmd_size - rsize, n);
+		if (ret < 0)
+			return ret;
+	}
 
 	if (size > *n) {
 		size -= *n;
 		msg->buf = malloc(size);
 		if (!msg->buf)
 			return -ENOMEM;
+
 		*n = 0;
 		return msg_read(fd, msg->buf, size, n);
 	}
@@ -437,7 +412,7 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 		return -EINVAL;
 
 	cpus = ntohl(recv_msg.rinit.cpus);
-	ports = malloc_or_die(sizeof(int) * cpus);
+	ports = malloc_or_die(sizeof(*ports) * cpus);
 	for (i = 0; i < cpus; i++)
 		ports[i] = ntohl(recv_msg.port_array[i]);
 
@@ -503,7 +478,7 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 	int cpus;
 	int ret;
 	int offset = 0;
-	u32 size = MIN_TINIT_SIZE;
+	u32 size;
 	u32 cmd;
 
 	ret = tracecmd_msg_recv_wait(msg_handle->fd, &msg);
@@ -535,6 +510,7 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 		goto error;
 	}
 
+	size = MSG_HDR_LEN + ntohl(msg.hdr.cmd_size);
 	options = ntohl(msg.tinit.opt_num);
 	for (i = 0; i < options; i++) {
 		if (size + sizeof(*opt) > ntohl(msg.hdr.size)) {
@@ -608,31 +584,29 @@ int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
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
@@ -643,7 +617,7 @@ int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle)
 	struct tracecmd_msg msg;
 	int ret;
 
-	tracecmd_msg_init(MSG_FINMETA, &msg);
+	tracecmd_msg_init(MSG_FIN_DATA, &msg);
 	ret = tracecmd_msg_send(msg_handle->fd, &msg);
 	if (ret < 0)
 		return ret;
@@ -653,11 +627,11 @@ int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle)
 int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd)
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
@@ -668,16 +642,16 @@ int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd)
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
@@ -687,8 +661,8 @@ int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 			}
 			t -= s;
 			s = n - t;
-		} while (t);
-	} while (cmd == MSG_SENDMETA);
+		}
+	}
 
 	/* check the finish message of the client */
 	while (!tracecmd_msg_done(msg_handle)) {
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f19341b..e45a1f8 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2785,7 +2785,7 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 		msg_handle->version = V1_PROTOCOL;
 		plog("Use the v1 protocol\n");
 	} else {
-		if (memcmp(buf, "V2", n) != 0)
+		if (memcmp(buf, "V3", n) != 0)
 			die("Cannot handle the protocol %s", buf);
 		/* OK, let's use v3 protocol */
 		write(fd, V3_MAGIC, sizeof(V3_MAGIC));
@@ -2892,11 +2892,9 @@ setup_connection(struct buffer_instance *instance, char *date2ts, int flags)
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
 		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
-		if (msg_handle->version == 3) {
-			add_options(network_handle, date2ts, flags);
-			tracecmd_write_cpus(network_handle, instance->cpu_count);
-			tracecmd_write_options(network_handle);
-		}
+		add_options(network_handle, date2ts, flags);
+		tracecmd_write_cpus(network_handle, instance->cpu_count);
+		tracecmd_write_options(network_handle);
 		tracecmd_msg_finish_sending_data(msg_handle);
 	} else
 		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
-- 
2.19.1
