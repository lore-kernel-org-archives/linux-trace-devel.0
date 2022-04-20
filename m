Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D95C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 15:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241421AbiDTPlW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 11:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235881AbiDTPlW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 11:41:22 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C634578A
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 08:38:35 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id n33-20020a17090a5aa400b001d28f5ee3f9so2365944pji.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 08:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xgK7rKaxDgrcczOp86KARt5j5UUJJkgW1zAPFzgwEpc=;
        b=fH8nsgrfc+xiuY5j3pZZze2rqA6m0wQuUcxxXs28TcmN248ROp2if/BxAyNRoRS8vG
         1inqVwFBaQBZQuRRznDRH3wv5soIhXkgOIuB5Fa9Ntj6mpEJfZZ8OcF1y8UNv5fe2DqL
         jt7pr7y7NY3O2yYJaOAUkOVRSQvoHg4Bhel77RaQY+gz8BcgxFwJovCBLhCu64eLRkY2
         quDtsLMCzs0cps+VQ1wdKLbDMff7PwAIBY/4zKSoNXI9rk29xw5pijC0AylEgBYj8FOh
         nG7gO6+SVaeERjRqMLjJMZxdWl6eeyHk3GCQbpUrTuJ379oXBwMDGyVsVLAia6pBUev+
         DOKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xgK7rKaxDgrcczOp86KARt5j5UUJJkgW1zAPFzgwEpc=;
        b=rSid9fogH8qiAew5cqtex7XyKmbf8aZQxG3VmDV8fpWYKzbH0Q8IKGjm8N7sBjyfqQ
         eg2aNixy3m783Ej0oDru0Jmj8N8wGJ/3YsEvsGX1oPtuc9O46Jpyc3Llv4aDUFODznCD
         VAnw25+xHv2AdxFKpYE9xUdpqB9ghvckTrzu86ly1gSrFGN/drDVw/zT+IX8ZzyTpArt
         9InZ/Eg9klM4uwXumPg9sWf73ZEU2xjgrZMbFl/ZFINevNc31NdETA34AHcgslVSokQ7
         J8BJ77mSoFLYXmwq57FKXMJX6Si/Wv08Dw1uYEIW0ZTwPQkPlusTyVqfVdOUrSvgnIZl
         RH0Q==
X-Gm-Message-State: AOAM533v9lpYHkKXaUJgqB5Z8RjrmMKEEzDfejfQ3JMQHxUAr6KX5Mwn
        1gQkPgbpNEeqzWgL5p43978=
X-Google-Smtp-Source: ABdhPJzGONsV6yKy7EraVol07AMx3yEQq2+P+AwNreWxN27kzm7fU8QWKcLg8Zb0uVxXDPNV5JKZxg==
X-Received: by 2002:a17:902:d70a:b0:158:7f07:e7c9 with SMTP id w10-20020a170902d70a00b001587f07e7c9mr21032202ply.109.1650469115358;
        Wed, 20 Apr 2022 08:38:35 -0700 (PDT)
Received: from localhost.localdomain ([14.100.48.186])
        by smtp.gmail.com with ESMTPSA id ay13-20020a056a00300d00b0050a5af3fbc7sm15296534pfb.220.2022.04.20.08.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 08:38:35 -0700 (PDT)
From:   Solomon Tan <wjsota@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] kernel-shark: Make FreeSans a compulsory component
Date:   Wed, 20 Apr 2022 23:38:26 +0800
Message-Id: <20220420153827.637413-1-wjsota@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <YmAkAE+5wy2mLncD@ArchDesktop>
References: <YmAkAE+5wy2mLncD@ArchDesktop>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch is proposed for two reasons.

Firstly, with reference to
https://lore.kernel.org/linux-trace-devel/Yl9WBztqKGD0PpmJ@ArchDesktop/
when the CMake does not detect FreeSans, it should cease generating the
Makefile since kernelshark requires FreeSans to output its graph
properly.

Secondly, when the make instructions on the README are followed, even
when FreeSans is not detected, `make` continues to compile and `make
install` (or `install_gui`) would install without indicating an error.
This gives the impression of a successful install, but `kernelshark`
will be missing.

Therefore, making CMake quit with error when FreeSans is not installed
solves these two issues.

Signed-off-by: Solomon Tan <wjsota@gmail.com>
---
 CMakeLists.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index e6a76d8..5473bfa 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -69,7 +69,7 @@ if (TT_FONT_FILE)
 
 else (TT_FONT_FILE)
 
-  message(WARNING "\nCould not find font ${KS_FONT}!\n")
+  message(FATAL_ERROR "\nCould not find font ${KS_FONT}!\n")
 
 endif (TT_FONT_FILE)
 
-- 
2.36.0

