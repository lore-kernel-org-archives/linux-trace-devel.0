Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D36C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2EBB619EA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhCXBkZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Mar 2021 21:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231534AbhCXBiY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 21:38:24 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81353619BB;
        Wed, 24 Mar 2021 01:38:23 +0000 (UTC)
Date:   Tue, 23 Mar 2021 21:38:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 11/18] trace-cmd: Perform all timestamp corrections
 in a single function
Message-ID: <20210323213821.52baf5cc@oasis.local.home>
In-Reply-To: <20210322095945.259300-12-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
        <20210322095945.259300-12-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Mar 2021 11:59:38 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> When reading event timestamps from a trace file, there could be various
> corrections depending on the metadata information from the file. Move
> all logic that performs timestamp calculations in a single function.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index be8a7919..dfbe4af6 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -1276,6 +1276,19 @@ static unsigned long long timestamp_correct(unsigned long long ts,
>  					 &host->ts_samples[mid+1]);
>  }
>  
> +static unsigned long long timestamp_calc(unsigned long long ts,
> +					 struct tracecmd_input *handle)
> +{
> +	unsigned long long tstamp;
> +
> +	tstamp = timestamp_correct(ts, handle);
> +
> +	if (handle->ts2secs)
> +		tstamp *= handle->ts2secs;
> +
> +	return tstamp;
> +}

I like to save on extra variables ;-)

static unsigned long long timestamp_calc(unsigned long long ts,
					 struct tracecmd_input *handle)
{
	ts = timestamp_correct(ts, handle);

	if (handle->ts2secs)
		ts *= handle->ts2secs;

	return ts;
}


-- Steve
