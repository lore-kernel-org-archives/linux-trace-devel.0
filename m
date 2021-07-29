Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE68C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 19:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7841860BD3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 19:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhG2ThG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 15:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhG2ThF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 15:37:05 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4EC960C3F;
        Thu, 29 Jul 2021 19:37:01 +0000 (UTC)
Date:   Thu, 29 Jul 2021 15:36:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 04/87] trace-cmd library: Fixed a memory leak on
 input handler close
Message-ID: <20210729153655.7086f4d9@oasis.local.home>
In-Reply-To: <20210729050959.12263-5-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:08:36 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> When an input hanlder to a trace file is closed with tracecmd_close(),
> the list with buffers is not freed. This leads to a memory leak. Added
> logic to free that list.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 33 +++++++++++++++++++--------------
>  1 file changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 9253bc37..af11cbc6 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -3483,7 +3483,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
>   */
>  void tracecmd_close(struct tracecmd_input *handle)
>  {
> -	int cpu;
> +	int i;

It's OK to add int i. There's no reason to rename cpu, as I believe the
"cpu" variable is still appropriate. The compiled code will have no
difference, as its a simple optimization to merge multiple local variables.

>  
>  	if (!handle)
>  		return;
> @@ -3496,21 +3496,21 @@ void tracecmd_close(struct tracecmd_input *handle)
>  	if (--handle->ref)
>  		return;
>  
> -	for (cpu = 0; cpu < handle->cpus; cpu++) {
> +	for (i = 0; i < handle->cpus; i++) {
>  		/* The tracecmd_peek_data may have cached a record */
> -		free_next(handle, cpu);
> -		free_page(handle, cpu);
> -		if (handle->cpu_data && handle->cpu_data[cpu].kbuf) {
> -			kbuffer_free(handle->cpu_data[cpu].kbuf);
> -			if (handle->cpu_data[cpu].page_map)
> -				free_page_map(handle->cpu_data[cpu].page_map);
> -
> -			if (handle->cpu_data[cpu].page_cnt)
> +		free_next(handle, i);
> +		free_page(handle, i);
> +		if (handle->cpu_data && handle->cpu_data[i].kbuf) {
> +			kbuffer_free(handle->cpu_data[i].kbuf);
> +			if (handle->cpu_data[i].page_map)
> +				free_page_map(handle->cpu_data[i].page_map);
> +
> +			if (handle->cpu_data[i].page_cnt)
>  				tracecmd_warning("%d pages still allocated on cpu %d%s",
> -						 handle->cpu_data[cpu].page_cnt, cpu,
> -						 show_records(handle->cpu_data[cpu].pages,
> -							      handle->cpu_data[cpu].nr_pages));
> -			free(handle->cpu_data[cpu].pages);
> +						 handle->cpu_data[i].page_cnt, i,
> +						 show_records(handle->cpu_data[i].pages,
> +							      handle->cpu_data[i].nr_pages));
> +			free(handle->cpu_data[i].pages);

One reason not to change it, is because I'm staring at this code trying
to figure out what logical change happened here. Then I realize, that
it's just a variable change.

Let's just add "int i" and keep "int cpu". Especially since I plan on
backporting this patch, and I don't need unnecessary conflicts to deal
with.

>  		}
>  	}
>  
> @@ -3521,6 +3521,11 @@ void tracecmd_close(struct tracecmd_input *handle)
>  	free(handle->version);
>  	close(handle->fd);
>  
> +	for (i = 0; i < handle->nr_buffers; i++)
> +		free(handle->buffers[i].name);
> +
> +	free(handle->buffers);

I take it, this patch only does the above.

-- Steve

> +
>  	tracecmd_free_hooks(handle->hooks);
>  	handle->hooks = NULL;
>  

