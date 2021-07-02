Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF5E3C11F68
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E0561420
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhGBLqH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 07:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231935AbhGBLqG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 07:46:06 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C46FE61416
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jul 2021 11:43:34 +0000 (UTC)
Date:   Fri, 2 Jul 2021 07:43:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Remove leftover regcomp() in
 event_enable_disable()
Message-ID: <20210702074333.7e3f0529@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When adding a helper function to perform the regex compiling
(make_regex()), one place left the open coded compiling but still added
the wrapper function.

Link: https://lore.kernel.org/linux-trace-devel/48ad3a02-f4bf-1579-df6a-f4dc206a7e4e@gmail.com/

Reported-by: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Fixes: de8592c0ef ("libtracefs: Fix tracefs_event_enable/disable() to not have open regex")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index b6d3136..568bfe6 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -868,7 +868,6 @@ static int event_enable_disable(struct tracefs_instance *instance,
 
 	if (system) {
 		ret = make_regex(&system_re, system);
-		ret = regcomp(&system_re, system, REG_ICASE|REG_NOSUB);
 		if (ret < 0)
 			goto out_free;
 	}
-- 
2.31.1

