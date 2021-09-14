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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB41AC43217
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C349F60724
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhINNSL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbhINNSK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:10 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBF2C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:53 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id d21so12468775wra.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RfqiSNfAxwO7yHzNNGqqUA/eKrI3uCiNUxgmJyywPk8=;
        b=expFe/il4E14UNai57r+PXzGTRNzjPdgwhvxUUYM32KQyNSkFf27jKDUNX1V5XgBED
         l6aXmwFP8ro3zI+dJhdlZSqrQQ868CJdgsjUK6vCBfnfdW1KfORKTruH2nBn8e8f9O1f
         mJ6/j1E4GKvnGlmOmZHTyDWZ+20EoCX3pYGa/qJGdDFCP19A6Y1R+gjlfp5iVTGsQ0tw
         7j2te6VjtN7sZWpC5IcFdYDXywUL039Yuq9UMJuiU6dqBzLxXtBCVM5cOmcP0AFO218v
         UiX6Yz7MQehpxakwkNvDmz5yx1m+a7K2LPzitc3S9FC33BlJehZJHT7291f8srO7o9iX
         KiXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RfqiSNfAxwO7yHzNNGqqUA/eKrI3uCiNUxgmJyywPk8=;
        b=CalnZG9zhhdjnn4X0IGc9PeeqAazrUCKd7jXGE9AefR7umkK2oQNC6eMRCXiR3DS+o
         Yg7u6YfVyX1I7eKYZl/4c2ZDhqwwYc+VG481auAgDS5ypyrjaMedyikKmmQLqWcPZYuV
         vBfa5vEFVGGwogMeJth0e7aom17B2nXUUFIQJ4AKRNarVfz+tpN9BzX7wx2YXO8O28Gk
         YgzCdZcAllGh/Pp68O0OfVNt3o+IhM02YKHLsOiRKyMlrw6WKCVCxtzOcHt3dnrkZhnu
         3DS17mYHoZZEOQMCD1iIBJM04UBRtNNG4Nc77Fw3CeJBTGkfUi3u47VwNjA2m3ivfKr3
         OPeg==
X-Gm-Message-State: AOAM531mi9S09dESaWNdeWeg+HQiTidFhplOvFx1VRALlPeHfN6hTd+m
        tDUmQn2+F09sONuKrL02EnLyqoZiDGQ=
X-Google-Smtp-Source: ABdhPJytkGjtJ4n060uoZGAOT15Ugf3/7ZqI1gd4TE3lAEqSIfBZLNFYiYpRO+iqGmOvL1Qwhvn1hg==
X-Received: by 2002:a05:6000:1623:: with SMTP id v3mr19124788wrb.288.1631625412206;
        Tue, 14 Sep 2021 06:16:52 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:16:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 05/20] trace-cmd library: New API to configure compression on an output handler
Date:   Tue, 14 Sep 2021 16:16:30 +0300
Message-Id: <20210914131645.3966308-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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
index edf05cfe..c15c6979 100644
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

