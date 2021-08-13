Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D3DC4320A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E97B61106
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238232AbhHMCSA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:18:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237718AbhHMCRx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 22:17:53 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43223610FC;
        Fri, 13 Aug 2021 02:17:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mEMlA-003wVq-PB; Thu, 12 Aug 2021 22:17:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/7] libtracefs: Add handlers 'onmax' and 'onchange' and actions 'snapshot' and 'save'
Date:   Thu, 12 Aug 2021 22:16:48 -0400
Message-Id: <20210813021655.939819-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the following APIs that now allow to perform 'onmax' and 'onchange'
handlers with the 'trace', 'snapshot' and 'save' actions for synthetic
events.

   tracefs_synth_trace()
   tracefs_synth_snapshot()
   tracefs_synth_save()

Also, update the sqlhist tool in the tracefs_sql(3) man page to have more
features, as well as give it its own man page!

With the above API sqlhist has been exapanded to customize latency tracing.

By using the full SQL language, synthetic events can be made and processed.
For example, using sqlhist along with trace-cmd, wake up latency can be
recorded by creating a synthetic event by attaching the sched_waking and the
sched_switch events.

 # sqlhist -n wakeup_lat -e -T -m lat 'SELECT end.next_comm AS comm, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) AS lat FROM ' \
    'sched_waking AS start JOIN sched_switch AS end ON start.pid = end.next_pid WHERE end.next_prio < 100 && end.next_comm == "cyclictest"'

 # trace-cmd start -e all -e wakeup_lat -R stacktrace

 # cyclictest -l 1000 -p80 -i250  -a -t -q -m -d 0 -b 1000 --tracemark

 # trace-cmd show -s | tail -30
         <idle>-0       [002] dNh4 23454.902246: sched_wakeup: comm=cyclictest pid=12272 prio=120 target_cpu=002
         <idle>-0       [005] ...1 23454.902246: cpu_idle: state=4294967295 cpu_id=5
         <idle>-0       [007] d..1 23454.902246: cpu_idle: state=0 cpu_id=7
         <idle>-0       [002] dNh1 23454.902247: hrtimer_expire_exit: hrtimer=0000000037956dc2
         <idle>-0       [005] d..1 23454.902248: cpu_idle: state=0 cpu_id=5
         <idle>-0       [002] dNh1 23454.902248: write_msr: 6e0, value 4866ce957272
         <idle>-0       [006] ...1 23454.902248: cpu_idle: state=4294967295 cpu_id=6
         <idle>-0       [002] dNh1 23454.902249: local_timer_exit: vector=236
         <idle>-0       [006] d..1 23454.902250: cpu_idle: state=0 cpu_id=6
         <idle>-0       [002] .N.1 23454.902250: cpu_idle: state=4294967295 cpu_id=2
         <idle>-0       [002] dN.1 23454.902251: rcu_utilization: Start context switch
         <idle>-0       [002] dN.1 23454.902252: rcu_utilization: End context switch
         <idle>-0       [001] ...1 23454.902252: cpu_idle: state=4294967295 cpu_id=1
         <idle>-0       [002] dN.3 23454.902253: prandom_u32: ret=3692516021
         <idle>-0       [001] d..1 23454.902254: cpu_idle: state=0 cpu_id=1
         <idle>-0       [002] d..2 23454.902254: sched_switch: prev_comm=swapper/2 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=cyclictest next_pid=12275 next_prio=19
         <idle>-0       [002] d..4 23454.902256: wakeup_lat: next_comm=cyclictest lat=17
         <idle>-0       [002] d..5 23454.902258: <stack trace>
=> trace_event_raw_event_synth
=> action_trace
=> event_hist_trigger
=> event_triggers_call
=> trace_event_buffer_commit
=> trace_event_raw_event_sched_switch
=> __traceiter_sched_switch
=> __schedule
=> schedule_idle
=> do_idle
=> cpu_startup_entry
=> secondary_startup_64_no_verify

Here’s the options for sqlhist explained:

-n wakeup_lat
    Name the synthetic event to use wakeup_lat.

-e
    Execute the commands that are printed.

-T
    Perform both a trace action and then a snapshot action (swap the buffer
    into the static snapshot buffer).

-m lat
    Trigger the actions whenever lat hits a new maximum value.

Now a breakdown of the SQL statement:

     'SELECT end.next_comm AS comm, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) AS lat FROM ' \
        'sched_waking AS start JOIN sched_switch AS end ON start.pid = end.next_pid WHERE end.next_prio < 100 && end.next_comm == "cyclictest"'

end.next_comm AS comm
    Save the sched_switch field next_comm and place it into the comm field
    of the wakeup_lat synthetic event.

(end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) AS lat
    Take the delta of the time stamps from the sched_switch event and the
    sched_waking event. As time stamps are usually recorded in nanoseconds,
    TIMESTAMP would give the full nanosecond time stamp, but here, the
    TIMESTAMP_USECS will truncate it into microseconds. The value is saved in
    the variable lat, which will also be recorded in the synthetic event.

FROM sched_waking AS start JOIN sched_switch AS end ON start.pid = end.next_pid
    Create the synthetic event by joining sched_waking to sched_switch,
    matching the sched_waking pid field with the sched_switch next_pid field.
    Also make start an alias for sched_waking and end an alias for sched_switch
    which then an use start and end as a subsitute for sched_waking and
    sched_switch respectively through out the rest of the SQL statement.

WHERE end.next_prio < 100 && end.next_comm == "cyclictest"
    Filter the logic where it executes only if sched_waking next_prio field
    is less than 100. (Note, in the Kernel, priorities are inverse, and the
    real-time priorities are represented from 0-100 where 0 is the highest
    priority). Also only trace when the next_comm (the task scheduling in) of
    the sched_switch event has the name "cyclictest".

For the trace-cmd(3) command:

       trace-cmd start -e all -e wakeup_lat -R stacktrace

trace-cmd start
    Enables tracing (does not record to a file).

-e all
    Enable all events

-e wakeup_lat -R stacktrace
    have the "wakeup_lat" event (our synthetic event) enable the stacktrace
    trigger, were for every instance of the "wakeup_lat" event, a kernel stack
    trace will be recorded in the ring buffer.

After calling cyclictest (a real-time tool to measure wakeup latency), read
the snapshot buffer.

trace-cmd show -s
    trace-cmd show reads the kernel ring buffer, and the -s option will read
    the snapshot buffer instead of the normal one.

     <idle>-0       [002] d..4 23454.902256: wakeup_lat: next_comm=cyclictest lat=17

We see on the "wakeup_lat" event happened on CPU 2, with a wake up latency
17 microseconds.

This can be extracted into a trace.dat file that trace-cmd(3) can read and
do further analysis, as well as kernelshark.

        # trace-cmd extract -s
        # trace-cmd report --cpu 2 | tail -30
              <idle>-0     [002] 23454.902238: prandom_u32:          ret=1633425088
              <idle>-0     [002] 23454.902239: sched_wakeup:         cyclictest:12275 [19] CPU:002
              <idle>-0     [002] 23454.902241: hrtimer_expire_exit:  hrtimer=0xffffbbd68286fe60
              <idle>-0     [002] 23454.902241: hrtimer_cancel:       hrtimer=0xffffbbd6826efe70
              <idle>-0     [002] 23454.902242: hrtimer_expire_entry: hrtimer=0xffffbbd6826efe70 now=23455294430750 function=hrtimer_wakeup/0x0
              <idle>-0     [002] 23454.902243: sched_waking:         comm=cyclictest pid=12272 prio=120 target_cpu=002
              <idle>-0     [002] 23454.902244: prandom_u32:          ret=1102749734
              <idle>-0     [002] 23454.902246: sched_wakeup:         cyclictest:12272 [120] CPU:002
              <idle>-0     [002] 23454.902247: hrtimer_expire_exit:  hrtimer=0xffffbbd6826efe70
              <idle>-0     [002] 23454.902248: write_msr:            6e0, value 4866ce957272
              <idle>-0     [002] 23454.902249: local_timer_exit:     vector=236
              <idle>-0     [002] 23454.902250: cpu_idle:             state=4294967295 cpu_id=2
              <idle>-0     [002] 23454.902251: rcu_utilization:      Start context switch
              <idle>-0     [002] 23454.902252: rcu_utilization:      End context switch
              <idle>-0     [002] 23454.902253: prandom_u32:          ret=3692516021
              <idle>-0     [002] 23454.902254: sched_switch:         swapper/2:0 [120] R ==> cyclictest:12275 [19]
              <idle>-0     [002] 23454.902256: wakeup_lat:           next_comm=cyclictest lat=17
              <idle>-0     [002] 23454.902258: kernel_stack:         <stack trace >
    => trace_event_raw_event_synth (ffffffff8121a0db)
    => action_trace (ffffffff8121e9fb)
    => event_hist_trigger (ffffffff8121ca8d)
    => event_triggers_call (ffffffff81216c72)
    => trace_event_buffer_commit (ffffffff811f7618)
    => trace_event_raw_event_sched_switch (ffffffff8110fda4)
    => __traceiter_sched_switch (ffffffff8110d449)
    => __schedule (ffffffff81c02002)
    => schedule_idle (ffffffff81c02c86)
    => do_idle (ffffffff8111e898)
    => cpu_startup_entry (ffffffff8111eba9)
    => secondary_startup_64_no_verify (ffffffff81000107)

Steven Rostedt (VMware) (7):
  libtracefs: Move creating of onmatch handler and trace action into
    helper functions
  libtracefs: Add logic to apply actions to synthetic events
  libtracefs: Add API tracefs_synth_trace()
  libtracefs: Add API tracefs_synth_snapshot()
  libtracefs: Add API tracefs_synth_save()
  libtracefs: Update the libtracefs-sql man page for the new
    tracefs_synth APIs
  libtracefs: Make a man page for the sqlhist man page example

 Documentation/Makefile                 |  53 +++-
 Documentation/libtracefs-sql.txt       | 107 +++++++-
 Documentation/libtracefs-sqlhist.txt.1 | 351 +++++++++++++++++++++++++
 Documentation/libtracefs-synth2.txt    |  37 ++-
 include/tracefs.h                      |  14 +
 src/tracefs-hist.c                     | 304 ++++++++++++++++++++-
 6 files changed, 838 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/libtracefs-sqlhist.txt.1

-- 
2.30.2

