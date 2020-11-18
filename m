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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42134C6369E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4C58246EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:51:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MGOLPYsU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgKROuk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 09:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727187AbgKROui (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 09:50:38 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61232C0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:38 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id a186so491943wme.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PqfdS/6TnB1dhHo01hicCaLFWXdFlAcnj6YCifRy0Mc=;
        b=MGOLPYsU6k63RVrGWWFjlheNz0hlnrHhIUaQMkaP7SrUvomYkuQ6o08sVNwQmWlhLZ
         1/3MPMoRrMVnmK9L+48/DoYVHORrWRUmnQIe/AAi7Lnz9Md0MTRjabafaAtx3SfNHlY4
         ewI9vJz8PqaPmtjNK7UFchwKjb1PLW6jDVv/DpzMbCe56zUkq7ilCZPsmB2P1PNdehyG
         UzCbS1yy63CcYs+uJQYMtUZCLFHbtjQW2uamQYOSp60pSX5kzscHmmor5m+62aAohFBo
         kDAoGJ2Zailo04N34mtYA8ns4WIYKF94W5TcuhvQMtXNiH+MBJVY4sYRF++B58x8fKXP
         LdGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PqfdS/6TnB1dhHo01hicCaLFWXdFlAcnj6YCifRy0Mc=;
        b=etvjmAKYIjZIRlbBkGvG/qdLxBfl5fUn0WhuwkOswAFt8hy4MTG4bj3QXjWZRTxe7q
         0Tj2IIXipLGnXKA4CHvsKwo1ySMEayHyJPq/tdxU7ZeHdRhxpjfN80A7kvThsiZkKYP3
         XKQ0lV19nioLOBF2hOcnTE/Jt6P6Lt5oAq31b1uyW+pdCRdnb+EJ5qr4s2/Zk1gbXaw+
         JOsVFdr8W13jVtRBqWuvDsbQDU6sECzYNL/XkAdrLoqLwHwKhzUQkJn+ePVz7zrdYQ5o
         M0dSkIPAUWqNYjLsohfTbWLXdT5hQFk7zrcqkOUT27DgNrjUA/yG7gLOkC5vGwc/hrbL
         6sAw==
X-Gm-Message-State: AOAM532zo16oT3Qi2b7Ls+hAfgkVTycoUPLYQWbKaWGFbuTS1H/xC2D2
        Jj3INXsX8jXYhtZs2yfvsp7j5pXfrCQ=
X-Google-Smtp-Source: ABdhPJzD/MNe8cjD6pwM2VWksKQx0YtWeMSzOXKhoGrxHEFqh4Gb9M6Bo1Q2Inm51/R5fdNii4LEHA==
X-Received: by 2002:a1c:81d7:: with SMTP id c206mr406306wmd.140.1605711036624;
        Wed, 18 Nov 2020 06:50:36 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id s202sm3926190wme.39.2020.11.18.06.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 06:50:36 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 11/20] kernel-shark: Remove dead code
Date:   Wed, 18 Nov 2020 16:49:54 +0200
Message-Id: <20201118145003.156542-12-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201118145003.156542-1-y.karadz@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Clean up the old readout code that is no longer used after switching
to the implementation provided by the Data stream interface.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.c | 826 +-----------------------------------------------
 src/libkshark.h |  70 +---
 2 files changed, 8 insertions(+), 888 deletions(-)

diff --git a/src/libkshark.c b/src/libkshark.c
index af1545d7..63dd233e 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -6,7 +6,7 @@
 
  /**
  *  @file    libkshark.c
- *  @brief   API for processing of FTRACE (trace-cmd) data.
+ *  @brief   API for processing of tracing data.
  */
 
 /** Use GNU C Library. */
@@ -21,8 +21,6 @@
 #include "libkshark.h"
 #include "libkshark-tepdata.h"
 
-static __thread struct trace_seq seq;
-
 static struct kshark_context *kshark_context_handler = NULL;
 
 static bool kshark_default_context(struct kshark_context **context)
@@ -35,6 +33,8 @@ static bool kshark_default_context(struct kshark_context **context)
 
 	kshark_ctx->stream = calloc(KS_DEFAULT_NUM_STREAMS,
 				    sizeof(*kshark_ctx->stream));
+	kshark_ctx->stream_info.array_size = KS_DEFAULT_NUM_STREAMS;
+	kshark_ctx->stream_info.max_stream_id = -1;
 
 	kshark_ctx->event_handlers = NULL;
 	kshark_ctx->collections = NULL;
@@ -65,14 +65,6 @@ static bool kshark_default_context(struct kshark_context **context)
 	return true;
 }
 
-static bool init_thread_seq(void)
-{
-	if (!seq.buffer)
-		trace_seq_init(&seq);
-
-	return seq.buffer != NULL;
-}
-
 /**
  * @brief Initialize a kshark session. This function must be called before
  *	  calling any other kshark function. If the session has been
@@ -109,9 +101,6 @@ bool kshark_instance(struct kshark_context **kshark_ctx)
 		}
 	}
 
-	if (!init_thread_seq())
-		return false;
-
 	return true;
 }
 
@@ -475,19 +464,10 @@ int kshark_close(struct kshark_context *kshark_ctx, int sd)
  */
 void kshark_close_all(struct kshark_context *kshark_ctx)
 {
-	int i, *stream_ids, n_streams;
-
-	stream_ids = kshark_all_streams(kshark_ctx);
-
-	/*
-	 * Get a copy of shark_ctx->n_streams befor you start closing. Be aware
-	 * that kshark_close() will decrement shark_ctx->n_streams.
-	 */
-	n_streams = kshark_ctx->n_streams;
-	for (i = 0; i < n_streams; ++i)
-		kshark_close(kshark_ctx, stream_ids[i]);
+	int i;
 
-	free(stream_ids);
+	for (i = 0; i <= kshark_ctx->stream_info.max_stream_id; ++i)
+		kshark_close(kshark_ctx, i);
 }
 
 /**
@@ -1011,42 +991,6 @@ ssize_t kshark_load_matrix(struct kshark_context *kshark_ctx, int sd,
 	return -EFAULT;
 }
 
-static struct kshark_task_list *
-kshark_find_task(struct kshark_context *kshark_ctx, uint32_t key, int pid)
-{
-	struct kshark_task_list *list;
-
-	for (list = kshark_ctx->tasks[key]; list; list = list->next) {
-		if (list->pid == pid)
-			return list;
-	}
-
-	return NULL;
-}
-
-static struct kshark_task_list *
-kshark_add_task(struct kshark_context *kshark_ctx, int pid)
-{
-	struct kshark_task_list *list;
-	uint32_t key;
-
-	key = tracecmd_quick_hash(pid, KS_TASK_HASH_SHIFT);
-
-	list = kshark_find_task(kshark_ctx, key, pid);
-	if (list)
-		return list;
-
-	list = malloc(sizeof(*list));
-	if (!list)
-		return NULL;
-
-	list->pid = pid;
-	list->next = kshark_ctx->tasks[key];
-	kshark_ctx->tasks[key] = list;
-
-	return list;
-}
-
 /**
  * @brief Get an array containing the Process Ids of all tasks presented in
  *	  the loaded trace data file.
@@ -1214,7 +1158,7 @@ static void set_all_visible(uint16_t *v) {
  *	  are filtered-out.
  *	  WARNING: Do not use this function if the advanced filter is set.
  *	  Applying the advanced filter requires access to prevent_record,
- *	  hence the data has to be reloaded using kshark_load_data_entries().
+ *	  hence the data has to be reloaded using kshark_load_entries().
  *
  * @param kshark_ctx: Input location for the session context pointer.
  * @param data: Input location for the trace data to be filtered.
@@ -1275,400 +1219,6 @@ void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
 		set_all_visible(&data[i]->visible);
 }
 
-static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
-				    struct tep_record *record,
-				    struct kshark_entry *entry)
-{
-	/* Offset of the record */
-	entry->offset = record->offset;
-
-	/* CPU Id of the record */
-	entry->cpu = record->cpu;
-
-	/* Time stamp of the record */
-	entry->ts = record->ts;
-
-	/* Event Id of the record */
-	entry->event_id = tep_data_type(kshark_ctx->pevent, record);
-
-	/*
-	 * Is visible mask. This default value means that the entry
-	 * is visible everywhere.
-	 */
-	entry->visible = 0xFF;
-
-	/* Process Id of the record */
-	entry->pid = tep_data_pid(kshark_ctx->pevent, record);
-}
-
-/** Prior time offset of the "missed_events" entry. */
-#define ME_ENTRY_TIME_SHIFT	10
-
-static void missed_events_action(struct kshark_context *kshark_ctx,
-				 struct tep_record *record,
-				 struct kshark_entry *entry)
-{
-	/*
-	 * Use the offset field of the entry to store the number of missed
-	 * events.
-	 */
-	entry->offset = record->missed_events;
-
-	entry->cpu = record->cpu;
-
-	/*
-	 * Position the "missed_events" entry a bit before (in time)
-	 * the original record.
-	 */
-	entry->ts = record->ts - ME_ENTRY_TIME_SHIFT;
-
-	/* All custom entries must have negative event Identifiers. */
-	entry->event_id = KS_EVENT_OVERFLOW;
-
-	entry->visible = 0xFF;
-
-	entry->pid = tep_data_pid(kshark_ctx->pevent, record);
-}
-
-static const char* missed_events_dump(struct kshark_context *kshark_ctx,
-				      const struct kshark_entry *entry,
-				      bool get_info)
-{
-	int size = 0;
-	static char *buffer;
-
-	if (get_info)
-		size = asprintf(&buffer, "missed_events=%i", (int) entry->offset);
-	else
-		size = asprintf(&buffer, "missed_events");
-	if (size > 0)
-		return buffer;
-
-	return NULL;
-}
-
-/**
- * rec_list is used to pass the data to the load functions.
- * The rec_list will contain the list of entries from the source,
- * and will be a link list of per CPU entries.
- */
-struct rec_list {
-	union {
-		/* Used by kshark_load_data_records */
-		struct {
-			/** next pointer, matches entry->next */
-			struct rec_list		*next;
-			/** pointer to the raw record data */
-			struct tep_record	*rec;
-		};
-		/** entry - Used for kshark_load_data_entries() */
-		struct kshark_entry		entry;
-	};
-};
-
-/**
- * rec_type defines what type of rec_list is being used.
- */
-enum rec_type {
-	REC_RECORD,
-	REC_ENTRY,
-};
-
-static void free_rec_list(struct rec_list **rec_list, int n_cpus,
-			  enum rec_type type)
-{
-	struct rec_list *temp_rec;
-	int cpu;
-
-	for (cpu = 0; cpu < n_cpus; ++cpu) {
-		while (rec_list[cpu]) {
-			temp_rec = rec_list[cpu];
-			rec_list[cpu] = temp_rec->next;
-			if (type == REC_RECORD)
-				free_record(temp_rec->rec);
-			free(temp_rec);
-		}
-	}
-	free(rec_list);
-}
-
-static ssize_t get_records(struct kshark_context *kshark_ctx,
-			   struct rec_list ***rec_list, enum rec_type type)
-{
-	struct kshark_event_handler *evt_handler;
-	struct tep_event_filter *adv_filter;
-	struct kshark_task_list *task;
-	struct tep_record *rec;
-	struct rec_list **temp_next;
-	struct rec_list **cpu_list;
-	struct rec_list *temp_rec;
-	size_t count, total = 0;
-	int n_cpus;
-	int pid;
-	int cpu;
-
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
-	cpu_list = calloc(n_cpus, sizeof(*cpu_list));
-	if (!cpu_list)
-		return -ENOMEM;
-
-	/* Just to shorten the name */
-	if (type == REC_ENTRY)
-		adv_filter = kshark_ctx->advanced_event_filter;
-
-	for (cpu = 0; cpu < n_cpus; ++cpu) {
-		count = 0;
-		cpu_list[cpu] = NULL;
-		temp_next = &cpu_list[cpu];
-
-		rec = tracecmd_read_cpu_first(kshark_ctx->handle, cpu);
-		while (rec) {
-			*temp_next = temp_rec = calloc(1, sizeof(*temp_rec));
-			if (!temp_rec)
-				goto fail;
-
-			temp_rec->next = NULL;
-
-			switch (type) {
-			case REC_RECORD:
-				temp_rec->rec = rec;
-				pid = tep_data_pid(kshark_ctx->pevent, rec);
-				break;
-			case REC_ENTRY: {
-				struct kshark_entry *entry;
-				int ret;
-
-				if (rec->missed_events) {
-					/*
-					 * Insert a custom "missed_events" entry just
-					 * befor this record.
-					 */
-					entry = &temp_rec->entry;
-					missed_events_action(kshark_ctx, rec, entry);
-
-					temp_next = &temp_rec->next;
-					++count;
-
-					/* Now allocate a new rec_list node and comtinue. */
-					*temp_next = temp_rec = calloc(1, sizeof(*temp_rec));
-				}
-
-				entry = &temp_rec->entry;
-				kshark_set_entry_values(kshark_ctx, rec, entry);
-
-				/* Execute all plugin-provided actions (if any). */
-				evt_handler = kshark_ctx->event_handlers;
-				while ((evt_handler = kshark_find_event_handler(evt_handler,
-										entry->event_id))) {
-					evt_handler->event_func(kshark_ctx, rec, entry);
-					evt_handler = evt_handler->next;
-					entry->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
-				}
-
-				pid = entry->pid;
-				/* Apply event filtering. */
-				ret = FILTER_MATCH;
-				if (adv_filter->filters)
-					ret = tep_filter_match(adv_filter, rec);
-
-				if (!kshark_show_event(kshark_ctx, entry->event_id) ||
-				    ret != FILTER_MATCH) {
-					unset_event_filter_flag(kshark_ctx, entry);
-				}
-
-				/* Apply CPU filtering. */
-				if (!kshark_show_cpu(kshark_ctx, entry->pid)) {
-					entry->visible &= ~kshark_ctx->filter_mask;
-				}
-
-				/* Apply task filtering. */
-				if (!kshark_show_task(kshark_ctx, entry->pid)) {
-					entry->visible &= ~kshark_ctx->filter_mask;
-				}
-				free_record(rec);
-				break;
-			} /* REC_ENTRY */
-			}
-
-			task = kshark_add_task(kshark_ctx, pid);
-			if (!task) {
-				free_record(rec);
-				goto fail;
-			}
-
-			temp_next = &temp_rec->next;
-
-			++count;
-			rec = tracecmd_read_data(kshark_ctx->handle, cpu);
-		}
-
-		total += count;
-	}
-
-	*rec_list = cpu_list;
-	return total;
-
- fail:
-	free_rec_list(cpu_list, n_cpus, type);
-	return -ENOMEM;
-}
-
-static int pick_next_cpu(struct rec_list **rec_list, int n_cpus,
-			 enum rec_type type)
-{
-	uint64_t ts = 0;
-	uint64_t rec_ts;
-	int next_cpu = -1;
-	int cpu;
-
-	for (cpu = 0; cpu < n_cpus; ++cpu) {
-		if (!rec_list[cpu])
-			continue;
-
-		switch (type) {
-		case REC_RECORD:
-			rec_ts = rec_list[cpu]->rec->ts;
-			break;
-		case REC_ENTRY:
-			rec_ts = rec_list[cpu]->entry.ts;
-			break;
-		}
-		if (!ts || rec_ts < ts) {
-			ts = rec_ts;
-			next_cpu = cpu;
-		}
-	}
-
-	return next_cpu;
-}
-
-/**
- * @brief Load the content of the trace data file into an array of
- *	  kshark_entries. This function provides an abstraction of the
- *	  entries from the raw data that is read, however the "latency"
- *	  and the "info" fields can be accessed only via the offset
- *	  into the file. This makes the access to these two fields much
- *	  slower.
- *	  If one or more filters are set, the "visible" fields of each entry
- *	  is updated according to the criteria provided by the filters. The
- *	  field "filter_mask" of the session's context is used to control the
- *	  level of visibility/invisibility of the filtered entries.
- *
- * @param kshark_ctx: Input location for context pointer.
- * @param data_rows: Output location for the trace data. The user is
- *		     responsible for freeing the elements of the outputted
- *		     array.
- *
- * @returns The size of the outputted data in the case of success, or a
- *	    negative error code on failure.
- */
-ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
-				 struct kshark_entry ***data_rows)
-{
-	struct kshark_entry **rows;
-	struct rec_list **rec_list;
-	enum rec_type type = REC_ENTRY;
-	ssize_t count, total = 0;
-	int n_cpus;
-
-	if (*data_rows)
-		free(*data_rows);
-
-	total = get_records(kshark_ctx, &rec_list, type);
-	if (total < 0)
-		goto fail;
-
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
-
-	rows = calloc(total, sizeof(struct kshark_entry *));
-	if (!rows)
-		goto fail_free;
-
-	for (count = 0; count < total; count++) {
-		int next_cpu;
-
-		next_cpu = pick_next_cpu(rec_list, n_cpus, type);
-
-		if (next_cpu >= 0) {
-			rows[count] = &rec_list[next_cpu]->entry;
-			rec_list[next_cpu] = rec_list[next_cpu]->next;
-		}
-	}
-
-	free_rec_list(rec_list, n_cpus, type);
-	*data_rows = rows;
-	return total;
-
- fail_free:
-	free_rec_list(rec_list, n_cpus, type);
-
- fail:
-	fprintf(stderr, "Failed to allocate memory during data loading.\n");
-	return -ENOMEM;
-}
-
-/**
- * @brief Load the content of the trace data file into an array of
- *	  tep_records. Use this function only if you need fast access
- *	  to all fields of the record.
- *
- * @param kshark_ctx: Input location for the session context pointer.
- * @param data_rows: Output location for the trace data. Use free_record()
- *	 	     to free the elements of the outputted array.
- *
- * @returns The size of the outputted data in the case of success, or a
- *	    negative error code on failure.
- */
-ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
-				 struct tep_record ***data_rows)
-{
-	struct tep_record **rows;
-	struct tep_record *rec;
-	struct rec_list **rec_list;
-	struct rec_list *temp_rec;
-	enum rec_type type = REC_RECORD;
-	ssize_t count, total = 0;
-	int n_cpus;
-
-	total = get_records(kshark_ctx, &rec_list, type);
-	if (total < 0)
-		goto fail;
-
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
-
-	rows = calloc(total, sizeof(struct tep_record *));
-	if (!rows)
-		goto fail_free;
-
-	for (count = 0; count < total; count++) {
-		int next_cpu;
-
-		next_cpu = pick_next_cpu(rec_list, n_cpus, type);
-
-		if (next_cpu >= 0) {
-			rec = rec_list[next_cpu]->rec;
-			rows[count] = rec;
-
-			temp_rec = rec_list[next_cpu];
-			rec_list[next_cpu] = rec_list[next_cpu]->next;
-			free(temp_rec);
-			/* The record is still referenced in rows */
-		}
-	}
-
-	/* There should be no records left in rec_list */
-	free_rec_list(rec_list, n_cpus, type);
-	*data_rows = rows;
-	return total;
-
- fail_free:
-	free_rec_list(rec_list, n_cpus, type);
-
- fail:
-	fprintf(stderr, "Failed to allocate memory during data loading.\n");
-	return -ENOMEM;
-}
-
 static inline void free_ptr(void *ptr)
 {
 	if (ptr)
@@ -1740,294 +1290,6 @@ bool kshark_data_matrix_alloc(size_t n_rows, int16_t **event_array,
 	return false;
 }
 
-static const char *get_latency(struct tep_handle *pe,
-			       struct tep_record *record)
-{
-	if (!record)
-		return NULL;
-
-	trace_seq_reset(&seq);
-	tep_print_event(pe, &seq, record, "%s", TEP_PRINT_LATENCY);
-	return seq.buffer;
-}
-
-static const char *get_info(struct tep_handle *pe,
-				   struct tep_record *record,
-				   struct tep_event *event)
-{
-	char *pos;
-
-	if (!record || !event)
-		return NULL;
-
-	trace_seq_reset(&seq);
-	tep_print_event(pe, &seq, record, "%s", TEP_PRINT_INFO);
-
-	/*
-	 * The event info string contains a trailing newline.
-	 * Remove this newline.
-	 */
-	if ((pos = strchr(seq.buffer, '\n')) != NULL)
-		*pos = '\0';
-
-	return seq.buffer;
-}
-
-/**
- * @brief This function allows for an easy access to the original value of the
- *	  Process Id as recorded in the tep_record object. The record is read
- *	  from the file only in the case of an entry being touched by a plugin.
- *	  Be aware that using the kshark_get_X_easy functions can be
- *	  inefficient if you need an access to more than one of the data fields
- *	  of the record.
- *
- * @param entry: Input location for the KernelShark entry.
- *
- * @returns The original value of the Process Id as recorded in the
- *	    tep_record object on success, otherwise negative error code.
- */
-int kshark_get_pid_easy(struct kshark_entry *entry)
-{
-	struct kshark_context *kshark_ctx = NULL;
-	struct tep_record *data;
-	int pid;
-
-	if (!kshark_instance(&kshark_ctx))
-		return -ENODEV;
-
-	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {
-		pid = entry->pid;
-	} else {
-		/*
-		 * The entry has been touched by a plugin callback function.
-		 * Because of this we do not trust the value of "entry->pid".
-		 *
-		 * Currently the data reading operations are not thread-safe.
-		 * Use a mutex to protect the access.
-		 */
-		pthread_mutex_lock(&kshark_ctx->input_mutex);
-
-		data = tracecmd_read_at(kshark_ctx->handle, entry->offset,
-					NULL);
-		pid = tep_data_pid(kshark_ctx->pevent, data);
-		free_record(data);
-
-		pthread_mutex_unlock(&kshark_ctx->input_mutex);
-	}
-
-	return pid;
-}
-
-/**
- * @brief This function allows for an easy access to the original value of the
- *	  Task name as recorded in the tep_record object. The record is read
- *	  from the file only in the case of an entry being touched by a plugin.
- *	  Be aware that using the kshark_get_X_easy functions can be
- *	  inefficient if you need an access to more than one of the data fields
- *	  of the record.
- *
- * @param entry: Input location for the KernelShark entry.
- *
- * @returns The original name of the task, retrieved from the Process Id
- *	    recorded in the tep_record object on success, otherwise NULL.
- */
-const char *kshark_get_task_easy(struct kshark_entry *entry)
-{
-	struct kshark_context *kshark_ctx = NULL;
-	int pid = kshark_get_pid_easy(entry);
-
-	if (pid < 0)
-		return NULL;
-
-	kshark_instance(&kshark_ctx);
-	return tep_data_comm_from_pid(kshark_ctx->pevent, pid);
-}
-
-/**
- * @brief This function allows for an easy access to the latency information
- *	  recorded in the tep_record object. The record is read from the file
- *	  using the offset field of kshark_entry. Be aware that using the
- *	  kshark_get_X_easy functions can be inefficient if you need an access
- *	  to more than one of the data fields of the record.
- *
- * @param entry: Input location for the KernelShark entry.
- *
- * @returns On success the function returns a string showing the latency
- *	    information, coded into 5 fields:
- *	    interrupts disabled, need rescheduling, hard/soft interrupt,
- *	    preempt count and lock depth. On failure it returns NULL.
- */
-const char *kshark_get_latency_easy(struct kshark_entry *entry)
-{
-	struct kshark_context *kshark_ctx = NULL;
-	struct tep_record *data;
-	const char *lat;
-
-	if (!kshark_instance(&kshark_ctx))
-		return NULL;
-
-	if (entry->event_id < 0)
-		return NULL;
-
-	/*
-	 * Currently the data reading operations are not thread-safe.
-	 * Use a mutex to protect the access.
-	 */
-	pthread_mutex_lock(&kshark_ctx->input_mutex);
-
-	data = tracecmd_read_at(kshark_ctx->handle, entry->offset, NULL);
-	lat = get_latency(kshark_ctx->pevent, data);
-	free_record(data);
-
-	pthread_mutex_unlock(&kshark_ctx->input_mutex);
-
-	return lat;
-}
-
-/**
- * @brief This function allows for an easy access to the original value of the
- *	  Event Id as recorded in the tep_record object. The record is read
- *	  from the file only in the case of an entry being touched by a plugin.
- *	  Be aware that using the kshark_get_X_easy functions can be
- *	  inefficient if you need an access to more than one of the data fields
- *	  of the record.
- *
- * @param entry: Input location for the KernelShark entry.
- *
- * @returns The original value of the Event Id as recorded in the
- *	    tep_record object on success, otherwise negative error code.
- */
-int kshark_get_event_id_easy(struct kshark_entry *entry)
-{
-	struct kshark_context *kshark_ctx = NULL;
-	struct tep_record *data;
-	int event_id;
-
-	if (!kshark_instance(&kshark_ctx))
-		return -ENODEV;
-
-	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {
-		event_id = entry->event_id;
-	} else {
-		/*
-		 * The entry has been touched by a plugin callback function.
-		 * Because of this we do not trust the value of
-		 * "entry->event_id".
-		 *
-		 * Currently the data reading operations are not thread-safe.
-		 * Use a mutex to protect the access.
-		 */
-		pthread_mutex_lock(&kshark_ctx->input_mutex);
-
-		data = tracecmd_read_at(kshark_ctx->handle, entry->offset,
-					NULL);
-		event_id = tep_data_type(kshark_ctx->pevent, data);
-		free_record(data);
-
-		pthread_mutex_unlock(&kshark_ctx->input_mutex);
-	}
-
-	return (event_id == -1)? -EFAULT : event_id;
-}
-
-/**
- * @brief This function allows for an easy access to the original name of the
- *	  trace event as recorded in the tep_record object. The record is read
- *	  from the file only in the case of an entry being touched by a plugin.
- *	  Be aware that using the kshark_get_X_easy functions can be
- *	  inefficient if you need an access to more than one of the data fields
- *	  of the record.
- *
- * @param entry: Input location for the KernelShark entry.
- *
- * @returns The mane of the trace event recorded in the tep_record object on
- *	    success, otherwise "[UNKNOWN EVENT]" or NULL.
- */
-const char *kshark_get_event_name_easy(struct kshark_entry *entry)
-{
-	struct kshark_context *kshark_ctx = NULL;
-	struct tep_event *event;
-
-	int event_id = kshark_get_event_id_easy(entry);
-	if (event_id == -EFAULT)
-		return NULL;
-
-	kshark_instance(&kshark_ctx);
-
-	if (event_id < 0) {
-		switch (event_id) {
-		case KS_EVENT_OVERFLOW:
-			return missed_events_dump(kshark_ctx, entry, false);
-		default:
-			return NULL;
-		}
-	}
-
-	/*
-	 * Currently the data reading operations are not thread-safe.
-	 * Use a mutex to protect the access.
-	 */
-	pthread_mutex_lock(&kshark_ctx->input_mutex);
-	event = tep_find_event(kshark_ctx->pevent, event_id);
-	pthread_mutex_unlock(&kshark_ctx->input_mutex);
-
-	if (event)
-		return event->name;
-
-	return "[UNKNOWN EVENT]";
-}
-
-/**
- * @brief This function allows for an easy access to the tep_record's info
- *	  streang. The record is read from the file using the offset field of
- *	  kshark_entry. Be aware that using the kshark_get_X_easy functions can
- *	  be inefficient if you need an access to more than one of the data
- *	  fields of the record.
- *
- * @param entry: Input location for the KernelShark entry.
- *
- * @returns A string showing the data output of the trace event on success,
- *	    otherwise NULL.
- */
-const char *kshark_get_info_easy(struct kshark_entry *entry)
-{
-	struct kshark_context *kshark_ctx = NULL;
-	struct tep_event *event;
-	struct tep_record *data;
-	const char *info = NULL;
-	int event_id;
-
-	if (!kshark_instance(&kshark_ctx))
-		return NULL;
-
-	if (entry->event_id < 0) {
-		switch (entry->event_id) {
-		case KS_EVENT_OVERFLOW:
-			return missed_events_dump(kshark_ctx, entry, true);
-		default:
-			return NULL;
-		}
-	}
-
-	/*
-	 * Currently the data reading operations are not thread-safe.
-	 * Use a mutex to protect the access.
-	 */
-	pthread_mutex_lock(&kshark_ctx->input_mutex);
-
-	data = tracecmd_read_at(kshark_ctx->handle, entry->offset, NULL);
-	event_id = tep_data_type(kshark_ctx->pevent, data);
-	event = tep_find_event(kshark_ctx->pevent, event_id);
-	if (event)
-		info = get_info(kshark_ctx->pevent, data, event);
-
-	free_record(data);
-
-	pthread_mutex_unlock(&kshark_ctx->input_mutex);
-
-	return info;
-}
-
 /**
  * @brief Convert the timestamp of the trace record (nanosecond precision) into
  *	  seconds and microseconds.
@@ -2044,44 +1306,6 @@ void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec)
 	*usec = (time - s * 1000000000ULL) / 1000;
 }
 
-/**
- * @brief Dump into a string the content a custom entry. The function allocates
- *	  a null terminated string and returns a pointer to this string.
- *
- * @param kshark_ctx: Input location for the session context pointer.
- * @param entry: A Kernel Shark entry to be printed.
- * @param info_func:
- *
- * @returns The returned string contains a semicolon-separated list of data
- *	    fields. The user has to free the returned string.
- */
-char* kshark_dump_custom_entry(struct kshark_context *kshark_ctx,
-			       const struct kshark_entry *entry,
-			       kshark_custom_info_func info_func)
-{
-	const char *event_name, *task, *info;
-	char *entry_str;
-	int size = 0;
-
-	task = tep_data_comm_from_pid(kshark_ctx->pevent, entry->pid);
-	event_name = info_func(kshark_ctx, entry, false);
-	info = info_func(kshark_ctx, entry, true);
-
-	size = asprintf(&entry_str, "%" PRIu64 "; %s-%i; CPU %i; ; %s; %s",
-			entry->ts,
-			task,
-			entry->pid,
-			entry->cpu,
-			event_name,
-			info);
-
-	if (size > 0)
-		return entry_str;
-
-	return NULL;
-}
-
-
 /**
  * @brief Binary search inside a time-sorted array of kshark_entries.
  *
@@ -2118,42 +1342,6 @@ ssize_t kshark_find_entry_by_time(uint64_t time,
 	return h;
 }
 
-/**
- * @brief Binary search inside a time-sorted array of tep_records.
- *
- * @param time: The value of time to search for.
- * @param data: Input location for the trace data.
- * @param l: Array index specifying the lower edge of the range to search in.
- * @param h: Array index specifying the upper edge of the range to search in.
- *
- * @returns On success, the first tep_record inside the range, having a
-	    timestamp equal or bigger than "time".
-	    If all entries inside the range have timestamps greater than "time"
-	    the function returns BSEARCH_ALL_GREATER (negative value).
-	    If all entries inside the range have timestamps smaller than "time"
-	    the function returns BSEARCH_ALL_SMALLER (negative value).
- */
-ssize_t kshark_find_record_by_time(uint64_t time,
-				   struct tep_record **data,
-				   size_t l, size_t h)
-{
-	size_t mid;
-
-	if (data[l]->ts > time)
-		return BSEARCH_ALL_GREATER;
-
-	if (data[h]->ts < time)
-		return BSEARCH_ALL_SMALLER;
-
-	/*
-	 * After executing the BSEARCH macro, "l" will be the index of the last
-	 * record having timestamp < time and "h" will be the index of the
-	 * first record having timestamp >= time.
-	 */
-	BSEARCH(h, l, data[mid]->ts < time);
-	return h;
-}
-
 /**
  * @brief Simple Pid matching function to be user for data requests.
  *
diff --git a/src/libkshark.h b/src/libkshark.h
index 523bdb6a..835be967 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -6,7 +6,7 @@
 
  /**
  *  @file    libkshark.h
- *  @brief   API for processing of FTRACE (trace-cmd) data.
+ *  @brief   API for processing of tracing data.
  */
 
 #ifndef _LIB_KSHARK_H
@@ -27,8 +27,6 @@ extern "C" {
 // trace-cmd
 #include "trace-cmd/trace-cmd.h"
 #include "trace-cmd/trace-filter-hash.h"
-#include "traceevent/event-parse.h"
-#include "tracefs/tracefs.h"
 
 // KernelShark
 #include "libkshark-plugin.h"
@@ -345,19 +343,6 @@ static inline char *kshark_set_data_format(char *dest_format,
 /** Hard-coded default number of data streams available at initialization. */
 #define KS_DEFAULT_NUM_STREAMS	256
 
-/** Size of the task's hash table. */
-#define KS_TASK_HASH_SHIFT 16
-#define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
-
-/** Linked list of tasks. */
-struct kshark_task_list {
-	/** Pointer to the next task's PID. */
-	struct kshark_task_list	*next;
-
-	/** PID of a task. */
-	int			 pid;
-};
-
 /**
  * Structure representing the parameters of the stream descriptor array owned
  * by the kshark session.
@@ -384,15 +369,6 @@ struct kshark_context {
 	/** Parameters of the stream descriptor array. */
 	struct kshark_stream_array_descriptor	stream_info;
 
-	/** Input handle for the trace data file. */
-	struct tracecmd_input	*handle;
-
-	/** Page event used to parse the page. */
-	struct tep_handle	*pevent;
-
-	/** Hash table of task PIDs. */
-	struct kshark_task_list	*tasks[KS_TASK_HASH_SIZE];
-
 	/** A mutex, used to protect the access to the input file. */
 	pthread_mutex_t		input_mutex;
 
@@ -455,12 +431,6 @@ kshark_get_stream_from_entry(const struct kshark_entry *entry);
 
 int *kshark_all_streams(struct kshark_context *kshark_ctx);
 
-ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
-				 struct kshark_entry ***data_rows);
-
-ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
-				 struct tep_record ***data_rows);
-
 ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int sd,
 			     int **pids);
 
@@ -474,18 +444,6 @@ char *kshark_comm_from_pid(int sd, int pid);
 
 char *kshark_event_from_id(int sd, int event_id);
 
-int kshark_get_pid_easy(struct kshark_entry *entry);
-
-const char *kshark_get_task_easy(struct kshark_entry *entry);
-
-const char *kshark_get_latency_easy(struct kshark_entry *entry);
-
-int kshark_get_event_id_easy(struct kshark_entry *entry);
-
-const char *kshark_get_event_name_easy(struct kshark_entry *entry);
-
-const char *kshark_get_info_easy(struct kshark_entry *entry);
-
 void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec);
 
 char* kshark_dump_entry(const struct kshark_entry *entry);
@@ -532,18 +490,6 @@ ssize_t kshark_load_matrix(struct kshark_context *kshark_ctx, int sd,
 			   int64_t **offset_array,
 			   int64_t **ts_array);
 
-/**
- * Custom entry info function type. To be user for dumping info for custom
- * KernelShark entryes.
- */
-typedef const char *(kshark_custom_info_func)(struct kshark_context *,
-					      const struct kshark_entry *,
-					      bool);
-
-char* kshark_dump_custom_entry(struct kshark_context *kshark_ctx,
-			       const struct kshark_entry *entry,
-			       kshark_custom_info_func info_func);
-
 /** Bit masks used to control the visibility of the entry after filtering. */
 enum kshark_filter_masks {
 	/**
@@ -666,10 +612,6 @@ ssize_t kshark_find_entry_by_time(uint64_t time,
 				  struct kshark_entry **data_rows,
 				  size_t l, size_t h);
 
-ssize_t kshark_find_record_by_time(uint64_t time,
-				   struct tep_record **data_rows,
-				   size_t l, size_t h);
-
 bool kshark_match_pid(struct kshark_context *kshark_ctx,
 		      struct kshark_entry *e, int pid);
 
@@ -954,16 +896,6 @@ bool kshark_export_adv_filters(struct kshark_context *kshark_ctx,
 bool kshark_import_adv_filters(struct kshark_context *kshark_ctx,
 			       struct kshark_config_doc *conf);
 
-bool kshark_export_event_filter(struct tep_handle *pevent,
-				struct tracecmd_filter_id *filter,
-				const char *filter_name,
-				struct kshark_config_doc *conf);
-
-int kshark_import_event_filter(struct tep_handle *pevent,
-			       struct tracecmd_filter_id *filter,
-			       const char *filter_name,
-			       struct kshark_config_doc *conf);
-
 bool kshark_export_user_mask(struct kshark_context *kshark_ctx,
 			     struct kshark_config_doc **conf);
 
-- 
2.25.1

