Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B8DC4361B
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 15:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCA91239D1
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 15:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgLHPBI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 10:01:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729842AbgLHPBI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 10:01:08 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1947239D1;
        Tue,  8 Dec 2020 15:00:26 +0000 (UTC)
Date:   Tue, 8 Dec 2020 10:00:24 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH] ftrace/selftests: Add binary test to verify ring
 buffer timestamps
Message-ID: <20201208100024.42bbcd23@gandalf.local.home>
In-Reply-To: <20201208211411.e41849908381eb493adce0f5@kernel.org>
References: <20201201160656.7cc6a5e8@gandalf.local.home>
        <20201208211411.e41849908381eb493adce0f5@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 8 Dec 2020 21:14:11 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> On Tue, 1 Dec 2020 16:06:56 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > 
> > A bug was reported about the ftrace ring buffer going backwards:
> > 
> > Link: https://lore.kernel.org/r/20201124223917.795844-1-elavila@google.com
> > 
> > In debugging this code, I wrote a C program that uses libtracefs to enable
> > all events and function tracing (if it exits), and then read the raw ring
> > buffer binary data and make sure that all the events never go backwards. If
> > they do, then it does a dump of the ring buffer sub buffer page and shows
> > the layout of the events and their deltas.
> > 
> > This was a very useful tool, and can be used to make sure that the ring
> > buffer's timestamps are consistently monotonic.  
> 
> Yeah, this sounds good to me.
> 
> > 
> > Adding this to the ftrace selftests seems to be a way that this can be
> > tested more often. But this would introduce the first binary code to the
> > ftracetests.  
> 
> No problem. I think it is better to be placed under ftracetest/bin/ and
> add a PATH before running testcases.

OK.

> 
> > To make sure that the tests still work on embedded devices (where a
> > compiler may not even exist), and also since this binary incorporates the
> > yet-to-be-released libtracefs library, if the make fails, the test exits
> > with UNTESTED. The UNTESTED is documented as being a place holder which
> > this would be if the make does not work.  
> 
> Hmm, in some embedded environment, we may not have make nor gcc.
> So it would be better to be build in the kselftest build process as similar
> to the other kselftests.
> 
> What about putting the source code under ftracetest/src/. For the embedded
> devices, it can be built with cross-tools (and make it static binary if
> needed) and install it under ftracetest/bin. If we have no cross-build
> tool etc. we just skip building the binary under ftracetest/bin. And if 
> the testcase finds there is no binary, it just returns UNRESOLVED or UNTESTED.
> 

OK. I'll look at how to make this for both cases (embedded and not).
Because, my current case is to copy the selftests to the machine and run
them there. So my use case requires the build to happen at test time. But I
can make it where it wont build if the binary already exists.

> (currently I returns UNRESOLVED when the test target kmodule is not found)

I used UNTESTED for a couple of reasons. I figured "UNRESOLVED" was for
lack of kernel features or modules. But this is not a lack of the kernel,
but a lack of user space. If something in user space is lacking (a tool,
library, or binary), then I thought UNTESTED would be a better option. But
if you have a strong opinion on it, I'll change it to UNRESOLVED, otherwise
I'll keep UNTESTED.

Thanks!

-- Steve
