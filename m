Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4701BC47257
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 20:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21F8F205ED
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 20:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgEDUaF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 16:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727890AbgEDUaD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 16:30:03 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1963D205ED;
        Mon,  4 May 2020 20:30:03 +0000 (UTC)
Date:   Mon, 4 May 2020 16:30:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] trace-cmd: Do not try to update parent's memory
 from a fork()-ed child
Message-ID: <20200504163001.0ce5629d@gandalf.local.home>
In-Reply-To: <20200504062711.107867-5-tz.stoyanov@gmail.com>
References: <20200504062711.107867-1-tz.stoyanov@gmail.com>
        <20200504062711.107867-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  4 May 2020 09:27:11 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> When trace-cmd runs a command, specified with the "-F" flag, it forks a
> child process and executes the command in its context. This child process
> receives a full copy of the parents memory at the moment of fork(). When
> it modifies this copy, the parent memory is not affected. Calling the
> function update_task_filter() in the child context will operate on a valid
> data, but will not update anything in the parent's databases.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-record.c | 64 +++++++++++++++++++++++++++++++++--------
>  1 file changed, 52 insertions(+), 12 deletions(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 1e4d38fa..ae8a5745 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -11,6 +11,7 @@
>  #include <stdarg.h>
>  #include <getopt.h>
>  #include <time.h>
> +#include <semaphore.h>

OK, first things first. Do not use semaphores. I think I mentioned this to
you before. Semaphores are a horrible interface, and should be avoided at
all costs! ;-)

Also, I don't think you are solving the bug you think you are ;-)

With today's code (without this patch), I can run:

 # trace-cmd record -e exceptions -e sched -e irq --proc-map ls

And for that result I can do:

 # trace-cmd dump --options
[..]
                [Option PROCMAPS, 2383 bytes]
a10 30 /usr/bin/ls
556850495000 556850499000 /usr/bin/ls
556850499000 5568504ad000 /usr/bin/ls
5568504ad000 5568504b6000 /usr/bin/ls
5568504b6000 5568504b8000 /usr/bin/ls
5568504b8000 5568504b9000 /usr/bin/ls
556850c60000 556850c81000 [heap]
7efce4a9b000 7efcf1a45000 /usr/lib/locale/locale-archive
7efcf1a49000 7efcf1a4f000 /usr/lib64/libpthread-2.28.so
7efcf1a4f000 7efcf1a5f000 /usr/lib64/libpthread-2.28.so
7efcf1a5f000 7efcf1a65000 /usr/lib64/libpthread-2.28.so
7efcf1a65000 7efcf1a66000 /usr/lib64/libpthread-2.28.so
7efcf1a66000 7efcf1a67000 /usr/lib64/libpthread-2.28.so
[..]

What is it that you are fixing? Remember, if we run --proc-map, we enable
ptrace. Which at the end of its execution we have:

			case PTRACE_EVENT_EXIT:
				if (get_procmap)
					get_pid_addr_maps(pid);

Where the code records the proc_map of the -F process when it exits.

The only thing this patch is saving, is the wasted time of updating the
procmaps from the child. And to stop that, all you need is this:

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1e4d38fa..4d647887 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1187,7 +1187,7 @@ static void get_filter_pid_maps(void)
 	}
 }
 
-static void update_task_filter(void)
+static void update_task_filter(bool do_procmaps)
 {
 	struct buffer_instance *instance;
 	int pid = getpid();
@@ -1195,7 +1195,7 @@ static void update_task_filter(void)
 	if (no_filter)
 		return;
 
-	if (get_procmap && filter_pids)
+	if (do_procmaps && get_procmap && filter_pids)
 		get_filter_pid_maps();
 
 	if (filter_task)
@@ -1496,7 +1496,7 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 		die("failed to fork");
 	if (!pid) {
 		/* child */
-		update_task_filter();
+		update_task_filter(false);
 		tracecmd_enable_tracing();
 		enable_ptrace();
 		/*
@@ -6285,7 +6285,7 @@ static void record_trace(int argc, char **argv,
 		if (!latency)
 			start_threads(type, ctx);
 	} else {
-		update_task_filter();
+		update_task_filter(true);
 		tracecmd_enable_tracing();
 		exit(0);
 	}
@@ -6293,11 +6293,11 @@ static void record_trace(int argc, char **argv,
 	if (ctx->run_command) {
 		run_cmd(type, ctx->user, (argc - optind) - 1, &argv[optind + 1]);
 	} else if (ctx->instance && is_agent(ctx->instance)) {
-		update_task_filter();
+		update_task_filter(true);
 		tracecmd_enable_tracing();
 		tracecmd_msg_wait_close(ctx->instance->msg_handle);
 	} else {
-		update_task_filter();
+		update_task_filter(true);
 		tracecmd_enable_tracing();
 		/* We don't ptrace ourself */
 		if (do_ptrace && filter_pids) {

-- Steve
