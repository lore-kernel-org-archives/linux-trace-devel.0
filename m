Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE190C4167B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C20D923B77
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgLIEWC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 23:22:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727023AbgLIEWC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 23:22:02 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A290E23B19
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 04:21:21 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kmqye-000304-LN
        for linux-trace-devel@vger.kernel.org; Tue, 08 Dec 2020 23:21:20 -0500
Message-ID: <20201209042120.532937710@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 08 Dec 2020 23:19:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/6] libtraceevent: Move creation of PKG_CONFIG_FILE to after
 Makefile.include
References: <20201209041946.131377586@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The creation of the PKG_CONFIG_FILE appends $(OUTPUT) to
$(PKG_CONFIG_SOURCE_FILE) but this happens before the include of
Makefile.include, that defines what $(OUTPUT) is. The end result is that the
libtraceevent.pc file is not created in tho output directory that is
specified.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 3c2bd5619c3b..3f96c1c7b4d6 100644
--- a/Makefile
+++ b/Makefile
@@ -52,15 +52,15 @@ includedir_relative = traceevent
 includedir = $(prefix)/include/$(includedir_relative)
 includedir_SQ = '$(subst ','\'',$(includedir))'
 
-PKG_CONFIG_SOURCE_FILE = libtraceevent.pc
-PKG_CONFIG_FILE := $(addprefix $(OUTPUT),$(PKG_CONFIG_SOURCE_FILE))
-
 export man_dir man_dir_SQ INSTALL
 export DESTDIR DESTDIR_SQ
 export EVENT_PARSE_VERSION
 
 include scripts/Makefile.include
 
+PKG_CONFIG_SOURCE_FILE = libtraceevent.pc
+PKG_CONFIG_FILE := $(addprefix $(OUTPUT),$(PKG_CONFIG_SOURCE_FILE))
+
 # copy a bit from Linux kbuild
 
 ifeq ("$(origin V)", "command line")
-- 
2.29.2


