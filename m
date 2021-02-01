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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E958C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2895164E54
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbhBARZC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbhBARYy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:24:54 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF44C06174A
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:14 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id f14so1337916ejc.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cVWQshYHmRecjva6Hux0++8NiD47FE2oRBIZvYkMseM=;
        b=oI9A6J6Jk+2xf916uVTFdGwLxxqIhbudfhQs3Xne5SJCS7Btxi/vg+J9Vqx75+e2s1
         CWS0FXPi25dd0BIrgfhVmXcIinU3cbQlRZatq2TmPfZG4guQ79MTPR5RMNyihKeX+vDp
         aADo43CL506nFDqATrJSl5FThwufnOfRKr9qHnM1G0bEcP2iN1rllFFcy0F6aAiPJI5o
         WapF2DUhd8Q3z1L/cPzAFhUOIfqG85dvtQ3haLnNm7xTliCqvH1TkYNwgLVX+fgQUk1s
         yoOiNSmxhDBOJfG8hG4POMUgQhbsgvMsFAbJ7PbGLjRcCmyuVKrxyOlFUm+aHOi6Eb+d
         MX0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cVWQshYHmRecjva6Hux0++8NiD47FE2oRBIZvYkMseM=;
        b=VXbdNwtD+oqFwJ/KVYvx9BBpp0RNer+5Lh2UCaEeD0gDYqo8YMEz8HK1epQcxBLZin
         Kfq+dkmrz8oqxbOewoZqHZQpGTgYIF1Zxyx1M/olNSF/vz4Fg+mjAzfzc67SIotPCRCb
         D1LxKwMLVpObNQWZzQUlfcyaRpJXqJHEUnleatY2LpwRahd3t2lXdLf6aybQXnetxl2k
         5zggzpCtwchZAeFQxF721lV7BKKXSDWucrTHvynt3OJxVXCsJ87iQTyGpB6DIVRc/wk3
         pxDIMS7QF3uvTWu/TjJLfkPubfpxYX0CXqlUPcFDVTxsgJuG/CpdYHpvgQy1q36wEjTD
         s9lg==
X-Gm-Message-State: AOAM5301N9ZwN7OlboxDcLNLUrDx9ij4SJuKhZEx342QibGO+9j00piT
        DqUnpeIXMx/+NJKNZXm/Myc=
X-Google-Smtp-Source: ABdhPJwZn6V9pJ1u9anr09UHZrFfnTGdC8X37bISn9f8fs0Hedw7nO182oXH493Jd9jZ8xEl7Eg+sQ==
X-Received: by 2002:a17:906:e203:: with SMTP id gf3mr18748896ejb.117.1612200252928;
        Mon, 01 Feb 2021 09:24:12 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:12 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 01/24] kernel-shark: Add get_stream_object()
Date:   Mon,  1 Feb 2021 19:23:35 +0200
Message-Id: <20210201172358.175407-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
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

