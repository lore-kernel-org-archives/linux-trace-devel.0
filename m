Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CB6C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 16:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A91BA23A33
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 16:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbgLJQZ3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 11:25:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389312AbgLJQZG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 11:25:06 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C077423118
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Dec 2020 16:24:25 +0000 (UTC)
Date:   Thu, 10 Dec 2020 11:24:23 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix the building dependencies for make install
Message-ID: <20201210112423.26219821@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

While testing: make DESTDIR=/tmp/install/ O=/tmp/build/ install
I found that the dependencies of the install were not correct.
Add the libraries to the install path, and also fix the creation of the
directories itself.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 02b3d25..035f4de 100644
--- a/Makefile
+++ b/Makefile
@@ -180,7 +180,7 @@ all_cmd: $(TARGETS) $(PKG_CONFIG_FILE)
 libtracefs.a: $(LIBTRACEFS_STATIC)
 libtracefs.so: $(LIBTRACEFS_SHARED)
 
-libs:
+libs: libtracefs.a libtracefs.so
 
 test: force $(LIBTRACEFS_STATIC)
 ifneq ($(CUNIT_INSTALLED),1)
@@ -204,6 +204,17 @@ endef
 $(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template
 	$(Q) $(call do_make_pkgconfig_file,$(prefix))
 
+define do_install_mkdir
+	if [ ! -d '$(DESTDIR_SQ)$1' ]; then		\
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$1';	\
+	fi
+endef
+
+define do_install
+	$(call do_install_mkdir,$2);			\
+	$(INSTALL) $(if $3,-m $3,) $1 '$(DESTDIR_SQ)$2'
+endef
+
 define do_install_pkgconfig_file
 	if [ -n "${pkgconfig_dir}" ]; then
					\ $(call
do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
-- 
2.25.4

