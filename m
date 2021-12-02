Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81DAAC43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbhLBM2l (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbhLBM2k (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:40 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C76DC06175A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:17 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id v1so115094543edx.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S9u7c0rh/PE/OQ2MH1QjoK+RqGLIuPkcbKbrcSX41rY=;
        b=CgSca0jaaLeTHT+yGN7Uxu8WoD7UZ8dXD6/6RPLzf6DR25dI0zV53fQt1ruY7Vxiyk
         u4fV3YTqGYTmyX2lD8B2gaCIBSJ5bpdcNW/vEhqvRpxB//o+oURfsMb2Dy21objwFmAY
         IO489EAVw3E1oxa23FZa3lx7Co/2v4J9EyTPmVmzcYQoiEMy3SNeOEjAZhJ1SLPC4mi0
         QZ3sQlTf8rj9Jnwdpbp5aPJkXRxMUjK0t24fbVRQPWucWkWueZEpzJlFvK3wG+UeNuSQ
         PV0HBHlPJx+vV/fnebRzCidtrD8rECr2erWCROIgYT7QbGn041nKvfQzkORjrPxBj/jQ
         QgtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S9u7c0rh/PE/OQ2MH1QjoK+RqGLIuPkcbKbrcSX41rY=;
        b=6FO+t146QPiZgtziPUMQYfkUIFf/C2VCL8hCkHmTR+6roa8xZ3X7Z82vQTZeJzN2zR
         MPa6QM7J19FFqq6VKRi5p0/uJlCY6cvOd5s4ilRl8J4rSi1rimLubb4ALQCiaoQTQQlw
         UYucd9LIg5MtM1hv15OPQX4FhBYjzqvM+ZAtmTJmlAgXSWz+37+NugVjzu9/fH9E83TA
         Rc3UYY8NeA05xz+cTK1YADYdI0zEqYXwflEiGOTiQaj7BXuts2cLzuhzWqdWvAz6JAXf
         qxLNUW+F8+ytFT8L2iIjiQyizYblJuBRrIOqpvXvInLtrNWKZw8yL8FnoMtRM0Gen1cx
         MJIg==
X-Gm-Message-State: AOAM532BW0lJuEPlE0OSgAAbVNiWzQsMezLrDee9HD4mM/Txy2FN6si2
        gdty98kvz2IsVbWkG16aI++D0jo4InwozA==
X-Google-Smtp-Source: ABdhPJzAsFi6teL/CvSp2FoHzrfDfkrLTCKQCAsgrZ5IPxkCt4ZK4Ty/Ex6tIRqPABY7xYJrT9Xa1g==
X-Received: by 2002:a17:906:9153:: with SMTP id y19mr14934627ejw.516.1638447915419;
        Thu, 02 Dec 2021 04:25:15 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 07/20] trace-cmd library: Compress part of the trace file
Date:   Thu,  2 Dec 2021 14:24:54 +0200
Message-Id: <20211202122507.43572-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
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

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 81 +++++++++++++++++++++++++++++-------
 1 file changed, 67 insertions(+), 14 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 0dafa2d2..876be404 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -400,6 +400,8 @@ out_write_section_header(struct tracecmd_output *handle, unsigned short header_i
 		return -1;
 	if (!HAS_SECTIONS(handle))
 		return 0;
+	if (!handle->compress)
+		flags &= ~TRACECMD_SEC_FL_COMPRESS;
 	offset = do_lseek(handle, 0, SEEK_CUR);
 	if (option) {
 		endian8 = convert_endian_8(handle, offset);
@@ -455,7 +457,7 @@ __hidden int out_update_section_header(struct tracecmd_output *handle, unsigned
 	return 0;
 }
 
-static int read_header_files(struct tracecmd_output *handle)
+static int read_header_files(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	tsize_t size, check_size, endian8;
@@ -475,11 +477,14 @@ static int read_header_files(struct tracecmd_output *handle)
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
@@ -493,6 +498,8 @@ static int read_header_files(struct tracecmd_output *handle)
 			goto out_close;
 		if (do_write_check(handle, &size, 8))
 			goto out_close;
+		if (out_compression_end(handle, compress))
+			goto out_close;
 		if (out_update_section_header(handle, offset))
 			goto out_close;
 		return 0;
@@ -545,6 +552,8 @@ static int read_header_files(struct tracecmd_output *handle)
 		goto out_close;
 	}
 	put_tracing_file(path);
+	if (out_compression_end(handle, compress))
+		goto out_close;
 	if (out_update_section_header(handle, offset))
 		goto out_close;
 	handle->file_state = TRACECMD_FILE_HEADERS;
@@ -552,6 +561,7 @@ static int read_header_files(struct tracecmd_output *handle)
 	return 0;
 
  out_close:
+	out_compression_reset(handle, compress);
 	if (fd >= 0)
 		close(fd);
 	return -1;
@@ -780,7 +790,7 @@ create_event_list_item(struct tracecmd_output *handle,
 	 tracecmd_warning("Insufficient memory");
 }
 
-static int read_ftrace_files(struct tracecmd_output *handle)
+static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems = NULL;
@@ -794,15 +804,20 @@ static int read_ftrace_files(struct tracecmd_output *handle)
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
@@ -828,7 +843,7 @@ create_event_list(struct tracecmd_output *handle,
 }
 
 static int read_event_files(struct tracecmd_output *handle,
-			    struct tracecmd_event_list *event_list)
+			    struct tracecmd_event_list *event_list, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems;
@@ -846,6 +861,8 @@ static int read_event_files(struct tracecmd_output *handle,
 		return -1;
 	}
 
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_EVENT_FORMATS,
 					  "events format", flags, true);
 	if (offset == (off64_t)-1)
@@ -866,7 +883,7 @@ static int read_event_files(struct tracecmd_output *handle,
 
 	for (slist = systems; slist; slist = slist->next)
 		count++;
-
+	out_compression_start(handle, compress);
 	ret = -1;
 	endian4 = convert_endian_4(handle, count);
 	if (do_write_check(handle, &endian4, 4))
@@ -881,6 +898,9 @@ static int read_event_files(struct tracecmd_output *handle,
 		}
 		ret = copy_event_system(handle, slist);
 	}
+	if (ret)
+		goto out_free;
+	ret = out_compression_end(handle, compress);
 	if (ret)
 		goto out_free;
 	ret = out_update_section_header(handle, offset);
@@ -888,6 +908,8 @@ static int read_event_files(struct tracecmd_output *handle,
  out_free:
 	if (!ret)
 		handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+	else
+		out_compression_reset(handle, compress);
 
 	free_list_events(systems);
 
@@ -934,7 +956,7 @@ err:
 		tracecmd_warning("can't set kptr_restrict");
 }
 
-static int read_proc_kallsyms(struct tracecmd_output *handle)
+static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
@@ -952,11 +974,14 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
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
@@ -982,14 +1007,19 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
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
@@ -1008,10 +1038,13 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
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
@@ -1034,12 +1067,15 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 
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
 
@@ -1426,21 +1462,25 @@ static int output_write_init(struct tracecmd_output *handle)
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
@@ -1811,6 +1851,7 @@ static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
 	enum tracecmd_section_flags flags = 0;
+	bool compress = false;
 	tsize_t offset;
 	int ret;
 
@@ -1820,14 +1861,26 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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

