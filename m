Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 668D5C4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DAD123F38
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730528AbgLKRMJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:12:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394874AbgLKRLm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 12:11:42 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C32C623EF3
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 17:10:15 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knlvq-000Hhq-R5
        for linux-trace-devel@vger.kernel.org; Fri, 11 Dec 2020 12:10:14 -0500
Message-ID: <20201211171014.706323506@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 11 Dec 2020 12:08:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 11/13] trace-cmd: Do not install libtracefs nor libtraceevent libraries
References: <20201211170842.611554918@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Now that both libtraceevent and libtracefs have their own repos and are
packaged separately from trace-cmd, do not install the libraries even if
they do not exist on the system. Anything that depends on those libraries
are require to get them from their corresponding repos and not depend on
trace-cmd for them from now on.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
index 30528952740d..737e54d82697 100644
--- a/Makefile
+++ b/Makefile
@@ -248,7 +248,6 @@ else
 LIBTRACEEVENT_CFLAGS = -I$(src)/include/traceevent -I$(src)/lib/traceevent/include
 LIBTRACEEVENT_LDLAGS = -L$(LIBTRACEEVENT_DIR) -ltraceevent
 LIBTRACEEVENT_STATIC_BUILD = $(LIBTRACEEVENT_STATIC)
-INSTALL_TRACEEVENT = install_traceevent
 endif
 
 export LIBTRACEEVENT_CFLAGS LIBTRACEEVENT_LDLAGS
@@ -260,7 +259,6 @@ else
 LIBTRACEFS_CFLAGS = -I$(src)/include/tracefs
 LIBTRACEFS_LDLAGS = -L$(LIBTRACEFS_DIR) -ltracefs
 LIBTRACEFS_STATIC_BUILD = $(LIBTRACEFS_STATIC)
-INSTALL_TRACEFS = install_tracefs
 endif
 
 export LIBTRACEFS_CFLAGS LIBTRACEFS_LDLAGS
@@ -471,16 +469,7 @@ install: install_cmd
 install_gui: install_cmd gui
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build install
 
-install_traceevent: $(LIBTRACEEVENT_STATIC_BUILD)
-	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ)/traceevent)
-	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ)/traceevent)
-	$(Q)$(call do_install,$(src)/include/traceevent/trace-seq.h,$(includedir_SQ)/traceevent)
-
-install_tracefs: $(LIBTRACEFS_STATIC_BUILD)
-	$(Q)$(call do_install,$(LIBTRACEFS_SHARED),$(libdir_SQ)/tracefs)
-	$(Q)$(call do_install,$(src)/include/tracefs/tracefs.h,$(includedir_SQ)/tracefs)
-
-install_libs: libs $(INSTALL_TRACEEVENT) $(INSTALL_TRACEFS)
+install_libs: libs
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/ $@
 
 doc:
-- 
2.29.2


