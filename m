Return-Path: <SRS0=nq8z=2I=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC2DEC43603
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Dec 2019 15:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8614824672
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Dec 2019 15:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfLRPY0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 10:24:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbfLRPY0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 10:24:26 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E47621582;
        Wed, 18 Dec 2019 15:24:25 +0000 (UTC)
Date:   Wed, 18 Dec 2019 10:24:23 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sven Schnelle <svens@linux.ibm.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] ftrace: fix endianness bug in histogram trigger
Message-ID: <20191218102423.755eefdc@gandalf.local.home>
In-Reply-To: <20191218074427.96184-4-svens@linux.ibm.com>
References: <20191218074427.96184-1-svens@linux.ibm.com>
        <20191218074427.96184-4-svens@linux.ibm.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 18 Dec 2019 08:44:27 +0100
Sven Schnelle <svens@linux.ibm.com> wrote:

> At least on PA-RISC and s390 synthetic histogram triggers are failing
> selftests because trace_event_raw_event_synth() always writes a 64 bit
> values, but the reader expects a field->size sized value. On little endian
> machines this doesn't hurt, but on big endian this makes the reader always
> read zero values.

Does this fix make the other one obsolete?

  https://lore.kernel.org/r/20191211110959.2baeb70f@gandalf.local.home

-- Steve

> 
> Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
> ---
>  kernel/trace/trace_events_hist.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> index f49d1a36d3ae..f62de5f43e79 100644
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -911,7 +911,26 @@ static notrace void trace_event_raw_event_synth(void *__data,
>  			strscpy(str_field, str_val, STR_VAR_LEN_MAX);
>  			n_u64 += STR_VAR_LEN_MAX / sizeof(u64);
>  		} else {
> -			entry->fields[n_u64] = var_ref_vals[var_ref_idx + i];
> +			struct synth_field *field = event->fields[i];
> +			u64 val = var_ref_vals[var_ref_idx + i];
> +
> +			switch (field->size) {
> +			case 1:
> +				*(u8 *)&entry->fields[n_u64] = (u8)val;
> +				break;
> +
> +			case 2:
> +				*(u16 *)&entry->fields[n_u64] = (u16)val;
> +				break;
> +
> +			case 4:
> +				*(u32 *)&entry->fields[n_u64] = (u32)val;
> +				break;
> +
> +			default:
> +				entry->fields[n_u64] = val;
> +				break;
> +			}
>  			n_u64++;
>  		}
>  	}

