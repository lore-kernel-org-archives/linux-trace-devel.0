Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD1E4C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FDA961937
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhCYGat (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhCYGaQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:30:16 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD9FC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:30:15 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 11so979950pfn.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oGycYWFVyk8PH757sqzxT3nEb3iLFetVOzgZJHfQi7c=;
        b=QAg6qcABGy3fzrZwyMbqzv2S0Jzu/a4Dzv9/pafByy7grCoqIFi/b9OLbryXBjXM0h
         77MXSDYkkgGYK6ixDcC1NmXUm18Y8IZhxM37VP5eEGTqeRwdgxsdJlx/oJebLDJeWEcN
         B4gojX3JrW79oJs4dWrPzl0Lznn2CxFaiD0efwCaHtMHiZtEUvqlqEjJBiBXi5JinvVN
         8q+xqXkJPjyvX5J6YZqzjZiP4z/4BBxV0fKShuunjexJp6sG0qZCdHsb+FdVw2ihOsGm
         7NglVJll1D3ATWNuMvhgpyFvHlO4/L7gYji+EhbWQTkUSXRa/doNrgSPjIu6K9tcn2LM
         WH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oGycYWFVyk8PH757sqzxT3nEb3iLFetVOzgZJHfQi7c=;
        b=JP3Fu/S5QKzODLKexRqHAwAxmfsCx12/sogVVBvsq+gB4VC8rGRtwW0QnMcTFtXd3Y
         VwlZ5STYTbitaxvCMad4U15l5Cjestp02+V2Me8FvcuRSmG91hVc+iqpEfDiH82i1jBH
         E4p683j6Yl7YvqJrdPTEZv13kwb7Yc67r9+ukfjROh6ct9DLBAJMAbWI5VMrn4uLd8Fi
         IRF2ElpzcRESRmmCNOe2BZrmq0SxcPdjECw4S1kMni/y/LgOSrRnZoijkZqO7GCpsM8c
         dghryXaT8FFSlpD4vn3qPLKPCdbV4uP4Eti/ub3GtZd8yWb+zL1G8T/yFpNZJaZQlJEx
         2XCw==
X-Gm-Message-State: AOAM530GPRNDNhAq5kvdK5h/PDlGOvd9tXvQFiNgvheHR1OPbFM0FGJV
        CljSdGcnJeITqwRbx93iWKMbr64GjYw1X3RnxvA98a7WmkdNAQ==
X-Google-Smtp-Source: ABdhPJy0IhwD5vI6E4B9hm86WUARV6F+5O49prXZrawSh0DMZ4ZqHbDgFOvp3Vv9z2t2CkwGAeQfQ1RzQJsL22DmioA=
X-Received: by 2002:a63:c143:: with SMTP id p3mr6331632pgi.44.1616653815290;
 Wed, 24 Mar 2021 23:30:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
 <20210324130418.436206-16-tz.stoyanov@gmail.com> <20210324145144.067efa87@gandalf.local.home>
In-Reply-To: <20210324145144.067efa87@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 25 Mar 2021 08:29:58 +0200
Message-ID: <CAPpZLN6YyrNi01WT-BM8Kne7gd0GLgFLXu51j_bSa9_4i3LAyg@mail.gmail.com>
Subject: Re: [PATCH v3 15/23] trace-cmd: Set order and priorities when
 applying timestamp corrections
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 24, 2021 at 8:51 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 24 Mar 2021 15:04:10 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > @@ -1296,15 +1287,23 @@ static unsigned long long timestamp_correct(unsigned long long ts,
> >  static unsigned long long timestamp_calc(unsigned long long ts,
> >                                        struct tracecmd_input *handle)
> >  {
> > -     ts = timestamp_correct(ts, handle);
> > +     /* Guest trace file, sync with host timestamps */
> > +     if (handle->host.sync_enable)
> > +             ts = timestamp_host_sync(ts, handle);
> >
> > -     if (handle->ts2secs)
> > +     if (handle->ts2secs) {
> > +             /* user specified clock frequency */
> >               ts *= handle->ts2secs;
> > -     else if (handle->tsc_calc.mult) {
> > +     } else if (handle->tsc_calc.mult) {
> > +             /* auto calculated TSC clock frequency */
> >               ts -= handle->tsc_calc.offset;
> >               ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
> >       }
> >
> > +     /* User specified time offset with --ts-offset or --date options */
> > +     if (handle->ts_offset)
> > +             ts += handle->ts_offset;
> > +
> >       return ts;
> >  }
>
>
> Now that I'm playing with this, I find I want to see what the result is
> without the tsc_calc.offset, but can't do it. I'm thinking that the
> --ts-offset should modify that instead:
>
>         bool ts_offset_set = false;
>         [..]
>
>         } else if (handel->tsc_calc.mult) {
>                 ts_offset_set = true;
>                 if (handle->ts_offset)
>                         ts += handle->ts_offset;

This will apply user specified offset instead of the autocalculated ?
I think it is better to have an option to disable the whole tsc2sec
adjustment when displaying the file, or just set a custom ts2sec:
     trace-cmd report --ts2secs 1000000000 ...  <- set ts2sec to 1,
this will be applied instead of tsc2nsec.
Or using a combination of "trace-cmd report --ts2secs ... --ts-offset
...", it replaces autocalculated tsc2sec with custom ones.
I think the existing "trace-cmd report" options are flexible enough.


>                 else
>                         ts -= handle->tsc_calc.offset;
>                 [..]
>         }
>
>         if (handle->ts_offset && !ts_offset_set)
>                 ts += handle->ts_offset;
>
> Or should we add another option to modify the ts_calc.offset?
>
> Thoughts?
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
