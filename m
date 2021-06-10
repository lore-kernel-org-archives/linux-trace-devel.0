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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA11C48BE0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 634CE613E9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhFJLh5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:57 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:54863 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhFJLh5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:57 -0400
Received: by mail-wm1-f48.google.com with SMTP id m3so742634wms.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GoJm7VsZJlhF8Q1T9Z+WwKmc6H4hjRgw29T+P08ERkU=;
        b=LzoZT11vZH2AMqbdOL0MH/SqbKnA25KkbIU4GhI/h5J+DBNEH82FgUaefukCqFH5uh
         arDp8DShoC8V3DOzeMnEdGS4sbi0OlIkOYf0q7u7SoJgO/UddeWKKyQkrt17SQhTREQw
         4UnVG+VpRN5WKWptbf5CIP1wzcxlasO9a3kiw5ES8K3wasta6wDF8asgKilgOrpx2zvK
         +x7E8ix0+AGIFwVLndombdmkOFLlG2jSMjgsQ20V/jCH4D7n6yX54azfCkEQ9OWWpHEh
         8KPhMOOPIE+pHoctI3L2OakhEYZ3nSf8tuh7mEck1fz5b8XlSLvUBV6xhxQk/gfh3go7
         bfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GoJm7VsZJlhF8Q1T9Z+WwKmc6H4hjRgw29T+P08ERkU=;
        b=PzWTtneyP1JbDFln3PepNxEAiR9/5ro0B7en0LwDp5LtZsF1B1L5RgWp1uXtGUHRGX
         2SQiRES/zmpIrnz1QtbkIfedbQR1mX2Msckepov48l2ccjIjJHuSfeFOv1omdLgbRP83
         wpuIrOy/CXVfELbbpOdZ3p/JK94gU4QA45sTTg8Mi+9C0+IK8pMtQx+xapbZwu4BOBTK
         Vj7xDMFJqWG54hy+DWY7nyRN6SP30tsjEvGeqs4AVMHhhzKAZpDUGb4yLi8xVe2+D9zj
         i4f+DioIVnMQrjKSiLARkZ53eX5eR71DlxpGxS50aASS5LShb6iB3xFFcKCWwoQmBnsu
         Q6Pg==
X-Gm-Message-State: AOAM531FYlkVSb3RF6tqmvJngWelr7E00WY9Vj2UZueVfQViALcdXVLT
        QEcSW6xK5lme4UR/x27YwjE=
X-Google-Smtp-Source: ABdhPJzC21RnvfC1wx2/tsI9nrJpfDr1JiEIIsEygUuxH+2mLT4jK/1snIMR8RBIEJH4zuWFJz9lNQ==
X-Received: by 2002:a1c:9dcd:: with SMTP id g196mr14879230wme.135.1623324888959;
        Thu, 10 Jun 2021 04:34:48 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:48 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 22/40] trace-cmd library: Refactor the logic for writing trace data in the file
Date:   Thu, 10 Jun 2021 14:34:08 +0300
Message-Id: <20210610113426.257931-23-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Refactored the internal logic of tracecmd_write_cpu_data() API to be
suitable for adding trace data compression.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 94 +++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 50 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 81d97d4a..860be759 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1679,11 +1679,17 @@ static char *get_clock(struct tracecmd_output *handle)
 	return handle->trace_clock;
 }
 
+struct data_file_write {
+	int file_size;
+	off64_t soffset;
+	off64_t data_offset;
+	off64_t doffset;
+};
+
 int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 			    int cpus, char * const *cpu_data_files)
 {
-	off64_t *offsets = NULL;
-	unsigned long long *sizes = NULL;
+	struct data_file_write *data_files = NULL;
 	off64_t offset;
 	unsigned long long endian8;
 	char *clock = NULL;
@@ -1705,37 +1711,11 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 	if (do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
-	offsets = malloc(sizeof(*offsets) * cpus);
-	if (!offsets)
-		goto out_free;
-	sizes = malloc(sizeof(*sizes) * cpus);
-	if (!sizes)
-		goto out_free;
-
-	offset = lseek64(handle->fd, 0, SEEK_CUR);
-
-	/* hold any extra data for data */
-	offset += cpus * (16);
-
-	/*
-	 * Unfortunately, the trace_clock data was placed after the
-	 * cpu data, and wasn't accounted for with the offsets.
-	 * We need to save room for the trace_clock file. This means
-	 * we need to find the size of it before we define the final
-	 * offsets.
-	 */
-	clock = get_clock(handle);
-	if (!clock)
+	data_files = calloc(cpus, sizeof(struct data_file_write));
+	if (!data_files)
 		goto out_free;
-	/* Save room for storing the size */
-	offset += 8;
-	offset += strlen(clock);
-	/* 2 bytes for [] around the clock */
-	offset += 2;
-
-	/* Page align offset */
-	offset = (offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
 
+	/* Write 0 for trace data offset and size and store offsets of these fields */
 	for (i = 0; i < cpus; i++) {
 		file = cpu_data_files[i];
 		ret = stat(file, &st);
@@ -1743,53 +1723,67 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 			tracecmd_warning("can not stat '%s'", file);
 			goto out_free;
 		}
-		offsets[i] = offset;
-		sizes[i] = st.st_size;
-		offset += st.st_size;
-		offset = (offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
+		data_files[i].file_size = st.st_size;
 
-		endian8 = convert_endian_8(handle, offsets[i]);
+		endian8 = 0;
+		data_files[i].doffset = lseek64(handle->fd, 0, SEEK_CUR);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
-		endian8 = convert_endian_8(handle, sizes[i]);
+		data_files[i].soffset = lseek64(handle->fd, 0, SEEK_CUR);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
 	}
 
-	if (save_clock(handle, clock))
+	clock = get_clock(handle);
+	if (clock && save_clock(handle, clock))
 		goto out_free;
 
 	for (i = 0; i < cpus; i++) {
+		data_files[i].data_offset = lseek64(handle->fd, 0, SEEK_CUR);
+		/* Page align offset */
+		data_files[i].data_offset = (data_files[i].data_offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
+		data_files[i].data_offset = lseek64(handle->fd, data_files[i].data_offset, SEEK_SET);
+		if (data_files[i].data_offset == (off64_t)-1)
+			goto out_free;
 		if (!tracecmd_get_quiet(handle))
 			fprintf(stderr, "CPU%d data recorded at offset=0x%llx\n",
-				i, (unsigned long long) offsets[i]);
-		offset = lseek64(handle->fd, offsets[i], SEEK_SET);
-		if (offset == (off64_t)-1) {
-			tracecmd_warning("could not seek to %lld\n", offsets[i]);
-			goto out_free;
-		}
+				i, (unsigned long long) data_files[i].data_offset);
+
 		check_size = copy_file(handle, cpu_data_files[i]);
-		if (check_size != sizes[i]) {
+		if (check_size != data_files[i].file_size) {
 			errno = EINVAL;
 			tracecmd_warning("did not match size of %lld to %lld",
-					 check_size, sizes[i]);
+					 check_size, data_files[i].file_size);
 			goto out_free;
 		}
+		/* Write the real CPU data offset inthe file */
+		offset = lseek64(handle->fd, data_files[i].doffset, SEEK_SET);
+		endian8 = convert_endian_8(handle, data_files[i].data_offset);
+		if (do_write_check(handle, &endian8, 8))
+			goto out_free;
+		/* Write the real CPU data size in the file */
+		offset = lseek64(handle->fd, data_files[i].soffset, SEEK_SET);
+		endian8 = convert_endian_8(handle, check_size);
+		if (do_write_check(handle, &endian8, 8))
+			goto out_free;
+		offset = data_files[i].data_offset + check_size;
+		offset = lseek64(handle->fd, offset, SEEK_SET);
 		if (!tracecmd_get_quiet(handle))
 			fprintf(stderr, "    %llu bytes in size\n",
 				(unsigned long long)check_size);
 	}
 
-	free(offsets);
-	free(sizes);
+	if (lseek64(handle->fd, 0, SEEK_END) == (off64_t)-1)
+		goto out_free;
 
+	free(data_files);
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
 
 	return 0;
 
  out_free:
-	free(offsets);
-	free(sizes);
+	lseek64(handle->fd, 0, SEEK_END);
+	free(data_files);
 	return -1;
 }
 
-- 
2.31.1

