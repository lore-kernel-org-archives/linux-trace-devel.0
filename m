Return-Path: <SRS0=sUNk=X2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D362DECE587
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Oct 2019 15:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A428920842
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Oct 2019 15:38:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kl9g/J9H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfJAPiG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Oct 2019 11:38:06 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44230 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbfJAPiG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Oct 2019 11:38:06 -0400
Received: by mail-pg1-f196.google.com with SMTP id i14so9882279pgt.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 01 Oct 2019 08:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/rak+hYTLdXXQCRqrn2ayIi6CHHvbPeY0rXnc7VKBdc=;
        b=Kl9g/J9Hnv7tYXy2dS7vJgWRJ1qSqoOeWhE0rjjS4XpESWUr6UqoLqLGgX9rLCbhw7
         9BTNmKap0wVh9LG5Oe+fZdQl8HaK1+vT1Cl8itZIZqwom0TrQ6MUmj8JdvjpODcfkG5p
         FSdMjJXG41PbF1xhN/hB2i/CjzPtcAE1tGqwHDYwlhAUuoAS8aSqhBqxpfxdf4zXhtHW
         BXiKRLOgZqlIgiJ/I19aLdOqlYonCoT3MA2jUQlaFAwxoyoSfOUAuKWL3Hqw64j2h5Dg
         kMeBe3JZxmZe+FyclLDITs+Aijc+9OlWkuVVto5GcGya60sj9KfFtBod+7+XYLdhsbH1
         qHcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/rak+hYTLdXXQCRqrn2ayIi6CHHvbPeY0rXnc7VKBdc=;
        b=C1pPblsIgkQLw2IFPLzSTJvhYCDq16gXnLmUVnCb2EeAzni9EMVrjeKwS3ctKmWdpS
         duvOYG+nOEtr0pHUF+H2qy8/X50ka/CEJ4DiMQm81p6dd9b14cfdSf8Iih/4Wk7cUjjg
         /fGllwhYN8nRZKEMaDfwrNy+/PtWIcxNpWx8ivBMCPcEvzcZIy61n7J7nSKyyeG+EFow
         dOeo4+XhOYpavbxECRGbrJFUcE6PRXTYaWO8y2Ida3DcfCw+DBOEycMC7tY07lqAUB2v
         bYnTi+m3T3Kt36zwy/WUcNeBS3itpm48djq42seZK/1QlbeWnCk69TOm3yGTY0HFX26v
         /3xQ==
X-Gm-Message-State: APjAAAV4bgw4RaIUKli6uh76M9UR+DeeBT4E7mCXp8++l0XRowH5RDpJ
        lrOgGP45gc1L2CR4/bOx9jkTrBVKFIQ3/jdQO7D6BjTY
X-Google-Smtp-Source: APXvYqyPCmIDYRRta2biOSw1LNRhXjyu5cnREIjjtXaTZI6EGmQpbOnVQGxI/HkE0pKnEZNU9xtdN1klpZAaObDDMB4=
X-Received: by 2002:a62:6489:: with SMTP id y131mr28626600pfb.71.1569944285545;
 Tue, 01 Oct 2019 08:38:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191001145740.8866-1-tz.stoyanov@gmail.com> <20191001145740.8866-3-tz.stoyanov@gmail.com>
 <20191001113232.644fa2f0@gandalf.local.home>
In-Reply-To: <20191001113232.644fa2f0@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 1 Oct 2019 18:37:54 +0300
Message-ID: <CAPpZLN67T2bbcKiPczA93uW8rNSO5qg3MD+ETUDQLZmCN=iOJA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] trace-cmd: Reset CPU mask to its default value
 with "trace-cmd reset".
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Oct 1, 2019 at 6:32 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue,  1 Oct 2019 17:57:40 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > "trace-cmd reset" command should put all ftrace config to its default
> > state, but trace cpumask was not reseted. The patch sets cpumask to
> > its default value - all CPUs are enabled for tracing.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  tracecmd/trace-record.c | 35 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> >
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index 69de82a..6f3520c 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -4096,6 +4096,40 @@ static void reset_clock(void)
> >               write_instance_file(instance, "trace_clock", "local", "clock");
> >  }
> >
> > +static void reset_cpu_mask(void)
> > +{
> > +     struct buffer_instance *instance;
> > +     int cpus = count_cpus();
> > +     int fullwords;
> > +     char *buf;
> > +     int bits;
> > +     int len;
> > +
> > +     fullwords = cpus / 32;
> > +     bits = cpus % 32;
> > +     len = (fullwords + 1) * 9;
> > +
> > +     buf = malloc(len + 1);
> > +     if (!buf) {
> > +             warning("Unable to allocate %d bytes for cpu mask", len + 1);
> > +             return;
> > +     }
> > +     buf[0] = '\0';
> > +     if (bits) {
> > +             sprintf(buf, "%x", (1 << bits) - 1);
> > +     } else if (fullwords) {
> > +             strcat(buf, "ffffffff");
> > +             fullwords--;
> > +     }
> > +     while (fullwords-- > 0)
> > +             strcat(buf, ",ffffffff");
>
> I like my way because it's a little more condensed ;-)
>
> But this works too and it's far from a fast path. As it's probably
> more readable, I'll all this one.
>
> -- Steve
>
Actually the only change here is to handle the case when bits is 0,
not to put the leading ",".
The ftrace complains with "Invalid argument" in that case.

>
> > +
> > +     for_all_instances(instance)
> > +             write_instance_file(instance, "tracing_cpumask", buf, "cpumask");
> > +
> > +     free(buf);
> > +}
> > +
> >  static void reset_event_pid(void)
> >  {
> >       add_event_pid("");
> > @@ -4808,6 +4842,7 @@ void trace_reset(int argc, char **argv)
> >       reset_clock();
> >       reset_event_pid();
> >       reset_max_latency_instance();
> > +     reset_cpu_mask();
> >       tracecmd_remove_instances();
> >       clear_func_filters();
> >       /* restore tracing_on to 1 */
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
