Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-wm1-f46.google.com ([209.85.128.46]:54812 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729271AbfACMIm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Jan 2019 07:08:42 -0500
Received: by mail-wm1-f46.google.com with SMTP id a62so29107118wmh.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Jan 2019 04:08:39 -0800 (PST)
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: multi-thread read bug
Message-ID: <e85a0404-85e7-b8f7-2c47-0c90ba42e7e0@gmail.com>
Date: Thu, 3 Jan 2019 14:08:37 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------ABEDFD0CE02DFF958AECFC17"
Content-Language: en-US
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------ABEDFD0CE02DFF958AECFC17
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ceco,

I have a problem when trying to call tracecmd_read_at() from different 
threads. Although the call of tracecmd_read_at() is protected by a 
mutex, I am still getting a segmentation fault.
A simple program that reproduces the problem is attached as a patch.

Thanks!
Yordan

--------------ABEDFD0CE02DFF958AECFC17
Content-Type: text/x-patch;
 name="mt_read_bug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mt_read_bug.patch"

diff --git a/kernel-shark-qt/examples/CMakeLists.txt b/kernel-shark-qt/examples/CMakeLists.txt
index e16216e..ae1331c 100644
--- a/kernel-shark-qt/examples/CMakeLists.txt
+++ b/kernel-shark-qt/examples/CMakeLists.txt
@@ -23,3 +23,7 @@ target_link_libraries(dplot   kshark-plot)
 message(STATUS "widgetdemo")
 add_executable(widgetdemo          widgetdemo.cpp)
 target_link_libraries(widgetdemo   kshark-gui)
+
+message(STATUS "mtread")
+add_executable(mtread          mt_read.cpp)
+target_link_libraries(mtread   kshark-gui)
diff --git a/kernel-shark-qt/examples/mt_read.cpp b/kernel-shark-qt/examples/mt_read.cpp
index e69de29..0419454 100644
--- a/kernel-shark-qt/examples/mt_read.cpp
+++ b/kernel-shark-qt/examples/mt_read.cpp
@@ -0,0 +1,82 @@
+// C
+#include <stdio.h>
+#include <stdlib.h>
+
+// C++
+#include <vector>
+#include <thread>
+
+// KernelShark
+#include "libkshark.h"
+
+using namespace std;
+
+const char *default_file = "trace.dat";
+
+static void read_job(struct kshark_context *kshark_ctx,
+		     struct kshark_entry **data,
+		     size_t first, size_t last)
+{
+	struct tep_record *rec;
+
+	for (size_t r = first; r < last; ++r) {
+		rec = kshark_read_at(kshark_ctx, data[r]->offset);
+		free(rec);
+	}
+}
+
+int main(int argc, char **argv)
+{
+	int nThreads = std::thread::hardware_concurrency();
+	struct kshark_context *kshark_ctx;
+	struct kshark_entry **data = NULL;
+	size_t r, n_rows;
+	int first, last, delta;
+	bool status;
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
+// 	nThreads = 1;
+	delta = n_rows / nThreads;
+	vector<thread> threads;
+	for (int i = 0; i < nThreads; ++i) {
+		first = i * delta;
+		last = first + delta - 1;
+		threads.push_back(thread(read_job, kshark_ctx, data, first, last));
+// 		threads.push_back(thread(read_job, kshark_ctx, data, 0, n_rows));
+	}
+
+	for (auto &t:threads)
+		t.join();
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

--------------ABEDFD0CE02DFF958AECFC17--
