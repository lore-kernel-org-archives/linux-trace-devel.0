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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D160C63777
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6C7122227
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D5L7xKYi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgKTJnd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbgKTJnc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 04:43:32 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117D9C0617A7
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:31 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id t11so8813145edj.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ejlaEm8XOpJPlKqDg8p1uDEpDWGwOXxKnVgOHl3rjiY=;
        b=D5L7xKYiNPS4MOPCXnVNo5auQ0tNDOlv9wiCdvVVxzCas08mjLGRY8yblSjsCgRn3/
         guNUIJGObawiXBhmAzYzYff0RJ1yj9iIPn67868qjTMfi1ArPmgf8eReO70i6/0rJhqt
         pI6maNsrLHZXb/DxeB+Nj84pvcEcAmflquZbNP3UxTjaND96plhz9MWIgc/VIlDL9myN
         JSV131xqrXUocCGk80E5+AWwykNMRQubx1btfBWyOLvgeaybSFF/zSOOnQwXjrx/hwEB
         5KlPGYgu0IYOvutP6bgOJBG3BUdLJPERi1JsfX/aPwVbYI+0Sx5oVwTH78qLT/Sphfff
         Hjvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ejlaEm8XOpJPlKqDg8p1uDEpDWGwOXxKnVgOHl3rjiY=;
        b=A5poqYQuGmqr8YabvpZ5QO/WY6nvaZ4v+623eBXVocPsQevU7/ZTxK/UcamVC5jppp
         0mrWK2M4egHIQ5iiD8eZWYZQ9ACPkhHnIVlyQH8oPFPq8Cox04aVrQGGuussbSoysnS0
         KcHmjDPgsJ3adtUu9IrWWMngzdBfb1Z3n4eRnotKf3gnHrVkclH51MVYee0CHmASD/Qa
         Q5pH3GhFwQ6Y09d6GFoOqJRGdDhRcABmLg/uIIoRnc8ReyP8oQujWbr4auuJFeYwYhdp
         A9gfOKgRQhaow1SeE7fgbD0C+7iuksru0Tl4M/UcWHzQcadu7elFmXGVmcu6BOxtboYH
         hKcg==
X-Gm-Message-State: AOAM533TJ5h2twZh2W+ParLJUWKNV1pcfSfmq7JoGnfWSIv7gi/r/eui
        DazI0SrTT5km/U2/q72Zm5k=
X-Google-Smtp-Source: ABdhPJx0i6A4V5BOnY5XG0pnDPU6OOOXHS3EhE3UhoWpdkSFyPnf96IUox0cNw0z7CPMTTZFPBMLDQ==
X-Received: by 2002:aa7:c889:: with SMTP id p9mr33653035eds.110.1605865409786;
        Fri, 20 Nov 2020 01:43:29 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id h2sm897006ejx.55.2020.11.20.01.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:43:29 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 07/20] kernel-shark: Housekeeping before implementing stream interface
Date:   Fri, 20 Nov 2020 11:42:51 +0200
Message-Id: <20201120094304.271502-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120094304.271502-1-y.karadz@gmail.com>
References: <20201120094304.271502-1-y.karadz@gmail.com>
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
index e8d35071..9cd6afb1 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -1190,21 +1190,6 @@ bool kshark_filter_is_set(struct kshark_context *kshark_ctx)
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
@@ -1680,11 +1665,25 @@ static inline void free_ptr(void *ptr)
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
@@ -1731,88 +1730,6 @@ static bool data_matrix_alloc(size_t n_rows, uint64_t **offset_array,
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

