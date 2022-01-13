Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50196C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jan 2022 00:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiAMAvi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jan 2022 19:51:38 -0500
Received: from smtpx.feld.cvut.cz ([147.32.210.153]:34213 "EHLO
        smtpx.fel.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiAMAvh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 19:51:37 -0500
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2022 19:51:37 EST
Received: from localhost (styx [192.168.200.7])
        by smtpx.fel.cvut.cz (Postfix) with ESMTP id D57DC167AE;
        Thu, 13 Jan 2022 01:46:16 +0100 (CET)
X-Virus-Scanned: IMAP STYX AMAVIS
Received: from smtpx.fel.cvut.cz ([192.168.200.2])
        by localhost (styx.feld.cvut.cz [192.168.200.7]) (amavisd-new, port 10060)
        with ESMTP id dYb_cSdy6LMS; Thu, 13 Jan 2022 01:46:14 +0100 (CET)
Received: from steelpick.2x.cz (ip-94-112-192-124.net.upcbroadband.cz [94.112.192.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sojkam1)
        by smtpx.fel.cvut.cz (Postfix) with ESMTPSA id A0C0D164F1;
        Thu, 13 Jan 2022 01:46:14 +0100 (CET)
Received: (nullmailer pid 1624429 invoked by uid 1000);
        Thu, 13 Jan 2022 00:46:13 -0000
From:   Michal Sojka <michal.sojka@cvut.cz>
To:     linux-trace-devel@vger.kernel.org
Cc:     Michal Sojka <michal.sojka@cvut.cz>
Subject: [PATCH] kernelshark: Fix "undefined reference to `glutInit'" when using CMake 3.22.1
Date:   Thu, 13 Jan 2022 01:45:59 +0100
Message-Id: <20220113004559.1624414-1-michal.sojka@cvut.cz>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When building with cmake 3.22.1, the build fails with the following
errors:

    /bin/ld: dataplot.cpp:(.text+0x17): undefined reference to `glutInit'
    /bin/ld: dataplot.cpp:(.text+0x62): undefined reference to `glutDisplayFunc'
    /bin/ld: dataplot.cpp:(.text+0x6d): undefined reference to `glutMainLoop'
    /bin/ld: ../../lib/libkshark-plot.so.2.0.2: undefined reference to `glutInitWindowPosition'
    /bin/ld: ../../lib/libkshark-plot.so.2.0.2: undefined reference to `glutInitDisplayMode'
    /bin/ld: ../../lib/libkshark-plot.so.2.0.2: undefined reference to `glutInitWindowSize'
    /bin/ld: ../../lib/libkshark-plot.so.2.0.2: undefined reference to `glutCreateWindow'
    /bin/ld: ../../lib/libkshark-plot.so.2.0.2: undefined reference to `glutSetOption'

The reason is this cmake commit:
https://gitlab.kitware.com/cmake/cmake/-/commit/f90d15458a9a98180fcc95158f2ab5d2b1ad3152,
which changes how the glut library is searched for. Specifically,
pkg-config is newly tried before other methods.

When pkg-config finds the library it doesn't set GLUT_LIBRARY variable
used by kernelshark, but only GLUT_LIBRARIES, as mentioned in the
official documentation:

    https://cmake.org/cmake/help/v3.22/module/FindGLUT.html

Therefore, we should switch to using the documented variable.

I also tested this change with CMake 3.21.2 (before the mentioned
commit) and it works.

Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
---
 src/CMakeLists.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index babb9c1..e4cf78f 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -59,7 +59,7 @@ if (OPENGL_FOUND)
                                      KsPlugins.cpp)
 
     target_link_libraries(kshark-plot  kshark
-                                       ${GLUT_LIBRARY}
+                                       ${GLUT_LIBRARIES}
                                        ${OPENGL_LIBRARIES})
 
     set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
-- 
2.34.1

