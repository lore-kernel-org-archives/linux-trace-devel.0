Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0566C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD1E3610D0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbhKKPOw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233978AbhKKPOv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:51 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8C5C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:02 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id v11so25477786edc.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hRYBW6PEQfSvGIKur4/uHch0dizs5En44cTOlYvvvzs=;
        b=LePIno0qxhvBsm4u96ahwxA+du95kFB0wbRv0c5Y/nTyPZErMQQCmMMuCfH+emj8hB
         nRL/k4I7dvQn0/gkCOgdLD9TS4MibmSnnv09onp9f6OLmPu4jXSsO2wjVH7navXRJFf8
         HGOfoFgF0XMAIy7GQG9KaVrRkSCqcRuetgBV+fXXJePp8pGElWObQAXIsSnaOg7tp+7h
         bmOcK9e5QAzFyNtQhBT/MU3Fvm/whnzlEivAieY13nS7G7nRoERLlnv/BPKG2R9uf1Tr
         z4shiOYqn5MOSNGJUBPAhJxP1xnNejx1cpn3UsH0SuHJWcJCDlfiubCxkiJw5S6rfXBD
         FK5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hRYBW6PEQfSvGIKur4/uHch0dizs5En44cTOlYvvvzs=;
        b=brR1bB/eXZoewrt5T4QCDuK6xYUrsX3tyvilNCSr+J5kkv9cfHtq2QLeuw2lS+FluY
         YQ8VohxcmZOURx3MZ0911KA3FfZkOMH6e2Z375muBLUfXXKA3s5LnrywNZ1jE0KLiMMR
         +BIl1cN0VNdiTze2f0T9BkxgG7ljmIhrkBQfWU2AfB00cmV5Jbt44XGctHzcHIztuHlh
         X6AyJ/xYcMXOEHxrjRwJzvutCiSp2ZT3bfUhOLRdbQbpatLaHSoXoVzXVeukNodCYpTl
         VE9xByKYEML8swR5QUd57S2r+bzh4YfLiiRUgIuozzZCfRRB9i5s2WDTFvWz0ECG6cX5
         bJqg==
X-Gm-Message-State: AOAM5308VI62qMB/w7sIzBuxc+ax7Jwqzx5lQpFKirIZBDV+QT9u2TuJ
        R+TpgAMm4lK/oWFd0E0+KJejVMSfYiXXGQ==
X-Google-Smtp-Source: ABdhPJzLJZbzeln+QtvNi7mCS4xRQ2/6quLFB5kzwR0ADdPT/WWOZzSTQeLswaMu2bbf6eh55ycQXg==
X-Received: by 2002:a05:6402:10c5:: with SMTP id p5mr10767802edu.150.1636643521068;
        Thu, 11 Nov 2021 07:12:01 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qf9sm1479509ejc.18.2021.11.11.07.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:00 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 05/20] trace-cmd library: New API to configure compression on an output handler
Date:   Thu, 11 Nov 2021 17:11:38 +0200
Message-Id: <20211111151153.86855-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151153.86855-1-tz.stoyanov@gmail.com>
References: <20211111151153.86855-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API can be used to configure compression algorithm on an output
handler to a trace file.
 tracecmd_output_set_compression()
The API for creation of latency trace file is extended with compression
parameter.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  3 +-
 lib/trace-cmd/trace-output.c                  | 57 ++++++++++++++++++-
 tracecmd/trace-record.c                       |  2 +-
 3 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index d5aea618..b44a6e58 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -297,12 +297,13 @@ int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *t
 int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms);
 int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle);
 int tracecmd_output_set_version(struct tracecmd_output *handler, int file_version);
+int tracecmd_output_set_compression(struct tracecmd_output *handler, const char *compression);
 int tracecmd_output_write_init(struct tracecmd_output *handler);
 int tracecmd_output_write_headers(struct tracecmd_output *handler,
 				  struct tracecmd_event_list *list);
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
-						     int file_version);
+						     int file_version, const char *compression);
 struct tracecmd_output *tracecmd_create_init_fd(int fd);
 
 struct tracecmd_output *tracecmd_create_init_file(const char *output_file);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 8f822323..6119721c 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -234,6 +234,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 	}
 
 	free(handle->trace_clock);
+	tracecmd_compress_destroy(handle->compress);
 	free(handle);
 }
 
@@ -1251,9 +1252,57 @@ int tracecmd_output_set_version(struct tracecmd_output *handler, int file_versio
 	if (file_version < FILE_VERSION_MIN || file_version > FILE_VERSION_MAX)
 		return -1;
 	handler->file_version = file_version;
+	if (handler->file_version < FILE_VERSION_COMPRESSION)
+		handler->compress = NULL;
 	return 0;
 }
 
+/**
+ * tracecmd_output_set_compression - Set file compression algorithm of the output handler
+ * @handle: output handler to a trace file.
+ * @compression: name of the desired compression algorithm. Can be one of:
+ *		 - "none" - do not use compression
+ *		 - "all" - use the best available compression algorithm
+ *		 - or specific name of the desired compression algorithm
+ *
+ * This API must be called before tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 in case of an error:
+ *   - the output file handler is not allocated or not in expected state.
+ *   - the specified compression algorithm is not available
+ */
+int tracecmd_output_set_compression(struct tracecmd_output *handler, const char *compression)
+{
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+
+	handler->compress = NULL;
+	if (compression && strcmp(compression, "none")) {
+		if (!strcmp(compression, "any")) {
+			handler->compress = tracecmd_compress_alloc(NULL, NULL, handler->fd,
+								    handler->pevent,
+								    handler->msg_handle);
+			if (!handler->compress)
+				tracecmd_warning("No compression algorithms are supported");
+		} else {
+			handler->compress = tracecmd_compress_alloc(compression, NULL, handler->fd,
+								    handler->pevent,
+								    handler->msg_handle);
+			if (!handler->compress) {
+				tracecmd_warning("Compression algorithm %s is not supported",
+						  compression);
+				return -1;
+			}
+		}
+	}
+	if (handler->compress && handler->file_version < FILE_VERSION_COMPRESSION) {
+		handler->file_version = FILE_VERSION_COMPRESSION;
+		if (handler->msg_handle)
+			tracecmd_msg_handle_cache(handler->msg_handle);
+	}
+
+	return 0;
+}
 
 /**
  * tracecmd_output_write_init - Write the initial magics in the trace file
@@ -1839,7 +1888,7 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 }
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
-						     int file_version)
+						     int file_version, const char *compression)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
@@ -1856,6 +1905,12 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 		goto out_free;
 	if (file_version && tracecmd_output_set_version(handle, file_version))
 		goto out_free;
+	if (compression) {
+		if (tracecmd_output_set_compression(handle, compression))
+			goto out_free;
+	} else if (file_version >= FILE_VERSION_COMPRESSION) {
+		tracecmd_output_set_compression(handle, "any");
+	}
 	if (tracecmd_output_write_init(handle))
 		goto out_free;
 	if (tracecmd_output_write_headers(handle, NULL))
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index fab34361..699fa511 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4516,7 +4516,7 @@ static void record_data(struct common_record_context *ctx)
 
 	if (latency) {
 		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
-						      ctx->file_version);
+						      ctx->file_version, NULL);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
-- 
2.33.1

