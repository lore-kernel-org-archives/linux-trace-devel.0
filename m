Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0A7C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E93323F38
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391168AbgLKRMJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:12:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730528AbgLKRLm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 12:11:42 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 000B023ECD
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 17:10:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knlvq-000HfQ-0j
        for linux-trace-devel@vger.kernel.org; Fri, 11 Dec 2020 12:10:14 -0500
Message-ID: <20201211171013.891812161@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 11 Dec 2020 12:08:48 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 06/13] trace-cmd: Clean up the Makefiles a little
References: <20201211170842.611554918@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Organize the Makefiles a little:

 Move the definition of LIBTRACECMD_SHARED_VERSION and LIBTRACECMD_SHARED_SO
 to the top level Makefile.

 Move the exports for LIBTRACECMD_* right below their definitions.

 Move the LIBTRACECMD_* definitions above the LIBTRACEEVENT_* definitions,
 as LIBTRACECMD_* is the main code here.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile               | 13 ++++++++-----
 lib/trace-cmd/Makefile |  4 ----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 24b2b8f652f7..3e07be45f84e 100644
--- a/Makefile
+++ b/Makefile
@@ -215,16 +215,20 @@ export prefix bindir src obj kshark-dir
 
 LIBS = -ldl
 
+LIBTRACECMD_DIR = $(obj)/lib/trace-cmd
+LIBTRACECMD_STATIC = $(LIBTRACECMD_DIR)/libtracecmd.a
+LIBTRACECMD_SHARED = $(LIBTRACECMD_DIR)/libtracecmd.so.$(LIBTRACECMD_VERSION)
+LIBTRACECMD_SHARED_VERSION = $(shell echo $(LIBTRACECMD_SHARED) | sed -e 's/\(\.so\.[0-9]*\).*/\1/')
+LIBTRACECMD_SHARED_SO = $(shell echo $(LIBTRACECMD_SHARED) | sed -e 's/\(\.so\).*/\1/')
+
+export LIBTRACECMD_STATIC LIBTRACECMD_SHARED
+export LIBTRACECMD_SHARED_VERSION LIBTRACECMD_SHARED_SO
 
 LIBTRACEEVENT=libtraceevent
 LIBTRACEEVENT_DIR = $(obj)/lib/traceevent
 LIBTRACEEVENT_STATIC = $(LIBTRACEEVENT_DIR)/libtraceevent.a
 LIBTRACEEVENT_SHARED = $(LIBTRACEEVENT_DIR)/libtraceevent.so
 
-LIBTRACECMD_DIR = $(obj)/lib/trace-cmd
-LIBTRACECMD_STATIC = $(LIBTRACECMD_DIR)/libtracecmd.a
-LIBTRACECMD_SHARED = $(LIBTRACECMD_DIR)/libtracecmd.so.$(LIBTRACECMD_VERSION)
-
 LIBTRACEFS=libtracefs
 LIBTRACEFS_DIR = $(obj)/lib/tracefs
 LIBTRACEFS_STATIC = $(LIBTRACEFS_DIR)/libtracefs.a
@@ -259,7 +263,6 @@ TRACE_LIBS = -L$(LIBTRACECMD_DIR) -ltracecmd	\
 
 export LIBS TRACE_LIBS
 export LIBTRACEEVENT_DIR LIBTRACECMD_DIR LIBTRACEFS_DIR
-export LIBTRACECMD_STATIC LIBTRACECMD_SHARED
 export Q SILENT VERBOSE EXT
 
 # Include the utils
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index ec68831de610..cd66eaa8ea6c 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -40,10 +40,6 @@ $(LIBTRACECMD_STATIC): $(OBJS)
 
 LIBS = -L$(obj)/lib/traceevent -ltraceevent
 
-LIBTRACECMD_SHARED_VERSION = $(shell echo $(LIBTRACECMD_SHARED) | sed -e 's/\(\.so\.[0-9]*\).*/\1/')
-
-LIBTRACECMD_SHARED_SO = $(shell echo $(LIBTRACECMD_SHARED) | sed -e 's/\(\.so\).*/\1/')
-
 $(LIBTRACECMD_SHARED_VERSION): $(LIBTRACECMD_SHARED)
 	@ln -sf $(<F) $@
 
-- 
2.29.2


