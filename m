Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1808FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Oct 2021 18:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFE1361425
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Oct 2021 18:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbhJDSuF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Oct 2021 14:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236069AbhJDSuF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Oct 2021 14:50:05 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2CC06140D;
        Mon,  4 Oct 2021 18:48:15 +0000 (UTC)
Date:   Mon, 4 Oct 2021 14:48:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 15/21] trace-cmd library: Track maximum CPUs count in
 input handler
Message-ID: <20211004144814.0b191b97@gandalf.local.home>
In-Reply-To: <20210914131232.3964615-16-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
        <20210914131232.3964615-16-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 14 Sep 2021 16:12:26 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> This clean up is needed for the design of the next trace file version,
> where only CPUs with trace data could be stored in the file. Each trace
> instance may have its own CPU count, depending on collected traces.
> As the main input handler is used by the top trace instance, the
> CPU count there is for the top trace instance and may differ with cpu
> counts of the other instances. Added a new "max_cpu" member of the input
> handler, that tracks the maximum CPU count of all instances, recorded in
> the file.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index cb8b9f14..dc82d3ea 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -125,6 +125,7 @@ struct tracecmd_input {
>  	int			long_size;
>  	int			page_size;
>  	int			page_map_size;
> +	int			max_cpu;
>  	int			cpus;
>  	int			ref;
>  	int			nr_buffers;	/* buffer instances */
> @@ -838,6 +839,7 @@ static int read_cpus(struct tracecmd_input *handle)
>  		return -1;
>  
>  	handle->cpus = cpus;
> +	handle->max_cpu = cpus;
>  	tep_set_cpus(handle->pevent, handle->cpus);
>  	handle->file_state = TRACECMD_FILE_CPU_COUNT;
>  
> @@ -2794,6 +2796,8 @@ static int handle_options(struct tracecmd_input *handle)
>  		case TRACECMD_OPTION_CPUCOUNT:
>  			cpus = *(int *)buf;
>  			handle->cpus = tep_read_number(handle->pevent, &cpus, 4);
> +			handle->max_cpu = handle->cpus;

Shouldn't this be:

			if (handles->cpus > handle->max_cpu)
				handle->max_cpu = handle->cpus;

??

-- Steve

> +			tep_set_cpus(handle->pevent, handle->cpus);
>  			break;
>  		case TRACECMD_OPTION_PROCMAPS:
>  			if (buf[size-1] == '\0')
> @@ -4074,7 +4078,7 @@ int tracecmd_page_size(struct tracecmd_input *handle)
>   */
>  int tracecmd_cpus(struct tracecmd_input *handle)
>  {
> -	return handle->cpus;
> +	return handle->max_cpu;
>  }
>  
>  /**

