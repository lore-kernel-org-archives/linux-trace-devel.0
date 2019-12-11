Return-Path: <SRS0=a1Iv=2B=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D485C43603
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Dec 2019 08:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5640620637
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Dec 2019 08:21:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HTtO3nIP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfLKIV5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Dec 2019 03:21:57 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39052 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfLKIV5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Dec 2019 03:21:57 -0500
Received: by mail-pl1-f194.google.com with SMTP id o9so1125319plk.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Dec 2019 00:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QbGHKf0ENjG97n7qmRnN0bEB8rfRI/9VctH85QIrMfI=;
        b=HTtO3nIPKnozWWfq9ZTpNQwBHaIGx4jzp202CVo8KItgjv+wn1zuvHKyIMRjsgd3M9
         0a8J8SZ+uXXsNDZvcpgG0c0PgXsxhoHH+hlhoxyfpVb4sLgPoQBi2H7MNrPo2dcSOHkB
         Ej8K2Aa9DzCCDGyeNNQvTLT8q0K3nagJdxSwi+no4GUEPIpvsQWd+ps3FEcp1bvsNtzk
         /+83T/E02EXF2+3yYWmmSbemEdcWuB2wgYS8v7w4wKSHFWzc/iMJIqEpuguFyQcbTDhx
         NvbFC+Ny1RwIlQw9Tchgc/EUH2L4nZTqblUNf0WXOmdfcbDzQWXWi2uYrEuXTTq9vbWD
         zVEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QbGHKf0ENjG97n7qmRnN0bEB8rfRI/9VctH85QIrMfI=;
        b=SmWNre/1GV7ZaO7Va3LFzHMNaYD+dzEiQtunCeKICWvgd/3SrFa1sS13o9NfXliB0q
         LaAr52v8k4FpgU0qWq2dBmyD3iSKcNtfH16+OnSTsd/EUO64v06UubHCftuuMmouRXZY
         He+urOz8hOxdcI0uPp5D+0vDU57WavGa+1bqWFkHgXEnohiL+SmUvRDzWZ3Amcr2ERS+
         XNZeGY9j/HRWUhD230dsTJ5AB3J5EtqQh/Vwh883yV0HlnhjVvi8Kfq+ble1h+imUB8y
         PcECN3puoKu+/73moOQ3/48CtQ5G2jvGnuwIQxuMo1BEztCAeCfH89hOTnPkn1e5q0c1
         Llag==
X-Gm-Message-State: APjAAAXK3MOVOvJjwqYDFnytNux5pyFY97klHg8gVWx0jz2kqWc9cQ8q
        uCFHsSEKg84xtBqmCwjI8z354R1Um5hxbippW4ZswGszjR0=
X-Google-Smtp-Source: APXvYqwzT/Ze8YEdbrYlXtEbHkvxdBAUSEZePLeOt4B4ELW+3+jN1Xmj49/72p8a7+6sIr67IcSvmTH5uFIfESdyQvQ=
X-Received: by 2002:a17:90a:19dd:: with SMTP id 29mr2208799pjj.32.1576052516074;
 Wed, 11 Dec 2019 00:21:56 -0800 (PST)
MIME-Version: 1.0
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
 <20191203103522.482684-15-tz.stoyanov@gmail.com> <20191209143101.146cb619@gandalf.local.home>
 <CAPpZLN6xhsdd8Xyocm2rRGesCsW5Wsk2X3ZiEvJW948xXda-kQ@mail.gmail.com> <20191210104829.36071c41@gandalf.local.home>
In-Reply-To: <20191210104829.36071c41@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 11 Dec 2019 10:21:44 +0200
Message-ID: <CAPpZLN7bY8=PMwJnB02SRrdxiTRJjE-RwAwnADQBy5oFfhcffQ@mail.gmail.com>
Subject: Re: [PATCH v17 14/18] trace-cmd: Add host trace clock as guest trace argument
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Dec 10, 2019 at 5:48 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 10 Dec 2019 10:49:43 +0200
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > > > +     if (guest_config) {
> > > > +             /* If -C is specified, prepend clock to all guest VM flags */
> > > > +             for_all_instances(instance) {
> > > > +                     if (top_instance.ftrace->clock) {
> > > > +                             if (is_guest(instance)) {
> > >
> > > We should only append this, if the guest didn't have a clock set
> > > already. As the change log seems to say, if the user states a "-C
> > > clock" for the guest, that should take precedence over the host clock
> > > set. That is, a user may specifically state that they are using a
> > > different clock. If we have frequency and offset set, it should still
> > > work with different clocks.
> >
> > The guest config string is not parsed in the host context, that's why the host
> > doesn't know if a guest has an explicit  "-C clock" argument.
> > I can parse the guest config here, but this will complicate the implementation.
> > Using the current approach still guarantees that the user specified
> > config has higher
> > priority than injected one - add_argv() API prepends to the beginning
> > of the string, so
> > user arguments are always after the injected one. When guest parses
> > the string, in case of
> > duplicated "-C clock" arguments, the last one wins.
>
> I'm confused. I'm looking at this:
>
>
>         for (;;) {
>                 [..]
>                 switch (c) {
>                 [..]
>                 case 'A':
>                         [..]
>                         ctx->instance->flags |= BUFFER_FL_GUEST;
>                 [..]
>                 case 'C':
>                         ctx->instance->ftrace->clock = optarg;
>                         guest_config = true;
>                         break;
>                 [..]
>                 }
>                 [..]
>         }
>         [..]
>         if (guest_config) {
>                 /* If -C is specified, prepend clock to all guest VM flags */
>                 for_all_instances(instance) {
>                         if (top_instance.ftrace->clock) {
>
> Why can't we have here:
>
>  if (top_instance.ftrace->clock && !instance->ftrace->clock)
>
> If the guest instance was given a -C, I would think we don't want to add
> another -C to pass to that guest?
>

In case of a guest ("-A" option), the logic skips the switch(), so the
guest args are not parsed.
There is a check, right before the switch() :

        /*
         * If the current instance is to record a guest, then save
         * all the arguments for this instance.
         */
        if (c != 'B' && c != 'A' && is_guest(ctx->instance)) {
            add_arg(ctx->instance, c, opts, long_options, optarg);
            continue;
        }

I can put inside that if() a check for "-C" guest argument, but it
will look like a hack.

The confusion is that guest_config is set to true for any "-C" host argument,
including those for instances, but only the one from the top instance
is used to inject
guest clock arg.


> -- Steve
>
>                                 if (is_guest(instance)) {
>                                         add_argv(instance,
>                                                  (char *)top_instance.ftrace->clock,
>                                                  true);
>                                         add_argv(instance, "-C", true);
>                                 }
>                         }
>                 }
>         }



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
