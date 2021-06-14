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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06778C48BE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D05826124B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbhFNHwy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbhFNHwx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:52:53 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB941C061787
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:50 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id l1so14990028ejb.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IJNFqqX/hbiSS7OIa+JNEw+bJG0elOcOWFPIQmVJ/Kw=;
        b=U5WcTA+E3FIoVqH8Ub9onfIRxndh5DSTjp+/X2WAOZltunBEoWvgQBMD3Xhy1vTmr4
         ss8cIzw9h/q3pxVXkmbgiESdNobWwB5NHB5lUUeWJnBHlemCQ9q5+Nv+eHDgnu77tY9r
         EXEZ6WdXEVQE9dLP6rkX7L4hTZ+fsIFeFCIpYTF9PdoCHN8jMMaC16g9JQqGHslbccvD
         vV6t2/quSqGklntmsgmk8BYJ17wLhj7okZXYwelY+owulqMUTS6lPetVYOiwSjxSrsD0
         0cpdfm+e8IOV6+kN+iJN5Biw8KbgULpz4yj1YZ4lw+YTvhdyv8d2IEwyK+acnTR2PLPL
         zfrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IJNFqqX/hbiSS7OIa+JNEw+bJG0elOcOWFPIQmVJ/Kw=;
        b=WhEMyGVUHRxXsZqMLc4b3qZhXlgh9vCiENGCZx+kdL9W90yVz+QsgFNO5Qr55q+tSw
         WqFMrwxxxaBdggOJrAFufEwmKjK7e3S69R9cbx8jncLQQurFcCEhnrziKAJz3f6x+wTp
         ych17zueM7Z7yHhSHXiaI5XTa2t/+XnXqeC7x2ib4rpT/ZcVYtFXbB1m3bC9J73fXLnZ
         WFiZtXxUJEVVpNZWrPo75jb7EiT6sY4fw1ku4Mj6TF0IJ59iL5IGchBM4mSWbhISc+zp
         Hii659WRnk4Xt7ka4dzcCBUKWjrIa4o/05J3bHB5sniPsl4dihdKNGmgOow3nYp65dy3
         Tn5w==
X-Gm-Message-State: AOAM532Td6SR6ppbsbmuv4S5WOUW6EoqvpQFdjTLlJZJtEmsUffTox/f
        7H8nLpBE/GWjF0WUWsiz5jfLjCm4K+zvqA==
X-Google-Smtp-Source: ABdhPJwqK2ZjuqAuwkcx7B/sl9RSxyGLqYXaYAB9p5w7t3OLoWje7AbUP4JSInECxIxKXsUMHUEs+g==
X-Received: by 2002:a17:906:fa13:: with SMTP id lo19mr14489986ejb.468.1623657049395;
        Mon, 14 Jun 2021 00:50:49 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 18/45] trace-cmd library: Hide the logic for updating buffer offset
Date:   Mon, 14 Jun 2021 10:50:02 +0300
Message-Id: <20210614075029.598048-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a trace buffer data are written in the trace file, the buffer
option in the file metadata is updated with the file offset of the
tracing data. Hide this logic into the trace-cmd library.
Added new APIs:
 tracecmd_add_buffer_description()
 tracecmd_write_buffers_description()
Changed APIs:
 tracecmd_append_buffer_cpu_data()
Removed APIs:
 tracecmd_add_buffer_option()

This internal refactoring is needed for changes, related to compression
of the options sections of the trace file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  8 +-
 lib/trace-cmd/trace-output.c                  | 84 +++++++++++++++++--
 tracecmd/trace-record.c                       | 16 ++--
 3 files changed, 85 insertions(+), 23 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index ee73325c..cbb578ec 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -295,8 +295,8 @@ struct tracecmd_option *
 tracecmd_add_option_v(struct tracecmd_output *handle,
 		      unsigned short id, const struct iovec *vector, int count);
 
-struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handle,
-						   const char *name, int cpus);
+int tracecmd_add_buffer_description(struct tracecmd_output *handle, const char *name, int cpus);
+int tracecmd_write_buffers_description(struct tracecmd_output *handle);
 
 int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
 int tracecmd_write_cmdlines(struct tracecmd_output *handle);
@@ -312,9 +312,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 			     int cpus, char * const *cpu_data_files);
 int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
-				    struct tracecmd_option *option,
-				    int cpus, char * const *cpu_data_files);
-
+				    const char *name, int cpus, char * const *cpu_data_files);
 struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
 
 /* --- Reading the Fly Recorder Trace --- */
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 7c7d3d76..8f8ca164 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -44,6 +44,14 @@ struct tracecmd_option {
 	struct list_head list;
 };
 
+struct tracecmd_buffer {
+	int		cpus;
+	void		*name;
+	tsize_t		offset;
+	struct tracecmd_option *option;
+	struct list_head list;
+};
+
 enum {
 	OUTPUT_FL_SEND_META	= (1 << 0),
 };
@@ -63,6 +71,7 @@ struct tracecmd_output {
 	struct tracecmd_compression *compress;
 
 	struct list_head	options;
+	struct list_head	buffers;
 	struct tracecmd_msg_handle *msg_handle;
 	char			*trace_clock;
 };
@@ -189,6 +198,7 @@ bool tracecmd_get_quiet(struct tracecmd_output *handle)
 void tracecmd_output_free(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *option;
+	struct tracecmd_buffer *buffer;
 
 	if (!handle)
 		return;
@@ -199,6 +209,13 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 	if (handle->pevent)
 		tep_unref(handle->pevent);
 
+	while (!list_empty(&handle->buffers)) {
+		buffer = container_of(handle->buffers.next,
+				      struct tracecmd_buffer, list);
+		list_del(&buffer->list);
+		free(buffer->name);
+		free(buffer);
+	}
 	while (!list_empty(&handle->options)) {
 		option = container_of(handle->options.next,
 				      struct tracecmd_option, list);
@@ -1071,6 +1088,7 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 		goto out_free;
 
 	list_head_init(&handle->options);
+	list_head_init(&handle->buffers);
 
 	buf[0] = 23;
 	buf[1] = 8;
@@ -1369,9 +1387,8 @@ int tracecmd_append_options(struct tracecmd_output *handle)
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
@@ -1399,6 +1416,53 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
 	return option;
 }
 
+int tracecmd_add_buffer_description(struct tracecmd_output *handle, const char *name, int cpus)
+{
+	struct tracecmd_buffer *buf;
+
+	buf = calloc(1, sizeof(struct tracecmd_buffer));
+	if (!buf)
+		return -1;
+	buf->name = strdup(name);
+	buf->cpus = cpus;
+	if (!buf->name) {
+		free(buf);
+		return -1;
+	}
+	list_add_tail(&buf->list, &handle->buffers);
+	return 0;
+}
+
+int tracecmd_write_buffers_description(struct tracecmd_output *handle)
+{
+	struct tracecmd_option *option;
+	struct tracecmd_buffer *buf;
+
+	list_for_each_entry(buf, &handle->buffers, list) {
+		option = add_buffer_option(handle, buf->name, buf->cpus);
+		if (!option)
+			return -1;
+		buf->option = option;
+	}
+	return 0;
+}
+
+static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char *name)
+{
+	struct tracecmd_buffer *buf;
+
+	list_for_each_entry(buf, &handle->buffers, list) {
+		if (strlen(name) == strlen(buf->name) && !strcmp(name, buf->name)) {
+			if (handle->file_version >= 7)
+				return buf->offset;
+			if (!buf->option)
+				break;
+			return buf->option->offset;
+		}
+	}
+	return 0;
+}
+
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
 	int ret;
@@ -1643,18 +1707,23 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 }
 
 int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
-				    struct tracecmd_option *option,
-				    int cpus, char * const *cpu_data_files)
+				    const char *name, int cpus, char * const *cpu_data_files)
 {
+	tsize_t b_offset;
 	tsize_t offset;
 	stsize_t ret;
 
+	b_offset = get_buffer_file_offset(handle, name);
+	if (!b_offset) {
+		tracecmd_warning("Cannot find description for buffer %s\n", name);
+		return -1;
+	}
 	offset = lseek64(handle->fd, 0, SEEK_CUR);
 
 	/* Go to the option data, where will write the offest */
-	ret = lseek64(handle->fd, option->offset, SEEK_SET);
+	ret = lseek64(handle->fd, b_offset, SEEK_SET);
 	if (ret == (off64_t)-1) {
-		tracecmd_warning("could not seek to %lld\n", option->offset);
+		tracecmd_warning("could not seek to %lld\n", b_offset);
 		return -1;
 	}
 
@@ -1713,6 +1782,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
 	list_head_init(&handle->options);
+	list_head_init(&handle->buffers);
 
 	if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
 		handle->compress = tracecmd_compress_alloc(cname, cver, handle->fd,
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index d3362e5b..eff6f2f0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4152,7 +4152,6 @@ static void touch_file(const char *file)
 }
 
 static void append_buffer(struct tracecmd_output *handle,
-			  struct tracecmd_option *buffer_option,
 			  struct buffer_instance *instance,
 			  char **temp_files)
 {
@@ -4180,7 +4179,7 @@ static void append_buffer(struct tracecmd_output *handle,
 			touch_file(temp_files[i]);
 	}
 
-	tracecmd_append_buffer_cpu_data(handle, buffer_option,
+	tracecmd_append_buffer_cpu_data(handle, tracefs_instance_get_name(instance->tracefs),
 					cpu_count, temp_files);
 
 	for (i = 0; i < instance->cpu_count; i++) {
@@ -4441,7 +4440,6 @@ static void write_guest_file(struct buffer_instance *instance)
 
 static void record_data(struct common_record_context *ctx)
 {
-	struct tracecmd_option **buffer_options;
 	struct tracecmd_output *handle;
 	struct buffer_instance *instance;
 	bool local = false;
@@ -4512,9 +4510,6 @@ static void record_data(struct common_record_context *ctx)
 		}
 
 		if (buffers) {
-			buffer_options = malloc(sizeof(*buffer_options) * buffers);
-			if (!buffer_options)
-				die("Failed to allocate buffer options");
 			i = 0;
 			for_each_instance(instance) {
 				int cpus = instance->cpu_count != local_cpu_count ?
@@ -4522,10 +4517,9 @@ static void record_data(struct common_record_context *ctx)
 
 				if (instance->msg_handle)
 					continue;
-
-				buffer_options[i++] = tracecmd_add_buffer_option(handle,
-										 tracefs_instance_get_name(instance->tracefs),
-										 cpus);
+				tracecmd_add_buffer_description(handle,
+								tracefs_instance_get_name(instance->tracefs),
+								cpus);
 				add_buffer_stat(handle, instance);
 			}
 		}
@@ -4560,7 +4554,7 @@ static void record_data(struct common_record_context *ctx)
 				if (instance->msg_handle)
 					continue;
 				print_stat(instance);
-				append_buffer(handle, buffer_options[i++], instance, temp_files);
+				append_buffer(handle, instance, temp_files);
 			}
 		}
 
-- 
2.31.1

