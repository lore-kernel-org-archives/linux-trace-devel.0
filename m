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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB3BC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA311613EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbhD1Hmo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236888AbhD1Hmn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:42:43 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486F9C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:41:58 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g10so5042356edb.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dyRpt8LR3emmeL6vzgGDgPExTCJRo6rFUvBT6aaQ3as=;
        b=Be6LF4TPFX/MKqvsMUtjrlYXJNGgaRMLvhtTIL7lSju8JJP2/2tYO5Q/865Z70KwkY
         Dq6jru8Mp9BFqLbJEYNIB44LnKPmbIxBljRrmuGCV9aiYe/5PH3FmrFMGIr8q5KJiwhX
         EV6usCkdAWIxkhJ7S5SkVEHSZ6xuzu5Axw215UqJKHYNebSPEs468Dny3QLGnqnbPq1/
         HpVXg5vRzlz7Fmqjl24idUkD/Z/bsQXnApnDROSnsKlaODNOUrcr8hWC3v4YBgwKZ+E6
         M3NbU/4Ay+ZaB9N6NJGRuDp46BEu6abveGL+yw4d7WdUxTjQ6y2MclcDQ5Rs/pri2Tyk
         FQOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dyRpt8LR3emmeL6vzgGDgPExTCJRo6rFUvBT6aaQ3as=;
        b=BLOJucMZjodhxOQ/sBKECf2kECr/XPEFMzIxJeFIZ9lTbZZCRc5qVATdvOBkkca0Gg
         rF9d6x1mrjahZ8AySH3a3EDnzxBRJvNb/PdxrjJ6cQORn03omXc22nTzkNKby52jZTZJ
         drUJJhbtwHJnRBp+XjOUArTtU6MwfrHhe+zbcnP9nvhwUDL4oY/Eq5IC3DIfUTQ2O8h1
         c2GyTcBo3vlsEEs1m3ShNC+l8JrV4nazicNpMjeTAGetThQkMBigBLSKoBzikfwyfH9u
         5e+DRFenFsm6dS0aLAoySW+VrQg4NcmpJP0mcKI5piw11dNWzX/I9aGoAmi21sfLs5vT
         tJAQ==
X-Gm-Message-State: AOAM531ToQVi/pYPo/LF41OG4hVQaKDyzIOgjhAFLOfQwZYeAV57+Upd
        buxwIhZClrbnOlgAYKhmN/1oupmKSPTa3Q==
X-Google-Smtp-Source: ABdhPJwOiTmIz7HvS6X68AIJRcHgIVgpIMmiod005DiFTCAaGeua9dypMSsyk1hb/jBPFFU12SoM9A==
X-Received: by 2002:a05:6402:cb6:: with SMTP id cn22mr9287266edb.302.1619595716990;
        Wed, 28 Apr 2021 00:41:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k5sm4530504edk.46.2021.04.28.00.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:41:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/8] trace-cmd library: Renamed tracecmd_fatal() to tracecmd_critical()
Date:   Wed, 28 Apr 2021 10:41:46 +0300
Message-Id: <20210428074149.757163-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428074149.757163-1-tz.stoyanov@gmail.com>
References: <20210428074149.757163-1-tz.stoyanov@gmail.com>
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
index 733e1858..f13402f8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1104,7 +1104,7 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 	int index;
 
 	if (!page->ref_count) {
-		tracecmd_fatal("Page ref count is zero!\n");
+		tracecmd_critical("Page ref count is zero!\n");
 		return;
 	}
 
@@ -1165,7 +1165,7 @@ void tracecmd_free_record(struct tep_record *record)
 		return;
 
 	if (!record->ref_count) {
-		tracecmd_fatal("record ref count is zero!");
+		tracecmd_critical("record ref count is zero!");
 		return;
 	}
 
@@ -1175,7 +1175,7 @@ void tracecmd_free_record(struct tep_record *record)
 		return;
 
 	if (record->locked) {
-		tracecmd_fatal("freeing record when it is locked!");
+		tracecmd_critical("freeing record when it is locked!");
 		return;
 	}
 
@@ -1376,7 +1376,7 @@ static int get_page(struct tracecmd_input *handle, int cpu,
 
 	if (offset & (handle->page_size - 1)) {
 		errno = -EINVAL;
-		tracecmd_fatal("bad page offset %llx", offset);
+		tracecmd_critical("bad page offset %llx", offset);
 		return -1;
 	}
 
@@ -1384,7 +1384,7 @@ static int get_page(struct tracecmd_input *handle, int cpu,
 	    offset > handle->cpu_data[cpu].file_offset +
 	    handle->cpu_data[cpu].file_size) {
 		errno = -EINVAL;
-		tracecmd_fatal("bad page offset %llx", offset);
+		tracecmd_critical("bad page offset %llx", offset);
 		return -1;
 	}
 
@@ -1950,7 +1950,7 @@ tracecmd_peek_data(struct tracecmd_input *handle, int cpu)
 
 		record = handle->cpu_data[cpu].next;
 		if (!record->data) {
-			tracecmd_fatal("Something freed the record");
+			tracecmd_critical("Something freed the record");
 			return NULL;
 		}
 
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 6f9da7c7..25c1ee92 100644
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
2.30.2

