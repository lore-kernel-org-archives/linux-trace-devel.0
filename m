Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CBFC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 21:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A9A561574
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 21:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236811AbhCXVQC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 17:16:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233583AbhCXVP6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 17:15:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA47261574;
        Wed, 24 Mar 2021 21:15:57 +0000 (UTC)
Date:   Wed, 24 Mar 2021 17:15:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 21/23] trace-cmd: Get current clock for host-guest
 tracing session
Message-ID: <20210324171556.47b8065f@gandalf.local.home>
In-Reply-To: <20210324130418.436206-22-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
        <20210324130418.436206-22-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Mar 2021 15:04:16 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> In host-guest tracing session, all peers should use the same tracing
> clock. If there is no user configured trace clock, the current logic
> assumes "local" clock for the session. This could be wrong, as other
> clock than "local" could be already configured on the host, before
> running trace-cmd. The default clock for host-guest tracing session
> should be rertieved from the host's "trace_clock" file.

Actually this is wrong. If clock is not specified, you should check the
first instance, because if the user does:

 # trace-cmd start -B foo -p nop -C myclock

 # trace-cmd record -B foo -e kvm -e sched -A Guest -e all

It should not use the clock from the top instance, but instead the first
instance.

I'm trying to make sure tha trace-cmd does not affect or even use the top
instance if it is not part of the command line.

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-record.c | 40 ++++++++++++++++++++++++++++++----------
>  1 file changed, 30 insertions(+), 10 deletions(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index f90fdbe4..2fc6723a 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -6455,11 +6455,12 @@ static void get_tsc_offset(struct common_record_context *ctx)
>  
>  static void set_tsync_params(struct common_record_context *ctx)
>  {
> -	const char *clock = ctx->clock;
>  	struct buffer_instance *instance;
>  	int shift, mult;
>  	bool force_tsc = false;
> +	char *clock = NULL;
>  
> +	if (!ctx->clock) {
>  	/*
>  	 * If no clock is configured &&
>  	 * KVM time sync protocol is available &&
> @@ -6468,18 +6469,35 @@ static void set_tsync_params(struct common_record_context *ctx)
>  	 * force using the x86-tsc clock for this host-guest tracing session
>  	 * and store TSC to nsec multiplier and shift.
>  	 */
> -	if (!clock && tsync_proto_is_supported("kvm") &&
> -	    clock_is_supported(NULL, TSC_CLOCK) &&
> -	    !get_tsc_nsec(&shift, &mult) && mult) {
> -		clock = TSC_CLOCK;
> -		ctx->tsc2nsec.mult = mult;
> -		ctx->tsc2nsec.shift = shift;
> -		ctx->tsc2nsec.offset = get_clock_now(TSC_CLOCK);
> -		force_tsc = true;
> +		if (tsync_proto_is_supported("kvm") &&
> +		    clock_is_supported(NULL, TSC_CLOCK) &&

So we want to test the first instance, not the top one.

-- Steve

> +		    !get_tsc_nsec(&shift, &mult) && mult) {
> +			clock = strdup(TSC_CLOCK);
> +			if (!clock)
> +				die("Cannot not allocate clock");
> +			ctx->tsc2nsec.mult = mult;
> +			ctx->tsc2nsec.shift = shift;
> +			ctx->tsc2nsec.offset = get_clock_now(TSC_CLOCK);
> +			force_tsc = true;
> +		} else {
> +		/*
> +		 * Else, use the current clock of the first host instance
> +		 */
> +			for_all_instances(instance) {
> +				if (is_guest(instance))
> +					continue;
> +				clock = tracefs_get_clock(instance->tracefs);
> +				break;
> +			}
> +		}
> +	} else {
> +		clock = strdup(ctx->clock);
> +		if (!clock)
> +			die("Cannot not allocate clock");
>  	}
>  
>  	if (!clock && !ctx->tsync_loop_interval)
> -		return;
> +		goto out;
>  	for_all_instances(instance) {
>  		if (clock && !(instance->flags & BUFFER_FL_HAS_CLOCK)) {
>  			/* use the same clock in all tracing peers */
> @@ -6501,6 +6519,8 @@ static void set_tsync_params(struct common_record_context *ctx)
>  		}
>  		instance->tsync_loop_interval = ctx->tsync_loop_interval;
>  	}
> +out:
> +	free(clock);
>  }
>  
>  /*

