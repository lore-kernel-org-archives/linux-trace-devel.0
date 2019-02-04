Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD81C282D7
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B0D520811
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbfBDG7D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 01:59:03 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38906 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfBDG7D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 01:59:03 -0500
Received: by mail-wr1-f67.google.com with SMTP id v13so13139515wrw.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 22:59:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nchF6aP4wBEXwHmlyn2j5ppBbARyelas+/PlNoYY8xo=;
        b=NQ8wAsy2OZTawj/kGKZfmSkvfb59SY0IqublCRC15COmu3I3iSmWloyEwVaPNeisz2
         rCT3IJSeenJ/wFzy0Z1kJ2lPpyFBFhOHrLxO+RKaPoae8qLGhnGrC+7DQ6+lWfjdtHf3
         TdpxZLs8J/hyAVbE6cFGwFfZMriaJ2aAutsgiPt9aVSYcWNHoZ1eRFNKu0MBt+W+ZD6v
         qWo1QeUTYns0XHATUxyVQ7vbcpZI70J/6zIMeNE0xJ4kO8lQTC/j9rocw5t86ZtgwV6D
         av2k7upino+SGMWd+u5/qsZo3uqUcLuTRNFHs6fT4MEl2bM7Z73uMmp2HWHnRpYGLMlH
         eHDQ==
X-Gm-Message-State: AJcUukfkdOHHS58aO2fbpG0sENO058OHh7fuy2ZVvdWir+0JE+JAvPG/
        2vvvW53NRr84Xwpr+IcuHO4Hhqk7vw==
X-Google-Smtp-Source: ALg8bN4noUGvRpyd2H3HWY7fCSoq6KqNpG5kcC8ycgBhl3CKdqHXXFzkIouJRgFY/PhivawiSzmY8w==
X-Received: by 2002:adf:8b4d:: with SMTP id v13mr46083721wra.282.1549263540173;
        Sun, 03 Feb 2019 22:59:00 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id q12sm12596809wrx.31.2019.02.03.22.58.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 22:58:59 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [RFC PATCH v5 03/11] trace-cmd: Add TRACE_REQ and TRACE_RESP messages
Date:   Mon,  4 Feb 2019 08:58:40 +0200
Message-Id: <20190204065848.8248-4-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190204065848.8248-1-kaslevs@vmware.com>
References: <20190204065848.8248-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add TRACE_REQ and TRACE_RESP messages which are used for initiating guest VM
tracing.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h |  16 ++-
 tracecmd/trace-msg.c          | 213 +++++++++++++++++++++++++++++++++-
 2 files changed, 224 insertions(+), 5 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 8b43462..7664074 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -326,7 +326,7 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 			       const char *buf, int size);
 int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle);
-void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
+int tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
 
 /* for server */
 int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle);
@@ -337,6 +337,20 @@ int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd);
 bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
 void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
 
+int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
+				int argc, char **argv);
+int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
+				int *argc, char ***argv);
+
+int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
+				 int nr_cpus, int page_size,
+				 unsigned int *ports);
+int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
+				 int *nr_cpus, int *page_size,
+				 unsigned int **ports);
+
+int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle);
+
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
 
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 529ae2a..8b6fb03 100644
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
@@ -569,12 +584,12 @@ int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
 	return 0;
 }
 
-void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle)
+int tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle)
 {
 	struct tracecmd_msg msg;
 
 	tracecmd_msg_init(MSG_CLOSE, &msg);
-	tracecmd_msg_send(msg_handle->fd, &msg);
+	return tracecmd_msg_send(msg_handle->fd, &msg);
 }
 
 int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
@@ -684,7 +699,7 @@ int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 	int ret;
 
 	ret = tracecmd_msg_read_data(msg_handle, ofd);
-	if (ret)
+	if (ret < 0)
 		goto error;
 
 	/* check the finish message of the client */
@@ -715,3 +730,193 @@ error:
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
+	if (ret < 0)
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
+	char *p, *buf_end, **args;
+	int i, ret, nr_args;
+	size_t buf_len;
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
+	nr_args = ntohl(msg.trace_req.argc);
+	args = calloc(nr_args, sizeof(*args));
+	if (!args) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	for (i = 0; i < nr_args; i++) {
+		if (p >= buf_end) {
+			ret = -1;
+			free(args);
+			goto out;
+		}
+
+		args[i] = p;
+		p = strchr(p, '\0');
+		p++;
+	}
+
+	/*
+	 * On success we're passing msg.buf to the caller through argv[0] so we
+	 * reset it here to avoid getting it freed below.
+	 */
+	msg.buf = NULL;
+	*argc = nr_args;
+	*argv = args;
+	ret = 0;
+
+out:
+	msg_free(&msg);
+	return ret;
+}
+
+static int make_trace_resp(struct tracecmd_msg *msg,
+			   int page_size, int nr_cpus, unsigned int *ports)
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
+				 int nr_cpus, int page_size,
+				 unsigned int *ports)
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
+				 int *nr_cpus, int *page_size,
+				 unsigned int **ports)
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
+	if (!*ports) {
+		ret = -ENOMEM;
+		goto out;
+	}
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
+	struct tracecmd_msg msg;
+	int ret;
+
+	memset(&msg, 0, sizeof(msg));
+	for (;;) {
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+		if (ret < 0)
+			return ret;
+
+		if (ntohl(msg.hdr.cmd) == MSG_CLOSE)
+			return 0;
+
+		msg_free(&msg);
+	}
+
+	return -1;
+}
-- 
2.19.1

