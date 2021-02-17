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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9D7C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 04:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 357BA64DF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 04:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhBQE1E (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Feb 2021 23:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbhBQEY2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Feb 2021 23:24:28 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3869DC06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Feb 2021 20:23:46 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z22so14800817edb.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Feb 2021 20:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b2KM8+HJ8l98x1TDAgUN/k9tVnp1khxnJpBIyw0txDE=;
        b=PqLwS3+99/fzBf3PE1J32tUDMTjZqy/qKJdppOvQWXrTIrYN/2E+jVlZ/PbUNnxvkf
         8V5TtrviCJbi87wP7io8L6Q3Q/6tYVIB2KjkNQQ9e/Cz2wN66C/lktXXn87e1ZiYRV7Z
         dyUpxyxTvVQMu/yC9ZWVG9azEZKAw7z29GZ84KyjRi3qAFOkk6djo9A2UeF4+c/d3R42
         WX9rSWRt6m4pS9rWo0W8Hn9+5GlvQ8Sq1snHayVKDWQXlMVA5DbBbAJ7zuDWFSidHKIC
         7bbX000a1Vsonx/gT6xDFeZNIkPpyvrWCGk7k2PwclDLwYN8T2guNrxpAwgfY0dzxA+y
         O/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b2KM8+HJ8l98x1TDAgUN/k9tVnp1khxnJpBIyw0txDE=;
        b=dOkixWqpJEXMksrg1/clCqog7x6KaCJhWHFl+TJgGP561DSaXG+wAQD0+5mFW9dosM
         EDxNeDfOwa4Du4C/OjM6gChmExCW5nIypkVml6u7xUdBrua2bHnUKTFkI0gLn5r+oqyF
         VvHj06lPC9R8CQPpKS/vMntYZybeKd7WFaIXgDqovkmHfi/Gcmr0NPLJTw5nfBktm7d9
         wInhL5apmN0mjimI/E7qHobdU+bErywG7mSUEbRH37OuAWJqXu/73EtxWqDRnaW1ZmTN
         0vdQ0dm8HKtuHlPBYE+EupXutuQC19sfKHntWVFZzBSJMPpdHwpIZN4R3C2NVTchYBLX
         V1Rw==
X-Gm-Message-State: AOAM532KWbga7K0clq6e22y3VIybxWqHa3JmSCJfG5JluSNGWiQfb/p0
        +4V8nzbt4WysNaijrcuc7hs9HNzYgr3rsg==
X-Google-Smtp-Source: ABdhPJyi8ntnXBwxY+GQ7qzQX4iFwUk3nyHDIWBDB/CpR0UtKkgMB3860NcAgiT/vciZwhrPWXOMvQ==
X-Received: by 2002:a05:6402:1151:: with SMTP id g17mr24417302edw.48.1613535824544;
        Tue, 16 Feb 2021 20:23:44 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id cb21sm389698edb.57.2021.02.16.20.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 20:23:44 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Add validation for reading and writing trace.dat files
Date:   Wed, 17 Feb 2021 06:23:40 +0200
Message-Id: <20210217042341.1675546-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210217042341.1675546-1-tz.stoyanov@gmail.com>
References: <20210217042341.1675546-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

trace.dat files have multiple sections, which must be in strict order. A
new logic is implemented, which checks the order of all mandatory
sections when reading and writing trace files. This validation is
useful when the file is constructed in different machines -
host / guest or listener tracing. In those use cases, part of the file
is generated in the client machine and is transferred to the server as
a sequence of bytes. The server should validate the format of the received
portion of the file and the order of the sections in it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  24 ++-
 lib/trace-cmd/trace-input.c                   |  27 ++-
 lib/trace-cmd/trace-output.c                  | 161 +++++++++++++++---
 tracecmd/trace-record.c                       |   2 +-
 tracecmd/trace-split.c                        |   2 +-
 5 files changed, 179 insertions(+), 37 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index eddfd9eb..2e345ef1 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -95,6 +95,21 @@ static inline int tracecmd_host_bigendian(void)
 
 /* --- Opening and Reading the trace.dat file --- */
 
+enum  {
+	TRACECMD_FILE_INIT		= (1 << 0),
+	TRACECMD_FILE_HEADERS		= (1 << 1),
+	TRACECMD_FILE_FTRACE_EVENTS	= (1 << 2),
+	TRACECMD_FILE_ALL_EVENTS	= (1 << 3),
+	TRACECMD_FILE_KALLSYMS		= (1 << 4),
+	TRACECMD_FILE_PRINTK		= (1 << 5),
+	TRACECMD_FILE_CMD_LINES		= (1 << 6),
+	TRACECMD_FILE_CPU_COUNT		= (1 << 7),
+	TRACECMD_FILE_OPTIONS		= (1 << 8),
+	TRACECMD_FILE_CPU_LATENCY	= (1 << 9),
+	TRACECMD_FILE_CPU_FLYRECORD	= (1 << 10),
+};
+#define TRACECMD_FILE_TRACE_DATA (TRACECMD_FILE_CPU_LATENCY | TRACECMD_FILE_CPU_FLYRECORD)
+
 enum {
 	TRACECMD_OPTION_DONE,
 	TRACECMD_OPTION_DATE,
@@ -115,9 +130,7 @@ enum {
 enum {
 	TRACECMD_FL_IGNORE_DATE		= (1 << 0),
 	TRACECMD_FL_BUFFER_INSTANCE	= (1 << 1),
-	TRACECMD_FL_LATENCY		= (1 << 2),
-	TRACECMD_FL_IN_USECS		= (1 << 3),
-	TRACECMD_FL_FLYRECORD		= (1 << 4),
+	TRACECMD_FL_IN_USECS		= (1 << 2),
 };
 
 struct tracecmd_ftrace {
@@ -150,6 +163,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
+unsigned long tracecmd_get_file_state(struct tracecmd_input *handle);
 unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle);
 int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable);
 
@@ -273,6 +287,7 @@ struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handl
 						   const char *name, int cpus);
 
 int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
+int tracecmd_write_cmdlines(struct tracecmd_output *handle);
 int tracecmd_write_options(struct tracecmd_output *handle);
 int tracecmd_append_options(struct tracecmd_output *handle);
 int tracecmd_update_option(struct tracecmd_output *handle,
@@ -500,7 +515,4 @@ void *tracecmd_record_page(struct tracecmd_input *handle,
 void *tracecmd_record_offset(struct tracecmd_input *handle,
 			     struct tep_record *record);
 
-int save_tracing_file_data(struct tracecmd_output *handle,
-			   const char *filename);
-
 #endif /* _TRACE_CMD_PRIVATE_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 76bcb215..c171e93c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -102,6 +102,7 @@ struct host_trace_info {
 
 struct tracecmd_input {
 	struct tep_handle	*pevent;
+	unsigned long		file_state;
 	struct tep_plugin_list	*plugin_list;
 	struct tracecmd_input	*parent;
 	unsigned long		flags;
@@ -161,6 +162,11 @@ unsigned long tracecmd_get_flags(struct tracecmd_input *handle)
 	return handle->flags;
 }
 
+unsigned long tracecmd_get_file_state(struct tracecmd_input *handle)
+{
+	return handle->file_state;
+}
+
 #if DEBUG_RECORD
 static void remove_record(struct page *page, struct tep_record *record)
 {
@@ -782,34 +788,40 @@ int tracecmd_read_headers(struct tracecmd_input *handle)
 	ret = read_header_files(handle);
 	if (ret < 0)
 		return -1;
+	handle->file_state |= TRACECMD_FILE_HEADERS;
+	tep_set_long_size(handle->pevent, handle->long_size);
 
 	ret = read_ftrace_files(handle, NULL);
 	if (ret < 0)
 		return -1;
+	handle->file_state |= TRACECMD_FILE_FTRACE_EVENTS;
 
 	ret = read_event_files(handle, NULL);
 	if (ret < 0)
 		return -1;
+	handle->file_state |= TRACECMD_FILE_ALL_EVENTS;
 
 	ret = read_proc_kallsyms(handle);
 	if (ret < 0)
 		return -1;
+	handle->file_state |= TRACECMD_FILE_KALLSYMS;
 
 	ret = read_ftrace_printk(handle);
 	if (ret < 0)
 		return -1;
+	handle->file_state |= TRACECMD_FILE_PRINTK;
 
 	if (read_and_parse_cmdlines(handle) < 0)
 		return -1;
+	handle->file_state |= TRACECMD_FILE_CMD_LINES;
 
 	if (read_cpus(handle) < 0)
 		return -1;
+	handle->file_state |= TRACECMD_FILE_CPU_COUNT;
 
 	if (read_options_type(handle) < 0)
 		return -1;
 
-	tep_set_long_size(handle->pevent, handle->long_size);
-
 	return 0;
 }
 
@@ -2657,6 +2669,7 @@ static int read_options_type(struct tracecmd_input *handle)
 	if (strncmp(buf, "options", 7) == 0) {
 		if (handle_options(handle) < 0)
 			return -1;
+		handle->file_state |= TRACECMD_FILE_OPTIONS;
 		if (do_read_check(handle, buf, 10))
 			return -1;
 	}
@@ -2665,9 +2678,9 @@ static int read_options_type(struct tracecmd_input *handle)
 	 * Check if this is a latency report or flyrecord.
 	 */
 	if (strncmp(buf, "latency", 7) == 0)
-		handle->flags |= TRACECMD_FL_LATENCY;
+		handle->file_state |= TRACECMD_FILE_CPU_LATENCY;
 	else if (strncmp(buf, "flyrecord", 9) == 0)
-		handle->flags |= TRACECMD_FL_FLYRECORD;
+		handle->file_state |= TRACECMD_FILE_CPU_FLYRECORD;
 	else
 		return -1;
 
@@ -2688,11 +2701,11 @@ static int read_cpu_data(struct tracecmd_input *handle)
 	/*
 	 * Check if this is a latency report or not.
 	 */
-	if (handle->flags & TRACECMD_FL_LATENCY)
+	if (handle->file_state & TRACECMD_FILE_CPU_LATENCY)
 		return 1;
 
 	/* We expect this to be flyrecord */
-	if (!(handle->flags & TRACECMD_FL_FLYRECORD))
+	if (!(handle->file_state & TRACECMD_FILE_CPU_FLYRECORD))
 		return -1;
 
 	cpus = handle->cpus;
@@ -3153,6 +3166,8 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	handle->header_files_start =
 		lseek64(handle->fd, handle->header_files_start, SEEK_SET);
 
+	handle->file_state = TRACECMD_FILE_INIT;
+
 	return handle;
 
  failed_read:
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 588f79a5..8b3e0000 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -54,10 +54,10 @@ struct tracecmd_output {
 	int			cpus;
 	struct tep_handle	*pevent;
 	char			*tracing_dir;
-	int			options_written;
 	int			nr_options;
 	bool			quiet;
-	struct list_head 	options;
+	unsigned long		file_state;
+	struct list_head	options;
 	struct tracecmd_msg_handle *msg_handle;
 };
 
@@ -797,8 +797,8 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	return -1;
 }
 
-int save_tracing_file_data(struct tracecmd_output *handle,
-			   const char *filename)
+static int save_tracing_file_data(struct tracecmd_output *handle,
+				  const char *filename)
 {
 	unsigned long long endian8;
 	char *file = NULL;
@@ -836,6 +836,55 @@ out_free:
 	return ret;
 }
 
+#define FILE_INIT_STATE (TRACECMD_FILE_INIT | TRACECMD_FILE_HEADERS | \
+			 TRACECMD_FILE_FTRACE_EVENTS | TRACECMD_FILE_ALL_EVENTS | \
+			 TRACECMD_FILE_KALLSYMS | TRACECMD_FILE_PRINTK)
+
+static int check_out_state(struct tracecmd_output *handle, int new_state)
+{
+	if (!handle)
+		return -1;
+
+	switch (new_state) {
+	case TRACECMD_FILE_CMD_LINES:
+		if ((handle->file_state & FILE_INIT_STATE) &&
+		    !(handle->file_state & TRACECMD_FILE_CMD_LINES))
+			return 0;
+		break;
+	case TRACECMD_FILE_CPU_COUNT:
+		if ((handle->file_state & FILE_INIT_STATE) &&
+		    (handle->file_state & TRACECMD_FILE_CMD_LINES) &&
+		    !(handle->file_state & TRACECMD_FILE_CPU_COUNT))
+			return 0;
+		break;
+	case TRACECMD_FILE_OPTIONS:
+		if ((handle->file_state & FILE_INIT_STATE) &&
+		    (handle->file_state & TRACECMD_FILE_CMD_LINES) &&
+		    (handle->file_state & TRACECMD_FILE_CPU_COUNT) &&
+		    !(handle->file_state & TRACECMD_FILE_OPTIONS))
+			return 0;
+		break;
+	case TRACECMD_FILE_CPU_LATENCY:
+		if ((handle->file_state & FILE_INIT_STATE) &&
+		    (handle->file_state & TRACECMD_FILE_CMD_LINES) &&
+		    (handle->file_state & TRACECMD_FILE_CPU_COUNT) &&
+		    !(handle->file_state & TRACECMD_FILE_CPU_FLYRECORD) &&
+		    !(handle->file_state & TRACECMD_FILE_CPU_LATENCY))
+			return 0;
+		break;
+	case TRACECMD_FILE_CPU_FLYRECORD:
+		if ((handle->file_state & FILE_INIT_STATE) &&
+		    (handle->file_state & TRACECMD_FILE_CMD_LINES) &&
+		    (handle->file_state & TRACECMD_FILE_CPU_COUNT) &&
+		    !(handle->file_state & TRACECMD_FILE_CPU_LATENCY) &&
+		    !(handle->file_state & TRACECMD_FILE_CPU_FLYRECORD))
+			return 0;
+		break;
+	}
+
+	return -1;
+}
+
 static struct tracecmd_output *
 create_file_fd(int fd, struct tracecmd_input *ihandle,
 	       const char *tracing_dir,
@@ -905,20 +954,30 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	endian4 = convert_endian_4(handle, handle->page_size);
 	if (do_write_check(handle, &endian4, 4))
 		goto out_free;
+	handle->file_state = TRACECMD_FILE_INIT;
 
 	if (ihandle)
 		return handle;
 
 	if (read_header_files(handle))
 		goto out_free;
+	handle->file_state |= TRACECMD_FILE_HEADERS;
+
 	if (read_ftrace_files(handle))
 		goto out_free;
+	handle->file_state |= TRACECMD_FILE_FTRACE_EVENTS;
+
 	if (read_event_files(handle, list))
 		goto out_free;
+	handle->file_state |= TRACECMD_FILE_ALL_EVENTS;
+
 	if (read_proc_kallsyms(handle, kallsyms))
 		goto out_free;
+	handle->file_state |= TRACECMD_FILE_KALLSYMS;
+
 	if (read_ftrace_printk(handle))
 		goto out_free;
+	handle->file_state |= TRACECMD_FILE_PRINTK;
 
 	return handle;
 
@@ -973,10 +1032,10 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 	int i, size = 0;
 
 	/*
-	 * We can only add options before they were written.
+	 * We can only add options before tracing data were written.
 	 * This may change in the future.
 	 */
-	if (handle->options_written)
+	if ((handle->file_state & TRACECMD_FILE_TRACE_DATA))
 		return NULL;
 
 	for (i = 0; i < count; i++)
@@ -1038,8 +1097,20 @@ tracecmd_add_option(struct tracecmd_output *handle,
 
 int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 {
+	int ret;
+
+	ret = check_out_state(handle, TRACECMD_FILE_CPU_COUNT);
+	if (ret < 0) {
+		warning("Cannot write CPU count into the file, unexpected state 0x%X",
+			handle->file_state);
+		return ret;
+	}
 	cpus = convert_endian_4(handle, cpus);
-	return do_write_check(handle, &cpus, 4);
+	ret = do_write_check(handle, &cpus, 4);
+	if (ret < 0)
+		return ret;
+	handle->file_state |= TRACECMD_FILE_CPU_COUNT;
+	return 0;
 }
 
 int tracecmd_write_options(struct tracecmd_output *handle)
@@ -1048,10 +1119,17 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 	unsigned short option;
 	unsigned short endian2;
 	unsigned int endian4;
+	int ret;
 
 	/* If already written, ignore */
-	if (handle->options_written)
+	if (handle->file_state & TRACECMD_FILE_OPTIONS)
 		return 0;
+	ret = check_out_state(handle, TRACECMD_FILE_OPTIONS);
+	if (ret < 0) {
+		warning("Cannot write options into the file, unexpected state 0x%X",
+			handle->file_state);
+		return ret;
+	}
 
 	if (do_write_check(handle, "options  ", 10))
 		return -1;
@@ -1078,7 +1156,7 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 	if (do_write_check(handle, &option, 2))
 		return -1;
 
-	handle->options_written = 1;
+	handle->file_state |= TRACECMD_FILE_OPTIONS;
 
 	return 0;
 }
@@ -1092,9 +1170,12 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 	off_t offset;
 	int r;
 
-	/* If already written, ignore */
-	if (handle->options_written)
-		return 0;
+	/* We can append only if options are already written and tracing data
+	 * is not yet written
+	 */
+	if (!(handle->file_state & TRACECMD_FILE_OPTIONS) ||
+	    (handle->file_state & TRACECMD_FILE_TRACE_DATA))
+		return -1;
 
 	if (lseek64(handle->fd, 0, SEEK_END) == (off_t)-1)
 		return -1;
@@ -1128,8 +1209,6 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 	if (do_write_check(handle, &option, 2))
 		return -1;
 
-	handle->options_written = 1;
-
 	return 0;
 }
 
@@ -1145,7 +1224,7 @@ int tracecmd_update_option(struct tracecmd_output *handle,
 		return -1;
 	}
 
-	if (!handle->options_written) {
+	if (!(handle->file_state & TRACECMD_FILE_OPTIONS)) {
 		/* Hasn't been written yet. Just update current pointer */
 		option->size = size;
 		memcpy(option->data, data, size);
@@ -1203,10 +1282,28 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
 	return option;
 }
 
+int tracecmd_write_cmdlines(struct tracecmd_output *handle)
+{
+	int ret;
+
+	ret = check_out_state(handle, TRACECMD_FILE_CMD_LINES);
+	if (ret < 0) {
+		warning("Cannot write command lines into the file, unexpected state 0x%X",
+			handle->file_state);
+		return ret;
+	}
+	ret = save_tracing_file_data(handle, "saved_cmdlines");
+	if (ret < 0)
+		return ret;
+	handle->file_state |= TRACECMD_FILE_CMD_LINES;
+	return 0;
+}
+
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
 {
 	struct tracecmd_output *handle;
 	char *path;
+	int ret;
 
 	handle = create_file(output_file, NULL, NULL, NULL, &all_event_list);
 	if (!handle)
@@ -1215,7 +1312,7 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	/*
 	 * Save the command lines;
 	 */
-	if (save_tracing_file_data(handle, "saved_cmdlines") < 0)
+	if (tracecmd_write_cmdlines(handle) < 0)
 		goto out_free;
 
 	if (tracecmd_write_cpus(handle, cpus) < 0)
@@ -1224,6 +1321,13 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
+	ret = check_out_state(handle, TRACECMD_FILE_CPU_LATENCY);
+	if (ret < 0) {
+		warning("Cannot write latency data into the file, unexpected state 0x%X",
+			handle->file_state);
+		goto out_free;
+	}
+
 	if (do_write_check(handle, "latency  ", 10))
 		goto out_free;
 
@@ -1235,6 +1339,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	put_tracing_file(path);
 
+	handle->file_state |= TRACECMD_FILE_CPU_LATENCY;
+
 	return handle;
 
 out_free:
@@ -1255,6 +1361,13 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 	int ret;
 	int i;
 
+	ret = check_out_state(handle, TRACECMD_FILE_CPU_FLYRECORD);
+	if (ret < 0) {
+		warning("Cannot write trace data into the file, unexpected state 0x%X",
+			handle->file_state);
+		goto out_free;
+	}
+
 	if (do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
@@ -1340,6 +1453,8 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 	free(offsets);
 	free(sizes);
 
+	handle->file_state |= TRACECMD_FILE_CPU_FLYRECORD;
+
 	return 0;
 
  out_free:
@@ -1356,7 +1471,7 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 	/*
 	 * Save the command lines;
 	 */
-	ret = save_tracing_file_data(handle, "saved_cmdlines");
+	ret = tracecmd_write_cmdlines(handle);
 	if (ret)
 		return ret;
 
@@ -1404,7 +1519,6 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 {
 	struct tracecmd_output *handle = NULL;
 	struct tracecmd_input *ihandle;
-	struct tep_handle *pevent;
 	int fd2;
 
 	/* Move the file descriptor to the beginning */
@@ -1417,9 +1531,10 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 		return NULL;
 
 	/* get a input handle from this */
-	ihandle = tracecmd_alloc_fd(fd2, 0);
+	ihandle = tracecmd_alloc_fd(fd2, TRACECMD_FL_LOAD_NO_PLUGINS);
 	if (!ihandle)
 		return NULL;
+	tracecmd_read_headers(ihandle);
 
 	/* move the file descriptor to the end */
 	if (lseek(fd, 0, SEEK_END) == (off_t)-1)
@@ -1432,11 +1547,11 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 
 	handle->fd = fd;
 
-	/* get endian and page size */
-	pevent = tracecmd_get_tep(ihandle);
-	/* Use the pevent of the ihandle for later writes */
+	/* get tep, state, endian and page size */
+	handle->file_state = tracecmd_get_file_state(ihandle);
+	/* Use the tep of the ihandle for later writes */
 	handle->pevent = tracecmd_get_tep(ihandle);
-	tep_ref(pevent);
+	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
 	list_head_init(&handle->options);
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index efd96d27..9396042d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3770,7 +3770,7 @@ static void setup_agent(struct buffer_instance *instance,
 	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
 						     listed_events);
 	add_options(network_handle, ctx);
-	save_tracing_file_data(network_handle, "saved_cmdlines");
+	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
 	tracecmd_write_options(network_handle);
 	tracecmd_msg_finish_sending_data(instance->msg_handle);
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index c707a5d5..a54dcbb4 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -510,7 +510,7 @@ void trace_split (int argc, char **argv)
 	if (!handle)
 		die("error reading %s", input_file);
 
-	if (tracecmd_get_flags(handle) & TRACECMD_FL_LATENCY)
+	if (tracecmd_get_file_state(handle) & TRACECMD_FILE_CPU_LATENCY)
 		die("trace-cmd split does not work with latency traces\n");
 
 	page_size = tracecmd_page_size(handle);
-- 
2.29.2

