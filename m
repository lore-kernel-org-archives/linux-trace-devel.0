Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8A5C64E75
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 14:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B529C206FB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 14:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730558AbgKXOMp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Nov 2020 09:12:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:49420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730003AbgKXOMo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 09:12:44 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9123D206FB;
        Tue, 24 Nov 2020 14:12:43 +0000 (UTC)
Date:   Tue, 24 Nov 2020 09:12:41 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH v2] libtracevent: Build libtraceevent.pc via "make" not
 "make install"
Message-ID: <20201124091241.3c0dbbc4@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

"make install" copies libtraceevent.pc.template to libtraceevent.pc and then
modifies it for the installation. This command is usually executed as root,
and when finished, it leaves behind the libtraceevent.pc file owned by root
and that may not be modified by the owner of the directory.

Instead, have the libtraceevent.pc file created via normal "make" and then
have the "make install" copy it to the system location.

Link: https://lore.kernel.org/linux-trace-devel/20201123184940.031517790@goodmis.org

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Changes since v1:
    - Have libtraceevent.pc created by "make" and not simply remove
      it after creation from the "make install". This allows us to be
      able to debug it, if it was not created properly.
         (Tzvetomir Stoyanov)

 Makefile | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 2a6bfcc..318ec55 100644
--- a/Makefile
+++ b/Makefile
@@ -52,6 +52,9 @@ includedir_relative = traceevent
 includedir = $(prefix)/include/$(includedir_relative)
 includedir_SQ = '$(subst ','\'',$(includedir))'
 
+PKG_CONFIG_SOURCE_FILE = libtraceevent.pc
+PKG_CONFIG_FILE := $(addprefix $(OUTPUT),$(PKG_CONFIG_SOURCE_FILE))
+
 export man_dir man_dir_SQ INSTALL
 export DESTDIR DESTDIR_SQ
 export EVENT_PARSE_VERSION
@@ -126,7 +129,7 @@ build := -f $(srctree)/build/Makefile.build dir=. obj
 TE_IN      := $(OUTPUT)libtraceevent-in.o
 LIB_TARGET := $(addprefix $(OUTPUT),$(LIB_TARGET))
 
-CMD_TARGETS = $(LIB_TARGET)
+CMD_TARGETS = $(LIB_TARGET) $(PKG_CONFIG_FILE)
 
 TARGETS = $(CMD_TARGETS)
 
@@ -208,15 +211,19 @@ define do_install
 	$(INSTALL) $(if $3,-m $3,) $1 '$(DESTDIR_SQ)$2'
 endef
 
-PKG_CONFIG_SOURCE_FILE = libtraceevent.pc
-PKG_CONFIG_FILE := $(addprefix $(OUTPUT),$(PKG_CONFIG_SOURCE_FILE))
+define do_make_pkgconfig_file
+	cp -f ${PKG_CONFIG_SOURCE_FILE}.template ${PKG_CONFIG_FILE};	\
+	sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
+	sed -i "s|LIB_VERSION|${EVENT_PARSE_VERSION}|g" ${PKG_CONFIG_FILE}; \
+	sed -i "s|LIB_DIR|${libdir}|g" ${PKG_CONFIG_FILE}; \
+	sed -i "s|HEADER_DIR|$(includedir)|g" ${PKG_CONFIG_FILE};
+endef
+
+$(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template
+	$(QUIET_GEN) $(call do_make_pkgconfig_file,$(prefix))
+
 define do_install_pkgconfig_file
 	if [ -n "${pkgconfig_dir}" ]; then 					\
-		cp -f ${PKG_CONFIG_SOURCE_FILE}.template ${PKG_CONFIG_FILE};	\
-		sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
-		sed -i "s|LIB_VERSION|${EVENT_PARSE_VERSION}|g" ${PKG_CONFIG_FILE}; \
-		sed -i "s|LIB_DIR|${libdir}|g" ${PKG_CONFIG_FILE}; \
-		sed -i "s|HEADER_DIR|$(includedir)|g" ${PKG_CONFIG_FILE}; \
 		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
 	else 									\
 		(echo Failed to locate pkg-config directory) 1>&2;		\
@@ -228,7 +235,7 @@ install_lib: all_cmd install_plugins install_headers install_pkgconfig
 		$(call do_install_mkdir,$(libdir_SQ)); \
 		cp -fpR $(LIB_INSTALL) $(DESTDIR)$(libdir_SQ)
 
-install_pkgconfig:
+install_pkgconfig: $(PKG_CONFIG_FILE)
 	$(call QUIET_INSTALL, $(PKG_CONFIG_FILE)) \
 		$(call do_install_pkgconfig_file,$(prefix))
 
-- 
2.25.4

