Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1237EC4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 22:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E48A6604D7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 22:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhG3Wbt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Jul 2021 18:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229604AbhG3Wbs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Jul 2021 18:31:48 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1F0D60524;
        Fri, 30 Jul 2021 22:31:42 +0000 (UTC)
Date:   Fri, 30 Jul 2021 18:31:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 00/17] libtracefs: Introducing tracefs_sql() to create
 synthetice events with an SQL line
Message-ID: <20210730183136.46eeb036@oasis.local.home>
In-Reply-To: <20210730221824.595597-1-rostedt@goodmis.org>
References: <20210730221824.595597-1-rostedt@goodmis.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 30 Jul 2021 18:18:07 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> FUNCTIONAL EXAMPLE:
> -------------------
> 
> After applying this patch, and installing it. If you compile the example from the man
> page (calling it sqlhist.c):
> 
>  >$ gcc -o sqlhist sqlhist.c `pkg-config --cflags --libs libtracefs`
>  >$ su
>  ># ./sqlhist -n syscall_wait -e 'select start.id, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat  
>     from sys_enter as start join sys_exit as end on start.common_pid = end.common_pid
>     where start.id != 23 && start.id != 7 && start.id != 61 && start.id != 230 &&
>           start.id != 232 && start.id != 270 && start.id != 271 && start.id != 202'
> 
> 
> (All the start.id filtering is hiding the syscalls that block for a long time)
> 
>  ># echo 'hist:keys=id.syscall,lat.buckets=10:sort=lat' > /sys/kernel/tracing/events/synthetic/syscall_wait/trigger  
> 
> <wait a while>
> 
>  ># cat /sys/kernel/tracing/events/synthetic/syscall_wait/hist  

And of course, I forgot to say what the above is doing :-p

I wanted to see how long syscalls block for. So I created a synthetic
event that connects with the starting of all system calls, with the
exit of the same system call, using the common_pid of the task as the
key to connect the two.

I record the id of the system call as well as the latency that is
recorded, and send that off to a synthetic event called "syscall_wait".

The '-e' option of the man page program sqlhist executes the command to
create the synthetic event.

Then I add a histogram to that event keying off the id (the ".syscall"
writes out the name of the system call along with the id), and the
latency "lat" grouping it in buckets of "5 microseconds", and sort it
by the latency.

I waited a while, and then reported the result.

When I first ran this, the system calls that block for a long time
filled up the histogram with useless data.  Those were the various
"poll" and "select" as well as (surprising) "futex" system call.

-- Steve
