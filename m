Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA04CC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 16:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 775452226A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 16:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgLWQdn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Dec 2020 11:33:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:59320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgLWQdn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Dec 2020 11:33:43 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77AD32226A
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Dec 2020 16:33:02 +0000 (UTC)
Date:   Wed, 23 Dec 2020 11:33:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Do not build or install traceevent plugins if
 libtraceevent exits
Message-ID: <20201223113300.6a284c7b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The plugins for libtraceevent belong to libtraceevent. If libtraceevent is
installed on the system, then the plugins for libtraceevent should not be
built or installed by trace-cmd.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index eb833f67..eae1eb39 100644
--- a/Makefile
+++ b/Makefile
@@ -243,10 +243,14 @@ endif
 ifeq ("$(TEST_LIBTRACEEVENT)", "y")
 LIBTRACEEVENT_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT)")
 LIBTRACEEVENT_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEEVENT)")
+TRACEEVENT_PLUGINS =
+TRACEEVENT_PLUGINS_INSTALL = 
 else
 LIBTRACEEVENT_CFLAGS = -I$(src)/include/traceevent -I$(src)/lib/traceevent/include
 LIBTRACEEVENT_LDLAGS = -L$(LIBTRACEEVENT_DIR) -ltraceevent
 LIBTRACEEVENT_STATIC_BUILD = $(LIBTRACEEVENT_STATIC)
+TRACEEVENT_PLUGINS = plugins_traceevent
+TRACEEVENT_PLUGINS_INSTALL = install_plugins_traceevent
 endif
 
 export LIBTRACEEVENT_CFLAGS LIBTRACEEVENT_LDLAGS
@@ -414,7 +418,7 @@ plugins_traceevent: force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir \
 plugins_tracecmd: force $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/plugins
 
-plugins: plugins_traceevent plugins_tracecmd
+plugins: $(TRACEEVENT_PLUGINS) plugins_tracecmd
 
 $(obj)/lib/traceevent/plugins/traceevent_plugin_dir: force
 	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins $@
@@ -454,7 +458,7 @@ install_plugins_traceevent: force
 install_plugins_tracecmd: force
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/plugins install_plugins
 
-install_plugins: install_plugins_traceevent install_plugins_tracecmd
+install_plugins: $(TRACEEVENT_PLUGINS_INSTALL) install_plugins_tracecmd
 
 install_python: force
 	$(Q)$(MAKE) -C $(src)/python $@
-- 
2.25.4

