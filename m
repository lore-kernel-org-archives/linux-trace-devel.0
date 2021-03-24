Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87240C433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C827619EA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhCXBlq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Mar 2021 21:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231393AbhCXBlb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 21:41:31 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3B3F61924;
        Wed, 24 Mar 2021 01:41:30 +0000 (UTC)
Date:   Tue, 23 Mar 2021 21:41:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 12/18] trace-cmd: Convert tsc timestamps to
 nanosecods when reading trace data from a file
Message-ID: <20210323214129.538dcbc7@oasis.local.home>
In-Reply-To: <20210322095945.259300-13-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
        <20210322095945.259300-13-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Mar 2021 11:59:39 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -1279,14 +1296,18 @@ static unsigned long long timestamp_correct(unsigned long long ts,
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
> +		t -= handle->tsc_calc.offset;
> +		t = mul_u64_u32_shr(t, handle->tsc_calc.mult, handle->tsc_calc.shift);
> +	}
>  
> -	return tstamp;
> +	return t;
>  }
>  

Like I said, I like to save on extra variables ;-)

static unsigned long long timestamp_calc(unsigned long long ts,
					 struct tracecmd_input *handle)
{
	ts = timestamp_correct(ts, handle);

	if (handle->ts2secs)
		ts *= handle->ts2secs;
	else if (handle->tsc_calc.mult) {
		ts -= handle->tsc_calc.offset;
		ts = mul_u64_u32_shr(t, handle->tsc_calc.mult, handle->tsc_calc.shift);
	}

	return ts;
}

-- Steve
