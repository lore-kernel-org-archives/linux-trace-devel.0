Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C16C43217
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Dec 2021 10:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241424AbhLMKEf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Dec 2021 05:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238099AbhLMJ6j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Dec 2021 04:58:39 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFB2C08EB29
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Dec 2021 01:48:32 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z5so50766606edd.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Dec 2021 01:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dEBZrJY7x9+p5wonW466oAoCm/VHVN/Kkq9coJG1KbM=;
        b=IRLJCfALUi88Pn7Ytf6nGMImZefZr/dRyKUaTOcWsARmIKmvjFqkTPFsihMHH5IqV4
         EMNtTRJojNzyvGy0fvYcEpJq4bdYhEENro6RqJXZAQ52GMb2tzex7sDHJoaPa5qPL1CI
         OK71VRF+2iSK3NHDKCmz4SrhWjWFbwcU+SJeQzG85IYMB25c27TDyw0Gw+Z7KnMl7jIj
         iDOP9SOupsKxO2BPOUwJinoAACpZXQYb8eLmPKY6xZmmpTTGHdmKSyJ9XrVYAAQR1rIZ
         H60HeUvdO8WYZGevDWCSU88jo7i+iraRyiRrECah61CHHoINpNGTCOY86FTyTIS1jLSt
         uXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dEBZrJY7x9+p5wonW466oAoCm/VHVN/Kkq9coJG1KbM=;
        b=S8vxPu+kzc35NZvx50+3ndSg31kb8SefBMCpA7MsAWBHefnKDhaWycjStVCK/4yUP3
         g1rcfxF7MtWS/cb33RPe0F6qg+9XxadW7kmI3rN9tWIx+bOrP6UyTjrzOOc5UvLCCa8/
         Xeta1oiF6y7i6gsK6/UkpIH5XpfSaJrPI6utqon5v4rcvG73hxn6HbG08RvNdnT4Q+Qk
         /ythn0l+F83Kwz6n8yZ6+rHneKS2rO7iZ3xianYC3Ftjea9tr/UfSwSdEy555uCTaRLY
         m1vVtXwzuQ0B462gd1VEiRmEQFm3DCtCmkggh1ASkXS4sNafNIFY8dOjOQo+jB822Wia
         3A0Q==
X-Gm-Message-State: AOAM532QuJhXbt6boq0RSxFFaJ61UT1IjcZ8MNRjWUG0j56IbSfYHfzH
        OO3L76J5E+mR91IcDfhDDuzSQsQYzfM=
X-Google-Smtp-Source: ABdhPJxuAdIbbB0hXQDHxQOaJCG1WvZEU0D+VU2UhLWbWmjWXL8UMm9WztCLk+bvCriML2gcxP8Wrw==
X-Received: by 2002:a05:6402:604:: with SMTP id n4mr62556846edv.226.1639388911523;
        Mon, 13 Dec 2021 01:48:31 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id yd20sm5465748ejb.47.2021.12.13.01.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 01:48:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 4/5] [RFC] tracing: Set new size of the ring buffer sub page
Date:   Mon, 13 Dec 2021 11:48:24 +0200
Message-Id: <20211213094825.61876-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211213094825.61876-1-tz.stoyanov@gmail.com>
References: <20211213094825.61876-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are two approaches when changing the size of the ring buffer
sub page:
 1. Destroying all pages and allocating new pages with the new size.
 2. Allocating new pages, copying the content of the old pages before
    destroying them.
The first approach is easier, it is selected in the proposed
implementation. Changing the ring buffer sub page size is supposed to
not happen frequently. Usually, that size should be set only once,
when the buffer is not in use yet and is supposed to be empty.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 kernel/trace/ring_buffer.c | 80 ++++++++++++++++++++++++++++++++++----
 1 file changed, 73 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 4aa5361a8f4c..a40fcb1cb299 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -323,6 +323,7 @@ struct buffer_page {
 	unsigned	 read;		/* index for next read */
 	local_t		 entries;	/* entries on this page */
 	unsigned long	 real_end;	/* real end of data */
+	unsigned	 order;		/* order of the page */
 	struct buffer_data_page *page;	/* Actual data page */
 };
 
@@ -352,7 +353,7 @@ static void rb_init_page(struct buffer_data_page *bpage)
  */
 static void free_buffer_page(struct buffer_page *bpage)
 {
-	free_page((unsigned long)bpage->page);
+	free_pages((unsigned long)bpage->page, bpage->order);
 	kfree(bpage);
 }
 
@@ -1563,10 +1564,12 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 
 		list_add(&bpage->list, pages);
 
-		page = alloc_pages_node(cpu_to_node(cpu_buffer->cpu), mflags, 0);
+		page = alloc_pages_node(cpu_to_node(cpu_buffer->cpu), mflags,
+					cpu_buffer->buffer->subbuf_order);
 		if (!page)
 			goto free_pages;
 		bpage->page = page_address(page);
+		bpage->order = cpu_buffer->buffer->subbuf_order;
 		rb_init_page(bpage->page);
 
 		if (user_thread && fatal_signal_pending(current))
@@ -1645,7 +1648,8 @@ rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
 	rb_check_bpage(cpu_buffer, bpage);
 
 	cpu_buffer->reader_page = bpage;
-	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
+
+	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, cpu_buffer->buffer->subbuf_order);
 	if (!page)
 		goto fail_free_reader;
 	bpage->page = page_address(page);
@@ -1725,6 +1729,7 @@ struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 		goto fail_free_buffer;
 
 	/* Default buffer page size - one system page */
+	buffer->subbuf_order = 0;
 	buffer->subbuf_size = PAGE_SIZE - BUF_PAGE_HDR_SIZE;
 
 	/* Max payload is buffer page size - header (8bytes) */
@@ -5434,8 +5439,8 @@ void *ring_buffer_alloc_read_page(struct trace_buffer *buffer, int cpu)
 	if (bpage)
 		goto out;
 
-	page = alloc_pages_node(cpu_to_node(cpu),
-				GFP_KERNEL | __GFP_NORETRY, 0);
+	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL | __GFP_NORETRY,
+				cpu_buffer->buffer->subbuf_order);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
@@ -5479,7 +5484,7 @@ void ring_buffer_free_read_page(struct trace_buffer *buffer, int cpu, void *data
 	local_irq_restore(flags);
 
  out:
-	free_page((unsigned long)bpage);
+	free_pages((unsigned long)bpage, buffer->subbuf_order);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_free_read_page);
 
@@ -5731,7 +5736,13 @@ EXPORT_SYMBOL_GPL(ring_buffer_subbuf_order_get);
  */
 int ring_buffer_subbuf_order_set(struct trace_buffer *buffer, int order)
 {
+	struct ring_buffer_per_cpu **cpu_buffers;
+	int old_order, old_size;
+	int nr_pages;
 	int psize;
+	int bsize;
+	int err;
+	int cpu;
 
 	if (!buffer || order < 0)
 		return -EINVAL;
@@ -5743,12 +5754,67 @@ int ring_buffer_subbuf_order_set(struct trace_buffer *buffer, int order)
 	if (psize <= BUF_PAGE_HDR_SIZE)
 		return -EINVAL;
 
+	bsize = sizeof(void *) * buffer->cpus;
+	cpu_buffers = kzalloc(bsize, GFP_KERNEL);
+	if (!cpu_buffers)
+		return -ENOMEM;
+
+	old_order = buffer->subbuf_order;
+	old_size = buffer->subbuf_size;
+
+	/* prevent another thread from changing buffer sizes */
+	mutex_lock(&buffer->mutex);
+	atomic_inc(&buffer->record_disabled);
+
+	/* Make sure all commits have finished */
+	synchronize_rcu();
+
 	buffer->subbuf_order = order;
 	buffer->subbuf_size = psize - BUF_PAGE_HDR_SIZE;
 
-	/* Todo: reset the buffer with the new page size */
+	/* Make sure all new buffers are allocated, before deleting the old ones */
+	for_each_buffer_cpu(buffer, cpu) {
+		if (!cpumask_test_cpu(cpu, buffer->cpumask))
+			continue;
+
+		nr_pages = buffer->buffers[cpu]->nr_pages;
+		cpu_buffers[cpu] = rb_allocate_cpu_buffer(buffer, nr_pages, cpu);
+		if (!cpu_buffers[cpu]) {
+			err = -ENOMEM;
+			goto error;
+		}
+	}
+
+	for_each_buffer_cpu(buffer, cpu) {
+		if (!cpumask_test_cpu(cpu, buffer->cpumask))
+			continue;
+
+		rb_free_cpu_buffer(buffer->buffers[cpu]);
+		buffer->buffers[cpu] = cpu_buffers[cpu];
+	}
+
+	atomic_dec(&buffer->record_disabled);
+	mutex_unlock(&buffer->mutex);
+
+	kfree(cpu_buffers);
 
 	return 0;
+
+error:
+	buffer->subbuf_order = old_order;
+	buffer->subbuf_size = old_size;
+
+	atomic_dec(&buffer->record_disabled);
+	mutex_unlock(&buffer->mutex);
+
+	for_each_buffer_cpu(buffer, cpu) {
+		if (!cpu_buffers[cpu])
+			continue;
+		kfree(cpu_buffers[cpu]);
+	}
+	kfree(cpu_buffers);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_subbuf_order_set);
 
-- 
2.31.1

