Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC82C28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239354AbiAZJtT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbiAZJtS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:18 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726CEC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:18 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id j23so63017742edp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ArlJQI5yeEdRvsif311poCbdWK60V5b7Z0DcRtpqzZM=;
        b=ajbkdmRoBAfxTouKqKnuGaYWVzas5Joq1myjONFnKPr3PFbCHa4vUGcUIz/A8+m3uJ
         XCHitDUiskaJUwvLQ4/ytK9jGuY5j6AMgUBaLLccSJ3/39JMRkD7fcuBIfiH31X4MCAk
         Mzv1vyTWg+3fsZ/8/hp36LhYdqu88mXs3QXfLYd5nu5MSeURGKDgTiWWS781vvePbNmp
         NpsEf97PePveXmmFoMFxqTmhJhNZAYr4uC9AcsCh87SHKKBntMm0AISSd3i6k5kgH2Vg
         URQad2PZ5ZXANv32iNG5xJglpAj5coukGbNaL8OOkTVSbsMGaLreP2KdybxG03vCMked
         2LXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ArlJQI5yeEdRvsif311poCbdWK60V5b7Z0DcRtpqzZM=;
        b=ehhkGpiNAL6hiyrOAsZt+iUcItANmC2L1sqyPJUv7w1OwASQFrcf7dZvzlXoCDRm26
         nrDgPGIJocxLXekyjXk8wXIjB1QxyUx6svwhOieN4t11zjKYV5e54c0sWma8NyNrqwAW
         nuE96hOsC2+UK8/1X4lcqUebxr7x749hlUc85it2zOtlEAHL7yQpULQZDkm+oJZ1CMYa
         YLE0CpvirSzfaeh2Z3/BKbC9ii/Cf9F4QGgiKdKL13T40U5Cbe4xcJ/8waqnKqRybe1O
         1eAMSU6QFWprJ8jKry05yhg9DAA2ootLMt96+SWjbInXhJuxflQIcJlQFFSIh2N1AVL7
         NM4g==
X-Gm-Message-State: AOAM533cfagbeyZWRB3O25E+C3PQvmK2EiAxlwMKfP3xbmmoPT5fOBOf
        D8SE1DRCiwsaBmMnMkxCo3WYO6ah+mg=
X-Google-Smtp-Source: ABdhPJxXoFEYPb9e0JvqKoIGrGS+IvKmTwjZ8em9AMJw0O/EVCZW7yg251q4ubGAUStC5hWzcnUG/g==
X-Received: by 2002:a05:6402:254d:: with SMTP id l13mr2651650edb.320.1643190556916;
        Wed, 26 Jan 2022 01:49:16 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 05/20] trace-cmd library: New API to configure compression on an output handler
Date:   Wed, 26 Jan 2022 11:48:51 +0200
Message-Id: <20220126094906.570451-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c                  | 60 ++++++++++++++++++-
 tracecmd/trace-record.c                       |  2 +-
 3 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 01c4c7a7..b5dbf56d 100644
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
index 2b511bfc..caa8cbc8 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -274,6 +274,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 
 	free(handle->strings);
 	free(handle->trace_clock);
+	tracecmd_compress_destroy(handle->compress);
 	free(handle);
 }
 
@@ -1353,6 +1354,55 @@ int tracecmd_output_set_version(struct tracecmd_output *handle, int file_version
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
 
@@ -1963,7 +2013,7 @@ out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 }
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
-						     int file_version)
+						     int file_version, const char *compression)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
@@ -1976,6 +2026,14 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	if (file_version && tracecmd_output_set_version(handle, file_version))
 		goto out_free;
+
+	if (compression) {
+		if (tracecmd_output_set_compression(handle, compression))
+			goto out_free;
+	} else if (file_version >= FILE_VERSION_COMPRESSION) {
+		tracecmd_output_set_compression(handle, "any");
+	}
+
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

