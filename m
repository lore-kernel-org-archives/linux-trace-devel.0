Return-Path: <SRS0=fnsP=DU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A2DC433DF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Oct 2020 00:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A7092087E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Oct 2020 00:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgJMAFq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 20:05:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgJMAFq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 20:05:46 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 361A920878;
        Tue, 13 Oct 2020 00:05:46 +0000 (UTC)
Date:   Mon, 12 Oct 2020 20:05:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 05/20] kernel-shark: Add stream_id to kshark_entry
Message-ID: <20201012200544.03d67163@oasis.local.home>
In-Reply-To: <20201012133523.469040-6-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
        <20201012133523.469040-6-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 12 Oct 2020 16:35:08 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> kshark_entry contains all information from one trace record, needed
> in order to visualize the time-series of trace records. Here we
> reorganize data fields to kshark_entry in order to make room for
> the unique identifier of the Data stream this entry belongs to.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/libkshark.c |  2 +-
>  src/libkshark.h | 12 +++++++++---
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/src/libkshark.c b/src/libkshark.c
> index 52aacd30..92e2450c 100644
> --- a/src/libkshark.c
> +++ b/src/libkshark.c
> @@ -489,7 +489,7 @@ static inline void unset_event_filter_flag(struct kshark_context *kshark_ctx,
>  	e->visible &= ~event_mask;
>  }
>  
> -static void set_all_visible(uint16_t *v) {
> +static void set_all_visible(uint8_t *v) {
>  	/*  Keep the original value of the PLUGIN_UNTOUCHED bit flag. */
>  	*v |= 0xFF & ~KS_PLUGIN_UNTOUCHED_MASK;
>  }
> diff --git a/src/libkshark.h b/src/libkshark.h
> index 1165c512..fe0ba7f2 100644
> --- a/src/libkshark.h
> +++ b/src/libkshark.h
> @@ -1,7 +1,7 @@
>  /* SPDX-License-Identifier: LGPL-2.1 */
>  
>  /*
> - * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>   */
>  
>   /**
> @@ -49,7 +49,10 @@ struct kshark_entry {
>  	 * kshark_filter_masks to check the level of visibility/invisibility
>  	 * of the entry.
>  	 */
> -	uint16_t	visible;
> +	uint8_t		visible;

Why did the visible variable turn from 16bits to 8 bits?

That should be stated in the change log.

> +
> +	/** Data stream identifier. */
> +	int8_t		stream_id;
>  
>  	/** The CPU core of the record. */
>  	int16_t		cpu;
> @@ -57,7 +60,7 @@ struct kshark_entry {
>  	/** The PID of the task the record was generated. */
>  	int32_t		pid;
>  
> -	/** Unique Id ot the trace event type. */
> +	/** Unique Id of the trace event type. */
>  	int32_t		event_id;
>  
>  	/** The offset into the trace file, used to find the record. */
> @@ -319,6 +322,9 @@ struct kshark_data_stream {
>  	struct kshark_data_stream_interface	interface;
>  };
>  
> +/** Hard-coded maximum number of data stream. */
> +#define KS_MAX_NUM_STREAMS	127

Will this become a variable?

Let's say we have a really powerful machine with a lot of memory. And
we have a data file with 500 CPUs traced, and we want to look at all of
them? Will this be a hard limit to change in the future without recompiling.

I've been hit by restrictions like this in code in the past, and know
that things like this can stay in the code for a long time, to a point
where they are no longer reasonable. I just want to make sure that we
don't get stuck with that. I've learned to look at all hard limits with
extra care, knowing that they are always a pain point in the future.

-- Steve


> +
>  /** Size of the task's hash table. */
>  #define KS_TASK_HASH_SHIFT 16
>  #define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)

