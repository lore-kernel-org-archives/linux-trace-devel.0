Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C7FFC63798
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Nov 2020 19:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 257C620728
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Nov 2020 19:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgKWTNX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Nov 2020 14:13:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729114AbgKWTNX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 14:13:23 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B05C2206B2
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Nov 2020 19:13:22 +0000 (UTC)
Date:   Mon, 23 Nov 2020 14:13:21 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Update URL with the new repository
Message-ID: <20201123141321.66f87d11@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From 2ae4d15228ff07c022624a77effa17e7f49d8316 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Mon, 23 Nov 2020 13:55:57 -0500
Subject: [PATCH] libtraceevent: Update URL with the new repository

libtraceevent.so no longer lives in the Linux kernel repository. Update the
pkg-config file to point to the URL of the new home.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 libtraceevent.pc.template | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libtraceevent.pc.template b/libtraceevent.pc.template
index 86384fc..d558377 100644
--- a/libtraceevent.pc.template
+++ b/libtraceevent.pc.template
@@ -3,7 +3,7 @@ libdir=LIB_DIR
 includedir=HEADER_DIR
 
 Name: libtraceevent
-URL: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+URL: https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
 Description: Linux kernel trace event library
 Version: LIB_VERSION
 Cflags: -I${includedir}
-- 
2.25.4

