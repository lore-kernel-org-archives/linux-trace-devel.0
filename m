Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35122C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 15:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9A6C64ED3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 15:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhBXPlM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 10:41:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232475AbhBXOUg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 09:20:36 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DDD064E6B;
        Wed, 24 Feb 2021 14:19:37 +0000 (UTC)
Date:   Wed, 24 Feb 2021 09:19:35 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [Bug 210643] libtracefs: Add ways to set the filtering of
 function tracing
Message-ID: <20210224091935.767a8e0c@gandalf.local.home>
In-Reply-To: <CAK7tX=aOyq3O_p1S5xVP3FZuciU6g=TcP997Sv3bxbxTWiBL7Q@mail.gmail.com>
References: <20210223120130.280e7838@gandalf.local.home>
        <CAPpZLN7tsF8=o1RQJc2rMAdbrFgmFvZmKWK9avbCPCa42U_iDw@mail.gmail.com>
        <CAK7tX=aOyq3O_p1S5xVP3FZuciU6g=TcP997Sv3bxbxTWiBL7Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Feb 2021 15:04:51 +0530
Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:

> hi,
> 
> >I forgot to include you on the Cc for this email.  
> 
> Not a problem at all steve , bugzilla daemon  sent me an update:)
> 
> I have read your requirements, I am thinking to give 3 incremental
> patches for this API
> 
> patch-1 : will write normal strings into the filter file
> patch-2: will handle the kernel glob expressions
> patch-3: will handle the regular expressions

Sure. You can send out a 3 patch set series and we can continue our
discussion on that.

> 
> >I think there should be a complementary API for deleting the filters,
> >may be something like
> >int tracefs_function_filter_remove(struct tracefs_instance *instance,
> >                                                        const char *
> > const *filters,
> >                                                       const char *module)
> > It should be able to remove the filters, configured by the first API
> > with the same "filters, module" input parameters.  
> 
> Tzvetomir,
> Let's wait for the steve inputs on this.

I agree with Tzvetomir, but let's worry about the addition of filters API
first, and then when we get that all settled out, we can add this one, as
this one should be much simpler (famous last words).

-- Steve
