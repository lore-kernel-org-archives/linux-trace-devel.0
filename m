Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45619C2BBCA
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13BEF239E5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732568AbgLINnz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732556AbgLINnz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:43:55 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96F1C0619D8
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:42:44 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id x22so1511738wmc.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xYDdkd4Naz1qJjqR3nqXAxILoqKFvD+WrVTeGHXtylw=;
        b=vMqIS3mJ0e6qoveoIClc7eAZ9v/r9TnYC2+X22y20gyBh0HhHCIIWX/0SWYimBQ9bJ
         1fQ5O/f8iaqihdPmbUaO+WAh0RkVYDzqvnGKT3F7AET3p0qgVWhfDlFOmj5TL7EkD9f3
         /3T97qyCOMjoymJ2vLpHw1KkeeO4GZ8mcPeRK4+9/3CpXqZfizu8+Qpn1rVRE90YC0dr
         izlOBY1iiYdnu3P1vYZLkOtWfcdGISiYaZU8BB/p1A1xvte8LMHYATc7cOgYfe6ZVzP+
         jZ5UUoH9MBTJHcshU+j0NV7/tBKfmBuQ7zRsHBI+NtgEMQm1MJ/PV2ZWBy/a5jbvhBPq
         m7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xYDdkd4Naz1qJjqR3nqXAxILoqKFvD+WrVTeGHXtylw=;
        b=ViX77dpe3TVkbGilMI8SWWfCujnkBNV6oV0JC858vNgu4y8JTA9I+QdQf10K1l0o/S
         C1x6Vgj/azFrSfYhW9sYvpfzEQur9Q2SkN1pUpHCIy3GOng5bpbTNvmEtFkBKnDXdZxq
         NhnbtN8EYXO7sSq9/4VwTLXoohpxFaxXFousLN7Z0bs/Z9YGJNCQ1HMsAkvUcR7UMewM
         Lv77YrhhrjpwJatEaTja7rViZSxPZCsPmhaqMcEMz198W0JEmaR1yqZPQHQJNQKrO2Qt
         vwEg1b05ekLk50fMN4A2gKrnUfb1EQDcAAFiv4DgnY1xhQCDMcHireG4+msa4jPVAkGa
         rgdg==
X-Gm-Message-State: AOAM53139SRSnhkFpwUNoIycyjZhHqznjNdV7HEJSkS33/84NHDXkEyD
        nsz1MVWBPw9msS3bWTuRQyD+5DgTS60=
X-Google-Smtp-Source: ABdhPJxFIXDuPZjy34vZFGePKsEDviW0ni2ySAnf1LSwTLxwyhfdc4gGxNS0SnFkzWdWmZrqFTSyNw==
X-Received: by 2002:a7b:c308:: with SMTP id k8mr2842237wmj.76.1607521363570;
        Wed, 09 Dec 2020 05:42:43 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id q143sm3871071wme.28.2020.12.09.05.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:42:43 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 26/27] kernel-shark: Add basic infrastructure for testing
Date:   Wed,  9 Dec 2020 15:42:02 +0200
Message-Id: <20201209134203.428068-27-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134203.428068-1-y.karadz@gmail.com>
References: <20201209134203.428068-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tasting infrastructure is based on GTest (CMake-provided
feature for automated testing) and Boost Test Library. In the
patch we also provide a very simple test of adding/removing
Data streams. For the moment this single test is used mainly to
validate the proper functioning of the tasting infrastructure
itself. A proper test coverage of the libraries is yet to be
implemented. In a following patch we will integrate the tasting
infrastructure into a "github Actions" workflow that will help
the CI process.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt            |  9 ++++++++
 build/cmake_clean.sh      |  4 ++++
 tests/CMakeLists.txt      | 14 ++++++++++++
 tests/libkshark-tests.cpp | 48 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+)
 create mode 100644 tests/CMakeLists.txt
 create mode 100644 tests/libkshark-tests.cpp

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 3d17977..cb95935 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -38,6 +38,8 @@ if (Qt5Widgets_FOUND)
 
 endif (Qt5Widgets_FOUND)
 
+find_package (Boost COMPONENTS unit_test_framework)
+
 set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
 set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 
@@ -91,6 +93,13 @@ message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
 add_subdirectory(${KS_DIR}/src)
 add_subdirectory(${KS_DIR}/examples)
 
+if (Boost_FOUND)
+
+    enable_testing()
+    add_subdirectory(${KS_DIR}/tests)
+
+endif()
+
 if (_DOXYGEN_DOC AND DOXYGEN_FOUND)
 
     message("\n doxygen documentation ...")
diff --git a/build/cmake_clean.sh b/build/cmake_clean.sh
index 2e7c8f9..f70b545 100755
--- a/build/cmake_clean.sh
+++ b/build/cmake_clean.sh
@@ -2,9 +2,13 @@ make clean
 rm CMakeCache.txt
 rm cmake_install.cmake
 rm Makefile
+rm CTestTestfile.cmake
+rm DartConfiguration.tcl
 rm -rf CMakeFiles/
 rm -rf src/
 rm -rf examples/
+rm -rf tests/
+rm -rf Testing/
 rm -f ../lib/*
 rm ../kernelshark.desktop
 rm ../org.freedesktop.kshark-record.policy
diff --git a/tests/CMakeLists.txt b/tests/CMakeLists.txt
new file mode 100644
index 0000000..a1e3085
--- /dev/null
+++ b/tests/CMakeLists.txt
@@ -0,0 +1,14 @@
+message("\n tests ...")
+
+set(KS_TEST_DIR                      "${KS_DIR}/tests")
+set(EXECUTABLE_OUTPUT_PATH           ${KS_TEST_DIR})
+
+add_executable(kshark-tests          libkshark-tests.cpp)
+target_include_directories(kshark-tests PRIVATE ${Boost_INCLUDE_DIRS})
+target_compile_definitions(kshark-tests PRIVATE "BOOST_TEST_DYN_LINK=1")
+target_link_libraries(kshark-tests   kshark
+                                     ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
+
+add_test(NAME              "libkshark_tests"
+         COMMAND           ${KS_TEST_DIR}/kshark-tests --log_format=HRF
+         WORKING_DIRECTORY ${KS_TEST_DIR})
diff --git a/tests/libkshark-tests.cpp b/tests/libkshark-tests.cpp
new file mode 100644
index 0000000..27c1171
--- /dev/null
+++ b/tests/libkshark-tests.cpp
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2020 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+// Boost
+#define BOOST_TEST_MODULE KernelSharkTests
+#include <boost/test/unit_test.hpp>
+
+// KernelShark
+#include "libkshark.h"
+
+#define N_TEST_STREAMS	1000
+
+BOOST_AUTO_TEST_CASE(add_remove_streams)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	int sd, free = 0, i;
+
+	kshark_instance(&kshark_ctx);
+
+	for (i = 0; i < N_TEST_STREAMS; ++i) {
+		sd = kshark_add_stream(kshark_ctx);
+		BOOST_CHECK_EQUAL(sd, free);
+
+		kshark_add_stream(kshark_ctx);
+
+		free = i / 2;
+		kshark_remove_stream(kshark_ctx, free);
+		sd = kshark_add_stream(kshark_ctx);
+		BOOST_CHECK_EQUAL(sd, free);
+
+		free = i / 2 + 1;
+		kshark_remove_stream(kshark_ctx, free);
+	}
+
+	BOOST_CHECK_EQUAL(kshark_ctx->n_streams, N_TEST_STREAMS);
+
+	while (sd > 0)
+		sd = kshark_add_stream(kshark_ctx);
+
+	BOOST_CHECK_EQUAL(kshark_ctx->n_streams, INT16_MAX + 1);
+	BOOST_CHECK_EQUAL(kshark_ctx->stream_info.array_size, INT16_MAX + 1);
+	BOOST_CHECK_EQUAL(sd, -ENODEV);
+
+	kshark_close_all(kshark_ctx);
+}
-- 
2.25.1

