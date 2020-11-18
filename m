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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E590C6369E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29A60246EB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:50:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZLzRaCs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgKROuf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 09:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbgKROue (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 09:50:34 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85319C0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:33 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id w24so2985977wmi.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NA2IAISgF322fgCOTHISjipcSXCm0neMpG9DP6i70vw=;
        b=CZLzRaCsa0bpeoUu4XL99SDThpu1FICF57OjQkIbNKW16iG0RGrQEuDR9CJoNQTNY2
         nwMUErN3gENQHHrU9Te5obSuf9Vmc+xOMZjMK0q9cLqo2ep43D3/yJDb7+n+t3/BgFGd
         UXGZkO8hkFhjdUnTZBm2zs/kgB+w9fyUmUmKsBTcXT4ZQvB5l+kNxhmW0lxgFGCRSJD4
         KtcQuMab0Q0At1tVk7SV5AzM0J2WC+0rAKpaXBjK9e9o6bDz5tF0IFBWOwo67w53HAi5
         HmFKJXCUeEf265B+OG5jwg5ziVUnrU636OTAMwHPHduCt1D5U9tfr1YMmifoJZSBScTX
         nxbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NA2IAISgF322fgCOTHISjipcSXCm0neMpG9DP6i70vw=;
        b=UBBRNyD2BP3rr3FCoZb03IypT5z6iRDcHkWZckEKtACymOWTQSVVLsSOJv+CmYim6W
         BERBGn4/HNsQIvofOSUVxcmn+eGUs96lX/bwYxC6O6Yen+W/LpKphIUNgs3LK+AiYvw3
         F3oUT4Im0YwrR6A3LbvUfHhbQqzTx8wOnJHA1FeuqEY+vAXzuIZ4Za+R8s4QAy2tsr/9
         31D55sacD1ZAtzfwbpzt77UvGY37DF/7xwbmiTgX5XssKp4/GXnVIVmOeYrh8rB2rgK2
         p8ODzL2R0HCODgxGGQhX5CYpC9+OsUI+QEaaG+ilCQjbTq87QWV7pzfboZearMpxLIGl
         Ny8w==
X-Gm-Message-State: AOAM531AlWMfYfvPo2wr6HB7JrET7h31/+xrsHSjmlHcR/kx0QUWXZFD
        1KcrHHKQ7n7yL3agXaMCyIc=
X-Google-Smtp-Source: ABdhPJxhvjdq0eEENzdooVQuI4CABlUKoGXFKfhOsuTSuBDQENbteMCx60E6KVJlLPBVNCZeGWXs6g==
X-Received: by 2002:a1c:2bc3:: with SMTP id r186mr355660wmr.163.1605711032252;
        Wed, 18 Nov 2020 06:50:32 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id s202sm3926190wme.39.2020.11.18.06.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 06:50:31 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 07/20] kernel-shark: Housekeeping before implementing stream interface
Date:   Wed, 18 Nov 2020 16:49:50 +0200
Message-Id: <20201118145003.156542-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201118145003.156542-1-y.karadz@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
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
index 39081993..422fb7d4 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -1189,21 +1189,6 @@ bool kshark_filter_is_set(struct kshark_context *kshark_ctx)
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
@@ -1679,11 +1664,25 @@ static inline void free_ptr(void *ptr)
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
@@ -1730,88 +1729,6 @@ static bool data_matrix_alloc(size_t n_rows, uint64_t **offset_array,
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
index 77fa4c54..36d60001 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -456,13 +456,6 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
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
@@ -617,6 +610,21 @@ bool kshark_this_filter_is_set(struct tracecmd_filter_id *filter);
 
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
@@ -995,6 +1003,12 @@ struct kshark_config_doc *kshark_open_config_file(const char *file_name,
 
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

