Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF43C4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 904E820639
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgLPUAt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:32768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbgLPUAt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 15:00:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28B5F20639
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 20:00:08 +0000 (UTC)
Date:   Wed, 16 Dec 2020 15:00:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Allow the pkg-config libs and cflags prefix
 to be overwritten
Message-ID: <20201216150006.7b65aea7@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In case libtracefs needs to be built in a destination directory where
libtraceevent will be located, and not on the host machine, it will need a
way to override the location of the include and library directories.
Facilitate this by having them use the ${prefix} variable.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                  | 8 ++++----
 libtraceevent.pc.template | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index f96232b..5bd3253 100644
--- a/Makefile
+++ b/Makefile
@@ -50,8 +50,8 @@ man_dir = $(prefix)/share/man
 man_dir_SQ = '$(subst ','\'',$(man_dir))'
 pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
 			--variable pc_path pkg-config | tr ":" " "))
-includedir_relative = traceevent
-includedir = $(prefix)/include/$(includedir_relative)
+includedir_relative = include/traceevent
+includedir = $(prefix)/$(includedir_relative)
 includedir_SQ = '$(subst ','\'',$(includedir))'
 
 export man_dir man_dir_SQ INSTALL
@@ -243,8 +243,8 @@ define do_make_pkgconfig_file
 	cp -f ${PKG_CONFIG_SOURCE_FILE}.template ${PKG_CONFIG_FILE};	\
 	sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
 	sed -i "s|LIB_VERSION|${EVENT_PARSE_VERSION}|g" ${PKG_CONFIG_FILE}; \
-	sed -i "s|LIB_DIR|${libdir}|g" ${PKG_CONFIG_FILE}; \
-	sed -i "s|HEADER_DIR|$(includedir)|g" ${PKG_CONFIG_FILE};
+	sed -i "s|LIB_DIR|${libdir_relative}|g" ${PKG_CONFIG_FILE}; \
+	sed -i "s|HEADER_DIR|$(includedir_relative)|g" ${PKG_CONFIG_FILE};
 endef
 
 $(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template $(BUILD_PREFIX)
diff --git a/libtraceevent.pc.template b/libtraceevent.pc.template
index d558377..1ab046f 100644
--- a/libtraceevent.pc.template
+++ b/libtraceevent.pc.template
@@ -1,6 +1,6 @@
 prefix=INSTALL_PREFIX
-libdir=LIB_DIR
-includedir=HEADER_DIR
+libdir=${prefix}/LIB_DIR
+includedir=${prefix}/HEADER_DIR
 
 Name: libtraceevent
 URL: https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
-- 
2.25.4

