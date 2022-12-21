Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5173DC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Dec 2022 18:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiLUSlI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Dec 2022 13:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbiLUSk5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Dec 2022 13:40:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A421D13D75
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 10:40:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3394D618E3
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 18:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E79EC433D2;
        Wed, 21 Dec 2022 18:40:53 +0000 (UTC)
Date:   Wed, 21 Dec 2022 13:40:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Mike Frysinger <vapier@google.com>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v2] libtraceevent: Make sure 32 bit works on 64 bit file
 systems
Message-ID: <20221221134051.53aad658@gandalf.local.home>
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
index 965ff47eae7d..a8a56b6773be 100644
--- a/Makefile
+++ b/Makefile
@@ -130,6 +130,9 @@ else
   CFLAGS := -g -Wall
 endif
 
+# Make sure 32 bit stat() works on large file systems
+CFLAGS += -D_FILE_OFFSET_BITS=64
+
 LIBS ?= -ldl
 export LIBS
 
-- 
2.35.1

