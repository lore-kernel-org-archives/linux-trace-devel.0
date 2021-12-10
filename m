Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8527EC43217
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240099AbhLJLDU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbhLJLDU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:20 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D69C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:45 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id z5so29196398edd.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tEv+d2Yp4nwWrdZaUchV59IXo+3StH/VDh4Teg9zL+Y=;
        b=Ck26dCnAw6M40BU1oHnnghBtHh2wMyTUtfeZdPBR1iGkVCzlmFVoL0eoIR5AujTQKj
         wl+IEjaOpDX7ombPzSj3y2THRlNj/RnWEkF4SOaltNO7b1ULJ5E4R1lUdBvmFVQAxg+B
         pX2cwcfG1BEtEN/p0Ax/CwT5mzNKkPByCSinoR75RLerqkzQ6e8FSJ6D66isEU6Pasuw
         TBDmLG6/CXygKCGr/SmEORHzc01YBw2gl4zAUugzS2oRPpsaBdF+1RZo10SP8h5GvP9S
         M7z+tUTSY9nXsDIVwcz1GTUgxRU/Yz8xGnxmvNZm/JGzCwTzUQaZTGFGvKCJcvoQ+nIO
         /HJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tEv+d2Yp4nwWrdZaUchV59IXo+3StH/VDh4Teg9zL+Y=;
        b=ykqYL/w7GjRZ/Wzx8sKE4c9L2ke+gNyqGizXzL3/ZsdowVrtPFJzIpjdgi5LNXK9hE
         A/DqjCIMMplRwROzMwuKZ6V1AwBHQhYMeBFQJD5FZhjT5qYoUBtxNMC88ug5e1APejo3
         41jYwDTMGNCpk/eip3LsJdvfbQF1ZqLtOVaNYOXwcQoQHLY8t/UBTrGYprRLqX1koDJt
         7AuSTbvnsMFlrkphlk+BbQjAIftCw+kpsjWlbTcw5/WRDaN7cEF2T6dV5far5x4nVd4v
         6lJAqXLOKc68xGesyj7YyPUueJjFS6EawqNmack51C1PbheKDr2zW8NANSFIhtJ0roO0
         20hQ==
X-Gm-Message-State: AOAM530LY8r5u/Idx7cYx7/Kmve+SzHi4e5pmUswlwDJAgFFr0AkWZBO
        Klc8QdQL0RbF7asMPr7YnzyyTzaqSm0=
X-Google-Smtp-Source: ABdhPJwVYnLm1S2iV3yhTSPAXPU6Ui5bdBdBi8RUOEdN+CtE2rI3C0De76ltg727sq96INxyKhIV7g==
X-Received: by 2002:a05:6402:3496:: with SMTP id v22mr36562591edc.177.1639133984138;
        Fri, 10 Dec 2021 02:59:44 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:43 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 05/20] trace-cmd library: New API to configure compression on an output handler
Date:   Fri, 10 Dec 2021 12:59:23 +0200
Message-Id: <20211210105938.98250-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
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
index 924efeeb..c385c6db 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -297,13 +297,14 @@ int tracecmd_output_set_trace_dir(struct tracecmd_output *handle, const char *tr
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
index a4d29d8e..9c996cd0 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -258,6 +258,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 
 	free(handle->strings);
 	free(handle->trace_clock);
+	tracecmd_compress_destroy(handle->compress);
 	free(handle);
 }
 
@@ -1336,6 +1337,55 @@ int tracecmd_output_set_version(struct tracecmd_output *handle, int file_version
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
 
@@ -1933,7 +1983,7 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 }
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
-						     int file_version)
+						     int file_version, const char *compression)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
@@ -1946,6 +1996,12 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
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
index 1b806e78..21937562 100644
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
2.33.1

