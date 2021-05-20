Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C2CDC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5B2E611AB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhETDVw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhETDVw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:52 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87E9C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:31 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id s22so22734820ejv.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fkZxC2X7hEb0oYvidiu3AmDabaLvi7WZgsLSTr3tHio=;
        b=RO1k6abBtbfIQcLPD2BlWfixDJQWtZfyZI+xqYfnCsGHp1RuQVARwwwwvc72FOOyIK
         Nq/LdvQYXzOvBMEM7Cg0pAJdaKjXpjfCa74V6NnKSJLBTRqDXQU0ZjDoSOwzVpIZWt/d
         rVl6QEUSeMK4znCDFfJeSFwEGkElY169IuKemH9SSee/y89+FHWLwZDw8kud2+Opy5ma
         cYZgZhNtrLTA018OIKpdur9aLMWQqmfQ3+qe+h+2JGuVvrpgX9lMZ5LmSaY4ckw2xcV2
         12ibncP11s7qr/9kD9oybqUyVp22wlov//oi02KjqNry0fwtzfrow78/VpFt4eX4FtLY
         8kaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fkZxC2X7hEb0oYvidiu3AmDabaLvi7WZgsLSTr3tHio=;
        b=VIcJqgYGuPn/lx8sFfC3digGhtFllm0lD0JI62GxkYDiSknCZoOXYvv1J7galmJen4
         xDnsP8pp2cMMFsWPnBJ7pjjGT0WaMZ2TWr7Q0o99slChakO7XgZiRCHTdas3YfKMwZdp
         MsOaz/pQ3Es6g9PJ4wxWWqZbUPWKWeovvA39pLGJl5DHc5PNkfNWvaFWy+BNWcF3mc1g
         mHoTvc3+B02F5+LWNGss0eWSe8dqYbdw7mLbR4elNE+xcVjNDqb74uYjLCJqYquvK9k9
         710KgnouezvZTenow/m3iT+pCU7U48KPKu5CTjoi0Jo3A0vFh5GomqQK6OAYKgTQFLLt
         /32g==
X-Gm-Message-State: AOAM530AEYcAeE7e7rEYDWEXQ5My9DUWNKfRXpPMDOio599fMiXZUjC5
        b6Tf3rBkod/yU2drkJWRdvI=
X-Google-Smtp-Source: ABdhPJwIW/LaaNkUyzKeT7ON9/JEidQu+s6p7uyrhe+othlRMUTihdcS5I/YitcO201I3Kb9ibwMDw==
X-Received: by 2002:a17:906:914d:: with SMTP id y13mr2406183ejw.489.1621480830305;
        Wed, 19 May 2021 20:20:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 26/29] trace-cmd library: Reuse within the library the function that checks file state.
Date:   Thu, 20 May 2021 06:19:56 +0300
Message-Id: <20210520031959.346165-27-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c            | 88 +++++++------------------
 lib/trace-cmd/trace-util.c              | 41 ++++++++++++
 4 files changed, 72 insertions(+), 66 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index e579a669..48a01d43 100644
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
index c2b64ea9..a1248f26 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4397,3 +4397,8 @@ int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable)
 
 	return 0;
 }
+
+__hidden bool check_in_state(struct tracecmd_input *handle, int new_state)
+{
+	return check_file_state(handle->file_version, handle->file_state, new_state);
+}
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index dbc956d4..e7370798 100644
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
@@ -1343,11 +1299,10 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
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
@@ -1363,16 +1318,14 @@ int tracecmd_write_options(struct tracecmd_output *handle)
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
@@ -1535,10 +1488,9 @@ static int write_buffers_description_v7(struct tracecmd_output *handle)
 	int size;
 	int ret;
 
-	ret = check_out_state(handle, TRACECMD_FILE_BUFERS);
-	if (ret < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_BUFERS)) {
 		tracecmd_warning("Cannot write buffers descriptions");
-		return ret;
+		return -1;
 	}
 
 	list_for_each_entry(buf, &handle->buffers, list) {
@@ -1597,11 +1549,10 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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
 
@@ -1621,7 +1572,6 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 {
 	struct tracecmd_output *handle;
 	char *path;
-	int ret;
 
 	handle = create_file(output_file, NULL, NULL, NULL, &all_event_list, compression);
 	if (!handle)
@@ -1640,8 +1590,7 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
-	ret = check_out_state(handle, TRACECMD_FILE_CPU_LATENCY);
-	if (ret < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_CPU_LATENCY)) {
 		tracecmd_warning("Cannot write latency data into the file, unexpected state 0x%X",
 				 handle->file_state);
 		goto out_free;
@@ -1730,7 +1679,9 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 
 	/* This can be called multiple times (when recording instances) */
 	ret = handle->file_state == TRACECMD_FILE_CPU_FLYRECORD ? 0 :
-		check_out_state(handle, TRACECMD_FILE_CPU_FLYRECORD);
+				    check_file_state(handle->file_version,
+						     handle->file_state,
+						     TRACECMD_FILE_CPU_FLYRECORD);
 	if (ret < 0) {
 		tracecmd_warning("Cannot write trace data into the file, unexpected state 0x%X",
 				 handle->file_state);
@@ -1999,3 +1950,8 @@ out_free:
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

