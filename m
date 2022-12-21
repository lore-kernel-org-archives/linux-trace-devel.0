Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4037AC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Dec 2022 18:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiLUStU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Dec 2022 13:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiLUStJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Dec 2022 13:49:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F921E70C
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 10:49:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBAE3B81BD2
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 18:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8CDC433D2;
        Wed, 21 Dec 2022 18:49:05 +0000 (UTC)
Date:   Wed, 21 Dec 2022 13:49:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Mike Frysinger <vapier@google.com>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtracefs: Make sure 32 bit works on 64 bit file systems
Message-ID: <20221221134903.4520c983@gandalf.local.home>
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
index 27d425c975ad..36c2076cf788 100644
--- a/Makefile
+++ b/Makefile
@@ -164,6 +164,9 @@ export INCLUDES
 # Append required CFLAGS
 override CFLAGS += -D_GNU_SOURCE $(LIBTRACEEVENT_INCLUDES) $(INCLUDES)
 
+# Make sure 32 bit stat() works on large file systems
+override CFLAGS += -D_FILE_OFFSET_BITS=64
+
 all: all_cmd
 
 LIB_TARGET  = libtracefs.a libtracefs.so.$(TRACEFS_VERSION)
-- 
2.35.1

