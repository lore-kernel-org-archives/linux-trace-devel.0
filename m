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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B28C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E072610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhINNST (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhINNST (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:19 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C76BC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:02 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id s24so9228270wmh.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+kcfbV8tKqZo1OCdmsj/KRe6lM3F32WAwHEZnU5jWKA=;
        b=F75rZj8JBNkKEQgbx3O7Ae9w2cT249yayKNd+ZGCT6AZAFPDGp5n5whlM3Qr/IPmsg
         LkV2yIG9/Ns3rbaC/syrZ/yQah8ngWlt2jJML23TgYGG/Pq2I5gd7EluxVpeai+J/qGt
         bAY2B2GsIqYjfMe4Gy65N4ZF9dmagKl+u+pEjdNG3E4OTHsK5uWbQEWvDJKmOAPL6/j1
         wYheprLgmiZAwtYYas2ptRjf8sAFjz7Tx2gbpdpC3gMX0RLupOnoaCIXksaVFU5I2MJC
         UksbYZxwg1OUzFQ5LQIUZUEHEYWgYfQj3ITiX9fHKb2tzxWtoqsRo4jQwI8rqhvKTEbp
         0PXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+kcfbV8tKqZo1OCdmsj/KRe6lM3F32WAwHEZnU5jWKA=;
        b=CPOf26m3bzTJgov0GTLy9Yy4jNDQkgj6c/wM3RP6w/Jh3aJLKqUSJ38TZqmSapWZ/1
         cNCqKo3fjwsKyu4MsBIYsFaV66hBWMUr3ik24IzuaigjZka1x+AGgl378hhH+XCGIQG8
         abZ++Iwj/6+28iQZfZejus23K658M2vt1h3x4CH/er2QcQ0ybqTl/StTYP7xOPsFBa2v
         wTmo0u9X0rSmdtHk4p7mbWLiq8xT+wCFDYdxnGAOB/Erm+miEVfinqblQq9drkDHM/dP
         qr6ZCcsGkWkvD8dfhibaSVJPWqd0LImuqxp1duIMe29PzlkDwSNX8GAHb3hsOIYaWOiC
         NqHg==
X-Gm-Message-State: AOAM533mnahPMgiNQfRsRvdIbWJ6Lzr0HWNOy9W3485k+J53doRQO+LI
        sM3W6slf2aaDEJB7Es51JhffVi8x43w=
X-Google-Smtp-Source: ABdhPJzdgTEonL2Jv1xo/+GsGyXQrBgBi9ALTrqnHVn2X4rCshobwoF0eUvghO43dKJfpWFNjAYLyg==
X-Received: by 2002:a7b:c8c3:: with SMTP id f3mr2212031wml.30.1631625420609;
        Tue, 14 Sep 2021 06:17:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:17:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 13/20] trace-cmd library: Initialize CPU data decompression logic
Date:   Tue, 14 Sep 2021 16:16:38 +0300
Message-Id: <20210914131645.3966308-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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
index 658855a5..0fd1a451 100644
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
@@ -2502,16 +2506,76 @@ tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record)
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
@@ -3380,6 +3444,8 @@ static int init_buffer_cpu_data(struct tracecmd_input *handle, struct input_buff
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

