Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35127C5479D
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Jan 2023 23:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjAIXlE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237536AbjAIXkk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jan 2023 18:40:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E82183A0
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 15:40:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1E5E61490
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 23:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB55C433EF
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 23:40:38 +0000 (UTC)
Date:   Mon, 9 Jan 2023 18:40:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Show migrate-disable field
Message-ID: <20230109184034.359f10ad@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Since Linux kernel 5.15 (specifically with the addition of 54357f0c9149c
("tracing: Add migrate-disabled counter to tracing output.")), the
common_preempt_count field of each event also held the "migrate-disable"
field in the most significant byte. This needs to be accounted for as when
the migrate disable field is set, it will show:

systemd--268     3d..3 15368.334398: rcu_dyntick:          --= 4000000000000002 4000000000000000 0x63c
systemd--268     3d..13 15368.334399: rcu_dyntick:          ++= 4000000000000000 4000000000000002 0x63c
systemd--268     3d..12 15368.334400: irq_disable:          caller=ct_irq_enter_irqson+0x17 parent=0x0
systemd--268     3d..13 15368.334400: rcu_dyntick:          --= 4000000000000002 4000000000000000 0x63c
systemd--268     3d..12 15368.334401: rcu_dyntick:          ++= 4000000000000000 4000000000000002 0x63c

Where the events above have:

   preempt-count	migrate-disable
   -------------        ---------------
	3			0
	3			1
	2			1
	3			1
	2			1

That is, in the above print of "3d..13", the '3' of the '13' is the
preempt count and the '1' is the migrate disable. But it really should be:

systemd--268     3d..3. 15368.334398: rcu_dyntick:          --= 4000000000000002 4000000000000000 0x63c
systemd--268     3d..31 15368.334399: rcu_dyntick:          ++= 4000000000000000 4000000000000002 0x63c
systemd--268     3d..21 15368.334400: irq_disable:          caller=ct_irq_enter_irqson+0x17 parent=0x0
systemd--268     3d..31 15368.334400: rcu_dyntick:          --= 4000000000000002 4000000000000000 0x63c
systemd--268     3d..21 15368.334401: rcu_dyntick:          ++= 4000000000000000 4000000000000002 0x63c

Where the migrate disabled is always displayed with a '.' when zero and
its hex count when set.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 18db7fcb456d..e655087dad60 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -6768,8 +6768,13 @@ static void data_latency_format(struct tep_handle *tep, struct trace_seq *s,
 	       (hardirq && softirq) ? 'H' :
 	       hardirq ? 'h' : softirq ? 's' : '.');
 
-	if (pc)
-		trace_seq_printf(&sq, "%x", pc);
+	if (pc & 0xf)
+		trace_seq_printf(&sq, "%x", pc & 0xf);
+	else
+		trace_seq_printf(&sq, ".");
+
+	if (pc & 0xf0)
+		trace_seq_printf(&sq, "%x", pc >> 4);
 	else
 		trace_seq_printf(&sq, ".");
 
-- 
2.35.1

