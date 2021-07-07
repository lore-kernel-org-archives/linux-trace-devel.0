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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE1E9C07E95
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5CB561C42
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhGGNZE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 09:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbhGGNZD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 09:25:03 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5B9C06175F
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jul 2021 06:22:22 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id v20so3218140eji.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Jul 2021 06:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=etrNYslhHa6hf62ZVBRiyaX0s97714mN4lbqHlFSZ/s=;
        b=kxm1teaigskw0qY8cKjCXtrcPAMk19IW2lKkL/eLf6zluTc+8xK/yk5YYsoIViV9OP
         LSDbLAoOWhql/hj55/PgSnuXdnLBfLu0p+ZRpXL/TfmdCXK+elJW3zkTXIEvnxtuJNe0
         IxbsVgZL1i/ydKLAJvBLoLHSZVN1C+2hn70bFNE9WvP6niFMYx0VtiDt+JFaCfcSieGL
         n1GlPEi7tRakGgBjxiXZn1MXhfRuSM2z6AmpjewvRTMDIonxdDsQnHb4k9dpLGuLEyjO
         flpELajJiAeuNe6qQxs7C+fL5evEM8RpmDQeUc4/hpUPszScQKsydnUbefFVgWJ6RHq/
         VzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=etrNYslhHa6hf62ZVBRiyaX0s97714mN4lbqHlFSZ/s=;
        b=gauXpQHNV1z//4G2TLw+6pnUVwQOtNDG8ehRXntmyDhOdqzp3EFM9SyI/5b8UgYwCk
         2v/WPU/yjzEgmEZmlzqq5dRUPURa55PKn+8Ft/TBOOHFyTbsD8a/MrFaVX5MTdjfhj1l
         Brdpy+IviorhTUY9uCXp+ZDrm0E+FsjCnAgsy0ABu09IGPequDNcdbrGCXrJbyekIPR6
         vofAY2ttdrgxr1PTO71C7W1oOn1ZrNX2Ob2sKKmZCdesGa4jE/AgQa5+21q5ob5qkOGt
         CB6VPHQzSN1HGtIT0CF7ZpbLKj5OIkcnbvo623bsM5+Goks1sxapE8dZGk7WTcKu1f4N
         qkWA==
X-Gm-Message-State: AOAM530WN++UyaBfalcEActPgHf501+l296QkGzxThFerg1p5izC9U64
        NEraTjohg3X9GpP3nwESFbaCMteTbr0=
X-Google-Smtp-Source: ABdhPJz0OdGdLC2U65wBPnD5oxlUmYYR5yctqwS7utlB1sots/OhGZTCssINAUeJokOtqpQCqLYvtQ==
X-Received: by 2002:a17:906:b190:: with SMTP id w16mr24464135ejy.332.1625664140997;
        Wed, 07 Jul 2021 06:22:20 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id eb9sm7064881ejc.32.2021.07.07.06.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 06:22:20 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 11/11] trace-cruncher: Add github workflow for CI testing
Date:   Wed,  7 Jul 2021 16:21:58 +0300
Message-Id: <20210707132158.68520-13-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210707132158.68520-1-y.karadz@gmail.com>
References: <20210707132158.68520-1-y.karadz@gmail.com>
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

