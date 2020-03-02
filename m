Return-Path: <SRS0=nG5h=4T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA6BBC3F2D1
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 13:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A8AF2187F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 13:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgCBNn7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 08:43:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbgCBNn7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 08:43:59 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 492F12187F;
        Mon,  2 Mar 2020 13:43:58 +0000 (UTC)
Date:   Mon, 2 Mar 2020 08:43:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v20 13/15] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
Message-ID: <20200302084356.4e021c6c@oasis.local.home>
In-Reply-To: <CAPpZLN67B53wpkZATXnXViaTYW=t9XsX0hVQXu==EtLFzNhotA@mail.gmail.com>
References: <20200227142001.61577-1-tz.stoyanov@gmail.com>
        <20200227142001.61577-14-tz.stoyanov@gmail.com>
        <20200228192811.77831fc9@gandalf.local.home>
        <CAPpZLN67B53wpkZATXnXViaTYW=t9XsX0hVQXu==EtLFzNhotA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 2 Mar 2020 11:43:52 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Sat, Feb 29, 2020 at 2:28 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> >
> > Now that I'm playing with patch 14, I took more interest in this code.
> >
> > On Thu, 27 Feb 2020 16:19:59 +0200
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> >  
> > > +
> > > +#define PROTO_MASK_SIZE (sizeof(char))  
> >
> > Hmm, this is the size in bytes of the mask, not bits. You may need both.
> >
> > #define PROTO_MASK_BITS (PROTO_MASK_SIZE * 8)
> >
> > Because we can have up to 8 protocols per mask size (8 bits in a byte).
> >  
> > > +/**
> > > + * tracecmd_tsync_proto_select - Select time sync protocol, to be used for
> > > + *           timestamp synchronization with a peer
> > > + *
> > > + * @proto_mask: bitmask array of time sync protocols, supported by the peer
> > > + * @length: size of the @protos array
> > > + *
> > > + * Retuns Id of a time sync protocol, that can be used with the peer, or 0
> > > + *     in case there is no match with supported protocols
> > > + */
> > > +unsigned int tracecmd_tsync_proto_select(char *proto_mask, int length)
> > > +{
> > > +     struct tsync_proto *selected = NULL;
> > > +     struct tsync_proto *proto;
> > > +     int word;
> > > +     int id;
> > > +
> > > +     for (word = 0; word < length; word++) {
> > > +             for (proto = tsync_proto_list; proto; proto = proto->next) {
> > > +                     if (proto->proto_id < word * PROTO_MASK_SIZE)
> > > +                             continue;  
> >
> > The above should be: proto->proto_id < word * PROTO_MASK_BITS
> >
> > Because what you have currently is:
> >
> >    proto->proto_id < word * 1
> >
> >  
> > > +
> > > +                     id = proto->proto_id - word * PROTO_MASK_SIZE;  
> >
> > And here you want PROTO_MASK_BITS, otherwise if we have a proto_id of 2
> > (which would fit as a bit in a char), this would become:
> >
> >         id = 2 - 0 * 1 = 1
> >  
> > > +                     if (id >= PROTO_MASK_SIZE)  
> >
> > Then this is: 2 >= 1 which would skip it.
> >
> > Hmm, maybe you don't even need PROTO_MASK_SIZE and only need
> > PROTO_MASK_BITS.
> >  
> The PROTO_MASK_SIZE is the size of 1 word of the mask array, in bytes.
> In the first implementation the array was of integers, and the define
> was 4. It was very easy to switch to char, that's why I prefer to keep
> the implementation as is - even though that "proto->proto_id < word *
> 1".
> The confusion is the name of the variable "id", which is actually the
> index of the bit inside the given bitmask's word. In the example of
> proto_id 2:
>   - the word is 0, this proto_id is in the first word from the bitmask array.
>   - the index of the bit in this word is 2 ( id = 2 - 0 * 1 = 2 )

Yes, 2 (that's what I meant), but then my point still is valid.

>   - then we can check if the bit, representing the proto_id 2 is up:
>         if ((1 << id) & proto_mask[word]) ...

I'm talking about this:

+			id = proto->proto_id - word * PROTO_MASK_SIZE;
+			if (id >= PROTO_MASK_SIZE)
+				continue;


Where id = 2, then if (2 >= 1) continue, means we skip it.

You need: if (id >= PROTO_MASK_SIZE_BITS)

-- Steve
