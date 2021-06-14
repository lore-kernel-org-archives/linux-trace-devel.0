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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 153FAC49360
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F260E61352
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhFNHyA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:54:00 -0400
Received: from mail-ej1-f47.google.com ([209.85.218.47]:44741 "EHLO
        mail-ej1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbhFNHx7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:59 -0400
Received: by mail-ej1-f47.google.com with SMTP id c10so15025547eja.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zf5AOhAEAPDVyQzk2iMX2j/CaJ3B/G0Hew1xFRyohqg=;
        b=pOlYaQluCfDn7PtthAFuyu4xPI3NVUF72qGjxLyF9dxEtc83YTi4PrikSMu8IvekTO
         bHF4/OXNg29/DAP3CJHmOEBJxQ0mfKRhHr9KpYqTpGlKiE4jLT7tA0eY7wA/MgmiFxyz
         HpSs6pM6CbVGEfzNjFmjHIVW3DA4zzKKDBAPIlcTHqxe682COZ3JnLOrq92XDBbx8YYn
         sd3AQDcvImL9p63kkIFei8FPT4QJLoVh4WwGxk/dt8LLW0QkbCI0pkqeb5fd7NrYOhai
         QJyEA0uIxrdgkvjpTgjwjMuHayUkAsiRLVnxRGJUtcSFlWfwY7kqmdzS4prcCEu8YGhU
         2dvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zf5AOhAEAPDVyQzk2iMX2j/CaJ3B/G0Hew1xFRyohqg=;
        b=eDp/keZUhYNVaLIBINmNWJPzlVsSrFvNj5dVhA9ncZTB1NWI/WiNKQPWucmytk3sXB
         wTfDyHuItTihPXsWtqagk1q7IyI8dIoNyo9V64JbWlkmvTqKs6BaLS+75HUgxy9MH0tq
         S1RElvmk8z9stQKB3FJjbSibB36j7Srhip94meliOp1l81zKbatUne0L/o3KR3rk67Ol
         jzRHYAnJBaxOVyXpeEtdffqOCSdSuifVo9eCVHNNtZzDa4n1qwUjXqQBP22vdvDqoESK
         GdUpbtjNAkZ0a5vLi8jA5G1gtRp1YPdhs4H+LgCwTIUmSAmJWUvSbLTAcTRVhUDmP+Xh
         MzHw==
X-Gm-Message-State: AOAM530/1hwjgXqCbrQlvkmVtSgoI8fqovUnmOZgqUHS7sq8XjZblDjH
        sW8tDt3LHdWRM86qU92wOYjEyNEhnjsAhA==
X-Google-Smtp-Source: ABdhPJxSHvoyWpP768+NxMH3iir6mpsEDKG67vZ7TKCe0lV0wUFuxgBrBuWe1FMnXUSSdT6Kejnbqw==
X-Received: by 2002:a17:906:fa93:: with SMTP id lt19mr14520107ejb.54.1623657042876;
        Mon, 14 Jun 2021 00:50:42 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 11/45] trace-cmd library: Read compressed trace file
Date:   Mon, 14 Jun 2021 10:49:55 +0300
Message-Id: <20210614075029.598048-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If a trace file version 7 is detected, read compressed sections of it.
Read the compression header, check if the compression algorithm and
version, used to compress the file, are supported and use it to
uncompress these sections of the file:
 - ftrace events format
 - format of recorded events
 - information of the mapping of function addresses to the function names
 - trace_printk() format strings
 - information of the mapping a PID to a process name

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |   3 +
 lib/trace-cmd/trace-input.c             | 257 ++++++++++++++++--------
 2 files changed, 178 insertions(+), 82 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 93613cd7..419bfee0 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -38,4 +38,7 @@ int out_compression_start(struct tracecmd_output *handle);
 int out_compression_end(struct tracecmd_output *handle);
 void out_compression_reset(struct tracecmd_output *handle);
 
+void in_uncompress_reset(struct tracecmd_input *handle);
+int in_uncompress_block(struct tracecmd_input *handle);
+
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 46619ac7..43d731e0 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -136,6 +136,9 @@ struct tracecmd_input {
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
 
+	bool			read_compress;
+	struct tracecmd_compression *compress;
+
 	struct host_trace_info	host;
 	double			ts2secs;
 	char *			cpustats;
@@ -255,12 +258,28 @@ static ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
 	return tot;
 }
 
+static inline int do_lseek(struct tracecmd_input *handle, int offset, int whence)
+{
+	if (handle->read_compress)
+		return tracecmd_compress_lseek(handle->compress, offset, whence);
+	else
+		return lseek(handle->fd, offset, whence);
+}
+
+static inline ssize_t do_read_compressed(struct tracecmd_input *handle, void *data, size_t size)
+{
+	if (handle->read_compress)
+		return tracecmd_compress_read(handle->compress, data, size);
+	else
+		return do_read(handle, data, size);
+}
+
 static ssize_t
 do_read_check(struct tracecmd_input *handle, void *data, size_t size)
 {
 	ssize_t ret;
 
-	ret = do_read(handle, data, size);
+	ret = do_read_compressed(handle, data, size);
 	if (ret < 0)
 		return ret;
 	if (ret != size)
@@ -278,10 +297,8 @@ static char *read_string(struct tracecmd_input *handle)
 	ssize_t r;
 
 	for (;;) {
-		r = do_read(handle, buf, BUFSIZ);
-		if (r < 0)
-			goto fail;
-		if (!r)
+		r = do_read_compressed(handle, buf, BUFSIZ);
+		if (r <= 0)
 			goto fail;
 
 		for (i = 0; i < r; i++) {
@@ -307,7 +324,7 @@ static char *read_string(struct tracecmd_input *handle)
 	}
 
 	/* move the file descriptor to the end of the string */
-	r = lseek(handle->fd, -(r - (i+1)), SEEK_CUR);
+	r = do_lseek(handle, -(r - (i+1)), SEEK_CUR);
 	if (r < 0)
 		goto fail;
 
@@ -359,6 +376,26 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
 	return 0;
 }
 
+__hidden void in_uncompress_reset(struct tracecmd_input *handle)
+{
+	if (handle->compress && handle->file_version >= 7) {
+		handle->read_compress = false;
+		tracecmd_compress_reset(handle->compress);
+	}
+}
+
+__hidden int in_uncompress_block(struct tracecmd_input *handle)
+{
+	int ret = 0;
+
+	if (handle->compress && handle->file_version >= 7) {
+		ret = tracecmd_uncompress_block(handle->compress);
+		if (!ret)
+			handle->read_compress = true;
+	}
+	return ret;
+}
+
 static int read_header_files(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
@@ -602,34 +639,40 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 		}
 	}
 
-	if (read4(handle, &count) < 0)
+	if (in_uncompress_block(handle))
 		return -1;
 
+	ret = read4(handle, &count);
+	if (ret < 0)
+		goto out;
+
 	for (i = 0; i < count; i++) {
-		if (read8(handle, &size) < 0)
-			return -1;
+		ret = read8(handle, &size);
+		if (ret < 0)
+			goto out;
 		ret = read_ftrace_file(handle, size, print_all, ereg);
 		if (ret < 0)
-			return -1;
+			goto out;
 	}
 
 	handle->event_files_start =
 		lseek64(handle->fd, 0, SEEK_CUR);
+	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
 
+	ret = 0;
+out:
 	if (sreg) {
 		regfree(sreg);
 		regfree(ereg);
 	}
-
-	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
-
-	return 0;
+	in_uncompress_reset(handle);
+	return ret;
 }
 
 static int read_event_files(struct tracecmd_input *handle, const char *regex)
 {
 	unsigned long long size;
-	char *system;
+	char *system = NULL;
 	regex_t spreg;
 	regex_t epreg;
 	regex_t *sreg = NULL;
@@ -654,13 +697,19 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 			return -1;
 	}
 
-	if (read4(handle, &systems) < 0)
+	if (in_uncompress_block(handle))
 		return -1;
 
+	ret = read4(handle, &systems);
+	if (ret < 0)
+		goto out;
+
 	for (i = 0; i < systems; i++) {
 		system = read_string(handle);
-		if (!system)
-			return -1;
+		if (!system) {
+			ret = -1;
+			goto out;
+		}
 
 		sys_printed = 0;
 		print_all = 0;
@@ -687,103 +736,117 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 			}
 		}
 
-		if (read4(handle, &count) < 0)
-			goto failed;
+		ret = read4(handle, &count);
+		if (ret < 0)
+			goto out;
 
 		for (x=0; x < count; x++) {
-			if (read8(handle, &size) < 0)
-				goto failed;
+			ret = read8(handle, &size);
+			if (ret < 0)
+				goto out;
 
 			ret = read_event_file(handle, system, size,
 					      print_all, &sys_printed,
 					      reg);
 			if (ret < 0)
-				goto failed;
+				goto out;
 		}
 		free(system);
-	}
-
-	if (sreg) {
-		regfree(sreg);
-		regfree(ereg);
+		system = NULL;
 	}
 
 	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
-
-	return 0;
-
- failed:
+	ret = 0;
+ out:
+	in_uncompress_reset(handle);
 	if (sreg) {
 		regfree(sreg);
 		regfree(ereg);
 	}
 
 	free(system);
-	return -1;
+	return ret;
 }
 
 static int read_proc_kallsyms(struct tracecmd_input *handle)
 {
-	struct tep_handle *pevent = handle->pevent;
+	struct tep_handle *tep = handle->pevent;
 	unsigned int size;
-	char *buf;
+	char *buf = NULL;
+	int ret;
 
 	if (handle->file_state >= TRACECMD_FILE_KALLSYMS)
 		return 0;
 
-	if (read4(handle, &size) < 0)
+	if (in_uncompress_block(handle))
 		return -1;
-	if (!size)
-		return 0; /* OK? */
 
-	buf = malloc(size+1);
-	if (!buf)
-		return -1;
-	if (do_read_check(handle, buf, size)){
-		free(buf);
-		return -1;
+	ret = read4(handle, &size);
+	if (ret < 0)
+		goto out;
+	if (!size) {
+		handle->file_state = TRACECMD_FILE_KALLSYMS;
+		goto out; /* OK? */
 	}
-	buf[size] = 0;
-
-	tep_parse_kallsyms(pevent, buf);
 
-	free(buf);
+	buf = malloc(size+1);
+	if (!buf) {
+		ret = -1;
+		goto out;
+	}
+	ret = do_read_check(handle, buf, size);
+	if (ret < 0)
+		goto out;
 
+	buf[size] = 0;
+	tep_parse_kallsyms(tep, buf);
 	handle->file_state = TRACECMD_FILE_KALLSYMS;
-
-	return 0;
+	ret = 0;
+out:
+	free(buf);
+	in_uncompress_reset(handle);
+	return ret;
 }
 
 static int read_ftrace_printk(struct tracecmd_input *handle)
 {
 	unsigned int size;
-	char *buf;
+	char *buf = NULL;
+	int ret;
 
 	if (handle->file_state >= TRACECMD_FILE_PRINTK)
 		return 0;
 
-	if (read4(handle, &size) < 0)
+	if (in_uncompress_block(handle))
 		return -1;
-	if (!size)
-		return 0; /* OK? */
+
+	ret = read4(handle, &size);
+	if (ret < 0)
+		goto out;
+	if (!size) {
+		handle->file_state = TRACECMD_FILE_PRINTK;
+		goto out; /* OK? */
+	}
 
 	buf = malloc(size + 1);
-	if (!buf)
-		return -1;
-	if (do_read_check(handle, buf, size)) {
-		free(buf);
-		return -1;
+	if (!buf) {
+		ret = -1;
+		goto out;
 	}
+	ret = do_read_check(handle, buf, size);
+	if (ret < 0)
+		goto out;
 
 	buf[size] = 0;
 
 	tep_parse_printk_formats(handle->pevent, buf);
-
-	free(buf);
-
 	handle->file_state = TRACECMD_FILE_PRINTK;
+	ret = 0;
 
-	return 0;
+out:
+	free(buf);
+	in_uncompress_reset(handle);
+	return ret;
 }
 
 static int read_and_parse_cmdlines(struct tracecmd_input *handle);
@@ -2974,20 +3037,30 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
 	unsigned long long size;
-	char *cmdlines;
+	char *cmdlines = NULL;
+	int ret;
 
 	if (handle->file_state >= TRACECMD_FILE_CMD_LINES)
 		return 0;
 
-	if (read_data_and_size(handle, &cmdlines, &size) < 0)
+	if (in_uncompress_block(handle))
 		return -1;
+
+	ret = read_data_and_size(handle, &cmdlines, &size);
+	if (ret < 0)
+		goto out;
+	if (!size) {
+		handle->file_state = TRACECMD_FILE_CMD_LINES;
+		goto out;
+	}
 	cmdlines[size] = 0;
 	tep_parse_saved_cmdlines(pevent, cmdlines);
-	free(cmdlines);
-
 	handle->file_state = TRACECMD_FILE_CMD_LINES;
-
-	return 0;
+	ret = 0;
+out:
+	free(cmdlines);
+	in_uncompress_reset(handle);
+	return ret;
 }
 
 static void extract_trace_clock(struct tracecmd_input *handle, char *line)
@@ -3268,7 +3341,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	struct tracecmd_input *handle;
 	char test[] = TRACECMD_MAGIC;
 	unsigned int page_size;
-	char *version;
+	size_t offset;
+	char *str = NULL;
+	char *zver;
 	char buf[BUFSIZ];
 	unsigned long ver;
 
@@ -3291,11 +3366,11 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	if (memcmp(buf, "tracing", 7) != 0)
 		goto failed_read;
 
-	version = read_string(handle);
-	if (!version)
+	str = read_string(handle);
+	if (!str)
 		goto failed_read;
-	tracecmd_info("version = %s\n", version);
-	ver = strtol(version, NULL, 10);
+	tracecmd_info("version = %s\n", str);
+	ver = strtol(str, NULL, 10);
 	if (!ver && errno)
 		goto failed_read;
 	if (!tracecmd_is_version_supported(ver)) {
@@ -3303,7 +3378,8 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 		goto failed_read;
 	}
 	handle->file_version = ver;
-	free(version);
+	free(str);
+	str = NULL;
 
 	if (do_read_check(handle, buf, 1))
 		goto failed_read;
@@ -3328,20 +3404,36 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	read4(handle, &page_size);
 	handle->page_size = page_size;
 
-	handle->header_files_start =
-		lseek64(handle->fd, 0, SEEK_CUR);
+	offset = lseek64(handle->fd, 0, SEEK_CUR);
+	handle->total_file_size = lseek64(handle->fd, 0, SEEK_END);
+	lseek64(handle->fd, offset, SEEK_SET);
 
-	handle->total_file_size =
-		lseek64(handle->fd, 0, SEEK_END);
+	if (handle->file_version >= 7) {
+		str = read_string(handle);
+		if (!str)
+			goto failed_read;
+		zver = strchr(str, ' ');
+		if (!zver)
+			goto failed_read;
+		*zver = '\0';
+		handle->compress = tracecmd_compress_alloc(str, zver + 1,
+							   handle->fd, handle->pevent, NULL);
+		if (!handle->compress) {
+			tracecmd_warning("Unsupported file compression %s %s", str, zver + 1);
+			goto failed_read;
+		}
+		free(str);
+		str = NULL;
+	}
 
 	handle->header_files_start =
-		lseek64(handle->fd, handle->header_files_start, SEEK_SET);
-
+		lseek64(handle->fd, 0, SEEK_CUR);
 	handle->file_state = TRACECMD_FILE_INIT;
 
 	return handle;
 
  failed_read:
+	free(str);
 	free(handle);
 
 	return NULL;
@@ -3519,7 +3611,8 @@ void tracecmd_close(struct tracecmd_input *handle)
 	if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
 		tracecmd_close(handle->parent);
 	else {
-		/* Only main handle frees plugins and pevent */
+		/* Only main handle frees plugins, pevent and compression context */
+		tracecmd_compress_destroy(handle->compress);
 		tep_unload_plugins(handle->plugin_list, handle->pevent);
 		tep_free(handle->pevent);
 	}
-- 
2.31.1

