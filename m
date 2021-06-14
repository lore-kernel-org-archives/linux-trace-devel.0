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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 183AFC48BE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F31AC61370
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbhFNHx4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:56 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:41955 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbhFNHx4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:56 -0400
Received: by mail-ed1-f46.google.com with SMTP id g18so43225229edq.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ad5WRDGSmHIxRG6OKUBwzd4Bx+HY5iH9CAWdyYF9xFg=;
        b=jhCXrCORuFFKHOp46YVSRSV8/zVfwSj2S3CIXijLkwpPETTbwhDIPu4+hAXXbFDjp0
         inC+v3fzZJ9IAtlon3TlQqe5k6VgfIyVEM/ykmGqo4AQoEMN73nEx+tq6W9JEcjk64Cs
         P80YCKYHu59vsGi6Aogxolkb3EXDALOhnjtG7HAdprFXH9iN6oCh3WmC0A5d5mN1AFAx
         iWludlMmOnbkmItW1h4RiIc+/HaflTs56eKJ4zLLKb7Go2UOO8iNsuSrjMjrVH5s6Aya
         ozq1G6Tbj27Uxxy3exoXffknu5zkWv5LywmCO6PC0l/N/AMWAXK10Uf3YAm/d4SffqXm
         SgHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ad5WRDGSmHIxRG6OKUBwzd4Bx+HY5iH9CAWdyYF9xFg=;
        b=gPfxteJ9v0T4gTLOYvWlLUJSKOi0OC549/8ogW1M4lv5s2fUslc4z8UF+AJL/CjtQb
         LYXCM03ufu5+GpHOlYvrUf21+5aWx2iaijF7tlDFw+z8OE4ybqmlVtY2E0Z7baWzq6Nb
         JcR+xhtqop9q/clEb+oREu6xMikNtJ0WLf428DR3zgmBeIJZjs37O9vH0uvnj1+Vs+qK
         Kk0f2dz1FHmO8FyG9Wgk8mw0t62iHHR3wfzoH1qKiSuo7oFbfDVIR8JePz8yUurCjEzi
         yyoz3WmvyofiHUiixzOIHD3zkSgAkMoYKhkfA/k9Gmdtlj3MrGcxYTc4Q88oiUA2NrnB
         oQFg==
X-Gm-Message-State: AOAM530ksuzo/HUFlCblwD6MdWYVHWGG67NCdb6eYHExudo5IGKMawO8
        XOUlCPU+76nfLPU8ljdJJzSF/fi1wzvPtg==
X-Google-Smtp-Source: ABdhPJyXGz4+X2/Yqi3Akxas5/lhnS/aT+vhcOXYq/CRQpLGrI2OSVhDlCO8BTgdmFfmOiekoKPA7g==
X-Received: by 2002:a05:6402:34c6:: with SMTP id w6mr15721294edc.174.1623657053170;
        Mon, 14 Jun 2021 00:50:53 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 22/45] trace-cmd library: Refactor the logic for writing trace data in the file
Date:   Mon, 14 Jun 2021 10:50:06 +0300
Message-Id: <20210614075029.598048-23-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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
index f7e6c3dd..ed4ef638 100644
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

