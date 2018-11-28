Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:47980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727979AbeK2D0z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 22:26:55 -0500
Date: Wed, 28 Nov 2018 11:24:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Cc: Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH] kernel-shark-qt: Have "make install_gui" install the Qt
 KernelShark version
Message-ID: <20181128112440.37475030@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


Now that the Qt version is the main version for KernelShark, have it be the
one that is installed when passing in the target "install_gui".

Suggested-by: Yordan Karadzhov <ykaradzhov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index d58ce0f2..7ee9e0d0 100644
--- a/Makefile
+++ b/Makefile
@@ -251,8 +251,10 @@ all_cmd: $(CMD_TARGETS)
 
 CMAKE_COMMAND = /usr/bin/cmake
 
-gui: force $(CMD_TARGETS)
+$(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
 	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) ..
+
+gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
 	echo "gui build complete"
 	echo "  kernelshark located at $(kshark-dir)/bin"
@@ -337,9 +339,7 @@ install: install_cmd
 	@echo "      to install man pages, type \"make install_doc\""
 
 install_gui: install_cmd gui
-	$(Q)$(call do_install,$(obj)/kernel-shark/trace-view,$(bindir_SQ))
-	$(Q)$(call do_install,$(obj)/kernel-shark/trace-graph,$(bindir_SQ))
-	$(Q)$(call do_install,$(obj)/kernel-shark/kernelshark,$(bindir_SQ))
+	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build install
 
 install_libs: libs
 	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
-- 
2.19.1
