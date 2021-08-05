Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B3AC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Aug 2021 21:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C88B61102
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Aug 2021 21:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbhHEV1j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Aug 2021 17:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229811AbhHEV1j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 17:27:39 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 347D160F02;
        Thu,  5 Aug 2021 21:27:24 +0000 (UTC)
Date:   Thu, 5 Aug 2021 17:27:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 20/87] trace-cmd library: Compress part of the trace
 file
Message-ID: <20210805172717.4e443fe1@oasis.local.home>
In-Reply-To: <20210729050959.12263-21-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-21-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:08:52 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> @@ -384,26 +384,30 @@ static int read_header_files(struct tracecmd_output *handle)
>  	if (!path)
>  		return -1;
>  
> +	if (compress)
> +		out_compression_start(handle);
>  	ret = stat(path, &st);
>  	if (ret < 0) {


> -
> +	if (compress && out_compression_end(handle))
> +		goto out_close;
>  	handle->file_state = TRACECMD_FILE_HEADERS;
>  


> -
> +	if (compress)
> +		out_compression_start(handle);
>  	ret = copy_event_system(handle, systems);
> -
> +	if (compress) {
> +		if (!ret)
> +			ret = out_compression_end(handle);
> +		else
> +			out_compression_reset(handle);
> +	}


> -
> +	if (compress)
> +		out_compression_start(handle);
>  	ret = -1;
>  	endian4 = convert_endian_4(handle, count);
>  	if (do_write_check(handle, &endian4, 4))
> @@ -763,9 +777,19 @@ static int read_event_files(struct tracecmd_output *handle,
>  		}
>  		ret = copy_event_system(handle, slist);
>  	}
> -
> -	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
> +	if (ret)
> +		goto out_free;
> +	if (compress) {
> +		ret = out_compression_end(handle);
> +		if (ret)
> +			goto out_free;
> +	}


> @@ -827,19 +851,21 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
>  	if (handle->kallsyms)
>  		path = handle->kallsyms;
>  
> +	if (compress)
> +		out_compression_start(handle);


> -
> -	return 0;
> +	if (compress) {
> +		ret = out_compression_end(handle);
> +		if (ret)
> +			goto out;
> +	}

>  
> +	if (compress)
> +		out_compression_start(handle);
>  	ret = stat(path, &st);
>  	if (ret < 0) {
>  		/* not found */
> @@ -894,11 +931,14 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
>  	}
>  
>   out:
> -	handle->file_state = TRACECMD_FILE_PRINTK;
>  	put_tracing_file(path);
> +	if (compress && out_compression_end(handle))
> +		return -1;
> +	handle->file_state = TRACECMD_FILE_PRINTK;

>  	}
> +
> +	if (handle->compress)
> +		out_compression_start(handle);
> +
>  	ret = save_tracing_file_data(handle, "saved_cmdlines");
> -	if (ret < 0)
> +	if (ret < 0) {
> +		out_compression_reset(handle);
>  		return ret;
> +	}
> +
> +	if (handle->compress && out_compression_end(handle))
> +		return -1;
> +
>  	handle->file_state = TRACECMD_FILE_CMD_LINES;
>  	return 0;
>  }


Pretty much all the out_compression_*() functions are enclosed in a:

	if (compress)
		out_compress_*()

condition.

Why not just add that to the parameter, and clean up the code where
this is used, because these branches are rather ugly and break up the
flow.

For example:

__hidden void out_compression_reset(struct tracecmd_output *handle, bool compress)
{
        if (!compress || !handle->compress)
                return;
        tracecmd_compress_reset(handle->compress);
        handle->do_compress = false;
}

__hidden int out_uncompress_block(struct tracecmd_output *handle, bool compress)
{
        int ret = 0;

        if (!compress || !handle->compress)
                return 0;
        ret = tracecmd_uncompress_block(handle->compress);
        if (!ret)
                handle->do_compress = true;
        return ret;
}

__hidden int out_compression_start(struct tracecmd_output *handle, bool compress)
{
        if (!compress || !handle->compress)
                return 0;
        tracecmd_compress_reset(handle->compress);
        handle->do_compress = true;
        return 0;
}

__hidden int out_compression_end(struct tracecmd_output *handle, bool compress)
{
        if (!compress || !handle->compress)
                return 0;
        handle->do_compress = false;
        return tracecmd_compress_block(handle->compress);
}

Then instead of all these:

        if (compress)
                out_compression_start(handle);

You just have:

        out_compression_start(handle, compress);


-- Steve
