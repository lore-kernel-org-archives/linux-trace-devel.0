Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82267C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 19:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350958AbhKXTaV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 14:30:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:58164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243400AbhKXTaU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 14:30:20 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 116D360E95;
        Wed, 24 Nov 2021 19:27:09 +0000 (UTC)
Date:   Wed, 24 Nov 2021 14:27:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 09/25] trace-cmd record: Append trace options after
 the trace data are written
Message-ID: <20211124142708.4a1f1cdf@gandalf.local.home>
In-Reply-To: <20211111150933.86678-1-tz.stoyanov@gmail.com>
References: <20211111150933.86678-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 17:09:33 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> In trace file version 7, the CPU trace metadata is saved in a trace
> option. As this metadata has file offsets, which depend on the CPU trace
> data, the option must be written in the file after the CPU trace data.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-record.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 757dab0f..32270e20 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -4449,6 +4449,9 @@ static void write_guest_file(struct buffer_instance *instance)
>  
>  	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files, NULL) < 0)
>  		die("failed to write CPU data");
> +	if (tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)

Can't this be detected on close?

That is, if the handle has pending options to write out, and the handle has
sections, can't the tracecmd_output_close() write it out then?

Why make this something the user must worry about?

-- Steve

> +		tracecmd_write_options(handle);
> +
>  	tracecmd_output_close(handle);
>  
>  	for (i = 0; i < cpu_count; i++)
> @@ -4597,7 +4600,8 @@ static void record_data(struct common_record_context *ctx)
>  				append_buffer(handle, instance, temp_files);
>  			}
>  		}
> -
> +		if (tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)
> +			tracecmd_write_options(handle);
>  		free(temp_files);
>  	}
>  	if (!handle)

