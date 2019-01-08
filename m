Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37761 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727678AbfAHPAd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Jan 2019 10:00:33 -0500
Received: by mail-pf1-f195.google.com with SMTP id y126so2058964pfb.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Jan 2019 07:00:32 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v2 5/6] trace-cmd: Add TRACE_REQ and TRACE_RESP messages
Date: Tue,  8 Jan 2019 17:00:14 +0200
Message-Id: <20190108150015.21327-6-kaslevs@vmware.com>
In-Reply-To: <20190108150015.21327-1-kaslevs@vmware.com>
References: <20190108150015.21327-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Add TRACE_REQ and TRACE_RESP messages which are used for initiating guest VM
tracing.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h |  12 +++
 tracecmd/trace-msg.c          | 185 +++++++++++++++++++++++++++++++++-
 2 files changed, 196 insertions(+), 1 deletion(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index c1b18fa..fae6ceb 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -337,6 +337,18 @@ int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd);
 bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
 void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
 
+int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
+				int argc, char **argv);
+int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
+				int *argc, char ***argv);
+
+int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
+				 int nr_cpus, int page_size, int *ports);
+int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
+				 int *nr_cpus, int *page_size, int **ports);
+
+int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle);
+
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
 
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index edde582..35d1d0e 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -16,6 +16,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdarg.h>
+#include <string.h>
 #include <unistd.h>
 #include <arpa/inet.h>
 #include <sys/types.h>
@@ -79,6 +80,16 @@ struct tracecmd_msg_rinit {
 	be32 cpus;
 } __attribute__((packed));
 
+struct tracecmd_msg_trace_req {
+	be32 flags;
+	be32 argc;
+} __attribute__((packed));
+
+struct tracecmd_msg_trace_resp {
+	be32 cpus;
+	be32 page_size;
+} __attribute__((packed));
+
 struct tracecmd_msg_header {
 	be32	size;
 	be32	cmd;
@@ -90,7 +101,9 @@ struct tracecmd_msg_header {
 	C(TINIT,	1,	sizeof(struct tracecmd_msg_tinit)),	\
 	C(RINIT,	2,	sizeof(struct tracecmd_msg_rinit)),	\
 	C(SEND_DATA,	3,	0),					\
-	C(FIN_DATA,	4,	0),
+	C(FIN_DATA,	4,	0),					\
+	C(TRACE_REQ,	5,	sizeof(struct tracecmd_msg_trace_req)),	\
+	C(TRACE_RESP,	6,	sizeof(struct tracecmd_msg_trace_resp)),
 
 #undef C
 #define C(a,b,c)	MSG_##a = b
@@ -122,6 +135,8 @@ struct tracecmd_msg {
 	union {
 		struct tracecmd_msg_tinit	tinit;
 		struct tracecmd_msg_rinit	rinit;
+		struct tracecmd_msg_trace_req	trace_req;
+		struct tracecmd_msg_trace_resp	trace_resp;
 	};
 	union {
 		struct tracecmd_msg_opt		*opt;
@@ -715,3 +730,171 @@ error:
 	msg_free(&msg);
 	return ret;
 }
+
+static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv)
+{
+	size_t args_size = 0;
+	char *p;
+	int i;
+
+	for (i = 0; i < argc; i++)
+		args_size += strlen(argv[i]) + 1;
+
+	msg->hdr.size = htonl(ntohl(msg->hdr.size) + args_size);
+	msg->trace_req.argc = htonl(argc);
+	msg->buf = calloc(args_size, 1);
+	if (!msg->buf)
+		return -ENOMEM;
+
+	p = msg->buf;
+	for (i = 0; i < argc; i++)
+		p = stpcpy(p, argv[i]) + 1;
+
+	return 0;
+}
+
+int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
+				int argc, char **argv)
+{
+	struct tracecmd_msg msg;
+	int ret;
+
+	tracecmd_msg_init(MSG_TRACE_REQ, &msg);
+	ret = make_trace_req(&msg, argc, argv);
+	if (ret)
+		return ret;
+
+	return tracecmd_msg_send(msg_handle->fd, &msg);
+}
+
+ /*
+  * NOTE: On success, the returned `argv` should be freed with:
+  *     free(argv[0]);
+  *     free(argv);
+  */
+int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
+				int *argc, char ***argv)
+{
+	struct tracecmd_msg msg;
+	char *p, *buf_end;
+	size_t buf_len;
+	int i, ret;
+
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+	if (ret < 0)
+		return ret;
+
+	if (ntohl(msg.hdr.cmd) != MSG_TRACE_REQ)
+		goto out;
+
+	if (ntohl(msg.trace_req.argc) < 0)
+		goto out;
+
+	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
+	buf_end = (char *)msg.buf + buf_len;
+	p = msg.buf;
+	*argc = ntohl(msg.trace_req.argc);
+	*argv = calloc(*argc, sizeof(**argv));
+	for (i = 0; i < *argc; i++) {
+		if (p >= buf_end) {
+			ret = -1;
+			free(*argv);
+			goto out;
+		}
+
+		(*argv)[i] = p;
+		p = strchr(p, '\0');
+		p++;
+	}
+
+	ret = 0;
+	msg.buf = NULL;
+
+out:
+	msg_free(&msg);
+	return ret;
+}
+
+static int make_trace_resp(struct tracecmd_msg *msg,
+			   int page_size, int nr_cpus, int *ports)
+{
+	int ports_size = nr_cpus * sizeof(*msg->port_array);
+	int i;
+
+	msg->hdr.size = htonl(ntohl(msg->hdr.size) + ports_size);
+	msg->trace_resp.cpus = htonl(nr_cpus);
+	msg->trace_resp.page_size = htonl(page_size);
+
+	msg->port_array = malloc(ports_size);
+	if (!msg->port_array)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_cpus; i++)
+		msg->port_array[i] = htonl(ports[i]);
+
+	return 0;
+}
+
+int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
+				 int nr_cpus, int page_size, int *ports)
+{
+	struct tracecmd_msg msg;
+	int ret;
+
+	tracecmd_msg_init(MSG_TRACE_RESP, &msg);
+	ret = make_trace_resp(&msg, page_size, nr_cpus, ports);
+	if (ret < 0)
+		return ret;
+
+	return tracecmd_msg_send(msg_handle->fd, &msg);
+}
+
+int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
+				 int *nr_cpus, int *page_size, int **ports)
+{
+	struct tracecmd_msg msg;
+	size_t buf_len;
+	int i, ret;
+
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+	if (ret < 0)
+		return ret;
+
+	if (ntohl(msg.hdr.cmd) != MSG_TRACE_RESP) {
+		ret = -1;
+		goto out;
+	}
+
+	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
+	if (buf_len <= 0 ||
+	    buf_len != sizeof(*msg.port_array) * ntohl(msg.trace_resp.cpus)) {
+		ret = -1;
+		goto out;
+	}
+
+	*nr_cpus = ntohl(msg.trace_resp.cpus);
+	*page_size = ntohl(msg.trace_resp.page_size);
+	*ports = calloc(*nr_cpus, sizeof(**ports));
+	for (i = 0; i < *nr_cpus; i++)
+		(*ports)[i] = ntohl(msg.port_array[i]);
+
+	ret = 0;
+
+out:
+	msg_free(&msg);
+	return ret;
+}
+
+int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle)
+{
+	char buf[BUFSIZ];
+	int ret;
+
+	for (;;) {
+		ret = read(msg_handle->fd, buf, sizeof(buf));
+		if (ret <= 0)
+			return ret;
+	}
+
+	return -1;
+}
-- 
2.19.1
