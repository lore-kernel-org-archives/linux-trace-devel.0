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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F2BC11F69
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C66F66140B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbhGALRN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 07:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236175AbhGALRL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 07:17:11 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793CEC0617AD
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Jul 2021 04:14:41 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o35-20020a05600c5123b02901e6a7a3266cso3802584wms.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 01 Jul 2021 04:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=etrNYslhHa6hf62ZVBRiyaX0s97714mN4lbqHlFSZ/s=;
        b=BlO7kgWQPPSOrDDokVopzjQ1z3jt4YtNMGXhpEu7qtxelWiG/XC7Ks6ZgYEUmVpxPY
         U4esnrQAlZHjbg7KQtui2YIAuvL/JitTW9bVrhshVpb38J2u9CyqM0U3oXbtRnHv+OzH
         cnpwnLHuapHr8l8Fu022oqKKGG1IgFtlLtqzBQEE18BAfz80jo7pFC5m8BjhJwRzm90m
         g0Xr2YVmaYyKelgG7A5WgY27peIBTVqIVEeHwAnM1HCngVLJw9Klk0wbUTfQqLOQLHd4
         1WOg0htZywHu8JYpJmdelLr4JU0Dk6dpTQAF6bjfG/OZ/oMy/tOyKr7kNa13zWzu/4+t
         RibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=etrNYslhHa6hf62ZVBRiyaX0s97714mN4lbqHlFSZ/s=;
        b=hwoLsYz3MmgDxyFcpyFY18D+fxCxzHcHk7BVFmkCHViLVPpoDyI2TUPVuD3W27eZzq
         QmTZp7VSaAEeGBzMIlGuLJ2lmyGcna3amNGjGFiClEERreGQM9GNjchRNzfdFeMIiT/f
         s4clqVYTz/uQPOfmGEPWYwLMdUHGrJcmirc9xmSOCsO7bdDql7TxzcM+vLX2wkc84Lzc
         GVZJ6A5Xw/5pUZMRb/CVeKj1w0PQLbJMZPxrQL7i1QGVq9KpkmK4ybiRVgrlClNmEgpw
         AoOGv/hg7KArc9WAVwSWpJdbz8iST8oWDpliTBHpJ2bTjlFsdoWl7CFHpZcEdF3cv1NJ
         sTdg==
X-Gm-Message-State: AOAM533kpNVoalybzfxrp2dnOT6bOks75geUkpTJeOhoHLZelBpA5CV5
        q1qLyWsMHYk6LE9xhphm5iHxD9C9des=
X-Google-Smtp-Source: ABdhPJzVBoAUSP/UE3qntCyRaL3ViqqQokLASLFbbteRoKlXQF6rC0k64cR0xEENbhmu8LBQnLYOaA==
X-Received: by 2002:a7b:cf3a:: with SMTP id m26mr20028050wmg.117.1625138079892;
        Thu, 01 Jul 2021 04:14:39 -0700 (PDT)
Received: from bucy.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id o17sm9223009wmh.19.2021.07.01.04.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 04:14:39 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, warthog9@eaglescrag.net,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 11/11] trace-cruncher: Add github workflow for CI testing
Date:   Thu,  1 Jul 2021 14:14:18 +0300
Message-Id: <20210701111418.18386-12-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210701111418.18386-1-y.karadz@gmail.com>
References: <20210701111418.18386-1-y.karadz@gmail.com>
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

