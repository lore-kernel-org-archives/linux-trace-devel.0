Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9BC2C2BBCF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0AA3235F9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbgLPUMQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:12:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:35188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728558AbgLPUMQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 15:12:16 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B03B02368A
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 20:11:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpd94-000vv1-Nn
        for linux-trace-devel@vger.kernel.org; Wed, 16 Dec 2020 15:11:34 -0500
Message-ID: <20201216201134.586548693@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 15:11:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/8] libtracefs: Use $(obj) instead of $(OUTPUT) for libtracefs.pc file
References: <20201216201106.170659791@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The location of libtracefs.pc was incorrectly using $(OUTPUT) which does not
even exist, where it should have been using $(obj) instead.

Also need to move the variable declarations down below where $(obj) is
defined.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index dec05e3e3a6a..ab64ef3e4f54 100644
--- a/Makefile
+++ b/Makefile
@@ -61,9 +61,6 @@ includedir_SQ = '$(subst ','\'',$(includedir))'
 pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
 			--variable pc_path pkg-config | tr ":" " "))
 
-PKG_CONFIG_SOURCE_FILE = libtracefs.pc
-PKG_CONFIG_FILE := $(addprefix $(OUTPUT),$(PKG_CONFIG_SOURCE_FILE))
-
 LIBTRACEEVENT_INCLUDES = $(shell $(PKG_CONFIG) --cflags libtraceevent)
 LIBTRACEEVENT_LIBS = $(shell $(PKG_CONFIG) --libs libtraceevent)
 
@@ -133,6 +130,9 @@ LIBTRACEFS_SHARED = $(bdir)/libtracefs.so.$(TRACEFS_VERSION)
 
 TRACE_LIBS = $(LIBTRACEEVENT_LIBS)
 
+PKG_CONFIG_SOURCE_FILE = libtracefs.pc
+PKG_CONFIG_FILE := $(addprefix $(obj)/,$(PKG_CONFIG_SOURCE_FILE))
+
 export LIBS TRACE_LIBS
 export LIBTRACEFS_STATIC LIBTRACEFS_SHARED
 
-- 
2.29.2


