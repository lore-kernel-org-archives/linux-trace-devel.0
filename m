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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258C2C43460
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E14E461444
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239908AbhD1Nse (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 09:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239918AbhD1Nsb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 09:48:31 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3578BC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:44 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id h10so74282534edt.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xZzs1ISpwrRvRkWW4R8VYE7rlqoWWCme5uCOsIPHhfc=;
        b=HxfwzhZXy18AUmReU+YompVqhn+HTFpFJzrFFIB8K+0JdVivRxqpWu5O6EZR4Ha6a7
         xJIbgnL9iQW5vTV92cPNSQ/6lZjTvvuqaSH/a4FidaFK4TEXdcGmEIJXkCYZSwGDsBUY
         o83GNkyqcXV4zmT9HeIP91wCO6zJipcF+jGgv92bE3tbySeQDdk50cdiJOjrf6xCczue
         GQUql0eIFOi22sGIh6IXSinNc6YoQhQJGHspoU+lFqO5gnoPqCa1z7KKxTLVbhLYld3B
         2uf/keI/4NOkoitMqpxzs+JiexUgwh7PaCkN4owbbdc7jZWrydofkmuofbZWR6qgQFz+
         WNDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xZzs1ISpwrRvRkWW4R8VYE7rlqoWWCme5uCOsIPHhfc=;
        b=dTAQGmi3QxdeaCrQeOk5rU6hPyZ9dCMkr+ILAF6Dryl2FVQ1PyEbT4chBjS2Kl2vJb
         JIE+CAWbxMhM1TlKYTj71bPZRpDI01vEWQd+k5RGxuiHuyvTYnxPOVJIfzmrrS2gKGqf
         kMnU6J747cqZHnd6+6W3yVbn7eBix+OxNpb6Xl64rl+0rL4vOf/hXOabIwvC6/TnbG5R
         D446Wg9XtIeqruiCfymXIZuGVKz5Rzss2x/PNI/270IRnu4ABAuvZLY5dZfu4PIwLJua
         x9IwRMfum7mqh8rU6vtvRPSmvgQtvg7TpHJC2ftVRfgAp5jZDrwwnawC3vTWbnviA53c
         2Txg==
X-Gm-Message-State: AOAM532X799hswo3yR7zMQKSyaKGHQ4jcdsB+R8dkts8GFrGrLMfmp6T
        fu2TEy31lxmUcW1dubLltlkumwzvOGU=
X-Google-Smtp-Source: ABdhPJxHbxg7qbI189sDC60qPGSQ1ceglStBm1VmaHxX1ptxh+74Qv3TXD3quudiOJh34cpx8EEVBw==
X-Received: by 2002:a05:6402:34c8:: with SMTP id w8mr11671382edc.194.1619617662774;
        Wed, 28 Apr 2021 06:47:42 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id y6sm4755952edc.26.2021.04.28.06.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 06:47:42 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/9] kernel-shark: Fix KS_DEFINE_PLUGIN_CONTEXT macro
Date:   Wed, 28 Apr 2021 16:47:24 +0300
Message-Id: <20210428134730.187533-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210428134730.187533-1-y.karadz@gmail.com>
References: <20210428134730.187533-1-y.karadz@gmail.com>
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

