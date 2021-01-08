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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163FEC433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Jan 2021 14:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1470238A1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Jan 2021 14:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbhAHOci (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Jan 2021 09:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbhAHOci (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Jan 2021 09:32:38 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2849C0612FD
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Jan 2021 06:31:57 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id g20so14854699ejb.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Jan 2021 06:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yg4a6WHkBJ0hMjF08qLfqPtBOBjR46qQKfEisVK0WdU=;
        b=gVAdrSQU3CMcolZncpzjW/IcY5zgHj0UMbv7AC/1Hae61kb0IqfEEYqx3NfjUgtJaS
         5Nhvh4ilzTnhNe1zuV33z8pV7tEMrp/RjFZhBbGN7FoutdX8ZsDiK3Cao9cPLoZskOlB
         Q2Fos/iSyVrenw5U5XE63T99SUneB9ku04i8S+tuuay1E6pn3+wcn1B06YnAcHSDD3ki
         9ca3mkCDahoXBo2YHPrt3FnVcUWxLo2+J8w+EAMoeIaOXjgzEIcMTfbidC1lmL/ayvyL
         SlaEfwiV2uPctpozW76J1zFVBSGUz8tii2Kn50sPktKgwIpnxaMnmrVsMr/J4N7WLw3E
         SSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yg4a6WHkBJ0hMjF08qLfqPtBOBjR46qQKfEisVK0WdU=;
        b=aUoF01FLPwJdMyglECmoTQVqdPn3WAPIQiL1SyY4fJlBo1lHryw1XhGPKw42NlO62H
         yUEkfq6s+2Qu8FaPdRb1qPLLpT/zTYktKFF3OFIa6OpIgLhov8L9sKt6sLpvT1FQIHza
         k+jPbd/GOyjq3o4OZjw4OYyn7FzvdHZ921Z/3c9uTvPEVJD5/NclNs1WWwa/s1NbL2VI
         NlkOtuqy7WDCyCvZSDeQY7oWcW7nAvBWH/l49aso1WM3GorOVn9gzBg7uuElJBvau3p8
         nvis075qSxMNLuhcThjeLbGh89B8LeJRtgEzktFhd4fteE0sEspGB+/Uvm/JuD1pnoIr
         hNLQ==
X-Gm-Message-State: AOAM530yr9zJPbZvNpnK5X7VUrWaY4leA/hzUE28NkhwfdhXfObs8GzL
        6K8B4My4HeaAW86Xj/Qd0F96HhfnaV8wDw==
X-Google-Smtp-Source: ABdhPJyeNIHtR+jbYYNtkmSJBWELaXN0fgNDOd0SoFkYj5xon0V5E0Ii2zj3Vj2d2WWIJa0uAUAaqw==
X-Received: by 2002:a17:906:358e:: with SMTP id o14mr2765986ejb.526.1610116316707;
        Fri, 08 Jan 2021 06:31:56 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id d13sm3588120ejc.44.2021.01.08.06.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 06:31:56 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 3/6] kernel-shark: Add KS_DEFINE_PLUGIN_CONTEXT macro
Date:   Fri,  8 Jan 2021 16:31:37 +0200
Message-Id: <20210108143140.285037-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108143140.285037-1-y.karadz@gmail.com>
References: <20210108143140.285037-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When we implement a KernelShark plugins, we often need a way to define
a structure that can hold context data that is visible only inside the
plugin and that has specific values for each data stream. The tricky
part here is that the total number of data streams and the IDs of the
active streams are dynamic quantities that can change as the user adds
or removes data streams. The macro defines an interface of functions
that will be useful for the plugin developer, helping to directly use
context objects, without caring for the complications due to the dynamic
configuration of active data streams.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-plugin.h    | 41 +++++++++++++++++++++++++++++++++++++++
 tests/libkshark-tests.cpp | 32 ++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
index 4104357..c62086f 100644
--- a/src/libkshark-plugin.h
+++ b/src/libkshark-plugin.h
@@ -363,6 +363,47 @@ int kshark_handle_all_dpis(struct kshark_data_stream *stream,
 	__ok;								\
 })									\
 
+/** General purpose macro defining methods for adding plugin context. */
+#define KS_DEFINE_PLUGIN_CONTEXT(type)					\
+static type **__context_handler;					\
+static ssize_t __n_streams = -1;					\
+static inline type *__init(int sd)					\
+{									\
+	type *obj;							\
+	if (__n_streams < 0 && sd < KS_DEFAULT_NUM_STREAMS) {		\
+		__context_handler =					\
+			(type **) calloc(KS_DEFAULT_NUM_STREAMS,	\
+					 sizeof(*__context_handler));	\
+		if (!__context_handler)					\
+			return NULL;					\
+		__n_streams = KS_DEFAULT_NUM_STREAMS;			\
+	} else if (sd >= __n_streams) {					\
+		if (!KS_DOUBLE_SIZE(__context_handler,			\
+				    __n_streams))			\
+			return NULL;					\
+	}								\
+	assert(__context_handler[sd] == NULL);				\
+	obj = (type *) calloc(1, sizeof(*obj));				\
+	__context_handler[sd] = obj;					\
+	return obj;							\
+}									\
+static inline void __close(int sd)					\
+{									\
+	if (sd < 0) {							\
+		free(__context_handler);				\
+		__n_streams = -1;					\
+		return;							\
+	}								\
+	free(__context_handler[sd]);					\
+	__context_handler[sd] = NULL;					\
+}									\
+static inline type *__get_context(int sd)				\
+{									\
+	if (sd < 0 || sd >= __n_streams)				\
+		return NULL;						\
+	return __context_handler[sd];					\
+}									\
+
 #ifdef __cplusplus
 }
 #endif // __cplusplus
diff --git a/tests/libkshark-tests.cpp b/tests/libkshark-tests.cpp
index 8a5dcf1..780a3fa 100644
--- a/tests/libkshark-tests.cpp
+++ b/tests/libkshark-tests.cpp
@@ -10,6 +10,7 @@
 
 // KernelShark
 #include "libkshark.h"
+#include "libkshark-plugin.h"
 
 #define N_TEST_STREAMS	1000
 
@@ -103,3 +104,34 @@ BOOST_AUTO_TEST_CASE(fill_data_container)
 
 	kshark_free_data_container(data);
 }
+
+struct test_context {
+	int a;
+	char b;
+};
+
+KS_DEFINE_PLUGIN_CONTEXT(struct test_context);
+
+BOOST_AUTO_TEST_CASE(init_close_plugin)
+{
+	struct test_context *ctx;
+	int i;
+
+	for (i = 0; i < N_TEST_STREAMS; ++i) {
+		ctx = __init(i);
+		ctx->a = i * 10;
+		ctx->b = 'z';
+	}
+
+	for (i = 0; i < N_TEST_STREAMS; ++i) {
+		ctx = __get_context(i);
+		BOOST_REQUIRE(ctx != NULL);
+		BOOST_CHECK_EQUAL(ctx->a, i * 10);
+		BOOST_CHECK_EQUAL(ctx->b, 'z');
+
+		__close(i);
+		BOOST_REQUIRE(__get_context(i) == NULL);
+	}
+
+	__close(-1);
+}
-- 
2.25.1

