Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C52C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 15:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52D4D22202
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 15:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbgLWPjb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Dec 2020 10:39:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbgLWPja (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Dec 2020 10:39:30 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E163423340;
        Wed, 23 Dec 2020 15:38:49 +0000 (UTC)
Date:   Wed, 23 Dec 2020 10:38:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Jan Engelhardt <ej+bko@inai.de>
Subject: [PATCH] libtracefs: Do not show the full version in the library 
 SONAME
Message-ID: <20201223103847.64d37c62@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The SONAME of the library should point to the same object as the
libtracefs.so does. Since the soft link libtracefs.so points to
libtracefs.so.1, then so should the SONAME of the executable.

Reported-by:  Jan Engelhardt <ej+bko@inai.de>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=210875
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 scripts/utils.mk | 2 +-
 src/Makefile     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/utils.mk b/scripts/utils.mk
index 7742e19..32a9b3c 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -56,7 +56,7 @@ do_build_static_lib =				\
 
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
-	$(CC) --shared $^ '-Wl,-soname,$(@F),-rpath=$$ORIGIN' -o $@ $(LIBS))
+	$(CC) --shared $^ '-Wl,-soname,$(1),-rpath=$$ORIGIN' -o $@ $(LIBS))
 
 do_compile_plugin_obj =				\
 	($(print_plugin_obj_compile)		\
diff --git a/src/Makefile b/src/Makefile
index 52f17af..3f64905 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -17,7 +17,7 @@ $(LIBTRACEFS_STATIC): $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
 $(LIBTRACEFS_SHARED): $(OBJS)
-	$(Q)$(call do_compile_shared_library)
+	$(Q)$(call do_compile_shared_library,$(notdir $(LIBTRACEFS_SHARED_VERSION)))
 
 $(LIBTRACEFS_SHARED_VERSION): $(LIBTRACEFS_SHARED)
 	@ln -sf $(<F) $@
-- 
2.25.4

