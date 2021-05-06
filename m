Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FD5C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 15:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96DAE610C8
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 15:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbhEFPtq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 May 2021 11:49:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235136AbhEFPtp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 May 2021 11:49:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09188610A1;
        Thu,  6 May 2021 15:48:46 +0000 (UTC)
Date:   Thu, 6 May 2021 11:48:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH] trace-cmd report: Have --align-ts ignore empty CPU buffers
Message-ID: <20210506114845.5c2cf201@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When testing out the trace-cmd report --align-ts, I saw no difference. And
that was because one of the CPUs were empty.

Have the --align-ts option ignore empty CPUs.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
Based on top of: https://lore.kernel.org/linux-trace-devel/20210428122839.805296-6-tz.stoyanov@gmail.com/

 lib/trace-cmd/trace-input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 4d5940d8..9726e994 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4089,6 +4089,9 @@ unsigned long long tracecmd_get_first_ts(struct tracecmd_input *handle)
 	int i;
 
 	for (i = 0; i < handle->cpus; i++) {
+		/* Ignore empty buffers */
+		if (!handle->cpu_data[i].size)
+			continue;
 		if (first || ts > handle->cpu_data[i].first_ts)
 			ts = handle->cpu_data[i].first_ts;
 		first = false;
-- 
2.29.2

