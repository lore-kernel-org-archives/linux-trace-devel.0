Return-Path: <SRS0=j4Iw=YO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FF5CA9EAF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Oct 2019 14:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77B492084C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Oct 2019 14:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfJUOlY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 10:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbfJUOlY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 10:41:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3D0B20659;
        Mon, 21 Oct 2019 14:41:22 +0000 (UTC)
Date:   Mon, 21 Oct 2019 10:41:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Allende Imanol <iallende@ikerlan.es>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: Re: Deadlock with FTrace in child process
Message-ID: <20191021104121.769f3162@gandalf.local.home>
In-Reply-To: <DB8PR03MB5897244BE1F37E6A001C300FB66F0@DB8PR03MB5897.eurprd03.prod.outlook.com>
References: <DB8PR03MB5897244BE1F37E6A001C300FB66F0@DB8PR03MB5897.eurprd03.prod.outlook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 19 Oct 2019 07:50:53 +0000
Allende Imanol <iallende@ikerlan.es> wrote:

> I am using Ftrace in a Ultra96 (arm64) 4.19.75-cip11 and it seems that
> I have a deadlock situation. I have a simple application executed as a
> child process from a python script. The child process reads from
> /dev/urandom and writes in /dev/zero. Ftrace is set only for this child
> process.

Are you saying that ftrace is calling the blocked task?

If you don't run ftrace, the task never gets stuck?


> 
> After thousands of executions of the child process with a high IRQ and
> CPU load (it varies in the number but it is quite reproducible) - the child
> process gets blocked. But the system still is running.
> 
> The child process appears as "sleeping state" and if I try to do kill
> -18 $pid it does not change.
> 
> In this case the child process is 4197 PID.
> 
> # ps -aux | grep python
> root      1145  6.3  0.4  85448  9508 ?        S<l  00:00  23:02 python3 test_client.py
> root      4197  0.0  0.4  85448  8256 ?        S<   05:53   0:00 python3 test_client.py
> root      5279  0.0  0.0   2752   280 ttyPS0   S+   06:02   0:00 grep python
> # cat /proc/4197/stack
> [<0>] __switch_to+0x94/0xd0
> [<0>] futex_wait_queue_me+0xd0/0x150
> [<0>] futex_wait+0x12c/0x200
> [<0>] do_futex+0x304/0xc10

Looks like the task is blocked on a user space mutex (futex).

> [<0>] __arm64_sys_futex+0x154/0x190
> [<0>] el0_svc_common+0xa0/0x170
> [<0>] el0_svc_handler+0x38/0x80
> [<0>] el0_svc+0x8/0xc
> [<0>] 0xffffffffffffffff
> 
> 
> The stack is more or less the same every time the block happens.
> 
> If I kill -9 the child process the execution loop will continue with
> spawning the next child so it seems that the deadlock is really only
> in the child process - but do not know why.
> 
> I am using function_graph traces and I added the funcgraph-proc,
> noirq-info and nofuncgraphs-irq options. I disable tracing after each 
> iteration, and I clear the trace buffer and pid set also.
> 
> I add the application that is executed as the child process:

I don't understand what you meant by this. Is the below the code that
gets stuck? But the above shows a python task?

> 
> #define DEV1 "/dev/urandom"
> #define DEV2 "/dev/null"
> 
> int main(int argc, char **argv)
> {
>  unsigned char result;
>  int fd1, fd2, ret;
>  char res_str[10] = {0};
> 
>  fd1 = open(DEV1, O_RDONLY);
>  fd2 = open(DEV2, O_WRONLY);
> 
>  ret = read(fd1, &result, 1);
>  sprintf(res_str, "%d", result);
>  ret = write(fd2, res_str, strlen(res_str));
> 
>  close(fd1);
>  close(fd2);
> 
>  return ret;
> }

Can you give the full reproducer, and explain the problem in a bit more
detail. I don't really see how ftrace is involved here, besides that
you are running it.

-- Steve

> 
> The preemption configuration is set to Preemptible kernel and the Ftrace
> config is set:
> CONFIG_FTRACE=y
> CONFIG_FUNCTION_TRACER=y
> CONFIG_FUNCTION_GRAPH_TRACER=y
> # CONFIG_PREEMPTIRQ_EVENTS is not set
> # CONFIG_IRQSOFF_TRACER is not set
> # CONFIG_PREEMPT_TRACER is not set
> # CONFIG_SCHED_TRACER is not set
> # CONFIG_HWLAT_TRACER is not set
> CONFIG_FTRACE_SYSCALLS=y
> # CONFIG_TRACER_SNAPSHOT is not set
> CONFIG_BRANCH_PROFILE_NONE=y
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> # CONFIG_PROFILE_ALL_BRANCHES is not set
> CONFIG_STACK_TRACER=y
> # CONFIG_BLK_DEV_IO_TRACE is not set
> CONFIG_UPROBE_EVENTS=y
> CONFIG_PROBE_EVENTS=y
> CONFIG_DYNAMIC_FTRACE=y
> # CONFIG_FUNCTION_PROFILER is not set
> CONFIG_FTRACE_MCOUNT_RECORD=y
> # CONFIG_FTRACE_STARTUP_TEST is not set
> # CONFIG_HIST_TRIGGERS is not set
> # CONFIG_TRACEPOINT_BENCHMARK is not set
> # CONFIG_RING_BUFFER_BENCHMARK is not set
> # CONFIG_RING_BUFFER_STARTUP_TEST is not set
> # CONFIG_PREEMPTIRQ_DELAY_TEST is not set
> # CONFIG_TRACE_EVAL_MAP_FILE is not set
> CONFIG_TRACING_EVENTS_GPIO=y

