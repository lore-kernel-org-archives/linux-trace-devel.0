Return-Path: <SRS0=byw1=VC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4DEC4649B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 14:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C0F420856
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 14:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbfGEOTG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 10:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfGEOTG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 10:19:06 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F00B220828;
        Fri,  5 Jul 2019 14:19:04 +0000 (UTC)
Date:   Fri, 5 Jul 2019 10:19:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     tz.stoyanov@gmail.com
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: Re: [PATCH v2] trace-cmd: Add option to execute traced process as
 given user
Message-ID: <20190705101903.6b0d3406@gandalf.local.home>
In-Reply-To: <20190705135331.20705-1-tz.stoyanov@gmail.com>
References: <20190705135331.20705-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  5 Jul 2019 16:53:31 +0300
tz.stoyanov@gmail.com wrote:

> From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
> 
> A new trace-cmd record option is added: "--user". When it is set with
> combination of option -F, the traced process is executed in the context
> of the specified user.
> 

Yordan and Slavomir,

Care to review this patch?


> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> Suggested-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

Ceco,

Note, it is better to add your Signed-of-by at the end. I know things
like patchwork appear to insert everything after the Signed-off-by, and
some people do it this way, but I think its best to see all the
Signed-off-bys at the end, as they are the most important tags in the
commit log.

Some comments below.


> ---
> [
>   Should be applied on top of patch "trace-cmd: Save the tracee memory map
> into the trace.dat file."
>   
>   v2 changes:
>      - Check for errors in change_user(). If an error occurs while
>        changing the user, the message is printed and the traced 
>        process is not executed.
> ]
> 
>  Documentation/trace-cmd-record.1.txt |  4 +++
>  tracecmd/trace-record.c              | 47 ++++++++++++++++++++++++++--
>  tracecmd/trace-usage.c               |  1 +
>  3 files changed, 49 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
> index 4a59de9..df92354 100644
> --- a/Documentation/trace-cmd-record.1.txt
> +++ b/Documentation/trace-cmd-record.1.txt
> @@ -122,6 +122,10 @@ OPTIONS
>  *--mmap*::
>       Used with either *-F* or *-P*, save the traced process memory map into
>       the trace.dat file.
> +
> +*--user*::
> +     Used with -F, execute the traced process as given user.

Why does it have to be used with -F? I could see it this be useful for
recording events other than just what is being executed.


> +
>  *-C* 'clock'::
>       Set the trace clock to "clock".
>  
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 48081d4..3a37cc2 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -33,6 +33,8 @@
>  #include <errno.h>
>  #include <limits.h>
>  #include <libgen.h>
> +#include <pwd.h>
> +#include <grp.h>
>  
>  #include "version.h"
>  #include "trace-local.h"
> @@ -208,6 +210,7 @@ struct common_record_context {
>  	struct buffer_instance *instance;
>  	const char *output;
>  	char *date2ts;
> +	char *user;
>  	int data_flags;
>  
>  	int record_all;
> @@ -1417,7 +1420,34 @@ static void trace_or_sleep(enum trace_type type)
>  		sleep(10);
>  }
>  
> -static void run_cmd(enum trace_type type, int argc, char **argv)
> +static int change_user(char *user)
> +{
> +	struct passwd *pwd;
> +
> +	if (!user)
> +		return -1;

I would have this return 0, and then remove the check below, as it is
redundant.

> +
> +	pwd = getpwnam(user);
> +	if (!pwd)
> +		return -1;
> +	if (initgroups(user, pwd->pw_gid) < 0)
> +		return -1;
> +	if (setgid(pwd->pw_gid) < 0)
> +		return -1;
> +	if (setuid(pwd->pw_uid) < 0)
> +		return -1;
> +
> +	if (setenv("HOME", pwd->pw_dir, 1) < 0)
> +		return -1;
> +	if (setenv("USER", pwd->pw_name, 1) < 0)
> +		return -1;
> +	if (setenv("LOGNAME", pwd->pw_name, 1) < 0)
> +		return -1;
> +
> +	return 0;
> +}
> +
> +static void run_cmd(enum trace_type type, char *user, int argc, char **argv)
>  {
>  	int status;
>  	int pid;
> @@ -1438,6 +1468,10 @@ static void run_cmd(enum trace_type type, int argc, char **argv)
>  			dup2(save_stdout, 1);
>  			close(save_stdout);
>  		}
> +
> +		if (user && change_user(user) < 0)

With the change of !user return 0 above, we can make this:

		if (change_user(user) < 0)

> +			die("Failed to change user to %s", user);
> +
>  		if (execvp(argv[0], argv)) {
>  			fprintf(stderr, "\n********************\n");
>  			fprintf(stderr, " Unable to exec %s\n", argv[0]);
> @@ -4548,6 +4582,7 @@ void update_first_instance(struct buffer_instance *instance, int topt)
>  }
>  
>  enum {
> +	OPT_user		= 243,
>  	OPT_mmap		= 244,
>  	OPT_quiet		= 245,
>  	OPT_debug		= 246,
> @@ -4780,6 +4815,7 @@ static void parse_record_options(int argc,
>  			{"quiet", no_argument, NULL, OPT_quiet},
>  			{"help", no_argument, NULL, '?'},
>  			{"mmap", no_argument, NULL, OPT_mmap},
> +			{"user", required_argument, NULL, OPT_user},
>  			{"module", required_argument, NULL, OPT_module},
>  			{NULL, 0, NULL, 0}
>  		};
> @@ -5011,6 +5047,9 @@ static void parse_record_options(int argc,
>  		case 'i':
>  			ignore_event_not_found = 1;
>  			break;
> +		case OPT_user:
> +			ctx->user = strdup(optarg);
> +			break;
>  		case OPT_mmap:
>  			get_mmap = 1;
>  			break;
> @@ -5079,7 +5118,9 @@ static void parse_record_options(int argc,
>  	if (!ctx->filtered && ctx->instance->filter_mod)
>  		add_func(&ctx->instance->filter_funcs,
>  			 ctx->instance->filter_mod, "*");
> -
> +	if (ctx->user && !filter_task)
> +		warning("--user %s is ignored, no traced process is specified",
> +			ctx->user);

Should change this to:

	if (ctx->user && !ctx->run_command)

>  	if (filter_task && get_mmap)
>  		do_ptrace = 1;
>  
> @@ -5237,7 +5278,7 @@ static void record_trace(int argc, char **argv,
>  	}
>  
>  	if (ctx->run_command)
> -		run_cmd(type, (argc - optind) - 1, &argv[optind + 1]);
> +		run_cmd(type, ctx->user, (argc - optind) - 1, &argv[optind + 1]);
>  	else {
>  		update_task_filter();
>  		tracecmd_enable_tracing();
> diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> index c658ede..fcc314e 100644
> --- a/tracecmd/trace-usage.c
> +++ b/tracecmd/trace-usage.c
> @@ -58,6 +58,7 @@ static struct usage_help usage_help[] = {
>  		"          --max-graph-depth limit function_graph depth\n"
>  		"          --no-filter include trace-cmd threads in the trace\n"
>  		"          --mmap used with -F or -P, save the traced process memory map into the trace.dat file\n"
> +		"          --user used with -F, execute the traced process as given user\n"

Again, let's not make it only for -F

Thanks!

-- Steve

>  	},
>  	{
>  		"start",

