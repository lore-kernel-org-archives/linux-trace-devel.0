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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFE9C48BE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 884C061352
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbhFNHxL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbhFNHxK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:10 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5693C061766
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:07 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id f5so40212012eds.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1WA9zC+hThGEZdfqPArjxMbh2DE3OSOtt2doRIwYfgI=;
        b=Sky/t7eEK5wIuIX+6fRW2H0asx88ijlI5b3B72uKBZ62eWF+sGSSXPdCirjZ4vGJhI
         VYd4C5o5qSn+Uhwt9gtMBiEbh8f8GmPQqV2qUTze1AkcZgvT02j1fX7mvzsVNZ4Mxmrn
         akgZqfBITqhPc2vJb+fMuuKs0g18mTuTHZXM0hfVjYqyzoud2FEs8BDI+Kcj2qO07H99
         zGlLkz51E2/4lJiikHpW3nuNS9aTRBx1pXZKgxr9VqnzesWtJxue3ypSiXsdVQJg8rLs
         no6gCoOVBIIwd1D850DRb1xMrPH4HfTb7uBfwPAPf+cUMKGLoz5weAvocDrGur2iCnwh
         k7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1WA9zC+hThGEZdfqPArjxMbh2DE3OSOtt2doRIwYfgI=;
        b=qHiS3bbeX1kCfBxnK1NyzP+2VGjAgRqB2xfyn5eA6HvWejLJ+M8SFjBPdjiRAnijcC
         xxahvGgWeZJj6ktd0QYLgijJISBb01mMmPNrkzX5izJ3mDwYGB95teIQNW8r6f8eGyxs
         F0MugkMaUgv0XeqAPhsJ/5dbqnzSX9rdF86EuNBZnI/uqbIJUu50UXahQjTNaijro8/e
         Su7E4hR8CeqGlZU5e21z+qnWvRX7IRYOnIDMMrM2jFtXRiISYk6yBSb1xVTefDqssnC6
         35Kq2cGgUc/2iNq+3cfJB0HOLbePnveUDXj6+KB/rrRYcdMa7XyE0JZIAwd27bcvzE2E
         XCxw==
X-Gm-Message-State: AOAM532Tnqv7ZSv7uDhGpaTveZGBNRTfwdK9fIcgLkgy7HcB6DjUdBrU
        J3U+ANImoVCkotoJ8dNb2u74MEG18G0P7w==
X-Google-Smtp-Source: ABdhPJzbnmiNQg+CrziJ4u8D6us0Jy1ZvSn7tFDeLpaA+uo8ynkQSxoBMHy01/CKuE9pmGEggyIieQ==
X-Received: by 2002:a05:6402:1c11:: with SMTP id ck17mr16273735edb.102.1623657066225;
        Mon, 14 Jun 2021 00:51:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:51:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 36/45] trace-cmd library: Refactor the logic for writing CPU trace data
Date:   Mon, 14 Jun 2021 10:50:20 +0300
Message-Id: <20210614075029.598048-37-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Refactored the internal library logic for writing trace CPU data in the
trace file. The existing logic copies trace data from a temporary file
into the trace file. In order to reuse the code, modify it to support
copying the trace data not only from temporary file, but from given fd
at given offset. These changes will be used in extending the
tracecmd_copy API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  13 +++
 lib/trace-cmd/trace-output.c            | 142 +++++++++++++++++-------
 2 files changed, 114 insertions(+), 41 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 2e5682c0..970087c7 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -53,10 +53,23 @@ int in_uncompress_block(struct tracecmd_input *handle);
 
 void out_set_file_state(struct tracecmd_output *handle, int new_state);
 void out_save_options_offset(struct tracecmd_output *handle);
+unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
+					int fd, unsigned long long max,
+					unsigned long long *write_size);
+
 
 int write_buffers_description_v7(struct tracecmd_output *handle);
 int write_buffers_description_v6(struct tracecmd_output *handle);
 
 long long do_write_check(struct tracecmd_output *handle, const void *data, long long size);
 
+struct cpu_data_source {
+	int fd;
+	int size;
+	off64_t offset;
+};
+
+int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
+		       struct cpu_data_source *data);
+
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 95ca483c..e5da4cdb 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -286,18 +286,26 @@ static unsigned long get_size(const char *file)
 	return size;
 }
 
-static tsize_t copy_file_fd(struct tracecmd_output *handle, int fd)
+static tsize_t copy_file_fd(struct tracecmd_output *handle, int fd, unsigned long long max)
 {
+	tsize_t rsize = 0;
 	tsize_t size = 0;
 	char buf[BUFSIZ];
 	stsize_t r;
 
 	do {
-		r = read(fd, buf, BUFSIZ);
+		if (max > 0 && (max - size) < BUFSIZ)
+			rsize = (max - size);
+		else
+			rsize = BUFSIZ;
+
+		r = read(fd, buf, rsize);
 		if (r > 0) {
 			size += r;
 			if (do_write_check(handle, buf, r))
 				return 0;
+			if (max > 0 && size >= max)
+				break;
 		}
 	} while (r > 0);
 
@@ -315,47 +323,61 @@ static tsize_t copy_file(struct tracecmd_output *handle,
 		tracecmd_warning("Can't read '%s'", file);
 		return 0;
 	}
-	size = copy_file_fd(handle, fd);
+	size = copy_file_fd(handle, fd, 0);
 	close(fd);
 
 	return size;
 }
 
 #define COMPRESS_CHUNK_SIZE (1*1024*1024)
-static tsize_t copy_file_compress(struct tracecmd_output *handle,
-				  const char *file, unsigned long long *write_size)
+__hidden unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
+						 int fd, unsigned long long max,
+						 unsigned long long *write_size)
 {
 	unsigned long long rsize = 0;
 	unsigned long long wsize = 0;
-	tsize_t size;
+	unsigned long long size;
 	int ret;
-	int fd;
-
-	fd = open(file, O_RDONLY);
-	if (fd < 0) {
-		tracecmd_warning("Can't read '%s'", file);
-		return 0;
-	}
 
 	if (handle->file_version >= 7) {
+		rsize = max;
 		ret = tracecmd_compress_copy_from(handle->compress, fd,
 						  COMPRESS_CHUNK_SIZE, &rsize, &wsize);
-		if (ret < 0) {
-			tracecmd_warning("Can't compress '%s'", file);
-			close(fd);
+		if (ret < 0)
 			return 0;
-		}
+
 		size = rsize;
-		*write_size = wsize;
+		if (write_size)
+			*write_size = wsize;
 	} else {
-		size = copy_file_fd(handle, fd);
-		*write_size = size;
+		size = copy_file_fd(handle, fd, max);
+		if (write_size)
+			*write_size = size;
 	}
 
-	close(fd);
 	return size;
 }
 
+static tsize_t copy_file_compress(struct tracecmd_output *handle,
+				  const char *file, unsigned long long *write_size)
+{
+	int ret;
+	int fd;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		tracecmd_warning("Can't read '%s'", file);
+		return 0;
+	}
+
+	ret = out_copy_fd_compress(handle, fd, 0, write_size);
+	if (!ret)
+		tracecmd_warning("Can't compress '%s'", file);
+
+	close(fd);
+	return ret;
+}
+
 /*
  * Finds the path to the debugfs/tracing
  * Allocates the string and stores it.
@@ -467,7 +489,7 @@ static int read_header_files(struct tracecmd_output *handle)
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
 		goto out_close;
-	check_size = copy_file_fd(handle, fd);
+	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s' size=%lld read=%lld", path, size, check_size);
@@ -493,7 +515,7 @@ static int read_header_files(struct tracecmd_output *handle)
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
 		goto out_close;
-	check_size = copy_file_fd(handle, fd);
+	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s'", path);
@@ -1671,8 +1693,8 @@ struct data_file_write {
 	off64_t doffset;
 };
 
-int tracecmd_write_cpu_data(struct tracecmd_output *handle,
-			    int cpus, char * const *cpu_data_files)
+__hidden int out_write_cpu_data(struct tracecmd_output *handle,
+				int cpus, struct cpu_data_source *data)
 {
 	struct data_file_write *data_files = NULL;
 	off64_t offset;
@@ -1680,8 +1702,6 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 	unsigned long long read_size;
 	unsigned long long write_size;
 	char *clock = NULL;
-	char *file;
-	struct stat st;
 	int ret;
 	int i;
 
@@ -1705,14 +1725,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 
 	/* Write 0 for trace data offset and size and store offsets of these fields */
 	for (i = 0; i < cpus; i++) {
-		file = cpu_data_files[i];
-		ret = stat(file, &st);
-		if (ret < 0) {
-			tracecmd_warning("can not stat '%s'", file);
-			goto out_free;
-		}
-		data_files[i].file_size = st.st_size;
-
+		data_files[i].file_size = data[i].size;
 		endian8 = 0;
 		data_files[i].doffset = lseek64(handle->fd, 0, SEEK_CUR);
 		if (do_write_check(handle, &endian8, 8))
@@ -1736,13 +1749,19 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 		if (!tracecmd_get_quiet(handle))
 			fprintf(stderr, "CPU%d data recorded at offset=0x%llx\n",
 				i, (unsigned long long) data_files[i].data_offset);
-
-		read_size = copy_file_compress(handle, cpu_data_files[i], &write_size);
-		if (read_size != data_files[i].file_size) {
-			errno = EINVAL;
-			tracecmd_warning("did not match size of %lld to %lld",
-					 read_size, data_files[i].file_size);
+		offset = lseek64(data[i].fd, data[i].offset, SEEK_SET);
+		if (offset == (off64_t)-1)
 			goto out_free;
+		if (data[i].size) {
+			read_size = out_copy_fd_compress(handle, data[i].fd, data[i].size, &write_size);
+			if (read_size != data_files[i].file_size) {
+				errno = EINVAL;
+				tracecmd_warning("did not match size of %lld to %lld",
+						 read_size, data_files[i].file_size);
+				goto out_free;
+			}
+		} else {
+			write_size = 0;
 		}
 		/* Write the real CPU data offset inthe file */
 		offset = lseek64(handle->fd, data_files[i].doffset, SEEK_SET);
@@ -1775,6 +1794,47 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 	return -1;
 }
 
+int tracecmd_write_cpu_data(struct tracecmd_output *handle,
+			    int cpus, char * const *cpu_data_files)
+{
+	struct cpu_data_source *data;
+	struct stat st;
+	int ret;
+	int i;
+
+	data = calloc(cpus, sizeof(struct cpu_data_source));
+	if (!data)
+		return -1;
+	for (i = 0; i < cpus; i++)
+		data[i].fd = -1;
+	for (i = 0; i < cpus; i++) {
+		ret = stat(cpu_data_files[i], &st);
+		if (ret < 0) {
+			tracecmd_warning("can not stat '%s'", cpu_data_files[i]);
+			break;
+		}
+		data[i].fd = open(cpu_data_files[i], O_RDONLY);
+		if (data[i].fd < 0) {
+			tracecmd_warning("Can't read '%s'", data[i].fd);
+			break;
+		}
+
+		data[i].size = st.st_size;
+		data[i].offset = 0;
+	}
+
+	if (i < cpus)
+		ret = -1;
+	else
+		ret = out_write_cpu_data(handle, cpus, data);
+	for (i = 0; i < cpus; i++) {
+		if (data[i].fd >= 0)
+			close(data[i].fd);
+	}
+	free(data);
+	return ret;
+}
+
 int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 			     int cpus, char * const *cpu_data_files)
 {
-- 
2.31.1

