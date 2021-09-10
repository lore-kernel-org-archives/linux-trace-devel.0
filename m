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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF2EC4321E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68777611C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbhIJNtY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbhIJNtU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:20 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC3CC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:09 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g21so2586073edw.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oTzbxfgmdv5dS26KmRX3/wLchys/YsUZn4fQBqrOuTQ=;
        b=GNEMPnysRBHbovaEb4g4Cr86ZOjdqgphNO+nUjkCjgMTmEcz8EjnlbFZgJ4zIq8yWf
         Xk77cCD+jUo0t1+ljSSk18ylmtlQW2HbV81YHw9MLOXR2l4yEfhJ1yckpKM5jCyXRE4p
         BvqwrdIQQkw9w9MwEz5S6IClgAjJnuwYhIUAIM/cNsVAyqWAxB52C8sPqv7d58GXENrg
         z4h6E9Dq6/jzDLaa9be0NG9xSJgiCuNIQ6WTayE5F8yskXR9nUyirIh/UuCa/74HHBvc
         Pgx2WzVtnsQCreeh5CnfHvE9G40u7p7KbTZnkVKv6IvdsJha58OUznptCN945/4ipZGv
         Xgfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oTzbxfgmdv5dS26KmRX3/wLchys/YsUZn4fQBqrOuTQ=;
        b=KlKAk2W9suG+c4lrseEsFx5kVKAtfbXSallaDBoSjRTccaLyXpRfr3HLow3dYxTuEe
         QUCF7ds1AU2vNzRO7SngjIxSZWSQLG38219vKay3+b2kDLDrFeb/L1TA91I9Qglkr1nW
         hPZtu5nhSl2TnAIVV7rOAn/FMmaMMNOAuGZCyVLWtXcpMJ9qGyq+w2ujCjW50hx5ifyv
         2jGXhInEM1se2tQB1RNg3Mpjt+vY2dLQp9y2ykyS3WvNV5HwDt1f7C/fKpIZXJWFOy1K
         rYsYUzaCmxaEuAuWd7jJmBfmDobPSSU3jnIiOJyXzVQazFQWGx91nsQoZfmN/mPWUjon
         NZvA==
X-Gm-Message-State: AOAM532qUsXoUXJe5hd4ov61hyYpdr++arNWbG1axk6oIDGDPwla2mM+
        ByDLmCUwO9g0rYwQ6F0zss6zUwbZ22g=
X-Google-Smtp-Source: ABdhPJz98akedkDteTg3xvP27WFpwWJ1v5MZLsfhA74SMdtLQ+/J1ucxBYh+NHMTeGi0+O7sAX5+AA==
X-Received: by 2002:a05:6402:524e:: with SMTP id t14mr9125757edd.66.1631281688031;
        Fri, 10 Sep 2021 06:48:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 08/21] trace-cmd library: Reuse within the library the function that checks file state.
Date:   Fri, 10 Sep 2021 16:47:44 +0300
Message-Id: <20210910134757.2863982-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Make the function, that checks if the next file state is valid, global
for the trace-cmd library, so it can be reused. It is important the same check
logic to be used in the whole library.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  2 +
 lib/trace-cmd/trace-input.c             |  1 +
 lib/trace-cmd/trace-output.c            | 66 ++++++++-----------------
 lib/trace-cmd/trace-util.c              | 28 +++++++++++
 4 files changed, 51 insertions(+), 46 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 821b5cdb..7f3b45a8 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -31,5 +31,7 @@ void tracecmd_info(const char *fmt, ...);
 #endif
 #endif
 
+bool check_file_state(unsigned long file_version, int current_state, int new_state);
+bool check_out_state(struct tracecmd_output *handle, int new_state);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index dd7689a3..2f749d0b 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4224,3 +4224,4 @@ int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable)
 
 	return 0;
 }
+
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a8de107c..fe1d1aaa 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -307,33 +307,6 @@ int tracecmd_ftrace_enable(int set)
 	return ret;
 }
 
-static int check_out_state(struct tracecmd_output *handle, int new_state)
-{
-	if (!handle)
-		return -1;
-
-	switch (new_state) {
-	case TRACECMD_FILE_HEADERS:
-	case TRACECMD_FILE_FTRACE_EVENTS:
-	case TRACECMD_FILE_ALL_EVENTS:
-	case TRACECMD_FILE_KALLSYMS:
-	case TRACECMD_FILE_PRINTK:
-	case TRACECMD_FILE_CMD_LINES:
-	case TRACECMD_FILE_CPU_COUNT:
-	case TRACECMD_FILE_OPTIONS:
-		if (handle->file_state == (new_state - 1))
-			return 0;
-		break;
-	case TRACECMD_FILE_CPU_LATENCY:
-	case TRACECMD_FILE_CPU_FLYRECORD:
-		if (handle->file_state == TRACECMD_FILE_OPTIONS)
-			return 0;
-		break;
-	}
-
-	return -1;
-}
-
 static int read_header_files(struct tracecmd_output *handle)
 {
 	tsize_t size, check_size, endian8;
@@ -342,7 +315,7 @@ static int read_header_files(struct tracecmd_output *handle)
 	int fd;
 	int ret;
 
-	if (check_out_state(handle, TRACECMD_FILE_HEADERS) < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_HEADERS)) {
 		tracecmd_warning("Cannot read header files, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -654,7 +627,7 @@ static int read_ftrace_files(struct tracecmd_output *handle)
 	struct tracecmd_event_list list = { .glob = "ftrace/*" };
 	int ret;
 
-	if (check_out_state(handle, TRACECMD_FILE_FTRACE_EVENTS) < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_FTRACE_EVENTS)) {
 		tracecmd_warning("Cannot read ftrace files, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -695,7 +668,7 @@ static int read_event_files(struct tracecmd_output *handle,
 	int endian4;
 	int ret;
 
-	if (check_out_state(handle, TRACECMD_FILE_ALL_EVENTS) < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_ALL_EVENTS)) {
 		tracecmd_warning("Cannot read event files, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -787,7 +760,7 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
 	struct stat st;
 	int ret;
 
-	if (check_out_state(handle, TRACECMD_FILE_KALLSYMS) < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_KALLSYMS)) {
 		tracecmd_warning("Cannot read kallsyms, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -832,7 +805,7 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	char *path;
 	int ret;
 
-	if (check_out_state(handle, TRACECMD_FILE_PRINTK) < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_PRINTK)) {
 		tracecmd_warning("Cannot read printk, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -1134,11 +1107,10 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 {
 	int ret;
 
-	ret = check_out_state(handle, TRACECMD_FILE_CPU_COUNT);
-	if (ret < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_CPU_COUNT)) {
 		tracecmd_warning("Cannot write CPU count into the file, unexpected state 0x%X",
 				 handle->file_state);
-		return ret;
+		return -1;
 	}
 	cpus = convert_endian_4(handle, cpus);
 	ret = do_write_check(handle, &cpus, 4);
@@ -1154,16 +1126,14 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 	unsigned short option;
 	unsigned short endian2;
 	unsigned int endian4;
-	int ret;
 
 	/* If already written, ignore */
 	if (handle->file_state == TRACECMD_FILE_OPTIONS)
 		return 0;
-	ret = check_out_state(handle, TRACECMD_FILE_OPTIONS);
-	if (ret < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_OPTIONS)) {
 		tracecmd_warning("Cannot write options into the file, unexpected state 0x%X",
 				 handle->file_state);
-		return ret;
+		return -1;
 	}
 
 	if (do_write_check(handle, "options  ", 10))
@@ -1281,11 +1251,10 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
 	int ret;
 
-	ret = check_out_state(handle, TRACECMD_FILE_CMD_LINES);
-	if (ret < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_CMD_LINES)) {
 		tracecmd_warning("Cannot write command lines into the file, unexpected state 0x%X",
 				 handle->file_state);
-		return ret;
+		return -1;
 	}
 	ret = save_tracing_file_data(handle, "saved_cmdlines");
 	if (ret < 0)
@@ -1298,7 +1267,6 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 {
 	struct tracecmd_output *handle;
 	char *path;
-	int ret;
 
 	handle = create_file(output_file, NULL, NULL, NULL, &all_event_list);
 	if (!handle)
@@ -1316,8 +1284,7 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
-	ret = check_out_state(handle, TRACECMD_FILE_CPU_LATENCY);
-	if (ret < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_CPU_LATENCY)) {
 		tracecmd_warning("Cannot write latency data into the file, unexpected state 0x%X",
 				 handle->file_state);
 		goto out_free;
@@ -1399,7 +1366,9 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 
 	/* This can be called multiple times (when recording instances) */
 	ret = handle->file_state == TRACECMD_FILE_CPU_FLYRECORD ? 0 :
-		check_out_state(handle, TRACECMD_FILE_CPU_FLYRECORD);
+				    check_file_state(handle->file_version,
+						     handle->file_state,
+						     TRACECMD_FILE_CPU_FLYRECORD);
 	if (ret < 0) {
 		tracecmd_warning("Cannot write trace data into the file, unexpected state 0x%X",
 				 handle->file_state);
@@ -1661,3 +1630,8 @@ out_free:
 	tracecmd_output_close(handle);
 	return NULL;
 }
+
+__hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
+{
+	return check_file_state(handle->file_version, handle->file_state, new_state);
+}
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 9bc94822..db7ce7ee 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -624,3 +624,31 @@ bool tracecmd_is_version_supported(unsigned int version)
 		return true;
 	return false;
 }
+
+__hidden bool check_file_state(unsigned long file_version, int current_state, int new_state)
+{
+	switch (new_state) {
+	case TRACECMD_FILE_HEADERS:
+	case TRACECMD_FILE_FTRACE_EVENTS:
+	case TRACECMD_FILE_ALL_EVENTS:
+	case TRACECMD_FILE_KALLSYMS:
+	case TRACECMD_FILE_PRINTK:
+	case TRACECMD_FILE_CMD_LINES:
+	case TRACECMD_FILE_CPU_COUNT:
+		if (current_state == (new_state - 1))
+			return true;
+		break;
+	case TRACECMD_FILE_OPTIONS:
+		if (current_state == (new_state - 1))
+			return true;
+		break;
+	case TRACECMD_FILE_CPU_LATENCY:
+	case TRACECMD_FILE_CPU_FLYRECORD:
+		if (current_state == TRACECMD_FILE_OPTIONS)
+			return true;
+		break;
+	}
+
+	return false;
+}
+
-- 
2.31.1

