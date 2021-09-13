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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520B5C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B21560FF2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239109AbhIMMna (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239085AbhIMMn3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:43:29 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDD5C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:10 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id m9so14500750wrb.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GysL5SYJIU/rSFQSYU0TJCpWOlQDAsa29SfJkSuSj2A=;
        b=JttTGDd76898bSrfzCpobCHcIKPLHliYaDUvAudyclF/u4A8cc6qmp171zTpMMCPZC
         Uf9aYuOmLvJgz1Tp1hB3nRcKGM1pIeWdkybuhlqF1y3dSJEIN/sm9tybPfAw+bfgInkR
         cuEySVMl6lJ7Ng5ihoUFUy5EOjrO7S8XjnjnYjPmlbnkQbE6Uq4WR6SvCrXkPZm3okdc
         8MwZKWMNWZs2GSDffovOM8wuHzK5KOfY99A1pk4FlrF5RDstPO4Pm2i4gJMcmi9VKsmz
         IAo8uUGKvKcbvdhKJfDX2735H4zUK6AQ5ShYFinAkCnXlNU8QwpDOfq5c3DqDbW7vjGO
         dOXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GysL5SYJIU/rSFQSYU0TJCpWOlQDAsa29SfJkSuSj2A=;
        b=BPOCEj63v/8P5NjKIg2EZ+PEu8sWTrnk0cVPgv++xdGzHwWD5bF7yrTNda2x950AjJ
         bxA8YzAN1S0uQod/bIwRKV2zbEzgonkHP3ON027t/q+52gv5PQ5y8B1ErhLXjlSQBMMc
         Fmeh3i3d1/TYPL5wa1C5hbO0bYmFpvPWZy1JSECrZs2oZYPKFPgkVyvqf1Seupc8lvjs
         fpSlSay6K88OFtzp4VIRZ7aP3vZu9Z1IrMN5Et9vG/stF8UskqgG9qLugMYg3wkkPUr/
         d9lkR9ztjBSLma3EmBQj/s5aynT/5Gp9RWsKBnaab4WdZ063C3d43P81U95Gl10uO1v8
         oXvA==
X-Gm-Message-State: AOAM532AUbGTnah2RxhLRgGgrulgyDfM2HwjtCqsYlOHql4fxu9vNdB8
        jelS1LQuNujdPZt+4lmD1jgG8Y0uP4c=
X-Google-Smtp-Source: ABdhPJwiAH36qFtIXmeDtnrXMhlzDxGgCSMA5xu1YIaa34cyq92UHR9mzSZc6A1e9fLhbg80/CnonA==
X-Received: by 2002:adf:f904:: with SMTP id b4mr12417570wrr.403.1631536929421;
        Mon, 13 Sep 2021 05:42:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u13sm7244290wrt.41.2021.09.13.05.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:42:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 05/20] trace-cmd library: New API to configure compression on an output handler
Date:   Mon, 13 Sep 2021 15:41:48 +0300
Message-Id: <20210913124203.3677760-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
References: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
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
index 30315c00..8f5408ff 100644
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
index a655d35f..802d35ed 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -234,6 +234,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 		free(option);
 	}
 	free(handle->trace_clock);
+	tracecmd_compress_destroy(handle->compress);
 	free(handle);
 }
 
@@ -1258,9 +1259,57 @@ int tracecmd_output_set_version(struct tracecmd_output *handler, int file_versio
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
@@ -1846,7 +1895,7 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 }
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
-						     int file_version)
+						     int file_version, const char *compression)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
@@ -1863,6 +1912,12 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
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
index 421bb7d4..fb6de81b 100644
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
2.31.1

