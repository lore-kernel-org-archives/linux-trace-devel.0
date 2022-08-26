Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1751BECAAD4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Aug 2022 22:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbiHZW7I (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Aug 2022 18:59:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51982 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbiHZW7I (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Aug 2022 18:59:08 -0400
Received: from usagi.middle.earth (ethbase.usagi.not.afront.org [IPv6:2620:137:e001:0:1897:4108:901b:c660])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4A1EA846F2C1;
        Fri, 26 Aug 2022 15:59:07 -0700 (PDT)
Received: from usagi.middle.earth (localhost [IPv6:::1])
        by usagi.middle.earth (Postfix) with ESMTP id 35033423F1D7;
        Fri, 26 Aug 2022 15:59:04 -0700 (PDT)
From:   John 'Warthog9' Hawley <warthog9@eaglescrag.net>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org
Subject: [PATCH] trace-cmd: Add compile time overrides for libraries
Date:   Fri, 26 Aug 2022 15:59:04 -0700
Message-Id: <20220826225904.1824344-1-warthog9@eaglescrag.net>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 26 Aug 2022 15:59:07 -0700 (PDT)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Continuing in the ld.lld link issues trace-cmd needs to override
-lrt -lpthread and -ldl.  This adds the ability, from the command line,
adjust LIBS, LRT and LPTHREAD

Signed-off-by: John 'Warthog9' Hawley <warthog9@eaglescrag.net>
---
 Makefile               | 2 +-
 lib/trace-cmd/Makefile | 4 +++-
 tracecmd/Makefile      | 5 ++++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 7178d7a9..92ba4ba4 100644
--- a/Makefile
+++ b/Makefile
@@ -216,7 +216,7 @@ export pkgconfig_dir PKG_CONFIG_FILE
 
 export prefix bindir src obj
 
-LIBS = -ldl
+LIBS ?= -ldl
 
 LIBTRACECMD_DIR = $(obj)/lib/trace-cmd
 LIBTRACECMD_STATIC = $(LIBTRACECMD_DIR)/libtracecmd.a
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 81cde3de..28b4afc6 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -52,7 +52,9 @@ $(DEPS): | $(bdir)
 $(LIBTRACECMD_STATIC): $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
-LIBS = $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS) $(ZLIB_LDLAGS) $(LIBZSTD_LDLAGS) -lpthread
+LPTHREAD ?= -lpthread
+
+LIBS = $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS) $(ZLIB_LDLAGS) $(LIBZSTD_LDLAGS) $(LPTHREAD)
 
 $(LIBTRACECMD_SHARED_VERSION): $(LIBTRACECMD_SHARED)
 	@ln -sf $(<F) $@
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 8207c54b..66387526 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -49,8 +49,11 @@ ALL_OBJS := $(TRACE_CMD_OBJS:%.o=$(bdir)/%.o)
 all_objs := $(sort $(ALL_OBJS))
 all_deps := $(all_objs:$(bdir)/%.o=$(bdir)/.%.d)
 
+LPTHREAD ?= -lpthread
+LRT ?= -lrt
+
 CONFIG_INCLUDES =
-CONFIG_LIBS	= -lrt -lpthread $(TRACE_LIBS) $(ZLIB_LDLAGS) $(LIBZSTD_LDLAGS)
+CONFIG_LIBS	= $(LRT) $(LPTHREAD) $(TRACE_LIBS) $(ZLIB_LDLAGS) $(LIBZSTD_LDLAGS)
 CONFIG_FLAGS	=
 
 all: $(TARGETS)
-- 
2.37.2

