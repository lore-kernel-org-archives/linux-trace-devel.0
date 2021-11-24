Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54844C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 19:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235610AbhKXTzE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 14:55:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:36268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235076AbhKXTzE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 14:55:04 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DF2160E94;
        Wed, 24 Nov 2021 19:51:54 +0000 (UTC)
Date:   Wed, 24 Nov 2021 14:51:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 24/25] trace-cmd: Call additional APIs when creating
 trace file
Message-ID: <20211124145151.1b5cd041@gandalf.local.home>
In-Reply-To: <20211111151133.86788-5-tz.stoyanov@gmail.com>
References: <20211111151133.86788-1-tz.stoyanov@gmail.com>
        <20211111151133.86788-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 17:11:32 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
> index 8d2fcae8..a903c21a 100644
> --- a/tracecmd/trace-restore.c
> +++ b/tracecmd/trace-restore.c
> @@ -163,6 +163,7 @@ void trace_restore (int argc, char **argv)
>  
>  	if (tracecmd_append_cpu_data(handle, args, &argv[first_arg]) < 0)
>  		die("failed to append data");
> -
> +	if (tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)
> +		tracecmd_write_options(handle);

I wonder if we are just missing a tracecmd_output_close() here?

And that will write the options as I mentioned before.

>  	return;
>  }
> diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
> index e4a0c3b3..671d6e9f 100644
> --- a/tracecmd/trace-split.c
> +++ b/tracecmd/trace-split.c
> @@ -391,6 +391,9 @@ static double parse_file(struct tracecmd_input *handle,
>  	if (tracecmd_append_cpu_data(ohandle, cpus, cpu_list) < 0)
>  		die("Failed to append tracing data\n");
>  
> +	if (tracecmd_get_out_file_version(ohandle) >= FILE_VERSION_SECTIONS)
> +		tracecmd_write_options(ohandle);
> +

And no more is written here to ohandle, and the close should fix it as well.

-- Steve

>  	current = end;
>  	for (cpu = 0; cpu < cpus; cpu++) {
>  		/* Set the tracecmd cursor to the next set of records */

