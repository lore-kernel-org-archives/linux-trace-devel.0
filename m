Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35200 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932239AbdLTSIG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 13:08:06 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH 05/18] trace-cmd: Extract part of Makefile in scripts/utils.mk
Date: Wed, 20 Dec 2017 20:07:35 +0200
Message-Id: <20171220180748.17273-6-vladislav.valtchev@gmail.com>
In-Reply-To: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
References: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch extracts useful functions for Makefile in order to allow the new
Makefiles that will be introduced in the next steps to reuse them.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile         | 57 +++----------------------------------------------
 scripts/utils.mk | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 54 deletions(-)
 create mode 100644 scripts/utils.mk

diff --git a/Makefile b/Makefile
index 6d45870..6f502e7 100644
--- a/Makefile
+++ b/Makefile
@@ -203,10 +203,6 @@ VERSION		= $(KS_VERSION)
 PATCHLEVEL	= $(KS_PATCHLEVEL)
 EXTRAVERSION	= $(KS_EXTRAVERSION)
 
-GUI		= 'GUI '
-GOBJ		= $@
-GSPACE		=
-
 REBUILD_GUI	= /bin/true
 G		=
 N 		= @/bin/true ||
@@ -222,10 +218,6 @@ VERSION		= $(TC_VERSION)
 PATCHLEVEL	= $(TC_PATCHLEVEL)
 EXTRAVERSION	= $(TC_EXTRAVERSION)
 
-GUI		=
-GSPACE		= "    "
-GOBJ		= $(GSPACE)$@
-
 REBUILD_GUI	= $(MAKE) -f $(src)/Makefile BUILDGUI=1 $@
 G		= $(REBUILD_GUI); /bin/true ||
 N		=
@@ -233,6 +225,9 @@ endif
 
 export Q VERBOSE
 
+# Include the utils
+include scripts/utils.mk
+
 TRACECMD_VERSION = $(TC_VERSION).$(TC_PATCHLEVEL).$(TC_EXTRAVERSION)
 KERNELSHARK_VERSION = $(KS_VERSION).$(KS_PATCHLEVEL).$(KS_EXTRAVERSION)
 
@@ -279,52 +274,6 @@ endif
 override CFLAGS += $(CONFIG_FLAGS) $(INCLUDES) $(PLUGIN_DIR_SQ) $(VAR_DIR)
 override CFLAGS += $(udis86-flags) $(blk-flags)
 
-ifeq ($(VERBOSE),1)
-  Q =
-  print_compile =
-  print_app_build =
-  print_fpic_compile =
-  print_shared_lib_compile =
-  print_plugin_obj_compile =
-  print_plugin_build =
-  print_install =
-else
-  Q = @
-  print_compile =		echo '  $(GUI)COMPILE            '$(GOBJ);
-  print_app_build =		echo '  $(GUI)BUILD              '$(GOBJ);
-  print_fpic_compile =		echo '  $(GUI)COMPILE FPIC       '$(GOBJ);
-  print_shared_lib_compile =	echo '  $(GUI)COMPILE SHARED LIB '$(GOBJ);
-  print_plugin_obj_compile =	echo '  $(GUI)COMPILE PLUGIN OBJ '$(GOBJ);
-  print_plugin_build =		echo '  $(GUI)BUILD PLUGIN       '$(GOBJ);
-  print_static_lib_build =	echo '  $(GUI)BUILD STATIC LIB   '$(GOBJ);
-  print_install =		echo '  $(GUI)INSTALL     '$(GSPACE)$1'	to	$(DESTDIR_SQ)$2';
-endif
-
-do_fpic_compile =					\
-	($(print_fpic_compile)				\
-	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) -fPIC $< -o $@)
-
-do_app_build =						\
-	($(print_app_build)				\
-	$(CC) $^ -rdynamic -o $@ $(LDFLAGS) $(CONFIG_LIBS) $(LIBS))
-
-do_compile_shared_library =			\
-	($(print_shared_lib_compile)		\
-	$(CC) --shared $^ -o $@)
-
-do_compile_plugin_obj =				\
-	($(print_plugin_obj_compile)		\
-	$(CC) -c $(CPPFLAGS) $(CFLAGS) -fPIC -o $@ $<)
-
-do_plugin_build =				\
-	($(print_plugin_build)			\
-	$(CC) $(CFLAGS) $(LDFLAGS) -shared -nostartfiles -o $@ $<)
-
-do_build_static_lib =				\
-	($(print_static_lib_build)		\
-	$(RM) $@;  $(AR) rcs $@ $^)
-
-
 define check_gui
 	if [ $(BUILDGUI) -ne 1 -a ! -z "$(filter $(gui_objs),$(@))" ];	then	\
 		$(REBUILD_GUI);							\
diff --git a/scripts/utils.mk b/scripts/utils.mk
new file mode 100644
index 0000000..39cb387
--- /dev/null
+++ b/scripts/utils.mk
@@ -0,0 +1,64 @@
+
+# Utils
+
+ifeq ($(BUILDGUI), 1)
+  GUI		= 'GUI '
+  GOBJ		= $@
+  GSPACE	=
+else
+  GUI		=
+  GSPACE	= "    "
+  GOBJ		= $(GSPACE)$@
+endif
+
+
+ifeq ($(VERBOSE),1)
+  Q =
+  print_compile =
+  print_app_build =
+  print_fpic_compile =
+  print_shared_lib_compile =
+  print_plugin_obj_compile =
+  print_plugin_build =
+  print_install =
+else
+  Q = @
+  print_compile =		echo '  $(GUI)COMPILE            '$(GOBJ);
+  print_app_build =		echo '  $(GUI)BUILD              '$(GOBJ);
+  print_fpic_compile =		echo '  $(GUI)COMPILE FPIC       '$(GOBJ);
+  print_shared_lib_compile =	echo '  $(GUI)COMPILE SHARED LIB '$(GOBJ);
+  print_plugin_obj_compile =	echo '  $(GUI)COMPILE PLUGIN OBJ '$(GOBJ);
+  print_plugin_build =		echo '  $(GUI)BUILD PLUGIN       '$(GOBJ);
+  print_static_lib_build =	echo '  $(GUI)BUILD STATIC LIB   '$(GOBJ);
+  print_install =		echo '  $(GUI)INSTALL     '$(GSPACE)$1'	to	$(DESTDIR_SQ)$2';
+endif
+
+
+do_compile =				\
+	($(print_compile)			\
+	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) $< -o $@)
+
+do_fpic_compile =					\
+	($(print_fpic_compile)				\
+	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) -fPIC $< -o $@)
+
+do_app_build =						\
+	($(print_app_build)				\
+	$(CC) $^ -rdynamic -o $@ $(LDFLAGS) $(CONFIG_LIBS) $(LIBS))
+
+do_build_static_lib =				\
+	($(print_static_lib_build)		\
+	$(RM) $@;  $(AR) rcs $@ $^)
+
+do_compile_shared_library =			\
+	($(print_shared_lib_compile)		\
+	$(CC) --shared $^ -o $@)
+
+do_compile_plugin_obj =				\
+	($(print_plugin_obj_compile)		\
+	$(CC) -c $(CPPFLAGS) $(CFLAGS) -fPIC -o $@ $<)
+
+do_plugin_build =				\
+	($(print_plugin_build)			\
+	$(CC) $(CFLAGS) $(LDFLAGS) -shared -nostartfiles -o $@ $<)
+
-- 
2.14.1
