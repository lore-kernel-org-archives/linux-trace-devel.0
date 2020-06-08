Return-Path: <SRS0=emdu=7V=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D68C433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Jun 2020 19:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93CB72068D
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Jun 2020 19:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgFHTfn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Jun 2020 15:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgFHTfn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Jun 2020 15:35:43 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 437732068D;
        Mon,  8 Jun 2020 19:35:42 +0000 (UTC)
Date:   Mon, 8 Jun 2020 15:35:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] trace-cmd: Enable "trace-cmd start" to run a
 command
Message-ID: <20200608153540.06b08942@oasis.local.home>
In-Reply-To: <20200603121506.49992-2-tz.stoyanov@gmail.com>
References: <20200603121506.49992-1-tz.stoyanov@gmail.com>
        <20200603121506.49992-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  3 Jun 2020 15:15:02 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> There is a resrtiction of "trace-cmd start" which does not allow it to
> run a command, specified by "-F" option or at the end of the command
> line. However, there are use cases where this is useful.
> The resrtiction is removed, it allows "trace-cmd start" to run commands
> just like "trace-cmd record".
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  Documentation/trace-cmd-start.1.txt |  2 +-
>  tracecmd/trace-record.c             | 28 ++++++++++++++++++++--------
>  tracecmd/trace-usage.c              |  2 +-
>  3 files changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/trace-cmd-start.1.txt b/Documentation/trace-cmd-start.1.txt
> index 2b027b01..63d2034c 100644
> --- a/Documentation/trace-cmd-start.1.txt
> +++ b/Documentation/trace-cmd-start.1.txt
> @@ -21,7 +21,7 @@ system or can be extracted with trace-cmd-extract(1).
>  OPTIONS
>  -------
>  The options are the same as 'trace-cmd-record(1)', except that it does not
> -take options specific to recording (*-s*, *-o*, *-F*, *-N*, and *-t*).
> +take options specific to recording (*-s*, *-o*, *-N*, and *-t*).
>  
>  SEE ALSO
>  --------
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 3242368e..f345c6d6 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -1598,7 +1598,8 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
>  		/* child */
>  		update_task_filter();
>  		tracecmd_enable_tracing();
> -		enable_ptrace();
> +		if (type != TRACE_TYPE_START)
> +			enable_ptrace();
>  		/*
>  		 * If we are using stderr for stdout, switch
>  		 * it back to the saved stdout for the code we run.
> @@ -1619,6 +1620,8 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
>  			die("Failed to exec %s", argv[0]);
>  		}
>  	}
> +	if (type & TRACE_TYPE_START)
> +		exit(0);

After playing with this a bit, I think we should not just fork and
ignore the executable. We should wait for it to finish. This means we
can be able to ptrace via trace-cmd start as well.

The reason I say this, is the few times I used it, I didn't think it
was working. For example, I did:

 # trace-cmd start -e all ls -ltr /bin

And it returned then printed the output of ls. Because of that, it
looked like it hung:

[root@bxtest ~]# trace-cmd start -e all ls -ltr ~/bin
[root@bxtest ~]# total 48716
-rwxr-xr-x 1 root root    50320 Apr 24 18:12 bootconfig
-rwxr-xr-x 3 root root 24902584 May 27 12:31 trace
-rwxr-xr-x 3 root root 24902584 May 27 12:31 perf
-rwxr-xr-x 1 root root    20860 May 27 12:31 perf-read-vdso32

And I'm waiting there for my prompt, not noticing that the prompt was
already printed before the output.

Although, we are not recording, it should by default wait for the
execed program to finish. We can add an option to change that, like:

 # trace-cmd start --fork -e all ls -ltr ~/bin

Which would let the user to explicitly ask for this behavior. But it
shouldn't be the default behavior. I basically think it hangs each time
I do this, even though I know why it does this.

-- Steve




>  	if (do_ptrace) {
>  		ptrace_attach(NULL, pid);
>  		ptrace_wait(type);
> @@ -5782,6 +5785,14 @@ static void add_arg(struct buffer_instance *instance,
>  	/* Not found? */
>  }
>  
> +static inline void cmd_check_die(struct common_record_context *ctx,
> +				 enum trace_cmd id, char *cmd, char *param)
> +{
> +	if (ctx->curr_cmd == id)
> +		die("%s has no effect with the command %s\n"
> +		    "Did you mean 'record'?", param, cmd);
> +}
> +
>  static void parse_record_options(int argc,
>  				 char **argv,
>  				 enum trace_cmd curr_cmd,
> @@ -6114,6 +6125,7 @@ static void parse_record_options(int argc,
>  				die("Failed to allocate user name");
>  			break;
>  		case OPT_procmap:
> +			cmd_check_die(ctx, CMD_start, *(argv+1), "--proc-map");
>  			ctx->instance->get_procmap = 1;
>  			break;
>  		case OPT_date:
> @@ -6221,9 +6233,6 @@ static void parse_record_options(int argc,
>  		die(" -c can only be used with -F (or -P with event-fork support)");
>  
>  	if ((argc - optind) >= 2) {
> -		if (IS_START(ctx))
> -			die("Command start does not take any commands\n"
> -			    "Did you mean 'record'?");
>  		if (IS_EXTRACT(ctx))
>  			die("Command extract does not take any commands\n"
>  			    "Did you mean 'record'?");
> @@ -6244,6 +6253,9 @@ static void parse_record_options(int argc,
>  		}
>  	}
>  
> +	if (do_ptrace && IS_START(ctx))
> +		die("ptrace not supported with command start");
> +
>  	for_all_instances(instance) {
>  		if (instance->get_procmap && !instance->nr_filter_pids) {
>  			warning("--proc-map is ignored for instance %s, "
> @@ -6410,10 +6422,6 @@ static void record_trace(int argc, char **argv,
>  		signal(SIGINT, finish);
>  		if (!latency)
>  			start_threads(type, ctx);
> -	} else {
> -		update_task_filter();
> -		tracecmd_enable_tracing();
> -		exit(0);
>  	}
>  
>  	if (ctx->run_command) {
> @@ -6428,6 +6436,10 @@ static void record_trace(int argc, char **argv,
>  
>  		update_task_filter();
>  		tracecmd_enable_tracing();
> +
> +		if (type & TRACE_TYPE_START)
> +			exit(0);
> +
>  		/* We don't ptrace ourself */
>  		if (do_ptrace) {
>  			for_all_instances(instance) {
> diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> index d43ca490..58bca9e4 100644
> --- a/tracecmd/trace-usage.c
> +++ b/tracecmd/trace-usage.c
> @@ -69,7 +69,7 @@ static struct usage_help usage_help[] = {
>  		"start",
>  		"start tracing without recording into a file",
>  		" %s start [-e event][-p plugin][-d][-O option ][-P pid]\n"
> -		"          Uses same options as record, but does not run a command.\n"
> +		"          Uses same options as record.\n"
>  		"          It only enables the tracing and exits\n"
>  	},
>  	{

