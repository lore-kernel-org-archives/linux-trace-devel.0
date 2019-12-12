Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615EBC43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 12:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24C9322B48
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 12:34:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MP0n7791"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbfLLMev (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 07:34:51 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34550 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729170AbfLLMev (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 07:34:51 -0500
Received: by mail-pj1-f65.google.com with SMTP id j11so995941pjs.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Dec 2019 04:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6ohX0KijNXau01/2aafaiWgl3pCQD9M4Y5W0MK84Gxc=;
        b=MP0n7791xeJ5YtGcCQwqwuTLIG6x5Y3HWUHDCmfZYBuPL8+H0bTK0UNEcJO6R48mlL
         oJk3wDipAbQoHqkmax2IV4t53OqPwyMkOC5bEZcVboM2yS+5ox3UXOh3lW5OijXDI5i8
         SjT7KYzDsOocncTCkuLtM2iP8DIP47iMMJeqndK3KplGdoFA4lOhcijyDkDRnDzdzNYL
         t9I3daUh/+ZqAFWjh9cAzpIQhi+XTH0TVt48wNLZWXsT3+vf3hrWjqt70MKMr+qmRn56
         2NH4xOZhbS1gpjX+YOcAFGJII8ZXNVA1aP8rpuEfhOu60zdQgygem9bvTYQ3WWZxB3dF
         Fmng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6ohX0KijNXau01/2aafaiWgl3pCQD9M4Y5W0MK84Gxc=;
        b=dXQMB8ANmwijn2fSo6Oi5IfV2BloKwa5Ez25nNIFHe+7WHI/dRkbQYC/PAttbrcMw6
         bHr+di00fBL30qyfp8DOpZjcZHOwo+lf9NkyZr/rUUcXChsBAh6RzRoSBr1uzi5uDBa6
         eG4wz6SPdYxIHV2RMc9zooIpjLfavzS4hBSMgOVvBYTTUDQ57EvJT/AdHODW3gkJjCd5
         xrmktU658uRkn6GIxKmdDMVmFLEMfaJQUHfkWSk2WvmhP0HfDok2mF5gICSwGYlmhBxD
         +vOD8C53+ryE70vMGylKx80mdT5fHAsCCRnPMP879iDNEdxAHxCklkM5IVJGi5W/MHni
         GgSw==
X-Gm-Message-State: APjAAAWgBsn7ByJLKwLkvMO4wM4SekRgwL4vDJlBt8+VZw26dl0oOnmp
        wwPTQF4bgSU8DHX0k8GBgFYXVK/qd7Y9gJjqTcIV8tgcNCw=
X-Google-Smtp-Source: APXvYqyoh854VyLPmYC7oe20tpQSenQrSKDy9FVQLA+TYcerAW0+7SC6DgkV05vcHayDR0O+PHx6uVkCUs0Q2USZb8Y=
X-Received: by 2002:a17:902:ba8c:: with SMTP id k12mr6723626pls.251.1576154090959;
 Thu, 12 Dec 2019 04:34:50 -0800 (PST)
MIME-Version: 1.0
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
 <20191203103522.482684-17-tz.stoyanov@gmail.com> <20191210133919.47830c13@gandalf.local.home>
In-Reply-To: <20191210133919.47830c13@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 12 Dec 2019 14:34:39 +0200
Message-ID: <CAPpZLN5A9Am1v+yrpXwyoGQkeqvSza5QxRon61oSbyMZ5K4ghg@mail.gmail.com>
Subject: Re: [PATCH v17 16/18] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

 Thanks, Steven!
I will prepare the next version addressing the comments.

On Tue, Dec 10, 2019 at 8:39 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
[ ... ]
> >
> > +static int tracecmd_msg_send_nofree(int fd, struct tracecmd_msg *msg)
>
> We probably shouldn't have a static function that starts with
> "tracecmd_".

I changed this one, but noticed few other static "tracecmd_" functions
in the legacy code, will rename them in a separate patch.

>
[ ... ]
> >  static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv,
> > -                       bool use_fifos, unsigned long long trace_id)
> > +                       bool use_fifos, unsigned long long trace_id,
> > +                       unsigned int tsync_protos)
> >  {
> >       size_t args_size = 0;
> >       char *p;
> > @@ -824,7 +848,11 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv,
> >               args_size += strlen(argv[i]) + 1;
> >
> >       msg->hdr.size = htonl(ntohl(msg->hdr.size) + args_size);
> > -     msg->trace_req.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
> > +     msg->trace_req.flags = 0;
> > +     if (use_fifos)
> > +             msg->trace_req.flags |= MSG_TRACE_USE_FIFOS;
>
> Why the change to flags here?

Fixed, It was a leftover from a previous version of this patch, where
flags were extended with time sync specific one.
However, I removed that time sync specific flag but forgot about this change.

>
[ ... ]
> > +
> > +/**
> > + * tracecmd_tsync_proto_select - Select time sync protocol, to be used for
> > + *           timestamp synchronization with a peer.
> > + *
> > + * @protos: Bitmask of time sync protocols, supported by the peer.
>
> Hmm, so we are limiting the number of protocols that we will ever
> support to 32? This makes me nervous (I always think of the famous
> quote of "Who will ever need more than 64K of RAM?")
>
> To be safe, we should probably make this an array:
>
>         int tracecmd_tsync_proto_select(unsigned int *protos, int words)
>
> The proto_id should be a bit, not a mask, that is:
>
>         int word;
>
>         for (word = 0; word < words; word++) {
>
>                 for (proto = tsync_proto_list; proto; proto = proto->next) {
>                         if (proto->proto_id < word * 32)
>                                 continue;
>
>                         id = proto->proto_id - word * 32;
>                         if (id >= 32)
>                                 continue;
>
>                         if ((1 << id) & protos[word]) {
>                                 if (selected)
>                                         [...]
>
> While we only have a single word, callers would just do:
>
>         unsigned int protos;
>
>         ret = tracecmd_tsync_proto_select(&protos, 1);
>
> At least this will never limit us to just 32 protocols, even though we
> will likely never need more. But we are safe if we ever do ;-)
>

I changed this and tracecmd_tsync_proto_getall() to work with
unlimited bitmasks,
but in order to support more than 32 protocols the trace request  packet must be
changed. In the current patch I added field
                                 be32 tsync_protos;
in struct tracecmd_msg_trace_req, which is bitmask for all time sync
protocols, supported
by the host. Defining this as a fixed size bitmap simplifies a lot the
protocol. We can add a
dynamic bitmask as part of the trace request  packet payload, but that
payload is already used
for the trace arguments. We can extend the payload to hold both
dynamic bitmask and trace arguments,
but I think it will complicate a lot the packet handling and the
benefit will be only the posibility to support
more than 32 time sync protocols.

> > + *
[ ... ]

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
