Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 935C2C4167B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C28523A79
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgLIEWn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 23:22:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgLIEWn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 23:22:43 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32DC023B28
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 04:21:22 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kmqyf-00031W-5U
        for linux-trace-devel@vger.kernel.org; Tue, 08 Dec 2020 23:21:21 -0500
Message-ID: <20201209042121.039426916@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 08 Dec 2020 23:19:52 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 6/6] libtraceevent: Move source files into src/ directory
References: <20201209041946.131377586@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

To clean up the source directory, create a "src" directory to store the
header and C files.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                                       | 18 +++++++++++-------
 plugins/Makefile                               |  2 +-
 Build => src/Build                             |  0
 src/Makefile                                   | 12 ++++++++++++
 event-parse-api.c => src/event-parse-api.c     |  0
 event-parse-local.h => src/event-parse-local.h |  0
 event-parse.c => src/event-parse.c             |  0
 event-parse.h => src/event-parse.h             |  0
 event-plugin.c => src/event-plugin.c           |  0
 event-utils.h => src/event-utils.h             |  0
 kbuffer-parse.c => src/kbuffer-parse.c         |  0
 kbuffer.h => src/kbuffer.h                     |  0
 parse-filter.c => src/parse-filter.c           |  0
 parse-utils.c => src/parse-utils.c             |  0
 tep_strerror.c => src/tep_strerror.c           |  0
 trace-seq.c => src/trace-seq.c                 |  0
 trace-seq.h => src/trace-seq.h                 |  0
 17 files changed, 24 insertions(+), 8 deletions(-)
 rename Build => src/Build (100%)
 create mode 100644 src/Makefile
 rename event-parse-api.c => src/event-parse-api.c (100%)
 rename event-parse-local.h => src/event-parse-local.h (100%)
 rename event-parse.c => src/event-parse.c (100%)
 rename event-parse.h => src/event-parse.h (100%)
 rename event-plugin.c => src/event-plugin.c (100%)
 rename event-utils.h => src/event-utils.h (100%)
 rename kbuffer-parse.c => src/kbuffer-parse.c (100%)
 rename kbuffer.h => src/kbuffer.h (100%)
 rename parse-filter.c => src/parse-filter.c (100%)
 rename parse-utils.c => src/parse-utils.c (100%)
 rename tep_strerror.c => src/tep_strerror.c (100%)
 rename trace-seq.c => src/trace-seq.c (100%)
 rename trace-seq.h => src/trace-seq.h (100%)

diff --git a/Makefile b/Makefile
index 9ec880c0105b..9044536d2fcf 100644
--- a/Makefile
+++ b/Makefile
@@ -135,7 +135,7 @@ MAKEOVERRIDES=
 export srctree OUTPUT CC LD CFLAGS V
 build := -f $(srctree)/build/Makefile.build dir=. obj
 
-TE_IN      := $(OUTPUT)libtraceevent-in.o
+TE_IN      := $(OUTPUT)src/libtraceevent-in.o
 LIB_TARGET := $(addprefix $(OUTPUT),$(LIB_TARGET))
 
 CMD_TARGETS = $(LIB_TARGET) $(PKG_CONFIG_FILE)
@@ -147,7 +147,7 @@ all: all_cmd plugins
 all_cmd: $(CMD_TARGETS)
 
 $(TE_IN): force
-	$(Q)$(MAKE) $(build)=libtraceevent
+	$(Q)$(call descend,src,libtraceevent)
 
 $(OUTPUT)$(LIBTRACEEVENT_SHARED): $(TE_IN)
 	$(Q)mkdir -p $(OUTPUT)$(bdir)
@@ -252,14 +252,14 @@ install_pkgconfig: $(PKG_CONFIG_FILE)
 
 install_headers:
 	$(call QUIET_INSTALL, headers) \
-		$(call do_install,event-parse.h,$(includedir_SQ),644); \
-		$(call do_install,event-utils.h,$(includedir_SQ),644); \
-		$(call do_install,trace-seq.h,$(includedir_SQ),644); \
-		$(call do_install,kbuffer.h,$(includedir_SQ),644)
+		$(call do_install,src/event-parse.h,$(includedir_SQ),644); \
+		$(call do_install,src/event-utils.h,$(includedir_SQ),644); \
+		$(call do_install,src/trace-seq.h,$(includedir_SQ),644); \
+		$(call do_install,src/kbuffer.h,$(includedir_SQ),644)
 
 install: install_lib
 
-clean: clean_plugins
+clean: clean_plugins clean_src
 	$(call QUIET_CLEAN, libtraceevent) \
 		$(RM) $(OUTPUT)*.o $(OUTPUT)*~ $(TARGETS) $(OUTPUT)*.a $(OUTPUT)*.so $(VERSION_FILES) $(OUTPUT).*.d $(OUTPUT).*.cmd; \
 		$(RM) TRACEEVENT-CFLAGS $(OUTPUT)tags $(OUTPUT)TAGS; \
@@ -310,6 +310,10 @@ PHONY += clean_plugins
 clean_plugins:
 	$(call descend,plugins,clean)
 
+PHONY += clean_src
+clean_src:
+	$(call descend,src,clean)
+
 force:
 
 # Declare the contents of the .PHONY variable as phony.  We keep that
diff --git a/plugins/Makefile b/plugins/Makefile
index a8868d01b09b..e8b8850a19a9 100644
--- a/plugins/Makefile
+++ b/plugins/Makefile
@@ -93,7 +93,7 @@ CONFIG_FLAGS   =
 OBJ            = $@
 N              =
 
-INCLUDES = -I. -I.. -I $(srctree)/include $(CONFIG_INCLUDES)
+INCLUDES = -I. -I.. -I../src -I $(srctree)/include $(CONFIG_INCLUDES)
 
 # Set compile option CFLAGS
 ifdef EXTRA_CFLAGS
diff --git a/Build b/src/Build
similarity index 100%
rename from Build
rename to src/Build
diff --git a/src/Makefile b/src/Makefile
new file mode 100644
index 000000000000..c62104b77c86
--- /dev/null
+++ b/src/Makefile
@@ -0,0 +1,12 @@
+
+include ../scripts/Makefile.include
+
+build := -f $(srctree)/build/Makefile.build dir=. obj
+
+libtraceevent: $(libtraceevent-y)
+	$(Q)$(MAKE) $(build)=libtraceevent
+
+clean:
+	$(call QUIET_CLEAN, trace_src) \
+		$(RM) $(OUTPUT)*.o $(OUTPUT)*~ .*.d .*.cmd
+
diff --git a/event-parse-api.c b/src/event-parse-api.c
similarity index 100%
rename from event-parse-api.c
rename to src/event-parse-api.c
diff --git a/event-parse-local.h b/src/event-parse-local.h
similarity index 100%
rename from event-parse-local.h
rename to src/event-parse-local.h
diff --git a/event-parse.c b/src/event-parse.c
similarity index 100%
rename from event-parse.c
rename to src/event-parse.c
diff --git a/event-parse.h b/src/event-parse.h
similarity index 100%
rename from event-parse.h
rename to src/event-parse.h
diff --git a/event-plugin.c b/src/event-plugin.c
similarity index 100%
rename from event-plugin.c
rename to src/event-plugin.c
diff --git a/event-utils.h b/src/event-utils.h
similarity index 100%
rename from event-utils.h
rename to src/event-utils.h
diff --git a/kbuffer-parse.c b/src/kbuffer-parse.c
similarity index 100%
rename from kbuffer-parse.c
rename to src/kbuffer-parse.c
diff --git a/kbuffer.h b/src/kbuffer.h
similarity index 100%
rename from kbuffer.h
rename to src/kbuffer.h
diff --git a/parse-filter.c b/src/parse-filter.c
similarity index 100%
rename from parse-filter.c
rename to src/parse-filter.c
diff --git a/parse-utils.c b/src/parse-utils.c
similarity index 100%
rename from parse-utils.c
rename to src/parse-utils.c
diff --git a/tep_strerror.c b/src/tep_strerror.c
similarity index 100%
rename from tep_strerror.c
rename to src/tep_strerror.c
diff --git a/trace-seq.c b/src/trace-seq.c
similarity index 100%
rename from trace-seq.c
rename to src/trace-seq.c
diff --git a/trace-seq.h b/src/trace-seq.h
similarity index 100%
rename from trace-seq.h
rename to src/trace-seq.h
-- 
2.29.2


