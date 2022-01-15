Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900ECC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 Jan 2022 15:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiAOPUz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 10:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiAOPUy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 10:20:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726DCC061574
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 07:20:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 332F9B8006F
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 15:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79792C36AE7;
        Sat, 15 Jan 2022 15:20:51 +0000 (UTC)
Date:   Sat, 15 Jan 2022 10:20:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 11/25] trace-cmd library: Fit CPU latency trace data
 in the new trace file version 7 format
Message-ID: <20220115102050.627f5e89@rorschach.local.home>
In-Reply-To: <20211210105448.97850-12-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
        <20211210105448.97850-12-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 10 Dec 2021 12:54:34 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

More nitpicking about spacing ;-)

> Trace file version 7 format is based on sections. To fit the latency
> trace data in this structure, a new section and option for it is
> defined:
>   BUFFER_TEXT

space

> It is similar to the BUFFER section which holds the flyrecord binary
> data, but has a latency specific design for text data. The BUFFER_TEXT
> section has:
>  - section header, as all other sections
>  - compression of the trace data, optional
>  - corresponding trace option, pointing to the section
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  .../include/private/trace-cmd-private.h       |  1 +
>  lib/trace-cmd/trace-output.c                  | 24 ++++++++++++++++---
>  2 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index 047fc26f..d8ee9b74 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -145,6 +145,7 @@ enum {
>  	TRACECMD_OPTION_KALLSYMS,
>  	TRACECMD_OPTION_PRINTK,
>  	TRACECMD_OPTION_CMDLINES,
> +	TRACECMD_OPTION_BUFFER_TEXT,
>  	TRACECMD_OPTION_MAX,
>  };
>  
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index 44050dc8..47227728 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -1874,7 +1874,9 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
>  
>  struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
>  {
> +	enum tracecmd_section_flags flags = 0;
>  	struct tracecmd_output *handle;
> +	tsize_t offset;
>  	char *path;
>  
>  	handle = tracecmd_output_create(output_file);
> @@ -1891,7 +1893,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
>  
>  	if (tracecmd_write_cpus(handle, cpus) < 0)
>  		goto out_free;
> -
> +	if (tracecmd_write_buffer_info(handle) < 0)
> +		goto out_free;
>  	if (tracecmd_write_options(handle) < 0)
>  		goto out_free;
>  
> @@ -1901,23 +1904,38 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
>  		goto out_free;
>  	}
>  
> -	if (do_write_check(handle, "latency  ", 10))
> +	if (!HAS_SECTIONS(handle) && do_write_check(handle, "latency  ", 10))
>  		goto out_free;
>  
>  	path = get_tracing_file(handle, "trace");
>  	if (!path)
>  		goto out_free;
>  
> +	offset = do_lseek(handle, 0, SEEK_CUR);
> +	if (HAS_SECTIONS(handle) &&
> +	    !out_add_buffer_option_v7(handle, "", TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
> +		goto out_free;
> +
> +	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER_TEXT,
> +					  "buffer latency", flags, false);
> +
>  	copy_file(handle, path);
> +	if (out_update_section_header(handle, offset))
> +		goto out_free;
>  
>  	put_tracing_file(path);
>  
>  	handle->file_state = TRACECMD_FILE_CPU_LATENCY;
>  
> +	if (HAS_SECTIONS(handle))
> +		tracecmd_write_options(handle);
> +
>  	return handle;


>  
>  out_free:
> -	tracecmd_output_close(handle);
> +	if (handle)
> +		tracecmd_output_close(handle);
> +	unlink(output_file);

Hmm, how does the above play a role in this patch?

That is, what about this new BUFFER_TEXT required this change?
I mean, output_file is being removed now, but I don't see anything in
the rest of the patch to warrant that?

-- Steve


>  	return NULL;
>  }
>  

