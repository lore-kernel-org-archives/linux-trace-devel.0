Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17650C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D88F92343F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgLJCJs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 21:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgLJCJj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 21:09:39 -0500
Date:   Thu, 10 Dec 2020 11:08:54 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607566138;
        bh=vG8yoWeJ5TaAqgH6L+L4b7udlEhhfsUN6amJFmbiL10=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LAm2qMJwFcHz+UDCYJXCzRI3QPaC062Wm3UXIEHSSt4OxiRy6Sh3FWl2bkxOVFXpl
         TStzxj5tau2vg0sW4gSsP5F88EvN6mpNKnXPrC/eAf21mIXrqX0x5fmFk63YOG0sgI
         ZEl3G+nU417GrW6KqDrfGqVEp5M2GrkKXiXf5I76fFISCmGZFYRPIBwNqU4lekyiW7
         eLPCrKGeRjDKZPGupjGxF3g4xrPYpeilRVIl0JyS3ixN04B9+NdoGONwB+dMH91qqM
         YfanActU+uD9AeNHjq7vr/+zTH+tpp6z5H8adBcLnGUubCjJEyxONSfZMd8qwZEMKh
         IPrB/4vfQmduA==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH] ftrace/selftests: Add binary test to verify ring
 buffer timestamps
Message-Id: <20201210110854.73fc08c6a19fdd8588f3e2c0@kernel.org>
In-Reply-To: <20201209094919.31724179@gandalf.local.home>
References: <20201201160656.7cc6a5e8@gandalf.local.home>
        <20201208211411.e41849908381eb493adce0f5@kernel.org>
        <20201208100024.42bbcd23@gandalf.local.home>
        <20201209083954.5f7321a7551013aa95c0a459@kernel.org>
        <20201209094919.31724179@gandalf.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 9 Dec 2020 09:49:19 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 9 Dec 2020 08:39:54 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > > OK. I'll look at how to make this for both cases (embedded and not).
> > > Because, my current case is to copy the selftests to the machine and run
> > > them there. So my use case requires the build to happen at test time. But I
> > > can make it where it wont build if the binary already exists.  
> > 
> > For that case, what about just "make clean" before copy, then the binary
> > will be removed? 
> 
> I just meant that the binary build should not depend on anything outside
> the directory. It should be able to be built if you just copy the
> ftracetest directory and run there.

Oh I thought you considered the case that the library version differences
between the binary and execute environment.

> > > > (currently I returns UNRESOLVED when the test target kmodule is not found)  
> > > 
> > > I used UNTESTED for a couple of reasons. I figured "UNRESOLVED" was for
> > > lack of kernel features or modules. But this is not a lack of the kernel,
> > > but a lack of user space. If something in user space is lacking (a tool,
> > > library, or binary), then I thought UNTESTED would be a better option. But
> > > if you have a strong opinion on it, I'll change it to UNRESOLVED, otherwise
> > > I'll keep UNTESTED.  
> > 
> > The idea of UNTESTED/UNRESOLVED (and UNSUPPORTED) came from POSIX standard,
> > it is expained in dejagnu's manual:
> > 
> > https://www.gnu.org/software/dejagnu/manual/A-POSIX-Conforming-Test-Framework.html
> > 
> > In this case, user can build the user space binary for the environment but
> > does't, so I think UNRESOLVED will fit to that case.
> > 
> > So strictly speaking, UNTESTED is just a placeholder which will be implemented
> > in the future. (hmm, it will be a good chance to write a document for it)
> 
> OK, I'll change it to UNRESOLVED. One reason I used UNTESTED, is that the
> build wont happen until libtracefs is packaged and released (or you
> download and build it yourself). And it's just getting ready now. So in
> essence, this is currently just a "placeholder" ;-)

Yeah, so now if it can not run, user can solve it by installing libtracefs:)

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
