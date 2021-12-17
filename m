Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59551C4321E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhLQFuw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:50:52 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50026 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbhLQFuu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:50:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7CC8BCE23EE
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA94C36AF1;
        Fri, 17 Dec 2021 05:50:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my68h-00056k-Ds;
        Fri, 17 Dec 2021 00:50:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 05/15] libtracefs: Remove unused "bindir" from Makefile
Date:   Fri, 17 Dec 2021 00:50:31 -0500
Message-Id: <20211217055041.19559-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217055041.19559-1-rostedt@goodmis.org>
References: <20211217055041.19559-1-rostedt@goodmis.org>
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
index 4910ebe140b9..d92bec9f1ed7 100644
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

