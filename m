Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57066C4320E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 14:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E4DF60F41
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 14:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238030AbhHQOyG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Aug 2021 10:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236592AbhHQOyG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 10:54:06 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1211B60F41;
        Tue, 17 Aug 2021 14:53:32 +0000 (UTC)
Date:   Tue, 17 Aug 2021 10:53:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 24/87] trace-cmd library: Add local helper function
 for data compression
Message-ID: <20210817105326.0ef34247@oasis.local.home>
In-Reply-To: <20210729050959.12263-25-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-25-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:08:56 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The newly added helper functions read data from a file and compress it,
> before writing into the trace file. The trace data is comressed in
> chunks, which are page aligned. A new local define is introduced:
>   PAGES_IN_CHUNK
> which can be used to tune how big a compression chunk is.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-output.c | 70 ++++++++++++++++++++++++++++++++----
>  1 file changed, 64 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index 6a44a99b..90625c4e 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -285,18 +285,26 @@ static unsigned long get_size(const char *file)
>  	return size;
>  }
>  
> -static tsize_t copy_file_fd(struct tracecmd_output *handle, int fd)
> +static tsize_t copy_file_fd(struct tracecmd_output *handle, int fd, unsigned long long max)
>  {
> +	tsize_t rsize = 0;
>  	tsize_t size = 0;
>  	char buf[BUFSIZ];
>  	stsize_t r;
>  
>  	do {
> -		r = read(fd, buf, BUFSIZ);
> +		if (max > 0 && (max - size) < BUFSIZ)
> +			rsize = (max - size);
> +		else
> +			rsize = BUFSIZ;
> +
> +		r = read(fd, buf, rsize);
>  		if (r > 0) {
>  			size += r;
>  			if (do_write_check(handle, buf, r))
>  				return 0;
> +			if (max > 0 && size >= max)
> +				break;
>  		}
>  	} while (r > 0);

I think this would be a bit cleaner:

static tsize_t copy_file_fd(struct tracecmd_output *handle, int fd, unsigned long long max)
{
	tsize_t rsize = BUFSIZ;
	tsize_t size = 0;
	char buf[BUFSIZ];
	stsize_t r;

	do {
		if (max && rsize > max)
			rsize = max;

		r = read(fd, buf, rsize);
		if (r > 0) {
			size += r;
			if (do_write_check(handle, buf, r))
				return 0;
			if (max) {
				max -= r;
				if (!max)
					break;
			}
		}
	} while (r > 0);

	return size;
}


>  
> @@ -314,12 +322,62 @@ static tsize_t copy_file(struct tracecmd_output *handle,
>  		tracecmd_warning("Can't read '%s'", file);
>  		return 0;
>  	}
> -	size = copy_file_fd(handle, fd);
> +	size = copy_file_fd(handle, fd, 0);
>  	close(fd);
>  
>  	return size;
>  }
>  
> +#define PAGES_IN_CHUNK 10
> +__hidden unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,

The above name is also hard to understand. "out_copy_fd_compress"?
Would "copy_out_fd_compress()" be better?

Also, why is it __hidden and not static. it's not used outside this file.

If it gets used outside this file in a follow up patch, please convert
it from static to __hidden then.

-- Steve


> +						 int fd, unsigned long long max,
> +						 unsigned long long *write_size)
> +{
> +	unsigned long long rsize = 0;
> +	unsigned long long wsize = 0;
> +	unsigned long long size;
> +	int ret;
> +
> +	if (handle->compress) {
> +		rsize = max;
> +		ret = tracecmd_compress_copy_from(handle->compress, fd,
> +						  PAGES_IN_CHUNK * handle->page_size,
> +						  &rsize, &wsize);
> +		if (ret < 0)
> +			return 0;
> +
> +		size = rsize;
> +		if (write_size)
> +			*write_size = wsize;
> +	} else {
> +		size = copy_file_fd(handle, fd, max);
> +		if (write_size)
> +			*write_size = size;
> +	}
> +
> +	return size;
> +}
> +
> +static tsize_t copy_file_compress(struct tracecmd_output *handle,
> +				  const char *file, unsigned long long *write_size)
> +{
> +	int ret;
> +	int fd;
> +
> +	fd = open(file, O_RDONLY);
> +	if (fd < 0) {
> +		tracecmd_warning("Can't read '%s'", file);
> +		return 0;
> +	}
> +
> +	ret = out_copy_fd_compress(handle, fd, 0, write_size);
> +	if (!ret)
> +		tracecmd_warning("Can't compress '%s'", file);
> +
> +	close(fd);
> +	return ret;
> +}
> +
>  /*
>   * Finds the path to the debugfs/tracing
>   * Allocates the string and stores it.
> @@ -516,7 +574,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
>  	endian8 = convert_endian_8(handle, size);
>  	if (do_write_check(handle, &endian8, 8))
>  		goto out_close;
> -	check_size = copy_file_fd(handle, fd);
> +	check_size = copy_file_fd(handle, fd, 0);
>  	close(fd);
>  	if (size != check_size) {
>  		tracecmd_warning("wrong size for '%s' size=%lld read=%lld", path, size, check_size);
> @@ -542,7 +600,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
>  	endian8 = convert_endian_8(handle, size);
>  	if (do_write_check(handle, &endian8, 8))
>  		goto out_close;
> -	check_size = copy_file_fd(handle, fd);
> +	check_size = copy_file_fd(handle, fd, 0);
>  	close(fd);
>  	if (size != check_size) {
>  		tracecmd_warning("wrong size for '%s'", path);
> @@ -1984,7 +2042,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
>  		if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
>  			goto out_free;
>  		if (data[i].size) {
> -			read_size = copy_file_fd(handle, data[i].fd);
> +			read_size = copy_file_fd(handle, data[i].fd, data[i].size);
>  			if (read_size != data_files[i].file_size) {
>  				errno = EINVAL;
>  				tracecmd_warning("did not match size of %lld to %lld",

