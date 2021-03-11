Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20854C433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C320C64FEB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhCKOoO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 09:44:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:59046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233684AbhCKOoE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 09:44:04 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CA2E64E55;
        Thu, 11 Mar 2021 14:44:03 +0000 (UTC)
Date:   Thu, 11 Mar 2021 09:44:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Dario Faggioli <dfaggioli@suse.com>
Subject: Clock sync priorities
Message-ID: <20210311094401.7c6bf259@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Tzvetomir,

I took a look at the following options:

  trace-cmd record : --date , --ts-offset

  trace-cmd report : --ts-offset , --ts2secs

And thought about how this will be affected by the the new host-guest
sync, and the tsc2nsecs.

Note, all of this is if the user does not specify -C on the record command
line. If the user specifies a clock, then only the host-guest in this is
done, but the tsc2nsecs is *not* performed.

1) trace-cmd record --date

man page:

  --date
           With the --date option, "trace-cmd" will write timestamps into
           the trace buffer after it has finished recording. It will then
           map the timestamp to gettimeofday which will allow wall time
           output from the timestamps reading the created trace.dat file.

My thought is this:

  raw time stamp (what is recorded in each event)

  + host-guest sync (for guest trace.dat files)

  + tsc2nsecs

  + conversion to wall time.

That is, the --date will work on the raw time stamp plus the conversion to
host and then to nanoseconds, and then convert that to wall time.

2) trace-cmd record --ts-offset


man page:

  --ts-offset offset
           Add an offset for the timestamp in the trace.dat file. This will
           add a offset option into the trace.dat file such that a
           trace-cmd report will offset all the timestamps of the events by
           the given offset. The offset is in raw units. That is, if the
           event timestamps are in nanoseconds the offset will also be in
           nanoseconds even if the displayed units are in microseconds.

I think we can do the same thing as with the --date.

  raw time stamp (what is recorded in each event)

  + host-guest sync (for guest trace.dat files)

  + tsc2nsecs (only if -C is not specified)

  + add offset.


3) trace-cmd report --ts-offset

man page:

  --ts-offset offset
           Add (or subtract if negative) an offset for all timestamps of
           the previous data file specified with -i. This is useful to
           merge sort multiple trace.dat files where the difference in the
           timestamp is known. For example if a trace is done on a virtual
           guest, and another trace is done on the host. If the host
           timestamp is 1000 units ahead of the guest, the following can be
           done:

               trace-cmd report -i host.dat --ts-offset -1000 -i guest.dat

               This will subtract 1000 timestamp units from all the host events as it merges
               with the guest.dat events. Note, the units is for the raw units recorded in
               the trace. If the units are nanoseconds, the addition (or subtraction) from
               the offset will be nanoseconds even if the displayed units are microseconds.


Again, I think we can do the following:

  raw time stamp (what is recorded in each event)

  + host-guest sync (for guest trace.dat files)

  + tsc2nsecs (only if in trace.dat files)

  + add offset (in nano seconds if -C was not specified in record)


The rationale is that is that we should be processing what the user sees.
If they see nanoseconds (regardless if its truncated to microseconds) then
the --ts-offset should be in nanoseconds.

4) trace-cmd report --ts2secs

man page:

  --ts2secs HZ
           Convert the current clock source into a second (nanosecond
           resolution) output. When using clocks like x86-tsc, if the
           frequency is known, by passing in the clock frequency, this will
           convert the time to seconds.

               This option affects any trace.dat file given with *-i* proceeding it.
               If this option comes before any *-i* option, then that value becomes
               the default conversion for all other trace.dat files. If another
               --ts2secs option appears after a *-i* trace.dat file, than that option
               will override the default value.

               Example: On a 3.4 GHz machine

               trace-cmd record -p function -C x86-tsc

               trace-cmd report --ts2ns 3400000000

               The report will convert the cycles timestamps into a readable second
               display. The default display resolution is microseconds, unless *-t*
               is used.

               The value of --ts-offset must still be in the raw timestamp units, even
               with this option. The offset will be converted as well.


This is the one exception, and done differently. But I think we should
still process the host-guest conversion first. But when this specified,
then it overrides the tsc2nsecs in the trace.dat file.

  raw time stamp (what is recorded in each event)

  + host-guest sync (for guest trace.dat files)

  + use --ts2secs instead of tsc2nsecs


5) trace-cmd report --ts2secs --ts-offset

Now if someone were to add both --ts2secs and --ts-offset, we should do the
same as --ts-offset and replace the tsc2nsecs with what is in the --ts2secs.

  raw time stamp (what is recorded in each event)

  + host-guest sync (for guest trace.dat files)

  + use --ts2secs instead of tsc2nsecs

  + add offset (in nano seconds if -C was not specified in record)


Does this make sense?

Dario, feel free to comment on this as well. The host-guest is the
information stored in each guest file that tells it how its TSC matches the
host (if -C is not used in the record). The ts2nsecs is done on the host
where it reads the perf data to find out how the kernels converts the TSC
to nanoseconds, and this information is stored in each trace.dat file (host
and guest). This email is about how those will affect the current options
listed above.

Thanks!

-- Steve
