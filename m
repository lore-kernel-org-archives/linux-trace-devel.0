Return-Path: <SRS0=G/lh=P5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82147C282DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jan 2019 09:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ECFD214DA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jan 2019 09:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbfAUJIg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Jan 2019 04:08:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbfAUJIg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Jan 2019 04:08:36 -0500
Received: from vmware.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D5AF2085A;
        Mon, 21 Jan 2019 09:08:35 +0000 (UTC)
Date:   Mon, 21 Jan 2019 04:08:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/7] trace-cmd: Added new option in trace.dat file for
 negative time offsets
Message-ID: <20190121040806.6fce022f@vmware.local.home>
In-Reply-To: <20190116191838.32127-3-tstoyanov@vmware.com>
References: <20190116191838.32127-1-tstoyanov@vmware.com>
        <20190116191838.32127-3-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.15.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Jan 2019 21:18:33 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index b628570..de15d4b 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -2151,6 +2151,7 @@ static int handle_options(struct tracecmd_input *handle)
>  			handle->ts_offset += offset;
>  			break;
>  		case TRACECMD_OPTION_OFFSET:
> +		case TRACECMD_OPTION_OFFSET_N:
>  			/*
>  			 * Similar to date option, but just adds an
>  			 * offset to the timestamp.
> @@ -2158,7 +2159,11 @@ static int handle_options(struct tracecmd_input *handle)
>  			if (handle->flags & TRACECMD_FL_IGNORE_DATE)
>  				break;
>  			offset = strtoll(buf, NULL, 0);
> -			handle->ts_offset += offset;
> +			if (option == TRACECMD_OPTION_OFFSET_N) {

Instead of adding a new option, couldn't we just make option a "long
long" and save a negative number in the trace.dat file? strtoll()
should be able to handle it.

-- Steve


> +				if (handle->ts_offset > offset)
> +					handle->ts_offset -= offset;
> +			} else
> +				handle->ts_offset += offset;
>  			break;
>  		case TRACECMD_OPTION_CPUSTAT:
>  			buf[size-1] = '\n';
