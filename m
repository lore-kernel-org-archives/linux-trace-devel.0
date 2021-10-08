Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD29C43217
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08D3061090
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbhJHEYT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbhJHEYS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:18 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8846C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:23 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r18so31297197edv.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e5RPV7v8rnimg5v9gzfZIlUzgwnYJDHlYLlGtbei0HE=;
        b=DRAqh5uE5l3y+xMbPfDGfcn6t1dCb3cp2wTMMMqziGCX03zAMW9+oMk7GIjPaRjD6C
         OD6YQuacujmEqSfoxl5jETUwvldTu0HlFZNIT9e5S+toI/VhoOBhYNqxXt3mbJgYXj8n
         nIb3aKRM6G0P42iomqFEeCsAtWc4yvBl/b0u/V1MFQId34FxbgDaZEW6jnOYj9iPQ2es
         GBGD4xyKAvmZN1kzsYIjANaxxREUiFp5e/OFz22mLcJ9GQJJCYP3p+r8s6BBii9jowd8
         Ohi98spmxncnHUgF29t34OpWXKQfqiu1isKo/HFkKIZpKDCO/ztNKVfIQVZmVIRmH9XL
         Uh0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e5RPV7v8rnimg5v9gzfZIlUzgwnYJDHlYLlGtbei0HE=;
        b=ZIyL9Tw0dFAgtAUyTgF/cRLBanmRmXYsdPaZr5XGpvvR7dSUTrIBPuM2cu6d4vBWd5
         5UmtCkblkN6KmGrd4+hDDZHuDACLqShNcbCRSxm6XHtMT8hJPJlRsNpZYEMVtWjEo0sq
         IBOn8435q5LwiQvFeMdNyoPluD0/cpWJY9Jxg//RMvSHHmOHm8dE6IYnfGhS9Bow3jkH
         R/4LiQf2ksEfpg8JlUGUPtTDLXxSx4ellUjfMShdxjL0r0SOG1uhu06CvaDQMlRYagbA
         msux2c1pwE/dD6Afz+2virCx8h8C9aeQlYVFcwk7QiBALEv+FF0Mm2loiBPzuDsxIPLM
         57GA==
X-Gm-Message-State: AOAM533TldVtSDDJaeJnwnpSArRtWS1WzhpiNZrzTuY07Tb6FWicxlnn
        gy18gb0dJvzGydE1/3VHSOqRR/peyTXb/A==
X-Google-Smtp-Source: ABdhPJylqiwrswmTJFIt5icgKRK6SQab4Bm5rdO3gxVy5JnMVqbYlyvQQzdiCTzcja1+s8Cp4b7UFw==
X-Received: by 2002:a17:906:f243:: with SMTP id gy3mr1316161ejb.327.1633666942224;
        Thu, 07 Oct 2021 21:22:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 05/20] trace-cmd library: New API to configure compression on an output handler
Date:   Fri,  8 Oct 2021 07:21:59 +0300
Message-Id: <20211008042214.977193-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
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
index 816db13d..f3afa7e6 100644
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
2.31.1

