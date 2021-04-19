Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6547FC43461
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 15:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AAD66127C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 15:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbhDSPOj convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 11:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240740AbhDSPOi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 11:14:38 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B527461007;
        Mon, 19 Apr 2021 15:14:08 +0000 (UTC)
Date:   Mon, 19 Apr 2021 11:14:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] trace-cmd library: Add check before applying
 tsc2nsec offset
Message-ID: <20210419111407.29a90f86@gandalf.local.home>
In-Reply-To: <20210419094543.15c131c2@gandalf.local.home>
References: <20210416103409.24597-1-tz.stoyanov@gmail.com>
        <20210416103409.24597-3-tz.stoyanov@gmail.com>
        <20210416161221.031d1f5d@gandalf.local.home>
        <CAPpZLN4K6H8p1zNuqHQd0LGDHatAgR+8SHRH1jTP8=Jb_bMZUw@mail.gmail.com>
        <20210419094543.15c131c2@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 19 Apr 2021 09:45:43 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:


> That is:
> 
> 	max = 0;
> 	for each stream:
> 		ret = read first event, compared to offset
> 		if (!ret) {
> 			/* ret will be how much off by offset */
> 			if (ret > max)
> 				max = ret;
> 		}
> 	if (max) {
> 		for each stream:
> 			Update offset by subtracting max
> 	}
> 
> Look at each stream, and have some callback give you how much ahead the
> first event is from its given offset. Take the biggest value from reading
> all the streams, then tell all the streams to subtract its offset by that
> max value. The end result is that all streams now start at a positive value.

From our call, here's the pseudo code that I was talking about:

> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index b17b36e0..f03dadd3 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -1302,7 +1302,7 @@ static unsigned long long timestamp_host_sync(unsigned long long ts, int cpu,
>  					 &tsync->ts_samples[mid+1]);
>  }
>  
> -static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
> +static unsigned long long pre_timestamp_calc(unsigned long long ts, int cpu,
>  					 struct tracecmd_input *handle)

I pulled out the timestamp_calc into a helper function.

>  {
>  	/* do not modify raw timestamps */
> @@ -1318,17 +1318,44 @@ static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
>  		ts *= handle->ts2secs;
>  	} else if (handle->tsc_calc.mult) {
>  		/* auto calculated TSC clock frequency */
> -		ts -= handle->tsc_calc.offset;

And removed the calc offset.

>  		ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
>  	}
>  
>  	/* User specified time offset with --ts-offset or --date options */
> -	if (handle->ts_offset)
> -		ts += handle->ts_offset;
> +	ts += handle->ts_offset;

As we mentioned (and this can be a separate patch), the if statement is
useless.

>  
>  	return ts;
>  }
>  
> +static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
> +					 struct tracecmd_input *handle)
> +{
> +	static int once;
> +
> +	ts = pre_timestamp_calc(ts, cpu, handle);
> +	if (!once && ts > handle->start_ts_offset) {
> +		once++;
> +		tracecmd_warning();
> +	}
> +	ts -= handle->start_ts_offset;

After looking at this more, I think we should just have the ts_offset and
start_ts_offset be the same. And remove the ts += handle->ts_offset, from
the pre_timestamp_calc() above, and have this check test just ts_offset.

So now the timestamp_calc() will get the timestamp and then apply the
ts_offset separately (and warn if the offset is greater than the ts).

> +}
> +
> +
> +
> +long long tracecmd_cpu_first_ts_offset(struct tracecmd_input *handle, int cpu)
> +}
> +	struct tep_record rec;
> +
> +	rec = first_event(handle, cpu);
> +	return pre_timestamp_calc(rec->ts, cpu, handle) - handle->ts_offset;
> +}

Add an API that shows the difference between the first stream event
timestamp against the user supplied (or file supplied) ts_offset.


> +
> +int tracecmd_modify_ts_offset(struct tracecmd_input *handle, long long offset)
> +{
> +	handle->ts_offset += offset;
> +}

Allow the user to tweak that offset. As we already have:

tracecmd_set_ts_offset(handle, offset) to set ts_offset, if the user found
that the offset was before, it could tweak it.

> +
> +
>  /*
>   * Page is mapped, now read in the page header info.
>   */
> 


That is, in the options, we would need to have the calc offset from the
file (doing the sync), do:

	handle->ts_offset -= start_offset.

Or something like that. I'll let you look at this code and see what you
come up with, and we can discuss this further.

-- Steve
