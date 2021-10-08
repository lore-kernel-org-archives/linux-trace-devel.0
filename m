Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CFFBC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 841D861073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237563AbhJHEWS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhJHEWR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:17 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19249C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:23 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b8so31214111edk.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g4GvYP6kE14dvqq8OxjgnXKDxiwQl0sxKhrQp0NS7PM=;
        b=lRPHvwiI3mAoxE2IO2+CgB36KgTCNIwFEU/cL6O6zYluSDNxF80Glvl5e/URTJdIta
         AUVMx9GwTdNepfOwTkkC51QP/nEDQVdKlO4t4mvxQowR2znjWRS8YNl/twBu22LcALRN
         J5+i99nq9+0D9zeO7Xg+ZLq/sN7FMfUjlwslpLA4mxHTcQQSZfW21U2l/grAqqc+k7n+
         Aua3Sl6ajX7+lvRUiMfqyFNVHBJukZgxxJHCWYK6AQZi+hxagoFynlSIG6aCmZkkMJun
         jqLa9/W0T0pCgVRhZPeuc3p94wQ46ZQQ1WQaqNWC8w8eYJeI6rJVFY5AWfByDJRnLGfY
         LvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g4GvYP6kE14dvqq8OxjgnXKDxiwQl0sxKhrQp0NS7PM=;
        b=Q2eNDsrBZopcV3ESxu64zT2a6bncZd87DFHfbvIoL49p/0NZd6eRIV6qmTwkOi0qj4
         g246+yrqpmj6dje2WTA9WW6Emcb3rQixicRAGRKHVAj8TZd/MKRk+Pz/yiCLheRllpRS
         Eg3RMuJ3Pjnl6zSdedOUZiPBtmZCX5wBYUaqj/EqHocaR0hVbj2qDctmj/3twhOcKMT8
         7ZOzwfTfp/EqWNwJHSd0n1LLqTOMP5+r+noNV5sXnz6dNU5ImmluGhU+YljPuEa/jzcY
         LVxdG8oYZNayUqxPurozV3F5EWwit7IuhK4BYHMlCwkIr2tlMTT9Kq1XdtQji7C5xfDs
         zepg==
X-Gm-Message-State: AOAM530UdrJGmAHfZBqGdeZu2wACMUbklHFGAC376Xr4aEfOm7M1nc0S
        IexX+OdNUxsZ19mKGE8x0HOIzW/CQ3ODzA==
X-Google-Smtp-Source: ABdhPJxCZXsOPHIOmELQoBYPLOWDYmEJ/cwhLyLwIFrS5tPdR68WxOVWjkV76PMr6rZ6oHtmxidS6A==
X-Received: by 2002:a17:906:2a0d:: with SMTP id j13mr1190139eje.545.1633666821658;
        Thu, 07 Oct 2021 21:20:21 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 20/25] trace-cmd library: Initialize CPU data for reading from version 7 trace files
Date:   Fri,  8 Oct 2021 07:19:53 +0300
Message-Id: <20211008041958.976309-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In version 7 trace files, CPU trace data is written in slightly
different way than in version 6 files. Added new CPU data initialization
flow, to handle version 7 files:
 - the top trace instance is saved in the same way as the other trace
   instances.
 - per CPU trace metadata is stored in the buffer option.
 - trace data section has section header.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 178 +++++++++++++++++++++++++-----------
 1 file changed, 123 insertions(+), 55 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 6137fc89..511f209f 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3194,34 +3194,18 @@ static int read_options_type(struct tracecmd_input *handle)
 	return 0;
 }
 
-static int read_cpu_data(struct tracecmd_input *handle)
+static int init_cpu_data(struct tracecmd_input *handle)
 {
-	struct tep_handle *pevent = handle->pevent;
 	enum kbuffer_long_size long_size;
 	enum kbuffer_endian endian;
-	unsigned long long size;
 	unsigned long long max_size = 0;
 	unsigned long long pages;
-	int cpus;
 	int cpu;
 
-	/*
-	 * Check if this is a latency report or not.
-	 */
-	if (handle->file_state == TRACECMD_FILE_CPU_LATENCY)
-		return 1;
-
 	/* We expect this to be flyrecord */
 	if (handle->file_state != TRACECMD_FILE_CPU_FLYRECORD)
 		return -1;
 
-	cpus = handle->cpus;
-
-	handle->cpu_data = malloc(sizeof(*handle->cpu_data) * handle->cpus);
-	if (!handle->cpu_data)
-		return -1;
-	memset(handle->cpu_data, 0, sizeof(*handle->cpu_data) * handle->cpus);
-
 	if (force_read)
 		handle->read_page = true;
 
@@ -3236,32 +3220,14 @@ static int read_cpu_data(struct tracecmd_input *handle)
 		endian = KBUFFER_ENDIAN_LITTLE;
 
 	for (cpu = 0; cpu < handle->cpus; cpu++) {
-		unsigned long long offset;
-
-		handle->cpu_data[cpu].cpu = cpu;
-
 		handle->cpu_data[cpu].kbuf = kbuffer_alloc(long_size, endian);
 		if (!handle->cpu_data[cpu].kbuf)
 			goto out_free;
-		if (tep_is_old_format(pevent))
+		if (tep_is_old_format(handle->pevent))
 			kbuffer_set_old_format(handle->cpu_data[cpu].kbuf);
 
-		read8(handle, &offset);
-		read8(handle, &size);
-
-		handle->cpu_data[cpu].file_offset = offset;
-		handle->cpu_data[cpu].file_size = size;
-		if (size > max_size)
-			max_size = size;
-
-		if (size && (offset + size > handle->total_file_size)) {
-			/* this happens if the file got truncated */
-			printf("File possibly truncated. "
-				"Need at least %llu, but file size is %zu.\n",
-				offset + size, handle->total_file_size);
-			errno = EINVAL;
-			goto out_free;
-		}
+		if (handle->cpu_data[cpu].file_size > max_size)
+			max_size = handle->cpu_data[cpu].file_size;
 	}
 
 	/* Calculate about a meg of pages for buffering */
@@ -3279,6 +3245,101 @@ static int read_cpu_data(struct tracecmd_input *handle)
 			goto out_free;
 	}
 
+	return 0;
+
+ out_free:
+	for ( ; cpu >= 0; cpu--) {
+		free_page(handle, cpu);
+		kbuffer_free(handle->cpu_data[cpu].kbuf);
+		handle->cpu_data[cpu].kbuf = NULL;
+	}
+	return -1;
+}
+
+static int init_buffer_cpu_data(struct tracecmd_input *handle, struct input_buffer_instance *buffer)
+{
+	unsigned long long offset;
+	unsigned long long size;
+	unsigned short id, flags;
+	int cpu;
+
+	if (handle->cpu_data)
+		return -1;
+
+	if (lseek64(handle->fd, buffer->offset, SEEK_SET) == (off_t)-1)
+		return -1;
+	if (read_section_header(handle, &id, &flags, NULL, NULL))
+		return -1;
+
+	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
+	handle->cpus = buffer->cpus;
+	if (handle->max_cpu < handle->cpus)
+		handle->max_cpu = handle->cpus;
+
+	handle->cpu_data = calloc(handle->cpus, sizeof(*handle->cpu_data));
+	if (!handle->cpu_data)
+		return -1;
+
+	for (cpu = 0; cpu < handle->cpus; cpu++) {
+		handle->cpu_data[cpu].cpu = buffer->cpu_data[cpu].cpu;
+		offset = buffer->cpu_data[cpu].offset;
+		size = buffer->cpu_data[cpu].size;
+		handle->cpu_data[cpu].file_offset = offset;
+		handle->cpu_data[cpu].file_size = size;
+		if (size && (offset + size > handle->total_file_size)) {
+			/* this happens if the file got truncated */
+			printf("File possibly truncated. "
+				"Need at least %llu, but file size is %zu.\n",
+				offset + size, handle->total_file_size);
+			errno = EINVAL;
+			return -1;
+		}
+	}
+
+	return init_cpu_data(handle);
+}
+
+static int read_cpu_data(struct tracecmd_input *handle)
+{
+	unsigned long long size;
+	int cpus;
+	int cpu;
+
+	/*
+	 * Check if this is a latency report or not.
+	 */
+	if (handle->file_state == TRACECMD_FILE_CPU_LATENCY)
+		return 1;
+
+	/* We expect this to be flyrecord */
+	if (handle->file_state != TRACECMD_FILE_CPU_FLYRECORD)
+		return -1;
+
+	cpus = handle->cpus;
+
+	handle->cpu_data = malloc(sizeof(*handle->cpu_data) * handle->cpus);
+	if (!handle->cpu_data)
+		return -1;
+	memset(handle->cpu_data, 0, sizeof(*handle->cpu_data) * handle->cpus);
+
+	for (cpu = 0; cpu < handle->cpus; cpu++) {
+		unsigned long long offset;
+
+		handle->cpu_data[cpu].cpu = cpu;
+		read8(handle, &offset);
+		read8(handle, &size);
+		handle->cpu_data[cpu].file_offset = offset;
+		handle->cpu_data[cpu].file_size = size;
+		if (size && (offset + size > handle->total_file_size)) {
+			/* this happens if the file got truncated */
+			printf("File possibly truncated. "
+				"Need at least %llu, but file size is %zu.\n",
+				offset + size, handle->total_file_size);
+			errno = EINVAL;
+			return -1;
+		}
+	}
+
 	/*
 	 * It is possible that an option changed the number of CPUs.
 	 * If that happened, then there's "empty" cpu data saved for
@@ -3298,15 +3359,7 @@ static int read_cpu_data(struct tracecmd_input *handle)
 		}
 	}
 
-	return 0;
-
- out_free:
-	for ( ; cpu >= 0; cpu--) {
-		free_page(handle, cpu);
-		kbuffer_free(handle->cpu_data[cpu].kbuf);
-		handle->cpu_data[cpu].kbuf = NULL;
-	}
-	return -1;
+	return init_cpu_data(handle);
 }
 
 static int read_data_and_size(struct tracecmd_input *handle,
@@ -3404,14 +3457,7 @@ static int read_and_parse_trace_clock(struct tracecmd_input *handle,
 	return 0;
 }
 
-/**
- * tracecmd_init_data - prepare reading the data from trace.dat
- * @handle: input handle for the trace.dat file
- *
- * This prepares reading the data from trace.dat. This is called
- * after tracecmd_read_headers() and before tracecmd_read_data().
- */
-int tracecmd_init_data(struct tracecmd_input *handle)
+static int init_data_v6(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
 	int ret;
@@ -3433,7 +3479,29 @@ int tracecmd_init_data(struct tracecmd_input *handle)
 			tracecmd_parse_trace_clock(handle, clock, 8);
 		}
 	}
+	return ret;
+}
+
+static int init_data_v7(struct tracecmd_input *handle)
+{
+	return init_buffer_cpu_data(handle, &handle->top_buffer);
+}
 
+/**
+ * tracecmd_init_data - prepare reading the data from trace.dat
+ * @handle: input handle for the trace.dat file
+ *
+ * This prepares reading the data from trace.dat. This is called
+ * after tracecmd_read_headers() and before tracecmd_read_data().
+ */
+int tracecmd_init_data(struct tracecmd_input *handle)
+{
+	int ret;
+
+	if (!HAS_SECTIONS(handle))
+		ret = init_data_v6(handle);
+	else
+		ret = init_data_v7(handle);
 	tracecmd_blk_hack(handle);
 
 	return ret;
-- 
2.31.1

