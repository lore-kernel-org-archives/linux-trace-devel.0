Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56F1C00528
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Aug 2023 14:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbjHAO1g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 10:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbjHAO1e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 10:27:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D23E170D;
        Tue,  1 Aug 2023 07:27:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2183A615C6;
        Tue,  1 Aug 2023 14:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF71CC433C7;
        Tue,  1 Aug 2023 14:27:30 +0000 (UTC)
Date:   Tue, 1 Aug 2023 10:27:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ze Gao <zegao2021@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org, Ze Gao <zegao@tencent.com>
Subject: Re: [RFC PATCH v3 3/6] sched, tracing: add to report task state in
 symbolic chars
Message-ID: <20230801102729.71906f13@gandalf.local.home>
In-Reply-To: <20230801114545.GD79828@hirez.programming.kicks-ass.net>
References: <20230801090124.8050-1-zegao@tencent.com>
        <20230801090124.8050-4-zegao@tencent.com>
        <20230801114545.GD79828@hirez.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 1 Aug 2023 13:45:45 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Aug 01, 2023 at 05:01:21PM +0800, Ze Gao wrote:
> > @@ -233,6 +255,7 @@ TRACE_EVENT(sched_switch,
> >  		__field(	pid_t,	prev_pid			)
> >  		__field(	int,	prev_prio			)
> >  		__field(	long,	prev_state			)
> > +		__field(	char,	prev_state_char			)
> >  		__array(	char,	next_comm,	TASK_COMM_LEN	)
> >  		__field(	pid_t,	next_pid			)
> >  		__field(	int,	next_prio			)  
> 
> And this again will wreck everybody that consumes the raw tracepoint
> without looking at tracefs.

Nobody does that anymore, as the events change constantly, and are
different on different kernels. Powertop (the tool that caused us pain
before by using raw values) had to break down and use libtraceevent,
because it would break if there was a 32 bit version running on a 64 bit
kernel.

I've changed the offsets of raw events a few times and nobody has
complained since.

-- Steve
