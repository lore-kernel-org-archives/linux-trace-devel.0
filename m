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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05380C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3B1A610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhINNQ0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbhINNQ0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:26 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3359C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:15:08 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d6so20139901wrc.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lNiHFGAi6rFItmFwzhQM7pzcHo1dNW3NyHEcsDYYd/E=;
        b=HkX/qDd1YkLZu8byfaQdhcCr2C1NNyPWpz5IQeYPfMH6B2YqmBmZ+ZWhTBOQORxbfz
         bARL6MaSkbba1FqkWVOxEL1kMY85D1xTavLoVLi9zTg7YuMMPnzBsiSxDa/+u2LDi9Pw
         l+JUCrRzPk0ybAyMh6mAr5CURlCY335fsoW1W4a96tt1M4ZsOu/F3Z97Ue3DMBtTPVnH
         i4h6EndwLeJLUxRm3vumKesLXUiPZYz56jHU7+fkhPS89ShdhG9uIjZ0rnmrN5+jGsad
         6QS2oVVd919d5PfoBGGfClC8ENA2A6q354freoZf5smM7kWRknu5nt2WJx0mWpiU7jzF
         57fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lNiHFGAi6rFItmFwzhQM7pzcHo1dNW3NyHEcsDYYd/E=;
        b=cuafA8nde9fCApB3hB3yWYQh3jLse0bCTJLRfSoMG3AdDU6J4vYAMn+QvtD/9fSFVX
         RnSA1rPK9/T8WvawWx02K5m+FHP8S5Lhlr3y8SDty99etWDKFUkZR9zqjkHUt+YJKbq3
         kGrOoTUh1hXKS3YxjaQeI/k8UsG/L7ZCP9bwlo3ocTJl+YYq5yF33GJoVBs0Aywu9IXK
         8uj8zzrE2WAtfVy64D8+sphxkWi3a4X/rxWlQ/AevdwZdBW4OHGAGOqsXOwI6oBgXhqc
         8TLhJW2ccsuLbNOjr4jj46QJHBj9V7hocTZ5Z23iXcA27AuzLIKrd8bqeOqQt+oD31vb
         kPdw==
X-Gm-Message-State: AOAM531rOn1Prq5TqlfeY6sbMqeNFvchnFiy2Csvix/Nws0lNk7ywLfb
        t2u7PMGw8tjYnyf3UH/XGdAARFMWWUs=
X-Google-Smtp-Source: ABdhPJzgBBBUnV4i3Eu1HY69SAJCuD29bQ1RwXXDicMQxARTIwwQnQX2wKz1m5yNdquVdgxAjw6mNg==
X-Received: by 2002:a5d:4bc8:: with SMTP id l8mr19288416wrt.105.1631625307447;
        Tue, 14 Sep 2021 06:15:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:15:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 21/25] trace-cmd library: Handle latency trace in version 7 files
Date:   Tue, 14 Sep 2021 16:14:34 +0300
Message-Id: <20210914131438.3965484-22-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
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
index a08890df..045fd5a1 100644
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
index 87c33423..1b4a4d6b 100644
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
index b3904204..645a8ab7 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1786,7 +1786,8 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 	return option;
 }
 
-struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
+struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
+						     int file_version)
 {
 	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
@@ -1801,6 +1802,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	handle = tracecmd_output_allocate(fd);
 	if (!handle)
 		goto out_free;
+	if (file_version && tracecmd_output_set_version(handle, file_version))
+		goto out_free;
 	if (tracecmd_output_write_init(handle))
 		goto out_free;
 	if (tracecmd_output_write_headers(handle, NULL))
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 879acb7c..af7f332c 100644
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
2.31.1

