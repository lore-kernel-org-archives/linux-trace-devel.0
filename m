Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C013C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhLQFuz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbhLQFux (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:50:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1B9C06173E
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:50:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3236CCE23F1
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A0EC36AEB;
        Fri, 17 Dec 2021 05:50:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my68h-000578-J1;
        Fri, 17 Dec 2021 00:50:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 13/15] libtracefs: Build in the same directories as the source
Date:   Fri, 17 Dec 2021 00:50:39 -0500
Message-Id: <20211217055041.19559-14-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217055041.19559-1-rostedt@goodmis.org>
References: <20211217055041.19559-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Modify the descend macro to create the same directory as the source is in
and build the objects in that directory.

Sort out the "lib" directory to only have the libraries built in that
directory.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile         | 18 ++++++++++--------
 scripts/utils.mk |  3 ++-
 src/Makefile     |  3 ---
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
index bf085bfdb800..6e18e0a015f5 100644
--- a/Makefile
+++ b/Makefile
@@ -119,13 +119,16 @@ srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
 objtree		:= $(BUILD_OUTPUT)
 src		:= $(srctree)
 obj		:= $(objtree)
-bdir		:= $(obj)/lib/tracefs
+bdir		:= $(obj)/lib
 
 export prefix src obj bdir
 
 LIBTRACEFS_STATIC = $(bdir)/libtracefs.a
 LIBTRACEFS_SHARED = $(bdir)/libtracefs.so.$(TRACEFS_VERSION)
 
+LIBTRACEFS_SHARED_SO = $(bdir)/libtracefs.so
+LIBTRACEFS_SHARED_VERSION = $(bdir)/libtracefs.so.$(TFS_VERSION)
+
 PKG_CONFIG_SOURCE_FILE = libtracefs.pc
 PKG_CONFIG_FILE := $(addprefix $(obj)/,$(PKG_CONFIG_SOURCE_FILE))
 
@@ -134,6 +137,7 @@ LIBS = $(LIBTRACEEVENT_LIBS) -lpthread
 export LIBS
 export LIBTRACEFS_STATIC LIBTRACEFS_SHARED
 export LIBTRACEEVENT_LIBS LIBTRACEEVENT_INCLUDES
+export LIBTRACEFS_SHARED_SO LIBTRACEFS_SHARED_VERSION
 
 export Q SILENT VERBOSE EXT
 
@@ -165,12 +169,12 @@ LIB_TARGET  = libtracefs.a libtracefs.so.$(TRACEFS_VERSION)
 LIB_INSTALL = libtracefs.a libtracefs.so*
 LIB_INSTALL := $(addprefix $(bdir)/,$(LIB_INSTALL))
 
-TARGETS = $(LIBTRACEFS_SHARED) $(LIBTRACEFS_STATIC)
+TARGETS = libtracefs.so libtracefs.a
 
 all_cmd: $(TARGETS) $(PKG_CONFIG_FILE)
 
-libtracefs.a: $(LIBTRACEFS_STATIC)
-libtracefs.so: $(LIBTRACEFS_SHARED)
+libtracefs.a: $(bdir) $(LIBTRACEFS_STATIC)
+libtracefs.so: $(bdir) $(LIBTRACEFS_SHARED)
 
 libs: libtracefs.a libtracefs.so
 
@@ -357,19 +361,17 @@ $(VERSION_FILE): force
 	$(Q)$(call update_version.h)
 
 $(LIBTRACEFS_STATIC): force
-	$(Q)mkdir -p $(bdir)
 	$(Q)$(call descend,$(src)/src,$@)
 
 $(bdir)/libtracefs.so.$(TRACEFS_VERSION): force
-	$(Q)mkdir -p $(bdir)
 	$(Q)$(call descend,$(src)/src,libtracefs.so)
 
-samples/sqlhist: $(LIBTRACEFS_STATIC)
+samples/sqlhist: libtracefs.a
 	$(Q)$(call descend,$(src)/samples,sqlhist)
 
 sqlhist: samples/sqlhist
 
-samples: $(LIBTRACEFS_STATIC) force
+samples: libtracefs.a force
 	$(Q)$(call descend,$(src)/samples,all)
 
 clean:
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 0f6225d3ee68..3bf59c550b1d 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -120,7 +120,8 @@ endif
 #
 descend = \
 	($(print_descend)		\
-	$(MAKE) $(PRINT_DIR) -C $(1) $(2))
+	mkdir -p $(obj)/$(BASE1); \
+	$(MAKE) $(PRINT_DIR) bdir=$(obj)/$(BASE1) -C $(1) $(2))
 
 
 define make_version.h
diff --git a/src/Makefile b/src/Makefile
index f284c70a640a..985744ba1118 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -22,9 +22,6 @@ OBJS += tracefs-sqlhist.o
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 
-LIBTRACEFS_SHARED_SO = $(bdir)/libtracefs.so
-LIBTRACEFS_SHARED_VERSION = $(bdir)/libtracefs.so.$(TFS_VERSION)
-
 $(LIBTRACEFS_STATIC): $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
-- 
2.33.0

