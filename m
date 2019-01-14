Return-Path: <SRS0=K4HJ=PW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A0DC43387
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jan 2019 15:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56D0120657
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jan 2019 15:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfANP2P (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jan 2019 10:28:15 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40653 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfANP2P (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jan 2019 10:28:15 -0500
Received: by mail-wr1-f68.google.com with SMTP id p4so23340151wrt.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jan 2019 07:28:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aBj0Ats+jVOEGerac8+191uHv0JCASOjPI3O6csj9Ok=;
        b=Mi7ed6+s3baHOrKh/DMbzHvRKHDhVPVyXXrGtb1XE9AcyYYysfW6srj446pzcfS8GK
         KQ5WnzazJl50DqewxgllSjOcMwONUW8a2lZolPfhbpcy3QjzQB8buhHpQfQ14TIeJ1x+
         4bHF2v9Sk4hXozpS5yrcuYj0KwE1X2vWxHyfCaE51LO+s4PTjHy7fSrnS+v/geGMbQWX
         PmSoTDr5lOoQsX0xZVhT9/V1YNMRYdmA0C4v/zkAFd+KsuxUSp0GJVm2OoHJCs8F1zsx
         FWd3mr8OFJW0WPNpFoqnTvBmxcvBxJ/K0of604UZ91Y44rxVvlhlOabHbSbeoD64L3bz
         Og/Q==
X-Gm-Message-State: AJcUukfMFC1gWLs8t0Fl3WIEn58XItXrgt1anUZtbsRULcLmx7pI3/K/
        BnZleAb022avH1hwE2xZGfTYvaZ7/Db0
X-Google-Smtp-Source: ALg8bN4WY5mFIEApkSdnXJuK7UuMcvuXKSm7WVP+FJW/1wklVNX1iq/zpiQ9FEIa6UHG4LjAzCAGJQ==
X-Received: by 2002:a5d:47d1:: with SMTP id l17mr24277152wrs.319.1547479692307;
        Mon, 14 Jan 2019 07:28:12 -0800 (PST)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a132sm34784167wmh.5.2019.01.14.07.28.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 07:28:11 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v3 4/6] trace-cmd: Add TRACE_REQ and TRACE_RESP messages
Date:   Mon, 14 Jan 2019 17:27:58 +0200
Message-Id: <20190114152800.31060-5-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190114152800.31060-1-kaslevs@vmware.com>
References: <20190114152800.31060-1-kaslevs@vmware.com>
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
 tracecmd/trace-msg.c          | 199 +++++++++++++++++++++++++++++++++-
 2 files changed, 210 insertions(+), 1 deletion(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index f0747c5..484340a 100644
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
index edde582..5173165 100644
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
@@ -715,3 +730,185 @@ error:
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

