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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65FEDC43460
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21B8860234
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhD1HdB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhD1HdB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:33:01 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BC7C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:32:17 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id j28so8950649edy.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yRTCBQFY96x+Vp1w2uiOlUjReQ2K91011H8356Xg0kU=;
        b=fMyT2SZTmBxCcv+pdqm22HYdrbliJgKn107rYFmwAE1/7TlZHYJwJq0eJiwRknOQ1O
         4m3N0LJ4LXMss+zO9CXgYHLCHRaZgLOIDC+zj3TRhF7LNKwIsKz4EmabPDiGRbLaXK2k
         mxyQqnlfvMezW8CX+sbfR+xSfjQiKt/iZa/sJfAy/2TFZ29jvVGcHUgRZM4QbqJcvH5j
         dVtX3hqww8+ruksBfcsciVWhJSsZGPZLSv/ioAfj0GaFDB1IKm3kLCsdodNuw2U0kNTp
         /DjMGmI/iCl8WHloR2Ozcs4rENgOP4cr0PZZdMS+/UgZUvlSXU9fvcdsP5rn6nKVF7Es
         1nyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yRTCBQFY96x+Vp1w2uiOlUjReQ2K91011H8356Xg0kU=;
        b=PxZ0ZYEzh/IoNDFoCAB4QZ/jSDKK3TzmIqjnpUVbAaWImAlk/s5bvlM63DZw2ueoM5
         T4pR0myRIoxeUVTT69qB8GYUdDepPUzCscR5cE+x87EAxHpDz0VbhH9V+nhZ/MRFqeux
         shhvVJX5YBJZlIErYsoLdZLskRygpXmSieQY+D4EZ82IFgzBwoa7S3A5GiW8Qku2xmcO
         vZRJvUttm4EsZMHw5BUJZ+W2ABrpCtiJIi3+QRiCntBnxIrbqjNXJqKFe0uOMEkpPEkB
         jzdb8AHVrSrcWX0EaZQxNBlx5OiD2kLWUv9H+SR1GjpIwovmPyBvVJPFXm7kKSkLF4yq
         qYPQ==
X-Gm-Message-State: AOAM531665h40V8CDreM8kci1IXTJ++DU/xQYGKu96bEA3glhioGtx+t
        buS/NNMksoB1Llb2oeUdZDw=
X-Google-Smtp-Source: ABdhPJzpcR289ojb203VVBmwStz/pmJjihCaA4xtNONuioFpKADh6eRqm/BbdnHTWQjofT31ffqyMw==
X-Received: by 2002:aa7:cd83:: with SMTP id x3mr9077314edv.373.1619595135953;
        Wed, 28 Apr 2021 00:32:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z26sm1363646ejd.52.2021.04.28.00.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:32:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] libtracefs: Add API to set the log level
Date:   Wed, 28 Apr 2021 10:32:11 +0300
Message-Id: <20210428073212.756329-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428073212.756329-1-tz.stoyanov@gmail.com>
References: <20210428073212.756329-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Library log level is added and new API to set the desired level.
Log levels defined in libtraceevent are used. By default, the log level
of tracefs library is TEP_LOG_CRITICAL. When a new level is set, it is
also propagated to the libtraceevent.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h   |  4 ++++
 src/tracefs-utils.c | 18 +++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 551c37c..da40e4f 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -177,4 +177,8 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 int tracefs_function_notrace(struct tracefs_instance *instance, const char *filter,
 			     const char *module, unsigned int flags);
 
+
+/* Control library logs */
+void tracefs_set_loglevel(enum tep_loglevel level);
+
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index e10b333..3cd5208 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 #include <errno.h>
 
+#include <traceevent/event-parse.h>
 #include <traceevent/event-utils.h>
 #include "tracefs.h"
 #include "tracefs-local.h"
@@ -25,12 +26,27 @@
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
+static int log_level = TEP_LOG_CRITICAL;
+
+/**
+ * tracefs_set_loglevel - set log level of the library
+ * @level: desired level of the library messages
+ */
+void tracefs_set_loglevel(enum tep_loglevel level)
+{
+	log_level = level;
+	tep_set_loglevel(level);
+}
+
 void __weak tracefs_warning(const char *fmt, ...)
 {
 	va_list ap;
 
+	if (log_level < TEP_LOG_WARNING)
+		return;
+
 	va_start(ap, fmt);
-	tep_vwarning("libtracefs", fmt, ap);
+	tep_vprint("libtracefs", TEP_LOG_WARNING, fmt, ap);
 	va_end(ap);
 }
 
-- 
2.30.2

