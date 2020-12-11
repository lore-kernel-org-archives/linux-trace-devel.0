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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D8DC4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F17523B31
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437698AbgLKPLM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437703AbgLKPKa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:10:30 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28066C0619DB
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:49 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id c5so5738595wrp.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YqCIYkci5/qTLDcsXiPAIutZAsoiZlUF5X7OYfhyass=;
        b=k9UsT5/OdWbYYLrsSXCzbR1IYG3iWQEcsfU1t7zDfxlS+2za6kWaRzBOxNbTFUWMnD
         /lhS+yeYLbCf8lFfUyapnnlilsp0sEuGvFxn6+fT0wgj0ZLmy8W8fQSyAdUpqPmFDF4W
         +WTyYNBtGk/Owny5+3+pqydh46J+qt7j8ceTSofi0qQ+o2s0hDX1douq6NJ6O1m+PBrr
         cG0/cwwddcgHxpdCoDdWE6k8x4+KIZrdC9znt+WwFacSP780snqwFswpcBVHS2JHhuHq
         epSioWRCL+XcyEevMlWpbH7DQ+geFMxa2FZ754L7z+u7eMKk1uEpj0Mwp/GvMLPxzHJt
         hU6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YqCIYkci5/qTLDcsXiPAIutZAsoiZlUF5X7OYfhyass=;
        b=CcqI/hnYfA41wmIUsGUAiSJj0UbivPwvU6kiCsaxQPTWjE5reOl6cIW3Zhb9ZaCEio
         ULkOMdw3ifNK1B4MAToQcf8estb8UadvMZpYov0chxCOCcNrb5+UZsZhkV3EEltIp4ds
         lgctd4nZnSpwRLxGv35aWjUfAQGG3Ox7laPOeERl7Y/HmI+FvhjR8Ck+eOcZJTMOlC5D
         8x6/zHr8+tm/ILo8HpVdKr2P9lkL46puNN1AaFicNo1yVbHpQ0eDzBBaEwliquJilsOT
         c9ftbq4A9T1+celHHCGNjcBttSJFU/x5qC1iSpFNN44pX8TbnbQmR3qhKmN0QzOM4iyo
         t93Q==
X-Gm-Message-State: AOAM530dRuOwTQEUU1N2Y0sK+P72BZHgaDW0w7uwNpFI0OX1aWDqjyTj
        HzlerMM9c5Yumg0L7nE5ELlu0F6PYBk=
X-Google-Smtp-Source: ABdhPJyR+bdKGnGmkBY98+MPKpX490fYBYAOySE4z7zVqklshPTbP5cdlBu/yehKG8LV+5xBr9iacg==
X-Received: by 2002:adf:eb07:: with SMTP id s7mr14504044wrn.414.1607699327917;
        Fri, 11 Dec 2020 07:08:47 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:47 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 31/32] kernel-shark: Add basic infrastructure for testing
Date:   Fri, 11 Dec 2020 17:07:55 +0200
Message-Id: <20201211150756.577366-32-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
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
index 44071a6..303e47e 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -42,6 +42,8 @@ if (Qt5Widgets_FOUND)
 
 endif (Qt5Widgets_FOUND)
 
+find_package (Boost COMPONENTS unit_test_framework)
+
 set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
 set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 
@@ -93,6 +95,13 @@ message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
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

