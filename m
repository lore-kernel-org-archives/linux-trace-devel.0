Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9FBC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Jan 2021 21:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9BC364DEC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Jan 2021 21:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhA1VcX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Jan 2021 16:32:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229769AbhA1VcT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Jan 2021 16:32:19 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B60A64DEB
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Jan 2021 21:31:37 +0000 (UTC)
Date:   Thu, 28 Jan 2021 16:31:35 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Move plugin_dir define logic to top level
 Makefile
Message-ID: <20210128163135.27ae85d5@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The installation location of the plugin directory needs to be passed into
the C files via the -DPLUGIN_DIR=".." compiler option. But the logic for
that was only in the plugin directory, such that the main library did not
know where to find the plugins (as the PLUGIN_DIR macro was not set). This
caused the library not to load the plugins for the application.

By moving the logic to the top level Makefile and exporting the variables,
this fixes the issue.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile         | 26 ++++++++++++++++++++++++++
 plugins/Makefile | 24 ------------------------
 2 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/Makefile b/Makefile
index e4eba74..11bfe54 100644
--- a/Makefile
+++ b/Makefile
@@ -118,6 +118,32 @@ endif
 
 LIBS = -ldl
 
+set_plugin_dir := 1
+
+# Set plugin_dir to preffered global plugin location
+# If we install under $HOME directory we go under
+# $(HOME)/.local/lib/traceevent/plugins
+#
+# We dont set PLUGIN_DIR in case we install under $HOME
+# directory, because by default the code looks under:
+# $(HOME)/.local/lib/traceevent/plugins by default.
+#
+ifeq ($(plugin_dir),)
+ifeq ($(prefix),$(HOME))
+override plugin_dir = $(HOME)/.local/lib/traceevent/plugins
+set_plugin_dir := 0
+else
+override plugin_dir = $(libdir)/traceevent/plugins
+endif
+export plugin_dir
+endif
+
+ifeq ($(set_plugin_dir),1)
+PLUGIN_DIR = -DPLUGIN_DIR="$(plugin_dir)"
+PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
+export PLUGIN_DIR PLUGIN_DIR_SQ
+endif
+
 # Append required CFLAGS
 override CFLAGS += -fPIC
 override CFLAGS += $(CONFIG_FLAGS) $(INCLUDES) $(PLUGIN_DIR_SQ)
diff --git a/plugins/Makefile b/plugins/Makefile
index e8b8850..b60352d 100644
--- a/plugins/Makefile
+++ b/plugins/Makefile
@@ -41,30 +41,6 @@ libdir_relative ?= $(libdir_relative_tmp)
 prefix ?= /usr/local
 libdir = $(prefix)/$(libdir_relative)
 
-set_plugin_dir := 1
-
-# Set plugin_dir to preffered global plugin location
-# If we install under $HOME directory we go under
-# $(HOME)/.local/lib/traceevent/plugins
-#
-# We dont set PLUGIN_DIR in case we install under $HOME
-# directory, because by default the code looks under:
-# $(HOME)/.local/lib/traceevent/plugins by default.
-#
-ifeq ($(plugin_dir),)
-ifeq ($(prefix),$(HOME))
-override plugin_dir = $(HOME)/.local/lib/traceevent/plugins
-set_plugin_dir := 0
-else
-override plugin_dir = $(libdir)/traceevent/plugins
-endif
-endif
-
-ifeq ($(set_plugin_dir),1)
-PLUGIN_DIR = -DPLUGIN_DIR="$(plugin_dir)"
-PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
-endif
-
 include ../scripts/Makefile.include
 
 # copy a bit from Linux kbuild
-- 
2.25.4

