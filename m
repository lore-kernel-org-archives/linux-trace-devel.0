Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C839FC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Apr 2021 02:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FA0B61077
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Apr 2021 02:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhDAClm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 22:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233015AbhDACld (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 22:41:33 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 207B361059;
        Thu,  1 Apr 2021 02:41:32 +0000 (UTC)
Date:   Wed, 31 Mar 2021 22:41:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 08/13 v2] libtracefs: Allow for setting filters with
 regex expressions
Message-ID: <20210331224130.4fec9cf5@oasis.local.home>
In-Reply-To: <fa1cb382-5984-d5de-5905-0eb3fd45a697@gmail.com>
References: <20210330005123.151740983@goodmis.org>
        <20210330005248.391852830@goodmis.org>
        <96e9fc99-53c5-ea5a-7e5d-5ea6dafc1f7c@gmail.com>
        <20210331123912.6295e9c1@gandalf.local.home>
        <fa1cb382-5984-d5de-5905-0eb3fd45a697@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 2 Apr 2021 07:29:59 +0530
sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:

> >
> > If you left off the "^" and "$" then it would be a glob, where "*" means
> > zero or more of any character. But if you want the same in regex, you need
> > to use:
> >
> >   "^ext4.*$"  
> 
> IF we use the regex in filters, running time of the program is 
> increasing drastically.

Only if the kernel doesn't support indexing, then it would take less
than a second.

> 
> lets say,
> 
> if we give the kernel glob as a filter, its getting converted to regex 
> and running time of program is
> 
> 5 secs, in other case where we use regex, its taking 80 secs to complete.

What example did you use? And yes, regex would do the matching in user
space and globs would be processed in the kernel (unless indexing is
available, in which case it uses regex for everything). That's because
the globs in the kernel were created to speed up the selection of
multiple functions. The regex would pass in one function that matched
at a time, and that's more of a O(n^2) algorithm.

This is why the function supports both globs and regex.

For simple regex, we could optimize it to use a glob, if indexing is
not supported. I mentioned this to Tzvetomir before and we agreed that
this optimization can be done with later patches in the future, as
modern kernels (5.1 and beyond) support indexing.

-- Steve
