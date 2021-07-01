Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C505C11F64
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 041BC6140B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236040AbhGALRK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 07:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbhGALRK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 07:17:10 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBECC0617A8
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Jul 2021 04:14:39 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id r3so4254831wmq.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 01 Jul 2021 04:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EoZoFIDSqhaUMDJIEPOTCg4yY+ObBNENsCiMEZHbcd0=;
        b=epJ8r+wUHsdCs+TkzR68FSdRiuLlSflfhUDBFWgLdodcqxpGNpLO7s8fBdF4Wx7Tzo
         UxbPXt3UUS3Mcgh2s22BaNj2VZCBZ1Pgk5Vf0bcvfUonwldk55fl5GaGaIMAWTD3UESi
         ZUl6yYs0/eiZbtlYt33X5D6D2pcEAer2H9YLRX6gezl3YRxNjUX6R+vSeDw5cU/wFcoC
         39NerhiV3iNziztrwklDF0njyDdbepoCg9EHaR5KDUMCH9XV+5RfjIsfVkHjTizb8qSG
         3IRQOxxKsVvLVZI7d67iarv7egqCc0sQ/RrTwO6V3HV91OpyAK/ZeSvGuvGneA9gO48g
         eCew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EoZoFIDSqhaUMDJIEPOTCg4yY+ObBNENsCiMEZHbcd0=;
        b=pznDUGiIW51wquLfJ3lF41U6BHM60CP4bC7IBquZg6u6lZOqY0K6KI+u0NqUYlMeQi
         HoGuH6AK6abv7A242wUjS1H/pu+/UwoP/+p5QmRgZ0pe3EjnEtSrUr7ysbswyhv/1frE
         vwNx/peDR3tffQgD2JhNy/LDyqeXSBG+MBDQFktabxgesBHi4L+0vOIhxEx+SiLu1sCq
         nEUjaIZJ3QL15z13kuf9MTaxeyDLuJikYZx74LDcrBNtDccHyXlShG92hbhAPlDNOLEV
         PijISr5hQwwMVPJtVscuECurXicKb2naus0DUcpk0PpwgpfGRT5DmxyqonbS240pcW5B
         GCSQ==
X-Gm-Message-State: AOAM531RALwMBfb/oUXbNwzQAdPmshA4hUHbPDQ4slLxo7J2vHDzw49M
        DARa+ZNVO3CZS+rz07s4TyekR9kmqTE=
X-Google-Smtp-Source: ABdhPJwH4qfbAXciQzVOYb6b4YlYk+egkDBzAxZXrk/VnL1922JR4FVyr5plA9+ZYLd8/kseG8V9CA==
X-Received: by 2002:a7b:c405:: with SMTP id k5mr44240772wmi.34.1625138077525;
        Thu, 01 Jul 2021 04:14:37 -0700 (PDT)
Received: from bucy.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id o17sm9223009wmh.19.2021.07.01.04.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 04:14:37 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, warthog9@eaglescrag.net,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 08/11] trace-cruncher: Update README.md
Date:   Thu,  1 Jul 2021 14:14:15 +0300
Message-Id: <20210701111418.18386-9-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210701111418.18386-1-y.karadz@gmail.com>
References: <20210701111418.18386-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Building instruction are updated in order to properly describe
the refactored version and the installation of all third-party
dependencies.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 README.md | 84 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 54 insertions(+), 30 deletions(-)

diff --git a/README.md b/README.md
index c5121ab..9a3696c 100644
--- a/README.md
+++ b/README.md
@@ -4,68 +4,92 @@
 
 ## Overview
 
-The Trace-Cruncher project aims to provide an interface between the existing instrumentation for collection and visualization of tracing data from the Linux kernel and the broad and very well developed ecosystem of instruments for data analysis available in Python. The interface will be based on NumPy.
+The Trace-Cruncher project aims to provide an interface between the existing instrumentation for collection and visualization of tracing data from the Linux kernel and the broad and very well developed ecosystem of instruments for data analysis available in Python. The interface is based on NumPy.
 
-NumPy implements an efficient multi-dimensional container of generic data and uses strong typing in order to provide fast data processing in Python. The  Trace-Cruncher will allow for sophisticated analysis of kernel tracing data via scripts, but it will also opens the door for exposing the kernel tracing data to the instruments provided by the scientific toolkit of Python like MatPlotLib, Stats, Scikit-Learn and even to the nowadays most popular frameworks for Machine Learning like TensorFlow and PyTorch. The Trace-Cruncher is strongly coupled to the KernelShark project and is build on top of the C API of libkshark.
+NumPy implements an efficient multi-dimensional container of generic data and uses strong typing in order to provide fast data processing in Python. The  Trace-Cruncher allows for sophisticated analysis of kernel tracing data via scripts, but it also opens the door for exposing the kernel tracing data to the instruments provided by the scientific toolkit of Python like MatPlotLib, Stats, Scikit-Learn and even to the nowadays most popular frameworks for Machine Learning like TensorFlow and PyTorch. The Trace-Cruncher is strongly coupled to the KernelShark project and is build on top of the C API of libkshark.
 
 ## Try it out
 
 ### Prerequisites
 
 Trace-Cruncher has the following external dependencies:
-  trace-cmd / KernelShark, Json-C, Cython, NumPy, MatPlotLib.
+  libtraceevent, libtracefs, KernelShark, Json-C, Cython, NumPy.
 
-1.1 In order to install the packages on Ubuntu do the following:
+1.1 In order to install all packages on Ubuntu do the following:
 
-    sudo apt-get install libjson-c-dev libpython3-dev cython3 -y
+    > sudo apt-get update
 
-    sudo apt-get install python3-numpy python3-matplotlib -y
+    > sudo apt-get install build-essential git cmake libjson-c-dev -y
 
-1.2 In order to install the packages on Fedora, as root do the following:
+    > sudo apt-get install libpython3-dev cython3 python3-numpy python3-pip -y
 
-    dnf install json-c-devel python3-devel python3-Cython -y
+    > sudo pip3 install --system pkgconfig GitPython
 
-    dnf install python3-numpy python3-matplotlib -y
+1.2 In order to install all packages on Fedora, as root do the following:
 
-2. In order to get the proper version of KernelShark / trace-cmd do the
-following:
+    > dnf install gcc gcc-c++ git cmake json-c-devel -y
 
-    git clone git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git --branch=kernelshark-v1.1
+    > dnf install python3-devel python3-Cython python3-numpy python3-pip -y
 
-or download a tarball from here:
-https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/snapshot/trace-cmd-kernelshark-v1.1.tar.gz
+    > sudo pip3 install --system pkgconfig GitPython
 
-### Build & Run
 
-1. Patch trace-cmd / KernelShark:
+2 In order to install all third party libraries do the following:
+
+    > git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
+
+    > cd libtraceevent
+
+    > make
+
+    > sudo make install
+
+    > cd ..
+
+
+    > git clone https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+    > cd libtracefs
 
-    cd path/to/trace-cmd/
+    > make
 
-    git am ../path/to/trace-cruncher/0001-kernel-shark-Add-_DEVEL-build-flag.patch
+    > sudo make install
 
-    git am ../path/to/trace-cruncher/0002-kernel-shark-Add-reg_pid-plugin.patch
+    > cd ..
 
-2. Install trace-cmd:
 
-    make
+    > git clone https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git
 
-    sudo make install_libs
+    > cd trace-cmd
 
-3. Install KernelShark:
+    > make
 
-    cd kernel-shark/build
+    > sudo make install_libs
 
-    cmake -D_DEVEL=1 ../
+    > cd ..
 
-    make
 
-    sudo make install
+    > git clone https://github.com/yordan-karadzhov/kernel-shark-v2.beta.git kernel-shark
+
+    > cd kernel-shark/build
+
+    > cmake ..
+
+    > make
+
+    > sudo make install
+
+    > cd ../..
+
+### Build & Run
+
+Installing trace-cruncher is very simple. After downloading the source code, you just have to run:
 
-4. Build the NumPy API itself:
+     > cd trace-cruncher
 
-    cd path/to/trace-cruncher
+     > make
 
-    ./np_setup.py build_ext -i
+     > sudo make install
 
 ## Documentation
 
-- 
2.27.0

