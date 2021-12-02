Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA355C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357910AbhLBM0O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358097AbhLBMZg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:36 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F1AC0613D7
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:13 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x15so115104772edv.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ro65zpDkRK8n7+zg69DpqQoe21YT6TArLg7k2P6Wj3o=;
        b=WgvgYsSf8e9Yes13i2YJ6RzHgoXq+7fQ+lP9xjSBYC2NYP6Z7wJuzNpg5lM9rVkvEU
         hMaLRX7qknqJlP4NPgThyCl1ba/SEyoWwXaZjtj/5c7xkXKP/8qGvRmCvHMcIZY6DbMf
         uuDGU5GqChiDDejR/VzXDxa9N+5PR+liL6YxjsEesXvYvwILOg2DZBsPlqLXOh7NmobU
         k3fObKNOwP3oshcWRxZnJ8n5Rw/GhP4mHQLXNLNOMh1KR/67nofxnAKHwvNdHuRq8I6m
         Y5PIYc8quNK9W+r8feiV7xzzsrNZxb5P3NQOgf5O78PbF//lDjz1edSt/Kqrh1Y5d+QP
         bWtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ro65zpDkRK8n7+zg69DpqQoe21YT6TArLg7k2P6Wj3o=;
        b=KeMZ5z8nNj3BA8Tw6pTeHRB73jFDGOQEF5qf/wPPLWeduKMSEuAYWglUTcEmWlAN21
         DQzhnSCILNFYHJdAONrxhCOSA0a8C1JkMKCERoNO1WRtEszAEh4oCnWxZkocrgftv4iq
         8lhpek8gNiS0X3hOkQzUdO8HX7HKMcjMIpM7HA+8HGNjaSdtNocm3qysnJMbYHlRhZ9s
         OaOIWUcz3ZmBay2tTF3jsSbaTuoplJW7CZBid6y0Q3iVLI00wF0hzeEHZmlDzkKiBcu3
         lfFEr2PfyGLwFtJ1XmIXiRHe8c7l6DllUigSfIda413e5oSIbByo8JHRl44zaThciAsU
         ePuw==
X-Gm-Message-State: AOAM532RouEE4y+MR1JTP8As4vlOlhy9FvHlzCQNy3GyCtrqcEk3hGXG
        8lvN+vHctTvhlxg+kpwMP8DO9ZfyRQo/CQ==
X-Google-Smtp-Source: ABdhPJz4q6cuK2LUC3B9E7A2xg5uZPwOd7YPnXmMEwWEOLi616BSD8jNzemU+XMKK+9Z0hN2NEfJjg==
X-Received: by 2002:a05:6402:34d:: with SMTP id r13mr17399122edw.208.1638447732035;
        Thu, 02 Dec 2021 04:22:12 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:22:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 18/23] trace-cmd library: Initialize CPU data for reading from version 7 trace files
Date:   Thu,  2 Dec 2021 14:21:47 +0200
Message-Id: <20211202122152.43275-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
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
index 629abcda..9c2175e1 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3193,34 +3193,18 @@ static int read_options_type(struct tracecmd_input *handle)
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
 
@@ -3235,32 +3219,14 @@ static int read_cpu_data(struct tracecmd_input *handle)
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
@@ -3278,6 +3244,101 @@ static int read_cpu_data(struct tracecmd_input *handle)
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
@@ -3297,15 +3358,7 @@ static int read_cpu_data(struct tracecmd_input *handle)
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
@@ -3403,14 +3456,7 @@ static int read_and_parse_trace_clock(struct tracecmd_input *handle,
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
@@ -3432,7 +3478,29 @@ int tracecmd_init_data(struct tracecmd_input *handle)
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
2.33.1

