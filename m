Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78850C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 15:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238001AbiDDPMg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 11:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353885AbiDDPMf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 11:12:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBAD24F30
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 08:10:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CE96615BF
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 15:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABD0C340EE
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 15:10:38 +0000 (UTC)
Date:   Mon, 4 Apr 2022 11:10:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Process trace_clock for v7 trace.dat
 files
Message-ID: <20220404111037.2248bb52@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

One of my ftrace tests records tracing data with the counter clock (just
counts by 1 for every event, it is not a time stamp), but the test failed
with the latest trace-cmd, as it was showing the counters as "usecs" and
truncating them:

Instead of:

          <idle>-0     [002]      818923: sched_switch:         swapper/2:0 [120] R ==> sleep:8298 [120]
          <idle>-0     [003]      818924: sched_switch:         swapper/3:0 [120] R ==> rb_consumer:47 [139]
          <idle>-0     [000]      818925: sched_switch:         swapper/0:0 [120] R ==> trace-cmd:8293 [120]
           sleep-8298  [002]      818926: sched_switch:         sleep:8298 [120] Z ==> swapper/2:0 [120]

It was showing the output like:

           sleep-8225  [002]     0.000809: sched_switch:         sleep:8225 [120] S ==> swapper/2:0 [120]
          <idle>-0     [003]     0.000809: sched_switch:         swapper/3:0 [120] R ==> rcu_preempt:13 [120]
     rcu_preempt-13    [003]     0.000809: sched_switch:         rcu_preempt:13 [120] W ==> swapper/3:0 [120]
          <idle>-0     [003]     0.000809: sched_switch:         swapper/3:0 [120] R ==> rcu_preempt:13 [120]

When the TRACECLOCK option is found, use it to set the appropriate clock
for trace-cmd.

Fixes: 02dfe3593624 ("trace-cmd library: Initialize CPU data for reading from version 7 trace files")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 18bb4cf984da..b8705ce364d1 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3436,6 +3436,7 @@ static int handle_options(struct tracecmd_input *handle)
 				goto out;
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
+			tracecmd_parse_trace_clock(handle, buf, size);
 			if (!handle->ts2secs)
 				handle->use_trace_clock = true;
 			break;
-- 
2.35.1

