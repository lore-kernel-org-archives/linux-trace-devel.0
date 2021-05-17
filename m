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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4FBC433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 638D1611BD
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237426AbhEQNl2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 09:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbhEQNl1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 09:41:27 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63256C061573
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:40:11 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id di13so6959668edb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yXcjd1VSx2FcFrHV2TYzupMqnptDEgXSHYvfrFfjJ9s=;
        b=guGC5uE/Lw2B/fp+D4BGYpBsnT2QQl/3rU1+HsXszxiRKCupbZWyYdbUHYMWKo0b9U
         8HVdJ8jRMy/Oq8s8k3xp1aRkf+2tURP5Zu8aCLqZv98RMFIYLEwavWDBdvtpjVTZ2dxD
         aJiiMUC3fT7FVvJMVreTdaSkk7vEAnwcg2QcsIYW8BhIxPhL2I6aMkuCfGcDcNG1kJjy
         FWCSreYak86d7RL//NpyWILQAg/yAx2OhDciKs4ItXTDeFrdDpS6c47jWD3ktsSkx/+h
         1FJ28k5PgECiOBTi5dqin0rY4sDgSuXcydN0BJMOzdJPcRpsyDC6ynQX/dzAXht33WPs
         PfRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yXcjd1VSx2FcFrHV2TYzupMqnptDEgXSHYvfrFfjJ9s=;
        b=bZ32wHPEZ4iy7AkmWesZ7m8cL23/IRCJOv2ifQkdp1Ndu402UZ7WOYJHZE6jujfGVh
         prOj3X8UFXFn+Ot+KvN9VHqSXWnLlR9cc9/i9myx3ZTQI/MIqIC3JkN6i7PBThi6XcmB
         M6u1MmrHJefbsET19hl+0eSmxOwj5WvRGoqMTnetkovDZEL2hYZXHBMB+M/h8dpKbe6e
         wLNWY1Kk45iX2WYEFiSNsJMzL02KB7Giq9dyJbHRE9c3rGCwqPL6+rQPbbQdDTfDl6wr
         QfSSkx34Pwf7JW+FFu+mMSkL2hIoHdVgEOglUjf/v18V+I0xx39JrRA5Vi78W8jC2UvO
         2ANg==
X-Gm-Message-State: AOAM5302WyLyWRrD3XF+7pgJa4H+5pLfEkLeraKzIzDT9LzsBgMLW1I5
        8X888Hz2D9esLmWzIpCsFNY=
X-Google-Smtp-Source: ABdhPJw5CuhTKzWa5G0Lz0AIjwwdzamj8IKVy4amzr/fTPBG9troNOMyPX5DtwB0EAntyG7jBhF51g==
X-Received: by 2002:aa7:d890:: with SMTP id u16mr65005edq.49.1621258810157;
        Mon, 17 May 2021 06:40:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r25sm10961799edv.78.2021.05.17.06.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 06:40:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/6] trace-cmd library: Renamed tracecmd_fatal() to tracecmd_critical()
Date:   Mon, 17 May 2021 16:40:02 +0300
Message-Id: <20210517134005.611251-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517134005.611251-1-tz.stoyanov@gmail.com>
References: <20210517134005.611251-1-tz.stoyanov@gmail.com>
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
index cd868f60..821b5cdb 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -11,7 +11,7 @@
 
 /* Can be overridden */
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
index 6db754e4..be9fcf0e 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -390,8 +390,7 @@ void __weak tracecmd_info(const char *fmt, ...)
 	va_end(ap);
 }
 
-
-void __weak tracecmd_fatal(const char *fmt, ...)
+void __weak tracecmd_critical(const char *fmt, ...)
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

