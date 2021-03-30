Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91EDAC433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A89F619A6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhC3AbN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 20:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230089AbhC3Aat (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 20:30:49 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29B0E61985
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Mar 2021 00:30:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lR2HQ-003TMX-4a
        for linux-trace-devel@vger.kernel.org; Mon, 29 Mar 2021 20:30:48 -0400
Message-ID: <20210330003048.022837218@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 29 Mar 2021 20:30:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] libtracefs: Add .gitignore files
References: <20210330003026.434340915@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add .gitignore files to remove backup files from vim and emacs, as well as
created files for installing and for documentation.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .gitignore               | 10 ++++++++++
 Documentation/.gitignore |  4 ++++
 2 files changed, 14 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 Documentation/.gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 000000000000..d2d39fbda7c2
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,10 @@
+*~
+\#*\#
+.pc
+libtracefs.pc
+TAGS
+tags
+lib/
+patches/
+build_prefix
+build_uninstall
diff --git a/Documentation/.gitignore b/Documentation/.gitignore
new file mode 100644
index 000000000000..747b2584d55b
--- /dev/null
+++ b/Documentation/.gitignore
@@ -0,0 +1,4 @@
+*.3
+*.m
+*.xml
+*.html
-- 
2.30.1


