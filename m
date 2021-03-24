Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8260C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 15:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81BAA61A06
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 15:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbhCXPUL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 11:20:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236621AbhCXPUD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 11:20:03 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32B4B61A06;
        Wed, 24 Mar 2021 15:20:03 +0000 (UTC)
Date:   Wed, 24 Mar 2021 11:20:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 06/23] trace-cmd: Add new trace-cmd clock tsc2nsec
Message-ID: <20210324112001.0d897bdb@gandalf.local.home>
In-Reply-To: <20210324130418.436206-7-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
        <20210324130418.436206-7-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Mar 2021 15:04:01 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -199,6 +200,12 @@ struct filter_pids {
>  	int exclude;
>  };
>  
> +struct tsc_nsec {
> +	int mult;
> +	int shift;
> +	unsigned long long offset;
> +};
> +
>  struct buffer_instance {
>  	struct buffer_instance	*next;
>  	char			*name;
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 5f7f5b3d..2a594736 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -57,6 +57,8 @@
>  #define MAX_LATENCY	"tracing_max_latency"
>  #define STAMP		"stamp"
>  #define FUNC_STACK_TRACE "func_stack_trace"
> +#define TSC_CLOCK	"x86-tsc"
> +#define TSCNSEC_CLOCK	"tsc2nsec"
>  
>  enum trace_type {
>  	TRACE_TYPE_RECORD	= 1,
> @@ -198,6 +200,7 @@ struct common_record_context {
>  	char *date2ts;
>  	char *user;
>  	int data_flags;
> +	struct tsc_nsec tsc2nsec;

struct tsc_nsec is 16 bytes in size, ending with a 8 byte word. It should
be added before the "int data_flags" to prevent a hole in the middle of
this struct.


>  
>  	int record_all;
>  	int total_disable;


> @@ -5904,7 +5965,15 @@ static void parse_record_options(int argc,
>  			break;
>  		case 'C':
>  			check_instance_die(ctx->instance, "-C");
> -			ctx->instance->clock = optarg;
> +			if (!strncmp(optarg, TSCNSEC_CLOCK, strlen(TSCNSEC_CLOCK))) {

Hmm, why the strncmp()? Shouldn't it be a full match, not a partial one?

> +				ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
> +						   &ctx->tsc2nsec.mult);
> +				if (ret || !clock_is_supported(NULL, TSC_CLOCK))
> +					die("Clock %s is not supported", optarg);
> +				ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
> +				ctx->instance->clock = strdup(TSC_CLOCK);

Hmm, why the strdup? below we have clock = optarg, one of them is wrong. If
we free instance->clock, then we can't have it set to optarg. As that was
the way it was before, it looks to be a separate bug that probably needs
its own patch.

> +			} else
> +				ctx->instance->clock = optarg;

Actually, I think we should have the above be:

		case 'C':
			if (strcmp(optarg, TSCNSEC_CLOCK) == 0) {
				ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
						   &ctx->tsc2nsec.mult);
				if (ret)
					die("TSC to nanosecond is not supported");

				ctx->instance->clock = TSC_CLOCK;
			} else {
				ctx->instance->clock = optarg;
			}
			if (!clock_is_supported(ctx->instance->clock))
				die("Clock %s is not supported",
				    ctx->instance->clock);
			ctx->instance->clock = strdup(ctx->instance->clock);
			if (!ctx->instance->clock)
				die("Failed allocation");

The above is more informative about the reason for the error, and also
removes duplicate code in the check of supported clocks.

-- Steve


>  			ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
>  			if (is_top_instance(ctx->instance))
>  				guest_sync_set = true;
> @@ -6159,6 +6228,13 @@ static void parse_record_options(int argc,
>  				die("--fork option used for 'start' command only");
>  			fork_process = true;
>  			break;
> +		case OPT_tsc2nsec:
> +			ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
> +					   &ctx->tsc2nsec.mult);
> +			if (ret)
> +				die("TSC to nanosecond is not supported");
> +			ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
> +			break;
>  		case OPT_quiet:
>  		case 'q':
>  			quiet = true;
