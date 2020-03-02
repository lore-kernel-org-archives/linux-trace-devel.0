Return-Path: <SRS0=nG5h=4T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02AB9C3F2D2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 09:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6504246BE
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 09:44:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pa+xYdzb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCBJoE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 04:44:04 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44988 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgCBJoE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 04:44:04 -0500
Received: by mail-pf1-f195.google.com with SMTP id y5so5294455pfb.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Mar 2020 01:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WCEthpR+KH1E5n68apZMLxsfrFFA/lb3BzmzQh5B+38=;
        b=Pa+xYdzbFv28svaqjbx1kvIqQ8Fe8ToCvARtf9vhr0InuA3J0LiGiaXk7RtnF5vNeu
         FWM2uLqYDhiwp72s2/n8S4VYr5oY0W6ygw7tsRhv7x8t3Kr0QWzUchWo7vT7L2txL4XH
         cm4tHjBxEFrj01fvnsc+6hI1qmP3CKzYelJVAPJWeEscOJw8g2C0Vze9Ge5Py5taC9aP
         xGeqzeB2jc2u0470PSTlh8PagQWpCoWPC0LvvZn5Odn9w76u8o9MocJgqbIHL5W5ng99
         ndGVqN1qo0V33FoE9aQBxOh6rhN9Lf5h9POxMB2McEeiMMTWE0ZyWhFOZL4pKQtboGZV
         rWBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WCEthpR+KH1E5n68apZMLxsfrFFA/lb3BzmzQh5B+38=;
        b=ozeHwOTqMpCsxEViM7eMrShOahYfGjopJ+EV5LZ9b1DGr/gXr5g6af8K7dO5naMw7D
         /cQ4xn31ADG7HTtZ3r9dPYmyh0/k1fakqN7l5Exp0Qw7nD+mqMfcl9RrLHZpLgJrd9ZQ
         J1LTI6+3jA38XiMTk9yfQQ9vO7YwX5ND6k0hsNOtwDKpMred6CPWptIqnnMlPWaZLXQx
         mfLFPwGSFk7P5ptwAmebsB2/8gHERmUVenA49W1A5qmNM8Ad75sZRbbZRzPGvu+adfYw
         m0e84iMgBE+gjNakW6TQzZKe9zFBu90/zFEtgbl/xyFk+hYMxcNGT00shkYSl4q/8q8S
         Homg==
X-Gm-Message-State: APjAAAVnkS6vCzjaACtRLHtSxHVKoubfoBYP5bgFXcLL4gjQtQlHxpFX
        mLBl6zys4Q278sDQbuPYabCQ1ned0X8BInrhjITGIn3r
X-Google-Smtp-Source: APXvYqwFWiQUt3/mwwk8WYwNJRjekb6rvjWsHBORt1Bc/erq0AOB9Jsq902dZgjuTbTWZ+5Ba7iNycf1GqIc0ncv6KA=
X-Received: by 2002:a63:565e:: with SMTP id g30mr18369172pgm.206.1583142243738;
 Mon, 02 Mar 2020 01:44:03 -0800 (PST)
MIME-Version: 1.0
References: <20200227142001.61577-1-tz.stoyanov@gmail.com> <20200227142001.61577-14-tz.stoyanov@gmail.com>
 <20200228192811.77831fc9@gandalf.local.home>
In-Reply-To: <20200228192811.77831fc9@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 2 Mar 2020 11:43:52 +0200
Message-ID: <CAPpZLN67B53wpkZATXnXViaTYW=t9XsX0hVQXu==EtLFzNhotA@mail.gmail.com>
Subject: Re: [PATCH v20 13/15] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Feb 29, 2020 at 2:28 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
> Now that I'm playing with patch 14, I took more interest in this code.
>
> On Thu, 27 Feb 2020 16:19:59 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > +
> > +#define PROTO_MASK_SIZE (sizeof(char))
>
> Hmm, this is the size in bytes of the mask, not bits. You may need both.
>
> #define PROTO_MASK_BITS (PROTO_MASK_SIZE * 8)
>
> Because we can have up to 8 protocols per mask size (8 bits in a byte).
>
> > +/**
> > + * tracecmd_tsync_proto_select - Select time sync protocol, to be used for
> > + *           timestamp synchronization with a peer
> > + *
> > + * @proto_mask: bitmask array of time sync protocols, supported by the peer
> > + * @length: size of the @protos array
> > + *
> > + * Retuns Id of a time sync protocol, that can be used with the peer, or 0
> > + *     in case there is no match with supported protocols
> > + */
> > +unsigned int tracecmd_tsync_proto_select(char *proto_mask, int length)
> > +{
> > +     struct tsync_proto *selected = NULL;
> > +     struct tsync_proto *proto;
> > +     int word;
> > +     int id;
> > +
> > +     for (word = 0; word < length; word++) {
> > +             for (proto = tsync_proto_list; proto; proto = proto->next) {
> > +                     if (proto->proto_id < word * PROTO_MASK_SIZE)
> > +                             continue;
>
> The above should be: proto->proto_id < word * PROTO_MASK_BITS
>
> Because what you have currently is:
>
>    proto->proto_id < word * 1
>
>
> > +
> > +                     id = proto->proto_id - word * PROTO_MASK_SIZE;
>
> And here you want PROTO_MASK_BITS, otherwise if we have a proto_id of 2
> (which would fit as a bit in a char), this would become:
>
>         id = 2 - 0 * 1 = 1
>
> > +                     if (id >= PROTO_MASK_SIZE)
>
> Then this is: 2 >= 1 which would skip it.
>
> Hmm, maybe you don't even need PROTO_MASK_SIZE and only need
> PROTO_MASK_BITS.
>
The PROTO_MASK_SIZE is the size of 1 word of the mask array, in bytes.
In the first implementation the array was of integers, and the define
was 4. It was very easy to switch to char, that's why I prefer to keep
the implementation as is - even though that "proto->proto_id < word *
1".
The confusion is the name of the variable "id", which is actually the
index of the bit inside the given bitmask's word. In the example of
proto_id 2:
  - the word is 0, this proto_id is in the first word from the bitmask array.
  - the index of the bit in this word is 2 ( id = 2 - 0 * 1 = 2 )
  - then we can check if the bit, representing the proto_id 2 is up:
        if ((1 << id) & proto_mask[word]) ...



> -- Steve
>
> > +                             continue;
> > +
> > +                     if ((1 << id) & proto_mask[word]) {
> > +                             if (selected) {
> > +                                     if (selected->weight < proto->weight)
> > +                                             selected = proto;
> > +                             } else
> > +                                     selected = proto;
> > +                     }
> > +             }
> > +     }
> > +
> > +     if (selected)
> > +             return selected->proto_id;
> > +
> > +     return 0;
> > +}
> > +



--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
