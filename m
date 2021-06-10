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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D734FC48BE8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C437B61419
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhFJLhu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:50 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:55886 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbhFJLhq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:46 -0400
Received: by mail-wm1-f45.google.com with SMTP id g204so5954906wmf.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XThZzPdOYJaqw5JOXWGo2FbsQo5b9Di4gify468C2WE=;
        b=oS4j3+cwJ7XOIHFjOrhYjqvALzBGey/oR3bGyQPcvyFL/tPCDOxhq/xJ1U9bU4Aj3T
         PVMGm4FM9nBv+8U6rzLfglZR5sxofb7KJrwOO4A/11miBgGemLS5sjJIWeL+Bueqg4nq
         Vre9+7lJMCzrg9ooZLO1Vwx/MJ6naCEMaRdmuzih4JZcicYCj9eWZIWN8ekVZwrLX0/Q
         vcfh8OsEWBPLDz4fh9BkFwz+0BXG+23BFRY6DkEtY6d0q+XZxRmY51pcT0mxXdsI693/
         u5GeaR+j8pyOH7k/tJj/xGjbIg5NjIgAbhwkqTUoQH8LVonPB9ui3ZKzfV5kDXT8Ckay
         6q4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XThZzPdOYJaqw5JOXWGo2FbsQo5b9Di4gify468C2WE=;
        b=hcXTBiDr9u4SyV+93Bm826Rt5XP0Exk+RKKdt1K4VVpajIo6bkin1g0cqpvwt8eZGJ
         9ef4JmpOoFEQdFRlm5CZ3/mfk0o7xPUCOuy/qXnVOmERe11d7+dkq4NKl4bZ/GbeYsw/
         Ne2TTST3eVqvSDXejQprKL54C5p0nkr6WlcquQRXAxZ0cJnOwXOIjylLp4uWsLgUSwGK
         u4mCpgAY34+rJyeRrIHmheth1w/HVjsbDrAABEj87ygcqxJK1bX0NzRJPiDGZfCqnQHB
         V9bxjJLlzRZPEhzTLdIS7WHdf0qwUhAX19r//4jopUICNIX3H14EI5Udd2H738fByM/a
         utUQ==
X-Gm-Message-State: AOAM533UTiK9SqDzftWF19HVfaSIngAQU75g7eIGu9je9zjNZojvizTK
        cBcfEhvqdvHQ6M0vQomNky6o0hXGq7poxw==
X-Google-Smtp-Source: ABdhPJwJ3xCbl+pyOjhtS2LRH593cWjGA9mZaMu9zbCWaF4PXmcbkiJGwa9c9TOP2Wkuo+BNDqLizg==
X-Received: by 2002:a7b:c20a:: with SMTP id x10mr4502370wmi.141.1623324889952;
        Thu, 10 Jun 2021 04:34:49 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 23/40] trace-cmd library: Add APIs for read and write compressed data in chunks
Date:   Thu, 10 Jun 2021 14:34:09 +0300
Message-Id: <20210610113426.257931-24-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New compression APIs are added for writing and reading compressed data
from / to files in chunks:
 tracecmd_compress_copy_from()
 tracecmd_uncompress_copy_to()
Format of the compressed data, used by these APIs, is:
 - 4 bytes, chunks count
   - for each chunk:
     - 4 bytes, size of compressed data in this chunk
     - 4 bytes, uncompressed size of the data in this chunk
     - data, bytes of <size of compressed data in this chunk>

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |   5 +-
 lib/trace-cmd/trace-compress.c                | 200 ++++++++++++++++++
 2 files changed, 204 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 10089389..067ba34d 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -494,7 +494,10 @@ int tracecmd_compress_proto_register(const char *name, const char *version, int
 						       char *out, unsigned int *out_bytes),
 				     unsigned int (*comress_size)(unsigned int bytes),
 				     bool (*is_supported)(const char *name, const char *version));
-
+int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int chunk_size,
+				unsigned long long *read_size, unsigned long long *write_size);
+int tracecmd_uncompress_copy_to(struct tracecmd_compression *handle, int fd,
+				unsigned long long *read_size, unsigned long long *write_size);
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
 
diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index 2b329d00..4a4707c2 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -594,3 +594,203 @@ error:
 	free(v);
 	return -1;
 }
+
+/**
+ * tracecmd_compress_copy_from - Copy and compress data from a file
+ * @handle: compression handler
+ * @fd: file descriptor to uncompressed data
+ * @chunk_size: size of one compression chunk
+ * @read_size: in - max bytes to read from @fd, 0 to read till the EOF
+ *	       out - size of the uncompressed data read from @fd
+ * @write_size: return, size of the compressed data written into @handle
+ *
+ * This function reads uncompressed data from given @fd until EOF is reached, compresses
+ * the data using the @handle compression context and writes the compressed data into the fd
+ * associated with the @handle. The data is compressed on chunks with given @chunk_size size.
+ * The compressed data is written in the format:
+ *  - 4 bytes, chunks count
+ *  - for each chunk:
+ *    - 4 bytes, size of compressed data in this chunk
+ *    - 4 bytes, uncompressed size of the data in this chunk
+ *    - data, bytes of <size of compressed data in this chunk>
+ *
+ * On success 0 is returned, @read_size and @write_size are updated with the size of
+ * read and written data.
+ */
+int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int chunk_size,
+				unsigned long long *read_size, unsigned long long *write_size)
+{
+	unsigned int chunks = 0;
+	unsigned int rsize = 0;
+	unsigned int rmax = 0;
+	unsigned int wsize = 0;
+	unsigned int csize;
+	unsigned int rchunk = 0;
+	unsigned int size;
+	unsigned int r;
+	off64_t offset;
+	char *buf_from;
+	char *buf_to;
+	int endian4;
+	int ret;
+
+	if (!handle || !handle->proto ||
+	    !handle->proto->comress_block || !handle->proto->comress_size)
+		return 0;
+	if (read_size)
+		rmax = *read_size;
+	csize = handle->proto->comress_size(chunk_size);
+	buf_from = malloc(chunk_size);
+	if (!buf_from)
+		return -1;
+	buf_to = malloc(csize);
+	if (!buf_to)
+		return -1;
+	/* save the initial offset and write 0 chunks */
+	offset = lseek64(handle->fd, 0, SEEK_CUR);
+	write_fd(handle->fd, &chunks, 4);
+
+	do {
+		if (rmax > 0 && (rmax - rsize) < chunk_size)
+			rchunk = (rmax - rsize);
+		else
+			rchunk = chunk_size;
+
+		r = read(fd, buf_from, rchunk);
+		if (r < 0 || (rmax > 0 && rsize >= rmax))
+			break;
+		rsize += r;
+		size = csize;
+		if (r > 0) {
+			ret = handle->proto->comress_block(buf_from, r, buf_to, &size);
+			if (ret < 0) {
+				if (errno == EINTR)
+					continue;
+				break;
+			}
+			/* Write compressed data size */
+			endian4 = tep_read_number(handle->tep, &size, 4);
+			ret = write_fd(handle->fd, &endian4, 4);
+			if (ret != 4)
+				break;
+			/* Write uncompressed data size */
+			endian4 = tep_read_number(handle->tep, &r, 4);
+			ret = write_fd(handle->fd, &endian4, 4);
+			if (ret != 4)
+				break;
+			/* Write the compressed data */
+			ret = write_fd(handle->fd, buf_to, size);
+			if (ret != size)
+				break;
+			/* data + compress header */
+			wsize += (size + 8);
+			chunks++;
+		}
+	} while (r > 0);
+	free(buf_from);
+	free(buf_to);
+	if (r)
+		return -1;
+	if (lseek64(handle->fd, offset, SEEK_SET) == (off_t)-1)
+		return -1;
+	endian4 = tep_read_number(handle->tep, &chunks, 4);
+	/* write chunks count*/
+	write_fd(handle->fd, &chunks, 4);
+	lseek64(handle->fd, offset, SEEK_SET);
+	if (lseek64(handle->fd, 0, SEEK_END) == (off_t)-1)
+		return -1;
+	if (read_size)
+		*read_size = rsize;
+	if (write_size)
+		*write_size = wsize;
+	return 0;
+}
+
+/**
+ * tracecmd_uncompress_copy_to - Uncompress data and copy to a file
+ * @handle: compression handler
+ * @fd: file descriptor to uncompressed data
+ * @read_size: return, size of the compressed data read from @handle
+ * @write_size: return, size of the uncompressed data written into @fd
+ *
+ * This function reads compressed data from the fd, associated with @handle, uncompresses it
+ * using the @handle compression context and writes the uncompressed data into the fd.
+ * The compressed data must be in the format:
+ *  - 4 bytes, chunks count
+ *  - for each chunk:
+ *    - 4 bytes, size of compressed data in this chunk
+ *    - 4 bytes, uncompressed size of the data in this chunk
+ *    - data, bytes of <size of compressed data in this chunk>
+ *
+ * On success 0 is returned, @read_size and @write_size are updated with the size of
+ * read and written data.
+ */
+int tracecmd_uncompress_copy_to(struct tracecmd_compression *handle, int fd,
+				unsigned long long *read_size, unsigned long long *write_size)
+{
+	unsigned int s_uncompressed;
+	unsigned int s_compressed;
+	unsigned int rsize = 0;
+	unsigned int wsize = 0;
+	char *bytes_out = NULL;
+	char *bytes_in = NULL;
+	int size_out;
+	int size_in;
+	int chunks;
+	char buf[4];
+	char *tmp;
+	int ret;
+
+	if (!handle || !handle->proto || !handle->proto->uncompress_block)
+		return -1;
+
+	if (read(handle->fd, buf, 4) != 4)
+		return -1;
+	chunks = tep_read_number(handle->tep, buf, 4);
+	rsize += 4;
+	while (chunks) {
+		if (read(handle->fd, buf, 4) != 4)
+			break;
+		s_compressed = tep_read_number(handle->tep, buf, 4);
+		rsize += 4;
+		if (read(handle->fd, buf, 4) != 4)
+			break;
+		s_uncompressed = tep_read_number(handle->tep, buf, 4);
+		rsize += 4;
+		if (!bytes_in || size_in < s_compressed) {
+			tmp = realloc(bytes_in, s_compressed);
+			if (!tmp)
+				break;
+			bytes_in = tmp;
+			size_in = s_compressed;
+		}
+
+		if (!bytes_out || size_out < s_uncompressed) {
+			tmp = realloc(bytes_out, s_uncompressed);
+			if (!tmp)
+				break;
+			bytes_out = tmp;
+			size_out = s_uncompressed;
+		}
+
+		if (read_fd(handle->fd, bytes_in, s_compressed) < 0)
+			break;
+		rsize += s_compressed;
+		ret = handle->proto->uncompress_block(bytes_in, s_compressed,
+						      bytes_out, &s_uncompressed);
+		if (ret)
+			break;
+		write_fd(fd, bytes_out, s_uncompressed);
+		wsize += s_uncompressed;
+		chunks--;
+	}
+	free(bytes_in);
+	free(bytes_out);
+	if (chunks)
+		return -1;
+	if (read_size)
+		*read_size = rsize;
+	if (write_size)
+		*write_size = wsize;
+	return 0;
+}
-- 
2.31.1

