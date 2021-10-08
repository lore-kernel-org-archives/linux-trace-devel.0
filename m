Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A705C43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1038161090
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbhJHEY3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237528AbhJHEY2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:28 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29BCC061765
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:32 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b8so31229227edk.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o+Fxm31SyfeqGreYI9kYGBHxACCNUlbbnZmJapszDTk=;
        b=E7sRB0xCD9yKtwPkCWQNH15CHXE9VD4wmp1tCh3x/lskhbpC4KISg6leCyjDw5uUYn
         3G2ZRUZnxvPMsPq8VrdtX0yQxVzONEVoGCI5eWA50lKjZYr/NNusYPfVGe5Bisa/hUiq
         Kz/2/ZSmJsn10/eqZIqlbjWCMAFGVMf+S0VdO8iP2wBr0FqW0/P+gJgztbga4d8wSIP4
         W8Ly21EV59sgGeh5r9znOmRkNy3H4rIXhHmiM4eaYui8pNrRfZJaFDTe1RfBG77nIM+9
         RT80ZMSKgrRPfgLrgDN5aA3cksxxnJtDDV1KQZguQAk4C9BcpGK2X5wMcjgTEGovYZhf
         FDAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o+Fxm31SyfeqGreYI9kYGBHxACCNUlbbnZmJapszDTk=;
        b=AlmSGLgXfAn0l0et5Nt4Rb8hPZcpdFQI14WNYcsRjD9euq+ED/0l4GG5uhx/sBPziM
         ZJpjulblrYsNT2ChfxHVfyM5l9IcFUuYWtQNidXniY+pOY9TVGl5rDco0wToln0JgLxG
         qBnScfSNrXQ/3JMYsebe+NoJ+1sLnWMdFPHzSjKbf0TAykiY5oWUP3rThIVnvMKIpuQJ
         kLOa3fEVZ6Xw11OxYyByGXO+6trxeD0ziaWt6ZHD9vaSkTjAesiV8MO07xH++S9Cx2//
         F5kWQ9q3AwKq/Ppb7fto5pIsea7cgDxHhu5PGbg7+RXEL+4+qnsXOYVEYpDlAqqq7LE7
         43HQ==
X-Gm-Message-State: AOAM532KYdlAg0c8h/1xRuxw9W9FM3Uxb1bYfF8hetUoPu8YOK6N4hoe
        PzvbpmtR/zkb///59xzGZGDij/x4f3045A==
X-Google-Smtp-Source: ABdhPJw/cwo9eJquMfbRNwEYMXTTg8Nr/dh8oFgu3Sz7gR0Br0LyQFPKZA1WvGx+X27pEvH+bio4pg==
X-Received: by 2002:a17:906:1e43:: with SMTP id i3mr1251510ejj.313.1633666951510;
        Thu, 07 Oct 2021 21:22:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 14/20] trace-cmd library: Add logic for in-memory decompression
Date:   Fri,  8 Oct 2021 07:22:08 +0300
Message-Id: <20211008042214.977193-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
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
index 91114483..5b9ff041 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -29,6 +29,9 @@
 
 #define COMMIT_MASK ((1 << 27) - 1)
 
+/* force uncompressing in memory */
+#define INMEMORY_DECOMPRESS
+
 /* for debugging read instead of mmap */
 static int force_read = 0;
 
@@ -1249,6 +1252,105 @@ static void free_page_map(struct page_map *page_map)
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
@@ -1260,6 +1362,9 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 	int ret;
 	int fd;
 
+	if (handle->cpu_compressed && handle->read_zpage)
+		return read_zpage(handle, cpu, offset);
+
 	if (handle->read_page) {
 		map = malloc(handle->page_size);
 		if (!map)
@@ -1402,6 +1507,8 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 
 	if (handle->read_page)
 		free(page->map);
+	else if (handle->read_zpage)
+		free_zpage(cpu_data, page->map);
 	else
 		free_page_map(page->page_map);
 
@@ -3890,6 +3997,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
 
+#ifdef INMEMORY_DECOMPRESS
+	handle->read_zpage = 1;
+#endif
 	if (do_read_check(handle, buf, 3))
 		goto failed_read;
 
-- 
2.31.1

