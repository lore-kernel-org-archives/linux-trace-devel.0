Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D2EC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AEFE23118
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbhAGQQs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbhAGQQr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 11:16:47 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57892C0612F8
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 08:16:07 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id 6so10461966ejz.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 08:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jmkMu/QYHXmGG1seImCzj9Y70IrC/yFLNCWMankBDtA=;
        b=f2O982BB4k4CKUOGjrbE/2HUj6bj5MCpcojolL4HKWn9cXNVFl4s568ytveCgbWkqy
         0AHyq07MYC2Bw1eFS2sLTl+vIuSi55Ob+8E3LC4yT11mzlX6u/BsgKul55VP2mMFmL5f
         +CuAcHrc3oaIeYKkbTHIj3BB0d88EdYQ2SdEHUSerW6gPAslUPSRWf7xlBdC+5IMm59Z
         83CKeKFe6kpssrnLmmcPxIG14irnS1YKLF8wfKQj+oPxBYU+uOF4AshwQKBcF7DnSx6p
         g7htqJyL9K1fmv4/J6ZdhTCIIzk7Uh3U3id+rwp3lFx1lxo5SDdAhfWr2TqcOcprCXad
         vtWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jmkMu/QYHXmGG1seImCzj9Y70IrC/yFLNCWMankBDtA=;
        b=bVwZ3/8e6TxsEyUkIgK+nWybHebpRxR44oD3cNLKhT2JCU9kEWgIS/PseG27Ik776f
         MNwuijSPY7em9l46OGak0BMgUSvz10nW7fNOfVnMmFFct7xryHiFE9vC67W/R+P9IIGi
         wIXMo5W0tPRV0lzbUMpg7pspM43/bqez4TmFT4/NxS1uKkN0K2XjlI8liYPB5bVxcfN/
         mR+EOBg7fdvRqVrN6jqkeUDCHlYdQhQKa0Lsu/fFhraUv5t2AagvG8CE/6Po12N6vwp+
         7dpR1kpuQl6YJDObpqho05iVvg9kQ7xnvntgAgiLk1Mshtb7GRbIu5zFxig3ZDxVTOB8
         4f/g==
X-Gm-Message-State: AOAM532gsSvdtWpHTE+NgksvOlA4GE/neQ4BoFmHopZqwUlLP/1uhCRI
        Cyn+Z3mprnG4DstxWE+1SIM=
X-Google-Smtp-Source: ABdhPJzySOy6u/O/4VWh0YV/QtWgX/tfECW0potYWHnOJo2el3Bc4jupJ2bFc/Ck6GinYfKx8Z3Ekg==
X-Received: by 2002:a17:906:3fc4:: with SMTP id k4mr6628770ejj.137.1610036166111;
        Thu, 07 Jan 2021 08:16:06 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id j23sm2846212edv.45.2021.01.07.08.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 08:16:05 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/6] kernel-shark: Add KS_DEFINE_PLUGIN_CONTEXT macro
Date:   Thu,  7 Jan 2021 18:15:44 +0200
Message-Id: <20210107161547.207270-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107161547.207270-1-y.karadz@gmail.com>
References: <20210107161547.207270-1-y.karadz@gmail.com>
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

