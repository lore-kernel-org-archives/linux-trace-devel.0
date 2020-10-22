Return-Path: <SRS0=yu5d=D5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CCAC2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Oct 2020 01:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 755F5223BF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Oct 2020 01:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442848AbgJVB0a (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Oct 2020 21:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2442841AbgJVB0a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Oct 2020 21:26:30 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E469C22206;
        Thu, 22 Oct 2020 01:26:28 +0000 (UTC)
Date:   Wed, 21 Oct 2020 21:26:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v24 03/10] trace-cmd: Add trace-cmd library APIs for
 ftrace clock name
Message-ID: <20201021212626.1c3436c4@oasis.local.home>
In-Reply-To: <20201009140338.25260-4-tz.stoyanov@gmail.com>
References: <20201009140338.25260-1-tz.stoyanov@gmail.com>
        <20201009140338.25260-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  9 Oct 2020 17:03:31 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Added enum with ftrace clock IDs and APIs to convert ftrace name to ID
> and vice versa, as part of libtracecmd.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h | 16 +++++++++++++
>  lib/trace-cmd/trace-util.c    | 45 +++++++++++++++++++++++++++++++++++
>  2 files changed, 61 insertions(+)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index f9c1f843..393a2e7b 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -415,6 +415,22 @@ int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
>  				unsigned int *sync_msg_id,
>  				unsigned int *payload_size, char **payload);
>  
> +enum tracecmd_clocks {
> +	TRACECMD_CLOCK_UNKNOWN	= 0,
> +	TRACECMD_CLOCK_LOCAL	= 1,
> +	TRACECMD_CLOCK_GLOBAL	= 1 << 1,
> +	TRACECMD_CLOCK_COUNTER	= 1 << 2,
> +	TRACECMD_CLOCK_UPTIME	= 1 << 3,
> +	TRACECMD_CLOCK_PERF	= 1 << 4,
> +	TRACECMD_CLOCK_MONO	= 1 << 5,
> +	TRACECMD_CLOCK_MONO_RAW	= 1 << 6,
> +	TRACECMD_CLOCK_BOOT	= 1 << 7,
> +	TRACECMD_CLOCK_X86_TSC	= 1 << 8

I'm curious to why you have this as a bitmask. We can only have on
clock at a time, right?

Also, if we make it a simple counter, we can create a string as well:

#define TRACECMD_CLOCKS \
 C(UNKNOWN,	unknown),	\
 C(LOCAL,	local),	\
 C(GLOBAL,	global),\
 C(COUNTER,	counter),\
 C(UPTIME,	uptime),\
 C(PERF,	perf),	\
 C(MONO,	mono),	\
 C(MONO_RAW,	mono_raw),\
 C(BOOT,	boot,	\
 C(X86_TSC,	x86-tsc)

#undef C
#define C(a, b) TRACECMD_CLOCK_##a

enum tracecmd_clocks { TRACECMD_CLOCKS };

#undef C

> +};
> +
> +enum tracecmd_clocks tracecmd_clock_str2id(const char *clock);
> +char *tracecmd_clock_id2str(enum tracecmd_clocks clock);
> +
>  /* --- Timestamp synchronization --- */
>  
>  enum{
> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index 0ead96ea..e20362e3 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -33,6 +33,51 @@ static bool debug;
>  
>  static FILE *logfp;
>  
> +const static struct {
> +	char *clock_str;
> +	enum tracecmd_clocks clock_id;
> +} trace_clocks[] = {
> +	{"local", TRACECMD_CLOCK_LOCAL},
> +	{"global", TRACECMD_CLOCK_GLOBAL},
> +	{"counter", TRACECMD_CLOCK_COUNTER},
> +	{"uptime", TRACECMD_CLOCK_UPTIME},
> +	{"perf", TRACECMD_CLOCK_PERF},
> +	{"mono", TRACECMD_CLOCK_MONO},
> +	{"mono_raw", TRACECMD_CLOCK_MONO_RAW},
> +	{"boot", TRACECMD_CLOCK_BOOT},
> +	{"x86-tsc", TRACECMD_CLOCK_X86_TSC},
> +	{NULL, -1}
> +};

He we would have:

#define C(a, b) #b
const char * trace_clocks[] = { TRACECMD_CLOCKS }

> +
> +/**
> + * tracecmd_clock_str2id - Convert ftrace clock name to clock ID
> + * @clock: Ftrace clock name
> + * Returns ID of the ftrace clock
> + */
> +enum tracecmd_clocks tracecmd_clock_str2id(const char *clock)
> +{
	int i;

btw, in normal C, it's not recommended to declare a counter in a loop.

	for (i = 0; i < ARRAY_SIZE(trace_clocks); i++) {
		if (strcmp(trace_clocks[i], clock) == 0)
			return i;
	return 0;
}


> +	for (int i = 0; trace_clocks[i].clock_str; i++) {
> +		if (!strncmp(clock, trace_clocks[i].clock_str,
> +		    strlen(trace_clocks[i].clock_str)))
> +			return trace_clocks[i].clock_id;
> +	}
> +	return TRACECMD_CLOCK_UNKNOWN;
> +}
> +
> +/**
> + * tracecmd_clock_id2str - Convert clock ID to ftare clock name
> + * @clock: Clock ID
> + * Returns name of a ftrace clock
> + */
> +char *tracecmd_clock_id2str(enum tracecmd_clocks clock)

Should probably have this return const char *.

Such that callers wont modify it.

> +{

And here we would have:

	if (clock < ARRAY_SIZE(trace_clocks))
		return trace_clocks[i];

	return NULL;

-- Steve

> +	for (int i = 0; trace_clocks[i].clock_str; i++) {
> +		if (trace_clocks[i].clock_id == clock)
> +			return trace_clocks[i].clock_str;
> +	}
> +	return NULL;
> +}
> +
>  /**
>   * tracecmd_set_debug - Set debug mode of the tracecmd library
>   * @set_debug: The new "debug" mode. If true, the tracecmd library is

