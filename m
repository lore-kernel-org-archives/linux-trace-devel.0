Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA093C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 16:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B42CA218FC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 16:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfCVQ0n (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 12:26:43 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39671 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfCVQ0n (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 12:26:43 -0400
Received: by mail-wr1-f66.google.com with SMTP id j9so3019635wrn.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Mar 2019 09:26:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QZ/7CfeXt0kUrsIbLgDnuLkiJeWiy9LZwePZATfHztA=;
        b=WKOjc4LX36WQDOxjgE0cmzSfRLm6th3eFdFAHIr9lvdN7y566xB5U3M7D8MxYCENxb
         lG3kHhPWk9CvroPAQXaCWTVq3/vHp/UbXUjRM74o1oCls1RNov0q4jfBr56/xaHl3nDD
         LFhobSQ9CxEGwlWf+Y3TggSc0yu937QpUmpDhIlXGTFYVUjcJrw+RAzSnZdjF9Wdik0K
         oWaebyBjcvDZz03FgULteM5jW1BxbJTSvEs3pt3NVhT199BfBnSZojdVPkzNhGeO6hfk
         E752ChRB7Fh2iTpJ08Ysb2IOzURX6+UcJ1Za1soqvx19H78Tr89cQG7oQKukNQPAGXkN
         ztQg==
X-Gm-Message-State: APjAAAVkUw8HUHL8NPDXdHo4JMg7H88QHw5X9F6scng2QI+jUMZR5pMU
        mtanhghSqCD0hSFDcs0GIw==
X-Google-Smtp-Source: APXvYqzvZUJIN3vtXiblaaIDn4EyrNhdDhJd/fqOXYupXbQAyrL1JwfMgh9sdYwH2gL3EFWyK4+7og==
X-Received: by 2002:a5d:4e82:: with SMTP id e2mr7415911wru.164.1553272001220;
        Fri, 22 Mar 2019 09:26:41 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y1sm13643789wrd.34.2019.03.22.09.26.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Mar 2019 09:26:40 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [PATCH] trace-cmd: Change tracecmd_msg's buf member type to char *
Date:   Fri, 22 Mar 2019 18:26:35 +0200
Message-Id: <20190322162635.30689-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Now that all protocol V3 messages (besides SEND_DATA) use the buffer for text,
it makes sense to have it declared as such and drop a few casts.

This also takes care of undefined behavior caused by void pointer arithmetic in
tracecmd_msg_data_send()/tracecmd_msg_read_data().

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

