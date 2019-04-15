Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73664C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 23:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A05520830
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 23:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfDOXbi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 19:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbfDOXbh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 19:31:37 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5868020830;
        Mon, 15 Apr 2019 23:31:35 +0000 (UTC)
Date:   Mon, 15 Apr 2019 19:31:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Raul E Rangel <rrangel@chromium.org>
Cc:     linux-mmc@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        djkurtz@chromium.org, zwisler@chromium.org,
        hongjiefang <hongjiefang@asrmicro.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Kyle Roeschley <kyle.roeschley@ni.com>,
        Avri Altman <avri.altman@wdc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v1 1/4] mmc: core: Add trace event for SD SCR response
Message-ID: <20190415193133.2cdbc6d0@gandalf.local.home>
In-Reply-To: <20190415225241.70088-1-rrangel@chromium.org>
References: <20190415225241.70088-1-rrangel@chromium.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 15 Apr 2019 16:52:38 -0600
Raul E Rangel <rrangel@chromium.org> wrote:

> Example:
> sd_scr: mmc0: version: 2, spec3: 1, width: 5, cmds: 0, raw: {0x2b58000,0x0}
> 
> Signed-off-by: Raul E Rangel <rrangel@chromium.org>
> ---
> 
>  drivers/mmc/core/sd.c      |  4 ++++
>  include/trace/events/mmc.h | 42 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 46 insertions(+)
> 
> diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
> index 265e1aeeb9d8..3bed7c4b6d75 100644
> --- a/drivers/mmc/core/sd.c
> +++ b/drivers/mmc/core/sd.c
> @@ -21,6 +21,8 @@
>  #include <linux/mmc/mmc.h>
>  #include <linux/mmc/sd.h>
>  
> +#include <trace/events/mmc.h>
> +
>  #include "core.h"
>  #include "card.h"
>  #include "host.h"
> @@ -200,6 +202,7 @@ static int mmc_decode_scr(struct mmc_card *card)
>  	if (scr_struct != 0) {
>  		pr_err("%s: unrecognised SCR structure version %d\n",
>  			mmc_hostname(card->host), scr_struct);
> +		trace_sd_scr(card, NULL);
>  		return -EINVAL;
>  	}
>  
> @@ -221,6 +224,7 @@ static int mmc_decode_scr(struct mmc_card *card)
>  
>  	if (scr->sda_spec3)
>  		scr->cmds = UNSTUFF_BITS(resp, 32, 2);
> +	trace_sd_scr(card, scr);
>  	return 0;
>  }
>  
> diff --git a/include/trace/events/mmc.h b/include/trace/events/mmc.h
> index 7b706ff21335..e45258e8a6cb 100644
> --- a/include/trace/events/mmc.h
> +++ b/include/trace/events/mmc.h
> @@ -10,6 +10,48 @@
>  #include <linux/mmc/host.h>
>  #include <linux/tracepoint.h>
>  
> +TRACE_EVENT(sd_scr,
> +
> +	TP_PROTO(struct mmc_card *card, struct sd_scr *scr),
> +
> +	TP_ARGS(card, scr),
> +
> +	TP_STRUCT__entry(
> +		__array(u32,			raw,	2)
> +		__field(unsigned char,		sda_vsn)
> +		__field(unsigned char,		sda_spec3)
> +		__field(unsigned char,		bus_widths)
> +		__field(unsigned char,		cmds)
> +		__string(name,			mmc_hostname(card->host))
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->raw, card->raw_scr, sizeof(card->raw_scr));

Having the memcpy() size be that of the source is dangerous. Not that
the destination will every be smaller, but I would highly suggest
either trying to see if "sizeof(__entry->raw)" works or at worse,
sizeof(u32)*2.

-- Steve

> +		if (scr) {
> +			__entry->sda_vsn = scr->sda_vsn;
> +			__entry->sda_spec3 = scr->sda_spec3;
> +			__entry->bus_widths = scr->bus_widths;
> +			__entry->cmds = scr->cmds;
> +		} else {
> +			__entry->sda_vsn = 0;
> +			__entry->sda_spec3 = 0;
> +			__entry->bus_widths = 0;
> +			__entry->cmds = 0;
> +		}
> +		__assign_str(name, mmc_hostname(card->host));
> +	),
> +
> +	TP_printk("%s: version: %d, spec3: %d, width: %d, cmds: %d, "
> +		"raw: %s",
> +		  __get_str(name),
> +		  __entry->sda_vsn,
> +		  __entry->sda_spec3,
> +		  __entry->bus_widths,
> +		  __entry->cmds,
> +		  __print_array(__entry->raw, 2, sizeof(u32))
> +	)
> +);
> +
>  TRACE_EVENT(mmc_request_start,
>  
>  	TP_PROTO(struct mmc_host *host, struct mmc_request *mrq),

