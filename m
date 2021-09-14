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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB1CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6243610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbhINNOD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhINNOC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:14:02 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D822C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:45 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id y132so9230405wmc.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/iP4a8bfrh1K3oUHJHD9zBIH/f3RsH2LCFQaSP0YOGI=;
        b=DZIYpPXiE3KC/BeNK0Z7JBNQoZfj6fqndLcdjCMqrFKuG4xvWRSM0LktKW9CzrRywS
         1pwAUsIrCXNt6DTJMDXRVHsCqVncsl1/1QogAdVIOyZxzwzcw4aat4gJ/mFpotMSJuE2
         Ij+ewIa0yzHNh76OJXzG6ycLHxnMt2aoHF6huK08fx3LSbVk7RoAZOnBw/0cVVFcWaDs
         FgsPwDvirFqIEZHc7hAAsSUE7SPAyftT9LLHxxE3HJuvtCoCMlATdnBgIHBlUNa/vd4J
         4XP2/qxXqW9uZMQyN9jU2i97MrMxRt50tD9gKX9SEzIKd/9Q4Y0hQ9byy35AVLbD3mGW
         qLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/iP4a8bfrh1K3oUHJHD9zBIH/f3RsH2LCFQaSP0YOGI=;
        b=XNiNfX6Y85kAb1UZA7VGgxf9rVsSPCmn/bBvH6BmVO5Rr+vK0RU8h5s1rHjotWDgWR
         C6RyA40E/M9O84FtoEGREHBdO7iIptEJG5mk3IiLLzrxjH9iVjcdL5Y86Oz3OnD8bFG0
         amaTPhGLoSQp5/rXJhlAl5Sw0rpjBpXlc1jRlBN+zf97AmkaFOvm8rmpBPHy6sXAgxKx
         6gaWMHNfBJco4gSlY9yORXjd70B9D9cr3h+jxbG8EVvSbpD6SFyZxWirnmoqupcFVT/x
         z9RbXFnwMTpQC9KIqvZKgnLU6PKuDbaxXUWQec1VrDyGbqwywl7JH/eqM9TjHZIqHIqm
         oXpA==
X-Gm-Message-State: AOAM530rHzanxo+IQLGqk0Bc8JmfeI30/v84eGZs7YT8+U5ehYI45ELd
        iwSMnM+SLOmsf3zkgrYBDDRkwhFasmw=
X-Google-Smtp-Source: ABdhPJxucop80mnCrEbjvS60NtUKN3mPTDl7JjUm9hNbf91wUu0DKdpD4vCHD//ju8JjnW9ib2WTbA==
X-Received: by 2002:a1c:ed03:: with SMTP id l3mr2230993wmh.56.1631625163917;
        Tue, 14 Sep 2021 06:12:43 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:43 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 08/21] trace-cmd library: Reuse within the library the function that checks file state.
Date:   Tue, 14 Sep 2021 16:12:19 +0300
Message-Id: <20210914131232.3964615-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
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
index d020cfae..bd0517e1 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4222,3 +4222,4 @@ int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable)
 
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

