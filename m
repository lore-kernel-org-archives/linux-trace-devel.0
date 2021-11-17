Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B40C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 15:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61E92613A9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 15:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238550AbhKQPob (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 10:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238566AbhKQPoM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 10:44:12 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68E8C061204
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Nov 2021 07:41:08 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so2446509wme.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Nov 2021 07:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hi5GraPioADh9C0xG19uKeCask0+NebXYmDaDM8zCqw=;
        b=XDqsycb1fdW4UWTHtyJuKIe4BgNgCsqhQOzK02/zwmFeeUUmtXX/l5egPbKC2Mrn9d
         ddByFGoizamCzis7H9bibkA/nO7Kt0sZjIRYqDhUkhBPTYDb02tSg7/BSxkPcf9Mgbga
         sAvzlA+pXkPsmmkKPauKs0uVdS9BJ8KZMcpj7Qoai3zo/jmjB6lIqtqQBQQshFUXeNc8
         STyIVUU/xnflx/UcnviOuyjABq6TErujn3mgIOngk+xr/NZxwHSVgcOivQfsXj3lZBZ5
         jKR89VA4ArYax1bzT0CgBhOnXu4AMaiwqI/23VEfsWuYRG3JoohjEmdzDQ5ujKW4YYB7
         efug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hi5GraPioADh9C0xG19uKeCask0+NebXYmDaDM8zCqw=;
        b=uXIB5QsXyC338ZMUA5tdVqm1Nk6RskZghJNEz4ptQ0gpR+tMMNhnuM8N3CENVGD2KX
         cjDOylm7lJtAIJw6rAArCle26lBN8UV66r1pUGC3TYLKd11sIYbihR35Fe55IBc+cck8
         77/lK1aSa4vhdhgtYq9LWZFNgwL55hUKiPnhZ1riWKgENa2QDvTwvtvofSXwE1BDsxsQ
         t04GjvoWghVHPt7CvJeU3lk9GBMZu4Sn/GnTb8Da3giaw9ZOdebMNJd3pdatr4XPhR+n
         2YFxbOYwRItekrpdet87aAsKPbDssQtp9UFGI4y7zIsx/meFNumQupF0sKvUBomoDr7d
         oHzA==
X-Gm-Message-State: AOAM530VSS80nQObfRKqJrRTFF/Z9KrU07n5XAJxFu+2Etik0vZQoA/c
        GGxSsIRlK9PoXEGMYn7L6ZU9AZNeq6Fnqw==
X-Google-Smtp-Source: ABdhPJxg+27O7JbEphoaz8PLUbpTtJ5Tn+qR9smVi3F2y84vaWhrD+nmZyukIxC1soKC/WU18wBteg==
X-Received: by 2002:a1c:2047:: with SMTP id g68mr657010wmg.181.1637163667395;
        Wed, 17 Nov 2021 07:41:07 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d7sm185759wrw.87.2021.11.17.07.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 07:41:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] [WiP] trace: Set new size of the ring buffer page
Date:   Wed, 17 Nov 2021 17:41:01 +0200
Message-Id: <20211117154101.38659-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117154101.38659-1-tz.stoyanov@gmail.com>
References: <20211117154101.38659-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are two approaches when changing the size of the ring buffer page:
 1. Destroying all pages and allocating new pages with the new size.
 2. Allocating new pages, copying the content of the old pages before
    destroying them.
The first approach is easier, it is selected in the proposed
implementation. Changing the ring buffer page size is supposed to
not happen frequently. Usually, that size should be set only once,
when the buffer is not in use yet and is supposed to be empty.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 kernel/trace/ring_buffer.c | 95 ++++++++++++++++++++++++++++++++++----
 1 file changed, 86 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9aa245795c3d..39be9b1cf6e0 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -368,6 +368,7 @@ static inline int test_time_stamp(u64 delta)
 
 /* Max payload is buffer page size - header (8bytes) */
 #define BUF_MAX_DATA_SIZE(B) ((B)->page_size - (sizeof(u32) * 2))
+#define BUF_SYS_PAGE_COUNT(B) (((B)->page_size + BUF_PAGE_HDR_SIZE) / PAGE_SIZE)
 
 struct rb_irq_work {
 	struct irq_work			work;
@@ -1521,6 +1522,7 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	struct buffer_page *bpage, *tmp;
 	bool user_thread = current->mm != NULL;
 	gfp_t mflags;
+	int psize;
 	long i;
 
 	/*
@@ -1552,6 +1554,12 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	 */
 	if (user_thread)
 		set_current_oom_origin();
+
+	/* Buffer page size must be at least one system page */
+	psize = BUF_SYS_PAGE_COUNT(cpu_buffer->buffer) - 1;
+	if (psize < 0)
+		psize = 0;
+
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page;
 
@@ -1564,7 +1572,7 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 
 		list_add(&bpage->list, pages);
 
-		page = alloc_pages_node(cpu_to_node(cpu_buffer->cpu), mflags, 0);
+		page = alloc_pages_node(cpu_to_node(cpu_buffer->cpu), mflags, psize);
 		if (!page)
 			goto free_pages;
 		bpage->page = page_address(page);
@@ -1620,6 +1628,7 @@ rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_page *bpage;
 	struct page *page;
+	int psize;
 	int ret;
 
 	cpu_buffer = kzalloc_node(ALIGN(sizeof(*cpu_buffer), cache_line_size()),
@@ -1646,7 +1655,13 @@ rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
 	rb_check_bpage(cpu_buffer, bpage);
 
 	cpu_buffer->reader_page = bpage;
-	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
+
+	/* Buffer page size must be at least one system page */
+	psize = BUF_SYS_PAGE_COUNT(cpu_buffer->buffer) - 1;
+	if (psize < 0)
+		psize = 0;
+
+	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, psize);
 	if (!page)
 		goto fail_free_reader;
 	bpage->page = page_address(page);
@@ -5412,6 +5427,7 @@ void *ring_buffer_alloc_read_page(struct trace_buffer *buffer, int cpu)
 	struct buffer_data_page *bpage = NULL;
 	unsigned long flags;
 	struct page *page;
+	int psize;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return ERR_PTR(-ENODEV);
@@ -5431,8 +5447,13 @@ void *ring_buffer_alloc_read_page(struct trace_buffer *buffer, int cpu)
 	if (bpage)
 		goto out;
 
+	/* Buffer page size must be at least one system page */
+	psize = BUF_SYS_PAGE_COUNT(cpu_buffer->buffer) - 1;
+	if (psize < 0)
+		psize = 0;
+
 	page = alloc_pages_node(cpu_to_node(cpu),
-				GFP_KERNEL | __GFP_NORETRY, 0);
+				GFP_KERNEL | __GFP_NORETRY, psize);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
@@ -5693,10 +5714,70 @@ int ring_buffer_page_size_get(struct trace_buffer *buffer)
 	if (!buffer)
 		return -EINVAL;
 
-	return (buffer->page_size + BUF_PAGE_HDR_SIZE) / PAGE_SIZE;
+	return BUF_SYS_PAGE_COUNT(buffer);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_page_size_get);
 
+static int page_size_set(struct trace_buffer *buffer, int size)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	int old_size = buffer->page_size;
+	int nr_pages;
+	int ret = 0;
+	int err;
+	int cpu;
+
+	if (buffer->page_size == size)
+		return 0;
+
+	/* prevent another thread from changing buffer sizes */
+	mutex_lock(&buffer->mutex);
+	atomic_inc(&buffer->record_disabled);
+
+	/* Make sure all commits have finished */
+	synchronize_rcu();
+
+	buffer->page_size = size;
+
+	for_each_buffer_cpu(buffer, cpu) {
+
+		if (!cpumask_test_cpu(cpu, buffer->cpumask))
+			continue;
+
+		nr_pages = buffer->buffers[cpu]->nr_pages;
+		rb_free_cpu_buffer(buffer->buffers[cpu]);
+		buffer->buffers[cpu] = rb_allocate_cpu_buffer(buffer, nr_pages, cpu);
+	}
+
+	atomic_dec(&buffer->record_disabled);
+	mutex_unlock(&buffer->mutex);
+
+	return 0;
+
+out_err:
+	buffer->page_size = old_size;
+
+	for_each_buffer_cpu(buffer, cpu) {
+		struct buffer_page *bpage, *tmp;
+
+		cpu_buffer = buffer->buffers[cpu];
+
+		if (list_empty(&cpu_buffer->new_pages))
+			continue;
+
+		list_for_each_entry_safe(bpage, tmp, &cpu_buffer->new_pages, list) {
+			list_del_init(&bpage->list);
+			free_buffer_page(bpage);
+		}
+		atomic_dec(&cpu_buffer->record_disabled);
+		atomic_dec(&cpu_buffer->resize_disabled);
+	}
+
+	mutex_unlock(&buffer->mutex);
+
+	return err;
+}
+
 /**
  * ring_buffer_page_size_set - set the size of ring buffer page.
  * @buffer: The ring_buffer to set the new page size.
@@ -5720,11 +5801,7 @@ int ring_buffer_page_size_set(struct trace_buffer *buffer, int pcount)
 	if (psize <= BUF_PAGE_HDR_SIZE)
 		return -EINVAL;
 
-	buffer->page_size = psize - BUF_PAGE_HDR_SIZE;
-
-	/* Todo: reset the buffer with the new page size */
-
-	return 0;
+	return page_size_set(buffer, psize - BUF_PAGE_HDR_SIZE);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_page_size_set);
 
-- 
2.31.1

