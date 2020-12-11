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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EF2C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 601FD23B31
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392801AbgLKPLm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437694AbgLKPJ4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:09:56 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4E9C0619D2
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:39 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id c5so5738040wrp.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XKKQKSyh11GV8jmzTAm3bhr1xnYyypCdbLzIBowMB7U=;
        b=NLKw+SmcJ3GeWq17ByE1chTTIejqSfOCPOEJT1Yy/LJy8tJMv0Qhu+Dajjzi51vlVf
         jfZW3rd3HubqMRxTWetpuS6Ul0IY/kf3nZnb2zL3YZRzXSyuNxs7Vx8AHYdbcd204Dw7
         DSvLIk5JiLXTkNgZJRZ624qvUdRQGNGXAxGnT5A10QOXxYYZvXxjfd907LGgHut9amUG
         kSM9XfHpNBg1ZVZ4kY4srp+bI2MwHFsj4LZEFSHXrB9RMfQZyUaM1ji8th9KLXS09xJs
         XfQOx/uiNpvwnd+0c6FnNX9/PWmg5Xeb/YwwueWnSApn1g+Oz/0g0i6Muluag0g7Cqq5
         F62A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XKKQKSyh11GV8jmzTAm3bhr1xnYyypCdbLzIBowMB7U=;
        b=tPjEQgM5sZGePXUtpAB4MPcmCDy9S0MjnbH1KBcdfWeQDv0trKCBZ3xEnWtg5OBuzN
         uLFdJo/2bhemy4t9+hFVUTmwAMmRNTw33V28sNHNx0TSEH/aTHhd4pQEJ6LzTbIycaOa
         zbP9W0lKDaJJkbd4dPqPqFaA4Cn21cEGKbhEX2nW7+ltSrx1eA2nHX/R+mI/iY8XK//6
         XaT67+IPwWWdnw8sKwh75U0vHhFXm0ozcL7QiGycwec6CX/fw/2IOVGeuZfoX4B4LsDL
         SRT60d3PW2hAKQQllSUc/dWDBrXQ+mYu+yRsHmnO4RbL4fTIzO4jHLMdiTmDHkIBkNwz
         uLjw==
X-Gm-Message-State: AOAM531dBNMW99RfSK7RgHy4F4Krs4RRFTBizml5Ppmm66fXx/xphrn1
        Xdf75tW0PnMccXRHkMZHoGM=
X-Google-Smtp-Source: ABdhPJx+eteBNzuxYwVKRdtGD2fwIl6hqbwa0Ev38rE2bZu0KBxUAW7/521gAP/6oeadGxI07Sh/xg==
X-Received: by 2002:adf:e80d:: with SMTP id o13mr14422758wrm.293.1607699318131;
        Fri, 11 Dec 2020 07:08:38 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:37 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 23/32] kernel-shark: Protect ksmodel_set_in_range_bining()
Date:   Fri, 11 Dec 2020 17:07:47 +0200
Message-Id: <20201211150756.577366-24-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
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

