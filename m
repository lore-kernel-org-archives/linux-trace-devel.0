Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F229BC433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 21:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C570B221E5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 21:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbgLHV40 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:56:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729429AbgLHV40 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 16:56:26 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1481A2310E
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Dec 2020 21:55:06 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kmkwr-003std-4G
        for linux-trace-devel@vger.kernel.org; Tue, 08 Dec 2020 16:55:05 -0500
Message-ID: <20201208215504.983661503@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 08 Dec 2020 16:54:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/6] libtracefs: Use pkg-config to find libtraceevent
References: <20201208215404.135186972@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As libtracefs is dependent on libtraceevent, use the proper pkg-config
method to find where libtraceevent is installed.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index f6b6a9ede5c0..be57682d37c9 100644
--- a/Makefile
+++ b/Makefile
@@ -62,6 +62,13 @@ pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
 PKG_CONFIG_SOURCE_FILE = libtracefs.pc
 PKG_CONFIG_FILE := $(addprefix $(OUTPUT),$(PKG_CONFIG_SOURCE_FILE))
 
+LIBTRACEEVENT_INCLUDES = $(shell $(PKG_CONFIG) --cflags libtraceevent)
+LIBTRACEEVENT_LIBS = $(shell $(PKG_CONFIG) --libs libtraceevent)
+
+ifeq ("$(LIBTRACEEVENT_INCLUDES)","")
+$(error libtraceevent.so not installed)
+endif
+
 ifeq ($(prefix),/usr/local)
 etcdir ?= /etc
 else
@@ -128,7 +135,7 @@ export prefix bindir src obj bdir
 LIBTRACEFS_STATIC = $(bdir)/libtracefs.a
 LIBTRACEFS_SHARED = $(bdir)/libtracefs.so.$(TRACEFS_VERSION)
 
-TRACE_LIBS = -L$(bdir) -ltracefs
+TRACE_LIBS = $(LIBTRACEEVENT_LIBS)
 
 export LIBS TRACE_LIBS
 export LIBTRACEFS_STATIC LIBTRACEFS_SHARED
@@ -155,7 +162,7 @@ export CFLAGS
 export INCLUDES
 
 # Required CFLAGS
-override CFLAGS += -D_GNU_SOURCE
+override CFLAGS += -D_GNU_SOURCE $(LIBTRACEEVENT_INCLUDES)
 
 # Append required CFLAGS
 override CFLAGS += $(INCLUDES)
-- 
2.28.0


