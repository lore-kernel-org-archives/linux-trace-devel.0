Return-Path: <SRS0=2y7b=6Y=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D47C38A2A
	for <linux-trace-devel@archiver.kernel.org>; Sun, 10 May 2020 15:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94ADC20736
	for <linux-trace-devel@archiver.kernel.org>; Sun, 10 May 2020 15:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgEJPXj convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 10 May 2020 11:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgEJPXj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 10 May 2020 11:23:39 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0322B20735;
        Sun, 10 May 2020 15:23:37 +0000 (UTC)
Date:   Sun, 10 May 2020 11:23:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Changbin Du <changbin.du@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 00/19] perf: ftrace enhancement
Message-ID: <20200510112336.444906c1@oasis.local.home>
In-Reply-To: <20200510150628.16610-1-changbin.du@gmail.com>
References: <20200510150628.16610-1-changbin.du@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 10 May 2020 23:06:09 +0800
Changbin Du <changbin.du@gmail.com> wrote:

> The perf has basic kernel ftrace support but lack support of most tracing
> options. This serias is target to enhance the perf ftrace functionality so
> that we can make full use of kernel ftrace with only perf.
> 
> In general, this serias be cataloged into two main changes:
>   1) Improve usability of existing functions. For example, we don't need to type
>      extra option to select the tracer.
>   2) Add new options to support all other ftrace functions.
> 
> Here is a glance of all ftrace functions with this serias:
>   * - improved existing options.
>   + - new added options.
> 
> $ sudo perf ftrace -h
> 
>  Usage: perf ftrace [<options>] [<command>]
>     or: perf ftrace [<options>] -- <command> [<options>]
> 
> *   -a, --all-cpus        system-wide collection from all CPUs
> +   -b, --buffer-size <n>
>                           size of per cpu buffer in kb
>     -C, --cpu <cpu>       list of cpus to monitor
> +   -d, --delay <n>       Wait <n> ms before tracing
>     -D, --graph-depth <n>
>                           Max depth for function graph tracer
> *   -G, --graph-funcs <func>
>                           Set graph filter on given functions (imply to use function_graph tracer)
>     -g, --nograph-funcs <func>
>                           Set nograph filter on given functions (imply to use function_graph tracer)
> +   -L, --list-functions  List available functions to filter
> +   -l, --long-info       Show process names, PIDs, timestamps, irq-info if available
>     -N, --notrace-funcs <func>
>                           do not trace given functions
> +   -P, --no-pager        Do not use pager
>     -p, --pid <pid>       trace on existing process id
> +   -s, --func-stack-trace
>                           Show kernel stack trace for function tracer
> +   -t, --tid <tid>       trace on existing thread id (exclusive to --pid)
>     -T, --trace-funcs <func>
>                           trace given functions only
> +   -u, --userstacktrace  Show stacktrace of the current user space thread
>     -v, --verbose         be more verbose
> +       --funcgraph-tail  Show function tails comment (function_graph only)
> +       --latency-format  displays additional information about the latency (function_graph only)
> +       --nofuncgraph-irqs
>                           Ignore functions that happen inside interrupt (function_graph only)
> +       --nosleep-time    Measure on-CPU time only (function_graph only)
> +       --trace-children  Trace children processes
> +       --tracing-thresh <n>
>                           Only show functions of which the duration is greater than <n>µs
> 

Note, we are working on making more of the trace-cmd functionality into
libraries. See this work here:

https://lore.kernel.org/r/20191219113502.28964-2-tz.stoyanov@gmail.com

Which introduces a libtracefs, that is to handle all the work needed to
interact with the tracefs directory. This will also be useful for perf
to read the event directory without having to open code that work.

I'm all for giving perf the functionality of ftrace, but I would like
to have it do so with a more generic solution that other tools could
benefit from as well.

Thanks!

-- Steve
