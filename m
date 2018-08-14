Return-Path: <SRS0=HiQF=K5=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:52007 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729384AbeHNUwg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Aug 2018 16:52:36 -0400
Received: by mail-wm0-f66.google.com with SMTP id y2-v6so13170389wma.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Aug 2018 11:04:16 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/3] kernel-shark-qt: Add an example showing how to import/export config. data
Date: Tue, 14 Aug 2018 21:03:48 +0300
Message-Id: <20180814180348.17236-3-y.karadz@gmail.com>
In-Reply-To: <20180814180348.17236-1-y.karadz@gmail.com>
References: <20180814180348.17236-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch introduces a basic example, showing how to use the
C API of KernelShark to import/export configuration data.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/examples/CMakeLists.txt |  4 ++
 kernel-shark-qt/examples/configio.c     | 67 +++++++++++++++++++++++++
 2 files changed, 71 insertions(+)
 create mode 100644 kernel-shark-qt/examples/configio.c

diff --git a/kernel-shark-qt/examples/CMakeLists.txt b/kernel-shark-qt/examples/CMakeLists.txt
index 6906eba..a3745fa 100644
--- a/kernel-shark-qt/examples/CMakeLists.txt
+++ b/kernel-shark-qt/examples/CMakeLists.txt
@@ -11,3 +11,7 @@ target_link_libraries(dfilter   kshark)
 message(STATUS "datahisto")
 add_executable(dhisto          datahisto.c)
 target_link_libraries(dhisto   kshark)
+
+message(STATUS "confogio")
+add_executable(confio          configio.c)
+target_link_libraries(confio   kshark)
diff --git a/kernel-shark-qt/examples/configio.c b/kernel-shark-qt/examples/configio.c
new file mode 100644
index 0000000..b7efad1
--- /dev/null
+++ b/kernel-shark-qt/examples/configio.c
@@ -0,0 +1,67 @@
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "libkshark.h"
+
+int main(int argc, char **argv)
+{
+	struct kshark_config_doc *conf, *filter, *hello;
+	struct kshark_context *kshark_ctx;
+	int *ids, i;
+
+	/* Create a new kshark session. */
+	kshark_ctx = NULL;
+	if (!kshark_instance(&kshark_ctx))
+		return 1;
+
+	if (argc == 1) {
+		tracecmd_filter_id_add(kshark_ctx->show_task_filter, 314);
+		tracecmd_filter_id_add(kshark_ctx->show_task_filter, 42);
+
+		/* Create a new Confog. doc. */
+		conf = kshark_config_new("foo.bar.config", KS_JSON_CONFIG);
+
+		/* Add filter's info. */
+		filter = kshark_export_all_filters(kshark_ctx);
+		kshark_config_doc_add(conf, "Filters" ,filter);
+
+		/* Add "Hello Kernel" message. */
+		hello = kshark_string_config_alloc();
+		hello->conf_doc = "Hello Kernel";
+		kshark_config_doc_add(conf, "Message" ,hello);
+
+		/* Save to file. */
+		kshark_save_config_file("conf.json", conf);
+	} else {
+		/* Open a Config. file. */
+		conf = kshark_open_config_file(argv[1], "foo.bar.config");
+
+		/* Retriever the filter's info. */
+		filter = kshark_config_alloc(KS_JSON_CONFIG);
+		if (!kshark_config_doc_get(conf, "Filters" ,filter))
+			return 1;
+
+		kshark_import_all_filters(kshark_ctx, filter);
+
+		/* Get the array of Ids to be fitered. */
+		ids = tracecmd_filter_ids(kshark_ctx->show_task_filter);
+		for (i = 0; i < kshark_ctx->show_task_filter->count; ++i)
+			printf("pid: %i\n", ids[i]);
+
+		/* Retriever the message. */
+		hello = kshark_string_config_alloc();
+		kshark_config_doc_get(conf, "Message" ,hello);
+
+		puts((char *) hello->conf_doc);
+
+		free(filter);
+		free(hello);
+		free(ids);
+	}
+
+	kshark_free_config_doc(conf);
+
+	kshark_free(kshark_ctx);
+
+	return 0;
+}
-- 
2.17.1
