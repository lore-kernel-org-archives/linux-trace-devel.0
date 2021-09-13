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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65AE5C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FEBC60555
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240004AbhIMM3i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236796AbhIMM3h (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:37 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3F1C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:21 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id g16so14444535wrb.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Zt0veOqDDSXpzCVbb+xlRgowJ7dD1XDzcMmVcCpCxA=;
        b=Y770IVQa7nOWLaRWQGIpZ8kWrk93tRzQcMOuiMSLrJY69w/GuQd3Kh+J8h3mIq8gbl
         TB7sPs9XZS2sLo2a0gQkug4WY7vDN+rBh6KSLesfDqk4MurpKFqxkm6PWK3YUdJR13Hb
         511NbKRe2dB0hElizJ192Wa/sEKYlrgxbUsbeOVqRz4E7LrCf7T32IecErGVTos8k8og
         HnMdXHSG4jt9gQFUDUr1ugi2R7Pd6OZdEoCMXnFpR+xrQstduI+LM2C3whW07CRdz8+a
         KTvHvQE9vHA/rEaRTzo9gSaILbja+0DiI+TSxZQOhbjWqJ+XdNqHJ+PBoqG6R2/fYTC4
         jplA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Zt0veOqDDSXpzCVbb+xlRgowJ7dD1XDzcMmVcCpCxA=;
        b=8CVgAtA02eEfTZLKGZvvzOFwQGWgOTbXkRfSMgXnXKBtahBKiqSlLZCi+Jhj401GOT
         XHE2eBh92s4afjOx7Bqge7gNDC+CIwWNOnCzJG7N/LsPhLAijo8g0Cd2IwrnTHD7+UCJ
         6U66697OYmX+B7BdMuAXlwMEG+bAUiV0OdhJO0wIDZAlAD0Xwxj+/v6RGaTTbe/TPSst
         nYJNCPBxmiLtkaGPYTYN/Hefj6XbNjJeJ2tIo3uM/ydENoN0A3WU4QSfFy9B2VToDq05
         4yaVA43qy2hvvTjp4HsBX2Cwu9hggnUBM7h5e5K0AlXJuZol2Ak7wewvaDWgfMNgZI/v
         Vs6g==
X-Gm-Message-State: AOAM531qGSsl9pG5mHg2OvVrreScVHIPG8xfgUWw7D84XosUqCueprzO
        6iFgNALVQVRNSpSJVm3Wu72i5tzSMsc=
X-Google-Smtp-Source: ABdhPJzeJ+bBRS4ORsIHhcpnmb8v5SD7UtzKBZWcpCdE7+FnN5Xu6TC14zpWW8npvPGlwAhqiMUjSw==
X-Received: by 2002:a5d:650b:: with SMTP id x11mr12136433wru.350.1631536100205;
        Mon, 13 Sep 2021 05:28:20 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:19 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 19/21] trace-cmd library: Refactor APIs for creating output handler
Date:   Mon, 13 Sep 2021 15:27:57 +0300
Message-Id: <20210913122759.3672494-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
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
 tracecmd_output_write_init()
 tracecmd_output_write_headers()

The new tracecmd_output_allocate() API allocates memory and performs
minimal initialization of an output handler to a trace file. No data
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
 .../include/private/trace-cmd-private.h       |  25 +-
 lib/trace-cmd/trace-output.c                  | 406 ++++++++++++------
 tracecmd/trace-record.c                       |  55 ++-
 tracecmd/trace-restore.c                      |  32 +-
 4 files changed, 356 insertions(+), 162 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index c58b09e9..167f3804 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -102,7 +102,8 @@ static inline int tracecmd_host_bigendian(void)
 /* --- Opening and Reading the trace.dat file --- */
 
 enum tracecmd_file_states {
-	TRACECMD_FILE_INIT = 1,
+	TRACECMD_FILE_ALLOCATED = 0,
+	TRACECMD_FILE_INIT,
 	TRACECMD_FILE_HEADERS,
 	TRACECMD_FILE_FTRACE_EVENTS,
 	TRACECMD_FILE_ALL_EVENTS,
@@ -268,20 +269,20 @@ struct tracecmd_event_list {
 struct tracecmd_option;
 struct tracecmd_msg_handle;
 
+struct tracecmd_output *tracecmd_output_allocate(int fd);
+int tracecmd_output_set_msg(struct tracecmd_output *handler,
+			    struct tracecmd_msg_handle *msg_handle);
+int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *tracing_dir);
+int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms);
+int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle);
+int tracecmd_output_write_init(struct tracecmd_output *handler);
+int tracecmd_output_write_headers(struct tracecmd_output *handler,
+				  struct tracecmd_event_list *list);
+
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
-struct tracecmd_output *
-tracecmd_create_init_file_glob(const char *output_file,
-			       struct tracecmd_event_list *list);
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
index fe1d1aaa..20116d99 100644
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
 
 	struct list_head	options;
 	struct tracecmd_msg_handle *msg_handle;
@@ -682,7 +680,7 @@ static int read_event_files(struct tracecmd_output *handle,
 			break;
 	}
 	/* all events are listed, use a global glob */
-	if (list)
+	if (!event_list || list)
 		event_list = &all_events;
 
 	systems = create_event_list(handle, event_list);
@@ -752,8 +750,7 @@ err:
 		tracecmd_warning("can't set kptr_restrict");
 }
 
-static int read_proc_kallsyms(struct tracecmd_output *handle,
-			      const char *kallsyms)
+static int read_proc_kallsyms(struct tracecmd_output *handle)
 {
 	unsigned int size, check_size, endian4;
 	const char *path = "/proc/kallsyms";
@@ -766,8 +763,8 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
 		return -1;
 	}
 
-	if (kallsyms)
-		path = kallsyms;
+	if (handle->kallsyms)
+		path = handle->kallsyms;
 
 	ret = stat(path, &st);
 	if (ret < 0) {
@@ -883,137 +880,247 @@ out_free:
 	return ret;
 }
 
-static int select_file_version(struct tracecmd_output *handle,
-				struct tracecmd_input *ihandle)
-{
-	if (ihandle)
-		handle->file_version = tracecmd_get_in_file_version(ihandle);
-	else
-		handle->file_version = FILE_VERSION;
-
-	return 0;
-}
-
-static struct tracecmd_output *
-create_file_fd(int fd, struct tracecmd_input *ihandle,
-	       const char *tracing_dir,
-	       const char *kallsyms,
-	       struct tracecmd_event_list *list,
-	       struct tracecmd_msg_handle *msg_handle)
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
 	struct tracecmd_output *handle;
-	struct tep_handle *pevent;
-	char buf[BUFSIZ];
-	int endian4;
 
-	handle = malloc(sizeof(*handle));
+	handle = calloc(1, sizeof(*handle));
 	if (!handle)
 		return NULL;
-	memset(handle, 0, sizeof(*handle));
-
-	list_head_init(&handle->options);
 
 	handle->fd = fd;
-	if (tracing_dir) {
-		handle->tracing_dir = strdup(tracing_dir);
-		if (!handle->tracing_dir)
-			goto out_free;
-	}
 
-	handle->msg_handle = msg_handle;
+	handle->file_version = FILE_VERSION;
 
-	if (select_file_version(handle, ihandle))
-		goto out_free;
+	handle->page_size = getpagesize();
 
-	buf[0] = 23;
-	buf[1] = 8;
-	buf[2] = 68;
-	memcpy(buf + 3, "tracing", 7);
+	if (tracecmd_host_bigendian())
+		handle->big_endian = true;
+	else
+		handle->big_endian = false;
 
-	if (do_write_check(handle, buf, 10))
-		goto out_free;
+	list_head_init(&handle->options);
 
-	sprintf(buf, "%lu", handle->file_version);
-	if (do_write_check(handle, buf, strlen(buf) + 1))
-		goto out_free;
+	handle->file_state = TRACECMD_FILE_ALLOCATED;
 
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
+	return handle;
+}
 
-	if (do_write_check(handle, buf, 1))
-		goto out_free;
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
+{
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
 
-	/* save size of long (this may not be what the kernel is) */
-	buf[0] = sizeof(long);
-	if (do_write_check(handle, buf, 1))
-		goto out_free;
+	handler->msg_handle = msg_handle;
 
-	endian4 = convert_endian_4(handle, handle->page_size);
-	if (do_write_check(handle, &endian4, 4))
-		goto out_free;
-	handle->file_state = TRACECMD_FILE_INIT;
+	return 0;
+}
 
-	if (ihandle)
-		return handle;
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
 
-	if (read_header_files(handle))
-		goto out_free;
+	free(handler->tracing_dir);
+	if (tracing_dir) {
+		handler->tracing_dir = strdup(tracing_dir);
+		if (!handler->tracing_dir)
+			return -1;
+	} else
+		handler->tracing_dir = NULL;
 
-	if (read_ftrace_files(handle))
-		goto out_free;
+	return 0;
+}
 
-	if (read_event_files(handle, list))
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
 
-	if (read_proc_kallsyms(handle, kallsyms))
-		goto out_free;
+	free(handler->kallsyms);
+	if (kallsyms) {
+		handler->kallsyms = strdup(kallsyms);
+		if (!handler->kallsyms)
+			return -1;
+	} else
+		handler->kallsyms = NULL;
 
-	if (read_ftrace_printk(handle))
-		goto out_free;
+	return 0;
+}
 
-	return handle;
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
 
- out_free:
-	tracecmd_output_close(handle);
-	return NULL;
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
+
+
+	return 0;
 }
 
-static struct tracecmd_output *create_file(const char *output_file,
-					   struct tracecmd_input *ihandle,
-					   const char *tracing_dir,
-					   const char *kallsyms,
-					   struct tracecmd_event_list *list)
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
 {
-	struct tracecmd_output *handle;
-	int fd;
+	char buf[BUFSIZ];
+	int endian4;
 
-	fd = open(output_file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
-	if (fd < 0)
-		return NULL;
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
 
-	handle = create_file_fd(fd, ihandle, tracing_dir, kallsyms, list, NULL);
-	if (!handle) {
-		close(fd);
-		unlink(output_file);
-	}
+	buf[0] = 23;
+	buf[1] = 8;
+	buf[2] = 68;
+	memcpy(buf + 3, "tracing", 7);
 
-	return handle;
+	if (do_write_check(handler, buf, 10))
+		return -1;
+
+	sprintf(buf, "%lu", handler->file_version);
+	if (do_write_check(handler, buf, strlen(buf) + 1))
+		return -1;
+
+	if (handler->big_endian)
+		buf[0] = 1;
+	else
+		buf[0] = 0;
+	if (do_write_check(handler, buf, 1))
+		return -1;
+
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
+}
+
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
+{
+	if (!handler || handler->file_state < TRACECMD_FILE_ALLOCATED)
+		return -1;
+
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
@@ -1267,11 +1374,19 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 {
 	struct tracecmd_output *handle;
 	char *path;
+	int fd;
 
-	handle = create_file(output_file, NULL, NULL, NULL, &all_event_list);
-	if (!handle)
+	fd = open(output_file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (fd < 0)
 		return NULL;
 
+	handle = tracecmd_output_allocate(fd);
+	if (!handle)
+		goto out_free;
+	if (tracecmd_output_write_init(handle))
+		goto out_free;
+	if (tracecmd_output_write_headers(handle, NULL))
+		goto out_free;
 	/*
 	 * Save the command lines;
 	 */
@@ -1565,39 +1680,38 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 
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
+	struct tracecmd_output *out;
 
-struct tracecmd_output *
-tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list)
-{
-	return create_file_fd(fd, NULL, NULL, NULL, list, NULL);
-}
-
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
@@ -1613,11 +1727,19 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
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
+
 	if (tracecmd_copy_headers(ihandle, handle->fd, 0, 0) < 0)
 		goto out_free;
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1767a6c6..15e07cf0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3689,6 +3689,25 @@ again:
 
 static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx);
 
+static struct tracecmd_output *create_net_output(struct common_record_context *ctx,
+						 struct tracecmd_msg_handle *msg_handle)
+{
+	struct tracecmd_output *out;
+
+	out = tracecmd_output_allocate(-1);
+	if (!out)
+		return NULL;
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
@@ -3700,7 +3719,7 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
-		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
+		network_handle = create_net_output(ctx, msg_handle);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -3718,10 +3737,11 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 	} else {
-		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
-							      listed_events);
+		network_handle = tracecmd_output_allocate(msg_handle->fd);
 		if (!network_handle)
 			goto error;
+		if (tracecmd_output_write_headers(network_handle, listed_events))
+			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
 	}
 
@@ -4067,8 +4087,7 @@ static void setup_agent(struct buffer_instance *instance,
 {
 	struct tracecmd_output *network_handle;
 
-	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
-						     listed_events);
+	network_handle = create_net_output(ctx, instance->msg_handle);
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
@@ -4437,6 +4456,30 @@ static void write_guest_file(struct buffer_instance *instance)
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
@@ -4491,7 +4534,7 @@ static void record_data(struct common_record_context *ctx)
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

