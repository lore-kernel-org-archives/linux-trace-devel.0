Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A6FC28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbiAZJtW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbiAZJtV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:21 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE935C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:20 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id j23so63017869edp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k87RSvEaD1yYN+cf/ZciLtCT99Fh458z0YF0RoMNQN0=;
        b=FNMkErkhTGVMGF9jfTjjHaHeF+GZGZtMsEeNtNNtfao2zYpIcCqmQaiseMvR7lxUxE
         40Z63VBKdVDR+v7F0wrlMocv7V3LeI+XYtIeJj6UAd5xrP3kM5WbAsQcYtEgFwOS5oWJ
         wiXCzpRIM8RNhPR/uB27ZPnq0tm/RdicT0zRgWpfyAVQOwl2RDA1CNAFoRRLn+npSM9g
         v5MJ/rs3YBVvsZTTMLYS0Ywu/QUQIYp2agGTipplb2YPfiyfyQTes3bdFaul0dOHd9ZZ
         xeD/50264SugzF+CHSEOvQ/79gyBwiCaPAKGmKJL4k+gFOHdz1pwgigfi+HBBF9Kq6IG
         Uwig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k87RSvEaD1yYN+cf/ZciLtCT99Fh458z0YF0RoMNQN0=;
        b=7f0xhezoAFvY9NhV44FQmX6PqDA8ezAj35Hts7y9h5l0nWI6J2tzqPeQLerGoohAUx
         P/jsbeeb8TPXCKxR/mBapnGspezmbDEnnhVtRXN2Q97kdA1MyBAP0nX+6P5GAXERXxhW
         0VPChwDl10ikfXg0HECjZ0SL/O9YAuqZkSnVXuUP50Nk0l8AiHikf43nWyVtrHHfQ+sf
         h0/nWiPHnSBue3XuZ8l7O7tH51qJSkqhx/lj/oA5BihZ5fQvmVFYloLP7uHGBkvTLC4k
         S5TSOZ2oU5ElYjqr4FxSjn+btYhmWNkglCJ7FwG+cq1ncRnTilm0y+9NZtewBn7nVKXR
         5owg==
X-Gm-Message-State: AOAM531SeuF6SSs/2VlNthMISAlEMyYuCqmUrZ+LOKuP2cS1DIYvZ6XM
        eLmmFaOW+xcznQBImtZy3oRTs/hlIAU=
X-Google-Smtp-Source: ABdhPJzqzD84mGas+tyQvM+hxvL7U4Y7xxpMLW+TejkyOSxfE6r0RkSrE6IRdftjdCXFzFPIf9cJIg==
X-Received: by 2002:a05:6402:4c5:: with SMTP id n5mr24657667edw.122.1643190559431;
        Wed, 26 Jan 2022 01:49:19 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:18 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 07/20] trace-cmd library: Compress part of the trace file
Date:   Wed, 26 Jan 2022 11:48:53 +0200
Message-Id: <20220126094906.570451-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c | 99 ++++++++++++++++++++++++++++++------
 1 file changed, 83 insertions(+), 16 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 76ff4419..3ee8d8b4 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -97,7 +97,7 @@ struct list_event_system {
 #define HAS_SECTIONS(H) ((H)->file_version >= FILE_VERSION_SECTIONS)
 
 static int write_options(struct tracecmd_output *handle);
-static int save_string_section(struct tracecmd_output *handle);
+static int save_string_section(struct tracecmd_output *handle, bool compress);
 
 static stsize_t
 do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
@@ -288,7 +288,7 @@ void tracecmd_output_close(struct tracecmd_output *handle)
 		write_options(handle);
 
 		/* write strings section */
-		save_string_section(handle);
+		save_string_section(handle, true);
 	}
 
 	if (handle->fd >= 0) {
@@ -444,6 +444,8 @@ out_write_section_header(struct tracecmd_output *handle, unsigned short header_i
 		return -1;
 	if (!HAS_SECTIONS(handle))
 		return 0;
+	if (!handle->compress)
+		flags &= ~TRACECMD_SEC_FL_COMPRESS;
 	offset = do_lseek(handle, 0, SEEK_CUR);
 	if (option) {
 		endian8 = convert_endian_8(handle, offset);
@@ -505,7 +507,7 @@ __hidden int out_update_section_header(struct tracecmd_output *handle, tsize_t o
 	return 0;
 }
 
-static int save_string_section(struct tracecmd_output *handle)
+static int save_string_section(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	tsize_t offset;
@@ -519,13 +521,20 @@ static int save_string_section(struct tracecmd_output *handle)
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
 
@@ -537,10 +546,11 @@ static int save_string_section(struct tracecmd_output *handle)
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
@@ -560,11 +570,14 @@ static int read_header_files(struct tracecmd_output *handle)
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
@@ -578,6 +591,8 @@ static int read_header_files(struct tracecmd_output *handle)
 			goto out_close;
 		if (do_write_check(handle, &size, 8))
 			goto out_close;
+		if (out_compression_end(handle, compress))
+			goto out_close;
 		if (out_update_section_header(handle, offset))
 			goto out_close;
 		return 0;
@@ -630,6 +645,9 @@ static int read_header_files(struct tracecmd_output *handle)
 		goto out_close;
 	}
 	put_tracing_file(path);
+	if (out_compression_end(handle, compress))
+		goto out_close;
+
 	if (out_update_section_header(handle, offset))
 		goto out_close;
 	handle->file_state = TRACECMD_FILE_HEADERS;
@@ -637,6 +655,7 @@ static int read_header_files(struct tracecmd_output *handle)
 	return 0;
 
  out_close:
+	out_compression_reset(handle, compress);
 	if (fd >= 0)
 		close(fd);
 	return -1;
@@ -865,7 +884,7 @@ create_event_list_item(struct tracecmd_output *handle,
 	 tracecmd_warning("Insufficient memory");
 }
 
-static int read_ftrace_files(struct tracecmd_output *handle)
+static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems = NULL;
@@ -879,14 +898,21 @@ static int read_ftrace_files(struct tracecmd_output *handle)
 		return -1;
 	}
 
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_FTRACE_EVENTS,
 					  "ftrace events", flags, true);
 	if (offset == (off64_t)-1)
 		return -1;
 
 	create_event_list_item(handle, &systems, &list);
+	out_compression_start(handle, compress);
 
 	ret = copy_event_system(handle, systems);
+	if (!ret)
+		ret = out_compression_end(handle, compress);
+	else
+		out_compression_reset(handle, compress);
 
 	free_list_events(systems);
 	if (ret)
@@ -913,7 +939,7 @@ create_event_list(struct tracecmd_output *handle,
 }
 
 static int read_event_files(struct tracecmd_output *handle,
-			    struct tracecmd_event_list *event_list)
+			    struct tracecmd_event_list *event_list, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems;
@@ -931,6 +957,8 @@ static int read_event_files(struct tracecmd_output *handle,
 		return -1;
 	}
 
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_EVENT_FORMATS,
 					  "events format", flags, true);
 	if (offset == (off64_t)-1)
@@ -951,7 +979,7 @@ static int read_event_files(struct tracecmd_output *handle,
 
 	for (slist = systems; slist; slist = slist->next)
 		count++;
-
+	out_compression_start(handle, compress);
 	ret = -1;
 	endian4 = convert_endian_4(handle, count);
 	if (do_write_check(handle, &endian4, 4))
@@ -966,6 +994,10 @@ static int read_event_files(struct tracecmd_output *handle,
 		}
 		ret = copy_event_system(handle, slist);
 	}
+	if (ret)
+		goto out_free;
+
+	ret = out_compression_end(handle, compress);
 	if (ret)
 		goto out_free;
 	ret = out_update_section_header(handle, offset);
@@ -973,6 +1005,8 @@ static int read_event_files(struct tracecmd_output *handle,
  out_free:
 	if (!ret)
 		handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+	else
+		out_compression_reset(handle, compress);
 
 	free_list_events(systems);
 
@@ -1019,7 +1053,7 @@ err:
 		tracecmd_warning("can't set kptr_restrict");
 }
 
-static int read_proc_kallsyms(struct tracecmd_output *handle)
+static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
@@ -1037,11 +1071,14 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
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
@@ -1067,14 +1104,20 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
 	}
 	set_proc_kptr_restrict(1);
 
+	ret = out_compression_end(handle, compress);
+	if (ret)
+		goto out;
+
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
@@ -1093,10 +1136,13 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
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
@@ -1119,12 +1165,16 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 
  out:
 	put_tracing_file(path);
+	if (out_compression_end(handle, compress))
+		return -1;
+
 	if (out_update_section_header(handle, offset))
 		return -1;
 	handle->file_state = TRACECMD_FILE_PRINTK;
 	return 0;
  fail:
 	put_tracing_file(path);
+	out_compression_reset(handle, compress);
 	return -1;
 }
 
@@ -1517,21 +1567,25 @@ static int output_write_init(struct tracecmd_output *handle)
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
@@ -1762,7 +1816,7 @@ int tracecmd_write_meta_strings(struct tracecmd_output *handle)
 	if (!HAS_SECTIONS(handle))
 		return 0;
 
-	return save_string_section(handle);
+	return save_string_section(handle, true);
 }
 
 int tracecmd_write_options(struct tracecmd_output *handle)
@@ -1911,6 +1965,7 @@ static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
 	enum tracecmd_section_flags flags = 0;
+	bool compress = false;
 	tsize_t offset;
 	int ret;
 
@@ -1920,14 +1975,26 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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
2.34.1

