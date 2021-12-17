Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55695C43219
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhLQFuv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:50:51 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49988 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbhLQFut (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:50:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6AAF8CE23E8
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7628EC36AE1;
        Fri, 17 Dec 2021 05:50:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my68h-00056Y-BI;
        Fri, 17 Dec 2021 00:50:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 01/15] libtracefs: Update gitignore file
Date:   Fri, 17 Dec 2021 00:50:27 -0500
Message-Id: <20211217055041.19559-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217055041.19559-1-rostedt@goodmis.org>
References: <20211217055041.19559-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add more files that should be ignored in the build. For some reason the .o
files were not ignored. Also ignore the dependency .d files. And a few
miscellaneous files.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .gitignore               | 4 ++++
 Documentation/.gitignore | 1 +
 2 files changed, 5 insertions(+)

diff --git a/.gitignore b/.gitignore
index ff3e01438270..88c9b42f1a28 100644
--- a/.gitignore
+++ b/.gitignore
@@ -5,7 +5,11 @@ libtracefs.pc
 TAGS
 tags
 lib/
+bin/
 patches/
 build_prefix
 build_uninstall
 tfs_version.h
+*.o
+*.d
+sqlhist
diff --git a/Documentation/.gitignore b/Documentation/.gitignore
index 747b2584d55b..4d2414d3f6b6 100644
--- a/Documentation/.gitignore
+++ b/Documentation/.gitignore
@@ -1,4 +1,5 @@
 *.3
+sqlhist.1
 *.m
 *.xml
 *.html
-- 
2.33.0

