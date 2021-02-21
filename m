Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A9DC433DB
	for <linux-trace-devel@archiver.kernel.org>; Sun, 21 Feb 2021 15:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57DF264EF2
	for <linux-trace-devel@archiver.kernel.org>; Sun, 21 Feb 2021 15:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhBUP3H (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 21 Feb 2021 10:29:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229910AbhBUP3F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 21 Feb 2021 10:29:05 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F49564E2F;
        Sun, 21 Feb 2021 15:28:23 +0000 (UTC)
Date:   Sun, 21 Feb 2021 10:28:21 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: New API to trace only specific functions by
 instance
Message-ID: <20210221102821.1b6f13bd@oasis.local.home>
In-Reply-To: <CAK7tX=bRRtcsAPWuiF8i5T2WnO_kSMKY7ar01f3Ki4awAC08rQ@mail.gmail.com>
References: <1613996661-6525-1-git-send-email-sameeruddin.shaik8@gmail.com>
        <CAK7tX=bRRtcsAPWuiF8i5T2WnO_kSMKY7ar01f3Ki4awAC08rQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Feb 2021 18:10:40 +0530
Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:

> hi steve,
> As you suggested, i have used an array of const pointers to const strings.
> This is the version-1 of the patch, it breaks in write.
> I faced two problems here
> 1. The above  code can't be able to write to  set_ftrace_filter file
> string by string (for normal files its working fine), After every
> successful write i am getting the count bytes written as supplied
> size, but strings are  not getting written in the set_ftrace_filter
> file. please give me any review or debug inputs on this

I'll take a look at your patch tomorrow.


> 2.I don't know how to reply to previous thread using git send-email, i
> apologize for that, please do let me know how to reply to the older
> threads
> using the git send-email.

Why do you need to reply to the previous thread with git send-email.
New versions of a patch should be their own thread and not a reply to
another thread.

That said, if you look at the headers of the email you want to reply
to, you'll see a Message-ID field. For example, your email that I'm
replying to has the message id of:

 Message-ID: <CAK7tX=bRRtcsAPWuiF8i5T2WnO_kSMKY7ar01f3Ki4awAC08rQ@mail.gmail.com>

Then I can use the part in between the '<' and '>' to send replies via
git send-email.

 git send-email '--in-reply-to=CAK7tX=bRRtcsAPWuiF8i5T2WnO_kSMKY7ar01f3Ki4awAC08rQ@mail.gmail.com'

Note the quotes used above. They may be needed to prevent bash from
interpreting anything inside the message ID.

And then the emails sent from git will be a reply to that email.

> Once i have the write functionality working fine, will implement the
> other features incrementally.

OK. Again, I'll take a look at your patch on Monday.

Thanks,

-- Steve

