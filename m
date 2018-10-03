Return-Path: <SRS0=ZGqO=MP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:49936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726966AbeJDBrU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Oct 2018 21:47:20 -0400
Date: Wed, 3 Oct 2018 14:57:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Some more updates for KernelShark
Message-ID: <20181003145740.06cd80d6@gandalf.local.home>
In-Reply-To: <20181003145458.165568c6@gandalf.local.home>
References: <20181003141552.1600bfa9@gandalf.local.home>
        <20181003145458.165568c6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 3 Oct 2018 14:54:58 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 3 Oct 2018 14:15:52 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Hi Yordan,
> > 
> > I'm using your latest KS for doing some real work (sched_deadline patch
> > review so it's perfect). Two nits:
> > 
> > In the event description window, instead of "Cpu" it should be "CPU" as
> > it is a proper acronym.
> > 
> > Second, can you do the same thing in the task plot view that you did in
> > the CPU view. That is, when the mouse is not over an event, the
> > description should show what CPU the task is on, like you did for the
> > CPU plot, where it showed what task the mouse is over.  
> 
> 
> Another issue I see. The colors of the CPUs for task plots need to stay
> consistent. That is, CPU-1 should be the same color on all task plots.
> This is required to see why a task was preempted.

Ah, I see what is done. You have the color of the task in the task
plot. The colors in the task plots need to be of the CPUs they
represent, not the color of the task. We need to see how a task is
migrating.

Another enhancement (not required for 1.0 as the above requests are),
is to have the designated color of the tasks be the background of the
text of the tasks name in the left. And we can do the same for the CPUs.

-- Steve
