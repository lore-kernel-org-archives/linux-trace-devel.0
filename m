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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271ACC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8921613FA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236805AbhD1Hmj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhD1Hmj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:42:39 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E666C06138A
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:41:55 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l4so93126496ejc.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w3zcNpacLQP5lvV0GVbXqc8L88nrr0NpbUPzQQqJApM=;
        b=gyzeOJwalzpOsov+raeBIzaFF4BIf7SvsQ9NN8dwYvgJcVTeE+DsHMUcVKB41I+btI
         c4NFtKkWw9lhYaPourb0Vw2fSXX0UjyVg63ojTZZXiMF2W+8cvI1D0wmLix7u43uAoCY
         NI4BCDlFrnZvBOEJGGJPJtZNVBdgwFPbI5BehojGTamxaRXjm9p2NOEHajgW+1DS5f6B
         gb844Zor+pqenF/h1FSEK5bnJ4gqkH4cXfhSL1N/55/TvK2s6Z3RwodBpC/pQlSw2K/I
         HRYiI9IfGckIGul5s5A3naKAlWVMOMTKRcX/rdDIDMHh5By/tKsj7t84NTBpvjirc55g
         a6qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w3zcNpacLQP5lvV0GVbXqc8L88nrr0NpbUPzQQqJApM=;
        b=ZeSZu93/Kc5G8KdYiij5Hj9prQjdsEOiTR2gXG0sb62hhlJKb250GhtNF9xajlm1Ps
         GG5xcaZjOrOdGTYtc5zqSQGegNbaYqk5aCi9kybMPxAd0MpD7UeO7bAkxG5NAJt7NoBf
         huR+47eZDwX55I7Lef6tnWTc8wY2XdoFhvN9WHtyNLXfZ/OjRl6NBUVOQj/CB2pksvyO
         Ur9cOH2DZfHEvdtOnxgQFwIcHQKFlQcPpajKln0ouTsDr/qsGDd789fdn9fn9fzEBYi+
         qifMcEsh30VF7zVwMcDET0UH1G1hT8lWnwbcXKWqLlui0AVqOosZ8BvA86u9jBYk77Z+
         OhAg==
X-Gm-Message-State: AOAM530q1ydLd500ItuZA4GWDjgYC0slDDt2guRv1DXdDaxlkEpnVFRJ
        cn4GqNdAO94pBEgexMe04/gisNqHMa2Lxg==
X-Google-Smtp-Source: ABdhPJybotw/Gy6xYdie/92zsJq/czr2Nnu9nblb4or1GKbsKNd8zp/BLiMG9TuyzmhWWLU0WRw/Bw==
X-Received: by 2002:a17:906:cec2:: with SMTP id si2mr28128474ejb.234.1619595713796;
        Wed, 28 Apr 2021 00:41:53 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k5sm4530504edk.46.2021.04.28.00.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:41:53 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/8] trace-cmd library: Add tracecmd_info() log function
Date:   Wed, 28 Apr 2021 10:41:43 +0300
Message-Id: <20210428074149.757163-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428074149.757163-1-tz.stoyanov@gmail.com>
References: <20210428074149.757163-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The pr_stat() function is removed from the traceevent library. This function
was used by trace-cmd to print statistics. Introduce tracecmd_info() log
function and replace pr_stat() with it in the trace-cmd library.
However, pr_stat() is used also in the trace-cmd application. In order no
to change the existing behaviour, add a static pr_stat() implementation for
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
index b17b36e0..733e1858 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3280,7 +3280,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
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
index 4228b055..77259357 100644
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
+	tep_vprint("libtracecmd", TEP_LOG_INFO, fmt, ap);
+	va_end(ap);
+}
+
+
 void __weak tracecmd_fatal(const char *fmt, ...)
 {
 	int ret;
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index fa942215..229b54f3 100644
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
index fd03a605..8805b10e 100644
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
2.30.2

