Return-Path: <SRS0=5iTX=JO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:33628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935624AbeF1Xhz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Jun 2018 19:37:55 -0400
Date: Thu, 28 Jun 2018 19:37:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 8/9] kernel-shark-qt: Add Advanced filter to the
 session context.
Message-ID: <20180628193752.6cd17bfe@gandalf.local.home>
In-Reply-To: <20180628163012.21477-9-y.karadz@gmail.com>
References: <20180628163012.21477-1-y.karadz@gmail.com>
        <20180628163012.21477-9-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 28 Jun 2018 19:30:11 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> @@ -306,9 +315,23 @@ void kshark_filter_entries(struct kshark_context *kshark_ctx,
>  			   size_t n_entries)
>  {
>  	int i;

Also add a space here.

> +	if (kshark_ctx->advanced_event_filter->filters) {

Can this be called with kshark_ctx->advanced_event_filter == NULL?

> +		/*
> +		 * The advanced filter is set but applying it requires
> +		 * access to prevent_record, hence the data has to be
> +		 * reloaded.
> +		 */

I'm a little confused by the comment above. So if this is called with
advanced filters, then it is an error?

> +		fprintf(stderr,
> +			"Failed to filter!\n");
> +		fprintf(stderr,
> +			"Reset the Advanced filter or reload the data.\n");
> +		return;
> +	}
> +
>  	if (!kshark_filter_is_set(kshark_ctx))
>  		return;
>  
> +	/* No need to reload the data. Apply the Id filters. */

Why is this comment added here? Would it make sense to add it in the
original patch? Does advanced filters make this different?

-- Steve

>  	for (i = 0; i < n_entries; ++i) {
>  		/* Start with and entry which is visible everywhere. */
>  		data[i]->visible = 0xFF;
