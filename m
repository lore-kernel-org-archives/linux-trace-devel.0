Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABECEC38142
	for <linux-trace-devel@archiver.kernel.org>; Sun, 22 Jan 2023 01:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjAVBY1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 21 Jan 2023 20:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjAVBY1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 21 Jan 2023 20:24:27 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B38FF05
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 Jan 2023 17:24:25 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m3-20020a17090a414300b00229ef93c5b0so7575291pjg.2
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 Jan 2023 17:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lY0jDPONTrS3gqFOeZL+QrwD04Dk0AKyOzczBG5aPBI=;
        b=gAJRea8bVDp42/IMTYIwFEy1A/I9Wu8YiuxaAdPXkAOow7Cotnbkt49roQ7CWWkekB
         1iT1vn+YxvBmzkOjAtzITLluKsYw59o1Xt34NLq9lpofcIzl+L3GXuNeAjcBq7wrLBpy
         IdOoklfHhf6ES0fdEkq+eoEAjUQAyYMGTlB5bI6RBaXlV1n4/LQRMLfgxM8hp8n34033
         m/zdLUwjJqAZI3f908bIv+qC+ma3EWq6bYRb8mZc2o7snqXWR0oLyqkFGBUWoFYK4yM/
         gQ/wY7pX7j5c3UYb6KTL65+VLNqzXumrcKDguoNhfpNfr+Ec0ejezmrw42bW9fQHRjQl
         O2hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lY0jDPONTrS3gqFOeZL+QrwD04Dk0AKyOzczBG5aPBI=;
        b=u45po+nKzEwUnEmP7hKtTmQIMUqYxFuUYrDm4vwapMsPaJqTTm77gU5j2c/dxXNHqM
         CeHazpa/sNCggX9WZEefGNyqwtfUCcQWBgOgaRdhmuPUQNiLfJRweh1e5ROChhttCNur
         a9BG9b42fzvNfdh6o46SqbKAhJVOxI+nroYPbMkdg+gm13wsXAe3eJ3hPO6/Khz8Q17o
         T/AgMScWMDbW+u0Y+GN2VfIAAqMtSsrQndUjWO89agS7FltTEJ5PlsiMYIAxMUoZ7DLd
         hkGEWU4VX7iANxuMz5hLrwIQ0oMtrnnlmMbrkRw68RRYMWGPCdbb0+CYQdBvgxyc0jU9
         xk9A==
X-Gm-Message-State: AFqh2kosyJ9Z7D+3bETxL31zH96Q1siqe2HOJnAM6nzqPNU6TAkGFY21
        onec/1cWqt2i7u8quaF984Y8yWezCps=
X-Google-Smtp-Source: AMrXdXuM2dXbXmPANiN5AF7DCfgdoZ2Mu2FXtylz3CuCXta6arudVUu1jf9t12xWFHTiHPtqjrGJvA==
X-Received: by 2002:a17:90a:c204:b0:229:eea7:65d0 with SMTP id e4-20020a17090ac20400b00229eea765d0mr2509067pjt.4.1674350664927;
        Sat, 21 Jan 2023 17:24:24 -0800 (PST)
Received: from mail.google.com (125-237-24-141-adsl.sparkbb.co.nz. [125.237.24.141])
        by smtp.gmail.com with ESMTPSA id h1-20020a17090a470100b002194319662asm4025715pjg.42.2023.01.21.17.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jan 2023 17:24:24 -0800 (PST)
Date:   Sun, 22 Jan 2023 14:24:19 +1300
From:   Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3] trace-cmd: Open code execvp routine to avoid multiple
 execve syscalls
Message-ID: <Y8yQQ3STYn8Q83+w@mail.google.com>
References: <Y8t9JbdH9s29fyRW@mail.google.com>
 <20230121122254.53f6dfa6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230121122254.53f6dfa6@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Jan 21, 2023 at 12:22:54PM -0500, Steven Rostedt wrote:
> On Sat, 21 Jan 2023 18:50:29 +1300
> Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com> wrote:
> 
> > In tracecmd/trace-record.c:<run_cmd>, trace-cmd record -F <executable>
> > is launched via the libc's execvp() routine. The way that execvp() routine
> > works is by invoking execve syscall for every entry on the $PATH if
> > command specified is neither absolute nor relative which can come across
> > as a bit cryptic to untrained eyes.
> > 
> > - absolute path example:
> > 
> >         # trace-cmd record -p function_graph \
> >                 -g __x64_sys_execve -O nofuncgraph-irqs \
> >                 -n __cond_resched --max-graph-depth 1  \
> >                 -F /usr/bin/echo "ftrace" > /dev/null
> > 
> >         # trace-cmd report
> >         echo-172994 [000] 185539.798539: funcgraph_entry:      ! 803.376 us |  __x64_sys_execve();
> > 
> > - PATH-dependent path example:
> > 
> >         # trace-cmd record -p function_graph \
> >                 -g __x64_sys_execve -O nofuncgraph-irqs \
> >                 -n __cond_resched --max-graph-depth 1  \
> >                 -F echo "ftrace" > /dev/null
> > 
> >         # trace-cmd report
> >         echo-172656 [002] 185009.671586: funcgraph_entry:      ! 288.732 us |  __x64_sys_execve();
> >         echo-172656 [002] 185009.671879: funcgraph_entry:      ! 158.337 us |  __x64_sys_execve();
> >         echo-172656 [002] 185009.672042: funcgraph_entry:      ! 161.843 us |  __x64_sys_execve();
> >         echo-172656 [002] 185009.672207: funcgraph_entry:      ! 157.656 us |  __x64_sys_execve();
> >         echo-172656 [002] 185009.672369: funcgraph_entry:      ! 156.343 us |  __x64_sys_execve();
> >         echo-172656 [002] 185009.672529: funcgraph_entry:      ! 863.629 us |  __x64_sys_execve();
> > 
> > Open code the libc's execvp routine into trace-cmd so ftrace will only
> > start recording once the command is found when it needs to be found in
> > PATH.
> > 
> > Signed-off-by: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
> > ---
> > Changelog:
> > 
> > - v3: simplify path traversal code via strtok_r. (Req. Steven Rostedt)
> > - v2: open code execvp routine into trace-cmd. (Req. Steven Rostedt)
> > - v1: https://lore.kernel.org/linux-trace-devel/Y7dUo6woh9Y31cdl@mail.google.com/
> > ---
> >  tracecmd/trace-record.c | 48 +++++++++++++++++++++++++++++++++++------
> >  1 file changed, 41 insertions(+), 7 deletions(-)
> > 
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index 7f0cebe..c111ef6 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -1683,6 +1683,46 @@ static int change_user(const char *user)
> >  	return 0;
> >  }
> >  
> > +static void execute_program(int argc, char **argv)
> > +{
> > +	char buf[PATH_MAX + NAME_MAX + 1];
> > +	char *path;
> > +	char *entry;
> > +	char *saveptr;
> > +
> > +	/*
> > +	 * if command specified by user is neither absolute nor
> > +	 * relative than we search for it in $PATH.
> > +	 */
> > +	if (*argv[0] != '/' && *argv[0] != '.') {
> 
> All you really need to do is check if '/' exists in the name, as the path
> lookup in bash will not add PATH in such cases:
> 
>  # mkdir /usr/bin/direct
>  # cp /usr/bin/grep /usr/bin/direct
>  # direct/grep
> -bash: direct/grep: No such file or directory
> 
> So, the above really has to be just "if (strchr(argv[0], '/') == NULL)"
> 
> No need to look for '.'. As you could an application that starts with "."
> and it should not think it's a path name in such cases.
> 
> In fact, if you have a '/' in the name. It will use relative paths.
> 
>  # mv /usr/bin/direct .
>  # direct/grep -h
> Usage: grep [OPTION]... PATTERNS [FILE]...
> Try 'grep --help' for more information.
> 
> So appending PATH in such cases is incorrect, and will produce unexpected
> results.
> 
> -- Steve

You are right Steve, that case slipped through the cracks somehow. good catch :)

I will submit a new one shortly.

thanks!

- Paulo A.

> 
> > +		path = getenv("PATH");
> > +
> > +		if (!path)
> > +			die("can't search for '%s' if $PATH is NULL", argv[0]);
> > +
> > +		for (entry = strtok_r(path, ":", &saveptr);
> > +		     entry; entry = strtok_r(NULL, ":", &saveptr)) {
> > +
> > +			snprintf(buf, sizeof(buf), "%s/%s", entry, argv[0]);
> > +
> > +			/* does it exist and can we execute it? */
> > +			if (access(buf, X_OK) == 0)
> > +				break;
> > +
> > +		}
> > +	} else {
> > +		strncpy(buf, argv[0], sizeof(buf));
> > +	}
> > +
> > +	tracecmd_enable_tracing();
> > +	if (execve(buf, argv, environ)) {
> > +		fprintf(stderr, "\n********************\n");
> > +		fprintf(stderr, " Unable to exec %s\n", argv[0]);
> > +		fprintf(stderr, "********************\n");
> > +		die("Failed to exec %s", argv[0]);
> > +	}
> > +}
> > +
> >  static void run_cmd(enum trace_type type, const char *user, int argc, char **argv)
> >  {
> >  	int status;
> > @@ -1693,7 +1733,6 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
> >  	if (!pid) {
> >  		/* child */
> >  		update_task_filter();
> > -		tracecmd_enable_tracing();
> >  		if (!fork_process)
> >  			enable_ptrace();
> >  		/*
> > @@ -1709,12 +1748,7 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
> >  		if (change_user(user) < 0)
> >  			die("Failed to change user to %s", user);
> >  
> > -		if (execvp(argv[0], argv)) {
> > -			fprintf(stderr, "\n********************\n");
> > -			fprintf(stderr, " Unable to exec %s\n", argv[0]);
> > -			fprintf(stderr, "********************\n");
> > -			die("Failed to exec %s", argv[0]);
> > -		}
> > +		execute_program(argc, argv);
> >  	}
> >  	if (fork_process)
> >  		exit(0);
> 
