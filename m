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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE8FC43460
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDE49613D6
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236592AbhEGJyh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbhEGJyh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:54:37 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17BEC061574
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:53:37 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y26so9510903eds.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lZHQOdRyIHk2MaqzgxDCIBcBIVFMyPrrgwagy00c46g=;
        b=OxyXPQ8PFkm0UeWuabzLAJ6GaPd3RwiDUF8jWuOJ/eJ+vtMa9px8tq+MOq7jnRihM1
         rl7injI2WCdlg1XjTzxKS6dPVoz52IsUFBwWO7xFnsM4XAo18J6SdzX47Qx2nUUkWebJ
         R/Y8RjtzGozL0BjOU0E+ojvdFIFFRoSP26g7WA7pwX/7wj4MVnn/DIfFjseIoHgWo4yR
         th8Kpjs8mKGbdD6hEyCEiJfi/E1QdbPb/pobo6T74lzbHqfgF9l3XvXuVJvkl8yohYI6
         TZq5x9g/+2wehhqBG8l+zq8yaTzCXPJnRiYc8BJkRC5TOjpEuYarw7qPQ/iiOC1FT7Sa
         hf2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lZHQOdRyIHk2MaqzgxDCIBcBIVFMyPrrgwagy00c46g=;
        b=JV8xYKVyujdFFfx8uimPhZuC2omx2kr5cJmhdNuAwTqEem7wPdjexg5B0uCqD9KExE
         Bpn1q10HVuedszOR77Y+2D72BynAeoD2qB06kRM7yMKFSEu365nIo+nGMbKB+brakJ6S
         /SiMhenuXqEhYDztci0Fw5K3eY2uCWpJant7smTCNomVEBHbrmOtFzdAFC8vNQmZCgDR
         njXrXc0eEFJk/fAfsgVvTAxMQ85LSRFhc+DiBnaKBr9xLPkU8vQsp+7tGRdAoH2h8hRG
         vUBQCCX94d4kWwlOYqJsnwnxvwfYJ2Wgbl2DMIgeUSMXuII/MMPQ6E+wAYNvCY1qydug
         fecA==
X-Gm-Message-State: AOAM531OO88adRTKWrka82vCTKU4uuQaLM1XdE+9WP+dn2cO/myb5/6z
        EzK8TtMDFqn+U9lFa9JI9PQ=
X-Google-Smtp-Source: ABdhPJzXilRfPLMtOWpPZ5AqY0ZJuU1DBw4kz4pbAfkm7cX6uB2huo8AYcTViWwrz3qc1WZDXAZASA==
X-Received: by 2002:a05:6402:26d1:: with SMTP id x17mr10359025edd.14.1620381216607;
        Fri, 07 May 2021 02:53:36 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id cr21sm3105812ejc.2.2021.05.07.02.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:53:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/8] trace-cmd library: Add tracecmd_info() log function
Date:   Fri,  7 May 2021 12:53:27 +0300
Message-Id: <20210507095333.1080910-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
References: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The pr_stat() function is removed from the traceevent library. This function
was used by trace-cmd to print statistics. Introduced tracecmd_info() log
function and replaced pr_stat() with it in the trace-cmd library.
However, pr_stat() is used also in the trace-cmd application. In order no
to change the existing behaviour, added a static pr_stat() implementation for
that usage.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  1 +
 lib/trace-cmd/trace-input.c             |  2 +-
 lib/trace-cmd/trace-plugin.c            |  2 +-
 lib/trace-cmd/trace-util.c              | 10 ++++++++++
 python/ctracecmd.i                      | 11 -----------
 tracecmd/trace-cmd.c                    | 14 --------------
 tracecmd/trace-record.c                 | 14 ++++++++++++++
 7 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index e8533b22..cd868f60 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -12,6 +12,7 @@
 /* Can be overridden */
 void tracecmd_warning(const char *fmt, ...);
 void tracecmd_fatal(const char *fmt, ...);
+void tracecmd_info(const char *fmt, ...);
 
 /* trace.dat file format version */
 #define FILE_VERSION 6
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9726e994..2e519752 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3292,7 +3292,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	version = read_string(handle);
 	if (!version)
 		goto failed_read;
-	pr_stat("version = %s\n", version);
+	tracecmd_info("version = %s\n", version);
 	free(version);
 
 	if (do_read_check(handle, buf, 1))
diff --git a/lib/trace-cmd/trace-plugin.c b/lib/trace-cmd/trace-plugin.c
index ca7cadae..50c800c2 100644
--- a/lib/trace-cmd/trace-plugin.c
+++ b/lib/trace-cmd/trace-plugin.c
@@ -140,7 +140,7 @@ load_plugin(struct trace_plugin_context *trace, const char *path,
 	list->name = plugin;
 	*plugin_list = list;
 
-	pr_stat("registering plugin: %s", plugin);
+	tracecmd_info("registering plugin: %s", plugin);
 	func(trace);
 	return;
 
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index ab77ce2a..049fe049 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -364,6 +364,16 @@ void __weak tracecmd_warning(const char *fmt, ...)
 	va_end(ap);
 }
 
+void tracecmd_info(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	tep_vprint("libtracecmd", TEP_LOG_INFO, false, fmt, ap);
+	va_end(ap);
+}
+
+
 void __weak tracecmd_fatal(const char *fmt, ...)
 {
 	int ret;
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index 7091b9bd..6d0179e3 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -44,17 +44,6 @@ static void py_supress_trace_output(void)
 	skip_output = 1;
 }
 
-void pr_stat(const char *fmt, ...)
-{
-        va_list ap;
-
-	if (skip_output)
-		return;
-	va_start(ap, fmt);
-	__vpr_stat(fmt, ap);
-	va_end(ap);
-}
-
 void warning(const char *fmt, ...)
 {
 	va_list ap;
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 7376c5a5..60cd3ea1 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -35,20 +35,6 @@ void warning(const char *fmt, ...)
 	fprintf(stderr, "\n");
 }
 
-void pr_stat(const char *fmt, ...)
-{
-	va_list ap;
-
-	if (!show_status)
-		return;
-
-	va_start(ap, fmt);
-	vprintf(fmt, ap);
-	va_end(ap);
-
-	printf("\n");
-}
-
 void *malloc_or_die(unsigned int size)
 {
 	void *data;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5dd8be4a..274d706c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2934,6 +2934,20 @@ static void test_event(struct event_list *event, const char *path,
 
 	*save = event;
 }
+static void pr_stat(const char *fmt, ...)
+{
+	va_list ap;
+
+	if (!show_status)
+		return;
+
+	va_start(ap, fmt);
+	vprintf(fmt, ap);
+	va_end(ap);
+
+	printf("\n");
+}
+
 
 static int expand_event_files(struct buffer_instance *instance,
 			      const char *file, struct event_list *old_event)
-- 
2.31.1

