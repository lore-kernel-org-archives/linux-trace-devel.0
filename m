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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3438C43462
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94CD261221
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237632AbhDSNCi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 09:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239332AbhDSNCc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 09:02:32 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9954CC061761
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Apr 2021 06:02:02 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id k128so18145191wmk.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Apr 2021 06:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=etrNYslhHa6hf62ZVBRiyaX0s97714mN4lbqHlFSZ/s=;
        b=q/g1qE2IvkxFfYENvhdcv0uL17CgcrUmf+1ujRYkmyTgOu5xoYnlBV+X8Q+UFFo40b
         6wB5njDMUXA5sF0EO881uw0Lk2k1c1d62hHxOCPap0sUJ9kB3e1pPPsd19cND2Iut5lP
         KGpmblpTsL1PKG73EgcKKH16QIbigegcKWP4ep+rSoSxPNeOVMrg1Uj8hSpJmaC7VSlC
         geuNEToS6sLf+TEySCjVIecHTzISUbe7OW/nRaXWFy48Z2J7z4Lf9fyBluu5RcdVHRIE
         95NqzPmG0YJ6i1kkD5kAMUjFFNLRhz7GG83fcZJsS7Sq8oCjUCGvC6j4wh9h+RSSB7x9
         w68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=etrNYslhHa6hf62ZVBRiyaX0s97714mN4lbqHlFSZ/s=;
        b=XWqBxHKkmksl3MTWrPrJ7UTdzJxrBfIS6oY0GtGXNg1skSAlhIEcBcICGUrf4xm5Vz
         nfpE8KGuW+6jzcjZ5ymdvj2sXhdGxmpCVBxhqWMxM7YBVp8n6SC8q7nZ+s6AZp7DuwJl
         LxKjd5d2UcXrNYS8bWZoAOTW3eiOF0fUOzm8L3QuvzBE8z/EzfFoQ98I69pS/oA0qdJp
         WYj0z5oBKYXiOsYXAgZs6OIiPjW0TqXEXr5pTzdc2eWAxgaqbWXpHDlfy1qj0TQhEoIG
         kjEdJRWkRCSGHsK84eekQHHYAF+UQ0hPwSyXvfxFYnU5HKDff4EfkXpgFTRLgHbpIra5
         CPqQ==
X-Gm-Message-State: AOAM530d98QzlHdUaOC6nkgNtReFVzaBlOEn5xtYyft3Cw0ChpnadfKC
        ceCyumME4ip3jaY5hZv+bJCDkjSk6Ks=
X-Google-Smtp-Source: ABdhPJwaj9Gm6Xa08ygrJVDZg/WRDwbnH/Y68lzkd4xLXc2GTnA9qkuKMgDMTrAeYMKghkYr4VW/5g==
X-Received: by 2002:a1c:b342:: with SMTP id c63mr21534893wmf.162.1618837320945;
        Mon, 19 Apr 2021 06:02:00 -0700 (PDT)
Received: from bucy.vmware.com ([84.40.93.28])
        by smtp.gmail.com with ESMTPSA id v7sm23164196wrs.2.2021.04.19.06.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 06:02:00 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 9/9] trace-cruncher: Add github workflow for CI testing
Date:   Mon, 19 Apr 2021 16:01:40 +0300
Message-Id: <20210419130140.59140-10-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210419130140.59140-1-y.karadz@gmail.com>
References: <20210419130140.59140-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The CI workflow will run once a week, or on any push to
branches "master" and "yordan_devel".

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 .github/workflows/main.yml | 58 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)
 create mode 100644 .github/workflows/main.yml

diff --git a/.github/workflows/main.yml b/.github/workflows/main.yml
new file mode 100644
index 0000000..94abf64
--- /dev/null
+++ b/.github/workflows/main.yml
@@ -0,0 +1,58 @@
+name: trace-cruncher CI
+
+on:
+  push:
+    branches: [master, yordan_devel]
+  schedule:
+    - cron:  '0 15 * * THU'
+
+jobs:
+  build:
+    runs-on: ubuntu-latest
+
+    steps:
+    - uses: actions/checkout@v2
+
+    - name: Install Dependencies
+      shell: bash
+      run: |
+        sudo apt-get update
+        sudo apt-get install build-essential git cmake libjson-c-dev -y
+        sudo apt-get install libpython3-dev cython3 python3-numpy -y
+        sudo apt install python3-pip
+        sudo pip3 install --system pkgconfig GitPython
+        git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
+        cd libtraceevent
+        make
+        sudo make install
+        cd ..
+        git clone https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+        cd libtracefs
+        make
+        sudo make install
+        cd ..
+        git clone https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git
+        cd trace-cmd
+        make
+        sudo make install_libs
+        cd ..
+        git clone https://github.com/yordan-karadzhov/kernel-shark-v2.beta.git kernel-shark
+        cd kernel-shark/build
+        cmake ..
+        make
+        sudo make install
+        cd ../..
+
+    - name: Build
+      working-directory: ${{runner.workspace}}/trace-cruncher
+      shell: bash
+      # Build and install.
+      run: |
+        make
+        sudo make install
+
+    - name: Test
+      working-directory: ${{runner.workspace}}/trace-cruncher/tests
+      shell: bash
+      # Execute tests defined by the CMake configuration.
+      run: sudo python3 -m unittest discover .
-- 
2.27.0

