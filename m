Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA7DC47423
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A41B208FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:41:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="evVZyFW1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730044AbgI2Nl7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729038AbgI2Nl7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 09:41:59 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B31C0613D1
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:57 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id t10so5480906wrv.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9V9VMnJyhQAjJUHzqJFyE0DzvspvbozI8gsD1dPO9Lo=;
        b=evVZyFW16sDdv6UmMrCnqIH4qYHAyg2ZyP12EdEhB1AsM/ZpMaZIfYVvCj3g8YffvF
         U4E/dpQlR3ELR+u8TS29Lw87qPPLl8vWfDDWmoHSZpB99eJQLWw3aoWKph3GfcZKCCsY
         WOApk9gRmqtHnrfVKScO+OKqf2vJdOdpiWaSQnVFutpcIUKDjBb1IvHkyii4fBFGa2UB
         g6m/rJ9bpbDqMRs4QJoh1lEGyiCpiS8XC+W7p2D61pRCqM4dg95T6WcqV/t3cPqogy/L
         J5nm/8YITaZlLhbPPAkLtxXGYj1UUfuZ3HSC9jqXPjHYzZZAA3Byy3rRE5Vpoxq/quYF
         /9bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9V9VMnJyhQAjJUHzqJFyE0DzvspvbozI8gsD1dPO9Lo=;
        b=o91AHUR3N4I2NuR2xEYEnublD9oST9AyHaNYH2xqr1G3tU/ZksXohhY2gwfc+F0kbV
         WAlybJmVYj26QLKs2IN8xHn5kUIpXIvAI11zxh6SazJT3udp0eHyo6t3xFbA617CxlLL
         vN/5lHVSLUSB3gvwnqFiJ1+IBadn0uiiGQrDbPYT5+I7s4BcXTx6i2rSlal3tS82eQFH
         EzJygsk+PIcsYpEAAxU97Cxm9bMabLpiYnylPpzMejG4DXO3O7ANXdvN8zeFg72p+ppd
         CglaR1EuXtvvHzzblYKiAyQ5ezsTdhQ8HbiaG29CMXNg93uKIGiuuRADOXOd7Vf07rpz
         35yA==
X-Gm-Message-State: AOAM532PlbQ6ff0NPT9p039lrLE7HyFk8vOViUc90j63vcGmQR+Js4R1
        gzJvbgGD0DglsT/sn46btxE=
X-Google-Smtp-Source: ABdhPJxf30rNtlGUDi4Z4E3x+NLIe8PHSKluS7XOA6y/8wVl9XiIiQzNd14y2iOigJCVKV6A7Z7kmQ==
X-Received: by 2002:a5d:570b:: with SMTP id a11mr4543076wrv.139.1601386916001;
        Tue, 29 Sep 2020 06:41:56 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id b84sm6162792wmd.0.2020.09.29.06.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 06:41:55 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 07/15] kernel-shark: Add stream_id to kshark_entry
Date:   Tue, 29 Sep 2020 16:41:15 +0300
Message-Id: <20200929134123.178688-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929134123.178688-1-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

kshark_entry contains all information from one trace record, needed
in order to visualize the time-series of trace records. Here we
reorganize data fields to kshark_entry in order to make room for
the unique identifier of the Data stream this entry belongs to.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.c |  2 +-
 src/libkshark.h | 12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/src/libkshark.c b/src/libkshark.c
index 52aacd3..92e2450 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -489,7 +489,7 @@ static inline void unset_event_filter_flag(struct kshark_context *kshark_ctx,
 	e->visible &= ~event_mask;
 }
 
-static void set_all_visible(uint16_t *v) {
+static void set_all_visible(uint8_t *v) {
 	/*  Keep the original value of the PLUGIN_UNTOUCHED bit flag. */
 	*v |= 0xFF & ~KS_PLUGIN_UNTOUCHED_MASK;
 }
diff --git a/src/libkshark.h b/src/libkshark.h
index b57fb5d..726f3d2 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: LGPL-2.1 */
 
 /*
- * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
  */
 
  /**
@@ -50,7 +50,10 @@ struct kshark_entry {
 	 * kshark_filter_masks to check the level of visibility/invisibility
 	 * of the entry.
 	 */
-	uint16_t	visible;
+	uint8_t		visible;
+
+	/** Data stream identifier. */
+	int8_t		stream_id;
 
 	/** The CPU core of the record. */
 	int16_t		cpu;
@@ -58,7 +61,7 @@ struct kshark_entry {
 	/** The PID of the task the record was generated. */
 	int32_t		pid;
 
-	/** Unique Id ot the trace event type. */
+	/** Unique Id of the trace event type. */
 	int32_t		event_id;
 
 	/** The offset into the trace file, used to find the record. */
@@ -351,6 +354,9 @@ struct kshark_data_stream {
 	struct kshark_data_stream_interface	interface;
 };
 
+/** Hard-coded maximum number of data stream. */
+#define KS_MAX_NUM_STREAMS	127
+
 /** Size of the task's hash table. */
 #define KS_TASK_HASH_SHIFT 16
 #define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
-- 
2.25.1

