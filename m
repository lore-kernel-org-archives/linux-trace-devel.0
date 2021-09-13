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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4806FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 347A160FF2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbhIMMng (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240006AbhIMMnf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:43:35 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0327C061766
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:18 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 196-20020a1c04cd000000b002fa489ffe1fso6851418wme.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GwTARa2VtynWMrU0jrXWmNwlc0ut56tBqfgsJMIxJ6Q=;
        b=K9EtPfnFXCEoMvsbihJRVCLCyogIFuhOGeWtnYp8qhWuL9xVpiV7mLZk15+N4Eb3Hd
         Hxn97i4RCrF43Ruw4QRbUiKr9PW2eUox52KNARbrvFTc3kjL7//4pS/VilHtPrWddW7e
         XQL4GU93B0r6DB5bFDWpFk4KNz0o3SuObEJDLp7aIagrqiuAx0zxAndKz20AK1fSnSFr
         oH4flmEZFhn5YBPQad7Y3WOw2C1dT/yBMx387/HwmUFDgV63xj1FKRyThs0x2w+l8aSN
         +vSibp/TZUa36/2gkRShHhrGF67udK9hxcJbc9WSEdpWk9s5ItHfN8ef9swtAOobcsgG
         xOEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GwTARa2VtynWMrU0jrXWmNwlc0ut56tBqfgsJMIxJ6Q=;
        b=0Tu7+jUpKBli3tdM6erBb3pG8N0hRWk+khDv5toZdUDq088TwnjhK+J6cKeLdilAnr
         IVvZDfwNbcUdx7LFHZ4YUcT/NAiMrbRNQKF/fTy8UDMA6L3fEK4Ofq7ixyZQ1aBb2vi7
         s/1FsByUKONcrICv0T5CgyxlCVHasHqJBsZcfa0WOw6O4E/hj91GLsqbjwtiSZnG1i7f
         yRG6yoevXeDZblF7Jf11zB8exABYTcHZl9Kul0OV8XxkKebO/RSranBZVab3ukV6pi8u
         dGA0TBILy0S02NhIte6nLiumvEFlkyY1BzIiKXWpr8HdhYtCmXs/2jKBnZ6Zo5XvMoFs
         NfPw==
X-Gm-Message-State: AOAM533YiLpGdKvRUoTLzdjhbo3eH+WYSs1jYtRT+bd8+yKqXihwvmiq
        kx+On90eU623tpm7zqXICq4PsSGj+0Y=
X-Google-Smtp-Source: ABdhPJxmgVoKD1FhDOv3oEMDqegwkDvNNrhnxzdZi/dFkfd6f7/Al24AspNs5z9FANTrj3FnW11sDw==
X-Received: by 2002:a1c:f00a:: with SMTP id a10mr10685882wmb.112.1631536937514;
        Mon, 13 Sep 2021 05:42:17 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u13sm7244290wrt.41.2021.09.13.05.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:42:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 14/20] trace-cmd library: Add logic for in-memory decompression
Date:   Mon, 13 Sep 2021 15:41:57 +0300
Message-Id: <20210913124203.3677760-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
References: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
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
index 8d1e1c28..fab8b9ba 100644
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
 
@@ -3900,6 +4007,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
 
+#ifdef INMEMORY_DECOMPRESS
+	handle->read_zpage = 1;
+#endif
 	if (do_read_check(handle, buf, 3))
 		goto failed_read;
 
-- 
2.31.1

