Return-Path: <SRS0=P3iB=VU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826AEC76186
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 19:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55F5E2229A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 19:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbfGWTLP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 15:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728441AbfGWTLP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 15:11:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1682D21849;
        Tue, 23 Jul 2019 19:11:14 +0000 (UTC)
Date:   Tue, 23 Jul 2019 15:11:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Patrick McLean <patrick.mclean@sony.com>
Subject: [PATCH 2/4 v3] trace-cmd: No automagic dependency on udis86
Message-ID: <20190723151112.59ef336c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: Patrick McLean <patrick.mclean@sony.com>

[ Resending again, without claws-mail mangling the lines :-p ]

Currently if udis86 is detected on the system, trace-cmd automatically
uses it. This is generally a problem for packagers since if the build
machine happens to have udis86, now there is a dependency on it that may
or may not be tracked.

This adds a NO_UDIS86 variable that can be set by the packager to
disable using udis86 completely.

Signed-off-by: Patrick McLean <patrick.mclean@sony.com>
---
 Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index 3579f27..ee3d8d9 100644
--- a/Makefile
+++ b/Makefile
@@ -136,8 +136,11 @@ export NO_PYTHON
 test-build = $(if $(shell sh -c 'echo "$(1)" | \
 	$(CC) -o /dev/null -c -x c - > /dev/null 2>&1 && echo y'), $2)
 
+ifndef NO_UDIS86
 # have udis86 disassembler library?
 udis86-flags := $(call test-build,\#include <udis86.h>,-DHAVE_UDIS86 -ludis86)
+udis86-ldflags := -ludis86
+endif # NO_UDIS86
 
 define BLK_TC_FLUSH_SOURCE
 #include <linux/blktrace_api.h>
@@ -237,6 +240,7 @@ endif
 # Append required CFLAGS
 override CFLAGS += $(INCLUDES) $(PLUGIN_DIR_SQ) $(VAR_DIR)
 override CFLAGS += $(udis86-flags) $(blk-flags)
+override LDFLAGS += $(udis86-ldflags)
 
 CMD_TARGETS = trace-cmd $(BUILD_PYTHON)
 
-- 
2.22.0
