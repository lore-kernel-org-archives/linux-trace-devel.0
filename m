Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EBABC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 070E423118
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:16:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbhAGQQp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbhAGQQp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 11:16:45 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E278DC0612F5
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 08:16:04 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cw27so8288400edb.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 08:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PMw4L2ve2WxqUYu8kFltnlB64JiUbb7s0LJmU4h7gPk=;
        b=Nom3bQSraGJR+y1ktvSMAEeBTpXAWP0c66TQJR8O/PZF1/By8+uuF0xjDHHNbBFo2W
         WIr/znP6N27sBBXeRQ6Y/Pai7ogc9rPwEcrkQt3xW1ScV4Zn6WMuFlFdAx2IIF+foSJ9
         3RhZaY7V7HYHG9i8y6yuWpwCWR33K/eBnEBZhtqvtVXVhUpwNY9B/dPZMuPw35InCKxj
         61kJx9LrLzLQpUpRDvrBDB8bI3/6OuTbNkoEHyWn9ZwwdNVpmVNFbUAhsBh4nP/rQMXQ
         1l3VAma7eCQybDKpOtMZvb1bjejXxIe5uPn4lO2gJ2v7wmNNiGfguPoDKw6UFuR08LyV
         WwcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PMw4L2ve2WxqUYu8kFltnlB64JiUbb7s0LJmU4h7gPk=;
        b=HUaoESgq13fYTE8UlPiumMQ5EJj8A+c/CWthocDnojdruA5LXfbemGEeibIM+FFGkJ
         g6PLO3LNT3Rm/B4kRf6uLKxxikfCnFIYoNrWnl6CNPDkMTFoDryryDHE1gL8bL6zlOJ+
         TlMESQX/lo0pLlGFdk27bpcGUAsEm82GzJ6mid0+V2yYH21bsfXv+8hZ+tZHqbkEY+Kr
         6pV5xJMDcZOtTA5JapY5aOqg80YdAmSHZY8TFHm3KgNNVONu6Tc52C2+Dn2ZJsDkzv9H
         U01PrfRWGEgnjTOgUFWIP+LRTDSr9Mp/DKzpHbF4Z5ferZjeME0d2PqrzrsCLPll2y0D
         tJhw==
X-Gm-Message-State: AOAM532wj+/Cc4hDgOvzNy95GMCLSyDFyHP0+6gUM6pa+rQp2dzg6Izs
        0Gogah4Lu7UD5lAtHzGCyZah0lKlayIaTg==
X-Google-Smtp-Source: ABdhPJz3ylAF8w5pEsLdkME9BPi/dpEClCa0F3W0UX2OPCCWRQYUftgQMnxaJkXoHCEiUVBXFQFugQ==
X-Received: by 2002:a05:6402:17cb:: with SMTP id s11mr2130147edy.119.1610036163672;
        Thu, 07 Jan 2021 08:16:03 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id j23sm2846212edv.45.2021.01.07.08.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 08:16:03 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/6] kernel-shark: Add KS_DOUBLE_SIZE macro
Date:   Thu,  7 Jan 2021 18:15:42 +0200
Message-Id: <20210107161547.207270-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107161547.207270-1-y.karadz@gmail.com>
References: <20210107161547.207270-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The macro is useful for resizing of dynamic arrays. It is currently
used to resize the Data stream descriptor array, owned by the session
context. We will later use the macro with the arrays of data fields and
plugin contexts.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-plugin.h    | 17 +++++++++++++++++
 src/libkshark.c           | 11 ++---------
 tests/libkshark-tests.cpp | 20 ++++++++++++++++++++
 3 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
index 1a642ad..4104357 100644
--- a/src/libkshark-plugin.h
+++ b/src/libkshark-plugin.h
@@ -346,6 +346,23 @@ int kshark_handle_dpi(struct kshark_data_stream *stream,
 int kshark_handle_all_dpis(struct kshark_data_stream *stream,
 			   enum kshark_plugin_actions  task_id);
 
+/** General purpose macro for resizing dynamic arrays. */
+#define KS_DOUBLE_SIZE(array, size)					\
+({									\
+	ssize_t __n = size;						\
+	bool __ok = false;						\
+	__typeof__(array) __tmp =					\
+		(__typeof__(array)) realloc(array,			\
+					    2 * __n * sizeof(*__tmp));	\
+	if (__tmp) {							\
+		memset(__tmp + __n, 0, __n * sizeof(*__tmp));		\
+		size = 2 * __n;						\
+		array = __tmp;						\
+		__ok = true;						\
+	}								\
+	__ok;								\
+})									\
+
 #ifdef __cplusplus
 }
 #endif // __cplusplus
diff --git a/src/libkshark.c b/src/libkshark.c
index 315c24f..0e2ce7a 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -234,16 +234,9 @@ int kshark_add_stream(struct kshark_context *kshark_ctx)
 
 	if (kshark_ctx->stream_info.next_free_stream_id ==
 	    kshark_ctx->stream_info.array_size) {
-		size_t new_size = 2 * kshark_ctx->stream_info.array_size;
-		struct kshark_data_stream **streams_tmp;
-
-		streams_tmp = realloc(kshark_ctx->stream,
-				      new_size * sizeof(*kshark_ctx->stream));
-		if (!streams_tmp)
+		if (!KS_DOUBLE_SIZE(kshark_ctx->stream,
+				    kshark_ctx->stream_info.array_size))
 			return -ENOMEM;
-
-		kshark_ctx->stream = streams_tmp;
-		kshark_ctx->stream_info.array_size = new_size;
 	}
 
 	stream = kshark_stream_alloc();
diff --git a/tests/libkshark-tests.cpp b/tests/libkshark-tests.cpp
index 27c1171..d0a3594 100644
--- a/tests/libkshark-tests.cpp
+++ b/tests/libkshark-tests.cpp
@@ -46,3 +46,23 @@ BOOST_AUTO_TEST_CASE(add_remove_streams)
 
 	kshark_close_all(kshark_ctx);
 }
+
+#define ARRAY_DEFAULT_SIZE	1000
+BOOST_AUTO_TEST_CASE(doule_size_macro)
+{
+	int i, n = ARRAY_DEFAULT_SIZE;
+	int *arr = (int *) malloc(n * sizeof(*arr));
+	bool ok;
+
+	for (i = 0; i < n; ++i)
+		arr[i] = i;
+
+	ok = KS_DOUBLE_SIZE(arr, n);
+	BOOST_CHECK_EQUAL(ok, true);
+	BOOST_CHECK_EQUAL(n, ARRAY_DEFAULT_SIZE * 2);
+
+	for (i = 0; i < ARRAY_DEFAULT_SIZE; ++i)
+		BOOST_CHECK_EQUAL(arr[i], i);
+	for (; i < n; ++i)
+		BOOST_CHECK_EQUAL(arr[i], 0);
+}
-- 
2.25.1

