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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A15EC4320E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68EC360EC0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbhG1NdU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236658AbhG1NdT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:19 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F22C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:15 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gs8so4563377ejc.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ik4dkRx+LCcT3uzrO6aNDWZPSHLGyODrXBsXukfh8KQ=;
        b=cO5s6fJgucQjVKNkO9PCVm8JIhM5RkCrQzdaEoOzo0szZBvnK0uXBurV1I6n/TbVwy
         wVJe8nS9etJqrdX29FAuKBDI/DEcuZF+bkvaEMdgf3yrY4q+HP2kqj4b4eOFNxIknqCP
         UF4DDZA0oEg4D4Oe4bIoH+iIqm6++e+nfKQaVM8USnZyla1bE2fm+aJkDqn1MNULwh4L
         4yO2arSvHIcznEgdBvH8ZKSwLKfB2HCnabTQjp4yl3QbaVtOfscyqfE4GQCwzICBYeyf
         wrVKkWpnehgazc+jbk5Dkl5275IbfaL3akzNkawdSyGsJeP5MOQZdFh5WiRlj1JxTZlL
         5bcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ik4dkRx+LCcT3uzrO6aNDWZPSHLGyODrXBsXukfh8KQ=;
        b=nUbjOT0f0orAzXkkEElNntHulJpMnGMeG6ae8HquxiJ39i9YJL5AgnwiYAFjURTd+d
         1nk6RxYv7zszvM0iE8ytYDdLNMYJAYuZyUbjOPOCi7MeAJZErP+vCRDLhmn1jxf1plVb
         JtT0Ekmo9t4nIad4QPOTNxKTiVbc1ajQiYTYSRHq4V+/G+eaza1W9XAlXK2veSA3Bnh4
         LG0AP7R9seU7mAhKdBWn98tyaO3q2nuMHFqDDrJH1LkBfTo7DgMPG1OqOCYfb1nY0+pk
         q4Aldat3ztnkv5KttM0nT2sbDOS6fdQocx3vJARezwQmPSApg+8lvbxAPxoKM3JNOvBu
         bjAg==
X-Gm-Message-State: AOAM530zhV/sSYagBB1AvrvamezGNYn2V4EFCKH6HVNh5pJ0C8bw43uh
        pL8wo0+cWMiXqieXoGFq91DEp+JLMB6kHw==
X-Google-Smtp-Source: ABdhPJwnfHGXuUWkVXqYH20Cv12Oi4yhbzm+AD3KJbfGbv9Ew/t4p67dhFyRgOZi4a8cWDcVWQhk5Q==
X-Received: by 2002:a17:906:4103:: with SMTP id j3mr26771954ejk.526.1627479194139;
        Wed, 28 Jul 2021 06:33:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 22/87] trace-cmd library: Write header before file sections
Date:   Wed, 28 Jul 2021 16:31:45 +0300
Message-Id: <20210728133250.234140-23-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index ee28502f..ff937c99 100644
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
@@ -853,6 +888,8 @@ static int read_event_files(struct tracecmd_output *handle,
 		if (ret)
 			goto out_free;
 	}
+	ret = out_update_section_header(handle, offset);
+
  out_free:
 	if (!ret)
 		handle->file_state = TRACECMD_FILE_ALL_EVENTS;
@@ -906,8 +943,10 @@ err:
 
 static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 {
+	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
 	const char *path = "/proc/kallsyms";
+	tsize_t offset;
 	struct stat st;
 	int ret;
 
@@ -920,6 +959,13 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
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
@@ -952,6 +998,7 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 		if (ret)
 			goto out;
 	}
+	ret = out_update_section_header(handle, offset);
 out:
 	if (!ret)
 		handle->file_state = TRACECMD_FILE_KALLSYMS;
@@ -962,7 +1009,9 @@ out:
 
 static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
 {
+	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
+	tsize_t offset;
 	struct stat st;
 	char *path;
 	int ret;
@@ -977,6 +1026,12 @@ static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
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
@@ -1003,6 +1058,8 @@ static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
 	put_tracing_file(path);
 	if (compress && out_compression_end(handle))
 		return -1;
+	if (out_update_section_header(handle, offset))
+		return -1;
 	handle->file_state = TRACECMD_FILE_PRINTK;
 	return 0;
  fail:
@@ -1632,6 +1689,8 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
 
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
+	enum tracecmd_section_flags flags = 0;
+	tsize_t offset;
 	int ret;
 
 	if (!check_out_state(handle, TRACECMD_FILE_CMD_LINES)) {
@@ -1640,6 +1699,13 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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
 
@@ -1652,6 +1718,9 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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

