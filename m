Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C19DC433E9
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 16:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EBD52312F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 16:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbhAFQMT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Jan 2021 11:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbhAFQMS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Jan 2021 11:12:18 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADCDC061359
        for <linux-trace-devel@vger.kernel.org>; Wed,  6 Jan 2021 08:11:38 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id b9so5842208ejy.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 06 Jan 2021 08:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AMfZqfEwANLhFci9bin94vClMQu8eTUomp2FFIpnm+w=;
        b=CoNhvOs2qisMQQcmUN+0IQ6D7s4o1GyxwWdhge2M8n+nz9sGsFIkOHuO3p/OQSOM8H
         nyg2z7tabIQj/CZXm37L/UQhB2XyPEvhwdg9cL8Hn3Jn3YyxX6gpHy4g18sl9CP4IYv9
         GUWSdU3BR4qAN1jXfpio6z2jnS9uDcVxHTbq7hLZiVaF2QYVNldRDRaUzpVCRmBbl5H3
         4FuLorQEx6AYQAMjSUi2nWEuqOEzNpLCIbkDIwTA+opGgKdEiGOnKh5qWfpN6xVe9t2/
         EoMsqS3fW0wbI2hPM4WIlDCsvABH1WVYVFCMwNAaEj1LU4EQBVpm0VEUg9WIi3iv6zju
         Av+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AMfZqfEwANLhFci9bin94vClMQu8eTUomp2FFIpnm+w=;
        b=EI6ON3i40axjckmM5jOnZhWC1k5BrJw9EzA8ZGVZMXoxKbo+7YiafAEWHuG4077+D+
         1aSbkflvMg9imMHaDkX8O1LDEUIV5Gm47OanWHkkANb2gnPgwMDuPou9BzFqNOI9D5rx
         j2gQ9uLcaPTiMGBB8YERatS1tfgEMmI+gmBVt4aWkSmZmbnC08+FpfAWqHIA2RTZI1ol
         aihNj1ArVbdKiexVuqJyf1OUAvPHFvq3Pr/0iQqHW0LsLVkiF1AOMtof7cpgTMhRH2Ly
         eXQ0n+qThC1O9mDKu7+3PhGQEpPNPdt9tVlowPq6NeKNRi0SYhfNdsg8k/PpeDGiJn7D
         v5uw==
X-Gm-Message-State: AOAM531BGdE0ZxgoH9DjXaJZiXDK85Z8viLPlMhlntTec/lb4lddncxz
        TXbf+LENRoXsTxUQXFUcDFQ=
X-Google-Smtp-Source: ABdhPJwkQk4Km23xbgqWhYn2ueCNAKryjYuAdZjwSEU4fpXK6SNw6IF/hRfjLyHXmjBVSbDgqWv+Rg==
X-Received: by 2002:a17:906:a192:: with SMTP id s18mr3149405ejy.249.1609949496895;
        Wed, 06 Jan 2021 08:11:36 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id q25sm1570041eds.85.2021.01.06.08.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 08:11:36 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/6] kernel-shark: Add KS_DEFINE_PLUGIN_CONTEXT macro
Date:   Wed,  6 Jan 2021 18:11:17 +0200
Message-Id: <20210106161120.119085-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106161120.119085-1-y.karadz@gmail.com>
References: <20210106161120.119085-1-y.karadz@gmail.com>
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
 src/libkshark-plugin.h    | 43 +++++++++++++++++++++++++++++++++++++++
 tests/libkshark-tests.cpp | 32 +++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
index f3c724f..e58d658 100644
--- a/src/libkshark-plugin.h
+++ b/src/libkshark-plugin.h
@@ -360,6 +360,49 @@ int kshark_handle_all_dpis(struct kshark_data_stream *stream,
 	}								\
 }									\
 
+/** General purpose macro defining methods for adding plugin context. */
+#define KS_DEFINE_PLUGIN_CONTEXT(type)					\
+static type **__context_handler;					\
+static ssize_t __n_streams = -1;					\
+static bool ok;								\
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
+		KS_DOUBLE_SIZE(type *, __context_handler,		\
+			       &__n_streams, &ok)			\
+		if (!ok)						\
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
index 06fdf62..4990cdb 100644
--- a/tests/libkshark-tests.cpp
+++ b/tests/libkshark-tests.cpp
@@ -10,6 +10,7 @@
 
 // KernelShark
 #include "libkshark.h"
+#include "libkshark-plugin.h"
 
 #define N_TEST_STREAMS	1000
 
@@ -80,3 +81,34 @@ BOOST_AUTO_TEST_CASE(fill_data_container)
 
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

