Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59BBC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC035611EE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhIJNwV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbhIJNwU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:20 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ECAC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:09 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id i21so4441922ejd.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=It9rMRjKwxscdF0C80OT1zYaIiFoNwk2iRM2QDkelqk=;
        b=ZD6je7tttwAd+IilX5CfedbVzgx3PMWVvWeQQ3PUm3Vg/ykri3zFdWJdEpYLB3A5Aj
         UDPdkoZxU7DSBjXYnk1eZJlQi+0vO2UASWcCfvkyhbS7759XhQUyVhalCVqUYrjgAcs6
         0LYHtWgo75I3Z0ooAWPTliiBYrGPsiTt6VC0wVxjmsao0vAHaZKwlQ2bcclcs3AJ+v3+
         RVriBwuuV84HDv24F55n/oWms1tCIx11mHTnNID8n9HASqw3Rmu2yRR7QriYe4ag8m1A
         4ZfO1gvs7yymE2sljxPsetcgneqXODXUbunbZxjkqvXQBKYTBv/gGm36CPC2z8DPlF2z
         j6aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=It9rMRjKwxscdF0C80OT1zYaIiFoNwk2iRM2QDkelqk=;
        b=syOEvs5YWDl8lps1Sr4xf2IXp4I/46S4BRrWBuEKNQH1kbYT4I+RV3Bkql+8jkFziT
         BB2NZbvSiq1SHTK4PkiY0hfY8iU4oz2fvCyliQ7Z/qwQUXiAy1lqQ3XeaHlSJvZt/ycP
         La//SNT9hQlF72zIrZwzwaPJpuI2JoBQW8lE5LJwinofV5s1P4NNNSd3qFOrWbFhuDmy
         QGrWJdnhow7zzBI9S9fGS6v/ZBwHe00I6AJcRuCdXB9mToyqYvzCYeCinO0lTL8tTWmW
         oLAXn1IFnhrEAG3uxvKuD46gi8a4X8o3aC7B8TPeCFIKl6J/Ho9OWCUgF8HIMc0DxpAM
         MGyA==
X-Gm-Message-State: AOAM533nreayS388722WowSZ0AancUV3hMPYKvDKNrXFjgu9hKTEc3Ux
        tzBlWlj0285+S/sIxHOsxhuHp/CJHCc=
X-Google-Smtp-Source: ABdhPJzAODK42fQvo72wFA6RHku9SiXIn2E9f4rHUGVgf9pgxt5UBCb0Ng8tQbmpQdu6bmO5K6Zabg==
X-Received: by 2002:a17:906:7047:: with SMTP id r7mr9281063ejj.342.1631281867911;
        Fri, 10 Sep 2021 06:51:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 05/25] trace-cmd library: Write header before file sections
Date:   Fri, 10 Sep 2021 16:50:41 +0300
Message-Id: <20210910135101.2865226-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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

New options are defined for each of these sections, holding
the section's offset into the trace file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |   6 +
 lib/trace-cmd/trace-output.c                  | 110 ++++++++++++++----
 2 files changed, 93 insertions(+), 23 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 6d524c99..d85a4b3b 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -138,6 +138,12 @@ enum {
 	TRACECMD_OPTION_TIME_SHIFT,
 	TRACECMD_OPTION_GUEST,
 	TRACECMD_OPTION_TSC2NSEC,
+	TRACECMD_OPTION_HEADER_INFO,
+	TRACECMD_OPTION_FTRACE_EVENTS,
+	TRACECMD_OPTION_EVENT_FORMATS,
+	TRACECMD_OPTION_KALLSYMS,
+	TRACECMD_OPTION_PRINTK,
+	TRACECMD_OPTION_CMDLINES,
 	TRACECMD_OPTION_MAX,
 };
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 3e987466..ca246fa8 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -402,10 +402,12 @@ __hidden int out_update_section_header(struct tracecmd_output *handle, unsigned
 
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
@@ -418,26 +420,33 @@ static int read_header_files(struct tracecmd_output *handle)
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
@@ -453,18 +462,18 @@ static int read_header_files(struct tracecmd_output *handle)
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
@@ -478,16 +487,18 @@ static int read_header_files(struct tracecmd_output *handle)
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
 
@@ -716,8 +727,10 @@ create_event_list_item(struct tracecmd_output *handle,
 
 static int read_ftrace_files(struct tracecmd_output *handle)
 {
+	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems = NULL;
 	struct tracecmd_event_list list = { .glob = "ftrace/*" };
+	tsize_t offset;
 	int ret;
 
 	if (!check_out_state(handle, TRACECMD_FILE_FTRACE_EVENTS)) {
@@ -726,11 +739,20 @@ static int read_ftrace_files(struct tracecmd_output *handle)
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
 
@@ -753,11 +775,13 @@ create_event_list(struct tracecmd_output *handle,
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
 
@@ -766,6 +790,11 @@ static int read_event_files(struct tracecmd_output *handle,
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
@@ -797,9 +826,14 @@ static int read_event_files(struct tracecmd_output *handle,
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
@@ -847,8 +881,10 @@ err:
 
 static int read_proc_kallsyms(struct tracecmd_output *handle)
 {
+	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
 	const char *path = "/proc/kallsyms";
+	tsize_t offset;
 	struct stat st;
 	int ret;
 
@@ -861,19 +897,24 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
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
@@ -881,18 +922,23 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
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
@@ -907,6 +953,10 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	if (!path)
 		return -1;
 
+	offset = out_write_section_header(handle, TRACECMD_OPTION_PRINTK, "printk", flags, true);
+	if (offset == (off64_t)-1)
+		return -1;
+
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
@@ -928,8 +978,10 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
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
@@ -1523,6 +1575,8 @@ static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char
 
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
+	enum tracecmd_section_flags flags = 0;
+	tsize_t offset;
 	int ret;
 
 	if (!check_out_state(handle, TRACECMD_FILE_CMD_LINES)) {
@@ -1530,9 +1584,19 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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
2.31.1

