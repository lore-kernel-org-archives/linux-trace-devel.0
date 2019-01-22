Return-Path: <SRS0=3hMC=P6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE37C282C3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jan 2019 14:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A5ED20870
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jan 2019 14:14:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t0rTQHpR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbfAVOOj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Jan 2019 09:14:39 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:39611 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbfAVOOi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Jan 2019 09:14:38 -0500
Received: by mail-it1-f196.google.com with SMTP id a6so20208644itl.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Jan 2019 06:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tWGxvUYSacGGC+y6+Kdc7BK/+awfz6c9Vb/bxAR8BqE=;
        b=t0rTQHpRfys5IBxEDHuqYGxkfk6kvTalsLDPYUJ2WwAvtMFqlsg36CpsMSimnRAWvk
         huus27yDj2qQyvxYxCEMcDiOhMC2m1O9mU+NYHg8ztCzv6SkuAvinvsS/kGm//NepqtN
         R72gjaELLG1JoIu5ezQBqPM+doNjVxuJhlbEw2xFCZY+Quxin6DuZLioY8sASXWsStCB
         Y3VrdSjVFMV+xUxoZNlVKhFBDgpwZ09BkTMYY6jZaOqcWD2MRSlqNTP1cHQr38g29iEE
         vXdvK50GxpGffR9Qi6+B9INHsGYH7PKvApQHaFPrGy0jvFCbe+0qE3DosIp9/vjqYttq
         UvrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tWGxvUYSacGGC+y6+Kdc7BK/+awfz6c9Vb/bxAR8BqE=;
        b=hXRLiQjFm/u11WCSGCQS2euFDj4XxrvAGJaQy6OehAUi1VjrbHGM5Yky2RYRBsQxmj
         3XYb4QhU/+5fVI5Lx5bIMqAyRGrYxXQIM6Lv0eEl+XdgvHyYRwu7ho5ZxkjOqT94hb3Z
         V4fvv5riaIbu38rE7eqZCSIiADysC5uHj0ziqstGM8pv0ZMfcC47bLEjidWgv5A0iXx1
         bUal31cohbmm1Dovm++D+0cRrEfmpr2mybV14SI6Zfq8lakezAwT5ydGodVPXhNWPVYJ
         Pu0a4LZtyesW5cpCpY388VpJsw7hFGCSQgtzxiDo9EZlGfGECKMWNhSPrYTNDs95+KZC
         19qg==
X-Gm-Message-State: AJcUukcT9qtjbJFGmqUy1S/5sIXDDanobRqtOIp3TjGuBRVJ+GAkGpKp
        fPl0cojmVxt7SPSeygd4Dcb6kyv6LY5QYdDFmQ==
X-Google-Smtp-Source: ALg8bN5xFRPIaM3DxWuJ52yl43Q4gofB0eYihDq+Z7ns2c6ywwqwCVv99WWHyuDvWOUIq8ViTUQDYaZpFXYZJJDV3PY=
X-Received: by 2002:a24:301:: with SMTP id e1mr1881946ite.109.1548166477696;
 Tue, 22 Jan 2019 06:14:37 -0800 (PST)
MIME-Version: 1.0
References: <20190116191838.32127-1-tstoyanov@vmware.com> <20190116191838.32127-6-tstoyanov@vmware.com>
 <20190121041959.1de4b1f0@vmware.local.home> <CACqStoezVCpB9n4GvCZ+LW11QPL4oQbLCfJi1HcOndHJ32Fuig@mail.gmail.com>
In-Reply-To: <CACqStoezVCpB9n4GvCZ+LW11QPL4oQbLCfJi1HcOndHJ32Fuig@mail.gmail.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Tue, 22 Jan 2019 16:14:25 +0200
Message-ID: <CAE0o1Nua3DKyNAcKSCawpn8ngV7G=DEPTP=e259kOeEB1A8c_Q@mail.gmail.com>
Subject: Re: [PATCH 5/7] trace-cmd: Added user configured clock to the record context
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jan 22, 2019 at 3:44 PM Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:
>
> On Mon, Jan 21, 2019 at 11:19 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Wed, 16 Jan 2019 21:18:36 +0200
> > Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:
> >
> > > Store the user configured clock (if any) in the record context,
> > > struct common_record_context. The clock is going to be used when
> > > synchronizing timestamps with remote tracing machine.
> > > ---
> > >  tracecmd/trace-record.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > > index f7349eb..900d0d4 100644
> > > --- a/tracecmd/trace-record.c
> > > +++ b/tracecmd/trace-record.c
> > > @@ -227,6 +227,7 @@ struct common_record_context {
> > >       int topt;
> > >       int do_child;
> > >       int run_command;
> > > +     char *clock;
> > >  };
> > >
> > >  static void add_reset_file(const char *file, const char *val, int prio)
> > > @@ -5183,6 +5184,7 @@ static void parse_record_options(int argc,
> > >                       break;
> > >               case 'C':
> > >                       ctx->instance->clock = optarg;
> > > +                     ctx->clock = optarg;
> >
> > Hmm, this can cause an issue. The first thing I have to ask is, why
> > can't we use ctx->instance->clock. I'm sure the answer is that we are
> > adding more than one clock. But this begs the question, which clock
> > should be use, if there are more than one clock to add?
> >
> > I think this patch is not needed. In the last patch, test if
> > ctx->instance->clock exists, and if not, we search the other instances
> > for a clock to use. Or something else that doesn't make which clock to
> > use ambiguous.
>
> Ok, I'll remove it and will search for the first ctx->instance->clock instead.
> Current algorithm assumes that only one clock is used, and it is the
> same in both
> host and guest contexts. We should think how to handle the case with
> multiple instances,
> each one with different clock. I do not know, how instances are
> written in the trace.dat file,
> is there a different time offset option in the file, per instance ?

Each instance goes into a separate file (by default "trace-$(name).dat").

For guest instances, this command
$ trace-cmd record -A guest0 -e irq -e sched -A guest1 -e irq -e sched

creates two trace files:
-rw-r--r-- 1 4.8M Jan 22 16:06 trace-guest0.dat
-rw-r--r-- 1 7.4M Jan 22 16:06 trace-guest1.dat

Cheers,

- Slavi
