Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E77C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 12:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 537AE6127A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 12:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhKEMTW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 08:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbhKEMTT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 08:19:19 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90A2C061205
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Nov 2021 05:16:39 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 71so6859551wma.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Nov 2021 05:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kjW3Ft0o1QbRPEMydzIPROuQg3tDieB+hGug3dKaESk=;
        b=Q/hQ6htTu4N8/v9DiyCe74+gAyzuP7hc6Svgs6rzhjgg8tPfg/dj0eiq5M/uCG59rP
         xunLjROixdWnIFWHLwnBZL4CuIuz6/Fq8miDlKVRM4IoyO2R7Qa+si0sCxqR3D7uKud7
         WcvEBWywueGAITOnA4h7ip9hDU3V9Fq8lrZNcXaNN2RtIBjclHwrHc5CqqpDd5m0cNg2
         0aU9vM9A/0T2g9zaiafkhRP4e8gaGgTmlmfoH7EyV86GEDY5vY6p99F27xxnobZ9zcp8
         eL6g8/UYzCnROnmRJJmq0y09ZxxNZnTbjuIxC7cIkrPN8kIqmDsILYE1lV6mF/FUZLSU
         GVDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kjW3Ft0o1QbRPEMydzIPROuQg3tDieB+hGug3dKaESk=;
        b=LHKDYBBchI9leq6eTUwTblnaEpzei8G16in5qriFSaC3fdX+Z1QLqJ+os8I5mfNHdI
         8+kIPiMQe+SUKUUPOlJD1pSl7CGuhFqTZebN5rdFkwhwTBxUp5FuYGpRuAv8P+G0RED0
         tTwAxqUeHa7g+y6J7T9tXagdL7CHj25NXVvwKZk+Vq/klWN1sqHcwgtsOO2W+LUts5C2
         JVGfjnN4m9zgnFEuzo0/T5eHU/RsAatR2d5lGm5u4k1zCOMd5O2JJITlTYjhi1fMg2wf
         f8UNhXvcTx2K5mJ9aQ8kSqCHQ+i0bD1nGAVvk30v4w4BwCY1UZUdejNtIr6nK3JE8Bzq
         GCvw==
X-Gm-Message-State: AOAM531v+WERDtJubYwNqZ4Na74IicnUIM0s9wzdub7VPmoKx/QSzd7E
        phq9Gg07668OrZR4WHQlpEAigsUeCNhQ5Q==
X-Google-Smtp-Source: ABdhPJzlIO053SLhqhCKkPH1lovILq7V2GO+KxG4tQI4FLoEsPCshe6rsHDJcPQQGRRrHh/OcmQoMA==
X-Received: by 2002:a05:600c:202:: with SMTP id 2mr30226657wmi.134.1636114598364;
        Fri, 05 Nov 2021 05:16:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x13sm7936531wrr.47.2021.11.05.05.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 05:16:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 12/12] libtracefs: Fix duplication in synthetic events man page
Date:   Fri,  5 Nov 2021 14:16:24 +0200
Message-Id: <20211105121624.398717-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211105121624.398717-1-tz.stoyanov@gmail.com>
References: <20211105121624.398717-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There is a duplication in the tracefs_synth_create() man page description.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-synth2.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index f734b44..5338351 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -49,8 +49,8 @@ as a field for both events to calculate the delta in nanoseconds, or use
 *TRACEFS_TIMESTAMP_USECS" as the compare fields for both events to calculate the
 delta in microseconds. This is used as the example below.
 
-*tracefs_synth_create*() creates the synthetic event in the system in the system
-in the _instance_ provided. Note, synthetic events apply across all instances,
+*tracefs_synth_create*() creates the synthetic event in the system in the
+_instance_ provided. Note, synthetic events apply across all instances,
 but some creation requires histograms to be established, which are local to
 instances.
 
-- 
2.31.1

