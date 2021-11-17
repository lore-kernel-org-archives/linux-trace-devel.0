Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3338FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 15:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18C2C6140A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 15:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238532AbhKQPoO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 10:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238596AbhKQPoF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 10:44:05 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FC9C061766
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Nov 2021 07:41:06 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id f7-20020a1c1f07000000b0032ee11917ceso2495268wmf.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Nov 2021 07:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5l1zCIP4ini0lNwinBa107HvzxDn5sNWZYaRQzHbRr4=;
        b=GfveRmm42rwz37xWMFcKFVDrlDvF6Vak0kufISWSHpot+RJo3vys3eIh/RdC6hvPoh
         0Rtn4EROrRkc6js0c3YAlPDblrU9aBLIGd5eRKDJYbA9FztKcyp9T7cxjfp35UxYXN4x
         ICBDqDtw0giNRHf/gqdW47d0ywYJAZvyrgbBmLu0Hj8hM86c3mm/jJjbdLuI6Y+Fbq6Z
         e71I5sBn7Eo4cJBn65cregukBvtc+mlzqPeAG1UynGeb8C1joySxmITyYHfQa7oft+cU
         u2xbEJtq7fGkm6ED3cN6gp9i0V4sjdon9PTaYSslKnizL97DZeVRq14G+iK4KmZx9V55
         gamw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5l1zCIP4ini0lNwinBa107HvzxDn5sNWZYaRQzHbRr4=;
        b=IAZ1J0Z44Uv8CuPqzIFj/LzFHUIKQj/C5p6B6iRa67N3NuYRKwOGhnJg9SdAfujkBz
         5jYMyBmZIZ0qF3/JWIsbLSII17vloknMWbUHwKgExq/cxe3BtQUaM4ZDswt9d9Cghkaf
         VGuEgoH3iuWP0Wx01/ae8CzVB0bYirYma8qHQAn+JvoOC4HyZ5j3eVNyjGYQLyQ8s6UU
         DlwEyVyqXA9SQE53oEu6J0eyWTyhWB5wplnaBEpNVVzDqN6j+716X9hLMMlvRnre9gBh
         w+MbOTN/fdEJZap82AZYFPUnsafLDDdB2g3x47Tw4xHLi+JDfkFZlUKhze1dVfNwec4W
         V1+w==
X-Gm-Message-State: AOAM530WQb69KgNNXOGxXVNpMtU56nJN0jEZXum4Tqz4gv7HoBAhEnYB
        9d7MmN60tUg5jK46QCx46JfwDvpcWHN69g==
X-Google-Smtp-Source: ABdhPJwzP3Y6H8NPrOhppOHs28EjSCljJEaRXv6R/SYPimBNO/74M7J+eRIEkdQ76iZVY7AD47pbPQ==
X-Received: by 2002:a7b:c207:: with SMTP id x7mr731692wmi.108.1637163665055;
        Wed, 17 Nov 2021 07:41:05 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d7sm185759wrw.87.2021.11.17.07.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 07:41:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] [RFC] trace: Page size per ring buffer
Date:   Wed, 17 Nov 2021 17:40:59 +0200
Message-Id: <20211117154101.38659-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117154101.38659-1-tz.stoyanov@gmail.com>
References: <20211117154101.38659-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently the size of one buffer page is global for all buffers and it
is hard coded to one system page. In order to introduce configurable
ring buffer page size, the internal logic should be refactored to work
with page size per ring buffer.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/linux/ring_buffer.h |   2 +-
 kernel/trace/ring_buffer.c  | 117 +++++++++++++++++++-----------------
 kernel/trace/trace_events.c |  71 +++++++++++++++++++---
 3 files changed, 123 insertions(+), 67 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index dac53fd3afea..d9a2e6e8fb79 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -200,7 +200,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer, void **data_page,
 struct trace_seq;
 
 int ring_buffer_print_entry_header(struct trace_seq *s);
-int ring_buffer_print_page_header(struct trace_seq *s);
+int ring_buffer_print_page_header(struct trace_buffer *buffer, struct trace_seq *s);
 
 enum ring_buffer_flags {
 	RB_FL_OVERWRITE		= 1 << 0,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2699e9e562b1..6bca2977ca1a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -366,40 +366,8 @@ static inline int test_time_stamp(u64 delta)
 	return 0;
 }
 
-#define BUF_PAGE_SIZE (PAGE_SIZE - BUF_PAGE_HDR_SIZE)
-
-/* Max payload is BUF_PAGE_SIZE - header (8bytes) */
-#define BUF_MAX_DATA_SIZE (BUF_PAGE_SIZE - (sizeof(u32) * 2))
-
-int ring_buffer_print_page_header(struct trace_seq *s)
-{
-	struct buffer_data_page field;
-
-	trace_seq_printf(s, "\tfield: u64 timestamp;\t"
-			 "offset:0;\tsize:%u;\tsigned:%u;\n",
-			 (unsigned int)sizeof(field.time_stamp),
-			 (unsigned int)is_signed_type(u64));
-
-	trace_seq_printf(s, "\tfield: local_t commit;\t"
-			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
-			 (unsigned int)offsetof(typeof(field), commit),
-			 (unsigned int)sizeof(field.commit),
-			 (unsigned int)is_signed_type(long));
-
-	trace_seq_printf(s, "\tfield: int overwrite;\t"
-			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
-			 (unsigned int)offsetof(typeof(field), commit),
-			 1,
-			 (unsigned int)is_signed_type(long));
-
-	trace_seq_printf(s, "\tfield: char data;\t"
-			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
-			 (unsigned int)offsetof(typeof(field), data),
-			 (unsigned int)BUF_PAGE_SIZE,
-			 (unsigned int)is_signed_type(char));
-
-	return !trace_seq_has_overflowed(s);
-}
+/* Max payload is buffer page size - header (8bytes) */
+#define BUF_MAX_DATA_SIZE(B) ((B)->page_size - (sizeof(u32) * 2))
 
 struct rb_irq_work {
 	struct irq_work			work;
@@ -544,6 +512,8 @@ struct trace_buffer {
 
 	struct rb_irq_work		irq_work;
 	bool				time_stamp_abs;
+
+	unsigned int			page_size;
 };
 
 struct ring_buffer_iter {
@@ -559,6 +529,36 @@ struct ring_buffer_iter {
 	int				missed_events;
 };
 
+int ring_buffer_print_page_header(struct trace_buffer *buffer, struct trace_seq *s)
+{
+	struct buffer_data_page field;
+
+	trace_seq_printf(s, "\tfield: u64 timestamp;\t"
+			 "offset:0;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)sizeof(field.time_stamp),
+			 (unsigned int)is_signed_type(u64));
+
+	trace_seq_printf(s, "\tfield: local_t commit;\t"
+			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)offsetof(typeof(field), commit),
+			 (unsigned int)sizeof(field.commit),
+			 (unsigned int)is_signed_type(long));
+
+	trace_seq_printf(s, "\tfield: int overwrite;\t"
+			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)offsetof(typeof(field), commit),
+			 1,
+			 (unsigned int)is_signed_type(long));
+
+	trace_seq_printf(s, "\tfield: char data;\t"
+			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)offsetof(typeof(field), data),
+			 (unsigned int)buffer->page_size,
+			 (unsigned int)is_signed_type(char));
+
+	return !trace_seq_has_overflowed(s);
+}
+
 #ifdef RB_TIME_32
 
 /*
@@ -1725,7 +1725,9 @@ struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 	if (!zalloc_cpumask_var(&buffer->cpumask, GFP_KERNEL))
 		goto fail_free_buffer;
 
-	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
+	/* Default buffer page size - one system page */
+	buffer->page_size = PAGE_SIZE - BUF_PAGE_HDR_SIZE;
+	nr_pages = DIV_ROUND_UP(size, buffer->page_size);
 	buffer->flags = flags;
 	buffer->clock = trace_clock_local;
 	buffer->reader_lock_key = key;
@@ -1919,7 +1921,8 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned long nr_pages)
 			 * Increment overrun to account for the lost events.
 			 */
 			local_add(page_entries, &cpu_buffer->overrun);
-			local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
+			local_sub(cpu_buffer->buffer->page_size,
+				  &cpu_buffer->entries_bytes);
 		}
 
 		/*
@@ -2041,7 +2044,7 @@ static void update_pages_handler(struct work_struct *work)
  * @size: the new size.
  * @cpu_id: the cpu buffer to resize
  *
- * Minimum size is 2 * BUF_PAGE_SIZE.
+ * Minimum size is 2 * buffer->page_size.
  *
  * Returns 0 on success and < 0 on failure.
  */
@@ -2063,7 +2066,7 @@ int ring_buffer_resize(struct trace_buffer *buffer, unsigned long size,
 	    !cpumask_test_cpu(cpu_id, buffer->cpumask))
 		return 0;
 
-	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
+	nr_pages = DIV_ROUND_UP(size, buffer->page_size);
 
 	/* we need a minimum of two pages */
 	if (nr_pages < 2)
@@ -2290,7 +2293,7 @@ rb_iter_head_event(struct ring_buffer_iter *iter)
 	 */
 	barrier();
 
-	if ((iter->head + length) > commit || length > BUF_MAX_DATA_SIZE)
+	if ((iter->head + length) > commit || length > BUF_MAX_DATA_SIZE(iter->cpu_buffer->buffer))
 		/* Writer corrupted the read? */
 		goto reset;
 
@@ -2403,7 +2406,8 @@ rb_handle_head_page(struct ring_buffer_per_cpu *cpu_buffer,
 		 * the counters.
 		 */
 		local_add(entries, &cpu_buffer->overrun);
-		local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
+		local_sub(cpu_buffer->buffer->page_size,
+			  &cpu_buffer->entries_bytes);
 
 		/*
 		 * The entries will be zeroed out when we move the
@@ -2530,13 +2534,13 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	 * Only the event that crossed the page boundary
 	 * must fill the old tail_page with padding.
 	 */
-	if (tail >= BUF_PAGE_SIZE) {
+	if (tail >= cpu_buffer->buffer->page_size) {
 		/*
 		 * If the page was filled, then we still need
 		 * to update the real_end. Reset it to zero
 		 * and the reader will ignore it.
 		 */
-		if (tail == BUF_PAGE_SIZE)
+		if (tail == cpu_buffer->buffer->page_size)
 			tail_page->real_end = 0;
 
 		local_sub(length, &tail_page->write);
@@ -2546,7 +2550,8 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	event = __rb_page_index(tail_page, tail);
 
 	/* account for padding bytes */
-	local_add(BUF_PAGE_SIZE - tail, &cpu_buffer->entries_bytes);
+	local_add(cpu_buffer->buffer->page_size - tail,
+		  &cpu_buffer->entries_bytes);
 
 	/*
 	 * Save the original length to the meta data.
@@ -2566,7 +2571,7 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	 * If we are less than the minimum size, we don't need to
 	 * worry about it.
 	 */
-	if (tail > (BUF_PAGE_SIZE - RB_EVNT_MIN_SIZE)) {
+	if (tail > (cpu_buffer->buffer->page_size - RB_EVNT_MIN_SIZE)) {
 		/* No room for any events */
 
 		/* Mark the rest of the page with padding */
@@ -2578,13 +2583,13 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	}
 
 	/* Put in a discarded event */
-	event->array[0] = (BUF_PAGE_SIZE - tail) - RB_EVNT_HDR_SIZE;
+	event->array[0] = (cpu_buffer->buffer->page_size - tail) - RB_EVNT_HDR_SIZE;
 	event->type_len = RINGBUF_TYPE_PADDING;
 	/* time delta must be non zero */
 	event->time_delta = 1;
 
 	/* Set write to end of buffer */
-	length = (tail + length) - BUF_PAGE_SIZE;
+	length = (tail + length) - cpu_buffer->buffer->page_size;
 	local_sub(length, &tail_page->write);
 }
 
@@ -3476,7 +3481,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	tail = write - info->length;
 
 	/* See if we shot pass the end of this buffer page */
-	if (unlikely(write > BUF_PAGE_SIZE)) {
+	if (unlikely(write > cpu_buffer->buffer->page_size)) {
 		/* before and after may now different, fix it up*/
 		b_ok = rb_time_read(&cpu_buffer->before_stamp, &info->before);
 		a_ok = rb_time_read(&cpu_buffer->write_stamp, &info->after);
@@ -3685,7 +3690,7 @@ ring_buffer_lock_reserve(struct trace_buffer *buffer, unsigned long length)
 	if (unlikely(atomic_read(&cpu_buffer->record_disabled)))
 		goto out;
 
-	if (unlikely(length > BUF_MAX_DATA_SIZE))
+	if (unlikely(length > BUF_MAX_DATA_SIZE(buffer)))
 		goto out;
 
 	if (unlikely(trace_recursive_lock(cpu_buffer)))
@@ -3835,7 +3840,7 @@ int ring_buffer_write(struct trace_buffer *buffer,
 	if (atomic_read(&cpu_buffer->record_disabled))
 		goto out;
 
-	if (length > BUF_MAX_DATA_SIZE)
+	if (length > BUF_MAX_DATA_SIZE(buffer))
 		goto out;
 
 	if (unlikely(trace_recursive_lock(cpu_buffer)))
@@ -4957,7 +4962,7 @@ ring_buffer_read_prepare(struct trace_buffer *buffer, int cpu, gfp_t flags)
 	if (!iter)
 		return NULL;
 
-	iter->event = kmalloc(BUF_MAX_DATA_SIZE, flags);
+	iter->event = kmalloc(BUF_MAX_DATA_SIZE(buffer), flags);
 	if (!iter->event) {
 		kfree(iter);
 		return NULL;
@@ -5075,14 +5080,14 @@ unsigned long ring_buffer_size(struct trace_buffer *buffer, int cpu)
 {
 	/*
 	 * Earlier, this method returned
-	 *	BUF_PAGE_SIZE * buffer->nr_pages
+	 *	buffer->page_size * buffer->nr_pages
 	 * Since the nr_pages field is now removed, we have converted this to
 	 * return the per cpu buffer value.
 	 */
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 0;
 
-	return BUF_PAGE_SIZE * buffer->buffers[cpu]->nr_pages;
+	return buffer->page_size * buffer->buffers[cpu]->nr_pages;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_size);
 
@@ -5618,7 +5623,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	} else {
 		/* update the entry counter */
 		cpu_buffer->read += rb_page_entries(reader);
-		cpu_buffer->read_bytes += BUF_PAGE_SIZE;
+		cpu_buffer->read_bytes += buffer->page_size;
 
 		/* swap the pages */
 		rb_init_page(bpage);
@@ -5649,7 +5654,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 		/* If there is room at the end of the page to save the
 		 * missed events, then record it there.
 		 */
-		if (BUF_PAGE_SIZE - commit >= sizeof(missed_events)) {
+		if (buffer->page_size - commit >= sizeof(missed_events)) {
 			memcpy(&bpage->data[commit], &missed_events,
 			       sizeof(missed_events));
 			local_add(RB_MISSED_STORED, &bpage->commit);
@@ -5661,8 +5666,8 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	/*
 	 * This page may be off to user land. Zero it out here.
 	 */
-	if (commit < BUF_PAGE_SIZE)
-		memset(&bpage->data[commit], 0, BUF_PAGE_SIZE - commit);
+	if (commit < buffer->page_size)
+		memset(&bpage->data[commit], 0, buffer->page_size - commit);
 
  out_unlock:
 	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 4021b9a79f93..a2bac76e73d3 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1846,10 +1846,31 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	return cnt;
 }
 
+static int open_header_file(struct inode *inode, struct file *filp)
+{
+	struct trace_array *tr = inode->i_private;
+	int ret;
+
+	ret = tracing_check_open_get_tr(tr);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int release_header_file(struct inode *inode, struct file *file)
+{
+	struct trace_array *tr = inode->i_private;
+
+	trace_array_put(tr);
+
+	return 0;
+}
+
 static ssize_t
-show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
+show_header_page_file(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 {
-	int (*func)(struct trace_seq *s) = filp->private_data;
+	struct trace_array *tr = file_inode(filp)->i_private;
 	struct trace_seq *s;
 	int r;
 
@@ -1862,7 +1883,31 @@ show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 
 	trace_seq_init(s);
 
-	func(s);
+	ring_buffer_print_page_header(tr->array_buffer.buffer, s);
+	r = simple_read_from_buffer(ubuf, cnt, ppos,
+				    s->buffer, trace_seq_used(s));
+
+	kfree(s);
+
+	return r;
+}
+
+static ssize_t
+show_header_event_file(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	struct trace_seq *s;
+	int r;
+
+	if (*ppos)
+		return 0;
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	trace_seq_init(s);
+
+	ring_buffer_print_entry_header(s);
 	r = simple_read_from_buffer(ubuf, cnt, ppos,
 				    s->buffer, trace_seq_used(s));
 
@@ -2117,10 +2162,18 @@ static const struct file_operations ftrace_tr_enable_fops = {
 	.release = subsystem_release,
 };
 
-static const struct file_operations ftrace_show_header_fops = {
-	.open = tracing_open_generic,
-	.read = show_header,
+static const struct file_operations ftrace_show_header_page_fops = {
+	.open = open_header_file,
+	.read = show_header_page_file,
+	.llseek = default_llseek,
+	.release = release_header_file,
+};
+
+static const struct file_operations ftrace_show_header_event_fops = {
+	.open = open_header_file,
+	.read = show_header_event_file,
 	.llseek = default_llseek,
+	.release = release_header_file,
 };
 
 static int
@@ -3469,14 +3522,12 @@ create_event_toplevel_files(struct dentry *parent, struct trace_array *tr)
 
 	/* ring buffer internal formats */
 	entry = trace_create_file("header_page", TRACE_MODE_READ, d_events,
-				  ring_buffer_print_page_header,
-				  &ftrace_show_header_fops);
+				  tr, &ftrace_show_header_page_fops);
 	if (!entry)
 		pr_warn("Could not create tracefs 'header_page' entry\n");
 
 	entry = trace_create_file("header_event", TRACE_MODE_READ, d_events,
-				  ring_buffer_print_entry_header,
-				  &ftrace_show_header_fops);
+				  tr, &ftrace_show_header_event_fops);
 	if (!entry)
 		pr_warn("Could not create tracefs 'header_event' entry\n");
 
-- 
2.31.1

