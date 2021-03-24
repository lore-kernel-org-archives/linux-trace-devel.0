Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A569DC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 18:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CE8061A12
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 18:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237437AbhCXSv5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237574AbhCXSvq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 14:51:46 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F22E461A0A;
        Wed, 24 Mar 2021 18:51:45 +0000 (UTC)
Date:   Wed, 24 Mar 2021 14:51:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 15/23] trace-cmd: Set order and priorities when
 applying timestamp corrections
Message-ID: <20210324145144.067efa87@gandalf.local.home>
In-Reply-To: <20210324130418.436206-16-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
        <20210324130418.436206-16-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Mar 2021 15:04:10 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -1296,15 +1287,23 @@ static unsigned long long timestamp_correct(unsigned long long ts,
>  static unsigned long long timestamp_calc(unsigned long long ts,
>  					 struct tracecmd_input *handle)
>  {
> -	ts = timestamp_correct(ts, handle);
> +	/* Guest trace file, sync with host timestamps */
> +	if (handle->host.sync_enable)
> +		ts = timestamp_host_sync(ts, handle);
>  
> -	if (handle->ts2secs)
> +	if (handle->ts2secs) {
> +		/* user specified clock frequency */
>  		ts *= handle->ts2secs;
> -	else if (handle->tsc_calc.mult) {
> +	} else if (handle->tsc_calc.mult) {
> +		/* auto calculated TSC clock frequency */
>  		ts -= handle->tsc_calc.offset;
>  		ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
>  	}
>  
> +	/* User specified time offset with --ts-offset or --date options */
> +	if (handle->ts_offset)
> +		ts += handle->ts_offset;
> +
>  	return ts;
>  }


Now that I'm playing with this, I find I want to see what the result is
without the tsc_calc.offset, but can't do it. I'm thinking that the
--ts-offset should modify that instead:

	bool ts_offset_set = false;
	[..]

	} else if (handel->tsc_calc.mult) {
		ts_offset_set = true;
		if (handle->ts_offset)
			ts += handle->ts_offset;
		else
			ts -= handle->tsc_calc.offset;
		[..]
	}

	if (handle->ts_offset && !ts_offset_set)
		ts += handle->ts_offset;

Or should we add another option to modify the ts_calc.offset?

Thoughts?

-- Steve
