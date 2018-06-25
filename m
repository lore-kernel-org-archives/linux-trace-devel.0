Return-Path: <SRS0=jM0/=JL=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38514 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934559AbeFYPC2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Jun 2018 11:02:28 -0400
Received: by mail-wm0-f68.google.com with SMTP id 69-v6so10385853wmf.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Jun 2018 08:02:28 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 7/7] kernel-shark-qt: Add an example showing how to filter trace data
Date: Mon, 25 Jun 2018 18:01:21 +0300
Message-Id: <20180625150121.14291-8-y.karadz@gmail.com>
In-Reply-To: <20180625150121.14291-1-y.karadz@gmail.com>
References: <20180625150121.14291-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch introduces a basic example, showing how to use the
C API of KernelShark in order to filter trace data.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/examples/CMakeLists.txt |   4 +
 kernel-shark-qt/examples/datafilter.c   | 114 ++++++++++++++++++++++++
 2 files changed, 118 insertions(+)
 create mode 100644 kernel-shark-qt/examples/datafilter.c

diff --git a/kernel-shark-qt/examples/CMakeLists.txt b/kernel-shark-qt/examples/CMakeLists.txt
index 98df9d8..009fd1e 100644
--- a/kernel-shark-qt/examples/CMakeLists.txt
+++ b/kernel-shark-qt/examples/CMakeLists.txt
@@ -3,3 +3,7 @@ message("\n examples ...")
 message(STATUS "dataload")
 add_executable(dload          dataload.c)
 target_link_libraries(dload   kshark)
+
+message(STATUS "datafilter")
+add_executable(dfilter          datafilter.c)
+target_link_libraries(dfilter   kshark)
diff --git a/kernel-shark-qt/examples/datafilter.c b/kernel-shark-qt/examples/datafilter.c
new file mode 100644
index 0000000..e824880
--- /dev/null
+++ b/kernel-shark-qt/examples/datafilter.c
@@ -0,0 +1,114 @@
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
+	// Create a new kshark session.
+	struct kshark_context *kshark_ctx = NULL;
+	kshark_instance(&kshark_ctx);
+
+	// Open a trace data file produced by trace-cmd.
+	bool status;
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
+	// Load the content of the file into an array of entries.
+	struct kshark_entry **data = NULL;
+	size_t n_rows;
+	n_rows = kshark_load_data_entries(kshark_ctx, &data);
+
+	// Filter the trace data coming from trace-cmd.
+	struct kshark_task_list* task = kshark_ctx->tasks;
+	while (task) {
+		const char *task_str = pevent_data_comm_from_pid(kshark_ctx->pevt,
+								 task->pid);
+
+		if (strcmp(task_str, "trace-cmd") == 0)
+			kshark_filter_add_id(kshark_ctx, HIDE_TASK_FILTER,
+							 task->pid);
+
+		task = task->next;
+	}
+
+	/*
+	 * Set the Filter Mask. In this case we want to avoid showing the filterd
+	 * entris in text format.
+	 */
+	kshark_ctx->filter_mask = KS_TEXT_VIEW_FILTER_MASK;
+
+	kshark_filter_entries(kshark_ctx, data, n_rows);
+
+	// Print to the screen the first 10 visible entries.
+	char *entry_str;
+	size_t r = 0, count = 0;
+	while (count < 10) {
+		if (data[r]->visible & KS_TEXT_VIEW_FILTER_MASK) {
+			entry_str = kshark_dump_entry(data[r]);
+			puts(entry_str);
+			free(entry_str);
+			++count;
+		}
+
+		++r;
+	}
+
+	puts("\n\n");
+
+	struct event_format *event;
+	size_t i, n_evts = kshark_ctx->pevt->nr_events;
+	for (i = 0; i < n_evts; ++i) {
+		event = kshark_ctx->pevt->events[i];
+		if (strcmp(event->system, "sched") == 0)
+			kshark_filter_add_id(kshark_ctx, SHOW_EVENT_FILTER,
+							 event->id);
+	}
+
+	kshark_filter_entries(kshark_ctx, data, n_rows);
+
+	// Print to the screen the first 10 visible entries.
+	count = 0;
+	r = 0;
+	while (count < 10) {
+		if (data[r]->visible & KS_TEXT_VIEW_FILTER_MASK) {
+			entry_str = kshark_dump_entry(data[r]);
+			puts(entry_str);
+			free(entry_str);
+			++count;
+		}
+
+		++r;
+	}
+
+	// Free the memory.
+	for (r = 0; r < n_rows; ++r)
+		free(data[r]);
+
+	free(data);
+
+	// Close the file.
+	kshark_close(kshark_ctx);
+
+	// Close the session.
+	kshark_free(kshark_ctx);
+
+	return 0;
+}
-- 
2.17.1
