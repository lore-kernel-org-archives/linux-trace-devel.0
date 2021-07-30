Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76149C4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 03:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52EE660EE6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 03:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbhG3DDS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 23:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234448AbhG3DDP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 23:03:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74AAE61019;
        Fri, 30 Jul 2021 03:03:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m9Inm-002PQt-1i; Thu, 29 Jul 2021 23:03:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/6] libtracefs: Update to version 1.3-dev
Date:   Thu, 29 Jul 2021 23:03:02 -0400
Message-Id: <20210730030307.574270-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210730030307.574270-1-rostedt@goodmis.org>
References: <20210730030307.574270-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Since the development of 1.3 source has diverged from the stable 1.2 path,
it still has the old 1.2.1 as the version number. If this is added to a
system with 1.2.2 or above, it wont be used, as the symlinks point to the
highest version (1.2.2 or above).

Set this to 1.3.dev to make it the latest version to be used.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 395b20745f9d..96d7f5528a56 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: LGPL-2.1
 # libtracefs version
 TFS_VERSION = 1
-TFS_PATCHLEVEL = 2
-TFS_EXTRAVERSION = 1
+TFS_PATCHLEVEL = 3
+TFS_EXTRAVERSION = dev
 TRACEFS_VERSION = $(TFS_VERSION).$(TFS_PATCHLEVEL).$(TFS_EXTRAVERSION)
 
 export TFS_VERSION
-- 
2.30.2

