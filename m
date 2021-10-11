Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C702C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 04:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8017561039
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 04:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhJKE2m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 00:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbhJKE2l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 00:28:41 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D07DC061570
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Oct 2021 21:26:42 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id d3so35069292edp.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Oct 2021 21:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3eXBVkg8Lzaw52sGpszKauCYhI/2wPeH8FBBx3FA4TY=;
        b=TWjOQPKJ+DPvO/dAVjrrFmnvQvjoKfzSHuv3ItX+g90svuwHxk4HHAd+GUcDmjo9t+
         mBJ6tos91wBBmdRpQ/+eMhpJsuqNbIqkAHgwEc2gXHUXzs/YHOewtMnnon/Wp90l0sJV
         E7yQ//CsDMsZAfMw8yBVBZoXJtsAi6Zvh8FL7azNUEr2+rbtvIRL4fIJy//es/HmrXIR
         ubcfNVNyecA4V9jNmlPTty+9RMi5ywn9CKaWsqKo9HtiXbRjcFp4hAbhiA+wC3++Y8Dc
         Wx4UDjCZ6FQ+UxUZbUEUdQJiPsArKQ1HIAbXV3OSCUSSov1+haazA5whiBZtiCmd0usf
         vrjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3eXBVkg8Lzaw52sGpszKauCYhI/2wPeH8FBBx3FA4TY=;
        b=1zfPRNCPiQR4dmTzO8BJfX/DuaP9NCn3jR21ZWskCO1UWKmbkNbtORfXVXozc6+iVB
         clAU/ecOzbpWxD/VUUgGko5J4JXubqE3iovxwJSEhVu/3Xi7dH4ToahwVop9avxhj6TW
         pGiaMPZVVhIiU6e5fIBIslBPFAcSKuEcSfZqCAxC71tpyJoJQznpfiXlDnxsLtoaogR4
         af2nL/JGRR4n+eEvj6MF3tDoJJBVZvc+7E+42JEHhcdu2HuTjbwj4tdcsCfMCnqvYnX3
         qYBRbFC/eLRTY5Q4eX2aqxfUTb+2OC9nVGHB+XUo0yc4dWMYNFM3bFP7Tna5CAOYiSdU
         eFNA==
X-Gm-Message-State: AOAM531kiV+ZaIizWGqHwtvmSPqaj6VCt0KpJCAAiJOhSl0Hr8AP0NSo
        Pnp5vJLZUte21YYjWWGgnKqDKaFYgdARrg==
X-Google-Smtp-Source: ABdhPJw2v4KmJgEa76GDXkdsOLdyZs9t9m9FnGFOFRRvk1V+qP80kO8ACNPzFCgHP0qB7k1xXFJKvw==
X-Received: by 2002:a05:6402:4308:: with SMTP id m8mr38093599edc.188.1633926400677;
        Sun, 10 Oct 2021 21:26:40 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j21sm3406532edr.64.2021.10.10.21.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 21:26:40 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/4] trace-cmd: Use the new trace buffers API
Date:   Mon, 11 Oct 2021 07:26:34 +0300
Message-Id: <20211011042636.1608374-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211011042636.1608374-1-tz.stoyanov@gmail.com>
References: <20211011042636.1608374-1-tz.stoyanov@gmail.com>
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

