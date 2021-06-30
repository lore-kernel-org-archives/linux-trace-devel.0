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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92E1C11F65
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 19:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A136B61474
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 19:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbhF3TkE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 15:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhF3TkA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 15:40:00 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB25FC061756
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jun 2021 12:37:27 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id i20so5831859ejw.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jun 2021 12:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eK5n5hhP36vGGY2XkS8TgB+6ndt5eUiulyfOb5s/Cuo=;
        b=hl/zRHFvABi1eneNntOStR/xU9ypFb8wG8+A++4xac/btYJC+V8D3JhVpRzX/8IgFS
         dhRhVD1elbJFn2X36vkvKwBoDkL3m7vQMIU0KHrinFulr3Qjx6iFsf7AmOgoi3jHlXQu
         KAvyU2CAfWNI2ZS5r6dO/0xu7yX15Vb8UEup2KUnyAjUTRvvMSuPjvwc8MGqwk9+pu2R
         DE7k8Mjm+mZwKqrIw/rB9R+kgubxTGck6gpQEHQ7QkJbkFPcAWpUn+o9D2oxZ1N6juWY
         tLz24n/Svkzo6INOAKWmTpVzaxPUm57VskvfXHG2u9wI9BQDPwmPMm0otPTUZ6wC7WiQ
         P0eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eK5n5hhP36vGGY2XkS8TgB+6ndt5eUiulyfOb5s/Cuo=;
        b=myqvp9TinQeTyDJr1a2N3Hts9evTQyTm4BvODmdxgm7Ydmujw0NyzzjcpaLi4rs+Fb
         HsIuZaJ7boAqSeIJchjmQne+bTFalaFWhvuEPrMLDb8ROkVeDUxENeA1gsMjrc7LHexI
         PYUxThlUL6uLTOtXWnnFHSoJb4bB4jrrkRfmDLbmp1u8jLFl/TRGQIZp9amePHyfwapT
         J4gWe0+rDzo6c9PCvigp3TAl6sV240YwYusF0a/x0n3oYllLWP6taHjf3W4UJIbtmllT
         OQRGeUQC3ivfGAIHiMEZNKhcvc27BuLZslbBChtx8Dg1maLEwve8iD7GYirj34RngL1v
         PG3g==
X-Gm-Message-State: AOAM532i1oh3BVcNX+J6MJYTjVAV0EoU3O4E9+eDRV3QDnsuDs7ySAuv
        QVqEoaGq4031y4lMgD/0hos=
X-Google-Smtp-Source: ABdhPJz1Wu6UgXWO5m0fPEuZBXUBhw3xJHhfSHOOQsG0Oj/QJU494givYQwkOH0dvZt2GRLt1NZc/A==
X-Received: by 2002:a17:906:6c92:: with SMTP id s18mr36351864ejr.246.1625081846329;
        Wed, 30 Jun 2021 12:37:26 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id g8sm3778994edv.84.2021.06.30.12.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 12:37:25 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2] libtraceevent: Fix bug in tep_print_event()
Date:   Wed, 30 Jun 2021 22:37:14 +0300
Message-Id: <20210630193714.27338-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We must handle the case when the "tep_event" object is not found.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/event-parse.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index de28b3b..f42ae38 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -6418,17 +6418,23 @@ void tep_print_event(struct tep_handle *tep, struct trace_seq *s,
 		     struct tep_record *record, const char *fmt, ...)
 {
 	struct print_event_type type;
-	char *format = strdup(fmt);
-	char *current = format;
-	char *str = format;
+	struct tep_event *event;
+	char *current;
+	char *format;
+	char *str;
 	int offset;
 	va_list args;
-	struct tep_event *event;
 
+	event = tep_find_event_by_record(tep, record);
+	if (!event) {
+		trace_seq_printf(s, "[UNKNOWN EVENT]");
+		return;
+	}
+
+	str = current = format = strdup(fmt);
 	if (!format)
 		return;
 
-	event = tep_find_event_by_record(tep, record);
 	va_start(args, fmt);
 	while (*current) {
 		current = strchr(str, '%');
-- 
2.27.0

