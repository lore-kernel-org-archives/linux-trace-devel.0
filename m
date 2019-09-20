Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E7CDC4CEC9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04043207FC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:48:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q6VTSELn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408704AbfITKsl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 06:48:41 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54963 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408702AbfITKsl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 06:48:41 -0400
Received: by mail-wm1-f68.google.com with SMTP id p7so1928173wmp.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2019 03:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z4kc1j7WPaNizPMBT7tjDLvWgc64zJOz/Y5IipybVpo=;
        b=Q6VTSELnh6IpMA/VXFfFqTwHd5dJ1SeCJEN1l7fqjwcCPX9c18XPTEMGgI0CZbi+xW
         br+/pNV4vOJOQyZbSocMdvCQzuk9/RCbpUu2SgMBxQTFvM+BAAgH/6axzE8ZqB9EYiD/
         WUegLXc60zNEIq4SPj7JPwQFXkFhu1NefcAzvPk3sT/jiDWi670r9VGbeDSnu1odRqcI
         U3iojpsLGmV8YDImIsXIbo1kXKoRX8iYk2YksU2LD7oDjHgukF+5P+d2GHyEMyj3oHxo
         RvfC7bsNAN67339CTndV/6ApZD24RVaRpjfHQJlVeQCb1TDkc1gJk6xVb5TWmRs0CFRb
         Q+nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z4kc1j7WPaNizPMBT7tjDLvWgc64zJOz/Y5IipybVpo=;
        b=gWFWHCNzDkpYsbCOhU/0HZ2rNbg9tFEQBzaoHGSF079d9Bu0doefyrB8Cs00jnNQcC
         gNE/YqLhFuD8KNfwc1s967M4UNN4hG3MACZRJ++FBGWGOGbeyoaKQttuVZhDJR1gchjo
         MUHFdnF0GcZIhNFbeDpN2bfjz+XeSrLXZ3qnFrEA8Hq04fc7bO8sPAado4TpZG3C/fW/
         H4y9aqsV/xUpQ3/TF6a8ypXhOA0FmRIVGBIDynpA0bc9p9uRXzz/wyUzW1xcRuVZSySL
         Uzutym0JP5NHZ7GxAt4p0f6mfnDYtmJG61kdJjfaI4cPnKXG8/Ka+c2ELVj9uzgjZjPR
         erbg==
X-Gm-Message-State: APjAAAUBC1aLqJvro6Kt6D7k8EwAPHT8rTEuD5Oggi6xWsXW+fUCqgrd
        5rMVf1B9jriWWYFqK1iY16A=
X-Google-Smtp-Source: APXvYqyDvrfuWukcSWPWb6YQhYeFTvfsj+z6/rivDrJ10qW5NiaIsuPEWvPR3vKgwZYDLIwujSdAlQ==
X-Received: by 2002:a1c:1d84:: with SMTP id d126mr2988394wmd.58.1568976518236;
        Fri, 20 Sep 2019 03:48:38 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t14sm1641978wrs.6.2019.09.20.03.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 03:48:37 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/4] kernel-shark: Use correct order when linking all depenancies
Date:   Fri, 20 Sep 2019 13:48:28 +0300
Message-Id: <20190920104831.23475-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190920104831.23475-1-y.karadz@gmail.com>
References: <20190920104831.23475-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I wasn't aware of the importance of the order in which the libraries are
passed to the linker, so in the dependency list in src/CMakeLists.txt
I naively started with the most basic libraries first. This is WRONG.
The linker searches and resolves symbols in the order that they appear.
If library A contains a call to a function from library B, we have to
put A before B, otherwise the linker won't know that something in B
needs to be resolved.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/CMakeLists.txt | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index 21494cc..e20a030 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -7,10 +7,10 @@ add_library(kshark SHARED libkshark.c
                           libkshark-configio.c
                           libkshark-collection.c)
 
-target_link_libraries(kshark ${CMAKE_DL_LIBS}
+target_link_libraries(kshark ${TRACEEVENT_LIBRARY}
+                             ${TRACECMD_LIBRARY}
                              ${JSONC_LIBRARY}
-                             ${TRACEEVENT_LIBRARY}
-                             ${TRACECMD_LIBRARY})
+                             ${CMAKE_DL_LIBS})
 
 set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
 
@@ -23,8 +23,8 @@ if (OPENGL_FOUND AND GLUT_FOUND)
                                      KsPlotTools.cpp)
 
     target_link_libraries(kshark-plot  kshark
-                                       ${OPENGL_LIBRARIES}
-                                       ${GLUT_LIBRARY})
+                                       ${GLUT_LIBRARY}
+                                       ${OPENGL_LIBRARIES})
 
     set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
 
@@ -65,11 +65,11 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                                                             KsAdvFilteringDialog.cpp)
 
     target_link_libraries(kshark-gui kshark-plot
-                                     ${CMAKE_DL_LIBS}
+                                     Qt5::Widgets
+                                     Qt5::Network
                                      ${TRACEEVENT_LIBRARY}
                                      ${TRACECMD_LIBRARY}
-                                     Qt5::Widgets
-                                     Qt5::Network)
+                                     ${CMAKE_DL_LIBS})
 
     set_target_properties(kshark-gui PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
 
-- 
2.20.1

