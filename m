Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C55BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Mar 2022 05:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236196AbiCDF5x (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 00:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235836AbiCDF5v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 00:57:51 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56BBEC5DC
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Mar 2022 21:57:03 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id u10so9408026wra.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Mar 2022 21:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MC4hoUBaVwlPPqWyjN+arvEm9A5b+U/dTvzidU7cZec=;
        b=atbN12J3q1/l+kX+u8LOV0Dk/vvMPsPfOnFAEV4pPgFQivCc8Qb1qQaVDGfQzA2/6p
         YfYVTqO/SSGh+XMdI5giqnlZfCFKOvb6XZJnlCPaLMI2heZs5DWwhSfRoNBJLu46keC5
         1dQzEet3226IvtmR77yMCN/gmMSdyB61W3AogGya3uv8UGv8jT3UFvb/WJE1NH81iKTJ
         YOCUy3+0V4bxtLqeMt3u7klVwhZ9sehnDGLWrawA4/UBVc1sYhAEyPq8JtNuMub3JON6
         HbO4saxOESvkJdtwnI88nKHGglOLk0xxeqRYerCI9d2JnlWM1PfZmJ9udnJ7oqEc35wT
         t8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MC4hoUBaVwlPPqWyjN+arvEm9A5b+U/dTvzidU7cZec=;
        b=dPTGgFmYnQboJ0SVWF1FMwxyhfu4XrimgFDaPIXQ4aZPM6LB+6Un2psc3jWCmo6jVN
         S+dT184uOmZhngDLsV5awT33iPAisjT4gOv7K8sqgR5RnPPBroL8NMUKwLY6VpZeuPxD
         H5xHUWgK4Avy1zOIppW/3u0S1Jc/Z7yufNo4gL1x0Bm47izYo+w2cVsyOVwzA+P0BW6w
         RTQiaBvpJEPFuOpN6Nh+AM783SkxZeUVFUsAb+B0YhYrCbUz2grKDQUX/cnVM+k2uuex
         0K3N5bedN2O9/AXop2x7rw+yqQXTvlv1OsP2L277UX+Sv7xjfipRirx4zMbPBanvdU+L
         UFKA==
X-Gm-Message-State: AOAM531McTXb6ISh6bk71MUF/RjhspOPQGeeEl59mJ3sanCgRzS5FMNC
        0+RusPKFT591du/ouMbki/QfEIMmrWg=
X-Google-Smtp-Source: ABdhPJyrieslXKQ0Hv0dOrgDRf37kFNPC3aSNd414xIkWnUXkDTwZGxqoWqTx3Bf6MR6dLIpRQJ+aw==
X-Received: by 2002:adf:e4cb:0:b0:1f0:3429:8386 with SMTP id v11-20020adfe4cb000000b001f034298386mr7750536wrm.177.1646373422259;
        Thu, 03 Mar 2022 21:57:02 -0800 (PST)
Received: from oberon.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r10-20020a05600c35ca00b0038981d85ae8sm505074wmq.33.2022.03.03.21.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 21:57:01 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     sebastian@breakpoint.cc, linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/5] trace-cmd: Use a structure to describe a compression protocol
Date:   Fri,  4 Mar 2022 07:56:54 +0200
Message-Id: <20220304055658.440904-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220304055658.440904-1-tz.stoyanov@gmail.com>
References: <20220304055658.440904-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Changed the tracecmd_compress_proto_register() function to use a
structure instead of list of arguments to describe new compression
protocol. That approach is more flexible and allows to extend the API in
the future without changing the already implemented protocols.

Suggested-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       | 18 ++++++++-----
 lib/trace-cmd/trace-compress-zlib.c           | 15 ++++++++---
 lib/trace-cmd/trace-compress-zstd.c           | 18 ++++++++-----
 lib/trace-cmd/trace-compress.c                | 26 +++++++------------
 4 files changed, 44 insertions(+), 33 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index d229b264..0ea37abc 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -514,6 +514,16 @@ struct tracecmd_compress_chunk {
 	off64_t			offset;
 };
 struct tracecmd_compression;
+struct tracecmd_compression_proto {
+	int weight;
+	const char *name;
+	const char *version;
+	int (*compress)(const char *in, unsigned int in_bytes, char *out, unsigned int *out_bytes);
+	int (*uncompress)(const char *in, unsigned int in_bytes, char *out, unsigned int *out_bytes);
+	unsigned int (*compress_size)(unsigned int bytes);
+	bool (*is_supported)(const char *name, const char *version);
+};
+
 struct tracecmd_compression *tracecmd_compress_alloc(const char *name, const char *version,
 						     int fd, struct tep_handle *tep,
 						     struct tracecmd_msg_handle *msg_handle);
@@ -530,13 +540,7 @@ int tracecmd_compress_proto_get_name(struct tracecmd_compression *compress,
 				     const char **name, const char **version);
 bool tracecmd_compress_is_supported(const char *name, const char *version);
 int tracecmd_compress_protos_get(char ***names, char ***versions);
-int tracecmd_compress_proto_register(const char *name, const char *version, int weight,
-				     int (*compress)(const char *in, unsigned int in_bytes,
-						     char *out, unsigned int *out_bytes),
-				     int (*uncompress)(const char *in, unsigned int in_bytes,
-						       char *out, unsigned int *out_bytes),
-				     unsigned int (*comress_size)(unsigned int bytes),
-				     bool (*is_supported)(const char *name, const char *version));
+int tracecmd_compress_proto_register(struct tracecmd_compression_proto *proto);
 int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int chunk_size,
 				unsigned long long *read_size, unsigned long long *write_size);
 int tracecmd_uncompress_copy_to(struct tracecmd_compression *handle, int fd,
diff --git a/lib/trace-cmd/trace-compress-zlib.c b/lib/trace-cmd/trace-compress-zlib.c
index a697cc61..8b9758c9 100644
--- a/lib/trace-cmd/trace-compress-zlib.c
+++ b/lib/trace-cmd/trace-compress-zlib.c
@@ -103,7 +103,16 @@ static bool zlib_is_supported(const char *name, const char *version)
 
 int tracecmd_zlib_init(void)
 {
-	return tracecmd_compress_proto_register(__ZLIB_NAME, zlibVersion(), __ZLIB_WEIGTH,
-						zlib_compress, zlib_decompress,
-						zlib_compress_bound, zlib_is_supported);
+	struct tracecmd_compression_proto proto;
+
+	memset(&proto, 0, sizeof(proto));
+	proto.name = __ZLIB_NAME;
+	proto.version = zlibVersion();
+	proto.weight = __ZLIB_WEIGTH;
+	proto.compress = zlib_compress;
+	proto.uncompress = zlib_decompress;
+	proto.is_supported = zlib_is_supported;
+	proto.compress_size = zlib_compress_bound;
+
+	return tracecmd_compress_proto_register(&proto);
 }
diff --git a/lib/trace-cmd/trace-compress-zstd.c b/lib/trace-cmd/trace-compress-zstd.c
index fc5e350f..f99ad312 100644
--- a/lib/trace-cmd/trace-compress-zstd.c
+++ b/lib/trace-cmd/trace-compress-zstd.c
@@ -59,9 +59,19 @@ static bool zstd_is_supported(const char *name, const char *version)
 
 int tracecmd_zstd_init(void)
 {
+	struct tracecmd_compression_proto proto;
 	int ret = 0;
 	size_t r;
 
+	memset(&proto, 0, sizeof(proto));
+	proto.name = __ZSTD_NAME;
+	proto.version = ZSTD_versionString();
+	proto.weight = __ZSTD_WEIGTH;
+	proto.compress = zstd_compress;
+	proto.uncompress = zstd_decompress;
+	proto.is_supported = zstd_is_supported;
+	proto.compress_size = zstd_compress_bound;
+
 	ctx_c = ZSTD_createCCtx();
 	ctx_d = ZSTD_createDCtx();
 	if (!ctx_c || !ctx_d)
@@ -71,13 +81,7 @@ int tracecmd_zstd_init(void)
 	if (ZSTD_isError(r))
 		goto err;
 
-	ret = tracecmd_compress_proto_register(__ZSTD_NAME,
-					       ZSTD_versionString(),
-					       __ZSTD_WEIGTH,
-					       zstd_compress,
-					       zstd_decompress,
-					       zstd_compress_bound,
-					       zstd_is_supported);
+	ret = tracecmd_compress_proto_register(&proto);
 	if (!ret)
 		return 0;
 err:
diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index 4fca7019..66bfc356 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -522,39 +522,33 @@ int tracecmd_compress_proto_get_name(struct tracecmd_compression *compress,
  * Returns 0 on success, or -1 in case of an error. If algorithm with given name
  * and version is already registered, -1 is returned.
  */
-int tracecmd_compress_proto_register(const char *name, const char *version, int weight,
-				     int (*compress)(const char *in, unsigned int in_bytes,
-						     char *out, unsigned int *out_bytes),
-				     int (*uncompress)(const char *in, unsigned int in_bytes,
-						       char *out, unsigned int *out_bytes),
-				     unsigned int (*compress_size)(unsigned int bytes),
-				     bool (*is_supported)(const char *name, const char *version))
+int tracecmd_compress_proto_register(struct tracecmd_compression_proto *proto)
 {
 	struct compress_proto *new;
 
-	if (!name || !compress || !uncompress)
+	if (!proto || !proto->name || !proto->compress || !proto->uncompress)
 		return -1;
 
-	if (tracecmd_compress_is_supported(name, version))
+	if (tracecmd_compress_is_supported(proto->name, proto->version))
 		return -1;
 
 	new = calloc(1, sizeof(*new));
 	if (!new)
 		return -1;
 
-	new->proto_name = strdup(name);
+	new->proto_name = strdup(proto->name);
 	if (!new->proto_name)
 		goto error;
 
-	new->proto_version = strdup(version);
+	new->proto_version = strdup(proto->version);
 	if (!new->proto_version)
 		goto error;
 
-	new->compress_block = compress;
-	new->uncompress_block = uncompress;
-	new->compress_size = compress_size;
-	new->is_supported = is_supported;
-	new->weight = weight;
+	new->compress_block = proto->compress;
+	new->uncompress_block = proto->uncompress;
+	new->compress_size = proto->compress_size;
+	new->is_supported = proto->is_supported;
+	new->weight = proto->weight;
 	new->next = proto_list;
 	proto_list = new;
 	return 0;
-- 
2.34.1

