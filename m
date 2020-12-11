Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD79C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DFDE23F29
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392029AbgLKRLQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:11:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393493AbgLKRLA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 12:11:00 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CAC323E20
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 17:10:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knlvp-000HdU-Bb
        for linux-trace-devel@vger.kernel.org; Fri, 11 Dec 2020 12:10:13 -0500
Message-ID: <20201211171013.160572044@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 11 Dec 2020 12:08:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 02/13] trace-cmd: Allow overriding of pkg-config
References: <20201211170842.611554918@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Change the Makefile to allow overriding of what is used for pkg-config.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/Makefile b/Makefile
index 3334d92c2b85..8edd217b87b5 100644
--- a/Makefile
+++ b/Makefile
@@ -26,6 +26,7 @@ endef
 # Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
 $(call allow-override,CC,$(CROSS_COMPILE)gcc)
 $(call allow-override,AR,$(CROSS_COMPILE)ar)
+$(call allow-override,PKG_CONFIG,pkg-config)
 
 EXT = -std=gnu99
 INSTALL = install
@@ -133,7 +134,7 @@ PYTHON_VERS ?= python
 PYTHON_PKGCONFIG_VERS ?= $(PYTHON_VERS)
 
 # Can build python?
-ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_PKGCONFIG_VERS) > /dev/null 2>&1 && echo y"), y)
+ifeq ($(shell sh -c "$(PKG_CONFIG) --cflags $(PYTHON_PKGCONFIG_VERS) > /dev/null 2>&1 && echo y"), y)
 	BUILD_PYTHON := $(PYTHON)
 	BUILD_PYTHON_WORKS := 1
 else
@@ -206,9 +207,9 @@ LIBTRACEFS_DIR = $(obj)/lib/tracefs
 LIBTRACEFS_STATIC = $(LIBTRACEFS_DIR)/libtracefs.a
 LIBTRACEFS_SHARED = $(LIBTRACEFS_DIR)/libtracefs.so
 
-ifeq ($(shell sh -c "pkg-config --cflags $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y"), y)
-LIBTRACEEVENT_CFLAGS = $(shell sh -c "pkg-config --cflags $(LIBTRACEEVENT)")
-LIBTRACEEVENT_LDLAGS = $(shell sh -c "pkg-config --libs $(LIBTRACEEVENT)")
+ifeq ($(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y"), y)
+LIBTRACEEVENT_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT)")
+LIBTRACEEVENT_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEEVENT)")
 else
 LIBTRACEEVENT_CFLAGS = -I$(src)/include/traceevent -I$(src)/lib/traceevent/include
 LIBTRACEEVENT_LDLAGS = -L$(LIBTRACEEVENT_DIR) -ltraceevent
@@ -218,9 +219,9 @@ endif
 
 export LIBTRACEEVENT_CFLAGS LIBTRACEEVENT_LDLAGS
 
-ifeq ($(shell sh -c "pkg-config --cflags $(LIBTRACEFS) > /dev/null 2>&1 && echo y"), y)
-LIBTRACEFS_CFLAGS = $(shell sh -c "pkg-config --cflags $(LIBTRACEFS)")
-LIBTRACEFS_LDLAGS = $(shell sh -c "pkg-config --libs $(LIBTRACEFS)")
+ifeq ($(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEFS) > /dev/null 2>&1 && echo y"), y)
+LIBTRACEFS_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEFS)")
+LIBTRACEFS_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEFS)")
 else
 LIBTRACEFS_CFLAGS = -I$(src)/include/tracefs
 LIBTRACEFS_LDLAGS = -L$(LIBTRACEFS_DIR) -ltracefs
@@ -494,10 +495,10 @@ report_nopythondev: force
 	$(Q)echo
 
 ifndef NO_PYTHON
-PYTHON_INCLUDES = `pkg-config --cflags $(PYTHON_PKGCONFIG_VERS)`
-PYTHON_LDFLAGS = `pkg-config --libs $(PYTHON_PKGCONFIG_VERS)` \
+PYTHON_INCLUDES = `$(PKG_CONFIG) --cflags $(PYTHON_PKGCONFIG_VERS)`
+PYTHON_LDFLAGS = `$(PKG_CONFIG) --libs $(PYTHON_PKGCONFIG_VERS)` \
 		$(shell $(PYTHON_VERS)-config --ldflags)
-PYGTK_CFLAGS = `pkg-config --cflags pygtk-2.0`
+PYGTK_CFLAGS = `$(PKG_CONFIG) --cflags pygtk-2.0`
 else
 PYTHON_INCLUDES =
 PYTHON_LDFLAGS =
-- 
2.29.2


