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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DEE1C48BE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33AE161289
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhFNHyA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:54:00 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:45591 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbhFNHx7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:59 -0400
Received: by mail-ed1-f52.google.com with SMTP id r7so30788989edv.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gtQ5F8jrQUF2N6tOvDi45fySOa/hLLTaZHUpfsjugYM=;
        b=PzwVEsyYiZssY+5rqGm4dmN1/OG8dtNotk+6tdrBKlNjmXmHQw7duFDkWzOcD+5frK
         cRqihW/tvlFLsPGWzfnoUYr+7EDAJkROfsr2OJ678l8hEGskDNeJOZ0vk217yFF/TkdZ
         luTG/uL5DA5CX+zBqhNQXzb4kHgLC8BYgU8UTkpkXaAnYjQPe1FhWcYumTNb+4/e7t+1
         zgDHURRS5ubiBMCcavWDCI7yp+GirfxCtKb93L+s8vY/T1jsVkUx6q/P58MLxYyrgu7f
         LXM6z2oPZmN27jLWE6LTolv19nrTnI8IZKIeNEwXqEjXJpFqVA/INcQs/NQCSENJ5rOV
         i97Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gtQ5F8jrQUF2N6tOvDi45fySOa/hLLTaZHUpfsjugYM=;
        b=Y9eq8BIOzzOKzZXhLFn4S0xtBzPLAYXlD6Rxv5J8aYitawxKGNNLSYfimF0Ki0a3wG
         q1m5+SJtwBmuJ4kDaSMzPzDicANGj+oQQMutB0bYACr5p2oX+5VJsKZIjkY65aGFK/qr
         IVlhl2JIR3SvZEc5jhEdCcAccNWGkNnlqaoe/uB3IaeJkyJiblYVt+Fo0cgabDPq2Wnz
         +wIM2Lw5oz4wt6sytzhD7P993mk7adT8E2SHd/xXMVIEwnDH7MHr5ko+bZCcTzm8l8jv
         oqJUnD7Q7tv3ECHZio+zLH3XuoitmdhyaFNTj9DqBaXDRX/rZCL6FtQobkuqFJXPxNoi
         PJbg==
X-Gm-Message-State: AOAM530kfzOyHiXN0KALSNAGjPsD/Pz26UeVzYbsenZ1X+rkk/cJ9pAf
        O06AiSBQkWgDSlTAOQePRZg=
X-Google-Smtp-Source: ABdhPJxXOnoYmMZSvTWVMQa/Pc8gm7SIzzg2/ZpYhi/Qi+1v+J+l4rnECRyHSHaMFpwLN9XZtXA3HQ==
X-Received: by 2002:a05:6402:35cc:: with SMTP id z12mr3089352edc.45.1623657045666;
        Mon, 14 Jun 2021 00:50:45 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:45 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 14/45] trace-cmd library: Extend the create file APIs to support different compression
Date:   Mon, 14 Jun 2021 10:49:58 +0300
Message-Id: <20210614075029.598048-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c                  | 79 ++++++++++++-------
 tracecmd/trace-record.c                       | 12 ++-
 tracecmd/trace-restore.c                      |  4 +-
 tracecmd/trace-stream.c                       |  2 +-
 5 files changed, 70 insertions(+), 46 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 624d0afb..ee73325c 100644
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
index 82b3e5df..7c7d3d76 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -978,24 +978,41 @@ out_free:
 }
 
 static int select_file_version(struct tracecmd_output *handle,
-				struct tracecmd_input *ihandle)
+				struct tracecmd_input *ihandle,
+				const char *compression)
 {
 	const char *cname = NULL;
 	const char *cver = NULL;
 
-	if (ihandle) {
-		handle->file_version = tracecmd_get_in_file_version(ihandle);
+	if (compression) { /* If compression is specified - use it */
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
+	} else if (ihandle) { /* If there is input handler - inherit compression */
 		if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
 			handle->compress = tracecmd_compress_alloc(cname, cver, handle->fd,
 								   handle->pevent, handle->msg_handle);
 			if (!handle->compress)
 				return -1;
 		}
-		return 0;
+	} else { /* default - auto select the best available compression algorithm */
+		handle->compress = tracecmd_compress_alloc(NULL, NULL, handle->fd,
+							    handle->pevent, handle->msg_handle);
 	}
 
-	handle->compress = tracecmd_compress_alloc(NULL, NULL, handle->fd,
-						   handle->pevent, handle->msg_handle);
 	if (handle->compress)
 		handle->file_version = 7;
 	else
@@ -1028,7 +1045,8 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	       const char *tracing_dir,
 	       const char *kallsyms,
 	       struct tracecmd_event_list *list,
-	       struct tracecmd_msg_handle *msg_handle)
+	       struct tracecmd_msg_handle *msg_handle,
+	       const char *compression)
 {
 	struct tracecmd_output *handle;
 	struct tep_handle *pevent;
@@ -1049,7 +1067,7 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 
 	handle->msg_handle = msg_handle;
 
-	if (select_file_version(handle, ihandle))
+	if (select_file_version(handle, ihandle, compression))
 		goto out_free;
 
 	list_head_init(&handle->options);
@@ -1128,7 +1146,8 @@ static struct tracecmd_output *create_file(const char *output_file,
 					   struct tracecmd_input *ihandle,
 					   const char *tracing_dir,
 					   const char *kallsyms,
-					   struct tracecmd_event_list *list)
+					   struct tracecmd_event_list *list,
+					   const char *compression)
 {
 	struct tracecmd_output *handle;
 	int fd;
@@ -1137,7 +1156,7 @@ static struct tracecmd_output *create_file(const char *output_file,
 	if (fd < 0)
 		return NULL;
 
-	handle = create_file_fd(fd, ihandle, tracing_dir, kallsyms, list, NULL);
+	handle = create_file_fd(fd, ihandle, tracing_dir, kallsyms, list, NULL, compression);
 	if (!handle) {
 		close(fd);
 		unlink(output_file);
@@ -1403,13 +1422,14 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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
 
@@ -1710,41 +1730,43 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
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
@@ -1756,12 +1778,13 @@ struct tracecmd_output *tracecmd_create_init_file_override(const char *output_fi
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
index 60ee5fb3..29f84b7c 100644
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

