Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FFBC2BB9A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7A8F23719
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgLPXW1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 18:22:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:59590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730459AbgLPXW1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 18:22:27 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8E122399A;
        Wed, 16 Dec 2020 23:21:46 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpg77-000xHp-OY; Wed, 16 Dec 2020 18:21:45 -0500
Message-ID: <20201216232145.613591947@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 18:19:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/6 v2] trace-cmd: Do not have local builds of libtraceevent or libtracefs
 use system headers
References: <20201216231942.127326802@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If building locally, do not use system includes. This is needed for
kernelshark v1 to build libtraceevent and libtracefs. If the system header
files are used, there may be a mismatch with the frozen version of
libtraceevent or libtracefs that kernelshark will use, and the system
headers, and the build will fail.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/traceevent/Makefile | 4 ++++
 lib/tracefs/Makefile    | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/lib/traceevent/Makefile b/lib/traceevent/Makefile
index 0dcd90c13328..21ef5a4ea59f 100644
--- a/lib/traceevent/Makefile
+++ b/lib/traceevent/Makefile
@@ -6,8 +6,12 @@ bdir:=$(obj)/lib/traceevent
 
 DEFAULT_TARGET = $(bdir)/libtraceevent.a
 
+LIBTRACEEVENT_CFLAGS = -I$(src)/include/traceevent -I$(src)/lib/traceevent/include
+
 CFLAGS += -I$(bdir)/include
 
+CFLAGS := $(LIBTRACEEVENT_CFLAGS) $(CFLAGS)
+
 OBJS =
 OBJS += event-parse.o
 OBJS += event-plugin.o
diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
index 021ae2b040de..6f4370d96f10 100644
--- a/lib/tracefs/Makefile
+++ b/lib/tracefs/Makefile
@@ -6,8 +6,13 @@ bdir:=$(obj)/lib/tracefs
 
 DEFAULT_TARGET = $(bdir)/libtracefs.a
 
+LIBTRACEEVENT_CFLAGS = -I$(src)/include/traceevent -I$(src)/lib/traceevent/include
+LIBTRACEFS_CFLAGS = -I$(src)/include/tracefs -I$(src)/lib/tracefs/include
+
 CFLAGS += -I$(bdir)/include
 
+CFLAGS := $(LIBTRACEEVENT_CFLAGS) $(LIBTRACEFS_CFLAGS) $(CFLAGS)
+
 OBJS =
 OBJS += tracefs-utils.o
 OBJS += tracefs-instance.o
-- 
2.29.2


