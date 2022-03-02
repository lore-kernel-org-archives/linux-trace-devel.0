Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 524FDC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Mar 2022 04:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbiCBEwV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Mar 2022 23:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbiCBEwU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Mar 2022 23:52:20 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5B0B0EA2
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Mar 2022 20:51:38 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id qk11so1232851ejb.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 01 Mar 2022 20:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dspl58zuLJZ2K9EAHhG8wMD1O9GENFwPkvT9SD+t70U=;
        b=qPBzgH4LTMZC217MTB3zygazsaYOK3IXj+V7gt6uD63eWUti7aQ06N7AJLfIX7YsDK
         hM42yvP4ORD6T3WR6McwhHN6nmnDDEBLmJuhaQSyUsYefDihqDIwBfxN1rbzKJXrjcYu
         ozstCXi54GuRL+vesSybSiSoOv2uAiSUEokDnf0YHQh1h+KiUu177mhXfZeThZM/M6lf
         rQBxV9SF/1+BOYRTxtQPpZg/lasu91W+HU7KgDPQMUAoyjo2riXodygf4dj9kZYCMdpm
         BxaZWDpDJSP3F3zMTffHl8rR4Q6pga22W4qIzurihK4GgFY6RiVuXLCuqQzXczSTo/bd
         tiXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dspl58zuLJZ2K9EAHhG8wMD1O9GENFwPkvT9SD+t70U=;
        b=fq6HuAPcJhuYraD8a/MZ4lUXuszf9DEMQxMi05TkdlFZQAev2s3BZyUNIQsfZCU8MV
         vZ+KE88/B/acSofMrLIjcRON/2sbo3tQv62f+TY7l0mHEy3lei6YM3EZRNNR9kZt+UH2
         SJkKz/R97leicL/lqycvommqx5+oW+ynNGd/6NcbR10ejnQ0Zh5apWKZtYEIIqZgwUWR
         GDbpZxxiEqhCgqIlmFm3n/DdyNhVQLFph32fd+Sg6Gss/DErbdGvoMAlzwUEkCE/Rkhf
         GuKtIvWwcCJDXqRAQ5LEPu9wsdx/y2YEXVTpLEbt8CHlXYG3hBlfq+Yy8F82Sq3f68LE
         SdjA==
X-Gm-Message-State: AOAM530pbAHL99+LwRok4pVGX5yTw2EH43sNc1BUwpjg9RW3Uk8C/dlb
        Awg0UDrNsfa7tZQmem3woq4=
X-Google-Smtp-Source: ABdhPJxAJklHJ27LXYsVp0HQoApGXB4y2yDsx19g/HIsFO8A7LcmtYorrsGqWZodjL2WHy7Ua5j8/w==
X-Received: by 2002:a17:906:c405:b0:6ce:7100:8cf1 with SMTP id u5-20020a170906c40500b006ce71008cf1mr22759213ejz.722.1646196696806;
        Tue, 01 Mar 2022 20:51:36 -0800 (PST)
Received: from oberon.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id ce7-20020a170906b24700b006cf095c2f5bsm5941036ejb.83.2022.03.01.20.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 20:51:36 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     sebastian@breakpoint.cc, linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/5] trace-cmd: Use errno from zlib, if available
Date:   Wed,  2 Mar 2022 06:51:29 +0200
Message-Id: <20220302045131.387658-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220302045131.387658-1-tz.stoyanov@gmail.com>
References: <20220302045131.387658-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-compress-zlib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/trace-cmd/trace-compress-zlib.c b/lib/trace-cmd/trace-compress-zlib.c
index 41342597..0dfd4f15 100644
--- a/lib/trace-cmd/trace-compress-zlib.c
+++ b/lib/trace-cmd/trace-compress-zlib.c
@@ -33,6 +33,8 @@ static int zlib_compress(const void *in, int in_bytes, void *out, int out_bytes)
 	case Z_STREAM_ERROR:
 		errno = -EINVAL;
 		break;
+	case Z_ERRNO:
+		break;
 	default:
 		errno = -EFAULT;
 		break;
@@ -61,6 +63,8 @@ static int zlib_decompress(const void *in, int in_bytes, void *out, int out_byte
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

