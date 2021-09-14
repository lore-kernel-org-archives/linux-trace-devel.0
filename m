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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C252C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 598D0610E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhINNQF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbhINNQE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:04 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AECDC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:47 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id i23so20175557wrb.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CCfKRGKW+rgbqdZ5QqTOyFlWtfS44UW1nom0Q4a+Wd0=;
        b=eOQuQIustM3TJIm2rZu3G/vcr/KuuSEuEGGj4J0mlG3xgYLIQQhwItsu/d/a3p821l
         dNf8Y0G/APVOiW/KgObkDw5WRcyh9+3UitoWujv7kzukXBsuC2I+3r0DX6ESOSrcJTSM
         poOMqSnctgJNiEEYmx/Wz14hQbfGOXyPycrU6ljJudcH1xvmTdPNqHPVbCWjVGOcBRS3
         J3BbllJt3TRdvxSO6lkQhcBL2ZrnrwxsbcgxblXWuALtPdNgRjbDUYtAlq/7PGdyvuJg
         HKpZSlJE+ocUG7rzqLNQ86w4q9q+V+RwoVpEipMCMCg+DKmc2JuFbqrVAyRcirXFIKXs
         iyLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CCfKRGKW+rgbqdZ5QqTOyFlWtfS44UW1nom0Q4a+Wd0=;
        b=QIQZI2PQjHVTDlcvZc7tuV0s4alRgLzjorZM1Wt/lhuoapiZjbJQ20oACalIhhxzWK
         b3i9iXeAmFCboWwvLuSAgWYu7eXNUcU7Ayry9GpCw7XgYdxzUxlPOVs466BxnTsCzy4t
         j8qWdyNT5+YziVHejGWwKi/clmHwontU3YZM6UBaGLKibyb3JojV+0DUMb0pwuLLkA+r
         EDgvX/t9oPrUEMhZKB8GFtwbMMIePHwKWmrStyVOnRJmHax7ycO+UE/vqwqIdnwgi2Hk
         jL57RQy7chqjqFAwVCmBzmyWPGU8fuOPWfFocLienI2P6Y6Jmn9hyrwWp2mPEA+xYZYe
         VhUQ==
X-Gm-Message-State: AOAM5320EDBmHyHpNUpMBtc3LxyIUGbl29FxlKgT9tJzA4DnIGXVyW0I
        +N4WI8Aftd2AW5ofQSLW6+estnTHUd0=
X-Google-Smtp-Source: ABdhPJy5QHoBjxuj9MTZwJpwamVRijplT+72+og8HM64jZj8Xpy0+R8QVt2dC/lANw+vC2yXA7epTg==
X-Received: by 2002:adf:e349:: with SMTP id n9mr19369528wrj.326.1631625285722;
        Tue, 14 Sep 2021 06:14:45 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:14:45 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 05/25] trace-cmd library: Write header before file sections
Date:   Tue, 14 Sep 2021 16:14:18 +0300
Message-Id: <20210914131438.3965484-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
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
index 5deabfe3..11f3ea77 100644
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
@@ -1520,6 +1572,8 @@ static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char
 
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
+	enum tracecmd_section_flags flags = 0;
+	tsize_t offset;
 	int ret;
 
 	if (!check_out_state(handle, TRACECMD_FILE_CMD_LINES)) {
@@ -1527,9 +1581,19 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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

