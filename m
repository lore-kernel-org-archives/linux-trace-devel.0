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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8120FC2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B28222249
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dWOUA54x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgKLOY0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 09:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbgKLOYZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 09:24:25 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFDAC0613D1
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:25 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id j7so6205855wrp.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6VPFTlAE5gRE/aVfbk9JahDg0/13QdDh19YwZJ+4/5U=;
        b=dWOUA54xXFv4tBEf7fu6zQ7AukuZVkg9NbHXZcl0n0EJJq+A+FSHlmXMBvmXfqe9Ze
         mhvTCZpej7vvYDCGO0I+9Wnk/eeSa0ifMdcVSVKCP64nu0stV82z4h9o+cITYBsRdrjG
         b1DeYw6Dfk80R7mnNMrEP/6ELLkILeGAPFthZ5fga6Qve75oKL2XKv79iUZ/yKvCkZzr
         xCSky0tt3/SmTB3aTcaNvzFkVf7vCX/7eLnSrnX+MWKrZnfIHh89wf/QKUHtlfL6uYMg
         WFa9NKk6uIu5wj1/GTch0xckW2ik4v+z8D1NMWNoZbePO9dZKvdCK6tBa5zmGjmDzQGU
         vMbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6VPFTlAE5gRE/aVfbk9JahDg0/13QdDh19YwZJ+4/5U=;
        b=C4+lF/lh8vaN6s05n26ZnDgRYk4ZkoYiskSTeOQgGKam2fR7dDXl+qIQV5PlENxgAv
         sIm6EkzPu6VdfQpZVLqpsZEyBXOKt/CaIqmmiQMK8Pc+RifDnicxiqZbgU2+yYOKWtlE
         tOFwQygcB5y9ddG8td0nW++n227Rzlh7isEwzd7j93GbkIyidpdcdadEOpgRS/gDLtfQ
         wpZDa6W/3WRvGdAQi0HQx7ME510P1AmvfVqtp4XTDzu/S1Kg725MCBdEHYdEO72EjPh6
         jrlbZG0f+pqN9Zqx6pspcOPFSHD+eCyeZNwY+JNYk0i2Yh9+Z+6/THKYtzCS+y9G7BQs
         xutw==
X-Gm-Message-State: AOAM530H7TaLtRUFBfn6i3sjNABNx5jYOYXxOG7wvPltGF4m57ETDaBG
        Em+Sr1rXqhu6oLr/JKdPQV4=
X-Google-Smtp-Source: ABdhPJzNVW/3x9ffV35Jp2nNOqYiqVoxGyxED+iBY+3jEC4PShXQAX4vL+4mHIYRhaSfgdUhsQ+Fhg==
X-Received: by 2002:a5d:654b:: with SMTP id z11mr33905889wrv.291.1605191064002;
        Thu, 12 Nov 2020 06:24:24 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id h15sm6950685wrw.15.2020.11.12.06.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 06:24:23 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 07/20] kernel-shark: Housekeeping before implementing stream interface
Date:   Thu, 12 Nov 2020 16:23:45 +0200
Message-Id: <20201112142358.36821-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112142358.36821-1-y.karadz@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

kshark_load data_matrix() is a method that is used only in trace-cruncher
prototype. The version of this function that is currently part of the API
is anyway not compatible with the latest version of trace-cruncher because
of the mismatch of the argument types, so we can directly remove the
existing implementation. An equivalent functionality will be provided as
part of the implantation of the Data stream interface in the following
patch. Here we just make kshark_data_matrix_alloc() and
unset_event_filter_flag() public, because the methods will be used in the
stream interface implementation.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.c | 121 ++++++++----------------------------------------
 src/libkshark.h |  28 ++++++++---
 2 files changed, 40 insertions(+), 109 deletions(-)

diff --git a/src/libkshark.c b/src/libkshark.c
index f3ad5be6..45e599c6 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -1174,21 +1174,6 @@ bool kshark_filter_is_set(struct kshark_context *kshark_ctx)
 -              kshark_this_filter_is_set(kshark_ctx->hide_event_filter);
 }
 
-static inline void unset_event_filter_flag(struct kshark_context *kshark_ctx,
-					   struct kshark_entry *e)
-{
-	/*
-	 * All entries, filtered-out by the event filters, will be treated
-	 * differently, when visualized. Because of this, ignore the value
-	 * of the GRAPH_VIEW flag provided by the user via
-	 * kshark_ctx->filter_mask. The value of the EVENT_VIEW flag in
-	 * kshark_ctx->filter_mask will be used instead.
-	 */
-	int event_mask = kshark_ctx->filter_mask & ~KS_GRAPH_VIEW_FILTER_MASK;
-
-	e->visible &= ~event_mask;
-}
-
 static void set_all_visible(uint16_t *v) {
 	/*  Keep the original value of the PLUGIN_UNTOUCHED bit flag. */
 	*v |= 0xFF & ~KS_PLUGIN_UNTOUCHED_MASK;
@@ -1664,11 +1649,25 @@ static inline void free_ptr(void *ptr)
 		free(*(void **)ptr);
 }
 
-static bool data_matrix_alloc(size_t n_rows, uint64_t **offset_array,
-					     uint16_t **cpu_array,
-					     uint64_t **ts_array,
-					     uint16_t **pid_array,
-					     int **event_array)
+/**
+ * @brief Allocate data arrays (matrix columns) to be used to load the tracing
+ *	  data into a data matrix form.
+ *
+ * @param n_rows: Number matrix rows to be allocated. Must be equal to the
+ *	 	  number of trace records.
+ * @param cpu_array: Output location for the CPU Id column.
+ * @param pid_array: Output location for the PID column.
+ * @param event_array: Output location for the Event Id column.
+ * @param offset_array: Output location for the record offset column.
+ * @param ts_array: Output location for the timestamp column.
+ *
+ * @returns True on success. Else false.
+ */
+bool kshark_data_matrix_alloc(size_t n_rows, int16_t **event_array,
+					     int16_t **cpu_array,
+					     int32_t **pid_array,
+					     int64_t **offset_array,
+					     int64_t **ts_array)
 {
 	if (offset_array) {
 		*offset_array = calloc(n_rows, sizeof(**offset_array));
@@ -1715,88 +1714,6 @@ static bool data_matrix_alloc(size_t n_rows, uint64_t **offset_array,
 	return false;
 }
 
-/**
- * @brief Load the content of the trace data file into a table / matrix made
- *	  of columns / arrays of data. The user is responsible for freeing the
- *	  elements of the outputted array
- *
- * @param kshark_ctx: Input location for the session context pointer.
- * @param offset_array: Output location for the array of record offsets.
- * @param cpu_array: Output location for the array of CPU Ids.
- * @param ts_array: Output location for the array of timestamps.
- * @param pid_array: Output location for the array of Process Ids.
- * @param event_array: Output location for the array of Event Ids.
- *
- * @returns The size of the outputted arrays in the case of success, or a
- *	    negative error code on failure.
- */
-size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
-			       uint64_t **offset_array,
-			       uint16_t **cpu_array,
-			       uint64_t **ts_array,
-			       uint16_t **pid_array,
-			       int **event_array)
-{
-	enum rec_type type = REC_ENTRY;
-	struct rec_list **rec_list;
-	ssize_t count, total = 0;
-	bool status;
-	int n_cpus;
-
-	total = get_records(kshark_ctx, &rec_list, type);
-	if (total < 0)
-		goto fail;
-
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
-
-	status = data_matrix_alloc(total, offset_array,
-					  cpu_array,
-					  ts_array,
-					  pid_array,
-					  event_array);
-	if (!status)
-		goto fail_free;
-
-	for (count = 0; count < total; count++) {
-		int next_cpu;
-
-		next_cpu = pick_next_cpu(rec_list, n_cpus, type);
-		if (next_cpu >= 0) {
-			struct rec_list *rec = rec_list[next_cpu];
-			struct kshark_entry *e = &rec->entry;
-
-			if (offset_array)
-				(*offset_array)[count] = e->offset;
-
-			if (cpu_array)
-				(*cpu_array)[count] = e->cpu;
-
-			if (ts_array)
-				(*ts_array)[count] = e->ts;
-
-			if (pid_array)
-				(*pid_array)[count] = e->pid;
-
-			if (event_array)
-				(*event_array)[count] = e->event_id;
-
-			rec_list[next_cpu] = rec_list[next_cpu]->next;
-			free(rec);
-		}
-	}
-
-	/* There should be no entries left in rec_list. */
-	free_rec_list(rec_list, n_cpus, type);
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
 static const char *get_latency(struct tep_handle *pe,
 			       struct tep_record *record)
 {
diff --git a/src/libkshark.h b/src/libkshark.h
index 6dce4bae..508df2e2 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -454,13 +454,6 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 				 struct tep_record ***data_rows);
 
-size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
-			       uint64_t **offset_array,
-			       uint16_t **cpu_array,
-			       uint64_t **ts_array,
-			       uint16_t **pid_array,
-			       int **event_array);
-
 ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids);
 
 void kshark_close(struct kshark_context *kshark_ctx);
@@ -615,6 +608,21 @@ bool kshark_this_filter_is_set(struct tracecmd_filter_id *filter);
 
 bool kshark_filter_is_set(struct kshark_context *kshark_ctx);
 
+static inline void unset_event_filter_flag(struct kshark_context *kshark_ctx,
+					   struct kshark_entry *e)
+{
+	/*
+	 * All entries, filtered-out by the event filters, will be treated
+	 * differently, when visualized. Because of this, ignore the value
+	 * of the GRAPH_VIEW flag provided by the user via
+	 * stream->filter_mask. The value of the EVENT_VIEW flag in
+	 * stream->filter_mask will be used instead.
+	 */
+	int event_mask = kshark_ctx->filter_mask & ~KS_GRAPH_VIEW_FILTER_MASK;
+
+	e->visible &= ~event_mask;
+}
+
 void kshark_filter_entries(struct kshark_context *kshark_ctx,
 			   struct kshark_entry **data,
 			   size_t n_entries);
@@ -993,6 +1001,12 @@ struct kshark_config_doc *kshark_open_config_file(const char *file_name,
 
 struct kshark_config_doc *kshark_json_to_conf(struct json_object *jobj);
 
+bool kshark_data_matrix_alloc(size_t n_rows, int16_t **event_array,
+					     int16_t **cpu_array,
+					     int32_t **pid_array,
+					     int64_t **offset_array,
+					     int64_t **ts_array);
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.25.1

