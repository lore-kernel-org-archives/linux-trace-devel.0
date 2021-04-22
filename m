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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1DEC43470
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C6C6613F2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhDVHkA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235122AbhDVHjx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:39:53 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B2EC061342
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:12 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id h8so12087737edb.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8egH+WdcCAjaSWjV15WP0DvD7USXfny0k7QNB+zZN+Q=;
        b=ADTl8I5DqiVt3z7Mt8xQeoezfuYPQBzcZWicO2P6MwqQ3gtGHkxWIhv/pV/O7Rz2f2
         MhSN+f9A0Zto0r2TpCThkYJC1Cm8wwBOvVjqIJupJ1klOBEuHhxN+OKT1VDQS4K4oUQK
         UipXK38XpWqlwzeT5KrDTVQD+c3RjpymgzA42ULSOtU4SiOziSc1q1nOfZvoGRDRa56d
         VbpBUtWBKJOe/39WhQPwwCBf4HiA0ax7U+8F8O7RMYNJ7RHxzE12V3tRCwXSIKx6MVJ/
         iyIZ+bFvnyKPx05rvlYxs7NX4sXgfcgYe3B63p1oXnxRH8/+vM3iXNmYJogYWQWe2JKC
         Sygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8egH+WdcCAjaSWjV15WP0DvD7USXfny0k7QNB+zZN+Q=;
        b=Rc7yaQeTU/NoCN7FYP4EPafmSoS5pwkQC1RkdBJxiHwP76SbM1NHRMXIgMqs5K1zdJ
         PZumIrfiRJtyJ5s44vVGG92wk1Ke/LslCGOWB4EldX9BpuNcwv2x2uwtrmRrnI8kcAj9
         c8LqLqd8DbgBl/s/s2NnqBpZHDRNjt+zbGoQiqXiCSpI8DtDi+d2yAPVyjHkCWlBgI4Y
         3N/k/Ky70GV1Z5ygDt0J0Zx7G0A6nudbc4OLErkfndXxhIxYjfKRoF8qyywRX11aJT9c
         tD9P7Gnji7x0/nJLOxibNp+1FOC+O0WNdpAqV/tdXwjAsxp5GlrbsOtLoqfUVGE8bRwx
         7HDw==
X-Gm-Message-State: AOAM531um7fsRqFkmXJgJ28ZJiTP6faJbskXWPIcFWNrd1/p78K2yydF
        XgNC3PFuwVUo9T1ykfAKK4L7uLtfMdnWmA==
X-Google-Smtp-Source: ABdhPJxQA3YOzL6dEG/jiKf0DsxR66IaUTr7AhlCwZmuCrGJls68/Did/LqA245ISVX9CGEbi1sG/w==
X-Received: by 2002:aa7:dc0b:: with SMTP id b11mr2161251edu.124.1619077150884;
        Thu, 22 Apr 2021 00:39:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s5sm1253692ejq.52.2021.04.22.00.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:39:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 07/10] trace-cmd library: Extend the create file APIs to support different compression
Date:   Thu, 22 Apr 2021 10:38:59 +0300
Message-Id: <20210422073902.484953-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422073902.484953-1-tz.stoyanov@gmail.com>
References: <20210422073902.484953-1-tz.stoyanov@gmail.com>
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

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       | 15 ++--
 lib/trace-cmd/trace-output.c                  | 80 ++++++++++++++-----
 tracecmd/trace-record.c                       | 10 +--
 tracecmd/trace-restore.c                      |  4 +-
 4 files changed, 74 insertions(+), 35 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 4d2116ab..244e6b4f 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -272,24 +272,27 @@ struct tracecmd_option;
 struct tracecmd_msg_handle;
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
-						     unsigned long file_version);
+						     unsigned long file_version,
+						     const char *compression);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file, struct tracecmd_event_list *list,
-			       unsigned long file_version);
+			       unsigned long file_version, const char *compression);
 struct tracecmd_output *tracecmd_create_init_fd(int fd);
 struct tracecmd_output *
 tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list,
-			     unsigned long file_version);
+			     unsigned long file_version, const char *compression);
 struct tracecmd_output *
 tracecmd_create_init_fd_msg(struct tracecmd_msg_handle *msg_handle,
 			    struct tracecmd_event_list *list,
-			    unsigned long file_version);
+			    unsigned long file_version, const char *compression);
 struct tracecmd_output *tracecmd_create_init_file(const char *output_file,
-						  unsigned long file_version);
+						  unsigned long file_version,
+						  const char *compression);
 struct tracecmd_output *tracecmd_create_init_file_override(const char *output_file,
 							   const char *tracing_dir,
 							   const char *kallsyms,
-							   unsigned long file_version);
+							   unsigned long file_version,
+							   const char *compression);
 struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
 					    unsigned short id, int size,
 					    const void *data);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 75cf143d..5fc7e778 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1021,15 +1021,40 @@ out_free:
 	return ret;
 }
 
-static int select_file_version(struct tracecmd_output *handle, struct tracecmd_input *ihandle,
-			       unsigned long file_version)
+static int select_file_version(struct tracecmd_output *handle,
+				struct tracecmd_input *ihandle,
+				unsigned long file_version, const char *compression)
 {
 	if (ihandle) {
 		handle->file_version = tracecmd_get_file_version(ihandle);
 		handle->compress_proto = tracecmd_get_file_comperssion(ihandle);
-	} else if (file_version > 0) {
+		return 0;
+	}
+
+	if (file_version > 0)
 		handle->file_version = file_version;
-	} else {
+	if (compression) {
+		if (handle->file_version && handle->file_version < 7) {
+			tracecmd_warning("Compression is not supported with trace file version %d",
+					 handle->file_version);
+			return -1;
+		}
+		handle->compress_proto = tracecmd_compress_proto_get(compression, NULL);
+		if (!handle->compress_proto) {
+			tracecmd_warning("Compression algorithm %s is not supported", compression);
+			return -1;
+		}
+		if (!handle->file_version)
+			handle->file_version = 7;
+	} else if (handle->file_version >= 7) {
+		handle->compress_proto = tracecmd_compress_proto_select();
+		if (!handle->compress_proto) {
+			tracecmd_warning("Compression is not supported");
+			return -1;
+		}
+	}
+
+	if (!handle->file_version) {
 		handle->compress_proto = tracecmd_compress_proto_select();
 		if (handle->compress_proto)
 			handle->file_version = 7;
@@ -1065,7 +1090,8 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	       const char *kallsyms,
 	       struct tracecmd_event_list *list,
 	       struct tracecmd_msg_handle *msg_handle,
-	       unsigned long file_version)
+	       unsigned long file_version,
+	       const char *compression)
 {
 	struct tracecmd_output *handle;
 	struct tep_handle *pevent;
@@ -1086,7 +1112,7 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 
 	handle->msg_handle = msg_handle;
 
-	if (select_file_version(handle, ihandle, file_version))
+	if (select_file_version(handle, ihandle, file_version, compression))
 		goto out_free;
 
 	list_head_init(&handle->options);
@@ -1166,7 +1192,7 @@ static struct tracecmd_output *create_file(const char *output_file,
 					   const char *tracing_dir,
 					   const char *kallsyms,
 					   struct tracecmd_event_list *list,
-					   unsigned long file_version)
+					   unsigned long file_version, const char *compression)
 {
 	struct tracecmd_output *handle;
 	int fd;
@@ -1175,7 +1201,7 @@ static struct tracecmd_output *create_file(const char *output_file,
 	if (fd < 0)
 		return NULL;
 
-	handle = create_file_fd(fd, ihandle, tracing_dir, kallsyms, list, NULL, file_version);
+	handle = create_file_fd(fd, ihandle, tracing_dir, kallsyms, list, NULL, file_version, compression);
 	if (!handle) {
 		close(fd);
 		unlink(output_file);
@@ -1482,14 +1508,15 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 }
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
-						     unsigned long file_version)
+						     unsigned long file_version,
+						     const char *compression)
 {
 	struct tracecmd_output *handle;
 	char *path;
 	int ret;
 
 	handle = create_file(output_file, NULL, NULL, NULL,
-			     &all_event_list, file_version);
+			     &all_event_list, file_version, compression);
 	if (!handle)
 		return NULL;
 
@@ -1785,46 +1812,48 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 
 struct tracecmd_output *tracecmd_create_init_fd(int fd)
 {
-	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list, NULL, 0);
+	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list, NULL, 0, NULL);
 }
 
 struct tracecmd_output *
 tracecmd_create_init_fd_msg(struct tracecmd_msg_handle *msg_handle,
 			    struct tracecmd_event_list *list,
-			    unsigned long file_version)
+			    unsigned long file_version, const char *compression)
 {
 	return create_file_fd(msg_handle->fd, NULL, NULL, NULL,
-			      list, msg_handle, file_version);
+			      list, msg_handle, file_version, compression);
 }
 
 struct tracecmd_output *
 tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list,
-			     unsigned long file_version)
+			     unsigned long file_version, const char *compression)
 {
-	return create_file_fd(fd, NULL, NULL, NULL, list, NULL, file_version);
+	return create_file_fd(fd, NULL, NULL, NULL, list, NULL, file_version, compression);
 }
 
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file, struct tracecmd_event_list *list,
-			       unsigned long file_version)
+			       unsigned long file_version, const char *compression)
 {
-	return create_file(output_file, NULL, NULL, NULL, list, file_version);
+	return create_file(output_file, NULL, NULL, NULL, list, file_version, compression);
 }
 
 struct tracecmd_output *tracecmd_create_init_file(const char *output_file,
-						  unsigned long file_version)
+						  unsigned long file_version,
+						  const char *compression)
 {
 	return create_file(output_file, NULL, NULL, NULL,
-			   &all_event_list, file_version);
+			   &all_event_list, file_version, compression);
 }
 
 struct tracecmd_output *tracecmd_create_init_file_override(const char *output_file,
 							   const char *tracing_dir,
 							   const char *kallsyms,
-							   unsigned long file_version)
+							   unsigned long file_version,
+							   const char *compression)
 {
 	return create_file(output_file, NULL, tracing_dir, kallsyms,
-			   &all_event_list, file_version);
+			   &all_event_list, file_version, compression);
 }
 
 /**
@@ -1839,10 +1868,17 @@ struct tracecmd_output *tracecmd_create_init_file_override(const char *output_fi
 struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 				      const char *file)
 {
+	struct tracecmd_compress_proto *compr;
 	struct tracecmd_output *handle;
+	const char *compr_name = NULL;
+
+
+	compr = tracecmd_get_file_comperssion(ihandle);
+	if (compr)
+		tracecmd_compress_proto_get_name(compr, &compr_name, NULL);
 
 	handle = create_file(file, ihandle, NULL, NULL, &all_event_list,
-			     tracecmd_get_file_version(ihandle));
+			     tracecmd_get_file_version(ihandle), compr_name);
 	if (!handle)
 		return NULL;
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f95db0e4..b8126eae 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3647,7 +3647,7 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
 		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events,
-							     ctx->file_version);
+							     ctx->file_version, NULL);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -3666,7 +3666,7 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 			goto error;
 	} else {
 		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd, listed_events,
-							      ctx->file_version);
+							      ctx->file_version, NULL);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -3854,7 +3854,7 @@ static void setup_agent(struct buffer_instance *instance,
 	struct tracecmd_output *network_handle;
 
 	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle, listed_events,
-						     ctx->file_version);
+						     ctx->file_version, NULL);
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
@@ -4247,7 +4247,7 @@ static void record_data(struct common_record_context *ctx)
 
 	if (latency) {
 		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
-						      ctx->file_version);
+						      ctx->file_version, NULL);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
@@ -4279,7 +4279,7 @@ static void record_data(struct common_record_context *ctx)
 		}
 
 		handle = tracecmd_create_init_file_glob(ctx->output, listed_events,
-							ctx->file_version);
+							ctx->file_version, NULL);
 		if (!handle)
 			die("Error creating output file");
 		tracecmd_set_quiet(handle, quiet);
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index f2b15434..4b6a0c12 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -91,7 +91,7 @@ void trace_restore (int argc, char **argv)
 		}
 
 		handle = tracecmd_create_init_file_override(output, tracing_dir,
-							    kallsyms, 0);
+							    kallsyms, 0, NULL);
 		if (!handle)
 			die("Unabled to create output file %s", output);
 		if (tracecmd_write_cmdlines(handle) < 0)
@@ -128,7 +128,7 @@ void trace_restore (int argc, char **argv)
 		handle = tracecmd_copy(ihandle, output);
 		tracecmd_close(ihandle);
 	} else
-		handle = tracecmd_create_init_file(output, 0);
+		handle = tracecmd_create_init_file(output, 0, NULL);
 
 	if (!handle)
 		die("error writing to %s", output);
-- 
2.30.2

