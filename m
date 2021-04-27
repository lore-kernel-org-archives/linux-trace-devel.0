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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0053DC433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDBCF61164
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238808AbhD0Q0w (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 12:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237408AbhD0QZ5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 12:25:57 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEE7C06135B
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:27 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id d14so6855117edc.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xZzs1ISpwrRvRkWW4R8VYE7rlqoWWCme5uCOsIPHhfc=;
        b=NYi+LyNB/Ih4rxCjZqXnRZR1J+f3FDz8beefvIw1DhjIFkMhVTd1dIpniZXkFeJgQu
         w9Bp9xjQBh6YMkEULE1ba6j+Gakk0HpfbCEylQT2uOilUlgAwnnPDkPTJE9NZ1IGgyjS
         z8OEaypCjawWWTk6X3mx1i2vwOwTsw2TJoaHuGKhBhbhncd+ooM8QdUdXKskL8OUh9rC
         4K/u5rRb4zHntYP7NwhkiPpVr+uPwQJduVcASui+jNmUFybHBRnUsDcH/7WRZ/8gQgzr
         OXWI44qly942eetxfr165rdAxHyqAddPgdrKJy6t/kymw76/f5YFDlE3aCJYQus5oUUU
         Y66w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xZzs1ISpwrRvRkWW4R8VYE7rlqoWWCme5uCOsIPHhfc=;
        b=X1Avw2VKlGeB4KRqk1vrUTMQQcyTAe3wZ/2ANTR4f739oG98P80KZerhqlhg/dWbsd
         ROeGxf/kUWs1+esdwX2bEfhhnaJ3LLd+BYXEvtu3DsdHCAvmeddDGNRy5AeKlMf/SPpI
         keMn9csBT7z+behycbkj6V93RvI7oJkvpSdl3SE7h9zSXL0bP2xbC4HzxTaXi+dLFRcj
         R6aL1v56WYILF85mvn7zUfYEkFSLwfBlszTiPKrahnG/ymeUypnk0a+MQIFIVhgwPbu6
         M02I/6y+JUI2H7INPFgbZPonojAG7ahV0vOKTIhs8bQY/JdWVbAYgRQakx4IzDiVjFEk
         1Wlw==
X-Gm-Message-State: AOAM5313rQkfIVXCBycrVk+oR3FT6V79diMJu1CV1O/dY2j2lxdmeaQv
        l4UHJjc/FJGoSSBUWv8LQdenhRWf7p4=
X-Google-Smtp-Source: ABdhPJysi6gz525uHuer3OzdJi0gex52av//elZdGvZW0JwhTjlF9zrOgw0KbeqGh6ssBQm8pUhWCA==
X-Received: by 2002:aa7:c049:: with SMTP id k9mr5380382edo.56.1619540665734;
        Tue, 27 Apr 2021 09:24:25 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id d15sm2740284edu.86.2021.04.27.09.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 09:24:25 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/7] kernel-shark: Fix KS_DEFINE_PLUGIN_CONTEXT macro
Date:   Tue, 27 Apr 2021 19:24:04 +0300
Message-Id: <20210427162408.134001-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210427162408.134001-1-y.karadz@gmail.com>
References: <20210427162408.134001-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The KS_DEFINE_PLUGIN_CONTEXT macro implements methods that are used
to deal with plugin-specific context objects. However, when this macro
is used in multiple plugins and those plugins are loaded together
the symbol resolving fails, resulting in undefined behavior. Namely,
version of the function from one plugin, being called by another
plugin. Here we make sure that the methods defined in
KS_DEFINE_PLUGIN_CONTEXT are not visible outside of the corresponding
plugin.

Fixing: 15df009 (kernel-shark: Add KS_DEFINE_PLUGIN_CONTEXT macro)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-plugin.h     | 22 ++++++++++++++++++----
 src/plugins/sched_events.c |  3 +++
 src/plugins/sched_events.h |  3 +--
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
index c110616..752dbeb 100644
--- a/src/libkshark-plugin.h
+++ b/src/libkshark-plugin.h
@@ -24,6 +24,8 @@ extern "C" {
 /* Quiet warnings over documenting simple structures */
 //! @cond Doxygen_Suppress
 
+#define __hidden __attribute__((visibility ("hidden")))
+
 #define _MAKE_STR(x)	#x
 
 #define MAKE_STR(x)	_MAKE_STR(x)
@@ -364,11 +366,14 @@ int kshark_handle_all_dpis(struct kshark_data_stream *stream,
 	__ok;								\
 })									\
 
-/** General purpose macro defining methods for adding plugin context. */
+/**
+ * General purpose macro defining methods for adding plugin context.
+ * Do not use this macro in header files.
+ */
 #define KS_DEFINE_PLUGIN_CONTEXT(type)					\
 static type **__context_handler;					\
 static ssize_t __n_streams = -1;					\
-static inline type *__init(int sd)					\
+__hidden type *__init(int sd)						\
 {									\
 	type *obj;							\
 	if (__n_streams < 0 && sd < KS_DEFAULT_NUM_STREAMS) {		\
@@ -388,7 +393,7 @@ static inline type *__init(int sd)					\
 	__context_handler[sd] = obj;					\
 	return obj;							\
 }									\
-static inline void __close(int sd)					\
+__hidden void __close(int sd)						\
 {									\
 	if (sd < 0) {							\
 		free(__context_handler);				\
@@ -398,13 +403,22 @@ static inline void __close(int sd)					\
 	free(__context_handler[sd]);					\
 	__context_handler[sd] = NULL;					\
 }									\
-static inline type *__get_context(int sd)				\
+__hidden type *__get_context(int sd)					\
 {									\
 	if (sd < 0 || sd >= __n_streams)				\
 		return NULL;						\
 	return __context_handler[sd];					\
 }									\
 
+/**
+ * General purpose macro declaring the methods for adding plugin context.
+ * To be used in header files.
+ */
+#define KS_DECLARE_PLUGIN_CONTEXT_METHODS(type)		\
+type *__init(int sd);					\
+void __close(int sd);					\
+type *__get_context(int sd);				\
+
 #ifdef __cplusplus
 }
 #endif // __cplusplus
diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index ac4a7bf..5798322 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -73,6 +73,9 @@ int plugin_sched_get_prev_state(ks_num_field_t field)
 	return (field & mask) >> PREV_STATE_SHIFT;
 }
 
+/** A general purpose macro is used to define plugin context. */
+KS_DEFINE_PLUGIN_CONTEXT(struct plugin_sched_context);
+
 static bool plugin_sched_init_context(struct kshark_data_stream *stream,
 				      struct plugin_sched_context *plugin_ctx)
 {
diff --git a/src/plugins/sched_events.h b/src/plugins/sched_events.h
index 78cfda0..2c540fd 100644
--- a/src/plugins/sched_events.h
+++ b/src/plugins/sched_events.h
@@ -53,8 +53,7 @@ struct plugin_sched_context {
 	struct kshark_data_container	*sw_data;
 };
 
-/** A general purpose macro is used to define plugin context. */
-KS_DEFINE_PLUGIN_CONTEXT(struct plugin_sched_context);
+KS_DECLARE_PLUGIN_CONTEXT_METHODS(struct plugin_sched_context)
 
 /** The type of the data field stored in the kshark_data_container object. */
 typedef int64_t ks_num_field_t;
-- 
2.27.0

