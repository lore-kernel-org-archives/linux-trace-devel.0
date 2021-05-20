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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE573C43461
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B80C3611AD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhETDVv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhETDVv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:51 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF827C06175F
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:30 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id lg14so22930681ejb.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KAi7sMVpNBuzvhj06aaJOwX5EJDMkuTTmz1SyghfmaA=;
        b=PNSqlTcdnaI8z1ZiVO/NVPKlVdE7Z0vDYcWH3ibrVh4gtc6sQQhxMqEyOWCHSo3VyU
         +sOxNgmg9SbO0/XZ4JvJv0N8No4WnfbLfy7ACJTYw+tWiHgt4DNloIiL+wTuzXncXCzk
         5w8BWKsh61DOH/+u/ZowNt5LQGrM8UhNyFzs6FRrdh7K643KU7/6+NkAm7fSdCcuqX3T
         iC2CR9ejzXy83Wm1T98lStl/0SlXF2yBQh6VGgWjVL//0n7YVvf7pdCT7q6K0XmTt0WN
         Frj8M7yfhaSdlMaOZ6B1xBT3qfRjRWWl+MGHX5iwEsKsxYnxctJcRDq/5ZldqJLL/Cua
         YC2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KAi7sMVpNBuzvhj06aaJOwX5EJDMkuTTmz1SyghfmaA=;
        b=fJPG7dlW5DCyAMZXQJTODT95p/7EaR/fBspRSma+B1N0CXXB0wkNBILuOgJMpIe6uh
         /cLDKXI1UOuM/vNBFZ15JZtGmxlqCvE1iMbsRSxz7Nf1IpLlivVnd4hobEjGaar7xlNk
         Lc+BLnU+MmoJTGNNQmgv6M1pvKo0HK9R7POhcMaTUbDqFQzNsAIz1ZRwqmopMz6khZu5
         YhsEwWhv8PN1MJNqzwsFJFqmOT39sCsRfndW3JCXiY+Leu37um6QD30NnF06d/p0vwJf
         XNrhgiLkHsVg5+2DiMUsGcgV9yvEQp5epcAPRINYgV96sCozflmhmIlPIDVAqAQ06FB8
         doWA==
X-Gm-Message-State: AOAM5334bWwFpFOgqjvNUQOMnhqntxfDJYK+JFhW/uN/oR0nF6LJ9drm
        zvU/3SkJDul+0jKTR3p4U/8=
X-Google-Smtp-Source: ABdhPJySnYZPnFPYOZMc//vL49CqB9lmsioCEbz9fnP7ou5obyCrG4/jA3aUQze0j1Ogda3cVpPAHw==
X-Received: by 2002:a17:906:fc0d:: with SMTP id ov13mr2407996ejb.504.1621480829412;
        Wed, 19 May 2021 20:20:29 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 25/29] trace-cmd: Read compressed trace data
Date:   Thu, 20 May 2021 06:19:55 +0300
Message-Id: <20210520031959.346165-26-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c | 75 +++++++++++++++++++++++++++++--------
 tracecmd/trace-read.c       |  8 ++++
 2 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f94ceab4..c2b64ea9 100644
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
@@ -2316,13 +2325,42 @@ tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record)
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
+	/* When creating a pipe, file_size is set to -1 to indicate no data in the file */
+	if (handle->file_version >= 7 && cpu_data->file_size != -1) {
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
@@ -3015,6 +3053,7 @@ static int read_cpu_data(struct tracecmd_input *handle)
 
 		handle->cpu_data[cpu].file_offset = offset;
 		handle->cpu_data[cpu].file_size = size;
+		handle->cpu_data[cpu].cfd = -1;
 		if (size > max_size)
 			max_size = size;
 
@@ -3635,17 +3674,23 @@ void tracecmd_close(struct tracecmd_input *handle)
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

