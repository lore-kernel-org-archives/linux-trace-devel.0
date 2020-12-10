Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2717C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91D3A23C43
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgLJCbH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 21:31:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728619AbgLJCbG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 21:31:06 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B23E23D4F
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Dec 2020 02:29:45 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knBiC-0004Bl-4v
        for linux-trace-devel@vger.kernel.org; Wed, 09 Dec 2020 21:29:44 -0500
Message-ID: <20201210022944.023068632@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 09 Dec 2020 21:29:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 8/9] trace-cmd: Have "make test" use system libraries if present
References: <20201210022906.112066412@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Update the Makefiles so that "make test" will use the system libraries of
libtraceevent and libtracefs if they are present, and only build them
locally if they are not.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile       | 5 ++++-
 utest/Makefile | 4 +---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index c6cdeeaef46d..8d82db567a52 100644
--- a/Makefile
+++ b/Makefile
@@ -215,6 +215,8 @@ LIBTRACEEVENT_LDLAGS = -L$(LIBTRACEEVENT_DIR) -ltraceevent
 LIBTRACEEVENT_STATIC_BUILD = $(LIBTRACEEVENT_STATIC)
 endif
 
+export LIBTRACEEVENT_CFLAGS LIBTRACEEVENT_LDLAGS
+
 ifeq ($(shell sh -c "pkg-config --cflags $(LIBTRACEFS) > /dev/null 2>&1 && echo y"), y)
 LIBTRACEFS_CFLAGS = $(shell sh -c "pkg-config --cflags $(LIBTRACEFS)")
 LIBTRACEFS_LDLAGS = $(shell sh -c "pkg-config --libs $(LIBTRACEFS)")
@@ -224,6 +226,7 @@ LIBTRACEFS_LDLAGS = -L$(LIBTRACEFS_DIR) -ltracefs
 LIBTRACEFS_STATIC_BUILD = $(LIBTRACEFS_STATIC)
 endif
 
+export LIBTRACEFS_CFLAGS LIBTRACEFS_LDLAGS
 
 TRACE_LIBS = -L$(LIBTRACECMD_DIR) -ltracecmd	\
 	     $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS)
@@ -358,7 +361,7 @@ libtracefs.so: $(LIBTRACEFS_SHARED)
 
 libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED) $(LIBTRACEFS_SHARED)
 
-test: force $(LIBTRACEEVENT_STATIC) $(LIBTRACEFS_STATIC) $(LIBTRACECMD_STATIC)
+test: force $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACEFS_STATIC_BUILD) $(LIBTRACECMD_STATIC)
 ifneq ($(CUNIT_INSTALLED),1)
 	$(error CUnit framework not installed, cannot build unit tests))
 endif
diff --git a/utest/Makefile b/utest/Makefile
index d635650d46e1..55828abb59e3 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -9,9 +9,7 @@ OBJS =
 OBJS += trace-utest.o
 OBJS += tracefs-utest.o
 
-LIBS += -lcunit				\
-	-L$(LIBTRACEFS_DIR) -ltracefs	\
-	-L$(LIBTRACEEVENT_DIR) -ltraceevent
+LIBS += -lcunit $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS)
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
-- 
2.29.2


