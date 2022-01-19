Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2801FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352442AbiASI1Y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343541AbiASI1Y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:24 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FD7C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:23 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id a18so7571405edj.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CMls2xTtvpRTRGCAZD2HybvQcNbb5m92n8AFdzk2vPo=;
        b=N4YvfIoKmgvp7DkQCrE4fa9R+GKaDKHTejw/HeCUrWl1On9yg2XjUQDVTvG5ZTZhCD
         UAl7c7pr9nDy0O6jl/yD7kuMSewnVqPnTrh1B1V9mDWjMeGBGpYd/0fAUV3tqKLQKjMI
         sxYLEWU6pXk0MEAzV8oCrzwFFlzjox+k5DfLH4IE9LGDAcNDzr+fNhx14lOApmgO4r4L
         jrFsxQmSRipMIxwauMUNDS+HwFlgiTEiMrEb+ADbNNgq3cj5qVyBl5KXzLn2uT9eT/aa
         vOaui1o8C7KhVnyLgUH5keVex6J1/SoJc14gqhI/pXV44CRwBanK/GuRQBC8L0li7vdS
         gUkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CMls2xTtvpRTRGCAZD2HybvQcNbb5m92n8AFdzk2vPo=;
        b=6QuDYCjhErFzl9NIr8Avj1m6wOlrT3AJTGB5tQD9m1eipj39pAr3Zhn2Ij/xRWyOVZ
         RylT47zF5/89jlj6UCEuYivb1OvZ3lz1tqtKd9U4HvadkV8fpEqcFJu+LiwtxOmvW/Dm
         ktz3XszFAGZfNbtP5ZWEhmw6WhSmWSpIMQRhJx6tQBB2SAMM8dOX/ALq5lnSaKaPOHYm
         RPm56bHaE65itCWlc6o6fTUZo1ejdsd8PSKfeTK2Zrw8pCQKyLUobEucVXyOCuGqPwPK
         Ng8Oy4Ud5ZNzMSxB+uHEGE4uMas00c1RWE7WVQ6Ogewjjg/pgmxvBVs25xWQ8xMKBKRO
         Tmxg==
X-Gm-Message-State: AOAM531gw1q1uMq4+yjoxCLIJ5d81pD/OcYv2Bw9kE76yledo86QuNOJ
        xCdXczACddN4gLUp1xuXStfqqQgPNa4=
X-Google-Smtp-Source: ABdhPJwhDkf2+Kwxr0Yc2IT0ASqUCfcodwaXeih3DCuoyjFE4bjSO+OjbUwUppX9MkTCIjpRY5Rp1A==
X-Received: by 2002:a17:907:60d6:: with SMTP id hv22mr24847802ejc.438.1642580842262;
        Wed, 19 Jan 2022 00:27:22 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:21 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 05/20] trace-cmd library: New API to configure compression on an output handler
Date:   Wed, 19 Jan 2022 10:27:00 +0200
Message-Id: <20220119082715.245846-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
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
index bcc4c9f3..e22c3b7e 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -302,13 +302,14 @@ int tracecmd_output_set_trace_dir(struct tracecmd_output *handle, const char *tr
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
index c37fee1a..f13d2b8e 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -263,6 +263,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 
 	free(handle->strings);
 	free(handle->trace_clock);
+	tracecmd_compress_destroy(handle->compress);
 	free(handle);
 }
 
@@ -1341,6 +1342,55 @@ int tracecmd_output_set_version(struct tracecmd_output *handle, int file_version
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
 
@@ -1951,7 +2001,7 @@ out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 }
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
-						     int file_version)
+						     int file_version, const char *compression)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
@@ -1964,6 +2014,12 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
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
index 4cf48c86..ece5a0c2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4511,7 +4511,7 @@ static void record_data(struct common_record_context *ctx)
 
 	if (latency) {
 		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
-						      ctx->file_version);
+						      ctx->file_version, NULL);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
-- 
2.34.1

