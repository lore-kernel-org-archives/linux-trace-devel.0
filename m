Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC80EC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 17:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E02061004
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 17:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhCaRYc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 13:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234311AbhCaRYZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 13:24:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0361460FF2
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 17:24:24 +0000 (UTC)
Date:   Wed, 31 Mar 2021 13:24:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Only support tsc2nsec if multiplier or shift is
 non-zero
Message-ID: <20210331132423.485ab869@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

perf on KVM guests does not support the multiplier or shift even though the
page has those fields. Instead, they are set to zeros. Only consider the
tsc2nsec supported if one of those is non-zero.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---

This applies on top of:

   https://patchwork.kernel.org/project/linux-trace-devel/list/?series=457305

 tracecmd/trace-record.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index bebecdbd..f642a5e3 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5808,7 +5808,8 @@ static int get_tsc_nsec(int *shift, int *mult)
 	if (i < cpus)
 		return -1;
 
-	supported = 1;
+	if (cpu_shift || cpu_mult)
+		supported = 1;
 out:
 	if (supported < 0)
 		return -1;
-- 
2.29.2

