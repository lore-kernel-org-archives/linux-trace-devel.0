Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 507E4C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Mar 2022 05:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiCDF5y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 00:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbiCDF5w (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 00:57:52 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B43EC5D7
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Mar 2022 21:57:05 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id j26so682200wrb.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Mar 2022 21:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FWAEPmib45XN5vMBOEv5P8Eu5JsJutcrBsuYJjzpe3c=;
        b=fpSvP/thLGi9a7/r5dq34uKQY4pmNGvPjpEZ6BLD/2yaMbv3nCtqOIGZS9nL/er2Ke
         SG66wUzntuEztJOsbs2JZfOqWqHjmJhoOkzYigTNOh4aun1ma+QZsHeJv521HWPsruhI
         uY9ywOPnF3JYMSuSUMia5fhkfgDT8e4A6M6GKQs5jaFrtR6j91r6h7paiqTxYtXpBVLI
         AGG78MdghrxWXAeppisUy/GDFBRZKOGVrrHZ4e15jljyG3n1U0vWg5MN6vETqpK1G6iV
         CKvjI+zdl/MzRSmDWRXex6eNs3kURb9byFV4UR1hI20SlUdWJy2oaVOF5bw5ki2hepN5
         9cUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FWAEPmib45XN5vMBOEv5P8Eu5JsJutcrBsuYJjzpe3c=;
        b=qt9L/l4c9c4pFTduw/rdCLBOz4lIvSSmgYow7Ewo/DrJemWL+OK/3RoLXXPPQ1N7K1
         1ubC5f6i8wZ+ogmZzmdq7ErcUgCb+Njo9oAB4j0OUqEoHMxuOS4rJLMr5ZPHOW2yj1TP
         bOMbShwFzRX7UjBC3DpI5jRFvNqYXMvHIHWRmACJCpgVBqHWdY2bkGHy2oAgzMrdYS53
         rmgaLFwUDRmqGCBOqLXHbGNMgpSHknKcoISJgr4NsY5lk30wE5MnKrI9l0d/95PgliE7
         8DA1e5DY4ors/v8MP2jAmlkbyM4pyDTAukFnNiYfQOzT6VC6zUuUjQh29OXFVzbeGihl
         4igw==
X-Gm-Message-State: AOAM531zuMmipbm3jFB3JYeRKd8Nd9+dWggufXdoQUWWdAxoGIEo8iBL
        WBQPZtC37AKgXC6GUODrMTiLrk7S0kY=
X-Google-Smtp-Source: ABdhPJwZkmATZhZLaozefkNmdCqrLksC5DVOreK/csgHbM/bVlKqWyl5nEPHiYzqTBua4PNLYsrYNQ==
X-Received: by 2002:a05:6000:178f:b0:1f0:4d60:1628 with SMTP id e15-20020a056000178f00b001f04d601628mr4681923wrg.40.1646373424445;
        Thu, 03 Mar 2022 21:57:04 -0800 (PST)
Received: from oberon.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r10-20020a05600c35ca00b0038981d85ae8sm505074wmq.33.2022.03.03.21.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 21:57:03 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     sebastian@breakpoint.cc, linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/5] trace-cmd: Use errno from zlib, if available
Date:   Fri,  4 Mar 2022 07:56:56 +0200
Message-Id: <20220304055658.440904-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220304055658.440904-1-tz.stoyanov@gmail.com>
References: <20220304055658.440904-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some zlib APIs set the errno in case of an error and return Z_ERRNO.
In these cases, errno should not be overwritten by the tarce-cmd zlib
wrappers.

Suggested-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-compress-zlib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-compress-zlib.c b/lib/trace-cmd/trace-compress-zlib.c
index 41342597..fd43d879 100644
--- a/lib/trace-cmd/trace-compress-zlib.c
+++ b/lib/trace-cmd/trace-compress-zlib.c
@@ -20,7 +20,6 @@ static int zlib_compress(const void *in, int in_bytes, void *out, int out_bytes)
 
 	ret = compress2((unsigned char *)out, &obytes,
 			(unsigned char *)in, (unsigned long)in_bytes, Z_BEST_COMPRESSION);
-	errno = 0;
 	switch (ret) {
 	case Z_OK:
 		return obytes;
@@ -33,6 +32,8 @@ static int zlib_compress(const void *in, int in_bytes, void *out, int out_bytes)
 	case Z_STREAM_ERROR:
 		errno = -EINVAL;
 		break;
+	case Z_ERRNO:
+		break;
 	default:
 		errno = -EFAULT;
 		break;
@@ -48,7 +49,6 @@ static int zlib_decompress(const void *in, int in_bytes, void *out, int out_byte
 
 	ret = uncompress((unsigned char *)out, &obytes,
 			 (unsigned char *)in, (unsigned long)in_bytes);
-	errno = 0;
 	switch (ret) {
 	case Z_OK:
 		return obytes;
@@ -61,6 +61,8 @@ static int zlib_decompress(const void *in, int in_bytes, void *out, int out_byte
 	case Z_DATA_ERROR:
 		errno = -EINVAL;
 		break;
+	case Z_ERRNO:
+		break;
 	default:
 		errno = -EFAULT;
 		break;
-- 
2.34.1

