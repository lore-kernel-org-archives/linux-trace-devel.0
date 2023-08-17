Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B7ECC2FC22
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 19:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353078AbjHQT36 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 15:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353274AbjHQT3d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 15:29:33 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D7C2D4A
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 12:29:31 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-349a94f3d69so3406375ab.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 12:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692300571; x=1692905371;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JAEtcKNHFiE/dYRTTl9omYvw39fc2X6AAb4+9iaUol8=;
        b=dgNAwPYNtK0PbSAcf17SKqX/YDVSAFG/YDhV6cDm0v77WPu7yuWJN551v0Ojzy9dF5
         2z1j7qDQfkSkodZuJi0n5jfTUKPBSbCV2yStJ2+P+8NP8rV+MCWOuoB+8c+6GW1xD4T9
         RKphqfVSCIntPcFzNscgRP30BUXEIaXQCF3AAa4avB3uC85WhkPnyCBiEEODnojdLHDb
         HncFuWj4knLPmQVWmLcWEf+ASWq7EUUModXQbmSzMaBpqmu4HrpzP0lTp28povRYokUI
         whjxk07shrPNwwX2XWdX2aPqzAVH1dso2f+F5+fo24FWGNQkXwZfLTK8U3NtBgzqf8gI
         TXjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692300571; x=1692905371;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAEtcKNHFiE/dYRTTl9omYvw39fc2X6AAb4+9iaUol8=;
        b=Uk7cxmG4aQEAp63modwNI7IW7gFZTgmEJYwgBndqt803ZRjtDRL4NNnmoGYt0Kf5Ql
         0EO6S+0rNKeO3MmnIQ5Moap9BWuVCtrjQF8A1ktqRBOUyLew2XEarpz4BsnOp0D4wprZ
         nfjZjsxfAP0HpSmu0/ktYOwUPrHczDTB2opT8nRbG21Z92E/0yqhVoknJD1qnZWLZk2M
         TXkMjLAw02IDRjjRgPFGE94wU4Yp6Vp7DxJVaJFC8wbT8eIoj2E5hEkV+pvCFJbZSrex
         1StThFhVoix8MZtSmlxcDlGW+fWxSmGkLb1Fivwlk9nP0CSOX5Ts6ytNvfiN07vAgRch
         lPAw==
X-Gm-Message-State: AOJu0YzzZf5OOoJ23sF9JzyDaTqzH/X7kt5Cfpih69/T33vMDrcRCqYQ
        INug7HqF0rqJCLd8SjAXKYbA4g==
X-Google-Smtp-Source: AGHT+IFcGgL1rtoPa3tHMKu2eMqYAP8FKqIfoZqPjY++eydTssdQQzJXJj8fMRUsBSrplnTcFn+xaw==
X-Received: by 2002:a05:6e02:e11:b0:349:9988:fc51 with SMTP id a17-20020a056e020e1100b003499988fc51mr302677ilk.14.1692300570738;
        Thu, 17 Aug 2023 12:29:30 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:b4cc:633b:f35:be2e])
        by smtp.gmail.com with ESMTPSA id q11-20020a92d40b000000b0034886587bdcsm55791ilm.18.2023.08.17.12.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 12:29:29 -0700 (PDT)
Date:   Thu, 17 Aug 2023 13:29:26 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v3 14/18] libtraceeval histogram: Use stack for old copy
 in update
Message-ID: <20230817192926.GA73817@google.com>
References: <20230817013310.88582-1-rostedt@goodmis.org>
 <20230817013310.88582-15-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817013310.88582-15-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Aug 16, 2023 at 09:33:06PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> In the update, instead of using the heap, use the stack to save the old
> values. This should save time where it does not need to allocate and then
> free the value list to do an update.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  src/histograms.c | 51 ++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 38 insertions(+), 13 deletions(-)
> 
> diff --git a/src/histograms.c b/src/histograms.c
> index 57b4b2166e3b..3050bad4190e 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
<>
> @@ -776,15 +782,34 @@ fail_entry:
>  static int update_entry(struct traceeval *teval, struct entry *entry,
>  			const union traceeval_data *vals)
>  {
> -	union traceeval_data *new_vals;
> +	struct traceeval_stat *stats = entry->val_stats;
> +	struct traceeval_type *types = teval->val_types;
> +	union traceeval_data *copy = entry->vals;
> +	union traceeval_data old[teval->nr_val_types];
> +	size_t size = teval->nr_val_types;
> +	size_t i;
>  
> -	if (copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
> -				vals, entry->val_stats, &new_vals) == -1)
> -		return -1;
> +	if (!size)
> +		return 0;
>  
> -	clean_data_set(entry->vals, teval->val_types, teval->nr_val_types);
> -	entry->vals = new_vals;
> +	for (i = 0; i < size; i++) {
> +		old[i] = copy[i];
> +
> +		if (copy_traceeval_data(types + i, stats + i,
> +					vals + i, copy + i))
> +			goto fail;
> +	}
> +	data_release(size, old, types);
>  	return 0;
> + fail:
> +	/* Free the new values that were added */
> +	data_release(i, copy, types);
> +	/* Put back the old values */
> +	for (i--; i >= 0; i--) {
> +		copy_traceeval_data(types + i, NULL,
> +				    copy + i, old + i);

should be:                          old + i, copy + i);

Right now we're copying 'copy' into 'old', but we want to be doing it the
other way around so we restore 'copy' back to its saved state in 'old'

> +	}
> +	return -1;
>  }
>  
>  struct traceeval_stat *traceeval_stat(struct traceeval *teval,
> -- 
> 2.40.1
> 
