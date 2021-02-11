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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8186BC433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E22E64E9A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhBKKgh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhBKKeE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:34:04 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFF4C061794
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:30 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y18so6359053edw.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3o4JFJE4ZIhEaleh7g9dxBiNEMdj76Ko5GwKXdRPcms=;
        b=FHW9wzSMpCeCuWzk0c9BFPxbVpJSliGhICPOi4BRY0p7liSs5fAc29CPtD/78cPe73
         98an3tvH7lUBYmUTlgp3O71XClb+CawfBmlJ9T/Ugg7BOHukp4aeWn5zyyMPYBvdflat
         31BKf0AiOejQNJ/I8jVWirLGkDmj3z2WJmVLXzpGz3N2MDcpe9E5ObhSS88UJbkajRg8
         /m90izL6Q2ZTd2RtbAFfcDZoJhXMRAY32BvhLU02b3z3TP9bnrfgQ9JhPtGsA5jXb09j
         39cR3nFq66y8EG4W3BN8u4Q5JUNp2Pd+2+sqG+RJHXVnFw8zoRF/WWHUOMuKwQzubQCY
         1kTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3o4JFJE4ZIhEaleh7g9dxBiNEMdj76Ko5GwKXdRPcms=;
        b=Vb43SVrjhW9ltzTCY+h2QSiwzFyZ4N2ZAFLZg05ysbOJ4QFLnL08O73kbc6LPHm0V9
         DNrWdmU89ZPK9nk3Xe/cbEZZkS9isoduju5azHEDjl894b51hS88Q+z92GER0AuaijG5
         G6ihzCsYIV00t31rprRwwHLChj8FcDkgVqiXwUU0RusEG1yllFMHhZSCmOe+oRuaWuyo
         ZzGt9SUrs2xU8NMJGOPQOhkPZtYANtAn+Lrp0Q8SMXyYcTlT+O/TzVS5Tl0S5RNwUwdC
         V8OiTUqFq2LvNVv62GbhyMpDHvnEBYHRErwTrPPt9IAAgPCtkHhtVeAETLFI1IH+GkKr
         Rt0Q==
X-Gm-Message-State: AOAM531qEVKhllxSRLnKC3/EP3k60dt+7rkuz748U681B82kFTLxSn0m
        zukZ281YDnIcx2OZfjTbyoc=
X-Google-Smtp-Source: ABdhPJxQZq3zhQyLVU1vNzyL4NhmnvgRM5CZPY+HgFHEvnYjDbt+SkzBZ2U7EraqYiXiaXDaPl58FQ==
X-Received: by 2002:a50:fe11:: with SMTP id f17mr7698951edt.88.1613039549178;
        Thu, 11 Feb 2021 02:32:29 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:28 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 08/27] kernel-shark: Add trace data files for CI testing
Date:   Thu, 11 Feb 2021 12:31:46 +0200
Message-Id: <20210211103205.418588-9-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
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

