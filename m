Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE41EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhLBM2t (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbhLBM2r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:47 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEFFC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:24 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y12so115204397eda.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vd+5I0JDkU0IGofdmfAZ9EoBCP92QoZYMavCimfRqvU=;
        b=IamQ9FDezJAzklJu4ii1CNCYjW8GFLVjCc1fwYiwl/gQRi7huOrhe6Gq69WW3+zEmG
         mIfrg5Mv/yCxEF/1BxP6IjFO+iMQfpabClJfGMWqyDCAGy7uHSY0Rtvu/dLDffif+wfk
         idk40p1oY3SMQTmkl1ZK6VquqR3JfUww6Y7AHjARqt1gKPGy0XOaIgpbZ7HCFfS4SSeJ
         X6Oq064+RRs3QBzweaE+HrpjxpEbp2zGPsU4TTo6YmqWQ54AAV7Y5pSP9xoLeeMziWD1
         5mWVPTHtuVt1PMJsrxJeVRa2+dEjLtfPW0+AUZPoCo9xrfYYatQ2D4ITbhs/YCb5jE9+
         Nfgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vd+5I0JDkU0IGofdmfAZ9EoBCP92QoZYMavCimfRqvU=;
        b=6gU7yGQXoUHtiG1BUZhgwI/XARplIuuONjdkyTE4PWQmzG17v5ufRpG3LAgDWKaB9h
         4/DpGKfskYnJP1Hr1JjARFEOxxWrlGvletSWQRpv3FF4wjNYRw+oMZO+SlWdp5V60QGA
         1kcNoPKyIAnu1I5fQ5n71+aqpGuqaF+9Aqi+YGBT8u/balhDomzO+hfQc1UjyeneATiL
         Pq+erU59Hm1hlxO8AOok2N41UvPnKRqALcscnUWoHEk06EG2Rn5UNPvFW15ew0GP3HgK
         VPN6rqh6dzXzXEog8IGCug95lRL1qGdf6AGH3RhGS1qmtd74ISuXEBZ4KJsbYIMlcmu5
         c5hw==
X-Gm-Message-State: AOAM532a5mcMwEfe16XRRfWHN0eljXlj8dcaAfJqSF2l++12/8gVYhhw
        f8Cd6g+JS5Vh27kZXI+VfjZtzQL8Q8u1zA==
X-Google-Smtp-Source: ABdhPJwW2Mftt+wlFcxdisylwxaK47nuu89NjPmoVNYQ6g5OuvNJoqKc4ZTXJctwizGo600+DXepkg==
X-Received: by 2002:a05:6402:26d4:: with SMTP id x20mr17459312edd.119.1638447922214;
        Thu, 02 Dec 2021 04:25:22 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:21 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 14/20] trace-cmd library: Add logic for in-memory decompression
Date:   Thu,  2 Dec 2021 14:25:01 +0200
Message-Id: <20211202122507.43572-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are two approaches to read compressed trace data:
 - use a temporary file to decompress entire trace data before reading
 - use in-memory decompression of requested trace data chunk only
In-memory decompression seems to be more efficient, but selecting which
approach to use depends in the use case.
A compression chunk consists of multiple trace pages, that's why a small
cache with uncompressed chunks is implemented. The chunk stays in the
cache until there are pages which have reference to it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 110 ++++++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 7bbd5485..baad5994 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -29,6 +29,9 @@
 
 #define COMMIT_MASK ((1 << 27) - 1)
 
+/* force uncompressing in memory */
+#define INMEMORY_DECOMPRESS
+
 /* for debugging read instead of mmap */
 static int force_read = 0;
 
@@ -1250,6 +1253,105 @@ static void free_page_map(struct page_map *page_map)
 	free(page_map);
 }
 
+#define CHUNK_CHECK_OFFSET(C, O)	((O) >= (C)->offset && (O) < ((C)->offset + (C)->size))
+static struct tracecmd_compress_chunk *get_zchunk(struct cpu_data *cpu, off64_t offset)
+{
+	struct cpu_zdata *cpuz = &cpu->compress;
+	int min, mid, max;
+
+	if (!cpuz->chunks)
+		return NULL;
+	if (offset > (cpuz->chunks[cpuz->count - 1].offset + cpuz->chunks[cpuz->count - 1].size))
+		return NULL;
+
+	/* check if the requested offset is in the last requested chunk or in the next chunk */
+	if (CHUNK_CHECK_OFFSET(cpuz->chunks + cpuz->last_chunk, offset))
+		return cpuz->chunks + cpuz->last_chunk;
+	cpuz->last_chunk++;
+	if (cpuz->last_chunk < cpuz->count &&
+	    CHUNK_CHECK_OFFSET(cpuz->chunks + cpuz->last_chunk, offset))
+		return cpuz->chunks + cpuz->last_chunk;
+
+	/* do a binary search to find the chunk holding the given offset */
+	min = 0;
+	max = cpuz->count - 1;
+	mid = (min + max)/2;
+	while (min <= max) {
+		if (offset < cpuz->chunks[mid].offset)
+			max = mid - 1;
+		else if (offset > (cpuz->chunks[mid].offset + cpuz->chunks[mid].size))
+			min = mid + 1;
+		else
+			break;
+		mid = (min + max)/2;
+	}
+	cpuz->last_chunk = mid;
+	return cpuz->chunks + mid;
+}
+
+static void free_zpage(struct cpu_data *cpu_data, void *map)
+{
+	struct zchunk_cache *cache;
+
+	list_for_each_entry(cache, &cpu_data->compress.cache, list) {
+		if (map <= cache->map && map > (cache->map + cache->chunk->size))
+			goto found;
+	}
+	return;
+
+found:
+	cache->ref--;
+	if (cache->ref)
+		return;
+	list_del(&cache->list);
+	free(cache->map);
+	free(cache);
+}
+
+static void *read_zpage(struct tracecmd_input *handle, int cpu, off64_t offset)
+{
+	struct cpu_data *cpu_data = &handle->cpu_data[cpu];
+	struct tracecmd_compress_chunk *chunk;
+	struct zchunk_cache *cache;
+	void *map = NULL;
+	int pindex;
+	int size;
+
+	/* Look in the cache of already loaded chunks */
+	list_for_each_entry(cache, &cpu_data->compress.cache, list) {
+		if (CHUNK_CHECK_OFFSET(cache->chunk, offset)) {
+			cache->ref++;
+			goto out;
+		}
+	}
+
+	chunk =  get_zchunk(cpu_data, offset);
+	if (!chunk)
+		return NULL;
+	size = handle->page_size > chunk->size ? handle->page_size : chunk->size;
+	map = malloc(size);
+	if (!map)
+		return NULL;
+	if (tracecmd_uncompress_chunk(handle->compress, chunk, map) < 0)
+		goto error;
+
+	cache = calloc(1, sizeof(struct zchunk_cache));
+	if (!cache)
+		goto error;
+	cache->ref = 1;
+	cache->chunk = chunk;
+	cache->map = map;
+	list_add(&cache->list, &cpu_data->compress.cache);
+
+	/* a chunk can hold multiple pages, get the requested one */
+out:
+	pindex = (offset - cache->chunk->offset) / handle->page_size;
+	return cache->map + (pindex * handle->page_size);
+error:
+	free(map);
+	return NULL;
+}
+
 static void *allocate_page_map(struct tracecmd_input *handle,
 			       struct page *page, int cpu, off64_t offset)
 {
@@ -1261,6 +1363,9 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 	int ret;
 	int fd;
 
+	if (handle->cpu_compressed && handle->read_zpage)
+		return read_zpage(handle, cpu, offset);
+
 	if (handle->read_page) {
 		map = malloc(handle->page_size);
 		if (!map)
@@ -1403,6 +1508,8 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 
 	if (handle->read_page)
 		free(page->map);
+	else if (handle->read_zpage)
+		free_zpage(cpu_data, page->map);
 	else
 		free_page_map(page->page_map);
 
@@ -3889,6 +3996,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
 
+#ifdef INMEMORY_DECOMPRESS
+	handle->read_zpage = 1;
+#endif
 	if (do_read_check(handle, buf, 3))
 		goto failed_read;
 
-- 
2.33.1

