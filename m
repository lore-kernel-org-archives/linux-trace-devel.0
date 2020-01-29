Return-Path: <SRS0=ilnn=3S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBD3C2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 15:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D8A32070E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 15:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgA2PnP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 10:43:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbgA2PnP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 10:43:15 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41231206F0;
        Wed, 29 Jan 2020 15:43:14 +0000 (UTC)
Date:   Wed, 29 Jan 2020 10:43:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH] trace-cmd: Have /etc paths honor $(prefix) if not the
 default
Message-ID: <20200129104312.2ba4a7a1@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As some files need to be placed in the root directory to take effect (like
the bash_completion) and not the normal /usr/local directory, they ignore
the $(prefix) and install directly. Unfortunately, this means that if
someone does a build like "make O=/tmp/mydir install" those files will still
try to be installed in the root "/etc" directory, and that will not work if
the user installing does not have permission.

Have the "/etc" directory change if prefix is something other than
"/usr/local".

Reported-by: Julia Lawall <julia.lawall@inria.fr>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=206277
Fixes: 77bdcb9b2 ("trace-cmd: Install trace-cmd.bash when installing")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 477625f7..d75f1437 100644
--- a/Makefile
+++ b/Makefile
@@ -51,6 +51,13 @@ libdir_SQ = '$(subst ','\'',$(libdir))'
 includedir = $(prefix)/include
 includedir_SQ = '$(subst ','\'',$(includedir))'
 
+ifeq ($(prefix),/usr/local)
+etcdir ?= /etc
+else
+etcdir ?= $(prefix)/etc
+endif
+etcdir_SQ = '$(subst ','\'',$(etcdir))'
+
 export man_dir man_dir_SQ html_install html_install_SQ INSTALL
 export img_install img_install_SQ
 export DESTDIR DESTDIR_SQ
@@ -87,8 +94,8 @@ HELP_DIR = -DHELP_DIR=$(html_install)
 HELP_DIR_SQ = '$(subst ','\'',$(HELP_DIR))'
 #' emacs highlighting gets confused by the above escaped quote.
 
-BASH_COMPLETE_DIR ?= /etc/bash_completion.d
-LD_SO_CONF_DIR ?= /etc/ld.so.conf.d
+BASH_COMPLETE_DIR ?= $(etcdir)/bash_completion.d
+LD_SO_CONF_DIR ?= $(etcdir)/ld.so.conf.d
 TRACE_LD_FILE ?= trace.conf
 
 export PLUGIN_DIR_TRACEEVENT
-- 
2.20.1

