Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465C6C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Jun 2022 22:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344892AbiFJW4y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Jun 2022 18:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344800AbiFJW4y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Jun 2022 18:56:54 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCBB38793
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Jun 2022 15:56:53 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id e24so718264pjt.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Jun 2022 15:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=24yHZDVoxY0TG+gtZtQ0/uSJrJYbT3lHB6QP99UeLDI=;
        b=k09+KIh7l+EdWxaEVi6xQ5BBIHZK9tWQAkLN0v1DWzEDSDdyl6bB7MZYCzdqrWvOMZ
         53LNkD5cW1hqYOoYrT6OsS8zAyM6dAFYA6OrM6180Bw4Y+8yVOXXm4hdQcF36votyuQq
         eiG7Q3LtQMHvk8W61tWYYFgz4IrhbCulcIL52D6tlO10H+6bP8fgYeEndOc4ClNbw+Px
         2nzU62Un4nsj9vaNKv8jV1jMzY3C9Xi0fHY3AKdjmJ4LuyX4dCU+HrAAQYa+FsdcxWdw
         flCLI9O+mFqL7zTqJbPbJMuwg6vXUokfOVx/YPWFZDDBaeeDlt51hdVSalOL+lskQQxL
         oANw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=24yHZDVoxY0TG+gtZtQ0/uSJrJYbT3lHB6QP99UeLDI=;
        b=ch4fWil6aUZJHrlfB+F+2q72o3uEiLESDBjOm4oxJ3R3F9TcX1jsWidgEEyIgNQS/Q
         5/MhAJD1qDBFitr8904tgVzfb2p0O2cG58Tw2grzWvp/BvlQ6sxzoE5AOY73bTMJU+sA
         2FsVyLxzOVwvxr8Bpxai7EdI2cg+X7USDXNuehFrfJAR7GgjoWkbOiwfcCDzeQ6SFQkf
         hHNgT7lht6UtlT4bczx4CwbaKLgTZR8Pah0fsuvVgOENYkiONXSwykIMxDekYlvtvdil
         uykIR4wp6Pyx0nY98PkybXvzYZ1NcdIxJsFslweavjoW3jole0SCgu/rJVDQ6l1Hh7hw
         YUfg==
X-Gm-Message-State: AOAM532acsbMV+M6AtZEp05nBLT9VudJ4Xu1WdQFZbugrt75xSwbpzNi
        BJxj9hQHEY8Uomxp2CAIl25SRZ00Xe2i8LBw
X-Google-Smtp-Source: ABdhPJzTfHI7MlwDCXmxhnutbhev7s/1BMhGpe5ygS/6ygkX1CV9HJ2N71nkzGnmrfoiP7jMVyW3xg==
X-Received: by 2002:a17:90a:bd89:b0:1e3:50de:5ccf with SMTP id z9-20020a17090abd8900b001e350de5ccfmr2042281pjr.104.1654901812125;
        Fri, 10 Jun 2022 15:56:52 -0700 (PDT)
Received: from kjune-z01.localdomain (c-73-170-198-111.hsd1.ca.comcast.net. [73.170.198.111])
        by smtp.gmail.com with ESMTPSA id l4-20020a170903120400b001620db30cd6sm228914plh.201.2022.06.10.15.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 15:56:51 -0700 (PDT)
From:   June Knauth <june.knauth@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "June Knauth (VMware)" <june.knauth@gmail.com>
Subject: [PATCH] trace-cruncher: README updates; add Testing, reformat, and fix deps
Date:   Fri, 10 Jun 2022 15:55:54 -0700
Message-Id: <20220610225554.5275-1-june.knauth@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "June Knauth (VMware)" <june.knauth@gmail.com>

This patch covers several small improvements in the README. They are:
1. Removal of the > characters and excess linebreaks to improve readability
2. Addition of two dependencies to the manual install instructions:
binutils-dev and pkg-config.
3. Addition of a "Testing" section

Signed-off-by: June Knauth (VMware) <june.knauth@gmail.com>
---
 README.md | 104 +++++++++++++++++++++---------------------------------
 1 file changed, 40 insertions(+), 64 deletions(-)

diff --git a/README.md b/README.md
index 95cbd8e..cba5495 100644
--- a/README.md
+++ b/README.md
@@ -17,83 +17,59 @@ Trace-Cruncher has the following external dependencies:
 
 1.1 In order to install all packages on Ubuntu do the following:
 
-    > sudo apt-get update
-
-    > sudo apt-get install build-essential git cmake libjson-c-dev -y
-
-    > sudo apt-get install libpython3-dev cython3 python3-numpy python3-pip -y
-
-    > sudo apt-get install flex valgrind -y
-
-    > sudo pip3 install --system pkgconfig GitPython
+    sudo apt-get update
+    sudo apt-get install build-essential git cmake libjson-c-dev -y
+    sudo apt-get install libpython3-dev cython3 python3-numpy python3-pip -y
+    sudo apt-get install flex valgrind binutils-dev pkg-config -y
+    sudo pip3 install --system pkgconfig GitPython
 
 1.2 In order to install all packages on Fedora, as root do the following:
 
-    > sudo dnf install gcc gcc-c++ git cmake json-c-devel -y
-
-    > sudo dnf install python3-devel python3-Cython python3-numpy python3-pip -y
-
-    > sudo dnf install flex valgrind -y
-
-    > sudo pip3 install --system pkgconfig GitPython
-
+    sudo dnf install gcc gcc-c++ git cmake json-c-devel -y
+    sudo dnf install python3-devel python3-Cython python3-numpy python3-pip -y
+    sudo dnf install flex valgrind -y
+    sudo pip3 install --system pkgconfig GitPython
 
 2 In order to install all third party libraries do the following:
 
-    > git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
-
-    > cd libtraceevent
-
-    > make
-
-    > sudo make install
-
-    > cd ..
-
-
-    > git clone https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
-
-    > cd libtracefs
-
-    > make
-
-    > sudo make install
-
-    > cd ..
-
-
-    > git clone https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
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
-    > git clone https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/
-
-    > cd kernel-shark/build
-
-    > cmake ..
-
-    > make
-
-    > sudo make install
-
-    > cd ../..
+    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
+    cd libtraceevent
+    make
+    sudo make install
+    cd ..
+
+    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+    cd libtracefs
+    make
+    sudo make install
+    cd ..
+
+    git clone https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+    cd trace-cmd
+    make
+    sudo make install_libs
+    cd ..
+
+    git clone https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/
+    cd kernel-shark/build
+    cmake ..
+    make
+    sudo make install
+    cd ../..
 
 ### Build & Run
 
 Installing trace-cruncher is very simple. After downloading the source code, you just have to run:
 
-     > cd trace-cruncher
+    cd trace-cruncher
+    make
+    sudo make install
+
+### Testing
 
-     > make
+To execute the unit tests run the following from the `trace-cruncher/tests` directory:
 
-     > sudo make install
+	sudo python3 -m unittest discover .
 
 ## Documentation
 For questions about the use of Trace-Cruncher, please send email to: linux-trace-users@vger.kernel.org
-- 
2.25.1

