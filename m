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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF782C432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99AC96101B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbhG1Nds (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236698AbhG1Nds (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:48 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFB9C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:46 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id x14so3197266edr.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o2TB83B1BZYWZzgI8hSwE2wVWE560gYHieRfBK/r4P4=;
        b=u4SclUP/Yar+GB1Le5wWGLMwkL8feSCWRG/2i388s6R0S8pMbjxY6tH21GC3jggiYb
         xqkMV2M1tNzD0GfSUUcglk+Q2gSBKdm4Nls4PmDfw1AI9WhVochFJJqDKFMgxscC4k9S
         8Cmtxnu5qRdBbLggySwOHM/UizIdby+O3j0blkmo9igWkTNMlp0aBoAPGiJvSiI+NnqG
         /FdjBngKKG8iIpp1mbsTiYbDRcTGtERsnAPFmCyaoLgwS+ksiiI0ClsNNfL/xxYbfZ62
         n97oGCIcoQQg/JDasgtaA5KnHHPKuivJq9vBgGt5V1yV00JSnPMb0a+wRAUvemU+aSLb
         Z/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o2TB83B1BZYWZzgI8hSwE2wVWE560gYHieRfBK/r4P4=;
        b=XCpERZ0Dh8zDFbmXRRLKFOlxeiHlXugx5Mqyzts4ACwgHykmM9L4iqTIqsPujwYn9v
         Ep/9fTs9ZB3p+UsoR06O7Buom4R0EHd46xsCT+bWufpfZi6Pmi+SUsitZh0JJ3Ybb5xJ
         GwILdFgI/hf6dCpW6tOpowLWc4C8UotiWqQp/yQwPJ5IE4HrSsSnpLw/MNfEL9kpFJ87
         SA+QNYYBHhF6to31hipaFoqePMneHAoj+mDYwsT5J/6VpNQokkaj+rmEHvJXbB2L/97/
         Pi5NmR1uC+RKrLhKwjalqFidq0RgO23tcjYaodOlETfUHAfvOSqGsDMYWjxV+6tupxLj
         2yLQ==
X-Gm-Message-State: AOAM532NZ+/WA2G5INIdXpfMIBprERRRHbIFT9aS04Vjq1woYo6YNgPz
        qpo4JFyawt7+fGGJwMh/se5gMl5NriYlZw==
X-Google-Smtp-Source: ABdhPJymfd9NJUQZ9MTFr0uFGHEdickaD4VqwpozSOk7BD8UUHtsa2l3qzWY6w7T2cNANhbQhtDn2g==
X-Received: by 2002:a50:af85:: with SMTP id h5mr10914245edd.27.1627479224907;
        Wed, 28 Jul 2021 06:33:44 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:44 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 52/87] trace-cmd library: Initialize CPU data decompression logic
Date:   Wed, 28 Jul 2021 16:32:15 +0300
Message-Id: <20210728133250.234140-53-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On CPU data initialization stage, initialize decompression context for
both in-memory and temporary file decompression logics.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 70 +++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f872e850..5c5046f9 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1276,6 +1276,7 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 	off64_t map_offset;
 	void *map;
 	int ret;
+	int fd;
 
 	if (handle->read_page) {
 		map = malloc(handle->page_size);
@@ -1315,12 +1316,15 @@ static void *allocate_page_map(struct tracecmd_input *handle,
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
@@ -2512,16 +2516,76 @@ tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record)
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
-- 
2.31.1

