Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47288C4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13BF12333C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391065AbgLKPKB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391120AbgLKPJb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:09:31 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DD6C06179C
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:15 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id v14so7829109wml.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vTSEvEHiG9btkhRtDWM+LLB87T6qgZkDrEAVaT92JLU=;
        b=WqRaJ7SueigEE2YTsS6jDVuXcdlGdqRQLleEVjAtp479BD4CE8BX32f5xH0LbQ9yiW
         x1ayyDEYNb/uRTfJkW7OK94PHL4M56gNGzzHt7quW5iBhP09rWVa+52XmJ5SOulG4gyw
         6i2+wOGF9us19ws2gMoqSFrbf2jD9kYwoITInobpw+tkYN+iPc+22g7CeMAUZHmPKllj
         MAt2enyfmI70xtyTDSF3ItTWFS3LmAa7uRZIVx8RwDeMMUB5OZVlL80y7m5tPdGguC4d
         mxTLPIk0YF8l7g5p3QL12uG8eWOaAVe0gwONDeXPpnjbpQcH0o+qpkNwfsNcKdYE/0+e
         aElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vTSEvEHiG9btkhRtDWM+LLB87T6qgZkDrEAVaT92JLU=;
        b=AxuMpwNKw88f27OB41NM5Ibkr5XYD7q5dXGd4Bw1awVstQIUQ1o4k97Cl6Zxsmk3Cs
         kxIfclZXcyyKgnVxEm6w0R78L8RIQUDKCTHcB1fI8WNuLbgbUmyvWM0clhYhmvTu/20+
         1O/4HfZjmxUizzpyWLtAZy/cXP/mS207JB+W8nCspckp6cQ6gLMONoFB7iL8IS7JV7bn
         bcwEEQY2ySsHLW1p+j1pcGTiLNfcKpEltg+8Ofcoh64wDU/9JxwWX7QQcOxlE4zv/31I
         8wK64wXsc/hzARz3QLNsN1CMVMes83VPDjRmUsH5vq95cfsXKEBAMNTFlaUo/lKM3HNx
         FLBA==
X-Gm-Message-State: AOAM531wi8jphx2wEiC1Po+fQNZRwMj8MbtGrRx68xWYoycl8US9FT1k
        ZsKvxL2wEGGCvq7OpDiNp5+cPAuh/wg=
X-Google-Smtp-Source: ABdhPJyapGILOS9prUwetcvK2XzzIZprYM8l5wQRdJ7Ib9BY6SBeBfvf/WUot0En8l15eYSEGSiI0Q==
X-Received: by 2002:a1c:2d8b:: with SMTP id t133mr13742656wmt.127.1607699294307;
        Fri, 11 Dec 2020 07:08:14 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:13 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 04/32] kernel-shark: Update README
Date:   Fri, 11 Dec 2020 17:07:28 +0200
Message-Id: <20201211150756.577366-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

KernelShark is now separated from libtraceevent, libtracefs and
trace-cmd. The README file has to be updated to reflect this.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 README | 129 ++++++++++++++++++++++++++++++---------------------------
 1 file changed, 67 insertions(+), 62 deletions(-)

diff --git a/README b/README
index 6c360bb..d7efd96 100644
--- a/README
+++ b/README
@@ -1,11 +1,13 @@
 
-This directory contains the new Qt-based version of the KernelShark GUI.
+KernelShark is a front-end reader of tracing data.
 
+The official repository is here:
+    https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git
 
 Third Party Software:
 ------------------------------------------------------------
 KernelShark has the following external dependencies:
-  Cmake, Json-C, OpenGL/Glut, Qt5Base.
+  Cmake, Json-C, OpenGL/Glut, Qt5Base, libtraceevent, libtracefs, trace-cmd.
 
 1. In order to install the packages on Ubuntu do the following:
     sudo apt-get install build-essential git cmake libjson-c-dev -y
@@ -25,88 +27,91 @@ KernelShark has the following external dependencies:
     dnf install graphviz doxygen -y
 
 
-Building:
-------------------------------------------------------------
-1. Follow the instructions given in trace-cmd/README and build
-the original trace-cmd end traceevent libraries.
-
-2. Building KernelShark:
-
-2.1 There is a simple and expert way to build KernelShark
+3. In order to install the final dependencies do the following:
+    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
+    cd libtraceevent
+    make
+    sudo make install
 
-2.1.1 Option 1 (simple) : build KernelShark as part of trace-cmd
+    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+    cd libtracefs
+    make
+    sudo make install
 
-   (from the toplevel git tree)
+    git clone https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+    cd trace-cmd
+    make
+    sudo make install_libs
 
-      make gui
+Building:
+------------------------------------------------------------
+2. Building KernelShark:
 
-   This will build the necessary parts of trace-cmd needed
-   by KernelShark.
+    cd kernel-shark/build
+    cmake ../
+    make
+    sudo make install
 
-2.1.1.1 By default, the installation prefix is "/usr/local". It can be
-changed by passing in "prefix" to the build.
+2.1 In order to create a Doxygen documentation add -D_DOXYGEN_DOC=1
+as a CMake Command-Line option.
 
-   make prefix=/usr gui
+2.2 KernelShark has multiple build types. By default, the build type is
+RelWithDebInfo, which will build a release candidate with debug information.
+To change the type, pass in the option CMAKE_BUILD_TYPE=<type>.
 
-2.1.1.2 Use "make clean" if you want to delete all already compiled objects.
-This will also clean up all the files created by cmake.
+    cmake -DCMAKE_BUILD_TYPE=Debug           - for "-g" option
+    cmake -DCMAKE_BUILD_TYPE=Release         - for "-O3" option
+    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo  - for "-g -O2" option (default)
+    cmake -DCMAKE_BUILD_TYPE=MinSizeRel      - for "-Os" option
 
-2.1.1.3 KernelShark has multiple build types (See section 2.1.2.3 for more
-details. By default, the build type is RelWithDebInfo, which will build
-a release candidate with debug information. To change the type, pass in
-the option BUILD_TYPE=<type> to the make process.
+2.3 In addition to the standard CMake build types (Debug, Release,
+RelWithDebInfo, MinSizeRel) KernelShark supports a "Package" build type.
+By default this build type adds the "-O3" compiler flag. Package maintainers
+can chose their own compiler flags by providing the corresponding
+CMAKE_XXXX_FLAGS_PACKAGE Command-Line options (see the example below).
 
-    make BUILD_TYPE=Debug gui          - for "-g" option
-    make BUILD_TYPE=Release gui        - for "-O3" option
-    make BUILD_TYPE=RelWithDebInfo gui - for "-g -O2" option (default)
-    make BUILD_TYPE=MinSizeRel gui     - for "-Os" option
+-- Note that when built as a "Package" the RPATH-s of the executables are
+set directly to _INSTALL_PREFIX/lib/kernelshark/
 
-2.1.2 Option 2 (expert) : standalone build of KernelShark (for hackers only)
+2.4 After building the code "kernel-shark/lib" will contain all libraries
+and "kernel-shark/bin" will contain all executables.
 
-   (note, you may need to do a normal make from the toplevel git
-    tree before performing the following)
+2.5 Use the script "cmake_clean.sh" if you want to delete all already
+compiled objects and all files generated by CMake.
 
-      make
-      cd kernel-shark/build
-      cmake ../
-      make
+    cd kernel-shark/build
+    ./cmake-clean.sh
 
-    This gives you a bit more control as you may easily pass in
-    your own cmake options.
+2.6 By default, installation prefix is "/usr/local". It can be changed using
+-D_INSTALL_PREFIX= as a CMake Command-Line option.
 
-2.1.2.1 In order to create a Doxygen documentation add -D_DOXYGEN_DOC=1
-as a CMake Command-Line option.
+2.7 In order to uninstall KernelShark do:
+    cd kernel-shark/build
+    ./cmake_uninstall.sh
 
-2.1.2.2 By default, installation prefix is "/usr/local". It can be changed using
--D_INSTALL_PREFIX= as a CMake Command-Line option.
 
-2.1.2.3 In addition to the standard CMake build types (Debug, Release,
-RelWithDebInfo, MinSizeRel) KernelShark supports a "Package" build type.
-By default this build type adds the "-O2" compiler flag. Package maintainers
-can chose their own compiler flags by providing the corresponding
-CMAKE_XXXX_FLAGS_PACKAGE Command-Line options (see the example below).
+CMake examples:
 
--- Note that when built as a "Package" the RPATH-s of the executables are
-set directly to _INSTALL_PREFIX/lib/kernelshark/
+    cmake -D_DOXYGEN_DOC=1 -D_INSTALL_PREFIX=/usr ../
 
--- Note that when built as a "Debug" the "Record" dialog will try to use the
-version of the trace-cmd executable from the build location. In all other cases
-the dialog will derive the absolut path to the trace-cmd executable from
-"_INSTALL_PREFIX", hence the dialog will use the installed version.
+    cmake -DCMAKE_BUILD_TYPE=Package -DCMAKE_C_FLAGS_PACKAGE="-O3 -pedantic"  ../
 
-If no build types is specified, the type will be "RelWithDebInfo".
 
-Examples:
+Contributions:
+------------------------------------------------------------
+3. For questions about the use of the library, please send email to:
+   linux-trace-users@vger.kernel.org
 
-    cmake -D_DOXYGEN_DOC=1 -D_INSTALL_PREFIX=/usr ../
+   Subscribe: http://vger.kernel.org/vger-lists.html#linux-trace-users
+   Archives: https://lore.kernel.org/linux-trace-users/
 
-    cmake -DCMAKE_BUILD_TYPE=Package -DCMAKE_C_FLAGS_PACKAGE="-O3 -pedantic"  ../
+3.1 For contributions to development, please send patches to:
+    linux-trace-devel@vger.kernel.org
 
-2.1.2.4 Use the script "cmake_clean.sh" if you want to delete all already
-compiled objects and all files generated by CMake.
+   Subscribe: http://vger.kernel.org/vger-lists.html#linux-trace-devel
+   Archives: https://lore.kernel.org/linux-trace-devel/
 
-    cd kernel-shark/build
-    ./cmake-clean.sh
+3.2 Note, this project follows the style of submitting patches as described
+by the Linux kernel.
 
-3. After building the code "kernel-shark/lib" will contain all libraries
-and "kernel-shark/bin" will contain all executables.
+    https://www.kernel.org/doc/html/v5.4/process/submitting-patches.html
-- 
2.25.1

