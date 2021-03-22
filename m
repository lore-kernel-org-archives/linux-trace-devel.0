Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CCDC433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 13:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D1FB61931
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 13:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhCVNjl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 09:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231203AbhCVNjL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 09:39:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FE846196F;
        Mon, 22 Mar 2021 13:39:10 +0000 (UTC)
Date:   Mon, 22 Mar 2021 09:39:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3] libtracefs: An API to set the filtering of functions
Message-ID: <20210322093908.41cd89de@gandalf.local.home>
In-Reply-To: <CAPpZLN5SSxa2ZwnE1G3iuk2uuvm0JaP_N92esJKqL=zSDwCruQ@mail.gmail.com>
References: <1616171938-18914-1-git-send-email-sameeruddin.shaik8@gmail.com>
        <CAPpZLN5SSxa2ZwnE1G3iuk2uuvm0JaP_N92esJKqL=zSDwCruQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 18 Mar 2021 19:22:26 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> Looks good to me.
> Thanks Sameer!
> Acked-by: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

Thanks Semeer,

I'm applying version 3 of your patch.

As Tzvetomir said:

> I consider this patch as a good foundation for the API, but we should
> work on some optimizations on top of it, in separate patches. What
> else should be added, when this patch is merged:
>  1. A unit test of the API
>  2. Man page of the API

Feel free to send us a unit test of the API, that would be most useful.

You can also work on a man page as well.

>  3. Optimizations: new kernels support writing indexes instead of
> strings into the "set_ftrace_filter" file. This is faster, as there is
> no string comparison in the kernel context. The function index can be
> retrieved from "available_filter_functions" files - the first function
> is with index 0, the next is 1 ... and so forth. So, the possible
> optimization of the API is to check - if the kernel supports indexes,
> use it, or fail back to the legacy logic with strings.

There was a task I had where I needed the above work completed and had to
write it myself. Since it is already completed, there's no reason to have
you work on something that is not needed anymore. The code I wrote only
works for Linux kernels 5.1 and beyond. The code you wrote here is needed
for kernels older than that. Knowing that you were working on this code, I
just tested if the optimization existed, and if not, it would fail. Now I
can make it fall back to your code instead of failing.

As the man pages and the unit tests are still needed, we are looking
forward for your continued contribution to the tracing libraries.

Thanks!

-- Steve
