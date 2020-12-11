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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0535DC4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE7A023C17
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392818AbgLKPLm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437672AbgLKPJ4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:09:56 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357B2C0611BB
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:38 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id y23so8911929wmi.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m9lQFJuvJrwOAGItYL0Yq0F1uOB4F66QAhKkaIHI7D8=;
        b=gNoFdo2TRlrxawz9kat2uk+xAY7U61tmPZZ9XLsvQqjmX+5HrTMH4MQmGINEANQK0V
         Ea/KBwA/EfBg7r61XTwElQGYPcr3woKpSrd9aXoQ7WndIuq+QFr3q7kE8tBwsvpDVl7W
         TI3XgoGGP30Ru/YTASAhNNYqzBnZUUQAGx04BaUCRtbgMaM5KZjEDS8+OiKUdA3nmQUE
         kJvHVUr1M5PDQn/Tgr43ZXAgmrRXDnhNwhQmOqXNvIvnId3YgXkE/7GRDTWh9nuCV4ZC
         4kThIzHabYRMOsv94mfA4j1tNnwYeo8khnnUUkjDUD3QW8qdgjP3Q6bwIJS++HQB2NBR
         EVaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m9lQFJuvJrwOAGItYL0Yq0F1uOB4F66QAhKkaIHI7D8=;
        b=ieVdq5FUbJCHWeJYcJlF85NOL4DQnM3395jAhVKesoT2blEVWcm6qGadCOAo0s9eSn
         QA8vMje9ENYVLNFu3FI9UqkjZchJz6cZeUGjb88nNR/a8uPyBQIzsS1lGvEd5da56t+7
         G/flfUYqCFMH8dIHZIxLCp/ymc6IC9h9DiWFHSptln6TZhVnzgMnCLi8b6ssWIbI246T
         AORZyscnmMka0ws0fEvxVl+spzUhsBGe55HOPi/rQwBE6hG4isCeceZPa8Ht8hP1MAji
         j6qTbF9TQTcVr5w7V0kag8aBpAvY7czujHmm2JmnTunjD1f2Fn3XopiCeY19GHoLy1Bt
         Iorw==
X-Gm-Message-State: AOAM530tcCHjUmAMp1oXeFEvJmQGc9FDXsVeZm8VJQLlxyaX7i7eW9u5
        MDHMkkUVm+vDWc8rrn8/Ij/miwOOzlo=
X-Google-Smtp-Source: ABdhPJy9t6+W65+4FnLs2aPJWvcZwgwd5gkgNtBgMcRNhid939z4Q1V5F4QcZbL2Do+833PO4dR73Q==
X-Received: by 2002:a1c:67c2:: with SMTP id b185mr13723390wmc.119.1607699316934;
        Fri, 11 Dec 2020 07:08:36 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:36 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 22/32] kernel-shark: Add ksmodel_get_bin()
Date:   Fri, 11 Dec 2020 17:07:46 +0200
Message-Id: <20201211150756.577366-23-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The method retrieves the Id of the bin of the model that contains
given entry.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-model.c | 27 +++++++++++++++++++++++++++
 src/libkshark-model.h |  3 +++
 2 files changed, 30 insertions(+)

diff --git a/src/libkshark-model.c b/src/libkshark-model.c
index f3864bf..2301b06 100644
--- a/src/libkshark-model.c
+++ b/src/libkshark-model.c
@@ -1325,3 +1325,30 @@ ksmodel_get_task_missed_events(struct kshark_trace_histo *histo,
 				       match_pid_missed_events, sd, &pid,
 				       col, index);
 }
+
+/**
+ * @brief Find the bin Id of a give entry.
+ *
+ * @param histo: Input location for the model descriptor.
+ * @param entry: Input location for entry.
+ *
+ * @returns If the timestamp of the entry is inside the range of the model the
+ * 	    function returns the Id of the bin it belongs to.
+ * 	    If the timestamp of the entry is outside of the range of the model
+ * 	    the function returns UPPER_OVERFLOW_BIN or LOWER_OVERFLOW_BIN
+ * 	    (negative values).
+ */
+int ksmodel_get_bin(struct kshark_trace_histo *histo,
+		    const struct kshark_entry *entry)
+{
+	if (entry->ts < histo->min)
+		return UPPER_OVERFLOW_BIN;
+
+	if (entry->ts > histo->max)
+		return LOWER_OVERFLOW_BIN;
+
+	if (entry->ts == histo->max)
+		return histo->n_bins - 1;
+
+	return  (entry->ts - histo->min) / histo->bin_size;
+}
diff --git a/src/libkshark-model.h b/src/libkshark-model.h
index b862480..8989ee0 100644
--- a/src/libkshark-model.h
+++ b/src/libkshark-model.h
@@ -175,6 +175,9 @@ static inline double ksmodel_bin_time(struct kshark_trace_histo *histo,
 	return ksmodel_bin_ts(histo, bin) * 1e-9;
 }
 
+int ksmodel_get_bin(struct kshark_trace_histo *histo,
+		    const struct kshark_entry *entry);
+
 #ifdef __cplusplus
 }
 #endif // __cplusplus
-- 
2.25.1

