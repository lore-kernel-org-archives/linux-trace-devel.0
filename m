Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C684C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34983610D1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbhJHERP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237331AbhJHERO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:17:14 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC4BC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:15:20 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x7so30389631edd.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3eXBVkg8Lzaw52sGpszKauCYhI/2wPeH8FBBx3FA4TY=;
        b=o9iXElpcIK5lsYZPVvGB7vFzf4alMmJLGFUDJ1lmcjEIcvXJwp5qrrtlUPPwXv2vk4
         44AdwlAtkD3i1WpyHSj+Y2ufrw+ubHqF8T8gvMydsbBx7nlroPxvXuQgc8zZx4YddB1/
         RJRyrqOBusTl0Q8I4li5YdOgn9PG3/u4vEU5vf+0CpW0se5EGosA6/qc3II/9JiaRAIi
         B0DBf8jmsgBY0vemVjNQPSH36FP6YL/TwdEXIAVgobERdsk9RAMyAHkI3Cq1uDMNPVaI
         2pOupmjI5RKlMbEUiDrG19omTeGbUC9nX4Snf2itPTAzPVFFpU9IXStmjxUionkdSOmT
         RbrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3eXBVkg8Lzaw52sGpszKauCYhI/2wPeH8FBBx3FA4TY=;
        b=Y4301q8Tw1EisQz7By6dwWfLLjG5+TOgR3Hejo7oYme/R2CVZR2ixd8I51tAigNUe/
         nXRoAQIaxyy7GX02u//4MayeQarWr88PTZiCvs/4vz6susUPNIu2flKU8an1F/OP81jm
         6xeirWuWUA7E61pC7bbt8nZliCUJQPS3iUkBvNMnISpyetshD/vyHYwjWh7hewNpi+sc
         RyjWQC30a7ly2eDZaB/N5heSOIFUncQVP2Q+54DaQIRQ+21rGs+CjxMvWZrqvYOvu46K
         wOK/1Tz7Gwt2jwyRo1AvrfnCtgKwcV+b7/QOkrCZBo8CwKUYM2kbEhpeAw4vwmy05cn1
         /snA==
X-Gm-Message-State: AOAM530rrrvypLoOZfRzlUrg+5owdusM41WOVB9E8La5FI+xWs5svvkf
        QnNdfTGKlBn1xulR0kKUQ5qQHra4F+An8w==
X-Google-Smtp-Source: ABdhPJwBzB8PUFN9Iy8fDQbRJ+8d3kocz509IZqJhJMe9zGH5aXh5gT2ornDx5anlSzhEm1bi47y4Q==
X-Received: by 2002:a17:906:6087:: with SMTP id t7mr1327654ejj.206.1633666518757;
        Thu, 07 Oct 2021 21:15:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w15sm459614ejb.4.2021.10.07.21.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:15:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/4] trace-cmd: Use the new trace buffers API
Date:   Fri,  8 Oct 2021 07:15:12 +0300
Message-Id: <20211008041514.974537-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041514.974537-1-tz.stoyanov@gmail.com>
References: <20211008041514.974537-1-tz.stoyanov@gmail.com>
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
index 75680d73..ed41f937 100644
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
2.31.1

