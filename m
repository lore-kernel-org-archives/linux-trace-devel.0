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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA9D0C2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A13D022249
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TAgH6hC9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgKLOYk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 09:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbgKLOYk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 09:24:40 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADFFC0613D1
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:39 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id j7so6206730wrp.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2k/cihOh2KLwE1zdCU9WvInL8UR6wytFcT2G4zPhyaA=;
        b=TAgH6hC9J4g3jl3fzYoLbfY7gBtHQ0InOHO17sU9zjE5I4TK+nl2TK8TWvfsBUg1fO
         e/gHvCKBzVCaeHjXKFLFc063CmLX0M5Uk5AW/RzOpoPUNoI8g5RbJpQTbioZxtApAtGj
         4SDrIDM0eq/rJ98l1u73GB/uYDv6H3LL5niQw/mbuod0TYIq+dUSZHu7mnstyQJN/7/w
         K3LzRzMwGJ7vyV1zbbel6Xv2b138VVk61r1XVVUygRWd3+BKERk9hzQjSWFua9RzANwm
         337VI8F+mmuKdsm4mTM+y69DVuBlAjFCNh3RnnKsFIg34B6lRjBg18PKPr0NCEArtLt4
         Yh+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2k/cihOh2KLwE1zdCU9WvInL8UR6wytFcT2G4zPhyaA=;
        b=UC5//19ieoOJ2I9npjMqbxKbfT9mqTSAE5k9b/6N/o6Q+cgMVJNS86aseDxxFcqcYK
         2h/Ox+x60AXYq+JhphohHgd2GFCVDQ2wXEPLLnYGs5dSwVJi+I91h/oTajDoiBwuEDm8
         qdkskIPW50gZu8jDprm4QIl0PDE277ErNCcKOIEQYeDTZ7lmRu3XKinMPwsUNGuM44NC
         1iwCMO8Zhx/wqLgWdWMOdWf6VVmpJGVPRpTjkkV2YSrS+OuAyU2em0vmC9pUaXBtV6ZX
         HluqVeTNF1CAOIc2JxpaMhDxxMe2XvUPV4/REP6/X1oj3ZX7gqfdRyxEqQEx6GMi7tkC
         fJww==
X-Gm-Message-State: AOAM530rRhDdcxpA6OVp/fBf+0mkrHELE7m8SxYErAIDXkP9GHz4qyvY
        pMagRivN0KCbjnQpu1RhWo/XEr8QtrI=
X-Google-Smtp-Source: ABdhPJz6M95+DmKsRzpDf2CiWJ88N3UUC3eAzF/lBGhTGdCqR0pRksl+Aj2p1vCbpmdSFNdTFr2+Ag==
X-Received: by 2002:a5d:514f:: with SMTP id u15mr24572474wrt.385.1605191078577;
        Thu, 12 Nov 2020 06:24:38 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id h15sm6950685wrw.15.2020.11.12.06.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 06:24:38 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 19/20] kernel-shark: Add methods for time calibration
Date:   Thu, 12 Nov 2020 16:23:57 +0200
Message-Id: <20201112142358.36821-20-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112142358.36821-1-y.karadz@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
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
index e1f83dbd..719041d3 100644
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
@@ -358,6 +361,12 @@ static ssize_t get_records(struct kshark_context *kshark_ctx,
 
 				entry->stream_id = stream->stream_id;
 
+				/*
+				 * Post-process the content of the entry. This includes
+				 * time calibration and event-specific plugin actions.
+				 */
+				kshark_postprocess_entry(stream, rec, entry);
+
 				pid = entry->pid;
 
 				/* Apply Id filtering. */
@@ -523,8 +532,10 @@ static ssize_t tepdata_load_matrix(struct kshark_data_stream *stream,
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
index d4b8af72..d8f67d6a 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -131,6 +131,7 @@ static void kshark_stream_free(struct kshark_data_stream *stream)
 
 	kshark_hash_id_free(stream->tasks);
 
+	free(stream->calib_array);
 	free(stream->file);
 	free(stream->name);
 	free(stream->interface);
@@ -1381,6 +1382,37 @@ void kshark_plugin_actions(struct kshark_data_stream *stream,
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
@@ -1778,6 +1810,73 @@ kshark_get_entry_back(const struct kshark_entry_request *req,
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
index 8f7900f1..e958c577 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -128,6 +128,12 @@ static const char top_name[] = { 0x1b, 0x00 }; // Non printable character
  */
 #define KS_UNNAMED	(char *) &top_name
 
+/**
+ * Timestamp calibration function type. To be user for system clock
+ * calibration.
+ */
+typedef void (*time_calib_func) (int64_t *, int64_t *);
+
 struct kshark_data_stream;
 
 /** A function type to be used to initialize the interface of the data stream. */
@@ -343,6 +349,15 @@ struct kshark_data_stream {
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
 
@@ -600,6 +615,12 @@ void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
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
@@ -990,6 +1011,12 @@ struct kshark_config_doc *kshark_open_config_file(const char *file_name,
 
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

