Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 035C0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1DA56044F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbhKKPPB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbhKKPPA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:00 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC58C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:11 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id v11so25479627edc.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y1gQJSSWIHQEZDOOQU4vx9BZINk/a3FDLCxMqa9nJ88=;
        b=cVAEMf1JFezohykmZ2jNrklBuGm4faU0mh6/EGj/8UfSLiwCPQNhAtUzZh2aCeHac5
         C1V4GEQ2l1ZAzI0kawGmTeDNzpdMkTnKME/hpUf9RMPAQLAmY3EB0aYA7/NefmnOQQya
         Sma66kvWCrPVFLLFmKMuei6G50F3gc1j6p3YDcsCatGyBCVOPjXomTAUf+RxG/cYD8hF
         t9vktqpxRhkjJhRy+MkZzYvAi9htrCaQs3HSfr2dq7iJLCtW2+kLdFKlmTy9ZgEhrOOI
         DeUv5TmVE4DsuYCDGbJqyrOAHrNKBMDLj07tCik93m+fwgvTC+OiwttYaoSojyk+4Vg9
         OKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y1gQJSSWIHQEZDOOQU4vx9BZINk/a3FDLCxMqa9nJ88=;
        b=mTlniie7oVvu58N8n9T503kiSos0FS3LFMS0xzkjPuzw9/Sj7E4LJceGAq+X3bAJA0
         nc1erjBN89jAK7ifIi3ph67+abNbbmPEShDm4SsL1iyYOaw8Bqg4P9SqmYuwRFa8J32s
         3x2KfIUUSZbLHFnW6sGVBZzHlXJpOuvEdPDkfz0AomoPBX2cGvm67dPs45GmDSGGk9OE
         Pw0VQcmTmNyHDYbuk071TrxJW9EjKBRLz3Oi5COI5VbCR/VhrQcrx2wEG78zLqIvTeQ/
         xzasP35QF41K0q6FNIX3EkIH0/Z6Q+cchoYwBJyiWiDHvzZ4MePwvnrMxiKZfMaXRFBs
         u5VQ==
X-Gm-Message-State: AOAM533ms0y0g94khhpiTO8AR2KEGKEyIANt7mMCDTkWr6NuEkMcM6rw
        G8PlKn0qJNx5pxDiaEtsUzaP6bw5BtVj4w==
X-Google-Smtp-Source: ABdhPJw7NBP7RCZij5w1A9J52C90rpxC1tPcEaFe2FjwVB4z28MVEciluS1LYjrkw7Khh+Ls/ab/ow==
X-Received: by 2002:a17:907:6e1c:: with SMTP id sd28mr10452437ejc.28.1636643530025;
        Thu, 11 Nov 2021 07:12:10 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qf9sm1479509ejc.18.2021.11.11.07.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 13/20] trace-cmd library: Initialize CPU data decompression logic
Date:   Thu, 11 Nov 2021 17:11:46 +0200
Message-Id: <20211111151153.86855-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151153.86855-1-tz.stoyanov@gmail.com>
References: <20211111151153.86855-1-tz.stoyanov@gmail.com>
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
index f46feac5..84895051 100644
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

