Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E653C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhLBMax (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbhLBMaw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:30:52 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7621CC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:27:30 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id t5so115475596edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tLF41MwcakWVLPdcI4/RUpaIjLs0D7fZ8WxfEM9lAsA=;
        b=Us+CV4js3paLo2zciHWCI2Q5LmABLnLa/BnLiZgub2O0WSWxizfO9WWiTCgRXR7qoh
         OQJLTmWx1V7F9+1RxDVaXjEPkijN+CPmaQtDjoFKKHTdM7oqEDs0Q3OljbB+eU6LpVY2
         5Nazh3//GMxu9xLuMu5KQsILiRozjBAgGel4b9LOOA//Q1z9Xj3uXONVid+YpA3EwlYi
         C4fy8yAPJax2P0DRMYL7HVHlGwxuDccVOOeiIri5YfoC2UbSDx5VoUEyFtAAtHT/gw6h
         K0oEmKipGKgQLlmcqxZvMHY4JdrR8pXxm3gZpXCkKBuJ3fniMNNiDbC6ODHc8jSWpSkz
         +8bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tLF41MwcakWVLPdcI4/RUpaIjLs0D7fZ8WxfEM9lAsA=;
        b=Bz2GQKds3RFFJmIgF2aJ58hIDhuWo7USAHGkV1sgNBha1A+uzXBvrTM5J3uvMiqoUA
         Qy7TFkKc0xvRfygfNLnZUOCcd/TkwgQfZtWxU7312MbsNRpZrAIgP/XaTzsSYAJgb3m0
         KhFwz+LP9v9WHw8niAUeyfaeMIzE23MIoRS8h4qhOIUgS1w8Ku/fZpu7CDlLkWDHA7Fa
         AiiQ8/lMQpZNNv8oliBgCvlxwSyTLEuxtJ2Q6mLHQ9cEFt56PxQjKcmxId4xVww+asSw
         9Q87JJcHBikrm2OYzXxvfXZqeYYNoTkbNwW06FKQHdkYzvmjW38wAXJj8Q3nBWWd051f
         yOQg==
X-Gm-Message-State: AOAM5307GttglEN0fJ4vMYVWOeH4oGaSyjz5RWU5y/anfzP0qoHkNpkd
        t4pAmQNpUIbjZfu7yG0yImm9XtztVjeV9w==
X-Google-Smtp-Source: ABdhPJzwOm1mDw5jDmByWPn+kDSgRusmvUW4mlIADna9x4US+n8y4jufzUZaw1CKdf9O145mMqiYoQ==
X-Received: by 2002:a17:907:7244:: with SMTP id ds4mr15595707ejc.55.1638448049009;
        Thu, 02 Dec 2021 04:27:29 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u16sm2073403edr.43.2021.12.02.04.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:27:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 1/8] trace-cmd library: Use output handler when copying data from input file
Date:   Thu,  2 Dec 2021 14:27:19 +0200
Message-Id: <20211202122726.43775-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122726.43775-1-tz.stoyanov@gmail.com>
References: <20211202122726.43775-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When copying data between two trace files, use input and output
handlers, instead of raw file descriptors. Handlers take care of
file version and compression context.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |   3 +-
 lib/trace-cmd/include/trace-cmd-local.h       |   2 +
 lib/trace-cmd/trace-input.c                   | 145 +++++++++---------
 lib/trace-cmd/trace-output.c                  |   6 +-
 4 files changed, 82 insertions(+), 74 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 6cc6ce46..9e2cfcdb 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -185,7 +185,8 @@ int tracecmd_get_parsing_failures(struct tracecmd_input *handle);
 int tracecmd_long_size(struct tracecmd_input *handle);
 int tracecmd_page_size(struct tracecmd_input *handle);
 int tracecmd_cpus(struct tracecmd_input *handle);
-int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
+int tracecmd_copy_headers(struct tracecmd_input *in_handle,
+			  struct tracecmd_output *out_handle,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 5f3f1056..b4ed3225 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -61,6 +61,8 @@ out_write_section_header(struct tracecmd_output *handle, unsigned short header_i
 			 char *description, int flags, bool option);
 int out_update_section_header(struct tracecmd_output *handle, unsigned long long offset);
 
+long long do_write_check(struct tracecmd_output *handle, const void *data, long long size);
+
 struct cpu_data_source {
 	int fd;
 	int size;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 69c7c55d..d47d7a94 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4380,44 +4380,47 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle);
 }
 
-static int read_copy_size8(struct tracecmd_input *handle, int fd, unsigned long long *size)
+static int read_copy_size8(struct tracecmd_input *in_handle,
+			   struct tracecmd_output *out_handle, unsigned long long *size)
 {
 	/* read size */
-	if (do_read_check(handle, size, 8))
+	if (do_read_check(in_handle, size, 8))
 		return -1;
 
-	if (__do_write_check(fd, size, 8))
+	if (do_write_check(out_handle, size, 8))
 		return -1;
 
-	*size = tep_read_number(handle->pevent, size, 8);
+	*size = tep_read_number(in_handle->pevent, size, 8);
 	return 0;
 }
 
-static int read_copy_size4(struct tracecmd_input *handle, int fd, unsigned int *size)
+static int read_copy_size4(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle,
+			   unsigned int *size)
 {
 	/* read size */
-	if (do_read_check(handle, size, 4))
+	if (do_read_check(in_handle, size, 4))
 		return -1;
 
-	if (__do_write_check(fd, size, 4))
+	if (do_write_check(out_handle, size, 4))
 		return -1;
 
-	*size = tep_read_number(handle->pevent, size, 4);
+	*size = tep_read_number(in_handle->pevent, size, 4);
 	return 0;
 }
 
-static int read_copy_data(struct tracecmd_input *handle,
-			  unsigned long long size, int fd)
+static int read_copy_data(struct tracecmd_input *in_handle,
+			  unsigned long long size,
+			  struct tracecmd_output *out_handle)
 {
 	char *buf;
 
 	buf = malloc(size);
 	if (!buf)
 		return -1;
-	if (do_read_check(handle, buf, size))
+	if (do_read_check(in_handle, buf, size))
 		goto failed_read;
 
-	if (__do_write_check(fd, buf, size))
+	if (do_write_check(out_handle, buf, size))
 		goto failed_read;
 	
 	free(buf);
@@ -4429,65 +4432,66 @@ static int read_copy_data(struct tracecmd_input *handle,
 	return -1;
 }
 
-static int copy_header_files(struct tracecmd_input *handle, int fd)
+static int copy_header_files(struct tracecmd_input *in_handle,
+			     struct tracecmd_output *out_handle)
 {
 	unsigned long long size;
 
-	if (handle->file_state != TRACECMD_FILE_HEADERS - 1)
+	if (in_handle->file_state != TRACECMD_FILE_HEADERS - 1)
 		return -1;
 
 	/* "header_page"  */
-	if (read_copy_data(handle, 12, fd) < 0)
+	if (read_copy_data(in_handle, 12, out_handle) < 0)
 		return -1;
 
-	if (read_copy_size8(handle, fd, &size) < 0)
+	if (read_copy_size8(in_handle, out_handle, &size) < 0)
 		return -1;
 
-	if (read_copy_data(handle, size, fd) < 0)
+	if (read_copy_data(in_handle, size, out_handle) < 0)
 		return -1;
 
 	/* "header_event"  */
-	if (read_copy_data(handle, 13, fd) < 0)
+	if (read_copy_data(in_handle, 13, out_handle) < 0)
 		return -1;
 
-	if (read_copy_size8(handle, fd, &size) < 0)
+	if (read_copy_size8(in_handle, out_handle, &size) < 0)
 		return -1;
 
-	if (read_copy_data(handle, size, fd) < 0)
+	if (read_copy_data(in_handle, size, out_handle) < 0)
 		return -1;
 
-	handle->file_state = TRACECMD_FILE_HEADERS;
+	in_handle->file_state = TRACECMD_FILE_HEADERS;
 
 	return 0;
 }
 
-static int copy_ftrace_files(struct tracecmd_input *handle, int fd)
+static int copy_ftrace_files(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
 	unsigned long long size;
 	unsigned int count;
 	unsigned int i;
 
-	if (handle->file_state != TRACECMD_FILE_FTRACE_EVENTS - 1)
+	if (in_handle->file_state != TRACECMD_FILE_FTRACE_EVENTS - 1)
 		return -1;
 
-	if (read_copy_size4(handle, fd, &count) < 0)
+	if (read_copy_size4(in_handle, out_handle, &count) < 0)
 		return -1;
 
 	for (i = 0; i < count; i++) {
 
-		if (read_copy_size8(handle, fd, &size) < 0)
+		if (read_copy_size8(in_handle, out_handle, &size) < 0)
 			return -1;
 
-		if (read_copy_data(handle, size, fd) < 0)
+		if (read_copy_data(in_handle, size, out_handle) < 0)
 			return -1;
 	}
 
-	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
+	in_handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
 
 	return 0;
 }
 
-static int copy_event_files(struct tracecmd_input *handle, int fd)
+static int copy_event_files(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
 	unsigned long long size;
 	char *system;
@@ -4495,103 +4499,103 @@ static int copy_event_files(struct tracecmd_input *handle, int fd)
 	unsigned int count;
 	unsigned int i,x;
 
-	if (handle->file_state != TRACECMD_FILE_ALL_EVENTS - 1)
+	if (in_handle->file_state != TRACECMD_FILE_ALL_EVENTS - 1)
 		return -1;
 
-	if (read_copy_size4(handle, fd, &systems) < 0)
+	if (read_copy_size4(in_handle, out_handle, &systems) < 0)
 		return -1;
 
 	for (i = 0; i < systems; i++) {
-		system = read_string(handle);
+		system = read_string(in_handle);
 		if (!system)
 			return -1;
-		if (__do_write_check(fd, system, strlen(system) + 1)) {
+		if (do_write_check(out_handle, system, strlen(system) + 1)) {
 			free(system);
 			return -1;
 		}
 		free(system);
 
-		if (read_copy_size4(handle, fd, &count) < 0)
+		if (read_copy_size4(in_handle, out_handle, &count) < 0)
 			return -1;
 
 		for (x=0; x < count; x++) {
-			if (read_copy_size8(handle, fd, &size) < 0)
+			if (read_copy_size8(in_handle, out_handle, &size) < 0)
 				return -1;
 
-			if (read_copy_data(handle, size, fd) < 0)
+			if (read_copy_data(in_handle, size, out_handle) < 0)
 				return -1;
 		}
 	}
 
-	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+	in_handle->file_state = TRACECMD_FILE_ALL_EVENTS;
 
 	return 0;
 }
 
-static int copy_proc_kallsyms(struct tracecmd_input *handle, int fd)
+static int copy_proc_kallsyms(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
 	unsigned int size;
 
-	if (handle->file_state != TRACECMD_FILE_KALLSYMS - 1)
+	if (in_handle->file_state != TRACECMD_FILE_KALLSYMS - 1)
 		return -1;
 
-	if (read_copy_size4(handle, fd, &size) < 0)
+	if (read_copy_size4(in_handle, out_handle, &size) < 0)
 		return -1;
 	if (!size)
 		return 0; /* OK? */
 
-	if (read_copy_data(handle, size, fd) < 0)
+	if (read_copy_data(in_handle, size, out_handle) < 0)
 		return -1;
 
-	handle->file_state = TRACECMD_FILE_KALLSYMS;
+	in_handle->file_state = TRACECMD_FILE_KALLSYMS;
 
 	return 0;
 }
 
-static int copy_ftrace_printk(struct tracecmd_input *handle, int fd)
+static int copy_ftrace_printk(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
 	unsigned int size;
 
-	if (handle->file_state != TRACECMD_FILE_PRINTK - 1)
+	if (in_handle->file_state != TRACECMD_FILE_PRINTK - 1)
 		return -1;
 
-	if (read_copy_size4(handle, fd, &size) < 0)
+	if (read_copy_size4(in_handle, out_handle, &size) < 0)
 		return -1;
 	if (!size)
 		return 0; /* OK? */
 
-	if (read_copy_data(handle, size, fd) < 0)
+	if (read_copy_data(in_handle, size, out_handle) < 0)
 		return -1;
 
-	handle->file_state = TRACECMD_FILE_PRINTK;
+	in_handle->file_state = TRACECMD_FILE_PRINTK;
 
 	return 0;
 }
 
-static int copy_command_lines(struct tracecmd_input *handle, int fd)
+static int copy_command_lines(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
 	unsigned long long size;
 
-	if (handle->file_state != TRACECMD_FILE_CMD_LINES - 1)
+	if (in_handle->file_state != TRACECMD_FILE_CMD_LINES - 1)
 		return -1;
 
-	if (read_copy_size8(handle, fd, &size) < 0)
+	if (read_copy_size8(in_handle, out_handle, &size) < 0)
 		return -1;
 	if (!size)
 		return 0; /* OK? */
 
-	if (read_copy_data(handle, size, fd) < 0)
+	if (read_copy_data(in_handle, size, out_handle) < 0)
 		return -1;
 
-	handle->file_state = TRACECMD_FILE_CMD_LINES;
+	in_handle->file_state = TRACECMD_FILE_CMD_LINES;
 
 	return 0;
 }
 
 /**
  * tracecmd_copy_headers - Copy headers from a tracecmd_input handle to a file descriptor
- * @handle: input handle for the trace.dat file to copy from.
- * @fd: The file descriptor to copy to.
+ * @in_handle: input handle for the trace.dat file to copy from.
+ * @out_handle: output handle to the trace.dat file to copy to.
  * @start_state: The file state to start copying from (zero for the beginnig)
  * @end_state: The file state to stop at (zero for up to cmdlines)
  *
@@ -4602,7 +4606,8 @@ static int copy_command_lines(struct tracecmd_input *handle, int fd)
  * NOTE: The input handle is also modified, and ends at the end
  *       state as well.
  */
-int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
+int tracecmd_copy_headers(struct tracecmd_input *in_handle,
+			  struct tracecmd_output *out_handle,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state)
 {
@@ -4620,71 +4625,71 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 	if (end_state < TRACECMD_FILE_HEADERS)
 		return 0;
 
-	if (handle->file_state >= start_state) {
+	if (in_handle->file_state >= start_state) {
 		/* Set the handle to just before the start state */
-		sec = section_open(handle, TRACECMD_OPTION_HEADER_INFO);
+		sec = section_open(in_handle, TRACECMD_OPTION_HEADER_INFO);
 		if (!sec)
 			return -1;
 		/* Now that the file handle has moved, change its state */
-		handle->file_state = TRACECMD_FILE_INIT;
+		in_handle->file_state = TRACECMD_FILE_INIT;
 	}
 
 	/* Try to bring the input up to the start state - 1 */
-	ret = tracecmd_read_headers(handle, start_state - 1);
+	ret = tracecmd_read_headers(in_handle, start_state - 1);
 	if (sec)
-		section_close(handle, sec);
+		section_close(in_handle, sec);
 	if (ret < 0)
 		goto out;
 
 	switch (start_state) {
 	case TRACECMD_FILE_HEADERS:
-		ret = copy_header_files(handle, fd);
+		ret = copy_header_files(in_handle, out_handle);
 		if (ret < 0)
 			goto out;
 
 		/* fallthrough */
 	case TRACECMD_FILE_FTRACE_EVENTS:
 		/* handle's state is now updating with the copies */
-		if (end_state <= handle->file_state)
+		if (end_state <= in_handle->file_state)
 			return 0;
 
-		ret = copy_ftrace_files(handle, fd);
+		ret = copy_ftrace_files(in_handle, out_handle);
 		if (ret < 0)
 			goto out;
 
 		/* fallthrough */
 	case TRACECMD_FILE_ALL_EVENTS:
-		if (end_state <= handle->file_state)
+		if (end_state <= in_handle->file_state)
 			return 0;
 
-		ret = copy_event_files(handle, fd);
+		ret = copy_event_files(in_handle, out_handle);
 		if (ret < 0)
 			goto out;
 
 		/* fallthrough */
 	case TRACECMD_FILE_KALLSYMS:
-		if (end_state <= handle->file_state)
+		if (end_state <= in_handle->file_state)
 			return 0;
 
-		ret = copy_proc_kallsyms(handle, fd);
+		ret = copy_proc_kallsyms(in_handle, out_handle);
 		if (ret < 0)
 			goto out;
 
 		/* fallthrough */
 	case TRACECMD_FILE_PRINTK:
-		if (end_state <= handle->file_state)
+		if (end_state <= in_handle->file_state)
 			return 0;
 
-		ret = copy_ftrace_printk(handle, fd);
+		ret = copy_ftrace_printk(in_handle, out_handle);
 		if (ret < 0)
 			goto out;
 
 		/* fallthrough */
 	case TRACECMD_FILE_CMD_LINES:
-		if (end_state <= handle->file_state)
+		if (end_state <= in_handle->file_state)
 			return 0;
 
-		ret = copy_command_lines(handle, fd);
+		ret = copy_command_lines(in_handle, out_handle);
 	default:
 		break;
 	}
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index bd838d1d..8063e249 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -89,8 +89,8 @@ struct list_event_system {
 
 static int write_options_v7(struct tracecmd_output *handle);
 
-static stsize_t
-do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
+__hidden long long
+do_write_check(struct tracecmd_output *handle, const void *data, long long size)
 {
 	if (handle->do_compress)
 		return tracecmd_compress_write(handle->compress, data, size);
@@ -2492,7 +2492,7 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 		goto out_free;
 	output_write_init(handle);
 
-	if (tracecmd_copy_headers(ihandle, handle->fd, 0, 0) < 0)
+	if (tracecmd_copy_headers(ihandle, handle, 0, 0) < 0)
 		goto out_free;
 
 	handle->file_state = tracecmd_get_file_state(ihandle);
-- 
2.33.1

