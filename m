Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1F0C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Mar 2022 04:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbiCBEwX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Mar 2022 23:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbiCBEwW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Mar 2022 23:52:22 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490D5B0EA2
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Mar 2022 20:51:40 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id qx21so1146594ejb.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 01 Mar 2022 20:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8FxFLGX1BEOBUVRtvIrxUM+uHMEWlXhooVRPrdsAHi4=;
        b=GFllhzEiVfekNSt4psgymBJ9B8phQhEDWBQXaTHwtA3UHGqSkSNfcJT87p0YvFwb6G
         +qzv1tXt776cAKU5QXBlqC2o2/VPYWYV2bYIOo4DDff7MRbf79AKlvl2h6q2Nn4ybLqg
         pNQsOSZ35Tzf0+O2YC37P9Q2s7QQnfQi13bcZ9AKWdr/Ayu8omzLHTD8PuWMyI5rkwEq
         gNwn0immFLiflVe4ls/e0wnXAI4u7ZjqT4I7guOGmzcEyNjHys8sXtSIk+lR013voTOP
         xzbXy/3Op/uY5k04RKx+auLAAa1oLz+uVlNCpP+6lHPw5pqTzLj6+fdnT43YjkIMQKnC
         2jSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8FxFLGX1BEOBUVRtvIrxUM+uHMEWlXhooVRPrdsAHi4=;
        b=TL+b558QMpEg9Qu7LdHbhazpbytNO6FBrLF4KZQMu+/SFFE2nMzZAH5uOpLtFRvFp8
         k9cFwr44KEuborDzs+MXoI9atumaGuwcmhYEyEoL39fDn034Syqn/AG98MlPKsi5f/bb
         6zWjJD2l8f22Ii+cz+qLdVGQe5xVlyrwnUCnK1tJLJKQfm7k+LbLTcav3LplDXXvT1Fu
         06WaN0OLiL+P5apBUNFQRztZsje6oTvWtWFw/N1P9Nz3aHQhKv91VXogZMtVGCT3djVV
         Z/mcFmnIBwvfUxxVuO3IpNzGSG6Ug93lFGi9XZJ2DUsmoIEaOuaLYC47JTGu38i1fuBN
         hOXw==
X-Gm-Message-State: AOAM5337PcRTqwPPizbG9PId33Hba9C+ujxEu1yJuQsQqL8jXN1PMLtE
        Fbs4RY82B1jRIsxY7iRJMEI=
X-Google-Smtp-Source: ABdhPJzUT0syvsur3tFPqYAyp2VOh5t9K5G8uK+PQRx3MglZGL7jSTUS38E3pu+sZghGMuf8X+vNXA==
X-Received: by 2002:a17:906:30d1:b0:6cf:c116:c9d3 with SMTP id b17-20020a17090630d100b006cfc116c9d3mr20369344ejb.245.1646196698855;
        Tue, 01 Mar 2022 20:51:38 -0800 (PST)
Received: from oberon.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id ce7-20020a170906b24700b006cf095c2f5bsm5941036ejb.83.2022.03.01.20.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 20:51:38 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     sebastian@breakpoint.cc, linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/5] trace-cmd: Use context hooks in zstd
Date:   Wed,  2 Mar 2022 06:51:31 +0200
Message-Id: <20220302045131.387658-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220302045131.387658-1-tz.stoyanov@gmail.com>
References: <20220302045131.387658-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using global compression context could be a limitation in multithreaded
use cases. Use context hooks instead of global compression context.

Suggested-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-compress-zstd.c | 80 +++++++++++++++++++----------
 1 file changed, 54 insertions(+), 26 deletions(-)

diff --git a/lib/trace-cmd/trace-compress-zstd.c b/lib/trace-cmd/trace-compress-zstd.c
index 98eaac00..3e42fc79 100644
--- a/lib/trace-cmd/trace-compress-zstd.c
+++ b/lib/trace-cmd/trace-compress-zstd.c
@@ -12,14 +12,20 @@
 #define __ZSTD_NAME		"zstd"
 #define __ZSTD_WEIGTH		5
 
-static ZSTD_CCtx *ctx_c;
-static ZSTD_DCtx *ctx_d;
+struct zstd_context {
+	ZSTD_CCtx *ctx_c;
+	ZSTD_DCtx *ctx_d;
+};
 
 static int zstd_compress(void *ctx, const void *in, int in_bytes, void *out, int out_bytes)
 {
+	struct zstd_context *context = ctx;
 	size_t ret;
 
-	ret = ZSTD_compress2(ctx_c, out, out_bytes, in, in_bytes);
+	if (!ctx)
+		return -1;
+
+	ret = ZSTD_compress2(context->ctx_c, out, out_bytes, in, in_bytes);
 	if (ZSTD_isError(ret))
 		return -1;
 
@@ -28,9 +34,13 @@ static int zstd_compress(void *ctx, const void *in, int in_bytes, void *out, int
 
 static int zstd_decompress(void *ctx, const void *in, int in_bytes, void *out, int out_bytes)
 {
+	struct zstd_context *context = ctx;
 	size_t ret;
 
-	ret = ZSTD_decompressDCtx(ctx_d, out, out_bytes, in, in_bytes);
+	if (!ctx)
+		return -1;
+
+	ret = ZSTD_decompressDCtx(context->ctx_d, out, out_bytes, in, in_bytes);
 	if (ZSTD_isError(ret)) {
 		errno = -EINVAL;
 		return -1;
@@ -55,11 +65,46 @@ static bool zstd_is_supported(const char *name, const char *version)
 	return true;
 }
 
+static void *new_zstd_context(void)
+{
+	struct zstd_context *context;
+	size_t r;
+
+	context = calloc(1, sizeof(*context));
+	if (!context)
+		return NULL;
+
+	context->ctx_c = ZSTD_createCCtx();
+	context->ctx_d = ZSTD_createDCtx();
+	if (!context->ctx_c || !context->ctx_d)
+		goto err;
+
+	r = ZSTD_CCtx_setParameter(context->ctx_c, ZSTD_c_contentSizeFlag, 0);
+	if (ZSTD_isError(r))
+		goto err;
+
+	return context;
+err:
+	ZSTD_freeCCtx(context->ctx_c);
+	ZSTD_freeDCtx(context->ctx_d);
+	free(context);
+	return NULL;
+}
+static void free_zstd_context(void *ctx)
+{
+	struct zstd_context *context = ctx;
+
+	if (!ctx)
+		return;
+
+	ZSTD_freeCCtx(context->ctx_c);
+	ZSTD_freeDCtx(context->ctx_d);
+	free(context);
+}
+
 int tracecmd_zstd_init(void)
 {
 	struct tracecmd_compression_proto proto;
-	int ret = 0;
-	size_t r;
 
 	memset(&proto, 0, sizeof(proto));
 	proto.name = __ZSTD_NAME;
@@ -69,25 +114,8 @@ int tracecmd_zstd_init(void)
 	proto.uncompress = zstd_decompress;
 	proto.is_supported = zstd_is_supported;
 	proto.compress_size = zstd_compress_bound;
+	proto.new_context = new_zstd_context;
+	proto.free_context = free_zstd_context;
 
-	ctx_c = ZSTD_createCCtx();
-	ctx_d = ZSTD_createDCtx();
-	if (!ctx_c || !ctx_d)
-		goto err;
-
-	r = ZSTD_CCtx_setParameter(ctx_c, ZSTD_c_contentSizeFlag, 0);
-	if (ZSTD_isError(r))
-		goto err;
-
-	ret = tracecmd_compress_proto_register(&proto);
-	if (!ret)
-		return 0;
-err:
-	ZSTD_freeCCtx(ctx_c);
-	ZSTD_freeDCtx(ctx_d);
-	ctx_c = NULL;
-	ctx_d = NULL;
-	if (ret < 0)
-		return ret;
-	return -1;
+	return tracecmd_compress_proto_register(&proto);
 }
-- 
2.34.1

