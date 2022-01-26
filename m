Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F512C2BA4C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiAZJt2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239394AbiAZJt1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:27 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E420C061744
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:27 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id j23so63018208edp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JBdb5e7L81M74GB3+zfjxtato/V8elX6m35Lg3qgLOs=;
        b=a1bQeNUkhKS0mNLqACeQKAc3B7Pv8CTbt+nVlfXVGDSF4W9k2/tI9cWlkRdFg2rT+9
         6ZQZDqJ2QDmxJh9N7nf32utL9YwfJPm8KcIe8LgMr8OY+5JWf1SuqrbZLZLzBeo+iy+6
         Sk+VcIYAbFcoN16mUoOgGL6nB8DXI4LZtx4N0pMtoJ3DtcWOAuTemNc9DDsu3b/v8J+L
         /vsLniViiigL3/RzLFruJ7eujz1Al+r/9O/JJbFNv8NgYIfu4MuU+n3FkVBtM8q4bnnJ
         mGYpYyqzTS6E1HI6FexxnhUH0jUtMGHUKFViYVO0gb9MiNbi8yhrhFiMSZnz/iEmBxvz
         wG5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JBdb5e7L81M74GB3+zfjxtato/V8elX6m35Lg3qgLOs=;
        b=FZuIIddu04HWEUF2qrSFh6x4f9sK9i2Apg6TeagqHT7XhwdILje0LKIeeQf/d09l5j
         0fqfwzaj76wKisxQ9KJPJSdgbC7myqhSAgF2suablnOjjS+3RuTCD4wTtvjt94GT3Xq3
         zuhBOANTMx1h/ZHBhUJDUHeLr0UVJh8FVkRYzSQFhzsXwXdqaEJ7ZpIaEWniLLbpY1mP
         cfV9E5iHP7GQRtKc7Lg8CRgKT8tpiHUnslEhoOK8dq6Or6R7EDjlVFnmbDr2besFee70
         e3h+OCxLAYGTd/34GI3wbJwIyt0nLjGmzwZ7UTYUM3s+xfAYKLG+ozNayvf+vgFhFKRG
         m1/g==
X-Gm-Message-State: AOAM531JQw6o8rBuu7HQ4WO1jZ6CHML7IXv1iq1Nzv6+lEKvBVVOfZ0t
        Ozmf5xdMxB5AJkc2SMjNUlmqCpvLNlo=
X-Google-Smtp-Source: ABdhPJxFqBk3S49ilbXtYjPfWSGBPpk0b6f5fpBu4d27IPNq9gGaMhovouW2iRXKaDfVffn8Qk3skQ==
X-Received: by 2002:a50:fa95:: with SMTP id w21mr24110429edr.123.1643190565703;
        Wed, 26 Jan 2022 01:49:25 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:25 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 12/20] trace-cmd library: Extend the input handle with trace data decompression context
Date:   Wed, 26 Jan 2022 11:48:58 +0200
Message-Id: <20220126094906.570451-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The CPU trace data is compressed in chunks, as chunk's size is multiple
trace pages. The input handle is extended with the necessary
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
index 20cd6c32..a6d90c01 100644
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
@@ -3316,6 +3337,7 @@ static int init_cpu_data(struct tracecmd_input *handle)
 		endian = KBUFFER_ENDIAN_LITTLE;
 
 	for (cpu = 0; cpu < handle->cpus; cpu++) {
+		handle->cpu_data[cpu].compress.fd = -1;
 		handle->cpu_data[cpu].kbuf = kbuffer_alloc(long_size, endian);
 		if (!handle->cpu_data[cpu].kbuf)
 			goto out_free;
@@ -4100,6 +4122,7 @@ static inline void free_buffer(struct input_buffer_instance *buf)
  */
 void tracecmd_close(struct tracecmd_input *handle)
 {
+	struct zchunk_cache *cache;
 	struct file_section *del_sec;
 	int cpu;
 	int i;
@@ -4119,17 +4142,31 @@ void tracecmd_close(struct tracecmd_input *handle)
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
2.34.1

