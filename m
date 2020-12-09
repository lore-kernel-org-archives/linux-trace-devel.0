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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7ABC433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B966205F4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732626AbgLINoT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732582AbgLINoS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:44:18 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80F4C0611CF
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:42:35 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id x6so1783013wro.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XKKQKSyh11GV8jmzTAm3bhr1xnYyypCdbLzIBowMB7U=;
        b=ohNwMbSYwfbBSMFOpGqd6R7SA3djBP+qLCztZKVyjjUzAon7iONNKNdapYQZaoRi7f
         /tX6lCnurilFl39R9Ovt4/CRbSYciBKDowidHNa4/pN9mLCAUhAFxXV6t0MWCgDExBuz
         ZmmoZ9qx0ek+RfTaCoP6gvTdUKcE6t1lmgWrJYuxqN9axwNeL75Ta/p6TWXCRifyIOeU
         22S3ToZvhIubJu2HkV1IfGqQy+NMb/0v/SJG3w9nMe49MuTUusPklgf6rOgg7FNHMmFB
         nO6dpXV8KE1PVaI+uxMv9Xam/8WcyZgr1aB5LoPanB5q+HLx/mWSKGimjwd155Wtb5Q8
         QaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XKKQKSyh11GV8jmzTAm3bhr1xnYyypCdbLzIBowMB7U=;
        b=uAM0cOWOKbhBhDPOXhT1lC/nHwwjx44EON0IGwzxiA9QSG+ZpdcrwdfaKuA6Zbxzk1
         DvYDwKCgHxXdaYWTW6jpf2CRTrblDJALtU+aZGqo1R/8AK5Tfl30xyuj79L1YKPb5EIV
         TqefwY5uVmesrzEp6RB5r08c/ZJanCG1ThI6F+EqHSkzqaw7DyR5ccigmBiGnWhW8GPt
         b3h3RCTFOmqXicedpEAV1NcemLTNvrJkxl9otS5yVNmi9z8Hc6WrByxp17zVq4zH22Am
         K1XAz8KTI/lwP6gcpZx0m9qbVdZZ+eM0r9PY+2I0fSw8kTXBqVpLwEVi+8y2k4iIL50r
         N4dA==
X-Gm-Message-State: AOAM533MwsAJOql/KH/i/PlqvdPHTfaCm8OSuPoViQWJaD6v/2XSFdDX
        GhncIeTVsH0rceZhH2uwSLo=
X-Google-Smtp-Source: ABdhPJw2p49zzTJuKveFxaHBKwWhkp1a/HCAtYFPYDM8E3k5XJrhDqR5z62zdbmR7G9IzSI661Mh2Q==
X-Received: by 2002:a5d:6289:: with SMTP id k9mr2913802wru.200.1607521354644;
        Wed, 09 Dec 2020 05:42:34 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id q143sm3871071wme.28.2020.12.09.05.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:42:34 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 18/27] kernel-shark: Protect ksmodel_set_in_range_bining()
Date:   Wed,  9 Dec 2020 15:41:54 +0200
Message-Id: <20201209134203.428068-19-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134203.428068-1-y.karadz@gmail.com>
References: <20201209134203.428068-1-y.karadz@gmail.com>
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

