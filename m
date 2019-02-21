Return-Path: <SRS0=APAm=Q4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA7CC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Feb 2019 16:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B19CD20836
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Feb 2019 16:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfBUQPk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:15:40 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:47048 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfBUQPk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Feb 2019 11:15:40 -0500
Received: by mail-wr1-f68.google.com with SMTP id i16so23008903wrs.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Feb 2019 08:15:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VaEFJaKiVbzs3tVm3g9eECZyMC73+EsbonGsLYkIbFA=;
        b=XKTCAdOjlBhHbRo1Nu4PhPMyvNeVS/s3fG7dajTYzciwJloi0uXnBfOsF2jRHePHIG
         Bjh7QB4Cf0zgIW3N/Dh8GQeKK7wm2hP1d6oTNcbTQ3jJbpBzq8mCLZnB5EmX7wiazOKB
         BQ7mPIIZQ/zjN4aIbcGc1HVwgrsJHwErmdU1hz40+5hN5mBzFHyPoKHwyjTTsBO7TGGT
         9CGPO/Bc9qPEZ+ZQaMgOL6qoX2fr8E636sXbDxcU6vwKMvV9OgcBB147a3V5WNQ/g64P
         YFrkkHChYjzAuJa74K/+lrDlZul4/ABExZvJ0DB3EIut0xGCz+lmX5hr0qLdXBjSBrGw
         S/dg==
X-Gm-Message-State: AHQUAuYQVEFDkCB85Rp/GRAerbFWIjY3t9UZWagewSydqnmfDqwXAZ5p
        BqyIHFP7NWIgk2VWqGnZpg==
X-Google-Smtp-Source: AHgI3IZvKsMUqkTbg5RywNWJ5RBDa2+cPh45Tge+XWj/5I/gtajV8tbayW8M1CQeRRBNeGOM5z8dNQ==
X-Received: by 2002:adf:fb0d:: with SMTP id c13mr3850343wrr.285.1550765738132;
        Thu, 21 Feb 2019 08:15:38 -0800 (PST)
Received: from box ([151.251.254.18])
        by smtp.gmail.com with ESMTPSA id r70sm8812247wme.46.2019.02.21.08.15.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 21 Feb 2019 08:15:37 -0800 (PST)
Date:   Thu, 21 Feb 2019 18:15:32 +0200
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] kernel-shark: Fix a bug in
 ksmodel_set_next_bin_edge()
Message-ID: <20190221161530.GA16009@box>
References: <20190221124205.21115-1-ykaradzhov@vmware.com>
 <20190221124205.21115-4-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190221124205.21115-4-ykaradzhov@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 21, 2019 at 02:42:05PM +0200, Yordan Karadzhov wrote:
> The modification of the last bin of the model makes no sense (this is
> my mistake). The comment above the code that is doing this modification
> is partially correct, however it speaks about increasing the size of
> the last bin, while the code below the comment changes the lower edge
> of this bin. The actual increase of the size of the last bin is done in
> ksmodel_set_upper_edge() where the lower edge of the Upper Overflow bin
> gets shifted (max + 1). This effectively increases the size of the last bin.
> 
> Reported-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> Fixes: f97e31f00 ("kernel-shark-qt: Introduce the visualization model ..")
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/libkshark-model.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
> index b6d3612..4bd1e2c 100644
> --- a/kernel-shark/src/libkshark-model.c
> +++ b/kernel-shark/src/libkshark-model.c
> @@ -266,15 +266,6 @@ static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
>  	/* Calculate the beginning of the next bin. */
>  	time = histo->min + next_bin * histo->bin_size;
>  
> -	/*
> -	 * The timestamp of the very last entry of the dataset can be exactly
> -	 * equal to the value of the upper edge of the range. This is very
> -	 * likely to happen when we use ksmodel_set_in_range_bining(). In this
> -	 * case we have to increase the size of the very last bin in order to
> -	 * make sure that the last entry of the dataset will fall into it.
> -	 */
> -	if (next_bin == histo->n_bins - 1)
> -		++time;
>  	/*
>  	 * Find the index of the first entry inside
>  	 * the next bin (timestamp > time).
> -- 
> 2.17.1
> 

Patches 1, 2 and 3 look good to me.

Acked-by: Slavomir Kaslev <kaslevs@vmware.com>

Side note: ksmodel_shift_backward/ksmodel_shift_forward look pretty similar. Can
they be generalized to an either-directional ksmodel_shift taking the shift
parameter as signed? If ksmodel_shift_backward/ksmodel_shift_forward need to be
kept for backward compatibility, they can call ksmodel_shift (with a flipped
sign in the backward case).

Thank you,

-- Slavi
