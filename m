Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1FBC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhLBM2o (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbhLBM2o (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:44 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB3BC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:21 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id v1so115095360edx.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H5r0DvR30Am7AFkraurPbx/cosS3KErdUZfOYM7PGzo=;
        b=MkRthLYFZOfaU6pyS4s6n8933RWLgLRvxBOlC5Er3k8+MLb01IUK9dMCOAFE0IU47j
         xC5E8JNg7nJypJZeKvIeQN4ErAqVpm+Jzs3EXoZimHWMKnaoaw6XcQFUs4zQjg1KjdBs
         +ly+FCZc2eHHU+1tbYiVfJ9fH+HkcHnCfOvB68F/wyQ1HObuj4TWcOXadF32qM7SYW19
         OpZ+pVUl3MTihuvTdSxLD14XB2Y+7rCLXFOzItOVdb55cqjFxGoqR1CF54bDR7ieTDfq
         ZVAWLCuZWsNPWPLisv261TPOH/ib/s7KddhkCbH/GK542ULBsp7RWg4ZbJL+qpHp30/e
         iN8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H5r0DvR30Am7AFkraurPbx/cosS3KErdUZfOYM7PGzo=;
        b=N+NAnnK900Y5tMDSxZ9zrmXTM/fMPs6UfDpqbcBKRDrUHYPWSKooMaiYFX5X8Zqzmn
         jGLnJEektggVtrrw8UJ/UMiz/2OyIsSK+Y6uV0MkxI7kqGUr/Df6H3MuXfUO4FlEZd0+
         fDwBs5r/AQwgyVp8l4duW5St0HCu9Yci1mGh57Q7OnLhfgai8qisnZ3DUn5hShcZiVGs
         kicyZfMmtNRnHnW9Re23TPAdRbiTuLpi2uKAhEWmpqBTmnU/nVnbCD4yYprj3DLOnrnp
         G5ekcrMOuTSAkxC83NDnzdNWhgdlFFCKI3j+WQRfVNO7TgMF5gxqI/Uat483/6GHYrgi
         wcGw==
X-Gm-Message-State: AOAM532vQK1K+ACLRMhL9w2zSmQ6yJGzJzHsbujwC3gaBdJCX/IwfpiU
        iV4HRrC+VDeKxu2fcY2dbsddBGzRhtbyIg==
X-Google-Smtp-Source: ABdhPJxPOGG14xb5W5Ns/V3doozJ/c6PIU+xorB4Sgw3VdORgaE1ZFgUIaKeLRiPU0XxA/ZhuCu7NQ==
X-Received: by 2002:a17:906:388c:: with SMTP id q12mr14715076ejd.281.1638447920059;
        Thu, 02 Dec 2021 04:25:20 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:19 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 12/20] trace-cmd library: Extend the input handler with trace data decompression context
Date:   Thu,  2 Dec 2021 14:24:59 +0200
Message-Id: <20211202122507.43572-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The CPU trace data is compressed in chunks, as chunk's size is multiple
trace pages. The input handler is extended with the necessary
structures, to control the data decompression. There are two approaches
for data decompression, both are supported and can be used in different
use cases:
 - in-memory decompression, page by page.
 - using a temporary file

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 59 ++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 11 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 3d67fb97..bfe9d333 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -54,6 +54,24 @@ struct page {
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
@@ -72,6 +90,7 @@ struct cpu_data {
 	int			page_cnt;
 	int			cpu;
 	int			pipe_fd;
+	struct cpu_zdata	compress;
 };
 
 struct cpu_file_data {
@@ -151,6 +170,8 @@ struct tracecmd_input {
 	bool			use_trace_clock;
 	bool			read_page;
 	bool			use_pipe;
+	bool			read_zpage; /* uncompress pages in memory, do not use tmp files */
+	bool			cpu_compressed;
 	int			file_version;
 	unsigned int		cpustats_size;
 	struct cpu_data 	*cpu_data;
@@ -3294,6 +3315,7 @@ static int init_cpu_data(struct tracecmd_input *handle)
 		endian = KBUFFER_ENDIAN_LITTLE;
 
 	for (cpu = 0; cpu < handle->cpus; cpu++) {
+		handle->cpu_data[cpu].compress.fd = -1;
 		handle->cpu_data[cpu].kbuf = kbuffer_alloc(long_size, endian);
 		if (!handle->cpu_data[cpu].kbuf)
 			goto out_free;
@@ -4030,6 +4052,7 @@ static inline void free_buffer(struct input_buffer_instance *buf)
  */
 void tracecmd_close(struct tracecmd_input *handle)
 {
+	struct zchunk_cache *cache;
 	struct file_section *del_sec;
 	int cpu;
 	int i;
@@ -4049,17 +4072,31 @@ void tracecmd_close(struct tracecmd_input *handle)
 		/* The tracecmd_peek_data may have cached a record */
 		free_next(handle, cpu);
 		free_page(handle, cpu);
-		if (handle->cpu_data && handle->cpu_data[cpu].kbuf) {
-			kbuffer_free(handle->cpu_data[cpu].kbuf);
-			if (handle->cpu_data[cpu].page_map)
-				free_page_map(handle->cpu_data[cpu].page_map);
-
-			if (handle->cpu_data[cpu].page_cnt)
-				tracecmd_warning("%d pages still allocated on cpu %d%s",
-						 handle->cpu_data[cpu].page_cnt, cpu,
-						 show_records(handle->cpu_data[cpu].pages,
-							      handle->cpu_data[cpu].nr_pages));
-			free(handle->cpu_data[cpu].pages);
+		if (handle->cpu_data) {
+			if (handle->cpu_data[cpu].kbuf) {
+				kbuffer_free(handle->cpu_data[cpu].kbuf);
+				if (handle->cpu_data[cpu].page_map)
+					free_page_map(handle->cpu_data[cpu].page_map);
+
+				if (handle->cpu_data[cpu].page_cnt)
+					tracecmd_warning("%d pages still allocated on cpu %d%s",
+							 handle->cpu_data[cpu].page_cnt, cpu,
+							 show_records(handle->cpu_data[cpu].pages,
+								      handle->cpu_data[cpu].nr_pages));
+				free(handle->cpu_data[cpu].pages);
+			}
+			if (handle->cpu_data[cpu].compress.fd >= 0) {
+				close(handle->cpu_data[cpu].compress.fd);
+				unlink(handle->cpu_data[cpu].compress.file);
+			}
+			while (!list_empty(&handle->cpu_data[cpu].compress.cache)) {
+				cache = container_of(handle->cpu_data[cpu].compress.cache.next,
+						     struct zchunk_cache, list);
+				list_del(&cache->list);
+				free(cache->map);
+				free(cache);
+			}
+			free(handle->cpu_data[cpu].compress.chunks);
 		}
 	}
 
-- 
2.33.1

