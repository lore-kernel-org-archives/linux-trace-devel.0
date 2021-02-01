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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B61C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24AA564EA9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhBARZq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhBARZj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:25:39 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56494C06178C
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:22 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id q2so5054854edi.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r2Eg+rhQmizGC96oY5Jr30a7ek1kvD8HlbsfC/4YcRI=;
        b=uc1NkL0E4QlKBXvK9B1cXATgFkUMNymOOgFGq3GiVacQ/fNhqAGKQ9qXXX0Gup0dJw
         Vw/2l+nS/7zSmtfvIcjCy9Dch+0vRftjR3qUk55cVv2BeHfpGuGkEmQ0QecnFwWUS33w
         Yw84xD71CjQotox3Djy/8tzmNKIlD4OGyEJiBQOIFUfeR/wMCeaqAZFX2uuEw6t+Yped
         8k030QnYfLwmTNp+dGvIIumlTrbQm8xsJa337lvR4u4Ei+gfTm1D7L5SgDGFi51SWkMs
         ff0yfvzcZO/Yv7ijL0xrdQvgZH2IN0DhdmuEXZ0+xlJGPizZkcEM8g637N4VpXitChLt
         RcqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r2Eg+rhQmizGC96oY5Jr30a7ek1kvD8HlbsfC/4YcRI=;
        b=A2JFuR5bGSHK/sCzEYHxNThH1Z3cOIWDSd1c9RY6TmRvFO/nRa5DnqiDg5zk/Fe+TK
         cF32EQjr0c3c88F8OKYoPxYaRPEa0m9WEOpFWgSpE0c/kGM0Rqe3/GKLBMVfDb6N+o7V
         T5u4pz1Uac8R33nh+6FGj9Ff5EekfJk3MCFBUfSSThq5uZ5W40Dsjh/WuuV7a21D104f
         WspHZiNQiLOcWPzc85mQRPUCgA/T5nWSsDAkaFfRgTYCwN6OOQpXjiQmXxkipGyzqUxQ
         WMzlb2YKhVJNBCQUKTXfYhB9rd7K31QP2V+5mtgJIGK1hJY4jx1wPJYW+sYiufTUY0c8
         oK1Q==
X-Gm-Message-State: AOAM533Bu11+xRvl0KiYM9DZtH8YQTWs1QDRW52tRDhT0mIWqAqj+v3E
        TwawRPMUILiBfmsy+XtRGVgIjxp8Axc=
X-Google-Smtp-Source: ABdhPJwYJ/os7u02o+1yQBmW4MQYdLZG+UzPlq8oktSYMkYOlkQKyAI9vM34yNTzPNgYd+xQ+yPcww==
X-Received: by 2002:a05:6402:220e:: with SMTP id cq14mr19954798edb.240.1612200260920;
        Mon, 01 Feb 2021 09:24:20 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:20 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 09/24] kernel-shark: Add plugin tests
Date:   Mon,  1 Feb 2021 19:23:43 +0200
Message-Id: <20210201172358.175407-10-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We add a number of dummy plugins and we test the plugin-related part
of the C API.

We also add few simple test cases of the functionalities provided in
KSUtils.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt                |  11 +-
 build/cmake_clean.sh          |   2 +-
 build/deff.h.cmake            |   3 +
 src/CMakeLists.txt            |   4 +-
 tests/CMakeLists.txt          |  34 +++-
 tests/libkshark-gui-tests.cpp | 227 +++++++++++++++++++++++++
 tests/libkshark-tests.cpp     | 309 +++++++++++++++++++++++++++++++++-
 tests/test-input.c            | 134 +++++++++++++++
 tests/test-input_ctrl.c       | 140 +++++++++++++++
 tests/test-plugin_dpi.c       |  26 +++
 tests/test-plugin_dpi_ctrl.c  |  32 ++++
 tests/test-plugin_dpi_err.c   |  26 +++
 12 files changed, 934 insertions(+), 14 deletions(-)
 create mode 100644 tests/libkshark-gui-tests.cpp
 create mode 100644 tests/test-input.c
 create mode 100644 tests/test-input_ctrl.c
 create mode 100644 tests/test-plugin_dpi.c
 create mode 100644 tests/test-plugin_dpi_ctrl.c
 create mode 100644 tests/test-plugin_dpi_err.c

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 26fb7ae..b9b947e 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -144,10 +144,13 @@ if (_DOXYGEN_DOC AND DOXYGEN_FOUND)
 
 endif ()
 
-configure_file( ${KS_DIR}/build/ks.desktop.cmake
-                ${KS_DIR}/${KS_APP_NAME}.desktop)
+configure_file(${KS_DIR}/build/deff.h.cmake
+               ${KS_DIR}/src/KsCmakeDef.hpp)
 
-configure_file( ${KS_DIR}/build/org.freedesktop.kshark-record.policy.cmake
-                ${KS_DIR}/org.freedesktop.kshark-record.policy)
+configure_file(${KS_DIR}/build/ks.desktop.cmake
+               ${KS_DIR}/${KS_APP_NAME}.desktop)
+
+configure_file(${KS_DIR}/build/org.freedesktop.kshark-record.policy.cmake
+               ${KS_DIR}/org.freedesktop.kshark-record.policy)
 
 message("")
diff --git a/build/cmake_clean.sh b/build/cmake_clean.sh
index b534014..2ca1136 100755
--- a/build/cmake_clean.sh
+++ b/build/cmake_clean.sh
@@ -3,7 +3,7 @@ rm CMakeCache.txt
 rm cmake_install.cmake
 rm Makefile
 rm CTestTestfile.cmake
-rm DartConfiguration.tcl
+rm -f DartConfiguration.tcl
 rm -rf CMakeFiles/
 rm -rf src/
 rm -rf examples/
diff --git a/build/deff.h.cmake b/build/deff.h.cmake
index 5584574..423a2fd 100644
--- a/build/deff.h.cmake
+++ b/build/deff.h.cmake
@@ -29,6 +29,9 @@
 /** Qt - old version detected. */
 #cmakedefine QT_VERSION_LESS_5_11
 
+/** Location of the KernelShark tests. */
+#cmakedefine KS_TEST_DIR "@KS_TEST_DIR@"
+
 /** Semicolon-separated list of plugin names. */
 #define KS_BUILTIN_PLUGINS "@PLUGINS@"
 
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 21d5b85..b308403 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -137,8 +137,6 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
 add_subdirectory(plugins)
+set(PLUGINS ${PLUGINS} PARENT_SCOPE)
 
 find_program(DO_AS_ROOT pkexec)
-
-configure_file( ${KS_DIR}/build/deff.h.cmake
-                ${KS_DIR}/src/KsCmakeDef.hpp)
diff --git a/tests/CMakeLists.txt b/tests/CMakeLists.txt
index 0847414..28f711b 100644
--- a/tests/CMakeLists.txt
+++ b/tests/CMakeLists.txt
@@ -1,18 +1,50 @@
 message("\n tests ...")
 
 set(EXECUTABLE_OUTPUT_PATH           ${KS_TEST_DIR})
+set(LIBRARY_OUTPUT_PATH              ${KS_TEST_DIR})
 
 add_executable(kshark-tests          libkshark-tests.cpp)
 target_include_directories(kshark-tests PRIVATE ${Boost_INCLUDE_DIRS})
 target_compile_definitions(kshark-tests PRIVATE "BOOST_TEST_DYN_LINK=1")
-target_link_libraries(kshark-tests   kshark-gui
+target_link_libraries(kshark-tests   kshark
                                      ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
 
 add_test(NAME              "get_test_data"
          COMMAND           ${KS_TEST_DIR}/get_test_data.sh
          WORKING_DIRECTORY ${KS_TEST_DIR})
 
+add_library(dummy_dpi             SHARED  test-plugin_dpi.c)
+set_target_properties(dummy_dpi   PROPERTIES PREFIX "plugin-")
+target_link_libraries(dummy_dpi   kshark)
+
+add_library(dummy_dpi_ctrl             SHARED  test-plugin_dpi_ctrl.c)
+set_target_properties(dummy_dpi_ctrl   PROPERTIES PREFIX "plugin-")
+target_link_libraries(dummy_dpi_ctrl   kshark)
+
+add_library(dummy_dpi_err             SHARED  test-plugin_dpi_err.c)
+set_target_properties(dummy_dpi_err   PROPERTIES PREFIX "plugin-")
+target_link_libraries(dummy_dpi_err   kshark)
+
+add_library(dummy_input             SHARED  test-input.c)
+set_target_properties(dummy_input   PROPERTIES PREFIX "input-")
+target_link_libraries(dummy_input   kshark)
+
+add_library(dummy_input_ctrl             SHARED  test-input_ctrl.c)
+set_target_properties(dummy_input_ctrl   PROPERTIES PREFIX "input-")
+target_link_libraries(dummy_input_ctrl   kshark)
+
 message(STATUS "libkshark-tests")
 add_test(NAME              "libkshark_tests"
          COMMAND           ${KS_TEST_DIR}/kshark-tests --log_format=HRF
          WORKING_DIRECTORY ${KS_TEST_DIR})
+
+add_executable(kshark-gui-tests          libkshark-gui-tests.cpp)
+target_include_directories(kshark-gui-tests PRIVATE ${Boost_INCLUDE_DIRS})
+target_compile_definitions(kshark-gui-tests PRIVATE "BOOST_TEST_DYN_LINK=1")
+target_link_libraries(kshark-gui-tests   kshark-gui
+                                     ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
+
+message(STATUS "libkshark-gui_tests")
+add_test(NAME              "libkshark-gui_tests"
+         COMMAND           ${KS_TEST_DIR}/kshark-gui-tests --log_format=HRF
+         WORKING_DIRECTORY ${KS_TEST_DIR})
diff --git a/tests/libkshark-gui-tests.cpp b/tests/libkshark-gui-tests.cpp
new file mode 100644
index 0000000..de6eb30
--- /dev/null
+++ b/tests/libkshark-gui-tests.cpp
@@ -0,0 +1,227 @@
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
+#include "libkshark-plugin.h"
+#include "KsUtils.hpp"
+
+using namespace KsUtils;
+
+#define N_RECORDS_TEST1		1530
+
+BOOST_AUTO_TEST_CASE(KsUtils_datatest)
+{
+	kshark_context *kshark_ctx{nullptr};
+	kshark_entry **data{nullptr};
+	std::string file(KS_TEST_DIR);
+	ssize_t n_rows;
+	int sd, ss_id;
+
+	BOOST_REQUIRE(kshark_instance(&kshark_ctx));
+	file += "/trace_test1.dat";
+	sd = kshark_open(kshark_ctx, file.c_str());
+	BOOST_CHECK_EQUAL(sd, 0);
+
+	n_rows = kshark_load_entries(kshark_ctx, sd, &data);
+	BOOST_CHECK_EQUAL(n_rows, N_RECORDS_TEST1);
+
+	auto cpus = getCPUList(sd);
+	BOOST_CHECK_EQUAL(cpus.size(), 8);
+	for (int i = 0; i < cpus.size(); ++i)
+		BOOST_CHECK_EQUAL(cpus[i], i);
+
+	auto pids = getPidList(sd);
+	BOOST_CHECK_EQUAL(pids.size(), 46);
+	BOOST_CHECK_EQUAL(pids[0], 0);
+	for (int i = 1; i < pids.size(); ++i)
+		BOOST_CHECK(pids[i] > pids[i - 1]);
+
+	auto evts = getEventIdList(sd);
+	BOOST_CHECK_EQUAL(evts.size(), 40);
+	BOOST_CHECK_EQUAL(evts[34], 323);
+
+	ss_id = getEventId(sd, "sched/sched_switch");
+	BOOST_CHECK_EQUAL(ss_id, 323);
+
+	QString name = getEventName(sd, 323);
+	BOOST_CHECK(name == QString("sched/sched_switch"));
+	name = getEventName(sd, 999);
+	BOOST_CHECK(name == QString("Unknown"));
+
+	auto fields = getEventFieldsList(sd, ss_id);
+	BOOST_CHECK_EQUAL(fields.size(), 11);
+	BOOST_CHECK(fields[10] == QString("next_prio"));
+
+	BOOST_CHECK_EQUAL(getEventFieldType(sd, ss_id, "next_prio"),
+			  KS_INTEGER_FIELD);
+
+	BOOST_CHECK_EQUAL(getEventFieldType(sd, ss_id, "next_comm"),
+			  KS_INVALID_FIELD);
+
+	for (ssize_t r = 0; r < n_rows; ++r)
+		free(data[r]);
+	free(data);
+
+	kshark_close(kshark_ctx, sd);
+	kshark_free(kshark_ctx);
+}
+
+BOOST_AUTO_TEST_CASE(KsUtils_setFilterSync)
+{
+	struct kshark_context *kshark_ctx{nullptr};
+
+	BOOST_REQUIRE(kshark_instance(&kshark_ctx));
+	kshark_ctx->filter_mask = KS_TEXT_VIEW_FILTER_MASK |
+				  KS_GRAPH_VIEW_FILTER_MASK |
+				  KS_EVENT_VIEW_FILTER_MASK;
+
+	BOOST_CHECK_EQUAL(kshark_ctx->filter_mask, 0x7);
+
+	listFilterSync(false);
+	BOOST_CHECK_EQUAL(kshark_ctx->filter_mask & KS_TEXT_VIEW_FILTER_MASK, 0);
+	BOOST_CHECK_EQUAL(kshark_ctx->filter_mask & KS_GRAPH_VIEW_FILTER_MASK,
+			  KS_GRAPH_VIEW_FILTER_MASK);
+	BOOST_CHECK_EQUAL(kshark_ctx->filter_mask & KS_EVENT_VIEW_FILTER_MASK,
+			  KS_EVENT_VIEW_FILTER_MASK);
+	listFilterSync(true);
+	BOOST_CHECK_EQUAL(kshark_ctx->filter_mask, 0x7);
+
+	graphFilterSync(false);
+	BOOST_CHECK_EQUAL(kshark_ctx->filter_mask & KS_TEXT_VIEW_FILTER_MASK,
+			  KS_TEXT_VIEW_FILTER_MASK);
+	BOOST_CHECK_EQUAL(kshark_ctx->filter_mask & KS_GRAPH_VIEW_FILTER_MASK, 0);
+	BOOST_CHECK_EQUAL(kshark_ctx->filter_mask & KS_EVENT_VIEW_FILTER_MASK, 0);
+	graphFilterSync(true);
+	BOOST_CHECK_EQUAL(kshark_ctx->filter_mask, 0x7);
+
+	kshark_free(kshark_ctx);
+}
+
+BOOST_AUTO_TEST_CASE(KsUtils_parseIds)
+{
+	QVector<int> ids_test = parseIdList("1,33,4-6,3,55-57");
+	QVector<int> ids = {1, 33, 4, 5, 6, 3, 55, 56, 57};
+	BOOST_CHECK(ids == ids_test);
+}
+
+#define N_RECORDS_TEST2		73945
+BOOST_AUTO_TEST_CASE(KsUtils_KsDataStore)
+{
+	int64_t ts_last(0);
+	KsDataStore data;
+	int sd;
+
+	BOOST_CHECK_EQUAL(data.size(), 0);
+	BOOST_CHECK_EQUAL(data.rows(), nullptr);
+
+	sd = data.loadDataFile(QString(KS_TEST_DIR) + "/trace_test1.dat", {});
+	BOOST_CHECK_EQUAL(sd, 0);
+	BOOST_CHECK_EQUAL(data.size(), N_RECORDS_TEST1);
+	BOOST_CHECK(data.rows() != nullptr);
+
+	sd = data.appendDataFile(QString(KS_TEST_DIR) + "/trace_test2.dat", {});
+	BOOST_CHECK_EQUAL(sd, 1);
+	BOOST_CHECK_EQUAL(data.size(), N_RECORDS_TEST1 + N_RECORDS_TEST2);
+
+	kshark_entry **rows = data.rows();
+	for (ssize_t i = 0; i < data.size(); ++i) {
+		BOOST_CHECK(rows[i]->ts >= ts_last);
+		ts_last = rows[i]->ts;
+	}
+
+	data.clear();
+	BOOST_CHECK_EQUAL(data.size(), 0);
+	BOOST_CHECK_EQUAL(data.rows(), nullptr);
+}
+
+BOOST_AUTO_TEST_CASE(KsUtils_getPluginList)
+{
+	QStringList plugins{"sched_events"};
+
+	BOOST_CHECK(getPluginList() == plugins);
+}
+
+#define PLUGIN_1_LIB	"/plugin-dummy_dpi.so"
+#define PLUGIN_2_LIB	"/plugin-dummy_dpi_ctrl.so"
+#define INPUT_A_LIB	"/input-dummy_input.so"
+
+QString path(KS_TEST_DIR);
+
+BOOST_AUTO_TEST_CASE(KsUtils_KsPluginManager)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	int sd, argc{0};
+	QCoreApplication a(argc, nullptr);
+
+	KsPluginManager pm;
+	pm.registerPlugins(path + INPUT_A_LIB);
+
+	kshark_instance(&kshark_ctx);
+	BOOST_CHECK_EQUAL(kshark_ctx->n_inputs, 1);
+	BOOST_CHECK(kshark_ctx->inputs != nullptr);
+
+	sd = kshark_add_stream(kshark_ctx);
+	BOOST_CHECK_EQUAL(sd, 0);
+	kshark_ctx->stream[sd]->interface =
+		malloc(1);
+
+	sd = kshark_add_stream(kshark_ctx);
+	BOOST_CHECK_EQUAL(sd, 1);
+	kshark_ctx->stream[sd]->interface = malloc(1);
+
+	pm.registerPluginToStream("sched_events",
+				  getStreamIdList(kshark_ctx));
+
+	QStringList list = pm.getStreamPluginList(sd);
+	BOOST_CHECK_EQUAL(list.count(), 1);
+	BOOST_CHECK(list[0] == "sched_events");
+
+	QString testPlugins = path + PLUGIN_1_LIB + ",";
+	testPlugins += path + PLUGIN_2_LIB;
+	pm.registerPlugins(testPlugins);
+	auto listTest = pm.getUserPlugins();
+	BOOST_CHECK_EQUAL(listTest.count(), 3);
+	list = pm.getStreamPluginList(sd);
+
+	for (auto const &p: listTest)
+		pm.registerPluginToStream(p->name, {sd});
+
+	list = pm.getStreamPluginList(sd);
+	BOOST_CHECK_EQUAL(list.count(), 3);
+
+	BOOST_CHECK(list == QStringList({"dummy_dpi_ctrl",
+					 "dummy_dpi",
+					 "sched_events"}));
+
+	auto active = pm.getActivePlugins(sd);
+	BOOST_CHECK(pm.getActivePlugins(sd) == QVector<int>({1, 1, 1}));
+
+	auto enabled = pm.getPluginsByStatus(sd, KSHARK_PLUGIN_ENABLED);
+	BOOST_CHECK(enabled == QVector<int>({0, 1, 2}));
+	auto loaded = pm.getPluginsByStatus(sd, KSHARK_PLUGIN_LOADED);
+	BOOST_CHECK(loaded == QVector<int>({0, 1}));
+	auto failed = pm.getPluginsByStatus(sd, KSHARK_PLUGIN_FAILED);
+	BOOST_CHECK(failed == QVector<int>({2}));
+
+	active[1] = 0;
+	pm.updatePlugins(sd, active);
+	BOOST_CHECK(active == pm.getActivePlugins(sd));
+
+	enabled = pm.getPluginsByStatus(sd, KSHARK_PLUGIN_ENABLED);
+	BOOST_CHECK(enabled == QVector<int>({0, 2}));
+	loaded = pm.getPluginsByStatus(sd, KSHARK_PLUGIN_LOADED);
+	BOOST_CHECK(loaded == QVector<int>({0}));
+	failed = pm.getPluginsByStatus(sd, KSHARK_PLUGIN_FAILED);
+	BOOST_CHECK(failed == QVector<int>({2}));
+
+	kshark_free(kshark_ctx);
+	a.exit();
+}
diff --git a/tests/libkshark-tests.cpp b/tests/libkshark-tests.cpp
index eb5cb1f..a22c1e5 100644
--- a/tests/libkshark-tests.cpp
+++ b/tests/libkshark-tests.cpp
@@ -11,6 +11,7 @@
 // KernelShark
 #include "libkshark.h"
 #include "libkshark-plugin.h"
+#include "KsCmakeDef.hpp"
 
 #define N_TEST_STREAMS	1000
 
@@ -19,7 +20,7 @@ BOOST_AUTO_TEST_CASE(add_remove_streams)
 	struct kshark_context *kshark_ctx = NULL;
 	int sd, free = 0, i;
 
-	kshark_instance(&kshark_ctx);
+	BOOST_REQUIRE(kshark_instance(&kshark_ctx));
 
 	for (i = 0; i < N_TEST_STREAMS; ++i) {
 		sd = kshark_add_stream(kshark_ctx);
@@ -45,10 +46,46 @@ BOOST_AUTO_TEST_CASE(add_remove_streams)
 	BOOST_CHECK_EQUAL(kshark_ctx->stream_info.array_size, INT16_MAX + 1);
 	BOOST_CHECK_EQUAL(sd, -ENODEV);
 
-	kshark_close_all(kshark_ctx);
 	kshark_free(kshark_ctx);
 }
 
+BOOST_AUTO_TEST_CASE(get_stream)
+{
+	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
+	int sd;
+
+	BOOST_REQUIRE(kshark_instance(&kshark_ctx));
+	sd = kshark_add_stream(kshark_ctx);
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	BOOST_CHECK_EQUAL(stream, nullptr);
+
+	kshark_ctx->stream[sd]->interface = malloc(1);
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	BOOST_CHECK(stream != nullptr);
+
+	kshark_free(kshark_ctx);
+}
+
+BOOST_AUTO_TEST_CASE(close_all)
+{
+	struct kshark_context *kshark_ctx(nullptr);
+	int sd, i;
+
+	BOOST_REQUIRE(kshark_instance(&kshark_ctx));
+	for (i = 0; i < N_TEST_STREAMS; ++i) {
+		sd = kshark_add_stream(kshark_ctx);
+		BOOST_CHECK_EQUAL(sd, i);
+	}
+
+	kshark_close_all(kshark_ctx);
+	BOOST_CHECK_EQUAL(kshark_ctx->n_streams, 0);
+	BOOST_CHECK_EQUAL(kshark_ctx->stream_info.next_free_stream_id, 0);
+	BOOST_CHECK_EQUAL(kshark_ctx->stream_info.max_stream_id, -1);
+	for (i = 0; i < kshark_ctx->stream_info.array_size; ++i)
+		BOOST_CHECK_EQUAL(kshark_ctx->stream[i], nullptr);
+}
+
 #define ARRAY_DEFAULT_SIZE	1000
 BOOST_AUTO_TEST_CASE(doule_size_macro)
 {
@@ -90,7 +127,7 @@ BOOST_AUTO_TEST_CASE(fill_data_container)
 	kshark_data_container_sort(data);
 	BOOST_CHECK_EQUAL(data->capacity, N_VALUES);
 	for (i = 0; i < N_VALUES; ++i) {
-		BOOST_REQUIRE(data->data[i]->entry->ts >= ts_last);
+		BOOST_CHECK(data->data[i]->entry->ts >= ts_last);
 		BOOST_CHECK_EQUAL(data->data[i]->entry->ts,
 				  10 - data->data[i]->field);
 
@@ -100,8 +137,8 @@ BOOST_AUTO_TEST_CASE(fill_data_container)
 	i = kshark_find_entry_field_by_time(MAX_TS / 2, data->data,
 					    0, N_VALUES - 1);
 
-	BOOST_REQUIRE(data->data[i - 1]->entry->ts < MAX_TS / 2);
-	BOOST_REQUIRE(data->data[i]->entry->ts >= MAX_TS / 2);
+	BOOST_CHECK(data->data[i - 1]->entry->ts < MAX_TS / 2);
+	BOOST_CHECK(data->data[i]->entry->ts >= MAX_TS / 2);
 
 	kshark_free_data_container(data);
 }
@@ -136,3 +173,265 @@ BOOST_AUTO_TEST_CASE(init_close_plugin)
 
 	__close(-1);
 }
+
+#define PLUGIN_1_LIB	"/plugin-dummy_dpi.so"
+#define PLUGIN_1_NAME	"dummy_dpi"
+
+#define PLUGIN_2_LIB	"/plugin-dummy_dpi_ctrl.so"
+#define PLUGIN_2_NAME	"dummy_dpi_ctrl"
+
+#define INPUT_A_LIB	"/input-dummy_input.so"
+#define INPUT_A_NAME	"dummy_input"
+
+#define INPUT_B_LIB	"/input-dummy_input_ctrl.so"
+#define INPUT_B_NAME	"dummy_input_ctrl"
+
+std::string path(KS_TEST_DIR);
+
+BOOST_AUTO_TEST_CASE(register_plugin)
+{
+	kshark_plugin_list *p1, *p2, *i1, *i2, *x1, *x2;
+	kshark_generic_stream_interface *interface;
+	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
+	std::string plugin;
+	int sd;
+
+	BOOST_REQUIRE(kshark_instance(&kshark_ctx));
+	BOOST_REQUIRE(kshark_ctx->plugins == nullptr);
+	BOOST_REQUIRE(kshark_ctx->inputs == nullptr);
+	BOOST_CHECK_EQUAL(kshark_ctx->n_plugins, 0);
+
+	plugin = path + PLUGIN_1_LIB;
+	p1 = kshark_register_plugin(kshark_ctx, PLUGIN_1_NAME, plugin.c_str());
+	BOOST_CHECK_EQUAL(kshark_ctx->n_plugins, 1);
+	BOOST_CHECK(kshark_ctx->plugins != nullptr);
+	BOOST_CHECK_EQUAL(kshark_ctx->plugins->next, nullptr);
+	BOOST_CHECK_EQUAL(kshark_ctx->plugins, p1);
+	BOOST_CHECK(p1 != nullptr);
+	BOOST_CHECK(p1->process_interface != nullptr);
+	BOOST_CHECK(p1->handle != nullptr);
+	BOOST_CHECK_EQUAL(strcmp(p1->file, plugin.c_str()), 0);
+	BOOST_CHECK_EQUAL(strcmp(p1->name, PLUGIN_1_NAME), 0);
+
+	BOOST_CHECK_EQUAL(p1->ctrl_interface, nullptr);
+	BOOST_CHECK_EQUAL(p1->readout_interface, nullptr);
+
+	plugin = path + PLUGIN_2_LIB;
+	p2 = kshark_register_plugin(kshark_ctx, PLUGIN_2_NAME, plugin.c_str());
+	BOOST_CHECK_EQUAL(kshark_ctx->n_plugins, 2);
+	BOOST_CHECK_EQUAL(kshark_ctx->plugins, p2);
+	BOOST_CHECK_EQUAL(kshark_ctx->plugins->next, p1);
+	BOOST_CHECK(p2 != nullptr);
+	BOOST_CHECK(p2->process_interface != nullptr);
+	BOOST_CHECK(p2->handle != nullptr);
+	BOOST_CHECK_EQUAL(strcmp(p2->file, plugin.c_str()), 0);
+	BOOST_CHECK_EQUAL(strcmp(p2->name, PLUGIN_2_NAME), 0);
+	BOOST_CHECK(p2->ctrl_interface != nullptr);
+
+	BOOST_CHECK_EQUAL(p2->readout_interface, nullptr);
+
+	plugin = path + INPUT_A_LIB;
+	i1 = kshark_register_plugin(kshark_ctx, INPUT_A_NAME, plugin.c_str());
+	BOOST_CHECK(i1 != nullptr);
+	BOOST_CHECK_EQUAL(kshark_ctx->n_plugins, 3);
+	BOOST_CHECK_EQUAL(kshark_ctx->n_inputs, 1);
+	BOOST_CHECK(kshark_ctx->inputs != nullptr);
+	BOOST_CHECK(i1->readout_interface != nullptr);
+	BOOST_CHECK(i1->handle != nullptr);
+	BOOST_CHECK_EQUAL(strcmp(i1->file, plugin.c_str()), 0);
+	BOOST_CHECK_EQUAL(strcmp(i1->name, INPUT_A_NAME), 0);
+
+	BOOST_CHECK_EQUAL(i1->ctrl_interface, nullptr);
+	BOOST_CHECK_EQUAL(i1->process_interface, nullptr);
+
+	plugin = path + INPUT_B_LIB;
+	i2 = kshark_register_plugin(kshark_ctx, INPUT_B_NAME, plugin.c_str());
+	BOOST_CHECK(i2 != nullptr);
+	BOOST_CHECK_EQUAL(kshark_ctx->n_plugins, 4);
+	BOOST_CHECK_EQUAL(kshark_ctx->n_inputs, 2);
+	BOOST_CHECK(i2->readout_interface != nullptr);
+	BOOST_CHECK(i2->handle != nullptr);
+	BOOST_CHECK(strcmp(i2->file, plugin.c_str()) == 0);
+	BOOST_CHECK(strcmp(i2->name, INPUT_B_NAME) == 0);
+	BOOST_CHECK(i2->ctrl_interface != nullptr);
+
+	BOOST_CHECK_EQUAL(i2->process_interface, nullptr);
+
+	x1 = kshark_find_plugin_by_name(kshark_ctx->plugins, PLUGIN_2_NAME);
+	BOOST_CHECK_EQUAL(x1, p2);
+
+	plugin = path + PLUGIN_2_LIB;
+	x2 = kshark_find_plugin(kshark_ctx->plugins, plugin.c_str());
+
+	BOOST_CHECK_EQUAL(x2, p2);
+
+	sd = kshark_add_stream(kshark_ctx);
+	interface =
+		(kshark_generic_stream_interface *) malloc(sizeof(*interface));
+	kshark_ctx->stream[sd]->interface = interface;
+	BOOST_CHECK_EQUAL(sd, 0);
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	BOOST_CHECK(stream != nullptr);
+
+	BOOST_CHECK_EQUAL(stream->plugins, nullptr);
+	kshark_register_plugin_to_stream(stream,
+					 p1->process_interface,
+					 true);
+	BOOST_CHECK_EQUAL(stream->n_plugins, 1);
+	BOOST_CHECK_EQUAL(stream->plugins->interface, p1->process_interface);
+	BOOST_CHECK_EQUAL(stream->plugins->next, nullptr);
+
+	kshark_register_plugin_to_stream(stream,
+					 p2->process_interface,
+					 true);
+	BOOST_CHECK_EQUAL(stream->n_plugins, 2);
+	BOOST_CHECK_EQUAL(stream->plugins->interface, p2->process_interface);
+	BOOST_CHECK_EQUAL(stream->plugins->next->interface, p1->process_interface);
+
+	kshark_unregister_plugin_from_stream(stream, p1->process_interface);
+	BOOST_CHECK_EQUAL(stream->n_plugins, 1);
+	BOOST_CHECK_EQUAL(stream->plugins->interface, p2->process_interface);
+	BOOST_CHECK_EQUAL(stream->plugins->next, nullptr);
+
+	kshark_free(kshark_ctx);
+}
+
+#define PLUGIN_ERR_LIB	"/plugin-dummy_dpi_err.so"
+#define PLUGIN_ERR_NAME	"dummy_dpi_err"
+
+BOOST_AUTO_TEST_CASE(handle_plugin)
+{
+	kshark_dpi_list *dpi1, *dpi2, *dpi_err;
+	kshark_plugin_list *p1, *p2, *p_err;
+	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
+	std::string plugin;
+	int sd, ret;
+
+	BOOST_REQUIRE(kshark_instance(&kshark_ctx));
+	BOOST_CHECK_EQUAL(kshark_ctx->plugins, nullptr);
+	BOOST_CHECK_EQUAL(kshark_ctx->n_plugins, 0);
+
+	plugin = path + PLUGIN_1_LIB;
+	p1 = kshark_register_plugin(kshark_ctx, PLUGIN_1_NAME, plugin.c_str());
+
+	plugin = path + PLUGIN_2_LIB;
+	p2 = kshark_register_plugin(kshark_ctx, PLUGIN_2_NAME, plugin.c_str());
+	BOOST_CHECK(kshark_ctx->plugins != nullptr);
+	BOOST_CHECK_EQUAL(kshark_ctx->n_plugins, 2);
+
+	sd = kshark_add_stream(kshark_ctx);
+	kshark_ctx->stream[sd]->interface = malloc(1);
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	BOOST_CHECK(stream != nullptr);
+
+	dpi1 = kshark_register_plugin_to_stream(stream,
+						p1->process_interface,
+						true);
+	BOOST_CHECK_EQUAL(dpi1->status, KSHARK_PLUGIN_ENABLED);
+
+	dpi2 = kshark_register_plugin_to_stream(stream,
+						p2->process_interface,
+						false);
+	BOOST_CHECK_EQUAL(dpi2->status, 0);
+
+	ret = kshark_handle_dpi(stream, dpi1, KSHARK_PLUGIN_INIT);
+	BOOST_CHECK_EQUAL(ret, 1);
+	BOOST_CHECK_EQUAL(dpi1->status,
+			  KSHARK_PLUGIN_LOADED | KSHARK_PLUGIN_ENABLED);
+
+	ret = kshark_handle_dpi(stream, dpi2, KSHARK_PLUGIN_INIT);
+	BOOST_CHECK_EQUAL(ret, 0);
+	BOOST_CHECK_EQUAL(dpi2->status, 0);
+
+	dpi2->status |= KSHARK_PLUGIN_ENABLED;
+	ret = kshark_handle_dpi(stream, dpi2, KSHARK_PLUGIN_INIT);
+	BOOST_CHECK_EQUAL(ret, 2);
+	BOOST_CHECK_EQUAL(dpi1->status,
+			  KSHARK_PLUGIN_LOADED | KSHARK_PLUGIN_ENABLED);
+
+	ret = kshark_handle_all_dpis(stream, KSHARK_PLUGIN_UPDATE);
+	BOOST_CHECK_EQUAL(ret, 0);
+	BOOST_CHECK_EQUAL(dpi1->status,
+			  KSHARK_PLUGIN_LOADED | KSHARK_PLUGIN_ENABLED);
+	BOOST_CHECK_EQUAL(dpi2->status,
+			  KSHARK_PLUGIN_LOADED | KSHARK_PLUGIN_ENABLED);
+
+	plugin = path + PLUGIN_ERR_LIB;
+	p_err = kshark_register_plugin(kshark_ctx, PLUGIN_ERR_NAME,
+				       plugin.c_str());
+	BOOST_CHECK_EQUAL(kshark_ctx->n_plugins, 3);
+	dpi_err = kshark_register_plugin_to_stream(stream,
+						   p_err->process_interface,
+						   true);
+	BOOST_CHECK_EQUAL(ret, 0);
+	ret = kshark_handle_dpi(stream, dpi_err, KSHARK_PLUGIN_INIT);
+	BOOST_CHECK_EQUAL(dpi_err->status,
+			  KSHARK_PLUGIN_FAILED | KSHARK_PLUGIN_ENABLED);
+	BOOST_CHECK_EQUAL(ret, 0);
+	ret = kshark_handle_dpi(stream, dpi_err, KSHARK_PLUGIN_CLOSE);
+	BOOST_CHECK_EQUAL(ret, 0);
+	BOOST_CHECK_EQUAL(dpi_err->status, KSHARK_PLUGIN_ENABLED);
+
+	ret = kshark_handle_all_dpis(stream, KSHARK_PLUGIN_CLOSE);
+	BOOST_CHECK_EQUAL(ret, -3);
+
+	kshark_free(kshark_ctx);
+}
+
+#define FAKE_DATA_FILE_A	"test.ta"
+#define FAKE_DATA_A_SIZE	200
+
+#define FAKE_DATA_FILE_B	"test.tb"
+#define FAKE_DATA_B_SIZE	100
+
+BOOST_AUTO_TEST_CASE(readout_plugins)
+{
+	kshark_context *kshark_ctx(nullptr);
+	kshark_entry **entries{nullptr};
+	kshark_data_stream *stream;
+	std::string plugin, data;
+	int sd, i, n_entries;
+	int64_t ts_last(0);
+
+	BOOST_REQUIRE(kshark_instance(&kshark_ctx));
+
+	plugin = path + INPUT_A_LIB;
+	kshark_register_plugin(kshark_ctx, INPUT_A_NAME, plugin.c_str());
+	plugin = path + INPUT_B_LIB;
+	kshark_register_plugin(kshark_ctx, INPUT_B_NAME, plugin.c_str());
+
+	data = FAKE_DATA_FILE_A;
+	sd = kshark_open(kshark_ctx, data.c_str());
+	BOOST_CHECK_EQUAL(sd, 0);
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	BOOST_CHECK(stream != nullptr);
+	BOOST_CHECK(stream->interface != nullptr);
+	BOOST_CHECK_EQUAL(strcmp(stream->data_format, "format_a"), 0);
+
+	data = FAKE_DATA_FILE_B;
+	sd = kshark_open(kshark_ctx, data.c_str());
+	BOOST_CHECK_EQUAL(sd, 1);
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	BOOST_CHECK(stream != nullptr);
+	BOOST_CHECK(stream->interface != nullptr);
+	BOOST_CHECK_EQUAL(strcmp(stream->data_format, "format_b"), 0);
+
+	n_entries = kshark_load_all_entries(kshark_ctx, &entries);
+	BOOST_CHECK_EQUAL(n_entries, FAKE_DATA_A_SIZE + FAKE_DATA_B_SIZE);
+
+	for (i = 0; i < n_entries; ++i) {
+		BOOST_CHECK(ts_last <= entries[i]->ts);
+		ts_last = entries[i]->ts;
+	}
+
+	for (i = 0; i < n_entries; ++i)
+		free(entries[i]);
+	free(entries);
+
+	kshark_free(kshark_ctx);
+}
diff --git a/tests/test-input.c b/tests/test-input.c
new file mode 100644
index 0000000..31620b9
--- /dev/null
+++ b/tests/test-input.c
@@ -0,0 +1,134 @@
+
+// C
+#ifndef _GNU_SOURCE
+/** Use GNU C Library. */
+#define _GNU_SOURCE
+#endif // _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plugin.h"
+
+static ssize_t load_entries(struct kshark_data_stream *stream,
+			    struct kshark_context *kshark_ctx,
+			    struct kshark_entry ***data_rows)
+{
+	struct kshark_entry **rows;
+	ssize_t total = 200, i;
+
+	rows = calloc(total, sizeof(struct kshark_entry *));
+	for (i = 0; i < total; ++i) {
+		rows[i] = calloc(1, sizeof(struct kshark_entry));
+		rows[i]->ts = 1000000 + i * 10000;
+		rows[i]->stream_id = stream->stream_id;
+		rows[i]->event_id = i % 5;
+		rows[i]->pid = 10 + i % 2;
+		rows[i]->cpu = i % 2;
+		rows[i]->visible = 0xff;
+	}
+
+	*data_rows = rows;
+	return total;
+}
+
+static char *dump_entry(struct kshark_data_stream *stream,
+			const struct kshark_entry *entry)
+{
+	char *entry_str;
+	int ret;
+
+	ret = asprintf(&entry_str, "e: time=%li evt=%i s_id=%i", entry->ts,
+								 entry->event_id,
+								 entry->stream_id);
+
+	if (ret <= 0)
+		return NULL;
+
+	return entry_str;
+}
+
+static const char *format_name = "format_a";
+
+const char *KSHARK_INPUT_FORMAT()
+{
+	return format_name;
+}
+
+bool KSHARK_INPUT_CHECK(const char *file, char **format)
+{
+	char *ext = strrchr(file, '.');
+
+	if (ext && strcmp(ext, ".ta") == 0)
+		return true;
+
+	return false;
+}
+
+static const int get_pid(struct kshark_data_stream *stream,
+			 const struct kshark_entry *entry)
+{
+	return entry->pid;
+}
+
+static char *get_task(struct kshark_data_stream *stream,
+		      const struct kshark_entry *entry)
+{
+	char *entry_str;
+	int ret;
+
+	ret = asprintf(&entry_str, "test_a/test");
+
+	if (ret <= 0)
+		return NULL;
+
+	return entry_str;
+}
+
+static char *get_event_name(struct kshark_data_stream *stream,
+			    const struct kshark_entry *entry)
+{
+	char *evt_str;
+	int ret;
+
+	ret = asprintf(&evt_str, "test_a/event-%i", entry->event_id);
+
+	if (ret <= 0)
+		return NULL;
+
+	return evt_str;
+}
+
+int KSHARK_INPUT_INITIALIZER(struct kshark_data_stream *stream)
+{
+	struct kshark_generic_stream_interface *interface;
+
+	stream->interface = interface = calloc(1, sizeof(*interface));
+	if (!interface)
+		return -ENOMEM;
+
+	interface->type = KS_GENERIC_DATA_INTERFACE;
+
+	stream->n_cpus = 2;
+	stream->n_events = 5;
+	stream->idle_pid = 0;
+
+	kshark_hash_id_add(stream->tasks, 10);
+	kshark_hash_id_add(stream->tasks, 11);
+
+	interface->get_pid = get_pid;
+	interface->get_task = get_task;
+	interface->get_event_name = get_event_name;
+
+	interface->dump_entry = dump_entry;
+	interface->load_entries = load_entries;
+
+	return 0;
+}
+
+void KSHARK_INPUT_DEINITIALIZER(struct kshark_data_stream *stream)
+{}
diff --git a/tests/test-input_ctrl.c b/tests/test-input_ctrl.c
new file mode 100644
index 0000000..3dcc92e
--- /dev/null
+++ b/tests/test-input_ctrl.c
@@ -0,0 +1,140 @@
+
+// C
+#ifndef _GNU_SOURCE
+/** Use GNU C Library. */
+#define _GNU_SOURCE
+#endif // _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plugin.h"
+
+static ssize_t load_entries(struct kshark_data_stream *stream,
+			    struct kshark_context *kshark_ctx,
+			    struct kshark_entry ***data_rows)
+{
+	struct kshark_entry **rows;
+	ssize_t total = 100, i;
+
+	rows = calloc(total, sizeof(struct kshark_entry *));
+	for (i = 0; i < total; ++i) {
+		rows[i] = calloc(1, sizeof(struct kshark_entry));
+		rows[i]->ts = 1000 + i * 15000;
+		rows[i]->stream_id = stream->stream_id;
+		rows[i]->event_id = i % 3;
+		rows[i]->pid = 20;
+		rows[i]->visible = 0xff;
+	}
+
+	rows[i-1]->pid = 0;
+
+	*data_rows = rows;
+	return total;
+}
+
+static char *dump_entry(struct kshark_data_stream *stream,
+			const struct kshark_entry *entry)
+{
+	char *entry_str;
+	int ret;
+
+	ret = asprintf(&entry_str, "e: time=%li evt=%i s_id=%i", entry->ts,
+								 entry->event_id,
+								 entry->stream_id);
+
+	if (ret <= 0)
+		return NULL;
+
+	return entry_str;
+}
+
+static const char *format_name = "format_b";
+// static const char *format_name = "tep data";
+
+const char *KSHARK_INPUT_FORMAT()
+{
+	return format_name;
+}
+
+bool KSHARK_INPUT_CHECK(const char *file, char **format)
+{
+	char *ext = strrchr(file, '.');
+
+	if (ext && strcmp(ext, ".tb") == 0)
+		return true;
+
+	return false;
+}
+
+static const int get_pid(struct kshark_data_stream *stream,
+			 const struct kshark_entry *entry)
+{
+	return entry->pid;
+}
+
+static char *get_task(struct kshark_data_stream *stream,
+		      const struct kshark_entry *entry)
+{
+	char *entry_str;
+	int ret;
+
+	ret = asprintf(&entry_str, "test_b/test");
+
+	if (ret <= 0)
+		return NULL;
+
+	return entry_str;
+}
+
+static char *get_event_name(struct kshark_data_stream *stream,
+			    const struct kshark_entry *entry)
+{
+	char *evt_str;
+	int ret;
+
+	ret = asprintf(&evt_str, "test_b/event-%i", entry->event_id);
+
+	if (ret <= 0)
+		return NULL;
+
+	return evt_str;
+}
+
+int KSHARK_INPUT_INITIALIZER(struct kshark_data_stream *stream)
+{
+	struct kshark_generic_stream_interface *interface;
+
+	stream->interface = interface = calloc(1, sizeof(*interface));
+	if (!interface)
+		return -ENOMEM;
+
+	interface->type = KS_GENERIC_DATA_INTERFACE;
+
+	stream->n_cpus = 1;
+	stream->n_events = 3;
+	stream->idle_pid = 0;
+
+	kshark_hash_id_add(stream->tasks, 20);
+
+	interface->get_pid = get_pid;
+	interface->get_task = get_task;
+	interface->get_event_name = get_event_name;
+	interface->dump_entry = dump_entry;
+	interface->load_entries = load_entries;
+
+	return 0;
+}
+
+void KSHARK_INPUT_DEINITIALIZER(struct kshark_data_stream *stream)
+{}
+
+/** Initialize the control interface of the plugin. */
+void *KSHARK_MENU_PLUGIN_INITIALIZER(void *ptr)
+{
+	return NULL;
+}
diff --git a/tests/test-plugin_dpi.c b/tests/test-plugin_dpi.c
new file mode 100644
index 0000000..82f94f3
--- /dev/null
+++ b/tests/test-plugin_dpi.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2021 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+// C
+#include <stdio.h>
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plugin.h"
+
+/** Load this plugin. */
+int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
+{
+	printf("--> plugin1\n");
+	return 1;
+}
+
+/** Unload this plugin. */
+int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
+{
+	printf("<-- plugin1\n");
+	return 1;
+}
diff --git a/tests/test-plugin_dpi_ctrl.c b/tests/test-plugin_dpi_ctrl.c
new file mode 100644
index 0000000..5fafd1d
--- /dev/null
+++ b/tests/test-plugin_dpi_ctrl.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2021 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+// C
+#include <stdio.h>
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plugin.h"
+
+/** Load this plugin. */
+int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
+{
+	printf("--> plugin2\n");
+	return 2;
+}
+
+/** Unload this plugin. */
+int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
+{
+	printf("<-- plugin2\n");
+	return 2;
+}
+
+/** Initialize the control interface of the plugin. */
+void *KSHARK_MENU_PLUGIN_INITIALIZER(void *ptr)
+{
+	return NULL;
+}
diff --git a/tests/test-plugin_dpi_err.c b/tests/test-plugin_dpi_err.c
new file mode 100644
index 0000000..4148930
--- /dev/null
+++ b/tests/test-plugin_dpi_err.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2021 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+// C
+#include <stdio.h>
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plugin.h"
+
+/** Load this plugin. */
+int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
+{
+	printf("--> plugin_err\n");
+	return 0;
+}
+
+/** Unload this plugin. */
+int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
+{
+	printf("<-- plugin_err\n");
+	return 0;
+}
-- 
2.25.1

