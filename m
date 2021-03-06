Return-Path: <SRS0=rW7V=IE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9250C433DB
	for <linux-trace-devel@archiver.kernel.org>; Sat,  6 Mar 2021 01:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9630364E44
	for <linux-trace-devel@archiver.kernel.org>; Sat,  6 Mar 2021 01:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCFBzp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 20:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhCFBzb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 20:55:31 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDADC06175F
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Mar 2021 17:55:31 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id z126so4654018oiz.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Mar 2021 17:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3dpOizzy32T+7u2PFj36PxbWaqQ22n0PMcogP8789wU=;
        b=peMIZ+2IgvoPm/V8erxyW0bUW6IddH/mZzcSEbWbKkmVlV3ZVF9tq3YsqdiL3YXSTu
         vspsfAtU1BxwBcJsw/VRcwe9dda18+17V/M4cSlhIoIWkYrIMENXPJrdV9DAI9QZZNcB
         DKCt9TL1uYiQ6zv1d+1wk+RiMfNG2HDbMQP1kj25rSDeVJN+dx+Bv9chCnCuZyP6GUya
         sAb+6LndyE010MJZHVESuyni//urxvDZ9nwAFlRVFtTEwt/xI/kWHG9+0fU/fMCTDEL5
         5NeCr61FUg6jR4E0f8L+s/q0/YY5uODC+evpe2Dr6KgluaAfAi2X/j1FVk83e+hrS8pb
         SIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3dpOizzy32T+7u2PFj36PxbWaqQ22n0PMcogP8789wU=;
        b=m39NuPs8TdNClE6fP+hHGbU9NPZUdDSN/KiW+akRYxP/lcREELRNZl5Afy1xU9H37t
         p0fYIvG02S1PnWLjgLKnJtp0vtsRZOwKkLeIUPekWECApqAfuul4RmKbDEXfUAz7dVrw
         u/mtFD9ErdQv8oka1JiAgJXwdE2OcHrbBvBrrqLIEFYcv3dJFLBQfgeTQdbJkCwVESu7
         ZzylsxH3zdSsoL5FyuQ/Bw4N93FhCJnTuRqXG7qiYcQHfwbDFE6Q57M8eezHxsN+jeJG
         WbsXH2ap/39063sx/blQRiGeK6X7n6dFUPcdQVJ9TUQabLFvC/901fo2n6m79UuFf2UP
         LY0w==
X-Gm-Message-State: AOAM531KdcC+kK6+O9QwLYI2mDhbj11YwEmhau0TI1ZIW9BiMxN1Ph8Z
        ou5VKSTsVYDREaMhluKER6ohBrP4ueMoX139lYvT7Ew3E1xPKg==
X-Google-Smtp-Source: ABdhPJwcax7nRfK2mE+U6nez2TzKne+ZL7XN+thwztYI5qsbNafaKPCmOgqPq0tTDJGUsF/NXAa1kGYb7v4uTfO9oRI=
X-Received: by 2002:aca:4a96:: with SMTP id x144mr8930415oia.2.1614995730912;
 Fri, 05 Mar 2021 17:55:30 -0800 (PST)
MIME-Version: 1.0
References: <1615029625-9749-1-git-send-email-sameeruddin.shaik8@gmail.com>
 <CAPpZLN6A+5pmCnOCJfg-eV1+1UR_MbwgvzhW-bd-ZZJ1F-dC=A@mail.gmail.com>
 <20210305093946.1c3f4ad7@gandalf.local.home> <20210305095439.10321303@gandalf.local.home>
In-Reply-To: <20210305095439.10321303@gandalf.local.home>
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Sat, 6 Mar 2021 07:25:18 +0530
Message-ID: <CAK7tX=aASGnr+zyAc+Y_oeqPwOdkwkstJUvypUS=yqNmenCy_Q@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

hi steve,

i have one doubt.
>Note, @filters should be of type: const char * const * filters,  as not
>only is filters pointing to constant strings, the array itself will not be
>modified.

what If the user wants to capture the filters at run time like below ?
let's say

  filters = malloc(sizeof(char *));
        if (!filters)
                return 1;
        printf("please enter the input filters count\n");
        scanf("%d", &fil_count);
        while(i < fil_count) {
                scanf("%s", buf);
                slen = strlen(buf);
                if (!slen)
                        return 1;
                filters[i] = calloc(1, slen);
                strncpy(filters[i++], buf, slen);
        }
at that time, this declaration will be problematic right?, because we
are trying to modify
the read-only memory. Are we expecting the user to supply filters at
compile time like below?
const char * const *filters = {"kvm_pmu_reset", "kvm_pmu_init",
"dir_item_err", NULL};

Tzvetomir & steve,
>Since a triple pointer is difficult to manage in the code, you could have:
>
>       const char **e = NULL;
>
>
>               if (errs) {
>                        e = realloc(sizeof(*e), j + 1);
>                        e[j++] = filters[i];
>               }
>
>Then at the end:
>
>       if (errs)
>                *errs = e;
i have a concern here
when a double pointer is doing our work here without any overhead, why
we want to make it a triple pointer?

Thanks,
sameer.

On Fri, Mar 5, 2021 at 8:24 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 5 Mar 2021 09:39:46 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > > > + * The @filters is an array of strings, where each string will be used to set
> > > > + * a function or functions to be traced.
> > > > + *
> > > > + * If @reset is true, then all functions in the filter are cleared before
> > > > + * adding functions from @filter. Otherwise, the functions set by @filter
> > > > + * will be appended to the filter file
> > > > + *
> > > > + * The @errs is an array of strings, where each string is a failed function
> > > > + * name
> > > > + *
> > > > + * returns -x (where x is number of failed filter srtings or it can be
> > > > + * 1 for general errors), or 0 if there are no errors.
> > > > + */
>
>
> We should for the return statement:
>
>  * returns -x on filter errorrs (where x is number of failed filter strings)
>  *         and @errs if non-NULL will be an allocated string array pointing
>  *         to the strings in @filter that failed, and must be freed with
>  *         free().
>  *
>  * returns 1 on general errors not related to setting the filter.
>  *         @errs is not set, even if supplied.
>  *
>  * returns 0 on success, and @errs is not set.
>
> -- Steve
