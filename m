Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E87C2BBCA
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Dec 2020 16:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49369207E8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Dec 2020 16:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgLOQlu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 11:41:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgLOQlt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 11:41:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ACB122581
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Dec 2020 16:41:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpDNr-000nHs-V5
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 11:41:07 -0500
Message-ID: <20201215164107.816232723@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 11:40:33 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] libtracefs: Remove KernelShark relics from build
References: <20201215164030.520449524@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The utils.mk file has variables to deal with building KernelShark as it was
taken from the trace-cmd.git repo. libtracefs dose not build KernelShark and
we can remove the variables that were for that.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 scripts/utils.mk | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/scripts/utils.mk b/scripts/utils.mk
index ad73814c5664..398b88a75bfb 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -2,15 +2,7 @@
 
 # Utils
 
-ifeq ($(BUILDGUI), 1)
-  GUI		= 'GUI '
-  GSPACE	=
-else
-  GUI		=
-  GSPACE	= "    "
-endif
-
- GOBJ		= $(GSPACE)$(notdir $(strip $@))
+ GOBJ		= $(notdir $(strip $@))
 
 
 ifeq ($(VERBOSE),1)
@@ -32,15 +24,15 @@ ifeq ($(findstring 1,$(SILENT)$(VERBOSE)),1)
   print_install =
   print_update =
 else
-  print_compile =		echo '  $(GUI)COMPILE            '$(GOBJ);
-  print_app_build =		echo '  $(GUI)BUILD              '$(GOBJ);
-  print_fpic_compile =		echo '  $(GUI)COMPILE FPIC       '$(GOBJ);
-  print_shared_lib_compile =	echo '  $(GUI)COMPILE SHARED LIB '$(GOBJ);
-  print_plugin_obj_compile =	echo '  $(GUI)COMPILE PLUGIN OBJ '$(GOBJ);
-  print_plugin_build =		echo '  $(GUI)BUILD PLUGIN       '$(GOBJ);
-  print_static_lib_build =	echo '  $(GUI)BUILD STATIC LIB   '$(GOBJ);
-  print_install =		echo '  $(GUI)INSTALL     '$(GSPACE)$1'	to	$(DESTDIR_SQ)$2';
-  print_update =		echo '  $(GUI)UPDATE             '$(GOBJ);
+  print_compile =		echo '  COMPILE            '$(GOBJ);
+  print_app_build =		echo '  BUILD              '$(GOBJ);
+  print_fpic_compile =		echo '  COMPILE FPIC       '$(GOBJ);
+  print_shared_lib_compile =	echo '  COMPILE SHARED LIB '$(GOBJ);
+  print_plugin_obj_compile =	echo '  COMPILE PLUGIN OBJ '$(GOBJ);
+  print_plugin_build =		echo '  BUILD PLUGIN       '$(GOBJ);
+  print_static_lib_build =	echo '  BUILD STATIC LIB   '$(GOBJ);
+  print_install =		echo '  INSTALL     '$1'	to	$(DESTDIR_SQ)$2';
+  print_update =		echo '  UPDATE             '$(GOBJ);
 endif
 
 do_fpic_compile =					\
-- 
2.29.2


