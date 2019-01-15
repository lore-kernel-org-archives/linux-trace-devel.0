Return-Path: <SRS0=27yZ=PX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A268BC43387
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jan 2019 15:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7277A20675
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jan 2019 15:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfAOPFd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Jan 2019 10:05:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727868AbfAOPFd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Jan 2019 10:05:33 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59E1E20656;
        Tue, 15 Jan 2019 15:05:32 +0000 (UTC)
Date:   Tue, 15 Jan 2019 10:05:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] kernel-shark-qt: Handle the case when the range of the
 model is too small
Message-ID: <20190115100530.13a5645f@gandalf.local.home>
In-Reply-To: <20190115101857.25857-1-ykaradzhov@vmware.com>
References: <20190115101857.25857-1-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 15 Jan 2019 12:18:57 +0200
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> The size of the bin must be equal or greater than 1, hence the range
> must be equal or greater than the number of bins. When this condition
> is not satisfied, the range has to be extended, instead of just leaving
> the model unset.
> 
> Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

You forgot to add:

Fixes: f97e31f00 ("kernel-shark-qt: Introduce the visualization model used by the Qt-based KS")

;-)

-- Steve

> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark-qt/src/libkshark-model.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel-shark-qt/src/libkshark-model.c b/kernel-shark-qt/src/libkshark-model.c
> index 76e2940..2094795 100644
> --- a/kernel-shark-qt/src/libkshark-model.c
> +++ b/kernel-shark-qt/src/libkshark-model.c
> @@ -102,8 +102,10 @@ static void ksmodel_set_in_range_bining(struct kshark_trace_histo *histo,
>  	struct kshark_entry *last;
>  
>  	/* The size of the bin must be >= 1, hence the range must be >= n. */
> -	if (n == 0 || range < n)
> -		return;
> +	if (n == 0 || range < n) {
> +		range = n;
> +		max = min + n;
> +	}
>  
>  	/*
>  	 * If the number of bins changes, allocate memory for the descriptor of

