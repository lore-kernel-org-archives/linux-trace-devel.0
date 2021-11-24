Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB495C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 20:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239303AbhKXUve (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 15:51:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238121AbhKXUve (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 15:51:34 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57B3460FDA;
        Wed, 24 Nov 2021 20:48:24 +0000 (UTC)
Date:   Wed, 24 Nov 2021 15:48:22 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH] trace-cmd library: Clean up comments and handle variable
 name
Message-ID: <20211124154822.4c3bc864@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The descriptor name for the tracecmd_output structure has always been
"handle" and not "handler". Rename all the locations that added the use of
"handler".

Clean up the function descriptions to remove the self reference of "API".

No functional changes.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  12 +-
 lib/trace-cmd/trace-output.c                  | 177 ++++++++++--------
 2 files changed, 101 insertions(+), 88 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index fb050671..86dbf683 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -270,13 +270,13 @@ struct tracecmd_option;
 struct tracecmd_msg_handle;
 
 struct tracecmd_output *tracecmd_output_allocate(int fd);
-int tracecmd_output_set_msg(struct tracecmd_output *handler,
+int tracecmd_output_set_msg(struct tracecmd_output *handle,
 			    struct tracecmd_msg_handle *msg_handle);
-int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *tracing_dir);
-int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms);
-int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle);
-int tracecmd_output_write_init(struct tracecmd_output *handler);
-int tracecmd_output_write_headers(struct tracecmd_output *handler,
+int tracecmd_output_set_trace_dir(struct tracecmd_output *handle, const char *tracing_dir);
+int tracecmd_output_set_kallsyms(struct tracecmd_output *handle, const char *kallsyms);
+int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracecmd_input *ihandle);
+int tracecmd_output_write_init(struct tracecmd_output *handle);
+int tracecmd_output_write_headers(struct tracecmd_output *handle,
 				  struct tracecmd_event_list *list);
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 27f296dd..9cebd02b 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -880,16 +880,16 @@ out_free:
 }
 
 /**
- * tracecmd_output_allocate - allocate new output handler to a trace file
- * @handle: file descriptor to an empty file, it can be -1 if the handler
- *	    will not write to a file
+ * tracecmd_output_allocate - allocate new output handle to a trace file
+ * @fd: File descriptor for the handle to write to.
  *
- * This API only allocates a handler and performs minimal initialization.
- * No data is written in the file.
+ * Allocate a tracecmd_output descriptor and perform minimal initialization.
+ * @fd will be set as the file descriptor for the handle. Nothing is
+ * written in the file yet, and if @fd is -1, then all writes will be ignored.
  *
- * Returns pointer to a newly allocated file descriptor, that can be used
- * with other library APIs. In case of an error, NULL is returned. The returned
- * handler must be freed with tracecmd_output_close() or tracecmd_output_free()
+ * Returns a pointer to a newly allocated file descriptor for the use of creating
+ * a tracecmd data file. In case of an error, NULL is returned. The returned
+ * handle must be freed with tracecmd_output_close() or tracecmd_output_free()
  */
 struct tracecmd_output *tracecmd_output_allocate(int fd)
 {
@@ -914,121 +914,133 @@ struct tracecmd_output *tracecmd_output_allocate(int fd)
 }
 
 /**
- * tracecmd_output_set_msg - associated an output file handler with network message handler
- * @handle: output handler to a trace file.
- * @msg_handle: network handler, allocated by tracecmd_msg_handle_alloc()
+ * tracecmd_output_set_msg - associated an output file handle with network message handle
+ * @handle: output handle to a trace file.
+ * @msg_handle: network handle, allocated by tracecmd_msg_handle_alloc()
  *
- * This API associates an output file handler with a network stream. All subsequent API calls
- * with this output file handler will send data over the network using the @msg_handle, instead
- * of writing to a file.
- * This API must be called after the handler file version is set and before
+ * Associate an output file handle (@handle) to a network stream (@msg_handle).
+ * All subsequent calls to @handle will send data over the network using @msg_handle
+ * instead of writing to a file.
+ *
+ * This mut be called after the handle file version is set and before calling
  * tracecmd_output_write_init().
  *
- * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ * Returns 0 on success, or -1 if the output file handle is not allocated or not
+ * in the expected state.
  */
-int tracecmd_output_set_msg(struct tracecmd_output *handler, struct tracecmd_msg_handle *msg_handle)
+int tracecmd_output_set_msg(struct tracecmd_output *handle, struct tracecmd_msg_handle *msg_handle)
 {
-	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+	if (!handle || handle->file_state != TRACECMD_FILE_ALLOCATED)
 		return -1;
 
-	handler->msg_handle = msg_handle;
+	handle->msg_handle = msg_handle;
 
 	return 0;
 }
 
 /**
  * tracecmd_output_set_trace_dir - Set a custom tracing dir, instead of system default
- * @handle: output handler to a trace file.
+ * @handle: output handle to a trace file.
  * @tracing_dir: full path to a directory with tracing files
  *
- * This API associates an output file handler with a custom tracing directory, to be used when
- * creating the trace file instead of the system default tracing directory.
- * This API must be called before tracecmd_output_write_init().
+ * Associate the output file handle (@handle) with a custom tracing directory
+ * (@tracing_dir), to be used when creating the trace file instead of using the
+ * system default tracig directory.
+ *
+ * Must be called before tracecmd_output_write_init().
  *
- * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ * Returns 0 on success, or -1 if the output file handle is not allocated or not
+ * in the expected state.
  */
-int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *tracing_dir)
+int tracecmd_output_set_trace_dir(struct tracecmd_output *handle, const char *tracing_dir)
 {
-	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+	if (!handle || handle->file_state != TRACECMD_FILE_ALLOCATED)
 		return -1;
 
-	free(handler->tracing_dir);
+	free(handle->tracing_dir);
 	if (tracing_dir) {
-		handler->tracing_dir = strdup(tracing_dir);
-		if (!handler->tracing_dir)
+		handle->tracing_dir = strdup(tracing_dir);
+		if (!handle->tracing_dir)
 			return -1;
 	} else
-		handler->tracing_dir = NULL;
+		handle->tracing_dir = NULL;
 
 	return 0;
 }
 
 /**
- * tracecmd_output_set_kallsyms - Set a custom kernel symbols file, instead of system default
- * @handle: output handler to a trace file.
+ * tracecmd_output_set_kallsyms - Set a custom kernel symbols file
+ * @handle: output handle to a trace file.
  * @tracing_dir: full path to a file with kernel symbols
  *
- * This API associates an output file handler with a custom kernel symbols file, to be used when
- * creating the trace file instead of the system default kernel symbols file.
- * This API must be called before tracecmd_output_write_init().
+ * Have the output file handle (@handle) use a custom kernel symbols file instead
+ * of the default /proc/kallsyms.
+ *
+ * Must be called before tracecmd_output_write_init().
  *
- * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ * Returns 0 on success, or -1 if the output file handle is not allocated or
+ * not in the expected state.
  */
-int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms)
+int tracecmd_output_set_kallsyms(struct tracecmd_output *handle, const char *kallsyms)
 {
-	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+	if (!handle || handle->file_state != TRACECMD_FILE_ALLOCATED)
 		return -1;
 
-	free(handler->kallsyms);
+	free(handle->kallsyms);
 	if (kallsyms) {
-		handler->kallsyms = strdup(kallsyms);
-		if (!handler->kallsyms)
+		handle->kallsyms = strdup(kallsyms);
+		if (!handle->kallsyms)
 			return -1;
 	} else
-		handler->kallsyms = NULL;
+		handle->kallsyms = NULL;
 
 	return 0;
 }
 
 /**
  * tracecmd_output_set_from_input - Inherit parameters from an existing trace file
- * @handle: output handler to a trace file.
- * @ihandle: input handler to an existing trace file.
+ * @handle: output handle to a trace file.
+ * @ihandle: input handle to an existing trace file.
  *
- * This API copies parameters from input handler @ihandle, associated with an existing trace file,
- * to the output handler @handle, associated with file that is going to be created.
- * These parameters are copied:
- *  - tep handler
+ * Have the output file handle (@handle) inherit the properties of a given
+ * input file handle (@ihandle).
+ *
+ * The parameters that are copied are:
+ *  - tep handle
  *  - page size
  *  - file endian
  *  - file version
  *  - file compression protocol
- * This API must be called before tracecmd_output_write_init().
  *
- * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ * Must be called before tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 if the output file handle is not allocated or
+ * not in expected state.
  */
-int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle)
+int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracecmd_input *ihandle)
 {
-	if (!handler || !ihandle || handler->file_state != TRACECMD_FILE_ALLOCATED)
+	if (!handle || !ihandle || handle->file_state != TRACECMD_FILE_ALLOCATED)
 		return -1;
 
 	/* get endian, page size, file version and compression */
 	/* Use the pevent of the ihandle for later writes */
-	handler->pevent = tracecmd_get_tep(ihandle);
-	tep_ref(handler->pevent);
-	handler->page_size = tracecmd_page_size(ihandle);
-	handler->file_version = tracecmd_get_in_file_version(ihandle);
-	handler->big_endian = tep_is_file_bigendian(handler->pevent);
+	handle->pevent = tracecmd_get_tep(ihandle);
+	tep_ref(handle->pevent);
+	handle->page_size = tracecmd_page_size(ihandle);
+	handle->file_version = tracecmd_get_in_file_version(ihandle);
+	handle->big_endian = tep_is_file_bigendian(handle->pevent);
 
 	return 0;
 }
 
 /**
- * tracecmd_output_write_init - Write the initial magics in the trace file
- * @handle: output handler to a trace file.
+ * tracecmd_output_write_init - Write the initial data into the trace file
+ * @handle: output handle to a trace file.
  *
- * This API must be called after all tracecmd_output_set_...() APIs and before writing anything
- * to the trace file. This initial information is written in the file:
+ * Must be called after tracecmd_output_set_*() functions and before writing
+ * anything else.
+ *
+ * The initial information to be written into the file:
  *  - initial file magic bytes
  *  - file version
  *  - data endian
@@ -1036,14 +1048,15 @@ int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct trace
  *  - page size
  *  - compression header
  *
- * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ * Returns 0 on success, or -1 if the output file handle is not allocated or
+ * not in the expected state.
  */
-int tracecmd_output_write_init(struct tracecmd_output *handler)
+int tracecmd_output_write_init(struct tracecmd_output *handle)
 {
 	char buf[BUFSIZ];
 	int endian4;
 
-	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+	if (!handle || handle->file_state != TRACECMD_FILE_ALLOCATED)
 		return -1;
 
 	buf[0] = 23;
@@ -1051,35 +1064,35 @@ int tracecmd_output_write_init(struct tracecmd_output *handler)
 	buf[2] = 68;
 	memcpy(buf + 3, "tracing", 7);
 
-	if (do_write_check(handler, buf, 10))
+	if (do_write_check(handle, buf, 10))
 		return -1;
 
-	sprintf(buf, "%lu", handler->file_version);
-	if (do_write_check(handler, buf, strlen(buf) + 1))
+	sprintf(buf, "%lu", handle->file_version);
+	if (do_write_check(handle, buf, strlen(buf) + 1))
 		return -1;
 
-	if (handler->big_endian)
+	if (handle->big_endian)
 		buf[0] = 1;
 	else
 		buf[0] = 0;
-	if (do_write_check(handler, buf, 1))
+	if (do_write_check(handle, buf, 1))
 		return -1;
 
 	/* save size of long (this may not be what the kernel is) */
 	buf[0] = sizeof(long);
-	if (do_write_check(handler, buf, 1))
+	if (do_write_check(handle, buf, 1))
 		return -1;
 
-	endian4 = convert_endian_4(handler, handler->page_size);
-	if (do_write_check(handler, &endian4, 4))
+	endian4 = convert_endian_4(handle, handle->page_size);
+	if (do_write_check(handle, &endian4, 4))
 		return -1;
-	handler->file_state = TRACECMD_FILE_INIT;
+	handle->file_state = TRACECMD_FILE_INIT;
 	return 0;
 }
 
 /**
  * tracecmd_output_write_headers - Write the trace file headers
- * @handle: output handler to a trace file.
+ * @handle: output handle to a trace file.
  * @list: desired events that will be included in the trace file.
  *	  It can be NULL for all available events
  *
@@ -1092,24 +1105,24 @@ int tracecmd_output_write_init(struct tracecmd_output *handler)
  *
  * Returns 0 on success, or -1 in case of an error.
  */
-int tracecmd_output_write_headers(struct tracecmd_output *handler,
+int tracecmd_output_write_headers(struct tracecmd_output *handle,
 				  struct tracecmd_event_list *list)
 {
-	if (!handler || handler->file_state < TRACECMD_FILE_ALLOCATED)
+	if (!handle || handle->file_state < TRACECMD_FILE_ALLOCATED)
 		return -1;
 
 	/* Write init data, if not written yet */
-	if (handler->file_state < TRACECMD_FILE_INIT && tracecmd_output_write_init(handler))
+	if (handle->file_state < TRACECMD_FILE_INIT && tracecmd_output_write_init(handle))
 		return -1;
-	if (read_header_files(handler))
+	if (read_header_files(handle))
 		return -1;
-	if (read_ftrace_files(handler))
+	if (read_ftrace_files(handle))
 		return -1;
-	if (read_event_files(handler, list))
+	if (read_event_files(handle, list))
 		return -1;
-	if (read_proc_kallsyms(handler))
+	if (read_proc_kallsyms(handle))
 		return -1;
-	if (read_ftrace_printk(handler))
+	if (read_ftrace_printk(handle))
 		return -1;
 	return 0;
 }
-- 
2.31.1

