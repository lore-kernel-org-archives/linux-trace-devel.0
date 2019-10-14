Return-Path: <SRS0=9oY8=YH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51130ECE587
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Oct 2019 14:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30B1820854
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Oct 2019 14:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732423AbfJNOHI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Oct 2019 10:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732337AbfJNOHI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Oct 2019 10:07:08 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA9F72083B;
        Mon, 14 Oct 2019 14:07:07 +0000 (UTC)
Date:   Mon, 14 Oct 2019 10:07:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Fix segmentation fault in tracecmd_read_at()
 in specific use case
Message-ID: <20191014100706.3c8d0cef@gandalf.local.home>
In-Reply-To: <20191011113353.11652-1-tz.stoyanov@gmail.com>
References: <20191011113353.11652-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 11 Oct 2019 14:33:53 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> There is a segmentation fault in update_page_info() when the requested page
> is not loaded, handle->cpu_data[cpu].page is NULL. The problematic flow starts
> from tracecmd_read_at() API, when reading offset in the first page (less than 4K),
> and this page is still not loaded yet. The problem can be observed randomly -
> there is a sporadic KernelShark crash when loading a file, browsing and
> zooming events.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=205165
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 6102eb3..da77418 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -1278,7 +1278,8 @@ tracecmd_read_at(struct tracecmd_input *handle, unsigned long long offset,
>  	/* check to see if we have this page already */
>  	for (cpu = 0; cpu < handle->cpus; cpu++) {
>  		if (handle->cpu_data[cpu].offset == page_offset &&
> -		    handle->cpu_data[cpu].file_size)
> +		    handle->cpu_data[cpu].file_size &&
> +		    handle->cpu_data[cpu].page)
>  			break;
>  	}
>  

This does indeed look like a legit bug. But instead of checking here
for page not existing, since it's not part of the criteria for finding
the page (if the offset matches, we still want to break), lets do the
check below:

	if (cpu < handle->cpus && handle->cpu_data[cpu].page) {
		if (pcpu)
			*pcpu = cpu;
		return read_event(handle, offset, cpu);
	} else
		return find_and_read_event(handle, offset, pcpu);

-- Steve
