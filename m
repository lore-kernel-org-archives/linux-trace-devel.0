Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pg0-f65.google.com ([74.125.83.65]:42848 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752324AbeBFItb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:31 -0500
Received: by mail-pg0-f65.google.com with SMTP id m28so824770pgc.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:31 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 12/24] trace-cmd: Fix the broken target ctracecmdgui.so
Date: Tue,  6 Feb 2018 10:48:54 +0200
Message-Id: <20180206084906.9854-13-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Currenly the ctracecmdgui.so target is broken beacause the object files
trace-view.o trace-view-store.o are not built with -fPIC. This patch just fixes
the kernel-shark/Makefile in order to those files to be built with -fPIC.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 kernel-shark/Makefile | 10 +++++++---
 scripts/utils.mk      | 10 +++++-----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel-shark/Makefile b/kernel-shark/Makefile
index 247f4d1..8e3ba8b 100644
--- a/kernel-shark/Makefile
+++ b/kernel-shark/Makefile
@@ -34,9 +34,11 @@ TRACE_GRAPH_MAIN_OBJS = trace-graph-main.o $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS)
 KERNEL_SHARK_OBJS = $(TRACE_VIEW_OBJS) $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS) \
 	trace-capture.o kernel-shark.o
 
-GUI_OBJS = $(KERNEL_SHARK_OBJS) $(TRACE_VIEW_MAIN_OBJS) $(TRACE_GRAPH_MAIN_OBJS)
+ALL_OBJS = $(KERNEL_SHARK_OBJS) $(TRACE_VIEW_MAIN_OBJS) $(TRACE_GRAPH_MAIN_OBJS)
+PIC_OBJS = $(TRACE_VIEW_OBJS)
 
-all_objs := $(sort $(GUI_OBJS))
+all_objs := $(sort $(ALL_OBJS))
+pic_objs = $(sort $(PIC_OBJS))
 all_deps := $(all_objs:%.o=.%.d)
 
 # Temporary HACK!
@@ -61,6 +63,8 @@ trace-view: $(TRACE_VIEW_MAIN_OBJS)
 trace-graph: $(TRACE_GRAPH_MAIN_OBJS)
 	$(Q)$(do_app_build)
 
+$(pic_objs): GENERATE_PIC := 1
+
 %.o: %.c
 	$(Q)$(call do_compile)
 
@@ -69,7 +73,7 @@ $(all_deps): .%.d: %.c
 
 $(all_deps): $(KS_VERSION)
 
-$(GUI_OBJS): %.o : .%.d
+$(all_objs): %.o : .%.d
 
 dep_includes := $(wildcard $(DEPS))
 
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 31fc9e9..043a68a 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -33,15 +33,15 @@ else
   print_install =		echo '  $(GUI)INSTALL     '$(GSPACE)$1'	to	$(DESTDIR_SQ)$2';
 endif
 
-
-do_compile =				\
-	($(print_compile)			\
-	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) $< -o $@)
-
 do_fpic_compile =					\
 	($(print_fpic_compile)				\
 	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) -fPIC $< -o $@)
 
+do_compile =							\
+	($(if $(GENERATE_PIC), $(do_fpic_compile),		\
+	 $(print_compile)					\
+	 $(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) $< -o $@))
+
 do_app_build =						\
 	($(print_app_build)				\
 	$(CC) $^ -rdynamic -o $@ $(LDFLAGS) $(CONFIG_LIBS) $(LIBS))
-- 
2.14.1
