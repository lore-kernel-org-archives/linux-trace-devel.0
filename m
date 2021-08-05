Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E532C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Aug 2021 13:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54F8461156
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Aug 2021 13:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239096AbhHENlB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Aug 2021 09:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235812AbhHENlB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 09:41:01 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FB816113C;
        Thu,  5 Aug 2021 13:40:47 +0000 (UTC)
Date:   Thu, 5 Aug 2021 09:40:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 11/87] trace-cmd library: Internal helpers for
 uncompressing data
Message-ID: <20210805094045.49301394@oasis.local.home>
In-Reply-To: <20210728133250.234140-12-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
        <20210728133250.234140-12-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Jul 2021 16:31:34 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> New library internal helper functions are introduced, to add compression
> functionality to the input trace handler.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/include/trace-cmd-local.h |  4 ++
>  lib/trace-cmd/trace-input.c             | 54 +++++++++++++++++++++----
>  2 files changed, 50 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
> index fa361766..670af8e4 100644
> --- a/lib/trace-cmd/include/trace-cmd-local.h
> +++ b/lib/trace-cmd/include/trace-cmd-local.h
> @@ -38,6 +38,10 @@ int out_uncompress_block(struct tracecmd_output *handle);
>  int out_compression_start(struct tracecmd_output *handle);
>  int out_compression_end(struct tracecmd_output *handle);
>  void out_compression_reset(struct tracecmd_output *handle);
> +
> +void in_uncompress_reset(struct tracecmd_input *handle);
> +int in_uncompress_block(struct tracecmd_input *handle);
> +
>  unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
>  					int fd, unsigned long long max,
>  					unsigned long long *write_size);
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 38dd0deb..da6825b8 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -136,6 +136,9 @@ struct tracecmd_input {
>  	long long		ts_offset;
>  	struct tsc2nsec		tsc_calc;
>  
> +	bool			read_compress;
> +	struct tracecmd_compression *compress;
> +
>  	struct host_trace_info	host;
>  	double			ts2secs;
>  	char *			cpustats;
> @@ -238,13 +241,13 @@ static const char *show_records(struct page **pages, int nr_pages)
>  
>  static int init_cpu(struct tracecmd_input *handle, int cpu);
>  
> -static ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
> +static ssize_t do_read_fd(int fd, void *data, size_t size)
>  {
>  	ssize_t tot = 0;
>  	ssize_t r;
>  
>  	do {
> -		r = read(handle->fd, data + tot, size - tot);
> +		r = read(fd, data + tot, size - tot);
>  		tot += r;
>  
>  		if (!r)
> @@ -256,12 +259,28 @@ static ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
>  	return tot;
>  }
>  
> +static inline int do_lseek(struct tracecmd_input *handle, int offset, int whence)
> +{
> +	if (handle->read_compress)
> +		return tracecmd_compress_lseek(handle->compress, offset, whence);
> +	else
> +		return lseek(handle->fd, offset, whence);
> +}
> +
> +static inline ssize_t do_read_compressed(struct tracecmd_input *handle, void *data, size_t size)

This should be just called "do_read", as it handles both compressed and
normal reads. And the name suggests that it only does compressed reads.

> +{
> +	if (handle->read_compress)
> +		return tracecmd_compress_read(handle->compress, data, size);
> +	else
> +		return do_read_fd(handle->fd, data, size);
> +}
> +
>  static ssize_t
>  do_read_check(struct tracecmd_input *handle, void *data, size_t size)
>  {
>  	ssize_t ret;
>  
> -	ret = do_read(handle, data, size);
> +	ret = do_read_compressed(handle, data, size);

By keeping it do_read() you don't need all these other changes.

-- Steve

>  	if (ret < 0)
>  		return ret;
>  	if (ret != size)
> @@ -279,10 +298,8 @@ static char *read_string(struct tracecmd_input *handle)
>  	ssize_t r;
>  
>  	for (;;) {
> -		r = do_read(handle, buf, BUFSIZ);
> -		if (r < 0)
> -			goto fail;
> -		if (!r)
> +		r = do_read_compressed(handle, buf, BUFSIZ);
> +		if (r <= 0)
>  			goto fail;
>  
>  		for (i = 0; i < r; i++) {
> @@ -308,7 +325,7 @@ static char *read_string(struct tracecmd_input *handle)
>  	}
>  
>  	/* move the file descriptor to the end of the string */
> -	r = lseek(handle->fd, -(r - (i+1)), SEEK_CUR);
> +	r = do_lseek(handle, -(r - (i+1)), SEEK_CUR);
>  	if (r < 0)
>  		goto fail;
>  
> @@ -372,6 +389,26 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
>  	return 0;
>  }
>  
> +__hidden void in_uncompress_reset(struct tracecmd_input *handle)
> +{
> +	if (handle->compress) {
> +		handle->read_compress = false;
> +		tracecmd_compress_reset(handle->compress);
> +	}
> +}
> +
> +__hidden int in_uncompress_block(struct tracecmd_input *handle)
> +{
> +	int ret = 0;
> +
> +	if (handle->compress) {
> +		ret = tracecmd_uncompress_block(handle->compress);
> +		if (!ret)
> +			handle->read_compress = true;
> +	}
> +	return ret;
> +}
> +
>  static int read_header_files(struct tracecmd_input *handle)
>  {
>  	struct tep_handle *pevent = handle->pevent;
> @@ -479,6 +516,7 @@ static int read_ftrace_file(struct tracecmd_input *handle,
>  	buf = malloc(size);
>  	if (!buf)
>  		return -1;
> +
>  	if (do_read_check(handle, buf, size)) {
>  		free(buf);
>  		return -1;

