Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 288C9C433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E976364F3A
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhCBX7a (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:59:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1578225AbhCBNQM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Mar 2021 08:16:12 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2935264F15;
        Tue,  2 Mar 2021 13:15:05 +0000 (UTC)
Date:   Tue, 2 Mar 2021 08:15:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
Message-ID: <20210302081503.692fd98f@oasis.local.home>
In-Reply-To: <CAK7tX=Zn-pj2-+6Y_JwCgUraiVCVz7uc28WYP27wJuKURhYsuQ@mail.gmail.com>
References: <1614705310-5887-1-git-send-email-sameeruddin.shaik8@gmail.com>
        <20210301131754.11f0be38@gandalf.local.home>
        <CAPpZLN7XLeOqTqBZZDetyL9Wc32dDNd0Gd8yBcET7Pd3qUYRcw@mail.gmail.com>
        <CAK7tX=Zn-pj2-+6Y_JwCgUraiVCVz7uc28WYP27wJuKURhYsuQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2 Mar 2021 10:44:14 +0530
Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:

> > Let's fix the number of parameters to this function:)  
> 
> >> Not sure what you mean by that.  
> Actually i meant this ""int tracefs_function_filter(struct
> tracefs_instance *instance,
>                                     const char * const * filters,
>                                     const char * module, bool reset,
>                                     const char * const ** errs);""
> For every patch, a parameter is increasing in this API.

And that's a normal approach to developing APIs. I've been doing this
for over 25 years, there's nothing special about this case. In
discussion on APIs, parameters grow to handle new cases. That's par for
the course. There's only 5 parameters, not too many.

> 
> > let's return the number of bytes written, also we will calculate the
> > complete filters length and return it, if there is difference,
> > we will loop into the integer array and print the erroneous filters  
> 
> >>Not sure how that is helpful. How would you use the number of bytes
> >>written?  
> 
> We will return the number of bytes written and we also store the total
> length of strings
> in filters array, in one pointer variable, we will check the
> difference between bytes written
> and the total length of the strings, if there is difference we will
> print failed filters otherwise
> we will not print anything.

Please show an example of a use case that you would use this with?

I gave you an example of how I intend on using it, and the user of this
interface should not care about number of bytes written. And the
interface should not be printing any error messages, it is a library,
error messages are for applications to produce. The interface must give
the application enough information to be able to produce it.


> 
> >It is very useful to have a way to report back the failed filters.
> >Using an array
> >of strings will work for this API, but I was thinking somehow to leverage the
> >error_log file by the ftrace itself. Currently it does not report any
> >error, just
> >returns EINVAL. In more complex filters it would be useful to log
> >more detailed description of the problem in the error_log file.  
> 
> This error_log is also a good idea.

It's actually not very useful for this interface. The only error that
it would give you is that it could not find any functions that match a
filter.

When we create other interfaces that do more than just setting
functions (like setting triggers) then we can return to looking at the
error log. But since the kernel does not produce anything in the error
log at the moment, it must be updated. And kernels take about a year or
two after a change to get into distributions. That means, this library
can't rely on it being there, and still needs a way to inform the
application of errors.

> 
> If possible let's have a live discussion on this API,so that we can
> discuss the corner cases in the design
> more efficiently and we can close it ASAP.
> 

I have a very good idea of what I want from this interface, which is
why I created the bugzilla about it. If you want to implement it
different than my idea, please show code examples of your use cases.

-- Steve
