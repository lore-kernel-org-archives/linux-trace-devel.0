Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDCAC43457
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A642D206F4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:04:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bi6Cg99A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388719AbgJLOEE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 10:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbgJLNgR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 09:36:17 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A19C0613D1
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:17 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id q5so17568053wmq.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QRGFyWD96P2o2F6V4CgAA5/3rTGFYG0pQQpuKrLitJM=;
        b=bi6Cg99AxznDPHmxbeYqLycb10Kgy2870AKz8davTF7S36KEHnykTpIBfJIFWVjIn5
         IxqXV+uMKBbskJ0b/Npmtos+qV51h1dIZHwUx9BFWtA+sQCeXBlDdBCwU/XCyXe1NHPS
         eMeNQ4Qyjl7HyL7QYSgQp8+ca8bKsmEBRFQvnOUTY+Sema+KwQt9dbd6rWHGHDp8NxL0
         tsSQqLR91kGlzpdErmI1YeMECOT04POLoU4oZCHz8hoWhrdbY6Yo+VSOfIYNf4TsKzUg
         Jdymrr/ByBFqFhYV7a1BZchRmuPtw76Twq+nin+Gp3P/TM+6Yx3HfmJOxPrh6r/kty7w
         tEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QRGFyWD96P2o2F6V4CgAA5/3rTGFYG0pQQpuKrLitJM=;
        b=bgxupNpEY9BFx6KrGulihhD6mVBa7cCZVySPsRWY2kGjaUCX6tm5zEhdLaMUmWSFcV
         Lk1VnINqV1JWtbHsWuKrWdHJFDIK8J57XoXULGpBUlJ+MmUshdhSszA57czEQwHnyMRI
         2ZMvkMpJ3LfTbymJDUE1OKosbZmRrwBiC+86njTtWP/3xMd7fa46ot8EXoqbs/sSuXi8
         njSqa+s6xTsgJjo6bD/bioEGIATULY6AJBI1KdNMQ+WwlLlOY/Pt2ZDMlVkIDGADJKK5
         BTs0l3JEAu99u3LLKGiZHE4tz+mysKGw4n8lxzPyhddQFr52eSfDrFALy+xUCealGrny
         YO7A==
X-Gm-Message-State: AOAM530zt6sddiQSU7WtVnvqh9RTniZEs1iPUdwOeZKdK2QDfAkpOQ8I
        lNDb4MgbXRAZlplDMo6fn/Q=
X-Google-Smtp-Source: ABdhPJz6V/8ZWXifhwTbxnhxfyqPXRAQLnTdtq5EUspteq+2QX53vw4fgqb5h6JF6cIzHgsZTYmraw==
X-Received: by 2002:a1c:e3c6:: with SMTP id a189mr10552525wmh.167.1602509775843;
        Mon, 12 Oct 2020 06:36:15 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id k5sm23145388wmb.19.2020.10.12.06.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:36:15 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 07/20] kernel-shark: Add basic methods for Data streams
Date:   Mon, 12 Oct 2020 16:35:10 +0300
Message-Id: <20201012133523.469040-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012133523.469040-1-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Here we introduce the basic mechanisms for using data streams.
For the moment these are just stand alone definitions and the
integration with the API is yet to be introduced in the following
patches.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.c | 197 ++++++++++++++++++++++++++++++++++++++++++++++++
 src/libkshark.h | 171 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 368 insertions(+)

diff --git a/src/libkshark.c b/src/libkshark.c
index 6a1258dc..ffeb66a7 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -166,6 +166,153 @@ bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
 	return true;
 }
 
+static void kshark_stream_free(struct kshark_data_stream *stream)
+{
+	if (!stream)
+		return;
+
+	kshark_hash_id_free(stream->show_task_filter);
+	kshark_hash_id_free(stream->hide_task_filter);
+
+	kshark_hash_id_free(stream->show_event_filter);
+	kshark_hash_id_free(stream->hide_event_filter);
+
+	kshark_hash_id_free(stream->show_cpu_filter);
+	kshark_hash_id_free(stream->hide_cpu_filter);
+
+	kshark_hash_id_free(stream->tasks);
+
+	free(stream->file);
+	free(stream->name);
+	free(stream);
+}
+
+static struct kshark_data_stream *kshark_stream_alloc()
+{
+	struct kshark_data_stream *stream;
+
+	stream = calloc(1, sizeof(*stream));
+	if (!stream)
+		goto fail;
+
+	stream->show_task_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
+	stream->hide_task_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
+
+	stream->show_event_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
+	stream->hide_event_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
+
+	stream->show_cpu_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
+	stream->hide_cpu_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
+
+	stream->tasks = kshark_hash_id_alloc(KS_TASK_HASH_NBITS);
+
+	if (!stream->show_task_filter ||
+	    !stream->hide_task_filter ||
+	    !stream->show_event_filter ||
+	    !stream->hide_event_filter ||
+	    !stream->tasks) {
+		    goto fail;
+	}
+
+	stream->format = KS_INVALIDE_DATA;
+
+	return stream;
+
+ fail:
+	fprintf(stderr, "Failed to allocate memory for data stream.\n");
+	if (stream)
+		kshark_stream_free(stream);
+
+	return NULL;
+}
+
+/**
+ * @brief Add new Data stream.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ *
+ * @returns Zero on success or a negative errno code on failure.
+ */
+int kshark_add_stream(struct kshark_context *kshark_ctx)
+{
+	struct kshark_data_stream *stream;
+
+	if (kshark_ctx->n_streams == KS_MAX_NUM_STREAMS)
+		return -EMFILE;
+
+	stream = kshark_stream_alloc();
+	stream->stream_id = kshark_ctx->n_streams;
+
+	if (pthread_mutex_init(&stream->input_mutex, NULL) != 0) {
+		kshark_stream_free(stream);
+		return -EAGAIN;
+	}
+
+	kshark_ctx->stream[kshark_ctx->n_streams++] = stream;
+
+	return stream->stream_id;
+}
+
+/**
+ * @brief Get the Data stream object having given Id.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param sd: Data stream identifier.
+ *
+ * @returns Pointer to a Data stream object if the sream exists. Otherwise
+ *	    NULL.
+ */
+struct kshark_data_stream *
+kshark_get_data_stream(struct kshark_context *kshark_ctx, int sd)
+{
+	if (sd >= 0 && sd < KS_MAX_NUM_STREAMS)
+		return kshark_ctx->stream[sd];
+
+	return NULL;
+}
+
+/**
+ * @brief Get the Data stream object corresponding to a given entry
+ *
+ * @param entry: Input location for the KernelShark entry.
+ *
+ * @returns Pointer to a Data stream object on success. Otherwise NULL.
+ */
+struct kshark_data_stream *
+kshark_get_stream_from_entry(const struct kshark_entry *entry)
+{
+	struct kshark_context *kshark_ctx = NULL;
+
+	if (!kshark_instance(&kshark_ctx))
+		return NULL;
+
+	return kshark_get_data_stream(kshark_ctx, entry->stream_id);
+}
+
+/**
+ * @brief Get an array containing the Ids of all opened Trace data streams.
+ * 	  The User is responsible for freeing the array.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ */
+int *kshark_all_streams(struct kshark_context *kshark_ctx)
+{
+	int *ids, i, count = 0;
+
+	ids = malloc(kshark_ctx->n_streams * (sizeof(*ids)));
+	if (!ids) {
+		fprintf(stderr,
+			"Failed to allocate memory for stream array.\n");
+		return NULL;
+	}
+
+	for (i = 0; i < KS_MAX_NUM_STREAMS; ++i)
+		if (kshark_ctx->stream[i])
+			ids[count++] = i;
+
+	return ids;
+}
+
 /**
  * @brief Close the trace data file and free the trace data handle.
  *
@@ -252,6 +399,56 @@ void kshark_free(struct kshark_context *kshark_ctx)
 	free(kshark_ctx);
 }
 
+/**
+ * @brief Get the name of the command/task from its Process Id.
+ *
+ * @param sd: Data stream identifier.
+ * @param pid: Process Id of the command/task.
+ */
+char *kshark_comm_from_pid(int sd, int pid)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct kshark_data_stream *stream;
+	struct kshark_entry e;
+
+	if (!kshark_instance(&kshark_ctx))
+		return NULL;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return NULL;
+
+	e.visible = KS_PLUGIN_UNTOUCHED_MASK;
+	e.pid = pid;
+
+	return stream->interface.get_task(stream, &e);
+}
+
+/**
+ * @brief Get the name of the event from its Id.
+ *
+ * @param sd: Data stream identifier.
+ * @param event_id: The unique Id of the event type.
+ */
+char *kshark_event_from_id(int sd, int event_id)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct kshark_data_stream *stream;
+	struct kshark_entry e;
+
+	if (!kshark_instance(&kshark_ctx))
+		return NULL;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return NULL;
+
+	e.visible = KS_PLUGIN_UNTOUCHED_MASK;
+	e.event_id = event_id;
+
+	return stream->interface.get_event_name(stream, &e);
+}
+
 static struct kshark_task_list *
 kshark_find_task(struct kshark_context *kshark_ctx, uint32_t key, int pid)
 {
diff --git a/src/libkshark.h b/src/libkshark.h
index fe0ba7f2..e299d067 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -340,6 +340,12 @@ struct kshark_task_list {
 
 /** Structure representing a kshark session. */
 struct kshark_context {
+	/** Array of data stream descriptors. */
+	struct kshark_data_stream	**stream;
+
+	/** The number of data streams. */
+	int				n_streams;
+
 	/** Input handle for the trace data file. */
 	struct tracecmd_input	*handle;
 
@@ -397,6 +403,16 @@ bool kshark_instance(struct kshark_context **kshark_ctx);
 
 bool kshark_open(struct kshark_context *kshark_ctx, const char *file);
 
+int kshark_add_stream(struct kshark_context *kshark_ctx);
+
+struct kshark_data_stream *
+kshark_get_data_stream(struct kshark_context *kshark_ctx, int sd);
+
+struct kshark_data_stream *
+kshark_get_stream_from_entry(const struct kshark_entry *entry);
+
+int *kshark_all_streams(struct kshark_context *kshark_ctx);
+
 ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 				 struct kshark_entry ***data_rows);
 
@@ -416,6 +432,10 @@ void kshark_close(struct kshark_context *kshark_ctx);
 
 void kshark_free(struct kshark_context *kshark_ctx);
 
+char *kshark_comm_from_pid(int sd, int pid);
+
+char *kshark_event_from_id(int sd, int event_id);
+
 int kshark_get_pid_easy(struct kshark_entry *entry);
 
 const char *kshark_get_task_easy(struct kshark_entry *entry);
@@ -432,6 +452,157 @@ void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec);
 
 char* kshark_dump_entry(const struct kshark_entry *entry);
 
+static inline int kshark_get_pid(const struct kshark_entry *entry)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return -1;
+
+	return stream->interface.get_pid(stream, entry);
+}
+
+static inline int kshark_get_event_id(const struct kshark_entry *entry)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return -1;
+
+	return stream->interface.get_event_id(stream, entry);
+}
+
+static inline int *kshark_get_all_event_ids(struct kshark_data_stream *stream)
+{
+	return stream->interface.get_all_event_ids(stream);
+}
+
+static inline char *kshark_get_event_name(const struct kshark_entry *entry)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return NULL;
+
+	return stream->interface.get_event_name(stream, entry);
+}
+
+static inline char *kshark_get_task(const struct kshark_entry *entry)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return NULL;
+
+	return stream->interface.get_task(stream, entry);
+}
+
+static inline char *kshark_get_latency(const struct kshark_entry *entry)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return NULL;
+
+	return stream->interface.get_latency(stream, entry);
+}
+
+static inline char *kshark_get_info(const struct kshark_entry *entry)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return NULL;
+
+	return stream->interface.get_info(stream, entry);
+}
+
+static inline int kshark_read_event_field(const struct kshark_entry *entry,
+					  const char* field, int64_t *val)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return -1;
+
+	return stream->interface.read_event_field_int64(stream, entry,
+							field, val);
+}
+
+/**
+ * @brief Load the content of the trace data file asociated with a given
+ *	  Data stream identifie into an array of kshark_entries.
+ *	  If one or more filters are set, the "visible" fields of each entry
+ *	  is updated according to the criteria provided by the filters. The
+ *	  field "filter_mask" of the session's context is used to control the
+ *	  level of visibility/invisibility of the filtered entries.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param sd: Data stream identifier.
+ * @param data_rows: Output location for the trace data. The user is
+ *		     responsible for freeing the elements of the outputted
+ *		     array.
+ *
+ * @returns The size of the outputted data in the case of success, or a
+ *	    negative error code on failure.
+ */
+static inline ssize_t kshark_load_entries(struct kshark_context *kshark_ctx,
+					  int sd,
+					  struct kshark_entry ***data_rows)
+{
+	struct kshark_data_stream *stream;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return -EBADF;
+
+	return stream->interface.load_entries(stream, kshark_ctx, data_rows);
+}
+
+/**
+ * @brief Load the content of the trace data file asociated with a given
+ *	  Data stream identifie into a data matrix. The user is responsible
+ *	  for freeing the outputted data.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param sd: Data stream identifier.
+ * @param cpu_array: Output location for the CPU column (array) of the matrix.
+ * @param event_array: Output location for the Event Id column (array) of the
+ *		       matrix.
+ * @param _array: Output location for the  column (array) of the matrix.
+ * @param offset_array: Output location for the offset column (array) of the
+ *			matrix.
+ * @param ts_array: Output location for the time stamp column (array) of the
+ *		    matrix.
+ */
+static inline ssize_t kshark_load_matrix(struct kshark_context *kshark_ctx,
+					 int sd,
+					 int16_t **cpu_array,
+					 int32_t **pid_array,
+					 int32_t **event_array,
+					 int64_t **offset_array,
+					 int64_t **ts_array)
+{
+	struct kshark_data_stream *stream;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return -EBADF;
+
+	return stream->interface.load_matrix(stream, kshark_ctx, cpu_array,
+								 pid_array,
+								 event_array,
+								 offset_array,
+								 ts_array);
+}
+
 /**
  * Custom entry info function type. To be user for dumping info for custom
  * KernelShark entryes.
-- 
2.25.1

