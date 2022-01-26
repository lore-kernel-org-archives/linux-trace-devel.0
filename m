Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E68AC63684
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239391AbiAZJta (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239395AbiAZJt3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:29 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C39AC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:29 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b13so68358670edn.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+v2WjOWOn8HIz03LZ6uXpCrt32crd2VXiBB6y+xafqI=;
        b=ijK3x5xkT8rdBjwzzr4V+Ea/mCpVtapsCu6P8Lc0o9cUV+yQelPAhCIkZkiYeC65ob
         f5/LeZSHrlqzel9espeMdvBknDvXOPUBKIFOjh7X0fwrRQ7C+IALHWVa+VtwL3U/mS4e
         jU6l9QIYFG2QgHTIRISliv/frGJO63WaBfUjotDXmwnQUsvSC5jmtTK0ouhdZXYuT6vm
         GV7k20ZUOcEXJD7QyGhz5JY+823N3Kegajsx5rN47Iql07c6vG/jVPjtzxLFaTif69go
         4o001If9UVQo7Tf0jih44k5x3G4zT8LYDrlmYPePkkU6UFSBsuNtitDvDsO2QljYws6I
         fzZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+v2WjOWOn8HIz03LZ6uXpCrt32crd2VXiBB6y+xafqI=;
        b=gDcD1fuSGoxqFDqelcxst7g4QUnaF84AvinyClSkdcd7y2tbBoL4h3zoCGZZs7P3AH
         /R5Af0s0L6+nps4OCib6Y0XS177bq8YvMTs7Z6xA/feZmPSOLqCc68j/FhtldwNFeRW0
         5wV8VpStNmAvHZjx5RDSc5uNzqqLLWLugdwg9Oeji+jIVH5x9LfKJh3cnzApnEpf8K6R
         3bu1ceTw+azn1JfPi+Uw9Bo2oqWqYPPQu6zkBlCz8jQS3x7XcgouzlK1Zg4s95rQtQtv
         AiZwzB2i+m5E5guy8REOrAFLQd2ENTNzyjBZcNRgoGoBR9X66qwQ4zroYlQ7ZhBjNbT8
         yRxw==
X-Gm-Message-State: AOAM532qKneahyIfqOp5VrS8Dpd8NThvxstTJqHV19Nd8eL4Pd2Oa6vo
        wjT2MiGXTkSm/gvZPMcwa0brL1mnw7Q=
X-Google-Smtp-Source: ABdhPJyjXTprJQ8viiwrkKv3WIYBQrvU1OgaAnkqZYNj0MAZLTXZSk21GtzMuOcJRGvZ+/PAIm/lIw==
X-Received: by 2002:a05:6402:190e:: with SMTP id e14mr13473369edz.15.1643190567925;
        Wed, 26 Jan 2022 01:49:27 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 14/20] trace-cmd library: Add logic for in-memory decompression
Date:   Wed, 26 Jan 2022 11:49:00 +0200
Message-Id: <20220126094906.570451-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c | 124 ++++++++++++++++++++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 192f6596..c52aa951 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -29,6 +29,9 @@
 
 #define COMMIT_MASK ((1 << 27) - 1)
 
+/* force uncompressing in memory */
+#define INMEMORY_DECOMPRESS
+
 /* for debugging read instead of mmap */
 static int force_read = 0;
 
@@ -1257,6 +1260,119 @@ static void free_page_map(struct page_map *page_map)
 	free(page_map);
 }
 
+#define CHUNK_CHECK_OFFSET(C, O)	((O) >= (C)->offset && (O) < ((C)->offset + (C)->size))
+
+static int chunk_cmp(const void *A, const void *B)
+{
+	const struct tracecmd_compress_chunk *a = A;
+	const struct tracecmd_compress_chunk *b = B;
+
+	if (CHUNK_CHECK_OFFSET(b, a->offset))
+		return 0;
+
+	if (b->offset < a->offset)
+		return -1;
+
+	return 1;
+}
+
+static struct tracecmd_compress_chunk *get_zchunk(struct cpu_data *cpu, off64_t offset)
+{
+	struct cpu_zdata *cpuz = &cpu->compress;
+	struct tracecmd_compress_chunk *chunk;
+	struct tracecmd_compress_chunk key;
+
+	if (!cpuz->chunks)
+		return NULL;
+
+	if (offset > (cpuz->chunks[cpuz->count - 1].offset + cpuz->chunks[cpuz->count - 1].size))
+		return NULL;
+
+	/* check if the requested offset is in the last requested chunk or in the next chunk */
+	if (CHUNK_CHECK_OFFSET(cpuz->chunks + cpuz->last_chunk, offset))
+		return cpuz->chunks + cpuz->last_chunk;
+
+	cpuz->last_chunk++;
+	if (cpuz->last_chunk < cpuz->count &&
+	    CHUNK_CHECK_OFFSET(cpuz->chunks + cpuz->last_chunk, offset))
+		return cpuz->chunks + cpuz->last_chunk;
+
+	key.offset = offset;
+	chunk = bsearch(&key, cpuz->chunks, cpuz->count, sizeof(*chunk), chunk_cmp);
+
+	if (!chunk) /* should never happen */
+		return NULL;
+
+	cpuz->last_chunk = chunk - cpuz->chunks;
+	return chunk;
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
+
+	size = handle->page_size > chunk->size ? handle->page_size : chunk->size;
+	map = malloc(size);
+	if (!map)
+		return NULL;
+
+	if (tracecmd_uncompress_chunk(handle->compress, chunk, map) < 0)
+		goto error;
+
+	cache = calloc(1, sizeof(struct zchunk_cache));
+	if (!cache)
+		goto error;
+
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
@@ -1268,6 +1384,9 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 	int ret;
 	int fd;
 
+	if (handle->cpu_compressed && handle->read_zpage)
+		return read_zpage(handle, cpu, offset);
+
 	if (handle->read_page) {
 		map = malloc(handle->page_size);
 		if (!map)
@@ -1410,6 +1529,8 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 
 	if (handle->read_page)
 		free(page->map);
+	else if (handle->read_zpage)
+		free_zpage(cpu_data, page->map);
 	else
 		free_page_map(page->page_map);
 
@@ -3960,6 +4081,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
 
+#ifdef INMEMORY_DECOMPRESS
+	handle->read_zpage = 1;
+#endif
 	if (do_read_check(handle, buf, 3))
 		goto failed_read;
 
-- 
2.34.1

