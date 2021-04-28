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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11AE7C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6D22600D4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhD1Hax (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236448AbhD1Haw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:30:52 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01686C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:30:08 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id q6so13688039edr.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zSOgWJ95EEp7A5+Wy9y/1qppCgR2i4QV4RIFIX7Utfg=;
        b=bwlLyRfVJXwVTJ+f4EG3GeDdaJ6AYtRlxW9mCBbuRNPQmCzsFvPhwDkjZ8Duv3BpjE
         E8y2BWl33DyjkpXwQKWJxJJb+gGQq8g/DjrrWTjhn8mBIewMYmkSunq+KLKQrowk48pM
         M81bRMQy29NpxsicnCOUOR4Au7FjS18Js28XebvK84TLGyCo3W/sbt4NFovDXLfb5r8y
         u56BDqqDCVoFKa09b/GBNcUQespzZJnkQU/5ZkUfiYLs8x4VtMJCHvcjgyKeFNc5Xnbl
         kYTDd1ItRjtx4bUhG+P1hnhu/icrakEbdj6MX1TCw/TQc6H/4cdcHXJo03aY8qAJCa80
         A5Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zSOgWJ95EEp7A5+Wy9y/1qppCgR2i4QV4RIFIX7Utfg=;
        b=DlIET+1r3iq6skdcjAJR/tRxjOft7QbGxLac345J/0/G2H1x7sD/Gx02n/bXESvlyd
         R3plTyiOvTuUJWiIET2EGGwL9RAdeNwrb/EgIK8+zGEVucYAbI8LDJlMcgehtMaTzdMa
         ZaJ9q5QRA+wEhXOpCxKN8jMYQNYYweQTs3gqazNlGVWhGqZgTqi5YJCovuM+jN9oxJMs
         iIT954dqznZi3Mh77GE2Jnq6smdnarRWswqWyVI8aGo+O8Jkef0AtgOQdTUYC6raDSEr
         F5eD8Zw8bLzcyrb7ECjXqK/6ndsA1qgekXWBtmbzY/B5tS9gCXjkPVYmSpeCL3fJRdkK
         S8xg==
X-Gm-Message-State: AOAM533PwbbGam8TSLpmHwlktn2Z2v5hMo3kRZ/KjTz8XUwYVTrrKs/R
        6aKRyr///uolRsDlCYtYx3mv6yr3LgcPKQ==
X-Google-Smtp-Source: ABdhPJxJzvN0k6p+elnUlXHaQMxVMO1KZ4Kip8GpEUNbl7E0GhBXB6LxTny/AoHS3AhTRfM1t47FAw==
X-Received: by 2002:a05:6402:350e:: with SMTP id b14mr9633994edd.307.1619595006817;
        Wed, 28 Apr 2021 00:30:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id dh6sm4274292edb.63.2021.04.28.00.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:30:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/4] libtraceevent: Rename tep_vwarning() to tep_vprint()
Date:   Wed, 28 Apr 2021 10:30:00 +0300
Message-Id: <20210428073001.755905-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428073001.755905-1-tz.stoyanov@gmail.com>
References: <20210428073001.755905-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Renamed the existing weak function tep_vwarning() to tep_vprint(), to
match its purpose. This function is used to print library logs with any
log severity, not only warnings.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/event-utils.h |  4 ++--
 src/parse-utils.c | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/event-utils.h b/src/event-utils.h
index 1951557..0e09838 100644
--- a/src/event-utils.h
+++ b/src/event-utils.h
@@ -9,10 +9,10 @@
 #include <ctype.h>
 #include <stdarg.h>
 
+void tep_warning(const char *fmt, ...);
 void tep_info(const char *fmt, ...);
 /* Can be overridden */
-void tep_warning(const char *fmt, ...);
-int tep_vwarning(const char *name, const char *fmt, va_list ap);
+int tep_vprint(const char *name, enum tep_loglevel level, const char *fmt, va_list ap);
 
 #define min(x, y) ({				\
 	typeof(x) _min1 = (x);			\
diff --git a/src/parse-utils.c b/src/parse-utils.c
index b997823..b4e95b7 100644
--- a/src/parse-utils.c
+++ b/src/parse-utils.c
@@ -24,11 +24,11 @@ void tep_set_loglevel(enum tep_loglevel level)
 	log_level = level;
 }
 
-int __weak tep_vwarning(const char *name, const char *fmt, va_list ap)
+int __weak tep_vprint(const char *name, enum tep_loglevel level, const char *fmt, va_list ap)
 {
 	int ret = errno;
 
-	if (errno)
+	if (errno && level <= TEP_LOG_WARNING)
 		perror(name);
 
 	fprintf(stderr, "  ");
@@ -38,7 +38,7 @@ int __weak tep_vwarning(const char *name, const char *fmt, va_list ap)
 	return ret;
 }
 
-void __weak tep_warning(const char *fmt, ...)
+void tep_warning(const char *fmt, ...)
 {
 	va_list ap;
 
@@ -46,7 +46,7 @@ void __weak tep_warning(const char *fmt, ...)
 		return;
 
 	va_start(ap, fmt);
-	tep_vwarning("libtraceevent", fmt, ap);
+	tep_vprint("libtraceevent", TEP_LOG_WARNING, fmt, ap);
 	va_end(ap);
 }
 
@@ -59,6 +59,6 @@ void tep_info(const char *fmt, ...)
 		return;
 
 	va_start(ap, fmt);
-	tep_vwarning("libtraceevent", fmt, ap);
+	tep_vprint("libtraceevent", TEP_LOG_INFO, fmt, ap);
 	va_end(ap);
 }
-- 
2.30.2

