Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C61C433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Mar 2021 21:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D3B2619D3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Mar 2021 21:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhCZVTD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Mar 2021 17:19:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhCZVSz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Mar 2021 17:18:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F181619D3;
        Fri, 26 Mar 2021 21:18:55 +0000 (UTC)
Date:   Fri, 26 Mar 2021 17:18:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 23/23] trace-cmd: Read at least 8 bytes trace-id
 option
Message-ID: <20210326171853.7a60b849@gandalf.local.home>
In-Reply-To: <20210325064055.539554-24-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
        <20210325064055.539554-24-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 25 Mar 2021 08:40:55 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> When reading the trace-id option from trace.dat file, check if the size
> is at least 8 bytes. If the size is greater, use the first 8 bytes only
> and ignore the rest. That way we can safely extend this option in the
> future, without breaking the legacy logic.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 513f6cc3..c0b47345 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -2703,7 +2703,7 @@ static int handle_options(struct tracecmd_input *handle)
>  				trace_pid_map_load(handle, buf);
>  			break;
>  		case TRACECMD_OPTION_TRACEID:
> -			if (size != 8)
> +			if (size < 8)
>  				break;
>  			handle->trace_id = tep_read_number(handle->pevent,
>  							   buf, 8);

This looks like it is unrelated to this patch set. I'm moving it to the
beginning, and will likely even add it to the v2.9 stable branch.

-- Steve
