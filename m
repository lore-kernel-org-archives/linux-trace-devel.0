Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E00C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 14:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 741CF61175
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 14:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbhEFOBO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 May 2021 10:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234356AbhEFOBL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 May 2021 10:01:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1399610FC
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 May 2021 14:00:12 +0000 (UTC)
Date:   Thu, 6 May 2021 10:00:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Free the regex in update_filter()
Message-ID: <20210506100010.483b2374@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

A regex is used to match functions in update_filter() using the regcomp()
functionality. But regcomp() needs to release its resources via regfree()
which is lacking in this function.

Fixes: 2df4a7ea ("libtracefs: Add checking of available_filter_functions to tracefs_function_filter()")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 6ef17f6..993fb3c 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -816,6 +816,7 @@ static int update_filter(const char *filter_path, int *fd,
 	}
 
  out_free:
+	regfree(&func_filter.re);
 	free_func_list(func_list);
  out:
 	pthread_mutex_unlock(lock);
-- 
2.29.2

