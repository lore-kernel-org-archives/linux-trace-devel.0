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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B1CC4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31FFA60EB2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbhG2FLB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbhG2FK6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:58 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114A5C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:56 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y12so6392402edo.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hgl5gMBxItia10lruAV2PkbjEaW+EM2h5ysLJEWNolo=;
        b=MQ5eM/kankgKcxdAYfzIPpsvMDDi+jZIBMWSKPU9xdji7jVdL8pJvuYHX2vaoLUohw
         4hQor4M2s+tnQCu59c0mcOBrB/VCLYQODk7AQtqcuaI8nglnMojh9Q1hkoIz5ySTne12
         9hRyKtFnr83q6LKJ21DlBxku8/jGaaX9w+DJ2NApSJ3gJ6xVFXUEwyZNnd6JR+AwGfqx
         w4a3XGyDHYkAUg1+ofs+ggwLn19JZz4gYWnac4foaE03WJPMdNBZRv203Tie3yUrjpgu
         BRHz4O2S6DNOI0vhJ1hwpi+MIieV5cFrx1LjCSgnr8OzC53gYmSpqoJ1VhoiWgS2G1/X
         EXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hgl5gMBxItia10lruAV2PkbjEaW+EM2h5ysLJEWNolo=;
        b=fHLOod+Fw/ZRDde+kdnxrERBVoeSlFl0KgDEHJTd38x+PvUOUT3KCc/AmjHV8AOy/z
         KCLGAdhxMeBOk1cCr0SeL8LwX4aglUzcmC/HyxK6jweIT8lbIb4tG+sg6d7q7tliPB7t
         zIjvPeSbPq8upRmapV0rZv0dpwhUN1JwUrHuhTQsAdplXBdnhMGZwEqnMTf6mHPh8UvQ
         D+F39g5EMeknEZ1lw8J1xmgXb+Wdj26psdbrSfA2BnEfk6ciSR8fUOduV1BM51tthzuj
         zRCZDcFxQAx5nnvlPgEG3JgYoUqYvdtBpyHZsv1eC2+eMEh5k6VIA4PaaJU5Z7Lpw6J1
         NJ8g==
X-Gm-Message-State: AOAM533suPlyAlpKNle1zlvc2Z4e9Sqv0tYpu8LdCwwFdN2filYdZ/Lt
        Hdh8k5ioLNYZ5Ab+0Zp89hU=
X-Google-Smtp-Source: ABdhPJxZLBiO1JJWZNfMSqfWsXTyazDvMlEScqrQouUwGmcwXsBpKOSOfc/HuM2HgYj5ppeEs9dyQw==
X-Received: by 2002:a05:6402:1057:: with SMTP id e23mr4073206edu.352.1627535454729;
        Wed, 28 Jul 2021 22:10:54 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 55/87] trace-cmd library: Handle latency trace in version 7 files
Date:   Thu, 29 Jul 2021 08:09:27 +0300
Message-Id: <20210729050959.12263-56-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Latency trace data is saved the same was as flyrecord buffer data
in trace files version 7. There is a BUFFER_LAT option which hols the
latency specific trace metadata and points to the secrtion in the file
with the trace data. Extended the input hanlder with latency trace
context and added new logic to  decompress and  read the latency data.
A new API is added to read latency data:
 tracecmd_latency_data_read()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 +
 lib/trace-cmd/trace-input.c                   | 91 ++++++++++++++++++-
 2 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index f2868576..0a3e12cf 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -217,6 +217,8 @@ tracecmd_peek_data_ref(struct tracecmd_input *handle, int cpu)
 	return rec;
 }
 
+int tracecmd_latency_data_read(struct tracecmd_input *handle, char **buf, size_t *size);
+
 struct tep_record *
 tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 4582b9bc..b9340160 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -175,6 +175,9 @@ struct tracecmd_input {
 	bool			read_zpage; /* uncompress pages in memory, do not use tmp files */
 	bool			cpu_compressed;
 	int			file_version;
+	/* temporary file for uncompressed latency data */
+	struct cpu_zdata	latz;
+
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
@@ -3431,6 +3434,56 @@ static int read_options_type(struct tracecmd_input *handle)
 	return 0;
 }
 
+int tracecmd_latency_data_read(struct tracecmd_input *handle, char **buf, size_t *size)
+{
+	struct cpu_zdata *zdata = &handle->latz;
+	void *data;
+	int rsize;
+	int fd = -1;
+	int id;
+
+	if (!handle || !buf || !size)
+		return -1;
+	if (handle->file_state != TRACECMD_FILE_CPU_LATENCY)
+		return -1;
+
+	if (!handle->cpu_compressed) {
+		fd = handle->fd;
+	} else if (!handle->read_zpage) {
+		if (zdata->fd < 0)
+			return -1;
+		fd = zdata->fd;
+	}
+
+	/* Read data from a file */
+	if (fd >= 0) {
+		if (!(*buf)) {
+			*size = BUFSIZ;
+			*buf = malloc(*size);
+			if (!(*buf))
+				return -1;
+		}
+		return do_read_fd(fd, *buf, *size);
+	}
+
+	/* Uncompress data in memory */
+	if (zdata->last_chunk >= zdata->count)
+		return 0;
+	id = zdata->last_chunk;
+	if (!*buf || *size < zdata->chunks[id].size) {
+		data = realloc(*buf, zdata->chunks[id].size);
+		if (!data)
+			return -1;
+		*buf = data;
+		*size = zdata->chunks[id].size;
+	}
+	if (tracecmd_uncompress_chunk(handle->compress, &zdata->chunks[id], *buf))
+		return -1;
+	rsize = zdata->chunks[id].size;
+	zdata->last_chunk++;
+	return rsize;
+}
+
 static int init_cpu_data(struct tracecmd_input *handle)
 {
 	enum kbuffer_long_size long_size;
@@ -3494,6 +3547,32 @@ static int init_cpu_data(struct tracecmd_input *handle)
 	return -1;
 }
 
+int init_latency_data(struct tracecmd_input *handle)
+{
+	unsigned long long wsize;
+	int ret;
+
+	if (!handle->cpu_compressed)
+		return 0;
+
+	if (handle->read_zpage) {
+		handle->latz.count = tracecmd_load_chunks_info(handle->compress, &handle->latz.chunks);
+		if (handle->latz.count < 0)
+			return -1;
+	} else {
+		strcpy(handle->latz.file, COMPR_TEMP_FILE);
+		handle->latz.fd = mkstemp(handle->latz.file);
+		if (handle->latz.fd < 0)
+			return -1;
+		ret = tracecmd_uncompress_copy_to(handle->compress, handle->latz.fd, NULL, &wsize);
+		if (ret)
+			return -1;
+		lseek64(handle->latz.fd, 0, SEEK_SET);
+	}
+
+	return 0;
+}
+
 static int init_buffer_cpu_data(struct tracecmd_input *handle, struct input_buffer_instance *buffer)
 {
 	unsigned long long offset;
@@ -3510,6 +3589,10 @@ static int init_buffer_cpu_data(struct tracecmd_input *handle, struct input_buff
 		return -1;
 	if (flags & TRACECMD_SEC_FL_COMPRESS)
 		handle->cpu_compressed = true;
+	if (buffer->latency) {
+		handle->file_state = TRACECMD_FILE_CPU_LATENCY;
+		return init_latency_data(handle) == 0 ? 1 : -1;
+	}
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
 	handle->cpus = buffer->cpus;
 	if (handle->max_cpu < handle->cpus)
@@ -3959,7 +4042,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 
 	handle->fd = fd;
 	handle->ref = 1;
-
+	handle->latz.fd = -1;
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
 
@@ -4233,7 +4316,11 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->trace_clock);
 	free(handle->version);
 	close(handle->fd);
-
+	free(handle->latz.chunks);
+	if (handle->latz.fd >= 0) {
+		close(handle->latz.fd);
+		unlink(handle->latz.file);
+	}
 	while (handle->sections) {
 		del_sec = handle->sections;
 		handle->sections = handle->sections->next;
-- 
2.31.1

