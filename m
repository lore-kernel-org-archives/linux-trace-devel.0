Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B77A5C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 19:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66AB564EB4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 19:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBSTLt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Feb 2021 14:11:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229636AbhBSTLs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Feb 2021 14:11:48 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75E3A64E43;
        Fri, 19 Feb 2021 19:11:07 +0000 (UTC)
Date:   Fri, 19 Feb 2021 14:11:05 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 5/5] [WIP] trace-cmd: Add new subcomand "trace-cmd perf"
Message-ID: <20210219141105.7fb5c712@gandalf.local.home>
In-Reply-To: <CAPpZLN6OuoFnAtc6ERAKQwncL6FQ2pTpm6Sao0RUSyCg7W4cSg@mail.gmail.com>
References: <20201203060226.476475-1-tz.stoyanov@gmail.com>
        <20201203060226.476475-6-tz.stoyanov@gmail.com>
        <20210218210352.61470b93@oasis.local.home>
        <CAPpZLN6nPbJoDBHe0Fm8+BECfXHdpNjQFt9gK9mHGAQriiGjEw@mail.gmail.com>
        <20210219093623.6965e487@gandalf.local.home>
        <CAPpZLN6OuoFnAtc6ERAKQwncL6FQ2pTpm6Sao0RUSyCg7W4cSg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Feb 2021 19:56:59 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:


> > Make sense?  
> Yes, but I have two concerns:
>  1. Recording kvm enter / exit events will make this implementation
> KVM specific,
>      how about other hypervisors ?

I think this should all be part of the protocol. The option can be
TRACECMD_OPTION_GUEST_METADATA, where that has a field for "enter/exit"
events with CPU, vCPU, timestamp, and the also a note of sched switch
events.

That is, the implementation will enable kvm events, but other trace-cmd
plugins can implement other events. But what gets recorded into the
trace.dat file can be post processed into a generic format.


>  2. The problem with finding guest event -> host CPU relation. We now only the
>       timestamp of the guest event, not yet synchronized with the host
> time. How will
>       find on what host CPU that guest event happened, as the host
> task CPU migration
>       mapping is recorded with host time ?

It would be done all post processed. Here's the workflow I envision:

 1. Run pre synchronization protocol between host/guest (ie. kvm, ptp)

 2. Start the meta data events.
	Start tracing guest enter/exit events along with scheduling.
	We may be able to even filter specifically if we know the threads a
	head of time, but that's just an optimization.
	These events will be recorded raw into a file (with host threads
	saving the events to disk like it does for the tracing data).
	All this is in a separate instance.

 3. Run tracing
	Recorded events on the guest are sent to the host and stored in raw
	format on the host.
	Optionally, events on the host is also recorded.

 4. At the end of tracing
	Stop the recording of tracing.
	Stop the recording of meta data.
	Run post synchronization protocol between host and guest.

 5. Read the meta data events and convert them into a form of timestamp,
    enter/exit events, migration events. Yes, the timestamp will be that of
    the host.

A couple of things to understand with step 5, and assumptions we can make.

The scale factor between the host and guest for each VCPU should not
change, even if the VCPU migrates. If it does, then there had to have been a
kernel event where the kernel knew about this change, and we need to find a
way to extract that. For now, we shouldn't worry about it, as I'm guessing
that could be rather complex to manage even on the kernel end, and it would
also be expensive for migrations.

I'm making a big assumption here, that either the different VCPUS have
different scaling factors but the host scaling between physical CPUS are
the same, or the physical CPUS have different scaling factors, but the VCPUS
do not. So far I ran this on 4 different machines (including my laptop) and
all had the same mult and shift on the host. Perhaps we just state that we
do not support machines that do not have this.

Anyway, when all is done, the meta data events will map to the host. Using
this mapping and the synchronization between the host and guest, we can map
these migrations and such to the guest itself. And if the vCPUS are
different (and we assume the host is the same for all), and we know when
VCPU scheduled away from a physical CPU (from the host time), we can then
figure out how to find the guest time when that happened.

Or did I miss something?

-- Steve
