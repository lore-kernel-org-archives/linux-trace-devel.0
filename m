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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CD3C4167B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83712239E5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732621AbgLINny (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732620AbgLINnx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:43:53 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AE7C0611D0
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:42:37 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id a12so1786963wrv.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sIRjXE6NlWPL82WjEH7+6tPmUpmeMs1H79KujRiaHkE=;
        b=qoZzdSXC69rnxAVqeIBtRL0811L0hjPwNRvBUJ3ZENaJSXZfVFPmiA54LhVwtS1U6z
         AsV9Ju2ZQJgJLXl7PJEvxjd10Q80nXZQnFbZ6aeJl7Pnkv0/zoJwQBkMavePrVDuV/SE
         seQOFvXekyB3KMTOCFpVKSJNtpZwubNK17JpXvh2V1F6W5/5Gbze762achVyVkUkKtSF
         5ECFFs5oS6SJ28ZTTKsXGXGmFxsOmraDGyWyrHK+R+yLtlkgN6YEfXsfdDNnC7iwdTY5
         9ySaQj7TAb7czs2Kfglz7ty/jeQyoWMOZWJPJjh/IZPRy19Yv/Kkm156vV6/b+59bCGD
         a7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sIRjXE6NlWPL82WjEH7+6tPmUpmeMs1H79KujRiaHkE=;
        b=qsXhgZVqlvyyXqQmUrBWDGq13km2iVw3SfBP7C5gC59kBRN7vsygpo6SJaEJqqn6hj
         LLzg8TZe3JLnj88Xja1tMDCY2Dk+sK5kTsGBJL5Xkg0pm4kpyvjNR7/9W89ccFSpWrKD
         /6k+2FvQRVfzVWNiuTj/LWH65eRi58pE99uhboZDAycjskato2wEhQaXaNpknfoaMF7A
         IDs7c/kThnmkxVvHa1DhGqNhB4MFu4voUJ9D/YlQR3v/PZL8k9zRHKpIgi3i8PWu7z0b
         XQ7OkvxnoIEby73rUt0FfZVLQ9cCvuhdZ60QcRE7UiRJMUD0sGk6S+msSPOmwB7VBx0m
         2kHw==
X-Gm-Message-State: AOAM531iTDANSHfOXEF7aLXsEc59Yz8PbP33Y0U6BxgIr280lh7svmVd
        oADAKYYg0iRMI+uXiBe+ABA=
X-Google-Smtp-Source: ABdhPJwCQxoIBo1IHnPzxd30C1WG60BazmaLepvZllGXlBORwBNWads+Zi1a+hOLMSjuo5wUll7v3A==
X-Received: by 2002:adf:9525:: with SMTP id 34mr2877192wrs.389.1607521355739;
        Wed, 09 Dec 2020 05:42:35 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id q143sm3871071wme.28.2020.12.09.05.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:42:35 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 19/27] kernel-shark: Add methods for time calibration
Date:   Wed,  9 Dec 2020 15:41:55 +0200
Message-Id: <20201209134203.428068-20-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134203.428068-1-y.karadz@gmail.com>
References: <20201209134203.428068-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We add an infrastructure for correcting the timestamps of the entries.
This is needed in order to correlate Data streams that have been
recorded using non-synchronized clocks. The infrastructure can handle
an arbitrary timestamps correction formula, however for the moment we
only provide calibration that adds a constant offset.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-tepdata.c | 13 +++++-
 src/libkshark.c         | 99 +++++++++++++++++++++++++++++++++++++++++
 src/libkshark.h         | 27 +++++++++++
 3 files changed, 138 insertions(+), 1 deletion(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 11bf441..0b23912 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -338,6 +338,9 @@ static ssize_t get_records(struct kshark_context *kshark_ctx,
 					entry = &temp_rec->entry;
 					missed_events_action(stream, rec, entry);
 
+					/* Apply time calibration. */
+					kshark_postprocess_entry(stream, rec, entry);
+
 					entry->stream_id = stream->stream_id;
 
 					temp_next = &temp_rec->next;
@@ -360,6 +363,12 @@ static ssize_t get_records(struct kshark_context *kshark_ctx,
 
 				entry->stream_id = stream->stream_id;
 
+				/*
+				 * Post-process the content of the entry. This includes
+				 * time calibration and event-specific plugin actions.
+				 */
+				kshark_postprocess_entry(stream, rec, entry);
+
 				pid = entry->pid;
 
 				/* Apply Id filtering. */
@@ -527,8 +536,10 @@ static ssize_t tepdata_load_matrix(struct kshark_data_stream *stream,
 			if (cpu_array)
 				(*cpu_array)[count] = e->cpu;
 
-			if (ts_array)
+			if (ts_array) {
+				kshark_calib_entry(stream, e);
 				(*ts_array)[count] = e->ts;
+			}
 
 			if (pid_array)
 				(*pid_array)[count] = e->pid;
diff --git a/src/libkshark.c b/src/libkshark.c
index cc8bd93..315c24f 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -131,6 +131,7 @@ static void kshark_stream_free(struct kshark_data_stream *stream)
 
 	kshark_hash_id_free(stream->tasks);
 
+	free(stream->calib_array);
 	free(stream->file);
 	free(stream->name);
 	free(stream->interface);
@@ -1367,6 +1368,37 @@ void kshark_plugin_actions(struct kshark_data_stream *stream,
 	}
 }
 
+/**
+ * @brief Time calibration of the timestamp of the entry.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param entry: Output location for entry.
+ */
+void kshark_calib_entry(struct kshark_data_stream *stream,
+			struct kshark_entry *entry)
+{
+	if (stream->calib && stream->calib_array) {
+		/* Calibrate the timestamp of the entry. */
+		stream->calib(&entry->ts, stream->calib_array);
+	}
+}
+
+/**
+ * @brief Post-process the content of the entry. This includes time calibration
+ *	  and all registered event-specific plugin actions.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param record: Input location for the trace record.
+ * @param entry: Output location for entry.
+ */
+void kshark_postprocess_entry(struct kshark_data_stream *stream,
+			      void *record, struct kshark_entry *entry)
+{
+	kshark_calib_entry(stream, entry);
+
+	kshark_plugin_actions(stream, record, entry);
+}
+
 static inline void free_ptr(void *ptr)
 {
 	if (ptr)
@@ -1764,6 +1796,73 @@ kshark_get_entry_back(const struct kshark_entry_request *req,
 	return get_entry(req, data, index, req->first, end, -1);
 }
 
+static int compare_time(const void* a, const void* b)
+{
+	const struct kshark_entry *entry_a, *entry_b;
+
+	entry_a = *(const struct kshark_entry **) a;
+	entry_b = *(const struct kshark_entry **) b;
+
+	if (entry_a->ts > entry_b->ts)
+		return 1;
+
+	if (entry_a->ts < entry_b->ts)
+		return -1;
+
+	return 0;
+}
+
+static void kshark_data_qsort(struct kshark_entry **entries, size_t size)
+{
+	qsort(entries, size, sizeof(struct kshark_entry *), compare_time);
+}
+
+/**
+ * Add constant offset to the timestamp of the entry. To be used by the sream
+ * object as a System clock calibration callback function.
+ */
+void kshark_offset_calib(int64_t *ts, int64_t *argv)
+{
+	*ts += argv[0];
+}
+
+/**
+ * @brief Apply constant offset to the timestamps of all entries from a given
+ *	  Data stream.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param entries: Input location for the trace data.
+ * @param size: The size of the trace data.
+ * @param sd: Data stream identifier.
+ * @param offset: The constant offset to be added (in nanosecond).
+ */
+void kshark_set_clock_offset(struct kshark_context *kshark_ctx,
+			     struct kshark_entry **entries, size_t size,
+			     int sd, int64_t offset)
+{
+	struct kshark_data_stream *stream;
+	int64_t correction;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return;
+
+	if (!stream->calib_array) {
+		stream->calib = kshark_offset_calib;
+		stream->calib_array = calloc(1, sizeof(*stream->calib_array));
+		stream->calib_array_size = 1;
+	}
+
+	correction = offset - stream->calib_array[0];
+	stream->calib_array[0] = offset;
+
+	for (size_t i = 0; i < size; ++i)
+		if (entries[i]->stream_id == sd)
+			entries[i]->ts += correction;
+
+	kshark_data_qsort(entries, size);
+}
+
 static int first_in_time_entry(struct kshark_entry_data_set *buffer, int n_buffers, size_t *count)
 {
 	int64_t t_min = INT64_MAX;
diff --git a/src/libkshark.h b/src/libkshark.h
index edf3dcf..dce3dd2 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -129,6 +129,12 @@ static const char top_name[] = { 0x1b, 0x00 }; // Non printable character
  */
 #define KS_UNNAMED	(char *) &top_name
 
+/**
+ * Timestamp calibration function type. To be user for system clock
+ * calibration.
+ */
+typedef void (*time_calib_func) (int64_t *, int64_t *);
+
 struct kshark_data_stream;
 
 /** A function type to be used by the method interface of the data stream. */
@@ -327,6 +333,15 @@ struct kshark_data_stream {
 	/** The number of plugins registered for this stream.*/
 	int			n_plugins;
 
+	/** System clock calibration function. */
+	time_calib_func		calib;
+
+	/** An array of time calibration constants. */
+	int64_t			*calib_array;
+
+	/** The size of the array of time calibration constants. */
+	size_t			calib_array_size;
+
 	/** List of Plugin's Event handlers. */
 	struct kshark_event_proc_handler	*event_handlers;
 
@@ -590,6 +605,12 @@ void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
 void kshark_plugin_actions(struct kshark_data_stream *stream,
 			   void *record, struct kshark_entry *entry);
 
+void kshark_calib_entry(struct kshark_data_stream *stream,
+			struct kshark_entry *entry);
+
+void kshark_postprocess_entry(struct kshark_data_stream *stream,
+			      void *record, struct kshark_entry *entry);
+
 /** Search failed identifiers. */
 enum kshark_search_failed {
 	/** All entries have greater timestamps. */
@@ -980,6 +1001,12 @@ struct kshark_config_doc *kshark_open_config_file(const char *file_name,
 
 struct kshark_config_doc *kshark_json_to_conf(struct json_object *jobj);
 
+void kshark_offset_calib(int64_t *ts, int64_t *atgv);
+
+void kshark_set_clock_offset(struct kshark_context *kshark_ctx,
+			     struct kshark_entry **entries, size_t size,
+			     int sd, int64_t offset);
+
 /** Structure representing a data set made of KernelShark entries. */
 struct kshark_entry_data_set {
 	/** Array of entries pointers. */
-- 
2.25.1

