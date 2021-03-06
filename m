Return-Path: <SRS0=rW7V=IE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDC6C433E0
	for <linux-trace-devel@archiver.kernel.org>; Sat,  6 Mar 2021 04:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA1FA64FBD
	for <linux-trace-devel@archiver.kernel.org>; Sat,  6 Mar 2021 04:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhCFE3x (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 23:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhCFE3q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 23:29:46 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C117FC06175F
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Mar 2021 20:29:46 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id t16so3893509ott.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Mar 2021 20:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pQ2O4rHM6dimLdxhxWOq+Qi4s0mJHj5OZ14KCx1db70=;
        b=OJzlLOwjkY0E8avgIMaO8xZ7CCwMtE4wfzHzC7Dnk1F9xx3oKcd7h/LKZx/YLuR/bw
         T2n63ORZUbW+UnhzuwsizqrU6LV1LewGteP+wu7Dw1bfZEnFr4bizF69qk2DkxrpJRqZ
         /pMkTp/nis08AnsqaxCT5NCia4OvqUyXj2HY3nDJbLJrvJtBbhByj/Un36AZv4bgpOJV
         kP6UNV16fGMs2vv1N5DagyJ4iOFJftrSUBbVID45oZMLcIcn9MBLep/reuta6MA7JwuV
         BXHilPDoTptvcwIDzQp2794j8coY2cuAr7T/b8KTXbZ7GGrtbxx6A3j0Szqb42mR8XbN
         NSJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pQ2O4rHM6dimLdxhxWOq+Qi4s0mJHj5OZ14KCx1db70=;
        b=toPuoNBhUwxYVbiQVhaRTvEwHjfhnpwdnFviQHgLKdBosbUInwfCtt5kBbSnlkd7CI
         rwwkeEAIYDXboCnOjvq3eptku7GEDtsCxLH+y1hSQROISv/5sbIjRfghib8rOJfBoutH
         xaK7RctcJLpb5zedRbPtmQ61IYlXTesQ+cX2dbOpgcxtc/Ejh8D5BO2MKPefNat7Lwjt
         acQ8SCOzPpHeAb4JKqGYv7WnoWSD6HCLFw8YlEqRybVgmPzBtBu6nIB84m2w0KHWpaoB
         oqFXxCefeFyh88IKoIlx8zKyD6CtkRetjXuRZUhSyRgmh2AGXszM0uVpp0IB/xRnYbR5
         yzyw==
X-Gm-Message-State: AOAM532USWN4sUhjH8zOEMVX5/vN/9LQ/7QX49fgZRG9OUGQ9ev7WGo1
        sam27g1AXlimG86tBzZuzvtgDpKkeeGZTK/2esuJSDQeavc=
X-Google-Smtp-Source: ABdhPJyOjo6ypJAK/fGtx9yq/QpRe8v1PNGIlRqgnFsT2aqErQ4TRLA2fmhnXBkBJOx0CTwHgEd56mWQhy9D/XKLRdk=
X-Received: by 2002:a9d:3bc3:: with SMTP id k61mr10666461otc.156.1615004986035;
 Fri, 05 Mar 2021 20:29:46 -0800 (PST)
MIME-Version: 1.0
References: <1615029625-9749-1-git-send-email-sameeruddin.shaik8@gmail.com>
 <CAPpZLN6A+5pmCnOCJfg-eV1+1UR_MbwgvzhW-bd-ZZJ1F-dC=A@mail.gmail.com>
 <20210305093946.1c3f4ad7@gandalf.local.home> <20210305095439.10321303@gandalf.local.home>
 <CAK7tX=aASGnr+zyAc+Y_oeqPwOdkwkstJUvypUS=yqNmenCy_Q@mail.gmail.com> <20210305223912.58f4e86c@rorschach.local.home>
In-Reply-To: <20210305223912.58f4e86c@rorschach.local.home>
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Sat, 6 Mar 2021 09:59:34 +0530
Message-ID: <CAK7tX=b=xQCB4ugQb5YSQisf+_bmmLrUbVgcCXG+vZD7upmx7A@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Okay steve

Actually I chose this API randomly from bugzilla, i don't have any
plans as of now.
I am developing it, as per your requirement.

Out of curiosity, I started implementing this API. Actually I am a
novice in development,
i know somewhat like how to write code logically and make it work, but
i haven't followed any standard
till now. I am learning some new things from your reviews.
Thanks,
sameer.

On Sat, 6 Mar, 2021, 9:08 am Steven Rostedt, <rostedt@goodmis.org> wrote:
>
> On Sat, 6 Mar 2021 07:25:18 +0530
> Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:
>
> > hi steve,
> >
> > i have one doubt.
> > >Note, @filters should be of type: const char * const * filters,  as not
> > >only is filters pointing to constant strings, the array itself will not be
> > >modified.
> >
> > what If the user wants to capture the filters at run time like below ?
> > let's say
> >
> >   filters = malloc(sizeof(char *));
> >         if (!filters)
> >                 return 1;
> >         printf("please enter the input filters count\n");
> >         scanf("%d", &fil_count);
> >         while(i < fil_count) {
> >                 scanf("%s", buf);
> >                 slen = strlen(buf);
> >                 if (!slen)
> >                         return 1;
> >                 filters[i] = calloc(1, slen);
> >                 strncpy(filters[i++], buf, slen);
> >         }
> > at that time, this declaration will be problematic right?, because we
> > are trying to modify
>
> No it wont. You can assign const pointers to dynamic pointers, but not
> the other way around. It's a way to show that the function you are
> calling wont do anything with the array you pass to it.
>
> > the read-only memory. Are we expecting the user to supply filters at
> > compile time like below?
> > const char * const *filters = {"kvm_pmu_reset", "kvm_pmu_init",
> > "dir_item_err", NULL};
>
> No, as explained above.
>
> >
> > Tzvetomir & steve,
> > >Since a triple pointer is difficult to manage in the code, you could have:
> > >
> > >       const char **e = NULL;
> > >
> > >
> > >               if (errs) {
> > >                        e = realloc(sizeof(*e), j + 1);
> > >                        e[j++] = filters[i];
> > >               }
> > >
> > >Then at the end:
> > >
> > >       if (errs)
> > >                *errs = e;
> > i have a concern here
> > when a double pointer is doing our work here without any overhead, why
> > we want to make it a triple pointer?
>
> What overhead? A string is a pointer, an array of strings is a double
> pointer, and passing in the address to an array of strings so you can
> modify that array is a triple pointer, and that's exactly what you need
> for errs.
>
> This is basic C coding, nothing special here.
>
> I'm curious to why you picked this particular API to implement. Is
> there something you are planning on using this for?
>
> -- Steve
