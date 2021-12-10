Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C18C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhLJK6d (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbhLJK6c (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:32 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA00C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:54:57 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id v1so28964436edx.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yMHISjM2K9Oz0saKtzBmExM8UFWVVQWYuCMzBQsHspM=;
        b=T3frN3huxpKHv1PkY0ob7ZYYJvy9qNeZ1WqrTNQBN0mKJIunlTAkj3NwhnDqwfimDN
         OA3Srr93SgvL13VQQbtrpQRzEV9bt5W7gnm7kn/59Z4AuFo4TEfiAo1MCq/6ex8EPQYp
         dEUEuCTgrBabFB42HysuQUq9AkJyLV+NvS1kyRD2ffMEo/p6HvAHT2Rqc2Tws44OFtlt
         IjJF/1z+YI1IahLYq370e+FvCeBGlRdXsnI1QmqOg5y2zoDfy5rK5Tw2dHxqkh0E6r+C
         PBOWcyS9ZXIlx62zA7t4W/CA4gPrGyJyGbfNnUCkcZDah/4X8YEQpwPw1n6tQYghwNxT
         RUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yMHISjM2K9Oz0saKtzBmExM8UFWVVQWYuCMzBQsHspM=;
        b=qDU9fIP5ROq5C1YH7GefCz3qhfod130w4TQMy893j80IFTN39ovbW1ooWyww3X+ach
         HFKE0YC1qkbsQMaELCr1bcR6YUg/iUb9ZtGqh6q+ojhE4gSL48HnWs+o0nxsD4sn7Iq0
         Gsn5IPt8fCaURaRMJ79VRsFNhhYvashQO4oiA15pZqZQRKCLRlTUsDsBoxlXWXfLAExp
         rsVG5Gb/+Rdm10DkjZjuVb99CBWyeyE1bX0m845FIhJUeorRWs44Viru6io3L0+8gN+F
         ObHdEJByioSE8Jx2AaMJpE9F1/M0dXq2/GyGpHRSjLkbyoRsywx+C1+fXKfL8FKetZRC
         EEXw==
X-Gm-Message-State: AOAM53344+KtjTt+1HtE8uOKvKy01/HJ4U+TGDT84MTZSkOZjL6n2cvi
        50/aKNotjBCodjXc2Uz5/G/F6R+e6EA=
X-Google-Smtp-Source: ABdhPJwfaxHmN5SCI4GgGdvDKqO96NIIpmgSqDFW14KerZcXS322BkQVckT4BYA0lQfmr+iW0a8KsQ==
X-Received: by 2002:a17:906:619:: with SMTP id s25mr23060814ejb.237.1639133695772;
        Fri, 10 Dec 2021 02:54:55 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:54:55 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 06/25] trace-cmd library: Write header before file sections
Date:   Fri, 10 Dec 2021 12:54:29 +0200
Message-Id: <20211210105448.97850-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Headers are added before these file sections, in trace
file version 7:
 - ftrace events format
 - format of recorded events
 - information of the mapping of function addresses to the function names
 - trace_printk() format strings
 - information of the mapping a PID to a process name
 - strings

New options are defined for each of these sections, holding
the section's offset into the trace file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |   6 +
 lib/trace-cmd/trace-output.c                  | 120 ++++++++++++++----
 2 files changed, 103 insertions(+), 23 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 1584d65a..047fc26f 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -139,6 +139,12 @@ enum {
 	TRACECMD_OPTION_GUEST,
 	TRACECMD_OPTION_TSC2NSEC,
 	TRACECMD_OPTION_STRINGS,
+	TRACECMD_OPTION_HEADER_INFO,
+	TRACECMD_OPTION_FTRACE_EVENTS,
+	TRACECMD_OPTION_EVENT_FORMATS,
+	TRACECMD_OPTION_KALLSYMS,
+	TRACECMD_OPTION_PRINTK,
+	TRACECMD_OPTION_CMDLINES,
 	TRACECMD_OPTION_MAX,
 };
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 457da305..aa55aad7 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -438,6 +438,9 @@ __hidden int out_update_section_header(struct tracecmd_output *handle, tsize_t o
 
 static int save_string_section(struct tracecmd_output *handle)
 {
+	enum tracecmd_section_flags flags = 0;
+	tsize_t offset;
+
 	if (!handle->strings || !handle->strings_p)
 		return 0;
 
@@ -447,9 +450,16 @@ static int save_string_section(struct tracecmd_output *handle)
 		return -1;
 	}
 
+	offset = out_write_section_header(handle, TRACECMD_OPTION_STRINGS, "strings", flags, false);
+	if (offset == (off64_t)-1)
+		return -1;
+
 	if (do_write_check(handle, handle->strings, handle->strings_p))
 		goto error;
 
+	if (out_update_section_header(handle, offset))
+		return -1;
+
 	handle->strings_offs += handle->strings_p;
 	free(handle->strings);
 	handle->strings = NULL;
@@ -463,10 +473,12 @@ error:
 
 static int read_header_files(struct tracecmd_output *handle)
 {
+	enum tracecmd_section_flags flags = 0;
 	tsize_t size, check_size, endian8;
 	struct stat st;
+	tsize_t offset;
 	char *path;
-	int fd;
+	int fd = -1;
 	int ret;
 
 	if (!check_out_state(handle, TRACECMD_FILE_HEADERS)) {
@@ -479,26 +491,33 @@ static int read_header_files(struct tracecmd_output *handle)
 	if (!path)
 		return -1;
 
+	offset = out_write_section_header(handle, TRACECMD_OPTION_HEADER_INFO,
+					  "headers", flags, true);
+	if (offset == (off64_t)-1)
+		return -1;
+
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* old style did not show this info, just add zero */
 		put_tracing_file(path);
 		if (do_write_check(handle, "header_page", 12))
-			return -1;
+			goto out_close;
 		size = 0;
 		if (do_write_check(handle, &size, 8))
-			return -1;
+			goto out_close;
 		if (do_write_check(handle, "header_event", 13))
-			return -1;
+			goto out_close;
 		if (do_write_check(handle, &size, 8))
-			return -1;
+			goto out_close;
+		if (out_update_section_header(handle, offset))
+			goto out_close;
 		return 0;
 	}
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0) {
 		tracecmd_warning("can't read '%s'", path);
-		return -1;
+		goto out_close;
 	}
 
 	/* unfortunately, you can not stat debugfs files for size */
@@ -514,18 +533,18 @@ static int read_header_files(struct tracecmd_output *handle)
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s' size=%lld read=%lld", path, size, check_size);
 		errno = EINVAL;
-		return -1;
+		goto out_close;
 	}
 	put_tracing_file(path);
 
 	path = get_tracing_file(handle, "events/header_event");
 	if (!path)
-		return -1;
+		goto out_close;
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0) {
 		tracecmd_warning("can't read '%s'", path);
-		return -1;
+		goto out_close;
 	}
 
 	size = get_size_fd(fd);
@@ -539,16 +558,18 @@ static int read_header_files(struct tracecmd_output *handle)
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s'", path);
-		return -1;
+		goto out_close;
 	}
 	put_tracing_file(path);
-
+	if (out_update_section_header(handle, offset))
+		goto out_close;
 	handle->file_state = TRACECMD_FILE_HEADERS;
 
 	return 0;
 
  out_close:
-	close(fd);
+	if (fd >= 0)
+		close(fd);
 	return -1;
 }
 
@@ -777,8 +798,10 @@ create_event_list_item(struct tracecmd_output *handle,
 
 static int read_ftrace_files(struct tracecmd_output *handle)
 {
+	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems = NULL;
 	struct tracecmd_event_list list = { .glob = "ftrace/*" };
+	tsize_t offset;
 	int ret;
 
 	if (!check_out_state(handle, TRACECMD_FILE_FTRACE_EVENTS)) {
@@ -787,11 +810,20 @@ static int read_ftrace_files(struct tracecmd_output *handle)
 		return -1;
 	}
 
+	offset = out_write_section_header(handle, TRACECMD_OPTION_FTRACE_EVENTS,
+					  "ftrace events", flags, true);
+	if (offset == (off64_t)-1)
+		return -1;
+
 	create_event_list_item(handle, &systems, &list);
 
 	ret = copy_event_system(handle, systems);
 
 	free_list_events(systems);
+	if (ret)
+		return ret;
+	if (out_update_section_header(handle, offset))
+		return -1;
 
 	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
 
@@ -814,11 +846,13 @@ create_event_list(struct tracecmd_output *handle,
 static int read_event_files(struct tracecmd_output *handle,
 			    struct tracecmd_event_list *event_list)
 {
+	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems;
 	struct list_event_system *slist;
 	struct tracecmd_event_list *list;
 	struct tracecmd_event_list all_events = { .glob = "*/*" };
 	int count = 0;
+	tsize_t offset;
 	int endian4;
 	int ret;
 
@@ -827,6 +861,11 @@ static int read_event_files(struct tracecmd_output *handle,
 				 handle->file_state);
 		return -1;
 	}
+
+	offset = out_write_section_header(handle, TRACECMD_OPTION_EVENT_FORMATS,
+					  "events format", flags, true);
+	if (offset == (off64_t)-1)
+		return -1;
 	/*
 	 * If any of the list is the special keyword "all" then
 	 * just do all files.
@@ -858,9 +897,14 @@ static int read_event_files(struct tracecmd_output *handle,
 		}
 		ret = copy_event_system(handle, slist);
 	}
+	if (ret)
+		goto out_free;
+	ret = out_update_section_header(handle, offset);
 
-	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
  out_free:
+	if (!ret)
+		handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+
 	free_list_events(systems);
 
 	return ret;
@@ -908,8 +952,10 @@ err:
 
 static int read_proc_kallsyms(struct tracecmd_output *handle)
 {
+	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
 	const char *path = "/proc/kallsyms";
+	tsize_t offset;
 	struct stat st;
 	int ret;
 
@@ -922,19 +968,24 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
 	if (handle->kallsyms)
 		path = handle->kallsyms;
 
+	offset = out_write_section_header(handle, TRACECMD_OPTION_KALLSYMS,
+					  "kallsyms", flags, true);
+	if (offset == (off64_t)-1)
+		return -1;
+
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
@@ -942,18 +993,23 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
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
+	ret = out_update_section_header(handle, offset);
+out:
+	if (!ret)
+		handle->file_state = TRACECMD_FILE_KALLSYMS;
+	return ret;
 }
 
 static int read_ftrace_printk(struct tracecmd_output *handle)
 {
+	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
+	tsize_t offset;
 	struct stat st;
 	char *path;
 	int ret;
@@ -968,6 +1024,10 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	if (!path)
 		return -1;
 
+	offset = out_write_section_header(handle, TRACECMD_OPTION_PRINTK, "printk", flags, true);
+	if (offset == (off64_t)-1)
+		return -1;
+
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
@@ -989,8 +1049,10 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	}
 
  out:
-	handle->file_state = TRACECMD_FILE_PRINTK;
 	put_tracing_file(path);
+	if (out_update_section_header(handle, offset))
+		return -1;
+	handle->file_state = TRACECMD_FILE_PRINTK;
 	return 0;
  fail:
 	put_tracing_file(path);
@@ -1594,6 +1656,8 @@ static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char
 
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
+	enum tracecmd_section_flags flags = 0;
+	tsize_t offset;
 	int ret;
 
 	if (!check_out_state(handle, TRACECMD_FILE_CMD_LINES)) {
@@ -1601,9 +1665,19 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 				 handle->file_state);
 		return -1;
 	}
+
+	offset = out_write_section_header(handle, TRACECMD_OPTION_CMDLINES,
+					  "command lines", flags, true);
+	if (offset == (off64_t)-1)
+		return -1;
+
 	ret = save_tracing_file_data(handle, "saved_cmdlines");
 	if (ret < 0)
 		return ret;
+
+	if (out_update_section_header(handle, offset))
+		return -1;
+
 	handle->file_state = TRACECMD_FILE_CMD_LINES;
 	return 0;
 }
-- 
2.33.1

