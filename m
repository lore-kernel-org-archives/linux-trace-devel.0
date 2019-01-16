Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750DDC43387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 13:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4432F206C2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 13:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393195AbfAPNn1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 08:43:27 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53981 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390606AbfAPNn0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 08:43:26 -0500
Received: by mail-wm1-f65.google.com with SMTP id d15so2028046wmb.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Jan 2019 05:43:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T9HjdvgaJF6PBPV6Si/8FnQfnGxz8wksS6OUCM3jlew=;
        b=G899P/U073vY8rOo1xTMknTzdiiWxS04rnOQeJP99+zAfqmknB+RJZ6i+5h0YNSKk8
         yNqro4ahOVwTJSErpU2AWKzLQ9KreP6LgeQZiMUjJ0uCwFnNYtsL5t0zG6Bjio8omeI3
         8Sq4ZT2LI+oGkKZ0zphX7KM441u5hkBlPLrpOAap2LsPjQKI26L1YwgXRFXI4DxrCJ9F
         M18Wehglkk8wqM4iJnP6gn3YghWDX+fKAvQUm4bePN1GFG9LYXIyfo2msBVmW/m8VMLn
         rDjDNIRzI+yjMhAmkeYNZi5YHYYwqWbTuRMJIwNyObyJ+NEms6qAFmBk3n/kobrE62AG
         NhZA==
X-Gm-Message-State: AJcUukf93W+g7vqhJqC2AzVg2M5iKLVtdZ+o655F74of0oWednu/xRsT
        UQCZ0yNPAisJnaKOnOWL0Ds6Zc0/mLDP
X-Google-Smtp-Source: ALg8bN7L5mFCYrK3aEu8LmftWlOCgTxTUsHgjGQut7C5XGCUfCTdyLyb07LyKKSY346AoJ6WDFiAAQ==
X-Received: by 2002:a1c:1383:: with SMTP id 125mr7908464wmt.71.1547646204005;
        Wed, 16 Jan 2019 05:43:24 -0800 (PST)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y13sm34636460wme.2.2019.01.16.05.43.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 05:43:23 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v4 5/8] trace-cmd: Add TRACE_REQ and TRACE_RESP messages
Date:   Wed, 16 Jan 2019 15:43:04 +0200
Message-Id: <20190116134307.4185-6-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190116134307.4185-1-kaslevs@vmware.com>
References: <20190116134307.4185-1-kaslevs@vmware.com>
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
 include/trace-cmd/trace-cmd.h |  14 +++
 tracecmd/trace-msg.c          | 206 +++++++++++++++++++++++++++++++++-
 2 files changed, 219 insertions(+), 1 deletion(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 8b43462..238e16b 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
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
index 529ae2a..46b18aa 100644
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
@@ -715,3 +730,192 @@ error:
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
+		ret = tracecmd_msg_wait_for_msg(msg_handle->fd, &msg);
+		msg_free(&msg);
+
+		if (ret == -ECONNABORTED)
+			return 0;
+		if (ret < 0)
+			return ret;
+	}
+
+	return -1;
+}
-- 
2.19.1

