Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CCE7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbhLBM2j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbhLBM2i (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:38 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D69AC061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:16 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id r25so49162693edq.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B+n5yh+LhF2w2p0i5FPFfVknoDtA6B4pxWVcKJU3WhU=;
        b=d7uJVJuzFqPiUDhe9AGm9UCSk4MQW4m6cQy6yjh0jRMhBmqhk4ePVw7G8rqrojtNLz
         74IhI7lGgr6gZjj+j4FDcGYQ8UgkmxRdpW7L1fIIerYG4LFDBtAX9S57cYaKYPhK83fF
         dgH9sU9gRZGXC2hS2YzoasrJubKXt6r+x/4Ajb4leySc7CWAi1a7Nnha/g39k9o8alCe
         SOewZ2Nww8ppQ+y8n10w4HZ7Wo5tnoNi87CLyirlDmVTb8zg9rA9VEMLd4P36UwSXwWb
         HDI730c0QGUyWd5oaskSW1A48TOuUjVEr/Sl8xpTBT3q5oIkPH0E3epcNL1Ha7PynUxs
         vGuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B+n5yh+LhF2w2p0i5FPFfVknoDtA6B4pxWVcKJU3WhU=;
        b=2DlK+ReaF0swL6mrLJVB6bVsv7Np5InW46hiG+2RJTYxHsaCQrDmRvV+lixQ9VDIq/
         SpST6vh7lACxbfpN7ETCrF0L+zyStKuZFjcrUuxCJ5OIK9LdBNQ0XUWfGU0GpJMTWU3M
         0aX1QHtHr+WiipsfT9kv2VEcouNOTTudRNFRovtALBrNTAeeXXRJ8IoC8MirEA5P56NJ
         A8BoPYF+55J+hL6wqoGk7CJ4s3V71BSzWxoYlPhYrJZby0Ety0+LEO1LcWQzqbMzm8N3
         r5znvdgaoEHjI7ZwyG96hhUR4VDwIK+0TjkZOT5Sqm5s0iKCPENfQAE7zkzTSrosCclw
         kBtQ==
X-Gm-Message-State: AOAM532ZfUqAxlQI2/SBpuux2HmaTJo0vSt3wOlmXcydvQSAQZAVAPOB
        zNJKXChGTXep5DXV04aqiE/AI2N00zgIcw==
X-Google-Smtp-Source: ABdhPJxE7UV/VsGp946b8rRQdLHLDvyrCeM03hglr8oAIvrqNYDElZrbWcr66bX5WpUgDkZc6atS6A==
X-Received: by 2002:a17:907:72d4:: with SMTP id du20mr15660807ejc.419.1638447913473;
        Thu, 02 Dec 2021 04:25:13 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 05/20] trace-cmd library: New API to configure compression on an output handler
Date:   Thu,  2 Dec 2021 14:24:52 +0200
Message-Id: <20211202122507.43572-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API can be used to configure compression algorithm on an output
handle to a trace file.
 tracecmd_output_set_compression()
The API for creation of latency trace file is extended with compression
parameter.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  3 +-
 lib/trace-cmd/trace-output.c                  | 58 ++++++++++++++++++-
 tracecmd/trace-record.c                       |  2 +-
 3 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 9cdd56a9..6cc6ce46 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -296,13 +296,14 @@ int tracecmd_output_set_trace_dir(struct tracecmd_output *handle, const char *tr
 int tracecmd_output_set_kallsyms(struct tracecmd_output *handle, const char *kallsyms);
 int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracecmd_input *ihandle);
 int tracecmd_output_set_version(struct tracecmd_output *handle, int file_version);
+int tracecmd_output_set_compression(struct tracecmd_output *handle, const char *compression);
 int tracecmd_output_write_headers(struct tracecmd_output *handle,
 				  struct tracecmd_event_list *list);
 
 struct tracecmd_output *tracecmd_output_create(const char *output_file);
 struct tracecmd_output *tracecmd_output_create_fd(int fd);
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
-						     int file_version);
+						     int file_version, const char *compression);
 
 struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
 					    unsigned short id, int size,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 7906fd92..bfd6e385 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -236,6 +236,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 	}
 
 	free(handle->trace_clock);
+	tracecmd_compress_destroy(handle->compress);
 	free(handle);
 }
 
@@ -1267,6 +1268,55 @@ int tracecmd_output_set_version(struct tracecmd_output *handle, int file_version
 	if (file_version < FILE_VERSION_MIN || file_version > FILE_VERSION_MAX)
 		return -1;
 	handle->file_version = file_version;
+	if (handle->file_version < FILE_VERSION_COMPRESSION)
+		handle->compress = NULL;
+	return 0;
+}
+
+/**
+ * tracecmd_output_set_compression - Set file compression algorithm of the output handle
+ * @handle: output handle to a trace file.
+ * @compression: name of the desired compression algorithm. Can be one of:
+ *		 - "none" - do not use compression
+ *		 - "all" - use the best available compression algorithm
+ *		 - or specific name of the desired compression algorithm
+ *
+ * This API must be called before tracecmd_output_write_headers().
+ *
+ * Returns 0 on success, or -1 in case of an error:
+ *   - the output file handle is not allocated or not in expected state.
+ *   - the specified compression algorithm is not available
+ */
+int tracecmd_output_set_compression(struct tracecmd_output *handle, const char *compression)
+{
+	if (!handle || handle->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+
+	handle->compress = NULL;
+	if (compression && strcmp(compression, "none")) {
+		if (!strcmp(compression, "any")) {
+			handle->compress = tracecmd_compress_alloc(NULL, NULL, handle->fd,
+								    handle->pevent,
+								    handle->msg_handle);
+			if (!handle->compress)
+				tracecmd_warning("No compression algorithms are supported");
+		} else {
+			handle->compress = tracecmd_compress_alloc(compression, NULL, handle->fd,
+								    handle->pevent,
+								    handle->msg_handle);
+			if (!handle->compress) {
+				tracecmd_warning("Compression algorithm %s is not supported",
+						  compression);
+				return -1;
+			}
+		}
+	}
+	if (handle->compress && handle->file_version < FILE_VERSION_COMPRESSION) {
+		handle->file_version = FILE_VERSION_COMPRESSION;
+		if (handle->msg_handle)
+			tracecmd_msg_handle_cache(handle->msg_handle);
+	}
+
 	return 0;
 }
 
@@ -1857,7 +1907,7 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 }
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
-						     int file_version)
+						     int file_version, const char *compression)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
@@ -1870,6 +1920,12 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	if (file_version && tracecmd_output_set_version(handle, file_version))
 		goto out_free;
+	if (compression) {
+		if (tracecmd_output_set_compression(handle, compression))
+			goto out_free;
+	} else if (file_version >= FILE_VERSION_COMPRESSION) {
+		tracecmd_output_set_compression(handle, "any");
+	}
 	if (tracecmd_output_write_headers(handle, NULL))
 		goto out_free;
 	/*
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index ead2c107..5f6fcc72 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4510,7 +4510,7 @@ static void record_data(struct common_record_context *ctx)
 
 	if (latency) {
 		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
-						      ctx->file_version);
+						      ctx->file_version, NULL);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
-- 
2.33.1

