Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC75DC2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 21:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1B6361164
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 21:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhFVVUw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 17:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhFVVUv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 17:20:51 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62A756100B;
        Tue, 22 Jun 2021 21:18:35 +0000 (UTC)
Date:   Tue, 22 Jun 2021 17:18:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH] trace-cmd split: Fail with an error message if appending
 data fails
Message-ID: <20210622171833.37b1e22b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If appending the CPU data fails, error out with a message to inform the
user what happened and not just continue as if nothing went wrong.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-split.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 10d0943d..233feb89 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -385,7 +385,8 @@ static double parse_file(struct tracecmd_input *handle,
 		cpu_list[cpu] = cpu_data[cpu].file;
 
 	tracecmd_set_out_clock(ohandle, tracecmd_get_trace_clock(handle));
-	tracecmd_append_cpu_data(ohandle, cpus, cpu_list);
+	if (tracecmd_append_cpu_data(ohandle, cpus, cpu_list) < 0)
+		die("Failed to append tracing data\n");
 
 	current = end;
 	for (cpu = 0; cpu < cpus; cpu++) {
-- 
2.29.2

