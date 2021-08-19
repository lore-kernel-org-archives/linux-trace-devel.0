Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6021C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 932B660F39
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbhHSTXE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 15:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233662AbhHSTXE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 15:23:04 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ABE860F5C;
        Thu, 19 Aug 2021 19:22:27 +0000 (UTC)
Date:   Thu, 19 Aug 2021 15:22:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 60/87] trace-cmd report: Init the top trace instance
 earlier
Message-ID: <20210819152225.6a4d9fa2@oasis.local.home>
In-Reply-To: <20210729050959.12263-61-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-61-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:09:32 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The instance must be initialized before calling the tracecmd_cpus() API,
> as in trace files version 7, CPU count is set when the trace data are
> initialized.

This should have been an earlier patch.

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-read.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
> index 1868a830..cafceffe 100644
> --- a/tracecmd/trace-read.c
> +++ b/tracecmd/trace-read.c
> @@ -1217,6 +1217,11 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
>  	list_for_each_entry(handles, handle_list, list) {
>  		int cpus;
>  
> +		if (!tracecmd_is_buffer_instance(handles->handle)) {
> +			ret = tracecmd_init_data(handles->handle);
> +			if (ret < 0)
> +				die("failed to init data");
> +		}
>  		cpus = tracecmd_cpus(handles->handle);
>  		handles->cpus = cpus;
>  		handles->last_timestamp = calloc(cpus, sizeof(*handles->last_timestamp));
> @@ -1227,9 +1232,6 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
>  		if (tracecmd_is_buffer_instance(handles->handle))
>  			continue;
>  
> -		ret = tracecmd_init_data(handles->handle);
> -		if (ret < 0)
> -			die("failed to init data");
>  		if (align_ts) {
>  			ts = tracecmd_get_first_ts(handles->handle);
>  			if (first || first_ts > ts)

