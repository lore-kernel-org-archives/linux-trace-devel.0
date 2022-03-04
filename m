Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5361EC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Mar 2022 05:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236045AbiCDF56 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 00:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236425AbiCDF5z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 00:57:55 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EE6EC5D7
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Mar 2022 21:57:08 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id r10so11058730wrp.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Mar 2022 21:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8FxFLGX1BEOBUVRtvIrxUM+uHMEWlXhooVRPrdsAHi4=;
        b=KUfhPDHSwqg2zPwf/kYUbWPBjl5rCjzyp+R9OctcYtKypSbkvDgx69SQf2IHL+E8mV
         RlFDXLXuu44JUje3BQDXQidDALUI3Z7oHKgKVfAT/L0uelnY4SrMp6wTB5wk5PCS2NRI
         mySaqB7dUhpqWtHCbPSNDOykPhY9AlAGT4tvX32AcXa4Hv4hulMqISqRE5AFe41qfRo5
         GuIEzwSv6AEv7kVeFl1rvoHzrgiAo57CMRWwUyatzWcfHHqt70nvQSCIFnTuNMg6or3Y
         MaguHt8F/uWIeCJHCB9FX5nTm5JhW7hmyisqSf+l9Hw2s7s0KmF5MrjkE5d1PFQQBnhR
         O40A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8FxFLGX1BEOBUVRtvIrxUM+uHMEWlXhooVRPrdsAHi4=;
        b=n96G8Cqa8p+n4/dzoUtwAJDFdaztqChA92/HqQ099agb2Akeo9QQskc74cvEFTE9+6
         Zq193zOMV3CWCkAoJjorqSHO58+VYP3nTcUMge9XIQj+ChwX0RFbig8L4BRYVp3K7hrn
         eptBW5FpCggzP62ifsX3AkdliTWT0kZf6sbRLOu7e7DDIyuEJFWODokMFdEGIO9MVLSG
         VKf1vbCXiIY48klfjlJjeD7C+ypwdmTNtKzmvxgDZnxUUndR05d1I8hBo9TsAJrpurqu
         QC5I4WioAQcuMkh3jguEpEnfAf2y5KQ3nluKjDY9WXzp0/0ZkQ6STMWhfefHXUwei7Rl
         lu3w==
X-Gm-Message-State: AOAM5336RMhNMeVeglrLlRhWIk+4b0nQla+oRmDYeQzBmQ4MRVdtzl3g
        aAMJO7oA231QIsWxV7OX/y7CTA9eKuI=
X-Google-Smtp-Source: ABdhPJxq6UDHg9oUSFk8Yr733Uaw7vRe6VWWr/NUU+1rVoAsw+iMmo4KP6CRuXNBaxZheOo+0wwc6Q==
X-Received: by 2002:adf:e74a:0:b0:1f0:25cb:3ad5 with SMTP id c10-20020adfe74a000000b001f025cb3ad5mr8425339wrn.231.1646373426711;
        Thu, 03 Mar 2022 21:57:06 -0800 (PST)
Received: from oberon.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r10-20020a05600c35ca00b0038981d85ae8sm505074wmq.33.2022.03.03.21.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 21:57:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     sebastian@breakpoint.cc, linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 5/5] trace-cmd: Use context hooks in zstd
Date:   Fri,  4 Mar 2022 07:56:58 +0200
Message-Id: <20220304055658.440904-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220304055658.440904-1-tz.stoyanov@gmail.com>
References: <20220304055658.440904-1-tz.stoyanov@gmail.com>
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

