Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D569CC43217
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352407AbiASIZe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352405AbiASIZd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:33 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F06C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:32 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id a18so7549583edj.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8XtAVvd5pbChMCkMkMESo1+yjK+cNkhfagDnRZi2opM=;
        b=a/OvHkAdUUmz/hNOIDayRPStJR69eTVxN0tVFRExg/VOD340/lXlPsyWc2DJyzaRcG
         AloVaHkzS47w2YUI2gxMtlkc6+eDbD1puJfN8BnFGxbgKwujO95UYg5hHMe01JL3nkEs
         cb7LzUYtarvE7k9neASL1htv6csvPMbFcrP92k5h6qH+G7dd93rxzmXOdViZU7wiwyuF
         PRp9KTxjlKrn6tQv/px+OWavS/JUr0+Chtz7AqSKEkPo0YOtcRgdaJO6WA9vX+CwTFcx
         JkiVL4X/YnHPvXC1RVgLIPyl9UVTNFj82zpiv9//1gUrTc0mVaNU1eEV6jJSRN9TYMV7
         /eRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8XtAVvd5pbChMCkMkMESo1+yjK+cNkhfagDnRZi2opM=;
        b=MqiIO4r27jPXQumsrfnVBrOvZHPac8fnpqo6wNHTBkurEuuV/bTgRBbYqGR4et+0cR
         0I7btLnT+4yIU5of7LqEi9npcqOVRSK4HN00GCyrY49BX2nfwX4dHD40/JitQs6+4klZ
         cIv0t7jKTF+gdW11A21KA3He9nAMx6IMkgl6S9lB/gCP8acFcCeDqu+MQWuy2kJGswBa
         XD0qf05Ys0fEHQ9opR3q6DeetgWOCLJ9gIoCXTxvzBCyu0Z1/SfGVZeZ8rdrUtF6uT0T
         Dvck50tZlFa+iSExcJSBD1qvHwIc2Xkwe9PTYvbBpKE5lgPHQQDYchA9dUp52hJ1Fslm
         O7pg==
X-Gm-Message-State: AOAM5324DPOo8Y2L1S9V9MGnIBk8YbMtVf6PLJij692zsFCArqZb6ZWc
        YLUQ+pffcgPVuhnvXl3FVwhfvOWBpN4=
X-Google-Smtp-Source: ABdhPJxYzcoC/6igFrJh6x44ND1eG9w9n72bIjTddetaFIiiWOoWcbwyEdDYoCOHdgpDUNKfQO+Tnw==
X-Received: by 2002:a50:ce4a:: with SMTP id k10mr29586648edj.31.1642580731440;
        Wed, 19 Jan 2022 00:25:31 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:30 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 21/25] trace-cmd library: Handle latency trace in version 7 files
Date:   Wed, 19 Jan 2022 10:25:03 +0200
Message-Id: <20220119082507.245600-22-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
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
index 94b33949..1efafba1 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -227,6 +227,8 @@ tracecmd_peek_data_ref(struct tracecmd_input *handle, int cpu)
 	return rec;
 }
 
+int tracecmd_latency_data_read(struct tracecmd_input *handle, char **buf, size_t *size);
+
 struct tep_record *
 tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record);
 
@@ -301,7 +303,8 @@ int tracecmd_output_write_headers(struct tracecmd_output *handle,
 
 struct tracecmd_output *tracecmd_output_create(const char *output_file);
 struct tracecmd_output *tracecmd_output_create_fd(int fd);
-struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
+struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
+						     int file_version);
 
 struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
 					    unsigned short id, int size,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 103ff7bf..6f540c90 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3214,6 +3214,24 @@ static int read_options_type(struct tracecmd_input *handle)
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
@@ -3276,6 +3294,12 @@ static int init_cpu_data(struct tracecmd_input *handle)
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
@@ -3290,7 +3314,10 @@ static int init_buffer_cpu_data(struct tracecmd_input *handle, struct input_buff
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
index fe4fcf64..15baef8f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1890,7 +1890,8 @@ out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 	return option;
 }
 
-struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
+struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
+						     int file_version)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
@@ -1901,6 +1902,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (!handle)
 		return NULL;
 
+	if (file_version && tracecmd_output_set_version(handle, file_version))
+		goto out_free;
 	if (tracecmd_output_write_headers(handle, NULL))
 		goto out_free;
 	/*
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f599610e..2dea79dc 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4501,7 +4501,8 @@ static void record_data(struct common_record_context *ctx)
 		return;
 
 	if (latency) {
-		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count);
+		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
+						      ctx->file_version);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
-- 
2.34.1

