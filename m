Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E26C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E808610D1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhJHEY3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237483AbhJHEY1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:27 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96124C061762
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:30 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id a25so15480526edx.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+HttJMT1mBdtCkRnWh8CR8m3YCUIELsyTpMeyuTgX+Q=;
        b=bX5cOo5YDt82Y/86a/5IFGKKYHrrfc2Kp7aRF2oIJe/9OQT2uhSFxQPyXhJA60cAfD
         mXq3oA6qMOk9PsY7YmE9zI8czlSmGCcfkUECttzfz6YAbJvooEZIRb7zmePKq7WA/DXs
         O07rFU8j/7FBQ1blQy+l9TStoZURsLaeeyim+DeSuxXidhf3VjoOJjdV+a2ehxlRlHVn
         ZX+OW4BQ0e89KstWu4aLpVkSMwajmGciebLVhDabISAZtul5ZzHsnoAd/hiRwEDArKdZ
         HfXMLMyfccgZsj7QsrZEfjUz54uCMGhtVAl8ZXg8LbB5lYithC+fDEcE7U/W8VdXs7wn
         VTqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+HttJMT1mBdtCkRnWh8CR8m3YCUIELsyTpMeyuTgX+Q=;
        b=GfpsCoPy/SXnEOXpM59HCdM2Xp2UjB/2JdlktB3/o7kmSApkg3yW0b6qqk3ciMD8S8
         qP0Iy8xnRxK7SPtb2lr9DMOYy6zuia5u6nXllBfr/Sr0KKF9D1JTEv8rLbXs25F/VDMl
         diJrAodvJ+4itCgKwVvOkP2rKFgTgOsyn+3lRpwqG1hWS98XCI3bGjbmoqdF/Q+JZkNw
         GjpqZHax5xbHUTPJTA4JcqY6F/uw7cJrb2UqDL58mepE2vE3oH1s4gFsY0rErf8vD8KD
         7NHBaPAJ1PAaB8Sz8e9KzJzYyIBNzhMXCUWwDWp5fCvVbY3j43bno10D74KGmrctc+6o
         +Zrg==
X-Gm-Message-State: AOAM532MS6wbuaOrQ4R7KaP2dPb9QXxPHDSjm0YTOGr3+GDT4LFYVy5I
        wuhGdX683U3AOiTk+BrB3TMkKFhAdIKxmQ==
X-Google-Smtp-Source: ABdhPJwvBJeP/op/wBC0Q0Eme9J+ntz8wZwek4QDsOBi15ORVWh/jUZF5SqPFk/M4l1569/uKfHwBQ==
X-Received: by 2002:a17:906:af49:: with SMTP id ly9mr1246647ejb.479.1633666949135;
        Thu, 07 Oct 2021 21:22:29 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 12/20] trace-cmd library: Extend the input handler with trace data decompression context
Date:   Fri,  8 Oct 2021 07:22:06 +0300
Message-Id: <20211008042214.977193-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
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
index 5bab81c7..05245b01 100644
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
 	unsigned int		cpustats_size;
 	struct cpu_data 	*cpu_data;
@@ -3295,6 +3316,7 @@ static int init_cpu_data(struct tracecmd_input *handle)
 		endian = KBUFFER_ENDIAN_LITTLE;
 
 	for (cpu = 0; cpu < handle->cpus; cpu++) {
+		handle->cpu_data[cpu].compress.fd = -1;
 		handle->cpu_data[cpu].kbuf = kbuffer_alloc(long_size, endian);
 		if (!handle->cpu_data[cpu].kbuf)
 			goto out_free;
@@ -4031,6 +4053,7 @@ static inline void free_buffer(struct input_buffer_instance *buf)
  */
 void tracecmd_close(struct tracecmd_input *handle)
 {
+	struct zchunk_cache *cache;
 	struct file_section *del_sec;
 	int cpu;
 	int i;
@@ -4050,17 +4073,31 @@ void tracecmd_close(struct tracecmd_input *handle)
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

