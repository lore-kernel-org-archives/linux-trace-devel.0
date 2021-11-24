Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F336EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 19:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351216AbhKXTdX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 14:33:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243674AbhKXTdM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 14:33:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D38860F58;
        Wed, 24 Nov 2021 19:30:02 +0000 (UTC)
Date:   Wed, 24 Nov 2021 14:30:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 12/25] trace-cmd library: Do not write CPUs with
 empty trace data
Message-ID: <20211124143000.1a21c1a1@gandalf.local.home>
In-Reply-To: <20211111151112.86751-3-tz.stoyanov@gmail.com>
References: <20211111151112.86751-1-tz.stoyanov@gmail.com>
        <20211111151112.86751-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 17:11:05 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Trace file version 7 has more flexible design, which allows to write only
> CPUs with trace data in the file. If a CPU has no recorded trace data,
> do not put it in the trace file version 7.
> 

Will both trace-cmd record and report still report that a CPU had no data?
Because that is useful information.

-- Steve


> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-output.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index 028ad580..2ed7155b 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -2079,8 +2079,10 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
>  
>  	if (i < cpus)
>  		ret = -1;
> -	else
> +	else if (size || !HAS_SECTIONS(handle))
>  		ret = out_write_cpu_data(handle, cpus, data, buff_name);
> +	else
> +		ret = 0;
>  
>  	for (i--; i >= 0; i--)
>  		close(data[i].fd);

