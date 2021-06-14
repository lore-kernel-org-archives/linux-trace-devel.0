Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6D1C49360
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A766361289
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbhFNHxE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbhFNHxD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:03 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30487C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:01 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id he7so14874170ejc.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kWTWcXZIvFdwVZ5sOQ6RY01OSTOmcKvJZe3e+kAuak8=;
        b=U82HDavWikp6E4VKnMH1n471OwlzKeqeKWWYzEgwcvI7ZuL4u8+NiNT/hnSWvXB897
         BiHF5FVxNM0FfuX24bA7Wzv1DNxLdgv2F1AwCdmraNBr5X2L375Vi28HrEQvkc8IvvXu
         n9hStiAUgKt/DTgV929DefMbe9OjQtK2bCnkD1g4bOGvj6pdme60SjGVwGryK1cwka6m
         Kkkpe1lG5Nc2sphidgNzIzM8HbYTzOJWXhG/UTvU8/GdHl6ZqYuxM0OK5O+y3y27N/p1
         YosWuvsFvPZ5wjxgai7PuVKv1/gauV2vXUzXTHCck+16UPUz3E1BW+I4loOxs3JxUtjw
         JXdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kWTWcXZIvFdwVZ5sOQ6RY01OSTOmcKvJZe3e+kAuak8=;
        b=LXUXXcWPEPBVcZkAIz1bVjm3Pn3xZ0Dje2AB2M3ZBZfhlQhsPDYjKrnoSKXsBn1+nR
         o1S67GoewWdM7OTM+qtT57Wo2SpMvVG+MWsfuxVuHnDfSb4XUJyOEkpUP4jb27eDB2oK
         XIL/QAcr/gFh9kk7iRTAD8L6++wEkn6wrPLouL7CTVBwGDO9GrD/WQvkbItlASje/+vq
         HwHcJr0EzF1nxMY7m7agn0r9g6HaPI1nYly0F2gopAPq83g92mgod92aPAuHQkmB8Gy/
         pYM5NBAVvC/omRUzIksGw7XLvV49nuTxyA4UNAVv67kzGk6k+Q4iPpYjl9P3VRu5Hbpu
         vLRw==
X-Gm-Message-State: AOAM532mZOJexHgv1rbPDnZRm2Gw5oNnK4NgNgqGDUhH+BxSFFIZmmBO
        0Sgv5UAhXJbs6djm4FgsKBaJkDOzn1Dflw==
X-Google-Smtp-Source: ABdhPJzkzm1dWbKZ+uVj5+Vv5z5FJr+ofLc7h44jb2zUYoMoeqsBjiH+h9Cth24h8C+QcJkvFlVSDQ==
X-Received: by 2002:a17:906:fa93:: with SMTP id lt19mr14520891ejb.54.1623657059724;
        Mon, 14 Jun 2021 00:50:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 29/45] trace-cmd library: Make tracecmd_copy_headers() to work with output handler
Date:   Mon, 14 Jun 2021 10:50:13 +0300
Message-Id: <20210614075029.598048-30-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When copying headers between two trace files, use output handler context
instead of just a fd. Using output handler will allow to use file
compression, if needed.
This change fixes "trace-cmd split" command to work with trace files v7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |   3 +-
 lib/trace-cmd/include/trace-cmd-local.h       |   4 +
 lib/trace-cmd/trace-input.c                   | 244 ++++++++++++------
 lib/trace-cmd/trace-output.c                  |  13 +-
 4 files changed, 174 insertions(+), 90 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 4a3eb1bc..65e80cec 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -170,7 +170,8 @@ int tracecmd_get_parsing_failures(struct tracecmd_input *handle);
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
index d44b58a9..8fb391fc 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -51,7 +51,11 @@ void out_compression_reset(struct tracecmd_output *handle);
 void in_uncompress_reset(struct tracecmd_input *handle);
 int in_uncompress_block(struct tracecmd_input *handle);
 
+void out_set_file_state(struct tracecmd_output *handle, int new_state);
+
 int write_buffers_description_v7(struct tracecmd_output *handle);
 int write_buffers_description_v6(struct tracecmd_output *handle);
 
+long long do_write_check(struct tracecmd_output *handle, const void *data, long long size);
+
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index d3c5ad18..74d1ebf7 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3759,44 +3759,47 @@ void tracecmd_close(struct tracecmd_input *handle)
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
@@ -3808,65 +3811,82 @@ static int read_copy_data(struct tracecmd_input *handle,
 	return -1;
 }
 
-static int copy_header_files(struct tracecmd_input *handle, int fd)
+static int copy_header_files(struct tracecmd_input *in_handle,
+			     struct tracecmd_output *out_handle)
 {
 	unsigned long long size;
 
-	if (handle->file_state != TRACECMD_FILE_HEADERS - 1)
+	if (!check_in_state(in_handle, TRACECMD_FILE_HEADERS) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_HEADERS))
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
+	out_set_file_state(out_handle, in_handle->file_state);
 
 	return 0;
 }
 
-static int copy_ftrace_files(struct tracecmd_input *handle, int fd)
+static int copy_ftrace_files(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
 	unsigned long long size;
 	unsigned int count;
 	unsigned int i;
 
-	if (handle->file_state != TRACECMD_FILE_FTRACE_EVENTS - 1)
+	if (!check_in_state(in_handle, TRACECMD_FILE_FTRACE_EVENTS) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_FTRACE_EVENTS))
 		return -1;
 
-	if (read_copy_size4(handle, fd, &count) < 0)
+	if (in_uncompress_block(in_handle))
 		return -1;
+	out_compression_start(out_handle);
+
+	if (read_copy_size4(in_handle, out_handle, &count) < 0)
+		goto error;
 
 	for (i = 0; i < count; i++) {
 
-		if (read_copy_size8(handle, fd, &size) < 0)
-			return -1;
+		if (read_copy_size8(in_handle, out_handle, &size) < 0)
+			goto error;
 
-		if (read_copy_data(handle, size, fd) < 0)
-			return -1;
+		if (read_copy_data(in_handle, size, out_handle) < 0)
+			goto error;
 	}
 
-	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
+	in_uncompress_reset(in_handle);
+	in_handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
+
+	if (out_compression_end(out_handle))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
 
 	return 0;
+error:
+	out_compression_reset(out_handle);
+	in_uncompress_reset(in_handle);
+	return -1;
 }
 
-static int copy_event_files(struct tracecmd_input *handle, int fd)
+static int copy_event_files(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
 	unsigned long long size;
 	char *system;
@@ -3874,103 +3894,159 @@ static int copy_event_files(struct tracecmd_input *handle, int fd)
 	unsigned int count;
 	unsigned int i,x;
 
-	if (handle->file_state != TRACECMD_FILE_ALL_EVENTS - 1)
+	if (!check_in_state(in_handle, TRACECMD_FILE_ALL_EVENTS) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_ALL_EVENTS))
 		return -1;
 
-	if (read_copy_size4(handle, fd, &systems) < 0)
+	if (in_uncompress_block(in_handle))
 		return -1;
+	out_compression_start(out_handle);
+
+	if (read_copy_size4(in_handle, out_handle, &systems) < 0)
+		goto error;
 
 	for (i = 0; i < systems; i++) {
-		system = read_string(handle);
+		system = read_string(in_handle);
 		if (!system)
-			return -1;
-		if (__do_write_check(fd, system, strlen(system) + 1)) {
+			goto error;
+		if (do_write_check(out_handle, system, strlen(system) + 1)) {
 			free(system);
-			return -1;
+			goto error;
 		}
 		free(system);
 
-		if (read_copy_size4(handle, fd, &count) < 0)
-			return -1;
+		if (read_copy_size4(in_handle, out_handle, &count) < 0)
+			goto error;
 
 		for (x=0; x < count; x++) {
-			if (read_copy_size8(handle, fd, &size) < 0)
-				return -1;
+			if (read_copy_size8(in_handle, out_handle, &size) < 0)
+				goto error;
 
-			if (read_copy_data(handle, size, fd) < 0)
-				return -1;
+			if (read_copy_data(in_handle, size, out_handle) < 0)
+				goto error;
 		}
 	}
 
-	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+	in_uncompress_reset(in_handle);
+	in_handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+
+	if (out_compression_end(out_handle))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
 
 	return 0;
+error:
+	out_compression_reset(out_handle);
+	in_uncompress_reset(in_handle);
+	return -1;
 }
 
-static int copy_proc_kallsyms(struct tracecmd_input *handle, int fd)
+static int copy_proc_kallsyms(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
 	unsigned int size;
 
-	if (handle->file_state != TRACECMD_FILE_KALLSYMS - 1)
+	if (!check_in_state(in_handle, TRACECMD_FILE_KALLSYMS) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_KALLSYMS))
 		return -1;
 
-	if (read_copy_size4(handle, fd, &size) < 0)
+	if (in_uncompress_block(in_handle))
 		return -1;
+	out_compression_start(out_handle);
+
+	if (read_copy_size4(in_handle, out_handle, &size) < 0)
+		goto error;
 	if (!size)
-		return 0; /* OK? */
+		goto out; /* OK? */
 
-	if (read_copy_data(handle, size, fd) < 0)
-		return -1;
+	if (read_copy_data(in_handle, size, out_handle) < 0)
+		goto error;
 
-	handle->file_state = TRACECMD_FILE_KALLSYMS;
+out:
+	in_uncompress_reset(in_handle);
+	in_handle->file_state = TRACECMD_FILE_KALLSYMS;
+
+	if (out_compression_end(out_handle))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
 
 	return 0;
+error:
+	out_compression_reset(out_handle);
+	in_uncompress_reset(in_handle);
+	return -1;
 }
 
-static int copy_ftrace_printk(struct tracecmd_input *handle, int fd)
+static int copy_ftrace_printk(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
 	unsigned int size;
 
-	if (handle->file_state != TRACECMD_FILE_PRINTK - 1)
+	if (!check_in_state(in_handle, TRACECMD_FILE_PRINTK) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_PRINTK))
 		return -1;
 
-	if (read_copy_size4(handle, fd, &size) < 0)
+	if (in_uncompress_block(in_handle))
 		return -1;
-	if (!size)
-		return 0; /* OK? */
+	out_compression_start(out_handle);
 
-	if (read_copy_data(handle, size, fd) < 0)
-		return -1;
+	if (read_copy_size4(in_handle, out_handle, &size) < 0)
+		goto error;
+	if (!size)
+		goto out; /* OK? */
 
-	handle->file_state = TRACECMD_FILE_PRINTK;
+	if (read_copy_data(in_handle, size, out_handle) < 0)
+		goto error;
 
+out:
+	in_uncompress_reset(in_handle);
+	in_handle->file_state = TRACECMD_FILE_PRINTK;
+	if (out_compression_end(out_handle))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
 	return 0;
+error:
+	out_compression_reset(out_handle);
+	in_uncompress_reset(in_handle);
+	return -1;
 }
 
-static int copy_command_lines(struct tracecmd_input *handle, int fd)
+static int copy_command_lines(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
 	unsigned long long size;
 
-	if (handle->file_state != TRACECMD_FILE_CMD_LINES - 1)
+	if (!check_in_state(in_handle, TRACECMD_FILE_CMD_LINES) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_CMD_LINES))
 		return -1;
 
-	if (read_copy_size8(handle, fd, &size) < 0)
+	if (in_uncompress_block(in_handle))
 		return -1;
+	out_compression_start(out_handle);
+
+	if (read_copy_size8(in_handle, out_handle, &size) < 0)
+		goto error;
 	if (!size)
-		return 0; /* OK? */
+		goto out; /* OK? */
 
-	if (read_copy_data(handle, size, fd) < 0)
-		return -1;
+	if (read_copy_data(in_handle, size, out_handle) < 0)
+		goto error;
 
-	handle->file_state = TRACECMD_FILE_CMD_LINES;
+out:
+	in_uncompress_reset(in_handle);
+	in_handle->file_state = TRACECMD_FILE_CMD_LINES;
+	if (out_compression_end(out_handle))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
 
 	return 0;
+error:
+	out_compression_reset(out_handle);
+	in_uncompress_reset(in_handle);
+	return -1;
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
@@ -3981,7 +4057,8 @@ static int copy_command_lines(struct tracecmd_input *handle, int fd)
  * NOTE: The input handle is also modified, and ends at the end
  *       state as well.
  */
-int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
+int tracecmd_copy_headers(struct tracecmd_input *in_handle,
+			  struct tracecmd_output *out_handle,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state)
 {
@@ -3997,68 +4074,67 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 
 	if (end_state < TRACECMD_FILE_HEADERS)
 		return 0;
-
-	if (handle->file_state >= start_state) {
+	if (in_handle->file_state >= start_state) {
 		/* Set the handle to just before the start state */
-		lseek64(handle->fd, handle->header_files_start, SEEK_SET);
+		lseek64(in_handle->fd, in_handle->header_files_start, SEEK_SET);
 		/* Now that the file handle has moved, change its state */
-		handle->file_state = TRACECMD_FILE_INIT;
+		in_handle->file_state = TRACECMD_FILE_INIT;
 	}
 
 	/* Try to bring the input up to the start state - 1 */
-	ret = tracecmd_read_headers(handle, start_state - 1);
+	ret = tracecmd_read_headers(in_handle, start_state - 1);
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
index c41dfb8f..06d0738e 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -89,8 +89,8 @@ struct list_event_system {
 	char				*name;
 };
 
-static stsize_t
-do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
+__hidden long long
+do_write_check(struct tracecmd_output *handle, const void *data, long long size)
 {
 	if (handle->do_compress)
 		return tracecmd_compress_write(handle->compress, data, size);
@@ -1946,11 +1946,9 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char
 	if (!handle)
 		return NULL;
 
-	if (tracecmd_copy_headers(ihandle, handle->fd, 0, 0) < 0)
+	if (tracecmd_copy_headers(ihandle, handle, 0, 0) < 0)
 		goto out_free;
 
-	handle->file_state = tracecmd_get_file_state(ihandle);
-
 	/* The file is all ready to have cpu data attached */
 	return handle;
 
@@ -1959,6 +1957,11 @@ out_free:
 	return NULL;
 }
 
+__hidden void out_set_file_state(struct tracecmd_output *handle, int new_state)
+{
+	handle->file_state = new_state;
+}
+
 __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
 {
 	return check_file_state(handle->file_version, handle->file_state, new_state);
-- 
2.31.1

