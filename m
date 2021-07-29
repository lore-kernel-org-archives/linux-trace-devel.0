Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A221EC432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CCB160C3F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbhG2FLS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbhG2FLS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:18 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55754C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:14 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id go31so8448604ejc.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BVvrX+9S7ES5E7ACKYpe31zxENBOyA7V53b6GnC/v8o=;
        b=WbZ51H5/KW4GCmG8eH2G/hxVciY5JJYMuUWxxTguntLeB4YoWyvesY/u2KtMP2Uejp
         jkBxHTW5jy/MxfkXRchZHplMoDih5Quk9zra3cKGJtiTq393EuIpZDpygKtdwbnlIQ8T
         f1da5QU5nBAaxf+Xk77r0yMIiIIcZYdn6YK2IJ1b/DF8ozcDGn84qdkHe+imFFfo5sL8
         nqr0IJhhdKu/7K04TXSbtHa+lu/gowBSaxwgYnrCVGU1gS6SkyNwMztxES6Mu0l6FKzA
         PjiWmB0PdPu6e8V20DjXRnj9JzwCHzXDciBzgmAr60GbPlITVLp3yY60xm+/JmZh+TE6
         izPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BVvrX+9S7ES5E7ACKYpe31zxENBOyA7V53b6GnC/v8o=;
        b=fm91VE7k4om2pQKLVd1d3XsR9Jh8f2PvCPJ6CXEdoLFpj7b2JivEPtiMWchG23/KHK
         Rx25szNEEyEhPMxJz3PtjaAQ4BbfUBLLpmo9qUP2AAMVr7H16t/UyYDVMPz3Ro/ShJXs
         5w/uQRpSZAkB38kMMyuyhC2t+Ldi41HSPz/BZGE55s9GbN7Ctr3tDIb8bl0d4b1Mwozb
         GdZeX00nstTFDPIVlQ5NAkxc5xLaoHnlD9lCgeiL6SS6UVNrPkJ24ZaDsTJ30ODLRGps
         oyPWY12p9b9blW3YxodpsMwt0UFcSoFqNoGGkCAGvUIQMDYLSWoDYnJwUyB1BtEcJhAy
         mylA==
X-Gm-Message-State: AOAM532pCFmPqKX9Jf/UDiuYGVqyTtbUiARw/1/RrUs4GW+EjvgQph8j
        2af1D3PZlINhri8Y6x8lFbh+lNvEU6AnLg==
X-Google-Smtp-Source: ABdhPJxVKZM689jCxCH06o8GezJtmegJ65Ho33ygztfzYDH39anQJwgGPQNFHlnJ3JizKsPKBPrZYA==
X-Received: by 2002:a17:907:9604:: with SMTP id gb4mr2928927ejc.142.1627535472874;
        Wed, 28 Jul 2021 22:11:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 74/87] trace-cmd library: Use output handler when copying data from input file
Date:   Thu, 29 Jul 2021 08:09:46 +0300
Message-Id: <20210729050959.12263-75-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c                   | 145 +++++++++---------
 lib/trace-cmd/trace-output.c                  |   2 +-
 3 files changed, 78 insertions(+), 72 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 0a3e12cf..05a2ea01 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -179,7 +179,8 @@ int tracecmd_get_parsing_failures(struct tracecmd_input *handle);
 int tracecmd_long_size(struct tracecmd_input *handle);
 int tracecmd_page_size(struct tracecmd_input *handle);
 int tracecmd_cpus(struct tracecmd_input *handle);
-int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
+int tracecmd_copy_headers(struct tracecmd_input *in_handle,
+			  struct tracecmd_output *out_handle,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2b98e6d8..2d2750ad 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4357,44 +4357,47 @@ void tracecmd_close(struct tracecmd_input *handle)
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
@@ -4406,65 +4409,66 @@ static int read_copy_data(struct tracecmd_input *handle,
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
@@ -4472,103 +4476,103 @@ static int copy_event_files(struct tracecmd_input *handle, int fd)
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
+	if (!check_out_state(out_handle, TRACECMD_FILE_CMD_LINES))
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
@@ -4579,7 +4583,8 @@ static int copy_command_lines(struct tracecmd_input *handle, int fd)
  * NOTE: The input handle is also modified, and ends at the end
  *       state as well.
  */
-int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
+int tracecmd_copy_headers(struct tracecmd_input *in_handle,
+			  struct tracecmd_output *out_handle,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state)
 {
@@ -4597,71 +4602,71 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 	if (end_state < TRACECMD_FILE_HEADERS)
 		return 0;
 
-	if (handle->file_state >= start_state) {
+	if (in_handle->file_state >= start_state) {
 		/* Set the handle to just before the start state */
-		sec = open_section(handle, TRACECMD_OPTION_HEADER_INFO);
+		sec = open_section(in_handle, TRACECMD_OPTION_HEADER_INFO);
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
-		close_section(handle, sec);
+		close_section(in_handle, sec);
 
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
index 01c1a4f5..8499ab6f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2494,7 +2494,7 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 	if (tracecmd_output_set_from_input(handle, ihandle))
 		goto out_free;
 	tracecmd_output_write_init(handle);
-	if (tracecmd_copy_headers(ihandle, handle->fd, 0, 0) < 0)
+	if (tracecmd_copy_headers(ihandle, handle, 0, 0) < 0)
 		goto out_free;
 
 	handle->file_state = tracecmd_get_file_state(ihandle);
-- 
2.31.1

