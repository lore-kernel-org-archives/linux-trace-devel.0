Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3D5C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 18:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D518D61BF4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 18:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240138AbhKQSm7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 13:42:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240099AbhKQSm7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 13:42:59 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 669A461BD4;
        Wed, 17 Nov 2021 18:40:00 +0000 (UTC)
Date:   Wed, 17 Nov 2021 13:39:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] [RFC] trace: Add interface for configuring trace
 ring buffer size
Message-ID: <20211117133958.71312e76@gandalf.local.home>
In-Reply-To: <20211117154101.38659-3-tz.stoyanov@gmail.com>
References: <20211117154101.38659-1-tz.stoyanov@gmail.com>
        <20211117154101.38659-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 17 Nov 2021 17:41:00 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The trace ring buffer page size can be configured, per trace instance. A
> new ftrace file "buffer_page_size" is added to get and set the size of
> the ring buffer page for current trace instance. The size must be
> multiple of system page size, that's why the new interface works with
> system page count, instead of absolute page size: 1 means the ring
> buffer page is equal to one system page and so forth. The ring buffer
> page is limited between 1 and 100 system pages.

It should be an order of pages, not a size (or a multiple).

0 - 1 page
1 - 2 pages
2 - 4 pages
3 - 8 pages
4 - 16 pages
[..]


> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/linux/ring_buffer.h |  3 +++
>  kernel/trace/ring_buffer.c  | 51 +++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace.c        | 47 ++++++++++++++++++++++++++++++++++
>  3 files changed, 101 insertions(+)
> 
> diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
> index d9a2e6e8fb79..53cd7a38b717 100644
> --- a/include/linux/ring_buffer.h
> +++ b/include/linux/ring_buffer.h
> @@ -202,6 +202,9 @@ struct trace_seq;
>  int ring_buffer_print_entry_header(struct trace_seq *s);
>  int ring_buffer_print_page_header(struct trace_buffer *buffer, struct trace_seq *s);
>  
> +int ring_buffer_page_size_get(struct trace_buffer *buffer);
> +int ring_buffer_page_size_set(struct trace_buffer *buffer, int psize);

  ring_buffer_subbuf_order_get/set()

> +
>  enum ring_buffer_flags {
>  	RB_FL_OVERWRITE		= 1 << 0,
>  };
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 6bca2977ca1a..9aa245795c3d 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -5677,6 +5677,57 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_read_page);
>  
> +/**
> + * ring_buffer_page_size_get - get count of system pages in one buffer page.
> + * @buffer: The ring_buffer to get the system page count from
> + *
> + * By default, one ring buffer pages equals to one system page. This parameter
> + * is configurable, per ring buffer. The size of the ring buffer page can be
> + * extended, but must be multiple of system page size.
> + *
> + * Returns the size of buffer page, in system pages: 1 means the buffer size is
> + * one system page and so forth. In case of an error < 0 is returned.
> + */
> +int ring_buffer_page_size_get(struct trace_buffer *buffer)
> +{
> +	if (!buffer)
> +		return -EINVAL;
> +
> +	return (buffer->page_size + BUF_PAGE_HDR_SIZE) / PAGE_SIZE;

And save it to another field in the structure, and not calculate it.

> +}
> +EXPORT_SYMBOL_GPL(ring_buffer_page_size_get);
> +
> +/**
> + * ring_buffer_page_size_set - set the size of ring buffer page.
> + * @buffer: The ring_buffer to set the new page size.
> + * @pcount: Number of system pages.
> + *
> + * By default, one ring buffer pages equals to one system page. This API can be
> + * used to set new size of the ring buffer page. The size must be multiple of
> + * system page size, that's why the input parameter @pcount is the count of
> + * system pages that are allocated for one ring buffer page.
> + *
> + * Returns 0 on success or < 0 in case of an error.
> + */
> +int ring_buffer_page_size_set(struct trace_buffer *buffer, int pcount)
> +{
> +	int psize;
> +
> +	if (!buffer)
> +		return -EINVAL;
> +
> +	psize = pcount * PAGE_SIZE;
> +	if (psize <= BUF_PAGE_HDR_SIZE)
> +		return -EINVAL;
> +
> +	buffer->page_size = psize - BUF_PAGE_HDR_SIZE;
> +
> +	/* Todo: reset the buffer with the new page size */
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ring_buffer_page_size_set);
> +
>  /*
>   * We only allocate new buffers, never free them if the CPU goes down.
>   * If we were to free the buffer, then the user would lose any trace that was in
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index f9139dc1262c..05fc2712fdbd 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -9005,6 +9005,50 @@ static const struct file_operations buffer_percent_fops = {
>  	.llseek		= default_llseek,
>  };
>  
> +static ssize_t
> +buffer_psize_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
> +{
> +	struct trace_array *tr = filp->private_data;
> +	char buf[64];
> +	int r;
> +
> +	r = sprintf(buf, "%d\n", ring_buffer_page_size_get(tr->array_buffer.buffer));
> +
> +	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
> +}
> +
> +static ssize_t
> +buffer_psize_write(struct file *filp, const char __user *ubuf,
> +		   size_t cnt, loff_t *ppos)
> +{
> +	struct trace_array *tr = filp->private_data;
> +	unsigned long val;
> +	int ret;
> +
> +	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val < 1 || val > 100)
> +		return -EINVAL;
> +
> +	ret = ring_buffer_page_size_set(tr->array_buffer.buffer, val);
> +	if (ret)
> +		return ret;
> +
> +	(*ppos)++;
> +
> +	return cnt;
> +}
> +
> +static const struct file_operations buffer_psize_fops = {
> +	.open		= tracing_open_generic_tr,
> +	.read		= buffer_psize_read,
> +	.write		= buffer_psize_write,
> +	.release	= tracing_release_generic_tr,
> +	.llseek		= default_llseek,
> +};
> +
>  static struct dentry *trace_instance_dir;
>  
>  static void
> @@ -9458,6 +9502,9 @@ init_tracer_tracefs(struct trace_array *tr, struct dentry *d_tracer)
>  	trace_create_file("buffer_percent", TRACE_MODE_READ, d_tracer,
>  			tr, &buffer_percent_fops);
>  
> +	trace_create_file("buffer_page_size", TRACE_MODE_WRITE, d_tracer,

 "buffer_subbuf_order"

-- Steve

> +			tr, &buffer_psize_fops);
> +
>  	create_trace_options_dir(tr);
>  
>  	trace_create_maxlat_file(tr, d_tracer);

