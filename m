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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E6F1C43460
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 10:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73B6061166
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 10:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239981AbhDPKej (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 06:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235193AbhDPKej (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 06:34:39 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B92C061756
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 03:34:14 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id 12so26213002wrz.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 03:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gUodvn4gT7Nvx4P5LWgrs3io/c+FH7XPpUCLhsJ+bak=;
        b=flnFpW7GLOyt/In3+jY8oKwTbOtE0AvUib3sBRyEOc9fBD3ucrH+SfrOaDy+jWpLi+
         IQDiZeIT9KAVosUHTCu160L2LNg2kaaur8QTn1CErxTK+alawQf26uuHr83AN1XtCvqH
         T6yOOE4Ti4Ub+nNCAnz0Cg/MRqOtw49rkhNRPjroM3TJrAL9AQCaOstcgRrRMfmgI07L
         XMtQKg8HtmLkrX9jFcDvTEf8pIL9eqyCRzJs3koOTTK9L9mhpv1qOwGf7zMxkhj4MrsY
         waJ4CF9EtQoZfdxOrIX2XaToM2t7HbJysrCE2Q2+lwgJZVS9pO9DOh1JKWbpCtpR/uQC
         O+Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gUodvn4gT7Nvx4P5LWgrs3io/c+FH7XPpUCLhsJ+bak=;
        b=IxXmPt8VMfnTYzIF2srGgv2kkvRH9Lbrzc6Rko4a2yJJfMZ33YqbdEUfAl/HYyc+5r
         A9+4vZC36GXTuOzwu04LpPVsoJHwGGiyk2y3dW4t/HrnsvxJL4NQAZUw7b0X1bXWWD4e
         ZMreS83SSBKH3NAwkKqUi7osjNEEX3swbVXaOXClOwEFOHPGKV23uUW1M983r/hCvR6J
         X6NVnsEWC+yHiMOAMSGETqb7mstXsVzpi0+ryvQ2LpRGt6RlqGOG7FNYdwcV1UbJBqgd
         TBWsRln5u1QK7HfkbemR/xzbY/vdKxr8WlO2w2oO6xcADp3ecEjcLjXGw8Qt6ESKf1a+
         fTHQ==
X-Gm-Message-State: AOAM5305WY9cdil4tGm2k+fB9SoFychEfda1c0LgKLKNkp68D+Yrzw/O
        cczrU35TBugjFt3Oa2uwBQeM2LtdRAvlOA==
X-Google-Smtp-Source: ABdhPJzk2YzNbvLRM1B12JJ+t1WMB0Qi0vmXnsv+b+UbEZXEdGyT1CirWx3lLoBf8fz6W8FmVqo/2g==
X-Received: by 2002:a05:6000:a:: with SMTP id h10mr8289662wrx.297.1618569253285;
        Fri, 16 Apr 2021 03:34:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v8sm9652139wrt.71.2021.04.16.03.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 03:34:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/3] trace-cmd library: Add check before applying tsc2nsec offset
Date:   Fri, 16 Apr 2021 13:34:08 +0300
Message-Id: <20210416103409.24597-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416103409.24597-1-tz.stoyanov@gmail.com>
References: <20210416103409.24597-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When converting TSC timestamps to nanoseconds, an offset is used. That
offset is subtracted from each TSC timestamp, before the conversion.
However, if the timestamp is lower that the offset this causes an
overflow, as both timestamp and offset are unsigned long integers. A
check is added to verify the subtraction will not cause an overflow. In
case of an overflow, the timestamp is set to 0 and a warning message is
printed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 974879e8..991abd5f 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1230,8 +1230,14 @@ static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
 		ts *= handle->ts2secs;
 	} else if (handle->tsc_calc.mult) {
 		/* auto calculated TSC clock frequency */
-		ts -= handle->tsc_calc.offset;
-		ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
+		if (ts > handle->tsc_calc.offset) {
+			ts -= handle->tsc_calc.offset;
+			ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
+		} else {
+			tracecmd_warning("Timestamp $llu is before the initial offset %llu, set it to 0",
+					 ts, handle->tsc_calc.offset);
+			ts = 0;
+		}
 	}
 
 	/* User specified time offset with --ts-offset or --date options */
-- 
2.30.2

