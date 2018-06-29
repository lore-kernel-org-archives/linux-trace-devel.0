Return-Path: <SRS0=62yJ=JP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:41619 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935222AbeF2P0i (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Jun 2018 11:26:38 -0400
Received: by mail-wr0-f193.google.com with SMTP id h10-v6so9218197wrq.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jun 2018 08:26:37 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 7/9] kernel-shark-qt: Add an example showing how to filter trace data
Date: Fri, 29 Jun 2018 18:25:39 +0300
Message-Id: <20180629152541.10109-8-y.karadz@gmail.com>
In-Reply-To: <20180629152541.10109-1-y.karadz@gmail.com>
References: <20180629152541.10109-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch introduces a basic example, showing how to use the
C API of KernelShark in order to filter trace data.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/examples/CMakeLists.txt |   4 +
 kernel-shark-qt/examples/datafilter.c   | 123 ++++++++++++++++++++++++
 2 files changed, 127 insertions(+)
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
index 0000000..70f814a
--- /dev/null
+++ b/kernel-shark-qt/examples/datafilter.c
@@ -0,0 +1,123 @@
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
+	char *entry_str;
+	struct kshark_entry **data = NULL;
+	size_t i, n_rows, n_tasks, n_evts, count;
+	bool status;
+	int *pids;
+
+	/* Create a new kshark session. */
+	struct kshark_context *kshark_ctx = NULL;
+	if(!kshark_instance(&kshark_ctx))
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
+	/* Filter the trace data coming from trace-cmd. */
+	n_tasks = kshark_get_task_pids(kshark_ctx, &pids);
+	for (i = 0; i < n_tasks; ++i) {
+		const char *task_str =
+			pevent_data_comm_from_pid(kshark_ctx->pevent,
+						  pids[i]);
+
+		if (strcmp(task_str, "trace-cmd") == 0)
+			kshark_filter_add_id(kshark_ctx, KS_HIDE_TASK_FILTER,
+							 pids[i]);
+	}
+
+	free(pids);
+
+	/*
+	 * Set the Filter Mask. In this case we want to avoid showing the
+	 * filterd entris in text format.
+	 */
+	kshark_ctx->filter_mask = KS_TEXT_VIEW_FILTER_MASK;
+	kshark_filter_entries(kshark_ctx, data, n_rows);
+
+	/* Print to the screen the first 10 visible entries. */
+	count = 0;
+	i = 0;
+	for (i = 0; i < n_rows; ++i) {
+		if (data[i]->visible & KS_TEXT_VIEW_FILTER_MASK) {
+			entry_str = kshark_dump_entry(data[i]);
+			puts(entry_str);
+			free(entry_str);
+
+			if (++count > 10)
+				break;
+		}
+
+		++i;
+	}
+
+	puts("\n\n");
+
+	/* Show only "sched" events. */
+	struct event_format *event;
+	n_evts = kshark_ctx->pevent->nr_events;
+	for (i = 0; i < n_evts; ++i) {
+		event = kshark_ctx->pevent->events[i];
+		if (strcmp(event->system, "sched") == 0)
+			kshark_filter_add_id(kshark_ctx, KS_SHOW_EVENT_FILTER,
+							 event->id);
+	}
+
+	kshark_filter_entries(kshark_ctx, data, n_rows);
+
+	/* Print to the screen the first 10 visible entries. */
+	count = 0;
+	i = 0;
+	for (i = 0; i < n_rows; ++i) {
+		if (data[i]->visible & KS_TEXT_VIEW_FILTER_MASK) {
+			entry_str = kshark_dump_entry(data[i]);
+			puts(entry_str);
+			free(entry_str);
+
+			if (++count > 10)
+				break;
+		}
+
+		++i;
+	}
+
+	/* Free the memory. */
+	for (i = 0; i < n_rows; ++i)
+		free(data[i]);
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
