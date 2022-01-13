Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DF2C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jan 2022 12:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbiAMMn1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 07:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbiAMMn0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 07:43:26 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD90C06173F
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 04:43:26 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id w16so22498363edc.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 04:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jm6PG3/MDkpeOoCz3IBp1ASyRW/y5J6OqoHRN9CtMJM=;
        b=QJ5/yYAmGnl3hqXidPna0DJPU+qH0vypmUIuAcdOz8va6T13/YjeeSKKIW0F0qE3Jk
         OPUrQT0q2VXJ85FK+GtVOxff1x0+ItI8aUMTnmhz3JAjBLwybaMq2d6dpTvXNQU0e1NT
         ickf3rB4ZTeocPy/ys3HivjBo3FQNsynhUwwiOg9nOWxZs1UbVS9nFxqFGLOoGlyyXMO
         QpSUphWPxbjDla5Hn83Hz67PdoZGbg/DV1k7i5dfGGu8dQ1rJ9/FS8h0rr9efQ/sKOSA
         8qHrxdOHMofDpRUJd3ukKwrPeqVhNTVxqaXkWteheJjjChiYVXrDCnxrqePOwuFoucD5
         ZaFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jm6PG3/MDkpeOoCz3IBp1ASyRW/y5J6OqoHRN9CtMJM=;
        b=qf0PE5bJoRJLKGnFt/q2kdUVZ+SDcV5tLjcEyIVGDgYfFDsZcJGEezLnn2d9iktmyO
         RBODHuLuflNU6Mg9kU3QZqohbll0RN/K3+iQ3LA+8x26MADdHy+HtoHXdJGlSN8g737X
         p1DQ8LWL9Wo/0/RjfH9BZVUdQwfjSP8O3xc/Dfh6ZOA9A4P/MDeFjXaXXO5L5fBh/Jv7
         Bh6dzZHEweYoulIwrgSUjyiMC1kYolqz89NJECeDdQqQISO4d0NBQN+meY8juWb+dCr+
         DhjrhrVpkC2tbdidTWSwd1Rgt5o++i3L7AxczB303UhbVbb9aBmAlsGp6KhfQshKR+q8
         nHLA==
X-Gm-Message-State: AOAM530cBVaCa4j5qBYzRTyKh5vPETRB7pDvAieWoKJqD33WplpD1ddq
        LlWlHphbJ/2uQ9jU/HMdlSw=
X-Google-Smtp-Source: ABdhPJwdG3KwRRqMcD2XgFOsKNI/7/C/AExSSLFdJ6EWEtw6zwpdfTjqDoHmvr3AbeyihXO5BKWCKA==
X-Received: by 2002:aa7:cb09:: with SMTP id s9mr4090747edt.379.1642077805138;
        Thu, 13 Jan 2022 04:43:25 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b1sm842775ejb.51.2022.01.13.04.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 04:43:24 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     michal.sojka@cvut.cz, linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] kernel-shark: Use cmake imported targets instead of variables
Date:   Thu, 13 Jan 2022 14:43:22 +0200
Message-Id: <20220113124322.292222-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using cmake imported targets instead of package variables is
recommended way to define package dependencies.

The GLUT_LIBRARY cmake variable was renamed in cmake 3.22.1, which
breaks the Kernel Shark build with the latest cmake.

Reported-by: Michal Sojka <michal.sojka@cvut.cz>
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
2.34.1

