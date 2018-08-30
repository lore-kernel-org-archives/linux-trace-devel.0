Return-Path: <SRS0=WdLK=LN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:41430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728273AbeH3SP2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Aug 2018 14:15:28 -0400
Date: Thu, 30 Aug 2018 10:13:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH 7/7] kernel-shark-qt: Add a plugin for sched events.
Message-ID: <20180830101306.005d73d1@gandalf.local.home>
In-Reply-To: <3e416b26-7155-51e0-fd27-be3a5d8a3c4d@gmail.com>
References: <20180829164224.20677-1-y.karadz@gmail.com>
        <20180829164224.20677-8-y.karadz@gmail.com>
        <20180829224312.25c7a16e@vmware.local.home>
        <3e416b26-7155-51e0-fd27-be3a5d8a3c4d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 30 Aug 2018 14:51:54 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> On 30.08.2018 05:43, Steven Rostedt wrote:
> >> +static int plugin_get_wakeup_pid_lazy(struct kshark_context *kshark_ctx,  
> > I thought we would use "_simple" ?
> >   
> 
> can we use "_easy"?
> 
> 

Yeah, "_easy" works. I just don't want to use "_lazy" which has a
different meaning in the Linux kernel.

-- Steve
