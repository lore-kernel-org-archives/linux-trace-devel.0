Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAF1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Apr 2022 11:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240052AbiDZLgS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Apr 2022 07:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238202AbiDZLgS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Apr 2022 07:36:18 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34A1CD679
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Apr 2022 04:33:10 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d5so9828512wrb.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Apr 2022 04:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n4BgfHqwdqI3YqWQFctUtjcxlGXw7vpzj8vy+lT8WF4=;
        b=ZdW2GycSR0vIMNf7P6Wmls9gc7iVG4A8f+Af3HC/h0dFQsN5Wjhtl9hsZR/jffY/k2
         conueUQ9UDfxqEIhCMpsyX9HvOZqHtJnaitV/Pl8IO2Vd5pRb8qU9sPZJR8vN0RNvSBq
         KsAsGEI7pPlp4Q0s0PFQrK0H0IQ6XYd7826Vgf030UeEasFiPgnWI5FRxZRgiEHNs+e4
         kkJTLa0jOb5KLUIcBOB36dl9iMK867sZupR+U/NLAe6FeNPvJq7T6fzWvmgnyYvRZ+Wm
         4K2h3T8egEicunS8AffTe7BqajU8mWm207D0daTV3F642fafGxhYorexIZ8Oq3bDQA4h
         JgCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n4BgfHqwdqI3YqWQFctUtjcxlGXw7vpzj8vy+lT8WF4=;
        b=1M0n5lK+zR1h/+nXP0GmiG4zLMPn6pkQiZRBQYU/Km07Lejw6uPt/+N1Nnoyv5y5YI
         UxNMNx2C/jrMXIDHx0ttYjNEaYGiw8F8hN9CuHDLOC8YtF8ZcCuaAwsovyz6dLX9EC5x
         grwnnGWFb64Aqxh8u8N7S0+ZncW/4fgASG9kG+sa4GbkmUN0hpj5wX0PtIHjt+vvND4z
         pkGIV4+oA1NX+THnJ9FlmdVtAmDJPjyBjyeJCv3q4VrJfUs9YMMMztsSJwIGrVF5AA7Q
         WQtDJr1JRLsC1UClLG8Oerc3IjzbO5JTJ2Tv/yqG8yhuq7jUdMFDpUQ842U1ibxNRGrs
         8wNQ==
X-Gm-Message-State: AOAM531K4laXn28BgBMv5zrckOVtNply7Zk9pnVFqsrZe1O4kEqAa+Po
        7dmeTN6+dm/nhyvQW4BGYPTsphG8kJM=
X-Google-Smtp-Source: ABdhPJwGjhtDv521jFyRtxg8a0fFgV5BerQbWXbCMCyQPHO/zxlPkCMMtubr3ZSaM0+K/RtE2fthpA==
X-Received: by 2002:a5d:5012:0:b0:20a:d9a9:44dc with SMTP id e18-20020a5d5012000000b0020ad9a944dcmr8858799wrt.627.1650972789297;
        Tue, 26 Apr 2022 04:33:09 -0700 (PDT)
Received: from crow.. (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id m24-20020adfa3d8000000b0020ae0999f05sm3108292wrb.88.2022.04.26.04.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 04:33:08 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] KernelShark: Version 2.1.1
Date:   Tue, 26 Apr 2022 14:32:58 +0300
Message-Id: <20220426113258.1471376-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 9dd160e..4ed8e89 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -7,7 +7,7 @@ project(kernel-shark)
 set(KS_APP_NAME "kernelshark")
 set(KS_VERSION_MAJOR 2)
 set(KS_VERSION_MINOR 1)
-set(KS_VERSION_PATCH 0)
+set(KS_VERSION_PATCH 1)
 set(KS_VERSION_STRING ${KS_VERSION_MAJOR}.${KS_VERSION_MINOR}.${KS_VERSION_PATCH})
 message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
 
-- 
2.32.0

