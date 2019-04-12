Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07ADAC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 15:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D698B2171F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 15:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfDLPPt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 11:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbfDLPPt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 11:15:49 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17BBE2084D;
        Fri, 12 Apr 2019 15:15:48 +0000 (UTC)
Date:   Fri, 12 Apr 2019 11:15:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Josef Bacik <jbacik@fb.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: Re: trace-cmd fails with many cpus
Message-ID: <20190412111546.0c54576e@gandalf.local.home>
In-Reply-To: <20190412135333.GB6201@pauld.bos.csb>
References: <20190412135333.GB6201@pauld.bos.csb>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 09:53:33 -0400
Phil Auld <pauld@redhat.com> wrote:

> Hi,
> 
> I was trying to get some sched traces on a 160 cpu box yesterday. Trace-cmd 
> failed with 

Thanks for the report!

> 
> # ./tracecmd/trace-cmd record -e "sched:*" sleep 2
> none
> trace-cmd: Invalid argument
>   Failed filter of /sys/kernel/tracing/events/sched/sched_switch/filter
> 
> trace-cmd: No such file or directory
>   can not stat 'trace.dat.cpu0'
> #
> 
> 
> Which can be seen better with strace
> 
> [pid 97653] open("/sys/kernel/tracing/events/sched/sched_swap_numa/filter", O_WRONLY|O_TRUNC) = 5
> [pid 97653] write(5, "(common_pid!=97652)&&(common_pid"..., 3358) = 3358
> [pid 97653] close(5)                    = 0
> [pid 97653] open("/sys/kernel/tracing/events/sched/sched_switch/filter", O_WRONLY|O_TRUNC) = 5
> [pid 97653] write(5, "(common_pid!=97652)&&(common_pid"..., 6398) = -1 EINVAL (Invalid argument)
> [pid 97653] close(5)                    = 0
> 
> The filter file can only take a max write of length PAGE_SIZE. 

Ah yeah. By default we try not to trace the recorders. Newer kernels
have a set_event_pid which is used for only tracing specific tasks for
the events. I wonder if we should allow for "!pid" to be sent to that
file as something to not be traced?

But that doesn't help you now.

Hmm, I thought we had an option to disable this, but I don't see one.
That's the first thing we should do. Add an option such that you record
all events, even the threads (which is something I would definitely
want!).

> 
> The extra pid filtering added for "next_pid"  more or less doubles length
> and pushes it over the 4k limit. 
> 
> WRITE: /sys/kernel/tracing/events/sched/sched_switch/filter, len 6718, data "(common_pid!=100199)&&(common_pid!=100198)&&(common_pid!=100197)&&(common_pid!=100196)&&(common_pid!=100195)&&(common_pid!=100194)&&(common_pid!=100193)&&(common_pid!=100192)&&(common_pid!=100191) ... 160 of these ...
> &&(common_pid!=100040)||(next_pid!=100199)&&(next_pid!=100198)&&(next_pid!=100197)&&(next_pid!=100196)&&(next_pid!=100195)&&(next_pid!=100194)&&(next_pid!=100193)&&(next_pid!=100192)...  160 of these...
> 
> 
> I suppose the answer is don't run on a system with that many cpus  :)
> 
> But I wonder if it would be possible to have the threads each handle say 8 cpu
> files or something.

Actually, I think another solution is to consolidate the pids that are
to be excluded and sort them. Thus if we have (which is very likely the
case)

 (common_pid!=1000)&&(common_pid!=1001)&&(common_pid!=1002)

That we change that to:

  !((common_pid>=1000)||(common_pid<=1002))

Which would also have the affect of improving the filter logic within
the kernel as well.

Tzvetomir or Slavomir, would either of you be able to implement the
above? Both adding an option to disable this (--no-filter) and the
sorting of the excluded pids?

Thanks!

-- Steve


> 
> Or maybe have the kernel filter accept an "all_pid" that covered common_pid, next_pid, pid to reduce
> the number of items needed in there? 
> 

