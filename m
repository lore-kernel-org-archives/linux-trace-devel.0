Return-Path: <SRS0=sUNk=X2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1A6ECE587
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Oct 2019 15:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CC9E2086A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Oct 2019 15:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389663AbfJAPpO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Oct 2019 11:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbfJAPpN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Oct 2019 11:45:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61CBD2086A;
        Tue,  1 Oct 2019 15:45:13 +0000 (UTC)
Date:   Tue, 1 Oct 2019 11:45:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] trace-cmd: Reset CPU mask to its default value
 with "trace-cmd reset".
Message-ID: <20191001114512.37929af3@gandalf.local.home>
In-Reply-To: <CAPpZLN67T2bbcKiPczA93uW8rNSO5qg3MD+ETUDQLZmCN=iOJA@mail.gmail.com>
References: <20191001145740.8866-1-tz.stoyanov@gmail.com>
        <20191001145740.8866-3-tz.stoyanov@gmail.com>
        <20191001113232.644fa2f0@gandalf.local.home>
        <CAPpZLN67T2bbcKiPczA93uW8rNSO5qg3MD+ETUDQLZmCN=iOJA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 1 Oct 2019 18:37:54 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Tue, Oct 1, 2019 at 6:32 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Tue,  1 Oct 2019 17:57:40 +0300
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> >  
> > > "trace-cmd reset" command should put all ftrace config to its default
> > > state, but trace cpumask was not reseted. The patch sets cpumask to
> > > its default value - all CPUs are enabled for tracing.
> > >
> > > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > > ---
> > >  tracecmd/trace-record.c | 35 +++++++++++++++++++++++++++++++++++
> > >  1 file changed, 35 insertions(+)
> > >
> > > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > > index 69de82a..6f3520c 100644
> > > --- a/tracecmd/trace-record.c
> > > +++ b/tracecmd/trace-record.c
> > > @@ -4096,6 +4096,40 @@ static void reset_clock(void)
> > >               write_instance_file(instance, "trace_clock", "local", "clock");
> > >  }
> > >
> > > +static void reset_cpu_mask(void)
> > > +{
> > > +     struct buffer_instance *instance;
> > > +     int cpus = count_cpus();
> > > +     int fullwords;
> > > +     char *buf;
> > > +     int bits;
> > > +     int len;
> > > +
> > > +     fullwords = cpus / 32;
> > > +     bits = cpus % 32;
> > > +     len = (fullwords + 1) * 9;
> > > +
> > > +     buf = malloc(len + 1);
> > > +     if (!buf) {
> > > +             warning("Unable to allocate %d bytes for cpu mask", len + 1);
> > > +             return;
> > > +     }
> > > +     buf[0] = '\0';
> > > +     if (bits) {
> > > +             sprintf(buf, "%x", (1 << bits) - 1);
> > > +     } else if (fullwords) {
> > > +             strcat(buf, "ffffffff");
> > > +             fullwords--;
> > > +     }
> > > +     while (fullwords-- > 0)
> > > +             strcat(buf, ",ffffffff");  
> >
> > I like my way because it's a little more condensed ;-)
> >
> > But this works too and it's far from a fast path. As it's probably
> > more readable, I'll all this one.
> >
> > -- Steve
> >  
> Actually the only change here is to handle the case when bits is 0,
> not to put the leading ",".
> The ftrace complains with "Invalid argument" in that case.
> 

Mine handled that case too. The difference was the "cpus - 1" part of
my code:

	fullwords = (cpus - 1) / 32;  <--
	bits = (cpus - 1) % 32 + 1;   <--
	len = (fullwords + 1) * 9;

	buf = malloc(len + 1);
	buf[0] = '\0';

	if (bits)
		sprintf(buf, "%x", (unsigned int)((1ULL << bits) - 1));
	while (fullwords-- > 0)
		strcat(buf, ",ffffffff");


The output of yours and mine were identical. When cpus was a power of
32, it would still have one less of "fullwords", and bits would be 32.
Which is why I needed to add "1ULL" to make:

	(1 << 32) - 1 == 0xffffffff

the fullwords was only for non bits.

-- Steve
