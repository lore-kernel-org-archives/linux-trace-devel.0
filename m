Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D7D0C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 20:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DB31610FF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 20:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237348AbhIIUII (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Sep 2021 16:08:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245508AbhIIUII (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Sep 2021 16:08:08 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47165610CE
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Sep 2021 20:06:58 +0000 (UTC)
Date:   Thu, 9 Sep 2021 16:06:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent/sched_switch: Do not have sched_switch plugin
 complain about target_cpu
Message-ID: <20210909160656.21f27793@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Older kernels did not have "target_cpu" as a field for wake up events. Do
not complain if it doesn't exist.

Fixes: 159f118588 ("libtraceevent: Do not print message if wakeup success field is missing")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 plugins/plugin_sched_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index 73145ff..8752cae 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -73,7 +73,7 @@ static int sched_wakeup_handler(struct trace_seq *s,
 	if (tep_get_field_val(s, event, "success", record, &val, 0) == 0)
 		trace_seq_printf(s, " success=%lld", val);
 
-	if (tep_get_field_val(s, event, "target_cpu", record, &val, 1) == 0)
+	if (tep_get_field_val(s, event, "target_cpu", record, &val, 0) == 0)
 		trace_seq_printf(s, " CPU:%03llu", val);
 
 	return 0;
-- 
2.31.1

