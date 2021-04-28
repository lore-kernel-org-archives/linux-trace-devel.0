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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E5AC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 536E3600D4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhD1Haw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhD1Hav (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:30:51 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3112C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:30:06 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id u21so93141549ejo.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8HuFWNZvUbEQt+HXbmP/jdGZc/zIp99hePuygD6I6ow=;
        b=q+XPm/vW839b+YUxnhyDEmN8sVozn2PkSMArA1It1CYhJ15SIW1QUS4sp8cR4uW1Kb
         TLjPu1QRSVynoXOyzMGOUWHogKvT+swlZp+dVfNR7mNuRXN/YQ3LC/Q5E13KKCf4SFuw
         4vxGcHq4h77uY3cIN4eeXeNiD7UASIAcJw9zGtd6HrHI09HzVVcOkV0ZZjCgkhlgAQa5
         5567M8QzOCQ+fxq49aCqZz2cXz/61bWeZkL0KfSk1J8OQWYARDgRapjW/WsNdz4d8Af9
         pkpJ/f7nOJCM4CJIqHwcHs1lXDcYagFdLLaLvjKTZbSPaUlMTJ4cZcudLr3xHtA9YcON
         z5Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8HuFWNZvUbEQt+HXbmP/jdGZc/zIp99hePuygD6I6ow=;
        b=Z9cHcgf07SpNhKUhIFKzZK/7aRAMCTFpFPAiK6hPc0WqozKqWxfen01kzECWdh2LQT
         FCTn+w6K4sIuAmWgiyHkGogZ8gZM4hYCdCPxYlxUB8R3m8qIqfIewsIBEf/laRr5LvwI
         OGPv0VXwvb74x3jEx9Hh1CofGTQuA+obgKGgqHhKJWY6R8b3GZN6vmd7Hqo7lDJWqSl6
         NtHg8lgmDUNHsvV8q/Hfwnu4uY31loDG6fG/V2YK53ohExIcwxf/XBxf/sKkoGvIe0Z7
         QJBJ2OpKedUY+rIG7SbKm4QsKSS0Hau/PNqScfPhLdzqTym171LeckoLfGBkk+lmhz/z
         iVVw==
X-Gm-Message-State: AOAM530Z2S89pRDxVULEgtd7rv3lZZjYNbNeU0+MHY0Xuwaezt90kWEn
        ZZmIyTc6idA00NDxx5dpzCU=
X-Google-Smtp-Source: ABdhPJwAppB31FJ0ftIwG7CkQUhC56vaxBjEn7yX6GbDpOooZgl80+qYbn5mI3Q6tZiHW16QMYNb6A==
X-Received: by 2002:a17:907:10d8:: with SMTP id rv24mr27094025ejb.542.1619595005729;
        Wed, 28 Apr 2021 00:30:05 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id dh6sm4274292edb.63.2021.04.28.00.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:30:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/4] libtraceevent: Add logs with severity info
Date:   Wed, 28 Apr 2021 10:29:59 +0300
Message-Id: <20210428073001.755905-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428073001.755905-1-tz.stoyanov@gmail.com>
References: <20210428073001.755905-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Renamed existing pr_stat() internal function to tep_info() and limit it
to print only when the log level is TEP_LOG_INFO. Removed duplicated and
unused functions:
 vpr_stat()
 __pr_stat()
 __vpr_stat()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/event-parse.c  | 14 +++++++-------
 src/event-plugin.c |  2 +-
 src/event-utils.h  |  7 +------
 src/parse-utils.c  | 24 ++++--------------------
 4 files changed, 13 insertions(+), 34 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 88ec909..97c1a97 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -6927,8 +6927,8 @@ static int find_event_handle(struct tep_handle *tep, struct tep_event *event)
 	if (!(*next))
 		return 0;
 
-	pr_stat("overriding event (%d) %s:%s with new print handler",
-		event->id, event->system, event->name);
+	tep_info("overriding event (%d) %s:%s with new print handler",
+		 event->id, event->system, event->name);
 
 	event->handler = handle->func;
 	event->context = handle->context;
@@ -7404,7 +7404,7 @@ int tep_register_print_function(struct tep_handle *tep,
 		 * plugins updating the function. This overrides the
 		 * system defaults.
 		 */
-		pr_stat("override of function helper '%s'", name);
+		tep_info("override of function helper '%s'", name);
 		remove_func_handler(tep, name);
 	}
 
@@ -7542,8 +7542,8 @@ int tep_register_event_handler(struct tep_handle *tep, int id,
 	if (event == NULL)
 		goto not_found;
 
-	pr_stat("overriding event (%d) %s:%s with new print handler",
-		event->id, event->system, event->name);
+	tep_info("overriding event (%d) %s:%s with new print handler",
+		 event->id, event->system, event->name);
 
 	event->handler = func;
 	event->context = context;
@@ -7628,8 +7628,8 @@ int tep_unregister_event_handler(struct tep_handle *tep, int id,
 		goto not_found;
 
 	if (event->handler == func && event->context == context) {
-		pr_stat("removing override handler for event (%d) %s:%s. Going back to default handler.",
-			event->id, event->system, event->name);
+		tep_info("removing override handler for event (%d) %s:%s. Going back to default handler.",
+			 event->id, event->system, event->name);
 
 		event->handler = NULL;
 		event->context = NULL;
diff --git a/src/event-plugin.c b/src/event-plugin.c
index df4a0a3..f42243f 100644
--- a/src/event-plugin.c
+++ b/src/event-plugin.c
@@ -497,7 +497,7 @@ load_plugin(struct tep_handle *tep, const char *path,
 	list->name = plugin;
 	*plugin_list = list;
 
-	pr_stat("registering plugin: %s", plugin);
+	tep_info("registering plugin: %s", plugin);
 	func(tep);
 	return;
 
diff --git a/src/event-utils.h b/src/event-utils.h
index ff4d6c4..1951557 100644
--- a/src/event-utils.h
+++ b/src/event-utils.h
@@ -9,15 +9,10 @@
 #include <ctype.h>
 #include <stdarg.h>
 
+void tep_info(const char *fmt, ...);
 /* Can be overridden */
 void tep_warning(const char *fmt, ...);
 int tep_vwarning(const char *name, const char *fmt, va_list ap);
-void pr_stat(const char *fmt, ...);
-void vpr_stat(const char *fmt, va_list ap);
-
-/* Always available */
-void __pr_stat(const char *fmt, ...);
-void __vpr_stat(const char *fmt, ...);
 
 #define min(x, y) ({				\
 	typeof(x) _min1 = (x);			\
diff --git a/src/parse-utils.c b/src/parse-utils.c
index bc89c44..b997823 100644
--- a/src/parse-utils.c
+++ b/src/parse-utils.c
@@ -50,31 +50,15 @@ void __weak tep_warning(const char *fmt, ...)
 	va_end(ap);
 }
 
-void __vpr_stat(const char *fmt, va_list ap)
-{
-	vprintf(fmt, ap);
-	printf("\n");
-}
 
-void __pr_stat(const char *fmt, ...)
+void tep_info(const char *fmt, ...)
 {
 	va_list ap;
 
-	va_start(ap, fmt);
-	__vpr_stat(fmt, ap);
-	va_end(ap);
-}
-
-void __weak vpr_stat(const char *fmt, va_list ap)
-{
-	__vpr_stat(fmt, ap);
-}
-
-void __weak pr_stat(const char *fmt, ...)
-{
-	va_list ap;
+	if (log_level < TEP_LOG_INFO)
+		return;
 
 	va_start(ap, fmt);
-	__vpr_stat(fmt, ap);
+	tep_vwarning("libtraceevent", fmt, ap);
 	va_end(ap);
 }
-- 
2.30.2

