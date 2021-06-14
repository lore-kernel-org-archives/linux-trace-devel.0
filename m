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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 793B2C48BE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F40361352
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhFNHxD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbhFNHxC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:02 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AB6C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:00 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id t3so45241527edc.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fm6GHm8rBYX0HOSR/Du9nrToQE1DoWVg7pjPtUjxL/M=;
        b=O92iOcvZHiACgfPFYL0jhuO7sukGEjI3cSgzixWuh8vO0+CNoUMRePIR39p97ApddS
         ud5df09wZmHAmJH10CMgSUMPFBhAKAFVUuLBhXMUEEcTaWuxg8wMgdu7oylm70bgonZ9
         H1CSIGPZg+40xmxcfQf6TD4VlzdSjTn2ZTKCFNptG830STg6yoqXai74VKEgQPsdgV4k
         EEl1ZMPSJWFGBDr7VFvQQant43cMUnMAdEZvVcfkcq4GfrE0p7llA43jgz+kdmHZIYq1
         RY3LJ4klUJth8u6FqXopVkcGT/mXXNCeDKhzySLSin9K8s7SNDPND2UnRxCGwUIWVTt+
         z24Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fm6GHm8rBYX0HOSR/Du9nrToQE1DoWVg7pjPtUjxL/M=;
        b=kcraV5CBdUaecDK8i7oVuLqqy7y7QI4OFWpkmyL8HOl9AxSP9D5723R2somUOYMRQs
         Lh5lQNGgBV/q1wN9oL0xe4g/sSyhFPcP21vfgQz+WAs7P4tJGrKwrlC0CMVbswdA53tQ
         SqFt6/U74Xb1RLj1VTFA7JXpA4yImK5EbrjbKa3UGkspovrVOY/0WOFaNOFR6Yn9sEpp
         BgWqgIeKHCZvugURQyaHCunhkvPc1XbZq8lLRpEyT3S19tN4UAp038rplFl2pwouTCw5
         Coh0VmaBnpmHV5JClfX8FMd0pG+DU9PpK1gP7XmAd1bMYixGy8IyM1pK3RKF+hroHUDo
         QDQA==
X-Gm-Message-State: AOAM532psvGgPTE93l5s9jLC/DMUOdY5+k1xWq+csqvWKmMKwjtBRXGO
        PSsMjh/ztmP6nrMLqbnRxWBUWkPMBop2iA==
X-Google-Smtp-Source: ABdhPJxFlkHESHjDqiKNF5HcMZwywkO95BwVdcWzEk6AV873fc3eXR0ZJMzUBVAMOxUQpmF/JhfmUQ==
X-Received: by 2002:a05:6402:1906:: with SMTP id e6mr15585793edz.14.1623657058800;
        Mon, 14 Jun 2021 00:50:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:58 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 28/45] trace-cmd library: Reuse within the library the function that checks file state.
Date:   Mon, 14 Jun 2021 10:50:12 +0300
Message-Id: <20210614075029.598048-29-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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
index 03d2a9a3..d44b58a9 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -39,6 +39,10 @@ void tracecmd_zlib_free(void);
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
index 017b3d7d..c41dfb8f 100644
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

