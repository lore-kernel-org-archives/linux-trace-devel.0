Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78241C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Mar 2022 05:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbiCDF5y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 00:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiCDF5w (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 00:57:52 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FABEC5EA
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Mar 2022 21:57:04 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id j17so11122944wrc.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Mar 2022 21:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bHD1J2VTUF2CyUdXN6vH9kOhGNENn+EXQmTCEV5ycyM=;
        b=d0XSCrYM1tKgfPGe5rh/fF7XWXw1D0YhEy9ZvuA3iOKYDpi8/0zIckDnWmdfrGllCN
         elSeEKE2bruBwnYR1eHJQVVp9BRY4frq97+WjxCJ5fn6mDif6meJoMdodSWs41n8FsO/
         lM2MiD+QhR5mBZGGj5Saa3uWAfa4a48Sv1LTxVYlEzfWsF56R+jvfuv40dNGaGr6T40N
         yzRAHapTIFV+jAyh8AU/yJSvCVrpg4cdoMRB5qiFHpxAKlNxx2Vdot6Rz0QUCUEJo1w2
         HuWP+OE2QUJoJ17vO+6iOMCbCblM8CBgjhfJbLm2YTUHxCtxoyROeaDrwZW31wALoy1/
         3liA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bHD1J2VTUF2CyUdXN6vH9kOhGNENn+EXQmTCEV5ycyM=;
        b=aXz2Lr1mzIjxR/7goDxrVFsMla+BHZEso9fHAEh3sCUhd7GFIB2ziDMjDhjX3WUdks
         tocxA2kF8lmpuSqSFVJE2LW/e6qrE0/u2wFDzkvoYFflaF76AV//swFBbUOw+oBeWu/9
         mB4YIYfbpy4kpaoF9zAdI6W87WpQ7c/K9xAGvlMQrkQ0in8dERE5TajLoKBgSA6MrZWB
         IL7qK9vt3T4C2D/T4Iw4t17Tq5T0QOlD2/XVXQrAQMP2kULahGWp0xYF458/TaoE1rJ+
         8kkQKBKGZYVZR4tskJBVsSvFR/vrmkPoL+R4UIgDFzpgNCpvBxBplXRLKBO+2JlkaOwd
         wd3g==
X-Gm-Message-State: AOAM530ouIOcvFE1BVtVnEd4j/cMtkYNIyk7DJJfezaoLWtiEfm5WWdM
        NVj2vOA9SeK4ZCoH85hesgc=
X-Google-Smtp-Source: ABdhPJwDOpkrJW1eWrnBrBUYZi/okb+NKxMNd5rcf8wIYCiXFfVrLfgz5TViYIHvyoYO4tAP8z6bAw==
X-Received: by 2002:a05:6000:2a7:b0:1f0:b26a:38b with SMTP id l7-20020a05600002a700b001f0b26a038bmr430088wry.23.1646373423455;
        Thu, 03 Mar 2022 21:57:03 -0800 (PST)
Received: from oberon.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r10-20020a05600c35ca00b0038981d85ae8sm505074wmq.33.2022.03.03.21.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 21:57:02 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     sebastian@breakpoint.cc, linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/5] trace-cmd: Make internal compression hooks more generic
Date:   Fri,  4 Mar 2022 07:56:55 +0200
Message-Id: <20220304055658.440904-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220304055658.440904-1-tz.stoyanov@gmail.com>
References: <20220304055658.440904-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Changed the prototypes of trace-cmd internal compression API to be more
generic.

Suggested-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  4 +--
 lib/trace-cmd/trace-compress-zlib.c           | 20 +++++------
 lib/trace-cmd/trace-compress-zstd.c           | 18 +++++-----
 lib/trace-cmd/trace-compress.c                | 33 ++++++++-----------
 4 files changed, 32 insertions(+), 43 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 0ea37abc..45d89270 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -518,8 +518,8 @@ struct tracecmd_compression_proto {
 	int weight;
 	const char *name;
 	const char *version;
-	int (*compress)(const char *in, unsigned int in_bytes, char *out, unsigned int *out_bytes);
-	int (*uncompress)(const char *in, unsigned int in_bytes, char *out, unsigned int *out_bytes);
+	int (*compress)(const void *in, int in_bytes, void *out, int out_bytes);
+	int (*uncompress)(const void *in, int in_bytes, void *out, int out_bytes);
 	unsigned int (*compress_size)(unsigned int bytes);
 	bool (*is_supported)(const char *name, const char *version);
 };
diff --git a/lib/trace-cmd/trace-compress-zlib.c b/lib/trace-cmd/trace-compress-zlib.c
index 8b9758c9..41342597 100644
--- a/lib/trace-cmd/trace-compress-zlib.c
+++ b/lib/trace-cmd/trace-compress-zlib.c
@@ -13,19 +13,17 @@
 #define __ZLIB_NAME		"zlib"
 #define __ZLIB_WEIGTH		10
 
-static int zlib_compress(const char *in, unsigned int in_bytes,
-			 char *out, unsigned int *out_bytes)
+static int zlib_compress(const void *in, int in_bytes, void *out, int out_bytes)
 {
-	unsigned long out_size = *out_bytes;
+	unsigned long obytes = out_bytes;
 	int ret;
 
-	ret = compress2((unsigned char *)out, &out_size,
+	ret = compress2((unsigned char *)out, &obytes,
 			(unsigned char *)in, (unsigned long)in_bytes, Z_BEST_COMPRESSION);
-	*out_bytes = out_size;
 	errno = 0;
 	switch (ret) {
 	case Z_OK:
-		return 0;
+		return obytes;
 	case Z_BUF_ERROR:
 		errno = -ENOBUFS;
 		break;
@@ -43,19 +41,17 @@ static int zlib_compress(const char *in, unsigned int in_bytes,
 	return -1;
 }
 
-static int zlib_decompress(const char *in, unsigned int in_bytes,
-			   char *out, unsigned int *out_bytes)
+static int zlib_decompress(const void *in, int in_bytes, void *out, int out_bytes)
 {
-	unsigned long out_size = *out_bytes;
+	unsigned long obytes = out_bytes;
 	int ret;
 
-	ret = uncompress((unsigned char *)out, &out_size,
+	ret = uncompress((unsigned char *)out, &obytes,
 			 (unsigned char *)in, (unsigned long)in_bytes);
-	*out_bytes = out_size;
 	errno = 0;
 	switch (ret) {
 	case Z_OK:
-		return 0;
+		return obytes;
 	case Z_BUF_ERROR:
 		errno = -ENOBUFS;
 		break;
diff --git a/lib/trace-cmd/trace-compress-zstd.c b/lib/trace-cmd/trace-compress-zstd.c
index f99ad312..eee4e5d6 100644
--- a/lib/trace-cmd/trace-compress-zstd.c
+++ b/lib/trace-cmd/trace-compress-zstd.c
@@ -15,31 +15,29 @@
 static ZSTD_CCtx *ctx_c;
 static ZSTD_DCtx *ctx_d;
 
-static int zstd_compress(const char *in, unsigned int in_bytes,
-			 char *out, unsigned int *out_bytes)
+static int zstd_compress(const void *in, int in_bytes, void *out, int out_bytes)
 {
 	size_t ret;
 
-	ret = ZSTD_compress2(ctx_c, out, *out_bytes, in, in_bytes);
+	ret = ZSTD_compress2(ctx_c, out, out_bytes, in, in_bytes);
 	if (ZSTD_isError(ret))
 		return -1;
-	*out_bytes = ret;
-	return 0;
+
+	return ret;
 }
 
-static int zstd_decompress(const char *in, unsigned int in_bytes,
-			   char *out, unsigned int *out_bytes)
+static int zstd_decompress(const void *in, int in_bytes, void *out, int out_bytes)
 {
 	size_t ret;
 
-	ret = ZSTD_decompressDCtx(ctx_d, out, *out_bytes, in, in_bytes);
+	ret = ZSTD_decompressDCtx(ctx_d, out, out_bytes, in, in_bytes);
 	if (ZSTD_isError(ret)) {
 		errno = -EINVAL;
 		return -1;
 	}
-	*out_bytes = ret;
+
 	errno = 0;
-	return 0;
+	return ret;
 }
 
 static unsigned int zstd_compress_bound(unsigned int in_bytes)
diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index 66bfc356..6263439c 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -18,10 +18,8 @@ struct compress_proto {
 	char *proto_version;
 	int weight;
 
-	int (*compress_block)(const char *in, unsigned int in_bytes,
-			     char *out, unsigned int *out_bytes);
-	int (*uncompress_block)(const char *in, unsigned int in_bytes,
-				char *out, unsigned int *out_bytes);
+	int (*compress_block)(const void *in, int in_bytes, void *out, int out_bytes);
+	int (*uncompress_block)(const void *in,  int in_bytes, void *out, int out_bytes);
 	unsigned int (*compress_size)(unsigned int bytes);
 	bool (*is_supported)(const char *name, const char *version);
 };
@@ -273,15 +271,13 @@ int tracecmd_uncompress_block(struct tracecmd_compression *handle)
 	if (read_fd(handle->fd, bytes, s_compressed) < 0)
 		goto error;
 
-	s_uncompressed = size;
-	ret = handle->proto->uncompress_block(bytes, s_compressed,
-					      handle->buffer, &s_uncompressed);
-	if (ret)
+	ret = handle->proto->uncompress_block(bytes, s_compressed, handle->buffer, size);
+	if (ret < 0)
 		goto error;
 
 	free(bytes);
 	handle->pointer = 0;
-	handle->capacity_read = s_uncompressed;
+	handle->capacity_read = ret;
 	handle->capacity = size;
 	return 0;
 error:
@@ -318,12 +314,12 @@ int tracecmd_compress_block(struct tracecmd_compression *handle)
 	if (!buf)
 		return -1;
 
-	ret = handle->proto->compress_block(handle->buffer, handle->pointer, buf, &size);
+	ret = handle->proto->compress_block(handle->buffer, handle->pointer, buf, size);
 	if (ret < 0)
 		goto out;
 
 	/* Write compressed data size */
-	endian4 = tep_read_number(handle->tep, &size, 4);
+	endian4 = tep_read_number(handle->tep, &ret, 4);
 	ret = do_write(handle, &endian4, 4);
 	if (ret != 4)
 		goto out;
@@ -710,12 +706,13 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 		rsize += all;
 		size = csize;
 		if (all > 0) {
-			ret = handle->proto->compress_block(buf_from, all, buf_to, &size);
+			ret = handle->proto->compress_block(buf_from, all, buf_to, size);
 			if (ret < 0) {
 				if (errno == EINTR)
 					continue;
 				break;
 			}
+			size = ret;
 			/* Write compressed data size */
 			endian4 = tep_read_number(handle->tep, &size, 4);
 			ret = write_fd(handle->fd, &endian4, 4);
@@ -851,7 +848,6 @@ int tracecmd_uncompress_chunk(struct tracecmd_compression *handle,
 			      struct tracecmd_compress_chunk *chunk, char *data)
 {
 	char *bytes_in = NULL;
-	unsigned int size;
 	int ret = -1;
 
 	if (!handle || !handle->proto || !handle->proto->uncompress_block || !chunk || !data)
@@ -867,8 +863,7 @@ int tracecmd_uncompress_chunk(struct tracecmd_compression *handle,
 	if (read_fd(handle->fd, bytes_in, chunk->zsize) < 0)
 		goto out;
 
-	size = chunk->size;
-	if (handle->proto->uncompress_block(bytes_in, chunk->zsize, data, &size))
+	if (handle->proto->uncompress_block(bytes_in, chunk->zsize, data, chunk->size) < 0)
 		goto out;
 
 	ret = 0;
@@ -954,12 +949,12 @@ int tracecmd_uncompress_copy_to(struct tracecmd_compression *handle, int fd,
 
 		rsize += s_compressed;
 		ret = handle->proto->uncompress_block(bytes_in, s_compressed,
-						      bytes_out, &s_uncompressed);
-		if (ret)
+						      bytes_out, s_uncompressed);
+		if (ret < 0)
 			break;
 
-		write_fd(fd, bytes_out, s_uncompressed);
-		wsize += s_uncompressed;
+		write_fd(fd, bytes_out, ret);
+		wsize += ret;
 		chunks--;
 	}
 	free(bytes_in);
-- 
2.34.1

