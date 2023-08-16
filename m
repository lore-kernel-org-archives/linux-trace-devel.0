Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C6E9C0015E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Aug 2023 01:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240943AbjHPBLJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 21:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240949AbjHPBKw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 21:10:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2911FFC
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 18:10:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C80460C26
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 01:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B28C433C8;
        Wed, 16 Aug 2023 01:10:50 +0000 (UTC)
Date:   Tue, 15 Aug 2023 21:10:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [RFC][PATCH] libtraceeval: Add size checks to insert and query
 functions
Message-ID: <20230815211052.7c56695d@gandalf.local.home>
In-Reply-To: <20230815200234.32fd17dd@gandalf.local.home>
References: <20230815200234.32fd17dd@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 15 Aug 2023 20:02:34 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> @@ -171,15 +171,23 @@ struct traceeval *traceeval_init(struct traceeval_type *keys,
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

I just realized that vals may be NULL, so the above needs to be:

#define traceeval_insert(teval, keys, vals)				\
	traceeval_insert_size(teval, keys, sizeof(keys) / sizeof(keys[0]), \
			      vals, vals ? sizeof(vals) / sizeof(vals[0]) : 0)

-- Steve
