Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F0DC4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4429123719
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbgLPXXI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 18:23:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbgLPXXH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 18:23:07 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E74E8239A4;
        Wed, 16 Dec 2020 23:21:46 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpg77-000xIJ-US; Wed, 16 Dec 2020 18:21:45 -0500
Message-ID: <20201216232145.792726583@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 18:19:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/6 v2] kernelshark: Build libtraceevent and libtracefs locally
References: <20201216231942.127326802@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

kernelshark v1 is now frozen in favor of developing kernelshark v2. Do not
use the system libraries libtraceevent or libtracefs for kernelshark v1, as
they may not be suitable. Use the frozen libtraceevent and libtracefs that
is in the local repository.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                | 24 ++++++++++++++++--------
 lib/traceevent/Makefile |  2 ++
 lib/tracefs/Makefile    |  3 +++
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index 662d24ba288f..7aef50b34a56 100644
--- a/Makefile
+++ b/Makefile
@@ -354,19 +354,14 @@ $(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template $(BUILD_PREFIX)
 $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
 	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) -D_LIBDIR=$(libdir) ..
 
-gui: force
-	$(MAKE) $(CMD_TARGETS)
-	$(MAKE) $(kshark-dir)/build/Makefile
-	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
-	@echo "gui build complete"
-	@echo "  kernelshark located at $(kshark-dir)/bin"
-
 trace-cmd: force $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACECMD_STATIC) $(LIBTRACEFS_STATIC_BUILD) \
 	force $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir
 	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
 
-$(LIBTRACEEVENT_STATIC): force $(obj)/lib/traceevent/plugins/trace_python_dir \
+LIBTRACEEVENT_DEPENDS = $(obj)/lib/traceevent/plugins/trace_python_dir \
 			 $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
+
+$(LIBTRACEEVENT_STATIC): force $(LIBTRACEEVENT_DEPENDS)
 	$(Q)$(MAKE) -C $(src)/lib/traceevent libtraceevent
 
 $(LIBTRACECMD_STATIC): force
@@ -385,6 +380,19 @@ libtracefs.a: $(LIBTRACEFS_STATIC)
 
 libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACEFS_STATIC_BUILD) $(PKG_CONFIG_FILE)
 
+libtraceevent_nowarn: $(LIBTRACEEVENT_DEPENDS)
+	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
+
+libtracefs_nowarn: force
+	$(Q)$(MAKE) -C $(src)/lib/tracefs $@
+
+
+gui: force $(CMD_TARGETS) libtraceevent_nowarn libtracefs_nowarn
+	$(MAKE) $(kshark-dir)/build/Makefile
+	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
+	@echo "gui build complete"
+	@echo "  kernelshark located at $(kshark-dir)/bin"
+
 test: force $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACEFS_STATIC_BUILD) $(LIBTRACECMD_STATIC)
 ifneq ($(CUNIT_INSTALLED),1)
 	$(error CUnit framework not installed, cannot build unit tests))
diff --git a/lib/traceevent/Makefile b/lib/traceevent/Makefile
index 21ef5a4ea59f..21eaffd21f7a 100644
--- a/lib/traceevent/Makefile
+++ b/lib/traceevent/Makefile
@@ -50,6 +50,8 @@ $(bdir)/libtraceevent.a: $(OBJS)
 
 libtraceevent: $(bdir)/libtraceevent.a warning
 
+libtraceevent_nowarn: $(bdir)/libtraceevent.a
+
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
index 6f4370d96f10..74cb8829979f 100644
--- a/lib/tracefs/Makefile
+++ b/lib/tracefs/Makefile
@@ -47,6 +47,9 @@ $(bdir)/libtracefs.a: $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
 libtracefs: $(bdir)/libtracefs.a warning
+
+libtracefs_nowarn: $(bdir)/libtracefs.a
+
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
-- 
2.29.2


