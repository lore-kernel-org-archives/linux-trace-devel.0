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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 973AAC43214
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FC6561052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbhG2FK1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbhG2FK1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:27 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2E3C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:24 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id x11so7515726ejj.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KlkRxkg7MkzkBDXkWogFob5bdRiFt8Jp3BlRur7Ub3c=;
        b=HbyN1cQSDTFpEzyF2bb/gQk/FyZfh3/rA3p5vHUTuC5KXJxrlg1msNVezTwZdDDZUr
         1pYsUy4ZXWmfO+BKsXC3ymiKbJ/GwlfQCs7KNxLublKsDJZoYeemj6PZmDebGkrVyjyb
         d+dfdrGGBlXTFiiSGlu++mw1r445KxEbrQ4etQiZV0Jx5vehRNMMJTe5APIrU7PyeaJS
         wp16/dvLKFawGeMIjMhHgi3vdfz6UqWe3zM7Mx8ccfwqhyOflTweG8kX6zWumOFP/Zr9
         57dJAYBnXNAp7oB+1/6KWQDVu+MrttrdSidpDC4m/mlEqMU98wJ3fZn/mNArjylCRpqq
         vysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KlkRxkg7MkzkBDXkWogFob5bdRiFt8Jp3BlRur7Ub3c=;
        b=eyX76llbMYUtLVXCFyzBcP4aTgfbpolYhTrGZoOEB7tDxKF4nr9OYl+7vlyrKnR0Ua
         pb2k2MOpMNZFIBQWXhSxQYAAJv2UOoWy4hYEiCIhuNEfpxGO9+I/2q0QK9V/67WJvHm/
         kefZDEKKMn2o5ILypmWXDosj64E8JdzwQ9TLpsGqVPAzu4Zl+8HM7mqtGHydWgXYDJiw
         hoSR/rqO7iOAhGwx1tRQ9Tr3+lezsSmi8gZyRNkMlTdaN8zSW88R6CZHbIuzCk8/NCqh
         GcrBbifxhzspnwbjj3QhZaJdFz1AsxJJdeuTt1k6XeKgBTKjKOqDvlp0ivofiTKfNcCn
         l4qA==
X-Gm-Message-State: AOAM531pfLWfVDxAmrWE0fxTu/3cG4PuW1SbXuwHy/fHZaVSZvwh741D
        DRVIgwoP6AWPJsHOVyCsuLw=
X-Google-Smtp-Source: ABdhPJxargtwtKhcQVDEGnMrLsOhzmv81Aw1ub1O/735sEbj+N0hpUiykWhLGPTCDeGJzLz+t/2vJw==
X-Received: by 2002:a17:906:138d:: with SMTP id f13mr2981980ejc.34.1627535423198;
        Wed, 28 Jul 2021 22:10:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 22/87] trace-cmd library: Write header before file sections
Date:   Thu, 29 Jul 2021 08:08:54 +0300
Message-Id: <20210729050959.12263-23-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Headers are added before these file secrtions, in trace
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
 .../include/private/trace-cmd-private.h       |  6 ++
 lib/trace-cmd/trace-output.c                  | 69 +++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 77948fbb..b193d6de 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -135,6 +135,12 @@ enum {
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
index 74192ea2..a5c11eba 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -438,8 +438,10 @@ __hidden int out_update_section_header(struct tracecmd_output *handle, unsigned
 
 static int read_header_files(struct tracecmd_output *handle, bool compress)
 {
+	enum tracecmd_section_flags flags = 0;
 	tsize_t size, check_size, endian8;
 	struct stat st;
+	tsize_t offset;
 	char *path;
 	int fd = -1;
 	int ret;
@@ -454,6 +456,13 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	if (!path)
 		return -1;
 
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
+	offset = out_write_section_header(handle, TRACECMD_OPTION_HEADER_INFO,
+					  "headers", flags, true);
+	if (offset == (off_t)-1)
+		return -1;
+
 	if (compress)
 		out_compression_start(handle);
 	ret = stat(path, &st);
@@ -469,6 +478,8 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 			goto out_close;
 		if (do_write_check(handle, &size, 8))
 			goto out_close;
+		if (out_update_section_header(handle, offset))
+			goto out_close;
 		if (compress && out_compression_end(handle))
 			goto out_close;
 		return 0;
@@ -523,6 +534,8 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	put_tracing_file(path);
 	if (compress && out_compression_end(handle))
 		goto out_close;
+	if (out_update_section_header(handle, offset))
+		goto out_close;
 	handle->file_state = TRACECMD_FILE_HEADERS;
 
 	return 0;
@@ -759,8 +772,10 @@ create_event_list_item(struct tracecmd_output *handle,
 
 static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
 {
+	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems = NULL;
 	struct tracecmd_event_list list = { .glob = "ftrace/*" };
+	tsize_t offset;
 	int ret;
 
 	if (!check_out_state(handle, TRACECMD_FILE_FTRACE_EVENTS)) {
@@ -769,6 +784,13 @@ static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
 		return -1;
 	}
 
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
+	offset = out_write_section_header(handle, TRACECMD_OPTION_FTRACE_EVENTS,
+					  "ftrace events", flags, true);
+	if (offset == (off_t)-1)
+		return -1;
+
 	create_event_list_item(handle, &systems, &list);
 	if (compress)
 		out_compression_start(handle);
@@ -780,6 +802,10 @@ static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
 			out_compression_reset(handle);
 	}
 	free_list_events(systems);
+	if (ret)
+		return ret;
+	if (out_update_section_header(handle, offset))
+		return -1;
 
 	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
 
@@ -802,11 +828,13 @@ create_event_list(struct tracecmd_output *handle,
 static int read_event_files(struct tracecmd_output *handle,
 			    struct tracecmd_event_list *event_list, bool compress)
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
 
@@ -815,6 +843,13 @@ static int read_event_files(struct tracecmd_output *handle,
 				 handle->file_state);
 		return -1;
 	}
+
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
+	offset = out_write_section_header(handle, TRACECMD_OPTION_EVENT_FORMATS,
+					  "events format", flags, true);
+	if (offset == (off64_t)-1)
+		return -1;
 	/*
 	 * If any of the list is the special keyword "all" then
 	 * just do all files.
@@ -854,6 +889,8 @@ static int read_event_files(struct tracecmd_output *handle,
 		if (ret)
 			goto out_free;
 	}
+	ret = out_update_section_header(handle, offset);
+
  out_free:
 	if (!ret)
 		handle->file_state = TRACECMD_FILE_ALL_EVENTS;
@@ -907,8 +944,10 @@ err:
 
 static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 {
+	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
 	const char *path = "/proc/kallsyms";
+	tsize_t offset;
 	struct stat st;
 	int ret;
 
@@ -921,6 +960,13 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 	if (handle->kallsyms)
 		path = handle->kallsyms;
 
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
+	offset = out_write_section_header(handle, TRACECMD_OPTION_KALLSYMS,
+					  "kallsyms", flags, true);
+	if (offset == (off64_t)-1)
+		return -1;
+
 	if (compress)
 		out_compression_start(handle);
 	ret = stat(path, &st);
@@ -953,6 +999,7 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 		if (ret)
 			goto out;
 	}
+	ret = out_update_section_header(handle, offset);
 out:
 	if (!ret)
 		handle->file_state = TRACECMD_FILE_KALLSYMS;
@@ -963,7 +1010,9 @@ out:
 
 static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
 {
+	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
+	tsize_t offset;
 	struct stat st;
 	char *path;
 	int ret;
@@ -978,6 +1027,12 @@ static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
 	if (!path)
 		return -1;
 
+	if (compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
+	offset = out_write_section_header(handle, TRACECMD_OPTION_PRINTK, "printk", flags, true);
+	if (offset == (off64_t)-1)
+		return -1;
+
 	if (compress)
 		out_compression_start(handle);
 	ret = stat(path, &st);
@@ -1004,6 +1059,8 @@ static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
 	put_tracing_file(path);
 	if (compress && out_compression_end(handle))
 		return -1;
+	if (out_update_section_header(handle, offset))
+		return -1;
 	handle->file_state = TRACECMD_FILE_PRINTK;
 	return 0;
  fail:
@@ -1636,6 +1693,8 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
 
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
+	enum tracecmd_section_flags flags = 0;
+	tsize_t offset;
 	int ret;
 
 	if (!check_out_state(handle, TRACECMD_FILE_CMD_LINES)) {
@@ -1644,6 +1703,13 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 		return -1;
 	}
 
+	if (handle->compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
+	offset = out_write_section_header(handle, TRACECMD_OPTION_CMDLINES,
+					  "command lines", flags, true);
+	if (offset == (off_t)-1)
+		return -1;
+
 	if (handle->compress)
 		out_compression_start(handle);
 
@@ -1656,6 +1722,9 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 	if (handle->compress && out_compression_end(handle))
 		return -1;
 
+	if (out_update_section_header(handle, offset))
+		return -1;
+
 	handle->file_state = TRACECMD_FILE_CMD_LINES;
 	return 0;
 }
-- 
2.31.1

