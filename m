Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E82DC433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Jan 2022 18:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbiAYSan (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 13:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiAYSal (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 13:30:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F9BC06173D
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Jan 2022 10:30:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ABEF6146E
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Jan 2022 18:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38807C340E7;
        Tue, 25 Jan 2022 18:30:35 +0000 (UTC)
Date:   Tue, 25 Jan 2022 13:30:33 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 14/20] trace-cmd library: Add logic for in-memory
 decompression
Message-ID: <20220125133033.131408f7@gandalf.local.home>
In-Reply-To: <20220119082715.245846-15-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
        <20220119082715.245846-15-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 19 Jan 2022 10:27:09 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> There are two approaches to read compressed trace data:
>  - use a temporary file to decompress entire trace data before reading
>  - use in-memory decompression of requested trace data chunk only
> In-memory decompression seems to be more efficient, but selecting which
> approach to use depends in the use case.
> A compression chunk consists of multiple trace pages, that's why a small
> cache with uncompressed chunks is implemented. The chunk stays in the
> cache until there are pages which have reference to it.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 110 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 110 insertions(+)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 45a87a63..f5241e4b 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -29,6 +29,9 @@
>  
>  #define COMMIT_MASK ((1 << 27) - 1)
>  
> +/* force uncompressing in memory */
> +#define INMEMORY_DECOMPRESS
> +
>  /* for debugging read instead of mmap */
>  static int force_read = 0;
>  
> @@ -1257,6 +1260,105 @@ static void free_page_map(struct page_map *page_map)
>  	free(page_map);
>  }
>  
> +#define CHUNK_CHECK_OFFSET(C, O)	((O) >= (C)->offset && (O) < ((C)->offset + (C)->size))

space

> +static struct tracecmd_compress_chunk *get_zchunk(struct cpu_data *cpu, off64_t offset)
> +{
> +	struct cpu_zdata *cpuz = &cpu->compress;
> +	int min, mid, max;
> +
> +	if (!cpuz->chunks)
> +		return NULL;

space

> +	if (offset > (cpuz->chunks[cpuz->count - 1].offset + cpuz->chunks[cpuz->count - 1].size))
> +		return NULL;
> +
> +	/* check if the requested offset is in the last requested chunk or in the next chunk */
> +	if (CHUNK_CHECK_OFFSET(cpuz->chunks + cpuz->last_chunk, offset))
> +		return cpuz->chunks + cpuz->last_chunk;
> +	cpuz->last_chunk++;
> +	if (cpuz->last_chunk < cpuz->count &&
> +	    CHUNK_CHECK_OFFSET(cpuz->chunks + cpuz->last_chunk, offset))
> +		return cpuz->chunks + cpuz->last_chunk;
> +
> +	/* do a binary search to find the chunk holding the given offset */
> +	min = 0;
> +	max = cpuz->count - 1;
> +	mid = (min + max)/2;
> +	while (min <= max) {
> +		if (offset < cpuz->chunks[mid].offset)
> +			max = mid - 1;
> +		else if (offset > (cpuz->chunks[mid].offset + cpuz->chunks[mid].size))
> +			min = mid + 1;
> +		else
> +			break;
> +		mid = (min + max)/2;
> +	}
> +	cpuz->last_chunk = mid;
> +	return cpuz->chunks + mid;

Instead of open coding the above what about:


	struct tracecmd_compress_chunk *chunk;
	struct tracecmd_compress_chunk key;

	key.offset = offset;
	chunk = bsearch(&key, cpuz->chunks, cpuz->count, sizeof(*chunk),
			chunk_cmp);

	if (!chunk) /* should never happen */
		return NULL;

	cpuz->last_chunk = chunk - cpuz->chunks;
	return chunk;
}

static int chunk_cmp(const void *A, const void *B)
{
	struct tracecmd_compress_chunk *a = A;
	struct tracecmd_compress_chunk *b = B;

	if (CHUNK_CHECK_OFFSET(b, a->offset))
		return 0;

	if (b->offset < a->offset)
		return -1;

	return 1;
}
	
> +}
> +
> +static void free_zpage(struct cpu_data *cpu_data, void *map)
> +{
> +	struct zchunk_cache *cache;
> +
> +	list_for_each_entry(cache, &cpu_data->compress.cache, list) {
> +		if (map <= cache->map && map > (cache->map + cache->chunk->size))
> +			goto found;
> +	}
> +	return;
> +
> +found:
> +	cache->ref--;
> +	if (cache->ref)
> +		return;
> +	list_del(&cache->list);
> +	free(cache->map);
> +	free(cache);
> +}
> +
> +static void *read_zpage(struct tracecmd_input *handle, int cpu, off64_t offset)
> +{
> +	struct cpu_data *cpu_data = &handle->cpu_data[cpu];
> +	struct tracecmd_compress_chunk *chunk;
> +	struct zchunk_cache *cache;
> +	void *map = NULL;
> +	int pindex;
> +	int size;
> +
> +	/* Look in the cache of already loaded chunks */
> +	list_for_each_entry(cache, &cpu_data->compress.cache, list) {
> +		if (CHUNK_CHECK_OFFSET(cache->chunk, offset)) {
> +			cache->ref++;
> +			goto out;
> +		}
> +	}
> +
> +	chunk =  get_zchunk(cpu_data, offset);
> +	if (!chunk)
> +		return NULL;

space

> +	size = handle->page_size > chunk->size ? handle->page_size : chunk->size;
> +	map = malloc(size);
> +	if (!map)
> +		return NULL;

space

> +	if (tracecmd_uncompress_chunk(handle->compress, chunk, map) < 0)
> +		goto error;
> +
> +	cache = calloc(1, sizeof(struct zchunk_cache));
> +	if (!cache)
> +		goto error;
> +	cache->ref = 1;
> +	cache->chunk = chunk;
> +	cache->map = map;
> +	list_add(&cache->list, &cpu_data->compress.cache);
> +
> +	/* a chunk can hold multiple pages, get the requested one */
> +out:
> +	pindex = (offset - cache->chunk->offset) / handle->page_size;
> +	return cache->map + (pindex * handle->page_size);
> +error:
> +	free(map);
> +	return NULL;
> +}
> +

-- Steve

>  static void *allocate_page_map(struct tracecmd_input *handle,
>  			       struct page *page, int cpu, off64_t offset)
>  {
> @@ -1268,6 +1370,9 @@ static void *allocate_page_map(struct tracecmd_input *handle,
>  	int ret;
>  	int fd;
>  
> +	if (handle->cpu_compressed && handle->read_zpage)
> +		return read_zpage(handle, cpu, offset);
> +
>  	if (handle->read_page) {
>  		map = malloc(handle->page_size);
>  		if (!map)
> @@ -1410,6 +1515,8 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
>  
>  	if (handle->read_page)
>  		free(page->map);
> +	else if (handle->read_zpage)
> +		free_zpage(cpu_data, page->map);
>  	else
>  		free_page_map(page->page_map);
>  
> @@ -3954,6 +4061,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
>  	/* By default, use usecs, unless told otherwise */
>  	handle->flags |= TRACECMD_FL_IN_USECS;
>  
> +#ifdef INMEMORY_DECOMPRESS
> +	handle->read_zpage = 1;
> +#endif
>  	if (do_read_check(handle, buf, 3))
>  		goto failed_read;
>  

