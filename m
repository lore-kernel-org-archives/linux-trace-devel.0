Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B1BC2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 18:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE50561242
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 18:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbhFNSpc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 14:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232992AbhFNSpc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 14:45:32 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DC3961209;
        Mon, 14 Jun 2021 18:43:28 +0000 (UTC)
Date:   Mon, 14 Jun 2021 14:43:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Claire Jensen <cjense@google.com>
Subject: Re: [PATCH 2/2] libtraceevent: Changed angled brackets to double
 quotes.
Message-ID: <20210614144326.5527899c@gandalf.local.home>
In-Reply-To: <CAP-5=fX00qHJmNeEpPCaCj5tqUkjbMc_Lk18o6Dv_ux6ESvSHw@mail.gmail.com>
References: <20210612014501.890593-1-irogers@google.com>
        <20210612014501.890593-3-irogers@google.com>
        <20210612190049.7e09d8c6@rorschach.local.home>
        <CAP-5=fX1riLr6y8KapEhmxk3BW1Xq9kV_zMywoQ+B8Dgs6fxeg@mail.gmail.com>
        <20210613192926.6cb6b983@rorschach.local.home>
        <CAP-5=fX00qHJmNeEpPCaCj5tqUkjbMc_Lk18o6Dv_ux6ESvSHw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 14 Jun 2021 09:14:08 -0700
Ian Rogers <irogers@google.com> wrote:

> On Sun, Jun 13, 2021 at 4:29 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Sun, 13 Jun 2021 14:31:42 -0700
> > Ian Rogers <irogers@google.com> wrote:
> >
> >  
> > > Would it be more conventional in this situation to use quotes within
> > > the library and angles outside? This change is within the library and
> > > not with code trying to link against it.  
> >
> > Does it matter? If not, what's the purpose of changing it?  
> 
> Sorry for not having this in the body, in the cover message I added to
> Claire's email with:
> 
> > Some build systems are picky about angled vs quotes, fix this minor issue.  
> 
> The problem is with certain build system, we use bazel at Google,
> where iquote is used for includes within the library, and other
> flavors outside the library. There's a similar conversation here:
> https://groups.google.com/g/bazel-discuss/c/6MNuZ5bKoa8?pli=1
> 
> the failure you see when building is:
> 
> In file included from src/event-parse.c:27:
> src/event-utils.h:13:10: error: 'event-parse.h' file not found with
> <angled> include; use "quotes" instead
> #include <event-parse.h>
>          ^~~~~~~~~~~~~~~
>          "event-parse.h"
> 
> Arguably -iquote is more correct within the library build, hence bazel
> using it. The libtraceevent Makefile is using -I, hence this not being
> a problem for others. We prefer not to carry internal patches, hence
> wanting to send this upstream.

OK, context is very important :-)

With the above explanation, it makes sense, and I'm OK with taking it.
Please resend with the above in the commit log.

Thanks!

-- Steve
