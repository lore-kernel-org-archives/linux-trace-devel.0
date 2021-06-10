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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38810C48BE0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2011361406
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhFJLhk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:40 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:44962 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhFJLhg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:36 -0400
Received: by mail-wm1-f41.google.com with SMTP id m41-20020a05600c3b29b02901b9e5d74f02so3100812wms.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t3intCMoSYuOhFvknXB492ibiTZthsbHP5Iqqq3yFFg=;
        b=JuV7z+ocDz/tmpNWo93ie38GcArHfxMTeVKyJBVlQq8m4nLowNSVjFD8isMqsFsc8p
         HeFQbn6lB2fGiL8fsKw/HGCNmT7HmDdMVsCPY8a02KkqSbnWyMm0zWaU5YFjBU18Dk7d
         9MlOM53GwIXp4NIBl6apEUQIw4LVNoTc2p/Lmd+i4znQtgn/7OxY5phBTuzqldbfvc4d
         TWEeUfMfaIVCGyFI/rOn1N3HcO5EVmZ415/i1Jk1JuWRXfmaCovag6T5pw9Yk3EQJOaR
         ADiiPih9BS/uipTsIavD5c2HF8JfOwMMHdioj6KepyS/dvbn4s6RRM4GR8oAtbYgK//m
         CQ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t3intCMoSYuOhFvknXB492ibiTZthsbHP5Iqqq3yFFg=;
        b=pDzQQBNZzTPefwEh6UsKRKzf8bUuacaLKlqaRNpDibuHKb0SpnCiB0ZKXpkXIxSpNn
         pz7UlpUlPZ5Bw9dM0QdWHOQhdf09ApHBSy6R5CzvZp2sKvPXmKGoauDMCxDMQtxSCzQf
         aYUImmczGkFIib6gi2886XMcArDXgYU9sWouY5u0949tK6fUOijW4vPK7EA/cGLERdJ0
         BAX8vIGc2ssegsyMUgFDtn38Q93c5WeSm4RALy0YcbtmYLe43AOsgoX/c+Pk6Mj8dZpG
         CCY3XxFyemmys2cQZyPIsGqLY+atnaaR5ayHQxbfakus0AiVRQKDA1h66uZx4NrfTpnl
         93sA==
X-Gm-Message-State: AOAM531N+UrSa27ll2Z4ebGHr1DwU1sMRDC/u3YqIpBZlDjIJYuJbNX6
        d8Xa7HbQ9nXlSRGy3JOUeDr9SRO0BHCEFQ==
X-Google-Smtp-Source: ABdhPJx5I3+xFbRSebm9+r9NkufyZytLcDrD3NkEWpcEanzl2+GlLgkxi/UzoYj/ts9Zh9kIiJHbqQ==
X-Received: by 2002:a05:600c:ada:: with SMTP id c26mr13858611wmr.189.1623324879179;
        Thu, 10 Jun 2021 04:34:39 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 11/40] trace-cmd library: Read compressed trace file
Date:   Thu, 10 Jun 2021 14:33:57 +0300
Message-Id: <20210610113426.257931-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
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
index bf90eae8..24228d8f 100644
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

