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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE30C433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56B7220700
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbhADRtT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbhADRtR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:17 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54484C0617BF
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:48:04 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id b9so37958611ejy.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XKKQKSyh11GV8jmzTAm3bhr1xnYyypCdbLzIBowMB7U=;
        b=vgsBe0eqXrd6EiWuzb8Z4K5HnP4CvoBFXOtHJlZ5K0rhfhP+bDaE0tHby+FnICq4RD
         /dRJmX9DQ8dqRUoD1wqSArsn5G9CzRqhmy0Mcv4wvuagbhqq4n+/NQnADXn6WXLAVLUx
         O4jtJGvjS6FlklSiLcC2ZCdY4HZSnQf8yshlF9Vuh3lnpMmoVlpNVfZcPSKLcKS6d8vv
         ScmjcvoOYmfCxbHpFFMRsv3LgnbpTKftgtzk5BRL4Z6SHCcK3e9Ff7wGH7fyaJQ9cxb+
         PCwS26JGi9u+54afPsks34yvdPP8ob93Ajlyu1UxoMZcic/RG7kA/7fd3IlwgmARcbXE
         1Xjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XKKQKSyh11GV8jmzTAm3bhr1xnYyypCdbLzIBowMB7U=;
        b=f67BiaeEfKF4jkK3FW4i9SjUHMYWLQZ/AauK01SRjjPwIs4HLEPqisqUxKI1W6cXCR
         lSN5+SnLckZt8hfApX6bhPQJuJoP7niFrk1a0qvfviIjYb5EeeHEmSohYugS3y9wDYTO
         oo5ACy4ulBCSpRiVk/pprtqa+ntNUanhUUF0lsjsjVlEuFucPfsz/hfzUcTQML+wNnKR
         L3CSVAYv24eyVNYjw0h3KVlBnledOZrVO3tM7YHuQKReF8YPLtnPzrawfbQabsKIz1Iu
         tP8P6UnLX2uBrm9nHUCKJS89yb+Re0w53TgQoBIEZduJ2gUHxefHBTR4moWaTmnTlYS4
         AHWw==
X-Gm-Message-State: AOAM531Eh6il4hYcb86sgrKl3X0jnj7odzs+a1CY/w8W8GLMdxl/aERh
        v62wWjwQ5qFk+w8+NpV2xtk=
X-Google-Smtp-Source: ABdhPJzSEfabpSnkn/fIBPXMFNUvct+1dWK/r8VSVnpZqhGopuDjdoSuL/OtdZ13x9F/XW98qRbWkw==
X-Received: by 2002:a17:906:7f83:: with SMTP id f3mr56443269ejr.282.1609782483163;
        Mon, 04 Jan 2021 09:48:03 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:02 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 26/44] kernel-shark: Protect ksmodel_set_in_range_bining()
Date:   Mon,  4 Jan 2021 19:47:06 +0200
Message-Id: <20210104174724.70404-27-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
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
index 2301b06..44f829d 100644
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

