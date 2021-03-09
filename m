Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98092C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Mar 2021 17:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D68765237
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Mar 2021 17:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhCIRWl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 12:22:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:35626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhCIRWS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 12:22:18 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABAE665237;
        Tue,  9 Mar 2021 17:22:17 +0000 (UTC)
Date:   Tue, 9 Mar 2021 12:22:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     pierre.gondois@arm.com
Subject: [PATCH] trace-cmd: Update make-trace-cmd.sh to handle pkg-config
 without --with-path
Message-ID: <20210309122216.4ce353e4@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Debian and Ubuntu's pkg-config does not support the "--with-path" option.
Check first if it is supported, and only use it when it is.

Set PKG_CONFIG_PATH to inform pkg-config where to search.

Note, this script may not be the best way to create packaging and there may
be better ways to do so.

Reported-by: pierre.gondois@arm.com
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=212149
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 make-trace-cmd.sh | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/make-trace-cmd.sh b/make-trace-cmd.sh
index ddff1814..31f32594 100755
--- a/make-trace-cmd.sh
+++ b/make-trace-cmd.sh
@@ -28,4 +28,12 @@ if [ -z "$PREFIX" ]; then
 	PREFIX="/usr"
 fi
 
-PKG_CONFIG="pkg-config --with-path $INSTALL_PATH/usr/lib64/pkgconfig --define-variable=prefix=$INSTALL_PATH/$PREFIX" CFLAGS="-g -Wall -I$INSTALL_PATH/$PREFIX/include" make DESTDIR=$INSTALL_PATH  $O_PATH prefix=$PREFIX $@
+PKG_PATH=`pkg-config --variable pc_path pkg-config | tr ":" " " | cut -d' ' -f1`
+
+WITH_PATH=""
+# If pkg-config supports --with-path, use that as well
+if pkg-config --with-path=/tmp --variable pc_path pkg-config &> /dev/null ; then
+	WITH_PATH="--with-path=$INSTALL_PATH$PKG_PATH"
+fi
+
+PKG_CONFIG_PATH="$INSTALL_PATH/$PKG_PATH" PKG_CONFIG="pkg-config $WITH_PATH --define-variable=prefix=$INSTALL_PATH/$PREFIX" CFLAGS="-g -Wall -I$INSTALL_PATH/$PREFIX/include" make DESTDIR=$INSTALL_PATH  $O_PATH prefix=$PREFIX $@
-- 
2.25.4

