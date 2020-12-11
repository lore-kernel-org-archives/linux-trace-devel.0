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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA43C4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AEAD23A7C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437703AbgLKPLS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437702AbgLKPKW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:10:22 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4F4C0619D4
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:40 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c198so7832556wmd.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sIRjXE6NlWPL82WjEH7+6tPmUpmeMs1H79KujRiaHkE=;
        b=aSatvW4YzqfG48QcCmZYQhJZuQ9iRcC7Rbb4w8Yi5EbcFFc7HsLyJD3+GX5T6iNBmX
         SF+7AqYntZPqAk1IaHJ6pBgaytPITKID0vIcnpDn8yelo3rx+ez2gGIo0/W+q8yZh0Kz
         zRPUj6scGDBQ+Wlv3kx402oEYUi6dTOapquuS95kKbU8LsuIo3MU60dsSBcFasbbEwTf
         V3qRGZ8QG5UM4Y+OGW/2cfu4ctRC3Uh0w1l3yeL/03XDbhbvCXYUJo9bwqh26oV5ClLP
         arh2MuUMk6wxQTFNvaeiuoGGh37tRyfigiKtvPMn10W8e1pnHOQTMo2LcOEVB6nh7yuV
         GIzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sIRjXE6NlWPL82WjEH7+6tPmUpmeMs1H79KujRiaHkE=;
        b=hsvLGy9tjX+uLmKJM34a+M3cyo2NZ/7hi0nZOFvgHbqvnOVP7UTymgajkBGHrgR8BJ
         FgXgKffdW+mQgagReGgtu9kh5t+VSsZMLTs1ZcIfb2/VmR6vfvMVpywFBa+8dqAiw3SR
         bZYIwIXLRpVtsbv//onKDiTfSAPm93asusumWbBblWdTavnmN1wxPKNxH3ZKlBSU9EFW
         mU6GfPVIDcDGwgmQSoHvT4m+rCgHS21vGR9/e2oixCmS3czgQRgOcqdFqtYIGxPe+n/j
         yfW0/+gQsg9GqsORVuylwE8ZLiJKmjOvDvCSXfMIX7nPdHma7Nyb66paxWdPq+Xrssmr
         KT4Q==
X-Gm-Message-State: AOAM53253IpD+yc2UPQNNFyOsgC1cTxLYcydiaLGnHuom0K89zVIIZnA
        LW+iKkQptkKMNOO/q85WneU=
X-Google-Smtp-Source: ABdhPJyLofMS3SHgorLUIFi7J1rXj8KIaksDXYG9Pqvjg14XQzjG93IL4SyBfuBJF3MlyPpRNAF2gQ==
X-Received: by 2002:a1c:454:: with SMTP id 81mr14054985wme.178.1607699319082;
        Fri, 11 Dec 2020 07:08:39 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:38 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 24/32] kernel-shark: Add methods for time calibration
Date:   Fri, 11 Dec 2020 17:07:48 +0200
Message-Id: <20201211150756.577366-25-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
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

