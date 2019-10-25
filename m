Return-Path: <SRS0=L246=YS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F9BCA9EAF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 01:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34EA321D7B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 01:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388655AbfJYBSx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 21:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388515AbfJYBSw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 21:18:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCA2621D71;
        Fri, 25 Oct 2019 01:18:51 +0000 (UTC)
Date:   Thu, 24 Oct 2019 21:18:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Allende Imanol <iallende@ikerlan.es>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: Re: Deadlock with FTrace in child process
Message-ID: <20191024211850.613279c6@gandalf.local.home>
In-Reply-To: <DB8PR03MB589769D8EFD0DCE8AEC6D283B6650@DB8PR03MB5897.eurprd03.prod.outlook.com>
References: <DB8PR03MB5897244BE1F37E6A001C300FB66F0@DB8PR03MB5897.eurprd03.prod.outlook.com>
        <20191021104121.769f3162@gandalf.local.home>
        <DB8PR03MB589769D8EFD0DCE8AEC6D283B6650@DB8PR03MB5897.eurprd03.prod.outlook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 25 Oct 2019 00:44:56 +0000
Allende Imanol <iallende@ikerlan.es> wrote:

> > On Sat, 19 Oct 2019 07:50:53 +0000
> > Allende Imanol <iallende@ikerlan.es> wrote:
> >   
> > > I am using Ftrace in a Ultra96 (arm64) 4.19.75-cip11 and it seems that
> > > I have a deadlock situation. I have a simple application executed as a
> > > child process from a python script. The child process reads from
> > > /dev/urandom and writes in /dev/zero. Ftrace is set only for this child
> > > process.  
> > 
> > Are you saying that ftrace is calling the blocked task?
> > 
> > If you don't run ftrace, the task never gets stuck?  
> 
> Without FTrace I did not get to achieve the same stuck scenario.
> 

OK, so you see this with function graph tracer enabled. The lockup is
that its stuck on a fast user-space mutex (futex). As function graph
does nothing to touch user space, but it does greatly effect timings
(function-graph is the slowest of the tracers), I'm guessing you have a
race that causes a deadlock in your application somewhere, but without
function graph tracing enabled, the race window is too small to trigger
it.

I've hit bugs like this before. Ftrace isn't the cause, it's the
instigator to help the real bug show its face.

Try limiting what gets traced, by either entering in functions in the
set_ftrace_notrace file, or entering in functions in the
set_ftrace_filter file. If you put in just a few functions in the
set_ftrace_filter file and you still see an issue, then you have a case
that it is the function graph tracer.

Start looking at the trace, and adding the most common functions used
into the set_ftrace_notrace file and see if the bug goes away.

Really, nothing in ftrace should cause an hang, except the fact that
you application has a race condition in it that ftrace makes the race
window big enough to trigger.

-- Steve
