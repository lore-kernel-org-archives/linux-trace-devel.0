Return-Path: <SRS0=rW7V=IE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E15C433E0
	for <linux-trace-devel@archiver.kernel.org>; Sat,  6 Mar 2021 03:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2D1565011
	for <linux-trace-devel@archiver.kernel.org>; Sat,  6 Mar 2021 03:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhCFDi6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 22:38:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:33152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229821AbhCFDih (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 22:38:37 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3388464FF0;
        Sat,  6 Mar 2021 03:38:37 +0000 (UTC)
Date:   Fri, 5 Mar 2021 22:39:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
Message-ID: <20210305223912.58f4e86c@rorschach.local.home>
In-Reply-To: <CAK7tX=aASGnr+zyAc+Y_oeqPwOdkwkstJUvypUS=yqNmenCy_Q@mail.gmail.com>
References: <1615029625-9749-1-git-send-email-sameeruddin.shaik8@gmail.com>
        <CAPpZLN6A+5pmCnOCJfg-eV1+1UR_MbwgvzhW-bd-ZZJ1F-dC=A@mail.gmail.com>
        <20210305093946.1c3f4ad7@gandalf.local.home>
        <20210305095439.10321303@gandalf.local.home>
        <CAK7tX=aASGnr+zyAc+Y_oeqPwOdkwkstJUvypUS=yqNmenCy_Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 6 Mar 2021 07:25:18 +0530
Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:

> hi steve,
> 
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

No it wont. You can assign const pointers to dynamic pointers, but not
the other way around. It's a way to show that the function you are
calling wont do anything with the array you pass to it.

> the read-only memory. Are we expecting the user to supply filters at
> compile time like below?
> const char * const *filters = {"kvm_pmu_reset", "kvm_pmu_init",
> "dir_item_err", NULL};

No, as explained above.

> 
> Tzvetomir & steve,
> >Since a triple pointer is difficult to manage in the code, you could have:
> >
> >       const char **e = NULL;
> >
> >
> >               if (errs) {
> >                        e = realloc(sizeof(*e), j + 1);
> >                        e[j++] = filters[i];
> >               }
> >
> >Then at the end:
> >
> >       if (errs)
> >                *errs = e;  
> i have a concern here
> when a double pointer is doing our work here without any overhead, why
> we want to make it a triple pointer?

What overhead? A string is a pointer, an array of strings is a double
pointer, and passing in the address to an array of strings so you can
modify that array is a triple pointer, and that's exactly what you need
for errs.

This is basic C coding, nothing special here.

I'm curious to why you picked this particular API to implement. Is
there something you are planning on using this for?

-- Steve
