Return-Path: <SRS0=wCVW=VV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D084AC76186
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 23:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A23F721911
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 23:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbfGXXIB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Jul 2019 19:08:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbfGXXIB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 19:08:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E64E721850;
        Wed, 24 Jul 2019 23:07:59 +0000 (UTC)
Date:   Wed, 24 Jul 2019 19:07:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Patrick McLean <chutzpah@gentoo.org>, howaboutsynergy@pm.me
Subject: [PATCH v2] trace-cmd: Only add udis86 CFLAGS and LDFLAGS if it is
 found
Message-ID: <20190724190758.4e18498f@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[ Patrick, so this works for you, can you give a "tested-by"? ]

As we need to update both LDFLAGS and CFLAGS, move the test to see if
udisc86 is installed to a variable, and then set NO_UDIS86 if it is not
found. This way we do not need to test if it exists twice, nor have
LDFLAGS set unconditionally.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204277

Reported-by: howaboutsynergy@pm.me
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
diff --git a/Makefile b/Makefile
index 0aa98517..3e63e9e9 100644
--- a/Makefile
+++ b/Makefile
@@ -136,9 +136,14 @@ export NO_PYTHON
 test-build = $(if $(shell sh -c 'echo "$(1)" | \
 	$(CC) -o /dev/null -c -x c - > /dev/null 2>&1 && echo y'), $2)
 
+UDIS86_AVAILABLE := $(call test-build,\#include <udis86.h>, y)
+ifneq ($(strip $(UDIS86_AVAILABLE)), y)
+NO_UDIS86 := 1
+endif
+
 ifndef NO_UDIS86
 # have udis86 disassembler library?
-udis86-flags := $(call test-build,\#include <udis86.h>,-DHAVE_UDIS86 -ludis86)
+udis86-flags := -DHAVE_UDIS86 -ludis86
 udis86-ldflags := -ludis86
 endif # NO_UDIS86
 
