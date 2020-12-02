Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB4BC64E7C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 18:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DB1121D7A
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 18:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387580AbgLBSHF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 13:07:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:55336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387531AbgLBSHE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 13:07:04 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEB54221FC
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Dec 2020 18:06:23 +0000 (UTC)
Date:   Wed, 2 Dec 2020 13:06:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Update .gitignore
Message-ID: <20201202130620.3f3a8264@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The .gitignore file is somewhat out of date. Update the main file as well as
adding a .gitignore in the tracecmd and kernel-shark directories.

Remove the exec names that use to be included in the top level directory,
and place them into the .gitignore in the directories that may build them.

Ignore files caused by running "patch".

Add *.data for perf files that may be in the directory.

Add .pc and patches/ to ignore quilt directories.

Add #*# to ignore emacs meta files.

Add a .gitignore file in kernel-shark to include all the files that are
built by the kernelshark build.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .gitignore              | 10 ++++++----
 kernel-shark/.gitignore | 22 ++++++++++++++++++++++
 tracecmd/.gitignore     |  1 +
 3 files changed, 29 insertions(+), 4 deletions(-)
 create mode 100644 kernel-shark/.gitignore
 create mode 100644 tracecmd/.gitignore

diff --git a/.gitignore b/.gitignore
index 6759e511..ca6c9cb6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,16 +1,18 @@
 *.o
-trace-cmd
 *.so
 *.a
 *.dat
+*.data
 *.patch
 .*.d
+*.orig
+*.rej
+.pc
 *~
-kernelshark
-trace-graph
-trace-view
 *.pyc
 *.swp
+\#*\#
+patches/
 tc_version.h
 ks_version.h
 ctracecmd_wrap.c
diff --git a/kernel-shark/.gitignore b/kernel-shark/.gitignore
new file mode 100644
index 00000000..a752f4ed
--- /dev/null
+++ b/kernel-shark/.gitignore
@@ -0,0 +1,22 @@
+bin/cmd_split
+bin/confio
+bin/dfilter
+bin/dhisto
+bin/dload
+bin/dplot
+bin/kernelshark
+bin/kshark-record
+bin/widgetdemo
+build/CMakeCache.txt
+build/CMakeDoxyfile.in
+build/CMakeDoxygenDefaults.cmake
+build/CMakeFiles/
+build/Makefile
+build/cmake_install.cmake
+build/examples/
+build/src/
+kernelshark.desktop
+lib/
+org.freedesktop.kshark-record.policy
+src/KsCmakeDef.hpp
+
diff --git a/tracecmd/.gitignore b/tracecmd/.gitignore
new file mode 100644
index 00000000..30f93eb4
--- /dev/null
+++ b/tracecmd/.gitignore
@@ -0,0 +1 @@
+trace-cmd
-- 
2.25.4

