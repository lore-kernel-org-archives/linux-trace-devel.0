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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC28C43461
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55DE1613D6
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236599AbhEGJyo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236866AbhEGJyo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:54:44 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8221BC061761
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:53:43 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id n15so4888436edw.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=atjZ/yiZiHgCaYm70jJ4k62FlJxalnCDG6n7ncN5BNU=;
        b=Yp+QBNEHNO17uLSts81/rgUmC+yJEuwNc2O639fWW83Y/5NXkE+1BtsX7p+MJxLIHC
         0otOFYkmIqgbqkjOMWXL2p2/euoWKUqlgOG07Fv2oUbPArTgeZVIUHGkh2YyUMiiKMY9
         f8Fj6Z9uwcl67GccnCoIAK4C9wzmAqEW4/coIGkmmDKN+eBRw7AVSw4GUG0Tk3fR/oES
         sw0yM5a6n4/Ukhs348jJjri575Zc4b0ZkPc5oFsMwXUX84EPElGdUQLRnYHNi3+UNhJX
         sreuH3QDeZXNmFV0dv+gGExrZ77dGD67To9FhK/X1WudxvnfRKyG6+szH142ZNSRrLpO
         Vf6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=atjZ/yiZiHgCaYm70jJ4k62FlJxalnCDG6n7ncN5BNU=;
        b=KK68iuyBBrlgNn5sDUC3m4qIB4/trmZ0gW8DdwMtT2iLW9h9uJYG6ykJtsv50IJaki
         udHzkVxQYBcnitxXjlQNXmXp3Fx8uRpiGdd+nyTjho344qt3BluR8DczAt8OUydpRpfV
         Zaq4gp/8W8JoIa7A/wEl3ZTp6KGZJp0wlliV8g9307DCwtY8f1XgdZ4+KomhkEsC4jXZ
         wPnYW1CJQbGkSQ7bIfitf/DNQp3xAxQtu+IXRYRIAhLP3WmxkPcZPA+deJwHR4rrXdYk
         n64TrJBeHUd0mZx1LTcn7/SWTX5lu76bC9hc0/261JJVj3feebMGZx2wB4avmUIu6EJK
         pt/Q==
X-Gm-Message-State: AOAM532xAMkUJ0uqCKtaE2JzPCbPP0ohx9ZVDWlZLLhiWko8amTTCW6w
        HJrQnROe28hW+7C+OqC+CkA=
X-Google-Smtp-Source: ABdhPJxqP19TdAyg3Y6TRJQYGkvPHPgiahq7Nfd+DhV8Ks4NPn3hWS6VR3g9HFztwbc+SF1qfzju2A==
X-Received: by 2002:a05:6402:26ce:: with SMTP id x14mr10184768edd.216.1620381217404;
        Fri, 07 May 2021 02:53:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id cr21sm3105812ejc.2.2021.05.07.02.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:53:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/8] trace-cmd library: Add log levels
Date:   Fri,  7 May 2021 12:53:28 +0300
Message-Id: <20210507095333.1080910-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
References: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add levels to library logs and introduce a new API to set the desired
log severity:
 tracecmd_set_loglevel()
When a new trace-cmd library log level is set, propagate it to tracefs
and traceevent libraries as well.
Removed the "weak" definition of the library log functions. Setting
the desired log level can be used to silence the library logs, instead
of overwriting the log functions.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h           |  2 ++
 lib/trace-cmd/include/trace-cmd-local.h |  1 -
 lib/trace-cmd/trace-util.c              | 26 ++++++++++++++++++++++---
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 7305487c..6984db86 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -43,4 +43,6 @@ int tracecmd_buffer_instances(struct tracecmd_input *handle);
 const char *tracecmd_buffer_instance_name(struct tracecmd_input *handle, int indx);
 struct tracecmd_input *tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx);
 
+void tracecmd_set_loglevel(enum tep_loglevel level);
+
 #endif /* _TRACE_CMD_H */
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index cd868f60..76179148 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -9,7 +9,6 @@
 #include <byteswap.h>
 #include "trace-cmd-private.h"
 
-/* Can be overridden */
 void tracecmd_warning(const char *fmt, ...);
 void tracecmd_fatal(const char *fmt, ...);
 void tracecmd_info(const char *fmt, ...);
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 049fe049..b3f1b075 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -30,7 +30,7 @@
 #define PROC_STACK_FILE "/proc/sys/kernel/stack_tracer_enabled"
 
 static bool debug;
-
+static int log_level = TEP_LOG_CRITICAL;
 static FILE *logfp;
 
 const static struct {
@@ -355,10 +355,24 @@ trace_load_plugins(struct tep_handle *tep, int flags)
 	return list;
 }
 
-void __weak tracecmd_warning(const char *fmt, ...)
+/**
+ * tracecmd_set_loglevel - set log level of the library
+ * @level: desired level of the library messages
+ */
+void tracecmd_set_loglevel(enum tep_loglevel level)
+{
+	log_level = level;
+	tracefs_set_loglevel(level);
+	tep_set_loglevel(level);
+}
+
+void tracecmd_warning(const char *fmt, ...)
 {
 	va_list ap;
 
+	if (log_level < TEP_LOG_WARNING)
+		return;
+
 	va_start(ap, fmt);
 	tep_vprint("libtracecmd", TEP_LOG_WARNING, true, fmt, ap);
 	va_end(ap);
@@ -368,17 +382,23 @@ void tracecmd_info(const char *fmt, ...)
 {
 	va_list ap;
 
+	if (log_level < TEP_LOG_INFO)
+		return;
+
 	va_start(ap, fmt);
 	tep_vprint("libtracecmd", TEP_LOG_INFO, false, fmt, ap);
 	va_end(ap);
 }
 
 
-void __weak tracecmd_fatal(const char *fmt, ...)
+void tracecmd_fatal(const char *fmt, ...)
 {
 	int ret;
 	va_list ap;
 
+	if (log_level < TEP_LOG_CRITICAL)
+		return;
+
 	va_start(ap, fmt);
 	ret = tep_vprint("libtracecmd", TEP_LOG_CRITICAL, true, fmt, ap);
 	va_end(ap);
-- 
2.31.1

