Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0CAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 16:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EB8D610EA
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 16:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhKCQuR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhKCQuQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 12:50:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAC8160FC2;
        Wed,  3 Nov 2021 16:47:39 +0000 (UTC)
Date:   Wed, 3 Nov 2021 12:47:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 01/11] libtracefs: Add new public macros for bits
 manipulations
Message-ID: <20211103124736.5965be6d@gandalf.local.home>
In-Reply-To: <CAPpZLN5ihwBHfKaaUtZGddRnJrrEvdsqc1poohUNxRmdiovo5g@mail.gmail.com>
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
        <20211103154417.246999-2-tz.stoyanov@gmail.com>
        <20211103122406.7a21859c@gandalf.local.home>
        <CAPpZLN5ihwBHfKaaUtZGddRnJrrEvdsqc1poohUNxRmdiovo5g@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 3 Nov 2021 18:34:49 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Wed, Nov 3, 2021 at 6:24 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Wed,  3 Nov 2021 17:44:07 +0200
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> >  
> > > diff --git a/include/tracefs.h b/include/tracefs.h
> > > index a2cda30..fa7f316 100644
> > > --- a/include/tracefs.h
> > > +++ b/include/tracefs.h
> > > @@ -10,6 +10,10 @@
> > >  #include <sched.h>
> > >  #include <event-parse.h>
> > >
> > > +#define TRACEFS_BIT_SET(M, B)        do { (M) |= (1ULL << (B)); } while (0)
> > > +#define TRACEFS_BIT_TEST(M, B)       ((M) & (1ULL<<(B)))
> > > +#define TRACEFS_BIT_CLEAR(M, B)      do { (M) &= ~(1ULL << (B)); } while (0)  
> >
> > Does this really need to be public?
> >
> > I was thinking that this would just be used internally, and thus in the
> > tracefs-local.h.
> >  
> 
> The  only reason to export it is because of these APIs, which get
> bitmask of enum tracefs_dynevent_type types:
>      int tracefs_dynevent_destroy_all(unsigned long type_mask, bool force);
>      struct tracefs_dynevent **tracefs_dynevent_get_all(unsigned long
> type_mask, const char *system);
> Currently that type is simple enum, and those macros are used to
> construct the bitmask:
> enum tracefs_dynevent_type {
>     TRACEFS_DYNEVENT_KPROBE = 0,
>     TRACEFS_DYNEVENT_KRETPROBE,
>     TRACEFS_DYNEVENT_UPROBE,
>     TRACEFS_DYNEVENT_URETPROBE,
>     TRACEFS_DYNEVENT_EPROBE,
>     TRACEFS_DYNEVENT_SYNTH,
>     TRACEFS_DYNEVENT_MAX,
> };
> 
> The other possible approach is to define the eum in that way, then no
> macros will be needed:
> enum tracefs_dynevent_type {
>     TRACEFS_DYNEVENT_KPROBE = 1,

For consistency we usually use "1 << 0" for this.

>     TRACEFS_DYNEVENT_KRETPROBE = 1 << 1,
>     TRACEFS_DYNEVENT_UPROBE = 1 << 2,
>     TRACEFS_DYNEVENT_URETPROBE = 1 << 3,
>     TRACEFS_DYNEVENT_EPROBE = 1 << 4,
>     TRACEFS_DYNEVENT_SYNTH = 1 << 5,

The above is very common, but make sure to tab it:

     TRACEFS_DYNEVENT_KPROBE		= 1 << 0,
     TRACEFS_DYNEVENT_KRETPROBE		= 1 << 1,
     TRACEFS_DYNEVENT_UPROBE		= 1 << 2,
     TRACEFS_DYNEVENT_URETPROBE		= 1 << 3,
     TRACEFS_DYNEVENT_EPROBE		= 1 << 4,
     TRACEFS_DYNEVENT_SYNTH		= 1 << 5,


>     TRACEFS_DYNEVENT_MAX = 0,

Although 0 does not make sense. What you do is this:

	TRACEFS_DYNEVENT_MAX		= 1 << 6;

And then you can also have:

#define TRACEFS_DYNEVENT_MASK (TRACEFS_DYNEVENT_MAX - 1)

-- Steve
