Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF8DBC433C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 00:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74A1A61A13
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 00:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239348AbhCYAfv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 20:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232496AbhCYAfl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 20:35:41 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 987E2619C9;
        Thu, 25 Mar 2021 00:35:40 +0000 (UTC)
Date:   Wed, 24 Mar 2021 20:35:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/7] libtracfes: Add tracefs_function_filter()
Message-ID: <20210324203538.7bbe7f77@oasis.local.home>
In-Reply-To: <743080c8-6b22-83b7-6b2b-0221c2ee945b@gmail.com>
References: <20210323012755.155237800@goodmis.org>
        <20210323085220.6e20d125@gandalf.local.home>
        <743080c8-6b22-83b7-6b2b-0221c2ee945b@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 26 Mar 2021 05:55:46 +0530
sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:

> 
> On 23/03/21 6:22 pm, Steven Rostedt wrote:
> > On Mon, 22 Mar 2021 21:27:55 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> >> This adds a new API tracefs_function_filter() as described in:
> >>
> >>   https://bugzilla.kernel.org/show_bug.cgi?id=210643
> >>
> >> It will use regular expressions against available_filter_functions (or even
> >> the kernel glob expression) to enable the function by the index method if it
> >> is supported. If it is not supported, it will go back to the writing of the
> >> filter strings directly into the set_ftrace_filter file.
> >>
> >>
> > Playing with the interface some more, I feel it's not quite adequate.
> >
> > The returning the negative number of filters that failed, isn't very
> > useful. Having the errs array that points to those filters gives us that
> > information.
> Yeah, Anyway we are pointing the failed filters using the errs pointer. 
> But to differentiate
> 
> the failed filters from the general errors, we can return -1, what you say?
>

No, I was thinking that -1 means that the file was never opened, but 1
means an error happened after the file was opened (and thus it must be
closed, or "committed"). In either case, the errs can be set.

I have the function checking the available_filter_functions to see if
there's any matches before it even opens the file, and if any filter
fails, I was thinking it should return -1 (meaning failure before
opening) and the errs will be set to the filters that failed (if it was
due to a filter failing. We should clear errno, at the start, so that
if a filter failed, errno is zero, and errs points to the failed
filters, if there was another failure, then errno would be set instead).

If all filters match, and we use your old method and there's some other
kind of error in writing the filter to set_ftrace_filter, then we could
have errs point to that filter, but still return 1 because the file was
opened and it still needs to be closed / committed. Note, this wont
happen on kernels 5.1 and beyond, as they support indexing, and once we
get to the indexing part, errs wont be used.

-- Steve
