Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3441C64E7B
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Dec 2020 18:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4502B22210
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Dec 2020 18:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392255AbgLAShh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Dec 2020 13:37:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389068AbgLAShh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Dec 2020 13:37:37 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27792208FE
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Dec 2020 18:36:57 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kkAWF-002STX-RN
        for linux-trace-devel@vger.kernel.org; Tue, 01 Dec 2020 13:36:55 -0500
Message-ID: <20201201183655.723229785@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 01 Dec 2020 13:36:05 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] trace-cmd: Fix whitespace in usage message of trace-cmd report
 --ts-diff
References: <20201201183604.562747692@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The "--ts-diff" description in "trace-cmd report -h" is not lined up with
the other long options. Fix the whitespace so that it is.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-usage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 79610bd36bb7..5d73c5982984 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -228,7 +228,7 @@ static struct usage_help usage_help[] = {
 		"                     to convert the displayed timestamps to seconds\n"
 		"                     Affects the previous data file, unless there was no\n"
 		"                     previous data file, in which case it becomes default\n"
-		"           --ts-diff Show the delta timestamp between events.\n"
+		"          --ts-diff Show the delta timestamp between events.\n"
 	},
 	{
 		"stream",
-- 
2.28.0


