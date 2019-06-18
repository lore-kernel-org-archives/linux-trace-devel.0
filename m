Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF71C31E5B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0C3220B1F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aJzo2JV4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729220AbfFROpJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:45:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34709 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbfFROpJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:45:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id k11so14325944wrl.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X+Hz2EPVoOdBKe7cNsysbubtcYMpmZGOKbW6o+rU0hQ=;
        b=aJzo2JV4v3XRVsz3YeHg64p0OVdPhRLYKdhr/CovTHA6B7pvtVvlR93rCYa/DAuum4
         wlvKE36zb8qKkCdtB3vV+F4lXELEHwbmQr4wylM9lSTz5tuCf+mBxSfPlj/tYg0QgDiV
         yOwzlgxXSGFWvZ63PBMrs41BLeGenJNjVlrjFUQCaYFa4NGsuudKsAW2cEfb/vsVUHm4
         DBAz253lHrsGpHFcPDF3qwgiiRScxjGqKyU7uGIsNWC0Ra3x3VITUBKO04iaEoDwFrSt
         UeuewIbSpXFKhWcDr4BkSG8srrVqaOFBnuAiBzWJUI1q/QE97lRpvqgSCCkZqyliYzOx
         l/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X+Hz2EPVoOdBKe7cNsysbubtcYMpmZGOKbW6o+rU0hQ=;
        b=fYvEVW3dZxtV0wdFIT/eg6MSAGkqd8vItpRqxQmmBE/CsRp2FK2P7MfST1dONkhFag
         n+2oE4dXJ5PkKdWxH/dqGfZkf9Qz/XefK8CjCteDgYfXs3jqli0dMbGeNQvgog6A7tb6
         +5irPSqz8zA5jyWHYHed5N+6EiT7ZwEEFITnF4MMCnHeouF7wbE95ue7OGVsG0YcL2aA
         5wLXOE3dOzFr8w9vpS1fMUkepRIyIcxreCI3MQwq3alvPDfhxnu/aXrqgj582DArYt9x
         cQZ83dKTuFaKLFkDVhocczB+rbBWrUQ5unxZeZ49D0cC9QRltqJT0GfO+Wf0mPaRKSjA
         55vg==
X-Gm-Message-State: APjAAAV+BcGHBLc4xThm+84NPZZyCSjJYz6orhcrR18EEE4CGUt1oXt5
        l3aP9sDZBJG7tZZSobeYmQ==
X-Google-Smtp-Source: APXvYqyK7R8av6FGRT3dRMmGXag7Y+nUrtCop2IdYyse6XTpr2MEpE/+p4HUkUw2diLmwTFJZpXiSg==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr15971652wre.283.1560869106411;
        Tue, 18 Jun 2019 07:45:06 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r3sm17686071wrr.61.2019.06.18.07.45.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:45:05 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 04/13] trace-cmd: Add VM tracing protocol messages
Date:   Tue, 18 Jun 2019 17:44:46 +0300
Message-Id: <20190618144455.3954-5-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
References: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Slavomir Kaslev <kaslevs@vmware.com>

Add TRACE_REQ and TRACE_RESP messages used for initiating guest VM tracing and
CLOSE_RESP message used for acknowledging stop recording request.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h |  14 ++
 tracecmd/trace-msg.c          | 234 +++++++++++++++++++++++++++++++++-
 2 files changed, 245 insertions(+), 3 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 28b5b38..db5baa8 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -324,7 +324,9 @@ int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 			       const char *buf, int size);
 int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
+int tracecmd_msg_send_close_resp_msg(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle);
+int tracecmd_msg_wait_close_resp(struct tracecmd_msg_handle *msg_handle);
 
 /* for server */
 int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle);
@@ -335,6 +337,18 @@ int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd);
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
index 74c0bc1..69c7c5f 100644
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
@@ -71,7 +83,10 @@ struct tracecmd_msg_header {
 	C(RINIT,	2,	sizeof(struct tracecmd_msg_rinit)),	\
 	C(SEND_DATA,	3,	0),					\
 	C(FIN_DATA,	4,	0),					\
-	C(NOT_SUPP,	5,	0),
+	C(NOT_SUPP,	5,	0),					\
+	C(TRACE_REQ,	6,	sizeof(struct tracecmd_msg_trace_req)),	\
+	C(TRACE_RESP,	7,	sizeof(struct tracecmd_msg_trace_resp)),\
+	C(CLOSE_RESP,	8,	0),
 
 #undef C
 #define C(a,b,c)	MSG_##a = b
@@ -103,6 +118,8 @@ struct tracecmd_msg {
 	union {
 		struct tracecmd_msg_tinit	tinit;
 		struct tracecmd_msg_rinit	rinit;
+		struct tracecmd_msg_trace_req	trace_req;
+		struct tracecmd_msg_trace_resp	trace_resp;
 	};
 	char					*buf;
 } __attribute__((packed));
@@ -625,6 +642,14 @@ int tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle)
 	return tracecmd_msg_send(msg_handle->fd, &msg);
 }
 
+int tracecmd_msg_send_close_resp_msg(struct tracecmd_msg_handle *msg_handle)
+{
+	struct tracecmd_msg msg;
+
+	tracecmd_msg_init(MSG_CLOSE_RESP, &msg);
+	return tracecmd_msg_send(msg_handle->fd, &msg);
+}
+
 int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 			   const char *buf, int size)
 {
@@ -745,7 +770,7 @@ int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 	return tracecmd_msg_wait_close(msg_handle);
 }
 
-int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle)
+static int tracecmd_msg_wait_for_cmd(struct tracecmd_msg_handle *msg_handle, enum tracecmd_msg_cmd cmd)
 {
 	struct tracecmd_msg msg;
 	int ret = -1;
@@ -756,7 +781,7 @@ int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle)
 		if (ret < 0)
 			goto error;
 
-		if (ntohl(msg.hdr.cmd) == MSG_CLOSE)
+		if (ntohl(msg.hdr.cmd) == cmd)
 			return 0;
 
 		error_operation(&msg);
@@ -771,3 +796,206 @@ error:
 	msg_free(&msg);
 	return ret;
 }
+
+int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle)
+{
+	return tracecmd_msg_wait_for_cmd(msg_handle, MSG_CLOSE);
+}
+
+int tracecmd_msg_wait_close_resp(struct tracecmd_msg_handle *msg_handle)
+{
+	return tracecmd_msg_wait_for_cmd(msg_handle, MSG_CLOSE_RESP);
+}
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
+		if (p >= buf_end || tatou(p, &(*ports)[i])) {
+			free(*ports);
+			ret = -EINVAL;
+			goto out;
+		}
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
2.20.1

