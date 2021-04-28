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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9B0C43470
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 666EE61158
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239903AbhD1Nse (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 09:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239912AbhD1Nsc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 09:48:32 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62F1C061344
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:45 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id j28so10290293edy.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=foydaeQupQGZAOnOFr5/fMaMck39gWKD2Snpovk8cyw=;
        b=cK6ABKurE50y6xy5MIF9oUqHm0/9+5X6Agbw+wkpYXb9Q64FR7BlRhNF0fFOsswBo8
         y0n850p5F6AgS7q8eHtfFLYmLSe6FzKBgLHp80ag3eKx/yHj1H4q58eV49ez+yLWlszL
         5XO13c9S7fEDP4FTz086MbiCWvwLq2VASYV5iD5jE4FiiXv4df1KJayw27a1RYmH1uqV
         iIstzeZjgc0jGsLDDqRRZQyS1v/tRQBTvhPvTti0vTp/7g4bq3pBTLJ1XHToBhgar7EU
         jkH26/6RZvj32r3cMODnZtx+T2rhmjvJV0hS6rW1jLnBIEuFXrsfV/Vu9SiSW0tYMPmo
         +NVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=foydaeQupQGZAOnOFr5/fMaMck39gWKD2Snpovk8cyw=;
        b=Ehnztz2qVM5cpq13sKwVrdozd1XfsaF5kJcFkwzTMfga9OQaO7WQCqcwBB3J76QI8k
         e37eA5iNoxsQKRgeZRlH3WztSYWqpTSz3DAhYFcV8gmUQOLORLoT+u9C/3p/gyC8zuc8
         yDxU0UduEZDm/z8kvL3YOUejwsPocydgh0n9yCjdzM0EpFhQEyIn9bNg4VxhpJuVKvkB
         jbIoZy9+VJkz1M8ZG0SOlGEFqqv8ixuX+rwKjsF5z0uTURA2TScpqXD5Wwzkd1J7w4b1
         rRYKA3AmDVKtzuxzjTzGRAkGZN2Vb+mQfnJ3w0VcU0HPukelp4du2Wg7sE91v9kWjqFR
         6nTw==
X-Gm-Message-State: AOAM532NVbDK00+MrS7ZvQkl3WwUivwMqfL0ay0u3JVi69BfCvRggW3V
        O+pQtwyvN73lXYyYx74cz95tpEHeIEs=
X-Google-Smtp-Source: ABdhPJx2FO1zYt8mh1742HDAXyCR73PbomBf6rs9L335Xxt5iAqtfAcI29f03KiJq4g+56Xe+xaAdg==
X-Received: by 2002:a05:6402:1a58:: with SMTP id bf24mr11644828edb.231.1619617664392;
        Wed, 28 Apr 2021 06:47:44 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id y6sm4755952edc.26.2021.04.28.06.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 06:47:44 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 5/9] kernel-shark: Fix memory leak in "sched events" plugin.
Date:   Wed, 28 Apr 2021 16:47:26 +0300
Message-Id: <20210428134730.187533-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210428134730.187533-1-y.karadz@gmail.com>
References: <20210428134730.187533-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The memory used by the Data container object must be freed. The fix
includes improvement of the KS_DEFINE_PLUGIN_CONTEXT macro.

Fixing: b39499d (kernel-shark: Speed-up the sched_events plugin)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-plugin.h     |  4 ++--
 src/plugins/sched_events.c | 11 ++++++++++-
 tests/libkshark-tests.cpp  |  2 +-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
index b259b24..10e5f1b 100644
--- a/src/libkshark-plugin.h
+++ b/src/libkshark-plugin.h
@@ -373,7 +373,7 @@ int kshark_handle_all_dpis(struct kshark_data_stream *stream,
  * General purpose macro defining methods for adding plugin context.
  * Do not use this macro in header files.
  */
-#define KS_DEFINE_PLUGIN_CONTEXT(type)					\
+#define KS_DEFINE_PLUGIN_CONTEXT(type, type_free)			\
 static type **__context_handler;					\
 static ssize_t __n_streams = -1;					\
 __hidden type *__init(int sd)						\
@@ -412,7 +412,7 @@ __hidden void __close(int sd)						\
 	}								\
 	obj = __get_context(sd);					\
 	if (obj) {							\
-		free(__context_handler[sd]);				\
+		type_free(__context_handler[sd]);			\
 		__context_handler[sd] = NULL;				\
 	}								\
 }									\
diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index f3c2c23..e151a70 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -73,8 +73,17 @@ int plugin_sched_get_prev_state(ks_num_field_t field)
 	return (field & mask) >> PREV_STATE_SHIFT;
 }
 
+static void sched_free_context(struct plugin_sched_context *plugin_ctx)
+{
+	if (!plugin_ctx)
+		return;
+
+	kshark_free_data_container(plugin_ctx->ss_data);
+	kshark_free_data_container(plugin_ctx->sw_data);
+}
+
 /** A general purpose macro is used to define plugin context. */
-KS_DEFINE_PLUGIN_CONTEXT(struct plugin_sched_context);
+KS_DEFINE_PLUGIN_CONTEXT(struct plugin_sched_context, sched_free_context);
 
 static bool plugin_sched_init_context(struct kshark_data_stream *stream,
 				      struct plugin_sched_context *plugin_ctx)
diff --git a/tests/libkshark-tests.cpp b/tests/libkshark-tests.cpp
index 5f7c88a..3a5b0c3 100644
--- a/tests/libkshark-tests.cpp
+++ b/tests/libkshark-tests.cpp
@@ -148,7 +148,7 @@ struct test_context {
 	char b;
 };
 
-KS_DEFINE_PLUGIN_CONTEXT(struct test_context);
+KS_DEFINE_PLUGIN_CONTEXT(struct test_context, free);
 
 BOOST_AUTO_TEST_CASE(init_close_plugin)
 {
-- 
2.27.0

