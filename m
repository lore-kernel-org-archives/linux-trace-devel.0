Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A5CC433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Mar 2021 21:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 545B964FA8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Mar 2021 21:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhCPVZy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Mar 2021 17:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhCPVZf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Mar 2021 17:25:35 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0714A64E76;
        Tue, 16 Mar 2021 21:25:34 +0000 (UTC)
Date:   Tue, 16 Mar 2021 17:25:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 09/12] trace-cmd: Convert tsc timestamps to nanosecods
 when reading trace data from a file
Message-ID: <20210316172533.221e05c1@gandalf.local.home>
In-Reply-To: <20210315061832.168495-10-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
        <20210315061832.168495-10-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 15 Mar 2021 08:18:29 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> If there is information for TSC to nanoseconds conversion in the trace
> file metadata, use it to recalculate the timestamps of all events.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 28 ++++++++++++++++++++++++----
>  1 file changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 65081007..dc9ac1d3 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -1276,17 +1276,37 @@ static unsigned long long timestamp_correct(unsigned long long ts,
>  					 &host->ts_samples[mid+1]);
>  }
>  

I would add a comment saying that the below function was taken from the
Linux kernel.

-- Steve

> +static unsigned long long mul_u64_u32_shr(unsigned long long a,
> +					  unsigned long long mul, unsigned int shift)
> +{
> +	unsigned int ah, al;
> +	unsigned long long ret;
> +
> +	al = a;
> +	ah = a >> 32;
> +
> +	ret = (al * mul) >> shift;
> +	if (ah)
> +		ret += (ah * mul) << (32 - shift);
> +
> +	return ret;
> +}
> +
>  static unsigned long long timestamp_calc(unsigned long long ts,
>  					 struct tracecmd_input *handle)
>  {
> -	unsigned long long tstamp;
> +	unsigned long long t;
>  
> -	tstamp = timestamp_correct(ts, handle);
> +	t = timestamp_correct(ts, handle);
>  
>  	if (handle->ts2secs)
> -		tstamp *= handle->ts2secs;
> +		t *= handle->ts2secs;
> +	else if (handle->tsc_calc.mult) {
> +		t = mul_u64_u32_shr(t, handle->tsc_calc.mult, handle->tsc_calc.shift);
> +		t += handle->tsc_calc.offset;
> +	}
>  
> -	return tstamp;
> +	return t;
>  }
>  
>  /*

