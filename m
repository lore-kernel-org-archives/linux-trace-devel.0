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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050F6C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D314620700
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbhADRt2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbhADRt2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:28 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244BAC061389
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:48:13 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id qw4so37872579ejb.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7N3iHQmzaB0c/IGxHOSi/RxAkqgGzZImjc6G+ESXAgg=;
        b=dzMI6Kygr4qSWs3QO1xbjeEOfljIvCJYYLxx+fo2N9x/kWKn/vqyt/mi4MZFqzkP3Q
         OUcbMw9E0rWJhlGJ3iJUVIRNeQbJZm2ngpsgFQb/b+8RVBUcdnYPbycLh5litVxH4OLs
         oG59SSR9TQA3T1wn/po+Y3BdijAUGjfArz42ShE8vRaiSjPRbGWmnBS4RGlq1VMYSzh1
         oGy5T7IcL4fXIbRmkazBAPXV6RRefNgkEMeP+Iso3PUiCkMhfiN3aVjzVV8XAGgZWmtS
         /h5yoo55XaebGoaEDm8J9EibIc7atMt5BVHY97DExm43gobQWSk02UJR8IpWfpD9oP4A
         PFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7N3iHQmzaB0c/IGxHOSi/RxAkqgGzZImjc6G+ESXAgg=;
        b=Fh/3pOABPtBRjJMZoIXiXJ1hitmhpQIZOXeLzx0oPkdgKZzm2YsvYTbLWp/QdL2i1o
         TKv6ceswSRpu2X1RtV9G91sIvGZksrlj+Ivc8pmqOFGJk19uaao+rGIcHCBGSetk4c52
         hqx80HKFlKAaWX1B6iWEC0BoWnMHFpiluGr4iB92ATV853mjXPC5vyo6712gUL+o1/XI
         XZD40A8MgWHo+ClpyoKhb1HzqXRxTWhOTbMlt3wFWWdKM3lVxoxrLrr/aRMMlgluSBi8
         Hm82RsOtI/swOll8i7u+0Dmi9WgyoaZk729o5yPsYo6SqR7tHuuku0cYhVe3MrSPuJoK
         gEFQ==
X-Gm-Message-State: AOAM533XCK0mOv7RRF3dcE9LoTowzodve045/g0pTlQTSfbMS7rWWsVD
        ZqNcKfwCQgfn/r+ZJDML4rtEB2QApsNxMw==
X-Google-Smtp-Source: ABdhPJz8dl/W6E739W+7hDvA97/a1bTyaMunjhpLjsRiBjx2frPK6NDaW4Ug5ZMi5deEDENf3K7KWA==
X-Received: by 2002:a17:907:b09:: with SMTP id h9mr68740106ejl.155.1609782491844;
        Mon, 04 Jan 2021 09:48:11 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:11 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 34/44] kernel-shark: Add "github Actions" workflow
Date:   Mon,  4 Jan 2021 19:47:14 +0200
Message-Id: <20210104174724.70404-35-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Yordan Karadzhov <y.karadz@gmail.com>

The workflow will install all third party libraries,
will build KernelShark and will run the tests.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 .github/workflows/main.yml | 63 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100644 .github/workflows/main.yml

diff --git a/.github/workflows/main.yml b/.github/workflows/main.yml
new file mode 100644
index 0000000..a35f003
--- /dev/null
+++ b/.github/workflows/main.yml
@@ -0,0 +1,63 @@
+name: KernelShark CI (CMAKE)
+
+on: [push]
+
+env:
+  # Customize the CMake build type here (Release, Debug, RelWithDebInfo, etc.)
+  BUILD_TYPE: Release
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
+        sudo apt-get install freeglut3-dev libxmu-dev libxi-dev -y
+        sudo apt-get install qtbase5-dev libboost-all-dev -y
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
+        git clone git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git
+        cd trace-cmd
+        make
+        sudo make install
+        sudo make install_libs
+    - name: Create Build Environment
+      # Some projects don't allow in-source building, so create a separate build directory
+      # We'll use this as our working directory for all subsequent commands
+      run: cmake -E make_directory ${{runner.workspace}}/build
+
+    - name: Configure CMake
+      # Use a bash shell so we can use the same syntax for environment variable
+      # access regardless of the host operating system
+      shell: bash
+      working-directory: ${{runner.workspace}}/build
+      # Note the current convention is to use the -S and -B options here to specify source
+      # and build directories, but this is only available with CMake 3.13 and higher.
+      # The CMake binaries on the Github Actions machines are (as of this writing) 3.12
+      run: cmake $GITHUB_WORKSPACE -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_C_FLAGS_RELEASE="-Werror"
+
+    - name: Build
+      working-directory: ${{runner.workspace}}/build
+      shell: bash
+      # Execute the build.  You can specify a specific target with "--target <NAME>"
+      run: cmake --build . --config $BUILD_TYPE
+
+    - name: Test
+      working-directory: ${{runner.workspace}}/build
+      shell: bash
+      # Execute tests defined by the CMake configuration.
+      run: ctest -C $BUILD_TYPE
-- 
2.25.1

