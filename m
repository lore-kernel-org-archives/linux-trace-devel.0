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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2167C43457
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 13:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CCE421D7F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 13:36:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c7/YIsCZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730566AbgJLNgd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 09:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388681AbgJLNgT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 09:36:19 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCFBC0613D2
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:18 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k18so17573229wmj.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vakxz4aqkl2nG75Bky/OE4taqN34RSdtokMEO/n9Hgg=;
        b=c7/YIsCZbL81SX1dSXZ21/jx47Pc2STm8dnT6N6XRVh9hRHe1MYPnpEkXMZw5TGiiZ
         ehhZht023dEcOLtk1vskfccEpac9BsJVaXk/YMrj/CKdrfvphKVCw6rCt/QPd4FJZChX
         lFeEbqvHOyHsKqak+ZH1czIHfjarNR1Nj/kgSPrlzPw+mspdIrLt8pPodIHk9DgqmPqp
         aSUJhi1DmWN+fR0B3VWYRWx3xnbF0z3txFCt8tIiPU/9s6OHu7RdxOT3Vx0ZKjEIvLPZ
         Fx4Nn23RMVU9nhCzo9ALjlRoMC39lmlnAgrXVncPX9FE9ns2Ud3kOiFMmVpKQ4qpmIRw
         OAxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vakxz4aqkl2nG75Bky/OE4taqN34RSdtokMEO/n9Hgg=;
        b=QJtPRPlTQ8WoDc+AQp0rRUgbrn2t6hCt4i0vCf7uJutxA9NP1JcW4kIPzE/OZY4KTc
         2lA+tAYMDN3QE+oq3hB7akRHxhqhRRwof7tBScjIm3wP15/tTSHD/+NdT9oKOM19ISBS
         oVsKyhEB/sWd9ZXCizdYePxT2IkvUVIJNsGqhAxUlbXadOeAwYDDpBG9ToMyfDu6tFJ2
         OCB4YfyCsGkysBSNi7GchGeJ1IIy38ECPF971MmT+B5i+losh1mUzIDq8ZsS4PGqr6CV
         L0v/eLHMzNa7eTk7G8FiNS4dIT9QPoPTwf+ADSikiEZ2IK3Ohrx/CWx5LbUKSRML5uB2
         FyIQ==
X-Gm-Message-State: AOAM5306eVDxV4A38OG5zaELIg37MBEZAQ+zWxCQYtclVnZv5xCS1nCs
        1PKDcpc5UeIj7x4+2WL2MHk=
X-Google-Smtp-Source: ABdhPJxfAgmpRRjuLFDm9IIWz/nTedOdqcW0S/TeB0fndLRBliBLMagY2l+9pIJch04BWqQxf1mXvw==
X-Received: by 2002:a1c:4904:: with SMTP id w4mr10300534wma.99.1602509777566;
        Mon, 12 Oct 2020 06:36:17 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id k5sm23145388wmb.19.2020.10.12.06.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:36:17 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 08/20] kernel-shark: Housekeeping before implementing stream interface
Date:   Mon, 12 Oct 2020 16:35:11 +0300
Message-Id: <20201012133523.469040-9-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012133523.469040-1-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
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
 src/libkshark.h |  21 +++++++++
 2 files changed, 40 insertions(+), 102 deletions(-)

diff --git a/src/libkshark.c b/src/libkshark.c
index ffeb66a7..56721717 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -671,21 +671,6 @@ bool kshark_filter_is_set(struct kshark_context *kshark_ctx)
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
 static void set_all_visible(uint8_t *v) {
 	/*  Keep the original value of the PLUGIN_UNTOUCHED bit flag. */
 	*v |= 0xFF & ~KS_PLUGIN_UNTOUCHED_MASK;
@@ -1161,11 +1146,25 @@ static inline void free_ptr(void *ptr)
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
+bool kshark_data_matrix_alloc(size_t n_rows, int16_t **cpu_array,
+					     int32_t **pid_array,
+					     int32_t **event_array,
+					     int64_t **offset_array,
+					     int64_t **ts_array)
 {
 	if (offset_array) {
 		*offset_array = calloc(n_rows, sizeof(**offset_array));
@@ -1212,88 +1211,6 @@ static bool data_matrix_alloc(size_t n_rows, uint64_t **offset_array,
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
index e299d067..f26fad7c 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -689,6 +689,21 @@ bool kshark_this_filter_is_set(struct tracecmd_filter_id *filter);
 
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
@@ -1067,6 +1082,12 @@ struct kshark_config_doc *kshark_open_config_file(const char *file_name,
 
 struct kshark_config_doc *kshark_json_to_conf(struct json_object *jobj);
 
+bool kshark_data_matrix_alloc(size_t n_rows, int16_t **cpu_array,
+					     int32_t **pid_array,
+					     int32_t **event_array,
+					     int64_t **offset_array,
+					     int64_t **ts_array);
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.25.1

