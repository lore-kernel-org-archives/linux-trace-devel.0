Return-Path: <SRS0=Hh4L=U2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2746DC48BD9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 17:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0713421670
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 17:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfF0RHe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 13:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfF0RHe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 13:07:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9015214AF;
        Thu, 27 Jun 2019 17:07:33 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hgXrx-0004UU-3H; Thu, 27 Jun 2019 13:07:33 -0400
Message-Id: <20190627170732.991239997@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 27 Jun 2019 13:05:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Troy Engel <troyengel@gmail.com>
Subject: [PATCH v2 1/3] kernelshark: Update the README for changes to the make process
References: <20190627170553.050679238@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The top level git tree's Makefile has code added to build the cmake portion
of KernelShark. But the README does not document the process. Bring the
README up to speed with how to actually build KernelShark.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/README | 50 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 10 deletions(-)

diff --git a/kernel-shark/README b/kernel-shark/README
index 75a0dd08dcac..7155e13b17fc 100644
--- a/kernel-shark/README
+++ b/kernel-shark/README
@@ -30,18 +30,47 @@ Building:
 1. Follow the instructions given in trace-cmd/README and build
 the original trace-cmd end traceevent libraries.
 
-2. Do:
-    cd kernel-shark/build
-    cmake ../
-    make
+2. Building KernelShark:
+
+2.1 There is a simple and expert way to build KernelShark
+
+2.1.1 Option 1 (simple) : build KernelShark as part of trace-cmd
+
+   (from the toplevel git tree)
+
+      make gui
+
+   This will build the necessary parts of trace-cmd needed
+   by KernelShark.
+
+2.1.1.1 By default, the installation prefix is "/usr/local". It can be
+changed by passing in "prefix" to the build.
+
+   make prefix=/usr gui
 
-2.1.1 In order to create a Doxygen documentation add -D_DOXYGEN_DOC=1
+2.1.1.2 Use "make clean" if you want to delete all already compiled objects.
+Note, this will not clean up the files created by cmake. See section 2.1.2.4
+
+2.1.2 Option 2 (expert) : standalone build of KernelShark (for hackers only)
+
+   (note, you may need to do a normal make from the toplevel git
+    tree before performing the following)
+
+      make
+      cd kernel-shark/build
+      cmake ../
+      make
+
+    This gives you a bit more control as you may easily pass in
+    your own cmake options.
+
+2.1.2.1 In order to create a Doxygen documentation add -D_DOXYGEN_DOC=1
 as a CMake Command-Line option.
 
-2.1.2 By default, installation prefix is "/usr/local". It can be changed using
+2.1.2.2 By default, installation prefix is "/usr/local". It can be changed using
 -D_INSTALL_PREFIX= as a CMake Command-Line option.
 
-2.1.3 In addition to the standard CMake build types (Debug, Release,
+2.1.2.3 In addition to the standard CMake build types (Debug, Release,
 RelWithDebInfo, MinSizeRel) KernelShark supports a "Package" build type.
 By default this build type adds the "-O2" compiler flag. Package maintainers
 can chose their own compiler flags by providing the corresponding
@@ -57,10 +86,11 @@ Examples:
 
     cmake -DCMAKE_BUILD_TYPE=Package -DCMAKE_C_FLAGS_PACKAGE="-O3 -pedantic"  ../
 
-2.2.1 Use "make clean" if you want to delete all already compiled objects.
-
-2.2.2 Use the script "cmake_clean.sh" if you want to delete all already
+2.1.2.4 Use the script "cmake_clean.sh" if you want to delete all already
 compiled objects and all files generated by CMake.
 
+    cd kernel-shark/build
+    ./cmake-clean.sh
+
 3. After building the code "kernel-shark/lib" will contain all libraries
 and "kernel-shark/bin" will contain all executables.
-- 
2.20.1


