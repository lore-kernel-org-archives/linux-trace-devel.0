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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 613A1C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 05:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 319BB613CF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 05:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhDGFMU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Apr 2021 01:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhDGFMU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Apr 2021 01:12:20 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26347C06174A
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Apr 2021 22:12:11 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id d191so8352719wmd.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Apr 2021 22:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3I+hhFqi6s0iH8QxfetNfLV9is3l4uhdiIAZN2/Rb2E=;
        b=MUk1vkSKtyhNlXg1OS5nOWcH869Pb8g+NxrIfj+vVDFO/sTI9bqoK+RakdBOgKfzwk
         7G29FWiMIwFJO66TtgRQzbrnCe5DnlqlsnaqDwgwKHBEquZsRc5w/3+Ij0o1pDBI7Xzh
         dPYL0bQBhlA9pfV6p93HkxemrtwDEWDmK9wBNLr6GbJBwVmfQkjTcJ+0eDoTNxjAevEv
         qB+eOb5tWjJtxlH+geR7EYRfYS40D2hncS5/u/4H8XjMo8hYsLcOfBjJgxQQbYt63TgJ
         3q14cWsvJHdu2KtjvgYMI8j0MzK01zXlwx04SOGjbES8zBsI6eKSpVUVupLru2TbhW6u
         V+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3I+hhFqi6s0iH8QxfetNfLV9is3l4uhdiIAZN2/Rb2E=;
        b=IoBnI1y5dgKbL3k1daKQ2ErMIp6iXEU3R0CHeur6NBgl/PSnMYSp/JJXRr1jayWpXs
         4urKmaEVlW46eqq3echUXFYKTMOv4vhAvsPKr4IVlPIf7fN+Htlk95iGRpFC9udHfh+E
         bqCyEvwptQ5Rz6/HLQnqvDbjdW9UpECwln3rDJUZJg2J06MdpVcpoTrgjp7hpcxOTR9p
         KEqdGsJUDVEIUE6BuvuvHPfrCRDHjuOCQ3GNydse5y8JCaXBjYHo5rb1EA5LQjeZSfcR
         AK1Z8Ch860D4GGO82n3YAC5Q6loMtBBbykxkp8bEFwXpm67EZ6Tu2VEt1z+MDhL9GFcE
         jlqQ==
X-Gm-Message-State: AOAM531xe5XkWKn0q8cXWVgGdXnzuia9SfQIIYnZoxl0U6Ej8DQ5Q1JA
        cQAMEDv1oGiZ8enAxpsewhUxDLQzGgvOlw==
X-Google-Smtp-Source: ABdhPJyNl4KgrrxMXCVTjrg53Weu3BgbKN+35Pail3FJTMTGf3aNbodXPLt/4eNu3SxU2fZtspzdbw==
X-Received: by 2002:a1c:df55:: with SMTP id w82mr1240096wmg.162.1617772329939;
        Tue, 06 Apr 2021 22:12:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e10sm19954194wrw.14.2021.04.06.22.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 22:12:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtraceevent: Add tep_warning()
Date:   Wed,  7 Apr 2021 08:12:08 +0300
Message-Id: <20210407051208.2422248-1-tz.stoyanov@gmail.com>
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

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 plugins/plugin_function.c |  4 ++--
 src/event-parse.c         | 22 +++++++++++-----------
 src/event-plugin.c        | 14 +++++++-------
 src/event-utils.h         |  2 +-
 src/parse-utils.c         |  2 +-
 5 files changed, 22 insertions(+), 22 deletions(-)

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
index 0560b96..50992e0 100644
--- a/src/event-utils.h
+++ b/src/event-utils.h
@@ -9,7 +9,7 @@
 #include <ctype.h>
 
 /* Can be overridden */
-void warning(const char *fmt, ...);
+void tep_warning(const char *fmt, ...);
 void pr_stat(const char *fmt, ...);
 void vpr_stat(const char *fmt, va_list ap);
 
diff --git a/src/parse-utils.c b/src/parse-utils.c
index e998671..139b82e 100644
--- a/src/parse-utils.c
+++ b/src/parse-utils.c
@@ -32,7 +32,7 @@ void __warning(const char *fmt, ...)
 	va_end(ap);
 }
 
-void __weak warning(const char *fmt, ...)
+void __weak tep_warning(const char *fmt, ...)
 {
 	va_list ap;
 
-- 
2.30.2

