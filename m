Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pl0-f67.google.com ([209.85.160.67]:38201 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752403AbeBFItR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:17 -0500
Received: by mail-pl0-f67.google.com with SMTP id 13so848755plb.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:16 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 05/24] trace-cmd: Extract part of Makefile in scripts/utils.mk
Date: Tue,  6 Feb 2018 10:48:47 +0200
Message-Id: <20180206084906.9854-6-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
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
index 3c21a27..3b5045e 100644
--- a/Makefile
+++ b/Makefile
@@ -204,10 +204,6 @@ VERSION		= $(KS_VERSION)
 PATCHLEVEL	= $(KS_PATCHLEVEL)
 EXTRAVERSION	= $(KS_EXTRAVERSION)
 
-GUI		= 'GUI '
-GOBJ		= $@
-GSPACE		=
-
 REBUILD_GUI	= /bin/true
 G		=
 N 		= @/bin/true ||
@@ -223,10 +219,6 @@ VERSION		= $(TC_VERSION)
 PATCHLEVEL	= $(TC_PATCHLEVEL)
 EXTRAVERSION	= $(TC_EXTRAVERSION)
 
-GUI		=
-GSPACE		= "    "
-GOBJ		= $(GSPACE)$@
-
 REBUILD_GUI	= $(MAKE) -f $(src)/Makefile BUILDGUI=1 $@
 G		= $(REBUILD_GUI); /bin/true ||
 N		=
@@ -234,6 +226,9 @@ endif
 
 export Q VERBOSE
 
+# Include the utils
+include scripts/utils.mk
+
 TRACECMD_VERSION = $(TC_VERSION).$(TC_PATCHLEVEL).$(TC_EXTRAVERSION)
 KERNELSHARK_VERSION = $(KS_VERSION).$(KS_PATCHLEVEL).$(KS_EXTRAVERSION)
 
@@ -280,52 +275,6 @@ endif
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
