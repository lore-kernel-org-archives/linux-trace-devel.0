Return-Path: <SRS0=g3Xf=24=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88217C33C9B
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DEC021744
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZX73Bqmd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgAGREN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 12:04:13 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45678 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbgAGREN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 12:04:13 -0500
Received: by mail-lj1-f196.google.com with SMTP id j26so280861ljc.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Jan 2020 09:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JFAFLX+LPNPQ8GXuT3eQBa7eWIGR+m1/PWTXdcMuTLk=;
        b=ZX73Bqmdycwh0635YuGuwUz9Ekw98IbJ5WAh/pHQs2+hGWqmOKrK5PFlu9vfMWlK1a
         fsnDqGCZ4+oTFAH+wXoJywu+6mnFBz0Z55YMAP+PpD65gF4svmbNf0zvN7SFd1Gm/FNl
         idQ56AFm5u3z+rFpwtji4irAgmHoRVPKXUS6J8hB8uplHhWaBldjPvBv30YU8WcGfIlW
         GMxAtI6mJeyOzO0SAN79hWpkMvIrihxFLfGnMLHHCUIrbzOsVeaH4o7VPasAetQvcJn6
         pdRsFHu+GRGWTjJiWBV8JtJ02JYpIBOHXsrbRJ4Ci/IyXtUCBtySHOpMWnbWC+1swiSl
         +Mog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JFAFLX+LPNPQ8GXuT3eQBa7eWIGR+m1/PWTXdcMuTLk=;
        b=kJY7XjnL61V+BVlyJDp0osUpvtEyhBUyUUz/ZthHRVA+T2/bmAQ0VE4ruuaE00q2QF
         +Av7e5HNZd+F/tFlsRGTeZ9cFXC5ZHQCA0lyrPR5Z6bEMJAD36j/YF9dcR2LwEyuVcVc
         fsXe2EYNzPr+qOVjHeD3pxJ8G1NWwS27SpF+SO6fhVK8/u96DFQ5QhYSMjlrAf5S7FF4
         E/jg0eNzLIyhZvXl7HFd4gvisa+8NhQiwWy9mw4MNitt54pgfMQyR7JOvWDvsiA1dGVW
         CoTS6vjUkqKxxP6T1nk9SKcLLiejmCZkb2GtYxt/FQIR9ZdGTcig9GtT2itgESO858p6
         k39g==
X-Gm-Message-State: APjAAAVAl4Vpw78evPLGpT5TeDvh9gmsSB495VqZUMbVvsNrICzo6eH/
        OfuZvcqxeHR6jcPFpEBIb8lxesl/
X-Google-Smtp-Source: APXvYqzVDOO6reAHZTM36y2Ls7fwMgzGqfBJabN2vqGSAJRzJLnRX1k+gq68/6+Mu8jfB/RHjlIoIg==
X-Received: by 2002:a2e:83d5:: with SMTP id s21mr267765ljh.95.1578416649257;
        Tue, 07 Jan 2020 09:04:09 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d16sm140605lfa.16.2020.01.07.09.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:04:08 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Douglas.Raillard@arm.com,
        Valentin.Schneider@arm.com, nd@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 10/12] trace-cruncher: Update README.md
Date:   Tue,  7 Jan 2020 19:03:10 +0200
Message-Id: <20200107170312.27116-11-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200107170312.27116-1-y.karadz@gmail.com>
References: <20200107170312.27116-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 README.md | 50 +++++++++++---------------------------------------
 1 file changed, 11 insertions(+), 39 deletions(-)

diff --git a/README.md b/README.md
index c5121ab..2f7d533 100644
--- a/README.md
+++ b/README.md
@@ -4,9 +4,9 @@
 
 ## Overview
 
-The Trace-Cruncher project aims to provide an interface between the existing instrumentation for collection and visualization of tracing data from the Linux kernel and the broad and very well developed ecosystem of instruments for data analysis available in Python. The interface will be based on NumPy.
+The Trace-Cruncher project aims to provide an interface between the existing instrumentation for collection and visualization of tracing data from the Linux kernel and the broad and very well developed ecosystem of instruments for data analysis available in Python. The interface is based on NumPy.
 
-NumPy implements an efficient multi-dimensional container of generic data and uses strong typing in order to provide fast data processing in Python. The  Trace-Cruncher will allow for sophisticated analysis of kernel tracing data via scripts, but it will also opens the door for exposing the kernel tracing data to the instruments provided by the scientific toolkit of Python like MatPlotLib, Stats, Scikit-Learn and even to the nowadays most popular frameworks for Machine Learning like TensorFlow and PyTorch. The Trace-Cruncher is strongly coupled to the KernelShark project and is build on top of the C API of libkshark.
+NumPy implements an efficient multi-dimensional container of generic data and uses strong typing in order to provide fast data processing in Python. The  Trace-Cruncher allows for sophisticated analysis of kernel tracing data via scripts, but it also opens the door for exposing the kernel tracing data to the instruments provided by the scientific toolkit of Python like MatPlotLib, Stats, Scikit-Learn and even to the nowadays most popular frameworks for Machine Learning like TensorFlow and PyTorch. The Trace-Cruncher is strongly coupled to the KernelShark project and is build on top of the C API of libkshark.
 
 ## Try it out
 
@@ -17,55 +17,27 @@ Trace-Cruncher has the following external dependencies:
 
 1.1 In order to install the packages on Ubuntu do the following:
 
-    sudo apt-get install libjson-c-dev libpython3-dev cython3 -y
+    > sudo apt-get install libjson-c-dev libpython3-dev cython3 -y
 
-    sudo apt-get install python3-numpy python3-matplotlib -y
+    > sudo apt-get install python3-numpy python3-matplotlib -y
 
 1.2 In order to install the packages on Fedora, as root do the following:
 
-    dnf install json-c-devel python3-devel python3-Cython -y
+    > dnf install json-c-devel python3-devel python3-Cython -y
 
-    dnf install python3-numpy python3-matplotlib -y
-
-2. In order to get the proper version of KernelShark / trace-cmd do the
-following:
-
-    git clone git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git --branch=kernelshark-v1.1
-
-or download a tarball from here:
-https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/snapshot/trace-cmd-kernelshark-v1.1.tar.gz
+    > dnf install python3-numpy python3-matplotlib -y
 
 ### Build & Run
 
-1. Patch trace-cmd / KernelShark:
-
-    cd path/to/trace-cmd/
-
-    git am ../path/to/trace-cruncher/0001-kernel-shark-Add-_DEVEL-build-flag.patch
-
-    git am ../path/to/trace-cruncher/0002-kernel-shark-Add-reg_pid-plugin.patch
-
-2. Install trace-cmd:
-
-    make
-
-    sudo make install_libs
-
-3. Install KernelShark:
-
-    cd kernel-shark/build
-
-    cmake -D_DEVEL=1 ../
-
-    make
+Installing trace-cruncher is very simple. After downloading the source code, you just have to run:
 
-    sudo make install
+     > cd trace-cruncher
 
-4. Build the NumPy API itself:
+     > make
 
-    cd path/to/trace-cruncher
+     > sudo make install
 
-    ./np_setup.py build_ext -i
+Note that this will automatically download, patch and build the appropriate versions of "trace-cmd / KernelShark" libraries from kernel.org. These third-party libraries will be installed as part of trace-cruncher itself and will not interfere with any existing system-wide installations of trace-cmd and KernelShark.
 
 ## Documentation
 
-- 
2.20.1

