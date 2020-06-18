Return-Path: <SRS0=0fRq=77=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D501C433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 15:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55FF120888
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 15:55:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IG1bk1rz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgFRPzm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Jun 2020 11:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbgFRPzl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 11:55:41 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A81BC06174E
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jun 2020 08:55:41 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b5so2965366pfp.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jun 2020 08:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vHY5MkZJQhCkP2KBEQN1Q0HALHe1I3TcerkJaDylFj4=;
        b=IG1bk1rzG1ybnP3NJhBsn3D2OcZd+btjM+12Y9ZVtElqrLQGMTFO1aSxL1mKz0owP1
         wT4Nbs/PrSSDdTqx4ahRywpAnRZ+2IZZwuiPWjewMfWK9nf5IGmhToWz0S0gjYqnpNqm
         JyScytMwebOMJ6ZSIHQXz//U29wd713vOI6piTWkkjA4XtZh+fz6BILZPejg+h2gFJIb
         yHlK5Czi0zTzBAcFoaw8JoLJleNN2ildRbqfoMVZoXo6+MBAiILqkWweiiTE3TjTSK9Q
         58BU2cu0lcUqnWwvl8YTUMEyJX/8Y9cbKauBes6U0Idy4BbULX5ADp93yz3Zmq8mP1TP
         zgKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vHY5MkZJQhCkP2KBEQN1Q0HALHe1I3TcerkJaDylFj4=;
        b=Tty598OKEHYS43n9fKgxOwDWxbgmr662DeZ5mAr4avSsReuHQJwFw24JKjBKnQZHqQ
         Ud5pR3rTZD1UhT6SATjbe0DJ6JyAlAZTnqSoVWpuDdMrsdhbUHgflCa05qEzXSEvDcet
         UFN4C/zINwALo3fBZr1VItBrxgz/ArYG4Du6SzlADPlywfAceOrAvwXqG8owT1d0Kfa1
         CaqNeqKJmEOMIHtk+DNUqBHX9xaCoRljZGPkJnau/82y3YxzVzKYeUsrX4BWWrOjnPDB
         gkk7z6WeUqOMjxX6WZJ1Me7Zm9Mct2q8yv2p5f8PMoHmRgAEAH4xlQpW251pxRC67H3y
         F6+g==
X-Gm-Message-State: AOAM533C+WzvhW+HiMb8g/Ciw+eUy4X+ArgRu2fIzipDiBKhyfJ8F5Jw
        hYJoNEHJZiVQtxSziUQMfjz1EotnIEdqGgIT/cxfXx3C
X-Google-Smtp-Source: ABdhPJwRjGH3HyDEa8QKFQYYGwL1cHRf9KTou8Bphla/fPmKfhMIoUSwDzSI0jvysldnbJqJZl7vPaGkAd01bxWFjy8=
X-Received: by 2002:a62:8f45:: with SMTP id n66mr4167326pfd.236.1592495741135;
 Thu, 18 Jun 2020 08:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAPpZLN4RkWjAFBw=wShOMhQ0ECWJnDiOyQQPP6os68pSM9VeBQ@mail.gmail.com>
 <20200618114657.34351921@oasis.local.home>
In-Reply-To: <20200618114657.34351921@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 18 Jun 2020 18:55:29 +0300
Message-ID: <CAPpZLN6Xd0fiBUxKUCn=-z5JsHRocWAUPBtmTFJ=Z6Nj6qbfPA@mail.gmail.com>
Subject: Re: libtraceevent sync
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Jun 18, 2020 at 6:47 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 18 Jun 2020 14:43:42 +0300
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > kernel/traceevent/plugins commits, should be added in
> > trace-cmd/traceevent/plugins:
> >     "libtraceevent: Remove unneeded semicolon"
> >         https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eebe80c982546ce1041b7dcf3c461406f1e7e88f
> >      "tools lib traceevent: Fix memory leakage in filter_event"
> >         https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f84ae29a6169318f9c929720c49d96323d2bbab9
> >      "tools lib traceevent: Take care of return value of asprintf"
> >         https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f8ff18be1f5c6ba1c2befb043bea6e7eaf9f8987
>
> The above are fine.
>
> >      "tools lib traceevent: Added support for pkg-config"
> >         https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cc03e1a8f82dff36fb329469c28cbfe7d2e6156a
>
> Hmm, do we need this? If the plan is to make traceevent its own
> package, I don't think we need to have pkg-config for trace-cmd.
>
> >      "tools lib traceevent: Remove hard coded install paths from
> > pkg-config file"
> >         https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=53dbabfe50262eeebb56ce18789c3c885f15e6ac
>
> Same for this one. I don't think the libraries should be installed via trace-cmd.

There is already an "install_libs" target in trace-cmd top Makefile. I
think all libraries which are supposed to be used with 3th party
applications should be integrated with pkg-config infrastructure.

>
>
> >
> > kernel/traceevent/plugins commits, should be added in
> > trace-cmd/traceevent/plugins:
> >      "tools lib traceevent: update KVM plugin"
> >          https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2f465deef7ce8c722121b782dd91c284f5ae80ca
>
> This is good.
>
> Thanks Tzvetomir!
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
