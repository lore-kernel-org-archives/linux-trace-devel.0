Return-Path: <SRS0=8H7y=JS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:43665 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752324AbeGBOFD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Jul 2018 10:05:03 -0400
Received: by mail-wr0-f196.google.com with SMTP id f18-v6so1979585wre.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Jul 2018 07:05:03 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 4/9] kernel-shark-qt: Add an example showing how to load trace data
Date: Mon,  2 Jul 2018 17:04:19 +0300
Message-Id: <20180702140424.23221-4-y.karadz@gmail.com>
In-Reply-To: <20180702140424.23221-1-y.karadz@gmail.com>
References: <20180702140424.23221-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch introduces a basic example, showing how to use the
C API of KernelShark and open a new session, load a trace data
file, produced by trace-cmd, print some data to the screen,
cleanup and then exit.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/CMakeLists.txt          |  1 +
 kernel-shark-qt/build/cmake_clean.sh    |  1 +
 kernel-shark-qt/examples/CMakeLists.txt |  5 ++
 kernel-shark-qt/examples/dataload.c     | 87 +++++++++++++++++++++++++
 4 files changed, 94 insertions(+)
 create mode 100644 kernel-shark-qt/examples/CMakeLists.txt
 create mode 100644 kernel-shark-qt/examples/dataload.c

diff --git a/kernel-shark-qt/CMakeLists.txt b/kernel-shark-qt/CMakeLists.txt
index 9929937..9ff12a1 100644
--- a/kernel-shark-qt/CMakeLists.txt
+++ b/kernel-shark-qt/CMakeLists.txt
@@ -33,6 +33,7 @@ message(STATUS "CXX flags    : " ${CMAKE_CXX_FLAGS})
 message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
 
 add_subdirectory(${KS_DIR}/src)
+add_subdirectory(${KS_DIR}/examples)
 
 if (_DOXYGEN_DOC AND DOXYGEN_FOUND)
 
diff --git a/kernel-shark-qt/build/cmake_clean.sh b/kernel-shark-qt/build/cmake_clean.sh
index 57c40a4..acdbb43 100755
--- a/kernel-shark-qt/build/cmake_clean.sh
+++ b/kernel-shark-qt/build/cmake_clean.sh
@@ -4,6 +4,7 @@ rm cmake_install.cmake
 rm Makefile
 rm -rf CMakeFiles/
 rm -rf src/
+rm -rf examples/
 rm -f ../lib/*
 rm -f ../src/KsDeff.h
 rm -f CMakeDoxyfile.in
diff --git a/kernel-shark-qt/examples/CMakeLists.txt b/kernel-shark-qt/examples/CMakeLists.txt
new file mode 100644
index 0000000..98df9d8
--- /dev/null
+++ b/kernel-shark-qt/examples/CMakeLists.txt
@@ -0,0 +1,5 @@
+message("\n examples ...")
+
+message(STATUS "dataload")
+add_executable(dload          dataload.c)
+target_link_libraries(dload   kshark)
diff --git a/kernel-shark-qt/examples/dataload.c b/kernel-shark-qt/examples/dataload.c
new file mode 100644
index 0000000..963bc08
--- /dev/null
+++ b/kernel-shark-qt/examples/dataload.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+// C
+#include <stdio.h>
+#include <stdlib.h>
+
+// KernelShark
+#include "libkshark.h"
+
+const char *default_file = "trace.dat";
+
+int main(int argc, char **argv)
+{
+	struct kshark_context *kshark_ctx;
+	struct kshark_entry **data = NULL;
+	size_t r, n_rows, n_tasks;
+	char *entry_str;
+	bool status;
+	int *pids;
+
+	/* Create a new kshark session. */
+	kshark_ctx = NULL;
+	if (!kshark_instance(&kshark_ctx))
+		return 1;
+
+	/* Open a trace data file produced by trace-cmd. */
+	if (argc > 1)
+		status = kshark_open(kshark_ctx, argv[1]);
+	else
+		status = kshark_open(kshark_ctx, default_file);
+
+	if (!status) {
+		kshark_free(kshark_ctx);
+		return 1;
+	}
+
+	/* Load the content of the file into an array of entries. */
+	n_rows = kshark_load_data_entries(kshark_ctx, &data);
+
+	/* Print to the screen the list of all tasks. */
+	n_tasks = kshark_get_task_pids(kshark_ctx, &pids);
+	for (r = 0; r < n_tasks; ++r) {
+		const char *task_str =
+			pevent_data_comm_from_pid(kshark_ctx->pevent,
+						  pids[r]);
+
+		printf("task: %s-%i\n", task_str, pids[r]);
+	}
+
+	free(pids);
+
+	puts("\n\n");
+
+	/* Print to the screen the first 10 entries. */
+	for (r = 0; r < 10; ++r) {
+		entry_str = kshark_dump_entry(data[r]);
+		puts(entry_str);
+		free(entry_str);
+	}
+
+	puts("\n...\n");
+
+	/* Print the last 10 entries. */
+	for (r = n_rows - 10; r < n_rows; ++r) {
+		entry_str = kshark_dump_entry(data[r]);
+		puts(entry_str);
+		free(entry_str);
+	}
+
+	/* Free the memory. */
+	for (r = 0; r < n_rows; ++r)
+		free(data[r]);
+
+	free(data);
+
+	/* Close the file. */
+	kshark_close(kshark_ctx);
+
+	/* Close the session. */
+	kshark_free(kshark_ctx);
+
+	return 0;
+}
-- 
2.17.1
