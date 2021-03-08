Return-Path: <SRS0=k9R7=IF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.4 required=3.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B08D7C433DB
	for <linux-trace-devel@archiver.kernel.org>; Sun,  7 Mar 2021 23:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78EE3650FD
	for <linux-trace-devel@archiver.kernel.org>; Sun,  7 Mar 2021 23:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhCGXw5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 7 Mar 2021 18:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbhCGXwZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 7 Mar 2021 18:52:25 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1805FC06174A
        for <linux-trace-devel@vger.kernel.org>; Sun,  7 Mar 2021 15:52:25 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id s23so1804948oot.12
        for <linux-trace-devel@vger.kernel.org>; Sun, 07 Mar 2021 15:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YoSIcqx4HsdqpkazzryRtYN2Vnh3yirPQ88LOwAHKO0=;
        b=cRrSLvDuEAJiJZNhvQlNY0QKJ9EKqWKETijdcCYyLX5bHBROrydqPw8lXzm5GlN174
         l0tDyRRLV3jeDYA1j8Q4de/9+JqfCq47tC0uqnXWM7td3IaOU4H6+0O5KfO1F6stBCWD
         5QPzSNTQ6pCWENcg9aMhqNFDjJyb25FV7I3vm3BEekyFnc2/82/G/qHBoKDvDEnrJiY2
         IsoLIJ0YKZ7FbT62rWrAEwof9sq/TIOhB0+xgGxrJdd9gB26xxSO86KiEj1GEkCgvwJy
         s4EoiZ4pcenXag1l7Sh8PMA9IZVcPNDWW7DyM/KgtEqLhpqZTlj21yKGG8RXXCLqU5EF
         c0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YoSIcqx4HsdqpkazzryRtYN2Vnh3yirPQ88LOwAHKO0=;
        b=HPCTf9UarmWpmdF/IJC4JGSs3Y7VaLcCRNVoMd9hoV+EQF9OxFctoN52JYwNB/4Xqs
         w+LezdfpGg7s9whsJZkzYvZSFb0OQEkJ7nDCC6Sr1m7hyofRY6xIbuVu9expvxIVbm+O
         zhIHTC7zhIhi7KdQwu3/QeuCo35Kr5yx3Efsqa619fBCOqfOBBAqm1YC0OfP1iHFM6BU
         khxj0627wu/byykb4w+d9Jgs0g97+GmDRaWeq/vV/qL6ofxEu4N6PInPoBGigLka9yAj
         Kt9xb+patEkt0lTCysq981SG2Q80wRhTgpy7w4C0QqeOBGQvbRjDqM6kJNek1aHJXg1P
         CWrA==
X-Gm-Message-State: AOAM533n1R7kuphsfWsoXLbE5h9nrLygIZl2KuHHy0t6c/I8ojhCB2zu
        Oa8CK+8tIyi7wEsyzhiKgi9nPa1TsVhlxOZBmEg=
X-Google-Smtp-Source: ABdhPJy5xuR+TTWSZ7D+twm6RUOZQkIjvETIlke0rMaBBq1s26Mm9izayZjb8KZaxzQPXxBDo5QXU74AtGfRaB/6faA=
X-Received: by 2002:a4a:b987:: with SMTP id e7mr16558342oop.92.1615161143609;
 Sun, 07 Mar 2021 15:52:23 -0800 (PST)
MIME-Version: 1.0
References: <1615029625-9749-1-git-send-email-sameeruddin.shaik8@gmail.com>
 <CAPpZLN6A+5pmCnOCJfg-eV1+1UR_MbwgvzhW-bd-ZZJ1F-dC=A@mail.gmail.com>
 <20210305093946.1c3f4ad7@gandalf.local.home> <20210305095439.10321303@gandalf.local.home>
 <CAK7tX=aASGnr+zyAc+Y_oeqPwOdkwkstJUvypUS=yqNmenCy_Q@mail.gmail.com> <20210306100525.5818bde6@oasis.local.home>
In-Reply-To: <20210306100525.5818bde6@oasis.local.home>
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Tue, 9 Mar 2021 05:23:00 +0530
Message-ID: <CAK7tX=ZKTRfcDs=TRTdo7dX5H7EeFeOVitX0hOPDMVYrAyP6hw@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

>We are happy to have you working with us.
>
>I asked because the API you happened to pick is probably the most
>complex one to implement compared to some of the other APIs listed in the
>bugzilla, which is why I asked if you planned on doing anything with it, as
>it is also one of the more crucial APIs to get right.

At first I thought, my work will be done, if I write to that file, but
complexity
increased gradually, but let me try, since i have started i will finish this.

>So yes, let's go with "const char **" as we want to show that the
>strings will not be modified, and have "const char ***" for errs.

okay then i will change the errors declaration alone.

Thanks
sameer.

On Sat, Mar 6, 2021 at 8:35 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Sat, 6 Mar 2021 07:25:18 +0530
> Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:
>
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
> > the read-only memory. Are we expecting the user to supply filters at
> > compile time like below?
> > const char * const *filters = {"kvm_pmu_reset", "kvm_pmu_init",
> > "dir_item_err", NULL};
>
> OK, my apologies, I see the issue that you are having, and you are
> correct.
>
> Because newer compiles will warn if you pass "char **" to a
> "const char * const *" parameter. Because it assumes that the two types
> are different, even when they shouldn't be. I'm not sure why the
> compiler wont let you pass in a char ** to a const char * const *, but
> it does indeed make them different.
>
> Even though there's ways to always pass strings via this logic, (you
> can create a "const char **" array and assign it to the dynamic one,
> and pass that in just fine). I looked at other prototypes, and see that
> the common method is.
>
>  const char **
>
> A couple do the "const char * const *" but they look to be special
> cases.
>
> So yes, let's go with "const char **" as we want to show that the
> strings will not be modified, and have "const char ***" for errs.
>
> Thanks!
>
> -- Steve
