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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B40C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B718D613B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhELGjw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbhELGjw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:52 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6CFC06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:44 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b17so25720412ede.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2IqNx8fXpgOaOemYCe6aYMTLlINXqpGBKKydV7rHt1I=;
        b=TUpmspB0yZGros/MCiAACjpq5Brm9YW9SoGtuq2CjHCnwbdnuk98ReN9YOjHO2XKuQ
         9IYV/FJLZuV8NfL5T4g37RItjx9xjafNwIl3NjNtqaNS9zBFe/bK39OTymc5NQwKyS4e
         4zDUYMVmsHqiIkffc5Pwt/nIKXJQp9TAmFw/NJ/5BiXF5aJYR28p7Gqqiptvx1Z91Zib
         fWkLc8t/FISLSlCH+PDbuw/Vew3w7iLWT/6GRPw3auvBixp+V/vNn2eplFmu6OZs9y5q
         aoTNeMujjzku0xFAfxl1IwsJU4q3AIaad86Dxpk3dKaUMedITY3EQ6RA+fBhE6khZWJ9
         4Yxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2IqNx8fXpgOaOemYCe6aYMTLlINXqpGBKKydV7rHt1I=;
        b=AOIakQ8+eeTI7MdcUlKhXYgD+uYfH4kZlDks8GebTiqYM/4yOOBDgQn0+4IlSbnT8h
         gCoz3gbKaesGWdqJaE1xGt7IpR6u+PGj7NEBRWW50QFgzJFYMbICjr0YZ8q0cnymuDx5
         fTlg48dxVnd/a3G3E85hqw82hMBhVuIZdDIvjs5+zJ4M04JDUTgK7MvMSBSz1h09VXWW
         /0zwdBVTRYzlilSfUv/ws0qiHIW+/RPI7pcjsX6VA5+gV3Z8748o/SI0nA/MCG70Qm2f
         CFisZAft4KJNgoZuAZxsOHrK7b/sQniIS1xvc4nY/jeYBMB1ZqJVqLktW9TR6YqmytB4
         +8yg==
X-Gm-Message-State: AOAM532oBPPbUFXD3A5QHli5jjDLXRBFiUNoonv9CH1DXeYCn+pBPGlr
        GyZMLVPQ0BxJSPCBx/a4AphEquQCV8O/xA==
X-Google-Smtp-Source: ABdhPJxOlTqYGRT9ubGRHyyCWWFMNQh3mIaSR4TRMUBilxt24qZ5pSDtHEjBLyAs3p/PwF7ky8KUxA==
X-Received: by 2002:a05:6402:154d:: with SMTP id p13mr42009491edx.371.1620801522770;
        Tue, 11 May 2021 23:38:42 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 18/25] trace-cmd library: Hide the logic for updating buffer offset
Date:   Wed, 12 May 2021 09:38:16 +0300
Message-Id: <20210512063823.324610-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c                  | 83 +++++++++++++++++--
 tracecmd/trace-record.c                       | 16 ++--
 3 files changed, 84 insertions(+), 23 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 7c5e3fe1..7d34f27b 100644
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
index 56b68edd..aa55a089 100644
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
@@ -1075,6 +1092,7 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 		goto out_free;
 
 	list_head_init(&handle->options);
+	list_head_init(&handle->buffers);
 
 	buf[0] = 23;
 	buf[1] = 8;
@@ -1373,9 +1391,8 @@ int tracecmd_append_options(struct tracecmd_output *handle)
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
@@ -1403,6 +1420,52 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
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
@@ -1647,18 +1710,23 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
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
 
@@ -1717,6 +1785,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_file_version(ihandle);
 	list_head_init(&handle->options);
+	list_head_init(&handle->buffers);
 
 	if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
 		handle->compress = tracecmd_compress_alloc(cname, cver, handle->fd,
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5e969dc7..e12d77cc 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3934,7 +3934,6 @@ static void touch_file(const char *file)
 }
 
 static void append_buffer(struct tracecmd_output *handle,
-			  struct tracecmd_option *buffer_option,
 			  struct buffer_instance *instance,
 			  char **temp_files)
 {
@@ -3962,7 +3961,7 @@ static void append_buffer(struct tracecmd_output *handle,
 			touch_file(temp_files[i]);
 	}
 
-	tracecmd_append_buffer_cpu_data(handle, buffer_option,
+	tracecmd_append_buffer_cpu_data(handle, tracefs_instance_get_name(instance->tracefs),
 					cpu_count, temp_files);
 
 	for (i = 0; i < instance->cpu_count; i++) {
@@ -4223,7 +4222,6 @@ static void write_guest_file(struct buffer_instance *instance)
 
 static void record_data(struct common_record_context *ctx)
 {
-	struct tracecmd_option **buffer_options;
 	struct tracecmd_output *handle;
 	struct buffer_instance *instance;
 	bool local = false;
@@ -4294,9 +4292,6 @@ static void record_data(struct common_record_context *ctx)
 		}
 
 		if (buffers) {
-			buffer_options = malloc(sizeof(*buffer_options) * buffers);
-			if (!buffer_options)
-				die("Failed to allocate buffer options");
 			i = 0;
 			for_each_instance(instance) {
 				int cpus = instance->cpu_count != local_cpu_count ?
@@ -4304,10 +4299,9 @@ static void record_data(struct common_record_context *ctx)
 
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
@@ -4342,7 +4336,7 @@ static void record_data(struct common_record_context *ctx)
 				if (instance->msg_handle)
 					continue;
 				print_stat(instance);
-				append_buffer(handle, buffer_options[i++], instance, temp_files);
+				append_buffer(handle, instance, temp_files);
 			}
 		}
 
-- 
2.31.1

