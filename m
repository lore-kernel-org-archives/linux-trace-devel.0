Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A81C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5625F64F8D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhCKO4b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 09:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbhCKO4P (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 09:56:15 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49C3C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 06:56:15 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so3340214pjb.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 06:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=npPb0FyYjm0Z+c5basaZyGCbaFfUWDDqVndaXscI1R8=;
        b=qPsfB1U3KkLzhf3Nme2RiDTygoV0TecbLyddcHDPj87Oz/HiDdMx5EJmNQ5iUXGOT2
         quBjUUQP4OWNzklVvUhNEvAlXECTazArDFMdiEn/MIDYLOQC348s134X7VogOos25Ves
         Zi18Ruysxyqsl3u4kU7Gq5TQnBoICgP+NxlEmSr363pH3C2Im32RM3GYtdGlcCMDCNTV
         aqLuBGERD+Gp0xrB6vbZPBEPIlnY9OxMx6nb+7NOnaGTo1hxkcx8emHflXX+efu/V0g+
         o1IpRjLMuKLv4wKxKSsERi5GlShRZNs8KUcTjzSHfVgxGCkV1/XvdNIrms7imX+38W2m
         IqWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=npPb0FyYjm0Z+c5basaZyGCbaFfUWDDqVndaXscI1R8=;
        b=gWRU9bzkqeK80HE2rCI1Ss/IbR+WMWILrvkKYAEq8/A7yB2KUNeo3lzH58xzTZ5T0o
         KjLcJdFfdGV/LaP+6vsTwdjRUHfcXRhJmURu/K1lj+KnP/juFW067DjJQu4nQtYCtU2l
         mCD6WogngeHAoLvwGxpqmIKgBj/gyX8FlhLq75+NOONWiSes9L2/XfqMDPzKtCuQZRg9
         dUBQO78GZCkHoAskJ/Vabm5a9LKPfrUQbwyLF0xjbEOEomjl5dAtP4/e2iwFsTuSwpRO
         Zua4/kBkYHLNpW+xe/P60+IfrfJJqEm4RFuB2AGrtvAOTS9ue68iUsqLqZszX6LPRf8e
         BH6Q==
X-Gm-Message-State: AOAM532GIn7bT5mZyeSF1MhPpTWTkF2Ogxw+5C+LzJvEOPjLDrcerZxx
        sosxvPA1FtuMIRSsFUVrBEUkGUzOIu879he8Y4i+Ni1Ag4H0dQ==
X-Google-Smtp-Source: ABdhPJylNaniCLS632hCGZZds+Ui2ZX2sOisM07+KNoBK/PNoPL3lqG5b/vdRm6TZWyqBrRTNssSPkBPP8itEKACgPY=
X-Received: by 2002:a17:902:bd8d:b029:e6:5398:609f with SMTP id
 q13-20020a170902bd8db02900e65398609fmr8357867pls.58.1615474575225; Thu, 11
 Mar 2021 06:56:15 -0800 (PST)
MIME-Version: 1.0
References: <20210311094401.7c6bf259@gandalf.local.home>
In-Reply-To: <20210311094401.7c6bf259@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 11 Mar 2021 16:55:58 +0200
Message-ID: <CAPpZLN7ZGPuScAuXozHA8gQ6xQGFUZMDHtn2LG3CKeJPDYeWLw@mail.gmail.com>
Subject: Re: Clock sync priorities
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Dario Faggioli <dfaggioli@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Mar 11, 2021 at 4:44 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Hi Tzvetomir,
>
> I took a look at the following options:
>
>   trace-cmd record : --date , --ts-offset
>
>   trace-cmd report : --ts-offset , --ts2secs
>
> And thought about how this will be affected by the the new host-guest
> sync, and the tsc2nsecs.
>
> Note, all of this is if the user does not specify -C on the record command
> line. If the user specifies a clock, then only the host-guest in this is
> done, but the tsc2nsecs is *not* performed.
>
> 1) trace-cmd record --date
>
> man page:
>
>   --date
>            With the --date option, "trace-cmd" will write timestamps into
>            the trace buffer after it has finished recording. It will then
>            map the timestamp to gettimeofday which will allow wall time
>            output from the timestamps reading the created trace.dat file.
>
> My thought is this:
>
>   raw time stamp (what is recorded in each event)
>
>   + host-guest sync (for guest trace.dat files)
>
>   + tsc2nsecs
>
>   + conversion to wall time.

In the following command:
trace-cmd record --date -e kvm -A GuestVM -e all --date
We have in the host trace file:
   - conversion to wall time, based on the raw TSC clock
   - conversion of raw TSC to nanoseconds
I think it does not make sense to apply conversion to wall time on the
nanoseconds, as this --date offset is according to the raw TSC, not to
the corresponding nanoseconds ?

In the guest is even more complicated, as we have:
 - conversion to wall time, based on the raw guest TSC clock
 - host-guest sync, which converts guest TSC to host TSC
 - conversion of raw host TSC to nanoseconds
We cannot apply 'conversion to wall time' based on the guest raw TSC
on the final result where we have guest events in nanoseconds (based
on host TSC)

>
> That is, the --date will work on the raw time stamp plus the conversion to
> host and then to nanoseconds, and then convert that to wall time.
>
> 2) trace-cmd record --ts-offset
>
>
> man page:
>
>   --ts-offset offset
>            Add an offset for the timestamp in the trace.dat file. This will
>            add a offset option into the trace.dat file such that a
>            trace-cmd report will offset all the timestamps of the events by
>            the given offset. The offset is in raw units. That is, if the
>            event timestamps are in nanoseconds the offset will also be in
>            nanoseconds even if the displayed units are in microseconds.
>
> I think we can do the same thing as with the --date.
>
>   raw time stamp (what is recorded in each event)
>
>   + host-guest sync (for guest trace.dat files)
>
>   + tsc2nsecs (only if -C is not specified)
>
>   + add offset.
>
>
> 3) trace-cmd report --ts-offset
>
> man page:
>
>   --ts-offset offset
>            Add (or subtract if negative) an offset for all timestamps of
>            the previous data file specified with -i. This is useful to
>            merge sort multiple trace.dat files where the difference in the
>            timestamp is known. For example if a trace is done on a virtual
>            guest, and another trace is done on the host. If the host
>            timestamp is 1000 units ahead of the guest, the following can be
>            done:
>
>                trace-cmd report -i host.dat --ts-offset -1000 -i guest.dat
>
>                This will subtract 1000 timestamp units from all the host events as it merges
>                with the guest.dat events. Note, the units is for the raw units recorded in
>                the trace. If the units are nanoseconds, the addition (or subtraction) from
>                the offset will be nanoseconds even if the displayed units are microseconds.
>
>
> Again, I think we can do the following:
>
>   raw time stamp (what is recorded in each event)
>
>   + host-guest sync (for guest trace.dat files)
>
>   + tsc2nsecs (only if in trace.dat files)
>
>   + add offset (in nano seconds if -C was not specified in record)
>
>
> The rationale is that is that we should be processing what the user sees.
> If they see nanoseconds (regardless if its truncated to microseconds) then
> the --ts-offset should be in nanoseconds.
>
> 4) trace-cmd report --ts2secs
>
> man page:
>
>   --ts2secs HZ
>            Convert the current clock source into a second (nanosecond
>            resolution) output. When using clocks like x86-tsc, if the
>            frequency is known, by passing in the clock frequency, this will
>            convert the time to seconds.
>
>                This option affects any trace.dat file given with *-i* proceeding it.
>                If this option comes before any *-i* option, then that value becomes
>                the default conversion for all other trace.dat files. If another
>                --ts2secs option appears after a *-i* trace.dat file, than that option
>                will override the default value.
>
>                Example: On a 3.4 GHz machine
>
>                trace-cmd record -p function -C x86-tsc
>
>                trace-cmd report --ts2ns 3400000000
>
>                The report will convert the cycles timestamps into a readable second
>                display. The default display resolution is microseconds, unless *-t*
>                is used.
>
>                The value of --ts-offset must still be in the raw timestamp units, even
>                with this option. The offset will be converted as well.
>
>
> This is the one exception, and done differently. But I think we should
> still process the host-guest conversion first. But when this specified,
> then it overrides the tsc2nsecs in the trace.dat file.
>
>   raw time stamp (what is recorded in each event)
>
>   + host-guest sync (for guest trace.dat files)
>
>   + use --ts2secs instead of tsc2nsecs
>
>
> 5) trace-cmd report --ts2secs --ts-offset
>
> Now if someone were to add both --ts2secs and --ts-offset, we should do the
> same as --ts-offset and replace the tsc2nsecs with what is in the --ts2secs.
>
>   raw time stamp (what is recorded in each event)
>
>   + host-guest sync (for guest trace.dat files)
>
>   + use --ts2secs instead of tsc2nsecs
>
>   + add offset (in nano seconds if -C was not specified in record)
>
>
> Does this make sense?
>
> Dario, feel free to comment on this as well. The host-guest is the
> information stored in each guest file that tells it how its TSC matches the
> host (if -C is not used in the record). The ts2nsecs is done on the host
> where it reads the perf data to find out how the kernels converts the TSC
> to nanoseconds, and this information is stored in each trace.dat file (host
> and guest). This email is about how those will affect the current options
> listed above.
>
> Thanks!
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
