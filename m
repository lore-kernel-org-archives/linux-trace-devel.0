Return-Path: <SRS0=yu5d=D5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE831C55178
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Oct 2020 01:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ACF0223FB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Oct 2020 01:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437961AbgJVBbi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Oct 2020 21:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410303AbgJVBbi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Oct 2020 21:31:38 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0EB1223FB;
        Thu, 22 Oct 2020 01:31:37 +0000 (UTC)
Date:   Wed, 21 Oct 2020 21:31:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v24 03/10] trace-cmd: Add trace-cmd library APIs for
 ftrace clock name
Message-ID: <20201021213135.2022f4e0@oasis.local.home>
In-Reply-To: <20201021212626.1c3436c4@oasis.local.home>
References: <20201009140338.25260-1-tz.stoyanov@gmail.com>
        <20201009140338.25260-4-tz.stoyanov@gmail.com>
        <20201021212626.1c3436c4@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 21 Oct 2020 21:26:26 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri,  9 Oct 2020 17:03:31 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> 
> > Added enum with ftrace clock IDs and APIs to convert ftrace name to ID
> > and vice versa, as part of libtracecmd.
> > 
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  include/trace-cmd/trace-cmd.h | 16 +++++++++++++
> >  lib/trace-cmd/trace-util.c    | 45 +++++++++++++++++++++++++++++++++++
> >  2 files changed, 61 insertions(+)
> > 
> > diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> > index f9c1f843..393a2e7b 100644
> > --- a/include/trace-cmd/trace-cmd.h
> > +++ b/include/trace-cmd/trace-cmd.h
> > @@ -415,6 +415,22 @@ int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
> >  				unsigned int *sync_msg_id,
> >  				unsigned int *payload_size, char **payload);
> >  
> > +enum tracecmd_clocks {
> > +	TRACECMD_CLOCK_UNKNOWN	= 0,
> > +	TRACECMD_CLOCK_LOCAL	= 1,
> > +	TRACECMD_CLOCK_GLOBAL	= 1 << 1,
> > +	TRACECMD_CLOCK_COUNTER	= 1 << 2,
> > +	TRACECMD_CLOCK_UPTIME	= 1 << 3,
> > +	TRACECMD_CLOCK_PERF	= 1 << 4,
> > +	TRACECMD_CLOCK_MONO	= 1 << 5,
> > +	TRACECMD_CLOCK_MONO_RAW	= 1 << 6,
> > +	TRACECMD_CLOCK_BOOT	= 1 << 7,
> > +	TRACECMD_CLOCK_X86_TSC	= 1 << 8  
> 
> I'm curious to why you have this as a bitmask. We can only have on
> clock at a time, right?

I got to patch 5 and see that you do need this to be a bitmask.

When this is the case, the change log should state that. That is, the
change log should have something like:

The clock enum will be used in a bitmask such that the synchronization
protocol can pass a bitmask of supported clocks.

Remember, all patches should be "stand alone". That is, do not assume
that someone will have access to other patches when they are looking at
the current patch.

You may disregard the rest of this email.

-- Steve
