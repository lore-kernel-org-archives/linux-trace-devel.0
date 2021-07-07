Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E06C11F66
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7080661C42
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhGGNZA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 09:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbhGGNY7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 09:24:59 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F592C061574
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jul 2021 06:22:18 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id b2so3232221ejg.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Jul 2021 06:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EoZoFIDSqhaUMDJIEPOTCg4yY+ObBNENsCiMEZHbcd0=;
        b=QFTdIWvCkvWQKyAWG/vyVO4ZKgxMn0H6kk3ZGTDvBgxjT1yCR1QgBSOHjOSYTQhrub
         kSrX53cN2mcvKzmCR6TtvA1vJI9HJNBimmL7hTtVQ8t52uZatGMgxsE+mGZbiAE43XaJ
         4UtPxxRsS4yjXmS1RHFmRztFyOJOJtv8mzq5l0/W0cTlOHTfB3hu5YR3iN7XS1brwpjX
         GYYDAXrrbWJet7tzK52ZC6gBWk+V13GY9WLeJ1lj9eP+oFj3gr2oOF1Z7ZhjYv1c4DYp
         qTfJ0dk6SSdmZMPpCEmPFKzqAhClbZGkNW7US9LlG0b049qPS5n+gr7R1DqtEBqLzdJs
         dATA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EoZoFIDSqhaUMDJIEPOTCg4yY+ObBNENsCiMEZHbcd0=;
        b=t1wA5Xb7OKd8iQ/9eh1JG5x03iUgDqiqUjiNL2WC1r7RJPj6QRyB3eh1WfMy0D79+T
         KrQftixaNT0BPRGN+8B7/O/fl0bkqyWjaBrWzNeHumXNGLUjrrkfKGQKzKB/8Ff1cRXX
         kGQbLd5Szfl2hlmFrJJWyZ7q7jFckJCdJJu0BQyn1mycjToyZisPo1JN+k7ucKgxoiSj
         sItMAZdXMTM6A6KpPKFMvwU9GhNJo2y2ElmyeMUHu+fLvV1rgDz73Ujhguynk8t6376h
         cB1Acty9YWJR56Dh4qLZnyoxbARTuxWIoYbY/Yy0OJ/nwEQm7moq3rzWUIOZzlUVhxxY
         BJ0w==
X-Gm-Message-State: AOAM532kwk47Dj5EfA37NJQl934nt3+tjjP/2NhfAHGGsB6eFB+y919s
        CJwoqOULzQSuRwGdPINmW3J12a8WW8M=
X-Google-Smtp-Source: ABdhPJxyvM1lTu/tHw7wsNsrWviPxxdqwzA55nGDwNOMRQp1Y1MSGiWeCkKzSmoOFh9SyHu1qr+NJA==
X-Received: by 2002:a17:906:974a:: with SMTP id o10mr23384375ejy.406.1625664136855;
        Wed, 07 Jul 2021 06:22:16 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id eb9sm7064881ejc.32.2021.07.07.06.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 06:22:16 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 08/11] trace-cruncher: Update README.md
Date:   Wed,  7 Jul 2021 16:21:55 +0300
Message-Id: <20210707132158.68520-10-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210707132158.68520-1-y.karadz@gmail.com>
References: <20210707132158.68520-1-y.karadz@gmail.com>
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

