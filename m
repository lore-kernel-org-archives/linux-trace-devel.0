Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9567FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237293AbhLJK6p (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232982AbhLJK6p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:45 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A442C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:10 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id y13so28244546edd.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CVeuaAR94T1feZiC6b333lXWv0fJ7x4GdshqDIAyzpo=;
        b=BK1nvLxxo8M7p2bEj3vuJWJiRG0f9F29oRQGpL2kfDjsQdLb98M9nBvu0KdwVl53f7
         n10ZrdstivlzTn+/XcQg846Qgx1VnKtiyhiP8WuihtA6VBmX042bbowreqZ4p5GQ1ZB/
         F4H0xQIR1NgoQMX8aWtd9hXQ/Eb3nl3LCS2QyEDY3/VlQbw2ETeHju+ZcD+qw2x0O697
         TeVmQD9y3usnXxb9BKseYsPnhrya3n3wdWPpBCzl4kOtBM774iivFkn3TV7ZgYnD+3dd
         DOzb02rjvRs/12p/aRg8Vo2Rnymf/kKUEf4VNlAKcB/GYTooU+aAL3mVQd/okY6Tw6tT
         ADgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CVeuaAR94T1feZiC6b333lXWv0fJ7x4GdshqDIAyzpo=;
        b=yenSjdc2CXPDnacltIKVtjM1K8nvZSmyh5pFGPLREgDTfJ4iQzX22Yc+l9kjLeQPLM
         fMwBePPbmAaT9LdrAh+7UL4PcAVfVOm/qr78gnB0KFXe1ay3qsA6A7XdOWtJWTLwgdhe
         XNti8IM3oj/r/McGxou72Vs3+RHmMCtnvaar28fSSAbF1afJdf8Y7Z1M1QxFIFUSi3k8
         7aWDblLdii3TdlRVrfum8f874bGDCvBeiJ0zWmR7MWxvvWs7EI80x4k7ganG8r3uUoFz
         gYs+26CaLI4/fv0JkyQFFClT5gFyGyzelg5iUjEHRvmYyWsjdZ+yElIwakfeTiFgifZn
         2dGw==
X-Gm-Message-State: AOAM532JAQb5d9mhGJVeUgHSGHI95/DZv6UWpCVrKcRM3eHFromkeKQY
        HpXDSvMsWJzC5MAd2NkedVCk50Eh1y0=
X-Google-Smtp-Source: ABdhPJyNZkaMFSwclgP20Vfk3sslnwVyFlXpXT6PdJg8lKGBwhRMZw+4mQ4WKr+E7WEo1RI/cFIImg==
X-Received: by 2002:a17:907:6e91:: with SMTP id sh17mr23744964ejc.86.1639133709119;
        Fri, 10 Dec 2021 02:55:09 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:55:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 21/25] trace-cmd library: Handle latency trace in version 7 files
Date:   Fri, 10 Dec 2021 12:54:44 +0200
Message-Id: <20211210105448.97850-22-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
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
index 2e0c32b6..6fa3ca3a 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -222,6 +222,8 @@ tracecmd_peek_data_ref(struct tracecmd_input *handle, int cpu)
 	return rec;
 }
 
+int tracecmd_latency_data_read(struct tracecmd_input *handle, char **buf, size_t *size);
+
 struct tep_record *
 tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record);
 
@@ -296,7 +298,8 @@ int tracecmd_output_write_headers(struct tracecmd_output *handle,
 
 struct tracecmd_output *tracecmd_output_create(const char *output_file);
 struct tracecmd_output *tracecmd_output_create_fd(int fd);
-struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
+struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
+						     int file_version);
 
 struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
 					    unsigned short id, int size,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index fe3d6e77..5c900e94 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3203,6 +3203,24 @@ static int read_options_type(struct tracecmd_input *handle)
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
@@ -3265,6 +3283,12 @@ static int init_cpu_data(struct tracecmd_input *handle)
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
@@ -3279,7 +3303,10 @@ static int init_buffer_cpu_data(struct tracecmd_input *handle, struct input_buff
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
index 1fa83e93..38a0699b 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1872,7 +1872,8 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 	return option;
 }
 
-struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
+struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
+						     int file_version)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
@@ -1883,6 +1884,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
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
2.33.1

