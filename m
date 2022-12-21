Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65723C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Dec 2022 18:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbiLUSrC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Dec 2022 13:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234902AbiLUSrB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Dec 2022 13:47:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D1D1EC4A
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 10:47:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D921DB81BEC
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 18:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A331C433EF;
        Wed, 21 Dec 2022 18:46:58 +0000 (UTC)
Date:   Wed, 21 Dec 2022 13:46:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Mike Frysinger <vapier@google.com>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v3] libtraceevent: Make sure 32 bit works on 64 bit file
 systems
Message-ID: <20221221134656.79589e83@gandalf.local.home>
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
Changes since v2: https://lore.kernel.org/linux-trace-devel/20221221134051.53aad658@gandalf.local.home/

 - Add "override" otherwise it can get lost if CFLAGS is defined externally

 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index 965ff47eae7d..746aedb528de 100644
--- a/Makefile
+++ b/Makefile
@@ -164,6 +164,9 @@ override CFLAGS += -fPIC
 override CFLAGS += $(CONFIG_FLAGS) $(INCLUDES) $(PLUGIN_DIR_SQ)
 override CFLAGS += $(udis86-flags) -D_GNU_SOURCE
 
+# Make sure 32 bit stat() works on large file systems
+override CFLAGS += -D_FILE_OFFSET_BITS=64
+
 ifeq ($(VERBOSE),1)
   Q =
 else
-- 
2.35.1

