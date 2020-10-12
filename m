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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D088CC433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 658FF2074D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:04:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ucXP910q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390874AbgJLOD6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 10:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730520AbgJLNgb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 09:36:31 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7627BC0613D2
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:28 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id e18so19213248wrw.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eVMccU+LWENSynKb+x3Hkzr8j4uPK2gAme6zDwP6Sus=;
        b=ucXP910qRAvzX5zBZRaaPG37IOdXNlz/3xWUrIkWbsUN82L9rb4wwMU+UVepaubCma
         tJHm1Men2rvLRozGoCnbKj+/41QJ1HgWKtVLtjDYaTRY5EcLvRV8Tg21NQam6/dObHyD
         0XVhC4ihRwH0gQZKRyPh/Xo39KtbqeBccIGKsdVR9ZFJZaA2TgNEFRQ5bkNk0riGA93z
         5rTMOkm6qod7RJSz7cFeUmv7tVqvDP/r/HjVc7/iZ+5x4hueN9Q8RLElD9rIHk82YEJJ
         bdrwWeqgRMMRvp5EUG2ZpLsjCPRXhpkK7a8Jj6o9Cq2g6pN3dO38oR5M197gqWgXdzT/
         4g6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eVMccU+LWENSynKb+x3Hkzr8j4uPK2gAme6zDwP6Sus=;
        b=cLKiqSqPvS80TRBrNnnFU1U5ySYuOP7dSfmmuZjGo1LMkv5F/KXfOTDzP8BPDK+cfH
         49UnZYtln+hO3zX4X3jDCvbA0CcZp6bqofnZiPEmx4zScZc/6Dvq45SIpXNiKpKrbE3O
         p/4CoJdzLQ0ZxkKBuG8ZYIcmWMpABtdiQW7mqEgyW//M4wEElKcXxN9NYMthSqC5Nae4
         3wuaHuKVhpTdhy04VkFDaN32aAg+kLH89IovJtE9A3hDGRaGN5T62OTlClDliF/fpSaO
         ZO0h77e3DqxskWWY6Y2Fq1iOnfUwGqYOBkqpZt28u+kxdys9iS+lPb6VTkNpfpyJPVla
         r15Q==
X-Gm-Message-State: AOAM533OKGncsGxjys/5hfaA7XRyuoBc1cF0AqXOb6Ku1nchofEofYcr
        +Wlkdj4W/oJ8iFZTqUBzUG8=
X-Google-Smtp-Source: ABdhPJxs6v+Ag5Hr6DQ3GA5gAFIocDZIPcsxZ4LT1B73f6RG9bP0vhq9du6flNx9UOrdDXeDTXYVzg==
X-Received: by 2002:a5d:5092:: with SMTP id a18mr26327114wrt.323.1602509786843;
        Mon, 12 Oct 2020 06:36:26 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id k5sm23145388wmb.19.2020.10.12.06.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:36:26 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 11/20] kernel-shark: Remove dead code
Date:   Mon, 12 Oct 2020 16:35:14 +0300
Message-Id: <20201012133523.469040-12-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012133523.469040-1-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Clean up the old readout code that is no longer used after switching
to the implementation provided by the Data stream interface.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.c | 807 +-----------------------------------------------
 src/libkshark.h |  77 +----
 2 files changed, 2 insertions(+), 882 deletions(-)

diff --git a/src/libkshark.c b/src/libkshark.c
index 6eff53e5..e363395a 100644
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
@@ -62,14 +60,6 @@ static bool kshark_default_context(struct kshark_context **context)
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
@@ -106,9 +96,6 @@ bool kshark_instance(struct kshark_context **kshark_ctx)
 		}
 	}
 
-	if (!init_thread_seq())
-		return false;
-
 	return true;
 }
 
@@ -487,42 +474,6 @@ char *kshark_event_from_id(int sd, int event_id)
 	return stream->interface.get_event_name(stream, &e);
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
@@ -751,400 +702,6 @@ void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
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
@@ -1216,294 +773,6 @@ bool kshark_data_matrix_alloc(size_t n_rows, int16_t **cpu_array,
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
@@ -1520,44 +789,6 @@ void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec)
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
@@ -1594,42 +825,6 @@ ssize_t kshark_find_entry_by_time(uint64_t time,
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
index ef48d94b..54c71a77 100644
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
@@ -325,19 +323,6 @@ struct kshark_data_stream {
 /** Hard-coded maximum number of data stream. */
 #define KS_MAX_NUM_STREAMS	127
 
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
 /** Structure representing a kshark session. */
 struct kshark_context {
 	/** Array of data stream descriptors. */
@@ -346,15 +331,6 @@ struct kshark_context {
 	/** The number of data streams. */
 	int				n_streams;
 
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
 
@@ -415,19 +391,6 @@ kshark_get_stream_from_entry(const struct kshark_entry *entry);
 
 int *kshark_all_streams(struct kshark_context *kshark_ctx);
 
-ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
-				 struct kshark_entry ***data_rows);
-
-ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
-				 struct tep_record ***data_rows);
-
-size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
-			       uint64_t **offset_array,
-			       uint16_t **cpu_array,
-			       uint64_t **ts_array,
-			       uint16_t **pid_array,
-			       int **event_array);
-
 ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int sd,
 			     int **pids);
 
@@ -441,18 +404,6 @@ char *kshark_comm_from_pid(int sd, int pid);
 
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
 
 static inline int kshark_get_pid(const struct kshark_entry *entry)
@@ -617,18 +568,6 @@ static inline ssize_t kshark_load_matrix(struct kshark_context *kshark_ctx,
 								 ts_array);
 }
 
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
@@ -751,10 +690,6 @@ ssize_t kshark_find_entry_by_time(uint64_t time,
 				  struct kshark_entry **data_rows,
 				  size_t l, size_t h);
 
-ssize_t kshark_find_record_by_time(uint64_t time,
-				   struct tep_record **data_rows,
-				   size_t l, size_t h);
-
 bool kshark_match_pid(struct kshark_context *kshark_ctx,
 		      struct kshark_entry *e, int pid);
 
@@ -1039,16 +974,6 @@ bool kshark_export_adv_filters(struct kshark_context *kshark_ctx,
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

