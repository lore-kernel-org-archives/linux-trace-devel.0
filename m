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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B41C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68B28604DC
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbhINNSS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhINNSS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:18 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47F5C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:00 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id t18so20212550wrb.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IBSnXtLUWdnoAGzwCpkqt/zTiW5sZ5SNi9LgmB9E914=;
        b=GIBzkx5QO9D+zcdPWRmRCrdvQTZfba7TISnXOWVXeK0PFg1MkmU1Na5eExoPQ4sPD8
         ziyy3LEG9iWmjRjzveYOJaytH/1Mo6BZBsFyEX0t/2qPW5Xvt3y1daGaIb9IPIx8aueC
         RJuEPBkWDqZswxWYe3cWAK8lgMg1D+jImLNoKNgVr/pSVq4bTEa24ht6w3fqynBW52+2
         G9hceCeStkb9uiVgdCsRDWC88xb99Vij7yWxStcJZtTcHCghEnuewavMoauOm6qwQsCL
         2JJplvvxvKlZ1jK1aQ4GQs9nAtGG2m3lh4JO0cJfzKnq9RTAYmOcIGtL9fJiHxgCvRAl
         /ZeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IBSnXtLUWdnoAGzwCpkqt/zTiW5sZ5SNi9LgmB9E914=;
        b=uUB6vRICnMRIJY1SHAiLQveez+Fzh+8HGd8yPt5fLKyGvQqHwQT/hY/vlzNaXK6Dgb
         B59NgNw7aogmojeoIDp5ERG4Maf7En7C0bOUfI16rl8/tUwatewgKBSZzjgcE4P/6XoO
         5mXcfZcIB3fYuA6IiuuHcbTZFN6zfq9xd1FvSw3gE1GUZDEneKqL6tqVBej9KZJWVx7m
         rq/UZhlIJZtVsYYgUxtXtGmKrveHqDNb0vk6AZ7yINY542JwahIZywzXMhVcS/pZ3M2i
         BXvMdhpG0nwyLlWzt6OFmdcyuXuKsuJeq6Gx+zuvrjtCss/vcM3Kgy2uDtCfkEhtC4wd
         VqXA==
X-Gm-Message-State: AOAM531+mLpk2Us5Y7yqtl/eEiMDBJJ5ZtLAvmxrdAc7qKpi4bIF3TTf
        n1uuCSXPd3I4cSHPBlJxJXbhoquaM9U=
X-Google-Smtp-Source: ABdhPJyahCONK/pilp86o5df+FtrVLdeJ0XFs0QL/JCFna3BEO6AT/q3tDc6nLGEF+d2ERmHSn7woA==
X-Received: by 2002:a5d:554e:: with SMTP id g14mr19061293wrw.48.1631625419341;
        Tue, 14 Sep 2021 06:16:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:16:58 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 12/20] trace-cmd library: Extend the input handler with trace data decompression context
Date:   Tue, 14 Sep 2021 16:16:37 +0300
Message-Id: <20210914131645.3966308-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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
index d4728c86..658855a5 100644
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
@@ -150,6 +169,8 @@ struct tracecmd_input {
 	bool			use_trace_clock;
 	bool			read_page;
 	bool			use_pipe;
+	bool			read_zpage; /* uncompress pages in memory, do not use tmp files */
+	bool			cpu_compressed;
 	int			file_version;
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
@@ -3302,6 +3323,7 @@ static int init_cpu_data(struct tracecmd_input *handle)
 		endian = KBUFFER_ENDIAN_LITTLE;
 
 	for (cpu = 0; cpu < handle->cpus; cpu++) {
+		handle->cpu_data[cpu].compress.fd = -1;
 		handle->cpu_data[cpu].kbuf = kbuffer_alloc(long_size, endian);
 		if (!handle->cpu_data[cpu].kbuf)
 			goto out_free;
@@ -4043,6 +4065,7 @@ static inline void free_buffer(struct input_buffer_instance *buf)
  */
 void tracecmd_close(struct tracecmd_input *handle)
 {
+	struct zchunk_cache *cache;
 	struct file_section *del_sec;
 	int cpu;
 	int i;
@@ -4062,17 +4085,31 @@ void tracecmd_close(struct tracecmd_input *handle)
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
2.31.1

