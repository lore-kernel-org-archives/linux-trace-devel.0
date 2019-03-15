Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486D2C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 15:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20BCA218A1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 15:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfCOPdh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 11:33:37 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34911 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbfCOPdg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 11:33:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id y15so6553830wma.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Mar 2019 08:33:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R4eouGmL1k26hbQaGQRboNDwcfQO95pMAck9nbQwCno=;
        b=UfcDrm7kdYgUhosLR+S9rxK94mfWVRCBIigRX0CFKmluLlYBGWRkVwQFxlo8IqKcNQ
         wG6TXAIRcj6o9ScqOJ+e7ghBRaQxDsM70I4xXxwCJeGkoJiMqdhMuHkFOeUzbknQ6Wcg
         OXbdRCHOsPugfd3sA2YH+LIsRdN2iw7/pUvAvX+ZAfjkzrO9PeF+xNH7C1+/k33/oxMm
         zVl9m2i/haRSkAUjwkEkldeOiN3be6zauOVE9X4kzInPzwQ5xQN6Ggj3IcBEfaW8N4r9
         RqkxP2YVPcKJ4EszyoE0gDK8VTGC3WyaDcjhmCfQsR1psJJs2og8klvtF8XeSmon9cg1
         km/g==
X-Gm-Message-State: APjAAAXPJV4FkC3kpuLtnwfo7J2ZvM+f1BMrXEI90qnKdv3ZPqoatJHB
        sKH+KRqffeX2hxbwUFyIruX7AMA=
X-Google-Smtp-Source: APXvYqyyGcgQ4mY6dmTAQJKHFzKF5IcCPMKBBZaaAtgLE29MkigF1vxXyQnyF3a2sgCwe3RlvljJUQ==
X-Received: by 2002:a7b:c14f:: with SMTP id z15mr2614933wmi.3.1552664014339;
        Fri, 15 Mar 2019 08:33:34 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a204sm2654221wmf.12.2019.03.15.08.33.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Mar 2019 08:33:33 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [PATCH 1/3] trace-cmd: Use text encoding for options in protocol V3
Date:   Fri, 15 Mar 2019 17:33:24 +0200
Message-Id: <20190315153326.5602-2-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190315153326.5602-1-kaslevs@vmware.com>
References: <20190315153326.5602-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Options are now encoded as text in the buffer at the end of protocol V3 messages.

Unrecognized options are logged and ignored by the listener to support adding
new options in the future.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-msg.c | 82 +++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 50 deletions(-)

diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 51d0ac8..4b43849 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -49,11 +49,6 @@ static inline void dprint(const char *fmt, ...)
 
 unsigned int page_size;
 
-struct tracecmd_msg_opt {
-	be32 size;
-	be32 opt_cmd;
-} __attribute__((packed));
-
 struct tracecmd_msg_tinit {
 	be32 cpus;
 	be32 page_size;
@@ -110,7 +105,6 @@ struct tracecmd_msg {
 		struct tracecmd_msg_rinit	rinit;
 	};
 	union {
-		struct tracecmd_msg_opt		*opt;
 		be32				*port_array;
 		void				*buf;
 	};
@@ -143,27 +137,17 @@ static int msg_write(int fd, struct tracecmd_msg *msg)
 	return __do_write_check(fd, msg->buf, data_size);
 }
 
-enum msg_opt_command {
-	MSGOPT_USETCP = 1,
-};
-
 static int make_tinit(struct tracecmd_msg_handle *msg_handle,
 		      struct tracecmd_msg *msg)
 {
-	struct tracecmd_msg_opt *opt;
 	int cpu_count = msg_handle->cpu_count;
 	int opt_num = 0;
 	int data_size = 0;
 
 	if (msg_handle->flags & TRACECMD_MSG_FL_USE_TCP) {
 		opt_num++;
-		opt = malloc(sizeof(*opt));
-		if (!opt)
-			return -ENOMEM;
-		opt->size = htonl(sizeof(*opt));
-		opt->opt_cmd = htonl(MSGOPT_USETCP);
-		msg->opt = opt;
-		data_size += sizeof(*opt);
+		msg->buf = strdup("tcp");
+		data_size += 4;
 	}
 
 	msg->tinit.cpus = htonl(cpu_count);
@@ -441,10 +425,10 @@ out:
 }
 
 static bool process_option(struct tracecmd_msg_handle *msg_handle,
-			   struct tracecmd_msg_opt *opt)
+			   const char *opt)
 {
-	/* currently the only option we have is to us TCP */
-	if (ntohl(opt->opt_cmd) == MSGOPT_USETCP) {
+	/* currently the only option we have is to use TCP */
+	if (strcmp(opt, "tcp") == 0) {
 		msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
 		return true;
 	}
@@ -475,15 +459,15 @@ void tracecmd_msg_handle_close(struct tracecmd_msg_handle *msg_handle)
 
 int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 {
-	struct tracecmd_msg_opt *opt;
 	struct tracecmd_msg msg;
+	char *p, *buf_end;
+	ssize_t buf_len;
 	int pagesize;
-	int options, i, s;
+	int options, i;
 	int cpus;
 	int ret;
-	int offset = 0;
-	u32 size;
 
+	memset(&msg, 0, sizeof(msg));
 	ret = tracecmd_msg_recv_wait(msg_handle->fd, &msg);
 	if (ret < 0) {
 		if (ret == -ETIMEDOUT)
@@ -512,38 +496,36 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 		goto error;
 	}
 
-	size = MSG_HDR_LEN + ntohl(msg.hdr.cmd_size);
+	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
+	if (buf_len < 0) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	if (buf_len == 0)
+		goto no_options;
+
+	if (((char *)msg.buf)[buf_len-1] != '\0') {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	buf_end = (char *)msg.buf + buf_len;
 	options = ntohl(msg.tinit.opt_num);
-	for (i = 0; i < options; i++) {
-		if (size + sizeof(*opt) > ntohl(msg.hdr.size)) {
-			plog("Not enough message for options\n");
+	for (i = 0, p = msg.buf; i < options; i++, p++) {
+		if (p >= buf_end) {
 			ret = -EINVAL;
 			goto error;
 		}
-		opt = (void *)msg.opt + offset;
-		offset += ntohl(opt->size);
-		size += ntohl(opt->size);
-		if (ntohl(msg.hdr.size) < size) {
-			plog("Not enough message for options\n");
-			ret = -EINVAL;
-			goto error;
-		}
-		/* prevent a client from killing us */
-		if (ntohl(opt->size) > MAX_OPTION_SIZE) {
-			plog("Exceed MAX_OPTION_SIZE\n");
-			ret = -EINVAL;
-			goto error;
-		}
-		s = process_option(msg_handle, opt);
+
 		/* do we understand this option? */
-		if (!s) {
-			plog("Cannot understand(%d:%d:%d)\n",
-			     i, ntohl(opt->size), ntohl(opt->opt_cmd));
-			ret = -EINVAL;
-			goto error;
-		}
+		if (!process_option(msg_handle, p))
+			plog("Cannot understand option '%s'\n", p);
+
+		p = strchr(p, '\0');
 	}
 
+no_options:
 	msg_free(&msg);
 	return pagesize;
 
-- 
2.19.1

