Return-Path: <SRS0=swVm=5P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68887C43331
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 307A82072E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:07:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TpXuxQCX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgC3QHZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 30 Mar 2020 12:07:25 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35259 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgC3QHY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 12:07:24 -0400
Received: by mail-lf1-f68.google.com with SMTP id t16so13820509lfl.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Mar 2020 09:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H3MPEHHYof7ZrvtG0+umwwT4+AgM2wjLWG9PGuFbOzQ=;
        b=TpXuxQCXmJID23ghPuYr4iFAzc8t8Tnq/HTQpwn0x5j9piVvdv4DHIuaf9lHqD80FR
         GF4AAilu8I23VQFwceENLDd7n9pCvL0zpPtLmmh/dOYiVPOtrnywnJMbjzkKxzdHvaCZ
         VDj0v4OiZekrCGpzBPGCLz3EJJKDwEpdSF4lpMUbTk3AnD0xI55N6nmW5nZMjTmlDPsL
         2mEuvb9X5GHKnNCPQ9MHwXnpOPQ4+8BfiZdbiNxdcfVPvEJJ+hjDROvakBc1Xxpo6V5U
         WoRtgPMSKsBD2O3Im7dWYmoTR1KeWJdZ9VXyTjdyaGiBLiGtul20CkDkzjq1ZZ5VFLvC
         mbAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H3MPEHHYof7ZrvtG0+umwwT4+AgM2wjLWG9PGuFbOzQ=;
        b=Gncbekdfy4zs+FCiEkPgMeKSB/4eMHJsV7pisuG4Tn5brWxhlyAN7dQEFagPihtrdZ
         itzWdfU1AF2tEx8nrsjat7iKzT7qvQ1+a/mdsvaBJ+jOkZkG9whlxtrJVzEmsx89glFR
         6Dt6fBZgIpj/Jz2G9UJWpCAGf+G+RGrIc4g1J0klVPZpsOFsnok5LtmOC5/Hd+QJLdNM
         XVR/B+Nq0yhW7n5TTCuWEypfB7/bOy/9F+U32rvMY3ifxdxR9hy8cidKYg/14nXWCy5K
         6O1rOKuFw0ST3PvJJhI63UbbONe1qnegh9JcVW8vhWaxJM2/JvxkhGlEDGu+CHDSr03L
         NOPg==
X-Gm-Message-State: AGi0PuawP/YsQNTeHNgXqAQ89op9H7tYKRnqGvwm2/h+5jFSrpJLcMgI
        VQw8ywQH1LGf4MhPkeTBdYI=
X-Google-Smtp-Source: APiQypLxfmb74e3uB43HKsdjlmFLNAynkl1IEkTWbOK5L0dOxHIkovoa29v4glAm4Qa/RnOYyNcTvg==
X-Received: by 2002:ac2:46ed:: with SMTP id q13mr8548458lfo.176.1585584438638;
        Mon, 30 Mar 2020 09:07:18 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.182])
        by smtp.gmail.com with ESMTPSA id x28sm5876123lfq.46.2020.03.30.09.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 09:07:17 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/6] kernel-shark: Add method for checking if a given ID filter is set
Date:   Mon, 30 Mar 2020 19:06:47 +0300
Message-Id: <20200330160652.28424-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200330160652.28424-1-y.karadz@gmail.com>
References: <20200330160652.28424-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The method is already defined and used as a static function in
libkshark.c and libkshark-configio.c (basically having two identical
copies). Now we are making this method part of the API. We will later
use this method in the GUI (following patch).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/libkshark-configio.c | 17 ++++++-----------
 kernel-shark/src/libkshark.c          | 21 ++++++++++++++-------
 kernel-shark/src/libkshark.h          |  2 ++
 3 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/kernel-shark/src/libkshark-configio.c b/kernel-shark/src/libkshark-configio.c
index 5d7323f..f01a39b 100644
--- a/kernel-shark/src/libkshark-configio.c
+++ b/kernel-shark/src/libkshark-configio.c
@@ -1306,11 +1306,6 @@ bool kshark_import_user_mask(struct kshark_context *kshark_ctx,
 	}
 }
 
-static bool filter_is_set(struct tracecmd_filter_id *filter)
-{
-	return filter && filter->count;
-}
-
 /**
  * @brief Record the current configuration of "show task" and "hide task"
  *	  filters into a Json document.
@@ -1335,13 +1330,13 @@ bool kshark_export_all_event_filters(struct kshark_context *kshark_ctx,
 		return false;
 
 	/* Save a filter only if it contains Id values. */
-	if (filter_is_set(kshark_ctx->show_event_filter))
+	if (kshark_this_filter_is_set(kshark_ctx->show_event_filter))
 		ret &= kshark_export_event_filter(kshark_ctx->pevent,
 						  kshark_ctx->show_event_filter,
 						  KS_SHOW_EVENT_FILTER_NAME,
 						  *conf);
 
-	if (filter_is_set(kshark_ctx->hide_event_filter))
+	if (kshark_this_filter_is_set(kshark_ctx->hide_event_filter))
 		ret &= kshark_export_event_filter(kshark_ctx->pevent,
 						  kshark_ctx->hide_event_filter,
 						  KS_HIDE_EVENT_FILTER_NAME,
@@ -1374,12 +1369,12 @@ bool kshark_export_all_task_filters(struct kshark_context *kshark_ctx,
 		return false;
 
 	/* Save a filter only if it contains Id values. */
-	if (filter_is_set(kshark_ctx->show_task_filter))
+	if (kshark_this_filter_is_set(kshark_ctx->show_task_filter))
 		ret &= kshark_export_filter_array(kshark_ctx->show_task_filter,
 						  KS_SHOW_TASK_FILTER_NAME,
 						  *conf);
 
-	if (filter_is_set(kshark_ctx->hide_task_filter))
+	if (kshark_this_filter_is_set(kshark_ctx->hide_task_filter))
 		ret &= kshark_export_filter_array(kshark_ctx->hide_task_filter,
 						  KS_HIDE_TASK_FILTER_NAME,
 						  *conf);
@@ -1412,12 +1407,12 @@ bool kshark_export_all_cpu_filters(struct kshark_context *kshark_ctx,
 		return false;
 
 	/* Save a filter only if it contains Id values. */
-	if (filter_is_set(kshark_ctx->show_task_filter))
+	if (kshark_this_filter_is_set(kshark_ctx->show_task_filter))
 		ret &= kshark_export_filter_array(kshark_ctx->show_cpu_filter,
 						  KS_SHOW_CPU_FILTER_NAME,
 						  *conf);
 
-	if (filter_is_set(kshark_ctx->hide_task_filter))
+	if (kshark_this_filter_is_set(kshark_ctx->hide_task_filter))
 		ret &= kshark_export_filter_array(kshark_ctx->hide_cpu_filter,
 						  KS_HIDE_CPU_FILTER_NAME,
 						  *conf);
diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index a361578..0905359 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -445,7 +445,14 @@ void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id)
 	tracecmd_filter_id_clear(filter);
 }
 
-static bool filter_is_set(struct tracecmd_filter_id *filter)
+/**
+ * @brief Check if a given Id filter is set.
+ *
+ * @param filter: Input location for the Id filster.
+ *
+ * @returns True if the Id filter is set, otherwise False.
+ */
+bool kshark_this_filter_is_set(struct tracecmd_filter_id *filter)
 {
 	return filter && filter->count;
 }
@@ -459,12 +466,12 @@ static bool filter_is_set(struct tracecmd_filter_id *filter)
  */
 bool kshark_filter_is_set(struct kshark_context *kshark_ctx)
 {
-	return filter_is_set(kshark_ctx->show_task_filter) ||
-	       filter_is_set(kshark_ctx->hide_task_filter) ||
-	       filter_is_set(kshark_ctx->show_cpu_filter) ||
-	       filter_is_set(kshark_ctx->hide_cpu_filter) ||
-	       filter_is_set(kshark_ctx->show_event_filter) ||
-	       filter_is_set(kshark_ctx->hide_event_filter);
+	return kshark_this_filter_is_set(kshark_ctx->show_task_filter) ||
+-              kshark_this_filter_is_set(kshark_ctx->hide_task_filter) ||
+-              kshark_this_filter_is_set(kshark_ctx->show_cpu_filter) ||
+-              kshark_this_filter_is_set(kshark_ctx->hide_cpu_filter) ||
+-              kshark_this_filter_is_set(kshark_ctx->show_event_filter) ||
+-              kshark_this_filter_is_set(kshark_ctx->hide_event_filter);
 }
 
 static inline void unset_event_filter_flag(struct kshark_context *kshark_ctx,
diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
index e795ed4..0d6c50d 100644
--- a/kernel-shark/src/libkshark.h
+++ b/kernel-shark/src/libkshark.h
@@ -261,6 +261,8 @@ void kshark_filter_add_id(struct kshark_context *kshark_ctx,
 
 void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id);
 
+bool kshark_this_filter_is_set(struct tracecmd_filter_id *filter);
+
 bool kshark_filter_is_set(struct kshark_context *kshark_ctx);
 
 void kshark_filter_entries(struct kshark_context *kshark_ctx,
-- 
2.20.1

