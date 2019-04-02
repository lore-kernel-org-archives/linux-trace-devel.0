Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F90C10F0B
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C37DD2146E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731743AbfDBNms (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:42:48 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55651 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731699AbfDBNmq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:42:46 -0400
Received: by mail-wm1-f65.google.com with SMTP id o25so3449212wmf.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:42:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hHMbDiJ+dBTJRZW7MX07pT6J/5TZtFiYq6f7feepKcQ=;
        b=HZzk22PMPduueJUKGwchvO5jhISXtgqLmS6uDtE3xyLjfMt0Ofn7+WqOBz6kRda+T3
         22UfeIj411FtqagAQdN5LpzCFcpQWMyWlPgSDiu4wDLHRZFxdupbk+WObEnkOwNNxibH
         Kpp50YwFJFrLT3NPABDZX2gcmCsaBxqz8tZtVBdeirTkCHaMsDVl/GYv3oSlYi/JpcPl
         WEP3VCTF303w+54hkdpqUK5vlPdMl3oDU940q7KjJwYRWQmHkUZaxhZM5cwRh5kQLanC
         SViM+9uhoW9DeCFqfckZTm0lqHhNqi0Pz0mhR+jqnD5ZH71S4GhEkN6SU7Kj+5L+w3BH
         IJkg==
X-Gm-Message-State: APjAAAXMo5TrclcnX+6humuNCI4g7PBVkdA0WDI3FaGq77G/3o74u+oi
        S2UQYyVXTlGbVzSYrx0dig==
X-Google-Smtp-Source: APXvYqwN12FRhdIzMnRV7B4sTcEUywMtj5b9V670gNX+TC+I4V3HVnmVbAsVyT7Rjzum8wdQYsWqgA==
X-Received: by 2002:a7b:c086:: with SMTP id r6mr3764456wmh.123.1554212564548;
        Tue, 02 Apr 2019 06:42:44 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h84sm19207083wmf.15.2019.04.02.06.42.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:42:43 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 04/11] trace-cmd: Add TRACE_REQ and TRACE_RESP messages
Date:   Tue,  2 Apr 2019 16:42:13 +0300
Message-Id: <20190402134230.30988-8-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190402134230.30988-1-kaslevs@vmware.com>
References: <20190402134230.30988-1-kaslevs@vmware.com>
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
 tracecmd/trace-msg.c          | 213 +++++++++++++++++++++++++++++++++-
 2 files changed, 224 insertions(+), 1 deletion(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 057f096..fe6b85b 100644
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
index 461b6cb..2db03ab 100644
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
@@ -59,6 +60,17 @@ struct tracecmd_msg_rinit {
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
@@ -71,7 +83,9 @@ struct tracecmd_msg_header {
 	C(RINIT,	2,	sizeof(struct tracecmd_msg_rinit)),	\
 	C(SEND_DATA,	3,	0),					\
 	C(FIN_DATA,	4,	0),					\
-	C(NOT_SUPP,	5,	0),
+	C(NOT_SUPP,	5,	0),					\
+	C(TRACE_REQ,	6,	sizeof(struct tracecmd_msg_trace_req)),	\
+	C(TRACE_RESP,	7,	sizeof(struct tracecmd_msg_trace_resp)),
 
 #undef C
 #define C(a,b,c)	MSG_##a = b
@@ -103,6 +117,8 @@ struct tracecmd_msg {
 	union {
 		struct tracecmd_msg_tinit	tinit;
 		struct tracecmd_msg_rinit	rinit;
+		struct tracecmd_msg_trace_req	trace_req;
+		struct tracecmd_msg_trace_resp	trace_resp;
 	};
 	char					*buf;
 } __attribute__((packed));
@@ -771,3 +787,198 @@ error:
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
+	for (i = 0, p = msg.buf; i < nr_args; i++, p++) {
+		if (p >= buf_end) {
+			ret = -EINVAL;
+			goto out_args;
+		}
+		args[i] = p;
+		p = strchr(p, '\0');
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
+	int data_size;
+
+	data_size = write_uints(NULL, 0, ports, nr_cpus);
+	msg->buf = malloc(data_size);
+	if (!msg->buf)
+		return -ENOMEM;
+	write_uints(msg->buf, data_size, ports, nr_cpus);
+
+	msg->hdr.size = htonl(ntohl(msg->hdr.size) + data_size);
+	msg->trace_resp.cpus = htonl(nr_cpus);
+	msg->trace_resp.page_size = htonl(page_size);
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
+	char *p, *buf_end;
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
+	buf_len = msg_buf_len(&msg);
+	if (buf_len <= 0) {
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
+
+	buf_end = msg.buf + buf_len;
+	for (i = 0, p = msg.buf; i < *nr_cpus; i++, p++) {
+		if (p >= buf_end) {
+			free(*ports);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		(*ports)[i] = atou(p);
+		p = strchr(p, '\0');
+	}
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

