Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A73C3DA78
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 Jan 2023 05:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjANFvU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 14 Jan 2023 00:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjANFvO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 14 Jan 2023 00:51:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125C03AA9
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Jan 2023 21:51:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9390560B41
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 Jan 2023 05:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8633C433EF;
        Sat, 14 Jan 2023 05:51:08 +0000 (UTC)
Date:   Sat, 14 Jan 2023 00:51:05 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] trace-cmd: open code execvp routine to avoid
 multiple execve syscalls
Message-ID: <20230114005105.166d54fe@rorschach.local.home>
In-Reply-To: <Y8HiIR9IrfWFG+MY@mail.google.com>
References: <20230105220727.0660a0e4@gandalf.local.home>
        <Y8HiIR9IrfWFG+MY@mail.google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 14 Jan 2023 11:58:41 +1300
Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com> wrote:

Hi Paulo,

A couple of nits about submitting a follow up patch.

1) A second patch should always start a new thread. It's easier to find
in inboxes.

If you want, you could add a link to the first thread in the "changes"
section (see below).

2) Please start the subject with a capital letter:

[PATCH v2] trace-cmd: Open code execvp routine to avoid multiple execve syscalls


> In tracecmd/trace-record.c:<run_cmd>, trace-cmd record -F <executable>
> is launched via the libc's execvp() routine. The way that execvp() routine
> works is by invoking execve syscall for every entry on the $PATH if
> command specified is neither absolute nor relative which can come across
> as a bit cryptic to untrained eyes.
> 
> - absolute path example:
> 
>         # trace-cmd record -p function_graph \
>                 -g __x64_sys_execve -O nofuncgraph-irqs \
>                 -n __cond_resched --max-graph-depth 1  \
>                 -F /usr/bin/echo "ftrace" > /dev/null
> 
>         # trace-cmd report
>         echo-172994 [000] 185539.798539: funcgraph_entry:      ! 803.376 us |  __x64_sys_execve();
> 
> - PATH-dependent path example:
> 
>         # trace-cmd record -p function_graph \
>                 -g __x64_sys_execve -O nofuncgraph-irqs \
>                 -n __cond_resched --max-graph-depth 1  \
>                 -F echo "ftrace" > /dev/null
> 
>         # trace-cmd report
>         echo-172656 [002] 185009.671586: funcgraph_entry:      ! 288.732 us |  __x64_sys_execve();
>         echo-172656 [002] 185009.671879: funcgraph_entry:      ! 158.337 us |  __x64_sys_execve();
>         echo-172656 [002] 185009.672042: funcgraph_entry:      ! 161.843 us |  __x64_sys_execve();
>         echo-172656 [002] 185009.672207: funcgraph_entry:      ! 157.656 us |  __x64_sys_execve();
>         echo-172656 [002] 185009.672369: funcgraph_entry:      ! 156.343 us |  __x64_sys_execve();
>         echo-172656 [002] 185009.672529: funcgraph_entry:      ! 863.629 us |  __x64_sys_execve();
> 
> Open code the libc's execvp routine into trace-cmd so ftrace will only
> start recording once the command is found when it needs to be found in
> PATH.
> 
> Signed-off-by: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
> ---
> Changelog:
> 
> - v2: open code execvp routine into trace-cmd. (Req. Steve Rostedt)
> - v1: https://lore.kernel.org/linux-trace-devel/Y7dUo6woh9Y31cdl@mail.google.com/
> ---
>  tracecmd/trace-record.c | 59 ++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 53 insertions(+), 6 deletions(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 7f0cebe..4a54637 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -1683,6 +1683,58 @@ static int change_user(const char *user)
>  	return 0;
>  }
>  
> +static void execute_program(int argc, char **argv)
> +{
> +	char buf[PATH_MAX + NAME_MAX + 1];	
> +	char *path_env;
> +	size_t path_len;
> +	size_t entry_len;
> +	char *ptr_start;
> +	char *ptr_end;
> +
> +	/*
> +	 * if command specified by user is neither absolute nor 
> +	 * relative than we search for it in $PATH. 
> +	 */
> +	if (!strchr(argv[0], '/') && !strchr(argv[0], '.')) {

Why the search of '.'? If you have an executable called:

   my.exec

Wouldn't that be found?

Can you have a relative path without '/'? Usually, you would do:

  ./exec

> +		path_env = getenv("PATH");

Need to check for NULL, in the rare case that no "PATH" is defined.

> +		path_len = strlen(path_env);
> +		ptr_start = path_env;
> +
> +		while ((ptr_start - path_env) < path_len) {
> +			ptr_end = strchr(ptr_start, ':');

Why not just use strtok_r() here?

Something like (untested):

		char *saveptr;

		for (path = strtok_r(path_env, ":", &saveptr);
		     path; path = strtok_r(NULL, ":", &saveptr) {

			snprintf(buf, PATH_MAX, "%s/%s", path, argv[0]);

			if (access(buf, X_OK) == 0)
				break;
		}

> +			
> +			/* single entry in PATH? */
> +			if (!ptr_end)
> +				entry_len = path_len;
> +			else
> +				entry_len = ptr_end - ptr_start;
> +
> +			strncpy(buf, ptr_start, entry_len);
> +
> +			if (buf[entry_len - 1] != '/')
> +				buf[entry_len++] = '/';
> +			
> +			strncpy(buf + entry_len, argv[0], sizeof(buf) - entry_len);
> +
> +			/* does it exist and can we execute it? */
> +			if (access(buf, X_OK) == 0)
> +				break;
> +
> +			ptr_start = ptr_end + 1;
> +		}
> +	} else {
> +		strncpy(buf, argv[0], sizeof(buf));
> +	}

Don't we want to enable tracing here?

-- Steve

> +
> +	if (execve(buf, argv, environ)) {
> +		fprintf(stderr, "\n********************\n");
> +		fprintf(stderr, " Unable to exec %s\n", argv[0]);
> +		fprintf(stderr, "********************\n");
> +		die("Failed to exec %s", argv[0]);
> +	}
> +}
> +
>  static void run_cmd(enum trace_type type, const char *user, int argc, char **argv)
>  {
>  	int status;
> @@ -1709,12 +1761,7 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
>  		if (change_user(user) < 0)
>  			die("Failed to change user to %s", user);
>  
> -		if (execvp(argv[0], argv)) {
> -			fprintf(stderr, "\n********************\n");
> -			fprintf(stderr, " Unable to exec %s\n", argv[0]);
> -			fprintf(stderr, "********************\n");
> -			die("Failed to exec %s", argv[0]);
> -		}
> +		execute_program(argc, argv);
>  	}
>  	if (fork_process)
>  		exit(0);

