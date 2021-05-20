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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71B4C43461
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A19661186
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhETDVk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhETDVk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:40 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C36AC061760
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:19 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id s22so22734311ejv.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ngRSmrkPXG+9QYQDdUwaQ5lXucdX3JKxISx3/qDcUgM=;
        b=jFMdonHqQDbPvtm7yTp7s2rkwYlJ/8DhJzFdwb/Ng4j+sDcaFPHOEwkKzbsDyAWVsS
         FIvVOeyypCqpxwGefAXzB9O3MmFY5IzQskPVUnXwRfeUGmnwf/Ekpm+mYg1qPtTqT8D8
         yyErxHvNkhcS1huqi+3rZTaRLS8KufZkRg0vCEymXTxd5ZyQXuLttj/DaJpWHSGw9+iR
         VACZbm56ElE98G6ViHhNzgr/GacUedlMVutpfAAq37g8BR1NCTqkc2r/C3e2Vy13S7Nv
         KVj560IZaf1M73DAomOJFaNujHG9do9LE7GJo3Zt5L0uM3FpuFQi3S3rKuYcl8rjn1no
         v/MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ngRSmrkPXG+9QYQDdUwaQ5lXucdX3JKxISx3/qDcUgM=;
        b=WtrZdRpIpQij34u/WzQrdgO7EU+PqOpdmlK6swScOIyE8T5ZKA+yboJzhrxMrZRoK4
         /VTlXzsTJ9y9+KROQew08i03H+oIfVYqxNBTzIu+h+zn5BZylY3+Pq146BS2P/ncShfq
         GH73tsLo38RPOVxMQE1r8LqsHJS/C4sflvm4SQ68IpvfMK19clL6XqSWVDF4bJ65kXdC
         kiIdVimmoRAnGqYS/8i8f68Rd1gLDs4UTFErSGmTinlFsuhI4C/Vfu+VuTZ/CMM+wbQM
         KbAMyPIvmi6XCTYXGX82gvQ0a35hIKwbogFWFXDAklUarmHybepbJgYM74NavWLB77Ys
         P/Xg==
X-Gm-Message-State: AOAM531cNnCY1Uc/dMgx+BUufxQ5PaJ23DEI1W0sB+DuDQXS0ZqVAzRN
        bcg1phLMNe0HhrrhH93X8t8=
X-Google-Smtp-Source: ABdhPJzs9ydEnMQI9jpC/PAemKGCmNDhHEg7RTEnAecEWn3y1jAosncwA4OLKCSr0MAWSz4xK3nngQ==
X-Received: by 2002:a17:906:4a81:: with SMTP id x1mr2399430eju.508.1621480818055;
        Wed, 19 May 2021 20:20:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 14/29] trace-cmd library: Extend the create file APIs to support different compression
Date:   Thu, 20 May 2021 06:19:44 +0300
Message-Id: <20210520031959.346165-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added additional parameter for file compression to all trace-cmd library
APIs for creating a new trace file. The caller could specify what
compression algorithm should be used when creating a new trace file:
 tracecmd_create_file_latency
 tracecmd_create_init_file_glob
 tracecmd_create_init_fd_glob
 tracecmd_create_init_fd_msg
 tracecmd_create_init_file
 tracecmd_create_init_file_override
 tracecmd_create_init_fd

The new parameter is of type string and can be one of:
 "any" - auto select the best available compression algorithm
 "none" - do not compress the trace file
 name - the name of the desired compression algorithms

If a compression is used, trace file version 7 is selected, otherwise
trace file version 6 is used.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       | 19 +++--
 lib/trace-cmd/trace-output.c                  | 77 +++++++++++++------
 tracecmd/trace-record.c                       | 12 ++-
 tracecmd/trace-restore.c                      |  4 +-
 tracecmd/trace-stream.c                       |  2 +-
 5 files changed, 71 insertions(+), 43 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 4265e37a..ebd633e1 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -271,20 +271,23 @@ struct tracecmd_event_list {
 struct tracecmd_option;
 struct tracecmd_msg_handle;
 
-struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
+struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
+						     const char *compression);
 struct tracecmd_output *
-tracecmd_create_init_file_glob(const char *output_file,
-			       struct tracecmd_event_list *list);
-struct tracecmd_output *tracecmd_create_init_fd(int fd);
+tracecmd_create_init_file_glob(const char *output_file, struct tracecmd_event_list *list,
+			       const char *compression);
+struct tracecmd_output *tracecmd_create_init_fd(int fd, const char *compression);
 struct tracecmd_output *
-tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list);
+tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list, const char *compression);
 struct tracecmd_output *
 tracecmd_create_init_fd_msg(struct tracecmd_msg_handle *msg_handle,
-			    struct tracecmd_event_list *list);
-struct tracecmd_output *tracecmd_create_init_file(const char *output_file);
+			    struct tracecmd_event_list *list,
+			    const char *compression);
+struct tracecmd_output *tracecmd_create_init_file(const char *output_file, const char *compression);
 struct tracecmd_output *tracecmd_create_init_file_override(const char *output_file,
 							   const char *tracing_dir,
-							   const char *kallsyms);
+							   const char *kallsyms,
+							   const char *compression);
 struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
 					    unsigned short id, int size,
 					    const void *data);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index f0ebc1af..d575ea3b 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -978,7 +978,8 @@ out_free:
 }
 
 static int select_file_version(struct tracecmd_output *handle,
-				struct tracecmd_input *ihandle)
+				struct tracecmd_input *ihandle,
+				const char *compression)
 {
 	const char *cname = NULL;
 	const char *cver = NULL;
@@ -994,8 +995,28 @@ static int select_file_version(struct tracecmd_output *handle,
 		return 0;
 	}
 
-	handle->compress = tracecmd_compress_alloc(NULL, NULL, handle->fd,
-						   handle->pevent, handle->msg_handle);
+	if (compression) {
+		if (!strcmp(compression, "any")) {
+			handle->compress = tracecmd_compress_alloc(NULL, NULL, handle->fd,
+								   handle->pevent, handle->msg_handle);
+			if (!handle->compress) {
+				tracecmd_warning("No compression algorithms are not supported");
+				return -1;
+			}
+		} else if (strcmp(compression, "none")) {
+			handle->compress = tracecmd_compress_alloc(compression, NULL, handle->fd,
+								   handle->pevent, handle->msg_handle);
+			if (!handle->compress) {
+				tracecmd_warning("Compression algorithm %s is not supported",
+						  compression);
+				return -1;
+			}
+		}
+	} else {
+		handle->compress = tracecmd_compress_alloc(NULL, NULL, handle->fd,
+							    handle->pevent, handle->msg_handle);
+	}
+
 	if (handle->compress)
 		handle->file_version = 7;
 	else
@@ -1028,7 +1049,8 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	       const char *tracing_dir,
 	       const char *kallsyms,
 	       struct tracecmd_event_list *list,
-	       struct tracecmd_msg_handle *msg_handle)
+	       struct tracecmd_msg_handle *msg_handle,
+	       const char *compression)
 {
 	struct tracecmd_output *handle;
 	struct tep_handle *pevent;
@@ -1049,7 +1071,7 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 
 	handle->msg_handle = msg_handle;
 
-	if (select_file_version(handle, ihandle))
+	if (select_file_version(handle, ihandle, compression))
 		goto out_free;
 
 	list_head_init(&handle->options);
@@ -1128,7 +1150,8 @@ static struct tracecmd_output *create_file(const char *output_file,
 					   struct tracecmd_input *ihandle,
 					   const char *tracing_dir,
 					   const char *kallsyms,
-					   struct tracecmd_event_list *list)
+					   struct tracecmd_event_list *list,
+					   const char *compression)
 {
 	struct tracecmd_output *handle;
 	int fd;
@@ -1137,7 +1160,7 @@ static struct tracecmd_output *create_file(const char *output_file,
 	if (fd < 0)
 		return NULL;
 
-	handle = create_file_fd(fd, ihandle, tracing_dir, kallsyms, list, NULL);
+	handle = create_file_fd(fd, ihandle, tracing_dir, kallsyms, list, NULL, compression);
 	if (!handle) {
 		close(fd);
 		unlink(output_file);
@@ -1403,13 +1426,14 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 	return ret;
 }
 
-struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
+struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
+						     const char *compression)
 {
 	struct tracecmd_output *handle;
 	char *path;
 	int ret;
 
-	handle = create_file(output_file, NULL, NULL, NULL, &all_event_list);
+	handle = create_file(output_file, NULL, NULL, NULL, &all_event_list, compression);
 	if (!handle)
 		return NULL;
 
@@ -1710,41 +1734,43 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	return NULL;
 }
 
-struct tracecmd_output *tracecmd_create_init_fd(int fd)
+struct tracecmd_output *tracecmd_create_init_fd(int fd, const char *compression)
 {
-	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list, NULL);
+	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list, NULL, compression);
 }
 
 struct tracecmd_output *
 tracecmd_create_init_fd_msg(struct tracecmd_msg_handle *msg_handle,
-			    struct tracecmd_event_list *list)
+			    struct tracecmd_event_list *list, const char *compression)
 {
-	return create_file_fd(msg_handle->fd, NULL, NULL, NULL, list, msg_handle);
+	return create_file_fd(msg_handle->fd, NULL, NULL, NULL,
+			      list, msg_handle, compression);
 }
 
 struct tracecmd_output *
-tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list)
+tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list, const char *compression)
 {
-	return create_file_fd(fd, NULL, NULL, NULL, list, NULL);
+	return create_file_fd(fd, NULL, NULL, NULL, list, NULL, compression);
 }
 
 struct tracecmd_output *
-tracecmd_create_init_file_glob(const char *output_file,
-			       struct tracecmd_event_list *list)
+tracecmd_create_init_file_glob(const char *output_file, struct tracecmd_event_list *list,
+			       const char *compression)
 {
-	return create_file(output_file, NULL, NULL, NULL, list);
+	return create_file(output_file, NULL, NULL, NULL, list, compression);
 }
 
-struct tracecmd_output *tracecmd_create_init_file(const char *output_file)
+struct tracecmd_output *tracecmd_create_init_file(const char *output_file, const char *compression)
 {
-	return create_file(output_file, NULL, NULL, NULL, &all_event_list);
+	return create_file(output_file, NULL, NULL, NULL, &all_event_list, compression);
 }
 
 struct tracecmd_output *tracecmd_create_init_file_override(const char *output_file,
 							   const char *tracing_dir,
-							   const char *kallsyms)
+							   const char *kallsyms,
+							   const char *compression)
 {
-	return create_file(output_file, NULL, tracing_dir, kallsyms, &all_event_list);
+	return create_file(output_file, NULL, tracing_dir, kallsyms, &all_event_list, compression);
 }
 
 /**
@@ -1756,12 +1782,13 @@ struct tracecmd_output *tracecmd_create_init_file_override(const char *output_fi
  * with the same characteristics (events and all) and returns
  * tracecmd_output handle to this new file.
  */
-struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
-				      const char *file)
+struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char *file)
 {
 	struct tracecmd_output *handle;
+	const char *compr_name = NULL;
 
-	handle = create_file(file, ihandle, NULL, NULL, &all_event_list);
+	tracecmd_get_file_compress_proto(ihandle, &compr_name, NULL);
+	handle = create_file(file, ihandle, NULL, NULL, &all_event_list, compr_name);
 	if (!handle)
 		return NULL;
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index bf911895..03d82377 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3700,7 +3700,7 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
-		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
+		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events, NULL);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -3718,8 +3718,7 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 	} else {
-		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
-							      listed_events);
+		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd, listed_events, NULL);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -4067,8 +4066,7 @@ static void setup_agent(struct buffer_instance *instance,
 {
 	struct tracecmd_output *network_handle;
 
-	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
-						     listed_events);
+	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle, listed_events, NULL);
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
@@ -4460,7 +4458,7 @@ static void record_data(struct common_record_context *ctx)
 		return;
 
 	if (latency) {
-		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count);
+		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count, NULL);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
@@ -4491,7 +4489,7 @@ static void record_data(struct common_record_context *ctx)
 				touch_file(temp_files[i]);
 		}
 
-		handle = tracecmd_create_init_file_glob(ctx->output, listed_events);
+		handle = tracecmd_create_init_file_glob(ctx->output, listed_events, NULL);
 		if (!handle)
 			die("Error creating output file");
 		tracecmd_set_quiet(handle, quiet);
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 280a37f0..96b4fb5d 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -91,7 +91,7 @@ void trace_restore (int argc, char **argv)
 		}
 
 		handle = tracecmd_create_init_file_override(output, tracing_dir,
-							    kallsyms);
+							    kallsyms, NULL);
 		if (!handle)
 			die("Unabled to create output file %s", output);
 		if (tracecmd_write_cmdlines(handle) < 0)
@@ -128,7 +128,7 @@ void trace_restore (int argc, char **argv)
 		handle = tracecmd_copy(ihandle, output);
 		tracecmd_close(ihandle);
 	} else
-		handle = tracecmd_create_init_file(output);
+		handle = tracecmd_create_init_file(output, NULL);
 
 	if (!handle)
 		die("error writing to %s", output);
diff --git a/tracecmd/trace-stream.c b/tracecmd/trace-stream.c
index b47b208c..317de1b2 100644
--- a/tracecmd/trace-stream.c
+++ b/tracecmd/trace-stream.c
@@ -43,7 +43,7 @@ trace_stream_init(struct buffer_instance *instance, int cpu, int fd, int cpus,
 		tfd = fileno(fp);
 
 		ofd = dup(tfd);
-		trace_output = tracecmd_create_init_fd(ofd);
+		trace_output = tracecmd_create_init_fd(ofd, NULL);
 		if (!trace_output) {
 			fclose(fp);
 			return NULL;
-- 
2.31.1

