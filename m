Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C670C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 23:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 154C623A5A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 23:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731789AbgLHXki (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 18:40:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:60578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731780AbgLHXki (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 18:40:38 -0500
Date:   Wed, 9 Dec 2020 08:39:54 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607470798;
        bh=rmI61EeHQCwVKLL9Ck31mxKDUHSt9NowP0gnU42nxHA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=j+skt7UhugtkoFr7WzkfFKWMnjeRMW1Q6/O/iw/3aJP3lkz2Q7VGs9HHJWqro1wLo
         WSb+hd5ZThSqwPz38lFCUfIFJGp7yO98q3tA81g9WDZnOrSzeRUCMuT07rYTHW0PaE
         u0sv6uUXtoSeU4OChX4v2ixKGEsKGj8Pc8iIHa+iL/IxZOCyVJQDBiuYhto/AqMgeu
         go4iadkkIlyBktZzQsbSM3DJRiKgKqlcEo1kDLJaE+2vvqMzbLEPzQRVOUk4p7nU1O
         gE2+Vfh/WvYRW3SL7UB5WUw8lJgAT8lQU795N4k2wElEjSMj/1/XsOAZbttOopyA9+
         ImE9I/4IUl/Rw==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH] ftrace/selftests: Add binary test to verify ring
 buffer timestamps
Message-Id: <20201209083954.5f7321a7551013aa95c0a459@kernel.org>
In-Reply-To: <20201208100024.42bbcd23@gandalf.local.home>
References: <20201201160656.7cc6a5e8@gandalf.local.home>
        <20201208211411.e41849908381eb493adce0f5@kernel.org>
        <20201208100024.42bbcd23@gandalf.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 8 Dec 2020 10:00:24 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 8 Dec 2020 21:14:11 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > On Tue, 1 Dec 2020 16:06:56 -0500
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > From: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > > 
> > > A bug was reported about the ftrace ring buffer going backwards:
> > > 
> > > Link: https://lore.kernel.org/r/20201124223917.795844-1-elavila@google.com
> > > 
> > > In debugging this code, I wrote a C program that uses libtracefs to enable
> > > all events and function tracing (if it exits), and then read the raw ring
> > > buffer binary data and make sure that all the events never go backwards. If
> > > they do, then it does a dump of the ring buffer sub buffer page and shows
> > > the layout of the events and their deltas.
> > > 
> > > This was a very useful tool, and can be used to make sure that the ring
> > > buffer's timestamps are consistently monotonic.  
> > 
> > Yeah, this sounds good to me.
> > 
> > > 
> > > Adding this to the ftrace selftests seems to be a way that this can be
> > > tested more often. But this would introduce the first binary code to the
> > > ftracetests.  
> > 
> > No problem. I think it is better to be placed under ftracetest/bin/ and
> > add a PATH before running testcases.
> 
> OK.
> 
> > 
> > > To make sure that the tests still work on embedded devices (where a
> > > compiler may not even exist), and also since this binary incorporates the
> > > yet-to-be-released libtracefs library, if the make fails, the test exits
> > > with UNTESTED. The UNTESTED is documented as being a place holder which
> > > this would be if the make does not work.  
> > 
> > Hmm, in some embedded environment, we may not have make nor gcc.
> > So it would be better to be build in the kselftest build process as similar
> > to the other kselftests.
> > 
> > What about putting the source code under ftracetest/src/. For the embedded
> > devices, it can be built with cross-tools (and make it static binary if
> > needed) and install it under ftracetest/bin. If we have no cross-build
> > tool etc. we just skip building the binary under ftracetest/bin. And if 
> > the testcase finds there is no binary, it just returns UNRESOLVED or UNTESTED.
> > 
> 
> OK. I'll look at how to make this for both cases (embedded and not).
> Because, my current case is to copy the selftests to the machine and run
> them there. So my use case requires the build to happen at test time. But I
> can make it where it wont build if the binary already exists.

For that case, what about just "make clean" before copy, then the binary
will be removed? 

> 
> > (currently I returns UNRESOLVED when the test target kmodule is not found)
> 
> I used UNTESTED for a couple of reasons. I figured "UNRESOLVED" was for
> lack of kernel features or modules. But this is not a lack of the kernel,
> but a lack of user space. If something in user space is lacking (a tool,
> library, or binary), then I thought UNTESTED would be a better option. But
> if you have a strong opinion on it, I'll change it to UNRESOLVED, otherwise
> I'll keep UNTESTED.

The idea of UNTESTED/UNRESOLVED (and UNSUPPORTED) came from POSIX standard,
it is expained in dejagnu's manual:

https://www.gnu.org/software/dejagnu/manual/A-POSIX-Conforming-Test-Framework.html

In this case, user can build the user space binary for the environment but
does't, so I think UNRESOLVED will fit to that case.

So strictly speaking, UNTESTED is just a placeholder which will be implemented
in the future. (hmm, it will be a good chance to write a document for it)

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
