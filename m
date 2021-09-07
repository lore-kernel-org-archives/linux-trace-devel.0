Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D983C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Sep 2021 18:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4456661108
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Sep 2021 18:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhIGSzJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Sep 2021 14:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhIGSzI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Sep 2021 14:55:08 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A2AC061575
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Sep 2021 11:54:02 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b6so15923385wrh.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Sep 2021 11:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p9qMnVhnBDv/BUOEbhz1bLC2PfxJ8I4cooAR5ir8KF8=;
        b=WvVvrtFt1mZd/dsGB8ND9G+il9QPJTHfJxPhS928Fu5faMmu83+/EQERytwGHLz1nA
         e0VHXQpr6xdPXNh/SXw5h3uNhbXiu1g4kbtUnbBNTqr3veUUPd/3khB/82JBuj47bZYp
         rj7vVA1gDk5AkRisCUm9M4LSni3v/hCQkh4diYa2jRSYQe+dfRYd6cpzjU9dZQlBXc15
         p5I2om5mjuqeg2F1CiOjgPboZmaB7ByyWULc2vVW2UxOYdSX3gh5bStrlrIDCGhvLVdK
         hfSTsYKIYOrg21xV1/9bCTpP8DwEgNGvNfz6etD+lzwc+G3Oh1qsAYizXHGYPUrGAu2W
         uZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p9qMnVhnBDv/BUOEbhz1bLC2PfxJ8I4cooAR5ir8KF8=;
        b=bRaeUkb4dCWJofkPbw5BIZLYhOGbx/Vsl8VKT5HxcacW4PjTRE+EXVeG9jnPza4LMl
         91auP/6uyva/HM9i5mN2+88gKQo4k4p28fp9etIkXf2wrAerJT22YMr1WG2qJrNqcMBz
         G2WMs4YEADvLQiLRdy2vaoXICeuKJZxycild9Ax7C+f6Z6cO4WgpK1O740gJRi0ZskAg
         EaEpTZN+JHNa8ylhlDuf+0JJlKBkrkLUpnUNEepfKAD6Ek58DIc6cLfJfJCwZMh2y3lP
         JLmz+HZseXtezVuCQW8RfB5clXO+bIHBArrILuPIGLzBRA531PamIpTgUPYbBEJk8ZC3
         DtQQ==
X-Gm-Message-State: AOAM532mLB+GRfhx8JF3H/KMGk7fvyZM+/IjLLDY+0TP3kPq5cfbTWAO
        U/IG2RTlY6sTIQMottbVrhxsmSBmjGZgvu37NqowVg==
X-Google-Smtp-Source: ABdhPJxvg4LsKS/e8Q2+Y3GorTbwNLj6QPoGG8W+71bqTdTTAeyvqb2zKp2aamj9sA1P1ICty3PRltaPX4OTCp+Xsqs=
X-Received: by 2002:adf:e5c2:: with SMTP id a2mr10116661wrn.251.1631040840653;
 Tue, 07 Sep 2021 11:54:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210902224840.2518539-1-irogers@google.com> <20210907105723.327be286@gandalf.local.home>
In-Reply-To: <20210907105723.327be286@gandalf.local.home>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 7 Sep 2021 11:53:48 -0700
Message-ID: <CAP-5=fWsxhZOkmpzFopqFQG+ZtbehZvT7NZ0bLzD7HhkZ4Qu1Q@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: Fix sometimes uninitialized warning.
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Sep 7, 2021 at 7:57 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu,  2 Sep 2021 15:48:40 -0700
> Ian Rogers <irogers@google.com> wrote:
>
> > The warning with clang looks like:
> >
> > src/tracefs-sqlhist.c:1107:2: error: variable 'cmp' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
> >         default:
> >         ^~~~~~~
> > third_party/libtracefs/src/tracefs-sqlhist.c:1112:35: note: uninitialized use occurs here
> >                             filter->lval->field.field, cmp, val);
> >                                                        ^~~
> > third_party/libtracefs/src/tracefs-sqlhist.c:1033:2: note: variable 'cmp' is declared here
> >         enum tracefs_compare cmp;
> >
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  src/tracefs-sqlhist.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
> > index 6224677..f4dc004 100644
> > --- a/src/tracefs-sqlhist.c
> > +++ b/src/tracefs-sqlhist.c
> > @@ -1105,7 +1105,7 @@ static int build_filter(struct tep_handle *tep, struct sqlhist_bison *sb,
> >       case FILTER_BIN_AND:    cmp = TRACEFS_COMPARE_AND; break;
> >       case FILTER_STR_CMP:    cmp = TRACEFS_COMPARE_RE; break;
> >       default:
> > -             break;
> > +             abort();
>
> Hmm, I wonder if we should do something different than call abort().
>
> Although this should never happen, I think it's rather rude of a library
> function to call abort() when it fails.
>
> I'd like to see this simply return an error. At most, a warning can be
> printed.
>
> Thanks!

Thanks Steve, I think the error handling in this function could use
some TLC. For example, the code:

ret = append_filter(synth, and_or, NULL, 0, NULL);
ret = append_filter(synth, TRACEFS_FILTER_OPEN_PAREN,
    NULL, 0, NULL);

doesn't check the value of ret. Assuming the return values are checked
then plumbing these up makes sense. Fwiw, there is evidence that going
in the direction of asserts/aborts is useful:
https://www.microsoft.com/en-us/research/publication/assessing-the-relationship-between-software-assertions-and-code-qualityan-empirical-investigation/

I can resend the patch with something like:

fprintf(stderr, "Error invalid filter type '%d'", filter->type);
return ERANGE;

Does that fit the expected convention?

Thanks!
Ian

> -- Steve
>
>
> >       }
> >
> >       ret = append_filter(synth, TRACEFS_FILTER_COMPARE,
>
