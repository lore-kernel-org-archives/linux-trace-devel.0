Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14763C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352463AbiASI1c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352447AbiASI1a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:30 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38470C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:30 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id 30so7635917edv.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OIi8QagZLh+y9dxAxkuYy9YD6d/O1jpJL+cICmJBoEE=;
        b=iWqzMGJAoJpQR7Evs8rDMftvS5U07zEred8aynCqyFSG4syb2hc3tNwCf/wKNIcCtn
         eRaNpZksM5e76dAvonIp9ueWnpi5sBH4hoWNBXPPUMpIu1MtH4feGT4Kvjd7UU9YJ1g2
         MU/xfjQG5pbzPxUG/z97ZhW9MPmWpib7TduGHnvUkXMDX25YQL5fkrXlzmMqKiglPGN5
         UQaFhaQfk4xGekEjBJUbDJUzDDAKq0VJEc8TYTXbwMoJLUtNRbj8+lgMH2uBti+cpdsr
         CkKAPOSUR9Z6fFsLcfyFk1I4sUs+JXkkTbA9J9SMxMtXwfgMDxdiPAX6c/hsgPaYtc73
         iOOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OIi8QagZLh+y9dxAxkuYy9YD6d/O1jpJL+cICmJBoEE=;
        b=pc5PlPOBgzW7v1vNW8js0AGrcD+Yy8mvhWAViPvGNmK0TgO0awP0E7ZbiobOTtIUAQ
         V5BlmX7YRwbx69TuElESR2HP3KDtPO4yqQk9d9ZSOLBvOWj80RHLLc9NUikihX2rcw4o
         auhyIxT7Ge2b4TWx9Dg4tI4moMbLLlFlZ/J+we9MGQ5JpkUXXY0C3ItHRQXPOzMdy+lb
         Qxm8/GTaRYfEj4rMsu0u8THGtTcUa3a6mtqvglaSA6gniOzxlaJgN/XR7IZXgFsTAEkl
         B3PRyflxs3slPVmEAHU8gnuWCKvkngbAr+7MVl1zoDwz4gdx9rCnCXIaA+oD8MkdMY00
         s2Dw==
X-Gm-Message-State: AOAM531wSjAMXbwtC83te7vZhsTD/6Vmhq9iWTjmeYUM5CQfTMgdoA3J
        JrvoYRmpmGLIo0z3E+zdpfxF7MzUgOU=
X-Google-Smtp-Source: ABdhPJz+gq32/IihVV2hBUR3in2pHpMSJ+uBRkWJ29STAVR/G7OP2XTsfAY5hl2/TCplTDTjhjGmBg==
X-Received: by 2002:a17:907:3e8b:: with SMTP id hs11mr23554410ejc.461.1642580848851;
        Wed, 19 Jan 2022 00:27:28 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 12/20] trace-cmd library: Extend the input handler with trace data decompression context
Date:   Wed, 19 Jan 2022 10:27:07 +0200
Message-Id: <20220119082715.245846-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
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
index ac3234f4..65b8111a 100644
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
@@ -3315,6 +3336,7 @@ static int init_cpu_data(struct tracecmd_input *handle)
 		endian = KBUFFER_ENDIAN_LITTLE;
 
 	for (cpu = 0; cpu < handle->cpus; cpu++) {
+		handle->cpu_data[cpu].compress.fd = -1;
 		handle->cpu_data[cpu].kbuf = kbuffer_alloc(long_size, endian);
 		if (!handle->cpu_data[cpu].kbuf)
 			goto out_free;
@@ -4096,6 +4118,7 @@ static inline void free_buffer(struct input_buffer_instance *buf)
  */
 void tracecmd_close(struct tracecmd_input *handle)
 {
+	struct zchunk_cache *cache;
 	struct file_section *del_sec;
 	int cpu;
 	int i;
@@ -4115,17 +4138,31 @@ void tracecmd_close(struct tracecmd_input *handle)
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

