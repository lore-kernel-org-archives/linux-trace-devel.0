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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46DEBC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14ED961407
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhD1Hmk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235862AbhD1Hmj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:42:39 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7784C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:41:53 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id c22so9343343edn.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ony9CCi3ZuhktnoFXPiqJ16zopPIAgjwby4VYHLSEUA=;
        b=OtP8CvauwYskCsc47FreUlqAIhciU2kGzj+AG0fddFaE76lsEvG3cs5hc6UYGP3yPm
         IfLGVH+CnC3VMB5yN49Jm1aq2xtrz5ad4KitzqCLrBnKgDkpzohDQj2xWLr1IFlRFUrC
         CZg442iTZnBK4BhBQ9iH6kHu9Qf/KoUjHpn5C/rPPFmVF7mPkVgdU8kRfNvg81Y/HHz9
         EDTpbn3uq4MGpnHx3hBp2aSckZiDADRXeYS2bEDgJUUS9pepFzLpdzyw2FDb1TISyeSB
         4BCRQRQhta2hONV1fXIJcMfeKmcMleqzgBSHdLBsBIlsTlwtfIl5A6DluFo80DuAlOvL
         vPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ony9CCi3ZuhktnoFXPiqJ16zopPIAgjwby4VYHLSEUA=;
        b=tvhL5cW78iT0oFd8GQ4kuu1BLf3lTSk6enXFBy2q2svQ34rehKoccJVNif48EIT4Dw
         sMuSGv//Nq4wdmenhvmzj9kPAgZncCWbAtSZgRm/3XG/yQ9RmLL6hiMx3qgI0G47cXxQ
         yuXYqvG+lIaUVsSb2ekBw6AtP+V4kVY4Ao1kaYMKtq6lsyLe9OaZMoDSaIJfEh2KWDoO
         +uMlDPOfjf0eURBRNRJlGUyzRhA5FtgxXrQ4pJHXGuA54i7Z9FArKnoahPi37tB+v2TB
         M5OkGiM/JRniH+g1RPh7gRcwHWgtlj6uWtUtdn4xWuZLgVGfjGrUOSvW8kywd142dyEA
         9rnQ==
X-Gm-Message-State: AOAM531DeQSVQaOU6NFc/zqsRM9l2RSUl9kYE0WxdojBnI/8cI0Sb4U6
        BUgMh18Ru+rVTzyORjRcT2A=
X-Google-Smtp-Source: ABdhPJzk5hoQKMGGN52Vy0VcDilnjhRSi8kW72TEP/LPAfDNsYubr3xqY1k9KeqzPsG0A8UuZkGXrw==
X-Received: by 2002:aa7:c1c9:: with SMTP id d9mr9201862edp.155.1619595712586;
        Wed, 28 Apr 2021 00:41:52 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k5sm4530504edk.46.2021.04.28.00.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:41:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/8] trace-cmd library: Use tep_vprint() for logs
Date:   Wed, 28 Apr 2021 10:41:42 +0300
Message-Id: <20210428074149.757163-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428074149.757163-1-tz.stoyanov@gmail.com>
References: <20210428074149.757163-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The traceevent library funciton for printing logs is changed from
tep_vwarning to tep_vprint.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-util.c | 5 +++--
 python/ctracecmd.i         | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 2d3bc741..4228b055 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -20,6 +20,7 @@
 #include <sys/stat.h>
 #include <sys/sysinfo.h>
 #include <time.h>
+#include <traceevent/event-parse.h>
 #include <traceevent/event-utils.h>
 
 #include "trace-cmd-private.h"
@@ -359,7 +360,7 @@ void __weak tracecmd_warning(const char *fmt, ...)
 	va_list ap;
 
 	va_start(ap, fmt);
-	tep_vwarning("libtracecmd", fmt, ap);
+	tep_vprint("libtracecmd", TEP_LOG_WARNING, fmt, ap);
 	va_end(ap);
 }
 
@@ -369,7 +370,7 @@ void __weak tracecmd_fatal(const char *fmt, ...)
 	va_list ap;
 
 	va_start(ap, fmt);
-	ret = tep_vwarning("libtracecmd", fmt, ap);
+	ret = tep_vprint("libtracecmd", TEP_LOG_CRITICAL, fmt, ap);
 	va_end(ap);
 
 	if (debug) {
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index e938c780..fa942215 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -63,7 +63,7 @@ void warning(const char *fmt, ...)
 		return;
 
 	va_start(ap, fmt);
-	tep_vwarning("tracecmd", fmt, ap);
+	tep_vprint("tracecmd", TEP_LOG_WARNING, fmt, ap);
 	va_end(ap);
 }
 
-- 
2.30.2

