Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:41690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbeK1NWm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 08:22:42 -0500
Date: Tue, 27 Nov 2018 21:22:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Cc: Slavomir Kaslev <kaslevs@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH] kernel-shark-qt: Have "make gui" build the Qt KernelShark
 version
Message-ID: <20181127212245.01c819b1@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


Now that the Qt version is the main version for KernelShark, have it be the
one that is built when passing in the target "gui".

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile         | 9 ++++++++-
 scripts/utils.mk | 2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 1e6fd5e7..d58ce0f2 100644
--- a/Makefile
+++ b/Makefile
@@ -161,6 +161,8 @@ objtree		:= $(BUILD_OUTPUT)
 src		:= $(srctree)
 obj		:= $(objtree)
 
+kshark-dir	= $(src)/kernel-shark-qt
+
 export prefix bindir src obj
 
 LIBS = -ldl
@@ -247,9 +249,13 @@ all: all_cmd plugins show_gui_make
 
 all_cmd: $(CMD_TARGETS)
 
+CMAKE_COMMAND = /usr/bin/cmake
+
 gui: force $(CMD_TARGETS)
-	$(Q)$(MAKE) -C $(src)/kernel-shark; \
+	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) ..
+	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
 	echo "gui build complete"
+	echo "  kernelshark located at $(kshark-dir)/bin"
 
 trace-cmd: force $(LIBTRACEEVENT_STATIC) $(LIBTRACECMD_STATIC)
 	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
@@ -356,6 +362,7 @@ clean:
 	$(MAKE) -C $(src)/lib/traceevent clean
 	$(MAKE) -C $(src)/lib/trace-cmd clean
 	$(MAKE) -C $(src)/kernel-shark clean
+	$(MAKE) -C $(kshark-dir)/build clean
 	$(MAKE) -C $(src)/plugins clean
 	$(MAKE) -C $(src)/python clean
 	$(MAKE) -C $(src)/tracecmd clean
diff --git a/scripts/utils.mk b/scripts/utils.mk
index ad31f6e4..f5feeca0 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -14,6 +14,7 @@ endif
 
 ifeq ($(VERBOSE),1)
   Q =
+  S =
   print_compile =
   print_app_build =
   print_fpic_compile =
@@ -23,6 +24,7 @@ ifeq ($(VERBOSE),1)
   print_install =
 else
   Q = @
+  S = -s
   print_compile =		echo '  $(GUI)COMPILE            '$(GOBJ);
   print_app_build =		echo '  $(GUI)BUILD              '$(GOBJ);
   print_fpic_compile =		echo '  $(GUI)COMPILE FPIC       '$(GOBJ);
-- 
2.19.1
