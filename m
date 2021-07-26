Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA71FC432BE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 16:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A67CE60FA0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 16:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbhGZPsi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 11:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238627AbhGZPsb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 11:48:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08EB760F6F;
        Mon, 26 Jul 2021 16:29:00 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m83TO-0022l0-Ke; Mon, 26 Jul 2021 12:28:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] trace-cmd: Remove leftover traces of libtraceevent in Makefiles
Date:   Mon, 26 Jul 2021 12:28:56 -0400
Message-Id: <20210726162857.487153-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726162857.487153-1-rostedt@goodmis.org>
References: <20210726162857.487153-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

There's still references to libtraceevent that was used for handling the
libtraceevent that was located in the repo. As these are now handled by
the libtraceevent external repo, they no longer need to be handled here.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .gitignore      |  1 -
 Makefile        | 23 ++---------------------
 python/Makefile |  2 +-
 3 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/.gitignore b/.gitignore
index f0719c5ef126..eb1b0dbea6f2 100644
--- a/.gitignore
+++ b/.gitignore
@@ -20,7 +20,6 @@ ctracecmdgui_wrap.c
 tags
 TAGS
 cscope*
-traceevent_plugin_dir
 trace_python_dir
 tracecmd_plugin_dir
 libtracecmd.pc
diff --git a/Makefile b/Makefile
index d6fd09d8d0e5..951e717e1d87 100644
--- a/Makefile
+++ b/Makefile
@@ -89,17 +89,13 @@ export img_install img_install_SQ libdir libdir_SQ includedir_SQ
 export DESTDIR DESTDIR_SQ
 
 ifeq ($(prefix),$(HOME))
-plugin_traceevent_dir = $(HOME)/.local/lib/traceevent/plugins
 plugin_tracecmd_dir = $(libdir)/trace-cmd/plugins
-python_dir ?= $(libdir)/traceevent/python
+python_dir ?= $(libdir)/trace-cmd/python
 var_dir = $(HOME)/.trace-cmd/
 else
-plugin_traceevent_dir = $(libdir)/trace-cmd/plugins
 python_dir ?= $(libdir)/trace-cmd/python
-PLUGIN_DIR_TRACEEVENT = -DPLUGIN_TRACEEVENT_DIR="$(plugin_traceevent_dir)"
 PLUGIN_DIR_TRACECMD = -DPLUGIN_TRACECMD_DIR="$(plugin_tracecmd_dir)"
 PYTHON_DIR = -DPYTHON_DIR="$(python_dir)"
-PLUGIN_DIR_TRACEEVENT_SQ = '$(subst ','\'',$(PLUGIN_DIR_TRACEEVENT))'
 PLUGIN_DIR_TRACECMD_SQ = '$(subst ','\'',$(PLUGIN_DIR_TRACECMD))'
 PYTHON_DIR_SQ = '$(subst ','\'',$(PYTHON_DIR))'
 var_dir = /var
@@ -108,7 +104,6 @@ endif
 # Shell quotes
 bindir_SQ = $(subst ','\'',$(bindir))
 bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
-plugin_traceevent_dir_SQ = $(subst ','\'',$(plugin_traceevent_dir))
 plugin_tracecmd_dir_SQ = $(subst ','\'',$(plugin_tracecmd_dir))
 python_dir_SQ = $(subst ','\'',$(python_dir))
 
@@ -124,11 +119,9 @@ HELP_DIR_SQ = '$(subst ','\'',$(HELP_DIR))'
 
 BASH_COMPLETE_DIR ?= $(etcdir)/bash_completion.d
 
-export PLUGIN_DIR_TRACEEVENT
 export PLUGIN_DIR_TRACECMD
 export PYTHON_DIR
 export PYTHON_DIR_SQ
-export plugin_traceevent_dir_SQ
 export plugin_tracecmd_dir_SQ
 export python_dir_SQ
 export var_dir
@@ -346,7 +339,7 @@ endif
 
 # Append required CFLAGS
 override CFLAGS += $(INCLUDES) $(VAR_DIR)
-override CFLAGS += $(PLUGIN_DIR_TRACEEVENT_SQ) $(PLUGIN_DIR_TRACECMD_SQ)
+override CFLAGS += $(PLUGIN_DIR_TRACECMD_SQ)
 override CFLAGS += $(udis86-flags) $(blk-flags)
 override LDFLAGS += $(udis86-ldflags)
 
@@ -431,24 +424,14 @@ ifneq ($(CUNIT_INSTALLED),1)
 endif
 	$(Q)$(MAKE) -C $(src)/utest $@
 
-plugins_traceevent: force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir \
-		   $(obj)/lib/traceevent/plugins/trace_python_dir
-	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins
-
 plugins_tracecmd: force $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/plugins
 
 plugins: plugins_tracecmd
 
-$(obj)/lib/traceevent/plugins/traceevent_plugin_dir: force
-	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins $@
-
 $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir: force
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/plugins $@
 
-$(obj)/lib/traceevent/plugins/trace_python_dir: force
-	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins $@
-
 show_other_make:
 	@echo "Note: to build man pages, type \"make doc\""
 	@echo "      to build unit tests, type \"make test\""
@@ -472,8 +455,6 @@ cscope: force
 	$(RM) cscope*
 	$(call find_tag_files) | cscope -b -q
 
-install_plugins_traceevent: force
-	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins install_plugins
 install_plugins_tracecmd: force
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/plugins install_plugins
 
diff --git a/python/Makefile b/python/Makefile
index acd67e918033..63f5736dec45 100644
--- a/python/Makefile
+++ b/python/Makefile
@@ -9,7 +9,7 @@ PYTHON_PY_LIBS := tracecmd.install
 endif
 
 ctracecmd.so: ctracecmd.i $(LIBTRACECMD_STATIC)
-	swig -Wall -python -noproxy -I$(src)/include/traceevent -I$(src)/include/trace-cmd $(LIBTRACEEVENT_CFLAGS) ctracecmd.i
+	swig -Wall -python -noproxy -I$(src)/include/trace-cmd $(LIBTRACEEVENT_CFLAGS) ctracecmd.i
 	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
 	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so $(TRACE_LIBS)
 
-- 
2.30.2

