Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B538C77B7A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 May 2023 04:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjE3Eut (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 May 2023 00:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjE3Eus (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 May 2023 00:50:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31834E3
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 May 2023 21:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2DDE62A06
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 04:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6DDC433D2;
        Tue, 30 May 2023 04:50:45 +0000 (UTC)
Date:   Tue, 30 May 2023 00:50:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] libtracefs: Documentation for
 tracefs_synth_set_instance
Message-ID: <20230530005041.61692a8e@rorschach.local.home>
In-Reply-To: <20230328150321.34808-3-tz.stoyanov@gmail.com>
References: <20230328150321.34808-1-tz.stoyanov@gmail.com>
        <20230328150321.34808-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 28 Mar 2023 18:03:21 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -45,9 +46,11 @@ as a field for both events to calculate the delta in nanoseconds, or use
>  *TRACEFS_TIMESTAMP_USECS* as the compare fields for both events to calculate the
>  delta in microseconds. This is used as the example below.
>  
> -*tracefs_synth_create*() creates the synthetic event in the system. The synthetic events apply
> -across all instances. A synthetic event must be created with *tracefs_synth_alloc*(3) before
> -it can be created.
> +*tracefs_synth_create*() creates the synthetic event in the system. By default, the synthetic
> +events are created in the top trace instance and apply across all instances.
> +The *tracefs_synth_set_instance()* API can be used to set a custom instance, where the synthetic
> +event will be created. In that case the event operates only in that instance. A synthetic event

The above is somewhat incorrect. That makes it sound like you can not
use the event elsewhere, where you most certainly can.

 ># cd /sys/kernel/tracing
 ># mkdir instances/foo
 ># echo 'wakeup pid_t pid; u64 lat' > synthetic_events
 ># echo 'hist:keys=pid:ts=common_timestamp.usecs' > instances/foo/events/sched/sched_waking/trigger
 ># echo 'hist:keys=next_pid:lat=common_timestamp.usecs-$ts:onmatch(sched.sched_waking).trace(wakeup,next_pid,$lat)' > instances/foo/events/sched/sched_switch/trigger
 ># mkdir instances/bar
 ># echo 1 > instances/bar/events/synthetic/wakeup/enable
 ># cat instances/bar/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 73761/73761   #P:8
#
#                                _-----=> irqs-off/BH-disabled
#                               / _----=> need-resched
#                              | / _---=> hardirq/softirq
#                              || / _--=> preempt-depth
#                              ||| / _-=> migrate-disable
#                              |||| /     delay
#           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
#              | |         |   |||||     |         |
          <idle>-0       [001] d..4. 56208.972686: wakeup: pid=1352 lat=25
            bash-843     [002] d..4. 56208.972784: wakeup: pid=1353 lat=20
          <idle>-0       [004] d..4. 56208.972894: wakeup: pid=3408 lat=25
          <idle>-0       [006] d..4. 56208.972937: wakeup: pid=820 lat=33
          <idle>-0       [004] d..4. 56208.972951: wakeup: pid=3408 lat=23
          <idle>-0       [004] d..4. 56208.972993: wakeup: pid=1355 lat=12
          <idle>-0       [003] d..4. 56208.973030: wakeup: pid=1354 lat=26


Now, I am going to apply these patches, but I also will update them to
reflect the actual benefit of them. The issue I see is that you have
triggers in the toplevel (histograms). And perhaps you don't want those
histograms there, and want to keep the histograms used to create a
synthetic event in a particular instance. That makes more sense,
although it's not that much of a interference, as you can add more than
one histogram to an event.

 ># cat instances/foo/events/sched/sched_waking/hist
# event histogram
#
# trigger info: hist:keys=pid:vals=hitcount:ts=common_timestamp.usecs:sort=hitcount:size=2048:clock=global [active]
#

{ pid:          2 } hitcount:          1
{ pid:         41 } hitcount:          1
{ pid:       3609 } hitcount:          1
{ pid:         26 } hitcount:          1
{ pid:       3612 } hitcount:          1
{ pid:         15 } hitcount:          1
[..]
{ pid:        289 } hitcount:       1920
{ pid:        454 } hitcount:       3747
{ pid:         84 } hitcount:       4714
{ pid:       3257 } hitcount:      83897
{ pid:       1351 } hitcount:     681823
{ pid:       1357 } hitcount:     681830
{ pid:       1353 } hitcount:     681831
{ pid:       1352 } hitcount:     681834
{ pid:       1358 } hitcount:     681837
{ pid:       1356 } hitcount:     681869
{ pid:       1355 } hitcount:     681872
{ pid:       1354 } hitcount:     681878

Totals:
    Hits: 5564963
    Entries: 89
    Dropped: 0

 ># cat events/sched/sched_waking/hist
 >#

-- Steve


> +must be created with *tracefs_synth_alloc*(3) before it can be created.
>  
