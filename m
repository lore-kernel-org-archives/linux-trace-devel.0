Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21104C5519F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 01:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFAD9246E4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 01:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgKSB3d (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 20:29:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgKSB3d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 20:29:33 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 460BC246E0;
        Thu, 19 Nov 2020 01:29:32 +0000 (UTC)
Date:   Wed, 18 Nov 2020 20:29:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 10/20] kernel-shark: Start using data streams
Message-ID: <20201118202929.08d8a30a@oasis.local.home>
In-Reply-To: <20201118145003.156542-11-y.karadz@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
        <20201118145003.156542-11-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 18 Nov 2020 16:49:53 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


> @@ -327,6 +302,34 @@ int kshark_add_stream(struct kshark_context *kshark_ctx)
>  	return stream->stream_id;
>  }
>  
> +/**
> + * @brief Use an existing Trace data stream to open and prepare for reading
> + *	  a trace data file specified by "file".
> + *
> + * @param stream: Input location for a Trace data stream pointer.
> + * @param file: The file to load.
> + *
> + * @returns Zero on success or a negative error code in the case of an errno.
> + */
> +int kshark_stream_open(struct kshark_data_stream *stream, const char *file)
> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +
> +	if (!stream || !kshark_instance(&kshark_ctx))
> +		return -EFAULT;
> +
> +	stream->file = strdup(file);

Should probably check the result of the allocation of file.

> +
> +	if (kshark_tep_check_data(file)) {
> +		kshark_set_data_format(stream->data_format,
> +				       TEP_DATA_FORMAT_IDENTIFIER);
> +
> +		return kshark_tep_init_input(stream, file);

Why pass in file, if it is going to equal stream->file?

Couldn't kshark_tep_init_input() just use whatever is in the stream->file?

-- Steve


> +	}
> +
> +	return -ENODATA;
> +}
> +
>  /**
>   * @brief Remove Data stream.
>   *
