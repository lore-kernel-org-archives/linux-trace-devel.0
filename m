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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D61C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 04:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57C68610FC
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 04:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhDHE0h (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 00:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhDHE0g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 00:26:36 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52681C061760
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Apr 2021 21:26:26 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id hq27so674820ejc.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Apr 2021 21:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=++v1SaBBXabIZ9lVU0bonDGBzDJSuq/XHIgAl8WTiTc=;
        b=r4nLj3ozHsSCyksfc8RAXD/MyD4msYH9NEw5nGjpv19OWx1weHVh7tK3sQ4XOZhWZM
         aLyY8b9Fe9wrJ2QVHygK5RlfxA1DNFzrvv9HHRUYgtxpz73sWeL3TiRRhiwRMnWf72Pj
         SvcbhECNl1XW0Z606sC/E2yobX6YbFpLUbc5RWxGVFcP2vOV6J1q1ZkPigTZpaIuGze+
         T9TzczvqVOKMwfZqk4wj0fR/0MNIOm2YzeTpz1CG21jMagbi2xDIbLBOw6Jr68Lpszhk
         BZDsmddnJBRv0tLdo442uj6Zw8ZwyuX4kkWRRGjtKYY7RndTnBnY658qQYHgCOtp1cSP
         P7AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=++v1SaBBXabIZ9lVU0bonDGBzDJSuq/XHIgAl8WTiTc=;
        b=ZbOQQq2mmQCbs7sGDojs3HIMrLPLg+qWxuzAxPNX1X1IXD5T47pzYxqRmmt69DcV4w
         5wh358GW8HqKdiGJSjod+Dwn8Ww1zvUVwPIsKEWwHEN9SHDWO7cGtj1t+eax2BRJMAFf
         PPzhO2q1IKu+WCp9/F6tBu7pmm2BKO8+/CaDgEd8SdeYwcsT9MXk5eRTnzf7D5wxDYrM
         NE5A/re9NFJzlXBGKAAOMiM2MF4zWMvwVJGCGtX2HwivRu/11Ynv5RWQyWOfeNh3A7Rl
         yK9c0Gj8VQlZTCUDygpI/mEPyRpA6JYtBaio/IAT8fl0XdnKQC9nBreAkIg2TXfREyIa
         hdCw==
X-Gm-Message-State: AOAM531q5G+8m56cNFqX/V/heZ5h2qIjtZnVk3J0pSPylO2mseUADqGV
        w3UdFuaxvPULJFY8+mfz/7y49FuRmZhulQ==
X-Google-Smtp-Source: ABdhPJz4JKdluuOexwtHhPZILWuAGYPFzCVT1L54S5kR+eUyhPStEx6fdVFbE44r8nMSQoW0tPTMCQ==
X-Received: by 2002:a17:906:2988:: with SMTP id x8mr7869938eje.168.1617855985048;
        Wed, 07 Apr 2021 21:26:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id hd37sm13022989ejc.114.2021.04.07.21.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 21:26:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] libtraceevent: Add tep_warning()
Date:   Thu,  8 Apr 2021 07:26:23 +0300
Message-Id: <20210408042623.3112002-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The traceevent library uses a function with generic name warning() to
print various warning messages. This function is implemented as a weak
and can be overridden by the application. However, as the name is
generic, there could be collisions with other libraries or application,
using the functin with the same name.
Renamed warning() to tep_warning().
Renamed__vwarning to tep_vwarning().
Both functions are weak and can be overrriden. Overriding tep_warning()
affects only the warnings of libtraceevent library. The tep_vwarning()
is used by all tracing libraries: libtraceevent, libtrasefs and
libtracecmd. Overriding tep_vwarning() affects the warnings of all those
libraries.
Removed the existing __warning() function, as it is not used by the
library.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 v2 changes:
  - Added tep_vwarning(), which is going to be used for all trace
    libraries.

 plugins/plugin_function.c |  4 ++--
 src/event-parse.c         | 22 +++++++++++-----------
 src/event-plugin.c        | 14 +++++++-------
 src/event-utils.h         |  7 +++----
 src/parse-utils.c         | 21 +++++++--------------
 5 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index 807b16e..93bdcc2 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -65,7 +65,7 @@ static void add_child(struct func_stack *stack, const char *child, int pos)
 		ptr = realloc(stack->stack, sizeof(char *) *
 			      (stack->size + STK_BLK));
 		if (!ptr) {
-			warning("could not allocate plugin memory\n");
+			tep_warning("could not allocate plugin memory\n");
 			return;
 		}
 
@@ -91,7 +91,7 @@ static int add_and_get_index(const char *parent, const char *child, int cpu)
 
 		ptr = realloc(fstack, sizeof(*fstack) * (cpu + 1));
 		if (!ptr) {
-			warning("could not allocate plugin memory\n");
+			tep_warning("could not allocate plugin memory\n");
 			return 0;
 		}
 
diff --git a/src/event-parse.c b/src/event-parse.c
index 2307e33..7c1f4cb 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -39,19 +39,19 @@ static int show_warning = 1;
 #define do_warning(fmt, ...)				\
 	do {						\
 		if (show_warning)			\
-			warning(fmt, ##__VA_ARGS__);	\
+			tep_warning(fmt, ##__VA_ARGS__);\
 	} while (0)
 
-#define do_warning_event(event, fmt, ...)			\
-	do {							\
-		if (!show_warning)				\
-			continue;				\
-								\
-		if (event)					\
-			warning("[%s:%s] " fmt, event->system,	\
-				event->name, ##__VA_ARGS__);	\
-		else						\
-			warning(fmt, ##__VA_ARGS__);		\
+#define do_warning_event(event, fmt, ...)				\
+	do {								\
+		if (!show_warning)					\
+			continue;					\
+									\
+		if (event)						\
+			tep_warning("[%s:%s] " fmt, event->system,	\
+				    event->name, ##__VA_ARGS__);	\
+		else							\
+			tep_warning(fmt, ##__VA_ARGS__);		\
 	} while (0)
 
 /**
diff --git a/src/event-plugin.c b/src/event-plugin.c
index e7f93d5..df4a0a3 100644
--- a/src/event-plugin.c
+++ b/src/event-plugin.c
@@ -454,14 +454,14 @@ load_plugin(struct tep_handle *tep, const char *path,
 
 	ret = asprintf(&plugin, "%s/%s", path, file);
 	if (ret < 0) {
-		warning("could not allocate plugin memory\n");
+		tep_warning("could not allocate plugin memory\n");
 		return;
 	}
 
 	handle = dlopen(plugin, RTLD_NOW | RTLD_GLOBAL);
 	if (!handle) {
-		warning("could not load plugin '%s'\n%s\n",
-			plugin, dlerror());
+		tep_warning("could not load plugin '%s'\n%s\n",
+			    plugin, dlerror());
 		goto out_free;
 	}
 
@@ -481,14 +481,14 @@ load_plugin(struct tep_handle *tep, const char *path,
 
 	func = dlsym(handle, TEP_PLUGIN_LOADER_NAME);
 	if (!func) {
-		warning("could not find func '%s' in plugin '%s'\n%s\n",
-			TEP_PLUGIN_LOADER_NAME, plugin, dlerror());
+		tep_warning("could not find func '%s' in plugin '%s'\n%s\n",
+			    TEP_PLUGIN_LOADER_NAME, plugin, dlerror());
 		goto out_free;
 	}
 
 	list = malloc(sizeof(*list));
 	if (!list) {
-		warning("could not allocate plugin memory\n");
+		tep_warning("could not allocate plugin memory\n");
 		goto out_free;
 	}
 
@@ -616,7 +616,7 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 
 	ret = asprintf(&path, "%s/%s", home, LOCAL_PLUGIN_DIR);
 	if (ret < 0) {
-		warning("could not allocate plugin memory\n");
+		tep_warning("could not allocate plugin memory\n");
 		return;
 	}
 
diff --git a/src/event-utils.h b/src/event-utils.h
index 0560b96..ff4d6c4 100644
--- a/src/event-utils.h
+++ b/src/event-utils.h
@@ -7,17 +7,16 @@
 #define __UTIL_H
 
 #include <ctype.h>
+#include <stdarg.h>
 
 /* Can be overridden */
-void warning(const char *fmt, ...);
+void tep_warning(const char *fmt, ...);
+int tep_vwarning(const char *name, const char *fmt, va_list ap);
 void pr_stat(const char *fmt, ...);
 void vpr_stat(const char *fmt, va_list ap);
 
 /* Always available */
-void __warning(const char *fmt, ...);
 void __pr_stat(const char *fmt, ...);
-
-void __vwarning(const char *fmt, ...);
 void __vpr_stat(const char *fmt, ...);
 
 #define min(x, y) ({				\
diff --git a/src/parse-utils.c b/src/parse-utils.c
index e998671..6a4a2cd 100644
--- a/src/parse-utils.c
+++ b/src/parse-utils.c
@@ -11,33 +11,26 @@
 
 #define __weak __attribute__((weak))
 
-void __vwarning(const char *fmt, va_list ap)
+int __weak tep_vwarning(const char *name, const char *fmt, va_list ap)
 {
+	int ret = errno;
+
 	if (errno)
-		perror("libtraceevent");
-	errno = 0;
+		perror(name);
 
 	fprintf(stderr, "  ");
 	vfprintf(stderr, fmt, ap);
-
 	fprintf(stderr, "\n");
-}
-
-void __warning(const char *fmt, ...)
-{
-	va_list ap;
 
-	va_start(ap, fmt);
-	__vwarning(fmt, ap);
-	va_end(ap);
+	return ret;
 }
 
-void __weak warning(const char *fmt, ...)
+void __weak tep_warning(const char *fmt, ...)
 {
 	va_list ap;
 
 	va_start(ap, fmt);
-	__vwarning(fmt, ap);
+	tep_vwarning("libtraceevent", fmt, ap);
 	va_end(ap);
 }
 
-- 
2.30.2

