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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19302C48BD1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00582613E9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhFJLhj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:39 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:35543 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhFJLhf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:35 -0400
Received: by mail-wr1-f42.google.com with SMTP id m18so1921274wrv.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5/Ptno904wbIfdQ2YLSEMRtXDnRxxep6QWoMNal48Tw=;
        b=nrYZY3DwSRKg3SbW1rrD9SkYRH/Q0ptuvt+e09sLqxSAZPrJBKNhMRMo7+Q4UWfWNv
         qTwTHYF2Frtqvt6yNVyN4tw1c1eIu03/M2gOHUbVBLzWlrKD9AC/YV8us1rBJobNtd4N
         9UcmnjxJpikqzOsSxcMgypgKeDS+/AqRlEw28PgvSeXr8otGogR/4oDMjaIwd1dbCRpV
         SwbB+/6OWDP50/Fk0l6r3eyi2HB3k2n+/qq1qRsvFmz5UpseD+vDdxfKLTC0DfbXkV4n
         E+K4zNZwKeZtmhDxgjQFAYrLt/kHR87wWwtKmVbw1/O0Gk5SaYNvtItOc9w3Lo2dCWpY
         KpDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5/Ptno904wbIfdQ2YLSEMRtXDnRxxep6QWoMNal48Tw=;
        b=NU6RCsIlcvT+q3oHX0lvjQ3KyawJspf0OS0LxO0/ZkXTNWTmQRxvjpIk0IGYzKlsjq
         dTJGzFX7GS8Xks2wh0vtP+wg0joEeBZgcv+GioejDeQJFeDspDBJczZHpXyj6hO2ermP
         jI/rMaQYg4ib8+CB7tEc4CPKoPOwAnk0SUWy8jORO3AuR2SfBlJOmrQUglQCMoSPRjIl
         dj1GsyfSseUXRwvzELzPTQEWJq+puYvF5sQF/223PHYlA5evtc9KS6k9t5CtKIdOFRZ7
         rtrSY8O0G1g11ESMeM7kjFTg/UIkZC+hjs3UJRAF50rCxt8fGgv2Gbg+mLutQloXawZJ
         egBQ==
X-Gm-Message-State: AOAM530d7UOPqPWQMZnt7teHIrmSgSm+zPdvgb3GEVc1/5usHegRAx4f
        EOrZ0sprnBDP4mMj5KKWwKw=
X-Google-Smtp-Source: ABdhPJyCkMJGsLOlFplbsflpYjnIz1eV+b+Due6D66FVWMMOjJV3aEpCncTB6V6oFLYlvYkOBXb3fg==
X-Received: by 2002:a5d:474d:: with SMTP id o13mr4812253wrs.176.1623324878387;
        Thu, 10 Jun 2021 04:34:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 10/40] trace-cmd library: Compress part of the trace file
Date:   Thu, 10 Jun 2021 14:33:56 +0300
Message-Id: <20210610113426.257931-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Compress part of the trace.dat file metadata. If there is compression
support, chose file version 7 and compress these parts of the file:
 - ftrace events format
 - format of recorded events
 - information of the mapping of function addresses to the function names
 - trace_printk() format strings
 - information of the mapping a PID to a process name

A new compression header is added in the file, right after the page size
information.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |   4 +
 lib/trace-cmd/trace-output.c            | 145 ++++++++++++++++++++----
 2 files changed, 127 insertions(+), 22 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 3332572b..bf90eae8 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -34,4 +34,8 @@ void tracecmd_info(const char *fmt, ...);
 int tracecmd_compress_init(void);
 void tracecmd_compress_free(void);
 
+int out_compression_start(struct tracecmd_output *handle);
+int out_compression_end(struct tracecmd_output *handle);
+void out_compression_reset(struct tracecmd_output *handle);
+
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index bacda23b..0d89fe13 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -58,6 +58,10 @@ struct tracecmd_output {
 	bool			quiet;
 	unsigned long		file_state;
 	unsigned long		file_version;
+
+	bool			do_compress;
+	struct tracecmd_compression *compress;
+
 	struct list_head	options;
 	struct tracecmd_msg_handle *msg_handle;
 	char			*trace_clock;
@@ -78,12 +82,31 @@ struct list_event_system {
 static stsize_t
 do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
 {
+	if (handle->do_compress && handle->compress)
+		return tracecmd_compress_write(handle->compress, data, size);
+
 	if (handle->msg_handle)
 		return tracecmd_msg_data_send(handle->msg_handle, data, size);
 
 	return __do_write_check(handle->fd, data, size);
 }
 
+static inline int do_lseek(struct tracecmd_output *handle, off_t offset, int whence)
+{
+	if (handle->do_compress)
+		return tracecmd_compress_lseek(handle->compress, offset, whence);
+	else
+		return lseek64(handle->fd, offset, whence);
+}
+
+static inline int do_preed(struct tracecmd_output *handle, void *dst, int len, off_t offset)
+{
+	if (handle->do_compress)
+		return tracecmd_compress_pread(handle->compress, dst, len, offset);
+	else
+		return pread(handle->fd, dst, len, offset);
+}
+
 static short convert_endian_2(struct tracecmd_output *handle, short val)
 {
 	if (!handle->pevent)
@@ -109,6 +132,31 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
 	return tep_read_number(handle->pevent, &val, 8);
 }
 
+__hidden void out_compression_reset(struct tracecmd_output *handle)
+{
+	if (handle->file_version < 7 || !handle->compress)
+		return;
+	tracecmd_compress_reset(handle->compress);
+	handle->do_compress = false;
+}
+
+__hidden int out_compression_start(struct tracecmd_output *handle)
+{
+	if (handle->file_version < 7 || !handle->compress)
+		return 0;
+	tracecmd_compress_reset(handle->compress);
+	handle->do_compress = true;
+	return 0;
+}
+
+__hidden int out_compression_end(struct tracecmd_output *handle)
+{
+	if (handle->file_version < 7 || !handle->compress)
+		return 0;
+	handle->do_compress = false;
+	return tracecmd_compress_block(handle->compress);
+}
+
 /**
  * tracecmd_set_quiet - Set if to print output to the screen
  * @quiet: If non zero, print no output to the screen
@@ -159,6 +207,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 		free(option);
 	}
 	free(handle->trace_clock);
+	tracecmd_compress_destroy(handle->compress);
 	free(handle);
 }
 
@@ -659,13 +708,17 @@ static int read_ftrace_files(struct tracecmd_output *handle)
 	}
 
 	create_event_list_item(handle, &systems, &list);
-
+	out_compression_start(handle);
 	ret = copy_event_system(handle, systems);
+	if (!ret)
+		ret = out_compression_end(handle);
+	else
+		out_compression_reset(handle);
 
 	free_list_events(systems);
 
-	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
-
+	if (!ret)
+		handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
 	return ret;
 }
 
@@ -715,6 +768,7 @@ static int read_event_files(struct tracecmd_output *handle,
 	for (slist = systems; slist; slist = slist->next)
 		count++;
 
+	out_compression_start(handle);
 	ret = -1;
 	endian4 = convert_endian_4(handle, count);
 	if (do_write_check(handle, &endian4, 4))
@@ -730,8 +784,14 @@ static int read_event_files(struct tracecmd_output *handle,
 		ret = copy_event_system(handle, slist);
 	}
 
-	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+	if (!ret)
+		ret = out_compression_end(handle);
  out_free:
+	if (!ret)
+		handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+	else
+		out_compression_reset(handle);
+
 	free_list_events(systems);
 
 	return ret;
@@ -793,20 +853,20 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
 
 	if (kallsyms)
 		path = kallsyms;
-
+	out_compression_start(handle);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
 		size = 0;
 		endian4 = convert_endian_4(handle, size);
-		if (do_write_check(handle, &endian4, 4))
-			return -1;
-		return 0;
+		ret = do_write_check(handle, &endian4, 4);
+		goto out;
 	}
 	size = get_size(path);
 	endian4 = convert_endian_4(handle, size);
-	if (do_write_check(handle, &endian4, 4))
-		return -1;
+	ret = do_write_check(handle, &endian4, 4);
+	if (ret)
+		goto out;
 
 	set_proc_kptr_restrict(0);
 	check_size = copy_file(handle, path);
@@ -814,13 +874,18 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
 		errno = EINVAL;
 		tracecmd_warning("error in size of file '%s'", path);
 		set_proc_kptr_restrict(1);
-		return -1;
+		ret = -1;
+		goto out;
 	}
 	set_proc_kptr_restrict(1);
 
-	handle->file_state = TRACECMD_FILE_KALLSYMS;
-
-	return 0;
+	ret = out_compression_end(handle);
+out:
+	if (!ret)
+		handle->file_state = TRACECMD_FILE_KALLSYMS;
+	else
+		out_compression_reset(handle);
+	return ret;
 }
 
 static int read_ftrace_printk(struct tracecmd_output *handle)
@@ -840,6 +905,7 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	if (!path)
 		return -1;
 
+	out_compression_start(handle);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
@@ -861,11 +927,14 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	}
 
  out:
-	handle->file_state = TRACECMD_FILE_PRINTK;
 	put_tracing_file(path);
+	if (out_compression_end(handle))
+		return -1;
+	handle->file_state = TRACECMD_FILE_PRINTK;
 	return 0;
  fail:
 	put_tracing_file(path);
+	out_compression_reset(handle);
 	return -1;
 }
 
@@ -911,14 +980,39 @@ out_free:
 static int select_file_version(struct tracecmd_output *handle,
 				struct tracecmd_input *ihandle)
 {
-	if (ihandle)
+	if (ihandle) {
 		handle->file_version = tracecmd_get_in_file_version(ihandle);
-	else
-		handle->file_version = FILE_VERSION;
+	} else {
+		handle->compress = tracecmd_compress_alloc(NULL, NULL, handle->fd,
+							   handle->pevent, handle->msg_handle);
+		if (handle->compress)
+			handle->file_version = 7;
+		else
+			handle->file_version = 6;
+	}
 
 	return 0;
 }
 
+static int write_compression_header(struct tracecmd_output *handle)
+{
+	const char *name = NULL;
+	const char *ver = NULL;
+	char *buf;
+	int ret;
+
+	ret = tracecmd_compress_proto_get_name(handle->compress, &name, &ver);
+	if (ret < 0 || !name || !ver)
+		return -1;
+	ret = asprintf(&buf, "%s %s", name, ver);
+	if (ret < 0)
+		return -1;
+	ret = do_write_check(handle, buf, strlen(buf) + 1);
+
+	free(buf);
+	return ret;
+}
+
 static struct tracecmd_output *
 create_file_fd(int fd, struct tracecmd_input *ihandle,
 	       const char *tracing_dir,
@@ -992,8 +1086,9 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	endian4 = convert_endian_4(handle, handle->page_size);
 	if (do_write_check(handle, &endian4, 4))
 		goto out_free;
+	if (handle->file_version >= 7 && write_compression_header(handle))
+		goto out_free;
 	handle->file_state = TRACECMD_FILE_INIT;
-
 	if (ihandle)
 		return handle;
 
@@ -1285,11 +1380,17 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 				 handle->file_state);
 		return ret;
 	}
+	out_compression_start(handle);
+
 	ret = save_tracing_file_data(handle, "saved_cmdlines");
-	if (ret < 0)
+	if (ret < 0) {
+		out_compression_reset(handle);
 		return ret;
-	handle->file_state = TRACECMD_FILE_CMD_LINES;
-	return 0;
+	}
+	ret = out_compression_end(handle);
+	if (!ret)
+		handle->file_state = TRACECMD_FILE_CMD_LINES;
+	return ret;
 }
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
-- 
2.31.1

