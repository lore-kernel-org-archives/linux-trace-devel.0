Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EF1C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 15:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE190218B0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 15:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbfCVPBN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 11:01:13 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41085 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbfCVPBN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 11:01:13 -0400
Received: by mail-wr1-f68.google.com with SMTP id p1so2692744wrs.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Mar 2019 08:01:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GwKFSb5Dlmi95/oLJsm99XOH/9yCmW4wLKgPb+NMWwY=;
        b=OfZVjxDZyca7Y3c5va4IjvNLw+JgJLLe8Be+g9gzPaVSMeVUNZK1C4jt1B/A670FSJ
         53zAIznjG2ljKOevGd/S1l1cjW3V7G6JPeC/z7t2QfzwrVCp/CWx5yN1zpuZq3UQMTnv
         7t0n4AdBhrJktGslHhQddY3O/0/30EyqfR1mrRaUbFfKPa6hZGCn1akaYJ3pPhM51DCh
         YKLOSfKBn1DfAYddk0UpeSLJQw3KQggys+xttv3voAr3M8v0xSq5YtmnMQVWY/sag22K
         Ru0wjXXVFtDofNir6knuaYPgRnaeky4WUdb+V5ror/UWZoX4xzckepKKaAyd7ypQ10LH
         ZxoA==
X-Gm-Message-State: APjAAAVDrUSOmSscDAT83kvNYvkS/Sr4YsXb4r0dWBpQ8hQOqZ3XEgKC
        uLUEu5XtmcIKMHsmCQAdBQ==
X-Google-Smtp-Source: APXvYqyvFvOF0+lCH8kMtSfYH05vkr+Lh506z6ESMw3YMVsY/WLVtXnAL9MTWPHbBZKwL/kqAVJN7g==
X-Received: by 2002:adf:e443:: with SMTP id t3mr7189284wrm.257.1553266871576;
        Fri, 22 Mar 2019 08:01:11 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f11sm4543522wrm.30.2019.03.22.08.01.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Mar 2019 08:01:10 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [PATCH] trace-cmd: Change tracecmd_msg's buf member type to char *
Date:   Fri, 22 Mar 2019 17:01:05 +0200
Message-Id: <20190322150105.24136-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Now that the buffer for protocol V3 messages is always text, it makes sense to
have it declared as such and drop a few casts.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-msg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index a91b211..9a27141 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -104,7 +104,7 @@ struct tracecmd_msg {
 		struct tracecmd_msg_tinit	tinit;
 		struct tracecmd_msg_rinit	rinit;
 	};
-	void					*buf;
+	char					*buf;
 } __attribute__((packed));
 
 static int msg_buf_len(struct tracecmd_msg *msg)
@@ -436,7 +436,7 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 		goto error;
 	}
 
-	if (((char *)msg.buf)[buf_len-1] != '\0') {
+	if (msg.buf[buf_len-1] != '\0') {
 		ret = -EINVAL;
 		goto error;
 	}
@@ -448,7 +448,7 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 		goto out;
 	}
 
-	buf_end = (char *)msg.buf + buf_len;
+	buf_end = msg.buf + buf_len;
 	for (i = 0, p = msg.buf; i < cpus; i++, p++) {
 		if (p >= buf_end) {
 			free(ports);
@@ -555,12 +555,12 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 	if (buf_len == 0)
 		goto no_options;
 
-	if (((char *)msg.buf)[buf_len-1] != '\0') {
+	if (msg.buf[buf_len-1] != '\0') {
 		ret = -EINVAL;
 		goto error;
 	}
 
-	buf_end = (char *)msg.buf + buf_len;
+	buf_end = msg.buf + buf_len;
 	options = ntohl(msg.tinit.opt_num);
 	for (i = 0, p = msg.buf; i < options; i++, p++) {
 		if (p >= buf_end) {
-- 
2.19.1

