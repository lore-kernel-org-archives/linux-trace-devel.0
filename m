Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBC9C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 20:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A3646108B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 20:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbhDGUhO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Apr 2021 16:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233083AbhDGUhN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Apr 2021 16:37:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ED99611EE
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Apr 2021 20:37:03 +0000 (UTC)
Date:   Wed, 7 Apr 2021 16:37:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Fix CONTRITUBE file, its git send-email not git
 --send-email
Message-ID: <20210407163701.36b872d2@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

There's two hyphens in the CONTRIBUTE file before send-email, which do not
belong. Get rid of them.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 CONTRIBUTE | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/CONTRIBUTE b/CONTRIBUTE
index aed78110..0440b186 100644
--- a/CONTRIBUTE
+++ b/CONTRIBUTE
@@ -67,12 +67,12 @@ fix that makes the code harder to read, that fix can probably be ignored.
 
 Finally, you can use the git "send-email" functionality:
 
-  git --send-email --from='<your-email> --to='linux-trace-devel@vger.kernel.org' HEAD~1..HEAD
+  git send-email --from='<your-email> --to='linux-trace-devel@vger.kernel.org' HEAD~1..HEAD
 
 If you are sending one patch, if you are adding more than one patch, also include
 a cover letter:
 
-  git --send-email --cover-letter --annotate --from='<your-email> --to='linux-trace-devel@vger.kernel.org' <first-commit>~1..HEAD
+  git send-email --cover-letter --annotate --from='<your-email> --to='linux-trace-devel@vger.kernel.org' <first-commit>~1..HEAD
 
 If you receive feedback on your patches, and plan on sending another version,
 please use the '-v' option to mark your patches that they are a new version.
@@ -80,7 +80,7 @@ For example, if you add "-v2" to the above commands, instead of having:
 "[PATCH]" in the subject, it will have "[PATCH v2]", letting the reviewers know
 that this is a new version. If you send another version, use "-v3" and so on.
 
-For more information about git --send-email:
+For more information about git send-email:
 
   https://git-scm.com/docs/git-send-email
 
-- 
2.29.2

