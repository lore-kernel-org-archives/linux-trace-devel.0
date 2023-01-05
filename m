Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0531CC4708E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Jan 2023 23:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbjAEXNY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 18:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjAEXNX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 18:13:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83B3676E3
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 15:13:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EC9B61C99
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 23:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FD5C433F1;
        Thu,  5 Jan 2023 23:13:19 +0000 (UTC)
Date:   Thu, 5 Jan 2023 18:13:17 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: document expected behaviour of execvp for
 record command
Message-ID: <20230105181317.32dcafa7@gandalf.local.home>
In-Reply-To: <Y7dUo6woh9Y31cdl@mail.google.com>
References: <Y7dUo6woh9Y31cdl@mail.google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 6 Jan 2023 11:52:19 +1300
Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com> wrote:

> In tracecmd/trace-record.c:<run_cmd>, trace-cmd record -F <executable>
> is launched via the libc's execvp() routine.
> 
> If you run a command which is meant to be found in one of the entries
> of the PATH env var then you should see <n> invocations of the
> __x64_sys_execve() syscall where <n> will be equal to the number of
> attempts that execvp() routine had done until it could find the
> executable.
> 
> While the routine works as expected, its behaviour can seem a bit
> cryptic for untrained eyes and makes one wonder whether there is
> something wrong in any of the parts involved in the tracing operation.
> Some time after one digs into trace-cmd's and libc's code base, one
> realises that everything is working as expected but documenting it could
> save other people's time :-)
> 
> Document the expected behaviour ftrace users should see depending on
> the way -F <executable> is used.
> 
> Signed-off-by: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
> ---
> Additional context:
> 
> - absolute path example:
> 
> 	# trace-cmd record -p function_graph \
> 		-g __x64_sys_execve -O nofuncgraph-irqs \
> 	        -n __cond_resched --max-graph-depth 1  \
> 		-F /usr/bin/echo "ftrace" > /dev/null
> 	
> 	# trace-cmd report 
> 	echo-172994 [000] 185539.798539: funcgraph_entry:      ! 803.376 us |  __x64_sys_execve();
> 
> - PATH-dependent path example:
> 
> 	# trace-cmd record -p function_graph \
> 		-g __x64_sys_execve -O nofuncgraph-irqs \
> 		-n __cond_resched --max-graph-depth 1  \
> 		-F echo "ftrace" > /dev/null
> 
> 	# trace-cmd report
>         echo-172656 [002] 185009.671586: funcgraph_entry:      ! 288.732 us |  __x64_sys_execve();
>         echo-172656 [002] 185009.671879: funcgraph_entry:      ! 158.337 us |  __x64_sys_execve();
>         echo-172656 [002] 185009.672042: funcgraph_entry:      ! 161.843 us |  __x64_sys_execve();
>         echo-172656 [002] 185009.672207: funcgraph_entry:      ! 157.656 us |  __x64_sys_execve();
>         echo-172656 [002] 185009.672369: funcgraph_entry:      ! 156.343 us |  __x64_sys_execve();
>         echo-172656 [002] 185009.672529: funcgraph_entry:      ! 863.629 us |  __x64_sys_execve();

Honestly, the above should be in the change log.

> 
> ---
>  Documentation/trace-cmd/trace-cmd-record.1.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
> index b709e48..a000cbe 100644
> --- a/Documentation/trace-cmd/trace-cmd-record.1.txt
> +++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
> @@ -113,6 +113,10 @@ OPTIONS
>      Using *-F* will let you trace only events that are caused by the given
>      command.
>  
> +    Note: if the specified filename is neither absolute or relative then libc
> +    will invoke execve() syscall for every entry in the colon-separated list of
> +    directory pathnames specified in the PATH environment variable.
> +

Hmm, do you think it may be worth open-coding execvp() and looking for it
from trace-cmd, and then only enabling tracing when it found the full path?

-- Steve


>  *-P* 'pid'::
>       Similar to *-F* but lets you specify a process ID to trace.
>  

