Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7348C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 864DF64EA9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhBARZn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbhBARZj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:25:39 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE04C06178B
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:20 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id bl23so25604096ejb.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3o4JFJE4ZIhEaleh7g9dxBiNEMdj76Ko5GwKXdRPcms=;
        b=dhDUfHcHugQHCgFIgfzmNfgGTa6Za9gIv8hsI5E+yXc0SheliIOVTS/KQcYO/uSX4W
         Nh5Jl4RLSmaQ7OsYMYgTdLGZVrZX2R9XIVeowIp3ENafo69I4+zlncKFWHSKLkM9OC0D
         QqWJcmlgw2xEw48vJ2JTuw8vjASwMNGlfwqAdK9lEgGblbL6VyxCDkjL6SbrRKYK5x0I
         +KSPVriedvqP4asyp4r0OCsiUEBslVESNlfJ6zU3MoFtunyxtzqxoaigg0k0ACHqrtCo
         Q9EVH1/nwEiZ/Ok5sV5MPH13pz+DlvOn/Res+viFPs/YVqdTbTJY6lIy2Qhsa56+Ypg8
         qyTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3o4JFJE4ZIhEaleh7g9dxBiNEMdj76Ko5GwKXdRPcms=;
        b=q3TFLUzO+Mup+qSvj7ig7umFWqJb/n0tuCVn+Kh2AXzMdE45AxCHu57f97fr/du+GX
         4lU2gba+6HoH1S0mQCLPr+dDEEZ7zfXDDoQ/4Yy3bUKDJpPV4/CGuoAtMHll/4wTdzC4
         fHGU81Wqz7hs89IVpiTHjboNpLeoQ9DeRLxiRUCvFPVwGNix2u0wmN8OfVcJG5ZS9XbQ
         K6j7ZDkmMciMm39Y15jDOUBYjkTRlHwuJBIvNHQEdVKYjJlEBXUBHpvSCmj0T+fnLwAj
         dfpczapbBx4UCuuBUmjTydwtJs2xMWF5MU1qI4er2PvyWsnPCY6HVscgz5v7Sz9bMG2w
         jhPQ==
X-Gm-Message-State: AOAM533uKl0UJ1FsN+M7v02L5dpNEH7H/ndq6IVBMqLceJsgjWtXDyvN
        NbNBSPurofb1NB8FWezLiD4=
X-Google-Smtp-Source: ABdhPJzyfJlNe0uBVNfURNHBRd52M2w4hmjHJeTkFLl4oPSWJSKw4/SigTjnH+3uLnKWDsjPVCM94Q==
X-Received: by 2002:a17:906:9588:: with SMTP id r8mr7233359ejx.167.1612200259654;
        Mon, 01 Feb 2021 09:24:19 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:19 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 08/24] kernel-shark: Add trace data files for CI testing
Date:   Mon,  1 Feb 2021 19:23:42 +0200
Message-Id: <20210201172358.175407-9-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch adds a procedure to download two trace data files that
will be used by the CI tests. The files are obtained from a dedicated
github repository. The tests cases using the trace data files will be
added in following patches.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 .github/workflows/main.yml |  8 ++++++++
 CMakeLists.txt             |  3 ++-
 build/cmake_clean.sh       |  1 +
 tests/CMakeLists.txt       |  6 +++++-
 tests/get_test_data.sh     | 21 +++++++++++++++++++++
 5 files changed, 37 insertions(+), 2 deletions(-)
 create mode 100755 tests/get_test_data.sh

diff --git a/.github/workflows/main.yml b/.github/workflows/main.yml
index a35f003..2cce624 100644
--- a/.github/workflows/main.yml
+++ b/.github/workflows/main.yml
@@ -35,6 +35,7 @@ jobs:
         make
         sudo make install
         sudo make install_libs
+
     - name: Create Build Environment
       # Some projects don't allow in-source building, so create a separate build directory
       # We'll use this as our working directory for all subsequent commands
@@ -61,3 +62,10 @@ jobs:
       shell: bash
       # Execute tests defined by the CMake configuration.
       run: ctest -C $BUILD_TYPE
+
+    - name: Upload Artifacts
+      if: ${{ always() }}
+      uses: actions/upload-artifact@v2
+      with:
+        name: artifacts-download
+        path: ${{runner.workspace}}/build/Testing/
diff --git a/CMakeLists.txt b/CMakeLists.txt
index e013916..26fb7ae 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -123,8 +123,9 @@ add_subdirectory(${KS_DIR}/examples)
 
 if (Boost_FOUND)
 
+    set(KS_TEST_DIR                      "${KS_DIR}/tests")
     enable_testing()
-    add_subdirectory(${KS_DIR}/tests)
+    add_subdirectory(${KS_TEST_DIR})
 
 endif()
 
diff --git a/build/cmake_clean.sh b/build/cmake_clean.sh
index f70b545..b534014 100755
--- a/build/cmake_clean.sh
+++ b/build/cmake_clean.sh
@@ -9,6 +9,7 @@ rm -rf src/
 rm -rf examples/
 rm -rf tests/
 rm -rf Testing/
+rm -f ../tests/*.dat
 rm -f ../lib/*
 rm ../kernelshark.desktop
 rm ../org.freedesktop.kshark-record.policy
diff --git a/tests/CMakeLists.txt b/tests/CMakeLists.txt
index 17b586e..0847414 100644
--- a/tests/CMakeLists.txt
+++ b/tests/CMakeLists.txt
@@ -1,6 +1,5 @@
 message("\n tests ...")
 
-set(KS_TEST_DIR                      "${KS_DIR}/tests")
 set(EXECUTABLE_OUTPUT_PATH           ${KS_TEST_DIR})
 
 add_executable(kshark-tests          libkshark-tests.cpp)
@@ -9,6 +8,11 @@ target_compile_definitions(kshark-tests PRIVATE "BOOST_TEST_DYN_LINK=1")
 target_link_libraries(kshark-tests   kshark-gui
                                      ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
 
+add_test(NAME              "get_test_data"
+         COMMAND           ${KS_TEST_DIR}/get_test_data.sh
+         WORKING_DIRECTORY ${KS_TEST_DIR})
+
+message(STATUS "libkshark-tests")
 add_test(NAME              "libkshark_tests"
          COMMAND           ${KS_TEST_DIR}/kshark-tests --log_format=HRF
          WORKING_DIRECTORY ${KS_TEST_DIR})
diff --git a/tests/get_test_data.sh b/tests/get_test_data.sh
new file mode 100755
index 0000000..b935d11
--- /dev/null
+++ b/tests/get_test_data.sh
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+TEST_DIR=`dirname $0`
+TEST_DATA_DIR=kernel-shark_testdata
+TEST_DATA_REPO=https://github.com/yordan-karadzhov/${TEST_DATA_DIR}.git
+
+rm -fv ${TEST_DIR}/*.dat
+
+if [ -d "${TEST_DATA_DIR}" ]; then
+    rm -rf ${TEST_DATA_DIR}
+fi
+
+git clone ${TEST_DATA_REPO}
+
+if [ ! -d "${TEST_DATA_DIR}" ]; then
+    exit false
+fi
+
+rm -f ${TEST_DATA_DIR}/LICENSE
+cp -v ${TEST_DATA_DIR}/* ${TEST_DIR}/
+rm -rf ${TEST_DATA_DIR}
-- 
2.25.1

