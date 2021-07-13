Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA238C07E9A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Jul 2021 01:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B15ED611F1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Jul 2021 01:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbhGMBXC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Jul 2021 21:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233797AbhGMBXB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Jul 2021 21:23:01 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72B6761158;
        Tue, 13 Jul 2021 01:20:12 +0000 (UTC)
Date:   Mon, 12 Jul 2021 21:20:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Cc:     John 'Warthog9' Hawley <warthog9@eaglescrag.net>
Subject: [PATCH] trace-cmd: KernelShark has left the nest
Message-ID: <20210712212005.2460a164@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

KernelShark 2.0 is out and now lives at:

   https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/

Users should not be using the version that lives in trace-cmd.git anymore.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                                      |   35 +-
 kernel-shark/.gitignore                       |   21 -
 kernel-shark/CMakeLists.txt                   |  116 --
 .../HTML/images/kernelshark-logo.svg          |    1 -
 .../Documentation/HTML/images/kernelshark.jpg |  Bin 54743 -> 0 bytes
 .../HTML/images/kshark-advance-filter-01.png  |  Bin 18693 -> 0 bytes
 .../HTML/images/kshark-advance-filter-02.png  |  Bin 36539 -> 0 bytes
 .../images/kshark-advance-filter-delete.png   |  Bin 23151 -> 0 bytes
 .../kshark-advance-filter-ext4-events.png     |  Bin 37093 -> 0 bytes
 .../images/kshark-advance-filter-ext4.png     |  Bin 23085 -> 0 bytes
 .../images/kshark-event-filter-dialog.png     |  Bin 31716 -> 0 bytes
 .../HTML/images/kshark-event-filter.png       |  Bin 292316 -> 0 bytes
 .../HTML/images/kshark-filter-menu.png        |  Bin 291366 -> 0 bytes
 .../HTML/images/kshark-graph-control-left.png |  Bin 3502 -> 0 bytes
 .../HTML/images/kshark-graph-control-line.png |  Bin 6422 -> 0 bytes
 .../images/kshark-graph-control-minus.png     |  Bin 2552 -> 0 bytes
 .../kshark-graph-control-minusminus.png       |  Bin 2744 -> 0 bytes
 .../HTML/images/kshark-graph-control-plus.png |  Bin 3251 -> 0 bytes
 .../images/kshark-graph-control-plusplus.png  |  Bin 4037 -> 0 bytes
 .../images/kshark-graph-control-right.png     |  Bin 3626 -> 0 bytes
 .../HTML/images/kshark-graph-info-line.png    |  Bin 9814 -> 0 bytes
 .../HTML/images/kshark-graph-plot-area.png    |  Bin 102128 -> 0 bytes
 .../HTML/images/kshark-graph-plot-title.png   |  Bin 3885 -> 0 bytes
 .../HTML/images/kshark-list-adjust.png        |  Bin 262029 -> 0 bytes
 .../HTML/images/kshark-list-graph-follow.png  |  Bin 255195 -> 0 bytes
 .../HTML/images/kshark-list-info-area.png     |  Bin 7451 -> 0 bytes
 .../Documentation/HTML/images/kshark-open.png |  Bin 243862 -> 0 bytes
 .../HTML/images/kshark-plot-cpu-1.png         |  Bin 10698 -> 0 bytes
 .../HTML/images/kshark-plot-cpu-2.png         |  Bin 11562 -> 0 bytes
 .../HTML/images/kshark-plot-cpu-result.png    |  Bin 249077 -> 0 bytes
 .../HTML/images/kshark-plot-menu.png          |  Bin 174240 -> 0 bytes
 .../kshark-plot-task-measure-preempt.png      |  Bin 200854 -> 0 bytes
 .../HTML/images/kshark-plot-task-measure.png  |  Bin 199879 -> 0 bytes
 .../HTML/images/kshark-plot-task-result.png   |  Bin 269824 -> 0 bytes
 .../HTML/images/kshark-plot-task-select.png   |  Bin 44873 -> 0 bytes
 .../HTML/images/kshark-plot-task-zoom-1.png   |  Bin 197157 -> 0 bytes
 .../HTML/images/kshark-select-a-1.png         |  Bin 168630 -> 0 bytes
 .../HTML/images/kshark-select-b-1.png         |  Bin 176819 -> 0 bytes
 .../HTML/images/kshark-task-filter-dialog.png |  Bin 29832 -> 0 bytes
 .../HTML/images/kshark-task-filter.png        |  Bin 174392 -> 0 bytes
 .../HTML/images/kshark-zoom-in-3.png          |  Bin 216450 -> 0 bytes
 .../HTML/images/kshark-zoom-in-select.png     |  Bin 247631 -> 0 bytes
 kernel-shark/Documentation/HTML/index.html    |  628 ------
 kernel-shark/Documentation/Makefile           |  108 -
 kernel-shark/Documentation/doxygen/dox_config |   16 -
 kernel-shark/Documentation/kernelshark.1.txt  |   46 -
 kernel-shark/README                           |  112 -
 kernel-shark/bin/kshark-su-record             |    5 -
 kernel-shark/build/FindJSONC.cmake            |   38 -
 kernel-shark/build/FindTraceCmd.cmake         |   95 -
 kernel-shark/build/cmake_clean.sh             |   13 -
 kernel-shark/build/cmake_uninstall.sh         |   17 -
 kernel-shark/build/deff.h.cmake               |   39 -
 kernel-shark/build/ks.desktop.cmake           |   10 -
 ...org.freedesktop.kshark-record.policy.cmake |   18 -
 kernel-shark/examples/CMakeLists.txt          |   33 -
 kernel-shark/examples/cmd_split.cpp           |   53 -
 kernel-shark/examples/configio.c              |   65 -
 kernel-shark/examples/datafilter.c            |  158 --
 kernel-shark/examples/datahisto.c             |  163 --
 kernel-shark/examples/dataload.c              |   91 -
 kernel-shark/examples/dataplot.cpp            |  237 ---
 kernel-shark/examples/widgetdemo.cpp          |  158 --
 kernel-shark/icons/CC_BY-4.0                  |  396 ----
 kernel-shark/icons/KS_icon_fin.svg            |    1 -
 kernel-shark/icons/KS_icon_shark.svg          |    1 -
 kernel-shark/icons/KS_logo_horizontal.svg     |    1 -
 kernel-shark/icons/KS_logo_stacked.svg        |    1 -
 kernel-shark/icons/KS_logo_symbol.svg         |    1 -
 kernel-shark/icons/ksharkicon.png             |  Bin 80474 -> 0 bytes
 kernel-shark/src/CMakeLists.txt               |  107 -
 kernel-shark/src/KsAdvFilteringDialog.cpp     |  440 ----
 kernel-shark/src/KsAdvFilteringDialog.hpp     |   91 -
 kernel-shark/src/KsCaptureDialog.cpp          |  636 ------
 kernel-shark/src/KsCaptureDialog.hpp          |  209 --
 kernel-shark/src/KsDualMarker.cpp             |  370 ----
 kernel-shark/src/KsDualMarker.hpp             |  232 ---
 kernel-shark/src/KsGLWidget.cpp               |  977 ---------
 kernel-shark/src/KsGLWidget.hpp               |  245 ---
 kernel-shark/src/KsMainWindow.cpp             | 1369 -------------
 kernel-shark/src/KsMainWindow.hpp             |  264 ---
 kernel-shark/src/KsModels.cpp                 |  558 -----
 kernel-shark/src/KsModels.hpp                 |  302 ---
 kernel-shark/src/KsPlotTools.cpp              | 1222 -----------
 kernel-shark/src/KsPlotTools.hpp              |  515 -----
 kernel-shark/src/KsPlugins.hpp                |   51 -
 kernel-shark/src/KsQuickContextMenu.cpp       |  324 ---
 kernel-shark/src/KsQuickContextMenu.hpp       |  148 --
 kernel-shark/src/KsSearchFSM.cpp              |  233 ---
 kernel-shark/src/KsSearchFSM.hpp              |  210 --
 kernel-shark/src/KsSession.cpp                |  600 ------
 kernel-shark/src/KsSession.hpp                |  102 -
 kernel-shark/src/KsTraceGraph.cpp             |  820 --------
 kernel-shark/src/KsTraceGraph.hpp             |  156 --
 kernel-shark/src/KsTraceViewer.cpp            |  837 --------
 kernel-shark/src/KsTraceViewer.hpp            |  173 --
 kernel-shark/src/KsUtils.cpp                  |  930 ---------
 kernel-shark/src/KsUtils.hpp                  |  273 ---
 kernel-shark/src/KsWidgetsLib.cpp             |  844 --------
 kernel-shark/src/KsWidgetsLib.hpp             |  358 ----
 kernel-shark/src/kernelshark.cpp              |  135 --
 kernel-shark/src/kshark-record.cpp            |   29 -
 kernel-shark/src/libkshark-collection.c       |  882 --------
 kernel-shark/src/libkshark-configio.c         | 1672 ---------------
 kernel-shark/src/libkshark-model.c            | 1307 ------------
 kernel-shark/src/libkshark-model.h            |  182 --
 kernel-shark/src/libkshark-plot.c             |  212 --
 kernel-shark/src/libkshark-plot.h             |   69 -
 kernel-shark/src/libkshark-plugin.c           |  295 ---
 kernel-shark/src/libkshark-plugin.h           |  179 --
 kernel-shark/src/libkshark.c                  | 1796 -----------------
 kernel-shark/src/libkshark.h                  |  650 ------
 kernel-shark/src/plugins/CMakeLists.txt       |   33 -
 kernel-shark/src/plugins/MissedEvents.cpp     |  149 --
 kernel-shark/src/plugins/SchedEvents.cpp      |  313 ---
 kernel-shark/src/plugins/missed_events.c      |   41 -
 kernel-shark/src/plugins/missed_events.h      |   30 -
 kernel-shark/src/plugins/sched_events.c       |  367 ----
 kernel-shark/src/plugins/sched_events.h       |   88 -
 119 files changed, 13 insertions(+), 24689 deletions(-)
 delete mode 100644 kernel-shark/.gitignore
 delete mode 100644 kernel-shark/CMakeLists.txt
 delete mode 100644 kernel-shark/Documentation/HTML/images/kernelshark-logo.svg
 delete mode 100644 kernel-shark/Documentation/HTML/images/kernelshark.jpg
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-advance-filter-01.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-advance-filter-02.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-advance-filter-delete.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-advance-filter-ext4-events.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-advance-filter-ext4.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-event-filter-dialog.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-event-filter.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-filter-menu.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-graph-control-left.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-graph-control-line.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-graph-control-minus.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-graph-control-minusminus.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-graph-control-plus.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-graph-control-plusplus.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-graph-control-right.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-graph-info-line.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-graph-plot-area.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-graph-plot-title.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-list-adjust.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-list-graph-follow.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-list-info-area.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-open.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-plot-cpu-1.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-plot-cpu-2.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-plot-cpu-result.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-plot-menu.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-plot-task-measure-preempt.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-plot-task-measure.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-plot-task-result.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-plot-task-select.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-plot-task-zoom-1.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-select-a-1.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-select-b-1.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-task-filter-dialog.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-task-filter.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-zoom-in-3.png
 delete mode 100644 kernel-shark/Documentation/HTML/images/kshark-zoom-in-select.png
 delete mode 100644 kernel-shark/Documentation/HTML/index.html
 delete mode 100644 kernel-shark/Documentation/Makefile
 delete mode 100644 kernel-shark/Documentation/doxygen/dox_config
 delete mode 100644 kernel-shark/Documentation/kernelshark.1.txt
 delete mode 100644 kernel-shark/README
 delete mode 100755 kernel-shark/bin/kshark-su-record
 delete mode 100644 kernel-shark/build/FindJSONC.cmake
 delete mode 100644 kernel-shark/build/FindTraceCmd.cmake
 delete mode 100755 kernel-shark/build/cmake_clean.sh
 delete mode 100755 kernel-shark/build/cmake_uninstall.sh
 delete mode 100644 kernel-shark/build/deff.h.cmake
 delete mode 100644 kernel-shark/build/ks.desktop.cmake
 delete mode 100644 kernel-shark/build/org.freedesktop.kshark-record.policy.cmake
 delete mode 100644 kernel-shark/examples/CMakeLists.txt
 delete mode 100644 kernel-shark/examples/cmd_split.cpp
 delete mode 100644 kernel-shark/examples/configio.c
 delete mode 100644 kernel-shark/examples/datafilter.c
 delete mode 100644 kernel-shark/examples/datahisto.c
 delete mode 100644 kernel-shark/examples/dataload.c
 delete mode 100644 kernel-shark/examples/dataplot.cpp
 delete mode 100644 kernel-shark/examples/widgetdemo.cpp
 delete mode 100644 kernel-shark/icons/CC_BY-4.0
 delete mode 100644 kernel-shark/icons/KS_icon_fin.svg
 delete mode 100644 kernel-shark/icons/KS_icon_shark.svg
 delete mode 100644 kernel-shark/icons/KS_logo_horizontal.svg
 delete mode 100644 kernel-shark/icons/KS_logo_stacked.svg
 delete mode 100644 kernel-shark/icons/KS_logo_symbol.svg
 delete mode 100644 kernel-shark/icons/ksharkicon.png
 delete mode 100644 kernel-shark/src/CMakeLists.txt
 delete mode 100644 kernel-shark/src/KsAdvFilteringDialog.cpp
 delete mode 100644 kernel-shark/src/KsAdvFilteringDialog.hpp
 delete mode 100644 kernel-shark/src/KsCaptureDialog.cpp
 delete mode 100644 kernel-shark/src/KsCaptureDialog.hpp
 delete mode 100644 kernel-shark/src/KsDualMarker.cpp
 delete mode 100644 kernel-shark/src/KsDualMarker.hpp
 delete mode 100644 kernel-shark/src/KsGLWidget.cpp
 delete mode 100644 kernel-shark/src/KsGLWidget.hpp
 delete mode 100644 kernel-shark/src/KsMainWindow.cpp
 delete mode 100644 kernel-shark/src/KsMainWindow.hpp
 delete mode 100644 kernel-shark/src/KsModels.cpp
 delete mode 100644 kernel-shark/src/KsModels.hpp
 delete mode 100644 kernel-shark/src/KsPlotTools.cpp
 delete mode 100644 kernel-shark/src/KsPlotTools.hpp
 delete mode 100644 kernel-shark/src/KsPlugins.hpp
 delete mode 100644 kernel-shark/src/KsQuickContextMenu.cpp
 delete mode 100644 kernel-shark/src/KsQuickContextMenu.hpp
 delete mode 100644 kernel-shark/src/KsSearchFSM.cpp
 delete mode 100644 kernel-shark/src/KsSearchFSM.hpp
 delete mode 100644 kernel-shark/src/KsSession.cpp
 delete mode 100644 kernel-shark/src/KsSession.hpp
 delete mode 100644 kernel-shark/src/KsTraceGraph.cpp
 delete mode 100644 kernel-shark/src/KsTraceGraph.hpp
 delete mode 100644 kernel-shark/src/KsTraceViewer.cpp
 delete mode 100644 kernel-shark/src/KsTraceViewer.hpp
 delete mode 100644 kernel-shark/src/KsUtils.cpp
 delete mode 100644 kernel-shark/src/KsUtils.hpp
 delete mode 100644 kernel-shark/src/KsWidgetsLib.cpp
 delete mode 100644 kernel-shark/src/KsWidgetsLib.hpp
 delete mode 100644 kernel-shark/src/kernelshark.cpp
 delete mode 100644 kernel-shark/src/kshark-record.cpp
 delete mode 100644 kernel-shark/src/libkshark-collection.c
 delete mode 100644 kernel-shark/src/libkshark-configio.c
 delete mode 100644 kernel-shark/src/libkshark-model.c
 delete mode 100644 kernel-shark/src/libkshark-model.h
 delete mode 100644 kernel-shark/src/libkshark-plot.c
 delete mode 100644 kernel-shark/src/libkshark-plot.h
 delete mode 100644 kernel-shark/src/libkshark-plugin.c
 delete mode 100644 kernel-shark/src/libkshark-plugin.h
 delete mode 100644 kernel-shark/src/libkshark.c
 delete mode 100644 kernel-shark/src/libkshark.h
 delete mode 100644 kernel-shark/src/plugins/CMakeLists.txt
 delete mode 100644 kernel-shark/src/plugins/MissedEvents.cpp
 delete mode 100644 kernel-shark/src/plugins/SchedEvents.cpp
 delete mode 100644 kernel-shark/src/plugins/missed_events.c
 delete mode 100644 kernel-shark/src/plugins/missed_events.h
 delete mode 100644 kernel-shark/src/plugins/sched_events.c
 delete mode 100644 kernel-shark/src/plugins/sched_events.h

diff --git a/Makefile b/Makefile
index b7783d60..d6fd09d8 100644
--- a/Makefile
+++ b/Makefile
@@ -355,11 +355,10 @@ CMD_TARGETS = trace-cmd $(BUILD_PYTHON)
 ###
 #    Default we just build trace-cmd
 #
-#    If you want kernelshark, then do:  make gui
 #    If you want all libraries, then do: make libs
 ###
 
-all: all_cmd plugins show_gui_make
+all: all_cmd plugins show_other_make
 
 all_cmd: $(CMD_TARGETS)
 
@@ -420,11 +419,11 @@ endef
 $(VERSION_FILE): force
 	$(Q)$(call update_version.h)
 
-gui: force $(CMD_TARGETS)
-	$(MAKE) $(kshark-dir)/build/Makefile
-	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
-	@echo "gui build complete"
-	@echo "  kernelshark located at $(kshark-dir)/bin"
+gui: force
+	@echo "***************************"
+	@echo "  KernelShark has moved!"
+	@echo "  Please use its new home at https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/"
+	@echo "***************************"
 
 test: force $(LIBTRACECMD_STATIC)
 ifneq ($(CUNIT_INSTALLED),1)
@@ -450,12 +449,11 @@ $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir: force
 $(obj)/lib/traceevent/plugins/trace_python_dir: force
 	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins $@
 
-show_gui_make:
-	@echo "Note: to build the gui, type \"make gui\""
-	@echo "      to build man pages, type \"make doc\""
+show_other_make:
+	@echo "Note: to build man pages, type \"make doc\""
 	@echo "      to build unit tests, type \"make test\""
 
-PHONY += show_gui_make
+PHONY += show_other_make
 
 define find_tag_files
 	find . -name '\.pc' -prune -o -name '*\.[ch]' -print -o -name '*\.[ch]pp' \
@@ -491,30 +489,23 @@ install_cmd: all_cmd install_plugins install_python install_bash_completion
 	$(Q)$(call do_install,$(obj)/tracecmd/trace-cmd,$(bindir_SQ))
 
 install: install_cmd
-	@echo "Note: to install the gui, type \"make install_gui\""
-	@echo "      to install man pages, type \"make install_doc\""
+	@echo "Note: to install man pages, type \"make install_doc\""
 
-install_gui: install_cmd gui
-	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build install
+install_gui: force
+	@echo "Nothing to do here."
+	@echo " Have you tried https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/"
 
 install_libs: libs
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/ $@
 
 doc:
 	$(MAKE) -C $(src)/Documentation all
-doc_gui:
-	$(MAKE) -C $(kshark-dir)/Documentation all
-
 
 doc_clean:
 	$(MAKE) -C $(src)/Documentation clean
-doc_gui_clean:
-	$(MAKE) -C $(kshark-dir)/Documentation clean
 
 install_doc:
 	$(MAKE) -C $(src)/Documentation install
-install_doc_gui:
-	$(MAKE) -C $(kshark-dir)/Documentation install
 
 clean:
 	$(RM) *.o *~ *.a *.so .*.d
diff --git a/kernel-shark/.gitignore b/kernel-shark/.gitignore
deleted file mode 100644
index 406436d7..00000000
diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
deleted file mode 100644
index a07c9ff2..00000000
diff --git a/kernel-shark/Documentation/HTML/images/kernelshark-logo.svg b/kernel-shark/Documentation/HTML/images/kernelshark-logo.svg
deleted file mode 100644
index bfe20017..00000000
diff --git a/kernel-shark/Documentation/HTML/images/kernelshark.jpg b/kernel-shark/Documentation/HTML/images/kernelshark.jpg
deleted file mode 100644
index 3c2b6dbc9e0026b9d20a536aca417e650a1c0c5d..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-advance-filter-01.png b/kernel-shark/Documentation/HTML/images/kshark-advance-filter-01.png
deleted file mode 100644
index aa6f037e43c78a9068a150dcf338517e7ec3680b..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-advance-filter-02.png b/kernel-shark/Documentation/HTML/images/kshark-advance-filter-02.png
deleted file mode 100644
index be99e58cbc09126591140b628542ec1a72fa77a7..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-advance-filter-delete.png b/kernel-shark/Documentation/HTML/images/kshark-advance-filter-delete.png
deleted file mode 100644
index 4bbf9967fdd1068ca4b3b13852d142f820453058..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-advance-filter-ext4-events.png b/kernel-shark/Documentation/HTML/images/kshark-advance-filter-ext4-events.png
deleted file mode 100644
index 230a9d4f5d0cc6bb98c5c82f6b902a79b5fb6a13..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-advance-filter-ext4.png b/kernel-shark/Documentation/HTML/images/kshark-advance-filter-ext4.png
deleted file mode 100644
index 1c834afc5b142918810b50b7e595a241e0ae3dc3..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-event-filter-dialog.png b/kernel-shark/Documentation/HTML/images/kshark-event-filter-dialog.png
deleted file mode 100644
index fbcb0554c83fee1ad246e09a6d811e46e52ea1a8..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-event-filter.png b/kernel-shark/Documentation/HTML/images/kshark-event-filter.png
deleted file mode 100644
index 9a34659d55bf9df1e1ba82b0230d17b31023c58b..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-filter-menu.png b/kernel-shark/Documentation/HTML/images/kshark-filter-menu.png
deleted file mode 100644
index cf0c6d8cb4527df4fc6cd682a358354a99306435..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-graph-control-left.png b/kernel-shark/Documentation/HTML/images/kshark-graph-control-left.png
deleted file mode 100644
index 6dc1820c3ad5de28e4345d0a1229533927d8c7d5..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-graph-control-line.png b/kernel-shark/Documentation/HTML/images/kshark-graph-control-line.png
deleted file mode 100644
index a5bcb0f0c170c76499e809afecb9fccc3c4b9dfe..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-graph-control-minus.png b/kernel-shark/Documentation/HTML/images/kshark-graph-control-minus.png
deleted file mode 100644
index 97dc4bc6ed377855283fcec4345dd1e1a4cae259..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-graph-control-minusminus.png b/kernel-shark/Documentation/HTML/images/kshark-graph-control-minusminus.png
deleted file mode 100644
index 804172ebd1504d45ec8c759657928f743303e6db..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-graph-control-plus.png b/kernel-shark/Documentation/HTML/images/kshark-graph-control-plus.png
deleted file mode 100644
index 3c8c20dd1a0c1495c65be0eeeaead1f2a8130d54..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-graph-control-plusplus.png b/kernel-shark/Documentation/HTML/images/kshark-graph-control-plusplus.png
deleted file mode 100644
index ff7a64e06be38d511576fc434bbeac9d372df07f..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-graph-control-right.png b/kernel-shark/Documentation/HTML/images/kshark-graph-control-right.png
deleted file mode 100644
index 94b5b8c6ed4a44f8633c638e1458160ba0778eb4..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-graph-info-line.png b/kernel-shark/Documentation/HTML/images/kshark-graph-info-line.png
deleted file mode 100644
index fcf3b4315f46d7f0df43bedc63c40466ca82a06f..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-graph-plot-area.png b/kernel-shark/Documentation/HTML/images/kshark-graph-plot-area.png
deleted file mode 100644
index 1edf7dda5da42692d4fe75050b1f7b01a7737538..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-graph-plot-title.png b/kernel-shark/Documentation/HTML/images/kshark-graph-plot-title.png
deleted file mode 100644
index b5944714f6d31b13972d6042d89819772e13ea9a..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-list-adjust.png b/kernel-shark/Documentation/HTML/images/kshark-list-adjust.png
deleted file mode 100644
index 92a8f11062ada41d1db42386f1a362be3d91c640..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-list-graph-follow.png b/kernel-shark/Documentation/HTML/images/kshark-list-graph-follow.png
deleted file mode 100644
index 3404f0c519c0789b8424004f6517e1705a4e8d30..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-list-info-area.png b/kernel-shark/Documentation/HTML/images/kshark-list-info-area.png
deleted file mode 100644
index b121040d12a7423edf277ad8870c16796b3047a1..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-open.png b/kernel-shark/Documentation/HTML/images/kshark-open.png
deleted file mode 100644
index 461e833445a40e512493bdfc98e119c113cfd487..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-plot-cpu-1.png b/kernel-shark/Documentation/HTML/images/kshark-plot-cpu-1.png
deleted file mode 100644
index 24de1bc2469e98348f8ce71ebb32e174bd43bd17..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-plot-cpu-2.png b/kernel-shark/Documentation/HTML/images/kshark-plot-cpu-2.png
deleted file mode 100644
index d430a4b5bf8aab23f560fca3a05d4f35ae11fb1a..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-plot-cpu-result.png b/kernel-shark/Documentation/HTML/images/kshark-plot-cpu-result.png
deleted file mode 100644
index e44aff49a751f2d00b078fa8d2779f30e32bda63..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-plot-menu.png b/kernel-shark/Documentation/HTML/images/kshark-plot-menu.png
deleted file mode 100644
index 0676266be5994515e9616128cd97ba39e896bd64..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-plot-task-measure-preempt.png b/kernel-shark/Documentation/HTML/images/kshark-plot-task-measure-preempt.png
deleted file mode 100644
index d430aa425570aad04e9a0102c2b11b8c7ca8ab1a..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-plot-task-measure.png b/kernel-shark/Documentation/HTML/images/kshark-plot-task-measure.png
deleted file mode 100644
index f7a23b4e558f3b501c5dc83b5d6b8609f8d4b262..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-plot-task-result.png b/kernel-shark/Documentation/HTML/images/kshark-plot-task-result.png
deleted file mode 100644
index 54937c032ad1665894a632567ce80dac6ef85990..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-plot-task-select.png b/kernel-shark/Documentation/HTML/images/kshark-plot-task-select.png
deleted file mode 100644
index c3d63df4c20563311d4197e31ec4c4a093afad79..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-plot-task-zoom-1.png b/kernel-shark/Documentation/HTML/images/kshark-plot-task-zoom-1.png
deleted file mode 100644
index 2c13b5036d3b88adde0b724593318d4b5b4d8fc6..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-select-a-1.png b/kernel-shark/Documentation/HTML/images/kshark-select-a-1.png
deleted file mode 100644
index 353c0c8e72c750289e504f0d781a7545828ef931..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-select-b-1.png b/kernel-shark/Documentation/HTML/images/kshark-select-b-1.png
deleted file mode 100644
index d5b137f329010c7f8fb65c46baee20c941fb43c6..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-task-filter-dialog.png b/kernel-shark/Documentation/HTML/images/kshark-task-filter-dialog.png
deleted file mode 100644
index 06c229bd3c75b8fe74014bd3ff07d0f67d1560c7..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-task-filter.png b/kernel-shark/Documentation/HTML/images/kshark-task-filter.png
deleted file mode 100644
index 2e90e4b65d002bbda62453c99297a5dc6bd5b521..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-zoom-in-3.png b/kernel-shark/Documentation/HTML/images/kshark-zoom-in-3.png
deleted file mode 100644
index 9eee7eafc37b042674d9f40f9e7ed1b140cb2e50..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/images/kshark-zoom-in-select.png b/kernel-shark/Documentation/HTML/images/kshark-zoom-in-select.png
deleted file mode 100644
index ad3c573318adb5c1228683e1c78fe4ddb77fbcc1..0000000000000000000000000000000000000000
diff --git a/kernel-shark/Documentation/HTML/index.html b/kernel-shark/Documentation/HTML/index.html
deleted file mode 100644
index 7dac810b..00000000
diff --git a/kernel-shark/Documentation/Makefile b/kernel-shark/Documentation/Makefile
deleted file mode 100644
index 4bb4fe3e..00000000
diff --git a/kernel-shark/Documentation/doxygen/dox_config b/kernel-shark/Documentation/doxygen/dox_config
deleted file mode 100644
index 89b92842..00000000
diff --git a/kernel-shark/Documentation/kernelshark.1.txt b/kernel-shark/Documentation/kernelshark.1.txt
deleted file mode 100644
index 6a217dd1..00000000
diff --git a/kernel-shark/README b/kernel-shark/README
deleted file mode 100644
index 6c360bb1..00000000
diff --git a/kernel-shark/bin/kshark-su-record b/kernel-shark/bin/kshark-su-record
deleted file mode 100755
index 70d781d8..00000000
diff --git a/kernel-shark/build/FindJSONC.cmake b/kernel-shark/build/FindJSONC.cmake
deleted file mode 100644
index 3bae20fa..00000000
diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
deleted file mode 100644
index a40f70e5..00000000
diff --git a/kernel-shark/build/cmake_clean.sh b/kernel-shark/build/cmake_clean.sh
deleted file mode 100755
index 2e7c8f94..00000000
diff --git a/kernel-shark/build/cmake_uninstall.sh b/kernel-shark/build/cmake_uninstall.sh
deleted file mode 100755
index ae9eab5b..00000000
diff --git a/kernel-shark/build/deff.h.cmake b/kernel-shark/build/deff.h.cmake
deleted file mode 100644
index 79726ff6..00000000
diff --git a/kernel-shark/build/ks.desktop.cmake b/kernel-shark/build/ks.desktop.cmake
deleted file mode 100644
index 2b02c0db..00000000
diff --git a/kernel-shark/build/org.freedesktop.kshark-record.policy.cmake b/kernel-shark/build/org.freedesktop.kshark-record.policy.cmake
deleted file mode 100644
index 988db782..00000000
diff --git a/kernel-shark/examples/CMakeLists.txt b/kernel-shark/examples/CMakeLists.txt
deleted file mode 100644
index 032f3057..00000000
diff --git a/kernel-shark/examples/cmd_split.cpp b/kernel-shark/examples/cmd_split.cpp
deleted file mode 100644
index b8cc1b59..00000000
diff --git a/kernel-shark/examples/configio.c b/kernel-shark/examples/configio.c
deleted file mode 100644
index faa116a1..00000000
diff --git a/kernel-shark/examples/datafilter.c b/kernel-shark/examples/datafilter.c
deleted file mode 100644
index bebc1813..00000000
diff --git a/kernel-shark/examples/datahisto.c b/kernel-shark/examples/datahisto.c
deleted file mode 100644
index b177b088..00000000
diff --git a/kernel-shark/examples/dataload.c b/kernel-shark/examples/dataload.c
deleted file mode 100644
index 15c5de05..00000000
diff --git a/kernel-shark/examples/dataplot.cpp b/kernel-shark/examples/dataplot.cpp
deleted file mode 100644
index 94841e79..00000000
diff --git a/kernel-shark/examples/widgetdemo.cpp b/kernel-shark/examples/widgetdemo.cpp
deleted file mode 100644
index 73049bfe..00000000
diff --git a/kernel-shark/icons/CC_BY-4.0 b/kernel-shark/icons/CC_BY-4.0
deleted file mode 100644
index da6ab6cc..00000000
diff --git a/kernel-shark/icons/KS_icon_fin.svg b/kernel-shark/icons/KS_icon_fin.svg
deleted file mode 100644
index eeec165d..00000000
diff --git a/kernel-shark/icons/KS_icon_shark.svg b/kernel-shark/icons/KS_icon_shark.svg
deleted file mode 100644
index 9ec75485..00000000
diff --git a/kernel-shark/icons/KS_logo_horizontal.svg b/kernel-shark/icons/KS_logo_horizontal.svg
deleted file mode 100644
index 7ffce3d9..00000000
diff --git a/kernel-shark/icons/KS_logo_stacked.svg b/kernel-shark/icons/KS_logo_stacked.svg
deleted file mode 100644
index 10e6fd8a..00000000
diff --git a/kernel-shark/icons/KS_logo_symbol.svg b/kernel-shark/icons/KS_logo_symbol.svg
deleted file mode 100644
index 4bf03400..00000000
diff --git a/kernel-shark/icons/ksharkicon.png b/kernel-shark/icons/ksharkicon.png
deleted file mode 100644
index 4c835d768abfb71918902b6109a71fc905a5596b..0000000000000000000000000000000000000000
diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
deleted file mode 100644
index 457c1007..00000000
diff --git a/kernel-shark/src/KsAdvFilteringDialog.cpp b/kernel-shark/src/KsAdvFilteringDialog.cpp
deleted file mode 100644
index 8dc53bb6..00000000
diff --git a/kernel-shark/src/KsAdvFilteringDialog.hpp b/kernel-shark/src/KsAdvFilteringDialog.hpp
deleted file mode 100644
index 2a534d0e..00000000
diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
deleted file mode 100644
index 7253ab68..00000000
diff --git a/kernel-shark/src/KsCaptureDialog.hpp b/kernel-shark/src/KsCaptureDialog.hpp
deleted file mode 100644
index 3fd3d8d7..00000000
diff --git a/kernel-shark/src/KsDualMarker.cpp b/kernel-shark/src/KsDualMarker.cpp
deleted file mode 100644
index 90c5373c..00000000
diff --git a/kernel-shark/src/KsDualMarker.hpp b/kernel-shark/src/KsDualMarker.hpp
deleted file mode 100644
index 597bddb2..00000000
diff --git a/kernel-shark/src/KsGLWidget.cpp b/kernel-shark/src/KsGLWidget.cpp
deleted file mode 100644
index 404f0d0e..00000000
diff --git a/kernel-shark/src/KsGLWidget.hpp b/kernel-shark/src/KsGLWidget.hpp
deleted file mode 100644
index c6fd7870..00000000
diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
deleted file mode 100644
index fc4e9a94..00000000
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
deleted file mode 100644
index 2fac1075..00000000
diff --git a/kernel-shark/src/KsModels.cpp b/kernel-shark/src/KsModels.cpp
deleted file mode 100644
index 51a7b79f..00000000
diff --git a/kernel-shark/src/KsModels.hpp b/kernel-shark/src/KsModels.hpp
deleted file mode 100644
index d360ad66..00000000
diff --git a/kernel-shark/src/KsPlotTools.cpp b/kernel-shark/src/KsPlotTools.cpp
deleted file mode 100644
index fe3008ed..00000000
diff --git a/kernel-shark/src/KsPlotTools.hpp b/kernel-shark/src/KsPlotTools.hpp
deleted file mode 100644
index ee447f1c..00000000
diff --git a/kernel-shark/src/KsPlugins.hpp b/kernel-shark/src/KsPlugins.hpp
deleted file mode 100644
index 3955cdfd..00000000
diff --git a/kernel-shark/src/KsQuickContextMenu.cpp b/kernel-shark/src/KsQuickContextMenu.cpp
deleted file mode 100644
index a84444ee..00000000
diff --git a/kernel-shark/src/KsQuickContextMenu.hpp b/kernel-shark/src/KsQuickContextMenu.hpp
deleted file mode 100644
index df8a65b2..00000000
diff --git a/kernel-shark/src/KsSearchFSM.cpp b/kernel-shark/src/KsSearchFSM.cpp
deleted file mode 100644
index 6a93ca72..00000000
diff --git a/kernel-shark/src/KsSearchFSM.hpp b/kernel-shark/src/KsSearchFSM.hpp
deleted file mode 100644
index 6a01d61d..00000000
diff --git a/kernel-shark/src/KsSession.cpp b/kernel-shark/src/KsSession.cpp
deleted file mode 100644
index a581bbf1..00000000
diff --git a/kernel-shark/src/KsSession.hpp b/kernel-shark/src/KsSession.hpp
deleted file mode 100644
index b07c8106..00000000
diff --git a/kernel-shark/src/KsTraceGraph.cpp b/kernel-shark/src/KsTraceGraph.cpp
deleted file mode 100644
index 7b656c0d..00000000
diff --git a/kernel-shark/src/KsTraceGraph.hpp b/kernel-shark/src/KsTraceGraph.hpp
deleted file mode 100644
index 15ade425..00000000
diff --git a/kernel-shark/src/KsTraceViewer.cpp b/kernel-shark/src/KsTraceViewer.cpp
deleted file mode 100644
index 0e0e3d4e..00000000
diff --git a/kernel-shark/src/KsTraceViewer.hpp b/kernel-shark/src/KsTraceViewer.hpp
deleted file mode 100644
index 6080d0dc..00000000
diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
deleted file mode 100644
index 24f7178a..00000000
diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
deleted file mode 100644
index 2772b84e..00000000
diff --git a/kernel-shark/src/KsWidgetsLib.cpp b/kernel-shark/src/KsWidgetsLib.cpp
deleted file mode 100644
index a84aff3b..00000000
diff --git a/kernel-shark/src/KsWidgetsLib.hpp b/kernel-shark/src/KsWidgetsLib.hpp
deleted file mode 100644
index 59e773d0..00000000
diff --git a/kernel-shark/src/kernelshark.cpp b/kernel-shark/src/kernelshark.cpp
deleted file mode 100644
index 0de80af6..00000000
diff --git a/kernel-shark/src/kshark-record.cpp b/kernel-shark/src/kshark-record.cpp
deleted file mode 100644
index 7d10469a..00000000
diff --git a/kernel-shark/src/libkshark-collection.c b/kernel-shark/src/libkshark-collection.c
deleted file mode 100644
index 66cdbca8..00000000
diff --git a/kernel-shark/src/libkshark-configio.c b/kernel-shark/src/libkshark-configio.c
deleted file mode 100644
index cb7ca54b..00000000
diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
deleted file mode 100644
index babac2a2..00000000
diff --git a/kernel-shark/src/libkshark-model.h b/kernel-shark/src/libkshark-model.h
deleted file mode 100644
index 47793b11..00000000
diff --git a/kernel-shark/src/libkshark-plot.c b/kernel-shark/src/libkshark-plot.c
deleted file mode 100644
index 17d3b903..00000000
diff --git a/kernel-shark/src/libkshark-plot.h b/kernel-shark/src/libkshark-plot.h
deleted file mode 100644
index 9a4dbc02..00000000
diff --git a/kernel-shark/src/libkshark-plugin.c b/kernel-shark/src/libkshark-plugin.c
deleted file mode 100644
index 4b21392a..00000000
diff --git a/kernel-shark/src/libkshark-plugin.h b/kernel-shark/src/libkshark-plugin.h
deleted file mode 100644
index b3cf1c62..00000000
diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
deleted file mode 100644
index e51a2587..00000000
diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
deleted file mode 100644
index a9cba054..00000000
diff --git a/kernel-shark/src/plugins/CMakeLists.txt b/kernel-shark/src/plugins/CMakeLists.txt
deleted file mode 100644
index 6c771792..00000000
diff --git a/kernel-shark/src/plugins/MissedEvents.cpp b/kernel-shark/src/plugins/MissedEvents.cpp
deleted file mode 100644
index 05dfcb5b..00000000
diff --git a/kernel-shark/src/plugins/SchedEvents.cpp b/kernel-shark/src/plugins/SchedEvents.cpp
deleted file mode 100644
index 84086573..00000000
diff --git a/kernel-shark/src/plugins/missed_events.c b/kernel-shark/src/plugins/missed_events.c
deleted file mode 100644
index cf652bfc..00000000
diff --git a/kernel-shark/src/plugins/missed_events.h b/kernel-shark/src/plugins/missed_events.h
deleted file mode 100644
index e05d79a1..00000000
diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
deleted file mode 100644
index 4b671f16..00000000
diff --git a/kernel-shark/src/plugins/sched_events.h b/kernel-shark/src/plugins/sched_events.h
deleted file mode 100644
index dbc9963c..00000000
-- 
2.31.1

