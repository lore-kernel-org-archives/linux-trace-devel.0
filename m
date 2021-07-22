Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26714C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 19:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B1C960EE0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 19:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhGVTOI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Jul 2021 15:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhGVTOH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Jul 2021 15:14:07 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 111DA60ED8;
        Thu, 22 Jul 2021 19:54:41 +0000 (UTC)
Date:   Thu, 22 Jul 2021 15:54:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Cc:     Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: [PATCH] libtracefs: Add Requires libtraceevent to pkg-config file
Message-ID: <20210722155435.773e91ec@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From e0e16d1a16749dccd3c00261e6dcb78f2e55e8ec Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Thu, 22 Jul 2021 15:44:55 -0400
Subject: [PATCH] libtracefs: Add Requires libtraceevent to pkg-config file

If a developer uses libtracefs only, they should not need to know about
libtraceevent just because libtracefs requires it.

The pkg-config pc file has an option to handle such cases, called
"Requires:". Utilize this feature so that users using libtracefs only need
to do:

  CFLAGS = `pkg-config --cflags --libs libtracefs`

And not:

  CFLAGS = `pkg-config --cflags --libs libtracefs libtraceevent`

As with the Requires option, pkg-config now produces:

 $ pkg-config --cflags --libs libtracefs
 -I/usr/local/include/tracefs -I/usr/local/include/traceevent -ltracefs -ltraceevent

Reported-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile               | 3 ++-
 libtracefs.pc.template | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index b509388..395b207 100644
--- a/Makefile
+++ b/Makefile
@@ -215,7 +215,8 @@ define do_make_pkgconfig_file
 	sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
 	sed -i "s|LIB_VERSION|${TRACEFS_VERSION}|g" ${PKG_CONFIG_FILE}; \
 	sed -i "s|LIB_DIR|${libdir_relative}|g" ${PKG_CONFIG_FILE}; \
-	sed -i "s|HEADER_DIR|$(includedir_relative)|g" ${PKG_CONFIG_FILE};
+	sed -i "s|HEADER_DIR|$(includedir_relative)|g" ${PKG_CONFIG_FILE}; \
+	sed -i "s|LIBTRACEEVENT_MIN|$(LIBTRACEEVENT_MIN_VERSION)|g" ${PKG_CONFIG_FILE};
 endef
 
 BUILD_PREFIX := $(BUILD_OUTPUT)/build_prefix
diff --git a/libtracefs.pc.template b/libtracefs.pc.template
index a674fee..09b335b 100644
--- a/libtracefs.pc.template
+++ b/libtracefs.pc.template
@@ -6,5 +6,6 @@ Name: libtracefs
 URL: https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 Description: Library for accessing ftrace file system
 Version: LIB_VERSION
+Requires: libtraceevent > LIBTRACEEVENT_MIN
 Cflags: -I${includedir}
 Libs: -L${libdir} -ltracefs
-- 
2.31.1

