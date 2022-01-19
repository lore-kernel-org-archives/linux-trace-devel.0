Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD12C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352445AbiASI10 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343541AbiASI10 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:26 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AF0C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:25 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id c71so7612135edf.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nXPjESN+IZYvavt56bFb3mWFnbygaB7vIUGWsR0B8yc=;
        b=hNdWDjYocO5TD/11pg5yLpHwTrf4GEEIswpfQuShU7PS5eZuo3vd92MFD0GjEXBEmS
         WPsUgWZqNwlRyHFXDpmFJnW+3/fQdeSO+xQ9/jTHWzZeq47uNqq/8LUbQwcjmpMhIey6
         1aLR3coJZnJ5K8x9jXRDAGy4kgDRx7g8CnInI9CtYVCmK8Ny0jG7upgIsrNS1tszJI9t
         rnQkGFNFOFXBTQPRkmScNDenW7DZabpshbtHpUni76jxO8FGy6KBVWxkwFhrTAQFBQFh
         EGNvydxGKfWLZU4+pkd7VhwNfAxu2R9rGQB6NNLyeLqM4LY5SnorTHI9Te/A1giUx5aD
         gszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nXPjESN+IZYvavt56bFb3mWFnbygaB7vIUGWsR0B8yc=;
        b=Q2xSPzqLktMa3EUN81OIMc09AWzTkPWpU1DQbGGtSbIqKdext8vN9Y2HfafcNlWbN/
         fuO9z12JHDx0DDpfbkRYHYFPdxn+SFgeRwFVOious3gdz8xxX37STvcfK9NAWeE4IqOa
         wOivvvOcdPHeM8R1v99HSq9zQsNWv+GHLA1iPsmQrtUG7U9iWLuQ5JHB+FtndwFJLuTo
         erq6928AVoRF9NX3TDRBR0tkm7H7hOAPPeI6F00C9btgo8CNwKuvxM/AijgHstN9VTe7
         rSkj5r6SQsoYmrsFAwaC3PftbBhCxNgooOKizi0O9Ow88Nn18d06p2hFkF9u92VCAGN3
         KsdA==
X-Gm-Message-State: AOAM533fPCBau9MvvuTGe1nEtnAgdJsITdnlTIZ2XGxSdlrfTnajLD8/
        B78ATJMwAZXkfCSad0Nuljw/9sJMjX4=
X-Google-Smtp-Source: ABdhPJy6ylqRA1e+EE9j12u8hKlGEP1X1528qG5oKO09NchV8hkxi31g7PKzZ2IJoJ2firDa0bJDWw==
X-Received: by 2002:a17:907:6218:: with SMTP id ms24mr11748379ejc.677.1642580844281;
        Wed, 19 Jan 2022 00:27:24 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:23 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 07/20] trace-cmd library: Compress part of the trace file
Date:   Wed, 19 Jan 2022 10:27:02 +0200
Message-Id: <20220119082715.245846-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
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
index e8a02bf9..df65d02c 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -97,7 +97,7 @@ struct list_event_system {
 #define HAS_SECTIONS(H) ((H)->file_version >= FILE_VERSION_SECTIONS)
 
 static int write_options(struct tracecmd_output *handle);
-static int save_string_section(struct tracecmd_output *handle);
+static int save_string_section(struct tracecmd_output *handle, bool compress);
 
 static stsize_t
 do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
@@ -277,7 +277,7 @@ void tracecmd_output_close(struct tracecmd_output *handle)
 		write_options(handle);
 
 		/* write strings section */
-		save_string_section(handle);
+		save_string_section(handle, true);
 	}
 
 	if (handle->fd >= 0) {
@@ -433,6 +433,8 @@ out_write_section_header(struct tracecmd_output *handle, unsigned short header_i
 		return -1;
 	if (!HAS_SECTIONS(handle))
 		return 0;
+	if (!handle->compress)
+		flags &= ~TRACECMD_SEC_FL_COMPRESS;
 	offset = do_lseek(handle, 0, SEEK_CUR);
 	if (option) {
 		endian8 = convert_endian_8(handle, offset);
@@ -494,7 +496,7 @@ __hidden int out_update_section_header(struct tracecmd_output *handle, tsize_t o
 	return 0;
 }
 
-static int save_string_section(struct tracecmd_output *handle)
+static int save_string_section(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	tsize_t offset;
@@ -508,13 +510,20 @@ static int save_string_section(struct tracecmd_output *handle)
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
 
@@ -526,10 +535,11 @@ static int save_string_section(struct tracecmd_output *handle)
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
@@ -549,11 +559,14 @@ static int read_header_files(struct tracecmd_output *handle)
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
@@ -567,6 +580,8 @@ static int read_header_files(struct tracecmd_output *handle)
 			goto out_close;
 		if (do_write_check(handle, &size, 8))
 			goto out_close;
+		if (out_compression_end(handle, compress))
+			goto out_close;
 		if (out_update_section_header(handle, offset))
 			goto out_close;
 		return 0;
@@ -619,6 +634,8 @@ static int read_header_files(struct tracecmd_output *handle)
 		goto out_close;
 	}
 	put_tracing_file(path);
+	if (out_compression_end(handle, compress))
+		goto out_close;
 	if (out_update_section_header(handle, offset))
 		goto out_close;
 	handle->file_state = TRACECMD_FILE_HEADERS;
@@ -626,6 +643,7 @@ static int read_header_files(struct tracecmd_output *handle)
 	return 0;
 
  out_close:
+	out_compression_reset(handle, compress);
 	if (fd >= 0)
 		close(fd);
 	return -1;
@@ -854,7 +872,7 @@ create_event_list_item(struct tracecmd_output *handle,
 	 tracecmd_warning("Insufficient memory");
 }
 
-static int read_ftrace_files(struct tracecmd_output *handle)
+static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems = NULL;
@@ -868,15 +886,20 @@ static int read_ftrace_files(struct tracecmd_output *handle)
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
@@ -902,7 +925,7 @@ create_event_list(struct tracecmd_output *handle,
 }
 
 static int read_event_files(struct tracecmd_output *handle,
-			    struct tracecmd_event_list *event_list)
+			    struct tracecmd_event_list *event_list, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems;
@@ -920,6 +943,8 @@ static int read_event_files(struct tracecmd_output *handle,
 		return -1;
 	}
 
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_EVENT_FORMATS,
 					  "events format", flags, true);
 	if (offset == (off64_t)-1)
@@ -940,7 +965,7 @@ static int read_event_files(struct tracecmd_output *handle,
 
 	for (slist = systems; slist; slist = slist->next)
 		count++;
-
+	out_compression_start(handle, compress);
 	ret = -1;
 	endian4 = convert_endian_4(handle, count);
 	if (do_write_check(handle, &endian4, 4))
@@ -955,6 +980,9 @@ static int read_event_files(struct tracecmd_output *handle,
 		}
 		ret = copy_event_system(handle, slist);
 	}
+	if (ret)
+		goto out_free;
+	ret = out_compression_end(handle, compress);
 	if (ret)
 		goto out_free;
 	ret = out_update_section_header(handle, offset);
@@ -962,6 +990,8 @@ static int read_event_files(struct tracecmd_output *handle,
  out_free:
 	if (!ret)
 		handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+	else
+		out_compression_reset(handle, compress);
 
 	free_list_events(systems);
 
@@ -1008,7 +1038,7 @@ err:
 		tracecmd_warning("can't set kptr_restrict");
 }
 
-static int read_proc_kallsyms(struct tracecmd_output *handle)
+static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
@@ -1026,11 +1056,14 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
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
@@ -1056,14 +1089,19 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
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
@@ -1082,10 +1120,13 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
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
@@ -1108,12 +1149,15 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 
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
 
@@ -1500,21 +1544,25 @@ static int output_write_init(struct tracecmd_output *handle)
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
@@ -1745,7 +1793,7 @@ int tracecmd_write_meta_strings(struct tracecmd_output *handle)
 	if (!HAS_SECTIONS(handle))
 		return 0;
 
-	return save_string_section(handle);
+	return save_string_section(handle, true);
 }
 
 int tracecmd_write_options(struct tracecmd_output *handle)
@@ -1894,6 +1942,7 @@ static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
 	enum tracecmd_section_flags flags = 0;
+	bool compress = false;
 	tsize_t offset;
 	int ret;
 
@@ -1903,14 +1952,26 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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

