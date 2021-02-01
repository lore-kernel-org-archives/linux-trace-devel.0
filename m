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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6326C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92E1964E54
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhBARZN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbhBARY5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:24:57 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1279EC061756
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:15 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id kg20so25634900ejc.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G4XnnSPEFwz6ybwMmQh5Ff1BkSFr87krInZBmQ1upb8=;
        b=cbXJxF4k3MUbRW5hTTdIfUOv93gs9koqFP4ermPTR8ItqW6HGi6qv5C4V61Vj5EXfI
         6hDI85R9m7mtfyVmk4qlMDCuvOCf6K0lGjwPuaHh3C4Z37h5+00rws+Ke7EI+SFXpCok
         yGpVMkQTqC8LtO0nNKQKh2Ntl973Abxz2u8e8YoAbjfjlYTHp0oRF8Wf0HaHte9O+Woq
         sz1iFEWua2NQ8MnbI9s+ou/TAkfVzSiO6IXH/YR8dxrMt+oT7YC4SGmIkEEjseAEuvQe
         7fyIPXKNAO+gkVth2SQyi6um3tYje1VEzhrPlUhTlGJurI82e0tS0W/ZzztSmJRtYpnz
         Sa5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G4XnnSPEFwz6ybwMmQh5Ff1BkSFr87krInZBmQ1upb8=;
        b=UT0QxOAbvtp4vAuBCSjBiQ+ptpVIQzUAoKuKz1yWv/9HMyXEuGObdBwP3OgkpnIwkT
         BeSFPg8grj797gjBIzJfmfqJqDBmtxjb2vTEGqooH8aFurELlpFNPEwjEC8sblIMy/zH
         a/880dfPJGkmyeDVCYYYoPhZoerD7E3XiKgUT0BZSLJ5j65b7u57x3aDW0k7lr5XaBNG
         /91v81oovvoL5RqT/EFhK5fkMhY2QqLMF+0yRtpJydYGG+WvgWlrIDHzWrPyOKrdd8mT
         Na7PN48dW06hZJ28kUFLnSN8PkE6mSRrpIFFePP4UUGigPa3iOWyPbn+yCp+Tj0ZGvjy
         dleg==
X-Gm-Message-State: AOAM533ZoMl506VTQvo4wQ+p0IvKvvj+va/AM4cfQa4CKAA36PfQoQTo
        g9AUvM+dyscCw0eMBwNHWznd4BcKMEs=
X-Google-Smtp-Source: ABdhPJwwEVuIycGJCYlVs9+D0WpffGBpGUur4Y4GsCN7oKQj0QIODVRPVbU1DnXCIWCHAfrdQnV63g==
X-Received: by 2002:a17:907:7295:: with SMTP id dt21mr19114150ejc.518.1612200253851;
        Mon, 01 Feb 2021 09:24:13 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:13 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 02/24] kernel-shark: Do proper reset in kshark_close_all()
Date:   Mon,  1 Feb 2021 19:23:36 +0200
Message-Id: <20210201172358.175407-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The function is supposed to close all Data streams and reset the
session context object (kshark_ctx). However, this is not happening
completely, because after closing the individual streams, the context
still contains the history of all closed stream Ids, recorded inside
the array of data stream descriptors. In this patch we add a proper
resetting of this array and its info descriptor.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/src/libkshark.c b/src/libkshark.c
index c57ca01..dc58dcf 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -37,6 +37,7 @@ static bool kshark_default_context(struct kshark_context **context)
 	kshark_ctx->stream = calloc(KS_DEFAULT_NUM_STREAMS,
 				    sizeof(*kshark_ctx->stream));
 	kshark_ctx->stream_info.array_size = KS_DEFAULT_NUM_STREAMS;
+	kshark_ctx->stream_info.next_free_stream_id = 0;
 	kshark_ctx->stream_info.max_stream_id = -1;
 
 	/* Will free kshark_context_handler. */
@@ -484,10 +485,22 @@ int kshark_close(struct kshark_context *kshark_ctx, int sd)
  */
 void kshark_close_all(struct kshark_context *kshark_ctx)
 {
+	size_t mem_reset_size;
 	int i;
 
+	if (kshark_ctx->stream_info.max_stream_id < 0)
+		return;
+
 	for (i = 0; i <= kshark_ctx->stream_info.max_stream_id; ++i)
 		kshark_close(kshark_ctx, i);
+
+	/* Reset the array of data stream descriptors. */
+	mem_reset_size = (kshark_ctx->stream_info.max_stream_id + 1 ) *
+			 sizeof(*kshark_ctx->stream);
+	memset(kshark_ctx->stream, 0, mem_reset_size);
+
+	kshark_ctx->stream_info.next_free_stream_id = 0;
+	kshark_ctx->stream_info.max_stream_id = -1;
 }
 
 /**
-- 
2.25.1

