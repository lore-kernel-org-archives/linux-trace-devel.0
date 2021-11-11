Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74485C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 572AF61268
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhKKPLA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbhKKPLA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:11:00 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D1CC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:08:11 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id f8so25601006edy.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dJ4ENCfOd6TCRPScHl/BkdWhdsno+tVEOizcPCPbEP0=;
        b=CKv1tB4foNgiqpbgQfl8glcJCmlI66d6THuBw9fUgjg8l3xTueOfdHsTQIZ+hijk55
         kmQr4Joof4MIH5G2K7Hrh4cGaF5mq8NBJ+PB3KZzCmWe+dfzxNfF7PdXKKeXtEjQTs+j
         2XiFpa48hTL0t/gfJ7WqjTp4NAQv92OXg1BOuvAS/J3iz9/pJF6CPGziN4ZtyYV+jfqd
         jAZI5t2x0XXAqYB6tIlTEXH7d68KmXU4S+FuuP6VCIvDvaCa1ACd5R5KUFINL1Hx12W/
         QStlArqm7Bp6KHA0obSNZR0LPhuwbxjVlZbbovpkunZiFILuvHlwg9yNeZAmFOy+ZN8f
         jakA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dJ4ENCfOd6TCRPScHl/BkdWhdsno+tVEOizcPCPbEP0=;
        b=SrUmAx3Lfi+H0PV1nEssKhxYVOEG4eBZUpptL33YZt0Y4Jhi2kF+wtoDKx+ThK+AIT
         xpAc1HaVtOx2ggemeGjSMmD2QTmCYwXCKrXKqZQo8sxWAzWkmfrQAX73o/s0FWwRHgrj
         cuc/DZsESOAN6R2wkRR3dWqWvn9lRCTp4/IOFHVqSQBzkT95s6F2VdfLfL+LgMYdSfbX
         61oW+l+ji851D15QNU4dZxOAN7uE2jz/qkqK5L7JzhFwB603lUiT7kv0Vt/8QLZZzOhE
         azQjgYXZxKMNOlejfJvxD6lQ9kx7HMVmRNwkeEwNXslBDE68MKoudeZym8NTA5qS7nai
         RFSw==
X-Gm-Message-State: AOAM530cAX5OGHYlwYB8UtoYgMYYfj2IZL//6mRdDTtv1pwQpop3wjWL
        ppzt204cIyUeUUWMiJXKF8UiHZo5/UCMlQ==
X-Google-Smtp-Source: ABdhPJx8oEBKSe7XjczYAESq0pq8cxxq1sll+0gnUO6LLSg9ttBkYkLcynYB/35c/C+ThkSJwDw2lw==
X-Received: by 2002:a05:6402:14c3:: with SMTP id f3mr10549221edx.67.1636643289624;
        Thu, 11 Nov 2021 07:08:09 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y15sm1869027eda.35.2021.11.11.07.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:08:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 2/4] trace-cmd: Use the new trace buffers API
Date:   Thu, 11 Nov 2021 17:08:03 +0200
Message-Id: <20211111150805.86419-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111150805.86419-1-tz.stoyanov@gmail.com>
References: <20211111150805.86419-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When recording trace buffers, use the newly introduced library API for
describing the buffers.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h          |  2 --
 lib/trace-cmd/trace-output.c                     |  7 +++----
 tracecmd/trace-record.c                          | 16 +++++-----------
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index c0a07045..47358c4b 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -290,8 +290,6 @@ struct tracecmd_option *
 tracecmd_add_option_v(struct tracecmd_output *handle,
 		      unsigned short id, const struct iovec *vector, int count);
 
-struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handle,
-						   const char *name, int cpus);
 int tracecmd_add_buffer_info(struct tracecmd_output *handle, const char *name, int cpus);
 int tracecmd_write_buffer_info(struct tracecmd_output *handle);
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index f0f6aeed..1f144d28 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1334,9 +1334,8 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 	return 0;
 }
 
-struct tracecmd_option *
-tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
-			   int cpus)
+static struct tracecmd_option *
+add_buffer_option(struct tracecmd_output *handle, const char *name, int cpus)
 {
 	struct tracecmd_option *option;
 	char *buf;
@@ -1387,7 +1386,7 @@ int tracecmd_write_buffer_info(struct tracecmd_output *handle)
 	struct tracecmd_buffer *buf;
 
 	list_for_each_entry(buf, &handle->buffers, list) {
-		option = tracecmd_add_buffer_option(handle, buf->name, buf->cpus);
+		option = add_buffer_option(handle, buf->name, buf->cpus);
 		if (!option)
 			return -1;
 		buf->option = option;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 15e07cf0..c96dcda0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4169,7 +4169,6 @@ static void touch_file(const char *file)
 }
 
 static void append_buffer(struct tracecmd_output *handle,
-			  struct tracecmd_option *buffer_option,
 			  struct buffer_instance *instance,
 			  char **temp_files)
 {
@@ -4197,7 +4196,7 @@ static void append_buffer(struct tracecmd_output *handle,
 			touch_file(temp_files[i]);
 	}
 
-	tracecmd_append_buffer_cpu_data(handle, buffer_option,
+	tracecmd_append_buffer_cpu_data(handle, NULL,
 					cpu_count, temp_files);
 
 	for (i = 0; i < instance->cpu_count; i++) {
@@ -4482,7 +4481,6 @@ error:
 
 static void record_data(struct common_record_context *ctx)
 {
-	struct tracecmd_option **buffer_options;
 	struct tracecmd_output *handle;
 	struct buffer_instance *instance;
 	bool local = false;
@@ -4551,9 +4549,6 @@ static void record_data(struct common_record_context *ctx)
 		}
 
 		if (buffers) {
-			buffer_options = malloc(sizeof(*buffer_options) * buffers);
-			if (!buffer_options)
-				die("Failed to allocate buffer options");
 			i = 0;
 			for_each_instance(instance) {
 				int cpus = instance->cpu_count != local_cpu_count ?
@@ -4561,10 +4556,9 @@ static void record_data(struct common_record_context *ctx)
 
 				if (instance->msg_handle)
 					continue;
-
-				buffer_options[i++] = tracecmd_add_buffer_option(handle,
-										 tracefs_instance_get_name(instance->tracefs),
-										 cpus);
+				tracecmd_add_buffer_info(handle,
+							tracefs_instance_get_name(instance->tracefs),
+							cpus);
 				add_buffer_stat(handle, instance);
 			}
 		}
@@ -4599,7 +4593,7 @@ static void record_data(struct common_record_context *ctx)
 				if (instance->msg_handle)
 					continue;
 				print_stat(instance);
-				append_buffer(handle, buffer_options[i++], instance, temp_files);
+				append_buffer(handle, instance, temp_files);
 			}
 		}
 
-- 
2.33.1

