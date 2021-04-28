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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBB6C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 414BC613EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236461AbhD1Hmm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235862AbhD1Hml (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:42:41 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35244C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:41:56 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id e7so72904809edu.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wE8HdGmKuoca9J+8oh31F6smXR7h6RkL8vlLj40oEP0=;
        b=B9PJQHhO/An3WrATj5x9zsQ8wWJRzv7trjG1ki0KCfMDVFZO/czUdNC3ZE1a5FLad9
         hl4siKKL/aOpY7kIDlhe1hacuVmZnNIr+rbPltZfgl+dkpDhL2KgdctPHdiXa/5ic7gT
         2sqku7luaJXD5VQPLl9zU5qQ5iGcOFZbIMFztxiaU+V2QhZf/73Y5qs0VbLE2a76I+Xt
         n8veJKaYvuu0zVM61CUsamZjPwGlhd6JTvlsJybw+vlssqFsqqIzpKprjIEbvwxkl/Mt
         chXGVrr91LVEq4/TFtOOYnEMY7Z2FjjjwznuBQpOTqGnTU0+v5/tckz9KQqwiOoyxURT
         c8ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wE8HdGmKuoca9J+8oh31F6smXR7h6RkL8vlLj40oEP0=;
        b=dzwQiNdSS8WP3w5uEVPm3AIbWgGFL301lU/d1hZ6lGFNLgWnj7ewAU8t/wR+uuUBYl
         z1OoKSwk3gdcYqVD9xnsWaiw5yzJQqF5+QeXY/RmdIHnjtYzVzyOB6NDfZFfZkbxun7K
         EIq5qDUA0Zy+tlr+yDt7wtvktHQlUWeel/SmPi2rXIkGrQasTVacZUxlBKiZ5YYdcbYY
         iv5fRe7hKnASLSjGxIuK8hJIKcZ2UunDDYZzOstNVGTA6LPiB4qDTFYEiVKdw/HjHqGK
         2djVrfdKzV90QGz6eTW6USEyE8/5bGZYgj1jiv86qg3wPJ234lRwlJfD8IdBZNA/ns3O
         dX0Q==
X-Gm-Message-State: AOAM533lvqP4W1UBzx4PZZW0h1Ij2GTQilD6haXNuAORRIGVMi5jZusD
        D3u5/zayIMEtS44YK3U3nNymhg5CvIA1/w==
X-Google-Smtp-Source: ABdhPJyqaUQa55ql03a70k+x44nZ8aNBtcvcIS65k9R6l6uy2KiXftbLsblN2LO/KnqJMEtr2IB+DA==
X-Received: by 2002:aa7:cd8b:: with SMTP id x11mr9433753edv.87.1619595714963;
        Wed, 28 Apr 2021 00:41:54 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k5sm4530504edk.46.2021.04.28.00.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:41:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/8] trace-cmd library: Add log levels
Date:   Wed, 28 Apr 2021 10:41:44 +0300
Message-Id: <20210428074149.757163-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428074149.757163-1-tz.stoyanov@gmail.com>
References: <20210428074149.757163-1-tz.stoyanov@gmail.com>
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
index 162cd318..1cfdc4af 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -41,4 +41,6 @@ int tracecmd_buffer_instances(struct tracecmd_input *handle);
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
index 77259357..6f9da7c7 100644
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
 	tep_vprint("libtracecmd", TEP_LOG_WARNING, fmt, ap);
 	va_end(ap);
@@ -368,17 +382,23 @@ void tracecmd_info(const char *fmt, ...)
 {
 	va_list ap;
 
+	if (log_level < TEP_LOG_INFO)
+		return;
+
 	va_start(ap, fmt);
 	tep_vprint("libtracecmd", TEP_LOG_INFO, fmt, ap);
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
 	ret = tep_vprint("libtracecmd", TEP_LOG_CRITICAL, fmt, ap);
 	va_end(ap);
-- 
2.30.2

