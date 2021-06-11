Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4A1C48BE5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DA1A613F1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhFKLn3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 07:43:29 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:33458 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbhFKLn2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 07:43:28 -0400
Received: by mail-wr1-f52.google.com with SMTP id a20so5759398wrc.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Jun 2021 04:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qzCZlXSwpT/g2xUVwDR/9ZbYIzRTzZFUiRqgetIGbts=;
        b=qLQbvYqbFENSwYMgYN7iTXlhzh8B1G6C7si9Nb/1KaxsD4Y02VO8/9Zq8T2ByufhBP
         er+N9pfI367rEqX0gpmPiw+bQxeoVgyPMUsarzEJvehACSvSeZhj4C98IUwB0uLghhUL
         0TElo2NCviPsVoodN+CjEaDqajeWdjF4JCEkz559mgkgkXbB5w4wCVE6k03bW6Ss0mEm
         edDKXWsIxbFTxAe/RP1vyVzxecqPAWu436rICSg+X+oiXuxdGu1qrk/1MFJjdaa6J4LY
         6lTXTJZA6mJw9llSanlK2AZTYfk3+htKQVIGyNc3tD12mlShqIG2vo0gQeGv6ARQ/FIs
         QVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qzCZlXSwpT/g2xUVwDR/9ZbYIzRTzZFUiRqgetIGbts=;
        b=AebzLMHs8GE6cKx3R/PYYbuzHLgOtDrALgfyS59RnEJmyGFGmnekJg47kQ+XAiFW0n
         RvRHYTLUQ7W/us7DkmtTJaIlc53zCx9liHtMHP1w2UbGPQckeh9Lf0D4V0k2v43/KqlZ
         FdXCP4fKwiJG3eL53YNzQXU84GDKRx3VKX967gf5V6O7q4ZSXeA6OacxjmB1fJJ3/Xu1
         qWt3JlfohmHLOkFsyojsUpppe4+2vkI9Byxh3dFdEaZD49wcNnxaUBBY0gFQj8h+0l9J
         efS3L8rl/TuGepG3B3A+TMjvrB9+0KT4i81NmRxGSV3YW9VOYfIhvYCFsjOmRji1Z+Ae
         96LQ==
X-Gm-Message-State: AOAM532qmv03zhAPMQkWYLdSUf+GNys8swuQ6cMThHn1wzqBOPzBmEAS
        93PB0zJVCtNTwVzT9EqxAbgIhZBe94o=
X-Google-Smtp-Source: ABdhPJz44MrtSs3ZCZpaFLBf6PGPTe1g3XCXulq/QXGZwFQFMs4zFB7cPs0gtAwJmtsoOWL9xS35BA==
X-Received: by 2002:a5d:4a4b:: with SMTP id v11mr3679218wrs.246.1623411615505;
        Fri, 11 Jun 2021 04:40:15 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.164])
        by smtp.gmail.com with ESMTPSA id c7sm6856464wrs.23.2021.06.11.04.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 04:40:15 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 7/9] trace-cruncher: Remove all leftover files.
Date:   Fri, 11 Jun 2021 14:39:56 +0300
Message-Id: <20210611113958.38142-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611113958.38142-1-y.karadz@gmail.com>
References: <20210611113958.38142-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch completes the refactoring of trace-cruncher into a Python
module. All obsoleted source files are removed.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 0001-kernel-shark-Add-_DEVEL-build-flag.patch |  90 -----
 0002-kernel-shark-Add-reg_pid-plugin.patch    | 231 -----------
 clean.sh                                      |   6 -
 examples/ksharksetup.py                       |  24 --
 libkshark-py.c                                | 224 -----------
 libkshark_wrapper.pyx                         | 361 ------------------
 np_setup.py                                   |  90 -----
 7 files changed, 1026 deletions(-)
 delete mode 100644 0001-kernel-shark-Add-_DEVEL-build-flag.patch
 delete mode 100644 0002-kernel-shark-Add-reg_pid-plugin.patch
 delete mode 100755 clean.sh
 delete mode 100644 examples/ksharksetup.py
 delete mode 100644 libkshark-py.c
 delete mode 100644 libkshark_wrapper.pyx
 delete mode 100755 np_setup.py

diff --git a/0001-kernel-shark-Add-_DEVEL-build-flag.patch b/0001-kernel-shark-Add-_DEVEL-build-flag.patch
deleted file mode 100644
index ddd3fd4..0000000
--- a/0001-kernel-shark-Add-_DEVEL-build-flag.patch
+++ /dev/null
@@ -1,90 +0,0 @@
-From 6c9e3b3f29c8af4780bb46313c3af73fb5d852c7 Mon Sep 17 00:00:00 2001
-From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
-Date: Fri, 20 Sep 2019 14:31:15 +0300
-Subject: [PATCH 1/2] kernel-shark: Add _DEVEL build flag
-
-KernelShark can be built with -D_DEVEL=1 as a command-line argument
-for Cmake. In this case the headers of the libraries will be installed
-as well and a symbolic link that points to the version of the library
-being installed will be created.
-
-Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
----
- kernel-shark/README             |  3 +++
- kernel-shark/src/CMakeLists.txt | 33 +++++++++++++++++++++++++++++++++
- 2 files changed, 36 insertions(+)
-
-diff --git a/kernel-shark/README b/kernel-shark/README
-index 6c360bb..0f14212 100644
---- a/kernel-shark/README
-+++ b/kernel-shark/README
-@@ -96,6 +96,9 @@ the dialog will derive the absolut path to the trace-cmd executable from
- 
- If no build types is specified, the type will be "RelWithDebInfo".
- 
-+2.1.4 In order to install a development version (including headers e.t.c) add
-+-D_DEVEL=1 as a CMake Command-Line option.
-+
- Examples:
- 
-     cmake -D_DOXYGEN_DOC=1 -D_INSTALL_PREFIX=/usr ../
-diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
-index e20a030..305840b 100644
---- a/kernel-shark/src/CMakeLists.txt
-+++ b/kernel-shark/src/CMakeLists.txt
-@@ -1,5 +1,13 @@
- message("\n src ...")
- 
-+macro(install_symlink filepath sympath)
-+    install(CODE "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${filepath} ${sympath})")
-+    install(CODE "LIST(APPEND CMAKE_INSTALL_MANIFEST_FILES ${sympath})")
-+    install(CODE "message(\"-- Created symlink: ${sympath} -> ${filepath}\")")
-+endmacro(install_symlink)
-+
-+set(KS_INCLUDS_DESTINATION "${_INSTALL_PREFIX}/include/${KS_APP_NAME}")
-+
- message(STATUS "libkshark")
- add_library(kshark SHARED libkshark.c
-                           libkshark-model.c
-@@ -16,6 +24,19 @@ set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
- 
- install(TARGETS kshark LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
- 
-+if (_DEVEL)
-+
-+    install_symlink("libkshark.so.${KS_VERSION_STRING}"
-+                    "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/libkshark.so")
-+
-+    install(FILES "${KS_DIR}/src/libkshark.h"
-+                  "${KS_DIR}/src/libkshark-plugin.h"
-+                  "${KS_DIR}/src/libkshark-model.h"
-+            DESTINATION ${KS_INCLUDS_DESTINATION}
-+            COMPONENT devel)
-+
-+endif (_DEVEL)
-+
- if (OPENGL_FOUND AND GLUT_FOUND)
- 
-     message(STATUS "libkshark-plot")
-@@ -30,6 +51,18 @@ if (OPENGL_FOUND AND GLUT_FOUND)
- 
-     install(TARGETS kshark-plot LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
- 
-+    if (_DEVEL)
-+
-+        install_symlink("libkshark-plot.so.${KS_VERSION_STRING}"
-+                        "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/libkshark-plot.so")
-+
-+        install(FILES "${KS_DIR}/src/KsPlotTools.hpp"
-+                      "${KS_DIR}/src/libkshark-plot.h"
-+                DESTINATION ${KS_INCLUDS_DESTINATION}
-+                COMPONENT devel)
-+
-+    endif (_DEVEL)
-+
- endif (OPENGL_FOUND AND GLUT_FOUND)
- 
- if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
--- 
-2.20.1
-
diff --git a/0002-kernel-shark-Add-reg_pid-plugin.patch b/0002-kernel-shark-Add-reg_pid-plugin.patch
deleted file mode 100644
index 146e3e6..0000000
--- a/0002-kernel-shark-Add-reg_pid-plugin.patch
+++ /dev/null
@@ -1,231 +0,0 @@
-From b3efcb6368bc7f70a23e156dce6c58d09953889a Mon Sep 17 00:00:00 2001
-From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
-Date: Wed, 9 Oct 2019 16:57:27 +0300
-Subject: [PATCH 2/2] kernel-shark: Add "reg_pid" plugin
-
-"reg_pid" plugin is a simplified version of the "sched_events" plugin
-that makes sure that all tasks presented in the data are registered.
-All other functionalities of the "sched_events" plugin are removed.
-"reg_pid" plugin will be used by the NumPy interface (Trace-Cruncher).
-
-Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
----
- kernel-shark/src/plugins/CMakeLists.txt |   5 +-
- kernel-shark/src/plugins/reg_pid.c      | 189 ++++++++++++++++++++++++
- 2 files changed, 193 insertions(+), 1 deletion(-)
- create mode 100644 kernel-shark/src/plugins/reg_pid.c
-
-diff --git a/kernel-shark/src/plugins/CMakeLists.txt b/kernel-shark/src/plugins/CMakeLists.txt
-index 6c77179..bf69945 100644
---- a/kernel-shark/src/plugins/CMakeLists.txt
-+++ b/kernel-shark/src/plugins/CMakeLists.txt
-@@ -27,7 +27,10 @@ BUILD_PLUGIN(NAME missed_events
-              SOURCE missed_events.c MissedEvents.cpp)
- list(APPEND PLUGIN_LIST "missed_events default") # This plugin will be loaded by default
- 
--install(TARGETS sched_events missed_events
-+BUILD_PLUGIN(NAME reg_pid
-+             SOURCE reg_pid.c)
-+
-+install(TARGETS sched_events missed_events reg_pid
-         LIBRARY DESTINATION ${KS_PLUGIN_INSTALL_PREFIX})
- 
- set(PLUGINS ${PLUGIN_LIST} PARENT_SCOPE)
-diff --git a/kernel-shark/src/plugins/reg_pid.c b/kernel-shark/src/plugins/reg_pid.c
-new file mode 100644
-index 0000000..4116dd8
---- /dev/null
-+++ b/kernel-shark/src/plugins/reg_pid.c
-@@ -0,0 +1,189 @@
-+// SPDX-License-Identifier: LGPL-2.1
-+
-+/*
-+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
-+ */
-+
-+/**
-+ *  @file    reg_pid.c
-+ *  @brief   Defines a callback function for Sched events used to registers the
-+ *	     "next" task (if not registered already).
-+ */
-+
-+// C
-+#include <stdlib.h>
-+#include <stdio.h>
-+#include <assert.h>
-+
-+// KernelShark
-+#include "libkshark.h"
-+
-+/** Structure representing a plugin-specific context. */
-+struct plugin_pid_reg_context {
-+	/** Page event used to parse the page. */
-+	struct tep_handle	*pevent;
-+
-+	/** Pointer to the sched_switch_event object. */
-+	struct tep_event	*sched_switch_event;
-+
-+	/** Pointer to the sched_switch_next_field format descriptor. */
-+	struct tep_format_field	*sched_switch_next_field;
-+
-+	/** Pointer to the sched_switch_comm_field format descriptor. */
-+	struct tep_format_field	*sched_switch_comm_field;
-+};
-+
-+/** Plugin context instance. */
-+struct plugin_pid_reg_context *plugin_pid_reg_context_handler = NULL;
-+
-+static void plugin_free_context(struct plugin_pid_reg_context *plugin_ctx)
-+{
-+	if (!plugin_ctx)
-+		return;
-+
-+	free(plugin_ctx);
-+}
-+
-+static bool plugin_pid_reg_init_context(struct kshark_context *kshark_ctx)
-+{
-+	struct plugin_pid_reg_context *plugin_ctx;
-+	struct tep_event *event;
-+
-+	/* No context should exist when we initialize the plugin. */
-+	assert(plugin_pid_reg_context_handler == NULL);
-+
-+	if (!kshark_ctx->pevent)
-+		return false;
-+
-+	plugin_pid_reg_context_handler =
-+		calloc(1, sizeof(*plugin_pid_reg_context_handler));
-+	if (!plugin_pid_reg_context_handler) {
-+		fprintf(stderr,
-+			"Failed to allocate memory for plugin_pid_reg_context.\n");
-+		return false;
-+	}
-+
-+	plugin_ctx = plugin_pid_reg_context_handler;
-+	plugin_ctx->pevent = kshark_ctx->pevent;
-+
-+	event = tep_find_event_by_name(plugin_ctx->pevent,
-+				       "sched", "sched_switch");
-+	if (!event) {
-+		plugin_free_context(plugin_ctx);
-+		plugin_pid_reg_context_handler = NULL;
-+
-+		return false;
-+	}
-+
-+	plugin_ctx->sched_switch_event = event;
-+
-+	plugin_ctx->sched_switch_next_field =
-+		tep_find_any_field(event, "next_pid");
-+
-+	plugin_ctx->sched_switch_comm_field =
-+		tep_find_field(event, "next_comm");
-+
-+	return true;
-+}
-+
-+/**
-+ * @brief Get the Process Id of the next scheduled task.
-+ *
-+ * @param record: Input location for a sched_switch record.
-+ */
-+int plugin_get_next_pid(struct tep_record *record)
-+{
-+	struct plugin_pid_reg_context *plugin_ctx =
-+		plugin_pid_reg_context_handler;
-+	unsigned long long val;
-+	int ret;
-+
-+	ret = tep_read_number_field(plugin_ctx->sched_switch_next_field,
-+				    record->data, &val);
-+
-+	return ret ? : val;
-+}
-+
-+static void plugin_register_command(struct kshark_context *kshark_ctx,
-+				    struct tep_record *record,
-+				    int pid)
-+{
-+	struct plugin_pid_reg_context *plugin_ctx =
-+		plugin_pid_reg_context_handler;
-+	const char *comm;
-+
-+	if (!plugin_ctx->sched_switch_comm_field)
-+		return;
-+
-+	comm = record->data + plugin_ctx->sched_switch_comm_field->offset;
-+	/*
-+	 * TODO: The retrieve of the name of the command above needs to be
-+	 * implemented as a wrapper function in libtracevent.
-+	 */
-+
-+	if (!tep_is_pid_registered(kshark_ctx->pevent, pid))
-+			tep_register_comm(kshark_ctx->pevent, comm, pid);
-+}
-+
-+static void plugin_pid_reg_action(struct kshark_context *kshark_ctx,
-+				  struct tep_record *rec,
-+				  struct kshark_entry *entry)
-+{
-+	int pid = plugin_get_next_pid(rec);
-+	if (pid >= 0)
-+		plugin_register_command(kshark_ctx, rec, pid);
-+}
-+
-+static void nop_action(struct kshark_cpp_argv *argv, int val, int action)
-+{}
-+
-+static int plugin_pid_reg_init(struct kshark_context *kshark_ctx)
-+{
-+	struct plugin_pid_reg_context *plugin_ctx;
-+
-+	if (!plugin_pid_reg_init_context(kshark_ctx))
-+		return 0;
-+
-+	plugin_ctx = plugin_pid_reg_context_handler;
-+
-+	kshark_register_event_handler(&kshark_ctx->event_handlers,
-+				      plugin_ctx->sched_switch_event->id,
-+				      plugin_pid_reg_action,
-+				      nop_action);
-+
-+	return 1;
-+}
-+
-+static int plugin_pid_reg_close(struct kshark_context *kshark_ctx)
-+{
-+	struct plugin_pid_reg_context *plugin_ctx;
-+
-+	if (!plugin_pid_reg_context_handler)
-+		return 0;
-+
-+	plugin_ctx = plugin_pid_reg_context_handler;
-+
-+	kshark_unregister_event_handler(&kshark_ctx->event_handlers,
-+					plugin_ctx->sched_switch_event->id,
-+					plugin_pid_reg_action,
-+					nop_action);
-+
-+	plugin_free_context(plugin_ctx);
-+	plugin_pid_reg_context_handler = NULL;
-+
-+	return 1;
-+}
-+
-+/** Load this plugin. */
-+int KSHARK_PLUGIN_INITIALIZER(struct kshark_context *kshark_ctx)
-+{
-+// 	printf("--> pid_reg init\n");
-+	return plugin_pid_reg_init(kshark_ctx);
-+}
-+
-+/** Unload this plugin. */
-+int KSHARK_PLUGIN_DEINITIALIZER(struct kshark_context *kshark_ctx)
-+{
-+// 	printf("<-- pid reg close\n");
-+	return plugin_pid_reg_close(kshark_ctx);
-+}
--- 
-2.20.1
-
diff --git a/clean.sh b/clean.sh
deleted file mode 100755
index a739b88..0000000
--- a/clean.sh
+++ /dev/null
@@ -1,6 +0,0 @@
-#!/bin/bash
-
-rm libkshark_wrapper.c
-rm ksharkpy.cpython-3*.so
-rm -rf build/
-rm -rf examples/__pycache__/
diff --git a/examples/ksharksetup.py b/examples/ksharksetup.py
deleted file mode 100644
index 86729e3..0000000
--- a/examples/ksharksetup.py
+++ /dev/null
@@ -1,24 +0,0 @@
-#!/usr/bin/env python3
-
-"""
-SPDX-License-Identifier: LGPL-2.1
-
-Copyright 2019 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
-"""
-
-import os
-import sys
-
-def setup():
-    os.chdir(os.path.dirname(__file__))
-    path = os.getcwd() + '/..'
-    sys.path.append(path)
-
-    if 'LD_LIBRARY_PATH' not in os.environ:
-        os.environ['LD_LIBRARY_PATH'] = '/usr/local/lib/kernelshark:/usr/local/lib/traceevent:/usr/local/lib/trace-cmd'
-        try:
-            os.execv(sys.argv[0], sys.argv)
-        except e:
-            print('Failed re-exec:', e)
-            sys.exit(1)
-
diff --git a/libkshark-py.c b/libkshark-py.c
deleted file mode 100644
index 8b39bae..0000000
--- a/libkshark-py.c
+++ /dev/null
@@ -1,224 +0,0 @@
-// SPDX-License-Identifier: LGPL-2.1
-
-/*
- * Copyright 2019 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
- */
-
- /**
-  *  @file    libkshark-py.c
-  *  @brief   Python API for processing of FTRACE (trace-cmd) data.
-  */
-
-// KernelShark
-#include "kernelshark/libkshark.h"
-#include "kernelshark/libkshark-model.h"
-
-bool kspy_open(const char *fname)
-{
-	struct kshark_context *kshark_ctx = NULL;
-
-	if (!kshark_instance(&kshark_ctx))
-		return false;
-
-	return kshark_open(kshark_ctx, fname);
-}
-
-void kspy_close(void)
-{
-	struct kshark_context *kshark_ctx = NULL;
-
-	if (!kshark_instance(&kshark_ctx))
-		return;
-
-	kshark_close(kshark_ctx);
-	kshark_free(kshark_ctx);
-}
-
-static int compare(const void * a, const void * b)
-{
-	return *(int*)a - *(int*)b;
-}
-
-size_t kspy_get_tasks(int **pids, char ***names)
-{
-	struct kshark_context *kshark_ctx = NULL;
-	const char *comm;
-	ssize_t i, n;
-	int ret;
-
-	if (!kshark_instance(&kshark_ctx))
-		return 0;
-
-	n = kshark_get_task_pids(kshark_ctx, pids);
-	if (n == 0)
-		return 0;
-
-	qsort(*pids, n, sizeof(**pids), compare);
-
-	*names = calloc(n, sizeof(char*));
-	if (!(*names))
-		goto fail;
-
-	for (i = 0; i < n; ++i) {
-		comm = tep_data_comm_from_pid(kshark_ctx->pevent, (*pids)[i]);
-		ret = asprintf(&(*names)[i], "%s", comm);
-		if (ret < 1)
-			goto fail;
-	}
-
-	return n;
-
-  fail:
-	free(*pids);
-	free(*names);
-	return 0;
-}
-
-size_t kspy_trace2matrix(uint64_t **offset_array,
-			 uint16_t **cpu_array,
-			 uint64_t **ts_array,
-			 uint16_t **pid_array,
-			 int **event_array)
-{
-	struct kshark_context *kshark_ctx = NULL;
-	size_t total = 0;
-
-	if (!kshark_instance(&kshark_ctx))
-		return false;
-
-	total = kshark_load_data_matrix(kshark_ctx, offset_array,
-					cpu_array,
-					ts_array,
-					pid_array,
-					event_array);
-
-	return total;
-}
-
-int kspy_get_event_id(const char *sys, const char *evt)
-{
-	struct kshark_context *kshark_ctx = NULL;
-	struct tep_event *event;
-
-	if (!kshark_instance(&kshark_ctx))
-		return -1;
-
-	event = tep_find_event_by_name(kshark_ctx->pevent, sys, evt);
-
-	return event->id;
-}
-
-unsigned long long kspy_read_event_field(uint64_t offset,
-					 int id, const char *field)
-{
-	struct kshark_context *kshark_ctx = NULL;
-	struct tep_format_field *evt_field;
-	struct tep_record *record;
-	struct tep_event *event;
-	unsigned long long val;
-	int ret;
-
-	if (!kshark_instance(&kshark_ctx))
-		return 0;
-
-	event = tep_find_event(kshark_ctx->pevent, id);
-	if (!event)
-		return 0;
-
-	evt_field = tep_find_any_field(event, field);
-	if (!evt_field)
-		return 0;
-
-	record = tracecmd_read_at(kshark_ctx->handle, offset, NULL);
-	if (!record)
-		return 0;
-
-	ret = tep_read_number_field(evt_field, record->data, &val);
-	free_record(record);
-
-	if (ret != 0)
-		return 0;
-
-	return val;
-}
-
-const char *kspy_get_function(unsigned long long addr)
-{
-	struct kshark_context *kshark_ctx = NULL;
-
-	if (!kshark_instance(&kshark_ctx))
-		return "";
-
-	return tep_find_function(kshark_ctx->pevent, addr);
-}
-
-void kspy_register_plugin(const char *plugin)
-{
-	struct kshark_context *kshark_ctx = NULL;
-	char *lib_file;
-	int n;
-
-	if (!kshark_instance(&kshark_ctx))
-		return;
-
-	n = asprintf(&lib_file, "%s/plugin-%s.so", KS_PLUGIN_DIR, plugin);
-	if (n > 0) {
-		kshark_register_plugin(kshark_ctx, lib_file);
-		kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_INIT);
-		free(lib_file);
-	}
-}
-
-const char *kspy_map_instruction_address(int pid, unsigned long long proc_addr,
-					 unsigned long long *obj_addr)
-{
-	struct kshark_context *kshark_ctx = NULL;
-	struct tracecmd_proc_addr_map *mem_map;
-
-	*obj_addr = 0;
-	if (!kshark_instance(&kshark_ctx))
-		return "UNKNOWN";
-
-	mem_map = tracecmd_search_task_map(kshark_ctx->handle,
-					   pid, proc_addr);
-
-	if (!mem_map)
-		return "UNKNOWN";
-
-	*obj_addr = proc_addr - mem_map->start;
-
-	return mem_map->lib_name;
-}
-
-void kspy_new_session_file(const char *data_file, const char *session_file)
-{
-	struct kshark_context *kshark_ctx = NULL;
-	struct kshark_trace_histo histo;
-	struct kshark_config_doc *session;
-	struct kshark_config_doc *filters;
-	struct kshark_config_doc *markers;
-	struct kshark_config_doc *model;
-	struct kshark_config_doc *file;
-
-	if (!kshark_instance(&kshark_ctx))
-		return;
-
-	session = kshark_config_new("kshark.config.session",
-				    KS_CONFIG_JSON);
-
-	file = kshark_export_trace_file(data_file, KS_CONFIG_JSON);
-	kshark_config_doc_add(session, "Data", file);
-
-	filters = kshark_export_all_filters(kshark_ctx, KS_CONFIG_JSON);
-	kshark_config_doc_add(session, "Filters", filters);
-
-	ksmodel_init(&histo);
-	model = kshark_export_model(&histo, KS_CONFIG_JSON);
-	kshark_config_doc_add(session, "Model", model);
-
-	markers = kshark_config_new("kshark.config.markers", KS_CONFIG_JSON);
-	kshark_config_doc_add(session, "Markers", markers);
-
-	kshark_save_config_file(session_file, session);
-	kshark_free_config_doc(session);
-}
diff --git a/libkshark_wrapper.pyx b/libkshark_wrapper.pyx
deleted file mode 100644
index 1b75685..0000000
--- a/libkshark_wrapper.pyx
+++ /dev/null
@@ -1,361 +0,0 @@
-"""
-SPDX-License-Identifier: LGPL-2.1
-
-Copyright 2019 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
-"""
-
-import ctypes
-
-# Import the Python-level symbols of numpy
-import numpy as np
-# Import the C-level symbols of numpy
-cimport numpy as np
-
-import json
-
-from libcpp cimport bool
-
-from libc.stdlib cimport free
-
-from cpython cimport PyObject, Py_INCREF
-
-
-cdef extern from 'stdint.h':
-    ctypedef unsigned short uint8_t
-    ctypedef unsigned short uint16_t
-    ctypedef unsigned long long uint64_t
-
-cdef extern from 'numpy/ndarraytypes.h':
-    int NPY_ARRAY_CARRAY
-
-# Declare all C functions we are going to call
-cdef extern from 'libkshark-py.c':
-    bool kspy_open(const char *fname)
-
-cdef extern from 'libkshark-py.c':
-    bool kspy_close()
-
-cdef extern from 'libkshark-py.c':
-    size_t kspy_trace2matrix(uint64_t **offset_array,
-                             uint8_t **cpu_array,
-                             uint64_t **ts_array,
-                             uint16_t **pid_array,
-                             int **event_array)
-
-cdef extern from 'libkshark-py.c':
-    int kspy_get_event_id(const char *sys, const char *evt)
-
-cdef extern from 'libkshark-py.c':
-    uint64_t kspy_read_event_field(uint64_t offset,
-                                   int event_id,
-                                   const char *field)
-
-cdef extern from 'libkshark-py.c':
-    ssize_t kspy_get_tasks(int **pids, char ***names)
-
-cdef extern from 'libkshark-py.c':
-    const char *kspy_get_function(unsigned long long addr)
-
-cdef extern from 'libkshark-py.c':
-    void kspy_register_plugin(const char *file)
-
-cdef extern from 'libkshark-py.c':
-    const char *kspy_map_instruction_address(int pid,
-					     unsigned long long proc_addr,
-					     unsigned long long *obj_addr)
-
-cdef extern from 'kernelshark/libkshark.h':
-    int KS_EVENT_OVERFLOW
-
-cdef extern from 'libkshark-py.c':
-    void kspy_new_session_file(const char *data_file,
-                               const char *session_file)
-
-EVENT_OVERFLOW = KS_EVENT_OVERFLOW
-
-# Numpy must be initialized!!!
-np.import_array()
-
-
-cdef class KsDataWrapper:
-    cdef int item_size
-    cdef int data_size
-    cdef int data_type
-    cdef void* data_ptr
-
-    cdef init(self,
-              int data_type,
-              int data_size,
-              int item_size,
-              void* data_ptr):
-        """ This initialization cannot be done in the constructor because
-            we use C-level arguments.
-        """
-        self.item_size = item_size
-        self.data_size = data_size
-        self.data_type = data_type
-        self.data_ptr = data_ptr
-
-    def __array__(self):
-        """ Here we use the __array__ method, that is called when numpy
-            tries to get an array from the object.
-        """
-        cdef np.npy_intp shape[1]
-        shape[0] = <np.npy_intp> self.data_size
-
-        ndarray = np.PyArray_New(np.ndarray,
-                                 1, shape,
-                                 self.data_type,
-                                 NULL,
-                                 self.data_ptr,
-                                 self.item_size,
-                                 NPY_ARRAY_CARRAY,
-                                 <object>NULL)
-
-        return ndarray
-
-    def __dealloc__(self):
-        """ Free the data. This is called by Python when all the references to
-            the object are gone.
-        """
-        free(<void*>self.data_ptr)
-
-
-def c_str2py(char *c_str):
-    """ String convertion C -> Python
-    """
-    return ctypes.c_char_p(c_str).value.decode('utf-8')
-
-
-def py_str2c(py_str):
-    """ String convertion Python -> C
-    """
-    return py_str.encode('utf-8')
-
-
-def open_file(fname):
-    """ Open a tracing data file.
-    """
-    return kspy_open(py_str2c(fname))
-
-
-def close():
-    """ Open the session file.
-    """
-    kspy_close()
-
-
-def read_event_field(offset, event_id, field):
-    """ Read the value of a specific field of the trace event.
-    """
-    cdef uint64_t v
-
-    v = kspy_read_event_field(offset, event_id, py_str2c(field))
-    return v
-
-
-def event_id(system, event):
-    """ Get the unique Id of the event
-    """
-    return kspy_get_event_id(py_str2c(system), py_str2c(event))
-
-
-def get_tasks():
-    """ Get a dictionary of all task's PIDs
-    """
-    cdef int *pids
-    cdef char **names
-    cdef int size = kspy_get_tasks(&pids, &names)
-
-    task_dict = {}
-
-    for i in range(0, size):
-        name = c_str2py(names[i])
-        pid_list = task_dict.get(name)
-
-        if pid_list is None:
-            pid_list = []
-
-        pid_list.append(pids[i])
-        task_dict.update({name : pid_list})
-
-    return task_dict
-
-def get_function(ip):
-    """ Get the name of the function from its ip
-    """
-    func = kspy_get_function(ip)
-    if func:
-        return c_str2py(kspy_get_function(ip))
-
-    return str("0x%x" %ip)
-
-def register_plugin(plugin):
-    """
-    """
-    kspy_register_plugin(py_str2c(plugin))
-
-def map_instruction_address(pid, address):
-    """
-    """
-    cdef unsigned long long obj_addr;
-    cdef const char* obj_file;
-    obj_file = kspy_map_instruction_address(pid, address, &obj_addr)
-
-    return {'obj_file' : c_str2py(obj_file), 'address' : obj_addr}
-
-def load_data(ofst_data=True, cpu_data=True,
-	      ts_data=True, pid_data=True,
-	      evt_data=True):
-    """ Python binding of the 'kshark_load_data_matrix' function that does not
-        copy the data. The input parameters can be used to avoid loading the
-        data from the unnecessary fields.
-    """
-    cdef uint64_t *ofst_c
-    cdef uint16_t *cpu_c
-    cdef uint64_t *ts_c
-    cdef uint16_t *pid_c
-    cdef int *evt_c
-
-    cdef np.ndarray ofst
-    cdef np.ndarray cpu
-    cdef np.ndarray ts
-    cdef np.ndarray pid
-    cdef np.ndarray evt
-
-    if not ofst_data:
-        ofst_c = NULL
-
-    if not cpu_data:
-        cpu_c = NULL
-
-    if not ts_data:
-        ts_c = NULL
-
-    if not pid_data:
-        pid_c = NULL
-
-    if not evt_data:
-        evt_c = NULL
-
-    data_dict = {}
-
-    # Call the C function
-    size = kspy_trace2matrix(&ofst_c, &cpu_c, &ts_c, &pid_c, &evt_c)
-
-    if ofst_data:
-        array_wrapper_ofst = KsDataWrapper()
-        array_wrapper_ofst.init(data_type=np.NPY_UINT64,
-                                item_size=0,
-                                data_size=size,
-                                data_ptr=<void *> ofst_c)
-
-
-        ofst = np.array(array_wrapper_ofst, copy=False)
-        ofst.base = <PyObject *> array_wrapper_ofst
-        data_dict.update({'offset': ofst})
-        Py_INCREF(array_wrapper_ofst)
-
-    if cpu_data:
-        array_wrapper_cpu = KsDataWrapper()
-        array_wrapper_cpu.init(data_type=np.NPY_UINT16,
-                               data_size=size,
-                               item_size=0,
-                               data_ptr=<void *> cpu_c)
-
-        cpu = np.array(array_wrapper_cpu, copy=False)
-        cpu.base = <PyObject *> array_wrapper_cpu
-        data_dict.update({'cpu': cpu})
-        Py_INCREF(array_wrapper_cpu)
-
-    if ts_data:
-        array_wrapper_ts = KsDataWrapper()
-        array_wrapper_ts.init(data_type=np.NPY_UINT64,
-                              data_size=size,
-                              item_size=0,
-                              data_ptr=<void *> ts_c)
-
-        ts = np.array(array_wrapper_ts, copy=False)
-        ts.base = <PyObject *> array_wrapper_ts
-        data_dict.update({'time': ts})
-        Py_INCREF(array_wrapper_ts)
-
-    if pid_data:
-        array_wrapper_pid = KsDataWrapper()
-        array_wrapper_pid.init(data_type=np.NPY_UINT16,
-                               data_size=size,
-                               item_size=0,
-                               data_ptr=<void *>pid_c)
-
-        pid = np.array(array_wrapper_pid, copy=False)
-        pid.base = <PyObject *> array_wrapper_pid
-        data_dict.update({'pid': pid})
-        Py_INCREF(array_wrapper_pid)
-
-    if evt_data:
-        array_wrapper_evt = KsDataWrapper()
-        array_wrapper_evt.init(data_type=np.NPY_INT,
-                               data_size=size,
-                               item_size=0,
-                               data_ptr=<void *>evt_c)
-
-        evt = np.array(array_wrapper_evt, copy=False)
-        evt.base = <PyObject *> array_wrapper_evt
-        data_dict.update({'event': evt})
-        Py_INCREF(array_wrapper_evt)
-
-    return data_dict
-
-def data_size(data):
-    """ Get the number of trace records.
-    """
-    if data['offset'] is not None:
-        return data['offset'].size
-
-    if data['cpu'] is not None:
-        return data['cpu'].size
-
-    if data['time'] is not None:
-        return data['time'].size
-
-    if data['pid'] is not None:
-        return data['pid'].size
-
-    if data['event'] is not None:
-        return data['event'].size
-
-    return 0
-
-def save_session(session, s):
-    """ Save a KernelShark session description of a JSON file.
-    """
-    s.seek(0)
-    json.dump(session, s, indent=4)
-    s.truncate()
-
-
-def new_session(fname, sname):
-    """ Generate and save a default KernelShark session description
-        file (JSON).
-    """
-    kspy_new_session_file(py_str2c(fname), py_str2c(sname))
-
-    with open(sname, 'r+') as s:
-        session = json.load(s)
-
-        session['Filters']['filter mask'] = 7
-        session['CPUPlots'] = []
-        session['TaskPlots'] = []
-        session['Splitter'] = [1, 1]
-        session['MainWindow'] = [1200, 800]
-        session['ViewTop'] = 0
-        session['ColorScheme'] = 0.75
-        session['Model']['bins'] = 1000
-
-        session['Markers']['markA'] = {}
-        session['Markers']['markA']['isSet'] = False
-        session['Markers']['markB'] = {}
-        session['Markers']['markB']['isSet'] = False
-        session['Markers']['Active'] = 'A'
-
-        save_session(session, s)
diff --git a/np_setup.py b/np_setup.py
deleted file mode 100755
index 40bb6fc..0000000
--- a/np_setup.py
+++ /dev/null
@@ -1,90 +0,0 @@
-#!/usr/bin/env python3
-
-"""
-SPDX-License-Identifier: LGPL-2.1
-
-Copyright 2019 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
-"""
-
-import sys
-import getopt
-
-from Cython.Distutils import build_ext
-from numpy.distutils.misc_util import Configuration
-from numpy.distutils.core import setup
-
-def lib_dirs(argv):
-    """ Function used to retrieve the library paths.
-    """
-    kslibdir = ''
-    evlibdir = ''
-    trlibdir = ''
-
-    try:
-        opts, args = getopt.getopt(
-            argv, 'k:t:e:', ['kslibdir=',
-                             'trlibdir=',
-                             'evlibdir='])
-
-    except getopt.GetoptError:
-        sys.exit(2)
-
-    for opt, arg in opts:
-        if opt in ('-k', '--kslibdir'):
-            kslibdir = arg
-        elif opt in ('-t', '--trlibdir'):
-            trlibdir = arg
-        elif opt in ('-e', '--evlibdir'):
-            evlibdir = arg
-
-    cmd1 = 1
-    for i in range(len(sys.argv)):
-        if sys.argv[i] == 'build_ext':
-            cmd1 = i
-
-    sys.argv = sys.argv[:1] + sys.argv[cmd1:]
-
-    if kslibdir == '':
-        kslibdir = '/usr/local/lib/kernelshark'
-
-    if evlibdir == '':
-        evlibdir = '/usr/local/lib/traceevent'
-
-    if trlibdir == '':
-        trlibdir = '/usr/local/lib/trace-cmd/'
-
-    return [kslibdir, evlibdir, trlibdir]
-
-
-def configuration(parent_package='',
-                  top_path=None,
-                  libs=['kshark', 'tracecmd', 'traceevent', 'json-c'],
-                  libdirs=['.']):
-    """ Function used to build configuration.
-    """
-    config = Configuration('', parent_package, top_path)
-    config.add_extension('ksharkpy',
-                         sources=['libkshark_wrapper.pyx'],
-                         libraries=libs,
-                         define_macros=[('KS_PLUGIN_DIR','\"' + libdirs[0] + '/plugins\"')],
-                         library_dirs=libdirs,
-                         depends=['libkshark-py.c'],
-                         include_dirs=libdirs)
-
-    return config
-
-
-def main(argv):
-    # Retrieve third-party libraries.
-    libdirs = lib_dirs(sys.argv[1:])
-
-    # Retrieve the parameters of the configuration.
-    params = configuration(libdirs=libdirs).todict()
-    params['cmdclass'] = dict(build_ext=build_ext)
-
-    ## Building the extension.
-    setup(**params)
-
-
-if __name__ == '__main__':
-    main(sys.argv[1:])
-- 
2.27.0

