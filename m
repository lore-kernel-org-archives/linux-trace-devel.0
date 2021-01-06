Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4098C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 17:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96FFE22CAF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 17:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbhAFRpn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Jan 2021 12:45:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbhAFRpn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Jan 2021 12:45:43 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6778A22CAF;
        Wed,  6 Jan 2021 17:45:02 +0000 (UTC)
Date:   Wed, 6 Jan 2021 12:45:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/6] kernel-shark: Add KS_DEFINE_PLUGIN_CONTEXT macro
Message-ID: <20210106124500.12c07933@gandalf.local.home>
In-Reply-To: <20210106161120.119085-4-y.karadz@gmail.com>
References: <20210106161120.119085-1-y.karadz@gmail.com>
        <20210106161120.119085-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  6 Jan 2021 18:11:17 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> When we implement a KernelShark plugins, we often need a way to define
> a structure that can hold context data that is visible only inside the
> plugin and that has specific values for each data stream. The tricky
> part here is that the total number of data streams and the IDs of the
> active streams are dynamic quantities that can change as the user adds
> or removes data streams. The macro defines an interface of functions
> that will be useful for the plugin developer, helping to directly use
> context objects, without caring for the complications due to the dynamic
> configuration of active data streams.
> ---
>  src/libkshark-plugin.h    | 43 +++++++++++++++++++++++++++++++++++++++
>  tests/libkshark-tests.cpp | 32 +++++++++++++++++++++++++++++
>  2 files changed, 75 insertions(+)
> 
> diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
> index f3c724f..e58d658 100644
> --- a/src/libkshark-plugin.h
> +++ b/src/libkshark-plugin.h
> @@ -360,6 +360,49 @@ int kshark_handle_all_dpis(struct kshark_data_stream *stream,
>  	}								\
>  }									\
>  
> +/** General purpose macro defining methods for adding plugin context. */
> +#define KS_DEFINE_PLUGIN_CONTEXT(type)					\

When macros like this are done in Linux, it is common to add a "prefix"
argument, and name all the variables and functions created by it with that
prefix.

#define KS_DEFINE_PLUGIN_CONTEXT(prefix, type) \
 static type **prefix##_context_handler; \
 [..]
 static inline type *prefix##_init(int sd) \
 [..]

This would allow this macro to be used more than once in a file.

It's up to you if you want to do it that way.

-- Steve

> +static type **__context_handler;					\
> +static ssize_t __n_streams = -1;					\
> +static bool ok;								\
> +static inline type *__init(int sd)					\
> +{									\
> +	type *obj;							\
> +	if (__n_streams < 0 && sd < KS_DEFAULT_NUM_STREAMS) {		\
> +		__context_handler =					\
> +			(type **) calloc(KS_DEFAULT_NUM_STREAMS,	\
> +					 sizeof(*__context_handler));	\
> +		if (!__context_handler)					\
> +			return NULL;					\
> +		__n_streams = KS_DEFAULT_NUM_STREAMS;			\
> +	} else if (sd >= __n_streams) {					\
> +		KS_DOUBLE_SIZE(type *, __context_handler,		\
> +			       &__n_streams, &ok)			\
> +		if (!ok)						\
> +			return NULL;					\
> +	}								\
> +	assert(__context_handler[sd] == NULL);				\
> +	obj = (type *) calloc(1, sizeof(*obj));				\
> +	__context_handler[sd] = obj;					\
> +	return obj;							\
> +}									\
> +static inline void __close(int sd)					\
> +{									\
> +	if (sd < 0) {							\
> +		free(__context_handler);				\
> +		__n_streams = -1;					\
> +		return;							\
> +	}								\
> +	free(__context_handler[sd]);					\
> +	__context_handler[sd] = NULL;					\
> +}									\
> +static inline type *__get_context(int sd)				\
> +{									\
> +	if (sd < 0 || sd >= __n_streams)				\
> +		return NULL;						\
> +	return __context_handler[sd];					\
> +}									\
> +
>  #ifdef __cplusplus
>  }
>  #endif // __cplusplus
