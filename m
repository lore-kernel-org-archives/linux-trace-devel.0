Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09EB1C4167B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4C1523C81
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgLJCa0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 21:30:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbgLJCa0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 21:30:26 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3633523D39
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Dec 2020 02:29:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knBiB-00048q-4a
        for linux-trace-devel@vger.kernel.org; Wed, 09 Dec 2020 21:29:43 -0500
Message-ID: <20201210022943.013917959@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 09 Dec 2020 21:29:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/9] trace-cmd: Add reference to trace-cmd.org in README
References: <20201210022906.112066412@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

This repo is mirrored in my personal github account, but that account is not
mirrored, and there's been people submitting issues there. Add to the
README, a reference to trace-cmd.org so that people will hopefully know the
correct way to contribute.

Link: https://lore.kernel.org/linux-trace-devel/20201201183655.868100504@goodmis.org

Reported-by: David Runge (on IRC)
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 README | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/README b/README
index fb06e754ee76..11531524e3bc 100644
--- a/README
+++ b/README
@@ -1,4 +1,7 @@
 
+
+  For more information on contributing please see: https://www.trace-cmd.org
+
 Note: The official repositiory for trace-cmd and KernelShark is here:
 
  git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git
-- 
2.29.2


