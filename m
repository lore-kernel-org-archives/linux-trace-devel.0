Return-Path: <SRS0=JD1t=VF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB8DC606A7
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Jul 2019 09:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E6BF20645
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Jul 2019 09:19:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R/0s3efU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfGHJTx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 05:19:53 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:39135 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfGHJTw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 05:19:52 -0400
Received: by mail-wm1-f47.google.com with SMTP id z23so15577385wma.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Jul 2019 02:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mxpfCIOjMxhMdQIZu09IesIxfyD2tlwO4s5MBN7n5YA=;
        b=R/0s3efURRaNnsrf62d69HqasbJk3Jyz3zmkavcIlrZRU6k6cMpTA77IS8Kt60KX73
         4q153VKyJqBaB8+rs5nn+SB+ss+ZlSGodNoDeKB+4yiFQEPO5d2ZONsG43OmJCnS3a0l
         XTUtj5M42KGdyMgj6lOEKYcDy6FpPPnv7ry2IT17XxwqXjsBHdyRMWFdHhSYbpx0BaFM
         BgxBAIa1A+8xRnmZD1dL0pgnWuSYvRdtA17ddCoA2in+ScWyCzNngMuDH+mf2xiLpc1D
         Xofr6FH0vmv1+a/vgj90DKo+od0xuhdoKU7gS72aqs1UYG2cbAf0c4HxyHnQcHfEGe2c
         jP8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mxpfCIOjMxhMdQIZu09IesIxfyD2tlwO4s5MBN7n5YA=;
        b=ff2KxXNfym8bLgtYMLCCIeBiUS9ZUPiDGOFSgHnww+ukrEIOFhajCSTwXgFCc5c/nt
         JmYN0L3QLHNgyO2vhHgNFFdNFN/Qagv+1fiUZwDBPPuCCaC+2bY30aQkmjD5KNDwHcxV
         w1kgqa8tuTW61c348IazMbkuXeTOGEAqSFId0ptdiuya+YePwfm7BCEq2ACmVphmcgiy
         yh02N1/kaeIOHdiwVKJ1cjo4tmYbntizEfDRIDpWuoRUrU6oITGrJSaZMO2P4IpSgZZ4
         rkUbz10Q5huKSJCxXc2ADjJjmsgdGKiy8Usrc/i6sdV3R1bSf5ZIt1PXWCZVg0Zop0Uc
         Qb6g==
X-Gm-Message-State: APjAAAU1JUSuJnZv0qHM6C7SN0RK0hXdxEeCaBP4c1hi8U9SqqWr9IAf
        IRbKQszD5iQHt6lRcrSef3rhVPFk+nw=
X-Google-Smtp-Source: APXvYqwXVXE1XnixUdyLq4GYx8pKk9+KV8k/9c+FFnqq3s4/7Il1kTraI5+CyiwmLUlDyzIa+5lUZw==
X-Received: by 2002:a7b:c347:: with SMTP id l7mr15386215wmj.163.1562577590492;
        Mon, 08 Jul 2019 02:19:50 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y1sm13208191wma.32.2019.07.08.02.19.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 02:19:50 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v3] kernel-shark: Define a CMAKE_BUILD_TYPE "Package"
Date:   Mon,  8 Jul 2019 12:19:45 +0300
Message-Id: <20190708091945.439-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Yordan Karadzhov <ykaradzhov@vmware.com>

A special build type dedicated for package maintainers is added.
By default this build type adds the "-O3" compiler flag. Users
can chose their own compiler flags by providing the corresponding
CMAKE_XXXX_FLAGS_PACKAGE Command-Line options.

If no types is specified, the build type will be "Debug".

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/CMakeLists.txt | 34 +++++++++++++++++++++++++---------
 kernel-shark/README         | 22 ++++++++++++++++------
 2 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 64124b0..a0535d8 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -36,22 +36,38 @@ set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC")
 set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread -fPIC")
 
-if(NOT _INSTALL_PREFIX)
-	set(_INSTALL_PREFIX "/usr/local")
-endif()
+if (NOT CMAKE_BUILD_TYPE)
+    set(CMAKE_BUILD_TYPE Debug)
+endif (NOT CMAKE_BUILD_TYPE)
+
+message("\n Build type: ${CMAKE_BUILD_TYPE}")
+
+if (NOT CMAKE_C_FLAGS_PACKAGE)
+    set(CMAKE_C_FLAGS_PACKAGE "-O3")
+endif (NOT CMAKE_C_FLAGS_PACKAGE)
+
+if (NOT CMAKE_CXX_FLAGS_PACKAGE)
+    set(CMAKE_CXX_FLAGS_PACKAGE "-O3")
+endif (NOT CMAKE_CXX_FLAGS_PACKAGE)
+
+if (NOT _INSTALL_PREFIX)
+    set(_INSTALL_PREFIX "/usr/local")
+endif (NOT _INSTALL_PREFIX)
 
 set(KS_PLUGIN_INSTALL_PREFIX ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/plugins/)
 set(KS_ICON ksharkicon.png)
 
-if (NOT _DEBUG)
+set(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")
+
+if (CMAKE_BUILD_TYPE MATCHES Package)
+
+    set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
 
-	set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -O2")
-	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2")
+else (CMAKE_BUILD_TYPE MATCHES Package)
 
-endif (NOT _DEBUG)
+    set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
 
-SET(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")
-SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
+endif (CMAKE_BUILD_TYPE MATCHES Package)
 
 include_directories(${KS_DIR}/src/
                     ${KS_DIR}/build/src/
diff --git a/kernel-shark/README b/kernel-shark/README
index 379c390..75a0dd0 100644
--- a/kernel-shark/README
+++ b/kernel-shark/README
@@ -38,14 +38,24 @@ the original trace-cmd end traceevent libraries.
 2.1.1 In order to create a Doxygen documentation add -D_DOXYGEN_DOC=1
 as a CMake Command-Line option.
 
-2.1.2 In order to generates complete debug information to be used by GDB add
--D_DEBUG=1 as a CMake Command-Line option.
-
-2.1.3 By default, installation prefix is "/usr/local". It can be changed using
+2.1.2 By default, installation prefix is "/usr/local". It can be changed using
 -D_INSTALL_PREFIX= as a CMake Command-Line option.
 
-Example:
-    cmake -D_DOXYGEN_DOC=1 -D_DEBUG=1 -D_INSTALL_PREFIX=/usr ../
+2.1.3 In addition to the standard CMake build types (Debug, Release,
+RelWithDebInfo, MinSizeRel) KernelShark supports a "Package" build type.
+By default this build type adds the "-O2" compiler flag. Package maintainers
+can chose their own compiler flags by providing the corresponding
+CMAKE_XXXX_FLAGS_PACKAGE Command-Line options (see the example below).
+
+Note that when built as a "Package" the RPATH-s of the executables are
+set directly to _INSTALL_PREFIX/lib/kernelshark/
+
+If no build types is specified, the type will be "Debug".
+
+Examples:
+    cmake -D_DOXYGEN_DOC=1 -D_INSTALL_PREFIX=/usr ../
+
+    cmake -DCMAKE_BUILD_TYPE=Package -DCMAKE_C_FLAGS_PACKAGE="-O3 -pedantic"  ../
 
 2.2.1 Use "make clean" if you want to delete all already compiled objects.
 
-- 
2.20.1

