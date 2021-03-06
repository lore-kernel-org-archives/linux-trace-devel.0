Return-Path: <SRS0=rW7V=IE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PI_IMPORTANCE_HIGH,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1307C433E0
	for <linux-trace-devel@archiver.kernel.org>; Sat,  6 Mar 2021 05:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8658D65012
	for <linux-trace-devel@archiver.kernel.org>; Sat,  6 Mar 2021 05:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhCFFTQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 6 Mar 2021 00:19:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhCFFTF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 6 Mar 2021 00:19:05 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B44F364FEA;
        Sat,  6 Mar 2021 05:19:04 +0000 (UTC)
Date:   Sat, 6 Mar 2021 00:19:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
Message-ID: <20210306001903.0542848e@gandalf.local.home>
In-Reply-To: <CAK7tX=b=xQCB4ugQb5YSQisf+_bmmLrUbVgcCXG+vZD7upmx7A@mail.gmail.com>
References: <1615029625-9749-1-git-send-email-sameeruddin.shaik8@gmail.com>
 <CAPpZLN6A+5pmCnOCJfg-eV1+1UR_MbwgvzhW-bd-ZZJ1F-dC=A@mail.gmail.com>
 <20210305093946.1c3f4ad7@gandalf.local.home>
 <20210305095439.10321303@gandalf.local.home>
 <CAK7tX=aASGnr+zyAc+Y_oeqPwOdkwkstJUvypUS=yqNmenCy_Q@mail.gmail.com>
 <20210305223912.58f4e86c@rorschach.local.home>
 <CAK7tX=b=xQCB4ugQb5YSQisf+_bmmLrUbVgcCXG+vZD7upmx7A@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Importance: high
X-Priority: 1 (Highest)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 6 Mar 2021 09:59:34 +0530
Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:

> Okay steve
> 
> Actually I chose this API randomly from bugzilla, i don't have any
> plans as of now.
> I am developing it, as per your requirement.
> 
> Out of curiosity, I started implementing this API. Actually I am a
> novice in development,
> i know somewhat like how to write code logically and make it work, but
> i haven't followed any standard
> till now. I am learning some new things from your reviews.

We are happy to have you working with us.

I asked because the API you happened to pick is probably the most
complex one to implement compared to some of the other APIs listed in the
bugzilla, which is why I asked if you planned on doing anything with it, as
it is also one of the more crucial APIs to get right.

-- Steve
