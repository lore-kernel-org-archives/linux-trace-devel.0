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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08648C47094
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B4C613F1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhFJLgw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhFJLgw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:36:52 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BE3C0617AD
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:56 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id b205so1270082wmb.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=66FlxMvR+6uLn0JyQQaiP+J5SvIQRJEbuwhocU3t7Is=;
        b=mq9Y+wBs6MO39kZrTSs5K59GpS06XUD3lBAmYf/mQ1P7tkW1g4/08dbr0hx1Q1gd9f
         fP6bbA35ByguhrT8Cru0MVf4ZN9Ra+RNb/jfDCiaGhTTeUjEZohQ8V3hxET5KnYV8ypV
         A86zs7HYI40cDyGA1EONzIDWVVZ8tIle7ItO79bAXmTUxbznecExwChl+pgyb3fKeh6k
         H/K7aTIdOPAJzOr+RN4XQEzOr+uFDusn0UBNmybPIumA1W3EvFbfbetv/3cDehcuWutG
         kuF7q+neG8KDUFvTFNilXVP1vjVT5JIrEjXiUMJA2Fhx4G2wcOqUFhBLkMp/VklkvdhT
         VOqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=66FlxMvR+6uLn0JyQQaiP+J5SvIQRJEbuwhocU3t7Is=;
        b=dYqFZB47w03UeQU2JexOVgR8wJt78ylt7hobeU9QK9FBdodQCSQjOF7mVSXEE/LZG1
         5kMH2grZI1hi4fUk2WzXxIvEDPkswLScqdI4GVnl/VpDvGSatXvQlnFjP3P9E0z4hfJz
         mtQQIYSM6TMkUJHGKuy+o9ejFV4SYozGJNd42wqfh38wG3t3I/YwUMct3aZWy9XQemoA
         jB8dppk8EP1L9uwKkVvIw0LTlepiXmnIArzGq7vt6p3u9H0scIOjQNtJ2BbbkJaCmHb2
         DmgsJN5veR1fp/6TS2l6d5yA4OchKpOjP1vIhfLGNcwVTyQiJKh2VZ1Com9+XH4IbXa1
         hKrg==
X-Gm-Message-State: AOAM530NDAqjp0sVBaRVnnUO9IgOu31WHkRBfskICFpsTx0MwgHtnavJ
        fYv6yDuUA98+NOI5rVAShnTl6PFCu9mBPA==
X-Google-Smtp-Source: ABdhPJwn3jiAA90JDy0mdG+StiaWdXpexFdftNZ/xcP/IiDlFGoiXRQiF5gLqZwxGHv3bzAu5xvrUg==
X-Received: by 2002:a7b:c099:: with SMTP id r25mr6110054wmh.144.1623324894577;
        Thu, 10 Jun 2021 04:34:54 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 28/40] trace-cmd library: Reuse within the library the function that checks file state.
Date:   Thu, 10 Jun 2021 14:34:14 +0300
Message-Id: <20210610113426.257931-29-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c             |  5 ++
 lib/trace-cmd/trace-output.c            | 83 ++++++-------------------
 lib/trace-cmd/trace-util.c              | 41 ++++++++++++
 4 files changed, 70 insertions(+), 63 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index b77c49ff..fa1b46b0 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -39,6 +39,10 @@ void tracecmd_zlib_free(void);
 int tracecmd_compress_init(void);
 void tracecmd_compress_free(void);
 
+bool check_file_state(unsigned long file_version, int current_state, int new_state);
+bool check_in_state(struct tracecmd_input *handle, int new_state);
+bool check_out_state(struct tracecmd_output *handle, int new_state);
+
 int out_uncompress_block(struct tracecmd_output *handle);
 int out_compression_start(struct tracecmd_output *handle);
 int out_compression_end(struct tracecmd_output *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 12876838..d3c5ad18 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4436,3 +4436,8 @@ int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable)
 
 	return 0;
 }
+
+__hidden bool check_in_state(struct tracecmd_input *handle, int new_state)
+{
+	return check_file_state(handle->file_version, handle->file_state, new_state);
+}
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 6a272503..039a49cd 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -419,50 +419,6 @@ int tracecmd_ftrace_enable(int set)
 	return ret;
 }
 
-static int check_out_state(struct tracecmd_output *handle, int new_state)
-{
-	if (!handle)
-		return -1;
-
-	if (handle->file_version < 7) {
-		switch (new_state) {
-		case TRACECMD_FILE_BUFERS:
-			tracecmd_warning("State %d is not supported in trace file version %d",
-					 new_state, handle->file_version);
-			return -1;
-		default:
-			break;
-		}
-	}
-
-	switch (new_state) {
-	case TRACECMD_FILE_HEADERS:
-	case TRACECMD_FILE_FTRACE_EVENTS:
-	case TRACECMD_FILE_ALL_EVENTS:
-	case TRACECMD_FILE_KALLSYMS:
-	case TRACECMD_FILE_PRINTK:
-	case TRACECMD_FILE_CMD_LINES:
-	case TRACECMD_FILE_CPU_COUNT:
-	case TRACECMD_FILE_BUFERS:
-		if (handle->file_state == (new_state - 1))
-			return 0;
-		break;
-	case TRACECMD_FILE_OPTIONS:
-		if (handle->file_version < 7 && handle->file_state == TRACECMD_FILE_CPU_COUNT)
-			return 0;
-		if (handle->file_version >= 7 && handle->file_state == TRACECMD_FILE_BUFERS)
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
@@ -471,7 +427,7 @@ static int read_header_files(struct tracecmd_output *handle)
 	int fd;
 	int ret;
 
-	if (check_out_state(handle, TRACECMD_FILE_HEADERS) < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_HEADERS)) {
 		tracecmd_warning("Cannot read header files, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -783,7 +739,7 @@ static int read_ftrace_files(struct tracecmd_output *handle)
 	struct tracecmd_event_list list = { .glob = "ftrace/*" };
 	int ret;
 
-	if (check_out_state(handle, TRACECMD_FILE_FTRACE_EVENTS) < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_FTRACE_EVENTS)) {
 		tracecmd_warning("Cannot read ftrace files, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -828,7 +784,7 @@ static int read_event_files(struct tracecmd_output *handle,
 	int endian4;
 	int ret;
 
-	if (check_out_state(handle, TRACECMD_FILE_ALL_EVENTS) < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_ALL_EVENTS)) {
 		tracecmd_warning("Cannot read event files, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -927,7 +883,7 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
 	struct stat st;
 	int ret;
 
-	if (check_out_state(handle, TRACECMD_FILE_KALLSYMS) < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_KALLSYMS)) {
 		tracecmd_warning("Cannot read kallsyms, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -977,7 +933,7 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	char *path;
 	int ret;
 
-	if (check_out_state(handle, TRACECMD_FILE_PRINTK) < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_PRINTK)) {
 		tracecmd_warning("Cannot read printk, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -1339,11 +1295,10 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
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
@@ -1359,16 +1314,14 @@ int tracecmd_write_options(struct tracecmd_output *handle)
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
@@ -1604,11 +1557,10 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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
 	out_compression_start(handle);
 
@@ -1628,7 +1580,6 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 {
 	struct tracecmd_output *handle;
 	char *path;
-	int ret;
 
 	handle = create_file(output_file, NULL, NULL, NULL, &all_event_list, compression);
 	if (!handle)
@@ -1647,8 +1598,7 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
-	ret = check_out_state(handle, TRACECMD_FILE_CPU_LATENCY);
-	if (ret < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_CPU_LATENCY)) {
 		tracecmd_warning("Cannot write latency data into the file, unexpected state 0x%X",
 				 handle->file_state);
 		goto out_free;
@@ -1737,7 +1687,9 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 
 	/* This can be called multiple times (when recording instances) */
 	ret = handle->file_state == TRACECMD_FILE_CPU_FLYRECORD ? 0 :
-		check_out_state(handle, TRACECMD_FILE_CPU_FLYRECORD);
+				    check_file_state(handle->file_version,
+						     handle->file_state,
+						     TRACECMD_FILE_CPU_FLYRECORD);
 	if (ret < 0) {
 		tracecmd_warning("Cannot write trace data into the file, unexpected state 0x%X",
 				 handle->file_state);
@@ -2006,3 +1958,8 @@ out_free:
 	tracecmd_output_close(handle);
 	return NULL;
 }
+
+__hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
+{
+	return check_file_state(handle->file_version, handle->file_state, new_state);
+}
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 136260c6..087d37ab 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -636,3 +636,44 @@ void tracecmd_lib_free(void)
 {
 	tracecmd_compress_free();
 }
+
+__hidden bool check_file_state(unsigned long file_version, int current_state, int new_state)
+{
+	if (file_version < 7) {
+		switch (new_state) {
+		case TRACECMD_FILE_BUFERS:
+			tracecmd_warning("State %d is not supported in trace file version %d",
+					 new_state, file_version);
+			return false;
+		default:
+			break;
+		}
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
+	case TRACECMD_FILE_BUFERS:
+		if (current_state == (new_state - 1))
+			return true;
+		break;
+	case TRACECMD_FILE_OPTIONS:
+		if (file_version < 7 && current_state == TRACECMD_FILE_CPU_COUNT)
+			return true;
+		if (file_version >= 7 && current_state == TRACECMD_FILE_BUFERS)
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

