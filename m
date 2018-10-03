Return-Path: <SRS0=ZGqO=MP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:51214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbeJDCFF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Oct 2018 22:05:05 -0400
Date: Wed, 3 Oct 2018 15:15:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Still problem with red preempted boxes for tasks
Message-ID: <20181003151522.133a10ca@gandalf.local.home>
In-Reply-To: <b1b4b516-9b6a-87ea-7755-4d1952ce0444@gmail.com>
References: <20181003144835.23f09933@gandalf.local.home>
        <b1b4b516-9b6a-87ea-7755-4d1952ce0444@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 3 Oct 2018 22:10:30 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Hi Steven,
> 
> Thanks a lot for this feedback!
> 
> I will try to fix this before the end of the week. Not sure I manage to 
> understand what has to be done for the colors of the task plots but I 
> guess you can show me at our next 1:1.

If you look at what the old kernelshark does, you should see what I'm
talking about.

For CPU plots, the colors match for what task is running on the CPU.

For task plots, the colors should match for what CPU the task is
running on. Thus, if a task migrates, it should have a different color.

> 
> My talk tomorrow starts at 5 PM Sofia time (10 AM for you). I still 
> don't have the link for the streaming but I hope to have it tomorrow.

Ah, so I shouldn't have canceled our tracing meeting, but instead made
your talk what we do for it ;-)

-- Steve
