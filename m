Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8931BC63682
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239392AbiAZJt3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239390AbiAZJt2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:28 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A1FC06174E
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:28 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id o12so37688042eju.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5VJP3/usVNah9d7A31vctDNOUws8inzymD6P1CBV3og=;
        b=k2rkWovc/V4CnDBqzyugg19TIG8FKZj9HaDyOzVsEWErdtukeFT3srl6gJ6VT4UIxi
         ZWxE+1/jYfBUXBk1jQae7WOLU7C3laq61uNNpMEibnCcdIiCjRGWCkSTbVMyYoT3R0d0
         x1sA2BHEsS/4tbncBjeTLTm5K2OFV6QhwO+WNYkdaBIqSfDA5GLdVzhUB23UxNDqNAR/
         d8lbci/vV1vwnxSNzsqvf4+4Jtmqqp9gPmtJOSw+TjTee3fjzjGJlH7badByly82Z6H/
         ekAgmZk3kYxQSqApXZiwtsB7lAABN+LSGqtswDCEfRV8AZrfNL1YF2BlwTRPx3MzRjcO
         47xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5VJP3/usVNah9d7A31vctDNOUws8inzymD6P1CBV3og=;
        b=RAar9rIH+s1P6EVawAHOU4VZilj0SrLPeUhqPIuLAHRnUr+7yGimhA5GM+iguDK7Ia
         PME9tkrxgZOVTJzOtSbYNjElpZrk8FMbw/wBmhcSdwfzS1tCT5cMoAyn6H8WToIB/K4I
         6aGAZ+N9LphHxFjzoSqDYQm8DbS0162dp/d15l1Lsspcxbis7hWuMfqpjxlUJML3Pjj5
         bcGs2IvthKNsKfKMcv/AgPKIb+vc1yRt3fLMnl7tSaTryNOBks64y+9jrgDHemWcDHtr
         27StFYTudtWCGWG8AvMnUKpG4lzQ1GVgAJeqZWGc8Sqzm0PNxLSIjAsZNjedPX3W9R22
         Fmgg==
X-Gm-Message-State: AOAM531Q1DSZAcB2E674c+85K01jsjVXuQcAviOECykiQ0Cx43P6pe3X
        hfwmATEx/upXqgz2imwPQv+JwftUYMo=
X-Google-Smtp-Source: ABdhPJw06TOpq7cpT5vlSxQipULqeKMOd2QTu62YCmRKPKsbZjOXuaPEemP2YF81LR+7kNHFJomT2Q==
X-Received: by 2002:a17:906:35cd:: with SMTP id p13mr16702326ejb.353.1643190566793;
        Wed, 26 Jan 2022 01:49:26 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:26 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 13/20] trace-cmd library: Initialize CPU data decompression logic
Date:   Wed, 26 Jan 2022 11:48:59 +0200
Message-Id: <20220126094906.570451-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On CPU data initialization stage, initialize decompression context for
both in-memory and temporary file decompression logics.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 77 +++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index a6d90c01..192f6596 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1266,6 +1266,7 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 	off64_t map_offset;
 	void *map;
 	int ret;
+	int fd;
 
 	if (handle->read_page) {
 		map = malloc(handle->page_size);
@@ -1305,12 +1306,15 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 		map_size -= map_offset + map_size -
 			(cpu_data->file_offset + cpu_data->file_size);
 
+	if (cpu_data->compress.fd >= 0)
+		fd = cpu_data->compress.fd;
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
@@ -2498,16 +2502,81 @@ tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record)
 	/* Not reached */
 }
 
-static int init_cpu(struct tracecmd_input *handle, int cpu)
+static int init_cpu_zfile(struct tracecmd_input *handle, int cpu)
+{
+	struct cpu_data *cpu_data;
+	unsigned long long size;
+	off64_t offset;
+
+	cpu_data = &handle->cpu_data[cpu];
+	offset = lseek64(handle->fd, 0, SEEK_CUR);
+	if (lseek64(handle->fd, cpu_data->file_offset, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	strcpy(cpu_data->compress.file, COMPR_TEMP_FILE);
+	cpu_data->compress.fd = mkstemp(cpu_data->compress.file);
+	if (cpu_data->compress.fd < 0)
+		return -1;
+
+	if (tracecmd_uncompress_copy_to(handle->compress, cpu_data->compress.fd, NULL, &size))
+		return -1;
+
+	if (lseek64(handle->fd, offset, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	cpu_data->offset = 0;
+	cpu_data->file_offset = 0;
+	cpu_data->file_size = size;
+	cpu_data->size = size;
+	return 0;
+}
+
+static int init_cpu_zpage(struct tracecmd_input *handle, int cpu)
 {
 	struct cpu_data *cpu_data = &handle->cpu_data[cpu];
+	int count;
 	int i;
 
+	if (lseek64(handle->fd, cpu_data->file_offset, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	count = tracecmd_load_chunks_info(handle->compress, &cpu_data->compress.chunks);
+	if (count < 0)
+		return -1;
+
+	cpu_data->compress.count = count;
+	cpu_data->compress.last_chunk = 0;
+
+	cpu_data->file_offset = 0;
+	cpu_data->file_size = 0;
+	for (i = 0; i < count; i++)
+		cpu_data->file_size += cpu_data->compress.chunks[i].size;
 	cpu_data->offset = cpu_data->file_offset;
 	cpu_data->size = cpu_data->file_size;
+	return 0;
+}
+
+static int init_cpu(struct tracecmd_input *handle, int cpu)
+{
+	struct cpu_data *cpu_data = &handle->cpu_data[cpu];
+	int ret;
+	int i;
+
+	if (handle->cpu_compressed && cpu_data->file_size > 0) {
+		if (handle->read_zpage)
+			ret = init_cpu_zpage(handle, cpu);
+		else
+			ret = init_cpu_zfile(handle, cpu);
+		if (ret)
+			return ret;
+	} else {
+		cpu_data->offset = cpu_data->file_offset;
+		cpu_data->size = cpu_data->file_size;
+	}
 	cpu_data->timestamp = 0;
 
 	list_head_init(&cpu_data->page_maps);
+	list_head_init(&cpu_data->compress.cache);
 
 	if (!cpu_data->size) {
 		printf("CPU %d is empty\n", cpu);
@@ -3394,6 +3463,8 @@ static int init_buffer_cpu_data(struct tracecmd_input *handle, struct input_buff
 		return -1;
 	if (read_section_header(handle, &id, &flags, NULL, NULL))
 		return -1;
+	if (flags & TRACECMD_SEC_FL_COMPRESS)
+		handle->cpu_compressed = true;
 	if (buffer->latency) {
 		handle->file_state = TRACECMD_FILE_CPU_LATENCY;
 		return init_latency_data(handle) == 0 ? 1 : -1;
-- 
2.34.1

