Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D322AC77B73
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 May 2023 08:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjE3IzK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 May 2023 04:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjE3IzJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 May 2023 04:55:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BCDBF
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 01:55:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D41E62316
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 08:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E764C433D2;
        Tue, 30 May 2023 08:55:07 +0000 (UTC)
Date:   Tue, 30 May 2023 04:55:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     avidanborisov@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/3] trace-cmd record: Add --daemonize
Message-ID: <20230530045503.467b0999@rorschach.local.home>
In-Reply-To: <20230501203118.3105605-2-avidanborisov@gmail.com>
References: <20230501203118.3105605-1-avidanborisov@gmail.com>
        <20230501203118.3105605-2-avidanborisov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  1 May 2023 23:31:16 +0300
avidanborisov@gmail.com wrote:

> +static void daemonize_start(void)
> +{
> +	int devnull;
> +	int status;
> +	int pid;
> +	int rc;
> +
> +	pid = fork();
> +	if (pid == -1)
> +		die("daemonize: fork failed");
> +
> +	if (pid == 0) { /* child */
> +		/*
> +		 * We keep stdout and stderr open to allow the user to
> +		 * see output and errors after the daemonization (he can
> +		 * choose to supress it with >/dev/null if he wants).

Please don't use "he", we do have women users.

The above should be:

		 * We keep stdout and stderr open to allow the user to
		 * see output and errors after the daemonization (the user can
		 * choose to supress it with >/dev/null if the user wants).


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

[..]

> @@ -6656,6 +6766,10 @@ static void parse_record_options(int argc,
>  				die("--fork option used for 'start' command only");
>  			fork_process = true;
>  			break;
> +		case OPT_daemonize:
> +			if (!IS_RECORD(ctx))
> +				die("--daemonize option used for 'record' command only");
> +			do_daemonize = true;

Missing "break".

I found this because I tested it on a VM that doesn't have tsc_nsec
support.

Thanks!

-- Steve

>  		case OPT_tsc2nsec:
>  			ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
>  					   &ctx->tsc2nsec.mult);
> @@ -6899,6 +7013,9 @@ static void record_trace(int argc, char **argv,
>  	struct buffer_instance *instance;
>  	struct filter_pids *pid;
>  
> +	if (do_daemonize)
> +		daemonize_start();
> +
>  	/*
>  	 * If top_instance doesn't have any plugins or events, then
>  	 * remove it from being processed.
> @@ -7017,8 +7134,15 @@ static void record_trace(int argc, char **argv,
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
> index 42a8e7d..0630e8e 100644
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

