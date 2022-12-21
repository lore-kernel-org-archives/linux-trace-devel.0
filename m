Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26112C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Dec 2022 18:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbiLUSwB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Dec 2022 13:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234986AbiLUSv7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Dec 2022 13:51:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC01D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 10:51:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13095618E8
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 18:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106D4C433EF;
        Wed, 21 Dec 2022 18:51:56 +0000 (UTC)
Date:   Wed, 21 Dec 2022 13:51:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Mike Frysinger <vapier@google.com>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH] trace-cmd: Make sure 32 bit works on 64 bit file systems
Message-ID: <20221221135154.427ad9f4@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

As stat() can overflow if a 32 bit user space reads a file on a file
system that has inodes greater than MAX_INT. Compile with
_FILE_OFFSET_BITS=64 that mitigates this problem on 32 bit user space.

Reported-by: Mike Frysinger <vapier@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index bda49dd9b3d8..1f2797604392 100644
--- a/Makefile
+++ b/Makefile
@@ -350,6 +350,9 @@ export INCLUDES
 # Required CFLAGS
 override CFLAGS += -D_GNU_SOURCE
 
+# Make sure 32 bit stat() works on large file systems
+override CFLAGS += -D_FILE_OFFSET_BITS=64
+
 ifndef NO_PTRACE
 ifneq ($(call try-cc,$(SOURCE_PTRACE),),y)
 	NO_PTRACE = 1
-- 
2.35.1

