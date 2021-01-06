Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF6AC433E9
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 17:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03BE023133
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 17:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbhAFRCv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Jan 2021 12:02:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727846AbhAFRCv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Jan 2021 12:02:51 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36C0323120;
        Wed,  6 Jan 2021 17:02:10 +0000 (UTC)
Date:   Wed, 6 Jan 2021 12:02:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/6] kernel-shark: Add KS_DOUBLE_SIZE macro
Message-ID: <20210106120208.3e212fbd@gandalf.local.home>
In-Reply-To: <20210106161120.119085-2-y.karadz@gmail.com>
References: <20210106161120.119085-1-y.karadz@gmail.com>
        <20210106161120.119085-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  6 Jan 2021 18:11:15 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The macro is useful for resizing of dynamic arrays. It is currently
> used to resize the Data stream descriptor array, owned by the session
> context. We will later use the macro with the arrays of data fields and
> plugin contexts.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/libkshark-plugin.h | 14 ++++++++++++++
>  src/libkshark.c        | 15 +++++++--------
>  2 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
> index 1a642ad..f3c724f 100644
> --- a/src/libkshark-plugin.h
> +++ b/src/libkshark-plugin.h
> @@ -346,6 +346,20 @@ int kshark_handle_dpi(struct kshark_data_stream *stream,
>  int kshark_handle_all_dpis(struct kshark_data_stream *stream,
>  			   enum kshark_plugin_actions  task_id);
>  
> +/** General purpose macro for resizing dynamic arrays. */

Perhaps make this into a static inline function?

> +#define KS_DOUBLE_SIZE(type, array, size, ok)				\
> +{									\
> +	ssize_t n = *size;						\
> +	*ok = false;							\

As a macro, ok does not need to be passed in as an address.

> +	type *tmp = (type *) realloc(array, 2 * n * sizeof(*tmp));	\
> +	if (tmp) {							\
> +		memset(tmp + n, 0, n * sizeof(*tmp));			\
> +		*size = 2 * n;						\

as a macro you do not need to pass in the address. If you are going to do
that, then please make this into a static inline function.

> +		array = tmp;						\
> +		*ok = true;						\

I would get rid of the ok, and just have this return true or false.

FYI, as a macro, to return a value you have:

#define foo() ({ return true; })

Which would then return a true value.

-- Steve

> +	}								\
> +}									\
> +
>  #ifdef __cplusplus
>  }
>  #endif // __cplusplus
> diff --git a/src/libkshark.c b/src/libkshark.c
> index 315c24f..3aa3fa2 100644
> --- a/src/libkshark.c
> +++ b/src/libkshark.c
> @@ -234,16 +234,15 @@ int kshark_add_stream(struct kshark_context *kshark_ctx)
>  
>  	if (kshark_ctx->stream_info.next_free_stream_id ==
>  	    kshark_ctx->stream_info.array_size) {
> -		size_t new_size = 2 * kshark_ctx->stream_info.array_size;
> -		struct kshark_data_stream **streams_tmp;
> +		bool ok;
>  
> -		streams_tmp = realloc(kshark_ctx->stream,
> -				      new_size * sizeof(*kshark_ctx->stream));
> -		if (!streams_tmp)
> -			return -ENOMEM;
> +		KS_DOUBLE_SIZE(struct kshark_data_stream *,
> +			       kshark_ctx->stream,
> +			       &kshark_ctx->stream_info.array_size,
> +			       &ok);
>  
> -		kshark_ctx->stream = streams_tmp;
> -		kshark_ctx->stream_info.array_size = new_size;
> +		if (!ok)
> +			return -ENOMEM;
>  	}
>  
>  	stream = kshark_stream_alloc();

