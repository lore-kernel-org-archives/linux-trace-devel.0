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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A50C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98DDC23329
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391079AbgLKPKf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392698AbgLKPKO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:10:14 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58880C0619DC
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:50 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id c198so7832952wmd.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mPz1zY1zvPzg+HZXSlyn7FR8XjTdBpKCpat7TPTDU/Q=;
        b=s/7klphAb+OVSB5+Y+Tk86OYLtb5GcWdV0mECNY3/hePA0dvbzPsLE+Dz8ZU/CcLb3
         Mc7TbCCPhiztPDW45jrXvJ7hSiMSs+evYjlAzBRr1nn+OcZP1Z5JsWUzMWgdLStzqKPo
         ETePr4vyvVLGZRUVD3kXKA6TInKOnaoKSUwcrJNUf6uvlAHkKmy5taY9PCE7xRu0g6hR
         OcHi8QOo1mBPEFX5tZ7cuSuidhaH6xvJc1989nkHd/pLeRY92nO0G4qfRoPqbYfoyRUu
         wZtvqyPbw4AMUv+hfvYUAVpnWUYsb2EuVRP9uq6mg1/8+5dBOWMfQctcerNM7a1QtHYi
         70gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mPz1zY1zvPzg+HZXSlyn7FR8XjTdBpKCpat7TPTDU/Q=;
        b=K460bA8FSo44i/Tpk2NJgj9WEqTli/vckJWWi4Caw5ZfXU8JmQe5ixn5G4EMD0jBCw
         8hDtk7mc0HVUZBk4mIQN1qdC4xRufIA0HIiXN03DCunMxiNVggtM5eybpq2Xzd966JUq
         ONQ77Ttf6HVjgLCvvik8NFny1jZBecEYCnJxzk8LdHuUILf/k9tELqpoHDdMISbxOdBV
         NEoQXCQoqzyukLb+PXa0w/sHR10oA1Jmd+PpSqwOIkJx39zoYIIAsn2K3hRlREfke0jW
         UsbvK6sGNgmnTvWY0mG4BFthaGG/rynugSGuS0+QZ3WqQlxOh9Qf7gb1ScIrtGkIWZ2A
         i35Q==
X-Gm-Message-State: AOAM5301oHIeI3IQq4vkZdd2WcuD0UGdwCjzZpKjP6BOlVgUjHKOuN8L
        e4RxBwcmPxVFeYcACLAVzaQ=
X-Google-Smtp-Source: ABdhPJyslHP0XUb7jEnspN89CN6X+52aFZ2ULAVqEqRAbWXqYqEAXGA7SMOD66MqHPRmDgR4PZPgzA==
X-Received: by 2002:a1c:e10b:: with SMTP id y11mr14408572wmg.65.1607699329058;
        Fri, 11 Dec 2020 07:08:49 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:48 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 32/32] kernel-shark: Add "github Actions" workflow
Date:   Fri, 11 Dec 2020 17:07:56 +0200
Message-Id: <20201211150756.577366-33-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
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
 .github/workflows/main.yml | 61 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 .github/workflows/main.yml

diff --git a/.github/workflows/main.yml b/.github/workflows/main.yml
new file mode 100644
index 0000000..e818f46
--- /dev/null
+++ b/.github/workflows/main.yml
@@ -0,0 +1,61 @@
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

