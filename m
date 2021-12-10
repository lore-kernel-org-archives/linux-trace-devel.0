Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63649C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240104AbhLJLDW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbhLJLDW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:22 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1D7C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:47 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id g14so27967060edb.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GSWtlPxKuX6lEMTp9uGEQk3/jlh12JO3c+vR8eul//k=;
        b=STk0ndlXcEKYM5QnOK8I0AE6wc+x609JSKYtYfrTfZzjXIAMUq5G3Wl1iti4s8wgor
         IT6NGYhKeX4cAd2x8u4Pu7ShIWYK15E8dML+7S+fy7cDjEtIzydtAaGRtymYYCG3bKPL
         ctc5xJ7MwCFpGuiBZgvT+83zbhfJsKaaPaZvCRjy9a2/MUZB3pzSuBO9hpIEQm4rGvzZ
         9fjo7nrjPc2mtMdXsnXGe1BKWA44sV1pErEIBDGDvXJu661D5dlyy1u0o1ksE96qpiaz
         hLEWyE2OqUafryDsZdkjDsoAQNdE3vcaHBeAcS6+piAxCAx/7aGfuVaWwc9HCDOjume+
         PJhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GSWtlPxKuX6lEMTp9uGEQk3/jlh12JO3c+vR8eul//k=;
        b=FUAlPs/qtuuKA82ZZu7CmHnIuntxPhmJ5H5yJJEDy04z1yavG2JnsFsjIC1gwItv2r
         nUeJa2Uk5kCoudMjI8JOOttoQByHUr4mfYOR7gIqDTlRO8NJMG2TBURy/YMZRVmim/Mj
         CUOnv8EitW+2uPyV4Pdj90bhwfnNXumh9loVIawZYBx+YgWTkTACTKnEg6nMSYry8mlX
         RRQHnSwF9KcPv/U0eX2PWNvX9ItRZiF3veT9ivIGEeGqglG6bF6W9C85y5eNcKHuGoxz
         MEf8gYPm1q4RlNqEqhN+ukcA0Od+uBdqJZhZntBtakBE+juMIMN425AWzODp+SrpxkFq
         VSkA==
X-Gm-Message-State: AOAM532aNuLp4u3bu9OOiyey3jV+q6Y+UGuklNUJ2eUt7phoPlgYkQKb
        01F8tqsklze9xVPmLA8lRBwLIVU7vPc=
X-Google-Smtp-Source: ABdhPJwjDrKHpIdr4guEBRxjiziWqErZZOUGLPYW1U/KCpoCnb/+mkmeKUCWQZdW6BIenC1I+XA9Og==
X-Received: by 2002:a17:906:90da:: with SMTP id v26mr23465978ejw.442.1639133985857;
        Fri, 10 Dec 2021 02:59:45 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:45 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 07/20] trace-cmd library: Compress part of the trace file
Date:   Fri, 10 Dec 2021 12:59:25 +0200
Message-Id: <20211210105938.98250-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Compress part of the trace.dat file metadata. If there is compression
support, compress these parts of the file:
 - ftrace events format
 - format of recorded events
 - information of the mapping of function addresses to the function names
 - trace_printk() format strings
 - information of the mapping a PID to a process name
 - strings

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 97 +++++++++++++++++++++++++++++-------
 1 file changed, 79 insertions(+), 18 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 43667c8b..a5878636 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -92,7 +92,7 @@ struct list_event_system {
 #define HAS_SECTIONS(H) ((H)->file_version >= FILE_VERSION_SECTIONS)
 
 static int write_options_v7(struct tracecmd_output *handle);
-static int save_string_section(struct tracecmd_output *handle);
+static int save_string_section(struct tracecmd_output *handle, bool compress);
 
 static stsize_t
 do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
@@ -272,7 +272,7 @@ void tracecmd_output_close(struct tracecmd_output *handle)
 		write_options_v7(handle);
 
 		/* write strings section */
-		save_string_section(handle);
+		save_string_section(handle, true);
 	}
 
 	if (handle->fd >= 0) {
@@ -428,6 +428,8 @@ out_write_section_header(struct tracecmd_output *handle, unsigned short header_i
 		return -1;
 	if (!HAS_SECTIONS(handle))
 		return 0;
+	if (!handle->compress)
+		flags &= ~TRACECMD_SEC_FL_COMPRESS;
 	offset = do_lseek(handle, 0, SEEK_CUR);
 	if (option) {
 		endian8 = convert_endian_8(handle, offset);
@@ -489,7 +491,7 @@ __hidden int out_update_section_header(struct tracecmd_output *handle, tsize_t o
 	return 0;
 }
 
-static int save_string_section(struct tracecmd_output *handle)
+static int save_string_section(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	tsize_t offset;
@@ -503,13 +505,20 @@ static int save_string_section(struct tracecmd_output *handle)
 		return -1;
 	}
 
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_STRINGS, "strings", flags, false);
 	if (offset == (off64_t)-1)
 		return -1;
 
+	out_compression_start(handle, compress);
+
 	if (do_write_check(handle, handle->strings, handle->strings_p))
 		goto error;
 
+	if (out_compression_end(handle, compress))
+		goto error;
+
 	if (out_update_section_header(handle, offset))
 		return -1;
 
@@ -521,10 +530,11 @@ static int save_string_section(struct tracecmd_output *handle)
 	return 0;
 
 error:
+	out_compression_reset(handle, compress);
 	return -1;
 }
 
-static int read_header_files(struct tracecmd_output *handle)
+static int read_header_files(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	tsize_t size, check_size, endian8;
@@ -544,11 +554,14 @@ static int read_header_files(struct tracecmd_output *handle)
 	if (!path)
 		return -1;
 
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_HEADER_INFO,
 					  "headers", flags, true);
 	if (offset == (off64_t)-1)
 		return -1;
 
+	out_compression_start(handle, compress);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* old style did not show this info, just add zero */
@@ -562,6 +575,8 @@ static int read_header_files(struct tracecmd_output *handle)
 			goto out_close;
 		if (do_write_check(handle, &size, 8))
 			goto out_close;
+		if (out_compression_end(handle, compress))
+			goto out_close;
 		if (out_update_section_header(handle, offset))
 			goto out_close;
 		return 0;
@@ -614,6 +629,8 @@ static int read_header_files(struct tracecmd_output *handle)
 		goto out_close;
 	}
 	put_tracing_file(path);
+	if (out_compression_end(handle, compress))
+		goto out_close;
 	if (out_update_section_header(handle, offset))
 		goto out_close;
 	handle->file_state = TRACECMD_FILE_HEADERS;
@@ -621,6 +638,7 @@ static int read_header_files(struct tracecmd_output *handle)
 	return 0;
 
  out_close:
+	out_compression_reset(handle, compress);
 	if (fd >= 0)
 		close(fd);
 	return -1;
@@ -849,7 +867,7 @@ create_event_list_item(struct tracecmd_output *handle,
 	 tracecmd_warning("Insufficient memory");
 }
 
-static int read_ftrace_files(struct tracecmd_output *handle)
+static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems = NULL;
@@ -863,15 +881,20 @@ static int read_ftrace_files(struct tracecmd_output *handle)
 		return -1;
 	}
 
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_FTRACE_EVENTS,
 					  "ftrace events", flags, true);
 	if (offset == (off64_t)-1)
 		return -1;
 
 	create_event_list_item(handle, &systems, &list);
-
+	out_compression_start(handle, compress);
 	ret = copy_event_system(handle, systems);
-
+	if (!ret)
+		ret = out_compression_end(handle, compress);
+	else
+		out_compression_reset(handle, compress);
 	free_list_events(systems);
 	if (ret)
 		return ret;
@@ -897,7 +920,7 @@ create_event_list(struct tracecmd_output *handle,
 }
 
 static int read_event_files(struct tracecmd_output *handle,
-			    struct tracecmd_event_list *event_list)
+			    struct tracecmd_event_list *event_list, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems;
@@ -915,6 +938,8 @@ static int read_event_files(struct tracecmd_output *handle,
 		return -1;
 	}
 
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_EVENT_FORMATS,
 					  "events format", flags, true);
 	if (offset == (off64_t)-1)
@@ -935,7 +960,7 @@ static int read_event_files(struct tracecmd_output *handle,
 
 	for (slist = systems; slist; slist = slist->next)
 		count++;
-
+	out_compression_start(handle, compress);
 	ret = -1;
 	endian4 = convert_endian_4(handle, count);
 	if (do_write_check(handle, &endian4, 4))
@@ -950,6 +975,9 @@ static int read_event_files(struct tracecmd_output *handle,
 		}
 		ret = copy_event_system(handle, slist);
 	}
+	if (ret)
+		goto out_free;
+	ret = out_compression_end(handle, compress);
 	if (ret)
 		goto out_free;
 	ret = out_update_section_header(handle, offset);
@@ -957,6 +985,8 @@ static int read_event_files(struct tracecmd_output *handle,
  out_free:
 	if (!ret)
 		handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+	else
+		out_compression_reset(handle, compress);
 
 	free_list_events(systems);
 
@@ -1003,7 +1033,7 @@ err:
 		tracecmd_warning("can't set kptr_restrict");
 }
 
-static int read_proc_kallsyms(struct tracecmd_output *handle)
+static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
@@ -1021,11 +1051,14 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
 	if (handle->kallsyms)
 		path = handle->kallsyms;
 
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_KALLSYMS,
 					  "kallsyms", flags, true);
 	if (offset == (off64_t)-1)
 		return -1;
 
+	out_compression_start(handle, compress);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
@@ -1051,14 +1084,19 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
 	}
 	set_proc_kptr_restrict(1);
 
+	ret = out_compression_end(handle, compress);
+	if (ret)
+		goto out;
 	ret = out_update_section_header(handle, offset);
 out:
 	if (!ret)
 		handle->file_state = TRACECMD_FILE_KALLSYMS;
+	else
+		out_compression_reset(handle, compress);
 	return ret;
 }
 
-static int read_ftrace_printk(struct tracecmd_output *handle)
+static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
@@ -1077,10 +1115,13 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	if (!path)
 		return -1;
 
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_PRINTK, "printk", flags, true);
 	if (offset == (off64_t)-1)
 		return -1;
 
+	out_compression_start(handle, compress);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
@@ -1103,12 +1144,15 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 
  out:
 	put_tracing_file(path);
+	if (out_compression_end(handle, compress))
+		return -1;
 	if (out_update_section_header(handle, offset))
 		return -1;
 	handle->file_state = TRACECMD_FILE_PRINTK;
 	return 0;
  fail:
 	put_tracing_file(path);
+	out_compression_reset(handle, compress);
 	return -1;
 }
 
@@ -1495,21 +1539,25 @@ static int output_write_init(struct tracecmd_output *handle)
 int tracecmd_output_write_headers(struct tracecmd_output *handle,
 				  struct tracecmd_event_list *list)
 {
+	bool compress = false;
+
 	if (!handle || handle->file_state < TRACECMD_FILE_ALLOCATED)
 		return -1;
 
 	/* Write init data, if not written yet */
 	if (handle->file_state < TRACECMD_FILE_INIT && output_write_init(handle))
 		return -1;
-	if (read_header_files(handle))
+	if (handle->compress)
+		compress = true;
+	if (read_header_files(handle, compress))
 		return -1;
-	if (read_ftrace_files(handle))
+	if (read_ftrace_files(handle, compress))
 		return -1;
-	if (read_event_files(handle, list))
+	if (read_event_files(handle, list, compress))
 		return -1;
-	if (read_proc_kallsyms(handle))
+	if (read_proc_kallsyms(handle, compress))
 		return -1;
-	if (read_ftrace_printk(handle))
+	if (read_ftrace_printk(handle, compress))
 		return -1;
 	return 0;
 }
@@ -1738,7 +1786,7 @@ int tracecmd_write_meta_strings(struct tracecmd_output *handle)
 	if (!HAS_SECTIONS(handle))
 		return 0;
 
-	return save_string_section(handle);
+	return save_string_section(handle, true);
 }
 
 int tracecmd_write_options(struct tracecmd_output *handle)
@@ -1887,6 +1935,7 @@ static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
 	enum tracecmd_section_flags flags = 0;
+	bool compress = false;
 	tsize_t offset;
 	int ret;
 
@@ -1896,14 +1945,26 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 		return -1;
 	}
 
+	if (handle->compress)
+		compress = true;
+
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_CMDLINES,
 					  "command lines", flags, true);
 	if (offset == (off64_t)-1)
 		return -1;
 
+	out_compression_start(handle, compress);
+
 	ret = save_tracing_file_data(handle, "saved_cmdlines");
-	if (ret < 0)
+	if (ret < 0) {
+		out_compression_reset(handle, compress);
 		return ret;
+	}
+
+	if (out_compression_end(handle, compress))
+		return -1;
 
 	if (out_update_section_header(handle, offset))
 		return -1;
-- 
2.33.1

