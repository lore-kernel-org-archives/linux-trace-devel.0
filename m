Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250F7C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 04:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3605610CD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 04:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhDPEmV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 00:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhDPEmV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 00:42:21 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0125CC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 21:41:56 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n10so2166644plc.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 21:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4x3hRnjOv6JqOFNAr1z+fOxzxL0VrCPR+CI69kmIvT4=;
        b=eHxFJjBGznS1dqf/Kjo9v8glNF5tK2L1bxr4O4LfvS9tX3iRFheEScjkZd2rILdiP2
         mAVM7KlO/XAEtpZ2v5a25tpXmZvydr05KkXqGJpqPngCDE/cdmH6CULb5Jh3uMEypFfh
         VB0JUjjJH49iIqo7ju/Tm7jtl2wWb3HPIPRNrL6skPNMrB15kkbRD0ALN9hqs01x4+DM
         3Pc0h7eg9txa/cNHy8wnrAp4ol22CqLel7EIK9yJmVeT+giqavzTCoOIC65FSlv99XWq
         z3GytIh9ZisN/bdrUQqhOSO5y3rkwOxUMQx5Mj99xvgULqTIhfRdZSpiyyf4mXGQguFf
         xVgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4x3hRnjOv6JqOFNAr1z+fOxzxL0VrCPR+CI69kmIvT4=;
        b=V7qZ2CS0522T5hgpu0TiNaxicBxY8iXZqa2RI24trXU9YZXB1CgGGYzg25zPqOiGUQ
         3i0WdplvJFA4s2yyRRoQPKdVcF2f+TR1a7pSeAoCZxOb405oyRLc2+jlcgrfr7HGoh/n
         Jy6QTuiqtPe9M4jOkNLRneXYKagxvEQs5pLyqSxN63Kv0fa9IgEtaXMborJerZcAY3io
         Z9Nol4ATig15c6sxKFgkB9HKdy/+rWaKvIOcN3F6N+0DYtVy0jA6FDejMp6yTm+QGqFy
         83pM7QSv2BazMp3gTqnuHxYCfl706QVjUfwKzrFEdj1LeJN0rkaT5LQBRVX/7dwm2Khs
         bh+w==
X-Gm-Message-State: AOAM530r1bcQ0qsZjpfi7/+ZllZ2glLxhb9O22nhTIr9z/QOdKYOJw9r
        R2ucLFpsVppCBu2JEUxmIphPxShvb2YtHq/nyId7FXyd4sWjMA==
X-Google-Smtp-Source: ABdhPJySbF0s2scZAMB9huUittQsr1iWbsuLSofLzSle7l34rWAHhqL0tlfEzL7Mp+mN/AQAvWXTGitPqdRUaHukyis=
X-Received: by 2002:a17:90a:fa84:: with SMTP id cu4mr7745156pjb.2.1618548116362;
 Thu, 15 Apr 2021 21:41:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210415081527.3483835-1-tz.stoyanov@gmail.com>
 <20210415081527.3483835-5-tz.stoyanov@gmail.com> <20210415171845.3e6ee0d8@gandalf.local.home>
In-Reply-To: <20210415171845.3e6ee0d8@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 16 Apr 2021 07:41:40 +0300
Message-ID: <CAPpZLN4m5bPj=Di-UA98dKKpLrL3d4eFiRMQpSSsJ2nnjVJcTg@mail.gmail.com>
Subject: Re: [PATCH 3/3] trace-cmd: Get the timestamp of the first recorded
 event as TSC offset
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 16, 2021 at 12:18 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
[...]
> >  static void record_data(struct common_record_context *ctx)
> > @@ -4231,9 +4306,18 @@ static void record_data(struct common_record_context *ctx)
> >       char **temp_files;
> >       int i;
> >
> > +     if (ctx->tsc2nsec.mult) {
> > +             for_all_instances(instance) {
> > +                     get_first_ts_instance(instance);
>
> Should check the return code, and at least warn if it fails. As it is done
> after the recording, we don't want to die. But at least let the user know
> something went wrong.
>
> -- Steve
>
> > +                     if (instance->first_ts &&

I'll add return code and will check it instead of that
"instance->first_ts". Failing to get the first ts could be a normal
case, if there are no events recorded in that instance.

> > +                         (!ctx->tsc2nsec.offset || ctx->tsc2nsec.offset > instance->first_ts))
> > +                             ctx->tsc2nsec.offset = instance->first_ts;
> > +             }
> > +     }
> > +
> >       for_all_instances(instance) {
> >               if (is_guest(instance))
> > -                     write_guest_file(instance);
> > +                     write_guest_file(ctx, instance);
> >               else if (host && instance->msg_handle)
> >                       finish_network(instance->msg_handle);
> >               else
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
