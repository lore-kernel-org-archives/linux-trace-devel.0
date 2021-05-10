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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3D6C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB68E61155
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhEJGSF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhEJGSE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:18:04 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10BFC061574
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:16:59 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id y26so17308461eds.4
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=La9bypsC5718y0TeuBbio6LCEZ+KHuHhhPEo9RSCR3A=;
        b=ob1lTpPZubQCz/BP2Ph1WE0Fi9Nm74riLaHD9AoVDbv+yACcVNq6lz05epJkBJW70a
         3GO6yxDIGYyt9HmD9OE6TdH7Ptey07WB3iJoB+SGha7mYtILphaygdctdA5iJ8DTC5Km
         Hq6ZbEbCe2u00f2UbSgtpfd8MiNX5Qcv/SfpJHQxbQzR6XN293go1JD/TE9/PaTmCND3
         wGk/R6yD0+pXUm/JYFmICzf+baqKSdNxaKvPIfPpggHgIDn24UbTvlViT146DuS+uDo5
         9+EPKWxRPbV4gfKBFqxnwmYOQA+yVMNwLG/a5Wj4bbz/hXgfK6LUtUsNtlAD3n++Tqvc
         PUsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=La9bypsC5718y0TeuBbio6LCEZ+KHuHhhPEo9RSCR3A=;
        b=Ux2oBJ/W6TG1+Ti4ySFFRP2FS9TKc+tjCx0qPqAADnPjWee5O6DdQIW/wTxndQDYNA
         9tWXKRSj25jzLQjl/+ONOIZNi6pPJTEXaimqGHUcvqStDxItVsvu7XlYZu5g2FVcd0Pb
         iPJVxuDTxjM5QAYgLadZpKj0KFT0obFbW9E0Thf3No/90RS6cI06CHK7hzMwxENeP6mF
         X+FU/5/P0jt90/SofKExiYMZ8OSs4fXRZ1ICowfbwTFmil3Tjp+Ajb7otk9z6NQ83E5s
         Uy6WAXAjheS5GLVSI6ocfjqf4+Kgns7sSOts8UY9EB3XyZTqCo4Ct5zyX+3rzi5DYPAz
         WpXQ==
X-Gm-Message-State: AOAM532mhD+Eg5TZJtvRvKE2yX55ChJVlgV60N+jaA0djmfbp2RbB1cj
        W1T4mrL8LGyQ/oN3Pd1hsU9P7/sIokMv5Q==
X-Google-Smtp-Source: ABdhPJwUaZuQbJe73Y9h8UQl0geoMGBch8EZSCGN9Ma2khvIZr8Xq1O9fAtUZkpGucu5wI+sT4ZP/w==
X-Received: by 2002:a05:6402:2753:: with SMTP id z19mr27390199edd.158.1620627418501;
        Sun, 09 May 2021 23:16:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm5055205eja.25.2021.05.09.23.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:16:58 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 21/21] trace-cmd library: Add compression of the option section of the trace file
Date:   Mon, 10 May 2021 09:16:36 +0300
Message-Id: <20210510061636.1794357-22-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
References: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Comperss the option section of the trace file. This section is not big
currently and compressing it does not reduce significantly the size of
the file. This could be useful in the future as new options can be
added, storing a potentially huge amount of data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c  | 46 +++++++++++++++---------
 lib/trace-cmd/trace-output.c | 68 ++++++++++++++++++++++++------------
 tracecmd/trace-dump.c        | 16 +++++++--
 3 files changed, 89 insertions(+), 41 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index a16c438c..d6ccc90a 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2761,23 +2761,29 @@ static int handle_options(struct tracecmd_input *handle)
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
 	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
-
+	if (uncompress_block(handle))
+		return -1;
 	for (;;) {
-		if (do_read_check(handle, &option, 2))
-			return -1;
+		ret = do_read_check(handle, &option, 2);
+		if (ret)
+			goto out;
 
 		if (option == TRACECMD_OPTION_DONE)
 			break;
 
 		/* next 4 bytes is the size of the option */
-		if (do_read_check(handle, &size, 4))
-			return -1;
+		ret = do_read_check(handle, &size, 4);
+		if (ret)
+			goto out;
 		size = tep_read_number(handle->pevent, &size, 4);
 		buf = malloc(size);
-		if (!buf)
-			return -ENOMEM;
-		if (do_read_check(handle, buf, size))
-			return -1;
+		if (!buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = do_read_check(handle, buf, size);
+		if (ret)
+			goto out;
 
 		switch (option) {
 		case TRACECMD_OPTION_DATE:
@@ -2827,14 +2833,16 @@ static int handle_options(struct tracecmd_input *handle)
 							     buf + 8, 4);
 			ret = tsync_cpu_offsets_load(handle, buf + 12, size - 12);
 			if (ret < 0)
-				return ret;
+				goto out;
 			tracecmd_enable_tsync(handle, true);
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
 			cpustats = realloc(cpustats, cpustats_size + size + 1);
-			if (!cpustats)
-				return -ENOMEM;
+			if (!cpustats) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			memcpy(cpustats + cpustats_size, buf, size);
 			cpustats_size += size;
 			cpustats[cpustats_size] = 0;
@@ -2844,14 +2852,17 @@ static int handle_options(struct tracecmd_input *handle)
 			handle->nr_buffers++;
 			handle->buffers = realloc(handle->buffers,
 						  sizeof(*handle->buffers) * handle->nr_buffers);
-			if (!handle->buffers)
-				return -ENOMEM;
+			if (!handle->buffers) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			buffer = &handle->buffers[handle->nr_buffers - 1];
 			buffer->name = strdup(buf + 8);
 			if (!buffer->name) {
 				free(handle->buffers);
 				handle->buffers = NULL;
-				return -ENOMEM;
+				ret = -ENOMEM;
+				goto out;
 			}
 			offset = *(unsigned long long *)buf;
 			buffer->offset = tep_read_number(handle->pevent, &offset, 8);
@@ -2908,8 +2919,11 @@ static int handle_options(struct tracecmd_input *handle)
 	}
 
 	handle->cpustats = cpustats;
+	ret = 0;
 
-	return 0;
+out:
+	uncompress_reset(handle);
+	return ret;
 }
 
 static int read_options_type(struct tracecmd_input *handle)
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 1bd2351f..ca115872 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -150,6 +150,18 @@ static inline void compression_reset(struct tracecmd_output *handle)
 	handle->do_compress = false;
 }
 
+static int uncompress_block(struct tracecmd_output *handle)
+{
+	int ret = 0;
+
+	if (handle->file_version < 7 || !handle->compress)
+		return 0;
+	ret = tracecmd_uncompress_block(handle->compress);
+	if (!ret)
+		handle->do_compress = true;
+	return ret;
+}
+
 static inline int compression_start(struct tracecmd_output *handle)
 {
 	if (handle->file_version < 7 || !handle->compress)
@@ -1330,32 +1342,38 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 
 	if (do_write_check(handle, "options  ", 10))
 		return -1;
-
+	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
+	compression_start(handle);
 	list_for_each_entry(options, &handle->options, list) {
 		endian2 = convert_endian_2(handle, options->id);
 		if (do_write_check(handle, &endian2, 2))
-			return -1;
+			goto error;
 
 		endian4 = convert_endian_4(handle, options->size);
 		if (do_write_check(handle, &endian4, 4))
-			return -1;
+			goto error;
 
 		/* Save the data location in case it needs to be updated */
-		options->offset = lseek64(handle->fd, 0, SEEK_CUR);
+		options->offset = do_lseek(handle, 0, SEEK_CUR);
 
 		if (do_write_check(handle, options->data,
 				   options->size))
-			return -1;
+			goto error;
 	}
 
 	option = TRACECMD_OPTION_DONE;
 
 	if (do_write_check(handle, &option, 2))
-		return -1;
+		goto error;
+	if (compression_end(handle))
+		goto error;
 
 	handle->file_state = TRACECMD_FILE_OPTIONS;
 
 	return 0;
+error:
+	compression_reset(handle);
+	return -1;
 }
 
 int tracecmd_append_options(struct tracecmd_output *handle)
@@ -1371,42 +1389,48 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 	 * We can append only if options are already written and tracing data
 	 * is not yet written
 	 */
-	if (handle->file_state != TRACECMD_FILE_OPTIONS)
+	if (handle->file_state != TRACECMD_FILE_OPTIONS || !handle->options_start)
 		return -1;
-
-	if (lseek64(handle->fd, 0, SEEK_END) == (off_t)-1)
+	if (lseek64(handle->fd, handle->options_start, SEEK_SET) == (off_t)-1)
 		return -1;
-	offset = lseek64(handle->fd, -2, SEEK_CUR);
-	if (offset == (off_t)-1)
+	if (uncompress_block(handle))
 		return -1;
-
-	r = pread(handle->fd, &option, 2, offset);
+	if (do_lseek(handle, 0, SEEK_END) == -1)
+		goto error;
+	offset = do_lseek(handle, -2, SEEK_CUR);
+	if (offset == (off_t)-1)
+		goto error;
+	r = do_preed(handle, &option, 2, offset);
 	if (r != 2 || option != TRACECMD_OPTION_DONE)
-		return -1;
-
+		goto error;
 	list_for_each_entry(options, &handle->options, list) {
 		endian2 = convert_endian_2(handle, options->id);
 		if (do_write_check(handle, &endian2, 2))
-			return -1;
+			goto error;
 
 		endian4 = convert_endian_4(handle, options->size);
 		if (do_write_check(handle, &endian4, 4))
-			return -1;
+			goto error;
 
 		/* Save the data location in case it needs to be updated */
-		options->offset = lseek64(handle->fd, 0, SEEK_CUR);
+		options->offset = do_lseek(handle, 0, SEEK_CUR);
 
 		if (do_write_check(handle, options->data,
 				   options->size))
-			return -1;
+			goto error;
 	}
-
 	option = TRACECMD_OPTION_DONE;
 
 	if (do_write_check(handle, &option, 2))
-		return -1;
-
+		goto error;
+	if (lseek64(handle->fd, handle->options_start, SEEK_SET) == (off_t)-1)
+		goto error;
+	if (compression_end(handle))
+		goto error;
 	return 0;
+error:
+	compression_reset(handle);
+	return -1;
 }
 
 static struct tracecmd_option *
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index d6136360..2c8d3995 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -82,6 +82,13 @@ static int read_compressed(int fd, char *dst, int len)
 	return read_fd(fd, dst, len);
 }
 
+static int do_lseek(int fd, int offset, int whence)
+{
+	if (read_compress)
+		return tracecmd_compress_lseek(compress, offset, whence);
+	return lseek64(fd, offset, whence);
+}
+
 static int read_file_string(int fd, char *dst, int len)
 {
 	size_t size = 0;
@@ -625,6 +632,9 @@ static void dump_options(int fd)
 	unsigned int size;
 	int count = 0;
 
+	if (uncompress_block())
+		die("cannot uncompress file block");
+
 	for (;;) {
 		if (read_file_number(fd, &option, 2))
 			die("cannot read the option id");
@@ -635,7 +645,7 @@ static void dump_options(int fd)
 
 		count++;
 		if (!DUMP_CHECK(OPTIONS) && !DUMP_CHECK(CLOCK) && !DUMP_CHECK(SUMMARY)) {
-			lseek64(fd, size, SEEK_CUR);
+			do_lseek(fd, size, SEEK_CUR);
 			continue;
 		}
 		switch (option) {
@@ -685,12 +695,12 @@ static void dump_options(int fd)
 		default:
 			do_print(OPTIONS, " %d %d\t[Unknown option, size - skipping]\n",
 				 option, size);
-			lseek64(fd, size, SEEK_CUR);
+			do_lseek(fd, size, SEEK_CUR);
 			break;
 		}
 	}
 	do_print(SUMMARY, "\t[%d options]\n", count);
-
+	uncompress_reset();
 }
 
 static void dump_latency(int fd)
-- 
2.31.1

