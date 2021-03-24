Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9300C433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D551619E9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhCXBtd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Mar 2021 21:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234581AbhCXBtb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 21:49:31 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92343619E8;
        Wed, 24 Mar 2021 01:49:30 +0000 (UTC)
Date:   Tue, 23 Mar 2021 21:49:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 14/18] trace-cmd: Add a new flag to disable any
 timestamp corrections
Message-ID: <20210323214928.0c47e295@oasis.local.home>
In-Reply-To: <20210322095945.259300-15-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
        <20210322095945.259300-15-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Mar 2021 11:59:41 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> A new flag is added in the trace-cmd library for controlling events
> timestamp corrections while reading a trace file. If the flag is set,
> all timestamps are displayed as-is from the trace file.
>    TRACECMD_FL_RAW_TS
> The flag can be modified with these APIs:
>   tracecmd_set_flag()
>   tracecmd_clear_flag()
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/include/private/trace-cmd-private.h |  1 +
>  lib/trace-cmd/trace-input.c                       | 12 ++++++++----
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index c33d067a..fdca7494 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -134,6 +134,7 @@ enum {
>  	TRACECMD_FL_IGNORE_DATE		= (1 << 0),
>  	TRACECMD_FL_BUFFER_INSTANCE	= (1 << 1),
>  	TRACECMD_FL_IN_USECS		= (1 << 2),
> +	TRACECMD_FL_RAW_TS		= (1 << 3),
>  };
>  
>  struct tracecmd_ftrace {
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 5d03cd00..88007cde 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -1289,6 +1289,9 @@ static unsigned long long timestamp_calc(unsigned long long ts,
>  {
>  	unsigned long long t = ts;
>  
> +	/* do not modify raw timestamps */
> +	if (handle->flags & TRACECMD_FL_RAW_TS)
> +		return ts;
>  
>  	/* Guest trace file, sync with host timestamps */
>  	if (handle->host.sync_enable)
> @@ -2604,7 +2607,8 @@ static int handle_options(struct tracecmd_input *handle)
>  			 * gtod. It is stored as ASCII with '0x'
>  			 * appended.
>  			 */
> -			if (handle->flags & TRACECMD_FL_IGNORE_DATE)
> +			if ((handle->flags & TRACECMD_FL_IGNORE_DATE) ||
> +			    (handle->flags & TRACECMD_FL_RAW_TS))
>  				break;

These are flags, let's use them as such:

			if (handle->flags &
			    (TRACECMD_FL_IGNORE_DATE | TRACECMD_FL_RAW_TS))
				break;

>  			offset = strtoll(buf, NULL, 0);
>  			/* Convert from micro to nano */
> @@ -2616,7 +2620,7 @@ static int handle_options(struct tracecmd_input *handle)
>  			 * Similar to date option, but just adds an
>  			 * offset to the timestamp.
>  			 */
> -			if (handle->flags & TRACECMD_FL_IGNORE_DATE)
> +			if (handle->flags & TRACECMD_FL_RAW_TS)

Why do we not break here for IGNORE_DATE?

>  				break;
>  			offset = strtoll(buf, NULL, 0);
>  			handle->ts_offset += offset;
> @@ -2631,7 +2635,7 @@ static int handle_options(struct tracecmd_input *handle)
>  			 * long long array of size [count] of timestamp offsets.
>  			 * long long array of size [count] of timestamp scaling ratios.*
>  			 */
> -			if (size < 16 || handle->flags & TRACECMD_FL_IGNORE_DATE)
> +			if (size < 16 || (handle->flags & TRACECMD_FL_RAW_TS))

And why did we change the code for IGNORE_DATE here too?

-- Steve

>  				break;
>  			handle->host.peer_trace_id = tep_read_number(handle->pevent,
>  								     buf, 8);
> @@ -2710,7 +2714,7 @@ static int handle_options(struct tracecmd_input *handle)
>  			trace_guest_load(handle, buf, size);
>  			break;
>  		case TRACECMD_OPTION_TSC2NSEC:
> -			if (size < 16)
> +			if (size < 16 || (handle->flags & TRACECMD_FL_RAW_TS))
>  				break;
>  			handle->tsc_calc.mult = tep_read_number(handle->pevent,
>  								buf, 4);

