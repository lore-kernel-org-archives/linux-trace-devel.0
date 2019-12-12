Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB55C43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 14:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 533FB21655
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 14:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbfLLOyP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 09:54:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728861AbfLLOyO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 09:54:14 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24603206C3;
        Thu, 12 Dec 2019 14:54:13 +0000 (UTC)
Date:   Thu, 12 Dec 2019 09:54:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v17 16/18] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
Message-ID: <20191212095411.05cc1318@gandalf.local.home>
In-Reply-To: <CAPpZLN5A9Am1v+yrpXwyoGQkeqvSza5QxRon61oSbyMZ5K4ghg@mail.gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
        <20191203103522.482684-17-tz.stoyanov@gmail.com>
        <20191210133919.47830c13@gandalf.local.home>
        <CAPpZLN5A9Am1v+yrpXwyoGQkeqvSza5QxRon61oSbyMZ5K4ghg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Dec 2019 14:34:39 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

>  Thanks, Steven!
> I will prepare the next version addressing the comments.
> 
> On Tue, Dec 10, 2019 at 8:39 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >  
> [ ... ]
> > >
> > > +static int tracecmd_msg_send_nofree(int fd, struct tracecmd_msg *msg)  
> >
> > We probably shouldn't have a static function that starts with
> > "tracecmd_".  
> 
> I changed this one, but noticed few other static "tracecmd_" functions
> in the legacy code, will rename them in a separate patch.

Yeah, those should probably be changed too.

> >  
> [ ... ]
> > > +
> > > +/**
> > > + * tracecmd_tsync_proto_select - Select time sync protocol, to be used for
> > > + *           timestamp synchronization with a peer.
> > > + *
> > > + * @protos: Bitmask of time sync protocols, supported by the peer.  
> >
> > Hmm, so we are limiting the number of protocols that we will ever
> > support to 32? This makes me nervous (I always think of the famous
> > quote of "Who will ever need more than 64K of RAM?")
> >
> > To be safe, we should probably make this an array:
> >
> >         int tracecmd_tsync_proto_select(unsigned int *protos, int words)
> >
> > The proto_id should be a bit, not a mask, that is:
> >
> >         int word;
> >
> >         for (word = 0; word < words; word++) {
> >
> >                 for (proto = tsync_proto_list; proto; proto = proto->next) {
> >                         if (proto->proto_id < word * 32)
> >                                 continue;
> >
> >                         id = proto->proto_id - word * 32;
> >                         if (id >= 32)
> >                                 continue;
> >
> >                         if ((1 << id) & protos[word]) {
> >                                 if (selected)
> >                                         [...]
> >
> > While we only have a single word, callers would just do:
> >
> >         unsigned int protos;
> >
> >         ret = tracecmd_tsync_proto_select(&protos, 1);
> >
> > At least this will never limit us to just 32 protocols, even though we
> > will likely never need more. But we are safe if we ever do ;-)
> >  
> 
> I changed this and tracecmd_tsync_proto_getall() to work with
> unlimited bitmasks,
> but in order to support more than 32 protocols the trace request  packet must be
> changed. In the current patch I added field
>                                  be32 tsync_protos;
> in struct tracecmd_msg_trace_req, which is bitmask for all time sync
> protocols, supported
> by the host. Defining this as a fixed size bitmap simplifies a lot the
> protocol. We can add a
> dynamic bitmask as part of the trace request  packet payload, but that
> payload is already used
> for the trace arguments. We can extend the payload to hold both
> dynamic bitmask and trace arguments,
> but I think it will complicate a lot the packet handling and the
> benefit will be only the posibility to support
> more than 32 time sync protocols.

Perhaps instead, we can add an option to which 32bit word the protocols
are used. That is, we pass an index of what the tsync_protos are, and
the response can pick one of them, and even say how many more words it
has.

That is, I don't think we should change the protocol to pass the entire
bitmask. Just part of it, and if we find a match, we use that. That
should keep it from being too complicated, right?

-- Steve


> 
> > > + *  
> [ ... ]
> 

