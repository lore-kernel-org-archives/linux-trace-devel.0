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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46B2C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 08:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7D4761249
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 08:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhDOIP7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 04:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbhDOIP6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 04:15:58 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26A6C061756
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 01:15:35 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z1so26945462edb.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 01:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gUodvn4gT7Nvx4P5LWgrs3io/c+FH7XPpUCLhsJ+bak=;
        b=hyO0NQji0xrctfAvS73r48HExO9wGszKDBtGuBZb6kGYx72r7F41I85zF7ayFJ2hAZ
         NAZFcJR9lb9sk48hy4HQS8OWjN3nM32nLE3TZT4n0CWi4iiqKu6sc3ixobxWnVxW5Gkx
         eAkSftoLU7ev5VGcejownFRIbmxAu4hr9KzkfLPLikrNwrx/9mv36ldOgsqjprHiDiNZ
         jYdKrZsVSc81FoUiB/LKABwHkAKWzR+ELjEKacRE5OAknu9TsD8YLvv+b9PdwCCb3jxE
         CDjxChN4RwOfbL77XJ5P6BR+UZhg9db0hBBj4nhrpMYFJi/4t/5cuYfOU2uwnlg+VTQS
         Tryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gUodvn4gT7Nvx4P5LWgrs3io/c+FH7XPpUCLhsJ+bak=;
        b=HePoO76CQi+NWZ1vmTp6ZL25L0Gdh571z9IWpCtaMCAUimm+1Udbiquj8wM6B7x937
         XGva3wZd93FVRjN5TRdAXCOC2Rp0pmihMXK/poMacTnmYLdaPFFZfUi7D6vYX3YZg4xS
         ghZPrCuC5yaLrDJaVJjwZPa0Jnfx0vJSnbYglZ4T8PFC0okfiy7HAWxM+DZDUsRNGLp8
         pRmxrFGg0Mp5L06lC0iRf4y6X8IlzY7nKRJc7x90rM4rso7PmRvI4a8NLr/hhPaixcqX
         TxW24tq3M5HpjujBpEzQVjtoJCumXX5ECoRZcSmrmommG9KXa5uX3+Gp9yCJjDn2aZkI
         bIbQ==
X-Gm-Message-State: AOAM530Xpzj3uTYbxpB6q6y4GxwEW1nC7FhXDhHeA2RZW5g7yoDcc41A
        AvHYtyByfQHMw4VrvWB+A9o=
X-Google-Smtp-Source: ABdhPJw/J142kINA9DEqIB+3BC642WNTVg3wYoKPdsVSLJjJm6mffyi6NpfFN/EkQi1keUvqxB5EvA==
X-Received: by 2002:aa7:c455:: with SMTP id n21mr2660521edr.48.1618474534439;
        Thu, 15 Apr 2021 01:15:34 -0700 (PDT)
Received: from oberon.zico.biz ([151.251.243.123])
        by smtp.gmail.com with ESMTPSA id r19sm1312840ejr.55.2021.04.15.01.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 01:15:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] trace-cmd library: Add check before applying tsc2nsec offset
Date:   Thu, 15 Apr 2021 11:15:26 +0300
Message-Id: <20210415081527.3483835-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415081527.3483835-1-tz.stoyanov@gmail.com>
References: <20210415081527.3483835-1-tz.stoyanov@gmail.com>
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

