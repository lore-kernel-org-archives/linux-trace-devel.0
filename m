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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C830CC63798
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CCEA22227
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fui1xEml"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgKTJnc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgKTJnb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 04:43:31 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D5CC0613CF
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:30 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id t9so8838116edq.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s4/xJiGdPqjGkH2TlfVNj9BMC1unn0aPU+O8NBeTBnU=;
        b=fui1xEml5N2HW4cvqneCh/bTVnOvvcbIPIJYamuExHYw8qqw9F/kU2SwKdqBElvjq7
         T3NAXayAhAFtasX+IqpBvsofda64NFcJY33/pbjtuK53TJwPeTteaIEwPBwdZQOyyCdj
         /nZRZ3Q99FUrJleC9lrwvPYjVKmr5BNGjHAJpumXno+uMqMU/g5Mh0f5/699uwnFrra6
         vi+PctfbMvAEVVHm2Fmiu+4oHSNl8fZD6o89o+RWtiiDgvx7T667XGXPuAkwA2pJjCGE
         nkPnZ4qlOR//dbmC2o2FjAmOCFsTwhWCaf6uG76zsJcimPgJ2xc797HWTq13eiATDCVZ
         XMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s4/xJiGdPqjGkH2TlfVNj9BMC1unn0aPU+O8NBeTBnU=;
        b=El9dU289sTuyKhqeTzs+OstFCdFTsWS87roxqDDbfmkIeiHhe8KW5GYpT6sso0005q
         lDhROnvXXlqULKO4gmzperomvh+j6Hr0Iz8Zhbl2e2bkj56QO9SP9e/Jw5DExGV2TUrr
         vk0T5oRMkuVB0bbK3njJ3nRQYwsMJzQMIkDVfLBfjs3BNuSFA738lMW+9M+zLAzUlnQ/
         NH5QhRtq+P8XHd3GBIEbLiu4/iQdhNsZk1M0P7iZkRuweYrWNNiG1/xaoo+d1fbnf3Lv
         syhhmZJdbq8FcIhSKmbU36thAm93RWLMBFPNZtdr/Jyqv/5OdrkJ32DaiEXZ39+pU5/r
         yU5g==
X-Gm-Message-State: AOAM532Hx2FBRxEsQeOu05F85iT69h7bqAdv0PkfbtEPPLGMiXSYFzLn
        tbQnEDy60IsArj/IbvwJ5Fw=
X-Google-Smtp-Source: ABdhPJxn9tsAOXZjuHSYKKL7DuWNAF4dVKeOi08JJUIIGXhVx8BS194wP5YUO5Ma9NTLhm67gXA6vQ==
X-Received: by 2002:a05:6402:1d82:: with SMTP id dk2mr12468060edb.366.1605865408977;
        Fri, 20 Nov 2020 01:43:28 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id h2sm897006ejx.55.2020.11.20.01.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:43:28 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 06/20] kernel-shark: Add basic methods for Data streams
Date:   Fri, 20 Nov 2020 11:42:50 +0200
Message-Id: <20201120094304.271502-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120094304.271502-1-y.karadz@gmail.com>
References: <20201120094304.271502-1-y.karadz@gmail.com>
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
 src/libkshark.c | 716 ++++++++++++++++++++++++++++++++++++++++++++++++
 src/libkshark.h | 104 +++++++
 2 files changed, 820 insertions(+)

diff --git a/src/libkshark.c b/src/libkshark.c
index f3323ae3..e8d35071 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -166,6 +166,258 @@ bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
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
+	free(stream->interface);
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
+	kshark_set_data_format(stream->data_format, KS_INVALID_DATA);
+	stream->name = strdup(KS_UNNAMED);
+
+	return stream;
+
+ fail:
+	kshark_stream_free(stream);
+
+	return NULL;
+}
+/**
+ * The maximum number of Data streams that can be added simultaneously.
+ * The limit is determined by the 16 bit integer used to store the stream Id
+ * inside struct kshark_entry.
+ */
+#define KS_MAX_STREAM_ID	INT16_MAX
+
+/**
+ * Bit mask (0 - 15) used when converting indexes to pointers and vise-versa.
+ */
+#define INDEX_MASK		UINT16_MAX
+
+/**
+ * Bit mask (16 - 31/63) used when converting indexes to pointers and
+ * vise-versa.
+ */
+#define INVALID_STREAM_MASK	(~((unsigned long) INDEX_MASK))
+
+static int index_from_ptr(void *ptr)
+{
+	unsigned long index = (unsigned long) ptr;
+
+	return (int) (index & INDEX_MASK);
+}
+
+static void *index_to_ptr(unsigned int index)
+{
+	unsigned long p;
+
+	p = INVALID_STREAM_MASK | index;
+
+	return (void *) p;
+}
+
+static bool kshark_is_valid_stream(void *ptr)
+{
+	unsigned long p = (unsigned long) ptr;
+	bool v = !((p & ~INDEX_MASK) == INVALID_STREAM_MASK);
+
+	return p && v;
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
+	int new_stream;
+
+	if(kshark_ctx->stream_info.next_free_stream_id > KS_MAX_STREAM_ID)
+		return -ENODEV;
+
+	if (kshark_ctx->stream_info.next_free_stream_id ==
+	    kshark_ctx->stream_info.array_size) {
+		size_t new_size = 2 * kshark_ctx->stream_info.array_size;
+		struct kshark_data_stream **streams_tmp;
+
+		streams_tmp = realloc(kshark_ctx->stream,
+				      new_size * sizeof(*kshark_ctx->stream));
+		if (!streams_tmp)
+			return -ENOMEM;
+
+		kshark_ctx->stream = streams_tmp;
+		kshark_ctx->stream_info.array_size = new_size;
+	}
+
+	stream = kshark_stream_alloc();
+	if (!stream)
+		return -ENOMEM;
+
+	if (pthread_mutex_init(&stream->input_mutex, NULL) != 0) {
+		kshark_stream_free(stream);
+		return -EAGAIN;
+	}
+
+	if (kshark_ctx->stream_info.next_free_stream_id >
+	    kshark_ctx->stream_info.max_stream_id) {
+		new_stream = ++kshark_ctx->stream_info.max_stream_id;
+
+		kshark_ctx->stream_info.next_free_stream_id = new_stream + 1;
+
+		kshark_ctx->stream[new_stream] = stream;
+		stream->stream_id = new_stream;
+	} else {
+		new_stream = kshark_ctx->stream_info.next_free_stream_id;
+
+		kshark_ctx->stream_info.next_free_stream_id =
+			index_from_ptr(kshark_ctx->stream[new_stream]);
+
+		kshark_ctx->stream[new_stream] = stream;
+		stream->stream_id = new_stream;
+	}
+
+	kshark_ctx->n_streams++;
+
+	return stream->stream_id;
+}
+
+/**
+ * @brief Remove Data stream.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param sd: Data stream identifier.
+ *
+ * @returns Zero on success or a negative errno code on failure.
+ */
+int kshark_remove_stream(struct kshark_context *kshark_ctx, int sd)
+{
+	struct kshark_data_stream *stream;
+
+	if (sd < 0 ||
+	    sd > kshark_ctx->stream_info.max_stream_id ||
+	    !kshark_is_valid_stream(kshark_ctx->stream[sd]))
+		return -EFAULT;
+
+	stream = kshark_ctx->stream[sd];
+
+	pthread_mutex_destroy(&stream->input_mutex);
+
+	kshark_stream_free(stream);
+	kshark_ctx->stream[sd] =
+		index_to_ptr(kshark_ctx->stream_info.next_free_stream_id);
+	kshark_ctx->stream_info.next_free_stream_id = sd;
+	kshark_ctx->n_streams--;
+
+	return 0;
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
+	if (sd >= 0 && sd <= kshark_ctx->stream_info.max_stream_id)
+		if (kshark_ctx->stream[sd] &&
+		    kshark_is_valid_stream(kshark_ctx->stream[sd]) &&
+		    kshark_ctx->stream[sd]->interface)
+			return kshark_ctx->stream[sd];
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
+	ids = calloc(kshark_ctx->n_streams, (sizeof(*ids)));
+	if (!ids)
+		return NULL;
+
+	for (i = 0; i <= kshark_ctx->stream_info.max_stream_id; ++i)
+		if (kshark_ctx->stream[i] &&
+		    kshark_is_valid_stream(kshark_ctx->stream[i]))
+			ids[count++] = i;
+
+	return ids;
+}
 /**
  * @brief Close the trace data file and free the trace data handle.
  *
@@ -252,6 +504,470 @@ void kshark_free(struct kshark_context *kshark_ctx)
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
+	struct kshark_generic_stream_interface *interface;
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
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->get_task) {
+		e.visible = KS_PLUGIN_UNTOUCHED_MASK;
+		e.pid = pid;
+
+		return interface->get_task(stream, &e);
+	}
+
+	return NULL;
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
+	struct kshark_generic_stream_interface *interface;
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
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->get_event_name) {
+		e.visible = KS_PLUGIN_UNTOUCHED_MASK;
+		e.event_id = event_id;
+
+		return interface->get_event_name(stream, &e);
+	}
+
+	return NULL;
+}
+
+/**
+ * @brief Get the original process Id of the entry. Using this function make
+ *	  sense only in cases when the original value can be overwritten by
+ *	  plugins. If you know that no plugins are loaded use "entry->pid"
+ *	  directly.
+ *
+ * @param entry: Input location for an entry.
+ */
+int kshark_get_pid(const struct kshark_entry *entry)
+{
+	struct kshark_generic_stream_interface *interface;
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return -EFAULT;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->get_pid)
+		return interface->get_pid(stream, entry);
+
+	return -EFAULT;
+}
+
+/**
+ * @brief Get the original event Id of the entry. Using this function make
+ *	  sense only in cases when the original value can be overwritten by
+ *	  plugins. If you know that no plugins are loaded use "entry->event_id"
+ *	  directly.
+ *
+ * @param entry: Input location for an entry.
+ */
+int kshark_get_event_id(const struct kshark_entry *entry)
+{
+	struct kshark_generic_stream_interface *interface;
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return -EFAULT;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->get_event_id)
+		return interface->get_event_id(stream, entry);
+
+	return -EFAULT;
+}
+
+/**
+ * @brief Get an array of all event Ids for a given data stream.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ *
+ * @returns An array of event Ids. The user is responsible for freeing the
+ *	    outputted array.
+ */
+int *kshark_get_all_event_ids(struct kshark_data_stream *stream)
+{
+	struct kshark_generic_stream_interface *interface;
+
+	if (!stream)
+		return NULL;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->get_all_event_ids)
+		return interface->get_all_event_ids(stream);
+
+	return NULL;
+}
+
+/**
+ * @brief Find the event Ids corresponding to a given event name.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param event_name: The name of the event.
+ *
+ * @returns Event Ids number.
+ */
+int kshark_find_event_id(struct kshark_data_stream *stream,
+			 const char *event_name)
+{
+	struct kshark_generic_stream_interface *interface;
+
+	if (!stream)
+		return -EFAULT;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->find_event_id)
+		return interface->find_event_id(stream, event_name);
+
+	return -EFAULT;
+}
+
+/**
+ * @brief Find the event name corresponding to a given entry.
+ *
+ * @param entry: Input location for an entry.
+ *
+ * @returns The mane of the event on success, or NULL in case of failure.
+ *	    The use is responsible for freeing the output string.
+ */
+char *kshark_get_event_name(const struct kshark_entry *entry)
+{
+	struct kshark_generic_stream_interface *interface;
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return NULL;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->get_event_name)
+		return interface->get_event_name(stream, entry);
+
+	return NULL;
+}
+
+/**
+ * @brief Find the task name corresponding to a given entry.
+ *
+ * @param entry: Input location for an entry.
+ *
+ * @returns The mane of the task on success, or NULL in case of failure.
+ *	    The use is responsible for freeing the output string.
+ */
+char *kshark_get_task(const struct kshark_entry *entry)
+{
+	struct kshark_generic_stream_interface *interface;
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return NULL;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->get_task)
+		return interface->get_task(stream, entry);
+
+	return NULL;
+}
+
+/**
+ * @brief Get the basic information (text) about the entry.
+ *
+ * @param entry: Input location for an entry.
+ *
+ * @returns A the info text. The user is responsible for freeing the
+ *	    outputted string.
+ */
+char *kshark_get_info(const struct kshark_entry *entry)
+{
+	struct kshark_generic_stream_interface *interface;
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return NULL;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->get_info)
+		return interface->get_info(stream, entry);
+
+	return NULL;
+}
+
+/**
+ * @brief Get the auxiliary information about the entry. In the case of
+ * 	  TEP (Ftrace) data, this function provides the latency info.
+ *
+ * @param entry: Input location for an entry.
+ *
+ * @returns A the auxiliary text info. The user is responsible for freeing the
+ *	    outputted string.
+ */
+char *kshark_get_aux_info(const struct kshark_entry *entry)
+{
+	struct kshark_generic_stream_interface *interface;
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return NULL;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->aux_info)
+		return interface->aux_info(stream, entry);
+
+	return NULL;
+}
+
+/**
+ * @brief Get an array of all data field names associated with a given entry.
+ *
+ * @param entry: Input location for an entry.
+ * @param fields: Output location of the array of field names. The user is
+ *		  responsible for freeing the elements of the outputted array.
+ *
+ * @returns Total number of event fields on success, or a negative errno in
+ *	    the case of a failure.
+ */
+int kshark_get_all_event_field_names(const struct kshark_entry *entry,
+				     char ***fields)
+{
+	struct kshark_generic_stream_interface *interface;
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return -EFAULT;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->get_all_event_field_names)
+		return interface->get_all_event_field_names(stream,
+							    entry, fields);
+
+	return -EFAULT;
+}
+
+/**
+ * @brief Get the value type of an event field corresponding to a given entry.
+ *
+ * @param entry: Input location for an entry.
+ * @param field: The name of the data field.
+ *
+ * @returns The type of the data field on success, or KS_INVALID_FIELD in
+ *	    the case of a failure.
+ */
+kshark_event_field_format
+kshark_get_event_field_type(const struct kshark_entry *entry,
+			    const char *field)
+{
+	struct kshark_generic_stream_interface *interface;
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return KS_INVALID_FIELD;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->get_event_field_type)
+		return interface->get_event_field_type(stream, entry, field);
+
+	return KS_INVALID_FIELD;
+}
+
+/**
+ * @brief Get the value of an event field in a given trace record.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param rec: Input location for a record.
+ * @param field: The name of the data field.
+ * @param val: Output location for the value of the field.
+ *
+ * @returns Zero on success or a negative errno in the case of a failure.
+ */
+int kshark_read_record_field_int(struct kshark_data_stream *stream, void *rec,
+				 const char *field, int64_t *val)
+{
+	struct kshark_generic_stream_interface *interface;
+
+	if (!stream)
+		return -EFAULT;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->read_record_field_int64)
+		return interface->read_record_field_int64(stream, rec,
+							  field, val);
+
+	return -EFAULT;
+}
+
+/**
+ * @brief Get the value of an event field corresponding to a given entry.
+ *	  The value is retrieved via the offset in the file of the original
+ *	  record.
+ *
+ * @param entry: Input location for an entry.
+ * @param field: The name of the data field.
+ * @param val: Output location for the value of the field.
+ *
+ * @returns Zero on success or a negative errno in the case of a failure.
+ */
+int kshark_read_event_field_int(const struct kshark_entry *entry,
+				const char* field, int64_t *val)
+{
+	struct kshark_generic_stream_interface *interface;
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return -EFAULT;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->read_event_field_int64)
+		return interface->read_event_field_int64(stream, entry, field, val);
+
+	return -EFAULT;
+}
+
+/** @brief Print the entry. */
+void kshark_print_entry(const struct kshark_entry *entry)
+{
+	char *entry_str = kshark_dump_entry(entry);
+
+	if (!entry_str)
+		puts("(nil)");
+
+	puts(entry_str);
+	free(entry_str);
+}
+
+/**
+ * @brief Load the content of the trace data file asociated with a given
+ *	  Data stream into an array of kshark_entries.
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
+ssize_t kshark_load_entries(struct kshark_context *kshark_ctx, int sd,
+			    struct kshark_entry ***data_rows)
+{
+	struct kshark_generic_stream_interface *interface;
+	struct kshark_data_stream *stream =
+		kshark_get_data_stream(kshark_ctx, sd);
+
+	if (!stream)
+		return -EFAULT;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->load_entries)
+		return interface->load_entries(stream, kshark_ctx, data_rows);
+
+	return -EFAULT;
+}
+
+/**
+ * @brief Load the content of the trace data file asociated with a given
+ *	  Data stream into a data matrix. The user is responsible
+ *	  for freeing the outputted data.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param sd: Data stream identifier.
+ * @param cpu_array: Output location for the CPU column (array) of the matrix.
+ * @param event_array: Output location for the Event Id column (array) of the
+ *		       matrix.
+ * @param pid_array: Output location for the PID column (array) of the matrix.
+ * @param offset_array: Output location for the offset column (array) of the
+ *			matrix.
+ * @param ts_array: Output location for the time stamp column (array) of the
+ *		    matrix.
+ */
+ssize_t kshark_load_matrix(struct kshark_context *kshark_ctx, int sd,
+			   int16_t **event_array,
+			   int16_t **cpu_array,
+			   int32_t **pid_array,
+			   int64_t **offset_array,
+			   int64_t **ts_array)
+{
+	struct kshark_generic_stream_interface *interface;
+	struct kshark_data_stream *stream =
+		kshark_get_data_stream(kshark_ctx, sd);
+
+	if (!stream)
+		return -EFAULT;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->load_matrix)
+		return interface->load_matrix(stream, kshark_ctx, event_array,
+								  cpu_array,
+								  pid_array,
+								  offset_array,
+								  ts_array);
+
+	return -EFAULT;
+}
+
 static struct kshark_task_list *
 kshark_find_task(struct kshark_context *kshark_ctx, uint32_t key, int pid)
 {
diff --git a/src/libkshark.h b/src/libkshark.h
index 9f7b6b1f..77fa4c54 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -121,6 +121,19 @@ void kshark_hash_id_free(struct kshark_hash_id *hash);
 
 int *kshark_hash_ids(struct kshark_hash_id *hash);
 
+/* Quiet warnings over documenting simple structures */
+//! @cond Doxygen_Suppress
+
+static const char top_name[] = { 0x1b, 0x00 }; // Non printable character
+
+//! @endcond
+
+/**
+ * Non printable character used for the name in the case when the name has to
+ * be ignored.
+ */
+#define KS_UNNAMED	(char *) &top_name
+
 struct kshark_data_stream;
 
 /** A function type to be used by the method interface of the data stream. */
@@ -264,6 +277,9 @@ struct kshark_generic_stream_interface {
 /** The limit in size of the data format identifier string. */
 #define KS_DATA_FORMAT_SIZE	15
 
+/** Data format identifier string indicating invalid data. */
+#define KS_INVALID_DATA		"invalid data"
+
 /** Structure representing a stream of trace data. */
 struct kshark_data_stream {
 	/** Data stream identifier. */
@@ -320,6 +336,12 @@ struct kshark_data_stream {
 	void				*interface;
 };
 
+static inline char *kshark_set_data_format(char *dest_format,
+					   const char *src_format)
+{
+	return strncpy(dest_format, src_format, KS_DATA_FORMAT_SIZE - 1);
+}
+
 /** Size of the task's hash table. */
 #define KS_TASK_HASH_SHIFT 16
 #define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
@@ -333,8 +355,32 @@ struct kshark_task_list {
 	int			 pid;
 };
 
+/**
+ * Structure representing the parameters of the stream descriptor array owned
+ * by the kshark session.
+ */
+struct kshark_stream_array_descriptor {
+	/** The identifier of the Data stream added. */
+	int		max_stream_id;
+
+	/** The the next free Data stream identifier (index). */
+	int		next_free_stream_id;
+
+	/** The capacity of the array of stream objects (pointers). */
+	int		array_size;
+};
+
 /** Structure representing a kshark session. */
 struct kshark_context {
+	/** Array of data stream descriptors. */
+	struct kshark_data_stream	**stream;
+
+	/** The number of data streams. */
+	int				n_streams;
+
+	/** Parameters of the stream descriptor array. */
+	struct kshark_stream_array_descriptor	stream_info;
+
 	/** Input handle for the trace data file. */
 	struct tracecmd_input	*handle;
 
@@ -392,6 +438,18 @@ bool kshark_instance(struct kshark_context **kshark_ctx);
 
 bool kshark_open(struct kshark_context *kshark_ctx, const char *file);
 
+int kshark_add_stream(struct kshark_context *kshark_ctx);
+
+int kshark_remove_stream(struct kshark_context *kshark_ctx, int sd);
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
 
@@ -411,6 +469,10 @@ void kshark_close(struct kshark_context *kshark_ctx);
 
 void kshark_free(struct kshark_context *kshark_ctx);
 
+char *kshark_comm_from_pid(int sd, int pid);
+
+char *kshark_event_from_id(int sd, int event_id);
+
 int kshark_get_pid_easy(struct kshark_entry *entry);
 
 const char *kshark_get_task_easy(struct kshark_entry *entry);
@@ -427,6 +489,48 @@ void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec);
 
 char* kshark_dump_entry(const struct kshark_entry *entry);
 
+void kshark_print_entry(const struct kshark_entry *entry);
+
+int kshark_get_pid(const struct kshark_entry *entry);
+
+int kshark_get_event_id(const struct kshark_entry *entry);
+
+int *kshark_get_all_event_ids(struct kshark_data_stream *stream);
+
+int kshark_find_event_id(struct kshark_data_stream *stream,
+			 const char *event_name);
+
+char *kshark_get_event_name(const struct kshark_entry *entry);
+
+char *kshark_get_task(const struct kshark_entry *entry);
+
+char *kshark_get_info(const struct kshark_entry *entry);
+
+char *kshark_get_aux_info(const struct kshark_entry *entry);
+
+kshark_event_field_format
+kshark_get_event_field_type(const struct kshark_entry *entry,
+			    const char *field);
+
+int kshark_get_all_event_field_names(const struct kshark_entry *entry,
+				     char ***field);
+
+int kshark_read_record_field_int(struct kshark_data_stream *stream, void *rec,
+				 const char *field, int64_t *val);
+
+int kshark_read_event_field_int(const struct kshark_entry *entry,
+				const char* field, int64_t *val);
+
+ssize_t kshark_load_entries(struct kshark_context *kshark_ctx, int sd,
+			    struct kshark_entry ***data_rows);
+
+ssize_t kshark_load_matrix(struct kshark_context *kshark_ctx, int sd,
+			   int16_t **event_array,
+			   int16_t **cpu_array,
+			   int32_t **pid_array,
+			   int64_t **offset_array,
+			   int64_t **ts_array);
+
 /**
  * Custom entry info function type. To be user for dumping info for custom
  * KernelShark entryes.
-- 
2.25.1

