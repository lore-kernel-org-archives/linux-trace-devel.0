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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB48C4727C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26635208FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:42:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lam3hpnA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgI2NmU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728617AbgI2NmT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 09:42:19 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC57DC061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:42:18 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e16so5493531wrm.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XKKQKSyh11GV8jmzTAm3bhr1xnYyypCdbLzIBowMB7U=;
        b=lam3hpnABjJq2ZzyDeCKsFvVP15VRbEPWPxFoIOH5JnMK4V3tcOedtrVqMIOQ/z1SK
         ZgGJmSBNoPCI60nOtf7fQKTyqsQdpqF7TdvDCkJvU34UX35xFXN2bq46YFPhpKhRj6VI
         BRPZb19EImkf6frfpVgRGh00YjsWkFOMw+rhrl7JB0ur7rGrrYirWkdXxDmt6+Rz6AUO
         BtIA2r7Mze1GoRUssUUPzH/J7qsq6YMGlSHYvQjc+3YRXc0VrV+SL892FLWDC0tjkCQB
         JUqU4zchf4S4Ias+ym6aM3jVKIJwTiKTjty2uLHB5tlu6D67xbVr6UBhBKvhClQQj8aN
         blYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XKKQKSyh11GV8jmzTAm3bhr1xnYyypCdbLzIBowMB7U=;
        b=eujarxcC1C0YqJzhoV2ec4xMEr+6wxmFx0fsF/8ndaxrXwcuJ0PDAn1k1Js30LVctt
         5LlZ6P6lYdEwI0o5bg1s8vkPsELWM31yHlxD4H/Uk4LN3msSEpL22bxDsqIj56iQCi4p
         oGElGInCQ6ahpsDXm1O2J/ynzXxAjrtJLa1ZjN6vhPIGqmbnTicK+qoZ3AWwoz2ZuwLh
         kdMaAYMagL9W0NavSeaQ+UOC1c4RTCu7tMAc9JsKvzt1XgIICmkfSK7K+3D9SieQBg8K
         ABPR69mmJpygOnpPRyIWmusTjOYpv6TIsRPak8jiWLzZdaAQBrIycMGqvsCBdO9Qgg3C
         gtXA==
X-Gm-Message-State: AOAM531wfk1MKH2xRTcGEWgmWuvjYnP3W1szQjGy+HLfzTTYZgS0Nht1
        C8hysY/NaKpYridT0u0DoFM=
X-Google-Smtp-Source: ABdhPJyexAaRi86SV2HhAhP0cia+OryJuBv45sJVAl2see2Z46M6MJTYDCdunsa+VZvfl46w0jRggw==
X-Received: by 2002:adf:8342:: with SMTP id 60mr4904140wrd.158.1601386937651;
        Tue, 29 Sep 2020 06:42:17 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id b84sm6162792wmd.0.2020.09.29.06.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 06:42:17 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 13/15] kernel-shark: Protect ksmodel_set_in_range_bining()
Date:   Tue, 29 Sep 2020 16:41:21 +0300
Message-Id: <20200929134123.178688-14-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929134123.178688-1-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
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

