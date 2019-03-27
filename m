Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C98C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 16:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AA8A20700
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 16:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfC0QDu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 12:03:50 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35636 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbfC0QDu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 12:03:50 -0400
Received: by mail-pl1-f196.google.com with SMTP id p19so3527551plo.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Mar 2019 09:03:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8zVIyzNbGKGvrkTMc44Mf2RnGpRFEVAMRC3Fuut3EY4=;
        b=MAwxM9rXmTIMTEr+1B+KNng7xELfalSTh9B1SNeaCjholkhEjatGYEx8SdZbOHiFtM
         06q/QyqA0R4OIerrVJXtdwZOoWiXWx4s1J+pxum19dkKJkn2Oi+BmfytfNkF2Wz8Z/pA
         EAR6CvRXix7wjFm5sA2ppSTCsHDYXmWxMaLZJBl4dFFwYt3UxPS4nKPYBHV1/XE0vsKq
         ba5Hj/k2JYFHKwtJYYNuKRSLntXeG6Er15OsPFymgYd67y/zX0f1a/n/wTfi+yGKsD3F
         aD5BEy/yrPWmvG+bhxL/YjrldFKq/lh8tn+u7fM8VlExHWtOiGsSjcsh64NBoIdrlGRa
         KGTQ==
X-Gm-Message-State: APjAAAUq20NLFPsbOp6a0doFDXiBY0e8w1BLznsfPhxfqix+578wa+3R
        GV6Y2gGehkf6GO+gfktEMfg=
X-Google-Smtp-Source: APXvYqy2Yes96WdAD9NBd90azT188FCf6od3fEiMGW4R9kNYMng2pHvtGdP3+xqclolikrS3EZrjvQ==
X-Received: by 2002:a17:902:e684:: with SMTP id cn4mr14690498plb.71.1553702629385;
        Wed, 27 Mar 2019 09:03:49 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id p88sm36150806pfa.80.2019.03.27.09.03.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Mar 2019 09:03:48 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: [RFC 3/7] kernel-shark: Prepare for building the NumPy interface
Date:   Wed, 27 Mar 2019 18:03:19 +0200
Message-Id: <20190327160323.31654-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327160323.31654-1-ykaradzhov@vmware.com>
References: <20190327160323.31654-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch prepares the Cmake build infrastructure for the
introduction of a the NumPy interface.

We add building of a static version of the C API library to be used by
the interface. The NumPy interface itself will be added in the following
patches.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/CMakeLists.txt     |  3 +++
 kernel-shark/README             | 12 ++++++++++--
 kernel-shark/src/CMakeLists.txt | 19 +++++++++++++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 20ced14..0c5d7a7 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -34,6 +34,9 @@ if (Qt5Widgets_FOUND)
 
 endif (Qt5Widgets_FOUND)
 
+find_package(PythonLibs)
+include(${KS_DIR}/build/FindNumPy.cmake)
+
 set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
 set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 
diff --git a/kernel-shark/README b/kernel-shark/README
index efc6748..5a723a4 100644
--- a/kernel-shark/README
+++ b/kernel-shark/README
@@ -12,7 +12,11 @@ KernelShark has the following external dependencies:
     sudo apt-get install freeglut3-dev libxmu-dev libxi-dev -y
     sudo apt-get install qtbase5-dev -y
 
-1.1 I you want to be able to generate Doxygen documentation:
+1.1 I you want to be able to use the NumPu Interface of KernelShark:
+    sudo apt-get install libpython-dev cython -y
+    sudo apt-get install python-numpy python-matplotlib -y
+
+1.2 I you want to be able to generate Doxygen documentation:
     sudo apt-get install graphviz doxygen-gui -y
 
 
@@ -21,7 +25,11 @@ KernelShark has the following external dependencies:
     dnf install freeglut-devel redhat-rpm-config -y
     dnf install qt5-qtbase-devel -y
 
-2.1 I you want to be able to generate Doxygen documentation:
+2.1 I you want to be able to use the NumPu Interface of KernelShark:
+    dnf install python2-devel python-Cython -y
+    dnf install python-numpy python3-matplotlib -y
+
+2.2 I you want to be able to generate Doxygen documentation:
     dnf install graphviz doxygen -y
 
 
diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index 1e0a794..a3c6743 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -28,6 +28,25 @@ if (OPENGL_FOUND AND GLUT_FOUND)
 
 endif (OPENGL_FOUND AND GLUT_FOUND)
 
+if (PYTHONLIBS_FOUND AND CYTHON_FOUND AND NUMPY_FOUND)
+
+    message(STATUS "kshark_wrapper")
+
+    add_library(pykshark STATIC libkshark.c
+                                libkshark-model.c
+                                libkshark-plugin.c
+                                libkshark-configio.c
+                                libkshark-collection.c)
+
+    target_compile_options(pykshark PUBLIC "-fPIC")
+
+    target_link_libraries(pykshark ${TRACEEVENT_LIBRARY}
+                                   ${TRACECMD_LIBRARY}
+                                   ${CMAKE_DL_LIBS}
+                                   ${JSONC_LIBRARIES})
+
+endif (PYTHONLIBS_FOUND AND CYTHON_FOUND AND NUMPY_FOUND)
+
 if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
     message(STATUS "libkshark-gui")
-- 
2.19.1

