Return-Path: <SRS0=0fRq=77=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE87C433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 13:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E3BC2082F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 13:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgFRN6e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Jun 2020 09:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgFRN6e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 09:58:34 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E42D2082F;
        Thu, 18 Jun 2020 13:58:33 +0000 (UTC)
Date:   Thu, 18 Jun 2020 09:58:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: libtraceevent sync
Message-ID: <20200618095831.45958f30@oasis.local.home>
In-Reply-To: <CAPpZLN4RkWjAFBw=wShOMhQ0ECWJnDiOyQQPP6os68pSM9VeBQ@mail.gmail.com>
References: <CAPpZLN4RkWjAFBw=wShOMhQ0ECWJnDiOyQQPP6os68pSM9VeBQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 18 Jun 2020 14:43:42 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> Hi Steven,
> These are differences in commits between both libtracevent
> implementations, in trace-cmd and in kernel. Please look at them, I'm
> going to synchronize both trees according to this list.
> 
> trace-cmd/traceevent commits, should be added in kernel/traceevent:
>   "trace-cmd: Introduced new traceevent API, for adding new plugins
> directories."
>      https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=5c8ac22552af4213f81cb7839f7f262252a80855
>    "trace-cmd: Optimize pretty_print() function"
>       https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=d8c1349f44ca9ac8ef0e7f198a133603ea399a95
>    "trace-cmd: Move plugin options from trace-cmd to libtraceevent."
>       https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=5988d3085d9ec5d7418ad49bc8c7e88c832d5ac5
>  "trace-cmd: Remove trace-cmd plugin handling routines"
>       https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=b2cf2e46a6d013d4037118274cc783570277ce32
>   "trace-cmd: Add proper KBUFFER_TYPE_TIME_STAMP handling"
>       https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=e5de44dd43523764d18dc773f82ce1b738c22e64
>    "trace-cmd: Add --debug to trace-cmd report"
>       https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=8cdbccd5ef422dc518e7246aa1c41922e834120b

OK for the above, but they the subjects will need to change to follow
the lib/traceeevent subjects. For example:

 trace-cmd: Optimize pretty_print() function

would become:

  tools lib traceevent: Optimize pretty_print() function

Also, the change logs may need to be tweaked to be specific for the
library. Though they can still reference trace-cmd as a user of the
APIs.

But keep the authors of these patches the same (From: lines).

> 
> trace-cmd/traceevent/plugins commits, should be added in
> kernel/traceevent/plugins:
>     "trace-cmd report: Add -O offset for function plugin"
>          https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=1785022e12cf0079889c519ffc7157f2143326ea
>     "trace-cmd: Move kernel_stack event handler to "function" plugin."
>         https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=8ba49dad8877fbd27cd6659397a01fb9243f7953
>     "tools lib traceevent: Add builtin handler for trace_marker_raw"
>         https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=d9f4b4043a68602f869c8c73b499cd7c7b4194b9
>     "trace-cmd: Add plugin for decoding syscalls/sys_enter_futex"
>         https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=25224f44a75e2ede5c2085683c0a008980ca87e7

Same for the above.

>     "Change to SPDX License format"
>         https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=ff551288621dd07e9a9da433cb5b9f539c025cb6

This hasn't already been updated (haven't gone and looked)?

>     "trace-cmd: Add more SVM exit reasons"
>         https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=4421d9551b903d720bb8534a02c3564187eab045
>     "trace-cmd: Add plugin for tlb_flush"
>         https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=7a0ead47bdb85288c855fafae24719b1ca9b907e

The above are fine with the same comments as the others.

>     "trace-cmd: Add hack to report out blktrace"
>         https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=9e0fd22b14805a3a3219a99bc5eccebf70f5484a

Hold off on this one.

I'll take a look at the rest later.

-- Steve
