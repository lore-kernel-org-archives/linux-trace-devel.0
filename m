Return-Path: <SRS0=jVtL=2A=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544F1C43603
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Dec 2019 08:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2665220726
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Dec 2019 08:49:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Er9Y/+Ed"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfLJItz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Dec 2019 03:49:55 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42495 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfLJItz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Dec 2019 03:49:55 -0500
Received: by mail-pf1-f195.google.com with SMTP id 4so8700084pfz.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Dec 2019 00:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vDDV9Yxyb5b88aBmBdyax91wKFqd0oNCNAykCUMcZFo=;
        b=Er9Y/+EdG0XcasmOz3gCnb/9mFEZqexJ//8AjagknxpAdSbptTqEKmDACAR6AyIEfa
         9PwJ3XygWMLso5hGhu+ErCMK6yHofYwIUi9jwvUL19Oy7ATl2bkCp/VO2mj/hhJq5HNm
         +azz/s1GUpDST6Ez7lwseNipaYEWvcN1Ah3x01lQ1MF5boQ8qJGFkmWGXp3zO3yuwj2h
         M2xWR7ENioNbuxxzMFoKdSDFmvJz8jrmGzUMvfsKNDZPfi01t0TdivHoBDCDoY/6txnp
         D62ezFN3lqoGyY9ccJmgNC6aRwzMhCI8SlBTFsU+gAjK74KBfRsxqm0vRvxpeSeiwzn7
         xT3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vDDV9Yxyb5b88aBmBdyax91wKFqd0oNCNAykCUMcZFo=;
        b=KZrtN6Lx/8dBbhM/XU7jrg29nIYpEr0cqz37SAPFjniDcVsc1L0YtjPT+YRVbD/SdP
         q4uJzYSo+ujMg6X1sflUjUpRQsjORBGddw9zoNSaOGNe9Zr0UqwXS9l+6g91oLK0IM26
         nicV+rnY3tX00M65I9SmVtv4kIRdEeC12scOgrohZBL4u4R4H/GqnoMG4U87P5bW63VI
         QXOhrU6Mq6gmwaySwH0s48tEiT9fPjXUAhql4/kRoeJPtzV4kPmQ8olgZkC9LI7Ot6o+
         AlSa/BW9C4ze7EBX/Z6/jA/6IzSEL/uyOs9SJSvT4DLHSXyqz1K2V+PitxLe1fEUUfK/
         Pxsw==
X-Gm-Message-State: APjAAAVdeDIDpqd/mbHbB3fikCqv2gjKTYzcTLnRqN90p8oQ3Hc0+gKz
        qgw6D+YcxVtVhD92CXocEoLyvzRvzd1vROglyZ5Pea5ir0s=
X-Google-Smtp-Source: APXvYqyIP8YSlBw6pICp1Ko8M2iN5hSeXkMs4aYJv9Ttzwi4ePNd+fUnGt5qVWblSF/LO/iKRABnXKtgQRBjJswpJP4=
X-Received: by 2002:a63:f60:: with SMTP id 32mr23251334pgp.206.1575967794741;
 Tue, 10 Dec 2019 00:49:54 -0800 (PST)
MIME-Version: 1.0
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
 <20191203103522.482684-15-tz.stoyanov@gmail.com> <20191209143101.146cb619@gandalf.local.home>
In-Reply-To: <20191209143101.146cb619@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 10 Dec 2019 10:49:43 +0200
Message-ID: <CAPpZLN6xhsdd8Xyocm2rRGesCsW5Wsk2X3ZiEvJW948xXda-kQ@mail.gmail.com>
Subject: Re: [PATCH v17 14/18] trace-cmd: Add host trace clock as guest trace argument
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Dec 9, 2019 at 9:31 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
[ ... ]
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index 49730d6..e7fb1bd 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -5405,6 +5405,8 @@ static void parse_record_options(int argc,
> >       char *sav;
> >       int name_counter = 0;
> >       int neg_event = 0;
> > +     struct buffer_instance *instance;
> > +     bool guest_config = false;
>
> Should have a different name, like "clock_set", as "guest_config"
> doesn't let us know what this is about.

I use the same flag in patch 16 from the same series, with the same purpose -
to apply host config to the guest. That's why decided to call it "guest_config".

>
>
> >
> >       init_common_record_context(ctx, curr_cmd);
> >
> > @@ -5562,6 +5564,7 @@ static void parse_record_options(int argc,
> >                       break;
> >               case 'C':
> >                       ctx->instance->ftrace->clock = optarg;
> > +                     guest_config = true;
> >                       break;
> >               case 'v':
> >                       neg_event = 1;
> > @@ -5779,14 +5782,26 @@ static void parse_record_options(int argc,
> >
> >       /* If --date is specified, prepend it to all guest VM flags */
> >       if (ctx->date) {
> > -             struct buffer_instance *instance;
> > -
> >               for_all_instances(instance) {
> >                       if (is_guest(instance))
> >                               add_argv(instance, "--date", true);
> >               }
> >       }
> >
> > +     if (guest_config) {
> > +             /* If -C is specified, prepend clock to all guest VM flags */
> > +             for_all_instances(instance) {
> > +                     if (top_instance.ftrace->clock) {
> > +                             if (is_guest(instance)) {
>
> We should only append this, if the guest didn't have a clock set
> already. As the change log seems to say, if the user states a "-C
> clock" for the guest, that should take precedence over the host clock
> set. That is, a user may specifically state that they are using a
> different clock. If we have frequency and offset set, it should still
> work with different clocks.

The guest config string is not parsed in the host context, that's why the host
doesn't know if a guest has an explicit  "-C clock" argument.
I can parse the guest config here, but this will complicate the implementation.
Using the current approach still guarantees that the user specified
config has higher
priority than injected one - add_argv() API prepends to the beginning
of the string, so
user arguments are always after the injected one. When guest parses
the string, in case of
duplicated "-C clock" arguments, the last one wins.


>
> -- Steve
>
>
> > +                                     add_argv(instance,
> > +                                              (char *)top_instance.ftrace->clock,
> > +                                              true);
> > +                                     add_argv(instance, "-C", true);
> > +                             }
> > +                     }
> > +             }
> > +     }
> > +
> >       if (!ctx->filtered && ctx->instance->filter_mod)
> >               add_func(&ctx->instance->filter_funcs,
> >                        ctx->instance->filter_mod, "*");
>

Thanks !

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
