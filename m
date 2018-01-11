Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35903 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964776AbeAKQPa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Jan 2018 11:15:30 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 13/18] trace-cmd: Move python-related files in python/
Date: Thu, 11 Jan 2018 18:15:11 +0200
Message-Id: <20180111161511.10549-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch moves all the files related with trace-cmd's python support to a
dedicated directory, as part of a bigger restructuring plan of trace-cmd's code
base. The build system has been updated to support this new directory structure
by adding a separate Makefile in python/ and by making the parent Makefile to
invoke it.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile                                  | 42 +++++++++----------------------
 python/Makefile                           | 40 +++++++++++++++++++++++++++++
 ctracecmd.i => python/ctracecmd.i         |  0
 ctracecmdgui.i => python/ctracecmdgui.i   |  0
 event-viewer.py => python/event-viewer.py |  0
 tracecmd.py => python/tracecmd.py         |  0
 tracecmdgui.py => python/tracecmdgui.py   |  0
 7 files changed, 52 insertions(+), 30 deletions(-)
 create mode 100644 python/Makefile
 rename ctracecmd.i => python/ctracecmd.i (100%)
 rename ctracecmdgui.i => python/ctracecmdgui.i (100%)
 rename event-viewer.py => python/event-viewer.py (100%)
 rename tracecmd.py => python/tracecmd.py (100%)
 rename tracecmdgui.py => python/tracecmdgui.py (100%)

diff --git a/Makefile b/Makefile
index 7a8ca84..8e3d787 100644
--- a/Makefile
+++ b/Makefile
@@ -112,13 +112,12 @@ PYTHON_VERS ?= python
 ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_VERS) > /dev/null 2>&1 && which swig && echo y"), y)
 	PYTHON_PLUGINS := plugin_python.so
 	BUILD_PYTHON := $(PYTHON) $(PYTHON_PLUGINS)
-	PYTHON_SO_INSTALL := ctracecmd.install
-	PYTHON_PY_PROGS := event-viewer.install
-	PYTHON_PY_LIBS := tracecmd.install tracecmdgui.install
+	BUILD_PYTHON_WORKS := 1
 endif
 endif # NO_PYTHON
 
 export PYTHON_PLUGINS
+export BUILD_PYTHON_WORKS
 
 # $(call test-build, snippet, ret) -> ret if snippet compiles
 #                                  -> empty otherwise
@@ -175,6 +174,7 @@ LIBTRACECMD_SHARED = $(LIBTRACECMD_DIR)/libtracecmd.so
 
 export LIBS
 export LIBTRACEEVENT_DIR LIBTRACECMD_DIR
+export LIBTRACECMD_STATIC LIBTRACECMD_SHARED
 
 CONFIG_INCLUDES = 
 CONFIG_LIBS	=
@@ -247,10 +247,6 @@ $(obj)/%.o: $(src)/%.c
 %.o: $(src)/%.c
 	$(Q)$(call do_compile)
 
-TRACE_VIEW_OBJS =
-TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view.o
-TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view-store.o
-
 TRACE_CMD_OBJS = trace-cmd.o trace-record.o trace-read.o trace-split.o trace-listen.o \
 	 trace-stack.o trace-hist.o trace-mem.o trace-snapshot.o trace-stat.o \
 	 trace-profile.o trace-stream.o trace-record.o trace-restore.o \
@@ -366,19 +362,8 @@ cscope: force
 install_plugins: force
 	$(Q)$(MAKE) -C $(src)/plugins $@
 
-$(PYTHON_SO_INSTALL): %.install : %.so force
-	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
-
-$(PYTHON_PY_PROGS): %.install : %.py force
-	$(Q)$(call do_install,$<,$(python_dir_SQ))
-
-$(PYTHON_PY_LIBS): %.install : %.py force
-	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
-
-$(PYTHON_PY_PLUGINS): %.install : %.py force
-	$(Q)$(call do_install_data,$<,$(plugin_dir_SQ))
-
-install_python: $(PYTHON_SO_INSTALL) $(PYTHON_PY_PROGS) $(PYTHON_PY_LIBS) $(PYTHON_PY_PLUGINS)
+install_python: force
+	$(Q)$(MAKE) -C $(src)/python $@
 
 install_bash_completion: force
 	$(Q)$(call do_install_data,trace-cmd.bash,$(BASH_COMPLETE_DIR))
@@ -411,19 +396,20 @@ install_doc:
 	$(MAKE) -C $(src)/Documentation install
 
 clean:
-	$(RM) *.o *~ $(TARGETS) *.a *.so ctracecmd_wrap.c .*.d
+	$(RM) *.o *~ $(TARGETS) *.a *.so .*.d
 	$(RM) tags TAGS cscope*
 	$(MAKE) -C $(src)/lib/traceevent clean
 	$(MAKE) -C $(src)/lib/trace-cmd clean
 	$(MAKE) -C $(src)/kernel-shark clean
 	$(MAKE) -C $(src)/plugins clean
+	$(MAKE) -C $(src)/python clean
 
 
 ##### PYTHON STUFF #####
 
 report_noswig: force
 	$(Q)echo
-	$(Q)echo "    NO_PYTHON forced: swig not installed, not compling python plugins"
+	$(Q)echo "    NO_PYTHON forced: swig not installed, not compiling python plugins"
 	$(Q)echo
 
 PYTHON_INCLUDES = `pkg-config --cflags $(PYTHON_VERS)`
@@ -435,15 +421,11 @@ export PYTHON_INCLUDES
 export PYTHON_LDFLAGS
 export PYGTK_CFLAGS
 
-ctracecmd.so: $(TCMD_LIB_OBJS) ctracecmd.i
-	swig -Wall -python -noproxy -I$(src)/include/traceevent -I$(src)/include/trace-cmd ctracecmd.i
-	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
-	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so
+ctracecmd.so: force $(LIBTRACECMD_STATIC)
+	$(Q)$(MAKE) -C $(src)/python $@
 
-ctracecmdgui.so: trace-view $(LIBTRACECMD_STATIC)
-	swig -Wall -python -noproxy -I$(src)/kernel-shark/include ctracecmdgui.i
-	$(CC) -fpic -c  $(CPPFLAGS) $(CFLAGS) $(INCLUDES) $(PYTHON_INCLUDES) $(PYGTK_CFLAGS) ctracecmdgui_wrap.c
-	$(CC) --shared $(TRACE_VIEW_OBJS) $(LIBTRACECMD_STATIC) $(LDFLAGS) $(LIBS) $(CONFIG_LIBS) ctracecmdgui_wrap.o -o ctracecmdgui.so
+ctracecmdgui.so: force $(LIBTRACECMD_STATIC) trace-view
+	$(Q)$(MAKE) -C $(src)/python $@
 
 PHONY += python
 python: $(PYTHON)
diff --git a/python/Makefile b/python/Makefile
new file mode 100644
index 0000000..b07c0d8
--- /dev/null
+++ b/python/Makefile
@@ -0,0 +1,40 @@
+include $(src)/scripts/utils.mk
+
+TRACE_VIEW_OBJS =
+TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view.o
+TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view-store.o
+
+ifdef BUILD_PYTHON_WORKS
+PYTHON_SO_INSTALL := ctracecmd.install
+PYTHON_PY_PROGS := event-viewer.install
+PYTHON_PY_LIBS := tracecmd.install tracecmdgui.install
+endif
+
+ctracecmd.so: ctracecmd.i $(LIBTRACECMD_STATIC)
+	swig -Wall -python -noproxy -I$(src)/include/traceevent -I$(src)/include/trace-cmd ctracecmd.i
+	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
+	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so
+
+ctracecmdgui.so: ctracecmdgui.i $(LIBTRACECMD_STATIC) $(TRACE_VIEW_OBJS)
+	swig -Wall -python -noproxy -I$(src)/kernel-shark/include ctracecmdgui.i
+	$(CC) -fpic -c  $(CPPFLAGS) $(CFLAGS) $(INCLUDES) $(PYTHON_INCLUDES) $(PYGTK_CFLAGS) ctracecmdgui_wrap.c
+	$(CC) --shared $(TRACE_VIEW_OBJS) $(LIBTRACECMD_STATIC) $(LDFLAGS) $(LIBS) $(CONFIG_LIBS) ctracecmdgui_wrap.o -o ctracecmdgui.so
+
+
+$(PYTHON_SO_INSTALL): %.install : %.so force
+	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
+
+$(PYTHON_PY_PROGS): %.install : %.py force
+	$(Q)$(call do_install,$<,$(python_dir_SQ))
+
+$(PYTHON_PY_LIBS): %.install : %.py force
+	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
+
+install_python: $(PYTHON_SO_INSTALL) $(PYTHON_PY_PROGS) $(PYTHON_PY_LIBS)
+
+
+clean:
+	$(RM) *.a *.so *.o .*.d ctracecmd_wrap.* ctracecmdgui_wrap.*
+
+force:
+.PHONY: clean force
diff --git a/ctracecmd.i b/python/ctracecmd.i
similarity index 100%
rename from ctracecmd.i
rename to python/ctracecmd.i
diff --git a/ctracecmdgui.i b/python/ctracecmdgui.i
similarity index 100%
rename from ctracecmdgui.i
rename to python/ctracecmdgui.i
diff --git a/event-viewer.py b/python/event-viewer.py
similarity index 100%
rename from event-viewer.py
rename to python/event-viewer.py
diff --git a/tracecmd.py b/python/tracecmd.py
similarity index 100%
rename from tracecmd.py
rename to python/tracecmd.py
diff --git a/tracecmdgui.py b/python/tracecmdgui.py
similarity index 100%
rename from tracecmdgui.py
rename to python/tracecmdgui.py
-- 
2.14.1
