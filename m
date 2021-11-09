Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75164C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 16:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A11F611CA
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 16:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238919AbhKIQRO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Nov 2021 11:17:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237427AbhKIQRO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 11:17:14 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAF0460FD8
        for <linux-trace-devel@vger.kernel.org>; Tue,  9 Nov 2021 16:14:27 +0000 (UTC)
Date:   Tue, 9 Nov 2021 11:14:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Add Requires: libtracefs to libtracecmd.pc file
Message-ID: <20211109111426.7639b2a6@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In order to not have users of libtracecmd having to also include the
includes and libraries for libtracefs and libraceevent, add a requires
field for libtracefs to the libtracecmd.pc file. As libtracefs requires
libtraceevent, it will pull that one in as well.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 libtracecmd.pc.template | 1 +
 scripts/utils.mk        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/libtracecmd.pc.template b/libtracecmd.pc.template
index dc41076e..bcf4e39d 100644
--- a/libtracecmd.pc.template
+++ b/libtracecmd.pc.template
@@ -6,5 +6,6 @@ Name: libtracecmd
 URL: https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 Description: Library for creating and reading trace-cmd data files
 Version: LIB_VERSION
+Requires: libtracefs >= LIBTRACEFS_MIN_VERSION
 Cflags: -I${includedir}
 Libs: -L${libdir} -ltracecmd
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 237b2fc9..6865a746 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -169,6 +169,7 @@ define do_make_pkgconfig_file
 	sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
 	sed -i "s|LIB_VERSION|${LIBTRACECMD_VERSION}|g" ${PKG_CONFIG_FILE}; \
 	sed -i "s|LIB_DIR|$(libdir)|g" ${PKG_CONFIG_FILE}; \
+	sed -i "s|LIBTRACEFS_MIN_VERSION|$(LIBTRACEFS_MIN_VERSION)|g" ${PKG_CONFIG_FILE}; \
 	sed -i "s|HEADER_DIR|$(includedir)/trace-cmd|g" ${PKG_CONFIG_FILE};
 endef
 
-- 
2.31.1

