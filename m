Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9FDC00528
	for <linux-trace-devel@archiver.kernel.org>; Mon, 31 Jul 2023 15:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjGaPiO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 31 Jul 2023 11:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjGaPiO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 31 Jul 2023 11:38:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB28E0;
        Mon, 31 Jul 2023 08:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A5266117D;
        Mon, 31 Jul 2023 15:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF1BC433C8;
        Mon, 31 Jul 2023 15:38:09 +0000 (UTC)
Date:   Mon, 31 Jul 2023 11:38:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ze Gao <zegao2021@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org, Ze Gao <zegao@tencent.com>
Subject: Re: [RFC PATCH v2 1/3] sched, tracing: add to report task state in
 symbolic chars
Message-ID: <20230731113807.1a4a455c@gandalf.local.home>
In-Reply-To: <20230726121618.19198-2-zegao@tencent.com>
References: <20230726121618.19198-1-zegao@tencent.com>
        <20230726121618.19198-2-zegao@tencent.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 26 Jul 2023 20:16:16 +0800
Ze Gao <zegao2021@gmail.com> wrote:

> @@ -231,41 +253,29 @@ TRACE_EVENT(sched_switch,
>  	TP_STRUCT__entry(
>  		__array(	char,	prev_comm,	TASK_COMM_LEN	)
>  		__field(	pid_t,	prev_pid			)
> -		__field(	int,	prev_prio			)
> -		__field(	long,	prev_state			)
> +		__field(	short,	prev_prio			)
> +		__field(	int,	prev_state			)
> +		__field(	char,	prev_state_char			)
>  		__array(	char,	next_comm,	TASK_COMM_LEN	)
>  		__field(	pid_t,	next_pid			)
> -		__field(	int,	next_prio			)
> +		__field(	short,	next_prio			)
>  	),

The above adds a bunch of holes. This needs to be reordered to condense the
event, we don't want to increase it. libtraceevent will handle reordering.

The above produces:

struct {
	char	prev_comm[16];
	pid_t	prev_pid;
	short	prev_prio; <-- 2 character padding
	int	prev_state;
	char	prev_state_char;
	char	next_comm[16]; <- 3 character padding
	pid_t	next_pid;
	short	next_prio; <- 2 char padding
};

(all events are at least 4 byte aligned, and are multiple of 4 bytes in
size, thus that last short of next_prio did nothing)

The above is a total of 56 bytes (note, that is the same as the current
sched_switch event size);

What the above should be:

	TP_STRUCT__entry(
		__field(	pid_t,	prev_pid			)
		__field(	pid_t,	next_pid			)
		__field(	short,	prev_prio			)
		__field(	short,	next_prio			)
		__field(	int,	prev_state			)
		__array(	char,	prev_comm,	TASK_COMM_LEN	)
		__array(	char,	next_comm,	TASK_COMM_LEN	)
		__field(	char,	prev_state_char			)
	),


Which would be:

struct {
	pid_t	prev_pid;
	pid_t	next_pid;
	short	prev_prio;
	short	next_prio;
	int	prev_state;
	char	prev_comm[16];
	char	next_comm[16];
	char	prev_stat_char; <-- 3 characters of padding
}

which would be 52 byte. Saving us 4 bytes per event. Which is a big deal!

-- Steve

