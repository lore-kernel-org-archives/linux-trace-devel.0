Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A2BC433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Mar 2022 04:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbiCBEwW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Mar 2022 23:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbiCBEwW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Mar 2022 23:52:22 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5D9B0EA1
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Mar 2022 20:51:39 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id dr20so1204940ejc.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 01 Mar 2022 20:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i2StLPfrNnVqBIJte/hCLed9gvRr/hCO6p+GYBj3TMk=;
        b=CWMrGbQxl/mGfZzjxVkgSquGBcvfeb7ENNIasTGotg9d22qheS5aORfubhn35+A/3e
         Ms6S94bKc/suThWSGmFyU7CuYjxlbggoz6zOeMlLLlA4D/xHik4Bv+5QwOsH1R/9gT5z
         Ai55swWG8ENmTkdv5leOv4I5i//N4RYzGqOaBkgJyC/ZgNQFrUVfAzRlzQFLDMoXfNuz
         QWcvI2hXTl+PPfx/9lZjAz7quMfZ/j9ZStNuTivkSfegiw7NSDAFOtqDgOgO5kK3+E34
         kpNF469FsY9Lcxkkvb4Iu+VfDXMFk7NzAHEohrXhyJTU2v0DqgcO1nfBh4W6udHSZuLv
         6OMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2StLPfrNnVqBIJte/hCLed9gvRr/hCO6p+GYBj3TMk=;
        b=XKw5rcXsWrmBADowr6/ApaX5ZfmkzK24YzdYxyXruNHLXmGM6ts/AYRbeeI9G6PDhD
         Wqhv+WkhPU2OaLncyLrt0xmY//usUxaE+0Fhvl6nk3TrQld78EKO4NtmoQMeKbPbqV+a
         meMvve+VaG4uGTy7wJZDvVtIOedZI21k7Mmi9GBq8uB6BN8kT4pNxbx7aui9G9RZg/q6
         bioGPAzH/RElcKrGe8BQBPOgeDQwAXb+bMqSJLgkYo6QPf4CIRLObi2XLzPxLIaaHBT1
         FMCDuYZak6+En57nuVBGZKR8/gOUBJaabteO4MuxHiLJod9tEEFNig49NCeS3n1AkbMp
         6ooA==
X-Gm-Message-State: AOAM530y/mAcKkWMosX+fbS1eBnRPFkaRR8JVc9YPHMXYlIsiOvrauiR
        z2RD/hqOcQJ39AkBjD4tXGw=
X-Google-Smtp-Source: ABdhPJwrq00n42McEh/jHkQaUDzCXImBn8IKAixXMW23B1cYF+r5LoIiBjhPR5RJ2o7MyHLzG7Trzw==
X-Received: by 2002:a17:906:d94:b0:6d6:e113:2768 with SMTP id m20-20020a1709060d9400b006d6e1132768mr6252390eji.193.1646196697935;
        Tue, 01 Mar 2022 20:51:37 -0800 (PST)
Received: from oberon.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id ce7-20020a170906b24700b006cf095c2f5bsm5941036ejb.83.2022.03.01.20.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 20:51:37 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     sebastian@breakpoint.cc, linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/5] trace-cmd: Add context to compression hooks
Date:   Wed,  2 Mar 2022 06:51:30 +0200
Message-Id: <20220302045131.387658-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220302045131.387658-1-tz.stoyanov@gmail.com>
References: <20220302045131.387658-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some compression libraries require a context for compression and
decompression. Currently the internal compression API does not have such
context. That could cause problems in the future, if a multithread
compression logic is implemented.

Suggested-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  8 +++--
 lib/trace-cmd/trace-compress-zlib.c           |  6 ++--
 lib/trace-cmd/trace-compress-zstd.c           |  6 ++--
 lib/trace-cmd/trace-compress.c                | 33 +++++++++++++------
 4 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 45d89270..69343765 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -518,10 +518,12 @@ struct tracecmd_compression_proto {
 	int weight;
 	const char *name;
 	const char *version;
-	int (*compress)(const void *in, int in_bytes, void *out, int out_bytes);
-	int (*uncompress)(const void *in, int in_bytes, void *out, int out_bytes);
-	unsigned int (*compress_size)(unsigned int bytes);
+	int (*compress)(void *ctx, const void *in, int in_bytes, void *out, int out_bytes);
+	int (*uncompress)(void *ctx, const void *in, int in_bytes, void *out, int out_bytes);
+	unsigned int (*compress_size)(void *ctx, unsigned int bytes);
 	bool (*is_supported)(const char *name, const char *version);
+	void *(*new_context)(void);
+	void (*free_context)(void *ctx);
 };
 
 struct tracecmd_compression *tracecmd_compress_alloc(const char *name, const char *version,
diff --git a/lib/trace-cmd/trace-compress-zlib.c b/lib/trace-cmd/trace-compress-zlib.c
index 0dfd4f15..819a739d 100644
--- a/lib/trace-cmd/trace-compress-zlib.c
+++ b/lib/trace-cmd/trace-compress-zlib.c
@@ -13,7 +13,7 @@
 #define __ZLIB_NAME		"zlib"
 #define __ZLIB_WEIGTH		10
 
-static int zlib_compress(const void *in, int in_bytes, void *out, int out_bytes)
+static int zlib_compress(void *ctx, const void *in, int in_bytes, void *out, int out_bytes)
 {
 	unsigned long obytes = out_bytes;
 	int ret;
@@ -43,7 +43,7 @@ static int zlib_compress(const void *in, int in_bytes, void *out, int out_bytes)
 	return -1;
 }
 
-static int zlib_decompress(const void *in, int in_bytes, void *out, int out_bytes)
+static int zlib_decompress(void *ctx, const void *in, int in_bytes, void *out, int out_bytes)
 {
 	unsigned long obytes = out_bytes;
 	int ret;
@@ -73,7 +73,7 @@ static int zlib_decompress(const void *in, int in_bytes, void *out, int out_byte
 	return -1;
 }
 
-static unsigned int zlib_compress_bound(unsigned int in_bytes)
+static unsigned int zlib_compress_bound(void *ctx, unsigned int in_bytes)
 {
 	return compressBound(in_bytes);
 }
diff --git a/lib/trace-cmd/trace-compress-zstd.c b/lib/trace-cmd/trace-compress-zstd.c
index eee4e5d6..98eaac00 100644
--- a/lib/trace-cmd/trace-compress-zstd.c
+++ b/lib/trace-cmd/trace-compress-zstd.c
@@ -15,7 +15,7 @@
 static ZSTD_CCtx *ctx_c;
 static ZSTD_DCtx *ctx_d;
 
-static int zstd_compress(const void *in, int in_bytes, void *out, int out_bytes)
+static int zstd_compress(void *ctx, const void *in, int in_bytes, void *out, int out_bytes)
 {
 	size_t ret;
 
@@ -26,7 +26,7 @@ static int zstd_compress(const void *in, int in_bytes, void *out, int out_bytes)
 	return ret;
 }
 
-static int zstd_decompress(const void *in, int in_bytes, void *out, int out_bytes)
+static int zstd_decompress(void *ctx, const void *in, int in_bytes, void *out, int out_bytes)
 {
 	size_t ret;
 
@@ -40,7 +40,7 @@ static int zstd_decompress(const void *in, int in_bytes, void *out, int out_byte
 	return ret;
 }
 
-static unsigned int zstd_compress_bound(unsigned int in_bytes)
+static unsigned int zstd_compress_bound(void *ctx, unsigned int in_bytes)
 {
 	return ZSTD_compressBound(in_bytes);
 }
diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index 6263439c..9371d3cc 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -18,10 +18,12 @@ struct compress_proto {
 	char *proto_version;
 	int weight;
 
-	int (*compress_block)(const void *in, int in_bytes, void *out, int out_bytes);
-	int (*uncompress_block)(const void *in,  int in_bytes, void *out, int out_bytes);
-	unsigned int (*compress_size)(unsigned int bytes);
+	int (*compress_block)(void *ctx, const void *in, int in_bytes, void *out, int out_bytes);
+	int (*uncompress_block)(void *ctx, const void *in,  int in_bytes, void *out, int out_bytes);
+	unsigned int (*compress_size)(void *ctx, unsigned int bytes);
 	bool (*is_supported)(const char *name, const char *version);
+	void *(*new_context)(void);
+	void (*free_context)(void *ctx);
 };
 
 static struct compress_proto *proto_list;
@@ -35,6 +37,7 @@ struct tracecmd_compression {
 	struct compress_proto		*proto;
 	struct tep_handle		*tep;
 	struct tracecmd_msg_handle	*msg_handle;
+	void				*context;
 };
 
 static int read_fd(int fd, char *dst, int len)
@@ -271,7 +274,8 @@ int tracecmd_uncompress_block(struct tracecmd_compression *handle)
 	if (read_fd(handle->fd, bytes, s_compressed) < 0)
 		goto error;
 
-	ret = handle->proto->uncompress_block(bytes, s_compressed, handle->buffer, size);
+	ret = handle->proto->uncompress_block(handle->context,
+					      bytes, s_compressed, handle->buffer, size);
 	if (ret < 0)
 		goto error;
 
@@ -308,13 +312,13 @@ int tracecmd_compress_block(struct tracecmd_compression *handle)
 	    !handle->proto->compress_size || !handle->proto->compress_block)
 		return -1;
 
-	size = handle->proto->compress_size(handle->pointer);
+	size = handle->proto->compress_size(handle->context, handle->pointer);
 
 	buf = malloc(size);
 	if (!buf)
 		return -1;
 
-	ret = handle->proto->compress_block(handle->buffer, handle->pointer, buf, size);
+	ret = handle->proto->compress_block(handle->context, handle->buffer, handle->pointer, buf, size);
 	if (ret < 0)
 		goto out;
 
@@ -443,6 +447,9 @@ struct tracecmd_compression *tracecmd_compress_alloc(const char *name, const cha
 	new->tep = tep;
 	new->msg_handle = msg_handle;
 	new->proto = proto;
+	if (proto->new_context)
+		new->context = proto->new_context();
+
 	return new;
 }
 
@@ -453,6 +460,8 @@ struct tracecmd_compression *tracecmd_compress_alloc(const char *name, const cha
 void tracecmd_compress_destroy(struct tracecmd_compression *handle)
 {
 	tracecmd_compress_reset(handle);
+	if (handle->proto->free_context)
+		handle->proto->free_context(handle->context);
 	free(handle);
 }
 
@@ -546,6 +555,8 @@ int tracecmd_compress_proto_register(struct tracecmd_compression_proto *proto)
 	new->is_supported = proto->is_supported;
 	new->weight = proto->weight;
 	new->next = proto_list;
+	new->new_context = proto->new_context;
+	new->free_context = proto->free_context;
 	proto_list = new;
 	return 0;
 
@@ -672,7 +683,7 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 
 	if (read_size)
 		rmax = *read_size;
-	csize = handle->proto->compress_size(chunk_size);
+	csize = handle->proto->compress_size(handle->context, chunk_size);
 	buf_from = malloc(chunk_size);
 	if (!buf_from)
 		return -1;
@@ -706,7 +717,8 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 		rsize += all;
 		size = csize;
 		if (all > 0) {
-			ret = handle->proto->compress_block(buf_from, all, buf_to, size);
+			ret = handle->proto->compress_block(handle->context,
+							    buf_from, all, buf_to, size);
 			if (ret < 0) {
 				if (errno == EINTR)
 					continue;
@@ -863,7 +875,8 @@ int tracecmd_uncompress_chunk(struct tracecmd_compression *handle,
 	if (read_fd(handle->fd, bytes_in, chunk->zsize) < 0)
 		goto out;
 
-	if (handle->proto->uncompress_block(bytes_in, chunk->zsize, data, chunk->size) < 0)
+	if (handle->proto->uncompress_block(handle->context,
+					    bytes_in, chunk->zsize, data, chunk->size) < 0)
 		goto out;
 
 	ret = 0;
@@ -948,7 +961,7 @@ int tracecmd_uncompress_copy_to(struct tracecmd_compression *handle, int fd,
 			break;
 
 		rsize += s_compressed;
-		ret = handle->proto->uncompress_block(bytes_in, s_compressed,
+		ret = handle->proto->uncompress_block(handle->context, bytes_in, s_compressed,
 						      bytes_out, s_uncompressed);
 		if (ret < 0)
 			break;
-- 
2.34.1

