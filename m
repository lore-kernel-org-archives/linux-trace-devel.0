Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FDBC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 00:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhLQAmS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 19:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhLQAmR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 19:42:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5463C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 16:42:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D0FF61EDB
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 00:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6585C36AE8;
        Fri, 17 Dec 2021 00:42:16 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my1KB-0004Cu-OV;
        Thu, 16 Dec 2021 19:42:15 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/9] libtracefs: Remove unused "bindir" from Makefile
Date:   Thu, 16 Dec 2021 19:42:06 -0500
Message-Id: <20211217004214.16074-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217004214.16074-1-rostedt@goodmis.org>
References: <20211217004214.16074-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

It appears the the bindir variables are not used to build or install the
library. Remove them from the Makefile as they just add unnecessary noise.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index 85b3c39a867c..8ee80097d77f 100644
--- a/Makefile
+++ b/Makefile
@@ -52,8 +52,6 @@ endif
 
 libdir_relative ?= $(libdir_relative_temp)
 prefix ?= /usr/local
-bindir_relative = bin
-bindir = $(prefix)/$(bindir_relative)
 man_dir = $(prefix)/share/man
 man_dir_SQ = '$(subst ','\'',$(man_dir))'
 libdir = $(prefix)/$(libdir_relative)
@@ -82,10 +80,6 @@ export man_dir man_dir_SQ html_install html_install_SQ INSTALL
 export img_install img_install_SQ
 export DESTDIR DESTDIR_SQ
 
-# Shell quotes
-bindir_SQ = $(subst ','\'',$(bindir))
-bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
-
 pound := \#
 
 HELP_DIR = -DHELP_DIR=$(html_install)
@@ -130,7 +124,7 @@ src		:= $(srctree)
 obj		:= $(objtree)
 bdir		:= $(obj)/lib/tracefs
 
-export prefix bindir src obj bdir
+export prefix src obj bdir
 
 LIBTRACEFS_STATIC = $(bdir)/libtracefs.a
 LIBTRACEFS_SHARED = $(bdir)/libtracefs.so.$(TRACEFS_VERSION)
-- 
2.33.0

