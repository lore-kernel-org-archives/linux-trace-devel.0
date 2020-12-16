Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B82C2BBCD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF4292371F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbgLPXW1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 18:22:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:59560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727942AbgLPXW1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 18:22:27 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84B7C23719;
        Wed, 16 Dec 2020 23:21:46 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpg77-000xHL-Ij; Wed, 16 Dec 2020 18:21:45 -0500
Message-ID: <20201216232145.409840117@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 18:19:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/6 v2] trace-cmd: Add a make-trace-cmd.sh script to simplify creating a
 trace-cmd package
References: <20201216231942.127326802@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a script "make-trace-cmd.sh" and a help file "PACKAGKING" to describe
what it does. The make-trace-cmd.sh will help create a full directory that
has libtraceevent, libtracefs, libtracecmd and trace-cmd binary without
needing to install them on the host machine.

As described in PACKAGING, the steps to do so are:

 git clone git://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git
 git clone git://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git
 git clone git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git

 cd libtraceevent
 INSTALL_PATH=/tmp/install ../trace-cmd/make-trace-cmd.sh install

 cd ../libtracefs
 INSTALL_PATH=/tmp/install ../trace-cmd/make-trace-cmd.sh install

 cd ../trace-cmd
 INSTALL_PATH=/tmp/install ./make-trace-cmd.sh install install_libs

 cd /tmp/install
 tar cvjf /tmp/trace-cmd-files.tar.bz2 .

And then the tarball of /tmp/trace-cmd-files.tar.bz2 will can be extracted
on another machine at the root directory, and trace-cmd will be installed there.

Note, the above process uses the /usr prefix. To have the package be
installed in /usr/local, add:

 PREFIX=/usr/local

in front of each of the make-trace-cmd.sh commands.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 PACKAGING         | 30 ++++++++++++++++++++++++++++++
 make-trace-cmd.sh | 31 +++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)
 create mode 100644 PACKAGING
 create mode 100755 make-trace-cmd.sh

diff --git a/PACKAGING b/PACKAGING
new file mode 100644
index 000000000000..7e7d20653017
--- /dev/null
+++ b/PACKAGING
@@ -0,0 +1,30 @@
+The libtracefs and libtraceevent packages are required for trace-cmd
+and libtracecmd.so
+
+In order to create a package directory with libtraceevent, libtracefs
+and libtracecmd and trace-cmd, you can follow these steps:
+
+ git clone git://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git
+ git clone git://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git
+ git clone git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git
+
+ cd libtraceevent
+ INSTALL_PATH=/tmp/install ../trace-cmd/make-trace-cmd.sh install
+
+ cd ../libtracefs
+ INSTALL_PATH=/tmp/install ../trace-cmd/make-trace-cmd.sh install
+
+ cd ../trace-cmd
+ INSTALL_PATH=/tmp/install ./make-trace-cmd.sh install install_libs
+
+ cd /tmp/install
+ tar cvjf /tmp/trace-cmd-files.tar.bz2 .
+
+And then the tarball of /tmp/trace-cmd-files.tar.bz2 will can be extracted
+on another machine at the root directory, and trace-cmd will be installed there.
+
+Note, to define a prefix, add a PREFIX variable before calling make-trace-cmd.sh
+
+ For example:
+
+  PREFIX=/usr/local INSTALL_PATH=/tmp/install ./make-trace-cmd.sh install
diff --git a/make-trace-cmd.sh b/make-trace-cmd.sh
new file mode 100755
index 000000000000..ddff18146c84
--- /dev/null
+++ b/make-trace-cmd.sh
@@ -0,0 +1,31 @@
+#!/bin/bash
+
+if [ -z "$INSTALL_PATH" ]; then
+	echo
+	echo 'Error: No $INSTALL_PATH defined'
+	echo
+	echo "   usage: [PREFIX=prefix][BUILD_PATH=/path/to/build] INSTALL_PATH=/path/to/install make-trace-cmd.sh install|install_libs|clean|uninstall"
+	echo
+	echo "     Used to create a self contained directory to copy to other machines."
+	echo
+	echo "   Please read PACKAGING for more information."
+	echo
+	exit
+fi
+
+if [ ! -d $INSTALL_PATH ]; then
+	mkdir $INSTALL_PATH
+fi
+
+if [ ! -z "$BUILD_PATH" ]; then
+	if [ ! -d $BUILD_PATH ]; then
+		mkdir $BUILD_PATH
+	fi
+	O_PATH="O=$BUILD_PATH"
+fi
+
+if [ -z "$PREFIX" ]; then
+	PREFIX="/usr"
+fi
+
+PKG_CONFIG="pkg-config --with-path $INSTALL_PATH/usr/lib64/pkgconfig --define-variable=prefix=$INSTALL_PATH/$PREFIX" CFLAGS="-g -Wall -I$INSTALL_PATH/$PREFIX/include" make DESTDIR=$INSTALL_PATH  $O_PATH prefix=$PREFIX $@
-- 
2.29.2


