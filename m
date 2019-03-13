Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAFF0C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 14:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B41D214AE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 14:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfCMOuY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 10:50:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbfCMOuY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 10:50:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18D822147C;
        Wed, 13 Mar 2019 14:50:23 +0000 (UTC)
Date:   Wed, 13 Mar 2019 10:50:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Claudio <claudio.fontana@gliwa.com>
Cc:     joel@joelfernandes.org,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>, Chunyu Hu <chuhu@redhat.com>
Subject: Re: make TGID available also in binary ring buffer?
Message-ID: <20190313105020.07bb8254@gandalf.local.home>
In-Reply-To: <0ce98e8a-47b7-7890-500a-e0a2bc938b53@gliwa.com>
References: <6e61f5ff-5302-ad96-66d3-38347bf3cf69@gliwa.com>
        <20190304135147.5fcc243f@gandalf.local.home>
        <ac830875-ca55-9978-1ece-4614fd988d29@gliwa.com>
        <20190313094417.7ed14ee0@gandalf.local.home>
        <0ce98e8a-47b7-7890-500a-e0a2bc938b53@gliwa.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 Mar 2019 15:03:35 +0100
Claudio <claudio.fontana@gliwa.com> wrote:


> >>
> >> When I read an event for a new process or thread
> >> (sched_process_fork), I need to know if it is a new thread or a
> >> new process at that time, and collect the tgid of the child.  
> > 
> > You are reading this at the time of tracing?  
> 
> Yes, my requirements are for live tracing of the low level events,
> and correlation of the events from all cores, in order to be able to
> immediately respond to the events from the tracing application.
> 
> Tracing is expected to be always on in the system (no expected
> trace-first/analyze later pattern - everything related to the
> analysis of the events is automated and occurs at runtime).

You could add a kprobe to find out the tgid as well.

> 
> This works fine for the real time timing analysis at the thread
> level, but for the process level I need to know the tgid of the
> thread at the time I see the event. 
> >>
> >> How can I get that information, if the update is done only at the
> >> time of the first "child" context-switch?
> >>
> >> 3) Is the saved_tgids map in sync with the reader of
> >> trace_pipe_raw, so that when reading an event from the pipe, the
> >> saved_tgids represent the particular state of the tid to tgid maps
> >> at the timestamp indicated in the event?  
> > 
> > Currently, it's only taken at the end of the trace.  
> 
> I wonder what the concept of the "end of the trace" is..


I meant for "trace-cmd record", the saved_cmdlines are stored when the
tracing is finished, not during the trace. But the saved_cmdlines is
updated at each sched_switch, and so is the tgid.

Now, we could add that info to the fork part as well.

-- Steve
