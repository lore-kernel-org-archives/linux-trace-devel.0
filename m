Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D134C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 14:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A33222B45
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 14:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgLUO71 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 09:59:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:59306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgLUO71 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 09:59:27 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D60F322B45
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Dec 2020 14:58:46 +0000 (UTC)
Date:   Mon, 21 Dec 2020 09:58:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Add LOCAL_LIBS variable to force building the
 local libraries
Message-ID: <20201221095845.1a6f2aa7@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In the process of changing the API for libtracefs before it becomes live,
add LOCAL_LIBS make command line variable to allow overriding the check if
libtracevent and libtracefs exist. If LOCAL_LIBS=1 is set on the make
command line, then the local versions of the libraries are built.

This is mostly for debug purposes, so it does not need to be documented.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 7aef50b3..eb833f67 100644
--- a/Makefile
+++ b/Makefile
@@ -232,7 +232,15 @@ LIBTRACEFS=libtracefs
 LIBTRACEFS_DIR = $(obj)/lib/tracefs
 LIBTRACEFS_STATIC = $(LIBTRACEFS_DIR)/libtracefs.a
 
-ifeq ($(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y"), y)
+# In the special case (debugging), that the local versions of the
+# libraries need to be built, adding "LOCAL_LIBS=1" to the make
+# command line will skip the check if they are installed.
+ifneq ("$(origin LOCAL_LIBS)", "command line")
+TEST_LIBTRACEEVENT = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y")
+TEST_LIBTRACEFS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEFS) > /dev/null 2>&1 && echo y")
+endif
+
+ifeq ("$(TEST_LIBTRACEEVENT)", "y")
 LIBTRACEEVENT_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT)")
 LIBTRACEEVENT_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEEVENT)")
 else
@@ -243,7 +251,7 @@ endif
 
 export LIBTRACEEVENT_CFLAGS LIBTRACEEVENT_LDLAGS
 
-ifeq ($(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEFS) > /dev/null 2>&1 && echo y"), y)
+ifeq ("$(TEST_LIBTRACEFS)", "y")
 LIBTRACEFS_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEFS)")
 LIBTRACEFS_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEFS)")
 else
-- 
2.25.4

