Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9F5C433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 22:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7D4D235FF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 22:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbhAGWYB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 17:24:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbhAGWYB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 17:24:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 225B9235FF;
        Thu,  7 Jan 2021 22:23:20 +0000 (UTC)
Date:   Thu, 7 Jan 2021 17:23:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] kernel-shark: Add KS_DEFINE_PLUGIN_CONTEXT macro
Message-ID: <20210107172318.15f4b191@gandalf.local.home>
In-Reply-To: <20210107161547.207270-4-y.karadz@gmail.com>
References: <20210107161547.207270-1-y.karadz@gmail.com>
        <20210107161547.207270-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  7 Jan 2021 18:15:44 +0200
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

You some how lost your signed off by.

-- Steve

> ---
>  src/libkshark-plugin.h    | 41 +++++++++++++++++++++++++++++++++++++++
>  tests/libkshark-tests.cpp | 32 ++++++++++++++++++++++++++++++
>  2 files changed, 73 insertions(+)
> 
> diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
> index 4104357..c62086f 100644
> --- a/src/libkshark-plugin.h
> +++ b/src/libkshark-plugin.h
> @@ -363,6 +363,47 @@ int kshark_handle_all_dpis(struct kshark_data_stream *stream,
>  	__ok;								\
>  })									\
>  
> +/** General purpose macro defining methods for adding plugin context. */
> +#define KS_DEFINE_PLUGIN_CONTEXT(type)					\
> +static type **__context_handler;					\
> +static ssize_t __n_streams = -1;					\
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
> +		if (!KS_DOUBLE_SIZE(__context_handler,			\
> +				    __n_streams))			\
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
> diff --git a/tests/libkshark-tests.cpp b/tests/libkshark-tests.cpp
> index 8a5dcf1..780a3fa 100644
> --- a/tests/libkshark-tests.cpp
> +++ b/tests/libkshark-tests.cpp
> @@ -10,6 +10,7 @@
>  
>  // KernelShark
>  #include "libkshark.h"
> +#include "libkshark-plugin.h"
>  
>  #define N_TEST_STREAMS	1000
>  
> @@ -103,3 +104,34 @@ BOOST_AUTO_TEST_CASE(fill_data_container)
>  
>  	kshark_free_data_container(data);
>  }
> +
> +struct test_context {
> +	int a;
> +	char b;
> +};
> +
> +KS_DEFINE_PLUGIN_CONTEXT(struct test_context);
> +
> +BOOST_AUTO_TEST_CASE(init_close_plugin)
> +{
> +	struct test_context *ctx;
> +	int i;
> +
> +	for (i = 0; i < N_TEST_STREAMS; ++i) {
> +		ctx = __init(i);
> +		ctx->a = i * 10;
> +		ctx->b = 'z';
> +	}
> +
> +	for (i = 0; i < N_TEST_STREAMS; ++i) {
> +		ctx = __get_context(i);
> +		BOOST_REQUIRE(ctx != NULL);
> +		BOOST_CHECK_EQUAL(ctx->a, i * 10);
> +		BOOST_CHECK_EQUAL(ctx->b, 'z');
> +
> +		__close(i);
> +		BOOST_REQUIRE(__get_context(i) == NULL);
> +	}
> +
> +	__close(-1);
> +}

