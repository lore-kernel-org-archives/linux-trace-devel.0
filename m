Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3FEC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 23:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D84820830
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 23:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfDOXeN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 19:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbfDOXeN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 19:34:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E27A02064B;
        Mon, 15 Apr 2019 23:34:11 +0000 (UTC)
Date:   Mon, 15 Apr 2019 19:34:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Raul E Rangel <rrangel@chromium.org>
Cc:     linux-mmc@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        djkurtz@chromium.org, zwisler@chromium.org,
        hongjiefang <hongjiefang@asrmicro.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Kyle Roeschley <kyle.roeschley@ni.com>,
        Avri Altman <avri.altman@wdc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v1 2/4] mmc: core: Add trace event for SD SSR response
Message-ID: <20190415193410.2b33d1d6@gandalf.local.home>
In-Reply-To: <20190415225241.70088-2-rrangel@chromium.org>
References: <20190415225241.70088-1-rrangel@chromium.org>
        <20190415225241.70088-2-rrangel@chromium.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 15 Apr 2019 16:52:39 -0600
Raul E Rangel <rrangel@chromium.org> wrote:

> Example:
> sd_ssr: mmc0: au: 8192, erase time: 0, erase offset: 0x0, raw: {0x0,0x3000000,0x1019000,0x10000,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0}
> 
> Signed-off-by: Raul E Rangel <rrangel@chromium.org>
> ---
> 
>  drivers/mmc/core/sd.c      |  2 ++
>  include/trace/events/mmc.h | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
> index 3bed7c4b6d75..cc33a4f96c6a 100644
> --- a/drivers/mmc/core/sd.c
> +++ b/drivers/mmc/core/sd.c
> @@ -282,6 +282,8 @@ static int mmc_read_ssr(struct mmc_card *card)
>  		}
>  	}
>  
> +	trace_sd_ssr(card);
> +
>  	/*
>  	 * starting SD5.1 discard is supported if DISCARD_SUPPORT (b313) is set
>  	 */
> diff --git a/include/trace/events/mmc.h b/include/trace/events/mmc.h
> index e45258e8a6cb..cad604ee800f 100644
> --- a/include/trace/events/mmc.h
> +++ b/include/trace/events/mmc.h
> @@ -52,6 +52,37 @@ TRACE_EVENT(sd_scr,
>  	)
>  );
>  
> +TRACE_EVENT(sd_ssr,
> +
> +	TP_PROTO(struct mmc_card *card),
> +
> +	TP_ARGS(card),
> +
> +	TP_STRUCT__entry(
> +		__array(u32,			raw,	16)
> +		__field(unsigned int,		au)
> +		__field(unsigned int,		erase_timeout)
> +		__field(unsigned int,		erase_offset)
> +		__string(name,			mmc_hostname(card->host))
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->raw, card->raw_ssr, sizeof(card->raw_ssr));

Again, memcpy() with the size of the source is dangerous.

Hmm, I wonder if a BUILD_BUG_ON(sizeof(u32)*16 < sizeof(card->raw_ssr))
would work here too. If it does, then that would be another approach.

-- Steve

> +		__entry->au = card->ssr.au;
> +		__entry->erase_timeout = card->ssr.erase_timeout;
> +		__entry->erase_offset = card->ssr.erase_offset;
> +		__assign_str(name, mmc_hostname(card->host));
> +	),
> +
> +	TP_printk("%s: au: %d, erase time: %d, erase offset: %#x, raw: %s",
> +		  __get_str(name),
> +		  __entry->au,
> +		  __entry->erase_timeout,
> +		  __entry->erase_offset,
> +		  __print_array(__entry->raw, 16, sizeof(u32))
> +	)
> +);
> +
>  TRACE_EVENT(mmc_request_start,
>  
>  	TP_PROTO(struct mmc_host *host, struct mmc_request *mrq),

