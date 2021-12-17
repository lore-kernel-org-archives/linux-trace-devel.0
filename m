Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84273C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbhLQFuu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbhLQFus (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:50:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D44C06173F
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:50:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 74002CE23EA
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAFEC36AE8;
        Fri, 17 Dec 2021 05:50:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my68h-00056n-EU;
        Fri, 17 Dec 2021 00:50:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 06/15] libtracefs: Remove unneeded blkflags from Makefile
Date:   Fri, 17 Dec 2021 00:50:32 -0500
Message-Id: <20211217055041.19559-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217055041.19559-1-rostedt@goodmis.org>
References: <20211217055041.19559-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The blkflags were leftover from copying from trace-cmd for handling the
blk tracer. They are not needed for the libtracefs library.
Remove them.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Makefile b/Makefile
index d92bec9f1ed7..07c9496364bd 100644
--- a/Makefile
+++ b/Makefile
@@ -104,9 +104,6 @@ SILENT := $(if $(findstring s,$(filter-out --%,$(MAKEFLAGS))),1)
 test-build = $(if $(shell sh -c 'echo "$(1)" | \
 	$(CC) -o /dev/null -c -x c - > /dev/null 2>&1 && echo y'), $2)
 
-# have flush/fua block layer instead of barriers?
-blk-flags := $(call test-build,$(BLK_TC_FLUSH_SOURCE),-DHAVE_BLK_TC_FLUSH)
-
 ifeq ("$(origin O)", "command line")
 
   saved-output := $(O)
-- 
2.33.0

