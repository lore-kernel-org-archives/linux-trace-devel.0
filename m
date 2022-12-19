Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEBA0C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Dec 2022 22:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiLSWeW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Dec 2022 17:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiLSWeV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Dec 2022 17:34:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D906254
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Dec 2022 14:34:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0129B81047
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Dec 2022 22:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A59CC433EF;
        Mon, 19 Dec 2022 22:34:17 +0000 (UTC)
Date:   Mon, 19 Dec 2022 17:34:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Mike Frysinger <vapier@google.com>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceevent: Have 32 bit compile with
 -D_FILE_OFFSET_BITS=64
Message-ID: <20221219173414.032e2124@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

As stat() can overflow if a 32 bit user space is running on a 64 bit
kernel and the inode is more than 32 bits, compile with
_FILE_OFFSET_BITS=64 that mitigates this problem on 32 bit user space.

Do this by running the cross compiler cpp and checking what __LONG_SIZE__
is. If it returns 4, then add the define.

Reported-by: Mike Frysinger <vapier@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Makefile b/Makefile
index 965ff47eae7d..fd324033f6d7 100644
--- a/Makefile
+++ b/Makefile
@@ -23,6 +23,7 @@ endef
 $(call allow-override,CC,$(CROSS_COMPILE)gcc)
 $(call allow-override,AR,$(CROSS_COMPILE)ar)
 $(call allow-override,NM,$(CROSS_COMPILE)nm)
+$(call allow-override,CPP,$(CROSS_COMPILE)cpp)
 $(call allow-override,PKG_CONFIG,pkg-config)
 $(call allow-override,LD_SO_CONF_PATH,/etc/ld.so.conf.d/)
 $(call allow-override,LDCONFIG,ldconfig)
@@ -130,6 +131,11 @@ else
   CFLAGS := -g -Wall
 endif
 
+# Make sure 32 bit on 64 bit doesn't have stat() bugs.
+ifeq ($(shell echo '' | $(CPP) -dM - | grep __SIZEOF_LONG__ | cut -d' ' -f3),4)
+	CFLAGS += -D_FILE_OFFSET_BITS=64
+endif
+
 LIBS ?= -ldl
 export LIBS
 
-- 
2.35.1

