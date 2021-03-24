Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADFFC433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 04:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C0ED619E8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 04:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhCXE7O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 00:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbhCXE6y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 00:58:54 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E12C061763
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Mar 2021 21:58:54 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so493477pjq.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Mar 2021 21:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RTP6j6UO6AkQBdeA2sg7aJsQyehqG5ermplU/HNtRDo=;
        b=Q2gJJi5o47TNHSMfFjRLpZwhWtoQhH4vHQtynZCUTIDEr63uXcNds75+ZblNzdk1KI
         +3RPLpY0Ctc82F9kjsktoqKxwIoq65HmRbXnHdVAgNdTx/jH1WPJRXvjkaVAJa7/3Q+z
         MHXNK5DzfQQFkTwox458I32PqdyC8DpvbNCCkblWvLYXKyiY+jaqzddYLJrkDh3AyQFu
         7KI0fuUY6YHllWOV2UG10Lo3Z4KkECd9zQexlHt2yu+z+gEojVcCqXOwErJ0oftJHrWa
         hgziHuxKtUpW/jdD4G+hXfpbD+9hXCiMdqzZOxBilb3kQQl1ZIV5ta0qJwo8K33wv/kX
         3waw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RTP6j6UO6AkQBdeA2sg7aJsQyehqG5ermplU/HNtRDo=;
        b=hiKmXV1ZtG7vEOfl27zAwKOPmqf98tzM4ETEJm9SsvnKnglqc9uWVUd7s5Vq3iLxXj
         mAu7tlQz/0E8ekVb9jQh+nRoKg0kInpo/W/uEicRND6Yiit9pQ7r6CetCmK3OQX4eIlG
         m/wflvzlXd3AUhdy//ghW2whUt0PF28mZnlYTJ7OBf8C2soBisjTde6P0hdPlV45kmfx
         suEOh3VUwbMi2jl708oMxsr/DoYDU/ckKfcnoomfZmvCZRfSIjjX7mSK2BTyzV1WC6Na
         pnNWuxYL6m6JfNeRrxZTvGtELByI72biaXh0ugPvIr+NmXI+dY9ypitVplXdSMJIMwNw
         8cxg==
X-Gm-Message-State: AOAM5333NE2SToOgW9SaSnPpczf3w6TnlevQsQbclfafaPAh4jrw1Ex8
        Kn1fCu9sVykMW0LrxQo7dqDdxZRsfyWwNrJ0oqJwKKLzu8eRDA==
X-Google-Smtp-Source: ABdhPJzsUS/LP5+dWP1R1yMcg6UDyRtxqfFLcKmarl5GgL9JUMEcet59bNchy0jNoStnoDICPGEk4nADgMV+5gKSWJU=
X-Received: by 2002:a17:90a:8505:: with SMTP id l5mr1556061pjn.100.1616561934185;
 Tue, 23 Mar 2021 21:58:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
 <20210322095945.259300-9-tz.stoyanov@gmail.com> <20210323213359.4c909222@oasis.local.home>
In-Reply-To: <20210323213359.4c909222@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 24 Mar 2021 06:58:37 +0200
Message-ID: <CAPpZLN6+2=A2xwf9mt1qxDN8npMDsN9ugZnOyGa5zsiE3WKODQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/18] trace-cmd: Save tsc2nsec clock in trace.dat file
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 24, 2021 at 3:34 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 22 Mar 2021 11:59:35 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > @@ -4168,7 +4167,8 @@ static void write_guest_file(struct buffer_instance *instance)
> >       handle = tracecmd_get_output_handle_fd(fd);
> >       if (!handle)
> >               die("error writing to %s", file);
> > -
> > +     if (instance->flags & BUFFER_FL_TSC2NSEC)
> > +             tracecmd_set_out_clock(handle, TSCNSEC_CLOCK);
> >       temp_files = malloc(sizeof(*temp_files) * cpu_count);
> >       if (!temp_files)
> >               die("failed to allocate temp_files for %d cpus",
> > @@ -4290,9 +4290,10 @@ static void record_data(struct common_record_context *ctx)
> >                               add_guest_info(handle, instance);
> >               }
> >
> > -             if (ctx->tsc2nsec.mult)
> > +             if (ctx->tsc2nsec.mult) {
> >                       add_tsc2nsec(handle, &ctx->tsc2nsec);
> > -
> > +                     tracecmd_set_out_clock(handle, TSCNSEC_CLOCK);
> > +             }
> >               if (tracecmd_write_cmdlines(handle))
> >                       die("Writing cmdlines");
> >
>
> OK, I see why you wanted to clean up the writing of all clocks. But I
> still find that information valuable as for the reasons I stated in the
> other email. I wonder if we can still read all the clocks, parse them
> out (remove the '[' and ']') and have tracecmd_set_out_clock() still
> write them. Hmm? Or at least save them in a new option (like I save
> uname).

The TRACECMD_OPTION_TRACECLOCK option can be extended to hold the
content of the "trace_clock" file. It is an empty option now, adding
more bytes will not break the old logic.

>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
