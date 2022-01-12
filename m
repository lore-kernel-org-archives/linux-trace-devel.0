Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B19C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jan 2022 15:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354674AbiALPiR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jan 2022 10:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244280AbiALPiK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 10:38:10 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FECAC06173F
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Jan 2022 07:38:09 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id a18so11535584edj.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Jan 2022 07:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dKRf6YPVCJICfLRq+D+RKfYFqnv4tu/j1X6zx9ZQWIU=;
        b=h29RS2OTZOEKkjhVGN+lHOJJsLuvdtgYoGtZLPoFRnJedohw3GzMTNtLj0lTRowu56
         /O+Jn92fnQjGMiEg/IyjnkGFaDPk8DpIe3RZLVoKP2pgCsLX1h9p7V7Smtkv2yRJIdxI
         pcRZHzqxE66xiNRi5bDU/gF81v0MvME2jO5ErpvyJuWRd8a70DFvJwIGGM7X14+9B5io
         EGODldiVetjTkSqtUEcPrRJw+DxpFwvDIfs4OQZ1bPH69kvwCvDPf4GY2UaMUGhkwa1+
         T6E7X7JIoR6vUyE0YeNK9i5b5eEDsr2zscaOZJ+deynAIfVblvnaWWT1CXgEax0C/lhz
         j/tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dKRf6YPVCJICfLRq+D+RKfYFqnv4tu/j1X6zx9ZQWIU=;
        b=yHuX+5cnp3i2VKg6LhaxiE0SQSx3TfBB81G5pMu9Nb0ENjoFxqecWiaq5NkiPPIzYU
         AZCcdMYwxtO8LyHSjJz22oVYFpWgKGRF9wcv+mNWmSn138xfjMqTLCs0C3kYA26nzoOa
         iK5XDnQjZ1ptI/7TPG+jBcKHvaDDXlMmHiNsQgSji2BBEGjm4259MLwBrE3IJbZvOO97
         4xTEDbyyDOMIWxZebBFpUCgoxPmb/pyY7vCxp5by6C9aNbziCrD7iHPGA1EKJ1jazFtf
         hTDZMzRRlSFqs31oRCd5ltE6XIuaqns5/2pRsPpjUUhEIzPgfpK4x9jZnUbAVg1gCqKu
         rjSw==
X-Gm-Message-State: AOAM532OUf+7i0SFz2DC/zkjZ7aHe4z9x6QXfiY6KazQDJUjBEkJcEv0
        CeJevPHKLshC//jFuFiFPzy4fd3Br/c=
X-Google-Smtp-Source: ABdhPJysC1FKDZFQ9mn7yp/Bsb7WqC+ncu2bvnjhGB+1GZZKVLvistk1ivmGYIPxfougsh25K1ybWw==
X-Received: by 2002:a17:906:5502:: with SMTP id r2mr211140ejp.627.1642001887731;
        Wed, 12 Jan 2022 07:38:07 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x1sm26815eju.18.2022.01.12.07.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 07:38:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] kernel-shark: Use cmake imported targets instead of variables
Date:   Wed, 12 Jan 2022 17:38:05 +0200
Message-Id: <20220112153805.222437-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using cmake imported targets instead of package variables is
recommended way to define package dependencies.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/CMakeLists.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index babb9c1..9e0b4ae 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -59,8 +59,8 @@ if (OPENGL_FOUND)
                                      KsPlugins.cpp)
 
     target_link_libraries(kshark-plot  kshark
-                                       ${GLUT_LIBRARY}
-                                       ${OPENGL_LIBRARIES})
+                                       GLUT::GLUT
+                                       OpenGL::GLU)
 
     set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
     install(TARGETS kshark-plot
-- 
2.33.1

