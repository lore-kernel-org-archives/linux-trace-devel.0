Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D4BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Jul 2022 19:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiGKTYA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 15:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiGKTX7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 15:23:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8503DF3B
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 12:23:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77633615A1
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 19:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A971DC34115
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 19:23:57 +0000 (UTC)
Date:   Mon, 11 Jul 2022 15:23:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd make-trace-cmd.sh: Allow overriding of CFLAGS
Message-ID: <20220711152356.65790b1b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Instead of hard coding CFLAGS to be "-g -Wall", have that be the default,
but if the user adds their own CFLAGS, it will override that.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 make-trace-cmd.sh | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/make-trace-cmd.sh b/make-trace-cmd.sh
index 31f32594c7d4..c16edf231ccb 100755
--- a/make-trace-cmd.sh
+++ b/make-trace-cmd.sh
@@ -4,7 +4,7 @@ if [ -z "$INSTALL_PATH" ]; then
 	echo
 	echo 'Error: No $INSTALL_PATH defined'
 	echo
-	echo "   usage: [PREFIX=prefix][BUILD_PATH=/path/to/build] INSTALL_PATH=/path/to/install make-trace-cmd.sh install|install_libs|clean|uninstall"
+	echo "   usage: [PREFIX=prefix][BUILD_PATH=/path/to/build][CFLAGS=custom-cflags] INSTALL_PATH=/path/to/install make-trace-cmd.sh install|install_libs|clean|uninstall"
 	echo
 	echo "     Used to create a self contained directory to copy to other machines."
 	echo
@@ -36,4 +36,8 @@ if pkg-config --with-path=/tmp --variable pc_path pkg-config &> /dev/null ; then
 	WITH_PATH="--with-path=$INSTALL_PATH$PKG_PATH"
 fi
 
-PKG_CONFIG_PATH="$INSTALL_PATH/$PKG_PATH" PKG_CONFIG="pkg-config $WITH_PATH --define-variable=prefix=$INSTALL_PATH/$PREFIX" CFLAGS="-g -Wall -I$INSTALL_PATH/$PREFIX/include" make DESTDIR=$INSTALL_PATH  $O_PATH prefix=$PREFIX $@
+if [ -z "$CFLAGS" ]; then
+    CFLAGS="-g -Wall"
+fi
+
+PKG_CONFIG_PATH="$INSTALL_PATH/$PKG_PATH" PKG_CONFIG="pkg-config $WITH_PATH --define-variable=prefix=$INSTALL_PATH/$PREFIX" CFLAGS="-I$INSTALL_PATH/$PREFIX/include $CFLAGS" make DESTDIR=$INSTALL_PATH  $O_PATH prefix=$PREFIX $@
-- 
2.35.1

