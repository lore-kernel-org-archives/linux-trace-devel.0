Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B9CC2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D861123159
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbgLPEnf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbgLPEnf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:35 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F07AC23332
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:42:15 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOdj-000r2h-0A
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:42:15 -0500
Message-ID: <20201216044214.856860622@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:42:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 11/12] trace-cmd: Update libtracecmd.pc if prefix is different
References: <20201216044150.375001748@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If a build is done with different DESTDIR and the prefix is changed, the
the libtracecmd.pc is not updated with the new prefix, and the one used may
not work with the installation being performed.

Add a "build_prefix" dependency, that creates a file "build_prefix" that has
the last prefix used to build the library. And if a new prefix is used, then
that file gets updated and so does libtracecmd.pc.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .gitignore       |  1 +
 Makefile         |  7 ++++++-
 scripts/utils.mk | 10 ++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index 1e8c1d4f5734..9ce25c8e031e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -24,3 +24,4 @@ traceevent_plugin_dir
 trace_python_dir
 tracecmd_plugin_dir
 libtracecmd.pc
+build_prefix
diff --git a/Makefile b/Makefile
index ddceab3f45e7..396a6795bad1 100644
--- a/Makefile
+++ b/Makefile
@@ -343,7 +343,12 @@ CMAKE_COMMAND = /usr/bin/cmake
 # Build with "BUILD_TYPE=Release" to remove cmake debug info
 BUILD_TYPE ?= RelWithDebInfo
 
-$(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template
+BUILD_PREFIX := $(BUILD_OUTPUT)/build_prefix
+
+$(BUILD_PREFIX): force
+	$(Q)$(call build_prefix,$(prefix))
+
+$(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template $(BUILD_PREFIX)
 	$(Q) $(call do_make_pkgconfig_file,$(prefix))
 
 $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
diff --git a/scripts/utils.mk b/scripts/utils.mk
index c8ef44b3776a..c06888795ddf 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -121,6 +121,16 @@ define update_dir
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
 define do_install
 	$(print_install)				\
 	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
-- 
2.29.2


