Return-Path: <SRS0=5V0s=3G=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1324C33CB3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jan 2020 13:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99224206E6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jan 2020 13:55:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kpw4FlOq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgAQNzz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jan 2020 08:55:55 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:42455 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgAQNzz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 08:55:55 -0500
Received: by mail-lj1-f169.google.com with SMTP id y4so26552151ljj.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jan 2020 05:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W2RIk8YBJEBADt5h9PuMeDLfC/U5RAsMn4okHahcH8Y=;
        b=kpw4FlOqLbkqXuP0Q/RGbbjEqEeGx/rY34cjm+m+BRf3oqCUs4mkimvreG2V52KGYb
         A9OyVvBHgUMId+WiWQagi/hLlr47rcbU/pOHPx4LhfBu4Xsv6nGY/0amyI1Or2D9MniY
         Xp7XSkqsB7UM2W22vC7+myMmgI2tTTYon1mbSqTjXg2PzAM1uLj1Qqptl5KwDu4AJMGb
         5UPNOK7iPC/0qfZaWl/RmQaMoCpcUgI3dV67DnSzEg6ammoUbmc306TlfUwzM4Fhv5T8
         RCE0Z1qNy5c48km7Uy+g2otO2iljfvl41MnWTDr0RtsyyZIMi0nL9ecw8Y6UR+Ls2pn2
         SofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W2RIk8YBJEBADt5h9PuMeDLfC/U5RAsMn4okHahcH8Y=;
        b=hXiY7X4wAt388hV0m0ztaOm+A6p9bKuD1IBVuT+FqdL/FUry/Dsv2JRgMfaFOvj3CX
         IsMAEMA6WYP6xq6GWVCGvQW5vSuMDBC121C2MjVpmBP8ztoyNQAYTRhdtVHYswxatTBk
         48PEclxnGVPFSj4vfOVpUIJszwcWVZz6ot/NS6wzgSGSe/jT65gu9mlleI6hCSqv0y2P
         bI3oalntCwp2nw1dsDhcvCXEuN/sp/wKJW6BAUDjVtuxnO9SDHjujfv1Q8i6anE1UicF
         KaDLeXj1U88rDOuQfoD9dzG93lPqCs6SLUGUWuo3hs68i+dgaiR/lpnLjUqDwKMFDywu
         gwNQ==
X-Gm-Message-State: APjAAAVuqa4H3fc8PlJLzvjvDFh9ELISkdoPUbJAbP1642Y8wWXpjnKi
        0+BVwxamXjOrmFBrUi2WBXVlIbuT
X-Google-Smtp-Source: APXvYqzAD8x9XhsH44zzLNu8YOV0556AEEEjaA8MuwmtNZhOD3WyGNdAHm+26uAKh3C1MOMEPiKzog==
X-Received: by 2002:a2e:9e03:: with SMTP id e3mr5847134ljk.186.1579269348814;
        Fri, 17 Jan 2020 05:55:48 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 21sm12422562ljv.19.2020.01.17.05.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 05:55:48 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 1/5] trace-cmd,kernel-shark: Introduce libtracefs library
Date:   Fri, 17 Jan 2020 15:55:40 +0200
Message-Id: <20200117135544.598235-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117135544.598235-1-tz.stoyanov@gmail.com>
References: <20200117135544.598235-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add a skeleton for new library: libtracefs.
It provides APIs for accessing files from tracefs.
 - Added new directories
    lib/tracefs
    include/tracefs
 - Integrated the libtracefs build into the trace-cmd compilation
 - The library is installed by "make install_libs" in:
         libtrasefs.so in $(libdir)/tracefs
         trasefs.h in $(includedir)/tracefs
 - Added implementation of initial APIs:
    char *tracefs_get_tracing_file(const char *name);
    void tracefs_put_tracing_file(char *name);
    const char *tracefs_get_tracing_dir(void);
    char *tracefs_find_tracing_dir(void);

Link libtracefs to kernel-shark and use its API:
  tracefs_get_tracing_dir()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile                              |  27 +++-
 include/trace-cmd/trace-cmd.h         |   9 --
 include/tracefs/tracefs.h             |  20 +++
 kernel-shark/CMakeLists.txt           |   3 +-
 kernel-shark/build/FindTraceCmd.cmake |  30 +++++
 kernel-shark/src/CMakeLists.txt       |   2 +
 kernel-shark/src/KsCaptureDialog.cpp  |   4 +-
 kernel-shark/src/libkshark.h          |   1 +
 lib/trace-cmd/trace-output.c          |   3 +-
 lib/trace-cmd/trace-recorder.c        |   7 +-
 lib/trace-cmd/trace-util.c            | 136 -------------------
 lib/tracefs/Makefile                  |  46 +++++++
 lib/tracefs/include/tracefs-local.h   |  12 ++
 lib/tracefs/tracefs-utils.c           | 183 ++++++++++++++++++++++++++
 tracecmd/Makefile                     |   2 +-
 tracecmd/trace-check-events.c         |   3 +-
 tracecmd/trace-list.c                 |  19 +--
 tracecmd/trace-record.c               | 127 +++++++++---------
 tracecmd/trace-show.c                 |   5 +-
 tracecmd/trace-snapshot.c             |   9 +-
 tracecmd/trace-stack.c                |   9 +-
 tracecmd/trace-stat.c                 |  17 +--
 22 files changed, 427 insertions(+), 247 deletions(-)
 create mode 100644 include/tracefs/tracefs.h
 create mode 100644 lib/tracefs/Makefile
 create mode 100644 lib/tracefs/include/tracefs-local.h
 create mode 100644 lib/tracefs/tracefs-utils.c

diff --git a/Makefile b/Makefile
index 48d88e7..aa803ba 100644
--- a/Makefile
+++ b/Makefile
@@ -183,12 +183,19 @@ LIBTRACECMD_DIR = $(obj)/lib/trace-cmd
 LIBTRACECMD_STATIC = $(LIBTRACECMD_DIR)/libtracecmd.a
 LIBTRACECMD_SHARED = $(LIBTRACECMD_DIR)/libtracecmd.so
 
-TRACE_LIBS = -L$(LIBTRACECMD_DIR) -ltracecmd -L$(LIBTRACEEVENT_DIR) -ltraceevent
+LIBTRACEFS_DIR = $(obj)/lib/tracefs
+LIBTRACEFS_STATIC = $(LIBTRACEFS_DIR)/libtracefs.a
+LIBTRACEFS_SHARED = $(LIBTRACEFS_DIR)/libtracefs.so
+
+TRACE_LIBS = -L$(LIBTRACECMD_DIR) -ltracecmd		\
+	     -L$(LIBTRACEEVENT_DIR) -ltraceevent	\
+	     -L$(LIBTRACEFS_DIR) -ltracefs
 
 export LIBS TRACE_LIBS
 export LIBTRACEEVENT_DIR LIBTRACECMD_DIR
 export LIBTRACECMD_STATIC LIBTRACECMD_SHARED
 export LIBTRACEEVENT_STATIC LIBTRACEEVENT_SHARED
+export LIBTRACEFS_STATIC LIBTRACEFS_SHARED
 
 export Q SILENT VERBOSE EXT
 
@@ -198,8 +205,10 @@ include scripts/utils.mk
 INCLUDES = -I$(src)/include -I$(src)/../../include
 INCLUDES += -I$(src)/include/traceevent
 INCLUDES += -I$(src)/include/trace-cmd
+INCLUDES += -I$(src)/include/tracefs
 INCLUDES += -I$(src)/lib/traceevent/include
 INCLUDES += -I$(src)/lib/trace-cmd/include
+INCLUDES += -I$(src)/lib/tracefs/include
 INCLUDES += -I$(src)/tracecmd/include
 INCLUDES += -I$(obj)/tracecmd/include
 
@@ -277,7 +286,7 @@ gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
 	@echo "gui build complete"
 	@echo "  kernelshark located at $(kshark-dir)/bin"
 
-trace-cmd: force $(LIBTRACEEVENT_STATIC) $(LIBTRACECMD_STATIC)
+trace-cmd: force $(LIBTRACEEVENT_STATIC) $(LIBTRACECMD_STATIC) $(LIBTRACEFS_STATIC)
 	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
 
 $(LIBTRACEEVENT_SHARED): force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
@@ -292,12 +301,21 @@ $(LIBTRACECMD_STATIC): force
 $(LIBTRACECMD_SHARED): force
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd $@
 
+$(LIBTRACEFS_STATIC): force
+	$(Q)$(MAKE) -C $(src)/lib/tracefs $@
+
+$(LIBTRACEFS_SHARED): force
+	$(Q)$(MAKE) -C $(src)/lib/tracefs $@
+
+
 libtraceevent.so: $(LIBTRACEEVENT_SHARED)
 libtraceevent.a: $(LIBTRACEEVENT_STATIC)
 libtracecmd.a: $(LIBTRACECMD_STATIC)
 libtracecmd.so: $(LIBTRACECMD_SHARED)
+libtracefs.a: $(LIBTRACEFS_STATIC)
+libtracefs.so: $(LIBTRACEFS_SHARED)
 
-libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED)
+libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED) $(LIBTRACEFS_SHARED)
 
 plugins: force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir $(obj)/lib/traceevent/plugins/trace_python_dir
 	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins
@@ -353,10 +371,12 @@ install_gui: install_cmd gui
 install_libs: libs
 	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ)/trace-cmd)
 	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ)/traceevent)
+	$(Q)$(call do_install,$(LIBTRACEFS_SHARED),$(libdir_SQ)/tracefs)
 	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ)/traceevent)
 	$(Q)$(call do_install,$(src)/include/traceevent/trace-seq.h,$(includedir_SQ)/traceevent)
 	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
 	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-filter-hash.h,$(includedir_SQ)/trace-cmd)
+	$(Q)$(call do_install,$(src)/include/tracefs/tracefs.h,$(includedir_SQ)/tracefs)
 
 doc:
 	$(MAKE) -C $(src)/Documentation all
@@ -379,6 +399,7 @@ clean:
 	$(RM) tags TAGS cscope*
 	$(MAKE) -C $(src)/lib/traceevent clean
 	$(MAKE) -C $(src)/lib/trace-cmd clean
+	$(MAKE) -C $(src)/lib/tracefs clean
 	$(MAKE) -C $(src)/lib/traceevent/plugins clean
 	$(MAKE) -C $(src)/python clean
 	$(MAKE) -C $(src)/tracecmd clean
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 13afce7..66736ae 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -64,12 +64,6 @@ static inline int tracecmd_host_bigendian(void)
 	return *ptr == 0x01020304;
 }
 
-/* tracecmd_get_tracing_dir must *not* be freed */
-const char *tracecmd_get_tracing_dir(void);
-
-/* tracecmd_find_tracing_dir must be freed */
-char *tracecmd_find_tracing_dir(void);
-
 /* --- Opening and Reading the trace.dat file --- */
 
 enum {
@@ -208,9 +202,6 @@ tracecmd_get_show_data_func(struct tracecmd_input *handle);
 void tracecmd_set_show_data_func(struct tracecmd_input *handle,
 				 tracecmd_show_data_func func);
 
-char *tracecmd_get_tracing_file(const char *name);
-void tracecmd_put_tracing_file(char *name);
-
 int tracecmd_record_at_buffer_start(struct tracecmd_input *handle, struct tep_record *record);
 unsigned long long tracecmd_page_ts(struct tracecmd_input *handle,
 				    struct tep_record *record);
diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
new file mode 100644
index 0000000..e844c75
--- /dev/null
+++ b/include/tracefs/tracefs.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#ifndef _TRACE_FS_H
+#define _TRACE_FS_H
+
+#include "traceevent/event-parse.h"
+
+char *tracefs_get_tracing_file(const char *name);
+void tracefs_put_tracing_file(char *name);
+
+/* tracefs_get_tracing_dir must *not* be freed */
+const char *tracefs_get_tracing_dir(void);
+
+/* tracefs_find_tracing_dir must be freed */
+char *tracefs_find_tracing_dir(void);
+
+#endif /* _TRACE_FS_H */
diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 20478b9..8786b83 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -76,7 +76,8 @@ endif (CMAKE_BUILD_TYPE MATCHES Package)
 include_directories(${KS_DIR}/src/
                     ${KS_DIR}/build/src/
                     ${JSONC_INCLUDE_DIR}
-                    ${TRACECMD_INCLUDE_DIR})
+                    ${TRACECMD_INCLUDE_DIR}
+                    ${TRACEFS_INCLUDE_DIR})
 
 message("")
 message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
index d3e145c..f27fafe 100644
--- a/kernel-shark/build/FindTraceCmd.cmake
+++ b/kernel-shark/build/FindTraceCmd.cmake
@@ -6,6 +6,8 @@
 #  TRACEEVENT_FOUND, If false, do not try to use traceevent.
 #
 #  TRACECMD_INCLUDE_DIR, where to find trace-cmd header.
+#  TRACEFS_INCLUDE_DIR, where to find tracefs header.
+#  TRACEFS_LIBRARY, the tracefs library.
 #  TRACECMD_LIBRARY, the trace-cmd library.
 #  TRACECMD_FOUND, If false, do not try to use trace-cmd.
 
@@ -31,12 +33,21 @@ find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h
                                 PATHS  $ENV{TRACE_CMD}/include/
                                        ${CMAKE_SOURCE_DIR}/../include/
                                 NO_DEFAULT_PATH)
+find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h
+                                PATHS  $ENV{TRACE_CMD}/include/
+                                       ${CMAKE_SOURCE_DIR}/../include/
+                                NO_DEFAULT_PATH)
 
 find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.a
                                 PATHS  $ENV{TRACE_CMD}/lib/
                                        ${CMAKE_SOURCE_DIR}/../lib/
                                 NO_DEFAULT_PATH)
 
+find_library(TRACEFS_LIBRARY    NAMES  trace-cmd/libtracefs.a
+                                PATHS  $ENV{TRACE_CMD}/lib/
+                                       ${CMAKE_SOURCE_DIR}/../lib/
+                                NO_DEFAULT_PATH)
+
 find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.a
                                 PATHS  $ENV{TRACE_CMD}/lib/
                                        ${CMAKE_SOURCE_DIR}/../lib/
@@ -46,7 +57,9 @@ find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.a
 # search was successful "find_path" will do nothing this time.
 find_program(TRACECMD_EXECUTABLE   NAMES  trace-cmd)
 find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h)
+find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h)
 find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.so)
+find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.so)
 find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.so)
 
 IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
@@ -65,6 +78,23 @@ ELSE (TRACECMD_FOUND)
 
 ENDIF (TRACECMD_FOUND)
 
+IF (TRACEFS_INCLUDE_DIR AND TRACEFS_LIBRARY)
+
+  SET(TRACEFS_FOUND TRUE)
+
+ENDIF (TRACEFS_INCLUDE_DIR AND TRACEFS_LIBRARY)
+
+IF (TRACEFS_FOUND)
+
+  MESSAGE(STATUS "Found tracefs: ${TRACEFS_LIBRARY}")
+
+ELSE (TRACEFS_FOUND)
+
+  MESSAGE(FATAL_ERROR "\nCould not find tracefs!\n")
+
+ENDIF (TRACEFS_FOUND)
+
+
 IF (TRACEEVENT_LIBRARY)
 
   SET(TRACEEVENT_FOUND TRUE)
diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index e20a030..33b5db8 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -9,6 +9,7 @@ add_library(kshark SHARED libkshark.c
 
 target_link_libraries(kshark ${TRACEEVENT_LIBRARY}
                              ${TRACECMD_LIBRARY}
+                             ${TRACEFS_LIBRARY}
                              ${JSONC_LIBRARY}
                              ${CMAKE_DL_LIBS})
 
@@ -69,6 +70,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                                      Qt5::Network
                                      ${TRACEEVENT_LIBRARY}
                                      ${TRACECMD_LIBRARY}
+                                     ${TRACEFS_LIBRARY}
                                      ${CMAKE_DL_LIBS})
 
     set_target_properties(kshark-gui PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index ad05917..548b6fb 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -26,7 +26,7 @@ extern "C" {
 
 static inline tep_handle *local_events()
 {
-	return tracecmd_local_events(tracecmd_get_tracing_dir());
+	return tracecmd_local_events(tracefs_get_tracing_dir());
 }
 
 /**
@@ -204,7 +204,7 @@ QStringList KsCaptureControl::_getPlugins()
 	QStringList pluginList;
 	char **all_plugins;
 
-	all_plugins = tracecmd_local_plugins(tracecmd_get_tracing_dir());
+	all_plugins = tracecmd_local_plugins(tracefs_get_tracing_dir());
 
 	if (!all_plugins)
 		return pluginList;
diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
index 3407db1..b05aa90 100644
--- a/kernel-shark/src/libkshark.h
+++ b/kernel-shark/src/libkshark.h
@@ -28,6 +28,7 @@ extern "C" {
 #include "trace-cmd/trace-cmd.h"
 #include "trace-cmd/trace-filter-hash.h"
 #include "traceevent/event-parse.h"
+#include "tracefs/tracefs.h"
 
 // KernelShark
 #include "libkshark-plugin.h"
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index be4d3f5..a3dda27 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -20,6 +20,7 @@
 #include <errno.h>
 #include <glob.h>
 
+#include "tracefs.h"
 #include "trace-cmd-local.h"
 #include "list.h"
 #include "trace-msg.h"
@@ -238,7 +239,7 @@ static tsize_t copy_file(struct tracecmd_output *handle,
 static const char *find_tracing_dir(struct tracecmd_output *handle)
 {
 	if (!handle->tracing_dir)
-		handle->tracing_dir = tracecmd_find_tracing_dir();
+		handle->tracing_dir = tracefs_find_tracing_dir();
 
 	return handle->tracing_dir;
 }
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 36c9a96..2a6e2b6 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -12,6 +12,7 @@
 #include <unistd.h>
 #include <errno.h>
 
+#include "tracefs.h"
 #include "trace-cmd.h"
 #include "event-utils.h"
 
@@ -306,7 +307,7 @@ struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned
 {
 	const char *tracing;
 
-	tracing = tracecmd_get_tracing_dir();
+	tracing = tracefs_get_tracing_dir();
 	if (!tracing) {
 		errno = ENODEV;
 		return NULL;
@@ -319,7 +320,7 @@ struct tracecmd_recorder *tracecmd_create_recorder(const char *file, int cpu, un
 {
 	const char *tracing;
 
-	tracing = tracecmd_get_tracing_dir();
+	tracing = tracefs_get_tracing_dir();
 	if (!tracing) {
 		errno = ENODEV;
 		return NULL;
@@ -333,7 +334,7 @@ tracecmd_create_recorder_maxkb(const char *file, int cpu, unsigned flags, int ma
 {
 	const char *tracing;
 
-	tracing = tracecmd_get_tracing_dir();
+	tracing = tracefs_get_tracing_dir();
 	if (!tracing) {
 		errno = ENODEV;
 		return NULL;
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b5bb0d5..1394469 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -23,8 +23,6 @@
 #include "event-utils.h"
 
 #define LOCAL_PLUGIN_DIR ".trace-cmd/plugins"
-#define TRACEFS_PATH "/sys/kernel/tracing"
-#define DEBUGFS_PATH "/sys/kernel/debug"
 #define PROC_STACK_FILE "/proc/sys/kernel/stack_tracer_enabled"
 
 int tracecmd_disable_sys_plugins;
@@ -33,9 +31,6 @@ static bool debug;
 
 static FILE *logfp;
 
-#define _STR(x) #x
-#define STR(x) _STR(x)
-
 /**
  * tracecmd_set_debug - Set debug mode of the tracecmd library
  * @set_debug: The new "debug" mode. If true, the tracecmd library is
@@ -147,113 +142,6 @@ void tracecmd_parse_ftrace_printk(struct tep_handle *pevent,
 	}
 }
 
-static int mount_debugfs(void)
-{
-	struct stat st;
-	int ret;
-
-	/* make sure debugfs exists */
-	ret = stat(DEBUGFS_PATH, &st);
-	if (ret < 0)
-		return -1;
-
-	ret = mount("nodev", DEBUGFS_PATH,
-		    "debugfs", 0, NULL);
-
-	return ret;
-}
-
-static int mount_tracefs(void)
-{
-	struct stat st;
-	int ret;
-
-	/* make sure debugfs exists */
-	ret = stat(TRACEFS_PATH, &st);
-	if (ret < 0)
-		return -1;
-
-	ret = mount("nodev", TRACEFS_PATH,
-		    "tracefs", 0, NULL);
-
-	return ret;
-}
-
-char *tracecmd_find_tracing_dir(void)
-{
-	char *debug_str = NULL;
-	char fspath[PATH_MAX+1];
-	char *tracing_dir;
-	char type[100];
-	int use_debug = 0;
-	FILE *fp;
-
-	if ((fp = fopen("/proc/mounts","r")) == NULL) {
-		warning("Can't open /proc/mounts for read");
-		return NULL;
-	}
-
-	while (fscanf(fp, "%*s %"
-		      STR(PATH_MAX)
-		      "s %99s %*s %*d %*d\n",
-		      fspath, type) == 2) {
-		if (strcmp(type, "tracefs") == 0)
-			break;
-		if (!debug_str && strcmp(type, "debugfs") == 0) {
-			debug_str = strdup(fspath);
-			if (!debug_str) {
-				fclose(fp);
-				return NULL;
-			}
-		}
-	}
-	fclose(fp);
-
-	if (strcmp(type, "tracefs") != 0) {
-		if (mount_tracefs() < 0) {
-			if (debug_str) {
-				strncpy(fspath, debug_str, PATH_MAX);
-				fspath[PATH_MAX] = 0;
-			} else {
-				if (mount_debugfs() < 0) {
-					warning("debugfs not mounted, please mount");
-					free(debug_str);
-					return NULL;
-				}
-				strcpy(fspath, DEBUGFS_PATH);
-			}
-			use_debug = 1;
-		} else
-			strcpy(fspath, TRACEFS_PATH);
-	}
-	free(debug_str);
-
-	if (use_debug) {
-		int ret;
-
-		ret = asprintf(&tracing_dir, "%s/tracing", fspath);
-		if (ret < 0)
-			return NULL;
-	} else {
-		tracing_dir = strdup(fspath);
-		if (!tracing_dir)
-			return NULL;
-	}
-
-	return tracing_dir;
-}
-
-const char *tracecmd_get_tracing_dir(void)
-{
-	static const char *tracing_dir;
-
-	if (tracing_dir)
-		return tracing_dir;
-
-	tracing_dir = tracecmd_find_tracing_dir();
-	return tracing_dir;
-}
-
 /* FIXME: append_file() is duplicated and could be consolidated */
 static char *append_file(const char *dir, const char *name)
 {
@@ -863,30 +751,6 @@ void trace_util_free_plugin_files(char **files)
 	free(files);
 }
 
-char *tracecmd_get_tracing_file(const char *name)
-{
-	static const char *tracing;
-	char *file;
-	int ret;
-
-	if (!tracing) {
-		tracing = tracecmd_find_tracing_dir();
-		if (!tracing)
-			return NULL;
-	}
-
-	ret = asprintf(&file, "%s/%s", tracing, name);
-	if (ret < 0)
-		return NULL;
-
-	return file;
-}
-
-void tracecmd_put_tracing_file(char *name)
-{
-	free(name);
-}
-
 void __noreturn __vdie(const char *fmt, va_list ap)
 {
 	int ret = errno;
diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
new file mode 100644
index 0000000..86d7845
--- /dev/null
+++ b/lib/tracefs/Makefile
@@ -0,0 +1,46 @@
+
+
+include $(src)/scripts/utils.mk
+
+bdir:=$(obj)/lib/tracefs
+
+DEFAULT_TARGET = $(bdir)/libtracefs.a
+
+OBJS =
+OBJS += tracefs-utils.o
+
+OBJS := $(OBJS:%.o=$(bdir)/%.o)
+DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
+
+all: $(DEFAULT_TARGET)
+
+$(bdir):
+	@mkdir -p $(bdir)
+
+$(OBJS): | $(bdir)
+$(DEPS): | $(bdir)
+
+$(bdir)/libtracefs.a: $(OBJS)
+	$(Q)$(call do_build_static_lib)
+
+$(bdir)/libtracefs.so: $(OBJS)
+	$(Q)$(call do_compile_shared_library)
+
+$(bdir)/%.o: %.c
+	$(Q)$(call do_fpic_compile)
+
+$(DEPS): $(bdir)/.%.d: %.c
+	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
+
+$(OBJS): $(bdir)/%.o : $(bdir)/.%.d
+
+dep_includes := $(wildcard $(DEPS))
+
+ifneq ($(dep_includes),)
+  include $(dep_includes)
+endif
+
+clean:
+	$(RM) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d
+
+.PHONY: clean
diff --git a/lib/tracefs/include/tracefs-local.h b/lib/tracefs/include/tracefs-local.h
new file mode 100644
index 0000000..231edd1
--- /dev/null
+++ b/lib/tracefs/include/tracefs-local.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#ifndef _TRACE_FS_LOCAL_H
+#define _TRACE_FS_LOCAL_H
+
+/* Can be overridden */
+void warning(const char *fmt, ...);
+
+#endif /* _TRACE_FS_LOCAL_H */
diff --git a/lib/tracefs/tracefs-utils.c b/lib/tracefs/tracefs-utils.c
new file mode 100644
index 0000000..0ef16fc
--- /dev/null
+++ b/lib/tracefs/tracefs-utils.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * Updates:
+ * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdlib.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <linux/limits.h>
+
+#include "tracefs.h"
+
+#define TRACEFS_PATH "/sys/kernel/tracing"
+#define DEBUGFS_PATH "/sys/kernel/debug"
+
+#define _STR(x) #x
+#define STR(x) _STR(x)
+
+void __attribute__((weak)) warning(const char *fmt, ...)
+{
+}
+
+static int mount_tracefs(void)
+{
+	struct stat st;
+	int ret;
+
+	/* make sure debugfs exists */
+	ret = stat(TRACEFS_PATH, &st);
+	if (ret < 0)
+		return -1;
+
+	ret = mount("nodev", TRACEFS_PATH,
+		    "tracefs", 0, NULL);
+
+	return ret;
+}
+
+static int mount_debugfs(void)
+{
+	struct stat st;
+	int ret;
+
+	/* make sure debugfs exists */
+	ret = stat(DEBUGFS_PATH, &st);
+	if (ret < 0)
+		return -1;
+
+	ret = mount("nodev", DEBUGFS_PATH,
+		    "debugfs", 0, NULL);
+
+	return ret;
+}
+
+/**
+ * tracefs_find_tracing_dir - Find tracing directory
+ *
+ * Returns string containing the full path to the system's tracing directory.
+ * The string must be freed by free()
+ */
+char *tracefs_find_tracing_dir(void)
+{
+	char *debug_str = NULL;
+	char fspath[PATH_MAX+1];
+	char *tracing_dir;
+	char type[100];
+	int use_debug = 0;
+	FILE *fp;
+
+	fp = fopen("/proc/mounts", "r");
+	if (!fp) {
+		warning("Can't open /proc/mounts for read");
+		return NULL;
+	}
+
+	while (fscanf(fp, "%*s %"
+		      STR(PATH_MAX)
+		      "s %99s %*s %*d %*d\n",
+		      fspath, type) == 2) {
+		if (strcmp(type, "tracefs") == 0)
+			break;
+		if (!debug_str && strcmp(type, "debugfs") == 0) {
+			debug_str = strdup(fspath);
+			if (!debug_str) {
+				fclose(fp);
+				return NULL;
+			}
+		}
+	}
+	fclose(fp);
+
+	if (strcmp(type, "tracefs") != 0) {
+		if (mount_tracefs() < 0) {
+			if (debug_str) {
+				strncpy(fspath, debug_str, PATH_MAX);
+				fspath[PATH_MAX] = 0;
+			} else {
+				if (mount_debugfs() < 0) {
+					warning("debugfs not mounted, please mount");
+					free(debug_str);
+					return NULL;
+				}
+				strcpy(fspath, DEBUGFS_PATH);
+			}
+			use_debug = 1;
+		} else
+			strcpy(fspath, TRACEFS_PATH);
+	}
+	free(debug_str);
+
+	if (use_debug) {
+		int ret;
+
+		ret = asprintf(&tracing_dir, "%s/tracing", fspath);
+		if (ret < 0)
+			return NULL;
+	} else {
+		tracing_dir = strdup(fspath);
+		if (!tracing_dir)
+			return NULL;
+	}
+
+	return tracing_dir;
+}
+
+/**
+ * tracefs_get_tracing_dir - Get tracing directory
+ *
+ * Returns string containing the full path to the system's tracing directory.
+ * Must use tracefs_put_tracing_file() to free the returned string.
+ */
+const char *tracefs_get_tracing_dir(void)
+{
+	static const char *tracing_dir;
+
+	if (tracing_dir)
+		return tracing_dir;
+
+	tracing_dir = tracefs_find_tracing_dir();
+	return tracing_dir;
+}
+
+/**
+ * tracefs_get_tracing_file - Get tracing file
+ * @name: tracing file name
+ *
+ * Returns string containing the full path to a tracing file in
+ * the system's tracing directory.
+ *
+ * Must use tracefs_put_tracing_file() to free the returned string.
+ */
+char *tracefs_get_tracing_file(const char *name)
+{
+	static const char *tracing;
+	char *file;
+	int ret;
+
+	if (!tracing) {
+		tracing = tracefs_find_tracing_dir();
+		if (!tracing)
+			return NULL;
+	}
+
+	ret = asprintf(&file, "%s/%s", tracing, name);
+	if (ret < 0)
+		return NULL;
+
+	return file;
+}
+
+/**
+ * tracefs_put_tracing_file - Free tracing file or directory name
+ *
+ * Frees tracing file or directory, returned by
+ * tracefs_get_tracing_file() or tracefs_get_tracing_dir() APIs
+ */
+void tracefs_put_tracing_file(char *name)
+{
+	free(name);
+}
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 29a623b..d00d8e0 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -62,7 +62,7 @@ $(all_objs): | $(bdir)
 $(bdir)/trace-cmd: $(ALL_OBJS)
 	$(Q)$(do_app_build)
 
-$(bdir)/trace-cmd: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC)
+$(bdir)/trace-cmd: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC) $(LIBTRACEFS_STATIC)
 
 $(bdir)/%.o: %.c
 	$(Q)$(call do_compile)
diff --git a/tracecmd/trace-check-events.c b/tracecmd/trace-check-events.c
index b09fcd0..a8ee60a 100644
--- a/tracecmd/trace-check-events.c
+++ b/tracecmd/trace-check-events.c
@@ -7,6 +7,7 @@
 #include <getopt.h>
 #include <errno.h>
 
+#include "tracefs.h"
 #include "trace-local.h"
 
 void trace_check_events(int argc, char **argv)
@@ -28,7 +29,7 @@ void trace_check_events(int argc, char **argv)
 			break;
 		}
 	}
-	tracing = tracecmd_get_tracing_dir();
+	tracing = tracefs_get_tracing_dir();
 
 	if (!tracing) {
 		printf("Can not find or mount tracing directory!\n"
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 65099a5..86e3358 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -6,6 +6,7 @@
 
 #include <stdlib.h>
 
+#include "tracefs.h"
 #include "trace-local.h"
 
 
@@ -35,7 +36,7 @@ void show_instance_file(struct buffer_instance *instance, const char *name)
 
 	path = get_instance_file(instance, name);
 	dump_file_content(path);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 }
 
 enum {
@@ -49,9 +50,9 @@ void show_file(const char *name)
 {
 	char *path;
 
-	path = tracecmd_get_tracing_file(name);
+	path = tracefs_get_tracing_file(name);
 	dump_file_content(path);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 }
 
 typedef int (*process_file_func)(char *buf, int len);
@@ -86,11 +87,11 @@ static void process_file_re(process_file_func func,
 
 	free(str);
 
-	path = tracecmd_get_tracing_file(name);
+	path = tracefs_get_tracing_file(name);
 	fp = fopen(path, "r");
 	if (!fp)
 		die("reading %s", path);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	do {
 		n = getline(&buf, &l, fp);
@@ -132,12 +133,12 @@ static char *get_event_file(const char *type, char *buf, int len)
 	if (!event)
 		die("no event found in %s\n", buf);
 
-	path = tracecmd_get_tracing_file("events");
+	path = tracefs_get_tracing_file("events");
 	ret = asprintf(&file, "%s/%s/%s/%s", path, system, event, type);
 	if (ret < 0)
 		die("Failed to allocate event file %s %s", system, event);
 
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	return file;
 }
@@ -282,9 +283,9 @@ static void show_buffers(void)
 	char *path;
 	int printed = 0;
 
-	path = tracecmd_get_tracing_file("instances");
+	path = tracefs_get_tracing_file("instances");
 	dir = opendir(path);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	if (!dir)
 		die("Can not read instance directory");
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 80b2234..5355813 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -39,6 +39,7 @@
 #include <linux/vm_sockets.h>
 #endif
 
+#include "tracefs.h"
 #include "version.h"
 #include "trace-local.h"
 #include "trace-msg.h"
@@ -337,21 +338,21 @@ static void test_set_event_pid(void)
 	if (tested)
 		return;
 
-	path = tracecmd_get_tracing_file("set_event_pid");
+	path = tracefs_get_tracing_file("set_event_pid");
 	ret = stat(path, &st);
 	if (!ret) {
 		have_set_event_pid = 1;
 		reset_save_file(path, RESET_DEFAULT_PRIO);
 	}
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
-	path = tracecmd_get_tracing_file("options/event-fork");
+	path = tracefs_get_tracing_file("options/event-fork");
 	ret = stat(path, &st);
 	if (!ret) {
 		have_event_fork = 1;
 		reset_save_file(path, RESET_DEFAULT_PRIO);
 	}
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	tested = 1;
 }
@@ -442,13 +443,13 @@ static int __add_all_instances(const char *tracing_dir)
  */
 void add_all_instances(void)
 {
-	char *tracing_dir = tracecmd_find_tracing_dir();
+	char *tracing_dir = tracefs_find_tracing_dir();
 	if (!tracing_dir)
 		die("malloc");
 
 	__add_all_instances(tracing_dir);
 
-	tracecmd_put_tracing_file(tracing_dir);
+	tracefs_put_tracing_file(tracing_dir);
 }
 
 /**
@@ -474,7 +475,7 @@ void tracecmd_stat_cpu_instance(struct buffer_instance *instance,
 	path = get_instance_file(instance, file);
 	free(file);
 	fd = open(path, O_RDONLY);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	if (fd < 0)
 		return;
 
@@ -772,9 +773,9 @@ static int set_ftrace(int set, int use_proc)
 	int ret;
 
 	/* First check if the function-trace option exists */
-	path = tracecmd_get_tracing_file("options/function-trace");
+	path = tracefs_get_tracing_file("options/function-trace");
 	ret = set_ftrace_enable(path, set);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	/* Always enable ftrace_enable proc file when set is true */
 	if (ret < 0 || set || use_proc)
@@ -790,7 +791,7 @@ static int set_ftrace(int set, int use_proc)
  *
  * Returns the path name of the @file for the given @instance.
  *
- * Must use tracecmd_put_tracing_file() to free the returned string.
+ * Must use tracefs_put_tracing_file() to free the returned string.
  */
 char *
 get_instance_file(struct buffer_instance *instance, const char *file)
@@ -803,10 +804,10 @@ get_instance_file(struct buffer_instance *instance, const char *file)
 		ret = asprintf(&buf, "instances/%s/%s", instance->name, file);
 		if (ret < 0)
 			die("Failed to allocate name for %s/%s", instance->name, file);
-		path = tracecmd_get_tracing_file(buf);
+		path = tracefs_get_tracing_file(buf);
 		free(buf);
 	} else
-		path = tracecmd_get_tracing_file(file);
+		path = tracefs_get_tracing_file(file);
 
 	return path;
 }
@@ -825,7 +826,7 @@ get_instance_dir(struct buffer_instance *instance)
 	ret = asprintf(&buf, "instances/%s", instance->name);
 	if (ret < 0)
 		die("Failed to allocate for instance %s", instance->name);
-	path = tracecmd_get_tracing_file(buf);
+	path = tracefs_get_tracing_file(buf);
 	free(buf);
 
 	return path;
@@ -868,7 +869,7 @@ write_instance_file(struct buffer_instance *instance,
 	ret = stat(path, &st);
 	if (ret == 0)
 		ret = write_file(path, str, type);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	return ret;
 }
@@ -886,7 +887,7 @@ static void __clear_trace(struct buffer_instance *instance)
 	fp = fopen(path, "w");
 	if (!fp)
 		die("writing to '%s'", path);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	fwrite("0", 1, 1, fp);
 	fclose(fp);
 }
@@ -905,11 +906,11 @@ static void clear_trace(void)
 	char *path;
 
 	/* reset the trace */
-	path = tracecmd_get_tracing_file("trace");
+	path = tracefs_get_tracing_file("trace");
 	fp = fopen(path, "w");
 	if (!fp)
 		die("writing to '%s'", path);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	fwrite("0", 1, 1, fp);
 	fclose(fp);
 }
@@ -956,7 +957,7 @@ static void update_ftrace_pid(const char *pid, int reset)
 		if (fd >= 0)
 			close(fd);
 		if (path)
-			tracecmd_put_tracing_file(path);
+			tracefs_put_tracing_file(path);
 		fd = -1;
 		path = NULL;
 		return;
@@ -970,7 +971,7 @@ static void update_ftrace_pid(const char *pid, int reset)
 
 	if (fd < 0) {
 		if (!path)
-			path = tracecmd_get_tracing_file("set_ftrace_pid");
+			path = tracefs_get_tracing_file("set_ftrace_pid");
 		if (!path)
 			return;
 		ret = stat(path, &st);
@@ -1601,12 +1602,12 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 		 * plugin for those if name is "nop".
 		 */
 		if (!strncmp(name, "nop", 3)) {
-			tracecmd_put_tracing_file(path);
+			tracefs_put_tracing_file(path);
 			return;
 		}
 		die("writing to '%s'", path);
 	}
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	fwrite(name, 1, strlen(name), fp);
 	fclose(fp);
@@ -1619,11 +1620,11 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 	path = get_instance_file(instance, "options/func_stack_trace");
 	fp = fopen(path, "w");
 	if (!fp) {
-		tracecmd_put_tracing_file(path);
-		path = tracecmd_get_tracing_file("options/func_stack_trace");
+		tracefs_put_tracing_file(path);
+		path = tracefs_get_tracing_file("options/func_stack_trace");
 		fp = fopen(path, "w");
 		if (!fp) {
-			tracecmd_put_tracing_file(path);
+			tracefs_put_tracing_file(path);
 			return;
 		}
 	}
@@ -1632,7 +1633,7 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 	 * the original content.
 	 */
 	add_reset_file(path, "0", RESET_HIGH_PRIO);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	fwrite(&zero, 1, 1, fp);
 	fclose(fp);
 }
@@ -1662,11 +1663,11 @@ static int set_option(const char *option)
 	FILE *fp;
 	char *path;
 
-	path = tracecmd_get_tracing_file("trace_options");
+	path = tracefs_get_tracing_file("trace_options");
 	fp = fopen(path, "w");
 	if (!fp)
 		warning("writing to '%s'", path);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	if (!fp)
 		return -1;
@@ -1693,7 +1694,7 @@ static void disable_func_stack_trace_instance(struct buffer_instance *instance)
 
 	path = get_instance_file(instance, "current_tracer");
 	ret = stat(path, &st);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	if (ret < 0)
 		return;
 
@@ -1727,7 +1728,7 @@ static void add_reset_options(void)
 	if (keep)
 		return;
 
-	path = tracecmd_get_tracing_file("trace_options");
+	path = tracefs_get_tracing_file("trace_options");
 	content = get_file_content(path);
 
 	for (opt = options; opt; opt = opt->next) {
@@ -1790,7 +1791,7 @@ static void add_reset_options(void)
 
 		add_reset_file(path, option, RESET_DEFAULT_PRIO);
 	}
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	free(content);
 }
 
@@ -1819,14 +1820,14 @@ static void set_saved_cmdlines_size(struct common_record_context *ctx)
 	if (!ctx->saved_cmdlines_size)
 		return;
 
-	path = tracecmd_get_tracing_file("saved_cmdlines_size");
+	path = tracefs_get_tracing_file("saved_cmdlines_size");
 	if (!path)
 		goto err;
 
 	reset_save_file(path, RESET_DEFAULT_PRIO);
 
 	fd = open(path, O_WRONLY);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	if (fd < 0)
 		goto err;
 
@@ -1852,7 +1853,7 @@ static int trace_check_file_exists(struct buffer_instance *instance, char *file)
 
 	path = get_instance_file(instance, file);
 	ret = stat(path, &st);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	return ret < 0 ? 0 : 1;
 }
@@ -1884,11 +1885,11 @@ static void old_update_events(const char *name, char update)
 		name = "*:*";
 
 	/* need to use old way */
-	path = tracecmd_get_tracing_file("set_event");
+	path = tracefs_get_tracing_file("set_event");
 	fp = fopen(path, "w");
 	if (!fp)
 		die("opening '%s'", path);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	/* Disable the event with "!" */
 	if (update == '0')
@@ -1935,12 +1936,12 @@ reset_events_instance(struct buffer_instance *instance)
 		die("opening to '%s'", path);
 	ret = write(fd, &c, 1);
 	close(fd);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	path = get_instance_file(instance, "events/*/filter");
 	globbuf.gl_offs = 0;
 	ret = glob(path, 0, NULL, &globbuf);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	if (ret < 0)
 		return;
 
@@ -2182,9 +2183,9 @@ static void check_tracing_enabled(void)
 	char *path;
 
 	if (fd < 0) {
-		path = tracecmd_get_tracing_file("tracing_enabled");
+		path = tracefs_get_tracing_file("tracing_enabled");
 		fd = open(path, O_WRONLY | O_CLOEXEC);
-		tracecmd_put_tracing_file(path);
+		tracefs_put_tracing_file(path);
 
 		if (fd < 0)
 			return;
@@ -2205,7 +2206,7 @@ static int open_instance_fd(struct buffer_instance *instance,
 		if (is_top_instance(instance))
 			die("opening '%s'", path);
 	}
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	return fd;
 }
@@ -2526,7 +2527,7 @@ static void set_mask(struct buffer_instance *instance)
 
 	close(fd);
  out:
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	free(instance->cpumask);
 	instance->cpumask = NULL;
 }
@@ -2583,7 +2584,7 @@ static void set_clock(struct buffer_instance *instance)
 	add_reset_file(path, str, RESET_DEFAULT_PRIO);
 
 	free(content);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	write_instance_file(instance, "trace_clock", instance->clock, "clock");
 }
@@ -2598,7 +2599,7 @@ static void set_max_graph_depth(struct buffer_instance *instance, char *max_grap
 
 	path = get_instance_file(instance, "max_graph_depth");
 	reset_save_file(path, RESET_DEFAULT_PRIO);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	ret = write_instance_file(instance, "max_graph_depth", max_graph_depth,
 				  NULL);
 	if (ret < 0)
@@ -2721,7 +2722,7 @@ static int expand_event_files(struct buffer_instance *instance,
 
 	globbuf.gl_offs = 0;
 	ret = glob(path, 0, NULL, &globbuf);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	free(p);
 
 	if (ret < 0)
@@ -3182,7 +3183,7 @@ create_recorder_instance_pipe(struct buffer_instance *instance,
 	if (instance->name)
 		path = get_instance_dir(instance);
 	else
-		path = tracecmd_find_tracing_dir();
+		path = tracefs_find_tracing_dir();
 
 	if (!path)
 		die("malloc");
@@ -3193,7 +3194,7 @@ create_recorder_instance_pipe(struct buffer_instance *instance,
 	recorder = tracecmd_create_buffer_recorder_fd(brass[1], cpu, flags, path);
 
 	if (instance->name)
-		tracecmd_put_tracing_file(path);
+		tracefs_put_tracing_file(path);
 
 	return recorder;
 }
@@ -3234,7 +3235,7 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 
 	record = tracecmd_create_buffer_recorder_maxkb(file, cpu, recorder_flags,
 						       path, max_kb);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	return record;
 }
@@ -3287,9 +3288,9 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 		if (instance->name && !is_agent(instance))
 			path = get_instance_dir(instance);
 		else
-			path = tracecmd_find_tracing_dir();
+			path = tracefs_find_tracing_dir();
 		recorder = tracecmd_create_buffer_recorder_fd(fd, cpu, flags, path);
-		tracecmd_put_tracing_file(path);
+		tracefs_put_tracing_file(path);
 	} else {
 		file = get_temp_file(instance, cpu);
 		recorder = create_recorder_instance(instance, file, cpu, brass);
@@ -4124,7 +4125,7 @@ static int write_func_file(struct buffer_instance *instance,
 	close(fd);
 	ret = 0;
  free:
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	return ret;
  failed:
 	die("Failed to write %s to %s.\n"
@@ -4142,7 +4143,7 @@ static int functions_filtered(struct buffer_instance *instance)
 
 	path = get_instance_file(instance, "set_ftrace_filter");
 	fd = open(path, O_RDONLY);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	if (fd < 0) {
 		if (is_top_instance(instance))
 			warning("Can not set set_ftrace_filter");
@@ -4265,7 +4266,7 @@ static unsigned long long find_time_stamp(struct tep_handle *pevent)
 	int fd;
 	int r;
 
-	path = tracecmd_get_tracing_file("per_cpu");
+	path = tracefs_get_tracing_file("per_cpu");
 	if (!path)
 		return 0;
 
@@ -4304,7 +4305,7 @@ static unsigned long long find_time_stamp(struct tep_handle *pevent)
 	closedir(dir);
 
  out:
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	return ts;
 }
 
@@ -4319,7 +4320,7 @@ static char *read_instance_file(struct buffer_instance *instance, char *file, in
 
 	path = get_instance_file(instance, file);
 	fd = open(path, O_RDONLY);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	if (fd < 0) {
 		warning("%s not found, --date ignored", file);
 		return NULL;
@@ -4400,9 +4401,9 @@ static char *get_date_to_ts(void)
 		goto out_pevent;
 	}
 
-	path = tracecmd_get_tracing_file("trace_marker");
+	path = tracefs_get_tracing_file("trace_marker");
 	tfd = open(path, O_WRONLY);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	if (tfd < 0) {
 		warning("Can not open 'trace_marker', --date ignored");
 		goto out_pevent;
@@ -4491,7 +4492,7 @@ static void set_buffer_size_instance(struct buffer_instance *instance)
 		warning("Can't write to %s", path);
 	close(fd);
  out:
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 }
 
 void set_buffer_size(void)
@@ -4560,7 +4561,7 @@ static void clear_instance_triggers(struct buffer_instance *instance)
 
 	trace_event_iter_free(iter);
 
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 }
 
 static void
@@ -4621,7 +4622,7 @@ static void clear_instance_filters(struct buffer_instance *instance)
 
 	trace_event_iter_free(iter);
 
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 }
 
 static void clear_filters(void)
@@ -4687,7 +4688,7 @@ static void clear_func_filters(void)
 		for (i = 0; files[i]; i++) {
 			path = get_instance_file(instance, files[i]);
 			clear_func_filter(path);
-			tracecmd_put_tracing_file(path);
+			tracefs_put_tracing_file(path);
 		}
 	}
 }
@@ -4712,7 +4713,7 @@ static void make_instances(void)
 		} else
 			/* Don't delete instances that already exist */
 			instance->flags |= BUFFER_FL_KEEP;
-		tracecmd_put_tracing_file(path);
+		tracefs_put_tracing_file(path);
 	}
 }
 
@@ -4734,7 +4735,7 @@ void tracecmd_remove_instances(void)
 		ret = rmdir(path);
 		if (ret < 0)
 			die("rmdir %s", path);
-		tracecmd_put_tracing_file(path);
+		tracefs_put_tracing_file(path);
 	}
 }
 
@@ -5043,7 +5044,7 @@ static int test_stacktrace_trigger(struct buffer_instance *instance)
 		ret = 1;
 	close(fd);
  out:
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	return ret;
 }
diff --git a/tracecmd/trace-show.c b/tracecmd/trace-show.c
index 96bfe77..391d329 100644
--- a/tracecmd/trace-show.c
+++ b/tracecmd/trace-show.c
@@ -7,6 +7,7 @@
 #include <getopt.h>
 #include <errno.h>
 
+#include "tracefs.h"
 #include "trace-local.h"
 
 enum {
@@ -157,9 +158,9 @@ void trace_show(int argc, char **argv)
 
 	if (show_name) {
 		char *name;
-		name = tracecmd_get_tracing_file(file);
+		name = tracefs_get_tracing_file(file);
 		printf("%s\n", name);
-		tracecmd_put_tracing_file(name);
+		tracefs_put_tracing_file(name);
 	}
 	show_file(file);
 	if (buffer)
diff --git a/tracecmd/trace-snapshot.c b/tracecmd/trace-snapshot.c
index a9a512a..34630b4 100644
--- a/tracecmd/trace-snapshot.c
+++ b/tracecmd/trace-snapshot.c
@@ -12,6 +12,7 @@
 #include <fcntl.h>
 #include <unistd.h>
 
+#include "tracefs.h"
 #include "trace-local.h"
 
 static void write_file(const char *name, char *val)
@@ -20,7 +21,7 @@ static void write_file(const char *name, char *val)
 	int fd;
 	ssize_t n;
 
-	path = tracecmd_get_tracing_file(name);
+	path = tracefs_get_tracing_file(name);
 	fd = open(path, O_WRONLY);
 	if (fd < 0)
 		die("writing %s", path);
@@ -29,7 +30,7 @@ static void write_file(const char *name, char *val)
 	if (n < 0)
 		die("failed to write to %s\n", path);
 
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	close(fd);
 }
 
@@ -91,11 +92,11 @@ void trace_snapshot (int argc, char **argv)
 		file = cpu_path;
 	}
 
-	name = tracecmd_get_tracing_file(file);
+	name = tracefs_get_tracing_file(file);
 	ret = stat(name, &st);
 	if (ret < 0)
 		die("Snapshot feature is not supported by this kernel");
-	tracecmd_put_tracing_file(name);
+	tracefs_put_tracing_file(name);
 
 	if (!reset_snap && !take_snap && !free_snap) {
 		show_file(file);
diff --git a/tracecmd/trace-stack.c b/tracecmd/trace-stack.c
index bb002c0..5e88b36 100644
--- a/tracecmd/trace-stack.c
+++ b/tracecmd/trace-stack.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 #include <errno.h>
 
+#include "tracefs.h"
 #include "trace-local.h"
 
 #define PROC_FILE "/proc/sys/kernel/stack_tracer_enabled"
@@ -86,7 +87,7 @@ static void reset_trace(void)
 	int fd;
 	int n;
 
-	path = tracecmd_get_tracing_file("stack_max_size");
+	path = tracefs_get_tracing_file("stack_max_size");
 	fd = open(path, O_WRONLY);
 	if (fd < 0)
 		die("writing %s", path);
@@ -95,7 +96,7 @@ static void reset_trace(void)
 	n = write(fd, buf, 1);
 	if (n < 0)
 		die("writing into %s", path);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 	close(fd);
 }
 
@@ -116,11 +117,11 @@ static void read_trace(void)
 	else
 		printf("(stack tracer not running)\n");
 
-	path = tracecmd_get_tracing_file("stack_trace");
+	path = tracefs_get_tracing_file("stack_trace");
 	fp = fopen(path, "r");
 	if (!fp)
 		die("reading to '%s'", path);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	while ((r = getline(&buf, &n, fp)) >= 0) {
 		/*
diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 538f4ad..7a1d9bb 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -13,6 +13,7 @@
 #include <fcntl.h>
 #include <ctype.h>
 
+#include "tracefs.h"
 #include "trace-local.h"
 
 #ifndef BUFSIZ
@@ -32,7 +33,7 @@ static int get_instance_file_fd(struct buffer_instance *instance,
 
 	path = get_instance_file(instance, file);
 	fd = open(path, O_RDONLY);
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	return fd;
 }
@@ -383,7 +384,7 @@ static void report_events(struct buffer_instance *instance)
 	if (!processed && !processed_part)
 		printf("  (none enabled)\n");
 
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 }
 
 static void
@@ -456,7 +457,7 @@ static void report_event_filters(struct buffer_instance *instance)
 
 	trace_event_iter_free(iter);
 
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 }
 
 static void
@@ -529,7 +530,7 @@ static void report_event_triggers(struct buffer_instance *instance)
 
 	trace_event_iter_free(iter);
 
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 }
 
 enum func_states {
@@ -604,7 +605,7 @@ static void report_graph_funcs(struct buffer_instance *instance)
 
 	list_functions(path, "Function Graph Filter");
 	
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	path = get_instance_file(instance, "set_graph_notrace");
 	if (!path)
@@ -612,7 +613,7 @@ static void report_graph_funcs(struct buffer_instance *instance)
 
 	list_functions(path, "Function Graph No Trace");
 	
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 }
 
 static void report_ftrace_filters(struct buffer_instance *instance)
@@ -625,7 +626,7 @@ static void report_ftrace_filters(struct buffer_instance *instance)
 
 	list_functions(path, "Function Filter");
 	
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	path = get_instance_file(instance, "set_ftrace_notrace");
 	if (!path)
@@ -633,7 +634,7 @@ static void report_ftrace_filters(struct buffer_instance *instance)
 
 	list_functions(path, "Function No Trace");
 	
-	tracecmd_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 }
 
 static void report_buffers(struct buffer_instance *instance)
-- 
2.24.1

