Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE5AC43332
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0F1120715
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbhADRto (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbhADRtn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:43 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313C5C061388
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:48:12 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y24so28197871edt.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QMdBqes0O1rtDdupS5aMe2/0Trfu9V4omes3kcRL98M=;
        b=hcCqY57nLoqmsfaIiJyn5ozwWt930vScve5uNj+BM5Zr798ykIoBrcWWOniNzKSnJL
         MbGoaBMB3naC+Y+PIGssGPQ+xQPk53qKTrEizjGBirnbxN+e8TGBPdApqiek7thAq0En
         LdiwPiin8trr4Rv9FtnFVqKwtOykmNDtA+RBwhxJ2jSRG75j+6LvJFb7WPdd8j/YEqVb
         VnArFPffUK82/3hd/2vkkFEO9RzYQTqC4kmU4+E7YmOmgs7ECsGBRTOjv8xTkq6hulJH
         oBgYmBsO4yxkg29J9D/yCzQPivKpjCLdCiQ0+u/4HpyubwLluRiAfVoiFqeR34Ec3mmo
         j49Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QMdBqes0O1rtDdupS5aMe2/0Trfu9V4omes3kcRL98M=;
        b=RApV/gjEjKBa1nJCpHnrih7dVj/+vDo7BD9omOudnPr5iJHCD06CZ155npMsBaJ43u
         K3KBC/1xo5AFKsRYFf+wSHcdpIJvlryGMlQBfFt0X/Z/jcpeb90EBAampCFh7RM39alP
         jUxx0jR2aKlKSZxslEWaCSPGtVkHe0Ps/XD4xW53nsfctYiWixF7WfGIpBS9TOBUSOnQ
         3bv/6dq0WXaNzbYXuUz1XLfsdlss5xOHpHo5RocP/Vgh8F91DG+QC+fltJUIBNZOppkJ
         GrSqNUROC5Ob8rdJDAmmHjiclMsS5BfipoHCAGBNefrctUuvgUXy+JGWPCu55W2pwJh2
         IsVQ==
X-Gm-Message-State: AOAM533kESMf+oyD9/pyMowARyiehNkXTw7rBDKpwCMtSZgFTLgopA32
        qjenYqUBNWJUbe2nFgqNvkg=
X-Google-Smtp-Source: ABdhPJwq2RvZm9QWZ2Bbomp19dlza0F12g9iXLfqRg0WWW7Ojgzik1G5belzRwQxkWcdW1QaMxKlRQ==
X-Received: by 2002:aa7:c543:: with SMTP id s3mr71067785edr.88.1609782490959;
        Mon, 04 Jan 2021 09:48:10 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:10 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 33/44] kernel-shark: Add basic infrastructure for testing
Date:   Mon,  4 Jan 2021 19:47:13 +0200
Message-Id: <20210104174724.70404-34-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
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
index 411163d..9abacd0 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -57,6 +57,8 @@ if (Qt5Widgets_FOUND)
 
 endif (Qt5Widgets_FOUND)
 
+find_package (Boost COMPONENTS unit_test_framework)
+
 set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
 set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 
@@ -109,6 +111,13 @@ message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
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
index 2e7c8f9..207abd7 100755
--- a/build/cmake_clean.sh
+++ b/build/cmake_clean.sh
@@ -2,9 +2,13 @@ make clean
 rm CMakeCache.txt
 rm cmake_install.cmake
 rm Makefile
+rm CTestTestfile.cmake
+rm -f DartConfiguration.tcl
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

