Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92185C678DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 22:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243993AbjHQWj5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 18:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355860AbjHQWjk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 18:39:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EE3B9
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 15:39:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E4B660C8C
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 22:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62325C433C7;
        Thu, 17 Aug 2023 22:39:37 +0000 (UTC)
Date:   Thu, 17 Aug 2023 18:39:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 7/9] libtraceeval: Add size checks to insert and query
 functions
Message-ID: <20230817183943.500343b4@gandalf.local.home>
In-Reply-To: <20230817222422.118568-8-rostedt@goodmis.org>
References: <20230817222422.118568-1-rostedt@goodmis.org>
        <20230817222422.118568-8-rostedt@goodmis.org>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Aug 2023 18:24:20 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -186,15 +186,23 @@ struct traceeval *traceeval_init(struct traceeval_type *keys,
>  
>  void traceeval_release(struct traceeval *teval);
>  
> -int traceeval_insert(struct traceeval *teval,
> -		     const struct traceeval_data *keys,
> -		     const struct traceeval_data *vals);
> +int traceeval_insert_size(struct traceeval *teval,
> +			  const struct traceeval_data *keys, size_t nr_keys,
> +			  const struct traceeval_data *vals, size_t nr_vals);
> +
> +#define traceeval_insert(teval, keys, vals)				\
> +	traceeval_insert_size(teval, keys, sizeof(keys) / sizeof(keys[0]), \
> +			      vals, sizeof(vals) / sizeof(vals[0]))
>  
>  int traceeval_remove(struct traceeval *teval,
>  		     const struct traceeval_data *keys);
>  
> -int traceeval_query(struct traceeval *teval, const struct traceeval_data *keys,
> -		    const struct traceeval_data **results);
> +int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *keys,
> +			 size_t nr_keys, const struct traceeval_data **results);
> +
> +#define traceeval_query(teval, keys, results)				\
> +	traceeval_query_size(teval, keys,				\
> +			     sizeof(keys) / sizeof(keys[0]), results);

That has an ';' at the end, and it causes failures for:

	if (traceeval_query(...) > 0)

(which I have in my trace-flames.c code).

I'll fix in v2.

-- Steve

