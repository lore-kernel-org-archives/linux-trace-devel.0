Return-Path: <SRS0=NWyF=WX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481F6C3A59F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Aug 2019 02:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 263B6206E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Aug 2019 02:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbfH0Coh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 22:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728345AbfH0Coh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 22:44:37 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E06BF206E0;
        Tue, 27 Aug 2019 02:44:35 +0000 (UTC)
Date:   Mon, 26 Aug 2019 22:44:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Tom Zanussi <zanussi@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH] tracing: Fix histogram referencing a variable
Message-ID: <20190826224434.385bc6b5@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: Steven Rostedt (VMware) <rostedt@goodmis.org>

I performed a three way histogram with the following commands:

echo 'irq_lat u64 lat pid_t pid' > synthetic_events
echo 'wake_lat u64 lat u64 irqlat pid_t pid' >> synthetic_events
echo 'hist:keys=common_pid:irqts=common_timestamp.usecs if function == 0xffffffff81200580' > events/timer/hrtimer_start/trigger
echo 'hist:keys=common_pid:lat=common_timestamp.usecs-$irqts:onmatch(timer.hrtimer_start).irq_lat($lat,pid) if common_flags & 1' > events/sched/sched_waking/trigger
echo 'hist:keys=pid:wakets=common_timestamp.usecs,irqlat=lat' > events/synthetic/irq_lat/trigger
echo 'hist:keys=next_pid:lat=common_timestamp.usecs-$wakets,irqlat=$irqlat:onmatch(synthetic.irq_lat).wake_lat($lat,$irqlat,next_pid)' > events/sched/sched_switch/trigger 
echo 1 > events/synthetic/wake_lat/enable 

Basically I wanted to see:

 hrtimer_start (calling function tick_sched_timer)

Note:

  # grep tick_sched_timer /proc/kallsyms
ffffffff81200580 t tick_sched_timer

And save the time of that, and then record sched_waking if it is called
in interrupt context and with the same pid as the hrtimer_start, it
will record the latency between that and the waking event.

I then look at when the task that is woken is scheduled in, and record
the latency between the wakeup and the task running.

At the end, the wake_lat synthetic event will show the wakeup to
scheduled latency, as well as the irq latency in from hritmer_start to
the wakeup. The problem is that I found this:

          <idle>-0     [007] d...   190.485261: wake_lat: lat=27 irqlat=190485230 pid=698
          <idle>-0     [005] d...   190.485283: wake_lat: lat=40 irqlat=190485239 pid=10
          <idle>-0     [002] d...   190.488327: wake_lat: lat=56 irqlat=190488266 pid=335
          <idle>-0     [005] d...   190.489330: wake_lat: lat=64 irqlat=190489262 pid=10
          <idle>-0     [003] d...   190.490312: wake_lat: lat=43 irqlat=190490265 pid=77
          <idle>-0     [005] d...   190.493322: wake_lat: lat=54 irqlat=190493262 pid=10
          <idle>-0     [005] d...   190.497305: wake_lat: lat=35 irqlat=190497267 pid=10
          <idle>-0     [005] d...   190.501319: wake_lat: lat=50 irqlat=190501264 pid=10

The irqlat seemed quite large! Investigating this further, if I had
enabled the irq_lat synthetic event, I noticed this:

          <idle>-0     [002] d.s.   249.429308: irq_lat: lat=164968 pid=335
          <idle>-0     [002] d...   249.429369: wake_lat: lat=55 irqlat=249429308 pid=335

Notice that the timestamp of the irq_lat "249.429308" is awfully
similar to the reported irqlat variable. In fact, all instances were
like this. It appeared that:

  irqlat=$irqlat

Wasn't assigning the old $irqlat to the new irqlat variable, but
instead was assigning the $irqts to it.

The issue is that hist_field_var_ref() is using hist_field->var_ref_idx
(the ref of the var being assigned) and not the ref of the var that is
the value (hist_field->var.idx).

Cc: stable@vger.kernel.org
Fixes: 067fe038e70f6 ("tracing: Add variable reference handling to hist triggers")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 65e7d071ed28..329488aeb9dd 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1858,7 +1858,7 @@ static u64 hist_field_var_ref(struct hist_field *hist_field,
 		return var_val;
 
 	elt_data = elt->private_data;
-	var_val = elt_data->var_ref_vals[hist_field->var_ref_idx];
+	var_val = elt_data->var_ref_vals[hist_field->var.idx];
 
 	return var_val;
 }
