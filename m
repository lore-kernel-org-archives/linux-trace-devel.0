Return-Path: <SRS0=g3Xf=24=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4F7C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93AF02087F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgAGRbs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 12:31:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728211AbgAGRbs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 12:31:48 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 475E12072A;
        Tue,  7 Jan 2020 17:31:46 +0000 (UTC)
Date:   Tue, 7 Jan 2020 12:31:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] sched/fair: Load balance aggressively for SCHED_IDLE
 CPUs
Message-ID: <20200107123144.2d6dc5a2@gandalf.local.home>
In-Reply-To: <20200107112518.fqqzldnflqxonptf@vireshk-i7>
References: <885b1be9af68d124f44a863f54e337f8eb6c4917.1577090998.git.viresh.kumar@linaro.org>
        <20200102122901.6acbf857@gandalf.local.home>
        <20200107112518.fqqzldnflqxonptf@vireshk-i7>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 7 Jan 2020 16:55:18 +0530
Viresh Kumar <viresh.kumar@linaro.org> wrote:

> Hi Steven,
> 
> On 02-01-20, 12:29, Steven Rostedt wrote:
> > On Tue, 24 Dec 2019 10:43:30 +0530
> > Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >   
> > > This is tested on ARM64 Hikey620 platform (octa-core) with the help of
> > > rt-app and it is verified, using kernel traces, that the newly
> > > SCHED_IDLE CPU does load balancing shortly after it becomes SCHED_IDLE
> > > and pulls tasks from other busy CPUs.  
> > 
> > Can you post the actual steps you used to test this and show the before
> > and after results? Then others can reproduce what you have shown and
> > even run other tests to see if this change has any other side effects.  
> 
> I have attached the json file I used on my octa-core hikey platform along with
> before/after kernelshark screenshots with this email.
> 
> The json file does following:
> 
> - it first creates 8 always running sched_idle tasks (thread-idle-X) and let
>   them spread on all 8 CPUs.
> 
> - it then creates 8 cfs tasks (thread-cfs-X) that run 50ms every 100ms which
>   will also spread on the 8 cores.
>   
>   one of these threads (thread-cfs2-7) run only 1ms instead of 50ms once every 6
>   periods. During this 6th period, a 9th task (thread-cfs3-8) wakes up.
> 
> - The 9th cfs task (thread-cfs3-8) is timed in a way that it wakes up only
>   during the 6th period of thread-cfs2-7. This thread runs 50ms every 600ms.
>   
>   Most of the time, thread-cfs3-8 doesn't wakeup on the cpu with the short
>   thread-cfs2-7 task so after 1ms, we have 1 cpu running only sched_idle task
>   and on another CPU 2 CFS tasks compete during 100ms.
>   
>   - the 9th task has to wait a full sched slice (12ms) before its 1st schedule
>   - the 2 cfs tasks that compete for the same CPU, need 100ms to complete
>     instead of 50ms (51ms in this case).
> 
> The before.jpg image shows what happened before this patch was applied. The
> thread-cfs3-8 doesn't migrate to CPU4 which was only running sched-idle stuff at
> the 6th period of thread-cfs2-7. The migration happened though when the
> thread-cfs3-8 woke up next time (after 600 ms), this isn't shown in the picture.
> 
> The after.jpg image shows what happened after this patch was applied. On the
> very first instance when thread-cfs3-8 gets a chance to run, the load balancer
> starts balancing the CPUs. It migrates lot of sched-idle tasks to CPU7 first
> (CPU7 was running thread-cfs2-7 then), and finally migrates the thread-cfs3-8
> task to CPU7.
> 
> I have done some markings on the jpg files as well to show the tasks and
> migration points.
> 
> Please lemme know in case someone needs further clarification. Thanks.
> 

Thanks. I think I was able to reproduce it. Speaking of, I'd
recommend that you download and install the latest KernelShark
(https://www.kernelshark.org), as it looks like you're still using the
pre-1.0 version (which is now deprecated). One nice feature of the
latest is that it has json session files that you can pass to others.
If you install KernelShark 1.0, then you can do:

 1) download http://rostedt.org/private/sched_idle_ks_data.tar.bz2
 2) extract it:
     $ cd /tmp
     $ wget http://rostedt.org/private/sched_idle_ks_data.tar.bz2
     $ tar xvf sched_idle_ks_data.tar.bz2
     $ cd sched_idle_ks_data
 3) Open up each of the data files and it will bring you right to
    where you want to be.
     $ kernelshark -s sched_idle_ks-before.json &
     $ kernelshark -s sched_idle_ks-after.json &

And you can see if I duplicated what you explained ;-)

-- Steve
