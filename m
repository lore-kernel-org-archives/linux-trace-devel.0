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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39516C47094
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2479B61406
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhFJLiB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:38:01 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:54864 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhFJLiB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:38:01 -0400
Received: by mail-wm1-f45.google.com with SMTP id m3so742716wms.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=05lK6z1tRPoWI6LsDB6q2WoJqm7gnqhaRWTmXEeBIrg=;
        b=NDtVgA+s+EOTt+QwBvTH6dupeY2FOV4ddHnWPJXdh9o6PlKjP5uzdAVGNyxyt/hyxO
         BoaybKt2je6/2zF7HkqIzAamuY+1Ka/KDLKTHy6mQcLcGhuZ6DAubBVn/QAi+jJcFMAC
         v+Kt80UWLwynx9bWPgnmQRDDNKqsjc3ocsmhU0pAAvtdoL+lHxXzsq+6MOQZnUm99FzC
         hUV77ikAjEapfhjagSnt7FiGJKJ3xm0gLw9x/sy+QGVV6LXy3CJzM4mtiZaoktowjrdT
         N2auaBXGt247t0jJQElAHx4Q4Ukg2qgNjSgTl0w7+wuF4X68xC+MSKrobS2uiY2EDYdR
         JLsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=05lK6z1tRPoWI6LsDB6q2WoJqm7gnqhaRWTmXEeBIrg=;
        b=J738UoCX1cDnxdODyOHgeM+q5CrzkKUrr+mRgqfkVH0lAFsK6TlTplNJBpJ6Q8zrJK
         Ii+sPhxPtHrMg0qE0SWFvpOwj0h7dOFcG0CkIkZJSZ4ekhr51dbUwBJvve9Gq5dRQAbT
         VTHwAWp4rpJ8LniMviqLn8wJyqIs1hkzsnFItFhSIA6hRkDFZyw4jcEb8BysyCk96pzT
         2sC36lvT+/owCLLl/LtzST0Pjfv8fFdwmPCxovXC/7nMw3tcwi1wYFnjgu7arKWyN1H+
         qX+RmJoXM1Mqkg59D7YhqQh2XGrZOKUAr22Gho5xtQbOV3rh4xgPqpc552xAn/7Az4gr
         PgvQ==
X-Gm-Message-State: AOAM5329voj43v4IokzT1Z2hJzvZXqlKuKoFB7IdSNx30CikEYJt4n/+
        wz+hVo+G7VtkD9ubJaUUSrhd2DU0SLvkVw==
X-Google-Smtp-Source: ABdhPJyz5YTymm6widXM0pZ8gD7O1PjV92qJDA6gT/nDHgIEUNWbmonu+dmECpWZajTMQ+6YTTu+Ug==
X-Received: by 2002:a05:600c:4b88:: with SMTP id e8mr4485261wmp.107.1623324891754;
        Thu, 10 Jun 2021 04:34:51 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 25/40] trace-cmd: Read compressed trace data
Date:   Thu, 10 Jun 2021 14:34:11 +0300
Message-Id: <20210610113426.257931-26-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
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
index 8fff003e..327082a2 100644
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
+	if (handle->file_version >= 7 && cpu_data->file_size > 0) {
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
 
@@ -3635,17 +3673,23 @@ void tracecmd_close(struct tracecmd_input *handle)
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
index 0cf6e773..d605d05a 100644
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
 
@@ -1924,6 +1931,7 @@ void trace_report (int argc, char **argv)
 	/* and version overrides uname! */
 	if (show_version)
 		otype = OUTPUT_VERSION_ONLY;
+
 	read_data_info(&handle_list, otype, global, align_ts);
 
 	list_for_each_entry(handles, &handle_list, list) {
-- 
2.31.1

