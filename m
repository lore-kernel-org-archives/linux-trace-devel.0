Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E86C43461
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 14:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06071613B6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 14:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243684AbhDUOwd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 10:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbhDUOwa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 10:52:30 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1E8C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Apr 2021 07:51:55 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id r9so63923016ejj.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Apr 2021 07:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AROYmnxUZ9EY17rKWAysWnjCIfUD+2dYjEhuGq092Ms=;
        b=QCp/qk8g47o0Km9ZCEpKdMZnb10ATpNkZW7t97LMUABUfpkN71vqefLmOXmUMs1uiB
         iXmNuvGQHVdIJXIm7hlsARQ8nz00KuW4GpIRbRvCYFT7dTLMARfpJ7UDboMxFLF8W5GY
         0WK4dlmBwAD31CEZrSmlv9rulJxXwqpLYaW1Y8JIWwGwf0MZoXolBI9vvfH7vDC4YxuI
         55U5wxgACsF0SsESesmWQNKtMxFqzU/vnOjjpMiqFWl7kU4hTal02ei0Ferkj9mB8hqQ
         OLzA2qXEHOsHzY+hIQUbzGmpBVXqcz6AJeOB+TlzJUPjUb4EHDmlzXcKPl3ZRUY++XWf
         Om5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AROYmnxUZ9EY17rKWAysWnjCIfUD+2dYjEhuGq092Ms=;
        b=HUma0uG/UxW8/KtmlP0aqg/NzJOzx0MDo0LMJSGE8GZNhk90fZfl4LHtQhDsXlHGNe
         EQh8qKUr2d5z9MkZboC5PZOZHgNPjGRYT7v4Eg+5qPVikTG0RJhIHXdkHPlByfrHNqfY
         ZD11sASzvJ3J5c3GhgUKbOmCh5RZ1bME1acedmG5mEDMs3O1fv4pA9Urx2w25ESVUUBA
         Kgl3xx5FvM0crhPe0/UA8XdCTLw3+HO3NdzDIt8HlbAGcGTjDVsCr+mPIDpaj4CMRQAJ
         bs/jOdKxM46gKH5WFhJsILNb1lMIc+jpwXcRXtEiz7YekZld/ha312iUGnc5ijBvphV1
         IQng==
X-Gm-Message-State: AOAM5303yvSKFX+qcfp6jM2sI1LJ95ZDl5C74+DA+C7YioDlMU3SSesd
        DfGLeTMa4fwp1kYwmQyX2t9nEjlRXxw=
X-Google-Smtp-Source: ABdhPJxLq0CaHCYtnJySxK2+G31CXuD0k5fjySvj6Vb3yLwzuSPZEg9gIkfe1W7ILFpPzytraCnfaQ==
X-Received: by 2002:a17:906:1114:: with SMTP id h20mr34182291eja.453.1619016713886;
        Wed, 21 Apr 2021 07:51:53 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.28])
        by smtp.gmail.com with ESMTPSA id ke14sm2730325ejc.1.2021.04.21.07.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 07:51:53 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/4] kernel-shark: Polish the README file
Date:   Wed, 21 Apr 2021 17:51:38 +0300
Message-Id: <20210421145140.95517-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210421145140.95517-1-y.karadz@gmail.com>
References: <20210421145140.95517-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixing some typos and making it easier to read.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 README | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/README b/README
index f5035f9..b1934c3 100644
--- a/README
+++ b/README
@@ -7,7 +7,8 @@ The official repository is here:
 Third Party Software:
 ------------------------------------------------------------
 KernelShark has the following external dependencies:
-  Cmake, Json-C, OpenGL/Glut, Qt5Base, libtraceevent, libtracefs, trace-cmd.
+  Cmake, Json-C, OpenGL/Glut, Qt5Base, libtraceevent, libtracefs, trace-cmd
+  and FreeSans font.
 
 1. In order to install the packages on Ubuntu do the following:
     sudo apt-get install build-essential git cmake libjson-c-dev -y
@@ -15,7 +16,7 @@ KernelShark has the following external dependencies:
     sudo apt-get install fonts-freefont-ttf
     sudo apt-get install qtbase5-dev -y
 
-1.1 I you want to be able to generate Doxygen documentation:
+1.1 If you want to be able to generate Doxygen documentation:
     sudo apt-get install graphviz doxygen-gui -y
 
 
@@ -24,7 +25,7 @@ KernelShark has the following external dependencies:
     dnf install freeglut-devel redhat-rpm-config -y
     dnf install qt5-qtbase-devel -y
 
-2.1 I you want to be able to generate Doxygen documentation:
+2.1 If you want to be able to generate Doxygen documentation:
     dnf install graphviz doxygen -y
 
 
@@ -46,26 +47,27 @@ KernelShark has the following external dependencies:
 
 Building:
 ------------------------------------------------------------
-2. Building KernelShark:
+1. Building and install KernelShark GUI:
 
     cd kernel-shark/build
     cmake ../
     make
     sudo ./install_gui.sh
 
-2.1 In order to create a Doxygen documentation add -D_DOXYGEN_DOC=1
-as a CMake Command-Line option.
+1.1 In order to create a Doxygen documentation add -D_DOXYGEN_DOC=1
+as a CMake Command-Line option (see the example below).
 
-2.2 KernelShark has multiple build types. By default, the build type is
+1.2 KernelShark has multiple build types. By default, the build type is
 RelWithDebInfo, which will build a release candidate with debug information.
-To change the type, pass in the option CMAKE_BUILD_TYPE=<type>.
+To change the type, pass in the option CMAKE_BUILD_TYPE=<type> (see the
+example below).
 
     cmake -DCMAKE_BUILD_TYPE=Debug           - for "-g" option
     cmake -DCMAKE_BUILD_TYPE=Release         - for "-O3" option
     cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo  - for "-g -O2" option (default)
     cmake -DCMAKE_BUILD_TYPE=MinSizeRel      - for "-Os" option
 
-2.3 In addition to the standard CMake build types (Debug, Release,
+1.3 In addition to the standard CMake build types (Debug, Release,
 RelWithDebInfo, MinSizeRel) KernelShark supports a "Package" build type.
 By default this build type adds the "-O3" compiler flag. Package maintainers
 can chose their own compiler flags by providing the corresponding
@@ -74,19 +76,19 @@ CMAKE_XXXX_FLAGS_PACKAGE Command-Line options (see the example below).
 -- Note that when built as a "Package" the RPATH-s of the executables are
 set directly to _INSTALL_PREFIX/lib/kernelshark/
 
-2.4 After building the code "kernel-shark/lib" will contain all libraries
+1.4 After building the code "kernel-shark/lib" will contain all libraries
 and "kernel-shark/bin" will contain all executables.
 
-2.5 Use the script "cmake_clean.sh" if you want to delete all already
+1.5 Use the script "cmake_clean.sh" if you want to delete all already
 compiled objects and all files generated by CMake.
 
     cd kernel-shark/build
-    ./cmake-clean.sh
+    ./cmake_clean.sh
 
-2.6 By default, installation prefix is "/usr/local". It can be changed using
--D_INSTALL_PREFIX= as a CMake Command-Line option.
+1.6 By default, installation prefix is "/usr/local". It can be changed using
+-D_INSTALL_PREFIX= as a CMake Command-Line option (see the example below).
 
-2.7 In order to uninstall KernelShark do:
+1.7 In order to uninstall KernelShark do:
     cd kernel-shark/build
     ./cmake_uninstall.sh
 
-- 
2.27.0

