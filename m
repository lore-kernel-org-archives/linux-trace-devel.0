Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9203C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhLBM2p (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbhLBM2p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:45 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922C2C061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:22 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id w1so115508612edc.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mcqzKScOqZrmTyjH5Sw2H7H39vZqIREw7NGGP7Qnf4o=;
        b=FjfeVgi6xG/Iswhv1QkhLdpGlEnBfnwN+ZXwZzjkVxPkm4V3zk/RS8UEL2mykPcO/N
         nsBZyEj6fM3Rgxko834g6yrusmhpTdQI9C58FLTwEa3ce2zw8VvxLefFYNtq3QhU0RYv
         8qg5HchS6fKR15lTWEnG+IidhAeXok6652ctmHA0W8SuXNIoMu5AZ+UCwIR0Q1Ll+hVH
         lS5jxaN3SLgsJQXJsPOf6ggMZXX01Bhj9LaFkLbCxKJ6jAFnms1G2Xrk/yX1S3/X/BKB
         0wUq7IV99oN1f6jRinFjkq0JE5EhNKJzDKHuGklIlP2CjYA2Jm6OuVKurStmThmCCaiu
         4Rgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mcqzKScOqZrmTyjH5Sw2H7H39vZqIREw7NGGP7Qnf4o=;
        b=1IIxgpXCoj58FQlvSIwJiX9V4UMqd01edKCz3zomF3KcU15/xDgM3VoMZFJ4d1g6lM
         eJqUEVqSrtBqS4GkcCJZblgusO6z85I4S6wRhRiRYTHBwPFApg45893Zo4Kb915PAHua
         EirbwMzL2MDAdSZTYDHUbKuD3Zfxsvyi+3qrFYwBLvEItNNVfaOqPMmSOJAwWCFgANJy
         Ugg/b2uJno8r/UfAcKwd19rXbUDgYe6TFWR7xRrJUhgO29BRAB85Ub0EEt5C1Tz+L4j4
         xFrGEqs0VNG6eZMEbztWVdjHHA4r9F6MHQaVpjsxKQaQJk5pJbK1s71CV0NjhjluJ1wa
         jcLQ==
X-Gm-Message-State: AOAM533owuTiXz9Vj1UNI4kv0p74xm7neZWnfLrx1IUcjDzD9EMUPk3j
        +94q3QKI5ePxedE2XTN1DG44uYk2f32+8Q==
X-Google-Smtp-Source: ABdhPJyV71LgJ96LeHkknyO4etcL0lFwhDX3DlJZCO47VQh+Bl9h5wAWTqYjlZ5VvnGRyPDkUIsA0g==
X-Received: by 2002:a17:907:60cf:: with SMTP id hv15mr14344023ejc.561.1638447921174;
        Thu, 02 Dec 2021 04:25:21 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:20 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 13/20] trace-cmd library: Initialize CPU data decompression logic
Date:   Thu,  2 Dec 2021 14:25:00 +0200
Message-Id: <20211202122507.43572-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On CPU data initialization stage, initialize decompression context for
both in-memory and temporary file decompression logics.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 72 +++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index bfe9d333..7bbd5485 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1259,6 +1259,7 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 	off64_t map_offset;
 	void *map;
 	int ret;
+	int fd;
 
 	if (handle->read_page) {
 		map = malloc(handle->page_size);
@@ -1298,12 +1299,15 @@ static void *allocate_page_map(struct tracecmd_input *handle,
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
@@ -2491,16 +2495,76 @@ tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record)
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
+	strcpy(cpu_data->compress.file, COMPR_TEMP_FILE);
+	cpu_data->compress.fd = mkstemp(cpu_data->compress.file);
+	if (cpu_data->compress.fd < 0)
+		return -1;
+	if (tracecmd_uncompress_copy_to(handle->compress, cpu_data->compress.fd, NULL, &size))
+		return -1;
+	if (lseek64(handle->fd, offset, SEEK_SET) == (off_t)-1)
+		return -1;
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
@@ -3372,6 +3436,8 @@ static int init_buffer_cpu_data(struct tracecmd_input *handle, struct input_buff
 		return -1;
 	if (read_section_header(handle, &id, &flags, NULL, NULL))
 		return -1;
+	if (flags & TRACECMD_SEC_FL_COMPRESS)
+		handle->cpu_compressed = true;
 	if (buffer->latency) {
 		handle->file_state = TRACECMD_FILE_CPU_LATENCY;
 		return init_latency_data(handle) == 0 ? 1 : -1;
-- 
2.33.1

