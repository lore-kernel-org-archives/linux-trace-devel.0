Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F6A0C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 10:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D90B61A04
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 10:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhCXKNt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 06:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbhCXKNl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 06:13:41 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43875C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 03:13:40 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id s11-20020a056830124bb029021bb3524ebeso5698936otp.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 03:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cc8guedDLfAW4S+7sOwXVOhJyxtp7lm6BemJs2xqSqg=;
        b=hTcfge+nyj+ZNt09XeSGPxhrHmI7l+x3QgXwKLVRzCdfoUqYTjqwqb1sM8q+0bu7Hq
         4GFpxR2l9uur+f3hmuA5yMeG+wcqrdo6D2TzPaXD+amKoaoKk61uBb+jg6ZZttMBWUnC
         xk5xr18VrCPf5vskWquUGJGGygaekkqiYM/Xt4jXTIX7I6/p/jKZmXj4TjoS2ZR6g6Kc
         v1dhvrJ2PJ3/XEKwX+3jkkR6ebtbVmGFDqDonT55GwDbKrl1zNdKlBaruETjvtMP+P0I
         C7En9oBnVgmKP7ttZgGuqgAM1PI5xGBCmJVT5+UF4f+LcBEKrmEaX2Pt0fAf7+QejpTU
         zNFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cc8guedDLfAW4S+7sOwXVOhJyxtp7lm6BemJs2xqSqg=;
        b=KmOfwqDm8h4d+pHxAuYjbO+vAnuNo0CjN/NunOlf3iSLLp9yVMa+ca0+70v4kLjYEq
         lNT2zfQUci22ClHsXxk7ZB07QsC2ao+5xvAhX+EfrmoHWyGYbV3NJJTXskKHBOuZj4z0
         D/POiQtyvdHDwI4QyUg4GpsHzIamwN0E2vUlX4hXXrYL8v2jDovcKnHU4BSNPweO16lK
         4WAnQmuyxfAi20EBiERt5X618cgpuE87ky0QQj59DTlK2E6skF70asLjMQxnF2cy5s+D
         CpmwenRLhDr+4F4v1oLyMbK9//33UgZ+QRRcq1tCipKmbXp6mkOXOFnKtiEAgjYGtdae
         6I3Q==
X-Gm-Message-State: AOAM533uD32LKUxlJMj9sr0KZVxkPkamksY2SVjo17Pl5YQwTgXeRNJR
        oMuDhwqwiZagTw0lnJ3FFHitxMgXzEGhFuBQAH5xfQsQRVh+0A==
X-Google-Smtp-Source: ABdhPJyGQJ5k111iXABVYOVAQ+KE+3ip1sB7utpMDN3hZ/Ijj1Iv50GySil5iP4lL8hCo4Eaja0Gfr55WLP2cQOyEU4=
X-Received: by 2002:a05:6830:348f:: with SMTP id c15mr2617166otu.138.1616580819586;
 Wed, 24 Mar 2021 03:13:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210323012755.155237800@goodmis.org> <20210323085220.6e20d125@gandalf.local.home>
In-Reply-To: <20210323085220.6e20d125@gandalf.local.home>
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Wed, 24 Mar 2021 15:43:28 +0530
Message-ID: <CAK7tX=bg_6ny22QP5DXZaHdOd-=ojOaQYanjo1b7OEMoSR=gjQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] libtracfes: Add tracefs_function_filter()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi steve,
I have doubt

On Tue, Mar 23, 2021 at 6:22 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 22 Mar 2021 21:27:55 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > This adds a new API tracefs_function_filter() as described in:
> >
> >  https://bugzilla.kernel.org/show_bug.cgi?id=210643
> >
> > It will use regular expressions against available_filter_functions (or even
> > the kernel glob expression) to enable the function by the index method if it
> > is supported. If it is not supported, it will go back to the writing of the
> > filter strings directly into the set_ftrace_filter file.
> >
> >
>
> Playing with the interface some more, I feel it's not quite adequate.
>
> The returning the negative number of filters that failed, isn't very
> useful. Having the errs array that points to those filters gives us that
> information.
>
> Also, because of the way that file works in the kernel, we need to be able
> to call this function several times without closing the file. That's
> because the actions take place when the file is closed, *not* when a write
> is made. Having the interface return errors without closing the file would
> allow the user to fix the failed filters and try again.
>
> I plan on committing this patch series, so any new changes will be done on
> top of them. But here's what I think needs to be done to make the interface
> more usable.
>
>  - Create a tracefs_function_filter_commit(instance) API that will close
>    the file and commit the changes.
>
>  - Have the tracefs_function_filter() open the set_ftrace_filter file if it
>    is not already opened. This will allow for the function to be called
>    multiple times. The file descriptor will be part of the instance
>    descriptor or a global variable for the top level instance. The opening
>    of the files will need to be protected by a pthread mutex.
>    Note, the "reset" parameter is only applicable if the file is not
>    already opened.
>
>  - On success, return 0 and tracefs_function_filter_commit() must be called.
>
>  - If the file descriptor is opened and an error happens, return 1, and the
>    tracefs_function_filter_commit() still needs to be called, but the user
>    can call tracefs_function_filter() again to try to fix the problem.
>
>  - If an error is found before the file descriptor is opened, then
>    tracefs_function_filter_commit() does not need to be called.
>
> That is:
>
>         ret = tracefs_function_filter(...);
>         if (ret >= 0)
>                 tracefs_function_filter_commit();
>
>  - Now for errs, it will be allocated if a problem happened on a filter,
>    and may be set if the return value is non zero (1 or -1). The user can
>    use it to know if the problem happened on a filter as well as find out
>    which filter had the problem.
>
>  - We can have a tracefs_read_function_filter() that returns an array of
>    strings which ends with a NULL pointer (and needs to be freed with
>    tracefs_list_free(), and have this:
>
>    save_filters = tracefs_read_function_filter(instance);

are we going to use the tracefs_read_function_filter() function to
read the set_ftrace_file for getting written filters?
>
>    ret = tracefs_function_filter(instance, filters, NULL, true, &errs);
>    if (ret > 0 && errs) {
>         /* Modified but failed */
>         int i, j;
>         for (i = 0; filters[i]; i++)
>                 ;
>         for (j = 0; errs[i]; j++)
>                 ;
>         if (i == j)
>                 /* all filters failed! Put back the original */
>                 tracefs_function_filter(instance, save_filters, NULL, false, NULL);
>    }
>    if (ret >= 0)
>         tracefs_function_filter_commit(instance);
>
> Another reason to have it not close the file is because we only support
> passing in one module at a time. If the user wants to enable functions in
> two modules, they would need to call this twice, and we want them to be
> able to do so and have both changes take affect at the same time.
>
> Thoughts?
>
> -- Steve

Thanks,
sameer.
