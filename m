Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B54C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD6FF61252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbhKKPO0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233978AbhKKPO0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:26 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2BCC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:36 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id v11so25472765edc.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DwtwwL7dh2VcFONxh8gCuF0yFXryF4H9/KX4SKY0LRs=;
        b=YQb/Ro//ZoyUucLei3sypfNAGkHlC5gPoNZ/zfcZzn7N5Mr9ohKdEKzmh0htki8YFA
         84PPpIHGy0v+Tpo3OopWlJ2ar9MhZhmcPRfAPSGq3qP+vud5DwT3wxnkvqjoWt8QMlrZ
         MrWtSVCGOG72i1OHEZDI1JXibRNXqY3UpPnu+NjlLC8fnpa7VJyjz1u0KhzJ/X3qdvrc
         fdAcundGI6tyTwZLxbqktdKfEj+nCH1mJljWZIZZmnLjByD4aj9sPXbF9G6eAjkkpBmT
         JVDdmTt9tpOxmBSrzWgpgLG3bUuQO24CRBtqiiVSyYseLMWlDqE8HFoA5ky0dcZnGLmJ
         3NYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DwtwwL7dh2VcFONxh8gCuF0yFXryF4H9/KX4SKY0LRs=;
        b=bnxEECdiJJ+1nVaZyUTU6JsGUljUbiM/xGnO3aYzjpgh+0N98IT9g+FI6lzIAwWio2
         xHlCxQHyNmMzOBGVfm14re/Z56+wQuL5LPO4RYmseMLe+jGTiusa9JwuXxr4w0jMUN1Y
         Ts1tXH/hBInXfOCjKiIq7tIVRLDipL19e1AxAXEUWsR+02XRFgHf/bRPO/noQpU9mBJH
         pWkjNovk3zspnYqOmjhwrq7Rnt9CMYoPxsCGaO/InIrO3aqGyO1U34bq0+qJYyA0bSWV
         m/iepdr0uBbmzx0n0Q7rfSBLZSEah1KVkNXGruYCE0SYivZoJa9ovti9ofRUdDCU/EWU
         SpOg==
X-Gm-Message-State: AOAM532/lMfVqe1BC7BiWbRyAdRO6EkFqfd+CpsU8OBj9OOMFR+sO+Lr
        5iEmJ4PSR1e3Cb4nxARMC8r4bS5SIKA/1Q==
X-Google-Smtp-Source: ABdhPJw/NFP85PTrk2JGbYkmLiF0FJE+IctxC7ItE0B1anDAqF/PfF/fRe5WSkCAlQsWl1KITZmB4Q==
X-Received: by 2002:a17:907:20e8:: with SMTP id rh8mr9916437ejb.437.1636643495514;
        Thu, 11 Nov 2021 07:11:35 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm967018edu.57.2021.11.11.07.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:11:35 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 21/25] trace-cmd library: Handle latency trace in version 7 files
Date:   Thu, 11 Nov 2021 17:11:29 +0200
Message-Id: <20211111151133.86788-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151133.86788-1-tz.stoyanov@gmail.com>
References: <20211111151133.86788-1-tz.stoyanov@gmail.com>
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
index 1a43b7e3..879640ac 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -221,6 +221,8 @@ tracecmd_peek_data_ref(struct tracecmd_input *handle, int cpu)
 	return rec;
 }
 
+int tracecmd_latency_data_read(struct tracecmd_input *handle, char **buf, size_t *size);
+
 struct tep_record *
 tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record);
 
@@ -295,7 +297,8 @@ int tracecmd_output_write_init(struct tracecmd_output *handler);
 int tracecmd_output_write_headers(struct tracecmd_output *handler,
 				  struct tracecmd_event_list *list);
 
-struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
+struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
+						     int file_version);
 struct tracecmd_output *tracecmd_create_init_fd(int fd);
 
 struct tracecmd_output *tracecmd_create_init_file(const char *output_file);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 5d9f24e8..5efa4859 100644
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
index 1d666775..e06931ce 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1778,7 +1778,8 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 	return option;
 }
 
-struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
+struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
+						     int file_version)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
@@ -1793,6 +1794,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	handle = tracecmd_output_allocate(fd);
 	if (!handle)
 		goto out_free;
+	if (file_version && tracecmd_output_set_version(handle, file_version))
+		goto out_free;
 	if (tracecmd_output_write_init(handle))
 		goto out_free;
 	if (tracecmd_output_write_headers(handle, NULL))
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 32270e20..0b1dc508 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4505,7 +4505,8 @@ static void record_data(struct common_record_context *ctx)
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

