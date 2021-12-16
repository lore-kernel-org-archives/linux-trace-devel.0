Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A7AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 21:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241607AbhLPVkB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 16:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241298AbhLPVkA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 16:40:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7EEC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 13:40:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2324861F98
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B03C36AE9;
        Thu, 16 Dec 2021 21:39:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mxyTl-0003dK-Pv;
        Thu, 16 Dec 2021 16:39:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 02/10] libtraceevent: Rewrite Makefiles to be like libtracefs
Date:   Thu, 16 Dec 2021 16:39:48 -0500
Message-Id: <20211216213956.13934-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211216213956.13934-1-rostedt@goodmis.org>
References: <20211216213956.13934-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The libtraceevent code has moved around various homes. It originated in
the trace-cmd.git repository and then moved to the Linux kernel under
tools/libs. Finally it made its home in its own libtraceevent git repo.
During its time at different foster homes, it took with it various ways to
build it from the other homes and this was incorporated into the
Makefiles. But the kernel Makefiles were rather complex as it had to build
not only libtraceevent but other tooling.

Unfortunately, that complexity made it's way into libtraceevent, making it
difficult to add new functionality. Instead, rewrite it to be more like
libtracefs that has a much simpler Makefile structure.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/Makefile   |  12 ++-
 Makefile                 | 185 ++++++++++++++++++++-------------------
 build/Build.include      | 103 ----------------------
 build/Makefile.build     | 162 ----------------------------------
 plugins/Makefile         |  61 +++----------
 scripts/Makefile.include | 135 ----------------------------
 scripts/features.mk      |  37 ++++++++
 scripts/utils.mk         | 174 ++++++++++++++++++++++++++++++++++++
 src/Makefile             |  51 ++++++++++-
 9 files changed, 371 insertions(+), 549 deletions(-)
 delete mode 100644 build/Build.include
 delete mode 100644 build/Makefile.build
 delete mode 100644 scripts/Makefile.include
 create mode 100644 scripts/features.mk
 create mode 100644 scripts/utils.mk

diff --git a/Documentation/Makefile b/Documentation/Makefile
index af124572c863..5904b798b786 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -1,5 +1,5 @@
-include ../scripts/Makefile.include
 include ../scripts/utilities.mak
+include ../scripts/utils.mk
 
 # This Makefile and manpage XSL files were taken from tools/perf/Documentation
 # and modified for libtraceevent.
@@ -13,6 +13,8 @@ _MAN_XML=$(patsubst %.txt,%.xml,$(MAN_TXT))
 _MAN_HTML=$(patsubst %.txt,%.html,$(MAN_TXT))
 _DOC_MAN3=$(patsubst %.txt,%.m,$(MAN3_TXT))
 
+OUTPUT		:= $(obj)/Documentation/
+
 MAN_XML=$(addprefix $(OUTPUT),$(_MAN_XML))
 MAN_HTML=$(addprefix $(OUTPUT),$(_MAN_HTML))
 DOC_MAN3=$(addprefix $(OUTPUT),$(_DOC_MAN3))
@@ -155,9 +157,7 @@ ifdef missing_tools
 endif
 
 $(OUTPUT)install-%.3: $(OUTPUT)%.3
-	$(call QUIET_INSTALL, $<) \
-		$(INSTALL) -d -m 755 $(DESTDIR)$(man3dir); \
-		$(INSTALL) -m 644 $< $(DESTDIR)$(man3dir);
+	$(Q)$(call do_install,$<,$(man3dir),644)
 
 do-install-man: man $(patsubst $(OUTPUT)%,$(OUTPUT)install-%,$(wildcard $(OUTPUT)*.3))
 
@@ -165,9 +165,7 @@ install-man: check-man-tools man
 	$(Q)$(MAKE) -C . do-install-man
 
 install-%.txt: $(OUTPUT)%.html
-	$(call QUIET_INSTALL, $<) \
-		$(INSTALL) -d -m 755 $(DESTDIR)$(htmldir); \
-		$(INSTALL) -m 644 $< $(DESTDIR)$(htmldir);
+	$(Q)$(call do_install,$<,$(htmldir),644)
 
 do-install-html: html $(addprefix install-,$(wildcard *.txt))
 
diff --git a/Makefile b/Makefile
index 194bbdd2666f..4363e9b73dc3 100644
--- a/Makefile
+++ b/Makefile
@@ -3,6 +3,7 @@
 EP_VERSION = 1
 EP_PATCHLEVEL = 4
 EP_EXTRAVERSION = 0
+EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
 
 MAKEFLAGS += --no-print-directory
 
@@ -56,12 +57,7 @@ includedir_SQ = '$(subst ','\'',$(includedir))'
 
 export man_dir man_dir_SQ INSTALL
 export DESTDIR DESTDIR_SQ
-export EVENT_PARSE_VERSION
-
-include scripts/Makefile.include
-
-PKG_CONFIG_SOURCE_FILE = libtraceevent.pc
-PKG_CONFIG_FILE := $(addprefix $(OUTPUT),$(PKG_CONFIG_SOURCE_FILE))
+export EP_VERSION EVENT_PARSE_VERSION
 
 # copy a bit from Linux kbuild
 
@@ -72,12 +68,36 @@ ifndef VERBOSE
   VERBOSE = 0
 endif
 
-ifeq ($(srctree),)
-srctree := $(CURDIR)
-#$(info Determined 'srctree' to be $(srctree))
+SILENT := $(if $(findstring s,$(filter-out --%,$(MAKEFLAGS))),1)
+
+ifeq ("$(origin O)", "command line")
+
+  saved-output := $(O)
+  BUILD_OUTPUT := $(shell cd $(O) && /bin/pwd)
+  $(if $(BUILD_OUTPUT),, \
+    $(error output directory "$(saved-output)" does not exist))
+
+else
+  BUILD_OUTPUT = $(CURDIR)
 endif
 
-export prefix libdir
+srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
+objtree		:= $(BUILD_OUTPUT)
+src		:= $(srctree)
+obj		:= $(objtree)
+bdir		:= $(obj)/lib
+
+export prefix src obj bdir
+
+PKG_CONFIG_SOURCE_FILE = libtraceevent.pc
+PKG_CONFIG_FILE := $(addprefix $(obj)/,$(PKG_CONFIG_SOURCE_FILE))
+
+export Q SILENT VERBOSE EXT
+
+# Include the utils
+include scripts/utils.mk
+
+include $(src)/scripts/features.mk
 
 # Shell quotes
 libdir_SQ = $(subst ','\'',$(libdir))
@@ -94,21 +114,13 @@ EXTRAVERSION	= $(EP_EXTRAVERSION)
 OBJ		= $@
 N		=
 
-EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
-
-bdir = lib
-
-export bdir
-
 LIBTRACEEVENT_STATIC = $(bdir)/libtraceevent.a
 LIBTRACEEVENT_SHARED = $(bdir)/libtraceevent.so.$(EVENT_PARSE_VERSION)
 
-LIB_TARGET  = $(LIBTRACEEVENT_STATIC) $(bdir)/libtraceevent.so $(bdir)/libtraceevent.so.$(EP_VERSION) $(LIBTRACEEVENT_SHARED)
-LIB_INSTALL = $(LIBTRACEEVENT_STATIC) $(bdir)/libtraceevent.so*
-LIB_INSTALL := $(addprefix $(OUTPUT),$(LIB_INSTALL))
-
 INCLUDES = -I. -I $(srctree)/include $(CONFIG_INCLUDES)
 
+export LIBTRACEEVENT_STATIC LIBTRACEEVENT_SHARED
+
 # Set compile option CFLAGS
 ifdef EXTRA_CFLAGS
   CFLAGS := $(EXTRA_CFLAGS)
@@ -120,7 +132,7 @@ LIBS = -ldl
 
 set_plugin_dir := 1
 
-# Set plugin_dir to preffered global plugin location
+# Set plugin_dir to prefered global plugin location
 # If we install under $HOME directory we go under
 # $(HOME)/.local/lib/traceevent/plugins
 #
@@ -160,11 +172,10 @@ endif
 # the same command line setup.
 MAKEOVERRIDES=
 
-export srctree OUTPUT CC LD CFLAGS V
+export srctree CC LD CFLAGS V
 build := -f $(srctree)/build/Makefile.build dir=. obj
 
-TE_IN      := $(OUTPUT)src/libtraceevent-in.o
-LIB_TARGET := $(addprefix $(OUTPUT),$(LIB_TARGET))
+LIB_TARGET := libtraceevent.so libtraceevent.a
 
 CMD_TARGETS = $(LIB_TARGET) $(PKG_CONFIG_FILE)
 
@@ -172,27 +183,33 @@ TARGETS = $(CMD_TARGETS)
 
 all: all_cmd plugins
 
-all_cmd: $(CMD_TARGETS)
+$(bdir):
+	$(Q)mkdir -p $(bdir)
 
-$(TE_IN): force
-	$(Q)$(call descend,src,libtraceevent)
+LIB_TARGET  = libtraceevent.a libtraceevent.so
+LIB_INSTALL = libtraceevent.a libtraceevent.so*
+LIB_INSTALL := $(addprefix $(bdir)/,$(LIB_INSTALL))
 
-$(OUTPUT)$(LIBTRACEEVENT_SHARED): $(TE_IN)
-	$(Q)mkdir -p $(OUTPUT)$(bdir)
-	$(QUIET_LINK)$(CC) --shared $(LDFLAGS) $^ -Wl,-soname,libtraceevent.so.$(EP_VERSION) -o $@  $(LIBS)
+LIBTRACEEVENT_SHARED_SO = $(bdir)/libtraceevent.so
+LIBTRACEEVENT_SHARED_VERSION = $(bdir)/libtraceevent.so.$(EP_VERSION)
 
-$(OUTPUT)$(bdir)/libtraceevent.so: $(OUTPUT)$(bdir)/libtraceevent.so.$(EP_VERSION)
-	@ln -sf $(<F) $@
+export LIBTRACEEVENT_SHARED_SO LIBTRACEEVENT_SHARED_VERSION
 
-$(OUTPUT)$(bdir)/libtraceevent.so.$(EP_VERSION): $(OUTPUT)$(LIBTRACEEVENT_SHARED)
-	@ln -sf $(<F) $@
+all_cmd: $(CMD_TARGETS)
+
+libtraceevent.a: $(bdir) $(LIBTRACEEVENT_STATIC)
+libtraceevent.so: $(bdir) $(LIBTRACEEVENT_SHARED)
 
-$(OUTPUT)$(LIBTRACEEVENT_STATIC): $(TE_IN)
-	$(Q)mkdir -p $(OUTPUT)$(bdir)
-	$(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
+libs: libtraceevent.a libtraceevent.so
 
-$(OUTPUT)$(bdir)/%.so: $(OUTPUT)%-in.o
-	$(QUIET_LINK)$(CC) $(CFLAGS) -shared $(LDFLAGS) -nostartfiles -o $@ $^ $(LIBS)
+$(LIBTRACEEVENT_STATIC): force
+	$(Q)$(call descend,$(src)/src,$@)
+
+$(LIBTRACEEVENT_SHARED): force
+	$(Q)$(call descend,$(src)/src,libtraceevent.so)
+
+$(bdir)/libtraceevent.so: $(bdir)/libtraceevent.so.$(EP_VERSION)
+	@ln -sf $(<F) $@
 
 define make_version.h
   (echo '/* This file is automatically generated. Do not modify. */';		\
@@ -214,10 +231,10 @@ define update_version.h
     fi);
 endef
 
-ep_version.h: force
-	$(Q)$(N)$(call update_version.h)
+VERSION_FILE = $(obj)/ep_version.h
 
-VERSION_FILES = ep_version.h
+$(VERSION_FILE): force
+	$(Q)$(N)$(call update_version.h)
 
 define update_dir
   (echo $1 > $@.tmp;				\
@@ -249,22 +266,11 @@ define build_prefix
 	fi);
 endef
 
-BUILD_PREFIX := $(OUTPUT)build_prefix
+BUILD_PREFIX := $(obj)/build_prefix
 
 $(BUILD_PREFIX): force
 	$(Q)$(call build_prefix,$(prefix))
 
-define do_install_mkdir
-	if [ ! -d '$(DESTDIR_SQ)$1' ]; then		\
-		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$1';	\
-	fi
-endef
-
-define do_install
-	$(call do_install_mkdir,$2);			\
-	$(INSTALL) $(if $3,-m $3,) $1 '$(DESTDIR_SQ)$2'
-endef
-
 define do_make_pkgconfig_file
 	cp -f ${PKG_CONFIG_SOURCE_FILE}.template ${PKG_CONFIG_FILE};	\
 	sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
@@ -273,8 +279,8 @@ define do_make_pkgconfig_file
 	sed -i "s|HEADER_DIR|$(includedir_relative)|g" ${PKG_CONFIG_FILE};
 endef
 
-$(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template $(BUILD_PREFIX) $(VERSION_FILES)
-	$(QUIET_GEN) $(call do_make_pkgconfig_file,$(prefix))
+$(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template $(BUILD_PREFIX) $(VERSION_FILE)
+	$(Q)$(print_gen)$(call do_make_pkgconfig_file,$(prefix))
 
 define do_install_pkgconfig_file
 	if [ -n "${pkgconfig_dir}" ]; then 					\
@@ -292,14 +298,14 @@ ifeq ("$(DESTDIR)", "")
 define install_ld_config
 	if $(LDCONFIG); then \
 		if ! grep -q "^$(libdir)$$" $(LD_SO_CONF_PATH)/* ; then \
-			$(CC) -o $(OUTPUT)test $(srctree)/test.c -I $(includedir_SQ) \
-				-L $(libdir_SQ) -ltraceevent &>/dev/null; \
-			if ! $(OUTPUT)test &> /dev/null; then \
-				$(call PRINT_INSTALL, trace.conf) \
+			$(CC) -o $(objtree)/test $(srctree)/test.c -I $(includedir_SQ) \
+				-L $(libdir_SQ) -ltraceevent &> /dev/null; \
+			if ! $(objtree)/test &> /dev/null; then \
+				$(call print_install, trace.conf, $(LD_SO_CONF_PATH)) \
 				echo $(libdir_SQ) >> $(LD_SO_CONF_PATH)/trace.conf; \
 				$(LDCONFIG); \
 			fi; \
-			$(RM) $(OUTPUT)test; \
+			$(RM) $(objtree)/test; \
 		fi; \
 	fi
 endef
@@ -310,34 +316,30 @@ define install_ld_config
 endef
 endif # DESTDIR = ""
 
-install_lib: all_cmd install_plugins install_headers install_pkgconfig
-	$(call QUIET_INSTALL, $(LIB_TARGET)) \
-		$(call do_install_mkdir,$(libdir_SQ)); \
-		cp -fpR $(LIB_INSTALL) $(DESTDIR)$(libdir_SQ); \
-		$(call install_ld_config)
+install: install_libs install_plugins
+
+install_libs: libs install_headers install_pkgconfig
+	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ)); \
+		cp -fpR $(LIB_INSTALL) $(DESTDIR)$(libdir_SQ)
+	$(Q)$(call install_ld_config)
 
 install_pkgconfig: $(PKG_CONFIG_FILE)
-	$(call QUIET_INSTALL, $(PKG_CONFIG_FILE)) \
-		$(call do_install_pkgconfig_file,$(prefix))
+	$(Q)$(call do_install_pkgconfig_file,$(prefix))
 
 install_headers:
-	$(call QUIET_INSTALL, headers) \
-		$(call do_install,src/event-parse.h,$(includedir_SQ),644); \
-		$(call do_install,src/event-utils.h,$(includedir_SQ),644); \
-		$(call do_install,src/trace-seq.h,$(includedir_SQ),644); \
-		$(call do_install,src/kbuffer.h,$(includedir_SQ),644)
+	$(Q)$(call do_install,src/event-parse.h,$(includedir_SQ),644);
+	$(Q)$(call do_install,src/event-utils.h,$(includedir_SQ),644);
+	$(Q)$(call do_install,src/trace-seq.h,$(includedir_SQ),644);
+	$(Q)$(call do_install,src/kbuffer.h,$(includedir_SQ),644)
 
-install: install_lib
+install: install_libs
 
 clean: clean_plugins clean_src
-	$(call QUIET_CLEAN, libtraceevent) \
-		$(RM) $(OUTPUT)*.o $(OUTPUT)*~ $(TARGETS) $(OUTPUT)*.a $(OUTPUT)*.so $(VERSION_FILES) $(OUTPUT).*.d $(OUTPUT).*.cmd; \
-		$(RM) TRACEEVENT-CFLAGS $(OUTPUT)tags $(OUTPUT)TAGS; \
-		$(RM) $(PKG_CONFIG_FILE)
-ifneq ($(OUTPUT),)
-else
-BUILD_OUTPUT := $(shell pwd)
-endif
+	$(Q)$(call do_clean,\
+	    $(VERSION_FILE) $(obj)/tags $(obj)/TAGS $(PKG_CONFIG_FILE) \
+	    $(LIBTRACEEVENT_STATIC) $(LIBTRACEEVENT_SHARED) \
+	    $(LIBTRACEEVENT_SHARED_SO) $(LIBTRACEEVENT_SHARED_VERSION) \
+	    $(BUILD_PREFIX))
 
 define build_uninstall_script
 	$(Q)mkdir $(BUILD_OUTPUT)/tmp_build
@@ -362,19 +364,20 @@ uninstall: $(BUILD_OUTPUT)/build_uninstall
 
 PHONY += doc
 doc:
-	$(call descend,Documentation)
+	$(Q)$(call descend,$(src)/Documentation,)
 
 PHONY += doc-clean
 doc-clean:
-	$(call descend,Documentation,clean)
+	$(MAKE) -C $(src)/Documentation clean
 
 PHONY += doc-install
 doc-install:
-	$(call descend,Documentation,install)
+	$(Q)$(call descend,$(src)/Documentation,install)
+
 
 PHONY += doc-uninstall
 doc-uninstall:
-	$(call descend,Documentation,uninstall)
+	$(MAKE) -C $(src)/Documentation uninstall
 
 PHONY += help
 help:
@@ -395,19 +398,19 @@ help:
 
 PHONY += plugins
 plugins:
-	$(call descend,plugins)
+	$(Q)$(call descend,plugins,)
 
 PHONY += install_plugins
-install_plugins:
-	$(call descend,plugins,install)
+install_plugins: plugins
+	$(Q)$(call descend,plugins,install)
 
 PHONY += clean_plugins
 clean_plugins:
-	$(call descend,plugins,clean)
+	$(Q)$(call descend_clean,plugins)
 
 PHONY += clean_src
 clean_src:
-	$(call descend,src,clean)
+	$(Q)$(call descend_clean,src)
 
 force:
 
diff --git a/build/Build.include b/build/Build.include
deleted file mode 100644
index b4c1786cbe4a..000000000000
--- a/build/Build.include
+++ /dev/null
@@ -1,103 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-###
-# build: Generic definitions
-#
-#  Lots of this code have been borrowed or heavily inspired from parts
-#  of kbuild code, which is not credited, but mostly developed by:
-#
-#  Copyright (C) Sam Ravnborg <sam@mars.ravnborg.org>, 2015
-#  Copyright (C) Linus Torvalds <torvalds@linux-foundation.org>, 2015
-#
-
-###
-# Convenient variables
-comma   := ,
-squote  := '
-pound   := \#
-
-###
-# Name of target with a '.' as filename prefix. foo/bar.o => foo/.bar.o
-dot-target = $(dir $@).$(notdir $@)
-
-###
-# filename of target with directory and extension stripped
-basetarget = $(basename $(notdir $@))
-
-###
-# The temporary file to save gcc -MD generated dependencies must not
-# contain a comma
-depfile = $(subst $(comma),_,$(dot-target).d)
-
-###
-# Check if both arguments has same arguments. Result is empty string if equal.
-arg-check = $(strip $(filter-out $(cmd_$(1)), $(cmd_$@)) \
-                    $(filter-out $(cmd_$@),   $(cmd_$(1))) )
-
-###
-# Escape single quote for use in echo statements
-escsq = $(subst $(squote),'\$(squote)',$1)
-
-# Echo command
-# Short version is used, if $(quiet) equals `quiet_', otherwise full one.
-echo-cmd = $(if $($(quiet)cmd_$(1)),\
-           echo '  $(call escsq,$($(quiet)cmd_$(1)))';)
-
-###
-# Replace >$< with >$$< to preserve $ when reloading the .cmd file
-# (needed for make)
-# Replace >#< with >$(pound)< to avoid starting a comment in the .cmd file
-# (needed for make)
-# Replace >'< with >'\''< to be able to enclose the whole string in '...'
-# (needed for the shell)
-make-cmd = $(call escsq,$(subst $(pound),$$(pound),$(subst $$,$$$$,$(cmd_$(1)))))
-
-###
-# Find any prerequisites that is newer than target or that does not exist.
-# PHONY targets skipped in both cases.
-any-prereq = $(filter-out $(PHONY),$?) $(filter-out $(PHONY) $(wildcard $^),$^)
-
-###
-# Copy dependency data into .cmd file
-#  - gcc -M dependency info
-#  - command line to create object 'cmd_object :='
-dep-cmd = $(if $(wildcard $(fixdep)),                                           \
-           $(fixdep) $(depfile) $@ '$(make-cmd)' > $(dot-target).tmp;           \
-           rm -f $(depfile);                                                    \
-           mv -f $(dot-target).tmp $(dot-target).cmd,                           \
-           printf '$(pound) cannot find fixdep (%s)\n' $(fixdep) > $(dot-target).cmd; \
-           printf '$(pound) using basic dep data\n\n' >> $(dot-target).cmd;           \
-           cat $(depfile) >> $(dot-target).cmd;                                 \
-           printf '\n%s\n' 'cmd_$@ := $(make-cmd)' >> $(dot-target).cmd)
-
-###
-# if_changed_dep  - execute command if any prerequisite is newer than
-#                   target, or command line has changed and update
-#                   dependencies in the cmd file
-if_changed_dep = $(if $(strip $(any-prereq) $(arg-check)),         \
-                  @set -e;                                         \
-                  $(echo-cmd) $(cmd_$(1));                         \
-                  $(dep-cmd))
-
-# if_changed      - execute command if any prerequisite is newer than
-#                   target, or command line has changed
-if_changed = $(if $(strip $(any-prereq) $(arg-check)),                   \
-              @set -e;                                                   \
-              $(echo-cmd) $(cmd_$(1));                                   \
-              printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd)
-
-###
-# C flags to be used in rule definitions, includes:
-# - depfile generation
-# - global $(CFLAGS)
-# - per target C flags
-# - per object C flags
-# - BUILD_STR macro to allow '-D"$(variable)"' constructs
-c_flags_1 = -Wp,-MD,$(depfile) -Wp,-MT,$@ $(CFLAGS) -D"BUILD_STR(s)=\#s" $(CFLAGS_$(basetarget).o) $(CFLAGS_$(obj))
-c_flags_2 = $(filter-out $(CFLAGS_REMOVE_$(basetarget).o), $(c_flags_1))
-c_flags   = $(filter-out $(CFLAGS_REMOVE_$(obj)), $(c_flags_2))
-cxx_flags = -Wp,-MD,$(depfile) -Wp,-MT,$@ $(CXXFLAGS) -D"BUILD_STR(s)=\#s" $(CXXFLAGS_$(basetarget).o) $(CXXFLAGS_$(obj))
-
-###
-## HOSTCC C flags
-
-host_c_flags = -Wp,-MD,$(depfile) -Wp,-MT,$@ $(KBUILD_HOSTCFLAGS) -D"BUILD_STR(s)=\#s" $(HOSTCFLAGS_$(basetarget).o) $(HOSTCFLAGS_$(obj))
diff --git a/build/Makefile.build b/build/Makefile.build
deleted file mode 100644
index c267572f5bf0..000000000000
--- a/build/Makefile.build
+++ /dev/null
@@ -1,162 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-###
-# Main build makefile.
-#
-#  Lots of this code have been borrowed or heavily inspired from parts
-#  of kbuild code, which is not credited, but mostly developed by:
-#
-#  Copyright (C) Sam Ravnborg <sam@mars.ravnborg.org>, 2015
-#  Copyright (C) Linus Torvalds <torvalds@linux-foundation.org>, 2015
-#
-
-PHONY := __build
-__build:
-
-ifeq ($(V),1)
-  quiet =
-  Q =
-else
-  quiet=quiet_
-  Q=@
-endif
-
-ifneq ($(findstring s,$(filter-out --%,$(MAKEFLAGS))),)
-  quiet=silent_
-endif
-
-build-dir := $(srctree)/build
-
-# Define $(fixdep) for dep-cmd function
-ifeq ($(OUTPUT),)
-  fixdep := $(build-dir)/fixdep
-else
-  fixdep := $(OUTPUT)/fixdep
-endif
-
-# Generic definitions
-include $(build-dir)/Build.include
-
-# do not force detected configuration
--include $(OUTPUT).config-detected
-
-# Init all relevant variables used in build files so
-# 1) they have correct type
-# 2) they do not inherit any value from the environment
-subdir-y     :=
-obj-y        :=
-subdir-y     :=
-subdir-obj-y :=
-
-# Build definitions
-build-file := $(dir)/Build
--include $(build-file)
-
-quiet_cmd_flex  = FLEX     $@
-quiet_cmd_bison = BISON    $@
-
-# Create directory unless it exists
-quiet_cmd_mkdir = MKDIR    $(dir $@)
-      cmd_mkdir = mkdir -p $(dir $@)
-     rule_mkdir = $(if $(wildcard $(dir $@)),,@$(call echo-cmd,mkdir) $(cmd_mkdir))
-
-# Compile command
-quiet_cmd_cc_o_c = CC       $@
-      cmd_cc_o_c = $(CC) $(c_flags) -c -o $@ $<
-
-quiet_cmd_host_cc_o_c = HOSTCC   $@
-      cmd_host_cc_o_c = $(HOSTCC) $(host_c_flags) -c -o $@ $<
-
-quiet_cmd_cxx_o_c = CXX      $@
-      cmd_cxx_o_c = $(CXX) $(cxx_flags) -c -o $@ $<
-
-quiet_cmd_cpp_i_c = CPP      $@
-      cmd_cpp_i_c = $(CC) $(c_flags) -E -o $@ $<
-
-quiet_cmd_cc_s_c = AS       $@
-      cmd_cc_s_c = $(CC) $(c_flags) -S -o $@ $<
-
-quiet_cmd_gen = GEN      $@
-
-# Link agregate command
-# If there's nothing to link, create empty $@ object.
-quiet_cmd_ld_multi = LD       $@
-      cmd_ld_multi = $(if $(strip $(obj-y)),\
-                     $(LD) -r -o $@  $(filter $(obj-y),$^),rm -f $@; $(AR) rcs $@)
-
-quiet_cmd_host_ld_multi = HOSTLD   $@
-      cmd_host_ld_multi = $(if $(strip $(obj-y)),\
-                          $(HOSTLD) -r -o $@  $(filter $(obj-y),$^),rm -f $@; $(HOSTAR) rcs $@)
-
-ifneq ($(filter $(obj),$(hostprogs)),)
-  host = host_
-endif
-
-# Build rules
-$(OUTPUT)%.o: %.c FORCE
-	$(call rule_mkdir)
-	$(call if_changed_dep,$(host)cc_o_c)
-
-$(OUTPUT)%.o: %.cpp FORCE
-	$(call rule_mkdir)
-	$(call if_changed_dep,cxx_o_c)
-
-$(OUTPUT)%.o: %.S FORCE
-	$(call rule_mkdir)
-	$(call if_changed_dep,$(host)cc_o_c)
-
-$(OUTPUT)%.i: %.c FORCE
-	$(call rule_mkdir)
-	$(call if_changed_dep,cpp_i_c)
-
-$(OUTPUT)%.s: %.S FORCE
-	$(call rule_mkdir)
-	$(call if_changed_dep,cpp_i_c)
-
-$(OUTPUT)%.s: %.c FORCE
-	$(call rule_mkdir)
-	$(call if_changed_dep,cc_s_c)
-
-# Gather build data:
-#   obj-y        - list of build objects
-#   subdir-y     - list of directories to nest
-#   subdir-obj-y - list of directories objects 'dir/$(obj)-in.o'
-obj-y        := $($(obj)-y)
-subdir-y     := $(patsubst %/,%,$(filter %/, $(obj-y)))
-obj-y        := $(patsubst %/, %/$(obj)-in.o, $(obj-y))
-subdir-obj-y := $(filter %/$(obj)-in.o, $(obj-y))
-
-# '$(OUTPUT)/dir' prefix to all objects
-objprefix    := $(subst ./,,$(OUTPUT)$(dir)/)
-obj-y        := $(addprefix $(objprefix),$(obj-y))
-subdir-obj-y := $(addprefix $(objprefix),$(subdir-obj-y))
-
-# Final '$(obj)-in.o' object
-in-target := $(objprefix)$(obj)-in.o
-
-PHONY += $(subdir-y)
-
-$(subdir-y):
-	$(Q)$(MAKE) -f $(build-dir)/Makefile.build dir=$(dir)/$@ obj=$(obj)
-
-$(sort $(subdir-obj-y)): $(subdir-y) ;
-
-$(in-target): $(obj-y) FORCE
-	$(call rule_mkdir)
-	$(call if_changed,$(host)ld_multi)
-
-__build: $(in-target)
-	@:
-
-PHONY += FORCE
-FORCE:
-
-# Include all cmd files to get all the dependency rules
-# for all objects included
-targets   := $(wildcard $(sort $(obj-y) $(in-target) $(MAKECMDGOALS)))
-cmd_files := $(wildcard $(foreach f,$(targets),$(dir $(f)).$(notdir $(f)).cmd))
-
-ifneq ($(cmd_files),)
-  include $(cmd_files)
-endif
-
-.PHONY: $(PHONY)
diff --git a/plugins/Makefile b/plugins/Makefile
index b60352da7816..8b1dbf68757c 100644
--- a/plugins/Makefile
+++ b/plugins/Makefile
@@ -41,7 +41,7 @@ libdir_relative ?= $(libdir_relative_tmp)
 prefix ?= /usr/local
 libdir = $(prefix)/$(libdir_relative)
 
-include ../scripts/Makefile.include
+include ../scripts/utils.mk
 
 # copy a bit from Linux kbuild
 
@@ -52,13 +52,6 @@ ifndef VERBOSE
   VERBOSE = 0
 endif
 
-ifeq ($(srctree),)
-srctree := $(patsubst %/,%,$(dir $(CURDIR)))
-#$(info Determined 'srctree' to be $(srctree))
-endif
-
-export prefix libdir
-
 # Shell quotes
 plugin_dir_SQ = $(subst ','\'',$(plugin_dir))
 
@@ -89,16 +82,9 @@ else
   Q = @
 endif
 
-# Disable command line variables (CFLAGS) override from top
-# level Makefile (perf), otherwise build Makefile will get
-# the same command line setup.
-MAKEOVERRIDES=
-
 export srctree OUTPUT CC LD CFLAGS V
 
-build := -f $(srctree)/build/Makefile.build dir=. obj
-
-DYNAMIC_LIST_FILE := $(OUTPUT)libtraceevent-dynamic-list
+DYNAMIC_LIST_FILE := $(bdir)/libtraceevent-dynamic-list
 
 PLUGINS  = plugin_jbd2.so
 PLUGINS += plugin_hrtimer.so
@@ -113,22 +99,16 @@ PLUGINS += plugin_scsi.so
 PLUGINS += plugin_cfg80211.so
 PLUGINS += plugin_tlb.so
 
-PLUGINS    := $(addprefix $(OUTPUT),$(PLUGINS))
-PLUGINS_IN := $(PLUGINS:.so=-in.o)
+PLUGINS := $(PLUGINS:%.so=$(bdir)/%.so)
+DEPS := $(PLUGINS:$(bdir)/%.so=$(bdir)/.%.d)
 
 plugins: $(PLUGINS) $(DYNAMIC_LIST_FILE)
 
-__plugin_obj = $(notdir $@)
-  plugin_obj = $(__plugin_obj:-in.o=)
-
-$(PLUGINS_IN): force
-	$(Q)$(MAKE) $(build)=$(plugin_obj)
+$(PLUGINS): | $(bdir)
+$(DEPS): | $(bdir)
 
-$(OUTPUT)libtraceevent-dynamic-list: $(PLUGINS)
-	$(QUIET_GEN)$(call do_generate_dynamic_list_file, $(PLUGINS), $@)
-
-$(OUTPUT)%.so: $(OUTPUT)%-in.o
-	$(QUIET_LINK)$(CC) $(CFLAGS) -shared $(LDFLAGS) -nostartfiles -o $@ $^
+$(bdir)/%.so: $(srctree)/plugins/%.c
+	$(Q)$(call do_plugin_build)
 
 define update_dir
   (echo $1 > $@.tmp;                           \
@@ -150,17 +130,6 @@ TAGS:	force
 	find . -name '*.[ch]' | xargs etags \
 	--regex='/_PE(\([^,)]*\).*/TEP_ERRNO__\1/'
 
-define do_install_mkdir
-	if [ ! -d '$(DESTDIR_SQ)$1' ]; then             \
-		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$1'; \
-	fi
-endef
-
-define do_install
-	$(call do_install_mkdir,$2);                    \
-	$(INSTALL) $(if $3,-m $3,) $1 '$(DESTDIR_SQ)$2'
-endef
-
 define do_install_plugins
        for plugin in $1; do                            \
          $(call do_install,$$plugin,$(plugin_dir_SQ)); \
@@ -180,18 +149,16 @@ define do_generate_dynamic_list_file
 		fi
 endef
 
+$(DYNAMIC_LIST_FILE): $(PLUGINS)
+	$(Q)($(print_gen)$(call do_generate_dynamic_list_file, $(PLUGINS), $@))
+
 install: $(PLUGINS)
-	$(call QUIET_INSTALL, trace_plugins) \
-	$(call do_install_plugins, $(PLUGINS))
+	$(Q)$(call do_install_plugins, $(PLUGINS))
 
 clean:
-	$(call QUIET_CLEAN, trace_plugins) \
-		$(RM) $(OUTPUT)*.o $(OUTPUT)*~ $(TARGETS) $(OUTPUT)*.a $(OUTPUT)*.so $(VERSION_FILES) .*.d .*.cmd; \
-		$(RM) $(OUTPUT)libtraceevent-dynamic-list; \
-		$(RM) $(PLUGINS); \
-		$(RM) TRACEEVENT-CFLAGS tags TAGS;
+	$(Q)$(call do_clean, $(DYNAMIC_LIST_FILE) $(PLUGINS))
 
-PHONY += force plugins
+PHONY += force plugins $(DYNAMIC_LIST_FILE)
 force:
 
 # Declare the contents of the .PHONY variable as phony.  We keep that
diff --git a/scripts/Makefile.include b/scripts/Makefile.include
deleted file mode 100644
index 1c9266c34d2a..000000000000
--- a/scripts/Makefile.include
+++ /dev/null
@@ -1,135 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-ifneq ($(O),)
-ifeq ($(origin O), command line)
-	dummy := $(if $(shell cd $(PWD); test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
-	ABSOLUTE_O := $(shell cd $(PWD); cd $(O) ; pwd)
-	OUTPUT := $(ABSOLUTE_O)/$(if $(subdir),$(subdir)/)
-	COMMAND_O := O=$(ABSOLUTE_O)
-ifeq ($(objtree),)
-	objtree := $(O)
-endif
-endif
-endif
-
-# check that the output directory actually exists
-ifneq ($(OUTPUT),)
-OUTDIR := $(shell cd $(OUTPUT) && pwd)
-$(if $(OUTDIR),, $(error output directory "$(OUTPUT)" does not exist))
-endif
-
-#
-# Include saner warnings here, which can catch bugs:
-#
-EXTRA_WARNINGS := -Wbad-function-cast
-EXTRA_WARNINGS += -Wdeclaration-after-statement
-EXTRA_WARNINGS += -Wformat-security
-EXTRA_WARNINGS += -Wformat-y2k
-EXTRA_WARNINGS += -Winit-self
-EXTRA_WARNINGS += -Wmissing-declarations
-EXTRA_WARNINGS += -Wmissing-prototypes
-EXTRA_WARNINGS += -Wnested-externs
-EXTRA_WARNINGS += -Wno-system-headers
-EXTRA_WARNINGS += -Wold-style-definition
-EXTRA_WARNINGS += -Wpacked
-EXTRA_WARNINGS += -Wredundant-decls
-EXTRA_WARNINGS += -Wstrict-prototypes
-EXTRA_WARNINGS += -Wswitch-default
-EXTRA_WARNINGS += -Wswitch-enum
-EXTRA_WARNINGS += -Wundef
-EXTRA_WARNINGS += -Wwrite-strings
-EXTRA_WARNINGS += -Wformat
-
-CC_NO_CLANG := $(shell $(CC) -dM -E -x c /dev/null | grep -Fq "__clang__"; echo $$?)
-
-# Makefiles suck: This macro sets a default value of $(2) for the
-# variable named by $(1), unless the variable has been set by
-# environment or command line. This is necessary for CC and AR
-# because make sets default values, so the simpler ?= approach
-# won't work as expected.
-define allow-override
-  $(if $(or $(findstring environment,$(origin $(1))),\
-            $(findstring command line,$(origin $(1)))),,\
-    $(eval $(1) = $(2)))
-endef
-
-# Allow setting various cross-compile vars or setting CROSS_COMPILE as a prefix.
-$(call allow-override,CC,$(CROSS_COMPILE)gcc)
-$(call allow-override,AR,$(CROSS_COMPILE)ar)
-$(call allow-override,LD,$(CROSS_COMPILE)ld)
-$(call allow-override,CXX,$(CROSS_COMPILE)g++)
-$(call allow-override,STRIP,$(CROSS_COMPILE)strip)
-
-ifeq ($(CC_NO_CLANG), 1)
-EXTRA_WARNINGS += -Wstrict-aliasing=3
-endif
-
-# Hack to avoid type-punned warnings on old systems such as RHEL5:
-# We should be changing CFLAGS and checking gcc version, but this
-# will do for now and keep the above -Wstrict-aliasing=3 in place
-# in newer systems.
-# Needed for the __raw_cmpxchg in tools/arch/x86/include/asm/cmpxchg.h
-#
-# See https://lkml.org/lkml/2006/11/28/253 and https://gcc.gnu.org/gcc-4.8/changes.html,
-# that takes into account Linus's comments (search for Wshadow) for the reasoning about
-# -Wshadow not being interesting before gcc 4.8.
-
-ifneq ($(filter 3.%,$(MAKE_VERSION)),)  # make-3
-EXTRA_WARNINGS += -fno-strict-aliasing
-EXTRA_WARNINGS += -Wno-shadow
-else
-EXTRA_WARNINGS += -Wshadow
-endif
-
-ifneq ($(findstring $(MAKEFLAGS), w),w)
-PRINT_DIR = --no-print-directory
-else
-NO_SUBDIR = :
-endif
-
-ifneq ($(findstring s,$(filter-out --%,$(MAKEFLAGS))),)
-  silent=1
-endif
-
-#
-# Define a callable command for descending to a new directory
-#
-# Call by doing: $(call descend,directory[,target])
-#
-descend = \
-	+mkdir -p $(OUTPUT)$(1) && \
-	$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1) $(2)
-
-QUIET_SUBDIR0  = +$(MAKE) $(COMMAND_O) -C # space to separate -C and subdir
-QUIET_SUBDIR1  =
-
-ifneq ($(silent),1)
-  ifneq ($(V),1)
-	QUIET_CC       = @echo '  CC       '$@;
-	QUIET_CC_FPIC  = @echo '  CC FPIC  '$@;
-	QUIET_CLANG    = @echo '  CLANG    '$@;
-	QUIET_AR       = @echo '  AR       '$@;
-	QUIET_LINK     = @echo '  LINK     '$@;
-	QUIET_MKDIR    = @echo '  MKDIR    '$@;
-	PRINT_GEN      = echo '  GEN      '$@;
-	QUIET_GEN      = @echo '  GEN      '$@;
-	QUIET_SUBDIR0  = +@subdir=
-	QUIET_SUBDIR1  = ;$(NO_SUBDIR) \
-			  echo '  SUBDIR   '$$subdir; \
-			 $(MAKE) $(PRINT_DIR) -C $$subdir
-	QUIET_FLEX     = @echo '  FLEX     '$@;
-	QUIET_BISON    = @echo '  BISON    '$@;
-
-	descend = \
-		+@echo	       '  DESCEND  '$(1); \
-		mkdir -p $(OUTPUT)$(1) && \
-		$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1) $(2)
-
-	PRINT_INSTALL  = printf '  INSTALL  %s\n' $1;
-	PRINT_UNINST   = printf '  UNINST   %s\n' $1;
-	QUIET_CLEAN    = @printf '  CLEAN    %s\n' $1;
-	QUIET_INSTALL  = @printf '  INSTALL  %s\n' $1;
-	QUIET_UNINST   = @printf '  UNINST   %s\n' $1;
-  endif
-endif
-
-pound := \#
diff --git a/scripts/features.mk b/scripts/features.mk
new file mode 100644
index 000000000000..9c7f8c3076b3
--- /dev/null
+++ b/scripts/features.mk
@@ -0,0 +1,37 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# taken from perf which was based on Linux Kbuild
+# try-cc
+# Usage: option = $(call try-cc, source-to-build, cc-options)
+try-cc = $(shell sh -c							\
+	'TMP="$(BUILD_OUTPUT)$(TMPOUT).$$$$";						\
+	echo "$(1)" |							\
+	$(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y;	\
+	rm -f "$$TMP"')
+
+define SOURCE_PTRACE
+#include <stdio.h>
+#include <sys/ptrace.h>
+
+int main (void)
+{
+	int ret;
+	ret = ptrace(PTRACE_ATTACH, 0, NULL, 0);
+	ptrace(PTRACE_TRACEME, 0, NULL, 0);
+	ptrace(PTRACE_GETSIGINFO, 0, NULL, NULL);
+	ptrace(PTRACE_GETEVENTMSG, 0, NULL, NULL);
+	ptrace(PTRACE_SETOPTIONS, NULL, NULL,
+		       PTRACE_O_TRACEFORK |
+		       PTRACE_O_TRACEVFORK |
+		       PTRACE_O_TRACECLONE |
+		       PTRACE_O_TRACEEXIT);
+	ptrace(PTRACE_CONT, NULL, NULL, 0);
+	ptrace(PTRACE_DETACH, 0, NULL, NULL);
+	ptrace(PTRACE_SETOPTIONS, 0, NULL,
+	       PTRACE_O_TRACEFORK |
+	       PTRACE_O_TRACEVFORK |
+	       PTRACE_O_TRACECLONE |
+	       PTRACE_O_TRACEEXIT);
+	return ret;
+}
+endef
diff --git a/scripts/utils.mk b/scripts/utils.mk
new file mode 100644
index 000000000000..e33a8176049f
--- /dev/null
+++ b/scripts/utils.mk
@@ -0,0 +1,174 @@
+# SPDX-License-Identifier: LGPL-2.1
+
+# Utils
+
+ PWD		:= $(shell /bin/pwd)
+ GOBJ		= $(notdir $(strip $@))
+ BASE1		= $(notdir $(strip $1))
+ BASE2		= $(notdir $(strip $2))
+ BASEPWD	= $(notdir $(strip $(PWD)))
+
+
+ifeq ($(VERBOSE),1)
+  Q =
+  S =
+else
+  Q = @
+  S = -s
+endif
+
+# Use empty print_* macros if either SILENT or VERBOSE.
+ifeq ($(findstring 1,$(SILENT)$(VERBOSE)),1)
+  print_compile =
+  print_app_build =
+  print_fpic_compile =
+  print_shared_lib_compile =
+  print_plugin_obj_compile =
+  print_plugin_build =
+  print_install =
+  print_uninstall =
+  print_gen =
+  print_update =
+  print_descend =
+  print_clean =
+else
+  print_compile =		echo '  COMPILE            '$(GOBJ);
+  print_app_build =		echo '  BUILD              '$(GOBJ);
+  print_fpic_compile =		echo '  COMPILE FPIC       '$(GOBJ);
+  print_shared_lib_compile =	echo '  COMPILE SHARED LIB '$(GOBJ);
+  print_plugin_obj_compile =	echo '  COMPILE PLUGIN OBJ '$(GOBJ);
+  print_plugin_build =		echo '  BUILD PLUGIN       '$(GOBJ);
+  print_static_lib_build =	echo '  BUILD STATIC LIB   '$(GOBJ);
+  print_install =		echo '  INSTALL     '$1'	to	$(DESTDIR_SQ)$2';
+  print_uninstall =		echo '  UNINSTALL     $(DESTDIR_SQ)$1';
+  print_gen =			echo '  GEN                '$(GOBJ);
+  print_update =		echo '  UPDATE             '$(GOBJ);
+  print_descend =		echo '  DESCEND            '$(BASE1) $(BASE2);
+  print_clean =			echo '  CLEAN              '$(BASEPWD);
+endif
+
+do_fpic_compile =					\
+	($(print_fpic_compile)				\
+	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) -fPIC $< -o $@)
+
+do_compile =							\
+	($(if $(GENERATE_PIC), $(do_fpic_compile),		\
+	 $(print_compile)					\
+	 $(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) $< -o $@))
+
+do_app_build =						\
+	($(print_app_build)				\
+	$(CC) $^ -rdynamic -o $@ $(LDFLAGS) $(CONFIG_LIBS) $(LIBS))
+
+do_build_static_lib =				\
+	($(print_static_lib_build)		\
+	if [ -f $@ ]; then			\
+	    mv $@ $@.rm; $(RM) $@.rm;		\
+	fi;					\
+	$(AR) rcs $@ $^)
+
+do_compile_shared_library =			\
+	($(print_shared_lib_compile)		\
+	$(CC) --shared $^ '-Wl,-soname,$(1),-rpath=$$ORIGIN' -o $@ $(LDFLAGS) $(LIBS))
+
+do_compile_plugin_obj =				\
+	($(print_plugin_obj_compile)		\
+	$(CC) -c $(CPPFLAGS) $(CFLAGS) -fPIC -o $@ $<)
+
+do_plugin_build =				\
+	($(print_plugin_build)			\
+	$(CC) $(CFLAGS) $(LDFLAGS) -shared -nostartfiles -o $@ $<)
+
+do_compile_python_plugin_obj =			\
+	($(print_plugin_obj_compile)		\
+	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_DIR_SQ) $(PYTHON_INCLUDES) -fPIC -o $@ $<)
+
+do_python_plugin_build =			\
+	($(print_plugin_build)			\
+	$(CC) $< -shared $(LDFLAGS) $(PYTHON_LDFLAGS) -o $@)
+
+do_clean =					\
+	($(print_clean)				\
+	$(RM) $1)
+
+#
+# Define a callable command for descending to a new directory
+#
+# Call by doing: $(call descend,directory[,target])
+#
+descend = \
+	($(print_descend)		\
+	mkdir -p $(obj)/$(BASE1); \
+	$(MAKE) $(PRINT_DIR) bdir=$(obj)/$(BASE1) -C $(1) $(2))
+
+descend_clean = \
+	$(MAKE) $(PRINT_DIR) bdir=$(obj)/$(BASE1) -C $(1) clean
+
+define make_version.h
+	(echo '/* This file is automatically generated. Do not modify. */';		\
+	echo \#define VERSION_CODE $(shell						\
+	expr $(VERSION) \* 256 + $(PATCHLEVEL));					\
+	echo '#define EXTRAVERSION ' $(EXTRAVERSION);					\
+	echo '#define VERSION_STRING "'$(VERSION).$(PATCHLEVEL).$(EXTRAVERSION)'"';	\
+	echo '#define FILE_VERSION '$(FILE_VERSION);					\
+	if [ -d $(src)/.git ]; then							\
+	  d=`git diff`;									\
+	  x="";										\
+	  if [ ! -z "$$d" ]; then x="+"; fi;						\
+	  echo '#define VERSION_GIT "'$(shell 						\
+		git log -1 --pretty=format:"%H" 2>/dev/null)$$x'"';			\
+	else										\
+	  echo '#define VERSION_GIT "not-a-git-repo"';					\
+	fi										\
+	) > $1
+endef
+
+define update_version.h
+	($(call make_version.h, $@.tmp);				\
+	if [ -r $@ ] && cmp -s $@ $@.tmp; then				\
+		rm -f $@.tmp;						\
+	else								\
+		$(print_update)						\
+		mv -f $@.tmp $@;					\
+	fi);
+endef
+
+define update_dir
+	(echo $1 > $@.tmp;	\
+	if [ -r $@ ] && cmp -s $@ $@.tmp; then				\
+		rm -f $@.tmp;						\
+	else								\
+		$(print_update)						\
+		mv -f $@.tmp $@;					\
+	fi);
+endef
+
+define build_prefix
+	(echo $1 > $@.tmp;	\
+	if [ -r $@ ] && cmp -s $@ $@.tmp; then				\
+		rm -f $@.tmp;						\
+	else								\
+		$(print_update)						\
+		mv -f $@.tmp $@;					\
+	fi);
+endef
+
+define do_install_mkdir
+	if [ ! -d '$(DESTDIR_SQ)$1' ]; then		\
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$1';	\
+	fi
+endef
+
+define do_install
+	$(print_install)				\
+	$(call do_install_mkdir,$2);			\
+	$(INSTALL) $(if $3,-m $3,) $1 '$(DESTDIR_SQ)$2'
+endef
+
+define do_install_pkgconfig_file
+	if [ -n "${pkgconfig_dir}" ]; then 					\
+		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
+	else 									\
+		(echo Failed to locate pkg-config directory) 1>&2;		\
+	fi
+endef
diff --git a/src/Makefile b/src/Makefile
index b7159bed9b68..53bb570182d2 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -1,12 +1,55 @@
 # SPDX-License-Identifier: LGPL-2.1
 
-include ../scripts/Makefile.include
+include $(src)/scripts/utils.mk
 
-build := -f $(srctree)/build/Makefile.build dir=. obj
+OBJS =
+OBJS += event-parse-api.o
+OBJS += event-parse.o
+OBJS += event-plugin.o
+OBJS += kbuffer-parse.o
+OBJS += parse-filter.o
+OBJS += parse-utils.o
+OBJS += tep_strerror.o
+OBJS += trace-seq.o
+
+OBJS := $(OBJS:%.o=$(bdir)/%.o)
+DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
+
+$(bdir)/%.o: %.c
+	$(Q)$(call do_fpic_compile)
+
+$(LIBTRACEEVENT_STATIC): $(OBJS)
+	$(Q)$(call do_build_static_lib)
+
+$(LIBTRACEEVENT_SHARED): $(OBJS)
+	$(Q)$(call do_compile_shared_library,$(notdir $(LIBTRACEEVENT_SHARED_VERSION)))
+
+$(LIBTRACEEVENT_SHARED_VERSION): $(LIBTRACEEVENT_SHARED)
+	@ln -sf $(<F) $@
+
+$(LIBTRACEEVENT_SHARED_SO): $(LIBTRACEEVENT_SHARED_VERSION)
+	@ln -sf $(<F) $@
+
+libtraceevent.so: $(LIBTRACEEVENT_SHARED_SO)
 
 libtraceevent: $(libtraceevent-y)
 	$(Q)$(MAKE) $(build)=libtraceevent
 
+$(DEPS): $(bdir)/.%.d: %.c
+	$(Q)$(CC) -M -MT $(bdir)/$*.o $(CPPFLAGS) $(CFLAGS) $< > $@
+
+$(OBJS): $(bdir)/%.o : $(bdir)/.%.d
+
+$(OBJS): | $(bdir)
+$(DEPS): | $(bdir)
+
 clean:
-	$(call QUIET_CLEAN, trace_src) \
-		$(RM) $(OUTPUT)*.o $(OUTPUT)*~ .*.d .*.cmd
+	$(Q)$(call do_clean,$(OBJS) $(DEPS))
+
+dep_includes := $(wildcard $(DEPS))
+
+ifneq ($(dep_includes),)
+  include $(dep_includes)
+endif
+
+.PHONY: $(LIBTRACEEVENT_SHARED_SO) $(LIBTRACEEVENT_STATIC)
-- 
2.33.0

