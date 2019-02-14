Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B931C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 21:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55D5A21B24
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 21:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392914AbfBNVHD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 16:07:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392805AbfBNVHC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 16:07:02 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF8EA2089F;
        Thu, 14 Feb 2019 21:07:01 +0000 (UTC)
Date:   Thu, 14 Feb 2019 16:07:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v6 10/11] trace-cmd: Add splice() recording from
 FIFO without additional pipe buffer
Message-ID: <20190214160700.638ddd4e@gandalf.local.home>
In-Reply-To: <20190214141335.28144-11-kaslevs@vmware.com>
References: <20190214141335.28144-1-kaslevs@vmware.com>
        <20190214141335.28144-11-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 Feb 2019 16:13:34 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> @@ -487,7 +538,10 @@ long tracecmd_flush_recording(struct tracecmd_recorder *recorder)
>  
>  int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long sleep)
>  {
> -	struct timespec req;
> +	struct timespec req = {
> +		.tv_sec = sleep / 1000000,
> +		.tv_nsec = (sleep % 1000000) * 1000,
> +	};
>  	long read = 1;
>  	long ret;
>  
> @@ -495,17 +549,12 @@ int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long s
>  
>  	do {
>  		/* Only sleep if we did not read anything last time */
> -		if (!read && sleep) {
> -			req.tv_sec = sleep / 1000000;
> -			req.tv_nsec = (sleep % 1000000) * 1000;
> +		if (!read && sleep)
>  			nanosleep(&req, NULL);
> -		}
> +

The above change is really a clean up and should be a separate patch as
well.

-- Steve

>  		read = 0;
>  		do {
> -			if (recorder->flags & TRACECMD_RECORD_NOSPLICE)
> -				ret = read_data(recorder);
> -			else
> -				ret = splice_data(recorder);
> +			ret = move_data(recorder);
>  			if (ret < 0)
>  				return ret;
>  			read += ret;

