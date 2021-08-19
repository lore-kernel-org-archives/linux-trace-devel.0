Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F147EC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C74EC60C3E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhHSTSv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 15:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhHSTSv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 15:18:51 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 982196056B;
        Thu, 19 Aug 2021 19:18:14 +0000 (UTC)
Date:   Thu, 19 Aug 2021 15:18:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 51/87] trace-cmd library: Extend the input handler
 with trace data decompression context
Message-ID: <20210819151807.36cc5868@oasis.local.home>
In-Reply-To: <20210729050959.12263-52-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-52-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:09:23 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The CPU tarce data is compressed in chunks, as chunk's size is multiple

typos.

> trace pages. The input handler is extended with the necessary
> structures, to control the data decompression. There are two approaches
> for data decompression, both are supported and can be used in different
> use cases:
>  - in-memory decompression, page by page.
>  - using a temporary file
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 66 ++++++++++++++++++++++++++++++-------
>  1 file changed, 54 insertions(+), 12 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 520d611f..6fb63c0f 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -29,6 +29,9 @@
>  
>  #define COMMIT_MASK ((1 << 27) - 1)
>  
> +/* force uncompressing in memory */
> +#define INMEMORY_DECOMPRESS

I wonder if we should just make this a variable in the handle, and
default it to in memory. Then it will be easy to change it from the
command line if we want to.

-- Steve

> +
>  /* for debugging read instead of mmap */
>  static int force_read = 0;
>  
> @@ -54,6 +57,24 @@ struct page {
>  #endif
>  };
>  
> +struct zchunk_cache {
> +	struct list_head		list;
> +	struct tracecmd_compress_chunk *chunk;
> +	void				*map;
> +	int				ref;
> +};
> +
> +struct cpu_zdata {
> +	/* uncompressed cpu data */
> +	int			fd;
> +	char			file[26]; /*
> strlen(COMPR_TEMP_FILE) */
> +	unsigned int		count;
> +	unsigned int		last_chunk;
> +	struct list_head	cache;
> +	struct tracecmd_compress_chunk	*chunks;
> +};
> +
> +#define COMPR_TEMP_FILE "/tmp/trace_cpu_dataXXXXXX"
>  struct cpu_data {
>  	/* the first two never change */
>  	unsigned long long	file_offset;
> @@ -72,6 +93,7 @@ struct cpu_data {
>  	int			page_cnt;
>  	int			cpu;
>  	int			pipe_fd;
> +	struct cpu_zdata	compress;
>  };
>  
>  struct cpu_file_data {
> @@ -150,6 +172,8 @@ struct tracecmd_input {
>  	bool			use_trace_clock;
>  	bool			read_page;
>  	bool			use_pipe;
> +	bool			read_zpage; /* uncompress pages
> in memory, do not use tmp files */
> +	bool			cpu_compressed;
>  	int			file_version;
>  	struct cpu_data 	*cpu_data;
>  	long long		ts_offset;
> @@ -3284,7 +3308,7 @@ static int read_cpu_data(struct tracecmd_input
> *handle) unsigned long long offset;
>  
>  		handle->cpu_data[cpu].cpu = cpu;
> -
> +		handle->cpu_data[cpu].compress.fd = -1;
>  		handle->cpu_data[cpu].kbuf =
> kbuffer_alloc(long_size, endian); if (!handle->cpu_data[cpu].kbuf)
>  			goto out_free;
> @@ -3701,6 +3725,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int
> fd, int flags) /* By default, use usecs, unless told otherwise */
>  	handle->flags |= TRACECMD_FL_IN_USECS;
>  
> +#ifdef INMEMORY_DECOMPRESS
> +	handle->read_zpage = 1;
> +#endif
>  	if (do_read_check(handle, buf, 3))
>  		goto failed_read;
>  
> @@ -3915,6 +3942,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
>   */
>  void tracecmd_close(struct tracecmd_input *handle)
>  {
> +	struct zchunk_cache *cache;
>  	struct file_section *del_sec;
>  	int i;
>  
> @@ -3933,17 +3961,31 @@ void tracecmd_close(struct tracecmd_input
> *handle) /* The tracecmd_peek_data may have cached a record */
>  		free_next(handle, i);
>  		free_page(handle, i);
> -		if (handle->cpu_data && handle->cpu_data[i].kbuf) {
> -			kbuffer_free(handle->cpu_data[i].kbuf);
> -			if (handle->cpu_data[i].page_map)
> -
> free_page_map(handle->cpu_data[i].page_map); -
> -			if (handle->cpu_data[i].page_cnt)
> -				tracecmd_warning("%d pages still
> allocated on cpu %d%s",
> -
> handle->cpu_data[i].page_cnt, i,
> -
> show_records(handle->cpu_data[i].pages,
> -
> handle->cpu_data[i].nr_pages));
> -			free(handle->cpu_data[i].pages);
> +		if (handle->cpu_data) {
> +			if (handle->cpu_data[i].kbuf) {
> +
> kbuffer_free(handle->cpu_data[i].kbuf);
> +				if (handle->cpu_data[i].page_map)
> +
> free_page_map(handle->cpu_data[i].page_map); +
> +				if (handle->cpu_data[i].page_cnt)
> +					tracecmd_warning("%d pages
> still allocated on cpu %d%s",
> +
> handle->cpu_data[i].page_cnt, i,
> +
> show_records(handle->cpu_data[i].pages,
> +
>  handle->cpu_data[i].nr_pages));
> +				free(handle->cpu_data[i].pages);
> +			}
> +			if (handle->cpu_data[i].compress.fd >= 0) {
> +
> close(handle->cpu_data[i].compress.fd);
> +
> unlink(handle->cpu_data[i].compress.file);
> +			}
> +			while
> (!list_empty(&handle->cpu_data[i].compress.cache)) {
> +				cache =
> container_of(handle->cpu_data[i].compress.cache.next,
> +						     struct
> zchunk_cache, list);
> +				list_del(&cache->list);
> +				free(cache->map);
> +				free(cache);
> +			}
> +			free(handle->cpu_data[i].compress.chunks);
>  		}
>  	}
>  

