Return-Path: <SRS0=QejA=KV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33659 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733159AbeHFSaA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Aug 2018 14:30:00 -0400
Received: by mail-wm0-f67.google.com with SMTP id r24-v6so11953845wmh.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Aug 2018 09:20:10 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 3/6] kernel-shark-qt: Add an example showing how to manipulate the Vis. model.
Date: Mon,  6 Aug 2018 19:19:24 +0300
Message-Id: <20180806161927.11206-4-y.karadz@gmail.com>
In-Reply-To: <20180806161927.11206-1-y.karadz@gmail.com>
References: <20180806161927.11206-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch introduces a basic example, showing how to initialize the
Visualization model and to use the API to perform some of the basic
operations.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/examples/CMakeLists.txt |   4 +
 kernel-shark-qt/examples/datahisto.c    | 155 ++++++++++++++++++++++++
 2 files changed, 159 insertions(+)
 create mode 100644 kernel-shark-qt/examples/datahisto.c

diff --git a/kernel-shark-qt/examples/CMakeLists.txt b/kernel-shark-qt/examples/CMakeLists.txt
index 009fd1e..6906eba 100644
--- a/kernel-shark-qt/examples/CMakeLists.txt
+++ b/kernel-shark-qt/examples/CMakeLists.txt
@@ -7,3 +7,7 @@ target_link_libraries(dload   kshark)
 message(STATUS "datafilter")
 add_executable(dfilter          datafilter.c)
 target_link_libraries(dfilter   kshark)
+
+message(STATUS "datahisto")
+add_executable(dhisto          datahisto.c)
+target_link_libraries(dhisto   kshark)
diff --git a/kernel-shark-qt/examples/datahisto.c b/kernel-shark-qt/examples/datahisto.c
new file mode 100644
index 0000000..3f19870
--- /dev/null
+++ b/kernel-shark-qt/examples/datahisto.c
@@ -0,0 +1,155 @@
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
+#include "libkshark-model.h"
+
+#define N_BINS 5
+
+const char *default_file = "trace.dat";
+
+void dump_bin(struct kshark_trace_histo *histo, int bin,
+	      const char *type, int val)
+{
+	const struct kshark_entry *e_front, *e_back;
+	char *entry_str;
+	ssize_t i_front, i_back;
+
+	printf("bin %i {\n", bin);
+	if (strcmp(type, "cpu") == 0) {
+		e_front = ksmodel_get_entry_front(histo, bin, true,
+						  kshark_match_cpu, val,
+						  &i_front);
+
+		e_back = ksmodel_get_entry_back(histo, bin, true,
+						kshark_match_cpu, val,
+						&i_back);
+	} else if (strcmp(type, "task") == 0) {
+		e_front = ksmodel_get_entry_front(histo, bin, true,
+						  kshark_match_pid, val,
+						  &i_front);
+
+		e_back = ksmodel_get_entry_back(histo, bin, true,
+						kshark_match_pid, val,
+						&i_back);
+	} else {
+		i_front = ksmodel_first_index_at_bin(histo, bin);
+		e_front = histo->data[i_front];
+
+		i_back = ksmodel_last_index_at_bin(histo, bin);
+		e_back = histo->data[i_back];
+	}
+
+	if (i_front == KS_EMPTY_BIN) {
+		puts ("EMPTY BIN");
+	} else {
+		entry_str = kshark_dump_entry(e_front);
+		printf("%li -> %s\n", i_front, entry_str);
+		free(entry_str);
+
+		entry_str = kshark_dump_entry(e_back);
+		printf("%li -> %s\n", i_back, entry_str);
+		free(entry_str);
+	}
+
+	puts("}\n");
+}
+
+void dump_histo(struct kshark_trace_histo *histo, const char *type, int val)
+{
+	size_t bin;
+
+	for (bin = 0; bin < histo->n_bins; ++bin)
+		dump_bin(histo, bin, type, val);
+}
+
+int main(int argc, char **argv)
+{
+	struct kshark_context *kshark_ctx;
+	struct kshark_entry **data = NULL;
+	struct kshark_trace_histo histo;
+	size_t i, n_rows, n_tasks;
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
+	/* Get a list of all tasks. */
+	n_tasks = kshark_get_task_pids(kshark_ctx, &pids);
+
+	/* Initialize the Visualization Model. */
+	ksmodel_init(&histo);
+	ksmodel_set_bining(&histo, N_BINS, data[0]->ts,
+					   data[n_rows - 1]->ts);
+
+	/* Fill the model with data and calculate its state. */
+	ksmodel_fill(&histo, data, n_rows);
+
+	/* Dump the raw bins. */
+	dump_histo(&histo, "", 0);
+
+	puts("\n...\n\n");
+
+	/*
+	 * Change the state of the model. Do 50% Zoom-In and dump only CPU 0.
+	 */
+	ksmodel_zoom_in(&histo, .50, -1);
+	dump_histo(&histo, "cpu", 0);
+
+	puts("\n...\n\n");
+
+	/* Shift forward by two bins and this time dump only CPU 1. */
+	ksmodel_shift_forward(&histo, 2);
+	dump_histo(&histo, "cpu", 1);
+
+	puts("\n...\n\n");
+
+	/*
+	 * Do 10% Zoom-Out, using the last bin as a focal point. Dump the last
+	 * Task.
+	 */
+	ksmodel_zoom_out(&histo, .10, N_BINS - 1);
+	dump_histo(&histo, "task", pids[n_tasks - 1]);
+
+	/* Reset (clear) the model. */
+	ksmodel_clear(&histo);
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
