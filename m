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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD2EC4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Aug 2021 09:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B937A61163
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Aug 2021 09:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbhHYJpj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 05:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236914AbhHYJpj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 05:45:39 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F27C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Aug 2021 02:44:53 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id g138so14553678wmg.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Aug 2021 02:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e4mBRpLe1cpkPbzbC1xtWPAsaukseip+CxycfkdzxO4=;
        b=epJ7UBh0zSBtKdh56uO0UJMOTvVXM0gQeMU0hCkoDkLvADOthm/bsDophMhS3HfcDa
         c7Zaq2jXyfDv9lwis1otX8OhGM2+RTjhCRoA9a9ikE32jqdDWElyRE/rlislAu/z80ES
         si0Zvz6vv7lki+Zg2DX7coETXXam/SH/mGTdqxYMciL8sGg3gcM2id+wi0ztcsEdAirN
         kAooNw7d8tlVrNYPUn4JkUHy6EPL1+12PWa3xy0RocAtXW7Ay9Zp0DgefNXP+m2bu79z
         7U0NHL9gKX8I3qZHwblIJesjnIof52PzDb9+WcpcE7PsLLjNYG2DPBIqr4GL+9pb5jy8
         5gJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e4mBRpLe1cpkPbzbC1xtWPAsaukseip+CxycfkdzxO4=;
        b=WmtpCXLUCK01oWuMSeQuY/FT8UASEVW/x/nvYSe+2f4dOnZ5oksgcIhXldM6AwwB5b
         RR9/h1pyM08+xiOsuFeYkDyopoFiWjwQjRb/T/EH0+LQefSwFbR0H7A1oFK5jhN9grH4
         z3IzGHwrJXNq8DDVpIgc9nHO7I3CNW7+MD06OW/7ZfiId9qej4oDxvK1PBZZj/tje+gB
         Kyaqgem/CUZTgxDRvj7Od8HxfE5cZDEhuSX3RCuUZPZb+U8kPRMXIm7Km2f+uwNCdyNb
         K7eV71LKxO6AWG9X6NkAl/oiXb6j2fu7/kFqQFu4G3IcTMGA1wZUj7WlnGAOrS17WUkU
         smFw==
X-Gm-Message-State: AOAM531IfEOO6N2Ep4VQQ2Wb1S0AjRlV+kFjMeEG8z+Ti9dzxoVB1DAB
        YTbdtR/+52XOwe20fOJRYRL60b7YNqw=
X-Google-Smtp-Source: ABdhPJwj3dzzwEtyoEHk+W+SHXzTxzW+HmMkGWU2u5ZBrmab062rNkpxlemr+NA44m5CfGekec2yLQ==
X-Received: by 2002:a1c:2086:: with SMTP id g128mr8364817wmg.46.1629884691924;
        Wed, 25 Aug 2021 02:44:51 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id u23sm4608794wmc.24.2021.08.25.02.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 02:44:51 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/3] trace-cruncher: Update README.md
Date:   Wed, 25 Aug 2021 12:44:35 +0300
Message-Id: <20210825094436.46958-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825094436.46958-1-y.karadz@gmail.com>
References: <20210825094436.46958-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Improve the the description of the project and make the provided
information consistent with content of CONTRIBUTING.md.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 README.md | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/README.md b/README.md
index 9a3696c..93f12c8 100644
--- a/README.md
+++ b/README.md
@@ -4,9 +4,9 @@
 
 ## Overview
 
-The Trace-Cruncher project aims to provide an interface between the existing instrumentation for collection and visualization of tracing data from the Linux kernel and the broad and very well developed ecosystem of instruments for data analysis available in Python. The interface is based on NumPy.
+The Trace-Cruncher project aims to provide an interface between the existing instrumentation for collection and visualization of tracing data from the Linux kernel and the broad and very well developed ecosystem of instruments for data analysis available in Python.
 
-NumPy implements an efficient multi-dimensional container of generic data and uses strong typing in order to provide fast data processing in Python. The  Trace-Cruncher allows for sophisticated analysis of kernel tracing data via scripts, but it also opens the door for exposing the kernel tracing data to the instruments provided by the scientific toolkit of Python like MatPlotLib, Stats, Scikit-Learn and even to the nowadays most popular frameworks for Machine Learning like TensorFlow and PyTorch. The Trace-Cruncher is strongly coupled to the KernelShark project and is build on top of the C API of libkshark.
+The Trace-Cruncher allows for sophisticated analysis of kernel tracing data via scripts, but it also opens the door for exposing the kernel tracing data to the instruments provided by the scientific toolkit of Python like MatPlotLib, Stats, Scikit-Learn and even to the nowadays most popular frameworks for Machine Learning like TensorFlow and PyTorch. The Trace-Cruncher is strongly coupled to the [libtraceevent](https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git), [libtracefs](https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/) and [KernelShark](https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/) projects and is build on top of the C API of this librearies.
 
 ## Try it out
 
@@ -23,13 +23,17 @@ Trace-Cruncher has the following external dependencies:
 
     > sudo apt-get install libpython3-dev cython3 python3-numpy python3-pip -y
 
+    > sudo apt-get install flex valgrind -y
+
     > sudo pip3 install --system pkgconfig GitPython
 
 1.2 In order to install all packages on Fedora, as root do the following:
 
-    > dnf install gcc gcc-c++ git cmake json-c-devel -y
+    > sudo dnf install gcc gcc-c++ git cmake json-c-devel -y
+
+    > sudo dnf install python3-devel python3-Cython python3-numpy python3-pip -y
 
-    > dnf install python3-devel python3-Cython python3-numpy python3-pip -y
+    > sudo dnf install flex valgrind -y
 
     > sudo pip3 install --system pkgconfig GitPython
 
@@ -58,17 +62,6 @@ Trace-Cruncher has the following external dependencies:
     > cd ..
 
 
-    > git clone https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git
-
-    > cd trace-cmd
-
-    > make
-
-    > sudo make install_libs
-
-    > cd ..
-
-
     > git clone https://github.com/yordan-karadzhov/kernel-shark-v2.beta.git kernel-shark
 
     > cd kernel-shark/build
@@ -92,14 +85,16 @@ Installing trace-cruncher is very simple. After downloading the source code, you
      > sudo make install
 
 ## Documentation
+For questions about the use of Trace-Cruncher, please send email to: linux-trace-users@vger.kernel.org
 
-For bug reports and issues, please file it here:
+[Subscribe](http://vger.kernel.org/vger-lists.html#linux-trace-users) / [Archives](https://lore.kernel.org/linux-trace-users/)
 
-https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---
+For bug reports and issues, please file it
+[bugzilla](https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---)
 
 ## Contributing
 
-The trace-cruncher project team welcomes contributions from the community. If you wish to contribute code and you have not signed our contributor license agreement (CLA), our bot will update the issue when you open a Pull Request. For any questions about the CLA process, please refer to our [FAQ](https://cla.vmware.com/faq).
+The trace-cruncher project team welcomes contributions from the community. For more detailed information, refer to [CONTRIBUTING.md](CONTRIBUTING.md).
 
 ## License
 
-- 
2.30.2

