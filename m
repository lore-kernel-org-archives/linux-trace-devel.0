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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585DAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F17460F0F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbhIMM3h (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236796AbhIMM3g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:36 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92829C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:20 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id v20-20020a1cf714000000b002e71f4d2026so5137051wmh.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AA+PGUMl91DR7kV9NuJ9YoaOinBRBGDhoRdn94IqH5o=;
        b=aCJE9HYHxqab9cjnWVGsCnQJE1Qe4YUgtnwPo++62fEvWanzvlutORwOc53mO2M25k
         mMnkO26zyu9cR/R2Ginty0tO4EJm3AmCH1J6qBz2yNVGSIWjQ+xuZ5owPU2OW6D80eEN
         0qsDjFmZmvBzY9GxEhBmut8er/2BjuCGPtJdMv67CnFDEv3w/GWpZiQNvhW4bZho2ooq
         diJG9Z5BEx7xcTdMTsiKWIDmrrkNm624hO8xRuBCv/4l00n4ipqFr9X4K4zHyzBn1jps
         TrbhMcSYWjr5bsRyBaX1nSMAXqH9wLpiVlDqztCXJ5rbhKMCvBmKYaHmc2IwxAzwuU4W
         pKlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AA+PGUMl91DR7kV9NuJ9YoaOinBRBGDhoRdn94IqH5o=;
        b=lIf3xiyXPpyM6uxJXbDOPw5gMoT1zGzAxnEJvltWCWwXR1X/jz80tjsEZIc8acLzam
         oUp8T3u0f3zTyRDvM+uAbg+lBLX2MFHZlrkgnlU48j5H+k4zRfycg36V9Oy8xG9zDRJM
         p6sVOeK9IomYSiPI3rH7quugbdSuWTedVzKDVg9mVWLqaQKcZfOyVXn5U85x29GwloLt
         J5lFhzEXrQJwS6x0iju/A6VJ23Ct8klk+TFVOiUUTHNr8+0pvXVgA6jSozhnSwF5li+g
         ycHlsWaQlim+RNgWFnTYreo/slKRljznjlR5mH9/yC39A1vrK2MLi7vnsz8tkNn8lzuZ
         qbWA==
X-Gm-Message-State: AOAM531juru9+IJNiEi7ab8jGGtSWbwQXYGcQAw0WMX0fd3mvumgwtle
        kNQ9Cde1WyeQl+48CplQoaGSvKmZn8A=
X-Google-Smtp-Source: ABdhPJwbkbXms5bs9xuSPGqg8kaNcpbcWwxUNhAykqNKx/Hb1tM5G1WTRds6fev/DId8XvA0pIqBLw==
X-Received: by 2002:a05:600c:3585:: with SMTP id p5mr1159748wmq.110.1631536099221;
        Mon, 13 Sep 2021 05:28:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 18/21] trace-cmd library: Set correct CPU to the record, retrieved with tracecmd_peek_data
Date:   Mon, 13 Sep 2021 15:27:56 +0300
Message-Id: <20210913122759.3672494-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This clean up is needed for the design of the next version of the trace
file, where only CPUs with trace data are stored in the file - empty CPUs
are omitted. Changed tracecmd_peek_data() to use the CPU id, instead of
the CPU index.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index dc82d3ea..de8e0d72 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2019,7 +2019,7 @@ read_again:
 
 	record->ts = handle->cpu_data[cpu].timestamp;
 	record->size = kbuffer_event_size(kbuf);
-	record->cpu = cpu;
+	record->cpu = handle->cpu_data[cpu].cpu;
 	record->data = data;
 	record->offset = handle->cpu_data[cpu].offset + index;
 	record->missed_events = kbuffer_missed_events(kbuf);
-- 
2.31.1

