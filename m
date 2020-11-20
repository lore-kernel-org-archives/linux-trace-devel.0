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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C81FCC63777
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F61C22227
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cdpgOQSJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgKTJno (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbgKTJnn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 04:43:43 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53086C0613CF
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:43 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o21so11981157ejb.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rX9XfHhXf9sK0NoFo9P7mnliYZ0IH4YeOB5MqGmFCZI=;
        b=cdpgOQSJARKlT9lttFs3Lu2tcnw+4Ab24kxGYRfdV8reTRrQOd+Byi/lpZb0QxyySE
         irmAxKoiHyAPVxK9Y4px2oiIhEle1tD6vBCffplT2sh8G6n2tILlEqh+c9sK3Eq2ekNY
         u8b94sYVtW/ECBR4B2Sxnpq1xqFy+EjZV9OTf+SXixyQK0EeHEI+C4K9G9UBfxFON9Gu
         SnRwJNde5kGNnU1QS3SlBtIg0Ud/rOANjhpPKoJ5o+db6KcGUNPM7Crsd4YQ57RbRBnf
         OP9Dmw6LEBVIWXzAgccsckB2MkanGXkAgmYfaV/ykgIsAu8fvCVKz1UoJ3pXa+PvuHUD
         WbRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rX9XfHhXf9sK0NoFo9P7mnliYZ0IH4YeOB5MqGmFCZI=;
        b=jlTUUPwQVCary5h/1aeFPBlaAmtvjKbvwF5Pg05dSyZsDVC3H44Wcma2KO/lWEOm83
         HDT735Qc3MvBB2d+evzmK/HsFyMX+sL2NMD4tFAnHj58n2LLMc+Qr5rGOMBMG3bRYjOs
         SKWMWdgWLtpK9fpIuQxFKcF3pSKaQdXLXSUCnAnjfKwjZfz1STP1jI0z4sY7M4gQddTk
         exqeqwprb6L6iahrRwgzAkHqDR/knxcvG/x1jVrvTv+WHdnJ3AVh8aY2YhkzYP4PNuK6
         e+rm07l0u0Ff8GRBBa1VdKtGSQ4U3ujqnos0DGVP+m7VpNu1Ny1heKQdKxT+2XHwiLym
         awXQ==
X-Gm-Message-State: AOAM531bpku8mpYiHvCuZ9Ga6wcMP2lBK+HVNcO70n76+ZTtdmveaVD5
        APfSB/pePQFAjdD3gXHJpidPDVTDOz0=
X-Google-Smtp-Source: ABdhPJzlcozqjhjUWRdG182o/QI0lCyuCqn4IwcIn0NYZ/M+zTAdpS0Lj381wQaZ0KTkX5wRh46q9A==
X-Received: by 2002:a17:906:6d13:: with SMTP id m19mr32505454ejr.345.1605865422088;
        Fri, 20 Nov 2020 01:43:42 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id h2sm897006ejx.55.2020.11.20.01.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:43:41 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 18/20] kernel-shark: Protect ksmodel_set_in_range_bining()
Date:   Fri, 20 Nov 2020 11:43:02 +0200
Message-Id: <20201120094304.271502-19-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120094304.271502-1-y.karadz@gmail.com>
References: <20201120094304.271502-1-y.karadz@gmail.com>
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

