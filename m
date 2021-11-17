Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3831C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 18:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DB5B61BD3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 18:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhKQSVA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 13:21:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230094AbhKQSU6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 13:20:58 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2371760F44;
        Wed, 17 Nov 2021 18:17:59 +0000 (UTC)
Date:   Wed, 17 Nov 2021 13:17:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/3] [RFC] trace: Page size per ring buffer
Message-ID: <20211117131757.6209091b@gandalf.local.home>
In-Reply-To: <20211117154101.38659-2-tz.stoyanov@gmail.com>
References: <20211117154101.38659-1-tz.stoyanov@gmail.com>
        <20211117154101.38659-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 17 Nov 2021 17:40:59 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Currently the size of one buffer page is global for all buffers and it
> is hard coded to one system page. In order to introduce configurable
> ring buffer page size, the internal logic should be refactored to work
> with page size per ring buffer.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/linux/ring_buffer.h |   2 +-
>  kernel/trace/ring_buffer.c  | 117 +++++++++++++++++++-----------------
>  kernel/trace/trace_events.c |  71 +++++++++++++++++++---
>  3 files changed, 123 insertions(+), 67 deletions(-)
> 
> diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
> index dac53fd3afea..d9a2e6e8fb79 100644
> --- a/include/linux/ring_buffer.h
> +++ b/include/linux/ring_buffer.h
> @@ -200,7 +200,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer, void **data_page,
>  struct trace_seq;
>  
>  int ring_buffer_print_entry_header(struct trace_seq *s);
> -int ring_buffer_print_page_header(struct trace_seq *s);
> +int ring_buffer_print_page_header(struct trace_buffer *buffer, struct trace_seq *s);
>  
>  enum ring_buffer_flags {
>  	RB_FL_OVERWRITE		= 1 << 0,
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 2699e9e562b1..6bca2977ca1a 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -366,40 +366,8 @@ static inline int test_time_stamp(u64 delta)
>  	return 0;
>  }
>  
> -#define BUF_PAGE_SIZE (PAGE_SIZE - BUF_PAGE_HDR_SIZE)
> -
> -/* Max payload is BUF_PAGE_SIZE - header (8bytes) */
> -#define BUF_MAX_DATA_SIZE (BUF_PAGE_SIZE - (sizeof(u32) * 2))
> -
> -int ring_buffer_print_page_header(struct trace_seq *s)
> -{
> -	struct buffer_data_page field;
> -
> -	trace_seq_printf(s, "\tfield: u64 timestamp;\t"
> -			 "offset:0;\tsize:%u;\tsigned:%u;\n",
> -			 (unsigned int)sizeof(field.time_stamp),
> -			 (unsigned int)is_signed_type(u64));
> -
> -	trace_seq_printf(s, "\tfield: local_t commit;\t"
> -			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
> -			 (unsigned int)offsetof(typeof(field), commit),
> -			 (unsigned int)sizeof(field.commit),
> -			 (unsigned int)is_signed_type(long));
> -
> -	trace_seq_printf(s, "\tfield: int overwrite;\t"
> -			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
> -			 (unsigned int)offsetof(typeof(field), commit),
> -			 1,
> -			 (unsigned int)is_signed_type(long));
> -
> -	trace_seq_printf(s, "\tfield: char data;\t"
> -			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
> -			 (unsigned int)offsetof(typeof(field), data),
> -			 (unsigned int)BUF_PAGE_SIZE,
> -			 (unsigned int)is_signed_type(char));
> -
> -	return !trace_seq_has_overflowed(s);
> -}
> +/* Max payload is buffer page size - header (8bytes) */
> +#define BUF_MAX_DATA_SIZE(B) ((B)->page_size - (sizeof(u32) * 2))

This is used in a lot of hot paths. So it should be calculated at the time
it is changed and use that instead.

	(B)->buf_data_size


>  
>  struct rb_irq_work {
>  	struct irq_work			work;
> @@ -544,6 +512,8 @@ struct trace_buffer {
>  
>  	struct rb_irq_work		irq_work;
>  	bool				time_stamp_abs;
> +
> +	unsigned int			page_size;

Should call it subbuf_size, as it's not a page size.

>  };
>  
>  struct ring_buffer_iter {
> @@ -559,6 +529,36 @@ struct ring_buffer_iter {
>  	int				missed_events;
>  };
>  
> +int ring_buffer_print_page_header(struct trace_buffer *buffer, struct trace_seq *s)
> +{
> +	struct buffer_data_page field;
> +
> +	trace_seq_printf(s, "\tfield: u64 timestamp;\t"
> +			 "offset:0;\tsize:%u;\tsigned:%u;\n",
> +			 (unsigned int)sizeof(field.time_stamp),
> +			 (unsigned int)is_signed_type(u64));
> +
> +	trace_seq_printf(s, "\tfield: local_t commit;\t"
> +			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
> +			 (unsigned int)offsetof(typeof(field), commit),
> +			 (unsigned int)sizeof(field.commit),
> +			 (unsigned int)is_signed_type(long));
> +
> +	trace_seq_printf(s, "\tfield: int overwrite;\t"
> +			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
> +			 (unsigned int)offsetof(typeof(field), commit),
> +			 1,
> +			 (unsigned int)is_signed_type(long));
> +
> +	trace_seq_printf(s, "\tfield: char data;\t"
> +			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
> +			 (unsigned int)offsetof(typeof(field), data),
> +			 (unsigned int)buffer->page_size,
> +			 (unsigned int)is_signed_type(char));
> +
> +	return !trace_seq_has_overflowed(s);

When moving and changing blocks of code, it is best to make that in
separate changes, so that the reviewer can see what changed.

The above just looks like you moved it, but it has changed as well, and
there's no diff on what those changes were.

> +}
> +
>  #ifdef RB_TIME_32
>  
>  /*
> @@ -1725,7 +1725,9 @@ struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
>  	if (!zalloc_cpumask_var(&buffer->cpumask, GFP_KERNEL))
>  		goto fail_free_buffer;
>  
> -	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
> +	/* Default buffer page size - one system page */
> +	buffer->page_size = PAGE_SIZE - BUF_PAGE_HDR_SIZE;
> +	nr_pages = DIV_ROUND_UP(size, buffer->page_size);
>  	buffer->flags = flags;
>  	buffer->clock = trace_clock_local;
>  	buffer->reader_lock_key = key;
> @@ -1919,7 +1921,8 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned long nr_pages)
>  			 * Increment overrun to account for the lost events.
>  			 */
>  			local_add(page_entries, &cpu_buffer->overrun);
> -			local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
> +			local_sub(cpu_buffer->buffer->page_size,
> +				  &cpu_buffer->entries_bytes);
>  		}
>  
>  		/*
> @@ -2041,7 +2044,7 @@ static void update_pages_handler(struct work_struct *work)
>   * @size: the new size.
>   * @cpu_id: the cpu buffer to resize
>   *
> - * Minimum size is 2 * BUF_PAGE_SIZE.
> + * Minimum size is 2 * buffer->page_size.
>   *
>   * Returns 0 on success and < 0 on failure.
>   */
> @@ -2063,7 +2066,7 @@ int ring_buffer_resize(struct trace_buffer *buffer, unsigned long size,
>  	    !cpumask_test_cpu(cpu_id, buffer->cpumask))
>  		return 0;
>  
> -	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
> +	nr_pages = DIV_ROUND_UP(size, buffer->page_size);
>  
>  	/* we need a minimum of two pages */
>  	if (nr_pages < 2)
> @@ -2290,7 +2293,7 @@ rb_iter_head_event(struct ring_buffer_iter *iter)
>  	 */
>  	barrier();
>  
> -	if ((iter->head + length) > commit || length > BUF_MAX_DATA_SIZE)
> +	if ((iter->head + length) > commit || length > BUF_MAX_DATA_SIZE(iter->cpu_buffer->buffer))
>  		/* Writer corrupted the read? */
>  		goto reset;
>  
> @@ -2403,7 +2406,8 @@ rb_handle_head_page(struct ring_buffer_per_cpu *cpu_buffer,
>  		 * the counters.
>  		 */
>  		local_add(entries, &cpu_buffer->overrun);
> -		local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
> +		local_sub(cpu_buffer->buffer->page_size,
> +			  &cpu_buffer->entries_bytes);
>  
>  		/*
>  		 * The entries will be zeroed out when we move the
> @@ -2530,13 +2534,13 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
>  	 * Only the event that crossed the page boundary
>  	 * must fill the old tail_page with padding.
>  	 */
> -	if (tail >= BUF_PAGE_SIZE) {
> +	if (tail >= cpu_buffer->buffer->page_size) {

rb_reset_tail() is a fast path, so we should put this into a single
variable and have it saved:

	unsigned long bsize = READ_ONCE(cpu_buffer->buffer->subbuf_size);

Then use bsize for the rest.

>  		/*
>  		 * If the page was filled, then we still need
>  		 * to update the real_end. Reset it to zero
>  		 * and the reader will ignore it.
>  		 */
> -		if (tail == BUF_PAGE_SIZE)
> +		if (tail == cpu_buffer->buffer->page_size)
>  			tail_page->real_end = 0;
>  
>  		local_sub(length, &tail_page->write);
> @@ -2546,7 +2550,8 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
>  	event = __rb_page_index(tail_page, tail);
>  
>  	/* account for padding bytes */
> -	local_add(BUF_PAGE_SIZE - tail, &cpu_buffer->entries_bytes);
> +	local_add(cpu_buffer->buffer->page_size - tail,
> +		  &cpu_buffer->entries_bytes);
>  
>  	/*
>  	 * Save the original length to the meta data.
> @@ -2566,7 +2571,7 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
>  	 * If we are less than the minimum size, we don't need to
>  	 * worry about it.
>  	 */
> -	if (tail > (BUF_PAGE_SIZE - RB_EVNT_MIN_SIZE)) {
> +	if (tail > (cpu_buffer->buffer->page_size - RB_EVNT_MIN_SIZE)) {
>  		/* No room for any events */
>  
>  		/* Mark the rest of the page with padding */
> @@ -2578,13 +2583,13 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
>  	}
>  
>  	/* Put in a discarded event */
> -	event->array[0] = (BUF_PAGE_SIZE - tail) - RB_EVNT_HDR_SIZE;
> +	event->array[0] = (cpu_buffer->buffer->page_size - tail) - RB_EVNT_HDR_SIZE;
>  	event->type_len = RINGBUF_TYPE_PADDING;
>  	/* time delta must be non zero */
>  	event->time_delta = 1;
>  
>  	/* Set write to end of buffer */
> -	length = (tail + length) - BUF_PAGE_SIZE;
> +	length = (tail + length) - cpu_buffer->buffer->page_size;
>  	local_sub(length, &tail_page->write);
>  }
>  
> @@ -3476,7 +3481,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
>  	tail = write - info->length;
>  
>  	/* See if we shot pass the end of this buffer page */
> -	if (unlikely(write > BUF_PAGE_SIZE)) {
> +	if (unlikely(write > cpu_buffer->buffer->page_size)) {
>  		/* before and after may now different, fix it up*/
>  		b_ok = rb_time_read(&cpu_buffer->before_stamp, &info->before);
>  		a_ok = rb_time_read(&cpu_buffer->write_stamp, &info->after);
> @@ -3685,7 +3690,7 @@ ring_buffer_lock_reserve(struct trace_buffer *buffer, unsigned long length)
>  	if (unlikely(atomic_read(&cpu_buffer->record_disabled)))
>  		goto out;
>  
> -	if (unlikely(length > BUF_MAX_DATA_SIZE))
> +	if (unlikely(length > BUF_MAX_DATA_SIZE(buffer)))
>  		goto out;
>  
>  	if (unlikely(trace_recursive_lock(cpu_buffer)))
> @@ -3835,7 +3840,7 @@ int ring_buffer_write(struct trace_buffer *buffer,
>  	if (atomic_read(&cpu_buffer->record_disabled))
>  		goto out;
>  
> -	if (length > BUF_MAX_DATA_SIZE)
> +	if (length > BUF_MAX_DATA_SIZE(buffer))
>  		goto out;
>  
>  	if (unlikely(trace_recursive_lock(cpu_buffer)))
> @@ -4957,7 +4962,7 @@ ring_buffer_read_prepare(struct trace_buffer *buffer, int cpu, gfp_t flags)
>  	if (!iter)
>  		return NULL;
>  
> -	iter->event = kmalloc(BUF_MAX_DATA_SIZE, flags);
> +	iter->event = kmalloc(BUF_MAX_DATA_SIZE(buffer), flags);
>  	if (!iter->event) {
>  		kfree(iter);
>  		return NULL;
> @@ -5075,14 +5080,14 @@ unsigned long ring_buffer_size(struct trace_buffer *buffer, int cpu)
>  {
>  	/*
>  	 * Earlier, this method returned
> -	 *	BUF_PAGE_SIZE * buffer->nr_pages
> +	 *	buffer->page_size * buffer->nr_pages
>  	 * Since the nr_pages field is now removed, we have converted this to
>  	 * return the per cpu buffer value.
>  	 */
>  	if (!cpumask_test_cpu(cpu, buffer->cpumask))
>  		return 0;
>  
> -	return BUF_PAGE_SIZE * buffer->buffers[cpu]->nr_pages;
> +	return buffer->page_size * buffer->buffers[cpu]->nr_pages;

We may want to add nr_subbufs and keep that separate from nr_pages, as
nr_pages should probably be the nr_pages that we allocated.

I'll have to look at the entire patch series to get a better idea of what
we need to keep track of.

>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_size);
>  
> @@ -5618,7 +5623,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
>  	} else {

I just realized we are going to have to analyze the logic of
ring_buffer_read_page(), because it can pass in a buffer to use that may
not be big enough.

I'll have to think about this some more.

>  		/* update the entry counter */
>  		cpu_buffer->read += rb_page_entries(reader);
> -		cpu_buffer->read_bytes += BUF_PAGE_SIZE;
> +		cpu_buffer->read_bytes += buffer->page_size;
>  
>  		/* swap the pages */
>  		rb_init_page(bpage);
> @@ -5649,7 +5654,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
>  		/* If there is room at the end of the page to save the
>  		 * missed events, then record it there.
>  		 */
> -		if (BUF_PAGE_SIZE - commit >= sizeof(missed_events)) {
> +		if (buffer->page_size - commit >= sizeof(missed_events)) {
>  			memcpy(&bpage->data[commit], &missed_events,
>  			       sizeof(missed_events));
>  			local_add(RB_MISSED_STORED, &bpage->commit);
> @@ -5661,8 +5666,8 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
>  	/*
>  	 * This page may be off to user land. Zero it out here.
>  	 */
> -	if (commit < BUF_PAGE_SIZE)
> -		memset(&bpage->data[commit], 0, BUF_PAGE_SIZE - commit);
> +	if (commit < buffer->page_size)
> +		memset(&bpage->data[commit], 0, buffer->page_size - commit);
>  
>   out_unlock:
>  	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 4021b9a79f93..a2bac76e73d3 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1846,10 +1846,31 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  	return cnt;
>  }
>  
> +static int open_header_file(struct inode *inode, struct file *filp)
> +{
> +	struct trace_array *tr = inode->i_private;
> +	int ret;
> +
> +	ret = tracing_check_open_get_tr(tr);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int release_header_file(struct inode *inode, struct file *file)
> +{
> +	struct trace_array *tr = inode->i_private;
> +
> +	trace_array_put(tr);
> +
> +	return 0;
> +}
> +

Why add these and not just use:

tracing_open_generic_tr() and tracing_release_generic()?

Where the latter would need to become global to use.


>  static ssize_t
> -show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
> +show_header_page_file(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
>  {
> -	int (*func)(struct trace_seq *s) = filp->private_data;
> +	struct trace_array *tr = file_inode(filp)->i_private;

Then you also do not need to use the file_inode macro, because the
tracing_open_generic_tr() will set filp->private_data to it.

-- Steve

>  	struct trace_seq *s;
>  	int r;
>  
> @@ -1862,7 +1883,31 @@ show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
>  
>  	trace_seq_init(s);
>  
> -	func(s);
> +	ring_buffer_print_page_header(tr->array_buffer.buffer, s);
> +	r = simple_read_from_buffer(ubuf, cnt, ppos,
> +				    s->buffer, trace_seq_used(s));
> +
> +	kfree(s);
> +
> +	return r;
> +}
> +
> +static ssize_t
> +show_header_event_file(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
> +{
> +	struct trace_seq *s;
> +	int r;
> +
> +	if (*ppos)
> +		return 0;
> +
> +	s = kmalloc(sizeof(*s), GFP_KERNEL);
> +	if (!s)
> +		return -ENOMEM;
> +
> +	trace_seq_init(s);
> +
> +	ring_buffer_print_entry_header(s);
>  	r = simple_read_from_buffer(ubuf, cnt, ppos,
>  				    s->buffer, trace_seq_used(s));
>  
> @@ -2117,10 +2162,18 @@ static const struct file_operations ftrace_tr_enable_fops = {
>  	.release = subsystem_release,
>  };
>  
> -static const struct file_operations ftrace_show_header_fops = {
> -	.open = tracing_open_generic,
> -	.read = show_header,
> +static const struct file_operations ftrace_show_header_page_fops = {
> +	.open = open_header_file,
> +	.read = show_header_page_file,
> +	.llseek = default_llseek,
> +	.release = release_header_file,
> +};
> +
> +static const struct file_operations ftrace_show_header_event_fops = {
> +	.open = open_header_file,
> +	.read = show_header_event_file,
>  	.llseek = default_llseek,
> +	.release = release_header_file,
>  };
>  
>  static int
> @@ -3469,14 +3522,12 @@ create_event_toplevel_files(struct dentry *parent, struct trace_array *tr)
>  
>  	/* ring buffer internal formats */
>  	entry = trace_create_file("header_page", TRACE_MODE_READ, d_events,
> -				  ring_buffer_print_page_header,
> -				  &ftrace_show_header_fops);
> +				  tr, &ftrace_show_header_page_fops);
>  	if (!entry)
>  		pr_warn("Could not create tracefs 'header_page' entry\n");
>  
>  	entry = trace_create_file("header_event", TRACE_MODE_READ, d_events,
> -				  ring_buffer_print_entry_header,
> -				  &ftrace_show_header_fops);
> +				  tr, &ftrace_show_header_event_fops);
>  	if (!entry)
>  		pr_warn("Could not create tracefs 'header_event' entry\n");
>  

