Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4611C2BB40
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B29A923C82
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgLJCbH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 21:31:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbgLJCbH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 21:31:07 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1374823D22;
        Thu, 10 Dec 2020 02:29:45 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knBiB-0004BH-Vy; Wed, 09 Dec 2020 21:29:44 -0500
Message-ID: <20201210022943.863999811@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 09 Dec 2020 21:29:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 7/9] trace-cmd: Use system trace libraries, if available
References: <20201210022906.112066412@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

Check if libtraceevent and libtracefs are installed in the system and
use them, otherwise build and use the local implementations.

Link: https://lore.kernel.org/linux-trace-devel/20201126072707.906347-1-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                | 40 ++++++++++++++++++++++++++++------------
 lib/traceevent/Makefile |  2 ++
 lib/tracefs/Makefile    |  2 ++
 tracecmd/Makefile       |  6 ++++--
 4 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/Makefile b/Makefile
index 8626b91bf653..c6cdeeaef46d 100644
--- a/Makefile
+++ b/Makefile
@@ -191,6 +191,8 @@ export prefix bindir src obj kshark-dir
 
 LIBS = -ldl
 
+
+LIBTRACEEVENT=libtraceevent
 LIBTRACEEVENT_DIR = $(obj)/lib/traceevent
 LIBTRACEEVENT_STATIC = $(LIBTRACEEVENT_DIR)/libtraceevent.a
 LIBTRACEEVENT_SHARED = $(LIBTRACEEVENT_DIR)/libtraceevent.so
@@ -199,35 +201,48 @@ LIBTRACECMD_DIR = $(obj)/lib/trace-cmd
 LIBTRACECMD_STATIC = $(LIBTRACECMD_DIR)/libtracecmd.a
 LIBTRACECMD_SHARED = $(LIBTRACECMD_DIR)/libtracecmd.so
 
+LIBTRACEFS=libtracefs
 LIBTRACEFS_DIR = $(obj)/lib/tracefs
 LIBTRACEFS_STATIC = $(LIBTRACEFS_DIR)/libtracefs.a
 LIBTRACEFS_SHARED = $(LIBTRACEFS_DIR)/libtracefs.so
 
-TRACE_LIBS = -L$(LIBTRACECMD_DIR) -ltracecmd		\
-	     -L$(LIBTRACEEVENT_DIR) -ltraceevent	\
-	     -L$(LIBTRACEFS_DIR) -ltracefs
+ifeq ($(shell sh -c "pkg-config --cflags $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y"), y)
+LIBTRACEEVENT_CFLAGS = $(shell sh -c "pkg-config --cflags $(LIBTRACEEVENT)")
+LIBTRACEEVENT_LDLAGS = $(shell sh -c "pkg-config --libs $(LIBTRACEEVENT)")
+else
+LIBTRACEEVENT_CFLAGS = -I$(src)/include/traceevent -I$(src)/lib/traceevent/include
+LIBTRACEEVENT_LDLAGS = -L$(LIBTRACEEVENT_DIR) -ltraceevent
+LIBTRACEEVENT_STATIC_BUILD = $(LIBTRACEEVENT_STATIC)
+endif
+
+ifeq ($(shell sh -c "pkg-config --cflags $(LIBTRACEFS) > /dev/null 2>&1 && echo y"), y)
+LIBTRACEFS_CFLAGS = $(shell sh -c "pkg-config --cflags $(LIBTRACEFS)")
+LIBTRACEFS_LDLAGS = $(shell sh -c "pkg-config --libs $(LIBTRACEFS)")
+else
+LIBTRACEFS_CFLAGS = -I$(src)/include/tracefs
+LIBTRACEFS_LDLAGS = -L$(LIBTRACEFS_DIR) -ltracefs
+LIBTRACEFS_STATIC_BUILD = $(LIBTRACEFS_STATIC)
+endif
+
+
+TRACE_LIBS = -L$(LIBTRACECMD_DIR) -ltracecmd	\
+	     $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS)
 
 export LIBS TRACE_LIBS
 export LIBTRACEEVENT_DIR LIBTRACECMD_DIR LIBTRACEFS_DIR
 export LIBTRACECMD_STATIC LIBTRACECMD_SHARED
-export LIBTRACEEVENT_STATIC LIBTRACEEVENT_SHARED
-export LIBTRACEFS_STATIC LIBTRACEFS_SHARED
-
 export Q SILENT VERBOSE EXT
 
 # Include the utils
 include scripts/utils.mk
 
 INCLUDES = -I$(src)/include -I$(src)/../../include
-INCLUDES += -I$(src)/include/traceevent
 INCLUDES += -I$(src)/include/trace-cmd
-INCLUDES += -I$(src)/include/tracefs
-INCLUDES += -I$(src)/lib/traceevent/include
 INCLUDES += -I$(src)/lib/trace-cmd/include
 INCLUDES += -I$(src)/lib/trace-cmd/include/private
-INCLUDES += -I$(src)/lib/tracefs/include
 INCLUDES += -I$(src)/tracecmd/include
-INCLUDES += -I$(obj)/tracecmd/include
+INCLUDES += $(LIBTRACEEVENT_CFLAGS)
+INCLUDES += $(LIBTRACEFS_CFLAGS)
 
 include $(src)/features.mk
 
@@ -288,6 +303,7 @@ CMD_TARGETS = trace-cmd $(BUILD_PYTHON)
 #    Default we just build trace-cmd
 #
 #    If you want kernelshark, then do:  make gui
+#    If you want all libraries, then do: make libs
 ###
 
 all: all_cmd plugins show_gui_make
@@ -309,7 +325,7 @@ gui: force
 	@echo "gui build complete"
 	@echo "  kernelshark located at $(kshark-dir)/bin"
 
-trace-cmd: force $(LIBTRACEEVENT_STATIC) $(LIBTRACECMD_STATIC) $(LIBTRACEFS_STATIC) \
+trace-cmd: force $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACECMD_STATIC) $(LIBTRACEFS_STATIC_BUILD) \
 	force $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir
 	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
 
diff --git a/lib/traceevent/Makefile b/lib/traceevent/Makefile
index d0666911766d..c7f7cda07c91 100644
--- a/lib/traceevent/Makefile
+++ b/lib/traceevent/Makefile
@@ -6,6 +6,8 @@ bdir:=$(obj)/lib/traceevent
 
 DEFAULT_TARGET = $(bdir)/libtraceevent.a
 
+CFLAGS += -I$(bdir)/include
+
 OBJS =
 OBJS += event-parse.o
 OBJS += event-plugin.o
diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
index cbcce36288d9..895195172ffe 100644
--- a/lib/tracefs/Makefile
+++ b/lib/tracefs/Makefile
@@ -6,6 +6,8 @@ bdir:=$(obj)/lib/tracefs
 
 DEFAULT_TARGET = $(bdir)/libtracefs.a
 
+CFLAGS += -I$(bdir)/include
+
 OBJS =
 OBJS += tracefs-utils.o
 OBJS += tracefs-instance.o
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 01f36c617eb4..de14176e2654 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -11,6 +11,8 @@ TARGETS = $(bdir)/trace-cmd $(TC_VERSION)
 BUILDGUI := 0
 include $(src)/scripts/utils.mk
 
+CFLAGS += -I$(bdir)/include
+
 TRACE_CMD_OBJS =
 TRACE_CMD_OBJS += trace-cmd.o
 TRACE_CMD_OBJS += trace-record.o
@@ -47,7 +49,7 @@ all_objs := $(sort $(ALL_OBJS))
 all_deps := $(all_objs:$(bdir)/%.o=$(bdir)/.%.d)
 
 CONFIG_INCLUDES =
-CONFIG_LIBS	= -lrt -lpthread
+CONFIG_LIBS	= -lrt -lpthread $(TRACE_LIBS)
 CONFIG_FLAGS	=
 
 all: $(TARGETS)
@@ -67,7 +69,7 @@ $(all_objs): | $(bdir)
 $(bdir)/trace-cmd: $(ALL_OBJS)
 	$(Q)$(do_app_build)
 
-$(bdir)/trace-cmd: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC) $(LIBTRACEFS_STATIC)
+$(bdir)/trace-cmd: $(LIBTRACECMD_STATIC)
 
 $(bdir)/%.o: %.c
 	$(Q)$(call do_compile)
-- 
2.29.2


