Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B836C4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 21:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70BFD61130
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 21:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240600AbhHTVgp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Aug 2021 17:36:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232732AbhHTVgo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 17:36:44 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76E7561102
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Aug 2021 21:36:06 +0000 (UTC)
Date:   Fri, 20 Aug 2021 17:35:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Do not print message if wakeup success field
 is missing
Message-ID: <20210820173559.5644c2b0@oasis.local.home>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The "success" field for sched wakeup has been hardcoded as "1" for years
now, because it is no longer anything but successful. The sched wakeup
plugin had the "err" parameter of tep_get_field_val() backwards, where it
had no message for fields it expects to see, but will show a error message
for the success field, which may not be there.

Fixes: 4f6857aa ("tools lib traceevent: Add sched_switch plugin")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 plugins/plugin_sched_switch.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index e12fa10..73145ff 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -67,13 +67,13 @@ static int sched_wakeup_handler(struct trace_seq *s,
 	}
 	trace_seq_printf(s, "%lld", val);
 
-	if (tep_get_field_val(s, event, "prio", record, &val, 0) == 0)
+	if (tep_get_field_val(s, event, "prio", record, &val, 1) == 0)
 		trace_seq_printf(s, " [%lld]", val);
 
-	if (tep_get_field_val(s, event, "success", record, &val, 1) == 0)
+	if (tep_get_field_val(s, event, "success", record, &val, 0) == 0)
 		trace_seq_printf(s, " success=%lld", val);
 
-	if (tep_get_field_val(s, event, "target_cpu", record, &val, 0) == 0)
+	if (tep_get_field_val(s, event, "target_cpu", record, &val, 1) == 0)
 		trace_seq_printf(s, " CPU:%03llu", val);
 
 	return 0;
@@ -96,10 +96,10 @@ static int sched_switch_handler(struct trace_seq *s,
 	}
 	trace_seq_printf(s, "%lld ", val);
 
-	if (tep_get_field_val(s, event, "prev_prio", record, &val, 0) == 0)
+	if (tep_get_field_val(s, event, "prev_prio", record, &val, 1) == 0)
 		trace_seq_printf(s, "[%d] ", (int) val);
 
-	if (tep_get_field_val(s,  event, "prev_state", record, &val, 0) == 0)
+	if (tep_get_field_val(s,  event, "prev_state", record, &val, 1) == 0)
 		write_state(s, val);
 
 	trace_seq_puts(s, " ==> ");
@@ -114,7 +114,7 @@ static int sched_switch_handler(struct trace_seq *s,
 	}
 	trace_seq_printf(s, "%lld", val);
 
-	if (tep_get_field_val(s, event, "next_prio", record, &val, 0) == 0)
+	if (tep_get_field_val(s, event, "next_prio", record, &val, 1) == 0)
 		trace_seq_printf(s, " [%d]", (int) val);
 
 	return 0;
-- 
2.31.1

