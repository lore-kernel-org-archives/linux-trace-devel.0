Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55048C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Apr 2022 22:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiD0Wfn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 18:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiD0Wfm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 18:35:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7E2266F
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Apr 2022 15:32:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5ECD61DF9
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Apr 2022 22:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E30C385A9;
        Wed, 27 Apr 2022 22:32:27 +0000 (UTC)
Date:   Wed, 27 Apr 2022 18:32:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH] trace-cmd library: Have clock source TAI parse to seconds
Message-ID: <20220427183226.1ae6f8f6@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Tell trace-cmd that the "tai" clock source should be displayed in seconds
and needs to be parsed as such.

Instead of:

    sleep-2084  [001]1651097314396951318: function:             __mutex_unlock_slowpath
    sleep-2084  [001]1651097314396951516: function:             ktime_get_mono_fast_ns
    sleep-2084  [001]1651097314396951773: function:             ktime_get_mono_fast_ns
    sleep-2084  [001]1651097314396951773: function:             rcu_read_lock_sched_held
    sleep-2084  [001]1651097314396951949: function:             ktime_get_mono_fast_ns
    sleep-2084  [001]1651097314396952359: function:             ktime_get_mono_fast_ns

Display as:

    sleep-2084  [001] 1651097314.396951: function:             __mutex_unlock_slowpath
    sleep-2084  [001] 1651097314.396952: function:             ktime_get_mono_fast_ns
    sleep-2084  [001] 1651097314.396952: function:             ktime_get_mono_fast_ns
    sleep-2084  [001] 1651097314.396952: function:             rcu_read_lock_sched_held
    sleep-2084  [001] 1651097314.396952: function:             ktime_get_mono_fast_ns
    sleep-2084  [001] 1651097314.396952: function:             ktime_get_mono_fast_ns

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 90bfa0f32984..442b1c5a6724 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3868,7 +3868,8 @@ static void extract_trace_clock(struct tracecmd_input *handle, char *line)
 	/* Clear usecs if not one of the specified clocks */
 	if (strcmp(clock, "local") && strcmp(clock, "global") &&
 	    strcmp(clock, "uptime") && strcmp(clock, "perf") &&
-	    strncmp(clock, "mono", 4) && strcmp(clock, TSCNSEC_CLOCK))
+	    strncmp(clock, "mono", 4) && strcmp(clock, TSCNSEC_CLOCK) &&
+	    strcmp(clock, "tai"))
 		handle->flags &= ~TRACECMD_FL_IN_USECS;
 }
 
-- 
2.35.1

