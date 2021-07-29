Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C9CC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD6496023E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbhG2FLB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbhG2FK6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:58 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D243C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:55 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id x11so7517464ejj.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JLRedXoW1NUWdO6nkQxVEPJu6H/0wYkRPiho+e2/F3o=;
        b=klAJS06sDGmF0tcoMvYjKRhL3e0yHAq06DOwllGWQlVomig14K2tLJtO/kw2pkgQQU
         1f1aQZWPFpIMv8OCa3EUpsWGmA1snQ4F/XBDhy9te+U2UZpkhxIoYYcnTYsBlHxnyYQ6
         SBj574xAjEDq3Lqf9reN0tREdnTuK+IlF2oOl/bfbUWnQKQdDg9/N9u7fkd4jhQ6Y6Zt
         NFZGVBZ8NDQAuoDqaIsl6P/OqXI114gV/43qB6nkukFgoKhTtpwRRDzJ0HG3OjxNSRxM
         XN7qtpLuoUW/KvSArWS5TE/DwFEpmtxwLjK2l/IQSBX5ApOwJm9fqWYEQqZMoKZHi75G
         L8kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JLRedXoW1NUWdO6nkQxVEPJu6H/0wYkRPiho+e2/F3o=;
        b=fo/hpc89j9yW0JoyWh/FWIJ07WhydpB6L8urMmatoDCUTVb3E7YN84Ak1SfeyiLjlM
         +giGvslAT2mnkuP1Q3g0eGdkLgDznLX9ygCLGcSUHOqRGZiN+kvRuMSkQFH/Ljmv/Yqq
         fjXBKW83rPL2GopS4zvM0rvD/1XvQEdz95csS+nLj2X21yDEZizR4JYayQynB52Qiy2/
         oyCJJmmq01POaN3+2gd4OVKb8XOh3lsvqiYH+X8A47oaO+1HKtIsXTtRDIQ4GbTqjEn5
         kYMvsqJzvHHWkZ6ZVHh8cT5cqSKjp5j64++V6uyHdFcgHadumTar3ezpM2h5pNdQ4rf7
         bdyw==
X-Gm-Message-State: AOAM532Q6a9HWEg+wer3r8aoFsTm5GzufBE7EqJKOb+wBRNYL3QqAYT+
        C6q5HEOw8LRPKtsa1BTkH3w=
X-Google-Smtp-Source: ABdhPJwkd05fqxwVaEb0i0KyjgUzuPqyW5CU6ZcviFovWNYFoc7uhnRMVR5W/V4wE/FQvmB9pZF1eQ==
X-Received: by 2002:a17:907:c08:: with SMTP id ga8mr2925883ejc.318.1627535453740;
        Wed, 28 Jul 2021 22:10:53 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:53 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 54/87] trace-cmd library: Add logic for in-memory decompression
Date:   Thu, 29 Jul 2021 08:09:26 +0300
Message-Id: <20210729050959.12263-55-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c | 104 ++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 3b58cb0a..4582b9bc 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1266,6 +1266,105 @@ static void free_page_map(struct page_map *page_map)
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
@@ -1277,6 +1376,9 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 	int ret;
 	int fd;
 
+	if (handle->cpu_compressed && handle->read_zpage)
+		return read_zpage(handle, cpu, offset);
+
 	if (handle->read_page) {
 		map = malloc(handle->page_size);
 		if (!map)
@@ -1419,6 +1521,8 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 
 	if (handle->read_page)
 		free(page->map);
+	else if (handle->read_zpage)
+		free_zpage(cpu_data, page->map);
 	else
 		free_page_map(page->page_map);
 
-- 
2.31.1

