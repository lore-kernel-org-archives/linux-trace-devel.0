Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E3DC2BBCD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E09B23124
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgLPEh7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:37:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:47442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgLPEh6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:37:58 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2342523130
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:37:18 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOYv-000qgY-4e
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:37:17 -0500
Message-ID: <20201216043717.009188125@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:36:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] libtraceevent: Update libtraceevent.pc if prefix is different
References: <20201216043637.453360298@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If a build is done with different DESTDIR and the prefix is changed, the
the libtraceevent.pc is not updated with the new prefix, and the one used may
not work with the installation being performed.

Add a "build_prefix" dependency, that creates a file "build_prefix" that has
the last prefix used to build the library. And if a new prefix is used, then
that file gets updated and so does libtraceevent.pc.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                 | 17 ++++++++++++++++-
 scripts/Makefile.include |  1 +
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index c85114beef96..f795e05d22a7 100644
--- a/Makefile
+++ b/Makefile
@@ -213,6 +213,21 @@ TAGS:	force
 	find . -name '*.[ch]' | xargs etags \
 	--regex='/_PE(\([^,)]*\).*/TEP_ERRNO__\1/'
 
+define build_prefix
+	(echo $1 > $@.tmp;	\
+	if [ -r $@ ] && cmp -s $@ $@.tmp; then				\
+		rm -f $@.tmp;						\
+	else								\
+		$(PRINT_GEN)						\
+		mv -f $@.tmp $@;					\
+	fi);
+endef
+
+BUILD_PREFIX := $(OUTPUT)build_prefix
+
+$(BUILD_PREFIX): force
+	$(Q)$(call build_prefix,$(prefix))
+
 define do_install_mkdir
 	if [ ! -d '$(DESTDIR_SQ)$1' ]; then		\
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$1';	\
@@ -232,7 +247,7 @@ define do_make_pkgconfig_file
 	sed -i "s|HEADER_DIR|$(includedir)|g" ${PKG_CONFIG_FILE};
 endef
 
-$(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template
+$(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template $(BUILD_PREFIX)
 	$(QUIET_GEN) $(call do_make_pkgconfig_file,$(prefix))
 
 define do_install_pkgconfig_file
diff --git a/scripts/Makefile.include b/scripts/Makefile.include
index d505b2f20b92..1c9266c34d2a 100644
--- a/scripts/Makefile.include
+++ b/scripts/Makefile.include
@@ -110,6 +110,7 @@ ifneq ($(silent),1)
 	QUIET_AR       = @echo '  AR       '$@;
 	QUIET_LINK     = @echo '  LINK     '$@;
 	QUIET_MKDIR    = @echo '  MKDIR    '$@;
+	PRINT_GEN      = echo '  GEN      '$@;
 	QUIET_GEN      = @echo '  GEN      '$@;
 	QUIET_SUBDIR0  = +@subdir=
 	QUIET_SUBDIR1  = ;$(NO_SUBDIR) \
-- 
2.29.2


