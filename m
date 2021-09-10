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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A467C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20179611EE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbhIJNwf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbhIJNwf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:35 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BB3C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:23 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id n27so4410767eja.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cMT4V0MnHrPJ9p7HRfPLTEnDRjbayiREcUKzcLY1zE4=;
        b=VdjMDdT6k8AbGmUMxhJvPxFO5/ISGlTEfQPaCX3yTk7rO1AEVVU3gw7yCdhfMRXNBq
         1UtlAiJXkRXY4bQEEWg+cj90EAcor4h/nBLKUEX5QsE6sd+T0A/7yvbKjhHUqONnOfMx
         qnnPZ9e9dy/rkTxIjfJhI4pMnvUvZjtyPWLBdRq4S7G9pRB3Lyrwc111PoR2HknxrxWb
         2YshDnJTC8t7LNfB3XsvJUuXY6wS5tnVuyzQ1cDsJFp/KCUVlPc6UOHLa6KLuhKEgr9v
         c2QLvU3t8k0w4UHRg+zBiGB/vR+W7AOLnm++DhxxKEbjszaaknoUWevjw9YxUXl3dscS
         mmlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cMT4V0MnHrPJ9p7HRfPLTEnDRjbayiREcUKzcLY1zE4=;
        b=afxmhzoUwJEtMrqyHT5pBc0iWFtbCyjEkLYBUfpyZBZ0fWBzn1AV5JYgSwONIfHYhw
         KtbGfg7/A7porrXbn3998aYkfuuhEyy2HrlNPI3xeeAvqWmnL/N7cZi9T4GX+tDd5je1
         ym9UoYtP/wC7bnSa/VIzhN6bTYiNEY4Du+vOu7kk7hp35Qqwv4ReDm40l07mBxPAbJOQ
         HJob8yapYwatE/NBX0yY9lHz884mHtqOeF236RWTOX6KiD+MGMmkJ0YTNNeD3mCNU8UW
         INGVuehaTiqQ9my7hJwdUvafiYNXyLAKbffZcECSTL83tHdmjHXZnGYIkUxltLb/0GHM
         oWmw==
X-Gm-Message-State: AOAM532cXwKRZLerqfxe0xgmdmv+QgZEdT8uq1/MG4o0daIz6Pp7Pnvz
        zY+HnYXNHnbzgUy6MItsmDcpAPip/WY=
X-Google-Smtp-Source: ABdhPJwMHaIXpWdBdwVtA6f3jMJPejZi8Ew2eRpO1uRcNCiHPDi+wF7Sap1bJoG3pl9KPfhL9H4o7w==
X-Received: by 2002:a17:906:a18f:: with SMTP id s15mr9820886ejy.269.1631281882361;
        Fri, 10 Sep 2021 06:51:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 20/25] trace-cmd library: Initialize CPU data for reading from version 7 trace files
Date:   Fri, 10 Sep 2021 16:50:56 +0300
Message-Id: <20210910135101.2865226-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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
index 5e33efa6..7ba08e5e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3203,34 +3203,18 @@ static int read_options_type(struct tracecmd_input *handle)
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
 
@@ -3245,32 +3229,14 @@ static int read_cpu_data(struct tracecmd_input *handle)
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
@@ -3288,6 +3254,101 @@ static int read_cpu_data(struct tracecmd_input *handle)
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
@@ -3307,15 +3368,7 @@ static int read_cpu_data(struct tracecmd_input *handle)
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
@@ -3418,14 +3471,7 @@ static int read_and_parse_trace_clock(struct tracecmd_input *handle,
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
@@ -3447,7 +3493,29 @@ int tracecmd_init_data(struct tracecmd_input *handle)
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
+	if (handle->file_version < 7)
+		ret = init_data_v6(handle);
+	else
+		ret = init_data_v7(handle);
 	tracecmd_blk_hack(handle);
 
 	return ret;
-- 
2.31.1

