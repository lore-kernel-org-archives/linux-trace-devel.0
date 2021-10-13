Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C5DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 03:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE0AE60F38
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 03:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhJMDQG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 23:16:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhJMDQG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 23:16:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98F2560C40;
        Wed, 13 Oct 2021 03:14:03 +0000 (UTC)
Date:   Tue, 12 Oct 2021 23:14:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] trace-cmd: Read and use fraction bits from
 TRACECMD_OPTION_TIME_SHIFT
Message-ID: <20211012231401.22c8c22f@oasis.local.home>
In-Reply-To: <20210923094526.765059-3-tz.stoyanov@gmail.com>
References: <20210923094526.765059-1-tz.stoyanov@gmail.com>
        <20210923094526.765059-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 23 Sep 2021 12:45:25 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -1235,7 +1236,6 @@ timestamp_correction_calc(unsigned long long ts, unsigned int flags,
>  			  struct ts_offset_sample *min,
>  			  struct ts_offset_sample *max)
>  {
> -	long long scaling;
>  	long long tscor;
>  
>  	if (flags & TRACECMD_TSYNC_FLAG_INTERPOLATE) {
> @@ -1243,15 +1243,12 @@ timestamp_correction_calc(unsigned long long ts, unsigned int flags,
>  		long long offset = ((long long)ts - min->time) *
>  				   (max->offset - min->offset);
>  
> -		scaling = (min->scaling + max->scaling) / 2;

So the max->scaling is not going to play a role here?

Does this work for other methods besides KVM?

-- Steve


>  		tscor = min->offset + (offset + delta / 2) / delta;
> -
>  	} else {
> -		scaling = min->scaling;
>  		tscor = min->offset;
>  	}
>  
> -	ts *= scaling;
> +	ts = (ts * min->scaling) >> min->fraction;
>  	if (tscor < 0)
>  		return ts - llabs(tscor);
>  
> @@ -2337,37 +2334,16 @@ static int tsync_offset_cmp(const void *a, const void *b)
>  
