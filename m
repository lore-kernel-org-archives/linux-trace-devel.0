Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059F1C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357944AbhLBM0R (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358104AbhLBMZg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:36 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658F2C0613F2
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:14 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id y12so115167911eda.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SDkcFFzdGxXaMnS0+8fD+x1KTLsu5yHoYjKybuJglj4=;
        b=mRa0NG5wNl7E5U0upkTPNCAh0QCnaRbjQiL3RKfgETl6fTAo2wUgPhGr6RSn8EJYFw
         kHnGyJcxeKNi2WI3Ia9C+4HeBNC3BhumSH4Bd6PUepErkFV2kyZT9jCpPYEESgGvBuCK
         Nwciv9D3TV5ZlP81R8vpLgrpNGt59F1vMWK9sy2/FBhEBM1q54xttO/oH6N5Jnly/bbs
         ZKWbK8vsN7c+AWxXlUhs2lHu74z2/gUgevO7GVRUhXaP/jNNuH2Rb7yvKHJOcIK+NDVv
         PT2meLo7P+8VkqiVDjqEuwiMj3KDC8PL8IM2wTm3J7m3Z0BhO4KgYdctfHkyy2nVpv1c
         rbJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SDkcFFzdGxXaMnS0+8fD+x1KTLsu5yHoYjKybuJglj4=;
        b=erJbD/CFLiaj08jMKI/42bKFq0NLGRFrkB145szTDOK+qLIjigTGAbFXiQ0RbVgglj
         jl+0If7LbiAPp45BMnjR87Bj7/WfE2aUl+wh6USTepliq8MjfIC1tfjx3JOKy+PpUI5w
         qFYR4CaW+/s6M7A9Rpn0TBzXAheRqGN4DqhnncKbLq08SM2xx1g+pxcT8GjLiMtj32rv
         f3jk9bWI8Iqo7p9UtjlzkfgJWJ8ztJ7xgto+JV3P+YN7qLpk9ksOX0bby5ww9BW8ZqFc
         FOTxXV5voRwKDwZf61rtdjQCIze5el53ARQDmCDyEElY8OO8MuvkJI7jneyPMBGau86v
         V1yw==
X-Gm-Message-State: AOAM530VZxEfhj+hHOaRwtfMmGTJHiImvJSZp71VMWQs9iYZ4ryzd5t5
        3VZCyJ4FHP8umKJ/u1KKrvA8sGpbuOTJqw==
X-Google-Smtp-Source: ABdhPJzb7Uq7o8PmaL05aI21Kr76/8BSQWSH+xxu4nbaVJ92r9Dk1lwMjOJ8pcBZVqLhMed+7IIBzg==
X-Received: by 2002:a17:906:3157:: with SMTP id e23mr14614679eje.359.1638447732934;
        Thu, 02 Dec 2021 04:22:12 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:22:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 19/23] trace-cmd library: Handle latency trace in version 7 files
Date:   Thu,  2 Dec 2021 14:21:48 +0200
Message-Id: <20211202122152.43275-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Latency trace data is saved the same was as flyrecord buffer data
in trace files version 7. There is a BUFFER_TEXT option which holds the
latency specific trace metadata and points to the section in the file
with the trace data. A new API is added to read latency data:
 tracecmd_latency_data_read()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  5 +++-
 lib/trace-cmd/trace-input.c                   | 29 ++++++++++++++++++-
 lib/trace-cmd/trace-output.c                  |  5 +++-
 tracecmd/trace-record.c                       |  3 +-
 4 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 3b5afeba..0feb4b30 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -221,6 +221,8 @@ tracecmd_peek_data_ref(struct tracecmd_input *handle, int cpu)
 	return rec;
 }
 
+int tracecmd_latency_data_read(struct tracecmd_input *handle, char **buf, size_t *size);
+
 struct tep_record *
 tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record);
 
@@ -295,7 +297,8 @@ int tracecmd_output_write_headers(struct tracecmd_output *handle,
 
 struct tracecmd_output *tracecmd_output_create(const char *output_file);
 struct tracecmd_output *tracecmd_output_create_fd(int fd);
-struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
+struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
+						     int file_version);
 
 struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
 					    unsigned short id, int size,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9c2175e1..896f4214 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3193,6 +3193,24 @@ static int read_options_type(struct tracecmd_input *handle)
 	return 0;
 }
 
+int tracecmd_latency_data_read(struct tracecmd_input *handle, char **buf, size_t *size)
+{
+	if (!handle || !buf || !size)
+		return -1;
+	if (handle->file_state != TRACECMD_FILE_CPU_LATENCY)
+		return -1;
+
+	/* Read data from a file */
+	if (!(*buf)) {
+		*size = BUFSIZ;
+		*buf = malloc(*size);
+		if (!(*buf))
+			return -1;
+	}
+
+	return do_read(handle, *buf, *size);
+}
+
 static int init_cpu_data(struct tracecmd_input *handle)
 {
 	enum kbuffer_long_size long_size;
@@ -3255,6 +3273,12 @@ static int init_cpu_data(struct tracecmd_input *handle)
 	return -1;
 }
 
+int init_latency_data(struct tracecmd_input *handle)
+{
+	/* To do */
+	return 0;
+}
+
 static int init_buffer_cpu_data(struct tracecmd_input *handle, struct input_buffer_instance *buffer)
 {
 	unsigned long long offset;
@@ -3269,7 +3293,10 @@ static int init_buffer_cpu_data(struct tracecmd_input *handle, struct input_buff
 		return -1;
 	if (read_section_header(handle, &id, &flags, NULL, NULL))
 		return -1;
-
+	if (buffer->latency) {
+		handle->file_state = TRACECMD_FILE_CPU_LATENCY;
+		return init_latency_data(handle) == 0 ? 1 : -1;
+	}
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
 	handle->cpus = buffer->cpus;
 	if (handle->max_cpu < handle->cpus)
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index c613c2ff..e57d32ba 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1796,7 +1796,8 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 	return option;
 }
 
-struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
+struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
+						     int file_version)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
@@ -1807,6 +1808,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (!handle)
 		return NULL;
 
+	if (file_version && tracecmd_output_set_version(handle, file_version))
+		goto out_free;
 	if (tracecmd_output_write_headers(handle, NULL))
 		goto out_free;
 	/*
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7b2b59bb..2c222ed9 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4500,7 +4500,8 @@ static void record_data(struct common_record_context *ctx)
 		return;
 
 	if (latency) {
-		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count);
+		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
+						      ctx->file_version);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
-- 
2.33.1

