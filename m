Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A917C43217
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 519A2610CE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237528AbhJHEYa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237506AbhJHEY2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:28 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28C6C061764
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:31 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id d3so3894102edp.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nmuDKwjQ0gmZrGZMOUsAsxupVw+MyW0hRiiylwgfjwc=;
        b=FgQZY30TSpOOEve+JUIVOKsJVKfRGoYanswPeWNCjzUZJExGxWCgeewd9i8OAtmdJd
         ssNE0GgUVahewxoG4TGgOSmmNiwN+U+myP5eQNeYVT44W3dgglo7lbhrgzQ6YqQPnlRM
         sTkRz28G3iu1VDZ7eQjZ4uzHPyNVySq1TlCQDrZGg6Nzscbg2E/ZQYsLXoozYLCBWgyM
         XWrEHTyIhTmDyk7rdDXOVFfpnJsTUnzZgyz7ZXYaG3jwhryXiAZaNfNKyroJkoCOo5b3
         ToObdqqKeYouuIP3psxrzHveFYTIGMD6zbNgJTV45Kkdj1MN2nz/MqvH1ewolIRHsp/D
         llyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nmuDKwjQ0gmZrGZMOUsAsxupVw+MyW0hRiiylwgfjwc=;
        b=5ZJYCMr3bgWzYjR3XG2947ykmvbpE5Mo1G+YoYqhjw3pmDDvSa+IP0TXzgvJ2Ku3Li
         l6r4aPzYqwbT5jKr+KeFz4TuBpRGTA27AR3tgqvrUjLJbB/9RTUG0+yJvdlJ1+KXlSgo
         TyU2MGZXvonVUSxaEwzYghayvvLrs7FKCQCT8LjjIDQVxJ/bA65ROTIm+p0it2aBraX5
         hiOgrN0noWGSXbwe+YHdpsQmUu1+I97NdwPki3MkoAW0ku6nxJZJAG64RNL4xZyfRW3u
         HpsbPAnodLqzHK2NrjQAMWqa6KmQ5Lpg+eJKrf1KhdcClE8dWVRSt9NbV1jvQ+r/ntW3
         HBVg==
X-Gm-Message-State: AOAM533ZkyJTFMst+c2cMIFyXudbJPA8dfGt8vffPsxM0Ni5Rz0B3ReM
        PMzm09AyXmIvACoS793VWYrmop/jWejmlA==
X-Google-Smtp-Source: ABdhPJxqkiAlTZwrXiaBUifHQT3hPDX4D8OfvdYAGZHnGL/Z3fNtwJekBwwvMP+lekAqJEQ18Zml1A==
X-Received: by 2002:a17:906:1146:: with SMTP id i6mr1341550eja.12.1633666950266;
        Thu, 07 Oct 2021 21:22:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 13/20] trace-cmd library: Initialize CPU data decompression logic
Date:   Fri,  8 Oct 2021 07:22:07 +0300
Message-Id: <20211008042214.977193-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
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
index 05245b01..91114483 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1258,6 +1258,7 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 	off64_t map_offset;
 	void *map;
 	int ret;
+	int fd;
 
 	if (handle->read_page) {
 		map = malloc(handle->page_size);
@@ -1297,12 +1298,15 @@ static void *allocate_page_map(struct tracecmd_input *handle,
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
@@ -2494,16 +2498,76 @@ tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record)
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
@@ -3373,6 +3437,8 @@ static int init_buffer_cpu_data(struct tracecmd_input *handle, struct input_buff
 		return -1;
 	if (read_section_header(handle, &id, &flags, NULL, NULL))
 		return -1;
+	if (flags & TRACECMD_SEC_FL_COMPRESS)
+		handle->cpu_compressed = true;
 	if (buffer->latency) {
 		handle->file_state = TRACECMD_FILE_CPU_LATENCY;
 		return init_latency_data(handle) == 0 ? 1 : -1;
-- 
2.31.1

