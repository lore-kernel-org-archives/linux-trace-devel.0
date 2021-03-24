Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB5EC433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 14:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A31261A10
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 14:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbhCXOJL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236035AbhCXOIy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 10:08:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21C9A619D5;
        Wed, 24 Mar 2021 14:08:54 +0000 (UTC)
Date:   Wed, 24 Mar 2021 10:08:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 0/7] libtracfes: Add tracefs_function_filter()
Message-ID: <20210324100852.6b79232d@gandalf.local.home>
In-Reply-To: <CAK7tX=bg_6ny22QP5DXZaHdOd-=ojOaQYanjo1b7OEMoSR=gjQ@mail.gmail.com>
References: <20210323012755.155237800@goodmis.org>
        <20210323085220.6e20d125@gandalf.local.home>
        <CAK7tX=bg_6ny22QP5DXZaHdOd-=ojOaQYanjo1b7OEMoSR=gjQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Mar 2021 15:43:28 +0530
Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:

> >  - We can have a tracefs_read_function_filter() that returns an array of
> >    strings which ends with a NULL pointer (and needs to be freed with
> >    tracefs_list_free(), and have this:
> >
> >    save_filters = tracefs_read_function_filter(instance);  
> 
> are we going to use the tracefs_read_function_filter() function to
> read the set_ftrace_file for getting written filters?

Yes, why not?

But it would not return probes, only filters.

That is, the set_ftrace_filter also shows probes, and they are different.
But the tracefs_read_function_filter() should not return them. For them, we
should have a tracefs_read_function_probes() API.

-- Steve


> >
> >    ret = tracefs_function_filter(instance, filters, NULL, true, &errs);
> >    if (ret > 0 && errs) {
> >         /* Modified but failed */
> >         int i, j;
> >         for (i = 0; filters[i]; i++)
> >                 ;
> >         for (j = 0; errs[i]; j++)
> >                 ;
> >         if (i == j)
> >                 /* all filters failed! Put back the original */
> >                 tracefs_function_filter(instance, save_filters, NULL, false, NULL);
> >    }
