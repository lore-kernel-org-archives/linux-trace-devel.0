Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C593EB64DA
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 Jul 2023 00:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbjGFAU2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 20:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbjGFAUV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 20:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F82E1BC0
        for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jul 2023 17:19:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFC3061780
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jul 2023 00:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC233C433C7;
        Thu,  6 Jul 2023 00:19:56 +0000 (UTC)
Date:   Wed, 5 Jul 2023 20:19:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     avidanborisov@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] trace-cmd record: Add --daemonize
Message-ID: <20230705201955.2d3dc612@gandalf.local.home>
In-Reply-To: <20230626091635.3002827-2-avidanborisov@gmail.com>
References: <20230530045119.30c8d973@rorschach.local.home>
        <20230626091635.3002827-1-avidanborisov@gmail.com>
        <20230626091635.3002827-2-avidanborisov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 26 Jun 2023 12:16:32 +0300
avidanborisov@gmail.com wrote:

> +static void daemonize_start(void)
> +{
> +	int devnull;
> +	int status;
> +	int pid;
> +	int rc;

To keep consistent with the rest of the code, use "ret" and not "rc".

> +
> +	pid = fork();
> +	if (pid == -1)
> +		die("daemonize: fork failed");
> +
> +	if (pid == 0) { /* child */
> +		/*
> +		 * We keep stdout and stderr open to allow the user to
> +		 * see output and errors after the daemonization (the user can
> +		 * choose to supress it with >/dev/null if the user wants).
> +		 *
> +		 * No reason to keep stdin open (it might interfere with the
> +		 * shell), we redirect it to /dev/null.
> +		 */
> +		devnull = open("/dev/null", O_RDONLY);
> +		if (devnull == -1)
> +			die("daemonize: open /dev/null failed");
> +
> +		if (devnull > 0) {
> +			if (dup2(devnull, 0) == -1)
> +				die("daemonize: dup2");
> +			close(0);
> +		}
> +
> +		return;
> +
> +		/*
> +		 * The child returns to back to the caller, but the parent waits until
> +		 * SIGRTMIN is received from the child (by calling daemonize_finish()),
> +		 * or the child exits for some reason (usually an indication of
> +		 * an error), which ever comes first.
> +		 *
> +		 * Then the parent exits (with the status code of the child,
> +		 * if it finished early, or with 0 if SIGRTMIN was received),
> +		 * which causes the child (and its entire process tree) to be
> +		 * inherited by init.
> +		 *
> +		 * Note that until the child calls daemonize_finish(), it still has
> +		 * the same session id as the parent, so it can die together with
> +		 * the parent before daemonization finished (purposefully, since the
> +		 * user might send a quick Ctrl^C to cancel the command, and we don't
> +		 * want background processes staying alive in that case)
> +		 */
> +	} else { /* parent */
> +		struct sigaction sa = {
> +			/* disable SA_RESTART, to allow waitpid() to be interrupted by SIGRTMIN */
> +			.sa_flags = 0,
> +			.sa_handler = daemonize_set_child_detached
> +		};
> +
> +		if (sigemptyset(&sa.sa_mask) == -1)
> +			die("daemonize: sigemptyset failed");
> +
> +		if (sigaddset(&sa.sa_mask, SIGRTMIN) == -1)
> +			die("daemonize: sigaddset failed");
> +
> +		if (sigprocmask(SIG_UNBLOCK, &sa.sa_mask, NULL) == -1)
> +			die("daemonize: sigprocmask failed");
> +
> +		if (sigaction(SIGRTMIN, &sa, NULL) == -1)
> +			die("daemonize: sigaction failed");
> +
> +		do {
> +			rc = waitpid(pid, &status, 0);
> +		} while (!child_detached && ((rc == -1) && (errno == EINTR)));

And usually it's a bit more robust to check for less than zero, instead
of -1, not a biggy, just my preference, as I code in the kernel, and errors
are not always -1, but some other negative number (-EINTR for instance).
Also, you don't need all those parenthesis.

		} while (!child_detached && ret < 0 && errno == EINTR);

-- Steve

		

> +
> +		if (child_detached)
> +			exit(0);
> +		else if (rc == pid)
> +			exit(WIFEXITED(status));
> +		else
> +			die("daemonize: waitpid failed");
> +
> +		__builtin_unreachable();
> +	}
> +}
> +
> +static void daemonize_finish(void)
> +{
> +	/*
> +	 * setsid() will also set the sid to be the pgid to all currently
> +	 * running threads in the process group (such as the tsync thread).
> +	 */
> +	if (setsid() == -1)
> +		die("daemonize: setsid");
> +
> +	if (kill(getppid(), SIGRTMIN) == -1)
> +		die("daemonize: kill");
> +}
> +
>  static void trace_or_sleep(enum trace_type type, bool pwait)
>  {
>  	int i;
> @@ -1748,6 +1853,9 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
>  
>  		execute_program(argc, argv);
>  	}
> +
> +	if (do_daemonize)
> +		daemonize_finish();
>  	if (fork_process)
>  		exit(0);
>  	if (do_ptrace) {
> @@ -5790,6 +5898,7 @@ enum {
>  	OPT_proxy		= 261,
>  	OPT_temp		= 262,
>  	OPT_notimeout		= 264,
> +	OPT_daemonize		= 265,
>  };
>  
>  void trace_stop(int argc, char **argv)
> @@ -6217,6 +6326,7 @@ static void parse_record_options(int argc,
>  			{"file-version", required_argument, NULL, OPT_file_ver},
>  			{"proxy", required_argument, NULL, OPT_proxy},
>  			{"temp", required_argument, NULL, OPT_temp},
> +			{"daemonize", no_argument, NULL, OPT_daemonize},
>  			{NULL, 0, NULL, 0}
>  		};
>  
> @@ -6690,6 +6800,11 @@ static void parse_record_options(int argc,
>  				die("--fork option used for 'start' command only");
>  			fork_process = true;
>  			break;
> +		case OPT_daemonize:
> +			if (!IS_RECORD(ctx))
> +				die("--daemonize option used for 'record' command only");
> +			do_daemonize = true;
> +			break;
>  		case OPT_tsc2nsec:
>  			ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
>  					   &ctx->tsc2nsec.mult);
> @@ -6933,6 +7048,9 @@ static void record_trace(int argc, char **argv,
>  	struct buffer_instance *instance;
>  	struct filter_pids *pid;
>  
> +	if (do_daemonize)
> +		daemonize_start();
> +
>  	/*
>  	 * If top_instance doesn't have any plugins or events, then
>  	 * remove it from being processed.
> @@ -7051,8 +7169,15 @@ static void record_trace(int argc, char **argv,
>  				}
>  			}
>  		}
> -		/* sleep till we are woken with Ctrl^C */
> -		printf("Hit Ctrl^C to stop recording\n");
> +
> +		if (do_daemonize) {
> +			daemonize_finish();
> +			printf("Send SIGINT to pid %d to stop recording\n", getpid());
> +		} else {
> +			/* sleep till we are woken with Ctrl^C */
> +			printf("Hit Ctrl^C to stop recording\n");
> +		}
> +
>  		for_all_instances(instance) {
>  			/* If an instance is not tracing individual processes
>  			 * or there is an error while waiting for a process to
> diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> index ecb7cad..45cb4f0 100644
> --- a/tracecmd/trace-usage.c
> +++ b/tracecmd/trace-usage.c
> @@ -81,6 +81,7 @@ static struct usage_help usage_help[] = {
>  		"                        available algorithms can be listed with trace-cmd list -c\n"
>  		"          --proxy vsocket to reach the agent. Acts the same as -A (for an agent)\n"
>  		"              but will send the proxy connection to the agent.\n"
> +		"          --daemonize run trace-cmd in the background as a daemon after recording has started\n"
>  	},
>  	{
>  		"set",

