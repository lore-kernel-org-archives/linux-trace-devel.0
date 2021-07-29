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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DDADC4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 892D261052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhG2FKU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhG2FKT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:19 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0574DC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:16 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id nb11so8482531ejc.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bkA0GZ2ckBzgKYqrlrHBm/kGHPZC3u/giUqUO8SvXiQ=;
        b=kOihxZtsxBgTpcIrklvIH0ZFVu4yEXuz+3PpwgWJ3cVjhNLp3N0euwuLdeCn8k6xd8
         wsyrwofKSSKKZeKgghwFh+4Ih5ljg3HJ2d2GImYM6eP8C1TnaAPw2eL2b9GIQBKh8aOC
         94QL1RhoKp38L8/t/1z8nhqE1SRS+aZsf7Ks9/1PjvPjW1w5tOtX5ELSNn52mW8iw+Ba
         r0PoMHu27dWcyD1CCSNsFZiG0hCc9EKTpe69LJofGeNh83Qh64y2CJFhH/llIdmi6ixy
         hD9Rk2cbHR3f+yZRFp02mB5ZJLQsoZIo+zKhl5TXecGPvt5faYfn4pHBWwRfupaJPGNM
         Dzaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bkA0GZ2ckBzgKYqrlrHBm/kGHPZC3u/giUqUO8SvXiQ=;
        b=WkUMTnMcuu6o3z0QLT8bIx0nl4PY345ei5vcqpY5qVch1UX/R2+P3wm9uDCcPgoXjZ
         Ag1ceg3NpKCvbucMIBd3gx+8Xgn7hvts14HfADZwHquM1Yx3MyAu1hpRJ8urzNHMWFDm
         Epb+EOV3qgI+567I0EL4rxSDY+9S9rrUwmUZJJPSYueMVfM/zIIpCUhJeACnyIgbLqvF
         uKOPZO713AsRt6cnkus6Lfg2te3E85N3X1oijBX7EnXBCiZSacZCwzQB+CTxGu0XJ48H
         hho7fDdbqMt0qRtSe2BPHCZ+sQVk0bbupyTJB7NSQoYxbAZhXBRQcGAtHuvOPlAylHpK
         eg5A==
X-Gm-Message-State: AOAM530M6uDN4GqvT9m87fjmpwH7PBR7LfM5vTKrGS8mkiAIRhqkLYTE
        x0TMN2KOcTr6Jtr9UoPqxWI=
X-Google-Smtp-Source: ABdhPJzrr9o06xyUviLlT/skq9W6J3S5Iybj731L4n3kFuggZaW73nnIAKTIQA3E14IL9WpOGZdEVw==
X-Received: by 2002:a17:906:a24c:: with SMTP id bi12mr2884877ejb.530.1627535414406;
        Wed, 28 Jul 2021 22:10:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 13/87] trace-cmd library: Refactor APIs for creating output handler
Date:   Thu, 29 Jul 2021 08:08:45 +0300
Message-Id: <20210729050959.12263-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In the trace-cmd library there are various APIs for allocating and
initializing output handler to a trace file. The existing APIs are use
case oriented, with a lot of parameters. Extending them for new use
cases, adding more input parameters, will make the library more complex
and not easy to use.
Almost all use case oriented APIs for output handler creation are
removed and replaced with new flow, which is easier to be extended with
new creation parameters.

Removed APIs:
 tracecmd_create_init_fd_msg()
 tracecmd_create_init_file_glob()
 tracecmd_create_init_fd_glob()
 tracecmd_create_init_file_override()

New APIs:
 tracecmd_output_allocate()
 tracecmd_output_set_msg()
 tracecmd_output_set_trace_dir()
 tracecmd_output_set_kallsyms()
 tracecmd_output_set_from_input()
 tracecmd_output_set_version()
 tracecmd_output_write_init()
 tracecmd_output_write_headers()

The new tracecmd_output_allocate() API allocates memory and performs
minimalinitialization of an output handler to a trace file. No data
is written in the file.
The tracecmd_output_set_...() APIs can be used to set various
parameters to the newly allocated output handler, that affect the way
the data is written into the file.
When the output handler is configured for the desired use case, the
tracecmd_output_write_init() is used to start writing to the file, it
writes initial magic bytes.
The tracecmd_output_write_headers() API is used to write the initial
headers into the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  29 +-
 lib/trace-cmd/trace-output.c                  | 437 ++++++++++++------
 tracecmd/trace-record.c                       |  64 ++-
 tracecmd/trace-restore.c                      |  32 +-
 4 files changed, 395 insertions(+), 167 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index c3b407a0..16dbed56 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -105,7 +105,8 @@ static inline int tracecmd_host_bigendian(void)
 /* --- Opening and Reading the trace.dat file --- */
 
 enum tracecmd_file_states {
-	TRACECMD_FILE_INIT = 1,
+	TRACECMD_FILE_ALLOCATED = 0,
+	TRACECMD_FILE_INIT,
 	TRACECMD_FILE_HEADERS,
 	TRACECMD_FILE_FTRACE_EVENTS,
 	TRACECMD_FILE_ALL_EVENTS,
@@ -271,20 +272,22 @@ struct tracecmd_event_list {
 struct tracecmd_option;
 struct tracecmd_msg_handle;
 
-struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
-struct tracecmd_output *
-tracecmd_create_init_file_glob(const char *output_file,
-			       struct tracecmd_event_list *list);
+struct tracecmd_output *tracecmd_output_allocate(int fd);
+int tracecmd_output_set_msg(struct tracecmd_output *handler,
+			    struct tracecmd_msg_handle *msg_handle);
+int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *tracing_dir);
+int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms);
+int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle);
+int tracecmd_output_set_version(struct tracecmd_output *handler, int file_version);
+int tracecmd_output_write_init(struct tracecmd_output *handler);
+int tracecmd_output_write_headers(struct tracecmd_output *handler,
+				  struct tracecmd_event_list *list);
+
+struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
+						     int file_version);
 struct tracecmd_output *tracecmd_create_init_fd(int fd);
-struct tracecmd_output *
-tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list);
-struct tracecmd_output *
-tracecmd_create_init_fd_msg(struct tracecmd_msg_handle *msg_handle,
-			    struct tracecmd_event_list *list);
+
 struct tracecmd_output *tracecmd_create_init_file(const char *output_file);
-struct tracecmd_output *tracecmd_create_init_file_override(const char *output_file,
-							   const char *tracing_dir,
-							   const char *kallsyms);
 struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
 					    unsigned short id, int size,
 					    const void *data);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index ae35c12d..e1373e80 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -31,11 +31,6 @@
 typedef unsigned long long	tsize_t;
 typedef long long		stsize_t;
 
-static struct tracecmd_event_list all_event_list = {
-	.next = NULL,
-	.glob = "all"
-};
-
 struct tracecmd_option {
 	unsigned short	id;
 	int		size;
@@ -54,11 +49,14 @@ struct tracecmd_output {
 	int			cpus;
 	struct tep_handle	*pevent;
 	char			*tracing_dir;
+	char			*kallsyms;
+	struct tracecmd_event_list *events;
 	int			nr_options;
 	bool			quiet;
 	unsigned long		file_state;
 	unsigned long		file_version;
 	size_t			options_start;
+	bool			big_endian;
 	bool			do_compress;
 	struct tracecmd_compression *compress;
 
@@ -769,7 +767,7 @@ static int read_event_files(struct tracecmd_output *handle,
 			break;
 	}
 	/* all events are listed, use a global glob */
-	if (list)
+	if (!event_list || list)
 		event_list = &all_events;
 
 	systems = create_event_list(handle, event_list);
@@ -839,8 +837,7 @@ err:
 		tracecmd_warning("can't set kptr_restrict");
 }
 
-static int read_proc_kallsyms(struct tracecmd_output *handle,
-			      const char *kallsyms)
+static int read_proc_kallsyms(struct tracecmd_output *handle)
 {
 	unsigned int size, check_size, endian4;
 	const char *path = "/proc/kallsyms";
@@ -853,8 +850,8 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
 		return -1;
 	}
 
-	if (kallsyms)
-		path = kallsyms;
+	if (handle->kallsyms)
+		path = handle->kallsyms;
 
 	ret = stat(path, &st);
 	if (ret < 0) {
@@ -970,137 +967,272 @@ out_free:
 	return ret;
 }
 
-static int select_file_version(struct tracecmd_output *handle,
-				struct tracecmd_input *ihandle)
+/**
+ * tracecmd_output_allocate - allocate new output handler to a trace file
+ * @handle: file descriptor to an empty file, it can be -1 if the handler
+ *	    will not write to a file
+ *
+ * This API only allocates a handler and performs minimal initialization.
+ * No data is written in the file.
+ *
+ * Returns pointer to a newly allocated file descriptor, that can be used
+ * with other library APIs. In case of an error, NULL is returned. The returned
+ * handler must be freed with tracecmd_output_close() or tracecmd_output_free()
+ */
+struct tracecmd_output *tracecmd_output_allocate(int fd)
 {
-	if (ihandle)
-		handle->file_version = tracecmd_get_in_file_version(ihandle);
+	struct tracecmd_output *handle;
+
+	handle = calloc(1, sizeof(*handle));
+	if (!handle)
+		return NULL;
+
+	handle->fd = fd;
+
+	handle->file_version = FILE_VERSION_DEFAULT;
+
+	handle->page_size = getpagesize();
+
+	if (tracecmd_host_bigendian())
+		handle->big_endian = true;
 	else
-		handle->file_version = FILE_VERSION_DEFAULT;
+		handle->big_endian = false;
 
-	return 0;
+	list_head_init(&handle->options);
+
+	handle->file_state = TRACECMD_FILE_ALLOCATED;
+
+	return handle;
 }
 
-static struct tracecmd_output *
-create_file_fd(int fd, struct tracecmd_input *ihandle,
-	       const char *tracing_dir,
-	       const char *kallsyms,
-	       struct tracecmd_event_list *list,
-	       struct tracecmd_msg_handle *msg_handle)
+/**
+ * tracecmd_output_set_msg - associated an output file handler with network message handler
+ * @handle: output handler to a trace file.
+ * @msg_handle: network handler, allocated by tracecmd_msg_handle_alloc()
+ *
+ * This API associates an output file handler with a network stream. All subsequent API calls
+ * with this output file handler will send data over the network using the @msg_handle, instead
+ * of writing to a file.
+ * This API must be called after the handler file version is set and before
+ * tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ */
+int tracecmd_output_set_msg(struct tracecmd_output *handler, struct tracecmd_msg_handle *msg_handle)
 {
-	struct tracecmd_output *handle;
-	struct tep_handle *pevent;
-	char buf[BUFSIZ];
-	int endian4;
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
 
-	handle = malloc(sizeof(*handle));
-	if (!handle)
-		return NULL;
-	memset(handle, 0, sizeof(*handle));
+	handler->msg_handle = msg_handle;
+	/* Force messages to be cached in a temp file before sending through the socket */
+	if (handler->msg_handle && handler->file_version >= 7)
+		tracecmd_msg_handle_cache(handler->msg_handle);
 
-	list_head_init(&handle->options);
+	return 0;
+}
 
-	handle->fd = fd;
+/**
+ * tracecmd_output_set_trace_dir - Set a custom tracing dir, instead of system default
+ * @handle: output handler to a trace file.
+ * @tracing_dir: full path to a directory with tracing files
+ *
+ * This API associates an output file handler with a custom tracing directory, to be used when
+ * creating the trace file instead of the system default tracing directory.
+ * This API must be called before tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ */
+int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *tracing_dir)
+{
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+
+	free(handler->tracing_dir);
 	if (tracing_dir) {
-		handle->tracing_dir = strdup(tracing_dir);
-		if (!handle->tracing_dir)
-			goto out_free;
-	}
+		handler->tracing_dir = strdup(tracing_dir);
+		if (!handler->tracing_dir)
+			return -1;
+	} else
+		handler->tracing_dir = NULL;
 
-	handle->msg_handle = msg_handle;
+	return 0;
+}
 
-	if (select_file_version(handle, ihandle))
-		goto out_free;
+/**
+ * tracecmd_output_set_kallsyms - Set a custom kernel symbols file, instead of system default
+ * @handle: output handler to a trace file.
+ * @tracing_dir: full path to a file with kernel symbols
+ *
+ * This API associates an output file handler with a custom kernel symbols file, to be used when
+ * creating the trace file instead of the system default kernel symbols file.
+ * This API must be called before tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ */
+int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms)
+{
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
 
-	buf[0] = 23;
-	buf[1] = 8;
-	buf[2] = 68;
-	memcpy(buf + 3, "tracing", 7);
+	free(handler->kallsyms);
+	if (kallsyms) {
+		handler->kallsyms = strdup(kallsyms);
+		if (!handler->kallsyms)
+			return -1;
+	} else
+		handler->kallsyms = NULL;
 
-	if (do_write_check(handle, buf, 10))
-		goto out_free;
+	return 0;
+}
 
-	sprintf(buf, "%lu", handle->file_version);
-	if (do_write_check(handle, buf, strlen(buf) + 1))
-		goto out_free;
+/**
+ * tracecmd_output_set_from_input - Inherit parameters from an existing trace file
+ * @handle: output handler to a trace file.
+ * @ihandle: input handler to an existing trace file.
+ *
+ * This API copies parameters from input handler @ihandle, associated with an existing trace file,
+ * to the output handler @handle, associated with file that is going to be created.
+ * These parameters are copied:
+ *  - tep handler
+ *  - page size
+ *  - file endian
+ *  - file version
+ *  - file compression protocol
+ * This API must be called before tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ */
+int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle)
+{
+	if (!handler || !ihandle || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
 
-	/* get endian and page size */
-	if (ihandle) {
-		pevent = tracecmd_get_tep(ihandle);
-		/* Use the pevent of the ihandle for later writes */
-		handle->pevent = tracecmd_get_tep(ihandle);
-		tep_ref(pevent);
-		if (tep_is_file_bigendian(pevent))
-			buf[0] = 1;
-		else
-			buf[0] = 0;
-		handle->page_size = tracecmd_page_size(ihandle);
-	} else {
-		if (tracecmd_host_bigendian())
-			buf[0] = 1;
-		else
-			buf[0] = 0;
-		handle->page_size = getpagesize();
-	}
+	/* get endian, page size, file version and compression */
+	/* Use the pevent of the ihandle for later writes */
+	handler->pevent = tracecmd_get_tep(ihandle);
+	tep_ref(handler->pevent);
+	handler->page_size = tracecmd_page_size(ihandle);
+	handler->file_version = tracecmd_get_in_file_version(ihandle);
+	if (tep_is_file_bigendian(handler->pevent))
+		handler->big_endian = true;
+	else
+		handler->big_endian = false;
 
-	if (do_write_check(handle, buf, 1))
-		goto out_free;
 
-	/* save size of long (this may not be what the kernel is) */
-	buf[0] = sizeof(long);
-	if (do_write_check(handle, buf, 1))
-		goto out_free;
+	return 0;
+}
 
-	endian4 = convert_endian_4(handle, handle->page_size);
-	if (do_write_check(handle, &endian4, 4))
-		goto out_free;
-	handle->file_state = TRACECMD_FILE_INIT;
+/**
+ * tracecmd_output_set_version - Set file version of the output handler
+ * @handle: output handler to a trace file.
+ * @file_version: desired file version
+ *
+ * This API must be called before tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ */
+int tracecmd_output_set_version(struct tracecmd_output *handler, int file_version)
+{
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+	if (file_version < FILE_VERSION_MIN || file_version > FILE_VERSION_MAX)
+		return -1;
+	handler->file_version = file_version;
+	if (handler->file_version < 7)
+		handler->compress = NULL;
+	return 0;
+}
 
-	if (ihandle)
-		return handle;
 
-	if (read_header_files(handle))
-		goto out_free;
+/**
+ * tracecmd_output_write_init - Write the initial magics in the trace file
+ * @handle: output handler to a trace file.
+ *
+ * This API must be called after all tracecmd_output_set_...() APIs and before writing anything
+ * to the trace file. This initial information is written in the file:
+ *  - initial file magic bytes
+ *  - file version
+ *  - data endian
+ *  - long size
+ *  - page size
+ *  - compression header
+ *
+ * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ */
+int tracecmd_output_write_init(struct tracecmd_output *handler)
+{
+	char buf[BUFSIZ];
+	int endian4;
 
-	if (read_ftrace_files(handle))
-		goto out_free;
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
 
-	if (read_event_files(handle, list))
-		goto out_free;
+	buf[0] = 23;
+	buf[1] = 8;
+	buf[2] = 68;
+	memcpy(buf + 3, "tracing", 7);
 
-	if (read_proc_kallsyms(handle, kallsyms))
-		goto out_free;
+	if (do_write_check(handler, buf, 10))
+		return -1;
 
-	if (read_ftrace_printk(handle))
-		goto out_free;
+	sprintf(buf, "%lu", handler->file_version);
+	if (do_write_check(handler, buf, strlen(buf) + 1))
+		return -1;
 
-	return handle;
+	if (handler->big_endian)
+		buf[0] = 1;
+	else
+		buf[0] = 0;
+	if (do_write_check(handler, buf, 1))
+		return -1;
 
- out_free:
-	tracecmd_output_close(handle);
-	return NULL;
+	/* save size of long (this may not be what the kernel is) */
+	buf[0] = sizeof(long);
+	if (do_write_check(handler, buf, 1))
+		return -1;
+
+	endian4 = convert_endian_4(handler, handler->page_size);
+	if (do_write_check(handler, &endian4, 4))
+		return -1;
+	handler->file_state = TRACECMD_FILE_INIT;
+	return 0;
 }
 
-static struct tracecmd_output *create_file(const char *output_file,
-					   struct tracecmd_input *ihandle,
-					   const char *tracing_dir,
-					   const char *kallsyms,
-					   struct tracecmd_event_list *list)
+/**
+ * tracecmd_output_write_headers - Write the trace file headers
+ * @handle: output handler to a trace file.
+ * @list: desired events that will be included in the trace file.
+ *	  It can be NULL for all available events
+ *
+ * These headers are written in the file:
+ *  - header files from the tracing directory
+ *  - ftrace events from the tracing directory
+ *  - event file from the tracing directory - all or only the one from @list
+ *  - kernel symbols from the tracing directory
+ *  - kernel printk strings from the tracing directory
+ *
+ * Returns 0 on success, or -1 in case of an error.
+ */
+int tracecmd_output_write_headers(struct tracecmd_output *handler,
+				  struct tracecmd_event_list *list)
 {
-	struct tracecmd_output *handle;
-	int fd;
-
-	fd = open(output_file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
-	if (fd < 0)
-		return NULL;
-
-	handle = create_file_fd(fd, ihandle, tracing_dir, kallsyms, list, NULL);
-	if (!handle) {
-		close(fd);
-		unlink(output_file);
-	}
+	if (!handler || handler->file_state < TRACECMD_FILE_ALLOCATED)
+		return -1;
 
-	return handle;
+	/* Write init data, if not written yet */
+	if (handler->file_state < TRACECMD_FILE_INIT && tracecmd_output_write_init(handler))
+		return -1;
+	if (read_header_files(handler))
+		return -1;
+	if (read_ftrace_files(handler))
+		return -1;
+	if (read_event_files(handler, list))
+		return -1;
+	if (read_proc_kallsyms(handler))
+		return -1;
+	if (read_ftrace_printk(handler))
+		return -1;
+	return 0;
 }
 
 /**
@@ -1354,16 +1486,26 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 	return 0;
 }
 
-struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
+struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
+						     int file_version)
 {
 	struct tracecmd_output *handle;
 	char *path;
-	int ret;
+	int fd;
 
-	handle = create_file(output_file, NULL, NULL, NULL, &all_event_list);
-	if (!handle)
+	fd = open(output_file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (fd < 0)
 		return NULL;
 
+	handle = tracecmd_output_allocate(fd);
+	if (!handle)
+		goto out_free;
+	if (file_version && tracecmd_output_set_version(handle, file_version))
+		goto out_free;
+	if (tracecmd_output_write_init(handle))
+		goto out_free;
+	if (tracecmd_output_write_headers(handle, NULL))
+		goto out_free;
 	/*
 	 * Save the command lines;
 	 */
@@ -1376,8 +1518,7 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
-	ret = check_out_state(handle, TRACECMD_FILE_CPU_LATENCY);
-	if (ret < 0) {
+	if (!check_out_state(handle, TRACECMD_FILE_CPU_LATENCY)) {
 		tracecmd_warning("Cannot write latency data into the file, unexpected state 0x%X",
 				 handle->file_state);
 		goto out_free;
@@ -1656,39 +1797,38 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 
 struct tracecmd_output *tracecmd_create_init_fd(int fd)
 {
-	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list, NULL);
-}
-
-struct tracecmd_output *
-tracecmd_create_init_fd_msg(struct tracecmd_msg_handle *msg_handle,
-			    struct tracecmd_event_list *list)
-{
-	return create_file_fd(msg_handle->fd, NULL, NULL, NULL, list, msg_handle);
-}
-
-struct tracecmd_output *
-tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list)
-{
-	return create_file_fd(fd, NULL, NULL, NULL, list, NULL);
-}
+	struct tracecmd_output *out;
 
-struct tracecmd_output *
-tracecmd_create_init_file_glob(const char *output_file,
-			       struct tracecmd_event_list *list)
-{
-	return create_file(output_file, NULL, NULL, NULL, list);
+	out = tracecmd_output_allocate(fd);
+	if (!out)
+		return NULL;
+	if (tracecmd_output_write_init(out))
+		goto error;
+	if (tracecmd_output_write_headers(out, NULL))
+		goto error;
+
+	return out;
+error:
+	tracecmd_output_close(out);
+	return NULL;
 }
 
 struct tracecmd_output *tracecmd_create_init_file(const char *output_file)
 {
-	return create_file(output_file, NULL, NULL, NULL, &all_event_list);
-}
+	struct tracecmd_output *handle;
+	int fd;
 
-struct tracecmd_output *tracecmd_create_init_file_override(const char *output_file,
-							   const char *tracing_dir,
-							   const char *kallsyms)
-{
-	return create_file(output_file, NULL, tracing_dir, kallsyms, &all_event_list);
+	fd = open(output_file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (fd < 0)
+		return NULL;
+	handle = tracecmd_create_init_fd(fd);
+	if (!handle) {
+		close(fd);
+		unlink(output_file);
+		return NULL;
+	}
+
+	return handle;
 }
 
 /**
@@ -1704,11 +1844,18 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 				      const char *file)
 {
 	struct tracecmd_output *handle;
+	int fd;
 
-	handle = create_file(file, ihandle, NULL, NULL, &all_event_list);
-	if (!handle)
+	fd = open(file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (fd < 0)
 		return NULL;
 
+	handle = tracecmd_output_allocate(fd);
+	if (!handle)
+		goto out_free;
+	if (tracecmd_output_set_from_input(handle, ihandle))
+		goto out_free;
+	tracecmd_output_write_init(handle);
 	if (tracecmd_copy_headers(ihandle, handle->fd, 0, 0) < 0)
 		goto out_free;
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 9780cedd..8080d612 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3690,6 +3690,27 @@ again:
 
 static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx);
 
+static struct tracecmd_output *create_net_output(struct common_record_context *ctx,
+						 struct tracecmd_msg_handle *msg_handle)
+{
+	struct tracecmd_output *out;
+
+	out = tracecmd_output_allocate(-1);
+	if (!out)
+		return NULL;
+	if (ctx->file_version && tracecmd_output_set_version(out, ctx->file_version))
+		goto error;
+	if (tracecmd_output_set_msg(out, msg_handle))
+		goto error;
+	if (tracecmd_output_write_headers(out, listed_events))
+		goto error;
+
+	return out;
+error:
+	tracecmd_output_close(out);
+	return NULL;
+}
+
 static struct tracecmd_msg_handle *
 setup_connection(struct buffer_instance *instance, struct common_record_context *ctx)
 {
@@ -3701,7 +3722,7 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
-		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
+		network_handle = create_net_output(ctx, msg_handle);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -3719,10 +3740,13 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 	} else {
-		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
-							      listed_events);
+		network_handle = tracecmd_output_allocate(msg_handle->fd);
 		if (!network_handle)
 			goto error;
+		if (tracecmd_output_set_version(network_handle, ctx->file_version))
+			goto error;
+		if (tracecmd_output_write_headers(network_handle, listed_events))
+			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
 	}
 
@@ -4068,8 +4092,7 @@ static void setup_agent(struct buffer_instance *instance,
 {
 	struct tracecmd_output *network_handle;
 
-	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
-						     listed_events);
+	network_handle = create_net_output(ctx, instance->msg_handle);
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
@@ -4438,6 +4461,32 @@ static void write_guest_file(struct buffer_instance *instance)
 	free(temp_files);
 }
 
+static struct tracecmd_output *create_output(struct common_record_context *ctx)
+{
+	struct tracecmd_output *out;
+	int fd;
+
+	fd = open(ctx->output, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (fd < 0)
+		return NULL;
+
+	out = tracecmd_output_allocate(fd);
+	if (!out)
+		goto error;
+	if (ctx->file_version && tracecmd_output_set_version(out, ctx->file_version))
+		goto error;
+	if (tracecmd_output_write_headers(out, listed_events))
+		goto error;
+	return out;
+error:
+	if (out)
+		tracecmd_output_close(out);
+	else
+		close(fd);
+	unlink(ctx->output);
+	return NULL;
+}
+
 static void record_data(struct common_record_context *ctx)
 {
 	struct tracecmd_option **buffer_options;
@@ -4461,7 +4510,8 @@ static void record_data(struct common_record_context *ctx)
 		return;
 
 	if (latency) {
-		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count);
+		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
+						      ctx->file_version);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
@@ -4492,7 +4542,7 @@ static void record_data(struct common_record_context *ctx)
 				touch_file(temp_files[i]);
 		}
 
-		handle = tracecmd_create_init_file_glob(ctx->output, listed_events);
+		handle = create_output(ctx);
 		if (!handle)
 			die("Error creating output file");
 		tracecmd_set_quiet(handle, quiet);
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 280a37f0..8d2fcae8 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -22,6 +22,35 @@
 
 #include "trace-local.h"
 
+static struct tracecmd_output *create_output(const char *file,
+					     const char *tracing_dir, const char *kallsyms)
+{
+	struct tracecmd_output *out;
+	int fd;
+
+	fd = open(file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (fd < 0)
+		return NULL;
+
+	out = tracecmd_output_allocate(fd);
+	if (!out)
+		goto error;
+	if (tracing_dir && tracecmd_output_set_trace_dir(out, tracing_dir))
+		goto error;
+	if (kallsyms && tracecmd_output_set_kallsyms(out, kallsyms))
+		goto error;
+	if (tracecmd_output_write_headers(out, NULL))
+		goto error;
+	return out;
+error:
+	if (out)
+		tracecmd_output_close(out);
+	else
+		close(fd);
+	unlink(file);
+	return NULL;
+}
+
 void trace_restore (int argc, char **argv)
 {
 	struct tracecmd_output *handle;
@@ -90,8 +119,7 @@ void trace_restore (int argc, char **argv)
 			usage(argv);
 		}
 
-		handle = tracecmd_create_init_file_override(output, tracing_dir,
-							    kallsyms);
+		handle = create_output(output, tracing_dir, kallsyms);
 		if (!handle)
 			die("Unabled to create output file %s", output);
 		if (tracecmd_write_cmdlines(handle) < 0)
-- 
2.31.1

