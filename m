Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0343FC00140
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Aug 2022 15:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240721AbiHEPkw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Aug 2022 11:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240752AbiHEPks (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Aug 2022 11:40:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7D823BD0
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 08:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 549CFB82962
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 15:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01208C43141;
        Fri,  5 Aug 2022 15:40:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oJzRJ-008S4M-2x;
        Fri, 05 Aug 2022 11:40:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/9] tracecmd: Use make variable instead of if statement for zlib test
Date:   Fri,  5 Aug 2022 11:40:32 -0400
Message-Id: <20220805154040.2014381-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220805154040.2014381-1-rostedt@goodmis.org>
References: <20220805154040.2014381-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Instead of adding a test in all the Makefiles that test ZLIB_INSTALLED,
just create a variable that has ZLIB_LDLAGS set to -lz when enabled and
pass that to the LIB flags. When it's not enabled, ZLIB_LDLAGS will be
empty.

(I guess LDLAGS should have been LDFLAGS but a typo appears to have gone
 wild!)

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile               | 3 +++
 lib/trace-cmd/Makefile | 6 +-----
 tracecmd/Makefile      | 6 +-----
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/Makefile b/Makefile
index 2cf66e0d5efc..437b7d5a7152 100644
--- a/Makefile
+++ b/Makefile
@@ -316,10 +316,13 @@ endif
 ZLIB_INSTALLED := $(shell if (printf "$(pound)include <zlib.h>\n void main(){deflateInit(NULL, Z_BEST_COMPRESSION);}" | $(CC) -o /dev/null -x c - -lz >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
 ifeq ($(ZLIB_INSTALLED), 1)
 export ZLIB_INSTALLED
+ZLIB_LDLAGS = -lz
 CFLAGS += -DHAVE_ZLIB
 $(info    Have zlib compression support)
 endif
 
+export ZLIB_LDLAGS
+
 TEST_LIBZSTD = $(shell sh -c "$(PKG_CONFIG) --atleast-version 1.4.0 libzstd > /dev/null 2>&1 && echo y")
 
 ifeq ("$(TEST_LIBZSTD)", "y")
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 9374b163b5f3..a476e35b3762 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -51,11 +51,7 @@ $(DEPS): | $(bdir)
 $(LIBTRACECMD_STATIC): $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
-LIBS = $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS) $(LIBZSTD_LDLAGS) -lpthread
-
-ifeq ($(ZLIB_INSTALLED), 1)
-LIBS += -lz
-endif
+LIBS = $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS) $(ZLIB_LDLAGS) $(LIBZSTD_LDLAGS) -lpthread
 
 $(LIBTRACECMD_SHARED_VERSION): $(LIBTRACECMD_SHARED)
 	@ln -sf $(<F) $@
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 56be9a3b88d1..8207c54b4391 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -50,13 +50,9 @@ all_objs := $(sort $(ALL_OBJS))
 all_deps := $(all_objs:$(bdir)/%.o=$(bdir)/.%.d)
 
 CONFIG_INCLUDES =
-CONFIG_LIBS	= -lrt -lpthread $(TRACE_LIBS) $(LIBZSTD_LDLAGS)
+CONFIG_LIBS	= -lrt -lpthread $(TRACE_LIBS) $(ZLIB_LDLAGS) $(LIBZSTD_LDLAGS)
 CONFIG_FLAGS	=
 
-ifeq ($(ZLIB_INSTALLED), 1)
-CONFIG_LIBS += -lz
-endif
-
 all: $(TARGETS)
 
 $(bdir):
-- 
2.35.1

