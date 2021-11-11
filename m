Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6774EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 495CC61179
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbhKKPrw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:47:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233986AbhKKPrt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:47:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0BB361252;
        Thu, 11 Nov 2021 15:44:59 +0000 (UTC)
Date:   Thu, 11 Nov 2021 10:44:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] trace-cmd library: Use the real trace buffer page
 size
Message-ID: <20211111104458.5ee5449d@gandalf.local.home>
In-Reply-To: <20211111151326.87227-2-tz.stoyanov@gmail.com>
References: <20211111151326.87227-1-tz.stoyanov@gmail.com>
        <20211111151326.87227-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 17:13:25 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> When new output handler is created, it assumes that the trace buffer page
> size is equal to the system memory page size. This assumption is valid
> for the current ftrace implementation, but it may change in the future.
> The newly introduced traceevent library API should be used to get the
> real trace buffer page size, bases on the information from the
> "events/header_page" ftrace file.
> 
> This commit depends on:
>  [PATCH] libtraceevent: A new API for trace page size
>  https://lore.kernel.org/linux-trace-devel/20211001062338.2389024-1-tz.stoyanov@gmail.com/
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-output.c | 52 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index a029678b..08fa485d 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -1189,6 +1189,56 @@ static int write_compression_header(struct tracecmd_output *handle)
>  	return 0;
>  }
>  
> +static int get_trace_page_size(struct tracecmd_output *handle)
> +{
> +	struct tep_handle *tep = NULL;
> +	tsize_t psize, size;
> +	char *path = NULL;
> +	char *buff = NULL;
> +	int fd = -1;
> +	int r, s;
> +
> +	/* In case of an error, return user space page size */
> +	psize = getpagesize();
> +
> +	path = get_tracing_file(handle, "events/header_page");
> +	if (!path)
> +		goto out;
> +	fd = open(path, O_RDONLY);
> +	if (fd < 0) /* old style did not show this info */

Note, as I stated in the other patch, calling tep_parse_trace_page_size()
with size zero should get the updates needed for the old format as well.

> +		goto out;
> +
> +	tep = tep_alloc();
> +	if (!tep)
> +		goto out;
> +	size = get_size_fd(fd);
> +	if (!size)
> +		goto out;
> +	buff = malloc(size);
> +	if (!buff)
> +		goto out;
> +
> +	s = size;
> +	do {
> +		r = read(fd, buff, s);
> +		if (r > 0)
> +			s -= r;
> +	} while (r > 0 && s);
> +	if (s)
> +		goto out;

I know that a lot of his is copied from other parts of this file, but this
was written before libtracefs existed. We should start using libtracefs
APIs for new code, and start also moving the old code to it. The above
could be replaced with:

	buf = tracefs_instance_file_read(NULL, "events/header_page", &size);

-- Steve


> +	if (tep_parse_header_page(tep, buff, size, sizeof(long long)))
> +		goto out;
> +	psize = tep_get_trace_page_size(tep);
> +out:
> +	tep_free(tep);
> +	free(buff);
> +	if (path)
> +		put_tracing_file(path);
> +	if (fd >= 0)
> +		close(fd);
> +	return psize;
> +}
> +
>  /**
>   * tracecmd_output_allocate - allocate new output handler to a trace file
>   * @handle: file descriptor to an empty file, it can be -1 if the handler
> @@ -1213,7 +1263,7 @@ struct tracecmd_output *tracecmd_output_allocate(int fd)
>  
>  	handle->file_version = FILE_VERSION_DEFAULT;
>  
> -	handle->page_size = getpagesize();
> +	handle->page_size = get_trace_page_size(handle);
>  	handle->big_endian = tracecmd_host_bigendian();
>  
>  	list_head_init(&handle->options);

