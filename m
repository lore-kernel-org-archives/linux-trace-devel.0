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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD01C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0335D613BA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhELGkE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhELGj4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:56 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65135C06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:48 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id v5so14632326edc.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BbgUX1dAmAvyY+7LZeJ/4MbTgGA6KeIVuGIq+vN1d5I=;
        b=sNj2aCIPvKXMSeWSiwAWuhZo17reqY74KB1iO51kiCiXojKs4rzd6vwgUIF+AERI5l
         bn8NSzEywp6rrG0091ZSJT45dHvdMtP6iUTE8y4pXP7EkuypbL5CLO7dWssouzFMPE+3
         zSV1PMgng1Kvj7Np1WOX8jMiGdupg6+aXCh3x3l5d8AeKYGlOLjoiE1ZUtEY7Y5pJrDg
         ZNxob4I3MB/fdC8BtkDz0eJrs/g8Rs4aS5mNdKW6Eub+n0I97jNOoCkwu2rezrn7qP1a
         XZPio8FY+X2CMJsdfrsOy5Pxz4NmPf7qFetlYP9GhZOVW0PW0aLgkdAIZnGPOWK5ad7b
         cu4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BbgUX1dAmAvyY+7LZeJ/4MbTgGA6KeIVuGIq+vN1d5I=;
        b=MvlAEZyfBXuaWdKbIGRAKwto775AyjP1p827wo4uz0NvHtUCqCWpAqxNCinuT4nhva
         hwwDB8HFVN3yhBmE/ibRQ+EpJxXQIQEqB+fndklsrTijBIi1h7XKQSRQEA6H3pAYLnLl
         f8dydEV90ZlaXk+n9GLzwNgJbFwrNaUH5o4yF/Q1flnTTRL+M7uEeA1m9jlJEk7NbVpQ
         PYXqNyxoLRWeOvw90eUQ0D4qrVM7+sxHHP8cZ8L1Kie4xl08B+xZn+fi2fVwbGUWrV+8
         6OjBTMIeljaf40m+Yll/n8GVPjBMVGM/QzJZHBlhy6szGwRzCnNzmlDLOCoAI3Enz+aB
         9ryQ==
X-Gm-Message-State: AOAM533siaiVp8INkJSp7xxvPChvp1QOp7GPitl7rQaLxTsMDfwCwBBd
        F1jB2D3pLhvjxJARCDGIftgTrOonMRdXBA==
X-Google-Smtp-Source: ABdhPJzRsJah2MoijZvsMQZxiww5Pcg/LVzUTPTbNXZ9DPFKO0SfDzHDcrPLQQ4DZq+otaEJ1zFXBA==
X-Received: by 2002:a50:8e44:: with SMTP id 4mr41322838edx.244.1620801527184;
        Tue, 11 May 2021 23:38:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 23/25] trace-cmd library: Add APIs for read and write compressed data in chunks
Date:   Wed, 12 May 2021 09:38:21 +0300
Message-Id: <20210512063823.324610-24-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-compress.c                | 191 ++++++++++++++++++
 2 files changed, 195 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index a9b66736..950e6b51 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -493,7 +493,10 @@ int tracecmd_compress_proto_register(const char *name, const char *version, int
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
index 2b329d00..3a7accc2 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -594,3 +594,194 @@ error:
 	free(v);
 	return -1;
 }
+
+/**
+ * tracecmd_compress_copy_from - Copy and compress data from a file
+ * @handle: compression handler
+ * @fd: file descriptor to uncompressed data
+ * @chunk_size: size of one compression chunk
+ * @read_size: return, size of the uncompressed data read from @fd
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
+	unsigned int wsize = 0;
+	unsigned int csize;
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
+
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
+		r = read(fd, buf_from, chunk_size);
+		if (r < 0)
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

