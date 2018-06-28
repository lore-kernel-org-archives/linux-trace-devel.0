Return-Path: <SRS0=5iTX=JO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:55880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752178AbeF1X3I (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Jun 2018 19:29:08 -0400
Date: Thu, 28 Jun 2018 19:29:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 6/9] kernel-shark-qt: Add filtering to the C API of
 KernelShark
Message-ID: <20180628192905.7773b9fa@gandalf.local.home>
In-Reply-To: <20180628163012.21477-7-y.karadz@gmail.com>
References: <20180628163012.21477-1-y.karadz@gmail.com>
        <20180628163012.21477-7-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 28 Jun 2018 19:30:09 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +static void unset_event_filter_flag(struct kshark_context *kshark_ctx,
> +				    struct kshark_entry *e)
> +{
> +	/*
> +	 * All entries, filtered-out by the event filters, will be treated
> +	 * differently, when visualized. Because of this, ignore the value
> +	 * of the GRAPH_VIEW flag provided by the user via
> +	 * kshark_ctx->filter_mask and unset the EVENT_VIEW flag.
> +	 */
> +	int event_mask = kshark_ctx->filter_mask;

Just to get you use to Linux kernel coding style. Always add a space
between the declaration and the code. Even when the declaration has
code.

There's a few places where this requirement is not strictly forced, but
we'll discuss that later.

> +	event_mask &= ~KS_GRAPH_VIEW_FILTER_MASK;
> +	event_mask |= KS_EVENT_VIEW_FILTER_MASK;
> +	e->visible &= ~event_mask;
> +}
> +
> +void kshark_filter_entries(struct kshark_context *kshark_ctx,
> +			   struct kshark_entry **data,
> +			   size_t n_entries)
> +{
> +	int i;

Here too, and any other places that has declarations.

-- Steve

> +	if (!kshark_filter_is_set(kshark_ctx))
> +		return;
> +
