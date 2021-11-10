Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46537C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 02:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F14661184
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 02:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhKJCmT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Nov 2021 21:42:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229717AbhKJCmS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 21:42:18 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A656061181
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Nov 2021 02:39:31 +0000 (UTC)
Date:   Tue, 9 Nov 2021 21:39:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Move the .m and .html ignore into Documentation
 file
Message-ID: <20211109213929.1a84ac32@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Ignoring the .m and .html output files from the Documentation directory
was located in the directory for the libtracecmd documentation. But it is
also needed for the trace-cmd documentation. Remove the .gitignore file
from libtracecmd documentation directory, and move its contents into the
.gitignore file of the top level Documentation directory.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/.gitignore             | 2 ++
 Documentation/libtracecmd/.gitignore | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)
 delete mode 100644 Documentation/libtracecmd/.gitignore

diff --git a/Documentation/.gitignore b/Documentation/.gitignore
index aecd243f..8a38b2ea 100644
--- a/Documentation/.gitignore
+++ b/Documentation/.gitignore
@@ -1 +1,3 @@
 *.[1-9]
+*.m
+*.html
diff --git a/Documentation/libtracecmd/.gitignore b/Documentation/libtracecmd/.gitignore
deleted file mode 100644
index 89b40e42..00000000
--- a/Documentation/libtracecmd/.gitignore
+++ /dev/null
@@ -1,2 +0,0 @@
-*.m
-*.html
-- 
2.31.1

