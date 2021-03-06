Return-Path: <SRS0=rW7V=IE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116C4C433E0
	for <linux-trace-devel@archiver.kernel.org>; Sat,  6 Mar 2021 15:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B92606501B
	for <linux-trace-devel@archiver.kernel.org>; Sat,  6 Mar 2021 15:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhCFPFw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 6 Mar 2021 10:05:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:36582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230238AbhCFPF1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 6 Mar 2021 10:05:27 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FF1765017;
        Sat,  6 Mar 2021 15:05:27 +0000 (UTC)
Date:   Sat, 6 Mar 2021 10:05:25 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
Message-ID: <20210306100525.5818bde6@oasis.local.home>
In-Reply-To: <CAK7tX=aASGnr+zyAc+Y_oeqPwOdkwkstJUvypUS=yqNmenCy_Q@mail.gmail.com>
References: <1615029625-9749-1-git-send-email-sameeruddin.shaik8@gmail.com>
        <CAPpZLN6A+5pmCnOCJfg-eV1+1UR_MbwgvzhW-bd-ZZJ1F-dC=A@mail.gmail.com>
        <20210305093946.1c3f4ad7@gandalf.local.home>
        <20210305095439.10321303@gandalf.local.home>
        <CAK7tX=aASGnr+zyAc+Y_oeqPwOdkwkstJUvypUS=yqNmenCy_Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 6 Mar 2021 07:25:18 +0530
Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:

> i have one doubt.
> >Note, @filters should be of type: const char * const * filters,  as not
> >only is filters pointing to constant strings, the array itself will not be
> >modified.  
> 
> what If the user wants to capture the filters at run time like below ?
> let's say
> 
>   filters = malloc(sizeof(char *));
>         if (!filters)
>                 return 1;
>         printf("please enter the input filters count\n");
>         scanf("%d", &fil_count);
>         while(i < fil_count) {
>                 scanf("%s", buf);
>                 slen = strlen(buf);
>                 if (!slen)
>                         return 1;
>                 filters[i] = calloc(1, slen);
>                 strncpy(filters[i++], buf, slen);
>         }
> at that time, this declaration will be problematic right?, because we
> are trying to modify
> the read-only memory. Are we expecting the user to supply filters at
> compile time like below?
> const char * const *filters = {"kvm_pmu_reset", "kvm_pmu_init",
> "dir_item_err", NULL};

OK, my apologies, I see the issue that you are having, and you are
correct.

Because newer compiles will warn if you pass "char **" to a
"const char * const *" parameter. Because it assumes that the two types
are different, even when they shouldn't be. I'm not sure why the
compiler wont let you pass in a char ** to a const char * const *, but
it does indeed make them different.

Even though there's ways to always pass strings via this logic, (you
can create a "const char **" array and assign it to the dynamic one,
and pass that in just fine). I looked at other prototypes, and see that
the common method is.

 const char **

A couple do the "const char * const *" but they look to be special
cases.

So yes, let's go with "const char **" as we want to show that the
strings will not be modified, and have "const char ***" for errs.

Thanks!

-- Steve
