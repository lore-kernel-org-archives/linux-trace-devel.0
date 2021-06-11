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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C171CC48BD1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7212613CD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhFKLn2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 07:43:28 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:37414 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbhFKLn2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 07:43:28 -0400
Received: by mail-wr1-f45.google.com with SMTP id i94so5734966wri.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Jun 2021 04:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=etrNYslhHa6hf62ZVBRiyaX0s97714mN4lbqHlFSZ/s=;
        b=ktRsBWzQEJgOQFkrijPPtzUCRcBmNZgShFZKkxxMXyrw3jxWGPx6k5gbWgj66B5gKX
         XWq2g4w3Vc0jnddOLtOuQI7TXO5HK+1aEOwvBtjALqkdMfUD7l7EFHlyDfBpbSCI3UmN
         sy5meCGFFiwu34orKeoexLd6ewKipotc0PYml0+MxzNpefTzHL3ydQW7E3SQNFqzBfHb
         qPeu4abO9r/alTtuhx0Nc9+jpHNV+GV7/SO0jN4p90TZk2CroJwXFAj9qoU8Osj1G1Sm
         O4plPuDMX8kazaVxklUxeaNogv4KNn9QnHN9CnRLeXwS9qGG1CSR5keID319QYk3FDMs
         atzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=etrNYslhHa6hf62ZVBRiyaX0s97714mN4lbqHlFSZ/s=;
        b=b/5eLPvfHhB9DL7IX++p5VvbPyuxXfPeTyfiRpozML6aRaa84piTQ21GcQMggJaMse
         TWqcO5LDPa5y+dQJPI1LRE8g+3Q1MZy1/xctTjXVY34ebpB9KoJSYstOueoSyMvLYJTm
         6IYLFJ6DtaZyNR14RXyc+E/Yc5HyQrH5gJ8DWX9tcwORMSm5FiynArRT10fp6V4bC3aR
         gtQ1pDPMihYdCdg9tMXgi8h0ka+c02jgqvSNv0VQIfNdwjI/2cNjNWnE1nPfjPQkZwyz
         8ViPIlogR7GRLlDLX2vj1IJvgDwX+1sX2GDkh1cwvAaTnAsIj5njkAXlg2xzWEOkz6Rb
         c3Rg==
X-Gm-Message-State: AOAM531iYh6HM5i8rGov+26P3Ge2nZK2VCxn/jCpcoowjEpXJYjHPmoo
        g61Dg5UKXQ5G5skhgMO7iuGc52+82Sw=
X-Google-Smtp-Source: ABdhPJzQvcHwAX28qU7xR5zSKEH5lFHhYAN2i/OtH/75hLVzdZy6GCoRCJjLutQHzDOA7LWuUBAc2w==
X-Received: by 2002:a5d:4d09:: with SMTP id z9mr3607463wrt.5.1623411617009;
        Fri, 11 Jun 2021 04:40:17 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.164])
        by smtp.gmail.com with ESMTPSA id c7sm6856464wrs.23.2021.06.11.04.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 04:40:16 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 9/9] trace-cruncher: Add github workflow for CI testing
Date:   Fri, 11 Jun 2021 14:39:58 +0300
Message-Id: <20210611113958.38142-10-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611113958.38142-1-y.karadz@gmail.com>
References: <20210611113958.38142-1-y.karadz@gmail.com>
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

