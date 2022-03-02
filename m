Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F0E2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Mar 2022 04:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbiCBEwT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Mar 2022 23:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbiCBEwT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Mar 2022 23:52:19 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A5DB0EA2
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Mar 2022 20:51:36 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id kt27so1295343ejb.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 01 Mar 2022 20:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MC4hoUBaVwlPPqWyjN+arvEm9A5b+U/dTvzidU7cZec=;
        b=Ccy6MU5C0RQqj0dWG7/lICfl72uE5FTBNsueAaL7lC35Tu4QZz/+t/NxloPoNKnuLW
         PCBcPsPpTL4TUdnWU9TmQFXCVnoFQOTOjtQfLCJ+R3xxMT80l2TZJcHwwADFx3fozhjP
         1ArbrawteglpR46QZdcLOk957CtJ7/MQS2Le8upx13nuE+Sst654gDny6u3auNPd3J7j
         3E7JyUaZaFdHEi4FngZa65EzET/t7fLS1jEYCD7L12KBgNXtwYtzSwWhqESBkPKCWyUd
         5bduFxIp0TgUGCslgRQwKo56hq//MY1CmrGqPxdCJMwVOUM4ChycZEf3BujEaRZ1R9zp
         pfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MC4hoUBaVwlPPqWyjN+arvEm9A5b+U/dTvzidU7cZec=;
        b=AyvWtlsEf3TbtScPDTIK1WZ7BgpYpQE6IwF5UyBZW1e+V+mzX2cpgPOV30obc5Piez
         h9hbyqN9ksfV0wdkGwae+zV0tv5Xr+db+IS5D/gg/VcOHkGxNaJ+BBadtuGJ3DI7n0xM
         qBYY/2Bq+AlxdHZ/ZlsYYQlJN5f5QkvSQD5JLjqxhDrLEGCe4j+BinaLSYprE3/N4eFU
         jrY5zo6FMg8LxzXyhMJFN4QhI3MC45fN3nzAKJF5z4LmbM3XDArA63iHBKj/qXUIdsAh
         qQtW75lPgvtXgHOA8pLIg56JOUmQMeHXmMzZaJK+ADG0DiPZPdpIp/WmbADKqzNo4Itp
         tUcg==
X-Gm-Message-State: AOAM530C0nkhO+a17vltCn3gsu7GA5dAyErAU3V33UELgo2vrwINy5LS
        Rbnchxb5ZrIqtqa+Pf/NualDkyhibnM=
X-Google-Smtp-Source: ABdhPJxGTWJ5m70K8Tyua0YuhmNwnTtno2x6OFa0zeHWCX2Dke1tdCOPs5hPvdHnobIsBAxFzTQQ+g==
X-Received: by 2002:a17:907:6286:b0:6da:6e24:5e43 with SMTP id nd6-20020a170907628600b006da6e245e43mr36977ejc.449.1646196694979;
        Tue, 01 Mar 2022 20:51:34 -0800 (PST)
Received: from oberon.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id ce7-20020a170906b24700b006cf095c2f5bsm5941036ejb.83.2022.03.01.20.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 20:51:34 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     sebastian@breakpoint.cc, linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/5] trace-cmd: Use a structure to describe a compression protocol
Date:   Wed,  2 Mar 2022 06:51:27 +0200
Message-Id: <20220302045131.387658-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220302045131.387658-1-tz.stoyanov@gmail.com>
References: <20220302045131.387658-1-tz.stoyanov@gmail.com>
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

