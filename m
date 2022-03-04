Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B90A9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Mar 2022 05:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbiCDF57 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 00:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236265AbiCDF5y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 00:57:54 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8A1EC5DC
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Mar 2022 21:57:07 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id i9-20020a1c3b09000000b00380f6f473b0so232288wma.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Mar 2022 21:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=71i7Wft610lYhRSTxxvgqEXn/8Ru22/+yKbd1RBssnQ=;
        b=JHetttTNycAGzds3Ov831jjUpHE5gwzCEx3oNAiLTzO4cu51cCXHQEwsj/yVtasrey
         QYaXJfgQOMcv8I0uCR6C25iBaLsesk+XiCgRMUVlycAl7zbvkQCwGEOKZLcHMyDy8jq6
         afdwl6B0cAb3G7MV8oM7H+HsfcvHjZGnsSwyrYtFd8RfdiA1/wXWQ90PvbjxBF9IpcMN
         mU7BbtXw4x5yVOZFE5CUZp4C+QklOac5p2MHpet/Od8QpMUbqBmX/RjBDH2kpOz0q1jE
         N+mIivnXd0kqbXUHLpfrT3rZ+E1lxc8B/3jG9EMelz7MlrS1/9jutjWU6nSit3BVKQ0x
         J0mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=71i7Wft610lYhRSTxxvgqEXn/8Ru22/+yKbd1RBssnQ=;
        b=adoE/RGCcYuGPDAaAAEMD0XgaFcq9tUnpTts8Qwax/rWU7TjmeNv6hSS1G//HZ2jfx
         Wowj4OIfHKyOB65rtK54H0tuoy8jCVd0ifL3WMik8e9QPd3sMWK05nM4DwZ7V8fCIkUC
         lgwPMXMdR+FZGxfOVzVW1J+TEqxweK0hkzB25fPGzEvGFMi1OEOGLcoXCN3OLrVejbDf
         awISp/2H7SHg/s9sFjNiiPFR2X+/1CAimgEjzfTcZRJ0ymJsJrOo78XHHH5a9kJX8I1i
         Y5gOeJ1CJHxhI34HyOJl+dvTd9ix8TDVNI6MnOl05RTj7mlFEQOaKzDXAQ6GWhwZ8LqQ
         ZF2w==
X-Gm-Message-State: AOAM532kM9vLlAzeUGgrUnwai26ycT6s+hk80gKvPMeoyb4yWaFygG53
        TpmVjqM5zvzB7FquPUwLnsy1V6LOALY=
X-Google-Smtp-Source: ABdhPJwYRa8gcVCdl6+49VHBz09oc388BdCunnerTQ6t9kWbb8vBJsrB6N7d1GKvI/viU2uPZ3NIOQ==
X-Received: by 2002:a1c:ed1a:0:b0:37f:a539:5d5e with SMTP id l26-20020a1ced1a000000b0037fa5395d5emr6393249wmh.37.1646373425668;
        Thu, 03 Mar 2022 21:57:05 -0800 (PST)
Received: from oberon.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r10-20020a05600c35ca00b0038981d85ae8sm505074wmq.33.2022.03.03.21.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 21:57:05 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     sebastian@breakpoint.cc, linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/5] trace-cmd: Add context to compression hooks
Date:   Fri,  4 Mar 2022 07:56:57 +0200
Message-Id: <20220304055658.440904-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220304055658.440904-1-tz.stoyanov@gmail.com>
References: <20220304055658.440904-1-tz.stoyanov@gmail.com>
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
 .../include/private/trace-cmd-private.h       |  8 ++--
 lib/trace-cmd/trace-compress-zlib.c           |  6 +--
 lib/trace-cmd/trace-compress-zstd.c           |  6 +--
 lib/trace-cmd/trace-compress.c                | 38 ++++++++++++++-----
 4 files changed, 39 insertions(+), 19 deletions(-)

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
index fd43d879..413a0764 100644
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
@@ -42,7 +42,7 @@ static int zlib_compress(const void *in, int in_bytes, void *out, int out_bytes)
 	return -1;
 }
 
-static int zlib_decompress(const void *in, int in_bytes, void *out, int out_bytes)
+static int zlib_decompress(void *ctx, const void *in, int in_bytes, void *out, int out_bytes)
 {
 	unsigned long obytes = out_bytes;
 	int ret;
@@ -71,7 +71,7 @@ static int zlib_decompress(const void *in, int in_bytes, void *out, int out_byte
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
index 6263439c..aa03d17c 100644
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
 
@@ -452,7 +459,14 @@ struct tracecmd_compression *tracecmd_compress_alloc(const char *name, const cha
  */
 void tracecmd_compress_destroy(struct tracecmd_compression *handle)
 {
+	if (!handle)
+		return;
+
 	tracecmd_compress_reset(handle);
+
+	if (handle->proto && handle->proto->free_context)
+		handle->proto->free_context(handle->context);
+
 	free(handle);
 }
 
@@ -546,6 +560,8 @@ int tracecmd_compress_proto_register(struct tracecmd_compression_proto *proto)
 	new->is_supported = proto->is_supported;
 	new->weight = proto->weight;
 	new->next = proto_list;
+	new->new_context = proto->new_context;
+	new->free_context = proto->free_context;
 	proto_list = new;
 	return 0;
 
@@ -672,7 +688,7 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 
 	if (read_size)
 		rmax = *read_size;
-	csize = handle->proto->compress_size(chunk_size);
+	csize = handle->proto->compress_size(handle->context, chunk_size);
 	buf_from = malloc(chunk_size);
 	if (!buf_from)
 		return -1;
@@ -706,7 +722,8 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 		rsize += all;
 		size = csize;
 		if (all > 0) {
-			ret = handle->proto->compress_block(buf_from, all, buf_to, size);
+			ret = handle->proto->compress_block(handle->context,
+							    buf_from, all, buf_to, size);
 			if (ret < 0) {
 				if (errno == EINTR)
 					continue;
@@ -863,7 +880,8 @@ int tracecmd_uncompress_chunk(struct tracecmd_compression *handle,
 	if (read_fd(handle->fd, bytes_in, chunk->zsize) < 0)
 		goto out;
 
-	if (handle->proto->uncompress_block(bytes_in, chunk->zsize, data, chunk->size) < 0)
+	if (handle->proto->uncompress_block(handle->context,
+					    bytes_in, chunk->zsize, data, chunk->size) < 0)
 		goto out;
 
 	ret = 0;
@@ -948,7 +966,7 @@ int tracecmd_uncompress_copy_to(struct tracecmd_compression *handle, int fd,
 			break;
 
 		rsize += s_compressed;
-		ret = handle->proto->uncompress_block(bytes_in, s_compressed,
+		ret = handle->proto->uncompress_block(handle->context, bytes_in, s_compressed,
 						      bytes_out, s_uncompressed);
 		if (ret < 0)
 			break;
-- 
2.34.1

