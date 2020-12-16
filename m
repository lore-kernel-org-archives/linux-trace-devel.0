Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34AD5C2BBCA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F21FA2312E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgLPEkD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgLPEkD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:40:03 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08CC223137
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:39:23 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOav-000qoW-Vq
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:39:21 -0500
Message-ID: <20201216043921.836601434@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:38:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/5] libtracefs: Update libtracefs.pc if prefix is different
References: <20201216043852.168982058@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If a build is done with different DESTDIR and the prefix is changed, the
the libtracefs.pc is not updated with the new prefix, and the one used may
not work with the installation being performed.

Add a "build_prefix" dependency, that creates a file "build_prefix" that has
the last prefix used to build the library. And if a new prefix is used, then
that file gets updated and so does libtracefs.pc.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile         |  7 ++++++-
 scripts/utils.mk | 10 ++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 653fdc448f45..204a4e5e6e1f 100644
--- a/Makefile
+++ b/Makefile
@@ -197,7 +197,12 @@ define do_make_pkgconfig_file
 	sed -i "s|HEADER_DIR|$(includedir)|g" ${PKG_CONFIG_FILE};
 endef
 
-$(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template
+BUILD_PREFIX := $(BUILD_OUTPUT)/build_prefix
+
+$(BUILD_PREFIX): force
+	$(Q)$(call build_prefix,$(prefix))
+
+$(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template $(BUILD_PREFIX)
 	$(Q) $(call do_make_pkgconfig_file,$(prefix))
 
 tags:	force
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 74b138eefed6..0d3c3194f6c5 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -113,6 +113,16 @@ define update_dir
 	fi);
 endef
 
+define build_prefix
+	(echo $1 > $@.tmp;	\
+	if [ -r $@ ] && cmp -s $@ $@.tmp; then				\
+		rm -f $@.tmp;						\
+	else								\
+		$(print_update)						\
+		mv -f $@.tmp $@;					\
+	fi);
+endef
+
 define do_install_mkdir
 	if [ ! -d '$(DESTDIR_SQ)$1' ]; then		\
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$1';	\
-- 
2.29.2


