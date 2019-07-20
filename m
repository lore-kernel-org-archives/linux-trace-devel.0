Return-Path: <SRS0=TfJx=VR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92907C76195
	for <linux-trace-devel@archiver.kernel.org>; Sat, 20 Jul 2019 03:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A3BB2082F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 20 Jul 2019 03:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390435AbfGTDD5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 23:03:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39662 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390431AbfGTDD4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 23:03:56 -0400
Received: from chiana.gaikai.org (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 57A79348129
        for <linux-trace-devel@vger.kernel.org>; Sat, 20 Jul 2019 03:03:56 +0000 (UTC)
From:   Patrick McLean <chutzpah@gentoo.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/4] trace-cmd: No automagic dependency on udis86
Date:   Fri, 19 Jul 2019 20:03:42 -0700
Message-Id: <20190720030344.1991393-3-chutzpah@gentoo.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190720030344.1991393-1-chutzpah@gentoo.org>
References: <20190720030344.1991393-1-chutzpah@gentoo.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Patrick McLean <patrick.mclean@sony.com>

Currently if udis86 is detected on the system, trace-cmd automatically
uses it. This is generally a problem for packagers since if the build
machine happens to have udis86, now there is a dependency on it that may
or may not be tracked.

This adds a NO_UDIS86 variable that can be set by the packager to
disable using udis86 completely.

Signed-off-by: Patrick McLean <patrick.mclean@sony.com>
---
 Makefile | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 3579f27..6b85e21 100644
--- a/Makefile
+++ b/Makefile
@@ -136,8 +136,13 @@ export NO_PYTHON
 test-build = $(if $(shell sh -c 'echo "$(1)" | \
 	$(CC) -o /dev/null -c -x c - > /dev/null 2>&1 && echo y'), $2)
 
+ifndef NO_UDIS86
 # have udis86 disassembler library?
-udis86-flags := $(call test-build,\#include <udis86.h>,-DHAVE_UDIS86 -ludis86)
+udis86-flags := -DHAVE_UDIS86
+udis86-ldflags := -ludis86
+else
+udis86-flags := -UHAVE_UDIS86
+endif # NO_UDIS86
 
 define BLK_TC_FLUSH_SOURCE
 #include <linux/blktrace_api.h>
@@ -237,6 +242,7 @@ endif
 # Append required CFLAGS
 override CFLAGS += $(INCLUDES) $(PLUGIN_DIR_SQ) $(VAR_DIR)
 override CFLAGS += $(udis86-flags) $(blk-flags)
+override LDFLAGS += $(udis86-ldflags)
 
 CMD_TARGETS = trace-cmd $(BUILD_PYTHON)
 
-- 
2.22.0

