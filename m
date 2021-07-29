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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A0C8C4320E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5078261052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhG2FKU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhG2FKT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:19 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4FCC061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:16 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id nb11so8482563ejc.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7W+uYwoE447rYrNNYEJfG9nAps77FgBFYvFHk9rmkZA=;
        b=NDfMGq6/dBsVk6sGmv6zgKm3Auv59qkubL+cmvtroxOuUNXhOUMBAuSMV9f7yU3WHG
         Sdt8TrzZygmDmowHoLMB/xx1aXIg6SijADUcF7c1fuLmMC9wtEXBqJvYmlqtdIaZDnvB
         VBmQV/x6uBc6I/PfADE07sv0RSJkHI/LvFbGSpGg37rzEtUEqJtf6gzGuiNZdkDz3ugw
         MTQiv68fM1V31qj90AgGvc8pzvLwPgZvzrCAlOKp82pQAZDhriQwkoerD4thTH4RXkgI
         IRepBpXMGCDbL7VDWNnxtw4Bvd9VVnfAAqt8ndYR6F366Pmw1UPuDtkh7vxLvXo/npTe
         g1YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7W+uYwoE447rYrNNYEJfG9nAps77FgBFYvFHk9rmkZA=;
        b=dakT9FCOokGNgtqEBMjTuD7RfqAuxgBeQAHlF0enMKTcwojNCyAlczkLWM245RHlYm
         Lrnoqi1eDO9xzN2lUqEF6RFLQ1Y+NDtsfast8DGx8d/tkZeaqHJP2PhxyqQ02HxC4bcv
         XChiOl5/opzR5T0bjLTxfHQDMYY/nG6VIKM/W+UuUxvTm52YO69QrX68CpURT0eFQ1Hz
         Hiic1peIbz+Fs6+4dozk5akyGSVhBGStoxsVWE+hhiZf0M+9oOs948zLPaZBM2R+dceD
         6lDKgJzpRdYIHIh6YzU6ntcKMH4v7q61IcNdlFhRyMUJiojTHHXpaeKaSqkTyagKl13U
         sTmw==
X-Gm-Message-State: AOAM531MePHE2eiYzbUE9NbgIln0wl0md9sRt4cCgE8F81V//yytmD+e
        L2bQY2/XmhHzpNyWn7I4ZE+WbtCZ7b1mYA==
X-Google-Smtp-Source: ABdhPJwEiWOG5TU5Gt2Co2mt2aOHSfLSyM5TbxJgxBhr4XjcidqwgenOfWG2Twr1+uY/56XKYb5qyw==
X-Received: by 2002:a17:907:82a6:: with SMTP id mr38mr2821608ejc.218.1627535415347;
        Wed, 28 Jul 2021 22:10:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 14/87] trace-cmd library: Reuse within the library the function that checks file state.
Date:   Thu, 29 Jul 2021 08:08:46 +0300
Message-Id: <20210729050959.12263-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Make the function, that checks if the next file state is valid, global
for the tracmd-library, so it can be reused. It is important the same check
logic to be used in the whole library.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  4 ++
 lib/trace-cmd/trace-input.c             |  5 +++
 lib/trace-cmd/trace-output.c            | 59 +++++++------------------
 lib/trace-cmd/trace-util.c              | 33 ++++++++++++++
 4 files changed, 59 insertions(+), 42 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index ad3f7e1f..f799ea8d 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -27,6 +27,10 @@ void tracecmd_info(const char *fmt, ...);
 void tracecmd_compress_init(void);
 void tracecmd_compress_free(void);
 
+bool check_file_state(unsigned long file_version, int current_state, int new_state);
+bool check_in_state(struct tracecmd_input *handle, int new_state);
+bool check_out_state(struct tracecmd_output *handle, int new_state);
+
 int out_uncompress_block(struct tracecmd_output *handle);
 int out_compression_start(struct tracecmd_output *handle);
 int out_compression_end(struct tracecmd_output *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e759285b..8495ce35 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4259,3 +4259,8 @@ int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable)
 
 	return 0;
 }
+
+__hidden bool check_in_state(struct tracecmd_input *handle, int new_state)
+{
+	return check_file_state(handle->file_version, handle->file_state, new_state);
+}
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index e1373e80..8e402d35 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -365,33 +365,6 @@ int tracecmd_ftrace_enable(int set)
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
@@ -400,7 +373,7 @@ static int read_header_files(struct tracecmd_output *handle)
 	int fd;
 	int ret;
 
-	if (check_out_state(handle, TRACECMD_FILE_HEADERS) < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_HEADERS)) {
 		tracecmd_warning("Cannot read header files, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -712,7 +685,7 @@ static int read_ftrace_files(struct tracecmd_output *handle)
 	struct tracecmd_event_list list = { .glob = "ftrace/*" };
 	int ret;
 
-	if (check_out_state(handle, TRACECMD_FILE_FTRACE_EVENTS) < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_FTRACE_EVENTS)) {
 		tracecmd_warning("Cannot read ftrace files, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -753,7 +726,7 @@ static int read_event_files(struct tracecmd_output *handle,
 	int endian4;
 	int ret;
 
-	if (check_out_state(handle, TRACECMD_FILE_ALL_EVENTS) < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_ALL_EVENTS)) {
 		tracecmd_warning("Cannot read event files, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -844,7 +817,7 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
 	struct stat st;
 	int ret;
 
-	if (check_out_state(handle, TRACECMD_FILE_KALLSYMS) < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_KALLSYMS)) {
 		tracecmd_warning("Cannot read kallsyms, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -889,7 +862,7 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	char *path;
 	int ret;
 
-	if (check_out_state(handle, TRACECMD_FILE_PRINTK) < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_PRINTK)) {
 		tracecmd_warning("Cannot read printk, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -1326,11 +1299,10 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
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
@@ -1346,16 +1318,14 @@ int tracecmd_write_options(struct tracecmd_output *handle)
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
@@ -1473,11 +1443,10 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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
@@ -1868,3 +1837,9 @@ out_free:
 	tracecmd_output_close(handle);
 	return NULL;
 }
+
+__hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
+{
+	return check_file_state(handle->file_version, handle->file_state, new_state);
+}
+
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 00246076..cda125c4 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -634,3 +634,36 @@ static void __attribute__((destructor)) tracecmd_lib_free(void)
 {
 	tracecmd_compress_free();
 }
+
+__hidden bool check_file_state(unsigned long file_version, int current_state, int new_state)
+{
+	if (file_version >= 7) {
+		if (current_state < TRACECMD_FILE_INIT)
+			return false;
+		return true;
+	}
+
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
+		if (file_version < 7 && current_state == TRACECMD_FILE_CPU_COUNT)
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
-- 
2.31.1

