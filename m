Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D09C2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DA3522249
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AGAPa499"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgKLOYb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 09:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbgKLOYb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 09:24:31 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A37C0613D1
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:30 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id c17so6151753wrc.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WL0Y+IPR+2lWPR4J4dt4h2/ReAVR8u4ibdm4b3FCL24=;
        b=AGAPa499ovRQfq32QBRSSiLWYA0tlOSNFnczho+3CtnC9hnlyIY/80f7fzU6nHQMr6
         pmnhoOE4+xVOUsfeiR8SwxleQTwV5nAF+U6LRhWHewvdNMazHhx/iB5RIAtcomsfI06w
         +VTs3F/eLRyehcUmvqjSIwOx1Hk/POLRXuqa3mwNPEWiLNOj/NcQfEWM04N0UdxoK3gs
         3cyWj6cqB4ZmpxOfMiAd/NdOOSUGoWPKFNQPfFvId8KrIryioCG5vNB/rrNM38MezvlR
         hq+hnn+rGzhGqdvkj3wWz8+q9c384PL1DTqB/Xgr2teO15Ly+Qgb2niDdbyrSCZoDRdV
         30rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WL0Y+IPR+2lWPR4J4dt4h2/ReAVR8u4ibdm4b3FCL24=;
        b=VjbIzuv++SljH8MIi2qXqJK6EG+pShI2YBU/SkIFv3oKqKGPSBm28Gw4jEZQ9hM+uw
         57Rx7XwMPR+9YOsnEFtTBxERCEmXLJVqrxHx+3fq/Kpd6lqh+v/xn7gy25NaZEj/HVN2
         HhT/QHAGNarZi7thPqrJ4gUNQbDdNZob5aN8TLcPAgqK8lP/+cppkjHszJ8a3Ia2CWzz
         XUefdo8IcmMzcerWK+KOycTlPrP6O+rVA5Qji0FbdwYa7D1TB+CvW2lKbwYHf/2cI6lO
         Wph5pB50X0+mAoJ/MUjlRBLSk9rkis1tmSy2aKwYbCXpvsQ0wuqVUWuKA47EEOwr6RET
         /9FA==
X-Gm-Message-State: AOAM530307l6SbDycJwXzUv6q3UFqqwKkZm1CKv7iQ9lFFX9Ozqq4npL
        GxtXj7WzXXhznkPf/qhrxcbNwd2/FDU=
X-Google-Smtp-Source: ABdhPJx9RlvPqf8aLuFiQRE0/i8lJw/9xzxt4bOkMAqKbD0QkvIID1ObEJYKYryYJU4TSLSdJdv2rw==
X-Received: by 2002:adf:814f:: with SMTP id 73mr35629589wrm.174.1605191068856;
        Thu, 12 Nov 2020 06:24:28 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id h15sm6950685wrw.15.2020.11.12.06.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 06:24:28 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 10/20] kernel-shark: Start using data streams
Date:   Thu, 12 Nov 2020 16:23:48 +0200
Message-Id: <20201112142358.36821-11-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112142358.36821-1-y.karadz@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Here we switch to using the trace data readout, provided by the Data
stream interface. The actual implementation of the new readout was
done in the previous commits.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/dataload.c |  21 ++-
 src/libkshark.c     | 366 ++++++++++++++++++++------------------------
 src/libkshark.h     |  11 +-
 3 files changed, 183 insertions(+), 215 deletions(-)

diff --git a/examples/dataload.c b/examples/dataload.c
index 15c5de05..c13acbcb 100644
--- a/examples/dataload.c
+++ b/examples/dataload.c
@@ -19,8 +19,7 @@ int main(int argc, char **argv)
 	struct kshark_entry **data = NULL;
 	ssize_t r, n_rows, n_tasks;
 	char *entry_str;
-	bool status;
-	int *pids;
+	int sd, *pids;
 
 	/* Create a new kshark session. */
 	kshark_ctx = NULL;
@@ -29,30 +28,28 @@ int main(int argc, char **argv)
 
 	/* Open a trace data file produced by trace-cmd. */
 	if (argc > 1)
-		status = kshark_open(kshark_ctx, argv[1]);
+		sd = kshark_open(kshark_ctx, argv[1]);
 	else
-		status = kshark_open(kshark_ctx, default_file);
+		sd = kshark_open(kshark_ctx, default_file);
 
-	if (!status) {
+	if (sd < 0) {
 		kshark_free(kshark_ctx);
 		return 1;
 	}
 
 	/* Load the content of the file into an array of entries. */
-	n_rows = kshark_load_data_entries(kshark_ctx, &data);
+	n_rows = kshark_load_entries(kshark_ctx, sd, &data);
 	if (n_rows < 1) {
 		kshark_free(kshark_ctx);
 		return 1;
 	}
 
 	/* Print to the screen the list of all tasks. */
-	n_tasks = kshark_get_task_pids(kshark_ctx, &pids);
+	n_tasks = kshark_get_task_pids(kshark_ctx, sd, &pids);
 	for (r = 0; r < n_tasks; ++r) {
-		const char *task_str =
-			tep_data_comm_from_pid(kshark_ctx->pevent,
-					       pids[r]);
-
+		char *task_str = kshark_comm_from_pid(sd, pids[r]);
 		printf("task: %s-%i\n", task_str, pids[r]);
+		free(task_str);
 	}
 
 	free(pids);
@@ -82,7 +79,7 @@ int main(int argc, char **argv)
 	free(data);
 
 	/* Close the file. */
-	kshark_close(kshark_ctx);
+	kshark_close(kshark_ctx, sd);
 
 	/* Close the session. */
 	kshark_free(kshark_ctx);
diff --git a/src/libkshark.c b/src/libkshark.c
index 45e599c6..bb99f5f9 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -19,6 +19,7 @@
 
 // KernelShark
 #include "libkshark.h"
+#include "libkshark-tepdata.h"
 
 static __thread struct trace_seq seq;
 
@@ -32,6 +33,9 @@ static bool kshark_default_context(struct kshark_context **context)
 	if (!kshark_ctx)
 		return false;
 
+	kshark_ctx->stream = calloc(KS_DEFAULT_NUM_STREAMS,
+				    sizeof(*kshark_ctx->stream));
+
 	kshark_ctx->event_handlers = NULL;
 	kshark_ctx->collections = NULL;
 	kshark_ctx->plugins = NULL;
@@ -47,6 +51,9 @@ static bool kshark_default_context(struct kshark_context **context)
 
 	kshark_ctx->filter_mask = 0x0;
 
+	kshark_ctx->stream_info.array_size = KS_DEFAULT_NUM_STREAMS;
+	kshark_ctx->stream_info.max_stream_id = -1;
+
 	/* Will free kshark_context_handler. */
 	kshark_free(NULL);
 
@@ -108,62 +115,30 @@ bool kshark_instance(struct kshark_context **kshark_ctx)
 	return true;
 }
 
-static void kshark_free_task_list(struct kshark_context *kshark_ctx)
-{
-	struct kshark_task_list *task;
-	int i;
-
-	if (!kshark_ctx)
-		return;
-
-	for (i = 0; i < KS_TASK_HASH_SIZE; ++i) {
-		while (kshark_ctx->tasks[i]) {
-			task = kshark_ctx->tasks[i];
-			kshark_ctx->tasks[i] = task->next;
-			free(task);
-		}
-	}
-}
-
 /**
  * @brief Open and prepare for reading a trace data file specified by "file".
- *	  If the specified file does not exist, or contains no trace data,
- *	  the function returns false.
  *
  * @param kshark_ctx: Input location for context pointer.
  * @param file: The file to load.
  *
- * @returns True on success, or false on failure.
+ * @returns The Id number of the data stream associated with this file on success.
+ * 	    Otherwise a negative errno code.
  */
-bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
+int kshark_open(struct kshark_context *kshark_ctx, const char *file)
 {
-	struct tracecmd_input *handle;
-
-	kshark_free_task_list(kshark_ctx);
+	int sd, rt;
 
-	handle = tracecmd_open(file);
-	if (!handle)
-		return false;
+	sd = kshark_add_stream(kshark_ctx);
+	if (sd < 0)
+		return sd;
 
-	if (pthread_mutex_init(&kshark_ctx->input_mutex, NULL) != 0) {
-		tracecmd_close(handle);
-		return false;
+	rt = kshark_stream_open(kshark_ctx->stream[sd], file);
+	if (rt < 0) {
+		kshark_remove_stream(kshark_ctx, sd);
+		return rt;
 	}
 
-	kshark_ctx->handle = handle;
-	kshark_ctx->pevent = tracecmd_get_pevent(handle);
-
-	kshark_ctx->advanced_event_filter =
-		tep_filter_alloc(kshark_ctx->pevent);
-
-	/*
-	 * Turn off function trace indent and turn on show parent
-	 * if possible.
-	 */
-	tep_plugin_add_option("ftrace:parent", "1");
-	tep_plugin_add_option("ftrace:indent", "0");
-
-	return true;
+	return sd;
 }
 
 static void kshark_stream_free(struct kshark_data_stream *stream)
@@ -262,7 +237,6 @@ int kshark_add_stream(struct kshark_context *kshark_ctx)
 
 	if (kshark_ctx->stream_info.next_free_stream_id ==
 	    kshark_ctx->stream_info.array_size) {
-		printf("realloc %i\n", 2 * kshark_ctx->stream_info.array_size);
 		struct kshark_data_stream **streams_tmp;
 
 		streams_tmp = realloc(kshark_ctx->stream,
@@ -306,6 +280,56 @@ int kshark_add_stream(struct kshark_context *kshark_ctx)
 	return stream->stream_id;
 }
 
+static bool is_tep(const char *filename)
+{
+	/*
+	 * TODO: This is very naive. Implement more appropriate check. Ideally
+	 * it should be part of the trace-cmd library.
+	 */
+	char *ext = strrchr(filename, '.');
+	return ext && strcmp(ext, ".dat") == 0;
+}
+
+static void set_format(struct kshark_context *kshark_ctx,
+		       struct kshark_data_stream *stream,
+		       const char *filename)
+{
+	stream->format = KS_INVALIDE_DATA;
+
+	if (is_tep(filename)) {
+		stream->format = KS_TEP_DATA;
+		return;
+	}
+}
+
+/**
+ * @brief Use an existing Trace data stream to open and prepare for reading
+ *	  a trace data file specified by "file".
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param file: The file to load.
+ *
+ * @returns Zero on success or a negative error code in the case of an errno.
+ */
+int kshark_stream_open(struct kshark_data_stream *stream, const char *file)
+{
+	struct kshark_context *kshark_ctx = NULL;
+
+	if (!stream || !kshark_instance(&kshark_ctx))
+		return -EFAULT;
+
+	stream->file = strdup(file);
+	set_format(kshark_ctx, stream, file);
+
+	switch (stream->format) {
+	case KS_TEP_DATA:
+		return kshark_tep_init_input(stream, file);
+
+	default:
+		return -ENODATA;
+	}
+}
+
 /**
  * @brief Remove Data stream.
  *
@@ -398,45 +422,77 @@ int *kshark_all_streams(struct kshark_context *kshark_ctx)
 
 	return ids;
 }
+
+static void kshark_stream_close(struct kshark_data_stream *stream)
+{
+	struct kshark_context *kshark_ctx = NULL;
+
+	if (!stream || !kshark_instance(&kshark_ctx))
+		return;
+
+	/*
+	 * All filters are file specific. Make sure that all Process Ids and
+	 * Event Ids from this file are not going to be used with another file.
+	 */
+	kshark_hash_id_clear(stream->show_task_filter);
+	kshark_hash_id_clear(stream->hide_task_filter);
+	kshark_hash_id_clear(stream->show_event_filter);
+	kshark_hash_id_clear(stream->hide_event_filter);
+	kshark_hash_id_clear(stream->show_cpu_filter);
+	kshark_hash_id_clear(stream->hide_cpu_filter);
+
+	switch (stream->format) {
+	case KS_TEP_DATA:
+		kshark_tep_close_interface(stream);
+		break;
+
+	default:
+		break;
+	}
+
+	pthread_mutex_destroy(&stream->input_mutex);
+}
+
 /**
  * @brief Close the trace data file and free the trace data handle.
  *
  * @param kshark_ctx: Input location for the session context pointer.
+ * @param sd: Data stream identifier.
  */
-void kshark_close(struct kshark_context *kshark_ctx)
+void kshark_close(struct kshark_context *kshark_ctx, int sd)
 {
-	if (!kshark_ctx || !kshark_ctx->handle)
+	struct kshark_data_stream *stream;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
 		return;
 
-	/*
-	 * All filters are file specific. Make sure that the Pids and Event Ids
-	 * from this file are not going to be used with another file.
-	 */
-	tracecmd_filter_id_clear(kshark_ctx->show_task_filter);
-	tracecmd_filter_id_clear(kshark_ctx->hide_task_filter);
-	tracecmd_filter_id_clear(kshark_ctx->show_event_filter);
-	tracecmd_filter_id_clear(kshark_ctx->hide_event_filter);
-	tracecmd_filter_id_clear(kshark_ctx->show_cpu_filter);
-	tracecmd_filter_id_clear(kshark_ctx->hide_cpu_filter);
-
-	if (kshark_ctx->advanced_event_filter) {
-		tep_filter_reset(kshark_ctx->advanced_event_filter);
-		tep_filter_free(kshark_ctx->advanced_event_filter);
-		kshark_ctx->advanced_event_filter = NULL;
-	}
+	kshark_stream_close(stream);
+	kshark_stream_free(stream);
+	kshark_ctx->stream[sd] = NULL;
+	kshark_ctx->n_streams--;
+}
+
+/**
+ * @brief Close all currently open trace data file and free the trace data handle.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ */
+void kshark_close_all(struct kshark_context *kshark_ctx)
+{
+	int i, *stream_ids, n_streams;
+
+	stream_ids = kshark_all_streams(kshark_ctx);
 
 	/*
-	 * All data collections are file specific. Make sure that collections
-	 * from this file are not going to be used with another file.
+	 * Get a copy of shark_ctx->n_streams befor you start closing. Be aware
+	 * that kshark_close() will decrement shark_ctx->n_streams.
 	 */
-	kshark_free_collection_list(kshark_ctx->collections);
-	kshark_ctx->collections = NULL;
-
-	tracecmd_close(kshark_ctx->handle);
-	kshark_ctx->handle = NULL;
-	kshark_ctx->pevent = NULL;
+	n_streams = kshark_ctx->n_streams;
+	for (i = 0; i < n_streams; ++i)
+		kshark_close(kshark_ctx, stream_ids[i]);
 
-	pthread_mutex_destroy(&kshark_ctx->input_mutex);
+	free(stream_ids);
 }
 
 /**
@@ -444,7 +500,7 @@ void kshark_close(struct kshark_context *kshark_ctx)
  *	  open trace data files and before your application terminates.
  *
  * @param kshark_ctx: Optional input location for session context pointer.
- *		      If it points to a context of a sessuin, that sessuin
+ *		      If it points to a context of a session, that session
  *		      will be deinitialize. If it points to NULL, it will
  *		      deinitialize the current session.
  */
@@ -458,25 +514,12 @@ void kshark_free(struct kshark_context *kshark_ctx)
 		/* kshark_ctx_handler will be set to NULL below. */
 	}
 
-	tracecmd_filter_id_hash_free(kshark_ctx->show_task_filter);
-	tracecmd_filter_id_hash_free(kshark_ctx->hide_task_filter);
+	kshark_close_all(kshark_ctx);
 
-	tracecmd_filter_id_hash_free(kshark_ctx->show_event_filter);
-	tracecmd_filter_id_hash_free(kshark_ctx->hide_event_filter);
+	free(kshark_ctx->stream);
 
-	tracecmd_filter_id_hash_free(kshark_ctx->show_cpu_filter);
-	tracecmd_filter_id_hash_free(kshark_ctx->hide_cpu_filter);
-
-	if (kshark_ctx->plugins) {
-		kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_CLOSE);
+	if (kshark_ctx->plugins)
 		kshark_free_plugin_list(kshark_ctx->plugins);
-		kshark_free_event_handler_list(kshark_ctx->event_handlers);
-	}
-
-	kshark_free_task_list(kshark_ctx);
-
-	if (seq.buffer)
-		trace_seq_destroy(&seq);
 
 	if (kshark_ctx == kshark_context_handler)
 		kshark_context_handler = NULL;
@@ -866,6 +909,31 @@ int kshark_read_event_field_int(const struct kshark_entry *entry,
 	return -EFAULT;
 }
 
+/**
+ * @brief Get a summary of the entry.
+ *
+ * @param entry: Input location for an entry.
+ *
+ * @returns A summary text info. The user is responsible for freeing the
+ *	    outputted string.
+ */
+char *kshark_dump_entry(const struct kshark_entry *entry)
+{
+	struct kshark_generic_stream_interface *interface;
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (BROKEN_STREAM(stream))
+		return NULL;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->dump_entry)
+		return interface->dump_entry(stream, entry);
+
+	return NULL;
+}
+
 /** @brief Print the entry. */
 void kshark_print_entry(const struct kshark_entry *entry)
 {
@@ -993,57 +1061,24 @@ kshark_add_task(struct kshark_context *kshark_ctx, int pid)
  *	  the loaded trace data file.
  *
  * @param kshark_ctx: Input location for context pointer.
+ * @param sd: Data stream identifier.
  * @param pids: Output location for the Pids of the tasks. The user is
  *		responsible for freeing the elements of the outputted array.
  *
  * @returns The size of the outputted array of Pids in the case of success,
  *	    or a negative error code on failure.
  */
-ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids)
+ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int sd,
+			     int **pids)
 {
-	size_t i, pid_count = 0, pid_size = KS_TASK_HASH_SIZE;
-	struct kshark_task_list *list;
-	int *temp_pids;
-
-	*pids = calloc(pid_size, sizeof(int));
-	if (!*pids)
-		goto fail;
-
-	for (i = 0; i < KS_TASK_HASH_SIZE; ++i) {
-		list = kshark_ctx->tasks[i];
-		while (list) {
-			(*pids)[pid_count] = list->pid;
-			list = list->next;
-			if (++pid_count >= pid_size) {
-				pid_size *= 2;
-				temp_pids = realloc(*pids, pid_size * sizeof(int));
-				if (!temp_pids) {
-					goto fail;
-				}
-				*pids = temp_pids;
-			}
-		}
-	}
-
-	if (pid_count) {
-		temp_pids = realloc(*pids, pid_count * sizeof(int));
-		if (!temp_pids)
-			goto fail;
-
-		/* Paranoid: In the unlikely case of shrinking *pids, realloc moves it */
-		*pids = temp_pids;
-	} else {
-		free(*pids);
-		*pids = NULL;
-	}
+	struct kshark_data_stream *stream;
 
-	return pid_count;
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return -EBADF;
 
-fail:
-	fprintf(stderr, "Failed to allocate memory for Task Pids.\n");
-	free(*pids);
-	*pids = NULL;
-	return -ENOMEM;
+	*pids = kshark_hash_ids(stream->tasks);
+	return stream->tasks->count;
 }
 
 static bool filter_find(struct tracecmd_filter_id *filter, int pid,
@@ -2055,75 +2090,6 @@ char* kshark_dump_custom_entry(struct kshark_context *kshark_ctx,
 	return NULL;
 }
 
-/**
- * @brief Dump into a string the content of one entry. The function allocates
- *	  a null terminated string and returns a pointer to this string. The
- *	  user has to free the returned string.
- *
- * @param entry: A Kernel Shark entry to be printed.
- *
- * @returns The returned string contains a semicolon-separated list of data
- *	    fields.
- */
-char* kshark_dump_entry(const struct kshark_entry *entry)
-{
-	const char *event_name, *task, *lat, *info;
-	struct kshark_context *kshark_ctx;
-	char *temp_str, *entry_str;
-	int size = 0;
-
-	kshark_ctx = NULL;
-	if (!kshark_instance(&kshark_ctx) || !init_thread_seq())
-		return NULL;
-
-	task = tep_data_comm_from_pid(kshark_ctx->pevent, entry->pid);
-
-	if (entry->event_id >= 0) {
-		struct tep_event *event;
-		struct tep_record *data;
-
-		data = tracecmd_read_at(kshark_ctx->handle, entry->offset,
-					NULL);
-
-		event = tep_find_event(kshark_ctx->pevent, entry->event_id);
-
-		event_name = event? event->name : "[UNKNOWN EVENT]";
-		lat = get_latency(kshark_ctx->pevent, data);
-
-		size = asprintf(&temp_str, "%" PRIu64 "; %s-%i; CPU %i; %s;",
-				entry->ts,
-				task,
-				entry->pid,
-				entry->cpu,
-				lat);
-
-		info = get_info(kshark_ctx->pevent, data, event);
-
-		if (size > 0) {
-			size = asprintf(&entry_str, "%s %s; %s; 0x%x",
-					temp_str,
-					event_name,
-					info,
-					entry->visible);
-
-			free(temp_str);
-		}
-
-		free_record(data);
-		if (size < 1)
-			entry_str = NULL;
-	} else {
-		switch (entry->event_id) {
-		case KS_EVENT_OVERFLOW:
-			entry_str = kshark_dump_custom_entry(kshark_ctx, entry,
-							     missed_events_dump);
-		default:
-			entry_str = NULL;
-		}
-	}
-
-	return entry_str;
-}
 
 /**
  * @brief Binary search inside a time-sorted array of kshark_entries.
diff --git a/src/libkshark.h b/src/libkshark.h
index a2b20fd2..d6447a7c 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -447,7 +447,9 @@ struct kshark_context {
 
 bool kshark_instance(struct kshark_context **kshark_ctx);
 
-bool kshark_open(struct kshark_context *kshark_ctx, const char *file);
+int kshark_open(struct kshark_context *kshark_ctx, const char *file);
+
+int kshark_stream_open(struct kshark_data_stream *stream, const char *file);
 
 int kshark_add_stream(struct kshark_context *kshark_ctx);
 
@@ -467,9 +469,12 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 				 struct tep_record ***data_rows);
 
-ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids);
+ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int sd,
+			     int **pids);
+
+void kshark_close(struct kshark_context *kshark_ctx, int sd);
 
-void kshark_close(struct kshark_context *kshark_ctx);
+void kshark_close_all(struct kshark_context *kshark_ctx);
 
 void kshark_free(struct kshark_context *kshark_ctx);
 
-- 
2.25.1

