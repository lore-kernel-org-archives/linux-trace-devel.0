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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76144C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F567613E8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbhD0Q1A (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 12:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238856AbhD0QZ6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 12:25:58 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71BFC06135D
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:28 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id t4so7069897ejo.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lW4iHB1552msQ3I1dGGw7R+FZ3bAcMKEqMxqLWDF8v4=;
        b=G9xoMLbB1gf5f5fm4NjD0tGhVXpsL+Cd/95xdhgfSvGpL7N/LhTLSPFryPDsZsWfek
         eZOJCOOftzx04HGFv/+RNizz8iJNXJalmiL0nkfeNahjDB3kvreYc90VBuRk55icB5hz
         cmh5S6CyPmxa3KI3mKEj5GU4ult3DstEvS0a4B8TQzYdW+qpF6awirsOoKskyaL4SR0q
         2LYHhYNH3dKadnRfPgPGNP+tjdHxELiGJhnYE2YiCrc9ESkv2q4MfFRPcMobIsjPJELD
         Yktksj+WIAY5pT77G5aKe8TbTEYDH7s3HktCMfcpyE9DwTgOgVHF28WwHgf3FiiQmRSS
         eYPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lW4iHB1552msQ3I1dGGw7R+FZ3bAcMKEqMxqLWDF8v4=;
        b=diCJJ0EUZxjlmcnlh3e5NrAOiWXOqHMKw9QvTyGb0N8xUVy3/+1NgTdX+yFjERydsJ
         hT/oRDrabfeGrFPiwhAXX+Ou43TE1dzlR/yviuhT2egwfwS0ftvlzWDWAitjkO8GetAj
         vS88dp9srK0RolMHL39mwWFAHaEySn8kYJcN+tOg1dQBAlGPwpJpHLiKLzhhTrTn0YJa
         li6iSG5s+H9nQSb9LoTpKeNOuMi7Q5JZ9XisWkC5vvIZCFQeMfHWaBx/fRYX7Ml88gyR
         AwPzeWpZTEcNQhwL3Lh/qZEMBhw79VOwlBi4uxHHaWYbW9sx+dPp2izkeYSV28TWWERF
         quKA==
X-Gm-Message-State: AOAM532eiZwiNMAzUSUqfLvTrBbn4Wz7alf7r1IeqnzucF2HthtTWx9B
        OucK1RLMUuZ86ZpO9B9HQ0/mCDjXXu8=
X-Google-Smtp-Source: ABdhPJxmpt9JbhK5x9tC1ORccr87t+Heqz903K/01Lpefo/FnkiEyva1YusKBADnYgFT+e7AKqNnuA==
X-Received: by 2002:a17:906:3a94:: with SMTP id y20mr23817768ejd.35.1619540667458;
        Tue, 27 Apr 2021 09:24:27 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id d15sm2740284edu.86.2021.04.27.09.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 09:24:27 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/7] kernel-shark: Fix memory leak in "sched events" plugin.
Date:   Tue, 27 Apr 2021 19:24:06 +0300
Message-Id: <20210427162408.134001-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210427162408.134001-1-y.karadz@gmail.com>
References: <20210427162408.134001-1-y.karadz@gmail.com>
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
 src/plugins/sched_events.c | 14 +++++++++++++-
 tests/libkshark-tests.cpp  |  2 +-
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
index 85a0a8c..4c5fa5a 100644
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
@@ -403,7 +403,7 @@ __hidden void __close(int sd)						\
 		__n_streams = -1;					\
 		return;							\
 	}								\
-	free(__context_handler[sd]);					\
+	type_free(__context_handler[sd]);				\
 	__context_handler[sd] = NULL;					\
 }									\
 __hidden type *__get_context(int sd)					\
diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index 5c82803..a66904a 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -73,8 +73,20 @@ int plugin_sched_get_prev_state(ks_num_field_t field)
 	return (field & mask) >> PREV_STATE_SHIFT;
 }
 
+static void sched_free_context(struct plugin_sched_context *plugin_ctx)
+{
+	if (!plugin_ctx)
+		return;
+
+	if (plugin_ctx->ss_data)
+		kshark_free_data_container(plugin_ctx->ss_data);
+
+	if (plugin_ctx->sw_data)
+		kshark_free_data_container(plugin_ctx->sw_data);
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

