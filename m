Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6C9C71153
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Aug 2023 19:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235575AbjHXTlx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 15:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243447AbjHXTlu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 15:41:50 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CE0211B
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 12:41:27 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-7909307ecd1so6304039f.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 12:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692906073; x=1693510873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=om1Six5yRnBHi+V0bQ8QDnCasyng8tfUveYZ/A/8vMU=;
        b=HInlnNXcU7mM3YKB4HgJR0b3V0nD7BbzBID3QcXG7ljUYHU5YJNuTJSu4qRf0W5gJR
         EjoSGjuHxsjSCwYDV24J2271Fe1xoQJsFTE3O4xrLPnNhwb1xMW6Q84rvhvV9jCFr7ti
         r92z5jP+O1SVW9Vfs/KHGrQ4Pg/Jf4di7Wsoy3bhyw8Bh5gPNw+C5HmFgWBRV0ZtXKxb
         ZTx7du+ODWB+5NvAb5qPHLbN7GaP4EWDekoD3AKCDTGN8+GXpRJZ8rBK2tez8GsNQhYm
         iihqjuT9Svx2ouARNhyYZ+kC+caeJOHYDBWET6xBKrbNIFApXqSMQLljXSeL3XJc0XuS
         ys+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692906073; x=1693510873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=om1Six5yRnBHi+V0bQ8QDnCasyng8tfUveYZ/A/8vMU=;
        b=Un2r8yxs1F1sSTkpV2HzBZMyhDZRTwWLwW+lhH3l1xKDzgB8KTTq9ALrger3Xmj+p5
         7L3wewl/pSshybhaUpcC0lAzsYFA4+X6PQWflKVHvdj6QlI7d8JbzibE2KxeGHHxGpJ/
         ps27le74i2kW7UV9ixTHx1mGGrS0PXtnaLLdx3p1n77HEmFbt+V371y5YackwPt5MZU2
         lnptIkmfnJcPqaQkbiUQAQzZLuudugZvTaw2IDEX+oJzn3TVf0B/LhCpuLQ494E3x10C
         7XHDuzuWqJHH9OloEp5rmsGeVufGUCScfW2HWfABRikUCeX31jZqlDp0CNSpHxKCZ6qh
         mKdA==
X-Gm-Message-State: AOJu0Yz8av0Drcxwul2yTxh04KDSRkdaB6hZ3FJdlpjjkDwrk/G11eVP
        KB48MCl1+cvMO9fWqJv7FNAtGw==
X-Google-Smtp-Source: AGHT+IFmJlreKVyjBsfuSfnMmj7RbOgMsvVLlC6tt6pgn4rK8ptb6iYxWFP1VS4SO5FCtRqtCAxkrA==
X-Received: by 2002:a5d:9da0:0:b0:783:68d0:9b34 with SMTP id ay32-20020a5d9da0000000b0078368d09b34mr10143861iob.7.1692906073075;
        Thu, 24 Aug 2023 12:41:13 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:12f4:1fa1:277e:6e17])
        by smtp.gmail.com with ESMTPSA id q24-20020a02c8d8000000b0042acf934cbasm50559jao.72.2023.08.24.12.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 12:41:12 -0700 (PDT)
Date:   Thu, 24 Aug 2023 13:41:08 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 1/9] libtraceeval: Add check for updates to know to
 recreate iter array
Message-ID: <20230824194108.GA110858@google.com>
References: <20230817222422.118568-1-rostedt@goodmis.org>
 <20230817222422.118568-2-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817222422.118568-2-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Aug 17, 2023 at 06:24:14PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> When an iterator is created, it creates an array of pointers to point to
> all the elements in the traceeval. This is used to index through the
> entities in an nice order. But if an event is added or removed from the
> traceeval, the size and count of this array will be off in the iterator.
> 
> Add an "update_counter" that gets incremented every time an item is added
> or removed (doesn't need to keep track of updates to existing entries). If
> the counter is different from the last time the iterator created the sort
> array, it will need to delete and recreate the list again before it can do
> a sort.
> 
> Note: It is safe to use the iterator to remove times, so a removal (or
                                                 items
> even insert) should not affect the traceeval_iterator_next(). But it
> should be explained in the man pages (soon to be written) that doing so
> must be done with care. And maybe a helper function should be used
> instead!
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  src/eval-local.h |  2 ++
>  src/histograms.c | 91 ++++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 74 insertions(+), 19 deletions(-)
<>
> @@ -1168,6 +1190,31 @@ static int iter_cmp(const void *A, const void *B, void *data)
>  	return 0;
>  }
>  
> +static int check_update(struct traceeval_iterator *iter)
> +{
> +	struct entry **entries;
> +	size_t nr_entries;
> +	int ret;
> +
> +	/* Was something added or removed from the teval? */
> +	if (iter->teval->update_counter == iter->update_counter)
> +		return 0;
> +
> +	entries = iter->entries;
> +	nr_entries = iter->nr_entries;
> +
> +	/* Something changed, need to recreate the array */
> +	ret = create_iter_array(iter);
> +	if (ret < 0) {
> +		iter->entries = entries;
> +		iter->nr_entries = nr_entries;
> +			return -1;

                ^^ extra tab

Aside from these 2 nits:

Reviewed-by: Ross Zwisler <zwisler@google.com>
