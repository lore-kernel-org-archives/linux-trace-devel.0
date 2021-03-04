Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58689C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 09:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B97264F1E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 09:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhCDJAN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Mar 2021 04:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237293AbhCDJAD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Mar 2021 04:00:03 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5B2C061574
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Mar 2021 00:59:23 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id s7so8570192plg.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Mar 2021 00:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PIBoqT301gmcz/jMopmi5ruANvSZkZ2TPheeYk3xgIQ=;
        b=sTX+2CGGzByK8LIj+CUUBWXUkC/j52oaFwmW5647JM0BZju4dER7xuKGyYxwnoz1P2
         sEKKxEVRMZkxFLNrTzX92vnzFbpsESNN/PISCIjOFjQAHPnN7PzKwo0XhrFW1zbph1j0
         StNN6z2ghjFZchLJ8a7kP3DvnnK/FMlx0P93twM2xmr85kP80xE4jkjuR+8psNaYMza9
         BKaGhFHVpIse8HV+hIBnyj5zwnn1kmuALadDYfkqMGdF0JDof3PW9jlq3lgSZk1bVWd5
         jKOHrcmbPBcHeT/wabFmcetXX7bW53Wi5JsFpxFh5AkHyiNrAc5TsH/qzzJMjCRMNQZ0
         1RsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PIBoqT301gmcz/jMopmi5ruANvSZkZ2TPheeYk3xgIQ=;
        b=MC9p2nbtL4yRbjn/VmKAlFl5mGZSWZKbTmY/jLscQtupxv5P6zXn911zX7EtztXWuj
         Y+Zq6GDLXlYX3dD88IH7VIG21e2qbR1p8eVYBzUW4r8dDgvc5RJGabBRQ7wf81Fem+WB
         y9ifEZlF6guMejkMGrfBwU0V1ipfQ/4iMKdptjpDQbb4jpCx3Zn3ZWQDyKDU6vH/gOB3
         Zf3j9YyOUxuYISjhaFgkTeyg+cpIP3w2UDsB1+2BiBcjjcVpZIF6bAKFR6Fvz9DbQpl4
         uDLCvTX2XnefuYIaKCtTNWpSoVhBvUKFKeevHyVzpA5OGWeFchSDytJzPQLugXwgdSXr
         0cDQ==
X-Gm-Message-State: AOAM531m5RdOgYobyk+5sWfBB9x36qssyGWnNDCqOMHYJ4Gg6k/LFRxi
        ebX3VigINAYKfmfoPHs66JqvvzM2cuL8wAXHm2g=
X-Google-Smtp-Source: ABdhPJyeuk/5OPzw2FvM4NR3r05W9Uvl/8VC9nGBDjAkIzfMBTnND6iGsP7cCDBKcTNMzUmFPpXN+GMSfAYdwGWim5o=
X-Received: by 2002:a17:902:6b87:b029:dc:3402:18af with SMTP id
 p7-20020a1709026b87b02900dc340218afmr3172460plk.29.1614848362775; Thu, 04 Mar
 2021 00:59:22 -0800 (PST)
MIME-Version: 1.0
References: <1614705310-5887-1-git-send-email-sameeruddin.shaik8@gmail.com>
 <20210301131754.11f0be38@gandalf.local.home> <CAK7tX=b4qPFcC+uGHfbBT3v90+qhHuBoLF=HgqUMmD0b00PF6A@mail.gmail.com>
 <20210301202803.3529949d@oasis.local.home>
In-Reply-To: <20210301202803.3529949d@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 4 Mar 2021 10:59:06 +0200
Message-ID: <CAPpZLN4h-cXe7j0sBxviQdttD4OT7H=tW5j0=0qYyDCw2XutMg@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Mar 4, 2021 at 9:24 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 3 Mar 2021 06:46:26 +0530
> Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:
>
> > what if we store the indices of the failed filters in an integer array
> > and return them back?
>
> There's not much difference if we return an array of pointers to the
> filters or an array of integers to the index. I was just thinking about
> how I would use the interface. When having a working interface, we
> should write a few robust programs to see how easy it is to use, and
> that will help in making the API appropriate. This needs to be done
> *before* we accept it. This particular API is going to be widely used,
> and it needs to be simple and robust.

One remark, not directly related to this discussion. When the implementation
of the API is ready, there should be a unit test (in a separate patch) - as for
any of the other APIs. Usually these are the first use cases that I write for
the new APIs.
Sameer, please look at utest directory where the unit tests are, each API has
a unit test there. We use the cunit framework, ask if there are questions about
it. This should be the next step, when the final version of the
implementation is
ready.
Thanks!

>
> > let's return the number of bytes written, also we will calculate the
> > complete filters length and return it, if there is difference,
> > we will loop into the integer array and print the erroneous filters
>
> Not sure how that is helpful. How would you use the number of bytes
> written?
>
> >
> > Let's fix the number of parameters to this function:)
>
> Not sure what you mean by that.
>
>
> Here's how I envision this interface.
>
>         char **errs;
>         char *filters[] = {
>                 "sched*", "spin_*", NULL
>         };
>         int ret;
>
>
>         ret = tracefs_function_filter(NULL, filters, NULL, &errs);
>         if (ret < 0) {
>                 int i;
>
>                 printf("Failed to apply: ");
>                 for (i = 0; errs[i]; i++) {
>                         if (i)
>                                 printf(", ");
>                         printf("'%s'", errs[i]);
>                 }
>                 printf("\n";
>                 exit(ret);
>         }
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
