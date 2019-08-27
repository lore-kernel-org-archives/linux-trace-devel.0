Return-Path: <SRS0=NWyF=WX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA603C3A5A6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Aug 2019 23:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C9D8214DA
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Aug 2019 23:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfH0Xbl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 19:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfH0Xbl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 19:31:41 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4584D214DA;
        Tue, 27 Aug 2019 23:31:39 +0000 (UTC)
Date:   Tue, 27 Aug 2019 19:31:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] trace-cmd: Extend ptrace logic to work with
 multiple filtered pids
Message-ID: <20190827193137.2e5f22fe@gandalf.local.home>
In-Reply-To: <20190814084712.28188-11-tz.stoyanov@gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
        <20190814084712.28188-11-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 14 Aug 2019 11:47:10 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> In the trace-record.c file there is a global variable named "filter_pid".
> It is not set anywhere in the code, but there is a logic which relies on it.
> This variable is a leftover from the past implementation of trace-cmd
> record "-P" option, when it was designed to filter only a single PID.
> Now "-P" option works with a list of PIDs, stored in filter_pids global
> list. The code is modified to work with filter_pids instead of filter_pid.
> This logic is used only if there is no ftrace "options/event-fork" on the
> system and we have ptrace support. There is one significant change in
> the trace-cmd record behavior in this specific use case:
>   - filtered pids are specified with the "-P" option.
>   - there is no ftrace "options/event-fork" on the system.
>   - there is ptrace support.
> The trace continues until Ctrl^C is hit or all filtered PIDs exit,
> whatever comes first.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-record.c | 65 ++++++++++++++++++++++++++++++++---------
>  1 file changed, 52 insertions(+), 13 deletions(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 5dc6f17..e0fa07d 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -86,7 +86,6 @@ static bool use_tcp;
>  static int do_ptrace;
>  
>  static int filter_task;
> -static int filter_pid = -1;
>  static bool no_filter = false;
>  
>  static int local_cpu_count;
> @@ -866,6 +865,13 @@ static void add_filter_pid(int pid, int exclude)
>  	struct filter_pids *p;
>  	char buf[100];
>  
> +	for (p = filter_pids; p; p = p->next) {
> +		if (p->pid == pid) {
> +			p->exclude = exclude;
> +			return;
> +		}
> +	}
> +
>  	p = malloc(sizeof(*p));
>  	if (!p)
>  		die("Failed to allocate pid filter");
> @@ -1223,17 +1229,34 @@ static void enable_ptrace(void)
>  	ptrace(PTRACE_TRACEME, 0, NULL, 0);
>  }
>  
> -static void ptrace_wait(enum trace_type type, int main_pid)
> +static void ptrace_wait(enum trace_type type)
>  {
> +	struct filter_pids *fpid;
>  	unsigned long send_sig;
>  	unsigned long child;
>  	siginfo_t sig;
> +	int main_pids;
>  	int cstatus;
>  	int status;
> +	int i = 0;
> +	int *pids;
>  	int event;
>  	int pid;
>  	int ret;
>  
> +	pids = calloc(nr_filter_pids, sizeof(int));
> +	if (!pids)

Probably at the minimum, we should add a warning here that it didn't
get allocated.

> +		return;
> +
> +	for (fpid = filter_pids; fpid; fpid = fpid->next) {
> +		if (fpid->exclude)
> +			continue;
> +		pids[i++] = fpid->pid;
> +		if (i >= nr_filter_pids)
> +			break;
> +	}
> +	main_pids = i;
> +
>  	do {
>  		ret = trace_waitpid(type, -1, &status, WSTOPPED | __WALL);
>  		if (ret < 0)
> @@ -1275,11 +1298,24 @@ static void ptrace_wait(enum trace_type type, int main_pid)
>  			       PTRACE_O_TRACEEXIT);
>  			ptrace(PTRACE_CONT, pid, NULL, send_sig);
>  		}
> -	} while (!finished && ret > 0 &&
> -		 (!WIFEXITED(status) || pid != main_pid));
> +		if (WIFEXITED(status) ||
> +		   (WIFSTOPPED(status) && event == PTRACE_EVENT_EXIT)) {
> +			for (i = 0; i < nr_filter_pids; i++) {
> +				if (pid == pids[i]) {
> +					pids[i] = 0;
> +					main_pids--;
> +					if (!main_pids)
> +						finished = 1;
> +					break;
> +				}
> +			}
> +		}
> +	} while (!finished && ret > 0);
> +
> +	free(pids);
>  }
>  #else
> -static inline void ptrace_wait(enum trace_type type, int main_pid) { }
> +static inline void ptrace_wait(enum trace_type type) { }
>  static inline void enable_ptrace(void) { }
>  static inline void ptrace_attach(int pid) { }
>  
> @@ -1289,8 +1325,8 @@ static void trace_or_sleep(enum trace_type type)
>  {
>  	struct timeval tv = { 1 , 0 };
>  
> -	if (do_ptrace && filter_pid >= 0)
> -		ptrace_wait(type, filter_pid);
> +	if (do_ptrace && filter_pids)
> +		ptrace_wait(type);
>  	else if (type & TRACE_TYPE_STREAM)
>  		trace_stream_read(pids, recorder_threads, &tv);
>  	else
> @@ -1327,7 +1363,7 @@ static void run_cmd(enum trace_type type, int argc, char **argv)
>  	}
>  	if (do_ptrace) {
>  		add_filter_pid(pid, 0);
> -		ptrace_wait(type, pid);
> +		ptrace_wait(type);
>  	} else
>  		trace_waitpid(type, pid, &status, 0);
>  }
> @@ -2318,7 +2354,7 @@ create_event(struct buffer_instance *instance, char *path, struct event_list *ol
>  	*event = *old_event;
>  	add_event(instance, event);
>  
> -	if (event->filter || filter_task || filter_pid) {
> +	if (event->filter || filter_task || filter_pids) {
>  		event->filter_file = strdup(path);
>  		if (!event->filter_file)
>  			die("malloc filter file");
> @@ -4924,9 +4960,9 @@ static void parse_record_options(int argc,
>  		add_func(&ctx->instance->filter_funcs,
>  			 ctx->instance->filter_mod, "*");
>  
> -	if (do_ptrace && !filter_task && (filter_pid < 0))
> +	if (do_ptrace && !filter_task && !nr_filter_pids)
>  		die(" -c can only be used with -F (or -P with event-fork support)");
> -	if (ctx->do_child && !filter_task &&! filter_pid)
> +	if (ctx->do_child && !filter_task && !nr_filter_pids)
>  		die(" -c can only be used with -P or -F");
>  
>  	if ((argc - optind) >= 2) {
> @@ -4997,6 +5033,7 @@ static void record_trace(int argc, char **argv,
>  {
>  	enum trace_type type = get_trace_cmd_type(ctx->curr_cmd);
>  	struct buffer_instance *instance;
> +	struct filter_pids *pid;
>  
>  	/*
>  	 * If top_instance doesn't have any plugins or events, then
> @@ -5083,8 +5120,10 @@ static void record_trace(int argc, char **argv,
>  		update_task_filter();
>  		tracecmd_enable_tracing();
>  		/* We don't ptrace ourself */
> -		if (do_ptrace && filter_pid >= 0)
> -			ptrace_attach(filter_pid);
> +		if (do_ptrace && filter_pids)
> +			for (pid = filter_pids; pid; pid = pid->next)
> +				if (!pid->exclude)
> +					ptrace_attach(pid->pid);

Just a nit, the above should have brackets. Leaving off brackets is
fine for non complex blocks. That is, only the internal if should have
no brackets:

	if (do_ptrace && filter_pids) {
		for (pid = filter_pids; pid; pid = pid->next) {
			if (!pid->exclude)
				ptrace_attach(pid->pid);
		}
	}

Otherwise mistakes can easily be made.

-- Steve


>  		/* sleep till we are woken with Ctrl^C */
>  		printf("Hit Ctrl^C to stop recording\n");
>  		while (!finished)

