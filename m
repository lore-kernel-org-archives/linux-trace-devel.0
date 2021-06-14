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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28880C48BE8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 134B361380
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhFNHyI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:54:08 -0400
Received: from mail-ed1-f43.google.com ([209.85.208.43]:35738 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbhFNHyH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:54:07 -0400
Received: by mail-ed1-f43.google.com with SMTP id ba2so43440161edb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OQ7uF0lhZZ996H2CtqnUokIHplGG0A0iEPr25+eVg7Q=;
        b=QPT5+ErOgUtIoznlYChmyV0+H8y5qY60jlyJmyfmHmkknMVANjEn/EqhWS+jYwrnUz
         pTiQEaWgMeuNBrwioG7KTQ9UzsVhM+wJaAn8ZPr2kg9D8oBtm4wkMWLRhYPthmXz+mFE
         fEqQDKUoHj8oxX6FA1FGgzfcIVOCHALxe7QGGiyEQGDE1kEP2asfn+hMucYwQdu1mEYA
         Tc36RWW1tgs9svPT/jtmnMemRIup+hgJi2e1hcJ8efiUtPEqax5OAf34pdmnaL8WnE/I
         rx7p+XYLtM/fNhOQzoipBBfe3u6qSkhU9UhIsbd+Vc0IphpLNtfwe5R1L2VPQaVfH7F0
         zP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OQ7uF0lhZZ996H2CtqnUokIHplGG0A0iEPr25+eVg7Q=;
        b=bGraWO4Hd24IK0HG52YuLB2qmXr4azkfM5mL07tZMTIwR5Z8C7N9kcpTRBtgB+z07F
         Ahm49vx5sR2cyoyKPz7OBg+wPyDaQ3hpDONfa6t4N71azxgZIW7Z8i2AH34JuaEjbyQz
         AvKeGKXwWdblYzl2D9zezmU7aXn5shuFbJR16v6zTTHJtE6g7GgNyjAUvdfPZEf73lKI
         RdgWvBZpMJ7E/mpbWMgi7+DEfp5X1SyyrDumWdnsqiAilpCdUO61sBM8ZsaOjN3kePOl
         dR+uFXnf2uClviDfFtM04HYDeLvJeThyv6uMTnRCQGppCe1n/xhtwn+fj6acr2UPR4IZ
         7xtw==
X-Gm-Message-State: AOAM5316e/lsCu/2xPZdkPI6F8Ezgq1zc5XYr/KDIV5dZBF97Mz9yqio
        lr4C5QWkWlLIpVtFYJBYLX0=
X-Google-Smtp-Source: ABdhPJxQ2yDGhkqpnau1Ipu5mTAeNZPPXmhtcR1jJMgA0fU+cK9BguvhTStcat1bmLLmtuPj1ztpjQ==
X-Received: by 2002:aa7:d857:: with SMTP id f23mr16229357eds.41.1623657052169;
        Mon, 14 Jun 2021 00:50:52 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 21/45] trace-cmd library: Add compression of the option section of the trace file
Date:   Mon, 14 Jun 2021 10:50:05 +0300
Message-Id: <20210614075029.598048-22-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/include/trace-cmd-local.h |  1 +
 lib/trace-cmd/trace-input.c             | 46 +++++++++++------
 lib/trace-cmd/trace-output.c            | 69 +++++++++++++++++--------
 tracecmd/trace-dump.c                   | 16 ++++--
 4 files changed, 92 insertions(+), 40 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 2f421103..03d2a9a3 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -39,6 +39,7 @@ void tracecmd_zlib_free(void);
 void tracecmd_compress_init(void);
 void tracecmd_compress_free(void);
 
+int out_uncompress_block(struct tracecmd_output *handle);
 int out_compression_start(struct tracecmd_output *handle);
 int out_compression_end(struct tracecmd_output *handle);
 void out_compression_reset(struct tracecmd_output *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b76f2b47..8fff003e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2761,23 +2761,29 @@ static int handle_options(struct tracecmd_input *handle)
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
 	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
-
+	if (in_uncompress_block(handle))
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
+	in_uncompress_reset(handle);
+	return ret;
 }
 
 static int read_options_type(struct tracecmd_input *handle)
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index bad234c4..f7e6c3dd 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -150,6 +150,18 @@ __hidden void out_compression_reset(struct tracecmd_output *handle)
 	handle->do_compress = false;
 }
 
+__hidden int out_uncompress_block(struct tracecmd_output *handle)
+{
+	int ret = 0;
+
+	if (handle->file_version < 7)
+		return 0;
+	ret = tracecmd_uncompress_block(handle->compress);
+	if (!ret)
+		handle->do_compress = true;
+	return ret;
+}
+
 __hidden int out_compression_start(struct tracecmd_output *handle)
 {
 	if (handle->file_version < 7 || !handle->compress)
@@ -1326,32 +1338,38 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 
 	if (do_write_check(handle, "options  ", 10))
 		return -1;
-
+	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
+	out_compression_start(handle);
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
+	if (out_compression_end(handle))
+		goto error;
 
 	handle->file_state = TRACECMD_FILE_OPTIONS;
 
 	return 0;
+error:
+	out_compression_reset(handle);
+	return -1;
 }
 
 int tracecmd_append_options(struct tracecmd_output *handle)
@@ -1367,42 +1385,51 @@ int tracecmd_append_options(struct tracecmd_output *handle)
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
+	if (out_uncompress_block(handle))
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
+		goto error;
 
+	if (handle->file_version >= 7 && handle->compress) {
+		if (lseek64(handle->fd, handle->options_start, SEEK_SET) == (off_t)-1)
+			goto error;
+		if (out_compression_end(handle))
+			goto error;
+	}
 	return 0;
+error:
+	out_compression_reset(handle);
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

