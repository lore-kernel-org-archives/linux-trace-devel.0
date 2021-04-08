Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961CDC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 17:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6722D61103
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 17:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhDHRwA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 13:52:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231918AbhDHRv7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 13:51:59 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 307476102A
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 17:51:48 +0000 (UTC)
Date:   Thu, 8 Apr 2021 13:51:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add minimum version for libtraceevent
Message-ID: <20210408135146.32a99951@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As libtracefs may in the future require new APIs from libtraceveent, add a
test to make sure that the required libtraceevent is installed on the
system.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 0eddb61..ff1a3a6 100644
--- a/Makefile
+++ b/Makefile
@@ -10,6 +10,8 @@ export TFS_PATCHLEVEL
 export TFS_EXTRAVERSION
 export TRACEFS_VERSION
 
+LIBTRACEEVENT_MIN_VERSION = 1.1
+
 # taken from trace-cmd
 MAKEFLAGS += --no-print-directory
 
@@ -62,12 +64,14 @@ includedir_SQ = '$(subst ','\'',$(includedir))'
 pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
 			--variable pc_path pkg-config | tr ":" " "))
 
-LIBTRACEEVENT_INCLUDES = $(shell $(PKG_CONFIG) --cflags libtraceevent)
-LIBTRACEEVENT_LIBS = $(shell $(PKG_CONFIG) --libs libtraceevent)
+TEST_LIBTRACEEVENT = $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEEVENT_MIN_VERSION) libtraceevent > /dev/null 2>&1 && echo y")
 
-ifneq ($(MAKECMDGOALS),clean)
- ifeq ("$(LIBTRACEEVENT_INCLUDES)","")
-   $(error libtraceevent.so not installed)
+ifeq ("$(TEST_LIBTRACEEVENT)", "y")
+LIBTRACEEVENT_INCLUDES = $(shell sh -c "$(PKG_CONFIG) --cflags libtraceevent")
+LIBTRACEEVENT_LIBS = $(shell sh -c "$(PKG_CONFIG) --libs libtraceevent")
+else
+ ifneq ($(MAKECMDGOALS),clean)
+   $(error libtraceevent.so minimum version of $(LIBTRACEEVENT_MIN_VERSION) not installed)
  endif
 endif
 
-- 
2.29.2

