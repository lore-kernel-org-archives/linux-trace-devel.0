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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D018C43460
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3754561628
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhELGkF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhELGkE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:40:04 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CB5C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:50 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id di13so25714068edb.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9p3HZ+fV114HUtuCsEoFxcTzF+q4DNlNLh6cTUwrBE0=;
        b=tF0aI57xN7PJ0PBmguLDhVvbJwSBq9ezYmLRLLl3j0t7K5thEuQegRTmaTTkI+GPhM
         l0RfPGv6J+zyBKlkrTRQqZy0U5wM5bgr5P0xIFTMnCfQycyCepXIoQ4DNtJbpw+na9QT
         Jfbf9Peh4QsuiVy02SrCxKI4LZS5bFFCOD3KwZRdOVKgFYplqA3k8/5dfUvEMdj1HOMD
         ByDV7GIx6FuSf52I/hQTESxq9KwsclPqMeR0gOnf2Iv2g0k43NETQdTmmyzXPCBVdIbh
         lvk0is6oeUVDUd0ALU+niR82MIulWimOdXDavZTIrxeO5CBNMcBdMsY3ErXlLDvHBwFp
         MpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9p3HZ+fV114HUtuCsEoFxcTzF+q4DNlNLh6cTUwrBE0=;
        b=Aiv+bZQst/NIr5U7/lVsuYspGBCIcRKXhxHMGzDV8SupMuKwOVHZZPP9CVN6CXqGZt
         BWQfDyKpg8f9Ou4k0XL7JaebJqllAN1J4N/7BEMXjTdNVv6sMbOQ2WhPqlGrybR9+9yZ
         q0BtjNEtU4DHTa01Bq+sQzqGOsMj6NEIfOa36qIPbMffm+c7opxiRNNUmwICLKZqr7Lw
         3lI3FCsIoT24DSVSoGiITqLdXV1CFZjODjF4+KBnvqNnYb7+XvuUU2wqJiQYqoa2dQiH
         0NP68qGD5ZfAUGTQTVTt7yoTyLi2ijQa6ZPBfKUtw4kxmmo5rsDFXLtVk54HNE6Lkw/x
         Mivw==
X-Gm-Message-State: AOAM531oR9nlBSaZS3I448QlVur5/qCyml+NC7QGwrQc7LZqyGv4ZHF1
        2CAYoAz/8XKaSuR2VYcrl1lkXBCYfxzfbg==
X-Google-Smtp-Source: ABdhPJwVM8CzIOwtqftv/fiMUNMzAXks644NWHTqVdAiaO9UjplSGa33+7uUX/2vt3yp86O0dY0sHg==
X-Received: by 2002:aa7:cb48:: with SMTP id w8mr41165362edt.55.1620801528888;
        Tue, 11 May 2021 23:38:48 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:48 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 25/25] trace-cmd: Read compressed trace data
Date:   Wed, 12 May 2021 09:38:23 +0300
Message-Id: <20210512063823.324610-26-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading a trace.dat file of version 7, uncompress the trace data.
The trace data for each CPU is uncompressed in a temporary file, located
in /tmp directory with prefix "trace_cpu_data".

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 74 +++++++++++++++++++++++++++++--------
 tracecmd/trace-read.c       |  8 ++++
 2 files changed, 67 insertions(+), 15 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 1cec6917..e7fd0d30 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -54,6 +54,7 @@ struct page {
 #endif
 };
 
+#define COMPR_TEMP_FILE "/tmp/trace_cpu_dataXXXXXX"
 struct cpu_data {
 	/* the first two never change */
 	unsigned long long	file_offset;
@@ -72,6 +73,10 @@ struct cpu_data {
 	int			page_cnt;
 	int			cpu;
 	int			pipe_fd;
+
+	/* temporary file for uncompressed cpu data */
+	int			cfd;
+	char			cfile[26]; /* strlen(COMPR_TEMP_FILE) */
 };
 
 struct input_buffer_instance {
@@ -1080,6 +1085,7 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 	off64_t map_offset;
 	void *map;
 	int ret;
+	int fd;
 
 	if (handle->read_page) {
 		map = malloc(handle->page_size);
@@ -1119,12 +1125,15 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 		map_size -= map_offset + map_size -
 			(cpu_data->file_offset + cpu_data->file_size);
 
+	if (cpu_data->cfd >= 0)
+		fd = cpu_data->cfd;
+	else
+		fd = handle->fd;
  again:
 	page_map->size = map_size;
 	page_map->offset = map_offset;
 
-	page_map->map = mmap(NULL, map_size, PROT_READ, MAP_PRIVATE,
-			 handle->fd, map_offset);
+	page_map->map = mmap(NULL, map_size, PROT_READ, MAP_PRIVATE, fd, map_offset);
 
 	if (page_map->map == MAP_FAILED) {
 		/* Try a smaller map */
@@ -2316,13 +2325,41 @@ tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record)
 	/* Not reached */
 }
 
+static int cpu_data_uncompress(struct tracecmd_input *handle, int cpu, unsigned long long *size)
+{
+	struct cpu_data *cpu_data;
+
+	cpu_data = &handle->cpu_data[cpu];
+	strcpy(cpu_data->cfile, COMPR_TEMP_FILE);
+	cpu_data->cfd = mkstemp(cpu_data->cfile);
+	if (cpu_data->cfd < 0)
+		return -1;
+	return tracecmd_uncompress_copy_to(handle->compress, cpu_data->cfd, NULL, size);
+}
+
 static int init_cpu(struct tracecmd_input *handle, int cpu)
 {
 	struct cpu_data *cpu_data = &handle->cpu_data[cpu];
+	unsigned long long size;
+	off64_t offset;
 	int i;
 
-	cpu_data->offset = cpu_data->file_offset;
-	cpu_data->size = cpu_data->file_size;
+	if (handle->file_version >= 7) {
+		offset = lseek64(handle->fd, 0, SEEK_CUR);
+		if (lseek64(handle->fd, cpu_data->file_offset, SEEK_SET) == (off_t)-1)
+			return -1;
+		if (cpu_data_uncompress(handle, cpu, &size) < 0)
+			return -1;
+		cpu_data->offset = 0;
+		cpu_data->file_offset = 0;
+		cpu_data->file_size = size;
+		cpu_data->size = size;
+		if (lseek64(handle->fd, offset, SEEK_SET) == (off_t)-1)
+			return -1;
+	} else {
+		cpu_data->offset = cpu_data->file_offset;
+		cpu_data->size = cpu_data->file_size;
+	}
 	cpu_data->timestamp = 0;
 
 	list_head_init(&cpu_data->page_maps);
@@ -3015,6 +3052,7 @@ static int read_cpu_data(struct tracecmd_input *handle)
 
 		handle->cpu_data[cpu].file_offset = offset;
 		handle->cpu_data[cpu].file_size = size;
+		handle->cpu_data[cpu].cfd = -1;
 		if (size > max_size)
 			max_size = size;
 
@@ -3637,17 +3675,23 @@ void tracecmd_close(struct tracecmd_input *handle)
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
+			if (handle->cpu_data[cpu].cfd >= 0) {
+				close(handle->cpu_data[cpu].cfd);
+				unlink(handle->cpu_data[cpu].cfile);
+			}
 		}
 	}
 
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index b315283e..e7a4f196 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1363,7 +1363,14 @@ struct tracecmd_input *read_trace_header(const char *file, int flags)
 
 static void sig_end(int sig)
 {
+	struct handle_list *handles;
+
 	fprintf(stderr, "trace-cmd: Received SIGINT\n");
+
+	list_for_each_entry(handles, &handle_list, list) {
+		tracecmd_close(handles->handle);
+	}
+
 	exit(0);
 }
 
@@ -1922,6 +1929,7 @@ void trace_report (int argc, char **argv)
 	/* and version overrides uname! */
 	if (show_version)
 		otype = OUTPUT_VERSION_ONLY;
+
 	read_data_info(&handle_list, otype, global, align_ts);
 
 	list_for_each_entry(handles, &handle_list, list) {
-- 
2.31.1

