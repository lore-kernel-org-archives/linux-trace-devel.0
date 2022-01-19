Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4856AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350447AbiASI2v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiASI2u (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:28:50 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116D9C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:28:50 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id j2so7555011edj.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pynPccNBvHvKrOKglnL2kpOC1gUPwjATbzd6smGaoS8=;
        b=FG+m+yyifPJR2X3C4CTT22aOlcNfyeElTh6bpAOlzNUuqMBqqfcz1C3e37ye62cMV6
         zYSJrIo0eJfeLLM7N+WI961CImTpvFtmKMJ+fR3eRT6yHb8yh0geReKw0SCFkMqDSFQo
         dfZqoGSlgBriFKZ1QDRREq3g8ab+EoKcdNNTq5PZZCEm/L5VUGkLtvivWkgNntltXzuV
         3zrxd26epxFX1HztEsazaBgYPtnTcFlvtuXjoEA9X8ChMwigMxDe9jL/Iix7pYtonRju
         Kl9b/vr/yxRQonTrCnpdYLIfNkJkevEkhiwRu8pMG06aUvShA7ZFFass1CPI+iquky93
         uZ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pynPccNBvHvKrOKglnL2kpOC1gUPwjATbzd6smGaoS8=;
        b=yuNDlpYOKq252BtWvH1qBYYs+5Un90xGblkLa4tDy86ArlrhEK2gvI0uD+BeJ+bjsE
         Kso6QS2T4wjHK/P+LzE0Yp6pqRbtOTAN37/OLGfysVyleMJQSgkihI9XBHnk63arVnoe
         7DQvD+WHeWPaC1rmFpAKX8sBoITalccVhrCarJrQXYMc7m40tW3KOuztP1WJ5/SvUsAD
         WBadZvQxGDKu91eg7mXcyCtOwhF4okW77EE9ghd8tj7TbCvux+HHkqEjvNCymarwiXfS
         PccNGRv08KzHPb5Phd7RohCTQNN5qbvKiWMAGQF7tbZS7PLQnD7V86Vfca/N7haQfVVO
         OW8w==
X-Gm-Message-State: AOAM533BuuUnZpVdrkVxtNTCmhWnGuatPTPYyRUwYXsDKYASb89oHzYz
        do0Ueak+bzpSj1dXDteaxv2EYWxlUJc=
X-Google-Smtp-Source: ABdhPJwq0UG/Nv2Yvk5wUZ63gMeyzeH1IaCuj1W9xpHSQucXUg3XwIQ70G8GzX7KyMqMitXe4cE1HA==
X-Received: by 2002:a17:906:c152:: with SMTP id dp18mr17044325ejc.274.1642580928644;
        Wed, 19 Jan 2022 00:28:48 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t14sm860838edq.24.2022.01.19.00.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:28:48 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 2/9] trace-cmd library: Handle version 7 files when copying headers between files
Date:   Wed, 19 Jan 2022 10:28:38 +0200
Message-Id: <20220119082845.245993-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082845.245993-1-tz.stoyanov@gmail.com>
References: <20220119082845.245993-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When copying header data between trace files, handle the file versions.
Internal library functions for copying these headers are fixed to work
with trace file version 7:
 copy_header_files
 copy_ftrace_files
 copy_event_files
 copy_proc_kallsyms
 copy_command_lines

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |   3 +
 lib/trace-cmd/trace-input.c             | 211 ++++++++++++++++++++----
 lib/trace-cmd/trace-output.c            |  10 ++
 lib/trace-cmd/trace-util.c              |   8 +-
 4 files changed, 200 insertions(+), 32 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 5ce640a6..4154e76e 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -50,6 +50,9 @@ int out_uncompress_block(struct tracecmd_output *handle);
 int out_compression_start(struct tracecmd_output *handle, bool compress);
 int out_compression_end(struct tracecmd_output *handle, bool compress);
 void out_compression_reset(struct tracecmd_output *handle, bool compress);
+bool out_check_compression(struct tracecmd_output *handle);
+
+void out_set_file_state(struct tracecmd_output *handle, int new_state);
 unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 					int fd, unsigned long long max,
 					unsigned long long *write_size);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index acb5ac87..27064fce 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4511,164 +4511,313 @@ static int read_copy_data(struct tracecmd_input *in_handle,
 	return -1;
 }
 
+
+static bool check_in_state(struct tracecmd_input *handle, int new_state)
+{
+	return check_file_state(handle->file_version, handle->file_state, new_state);
+}
+
 static int copy_header_files(struct tracecmd_input *in_handle,
 			     struct tracecmd_output *out_handle)
 {
+	bool compress = out_check_compression(out_handle);
+	struct file_section *sec;
+	unsigned long long offset;
 	unsigned long long size;
 
-	if (in_handle->file_state != TRACECMD_FILE_HEADERS - 1)
+	if (!check_in_state(in_handle, TRACECMD_FILE_HEADERS) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_HEADERS))
 		return -1;
 
+	sec = section_open(in_handle, TRACECMD_OPTION_HEADER_INFO);
+	if (!sec)
+		return -1;
+	offset = out_write_section_header(out_handle, TRACECMD_OPTION_HEADER_INFO,
+					  "headers", TRACECMD_SEC_FL_COMPRESS, true);
+	out_compression_start(out_handle, compress);
+
 	/* "header_page"  */
 	if (read_copy_data(in_handle, 12, out_handle) < 0)
-		return -1;
+		goto error;
 
 	if (read_copy_size8(in_handle, out_handle, &size) < 0)
-		return -1;
+		goto error;
 
 	if (read_copy_data(in_handle, size, out_handle) < 0)
-		return -1;
+		goto error;
 
 	/* "header_event"  */
 	if (read_copy_data(in_handle, 13, out_handle) < 0)
-		return -1;
+		goto error;
 
 	if (read_copy_size8(in_handle, out_handle, &size) < 0)
-		return -1;
+		goto error;
 
 	if (read_copy_data(in_handle, size, out_handle) < 0)
-		return -1;
+		goto error;
 
 	in_handle->file_state = TRACECMD_FILE_HEADERS;
+	if (out_compression_end(out_handle, compress))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
+	section_close(in_handle, sec);
+
+	if (out_update_section_header(out_handle, offset))
+		goto error;
 
 	return 0;
+error:
+	out_compression_reset(out_handle, compress);
+	section_close(in_handle, sec);
+	return -1;
 }
 
 static int copy_ftrace_files(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
+	bool compress = out_check_compression(out_handle);
+	struct file_section *sec;
+	unsigned long long offset;
 	unsigned long long size;
 	unsigned int count;
 	unsigned int i;
 
-	if (in_handle->file_state != TRACECMD_FILE_FTRACE_EVENTS - 1)
+	if (!check_in_state(in_handle, TRACECMD_FILE_FTRACE_EVENTS) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_FTRACE_EVENTS))
 		return -1;
 
-	if (read_copy_size4(in_handle, out_handle, &count) < 0)
+	sec = section_open(in_handle, TRACECMD_OPTION_FTRACE_EVENTS);
+	if (!sec)
 		return -1;
+	offset = out_write_section_header(out_handle, TRACECMD_OPTION_FTRACE_EVENTS,
+					  "ftrace events", TRACECMD_SEC_FL_COMPRESS, true);
+
+	out_compression_start(out_handle, compress);
+
+	if (read_copy_size4(in_handle, out_handle, &count) < 0)
+		goto error;
 
 	for (i = 0; i < count; i++) {
 
 		if (read_copy_size8(in_handle, out_handle, &size) < 0)
-			return -1;
+			goto error;
 
 		if (read_copy_data(in_handle, size, out_handle) < 0)
-			return -1;
+			goto error;
 	}
 
 	in_handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
+	if (out_compression_end(out_handle, compress))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
+
+	section_close(in_handle, sec);
+
+	if (out_update_section_header(out_handle, offset))
+		goto error;
 
 	return 0;
+error:
+	out_compression_reset(out_handle, compress);
+	section_close(in_handle, sec);
+	return -1;
 }
 
 static int copy_event_files(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
+	bool compress = out_check_compression(out_handle);
+	struct file_section *sec;
+	unsigned long long offset;
 	unsigned long long size;
 	char *system;
 	unsigned int systems;
 	unsigned int count;
 	unsigned int i,x;
 
-	if (in_handle->file_state != TRACECMD_FILE_ALL_EVENTS - 1)
+	if (!check_in_state(in_handle, TRACECMD_FILE_ALL_EVENTS) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_ALL_EVENTS))
 		return -1;
 
-	if (read_copy_size4(in_handle, out_handle, &systems) < 0)
+	sec = section_open(in_handle, TRACECMD_OPTION_EVENT_FORMATS);
+	if (!sec)
 		return -1;
+	offset = out_write_section_header(out_handle, TRACECMD_OPTION_EVENT_FORMATS,
+					  "events format", TRACECMD_SEC_FL_COMPRESS, true);
+
+	out_compression_start(out_handle, compress);
+
+	if (read_copy_size4(in_handle, out_handle, &systems) < 0)
+		goto error;
 
 	for (i = 0; i < systems; i++) {
 		system = read_string(in_handle);
 		if (!system)
-			return -1;
+			goto error;
 		if (do_write_check(out_handle, system, strlen(system) + 1)) {
 			free(system);
-			return -1;
+			goto error;
 		}
 		free(system);
 
 		if (read_copy_size4(in_handle, out_handle, &count) < 0)
-			return -1;
+			goto error;
 
 		for (x=0; x < count; x++) {
 			if (read_copy_size8(in_handle, out_handle, &size) < 0)
-				return -1;
+				goto error;
 
 			if (read_copy_data(in_handle, size, out_handle) < 0)
-				return -1;
+				goto error;
 		}
 	}
 
 	in_handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+	if (out_compression_end(out_handle, compress))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
+
+	section_close(in_handle, sec);
+
+	if (out_update_section_header(out_handle, offset))
+		goto error;
 
 	return 0;
+error:
+	out_compression_reset(out_handle, compress);
+	section_close(in_handle, sec);
+	return -1;
 }
 
 static int copy_proc_kallsyms(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
+	bool compress = out_check_compression(out_handle);
+	struct file_section *sec;
+	unsigned long long offset;
 	unsigned int size;
 
-	if (in_handle->file_state != TRACECMD_FILE_KALLSYMS - 1)
+	if (!check_in_state(in_handle, TRACECMD_FILE_KALLSYMS) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_KALLSYMS))
 		return -1;
 
-	if (read_copy_size4(in_handle, out_handle, &size) < 0)
+	sec = section_open(in_handle, TRACECMD_OPTION_KALLSYMS);
+	if (!sec)
 		return -1;
+	offset = out_write_section_header(out_handle, TRACECMD_OPTION_KALLSYMS,
+					  "kallsyms", TRACECMD_SEC_FL_COMPRESS, true);
+
+	out_compression_start(out_handle, compress);
+	if (read_copy_size4(in_handle, out_handle, &size) < 0)
+		goto error;
 	if (!size)
-		return 0; /* OK? */
+		goto out; /* OK? */
 
 	if (read_copy_data(in_handle, size, out_handle) < 0)
-		return -1;
-
+		goto error;
+out:
 	in_handle->file_state = TRACECMD_FILE_KALLSYMS;
+	if (out_compression_end(out_handle, compress))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
+
+	section_close(in_handle, sec);
+
+	if (out_update_section_header(out_handle, offset))
+		goto error;
 
 	return 0;
+error:
+	out_compression_reset(out_handle, compress);
+	section_close(in_handle, sec);
+	return -1;
 }
 
 static int copy_ftrace_printk(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
+	bool compress = out_check_compression(out_handle);
+	struct file_section *sec;
+	unsigned long long offset;
 	unsigned int size;
 
-	if (in_handle->file_state != TRACECMD_FILE_PRINTK - 1)
+	if (!check_in_state(in_handle, TRACECMD_FILE_PRINTK) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_PRINTK))
 		return -1;
 
-	if (read_copy_size4(in_handle, out_handle, &size) < 0)
+	sec = section_open(in_handle, TRACECMD_OPTION_PRINTK);
+	if (!sec)
 		return -1;
+	offset = out_write_section_header(out_handle, TRACECMD_OPTION_PRINTK,
+					  "printk", TRACECMD_SEC_FL_COMPRESS, true);
+
+	out_compression_start(out_handle, compress);
+
+	if (read_copy_size4(in_handle, out_handle, &size) < 0)
+		goto error;
 	if (!size)
-		return 0; /* OK? */
+		goto out; /* OK? */
 
 	if (read_copy_data(in_handle, size, out_handle) < 0)
-		return -1;
+		goto error;
 
+out:
 	in_handle->file_state = TRACECMD_FILE_PRINTK;
+	if (out_compression_end(out_handle, compress))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
+
+	section_close(in_handle, sec);
+
+	if (out_update_section_header(out_handle, offset))
+		goto error;
 
 	return 0;
+error:
+	out_compression_reset(out_handle, compress);
+	section_close(in_handle, sec);
+	return -1;
 }
 
 static int copy_command_lines(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
+	bool compress = out_check_compression(out_handle);
+	struct file_section *sec;
+	unsigned long long offset;
 	unsigned long long size;
 
-	if (in_handle->file_state != TRACECMD_FILE_CMD_LINES - 1)
+	if (!check_in_state(in_handle, TRACECMD_FILE_CMD_LINES) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_CMD_LINES))
 		return -1;
 
-	if (read_copy_size8(in_handle, out_handle, &size) < 0)
+	sec = section_open(in_handle, TRACECMD_OPTION_CMDLINES);
+	if (!sec)
 		return -1;
+	offset = out_write_section_header(out_handle, TRACECMD_OPTION_CMDLINES,
+					  "command lines", TRACECMD_SEC_FL_COMPRESS, true);
+
+	out_compression_start(out_handle, compress);
+
+	if (read_copy_size8(in_handle, out_handle, &size) < 0)
+		goto error;
 	if (!size)
-		return 0; /* OK? */
+		goto out; /* OK? */
 
 	if (read_copy_data(in_handle, size, out_handle) < 0)
-		return -1;
+		goto error;
 
+out:
 	in_handle->file_state = TRACECMD_FILE_CMD_LINES;
+	if (out_compression_end(out_handle, compress))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
+
+	section_close(in_handle, sec);
+
+	if (out_update_section_header(out_handle, offset))
+		goto error;
 
 	return 0;
+error:
+	out_compression_reset(out_handle, compress);
+	section_close(in_handle, sec);
+	return -1;
 }
 
 /**
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 4554be28..9a8f3741 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2606,11 +2606,21 @@ out_free:
 	return NULL;
 }
 
+__hidden void out_set_file_state(struct tracecmd_output *handle, int new_state)
+{
+	handle->file_state = new_state;
+}
+
 __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
 {
 	return check_file_state(handle->file_version, handle->file_state, new_state);
 }
 
+__hidden bool out_check_compression(struct tracecmd_output *handle)
+{
+	return (handle->compress != NULL);
+}
+
 /**
  * tracecmd_get_out_file_version - return the trace.dat file version
  * @handle: output handle for the trace.dat file
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 06071f6c..f9014a9a 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -647,6 +647,12 @@ static void __attribute__((destructor)) tracecmd_lib_free(void)
 
 __hidden bool check_file_state(unsigned long file_version, int current_state, int new_state)
 {
+	if (file_version >= FILE_VERSION_SECTIONS) {
+		if (current_state < TRACECMD_FILE_INIT)
+			return false;
+		return true;
+	}
+
 	switch (new_state) {
 	case TRACECMD_FILE_HEADERS:
 	case TRACECMD_FILE_FTRACE_EVENTS:
@@ -659,7 +665,7 @@ __hidden bool check_file_state(unsigned long file_version, int current_state, in
 			return true;
 		break;
 	case TRACECMD_FILE_OPTIONS:
-		if (current_state == (new_state - 1))
+		if (file_version < FILE_VERSION_SECTIONS && current_state == TRACECMD_FILE_CPU_COUNT)
 			return true;
 		break;
 	case TRACECMD_FILE_CPU_LATENCY:
-- 
2.34.1

