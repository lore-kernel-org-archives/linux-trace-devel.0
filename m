Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C345C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DC4E60F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237434AbhJHEYV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbhJHEYU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:20 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FF3C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:25 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id r18so31297343edv.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4mkCTRKMwSpXL7qMAK0zSmx8Npt2l2sm/JfSDNeFJsY=;
        b=kLoDErA9sATOsnRObdyGJQbDHcg59zkLZIEiPKTYtOcF9f83Xpq/4tRHRk5qX+ASux
         PNhCnbRGpG545UcNxnAcyk13ACOOC4r4tG7ws+QaTpN9B0hJ+LkUTyXZcERCgVUDhvVm
         4OTp0BLnQAiZbu/CdOI7NtUpq+EvpMJx5EQMMZ/edCVTr+j6B9YyuQZGxdUEHSnP0pmq
         XlZZQkz7NPpFlueYPmPEdNNO7nsMIFXWM3UiqVR/JaGbDrvivPXU9jIdiq9rp1StQskY
         UdAszawY29WHVsT7ny0cs0HrIfjzqoAgBFYsHCu83bUCyPFN/St8ELr2T8GHJPyG4im0
         o76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4mkCTRKMwSpXL7qMAK0zSmx8Npt2l2sm/JfSDNeFJsY=;
        b=UWYyIwkBjE9qAsCQDGrvRSfb9XNYZjhkK7Ox3F7v/z2+elKThVf+FBVmt2frNX+wX+
         dwY/OyB6OlpZ4JrGnXP/9qG0+qN+cgqpN0ovNq58QrT+1Ky/Snkm9D2u8O9VmIhTCfWb
         CjEXAzQ/myRDLWAXc9KgV4xhGy1++5dkxhcz59hED2DQzZvRnTCpKwnkqZTU7fvycu3q
         SNW7wX7a4EE2ko5ujwM3E5xneFQo8428PZrFxPtoeG68nM0W9YTx0qnH1ijxdZICMbJK
         rJulx1Ij1fP13CVs9f3ZT9QqSayTwePtovlbzHtsd8IRa+D3QNZ9MtxkjZs5QnrE4Qbd
         7aBQ==
X-Gm-Message-State: AOAM531zrz00HIA93d5wckzLTtySuLGeMD9DYabgSV1U5Fj+zFvGvh14
        91TmxzOV1VWmlocZhZxtW5XVbXJmSrIihg==
X-Google-Smtp-Source: ABdhPJzbLQ/AyaDmIVDJJLLhe2ttr0X26oN/BuQbVsmwDrWQW3Xuh5cdHD0sc113Z+aYBVXfYN2Yfw==
X-Received: by 2002:a17:906:54c3:: with SMTP id c3mr1269148ejp.536.1633666944229;
        Thu, 07 Oct 2021 21:22:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 07/20] trace-cmd library: Compress part of the trace file
Date:   Fri,  8 Oct 2021 07:22:01 +0300
Message-Id: <20211008042214.977193-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
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
index ee978409..d15a5986 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -394,6 +394,8 @@ out_write_section_header(struct tracecmd_output *handle, unsigned short header_i
 		return -1;
 	if (!HAS_SECTIONS(handle))
 		return 0;
+	if (!handle->compress)
+		flags &= ~TRACECMD_SEC_FL_COMPRESS;
 	offset = do_lseek(handle, 0, SEEK_CUR);
 	if (option) {
 		endian8 = convert_endian_8(handle, offset);
@@ -449,7 +451,7 @@ __hidden int out_update_section_header(struct tracecmd_output *handle, unsigned
 	return 0;
 }
 
-static int read_header_files(struct tracecmd_output *handle)
+static int read_header_files(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	tsize_t size, check_size, endian8;
@@ -469,11 +471,14 @@ static int read_header_files(struct tracecmd_output *handle)
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
@@ -487,6 +492,8 @@ static int read_header_files(struct tracecmd_output *handle)
 			goto out_close;
 		if (do_write_check(handle, &size, 8))
 			goto out_close;
+		if (out_compression_end(handle, compress))
+			goto out_close;
 		if (out_update_section_header(handle, offset))
 			goto out_close;
 		return 0;
@@ -539,6 +546,8 @@ static int read_header_files(struct tracecmd_output *handle)
 		goto out_close;
 	}
 	put_tracing_file(path);
+	if (out_compression_end(handle, compress))
+		goto out_close;
 	if (out_update_section_header(handle, offset))
 		goto out_close;
 	handle->file_state = TRACECMD_FILE_HEADERS;
@@ -546,6 +555,7 @@ static int read_header_files(struct tracecmd_output *handle)
 	return 0;
 
  out_close:
+	out_compression_reset(handle, compress);
 	if (fd >= 0)
 		close(fd);
 	return -1;
@@ -774,7 +784,7 @@ create_event_list_item(struct tracecmd_output *handle,
 	 tracecmd_warning("Insufficient memory");
 }
 
-static int read_ftrace_files(struct tracecmd_output *handle)
+static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems = NULL;
@@ -788,15 +798,20 @@ static int read_ftrace_files(struct tracecmd_output *handle)
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
@@ -822,7 +837,7 @@ create_event_list(struct tracecmd_output *handle,
 }
 
 static int read_event_files(struct tracecmd_output *handle,
-			    struct tracecmd_event_list *event_list)
+			    struct tracecmd_event_list *event_list, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems;
@@ -840,6 +855,8 @@ static int read_event_files(struct tracecmd_output *handle,
 		return -1;
 	}
 
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_EVENT_FORMATS,
 					  "events format", flags, true);
 	if (offset == (off64_t)-1)
@@ -860,7 +877,7 @@ static int read_event_files(struct tracecmd_output *handle,
 
 	for (slist = systems; slist; slist = slist->next)
 		count++;
-
+	out_compression_start(handle, compress);
 	ret = -1;
 	endian4 = convert_endian_4(handle, count);
 	if (do_write_check(handle, &endian4, 4))
@@ -875,6 +892,9 @@ static int read_event_files(struct tracecmd_output *handle,
 		}
 		ret = copy_event_system(handle, slist);
 	}
+	if (ret)
+		goto out_free;
+	ret = out_compression_end(handle, compress);
 	if (ret)
 		goto out_free;
 	ret = out_update_section_header(handle, offset);
@@ -882,6 +902,8 @@ static int read_event_files(struct tracecmd_output *handle,
  out_free:
 	if (!ret)
 		handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+	else
+		out_compression_reset(handle, compress);
 
 	free_list_events(systems);
 
@@ -928,7 +950,7 @@ err:
 		tracecmd_warning("can't set kptr_restrict");
 }
 
-static int read_proc_kallsyms(struct tracecmd_output *handle)
+static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
@@ -946,11 +968,14 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
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
@@ -976,14 +1001,19 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
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
@@ -1002,10 +1032,13 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
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
@@ -1028,12 +1061,15 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 
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
 
@@ -1407,21 +1443,25 @@ int tracecmd_output_write_init(struct tracecmd_output *handler)
 int tracecmd_output_write_headers(struct tracecmd_output *handler,
 				  struct tracecmd_event_list *list)
 {
+	bool compress = false;
+
 	if (!handler || handler->file_state < TRACECMD_FILE_ALLOCATED)
 		return -1;
 
 	/* Write init data, if not written yet */
 	if (handler->file_state < TRACECMD_FILE_INIT && tracecmd_output_write_init(handler))
 		return -1;
-	if (read_header_files(handler))
+	if (handler->compress)
+		compress = true;
+	if (read_header_files(handler, compress))
 		return -1;
-	if (read_ftrace_files(handler))
+	if (read_ftrace_files(handler, compress))
 		return -1;
-	if (read_event_files(handler, list))
+	if (read_event_files(handler, list, compress))
 		return -1;
-	if (read_proc_kallsyms(handler))
+	if (read_proc_kallsyms(handler, compress))
 		return -1;
-	if (read_ftrace_printk(handler))
+	if (read_ftrace_printk(handler, compress))
 		return -1;
 	return 0;
 }
@@ -1792,6 +1832,7 @@ static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
 	enum tracecmd_section_flags flags = 0;
+	bool compress = false;
 	tsize_t offset;
 	int ret;
 
@@ -1801,14 +1842,26 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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
2.31.1

