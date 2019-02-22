Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 514D0C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 254632070D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfBVSFy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 13:05:54 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38555 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfBVSFy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 13:05:54 -0500
Received: by mail-wr1-f67.google.com with SMTP id v13so3349296wrw.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 10:05:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RXgZSquThHimJvewGfohGUh7Fkzgv8cmOEiMdA0aLos=;
        b=GWmUiaLND6K7BuByKqh4vK/yBZ4f92XWGnUZ8ZDUZyPWvgoj23zhJ5vVbau3BplPN6
         opmQ192htms1FjjbV1IVl1kYZTKNT7qqWKNFAbkwxt1vK+8BzAm0+mApo2oOjjBpQRne
         sJ9bT9SOyjZKfUaLJgREfZv4R9aPDX71pXO7hWzCBcAAnqM7FtqrR3B99t2b5cpAPwGg
         YAC9V60waqyOnFmcc3a3r4kh1+7ffqyDkIbU1XZeRsGBcEUiTWp+YzVnmm875w4Fckl2
         Q2RCVMJoWNZ6Bf5v02auouhoLQFZRNuOWbmOWuAhb9NwaKgSy5oxBKa/7IUhNiq4NcCv
         btVg==
X-Gm-Message-State: AHQUAuYTkDG7zPCjEPj6eLIv814iRrF9pfaRBdXcum2dRwrQZe3Lhzvp
        mG1iGr3vxCC8s7NXjM4hThQRdCw=
X-Google-Smtp-Source: AHgI3IYiGNlvLph3N0zHBiTkp6r2bYcIFDvPj2aKxQ78xgWEFFDEh5zf8ZvjiSSJ+DbMzyuO4VJ5CA==
X-Received: by 2002:adf:d0c9:: with SMTP id z9mr3865196wrh.132.1550858752213;
        Fri, 22 Feb 2019 10:05:52 -0800 (PST)
Received: from localhost.localdomain ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id c18sm1320678wre.32.2019.02.22.10.05.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 10:05:51 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 05/13] trace-cmd: Add TRACE_REQ and TRACE_RESP messages
Date:   Fri, 22 Feb 2019 20:05:31 +0200
Message-Id: <20190222180539.27439-6-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190222180539.27439-1-kaslevs@vmware.com>
References: <20190222180539.27439-1-kaslevs@vmware.com>
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
 include/trace-cmd/trace-cmd.h |  12 ++
 tracecmd/trace-msg.c          | 211 +++++++++++++++++++++++++++++++++-
 2 files changed, 222 insertions(+), 1 deletion(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 5961355..6a21e66 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -331,6 +331,18 @@ int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd);
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
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
 
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 51d0ac8..8ce1f98 100644
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
@@ -64,6 +65,17 @@ struct tracecmd_msg_rinit {
 	be32 cpus;
 } __attribute__((packed));
 
+struct tracecmd_msg_trace_req {
+	be32 flags;
+	be32 argc;
+} __attribute__((packed));
+
+struct tracecmd_msg_trace_resp {
+	be32 flags;
+	be32 cpus;
+	be32 page_size;
+} __attribute__((packed));
+
 struct tracecmd_msg_header {
 	be32	size;
 	be32	cmd;
@@ -76,7 +88,9 @@ struct tracecmd_msg_header {
 	C(RINIT,	2,	sizeof(struct tracecmd_msg_rinit)),	\
 	C(SEND_DATA,	3,	0),					\
 	C(FIN_DATA,	4,	0),					\
-	C(NOT_SUPP,	5,	0),
+	C(NOT_SUPP,	5,	0),					\
+	C(TRACE_REQ,	6,	sizeof(struct tracecmd_msg_trace_req)),	\
+	C(TRACE_RESP,	7,	sizeof(struct tracecmd_msg_trace_resp)),
 
 #undef C
 #define C(a,b,c)	MSG_##a = b
@@ -108,6 +122,8 @@ struct tracecmd_msg {
 	union {
 		struct tracecmd_msg_tinit	tinit;
 		struct tracecmd_msg_rinit	rinit;
+		struct tracecmd_msg_trace_req	trace_req;
+		struct tracecmd_msg_trace_resp	trace_resp;
 	};
 	union {
 		struct tracecmd_msg_opt		*opt;
@@ -723,3 +739,196 @@ error:
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
+	ssize_t buf_len;
+
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+	if (ret < 0)
+		return ret;
+
+	if (ntohl(msg.hdr.cmd) != MSG_TRACE_REQ) {
+		ret = -ENOTSUP;
+		goto out;
+	}
+
+	nr_args = ntohl(msg.trace_req.argc);
+	if (nr_args <= 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
+	buf_end = (char *)msg.buf + buf_len;
+	if (buf_len <= 0 && ((char *)msg.buf)[buf_len-1] != '\0') {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	args = calloc(nr_args, sizeof(*args));
+	if (!args) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	p = msg.buf;
+	for (i = 0; i < nr_args; i++) {
+		if (p >= buf_end) {
+			ret = -EINVAL;
+			goto out_args;
+		}
+		args[i] = p;
+		p = strchr(p, '\0');
+		if (!p) {
+			ret = -EINVAL;
+			goto out_args;
+		}
+		p++;
+	}
+
+	*argc = nr_args;
+	*argv = args;
+
+	/*
+	 * On success we're passing msg.buf to the caller through argv[0] so we
+	 * reset it here before calling msg_free().
+	 */
+	msg.buf = NULL;
+	msg_free(&msg);
+	return 0;
+
+out_args:
+	free(args);
+out:
+	error_operation(&msg);
+	if (ret == -EOPNOTSUPP)
+		handle_unexpected_msg(msg_handle, &msg);
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
+	ssize_t buf_len;
+	int i, ret;
+
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+	if (ret < 0)
+		return ret;
+
+	if (ntohl(msg.hdr.cmd) != MSG_TRACE_RESP) {
+		ret = -ENOTSUP;
+		goto out;
+	}
+
+	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
+	if (buf_len <= 0 ||
+	    buf_len != sizeof(*msg.port_array) * ntohl(msg.trace_resp.cpus)) {
+		ret = -EINVAL;
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
+	msg_free(&msg);
+	return 0;
+
+out:
+	error_operation(&msg);
+	if (ret == -EOPNOTSUPP)
+		handle_unexpected_msg(msg_handle, &msg);
+	msg_free(&msg);
+	return ret;
+}
-- 
2.19.1

