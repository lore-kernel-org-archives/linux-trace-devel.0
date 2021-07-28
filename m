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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE83C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56E8960FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236699AbhG1Nds (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236694AbhG1Ndr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:47 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD0DC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:45 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id h8so3258373ede.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6ZX5cI7y8BTJWBsSrBzkn/77Bi9zURBxIy2fFS4vjNU=;
        b=MgmpiJQXM2HlAwEaUgf/QJGJBPuoyPcE7Ubjjf7UuKxh87anVoXz4PUezB8csXmqJz
         VfIhO8sXMBdllQffF4jp4/eYNsmZMTo9QhF+BWZwohn5uEYz+yrE3ZDGnEvvpsG8ROaq
         0g/rVBnVmfNGm3lAftgBlCDotg39YoD9orhmmSQYuTWK4Pf/E0zSR3J9fGuPs9Pamuhb
         J0lFvQ1fXsnCXFvZF+eysYfJiFmSx8veQ975kr0Lj/c7L4FetcohGNjtgt/69xlxmqnG
         BGx8qIAx+ATqjp7GM5hTPqZNesxtfeDb65LmDZl3UvT9S4V6tGork+S//AYpGltdboLI
         Q7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6ZX5cI7y8BTJWBsSrBzkn/77Bi9zURBxIy2fFS4vjNU=;
        b=QMGhmLPDABqOSgZtfBLJldljcQM7AuL0wiTJGKF0xLDreTtM8HNE/0GFbu2nYYIcPr
         OtdZzeKSx2DmsfNlgxoVPtshqdC6x/KjhaI2L+fbV9VMued9CLhq5gMrh9+uYVw8LwFa
         ZGTcHSST7cOqeYEFgYlqIzl/XOQcsHqQofRdnlhe5Kz2NdUVUE+4rtrdPY3ruDzc2kNu
         ogUNJO4gD8SIsAlM2amijL/mJ83WsxapaCqAEzISYQmyJ0VUUXy+NJ0Iu5zyfg0BSZRR
         GZx2iF6rs0LT0zXn/GpbzgWGOa6HR30L6FTH+Sx7RgPfvwxOMpswXDTNTsq2p2UpdJkV
         H2HQ==
X-Gm-Message-State: AOAM5304huQ+l1GSpr6/U5f22yforHGHXQpymmPxOwKdL+EP6gonf/5/
        41xrEe3jFwhMbiwq5qbENlPh04+J1OkMvw==
X-Google-Smtp-Source: ABdhPJwt3BR1mwqdM6yzcJA3J9n/XwDqJHREU8agjYCQvgbewKPTda054+LIf38EsOfZK1pbvZEEVg==
X-Received: by 2002:a05:6402:b19:: with SMTP id bm25mr17013868edb.213.1627479223863;
        Wed, 28 Jul 2021 06:33:43 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:43 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 51/87] trace-cmd library: Extend the input handler with trace data decompression context
Date:   Wed, 28 Jul 2021 16:32:14 +0300
Message-Id: <20210728133250.234140-52-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The CPU tarce data is compressed in chunks, as chunk's size is multiple
trace pages. The input handler is extended with the necessary
structures, to control the data decompression. There are two approaches
for data decompression, both are supported and can be used in different
use cases:
 - in-memory decompression, page by page.
 - using a temporary file

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 66 ++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 12 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 5ee0adcf..f872e850 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -29,6 +29,9 @@
 
 #define COMMIT_MASK ((1 << 27) - 1)
 
+/* force uncompressing in memory */
+#define INMEMORY_DECOMPRESS
+
 /* for debugging read instead of mmap */
 static int force_read = 0;
 
@@ -54,6 +57,24 @@ struct page {
 #endif
 };
 
+struct zchunk_cache {
+	struct list_head		list;
+	struct tracecmd_compress_chunk *chunk;
+	void				*map;
+	int				ref;
+};
+
+struct cpu_zdata {
+	/* uncompressed cpu data */
+	int			fd;
+	char			file[26]; /* strlen(COMPR_TEMP_FILE) */
+	unsigned int		count;
+	unsigned int		last_chunk;
+	struct list_head	cache;
+	struct tracecmd_compress_chunk	*chunks;
+};
+
+#define COMPR_TEMP_FILE "/tmp/trace_cpu_dataXXXXXX"
 struct cpu_data {
 	/* the first two never change */
 	unsigned long long	file_offset;
@@ -72,6 +93,7 @@ struct cpu_data {
 	int			page_cnt;
 	int			cpu;
 	int			pipe_fd;
+	struct cpu_zdata	compress;
 };
 
 struct cpu_file_data {
@@ -150,6 +172,8 @@ struct tracecmd_input {
 	bool			use_trace_clock;
 	bool			read_page;
 	bool			use_pipe;
+	bool			read_zpage; /* uncompress pages in memory, do not use tmp files */
+	bool			cpu_compressed;
 	int			file_version;
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
@@ -3284,7 +3308,7 @@ static int read_cpu_data(struct tracecmd_input *handle)
 		unsigned long long offset;
 
 		handle->cpu_data[cpu].cpu = cpu;
-
+		handle->cpu_data[cpu].compress.fd = -1;
 		handle->cpu_data[cpu].kbuf = kbuffer_alloc(long_size, endian);
 		if (!handle->cpu_data[cpu].kbuf)
 			goto out_free;
@@ -3701,6 +3725,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
 
+#ifdef INMEMORY_DECOMPRESS
+	handle->read_zpage = 1;
+#endif
 	if (do_read_check(handle, buf, 3))
 		goto failed_read;
 
@@ -3915,6 +3942,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
  */
 void tracecmd_close(struct tracecmd_input *handle)
 {
+	struct zchunk_cache *cache;
 	struct file_section *del_sec;
 	int i;
 
@@ -3933,17 +3961,31 @@ void tracecmd_close(struct tracecmd_input *handle)
 		/* The tracecmd_peek_data may have cached a record */
 		free_next(handle, i);
 		free_page(handle, i);
-		if (handle->cpu_data && handle->cpu_data[i].kbuf) {
-			kbuffer_free(handle->cpu_data[i].kbuf);
-			if (handle->cpu_data[i].page_map)
-				free_page_map(handle->cpu_data[i].page_map);
-
-			if (handle->cpu_data[i].page_cnt)
-				tracecmd_warning("%d pages still allocated on cpu %d%s",
-						 handle->cpu_data[i].page_cnt, i,
-						 show_records(handle->cpu_data[i].pages,
-							      handle->cpu_data[i].nr_pages));
-			free(handle->cpu_data[i].pages);
+		if (handle->cpu_data) {
+			if (handle->cpu_data[i].kbuf) {
+				kbuffer_free(handle->cpu_data[i].kbuf);
+				if (handle->cpu_data[i].page_map)
+					free_page_map(handle->cpu_data[i].page_map);
+
+				if (handle->cpu_data[i].page_cnt)
+					tracecmd_warning("%d pages still allocated on cpu %d%s",
+							 handle->cpu_data[i].page_cnt, i,
+							 show_records(handle->cpu_data[i].pages,
+								      handle->cpu_data[i].nr_pages));
+				free(handle->cpu_data[i].pages);
+			}
+			if (handle->cpu_data[i].compress.fd >= 0) {
+				close(handle->cpu_data[i].compress.fd);
+				unlink(handle->cpu_data[i].compress.file);
+			}
+			while (!list_empty(&handle->cpu_data[i].compress.cache)) {
+				cache = container_of(handle->cpu_data[i].compress.cache.next,
+						     struct zchunk_cache, list);
+				list_del(&cache->list);
+				free(cache->map);
+				free(cache);
+			}
+			free(handle->cpu_data[i].compress.chunks);
 		}
 	}
 
-- 
2.31.1

