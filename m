Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C08BC433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75A9E610CE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhINNSV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhINNSU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:20 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF61C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:03 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id d21so12469641wra.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y3/WTAvwdoRnVjxeqxmfI6+6BiqDEX3drwjk1TFdTIo=;
        b=F/aS1eu5uz4gHQ5tRR1iGBgVVrwjHhvxHC2ZFgjmStNrbKJ4wdYt84k5HyFuPChxGo
         YFPCRLmkufxkSTmSX50TkSB2VITlrr7SFu4NczPtVT9g8JIfDYrPhEjFI30dEEiGxeHc
         iWS8tfGw4e9Fpkc5Ic5DsFEPTNN2q5eCEumwStKvHhWeEHMxkPamJ9zrprCMvnocfv34
         zdLqPl8W3WXh/0zJlSYAW6Deg63/HcBPoYmQjPETHjuJTUSEp7SpKHYz64hGZ3bWwRRz
         COkpWtCwXUpvO5tVC8wUh+lveBoJ3KLwf710VhBLt6TMJZwewbCbb3UzrtFSZCN4mX1W
         tnJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y3/WTAvwdoRnVjxeqxmfI6+6BiqDEX3drwjk1TFdTIo=;
        b=DAPhaDnqzr1AcR8xjrFNv34D0/hE5sgAwj12a6CxiOWH9knIez4HouLHEe9D4nJ5zp
         OPXC6IHVr1BwsEYzltpSvlqaQkUfn5MM2zq2o7x8ffrPjuwR2PWub33TOHVwD/pF4GwK
         Td/hLnuWneQRWnWDGkJJ6GhkW1UhPplMUpy9Fpgrj8egTOOxsvwusm8m13ETbcubEq66
         yTszrroNxKwYDHN4AMUiks0QWd3F3m8YXrE4GDNL+4OMF8z7a4REDYr+1lkR/m4BLx9J
         VK0CVgyOm9r+e7Sf4ZmzpzZjUcwq4lO6nqCqJJB3tSNS7YrpSFtMGcYJ9WCUpx+7rky3
         AvZw==
X-Gm-Message-State: AOAM530iVVgxyeIzDDPqONOp+9rhrr2sV9CWZvjDQhBHtHBBAG+NAmmG
        bwxxW6WTzafm1wGL8aCgBdOSYgHslSk=
X-Google-Smtp-Source: ABdhPJw5R6BY0t2XIaXGiuR/dtyACAs3qZjLLXkkTWdB+dNAYj+3u2WJK07XMmYQYpp4MN2ThxjGwQ==
X-Received: by 2002:a5d:6750:: with SMTP id l16mr18697268wrw.174.1631625421752;
        Tue, 14 Sep 2021 06:17:01 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:17:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 14/20] trace-cmd library: Add logic for in-memory decompression
Date:   Tue, 14 Sep 2021 16:16:39 +0300
Message-Id: <20210914131645.3966308-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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
index 0fd1a451..040fb391 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -29,6 +29,9 @@
 
 #define COMMIT_MASK ((1 << 27) - 1)
 
+/* force uncompressing in memory */
+#define INMEMORY_DECOMPRESS
+
 /* for debugging read instead of mmap */
 static int force_read = 0;
 
@@ -1257,6 +1260,105 @@ static void free_page_map(struct page_map *page_map)
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
@@ -1268,6 +1370,9 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 	int ret;
 	int fd;
 
+	if (handle->cpu_compressed && handle->read_zpage)
+		return read_zpage(handle, cpu, offset);
+
 	if (handle->read_page) {
 		map = malloc(handle->page_size);
 		if (!map)
@@ -1410,6 +1515,8 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 
 	if (handle->read_page)
 		free(page->map);
+	else if (handle->read_zpage)
+		free_zpage(cpu_data, page->map);
 	else
 		free_page_map(page->page_map);
 
@@ -3902,6 +4009,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
 
+#ifdef INMEMORY_DECOMPRESS
+	handle->read_zpage = 1;
+#endif
 	if (do_read_check(handle, buf, 3))
 		goto failed_read;
 
-- 
2.31.1

