Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5009BC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED96664E92
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhBKKfQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhBKKdD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:33:03 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB392C0613D6
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:22 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id p20so9278137ejb.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cVWQshYHmRecjva6Hux0++8NiD47FE2oRBIZvYkMseM=;
        b=fT6pzhRQVY5BK2ZUGvL6pdA0PrWaZyFUiOaor9fzwTAT4DbpfADyt9+ho4zJUJzGIs
         yain+ic3MSTDhmWyzKBFdW1jcAb801x8Enujj/1SYIa9TnSOOu2Iu79Nq2nEL5lhL12r
         n7NWXRqcbF+7CrYSLZ6EvdGhvgOpcLABHSzOgPJE+rg9i+H90+JT/rgPtNWiSvzBkYSw
         46lhlvRpA6sNuCS1ZJntV7YLYALqlK3LAjbFTimJ9bxT7On9ZS3c84OK25AWQKvnP+Bm
         qz3tPEIp702x8wnddZ2skUB9tRjHVHmpVJtI5FUoENoW0Vw+L6Hi94QIGv9JmVuYMPwk
         9yMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cVWQshYHmRecjva6Hux0++8NiD47FE2oRBIZvYkMseM=;
        b=ZbJy2bfwmh6+t39fjU042ZTkkSUKRI7ldg2KDc2aJmJKcOAxjRxp2GV1KoMhDBG8Fo
         VZog3WzEy61/vzNCic4utg/YnDBZZiEHU0uVboiRWV0NfbldybfQca4XZAS8Ht4sTlNl
         A62a7AKkSSXxubEVq4FwJ66PKRtwSSjy7fUr3dvtJTx+mtr2bubVPa+GgxHXoG6SeVsI
         Y2OFzsjkm7SIULuauzflnatNSV+X/KTzeM98DNd+QOFE7VRGdHvTtf4M9/ZNlVF4IaMb
         r0itqV/pIuE3ms6UtiiO/YoKigdilNdQwAPAQHy9dWSxxInzHiIezeFk/k2kqen78vXD
         WRkA==
X-Gm-Message-State: AOAM530Gwy/DwyYq+nE8czwLrA9l8Fogq6Wq8UCRE/CknmjeayWeBa/4
        eDNnYM/TlOqzftq0PAcMijRr16P3YFQ=
X-Google-Smtp-Source: ABdhPJwmZwG/gNhm0E514gQDWCg28Lx1cZ0nBkolzFWnCGyYi+9gJcnhYDyqLokavBWlUHJQkAkSKg==
X-Received: by 2002:a17:906:3acc:: with SMTP id z12mr8097240ejd.494.1613039541454;
        Thu, 11 Feb 2021 02:32:21 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:21 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 01/27] kernel-shark: Add get_stream_object()
Date:   Thu, 11 Feb 2021 12:31:39 +0200
Message-Id: <20210211103205.418588-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In a previous patch we modified kshark_get_data_stream() to return
NULL in the case when the kshark_data_stream object does not own
a data processing interface. This was motivated by the idea that
kshark_get_data_stream() is supposed to be used to access only
successfully loaded data streams, which is not possible in the case
when the data processing interface is not initialized. However, this
creates a contradiction with the definition of the public method
kshark_add_stream(). This method adds a stream without initializing
its data processing interface. In this patch we add a static function
that returns the Data stream object, regardless of the existence of
the interface and we use this static function in all cases when the
existence of the interface is not guaranteed.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/src/libkshark.c b/src/libkshark.c
index a54fdd5..c57ca01 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -361,6 +361,17 @@ kshark_get_data_stream(struct kshark_context *kshark_ctx, int sd)
 	return NULL;
 }
 
+static struct kshark_data_stream *
+get_stream_object(struct kshark_context *kshark_ctx, int sd)
+{
+	if (sd >= 0 && sd <= kshark_ctx->stream_info.max_stream_id)
+		if (kshark_ctx->stream[sd] &&
+		    kshark_is_valid_stream(kshark_ctx->stream[sd]))
+			return kshark_ctx->stream[sd];
+
+	return NULL;
+}
+
 /**
  * @brief Get the Data stream object corresponding to a given entry
  *
@@ -443,7 +454,7 @@ int kshark_close(struct kshark_context *kshark_ctx, int sd)
 	struct kshark_data_stream *stream;
 	int ret;
 
-	stream = kshark_get_data_stream(kshark_ctx, sd);
+	stream = get_stream_object(kshark_ctx, sd);
 	if (!stream)
 		return -EFAULT;
 
@@ -1182,7 +1193,7 @@ bool kshark_filter_is_set(struct kshark_context *kshark_ctx, int sd)
 {
 	struct kshark_data_stream *stream;
 
-	stream = kshark_get_data_stream(kshark_ctx, sd);
+	stream = get_stream_object(kshark_ctx, sd);
 	if (!stream)
 		return false;
 
-- 
2.25.1

