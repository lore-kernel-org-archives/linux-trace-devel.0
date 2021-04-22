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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE605C43461
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE029613F2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbhDVHkA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235097AbhDVHjx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:39:53 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CF4C06138B
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:09 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id g5so60571697ejx.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ngfPvzkDhV5tKq3sGs2rSA0L1K3Nl48FzXTto9WL40o=;
        b=ToI2vGSOAbqEDn+xjeeobK1koEtOJlhigzdEQINg6ak84SaaHWvYV0kTOi0vACtmf5
         g8JazoZadM8ocIeTo3ihBHuGmoTDLLvScxZ/t1S1rn2gH1ouYVzzluJaD+vtIBxuqWpV
         fAyGnYHH4wl5Zg7ch8wvfwiEQulXwPGfP8zuMxDlPr3UsaVbyCwOVt8hjeVg9fFpSInJ
         hOWzWg5QY2fCi3lUqppOvQTwjbZ/wt92bdxmxp4ghEgMYt0nWJCuPl4v3zJKbvs5W8Bl
         r7+YWatan5+N8Lp+luubJ1jdKP7f1FObmhYr9TdDj12ANfR4sBF3f3WQjZ0s/+Pq3Psi
         yqjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ngfPvzkDhV5tKq3sGs2rSA0L1K3Nl48FzXTto9WL40o=;
        b=IvCKxCkOZvPY2bPddQOdc3nH1hratstxtV/4xnEonQdK07CtfBGVbunBdyBRgWMUnu
         WvM2NXQWGb3fNUIeVr5NFV3LOljOMB/ScOx+d99TB6tFRTDmFKl6Pc0gfnDpEKtYEhLC
         M+aGLsaEyBhD5P3kevqLJCX8bsNdSk6sREHvMQsn/lKLlteZhtvS++LErHN/kflYweWw
         Nky0lJq5E2J5ttW6paIXio8kJtX2RYy6f20fw4TrdEuAMFPtMNiUClYJXwYpG5Fo/xQP
         VfQ01MHP89xvby0z4tgGf0pr9SUyC+0zBhh+NeAJFisLP6V12mV+Q0cvVJO8DpUm6X4+
         lGWA==
X-Gm-Message-State: AOAM530O8hmXwItz8OJej0t6r6V5wFSItnRTV8lPTMHd9PqqD2q4DOMA
        cwr5v82F2IWn5zcP3pmfKtw=
X-Google-Smtp-Source: ABdhPJzwWViSnPX9PHKfQBaLuRAhWGk177yUpZOkmJWCGjRiH7BLpZu4YR0598SimK0sXZ2SsZJTvA==
X-Received: by 2002:a17:906:f1cb:: with SMTP id gx11mr2023297ejb.106.1619077147775;
        Thu, 22 Apr 2021 00:39:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s5sm1253692ejq.52.2021.04.22.00.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:39:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 04/10] trace-cmd library: Read compressed trace file
Date:   Thu, 22 Apr 2021 10:38:56 +0300
Message-Id: <20210422073902.484953-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422073902.484953-1-tz.stoyanov@gmail.com>
References: <20210422073902.484953-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If a trace file version 7 is detected, read compresses sections of it.
Read the compression header, check if the comporession algorithm and
version, used to compress the file, are supported and use it to
uncompress these secions from the file:
 - ftrace events format
 - format of recorded events
 - information of the mapping of function addresses to the function names
 - trace_printk() format strings
 - information of the mapping a PID to a process name

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 293 +++++++++++++++++++++++++++---------
 1 file changed, 221 insertions(+), 72 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b2a03ab8..b96b0192 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -135,6 +135,11 @@ struct tracecmd_input {
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
 
+	struct tracecmd_compress_proto *z_proto;
+	char *z_buffer;
+	unsigned long z_buffer_size;
+	unsigned long z_pointer;
+
 	struct host_trace_info	host;
 	double			ts2secs;
 	char *			cpustats;
@@ -254,12 +259,52 @@ static ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
 	return tot;
 }
 
+static ssize_t do_read_compressed(struct tracecmd_input *handle, void *data, size_t size)
+{
+	int ret;
+	int s;
+
+	if (handle->z_buffer) {
+		if (handle->z_pointer + size > handle->z_buffer_size)
+			s = handle->z_buffer_size - handle->z_pointer;
+		else
+			s = size;
+		memcpy(data, handle->z_buffer + handle->z_pointer, s);
+		handle->z_pointer += s;
+		ret = s;
+	} else {
+		ret = do_read(handle, data, size);
+	}
+
+	return ret;
+}
+
+static int do_lseek(struct tracecmd_input *handle, int offset, int whence)
+{
+	int ret;
+
+	if (handle->z_buffer) {
+		if (whence != SEEK_CUR)
+			return -1;
+		if (offset < 0 && handle->z_pointer < (-offset))
+			return -1;
+		if (offset > 0 && handle->z_pointer + offset > handle->z_buffer_size)
+			return -1;
+		handle->z_pointer += offset;
+		ret = 0;
+	} else {
+		ret = lseek(handle->fd, offset, whence);
+	}
+
+	return ret;
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
@@ -277,7 +322,7 @@ static char *read_string(struct tracecmd_input *handle)
 	ssize_t r;
 
 	for (;;) {
-		r = do_read(handle, buf, BUFSIZ);
+		r = do_read_compressed(handle, buf, BUFSIZ);
 		if (r < 0)
 			goto fail;
 		if (!r)
@@ -306,7 +351,7 @@ static char *read_string(struct tracecmd_input *handle)
 	}
 
 	/* move the file descriptor to the end of the string */
-	r = lseek(handle->fd, -(r - (i+1)), SEEK_CUR);
+	r = do_lseek(handle, -(r - (i+1)), SEEK_CUR);
 	if (r < 0)
 		goto fail;
 
@@ -358,6 +403,54 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
 	return 0;
 }
 
+static void uncompress_reset(struct tracecmd_input *handle)
+{
+	free(handle->z_buffer);
+	handle->z_buffer = NULL;
+	handle->z_buffer_size = 0;
+	handle->z_pointer = 0;
+}
+
+static int uncompress_block(struct tracecmd_input *handle)
+{
+	unsigned int s_compressed;
+	unsigned int s_uncompressed;
+	char *bytes = NULL;
+	int ret;
+
+	if (handle->file_version < 7 || !handle->z_proto)
+		return 0;
+	uncompress_reset(handle);
+
+	if (read4(handle, &s_compressed) < 0)
+		return -1;
+	if (read4(handle, &s_uncompressed) < 0)
+		return -1;
+
+	handle->z_buffer = malloc(s_uncompressed);
+	if (!handle->z_buffer)
+		return -1;
+	bytes = malloc(s_compressed);
+	if (!bytes)
+		goto error;
+
+	if (do_read(handle, bytes, s_compressed) != s_compressed)
+		goto error;
+	ret = tracecmd_uncompress_data(handle->z_proto, bytes, s_compressed,
+				       handle->z_buffer, &s_uncompressed);
+	if (ret)
+		goto error;
+	free(bytes);
+	handle->z_buffer_size = s_uncompressed;
+	handle->z_pointer = 0;
+	return 0;
+error:
+	uncompress_reset(handle);
+	free(bytes);
+	return -1;
+
+}
+
 static int read_header_files(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
@@ -601,34 +694,40 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 		}
 	}
 
-	if (read4(handle, &count) < 0)
+	if (uncompress_block(handle))
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
+	uncompress_reset(handle);
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
@@ -653,13 +752,19 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 			return -1;
 	}
 
-	if (read4(handle, &systems) < 0)
+	if (uncompress_block(handle))
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
@@ -686,103 +791,117 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
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
+	uncompress_reset(handle);
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
+	if (uncompress_block(handle))
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
+	uncompress_reset(handle);
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
+	if (uncompress_block(handle))
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
+	uncompress_reset(handle);
+	return ret;
 }
 
 static int read_and_parse_cmdlines(struct tracecmd_input *handle);
@@ -2962,20 +3081,30 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
 	unsigned long long size;
-	char *cmdlines;
+	char *cmdlines = NULL;
+	int ret;
 
 	if (handle->file_state >= TRACECMD_FILE_CMD_LINES)
 		return 0;
 
-	if (read_data_and_size(handle, &cmdlines, &size) < 0)
+	if (uncompress_block(handle))
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
+	uncompress_reset(handle);
+	return ret;
 }
 
 static void extract_trace_clock(struct tracecmd_input *handle, char *line)
@@ -3256,7 +3385,8 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	struct tracecmd_input *handle;
 	char test[] = TRACECMD_MAGIC;
 	unsigned int page_size;
-	char *version;
+	char *str = NULL;
+	char *zver;
 	char buf[BUFSIZ];
 	unsigned long ver;
 
@@ -3279,11 +3409,11 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	if (memcmp(buf, "tracing", 7) != 0)
 		goto failed_read;
 
-	version = read_string(handle);
-	if (!version)
+	str = read_string(handle);
+	if (!str)
 		goto failed_read;
-	pr_stat("version = %s\n", version);
-	ver = strtol(version, NULL, 10);
+	pr_stat("version = %s\n", str);
+	ver = strtol(str, NULL, 10);
 	if (!ver && errno)
 		goto failed_read;
 	if (!tracecmd_is_version_supported(ver)) {
@@ -3291,7 +3421,8 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 		goto failed_read;
 	}
 	handle->file_version = ver;
-	free(version);
+	free(str);
+	str = NULL;
 
 	if (do_read_check(handle, buf, 1))
 		goto failed_read;
@@ -3325,11 +3456,29 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	handle->header_files_start =
 		lseek64(handle->fd, handle->header_files_start, SEEK_SET);
 
+	if (handle->file_version >= 7) {
+		str = read_string(handle);
+		if (!str)
+			goto failed_read;
+		zver = strchr(str, ' ');
+		if (!zver)
+			goto failed_read;
+		*zver = '\0';
+		handle->z_proto = tracecmd_compress_proto_get(str, zver + 1);
+		if (!handle->z_proto) {
+			tracecmd_warning("Unsupported file compression %s %s", str, zver + 1);
+			goto failed_read;
+		}
+		free(str);
+		str = NULL;
+	}
+
 	handle->file_state = TRACECMD_FILE_INIT;
 
 	return handle;
 
  failed_read:
+	free(str);
 	free(handle);
 
 	return NULL;
-- 
2.30.2

