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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36F1C43460
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9AFE61186
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhETDVu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbhETDVt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:49 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9416C06175F
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:28 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id lg14so22930606ejb.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3SuOgqaLVIFlZcKjsmKN3FpRA1xd7G9h6G1W6+B2JeA=;
        b=PZUp5UKNFH995leNxVsPFNvP2oo541nnHi9aRVIwPYpSoLgOF/CajHhchnziS1f9ve
         AyPejXhbj24FiQnIlzo3gG8vwdA+bWKfKZyfPOJ50xQ1S10cLnTi9KGWSDAnda3Au/kr
         70JckuRmVbQ0805anlXYjgokOVLnzhGgel/fx9XLZzds5d69Afg3Dug8HGfWvGLUolQ9
         u2zyTBJYpaUgFqaktB4hh54IOL/tCOEamZ2hog5pNFnTrYNsMoxdPXneKmIQEEpbpdc+
         lwcyVa0ASoHVlKfltrKFNkZC+BZ8r9pjZ7A+VB2r822YXl41yWV32ancwDG60JnO9QYv
         1UDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3SuOgqaLVIFlZcKjsmKN3FpRA1xd7G9h6G1W6+B2JeA=;
        b=IstKBIuC5BbCq3vNZ0ADjhOqFGD/7Ic6iHRHX0Vb5bAZktsu1N9wro5aaQqXdk3FCN
         L++HtrYXsD+kE6G3EOLf2884KezeJBcegQyhDGdl6syBICsZyOnMqWml42ZLfhQT7qIA
         jE7XN3eRQ4szR+y/lx2J1Udjgh+RyJNyC3+258mTygf1BUJlSEeDA1Ue3KcYLi+lOkLn
         hrFmhPN2C8debnLZdVe9kCk6v2aQpxeqLl0mWoMFVmK8DjpC1RzIZY9wmxzc54kXd/n+
         0zeGpE1cNKAiinZgjktQ1Ix9zEy8HvAZLix62Dt2E6TFKQKpRoaAigc1gtG499pTbi4J
         nv0g==
X-Gm-Message-State: AOAM531gIsp1aX5dIKBAZXejX6sU9QlsFnq6MKghRKYjXtvaNFx/FSJL
        KU5VzO2Gdjp0xqyjqXq0EO4=
X-Google-Smtp-Source: ABdhPJxdOVK7YdU78RvIWtCgFrpRxfZ+raVGK9IIzqYEmtY/IcIncuteKKI0gWRrWEhvZ2deNo4GbA==
X-Received: by 2002:a17:906:4c8c:: with SMTP id q12mr2459440eju.254.1621480827468;
        Wed, 19 May 2021 20:20:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 23/29] trace-cmd library: Add APIs for read and write compressed data in chunks
Date:   Thu, 20 May 2021 06:19:53 +0300
Message-Id: <20210520031959.346165-24-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
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
index 2c28ee04..19dc9e05 100644
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

