Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045B8C19437
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 21:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF311221E5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 21:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbgLHVzq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:55:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730418AbgLHVzp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 16:55:45 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81B09221E5
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Dec 2020 21:55:05 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kmkwq-003ssA-IB
        for linux-trace-devel@vger.kernel.org; Tue, 08 Dec 2020 16:55:04 -0500
Message-ID: <20201208215504.451420772@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 08 Dec 2020 16:54:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/6] libtracefs: Remove LIBTRACEFS_DIR as it is the same as bdir
References: <20201208215404.135186972@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Remove the variable LIBTRACEFS_DIR as it is simply bdir, and makes the
Makefile confusing. Simply use $(bdir) where $(LIBTRACEFS_DIR) is currently
used.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile       | 11 +++++------
 utest/Makefile |  2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index e84b41408b54..5aa2ba4b5145 100644
--- a/Makefile
+++ b/Makefile
@@ -123,16 +123,15 @@ src		:= $(srctree)
 obj		:= $(objtree)
 bdir		:= $(obj)/lib/tracefs
 
-export prefix bindir src obj
+export prefix bindir src obj bdir
 
-LIBTRACEFS_DIR = $(obj)/lib/tracefs
-LIBTRACEFS_STATIC = $(LIBTRACEFS_DIR)/libtracefs.a
-LIBTRACEFS_SHARED = $(LIBTRACEFS_DIR)/libtracefs.so.$(TRACEFS_VERSION)
+LIBTRACEFS_STATIC = $(bdir)/libtracefs.a
+LIBTRACEFS_SHARED = $(bdir)/libtracefs.so.$(TRACEFS_VERSION)
 
-TRACE_LIBS = -L$(LIBTRACEFS_DIR) -ltracefs
+TRACE_LIBS = -L$(bdir) -ltracefs
 
 export LIBS TRACE_LIBS
-export LIBTRACEFS_STATIC LIBTRACEFS_SHARED LIBTRACEFS_DIR
+export LIBTRACEFS_STATIC LIBTRACEFS_SHARED
 
 export Q SILENT VERBOSE EXT
 
diff --git a/utest/Makefile b/utest/Makefile
index a26d7a9a24af..9f96c4e397c1 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -11,7 +11,7 @@ OBJS += tracefs-utest.o
 
 LIBS += -lcunit				\
 	-ldl				\
-	-L$(LIBTRACEFS_DIR) -ltracefs
+	-L$(bdir) -ltracefs
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
-- 
2.28.0


