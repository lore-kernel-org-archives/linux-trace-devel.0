Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 680CDC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 17:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2280423DE3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 17:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392636AbgLJROa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 12:14:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392633AbgLJROa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 12:14:30 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EEDD230FA
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Dec 2020 17:13:48 +0000 (UTC)
Date:   Thu, 10 Dec 2020 12:13:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add README
Message-ID: <20201210121347.5b8cfe33@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a README file that describes where the repositories are, how to build
and install the library, and how to ask questions and contribute.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 README | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 README

diff --git a/README b/README
new file mode 100644
index 0000000..ad95602
--- /dev/null
+++ b/README
@@ -0,0 +1,56 @@
+
+The official repository is here:
+
+  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+This repository requires libtraceevent to be installed:
+
+  https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
+
+
+To build:
+
+    make;
+    sudo make install;
+
+To build in a specific directory outside of the source directory:
+
+    make O=/path/to/build; sudo make O=/path/to/build
+
+  Note that the path needs to exist before building.
+
+To set the install path (the expected final location):
+
+    make prefix=/usr; sudo make O=/path/to/build
+
+To install in a directory not for the local system (for use to move
+to another machine):
+
+    make DESTDIR=/path/to/dest/ install
+
+  Note, if you have write permission to the DESTDIR, then there is
+  no reason to use sudo or switch to root.
+
+  Note, DESTDIR must end with '/', otherwise the files will be appended
+  to the path, which will most likely have unwanted results.
+
+Contributions:
+
+  For questions about the use of the library, please send email to:
+
+    linux-trace-users@vger.kernel.org
+
+    Subscribe: http://vger.kernel.org/vger-lists.html#linux-trace-users
+    Archives: https://lore.kernel.org/linux-trace-users/
+
+  For contributions to development, please send patches to:
+
+    linux-trace-devel@vger.kernel.org
+
+    Subscribe: http://vger.kernel.org/vger-lists.html#linux-trace-devel
+    Archives: https://lore.kernel.org/linux-trace-devel/
+
+  Note, this project follows the style of submitting patches as described
+  by the Linux kernel.
+
+     https://www.kernel.org/doc/html/v5.4/process/submitting-patches.html
-- 
2.25.4

