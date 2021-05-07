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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD44C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3608661059
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbhEGJyk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbhEGJyk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:54:40 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E47C061761
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:53:40 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id u13so9512202edd.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wF8u9Jrym8Q2KVTiI435kCIiqYjj3/Tg6jcIA91IEqo=;
        b=vVQrDZ8OyL7OJcc2xEcYs+j/W4LtfKG9G4bQJZn0imIjwwFrXohN6EILaACDZiyiWR
         zCGKy+fAUW2Xw4CsM7AAQpGfnLjd+ezn+mEiQI6t4FO1hv0niNAMrvc4dKYpI+Sh6HOC
         ZN7BmhzvgjWWJmBFjw2HFAPKRIrAtxahmRgjFc3VhsKEZy2QjQSt0YCa1Zj3YdZCkvm2
         yJcELAlVvywL0FBdOxnd4MVkGQE2te1VAnCFzJlQ54kVrAV06Bu31v8+GMEdkqd9ORp2
         TDsFuuEOI9tnVbX29zQeac4Apk14yZvzXuEmmKNwK+h6NHKIkWccp30i84GDErF0c6Yf
         f92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wF8u9Jrym8Q2KVTiI435kCIiqYjj3/Tg6jcIA91IEqo=;
        b=HCIVbt7O3el8vDa3/Y/llYAU85lksq3Wfgu5zkAQ09MLr1K5HIUvyaAw6AsGbEmxXm
         aspBqfY88lR5UmIxJxzRHLE+HM/1YTVciv06HeeMrKCMi5rdEi2rzrZQeZ0uiLP98JB6
         /iPlxuyZ9VAfCq6gnvSO9naCdvExv1BArpazjnCBHvahVKjh6Lzh3OZX1C7d+MwVe6e5
         xk/KI2Gj97MrWV8+m6GWpGn85OKDsm2NfN5gtAZALZuqmvINpTeNmh6pSqffCPWqx+se
         0DugndNt14cnzTXms6plJwcxkEXTf2IFdpmQUcbnQhVgc1cc+Wkt4GvwfA0f/+VJ8Vsc
         oYKw==
X-Gm-Message-State: AOAM5308PsoI1wDS+1/klYkHT1WWghaNxXVT0OcT6xcNLcZpnGZWQUjN
        WQaIeJOFy0rIOU1LtD1GA2A=
X-Google-Smtp-Source: ABdhPJzfnfYS4oARpCWNrOiIOIm2UFDd3LDleeiyZd50jvOvYz0WIW9jpleS1D8+F/pwOy2qH/XdEQ==
X-Received: by 2002:a50:c44f:: with SMTP id w15mr10486599edf.79.1620381219382;
        Fri, 07 May 2021 02:53:39 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id cr21sm3105812ejc.2.2021.05.07.02.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:53:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 5/8] trace-cmd library: Renamed tracecmd_fatal() to tracecmd_critical()
Date:   Fri,  7 May 2021 12:53:30 +0300
Message-Id: <20210507095333.1080910-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
References: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace-cmd library function for pritning critical logs is renamed
from tracecmd_fatal() to tracecmd_critical() to be consistent with the
names of the log levels.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  2 +-
 lib/trace-cmd/trace-input.c             | 12 ++++++------
 lib/trace-cmd/trace-util.c              |  5 ++---
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 76179148..7bf620d4 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -10,7 +10,7 @@
 #include "trace-cmd-private.h"
 
 void tracecmd_warning(const char *fmt, ...);
-void tracecmd_fatal(const char *fmt, ...);
+void tracecmd_critical(const char *fmt, ...);
 void tracecmd_info(const char *fmt, ...);
 
 /* trace.dat file format version */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2e519752..5ee69b14 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1105,7 +1105,7 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 	int index;
 
 	if (!page->ref_count) {
-		tracecmd_fatal("Page ref count is zero!\n");
+		tracecmd_critical("Page ref count is zero!\n");
 		return;
 	}
 
@@ -1166,7 +1166,7 @@ void tracecmd_free_record(struct tep_record *record)
 		return;
 
 	if (!record->ref_count) {
-		tracecmd_fatal("record ref count is zero!");
+		tracecmd_critical("record ref count is zero!");
 		return;
 	}
 
@@ -1176,7 +1176,7 @@ void tracecmd_free_record(struct tep_record *record)
 		return;
 
 	if (record->locked) {
-		tracecmd_fatal("freeing record when it is locked!");
+		tracecmd_critical("freeing record when it is locked!");
 		return;
 	}
 
@@ -1375,7 +1375,7 @@ static int get_page(struct tracecmd_input *handle, int cpu,
 
 	if (offset & (handle->page_size - 1)) {
 		errno = -EINVAL;
-		tracecmd_fatal("bad page offset %llx", offset);
+		tracecmd_critical("bad page offset %llx", offset);
 		return -1;
 	}
 
@@ -1383,7 +1383,7 @@ static int get_page(struct tracecmd_input *handle, int cpu,
 	    offset > handle->cpu_data[cpu].file_offset +
 	    handle->cpu_data[cpu].file_size) {
 		errno = -EINVAL;
-		tracecmd_fatal("bad page offset %llx", offset);
+		tracecmd_critical("bad page offset %llx", offset);
 		return -1;
 	}
 
@@ -1949,7 +1949,7 @@ tracecmd_peek_data(struct tracecmd_input *handle, int cpu)
 
 		record = handle->cpu_data[cpu].next;
 		if (!record->data) {
-			tracecmd_fatal("Something freed the record");
+			tracecmd_critical("Something freed the record");
 			return NULL;
 		}
 
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b3f1b075..3b2a9183 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -390,8 +390,7 @@ void tracecmd_info(const char *fmt, ...)
 	va_end(ap);
 }
 
-
-void tracecmd_fatal(const char *fmt, ...)
+void tracecmd_critical(const char *fmt, ...)
 {
 	int ret;
 	va_list ap;
@@ -560,7 +559,7 @@ int tracecmd_count_cpus(void)
 
 	fp = fopen("/proc/cpuinfo", "r");
 	if (!fp) {
-		tracecmd_fatal("Can not read cpuinfo");
+		tracecmd_critical("Can not read cpuinfo");
 		return 0;
 	}
 
-- 
2.31.1

