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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE80C43460
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEF4D6145E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhEGJvd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbhEGJv2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:51:28 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB4EC061763
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:50:27 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id r9so12693268ejj.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kjeYPzWedHXFV9cUskK8JHWMrLdjtg+aql0UHmLl6LI=;
        b=YiGCI0Xf8eHulSKPhMXDLYQBpu6P+R18hbq5FSzxQ5SfnOKYHhSwq70PlVcc/idguI
         jHHw1mtANKkR9oSO67ekAUR1SOz2onarx77DWMju7hf1OJOPL6VPGk2IylkZCPoy2zd1
         aGDubGmO7Ih6hS/E3Xt3Bet7bMzKkEByPgmB4O2CEJklpOShHPFhx3Lx503hiEC6YfKo
         7WquymJeUBRmHYkrifHvFLRTQOc7WCLUG8yW3htMoyn/G6XM6a5p3Q6PJT6JuPavScb3
         E6QveVgd8oeOVtV+LVXwz6bbwlNilzuy2u1pxFjfLfS2GxYGF7PHCDH76fD0wHiu/d4d
         lCQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kjeYPzWedHXFV9cUskK8JHWMrLdjtg+aql0UHmLl6LI=;
        b=BH2Qqkth38lx+ifivhF8MBaGkha/gpinyv0dTcELf3biO8YUXlWCjlAWXbCb1cAV8z
         Mig1iXC5jeyqBL0N2uMVQ+DJQph2Z2D9vlxCoJ+mtnjJmVy9TWKc6GMsp2kYcfjKNRzu
         ljcUA+Z6Wpc4eOON5MCIFMQWMNNOX85lj3s8zutiCW6EeDSr5huUV4uYqOyRpyzqiShx
         cI4cnz5pvBccm2tQFLPZI2/MXIvY0sVW15wHZX27bGXv7TaG29oCfcJdG7kPOkAPQLXP
         rYMdzzVhqOPklXNNoig/JbIjK/ZenrC5gsUt90WhJv1qWwig2rkMVkBek0FbEJ7k9Tli
         oqvQ==
X-Gm-Message-State: AOAM532YQM25q3p8MnCR5bPQxLS01W6QUchHt3GQ5VeBVzhKGIihOsRb
        VA7hhQHpp5GFWB4ubx5oK1PWuw8kSWdQhA==
X-Google-Smtp-Source: ABdhPJx/90NYWV649M60aeOlphZsbW0M7Bf3mudi4l/nEYea4HJeG/lu/M/GFbG6Q/sPZRTTDKiDTQ==
X-Received: by 2002:a17:907:948d:: with SMTP id dm13mr8561374ejc.180.1620381026650;
        Fri, 07 May 2021 02:50:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a24sm3787193edr.74.2021.05.07.02.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:50:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/4] libtraceevent: Add logs with severity info
Date:   Fri,  7 May 2021 12:50:20 +0300
Message-Id: <20210507095022.1079364-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507095022.1079364-1-tz.stoyanov@gmail.com>
References: <20210507095022.1079364-1-tz.stoyanov@gmail.com>
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
2.31.1

