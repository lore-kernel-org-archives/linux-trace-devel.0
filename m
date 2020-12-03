Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD01C64E8A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 13:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19B9520872
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 13:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbgLCNAH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 08:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730503AbgLCNAH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 08:00:07 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C32C061A52
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Dec 2020 04:59:27 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id q10so1246049pfn.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Dec 2020 04:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=enRdTaPc2vrUISdnPW5Ro2qKdSBCA6ZeKUPhdFGy2QA=;
        b=AH6uJwg63kAbadCJgRNbFsM26Ntv78X5C72v77nggApZFUWwakFEoBL5kFORl/xnWk
         xI8FhofgzCIANVtrBq7sUt88kLobBbSKJYR6/6DxYek+3AHRM2fOPzFjOD6A9XHYHeDt
         wRF6mZzcQ1Bz3OoTCch/D7hYXrOdkWLpIRkK2oev1F9MdX6I4xHTGXrLtlgJq6QkzJBh
         pBLj4yusWtnhJDkMq0wTrGeo+mwB+qNg6x4wuxpehUE0fS+WJjzfDwihyP5VL53HWmFs
         zBjclfNWrAzW/3C/xHrrgFBdFwB+PpdWJY1C0E3F635yahKyYgvbYx6YLGitocbcHhws
         /0yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=enRdTaPc2vrUISdnPW5Ro2qKdSBCA6ZeKUPhdFGy2QA=;
        b=ed5lolQxn9PDVsB1wn2BTUiTgB89znxodDxzc90RdZtJygae/W8O4hnNJcvyWU+M1V
         hxADOkwpGSkmjSg2c0kKaP4olBLIhs1V0fEx/hixiV+p2tNEdYH2GmMhT3tYGTjupLbC
         SYMTdsxpkgFReLlr1pPrRRXwaNoVyV2S7PmRaYSyF4dDCrI1rqst3qoKBYeV+yL1RFFe
         vUF01hQ+iQZguc4pReIKslblC8inTd/4LAm3prSatoEjiXFZx8z1poid1gKFM8HaoA/+
         SWa6dzI2y9+D0ezPPF/seOP1PXoWnUDM5bf0OQ8rqqDfMTqVuPAOW4wzeGIygzQ81b9V
         vHYQ==
X-Gm-Message-State: AOAM532grvgX7X+anoF45muAEmQfRN3A/6dOre0F2Zgynj/iHVJiI7ok
        GSU4SUgK6yVTviHRlYed0W7Jz00v6kpyFeX+iwFEtZXl/b/WWc0h
X-Google-Smtp-Source: ABdhPJxwho7vdMjEaZoq55rsxJo/4ToUDYJgkwjc7OeXBoodezdZAnNy2pGsIT5RdIJaDCPg0KIxkM3cV2Efq+Rl8/k=
X-Received: by 2002:a05:6a00:22d4:b029:19d:13f0:3a40 with SMTP id
 f20-20020a056a0022d4b029019d13f03a40mr2914754pfj.50.1607000366773; Thu, 03
 Dec 2020 04:59:26 -0800 (PST)
MIME-Version: 1.0
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
 <20201029111816.247241-11-tz.stoyanov@gmail.com> <20201202210934.3852e5c3@oasis.local.home>
In-Reply-To: <20201202210934.3852e5c3@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 3 Dec 2020 14:59:10 +0200
Message-ID: <CAPpZLN7XCHQS6ADWgh-RoPj90hRqDbhGz2qQOzGrk=JkA1u4gw@mail.gmail.com>
Subject: Re: [PATCH v25 10/16] trace-cmd: Add time sync protocol flags
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Dec 3, 2020 at 4:09 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 29 Oct 2020 13:18:10 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Added 32bit flags for the time synchronization protocols. The first added
> > flag is TRACECMD_TSYNC_FLAG_INTERPOLATE, used to specify how the
> > timestamps must be corrected.
> >  - If the flag is set, an interpolation is performed:
> >    Find the (min, max) interval from the offsets array and calculate
> > offset specific to the given timestamp using interpolation in that
> > interval.
> >  - If the flag is not set, do not interpolate:
> >    Find the (min, max) interval from the offsets array and use the
> >    min offset for all timespamps within the interval.
>
>     "timestamps"
>
> >
> > These flags are set by the timestamp synchronization protocols at the
> > protocol initialization time.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> > --- a/tracecmd/trace-tsync.c
> > +++ b/tracecmd/trace-tsync.c
> > @@ -132,7 +132,8 @@ out:
> >  static void write_guest_time_shift(struct buffer_instance *instance)
> >  {
> >       struct tracecmd_output *handle;
> > -     struct iovec vector[5];
> > +     struct iovec vector[6];
> > +     unsigned int flags;
> >       long long *scalings = NULL;
> >       long long *offsets = NULL;
> >       long long *ts = NULL;
> > @@ -145,6 +146,9 @@ static void write_guest_time_shift(struct buffer_instance *instance)
> >                                        &ts, &offsets, &scalings);
> >       if (ret < 0 || !count || !ts || !offsets || !scalings)
> >               return;
> > +     ret = tracecmd_tsync_get_proto_flags(&instance->tsync, &flags);
> > +     if (ret < 0)
> > +             return;
> >
> >       file = instance->output_file;
> >       fd = open(file, O_RDWR);
> > @@ -154,14 +158,16 @@ static void write_guest_time_shift(struct buffer_instance *instance)
> >       vector[0].iov_len = 8;
> >       vector[0].iov_base = &top_instance.trace_id;
> >       vector[1].iov_len = 4;
> > -     vector[1].iov_base = &count;
> > -     vector[2].iov_len = 8 * count;
> > -     vector[2].iov_base = ts;
> > +     vector[1].iov_base = &flags;
> > +     vector[2].iov_len = 4;
> > +     vector[2].iov_base = &count;
> >       vector[3].iov_len = 8 * count;
> > -     vector[3].iov_base = offsets;
> > +     vector[3].iov_base = ts;
> >       vector[4].iov_len = 8 * count;
> > -     vector[4].iov_base = scalings;
> > -     tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 5);
> > +     vector[4].iov_base = offsets;
> > +     vector[5].iov_len = 8 * count;
> > +     vector[5].iov_base = scalings;
> > +     tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 6);
> >       tracecmd_append_options(handle);
> >       tracecmd_output_close(handle);
> >  #ifdef TSYNC_DEBUG
>
> To make the above cleaner, I would use an enum to define the vector
> indexes:
>
> enum {
>         VECTOR_TRACE_ID,
>         VECTOR_FLAGS,
>         VECTOR_COUNT,
>         VECTOR_TIMES,
>         VECTOR_OFFSETS,
>         VECTOR_SCALINGS,
> }
>
> And then you can make it:
>
>         vector[VECTOR_TRACE_ID].iov_len = 8;
>         vector[VECTOR_TRACE_ID].iov_base = &top_instance.trace_id;
>         vector[VECTOR_FLAGS].iov_len = 4;
>         vector[VECTOR_FLAGS].iov_base = &flags;
>         vector[VECTOR_COUNT].iov_len = 4;
>         vector[VECTOR_COUNT].iov_base = &count;
>         vector[VECTOR_TIMES].iov_len = 8 * count;
>         vector[VECTOR_TIMES].iov_base = ts;
>         vector[VECTOR_OFFSETS].iov_len = 8 * count;
>         vector[VECTOR_OFFSETS].iov_base = offsets;
>         vector[VECTOR_SCALINGS].iov_len = 8 * count;
>         vector[VECTOR_SCALINGS].iov_base = scalings;
>
> It makes it obvious what each vector is used for.
>
> This is just an opinion. You don't need to implement it. I just hate
> hard coded numbers ;-)

The code is changed in "trace-cmd: Add timestamp synchronization per
vCPU" patch,
mo more hard coded numbers. The vector size is dynamic, depending on
the VCPU count.

>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
