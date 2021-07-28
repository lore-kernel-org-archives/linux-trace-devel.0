Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD41BC432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99BE361019
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbhG1Nd1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236645AbhG1Nd1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:27 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746F4C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:24 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id qk33so4575488ejc.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=09FaF4ZoHaHVUGUgFuS3lYTOmsYFHWJ751RiZ3S/Oqg=;
        b=H3MUDdYhZupxQ7IeiEiGW/CdpZPPtH1Yqdp+Dj/+FJAT44qKHbp2Mx9dLFw+vEX7Ns
         y7yQ4m0pZyU74sRexSXnQnm39q4xJYeavrk/yAnxHYLtBKhNn/HVGZLdn8o1+BSnkDlM
         lmrOSajJs4FGBhwiMg31RkKWA7x7HhsBAFFFePEdoAK8S0mQFFI5mS1Zbv7kCc61l0px
         JluCIT3smLX6KX1wcPuT5T6wxO/NaB3BUmA6+iArNaeFXCoi+OAO9aXgY+2KYvFgyBuU
         DoMi53jFXtG/VxHzRNTtwG0Bkh6uRw8BuJVDL0AXrkaXvAKd3fyTsOzmEPgE/Ujkn8iy
         Turw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=09FaF4ZoHaHVUGUgFuS3lYTOmsYFHWJ751RiZ3S/Oqg=;
        b=dEeX76hwyH6ESLJbNma8/pNJ5K6Go/rYdGKNiHvAk4EGdMT4LYtAromov1FgPKyvgJ
         hZ6v/0l93PSdbH6ABL2gbduEaBRwe9pNhxzYlaoy6N7sO6uTab15p1KDsfjPF3CtAI+I
         BkDE36gjt1mgU6zSOjLpcNc2M+d6tdvPbLBZBUUoe5bDS+KQFJXz3SXprNqg7mnsnFF/
         jHRpmmwE/f4ynhZEn/VGK678ip1+yy/ESf7xrmpgIUe6Zl7EwRcu+Jhm1JmX0hRKXh4F
         M4m7N+4V+LvHqPCEISyDdh2S3fSz/GneNqDLfMxkT01/J7tHhfMGHcrRQPkg9vg4lbka
         ZCsg==
X-Gm-Message-State: AOAM530jlINqcl6EHsaEyBr+L3vX0SGRJ0J2JDhZ9ZhWVSNxyV2GNaUS
        8ilgwdAq1JKqS+XbDPHpAvw=
X-Google-Smtp-Source: ABdhPJwe3PWfNmMa+BLlySf/XJ0BkIKLA5ohT4bldOIPk+wb2mIwwRNGCn+afV9jGxbQa9QZ1pbDng==
X-Received: by 2002:a17:907:7e9a:: with SMTP id qb26mr27619384ejc.490.1627479203107;
        Wed, 28 Jul 2021 06:33:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 31/87] trace-cmd library: Fit CPU latency trace data in the new trace file version 7 format
Date:   Wed, 28 Jul 2021 16:31:54 +0300
Message-Id: <20210728133250.234140-32-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 format is based on sections. To fit the latency
trace data in this structure, a new section and option for it is
defined:
  BUFFER_LAT
It is similar to the BUFFER section which holds the flyrecord data, but
has a latency specific design. The BUFFER_LAT section has:
 - section header, as all other sections
 - compression of the trace data, optional
 - corresponding trace option, pointing to the section

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  3 +-
 lib/trace-cmd/trace-output.c                  | 36 ++++++++++++++++---
 tracecmd/trace-record.c                       |  2 +-
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 4e718c40..f2868576 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -135,6 +135,7 @@ enum {
 	TRACECMD_OPTION_TIME_SHIFT,
 	TRACECMD_OPTION_GUEST,
 	TRACECMD_OPTION_TSC2NSEC,
+	TRACECMD_OPTION_BUFFER_LAT,
 	TRACECMD_OPTION_HEADER_INFO,
 	TRACECMD_OPTION_FTRACE_EVENTS,
 	TRACECMD_OPTION_EVENT_FORMATS,
@@ -294,7 +295,7 @@ int tracecmd_output_write_headers(struct tracecmd_output *handler,
 				  struct tracecmd_event_list *list);
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
-						     int file_version);
+						     int file_version, const char *compression);
 struct tracecmd_output *tracecmd_create_init_fd(int fd);
 
 struct tracecmd_output *tracecmd_create_init_file(const char *output_file);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index e027dd93..e6dadba5 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2030,9 +2030,11 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 }
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
-						     int file_version)
+						     int file_version, const char *compression)
 {
+	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
+	tsize_t offset;
 	char *path;
 	int fd;
 
@@ -2045,6 +2047,12 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 		goto out_free;
 	if (file_version && tracecmd_output_set_version(handle, file_version))
 		goto out_free;
+	if (compression) {
+		if (tracecmd_output_set_compression(handle, compression))
+			goto out_free;
+	} else if (file_version >= 7) {
+		tracecmd_output_set_compression(handle, "any");
+	}
 	if (tracecmd_output_write_init(handle))
 		goto out_free;
 	if (tracecmd_output_write_headers(handle, NULL))
@@ -2057,7 +2065,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	if (tracecmd_write_cpus(handle, cpus) < 0)
 		goto out_free;
-
+	if (tracecmd_write_buffer_info(handle) < 0)
+		goto out_free;
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
@@ -2067,23 +2076,42 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 		goto out_free;
 	}
 
-	if (do_write_check(handle, "latency  ", 10))
+	if (handle->file_version < 7 && do_write_check(handle, "latency  ", 10))
 		goto out_free;
 
 	path = get_tracing_file(handle, "trace");
 	if (!path)
 		goto out_free;
 
+	offset = do_lseek(handle, 0, SEEK_CUR);
+	if (handle->file_version >= 7 &&
+	    !out_add_buffer_option_v7(handle, "", TRACECMD_OPTION_BUFFER_LAT, offset, 0, NULL))
+		goto out_free;
+	if (handle->compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
+
+	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER_LAT,
+					  "buffer latency", flags, false);
+
 	copy_file_compress(handle, path, NULL);
+	if (out_update_section_header(handle, offset))
+		goto out_free;
 
 	put_tracing_file(path);
 
 	handle->file_state = TRACECMD_FILE_CPU_LATENCY;
 
+	if (tracecmd_get_out_file_version(handle) >= 7)
+		tracecmd_write_options(handle);
+
 	return handle;
 
 out_free:
-	tracecmd_output_close(handle);
+	if (handle)
+		tracecmd_output_close(handle);
+	else
+		close(fd);
+	unlink(output_file);
 	return NULL;
 }
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f8c1c090..2e8db8a4 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4531,7 +4531,7 @@ static void record_data(struct common_record_context *ctx)
 
 	if (latency) {
 		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
-						      ctx->file_version);
+						      ctx->file_version, ctx->compression);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
-- 
2.31.1

