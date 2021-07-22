Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEEFCC07E9D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 03:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6DDF61355
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 03:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhGVC67 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230225AbhGVC67 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Jul 2021 22:58:59 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0027361183;
        Thu, 22 Jul 2021 03:39:34 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m6PYb-001Xmi-K7; Wed, 21 Jul 2021 23:39:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/4] libtracefs: Creating synthetic events
Date:   Wed, 21 Jul 2021 23:39:13 -0400
Message-Id: <20210722033917.367982-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add an interface to libtracefs that makes it easy to create synthetic
events. For example:

	struct tracefs_synth *synth;
	struct tep_handle *tep;
	struct trace_seq seq;

	/* Load all events from the system */
	tep = tracefs_local_events(NULL);
	
	/* Initialize the synthetic event */
	synth = tracefs_synth_init(tep, "wakeup_lat",
				   NULL, start_event,
				   NULL, end_event,
				   match_name,
				   start_field, end_field);

	/* The tep is no longer needed */
	tep_free(tep);


	/* Save the "prio" field as "prio" from the start event */
	tracefs_synth_add_start_field(synth, NULL, "prio");

	/* Save the "next_comm" as "comm" from the end event */
	tracefs_synth_add_end_field(synth, "comm", "next_comm");

	/* Save the "prev_prio" as "prev_prio" from the end event */
	tracefs_synth_add_end_field(synth, NULL, "prev_prio");

	/*
	 * Take a microsecond time difference between end and start
	 * and record as "delta"
	 */
	tracefs_synth_add_compare_field(synth, "delta", TRACEFS_TIMESTAMP_USECS,
					TRACEFS_TIMESTAMP_USECS,
					TRACEFS_SYNTH_DELTA_END);

	/* Only record if start event "prio" is less than 100 */
	tracefs_synth_add_start_filter(synth, "prio",
				       TRACEFS_COMPARE_LT, "100",
				       false, false);

	/*
	 * Only record if end event "next_prio" is less than 50
	 * or the previous task's prio was less than 100.
	 */
	tracefs_synth_add_end_filter(synth, "next_prio",
				       TRACEFS_COMPARE_LT, "50",
				       false, false);
	tracefs_synth_add_end_filter(synth, "prev_prio",
				       TRACEFS_COMPARE_LT, "100",
				       false, true);

	trace_seq_init(&seq);
	tracefs_synth_show(&seq, tracefs_synth_show(&s, NULL, synth);
	trace_seq_terminate(&s);
	trace_seq_do_printf(&s);
	trace_seq_destroy(&s);

	tracefs_synth_free(synth);

Will produce:

echo 'wakeup_lat s32 pid; s32 prio; char comm[16]; s32 prev_prio; u64 delta;' > /sys/kernel/tracing/synthetic_events
echo 'hist:keys=pid:__arg__1=prio,__arg__2=common_timestamp.usecs if (prio < 100)' > /sys/kernel/tracing/events/sched/sched_waking/trigger
echo 'hist:keys=next_pid:pid=next_pid,prio=$__arg__1,comm=next_comm,prev_prio=prev_prio,delta=common_timestamp.usecs-$__arg__2:onmatch(sched.sched_waking).trace(wakeup_lat,$pid,$prio,$comm,$prev_prio,$delta) if (next_prio < 50) || (prev_prio < 100)' > /sys/kernel/tracing/events/sched/sched_switch/trigger

There's functionality to also create and destroy the synthetic event, not
only produce the above.

Once this is in libtracefs, it can then be brought over to trace-cruncher
where this can be done in Python.

Steven Rostedt (VMware) (4):
  libtracefs: Add tracefs_list_pop() to remove the last item
  libtracefs: Create a way to create a synthetic event
  libtracefs: Add TRACEFS_TIMESTAMP and TRACEFS_TIMESTAMP_USECS to synth
  libtracefs: Add man pages for creating synthetic events

 Documentation/libtracefs-synth.txt |  353 +++++++++
 include/tracefs.h                  |   70 ++
 src/tracefs-hist.c                 | 1104 ++++++++++++++++++++++++++++
 src/tracefs-utils.c                |   26 +
 4 files changed, 1553 insertions(+)
 create mode 100644 Documentation/libtracefs-synth.txt

-- 
2.30.2

