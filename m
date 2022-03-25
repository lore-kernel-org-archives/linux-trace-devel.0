Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F5F0C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Mar 2022 20:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiCYUd1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 16:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbiCYUd0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 16:33:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EC2E0F5;
        Fri, 25 Mar 2022 13:31:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B47AE61D2A;
        Fri, 25 Mar 2022 20:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6B0C2BBE4;
        Fri, 25 Mar 2022 20:31:50 +0000 (UTC)
Date:   Fri, 25 Mar 2022 16:31:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     John Keeping <john@metanate.com>
Cc:     linux-trace-devel@vger.kernel.org, williskung@google.com,
        kaleshsingh@google.com, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 09/12] trace-cmd analyze: Add wake up latency timings
Message-ID: <20220325163148.0bf4146b@gandalf.local.home>
In-Reply-To: <20220325161333.65ffb789@gandalf.local.home>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
        <20220324025726.1727204-10-rostedt@goodmis.org>
        <Yj4ZPMJdz49eQy7I@donbot>
        <20220325161333.65ffb789@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 25 Mar 2022 16:13:33 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> I'll fix it in v2.

BTW, I plan on rewriting a lot of this to move it into libtracecmd. That
way other tools can easily extract data from it.

For example, instead of hard coding "page faults" and "wake ups" I plan on
adding a way to register events to trigger on. Something like:

 tracecmd_analyze_register_event_timing(handle, name, start_event,
		 start_field, start_record, end_event, end_field,
		 end_record);

Where "start_record" and "end_record" is if the field is a task to record.

enum {
	TRACECMD_ANALYZE_FL_NONE,
	TRACECMD_ANALYZE_FL_PID,
	TRACECMD_ANALYZE_FL_PID_CPU,
};

Thus, we could have:

	tracecmd_analyze_register_event_timing(handle,
			"Wakeup", sched_waking,
			pid_field, TRACECMD_ANALYZE_FL_PID,
			sched_switch, next_pid,
			TRACECMD_ANALYZE_FL_PID_CPU);

Or something like the above, that will end up turning into the
process_wakeup() function (and properly record the waking pid globally).

One tool I want to use this with, is my ktrace shell (development has
stalled, but I do plan on starting it again). 

  https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/ktrace.git/

And then I could have commands like:

ktrace> open trace.dat
ktrace> analyze register timing sched.sched_switch pid global \
  sched.sched_switch next_pid cpu
ktrace> analyze
ktrace> analyze show cpu 1

And it only shows cpu 1 data.

ktrace> analyze show pid 512

to see just pid 512

etc.

-- Steve
