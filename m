Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:59166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964792AbeALPrb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 10:47:31 -0500
Date: Fri, 12 Jan 2018 10:47:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] trace-cmd: Making stat to report when the stack
 tracer is ON
Message-ID: <20180112104728.2f7d93b1@gandalf.local.home>
In-Reply-To: <20171221152520.25867-4-vladislav.valtchev@gmail.com>
References: <20171221152520.25867-1-vladislav.valtchev@gmail.com>
        <20171221152520.25867-4-vladislav.valtchev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 21 Dec 2017 17:25:20 +0200
"Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com> wrote:

> trace-cmd stat is a handy way for users to see what tracing is currently going
> on, but currently it does not say anything about the stack tracing. This patch
> makes the command to show a message when the stack tracer is ON.
> 
> Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
> ---
>  trace-cmd.h   | 2 ++
>  trace-stack.c | 6 ++++++
>  trace-stat.c  | 8 ++++++++
>  3 files changed, 16 insertions(+)
> 
> diff --git a/trace-cmd.h b/trace-cmd.h
> index 6fd34d7..9704b2e 100644
> --- a/trace-cmd.h
> +++ b/trace-cmd.h
> @@ -358,6 +358,8 @@ void tracecmd_free_hooks(struct hook_list *hooks);
>  /* --- Hack! --- */
>  int tracecmd_blk_hack(struct tracecmd_input *handle);
>  
> +/* --- Stack tracer functions --- */
> +int tracecmd_stack_tracer_status(int *status);
>  
>  /* --- Debugging --- */
>  struct kbuffer *tracecmd_record_kbuf(struct tracecmd_input *handle,
> diff --git a/trace-stack.c b/trace-stack.c
> index d55d994..0028ecc 100644
> --- a/trace-stack.c
> +++ b/trace-stack.c
> @@ -107,6 +107,12 @@ static int read_proc(int *status)
>  	return 1; /* full success */
>  }
>  
> +/* Public wrapper of read_proc() */
> +int tracecmd_stack_tracer_status(int *status)
> +{
> +	return read_proc(status);
> +}
> +
>  /* NOTE: this implementation only accepts new_status in the range [0..9]. */
>  static void change_stack_tracer_status(int new_status)
>  {
> diff --git a/trace-stat.c b/trace-stat.c
> index fd16354..61dd41f 100644
> --- a/trace-stat.c
> +++ b/trace-stat.c
> @@ -894,6 +894,7 @@ void trace_stat (int argc, char **argv)
>  	struct buffer_instance *instance = &top_instance;
>  	int topt = 0;
>  	int c;
> +	int stack_tracer_status;

Needs to be upside down x-mas tree. (can't you feel the season?) ;-)

Not to mention, it's an awfully verbose variable name. Just call it
"status".

>  
>  	for (;;) {
>  		c = getopt(argc-1, argv+1, "tB:");
> @@ -928,5 +929,12 @@ void trace_stat (int argc, char **argv)
>  		stat_instance(instance);
>  	}
>  
> +	if (tracecmd_stack_tracer_status(&stack_tracer_status) >= 0) {
> +		if (stack_tracer_status > 0)
> +			printf("Stack tracing is enabled\n\n");
> +	} else {
> +		printf("The status of the stack tracer is indeterminate\n\n");

I wonder if we should report saying there was an error?

	printf("Error reading stack tracer status\n");

-- Steve

> +	}
> +
>  	exit(0);
>  }
