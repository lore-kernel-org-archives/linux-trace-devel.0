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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CB2C43460
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4CEC617C9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhELGjy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbhELGjy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:54 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9D9C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:46 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id di13so25713929edb.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tLnpfeNVWbyIOVfArLlXsardczbIEiDd7wB8LQwgGYw=;
        b=B4bUZVF7Szi0Q4JvzqfAKLmKzqtnB9yyhp2mtDqun5GI6WdOUUxQeSR6M4L5q0ihHo
         L4fetodIsedYLWHeEFVGiILdMKucafiWqmEoczWlAZ7GhyuTW2hdB1lwfHEJ+EwFPkGd
         nTOeFgt7+sOGeqKtroeAE7ml6AUSyWFt8dG1JkDalHCMv2OzI9lNt+9nugGV/Yw0iw3z
         HcQ2fJLER0ybmWmBfAJGCL1WKk2GA4izKNG+/tDJlFhhH7LHqr0JphS2VGhxzEXQy9+O
         nBCpcyzroXJ70vGMXhiN2OF6VLOvk3eFOI2waOTlS/MsxkBpJmUhPDpTy3y3INqa8qqN
         JHZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tLnpfeNVWbyIOVfArLlXsardczbIEiDd7wB8LQwgGYw=;
        b=A6h2tFeegeqGWCHzdE2Nkb9tm0UrvGMfihpnQE36uQ/0309CbIxuoNOWDBjcaXOO2V
         /0luCtdLM8Kdnv4Sr+h80jH2NT/hug8HjoPNJGMTK8AQB/XVm0Ipu1victtdMhc6tWi/
         Er6QHXo7PcftSQ38KOtmlcHvG8VFNwHATEVrSV+6o3aGhSLdJlDXlJU0jQDacsp71mfH
         lM8g8U6oob1cly7qGCxSgZFwyxGJX5oO09dJ4cqjbZnYi/t6YGn3iD2VpJwmO7n0ufEd
         kZld5bOBTBZvoAlEoEHAfLZfCLhvalZiiiBaOmxG+kw717ofTunVx/sFxR08RfJLhCug
         KgXw==
X-Gm-Message-State: AOAM533PA6gEmMwRoy8UUVr6iCUJjXERiUOpLrGcMdWSH4MPuCMZBv2U
        OOB9IbrmJDhcZzaPL9XdSw5Vshv6LpEsMg==
X-Google-Smtp-Source: ABdhPJyD4lAKtffH8+UM/meUDEGFRicYWSr1T5A7OjOVhKq9zoA7KgPSlAjRO/FitdvjyVwlWxR1xw==
X-Received: by 2002:a05:6402:da:: with SMTP id i26mr4833888edu.379.1620801525477;
        Tue, 11 May 2021 23:38:45 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:45 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 21/25] trace-cmd library: Add compression of the option section of the trace file
Date:   Wed, 12 May 2021 09:38:19 +0300
Message-Id: <20210512063823.324610-22-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
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
index 78581789..1cec6917 100644
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
index 56acb01d..8d0f2251 100644
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

