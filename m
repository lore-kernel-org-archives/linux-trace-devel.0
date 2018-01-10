Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f196.google.com ([209.85.128.196]:39163 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965900AbeAJP7A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 10:59:00 -0500
Received: by mail-wr0-f196.google.com with SMTP id z48so12101265wrz.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2018 07:59:00 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH 5/6] trace-cmd: Make the python targets buildable out-of-tree
Date: Wed, 10 Jan 2018 17:58:31 +0200
Message-Id: <20180110155832.15928-6-vladislav.valtchev@gmail.com>
In-Reply-To: <20180110155832.15928-1-vladislav.valtchev@gmail.com>
References: <20180110155832.15928-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch allows the python targets to be buildable out-of-tree when the 'O'
variable is set at command line while invoking make.

At this stage, when the 'O' variable is set, the out-of-tree build will fail
for some targets like 'gui' (as it *already* happens on the master branch):
with this patch the final goal of a fully working out-of-tree build gets closer.

In successive steps, the remaining Makefiles will be made to support
out-of-tree builds, until everything works.

NOTE: the regular in-tree build of all targets clearly continues to work.
Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile        |  4 ++--
 python/Makefile | 30 +++++++++++++++++-------------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/Makefile b/Makefile
index c42bea0..88f252e 100644
--- a/Makefile
+++ b/Makefile
@@ -375,10 +375,10 @@ export PYTHON_LDFLAGS
 export PYGTK_CFLAGS
 
 ctracecmd.so: force $(LIBTRACECMD_STATIC)
-	$(Q)$(MAKE) -C $(src)/python $@
+	$(Q)$(MAKE) -C $(src)/python $(obj)/python/ctracecmd.so
 
 ctracecmdgui.so: force $(LIBTRACECMD_STATIC) trace-view
-	$(Q)$(MAKE) -C $(src)/python $@
+	$(Q)$(MAKE) -C $(src)/python $(obj)/python/ctracecmdgui.so
 
 PHONY += python
 python: $(PYTHON)
diff --git a/python/Makefile b/python/Makefile
index b07c0d8..f8e7328 100644
--- a/python/Makefile
+++ b/python/Makefile
@@ -1,40 +1,44 @@
 include $(src)/scripts/utils.mk
 
+bdir:=$(obj)/python
+
 TRACE_VIEW_OBJS =
 TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view.o
 TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view-store.o
 
 ifdef BUILD_PYTHON_WORKS
-PYTHON_SO_INSTALL := ctracecmd.install
-PYTHON_PY_PROGS := event-viewer.install
-PYTHON_PY_LIBS := tracecmd.install tracecmdgui.install
+PYTHON_SO_INSTALL := $(bdir)/ctracecmd.install
+PYTHON_PY_PROGS := $(bdir)/event-viewer.install
+PYTHON_PY_LIBS := $(bdir)/tracecmd.install $(bdir)/tracecmdgui.install
 endif
 
-ctracecmd.so: ctracecmd.i $(LIBTRACECMD_STATIC)
+$(bdir)/ctracecmd.so: ctracecmd.i $(LIBTRACECMD_STATIC) | $(bdir)
 	swig -Wall -python -noproxy -I$(src)/include/traceevent -I$(src)/include/trace-cmd ctracecmd.i
-	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
-	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so
+	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES) -o $(bdir)/ctracecmd_wrap.o ctracecmd_wrap.c
+	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) $(bdir)/ctracecmd_wrap.o -o $(bdir)/ctracecmd.so
 
-ctracecmdgui.so: ctracecmdgui.i $(LIBTRACECMD_STATIC) $(TRACE_VIEW_OBJS)
+$(bdir)/ctracecmdgui.so: ctracecmdgui.i $(LIBTRACECMD_STATIC) $(TRACE_VIEW_OBJS) | $(bdir)
 	swig -Wall -python -noproxy -I$(src)/kernel-shark/include ctracecmdgui.i
-	$(CC) -fpic -c  $(CPPFLAGS) $(CFLAGS) $(INCLUDES) $(PYTHON_INCLUDES) $(PYGTK_CFLAGS) ctracecmdgui_wrap.c
-	$(CC) --shared $(TRACE_VIEW_OBJS) $(LIBTRACECMD_STATIC) $(LDFLAGS) $(LIBS) $(CONFIG_LIBS) ctracecmdgui_wrap.o -o ctracecmdgui.so
+	$(CC) -fpic -c  $(CPPFLAGS) $(CFLAGS) $(INCLUDES) $(PYTHON_INCLUDES) $(PYGTK_CFLAGS) -o $(bdir)/ctracecmdgui_wrap.o ctracecmdgui_wrap.c
+	$(CC) --shared $(TRACE_VIEW_OBJS) $(LIBTRACECMD_STATIC) $(LDFLAGS) $(LIBS) $(CONFIG_LIBS) $(bdir)/ctracecmdgui_wrap.o -o $(bdir)/ctracecmdgui.so
 
+$(bdir):
+	@mkdir -p $(bdir)
 
-$(PYTHON_SO_INSTALL): %.install : %.so force
+$(PYTHON_SO_INSTALL): $(bdir)/%.install : $(bdir)/%.so force
 	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
 
-$(PYTHON_PY_PROGS): %.install : %.py force
+$(PYTHON_PY_PROGS): $(bdir)/%.install : %.py force
 	$(Q)$(call do_install,$<,$(python_dir_SQ))
 
-$(PYTHON_PY_LIBS): %.install : %.py force
+$(PYTHON_PY_LIBS): $(bdir)/%.install : %.py force
 	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
 
 install_python: $(PYTHON_SO_INSTALL) $(PYTHON_PY_PROGS) $(PYTHON_PY_LIBS)
 
 
 clean:
-	$(RM) *.a *.so *.o .*.d ctracecmd_wrap.* ctracecmdgui_wrap.*
+	$(RM) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d $(bdir)/ctracecmd_wrap.* $(bdir)/ctracecmdgui_wrap.*
 
 force:
 .PHONY: clean force
-- 
2.14.1
