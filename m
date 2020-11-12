Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E5DC63697
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77E3B22248
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sSGqFnlJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgKLOYj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 09:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbgKLOYj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 09:24:39 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8646C0613D1
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:38 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id d12so6148917wrr.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rX9XfHhXf9sK0NoFo9P7mnliYZ0IH4YeOB5MqGmFCZI=;
        b=sSGqFnlJRBvQkbFuidtvyji+itD4O8Z3zMO2HQA/W7ioB0qm53awibQnVwK1qxBIys
         tM62cHGKtgnsr7BGryEGW7josXagkbjYjzdqhPypSFJ1Ak8yZnBrCRKFaW2QZysIdWz0
         dkLLA/2HBS723JJkegaPE2J53Bmdp3ocNinlZEeXhrUMjbrTrRAmcTDcuT4Meuuv0TZn
         bMPGlCtuplvtsaO2q8XLw5RCpW4M+rFuv70nJZEzhjKVu5CGzO+83vGjihXnd2o8lqt4
         1ycuju918tPSO9kcd2fYvbtZx9l3t/ShcMTr4hb8gwjmSre7toh8nN7nlYHZc5wzytpw
         P8EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rX9XfHhXf9sK0NoFo9P7mnliYZ0IH4YeOB5MqGmFCZI=;
        b=ftFvKj69kvtkgKr7v+QhxIitKIQhG8vmDj/hrdcmVUfRn6TxwniITn0bw/NyRVPUaU
         iIcom46xyWlEylybzMpKPsu9TAxHgvjnQWEj+o06VArDFb5MFDFl3i3wY8OvdyhRtd5W
         HezInmxUx7qtO0b7Bef4fThBg461jPAL1VBTMie71ErnWLZySQfOJbI+OqKWQ+9Hny4d
         5ex2XKZ+nl/nNo41PV3HW/+gAg7JjQveoUUVn/9F3xm5LE62H1SZhpwP5cHpdH6ppqib
         Nr8KND+s7YarJGJ1oQXNgg5HTjHBvcEC1KfxOo3Dw4aNP1gurjOt8fb/Mgma2ohoT6NU
         HCHQ==
X-Gm-Message-State: AOAM531HVVysHf28R4nETFCxUevUvr20ODGnEXpyckYXvRIqH/UZJ2wj
        JByZYrO65sRhQNNWUSYxj/c=
X-Google-Smtp-Source: ABdhPJzPDKhqVOF1fz8V7U9fl18xmp138WH9uEofxzgi+Puww/wsihDB4GC4wtreOTlqHWVyGP4Llw==
X-Received: by 2002:adf:a343:: with SMTP id d3mr35969045wrb.91.1605191077551;
        Thu, 12 Nov 2020 06:24:37 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id h15sm6950685wrw.15.2020.11.12.06.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 06:24:37 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 18/20] kernel-shark: Protect ksmodel_set_in_range_bining()
Date:   Thu, 12 Nov 2020 16:23:56 +0200
Message-Id: <20201112142358.36821-19-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112142358.36821-1-y.karadz@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Handle the case when the number of bins is zero or negative.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-model.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/src/libkshark-model.c b/src/libkshark-model.c
index 2301b069..44f829d6 100644
--- a/src/libkshark-model.c
+++ b/src/libkshark-model.c
@@ -97,8 +97,19 @@ static void ksmodel_set_in_range_bining(struct kshark_trace_histo *histo,
 	int64_t corrected_range, delta_range, range = max - min;
 	struct kshark_entry *last;
 
+	if (n <= 0) {
+		histo->n_bins = histo->bin_size = 0;
+		histo->min = min;
+		histo->max = max;
+
+		free(histo->bin_count);
+		free(histo->map);
+
+		return;
+	}
+
 	/* The size of the bin must be >= 1, hence the range must be >= n. */
-	if (n == 0 || range < n) {
+	if (range < n) {
 		range = n;
 		max = min + n;
 	}
-- 
2.25.1

