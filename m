Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8066C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 19:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9977F61B72
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 19:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240141AbhKQTxT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 14:53:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239106AbhKQTxT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 14:53:19 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D6D661265;
        Wed, 17 Nov 2021 19:50:20 +0000 (UTC)
Date:   Wed, 17 Nov 2021 14:50:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] [WiP] trace: Set new size of the ring buffer page
Message-ID: <20211117145018.3d39937b@gandalf.local.home>
In-Reply-To: <20211117154101.38659-4-tz.stoyanov@gmail.com>
References: <20211117154101.38659-1-tz.stoyanov@gmail.com>
        <20211117154101.38659-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 17 Nov 2021 17:41:01 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> There are two approaches when changing the size of the ring buffer page:
>  1. Destroying all pages and allocating new pages with the new size.
>  2. Allocating new pages, copying the content of the old pages before
>     destroying them.
> The first approach is easier, it is selected in the proposed
> implementation. Changing the ring buffer page size is supposed to
> not happen frequently. Usually, that size should be set only once,
> when the buffer is not in use yet and is supposed to be empty.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  kernel/trace/ring_buffer.c | 95 ++++++++++++++++++++++++++++++++++----
>  1 file changed, 86 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 9aa245795c3d..39be9b1cf6e0 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -368,6 +368,7 @@ static inline int test_time_stamp(u64 delta)
>  
>  /* Max payload is buffer page size - header (8bytes) */
>  #define BUF_MAX_DATA_SIZE(B) ((B)->page_size - (sizeof(u32) * 2))
> +#define BUF_SYS_PAGE_COUNT(B) (((B)->page_size + BUF_PAGE_HDR_SIZE) / PAGE_SIZE)
>  
>  struct rb_irq_work {
>  	struct irq_work			work;
> @@ -1521,6 +1522,7 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
>  	struct buffer_page *bpage, *tmp;
>  	bool user_thread = current->mm != NULL;
>  	gfp_t mflags;
> +	int psize;
>  	long i;
>  
>  	/*
> @@ -1552,6 +1554,12 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
>  	 */
>  	if (user_thread)
>  		set_current_oom_origin();
> +
> +	/* Buffer page size must be at least one system page */
> +	psize = BUF_SYS_PAGE_COUNT(cpu_buffer->buffer) - 1;
> +	if (psize < 0)
> +		psize = 0;
> +
>  	for (i = 0; i < nr_pages; i++) {
>  		struct page *page;
>  
> @@ -1564,7 +1572,7 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
>  
>  		list_add(&bpage->list, pages);
>  
> -		page = alloc_pages_node(cpu_to_node(cpu_buffer->cpu), mflags, 0);
> +		page = alloc_pages_node(cpu_to_node(cpu_buffer->cpu), mflags, psize);
>  		if (!page)
>  			goto free_pages;
>  		bpage->page = page_address(page);
> @@ -1620,6 +1628,7 @@ rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
>  	struct ring_buffer_per_cpu *cpu_buffer;
>  	struct buffer_page *bpage;
>  	struct page *page;
> +	int psize;
>  	int ret;
>  
>  	cpu_buffer = kzalloc_node(ALIGN(sizeof(*cpu_buffer), cache_line_size()),
> @@ -1646,7 +1655,13 @@ rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
>  	rb_check_bpage(cpu_buffer, bpage);
>  
>  	cpu_buffer->reader_page = bpage;
> -	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
> +
> +	/* Buffer page size must be at least one system page */
> +	psize = BUF_SYS_PAGE_COUNT(cpu_buffer->buffer) - 1;
> +	if (psize < 0)
> +		psize = 0;
> +
> +	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, psize);

Note, psize is an order not a size. That is if psize = 5 it is allocating
32 pages. And this needs to be kept track of.

If we are shrinking the pages, we could do some tricks too, and not even
have to free anything (although we would need to still clear out the data).

That is, because the subbuf size is a power of two that means we can split
them up nicely.

if order is 3 (8 pages) and we shrink to 1 (two pages) we split each of the
8 pages into four 2 page sub buffers.

Note, when freeing pages, you must pass in the order. Allocating pages is
not the same as allocating from the heap (like kmalloc). You must keep
track of what you allocated.

Which brings up how to do this. If a sub buffer is allocated of a given
size, and a reader reads that sub buffer, it must know its size.

>  	if (!page)
>  		goto fail_free_reader;
>  	bpage->page = page_address(page);
> @@ -5412,6 +5427,7 @@ void *ring_buffer_alloc_read_page(struct trace_buffer *buffer, int cpu)
>  	struct buffer_data_page *bpage = NULL;
>  	unsigned long flags;
>  	struct page *page;
> +	int psize;
>  
>  	if (!cpumask_test_cpu(cpu, buffer->cpumask))
>  		return ERR_PTR(-ENODEV);
> @@ -5431,8 +5447,13 @@ void *ring_buffer_alloc_read_page(struct trace_buffer *buffer, int cpu)
>  	if (bpage)
>  		goto out;
>  
> +	/* Buffer page size must be at least one system page */
> +	psize = BUF_SYS_PAGE_COUNT(cpu_buffer->buffer) - 1;
> +	if (psize < 0)
> +		psize = 0;
> +
>  	page = alloc_pages_node(cpu_to_node(cpu),
> -				GFP_KERNEL | __GFP_NORETRY, 0);
> +				GFP_KERNEL | __GFP_NORETRY, psize);
>  	if (!page)
>  		return ERR_PTR(-ENOMEM);
>  
> @@ -5693,10 +5714,70 @@ int ring_buffer_page_size_get(struct trace_buffer *buffer)
>  	if (!buffer)
>  		return -EINVAL;
>  
> -	return (buffer->page_size + BUF_PAGE_HDR_SIZE) / PAGE_SIZE;
> +	return BUF_SYS_PAGE_COUNT(buffer);
>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_page_size_get);
>  
> +static int page_size_set(struct trace_buffer *buffer, int size)
> +{
> +	struct ring_buffer_per_cpu *cpu_buffer;
> +	int old_size = buffer->page_size;
> +	int nr_pages;
> +	int ret = 0;
> +	int err;
> +	int cpu;
> +
> +	if (buffer->page_size == size)
> +		return 0;
> +
> +	/* prevent another thread from changing buffer sizes */
> +	mutex_lock(&buffer->mutex);
> +	atomic_inc(&buffer->record_disabled);
> +

We probably need to add a read_disable field as well, and set it via the
raw_spin_lock reader_lock, and have all readers exit without reading
anything (like the buffer is empty).

> +	/* Make sure all commits have finished */
> +	synchronize_rcu();
> +
> +	buffer->page_size = size;
> +
> +	for_each_buffer_cpu(buffer, cpu) {
> +
> +		if (!cpumask_test_cpu(cpu, buffer->cpumask))
> +			continue;
> +
> +		nr_pages = buffer->buffers[cpu]->nr_pages;
> +		rb_free_cpu_buffer(buffer->buffers[cpu]);
> +		buffer->buffers[cpu] = rb_allocate_cpu_buffer(buffer, nr_pages, cpu);

So are we considering that nr_pages is the number of pages, or the number
of sub buffers?

> +	}
> +
> +	atomic_dec(&buffer->record_disabled);
> +	mutex_unlock(&buffer->mutex);
> +
> +	return 0;
> +
> +out_err:

Nothing jumps to out_err.  ??

-- Steve


> +	buffer->page_size = old_size;
> +
> +	for_each_buffer_cpu(buffer, cpu) {
> +		struct buffer_page *bpage, *tmp;
> +
> +		cpu_buffer = buffer->buffers[cpu];
> +
> +		if (list_empty(&cpu_buffer->new_pages))
> +			continue;
> +
> +		list_for_each_entry_safe(bpage, tmp, &cpu_buffer->new_pages, list) {
> +			list_del_init(&bpage->list);
> +			free_buffer_page(bpage);
> +		}
> +		atomic_dec(&cpu_buffer->record_disabled);
> +		atomic_dec(&cpu_buffer->resize_disabled);
> +	}
> +
> +	mutex_unlock(&buffer->mutex);
> +
> +	return err;
> +}
> +
>  /**
>   * ring_buffer_page_size_set - set the size of ring buffer page.
>   * @buffer: The ring_buffer to set the new page size.
> @@ -5720,11 +5801,7 @@ int ring_buffer_page_size_set(struct trace_buffer *buffer, int pcount)
>  	if (psize <= BUF_PAGE_HDR_SIZE)
>  		return -EINVAL;
>  
> -	buffer->page_size = psize - BUF_PAGE_HDR_SIZE;
> -
> -	/* Todo: reset the buffer with the new page size */
> -
> -	return 0;
> +	return page_size_set(buffer, psize - BUF_PAGE_HDR_SIZE);
>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_page_size_set);
>  

