Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048A7C433E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Mar 2021 17:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C967C6512B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Mar 2021 17:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhCPRjz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Mar 2021 13:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbhCPRjo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Mar 2021 13:39:44 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE36C06175F
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Mar 2021 10:39:43 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id e18so7873511wrt.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Mar 2021 10:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2l0/q3oj+CBGXucKw7yMd7n960z+gsAxzyVuupixl6w=;
        b=NR+nj2ZiF2UeQws7s5pprQDvPrK2u7vx/xMkDOfJuG0PS/fJpR7r7N97zy2MbS/YWJ
         Aa8Y7W46T2SFxi8x9E2r+w/l4DKGEr6WBumXknYLuxUXRYgH59qTDxPCoLR4jL/XFaTx
         pDej5KriUK0saZui05jfLE1fms1KUJUZTNWBUAdr7+SucSsXcH3wr0rYpcY683mk3zAa
         ISTW291j5gxn/LZxSYSOFfIs423y/+X7UzRvXlRuWFwP2cTe8UHZroyANo/QlTKdHEP6
         ENwtuGh2RBBdXSvnHSYeie5DXulpOxWYKDINCGFcNBXx0eXho78ZxLVVpNqUeakLgPp2
         kGxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2l0/q3oj+CBGXucKw7yMd7n960z+gsAxzyVuupixl6w=;
        b=hEwhUUMFIaFXXVv7hwxK3QLLpD5u+j75JMatNr/APjjuSH5r1hRDGW5KKLXL0ZtTp1
         KWV1T4x2A9ESLcQmBovX/C8KayM6u5aXBMzd8TeefOkzAtkRuSbNRFnigI8RGMQCcDqo
         yH6nOOCGmvpJZP5s0g3OEIBs+panVHgMOZtbZ/dSiGvZZl/821m7HS72voyd5HJkgaDf
         TRaRwnBXX69mk63rKyelWOJURQmeEkaKPZcc8k1k2JOs15Q3jT53r/1viYU+qeD99tcc
         s55vfDSrexTFnNk7ZdOlTpPa03Ix/XrDXwcfOhd0rsf/O9B5GMxRit0Y4o4wBYnbuJqc
         mmNQ==
X-Gm-Message-State: AOAM530lit3MPJ5mkOGP5nzE3eG87T/55sZGfdywwff4ddxdrU/ynmdX
        xx0MQQOEvfCCfu2NnZjoCaPyYiNtCUM/0Q==
X-Google-Smtp-Source: ABdhPJw2j+h9H5xb2mZPWQBcE29Mx7S64SGJ85OgKpJBlcr2Sj8kjFhwQMFR6HUch+eKqnm5vc7tZg==
X-Received: by 2002:adf:f005:: with SMTP id j5mr101055wro.423.1615916382494;
        Tue, 16 Mar 2021 10:39:42 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.162])
        by smtp.gmail.com with ESMTPSA id a12sm21890191wrx.5.2021.03.16.10.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 10:39:42 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/3] kernel-shark: Always install the pkg-config descriptor
Date:   Tue, 16 Mar 2021 19:39:22 +0200
Message-Id: <20210316173922.657865-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316173922.657865-1-y.karadz@gmail.com>
References: <20210316173922.657865-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The pkg-config support is part of libkshark and has to be installed
together with the other components of the library regardless of the
GUI compilation.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 5942e91..ec4149a 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -38,6 +38,12 @@ install(FILES "${KS_DIR}/src/libkshark.h"
         DESTINATION ${KS_INCLUDS_DESTINATION}
             COMPONENT libkshark-devel)
 
+execute_process(COMMAND  bash "-c" "pkg-config --variable pc_path pkg-config | cut -f 1 -d: -z"
+                OUTPUT_VARIABLE PKG_CONGIG_DIR)
+install(FILES "${KS_DIR}/libkshark.pc"
+        DESTINATION ${PKG_CONGIG_DIR}
+            COMPONENT                 libkshark-devel)
+
 if (OPENGL_FOUND)
 
     message(STATUS "libkshark-plot")
@@ -134,12 +140,6 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
             DESTINATION ${_INSTALL_PREFIX}/bin/
                 COMPONENT                 kernelshark)
 
-    execute_process(COMMAND  bash "-c" "pkg-config --variable pc_path pkg-config | cut -f 1 -d: -z"
-                    OUTPUT_VARIABLE PKG_CONGIG_DIR)
-    install(FILES "${KS_DIR}/libkshark.pc"
-            DESTINATION ${PKG_CONGIG_DIR}
-                COMPONENT                 libkshark-devel)
-
     add_subdirectory(plugins)
     set(PLUGINS ${PLUGINS} PARENT_SCOPE)
 
-- 
2.25.1

