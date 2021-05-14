Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5046DC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25FB7611CE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhENNkL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 09:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229906AbhENNkK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 09:40:10 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69D2D6144C
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 13:38:59 +0000 (UTC)
Date:   Fri, 14 May 2021 09:38:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Add new line to trace-seq warnings
Message-ID: <20210514093858.4e862bda@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The WARN_ONCE() logic in trace_seq is based off of the WARN_ONCE() logic
in the Linux kernel, where the message does not require to end with a new
line. But the implementation is different than the kernel, and it lacks
adding a new line when it writes the output.

Add the new line to make it match what happens in the Linux kernel.

Link: https://lore.kernel.org/linux-trace-devel/20210514122825.162203-1-y.karadz@gmail.com/

Fixes: 3b760f95 ("tools include: Move perf's bug.h to a generic place")
Reported-by: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/asm/bug.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm/bug.h b/include/asm/bug.h
index 550223f..de8f8fe 100644
--- a/include/asm/bug.h
+++ b/include/asm/bug.h
@@ -5,7 +5,7 @@
 #include <linux/compiler.h>
 #include <stdio.h>
 
-#define __WARN_printf(arg...)	do { fprintf(stderr, arg); } while (0)
+#define __WARN_printf(arg...)	do { fprintf(stderr, arg); fprintf(stderr, "\n");} while (0)
 
 #define WARN(condition, format...) ({		\
 	int __ret_warn_on = !!(condition);	\
-- 
2.29.2

