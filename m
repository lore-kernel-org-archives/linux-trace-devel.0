Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A521E863
	for <linux-trace-devel@vger.kernel.org>; Sun, 10 Mar 2024 19:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710099220; cv=none; b=g868LZR3Y/Hg7HErNHN5zOy3m9poiU4lQ6wyed3oKjWPgmsDs34/t9f+H0DrSy6CScpM2S0IHO+bYHXRIYonkor6u2x1nJTaNnkWUA6LUpvYA//kWME7nRjcdYEzDD7Y97Pt0fx2fhSI8NAym0z93U/MzobyiS9GKaNfkSSi90A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710099220; c=relaxed/simple;
	bh=j+H2DUGrwhU+AAmHDW65gSl77IuW/6+k1eoNlgwIAwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5LQ89Ay3zYq+VmE0R9SfE7fzm5xOa2wpR2WGrFSAkrqGk8qSrkqp5XJmB5fTHUyDPUWWXSm52kVPY+DL0RRiRE1hNUW+wzF3xMjlj4y9GtUDnXcmfXG6fHFIrw1O6a4LLZXrOlA1a3F9AIntUHA9plGkN0IBPupnduByJCoaJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gMVpktUT; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gMVpktUT"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-41329af9093so1780095e9.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Mar 2024 12:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710099216; x=1710704016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2n48bqiVVb1kVqKMgNFucrdQvizbfNpAjLLj3wjL74k=;
        b=gMVpktUTdLUY4Q6UBzZIjJZDQMQTNlvD/KoPY+Zc+yo16QEAX+85w6M9a30ku8H3jg
         jSNMsSf21RfLQT5MiLTmb312006Z+rCzVQSNFNBi5vLeBZYiNcjufJcxSjjtpWir0hnM
         qa2593rVkzCMPH8mp6rME0IMvuan0oKKMjTAtKCX5CHbqNoJfz/0yBm6AuiAGgMMSAQH
         ZfOfdPHfzC5jB8fxL4vhV9oOjYwyjiAY/b2/ZZxRdEJGtYkmfeSvQLvgUPs3I4Y5ga+3
         LJZnSrV7lKDkIUGfAQCyqVXMk9YggJxEN8h1DBCO1YIiwihEa2xO2LDRKv25tacMr7YA
         uz2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710099216; x=1710704016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2n48bqiVVb1kVqKMgNFucrdQvizbfNpAjLLj3wjL74k=;
        b=tSIEX0eLs0jtK/K79zj2U0S21ywm/7d67rzmMDdv9omfa2mXZ/4fivVXbtRRllQPEs
         10DorK73YzOTfkY88imilbMw8iX69WdybJe0HFEy8xQlINaICX4qcctGh4IUQ/bMDNmV
         mN/w5wzVtBOYBkEJyRCV9zlXxLawlzm7raOCw5Ts+1ZafESonAoaZl9/JDrLYHIsiDlj
         D1E2KjUfh+RE7sSayUMf14bCPcmWnC0mb9d9+8h7fn6b6oZLG0+ne08DPvxXJnjwzHBk
         EQv3NtlxM88UzVZHaGuDfPjAgnoBH7gXSZ8muWF1KIvOUirTEJURGr4iz30ltD+yL/wO
         rHGQ==
X-Gm-Message-State: AOJu0YwgNRPkOrAW/VDbf+/SkAP+WmMUPoyWXWMSuCO8nlY2tVQhydZc
	oeX7cERVbVTOdVH1H1SuA7PEMk5hXEJEanQHvzFLjBrJCXgKMpvFS3C34JnS
X-Google-Smtp-Source: AGHT+IFIRqNbzQW49D2RSh2JmES0lfuZTw8JXZGacUnnjGB44IHdl8o/VQK2YDXH79s7AKKEMrkirA==
X-Received: by 2002:a05:600c:19d0:b0:413:128a:403 with SMTP id u16-20020a05600c19d000b00413128a0403mr4133862wmq.1.1710099216172;
        Sun, 10 Mar 2024 12:33:36 -0700 (PDT)
Received: from belmeken.. (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id ay5-20020a05600c1e0500b0041327ac5dbesm2422768wmb.48.2024.03.10.12.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Mar 2024 12:33:35 -0700 (PDT)
From: Yordan Karadzhov <y.karadz@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: dev@benjarobin.fr,
	Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 3/3] kernel-shark: Fix various compile warnings
Date: Sun, 10 Mar 2024 21:32:58 +0200
Message-ID: <20240310193258.50899-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240310193258.50899-1-y.karadz@gmail.com>
References: <20240310193258.50899-1-y.karadz@gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Those warnings started showing up after adding the "-Wextra"
compiler flag.

Signed-off-by: Yordan Karadzhov <y.karadz@gmail.com>
---
 examples/configio.c        |  3 ++-
 examples/datafilter.c      |  4 ++--
 examples/datahisto.c       |  2 +-
 src/libkshark-collection.c | 42 ++++++++++++++++++++------------------
 src/libkshark-configio.c   |  6 ++++--
 src/libkshark-hash.c       |  7 +++----
 src/libkshark-model.c      | 20 +++++++++---------
 src/libkshark-model.h      |  4 ++--
 src/libkshark-tepdata.c    |  3 +--
 src/libkshark.c            | 28 ++++++++++++++++---------
 src/libkshark.h            |  6 +++---
 src/plugins/sched_events.c | 16 +++++++--------
 12 files changed, 76 insertions(+), 65 deletions(-)

diff --git a/examples/configio.c b/examples/configio.c
index 9710d53..575211d 100644
--- a/examples/configio.c
+++ b/examples/configio.c
@@ -8,7 +8,8 @@ int main(int argc, char **argv)
 	struct kshark_config_doc *conf, *filter, *hello;
 	struct kshark_context *kshark_ctx;
 	struct kshark_data_stream *stream;
-	int sd, *ids = NULL, i;
+	int sd, *ids = NULL;
+	size_t i;
 
 	/* Create a new kshark session. */
 	kshark_ctx = NULL;
diff --git a/examples/datafilter.c b/examples/datafilter.c
index 8e86d9c..120c12e 100644
--- a/examples/datafilter.c
+++ b/examples/datafilter.c
@@ -17,11 +17,11 @@ const char *default_file = "trace.dat";
 
 int main(int argc, char **argv)
 {
-	size_t i, sd, n_rows, n_tasks, n_evts, count;
+	size_t i, n_rows, n_tasks, n_evts, count;
 	struct kshark_context *kshark_ctx;
 	struct kshark_data_stream *stream;
 	struct kshark_entry **data = NULL;
-	int *pids, *evt_ids;
+	int sd, *pids, *evt_ids;
 	char *entry_str;
 
 	/* Create a new kshark session. */
diff --git a/examples/datahisto.c b/examples/datahisto.c
index 568072d..b54b9e9 100644
--- a/examples/datahisto.c
+++ b/examples/datahisto.c
@@ -70,7 +70,7 @@ void dump_bin(struct kshark_trace_histo *histo, int bin, int sd,
 
 void dump_histo(struct kshark_trace_histo *histo, int sd, const char *type, int val)
 {
-	size_t bin;
+	int bin;
 
 	for (bin = 0; bin < histo->n_bins; ++bin)
 		dump_bin(histo, bin, sd, type, val);
diff --git a/src/libkshark-collection.c b/src/libkshark-collection.c
index 915983b..c44d579 100644
--- a/src/libkshark-collection.c
+++ b/src/libkshark-collection.c
@@ -120,7 +120,7 @@ kshark_data_collection_alloc(struct kshark_context *kshark_ctx,
 		temp->type = COLLECTION_IGNORE;
 	}
 
-	for (i = first + margin; i < end; ++i) {
+	for (i = first + margin; i < (size_t) end; ++i) {
 		if (!cond(kshark_ctx, data[i], sd, values)) {
 			/*
 			 * The entry is irrelevant for this collection.
@@ -161,9 +161,8 @@ kshark_data_collection_alloc(struct kshark_context *kshark_ctx,
 
 			/* Keep adding entries until the "next" record. */
 			for (j = i + 1;
-			     j != end && last_vis_entry->next != data[j];
-			     j++)
-				;
+			     j != (size_t) end && last_vis_entry->next != data[j];
+			     j++);
 
 			/*
 			 * If the number of added entries is smaller than the
@@ -322,8 +321,9 @@ map_collection_request_init(const struct kshark_entry_collection *col,
 			    bool front, size_t *end)
 {
 	int col_index_flag;
-	ssize_t col_index;
+	size_t col_index;
 	size_t req_end;
+	ssize_t ret;
 
 	if (req->next || col->size == 0) {
 		fprintf(stderr,
@@ -338,19 +338,17 @@ map_collection_request_init(const struct kshark_entry_collection *col,
 	 * Find the first Resume Point of the collection which is equal or
 	 * greater than the first index of this request.
 	 */
-	col_index = map_collection_index_from_source(col,
-						     req->first,
-						     &col_index_flag);
+	ret = map_collection_index_from_source(col, req->first, &col_index_flag);
+	if (ret == KS_EMPTY_BIN) {
+		/* Empty collection. */
+		goto do_nothing;
+	}
+	col_index = ret;
 
 	/*
 	 * The value of "col_index" is ambiguous. Use the "col_index_flag" to
 	 * deal with all possible cases.
 	 */
-	if (col_index == KS_EMPTY_BIN) {
-		/* Empty collection. */
-		goto do_nothing;
-	}
-
 	if (col_index_flag == COLLECTION_AFTER) {
 		/*
 		 * This request starts after the end of interval "col_index".
@@ -436,12 +434,14 @@ map_collection_back_request(const struct kshark_entry_collection *col,
 			    struct kshark_entry_request *req)
 {
 	size_t req_first, req_end;
-	ssize_t col_index;
+	size_t col_index;
 	int req_count;
+	ssize_t ret;
 
-	col_index = map_collection_request_init(col, req, false, &req_end);
-	if (col_index == KS_EMPTY_BIN)
+	ret = map_collection_request_init(col, req, false, &req_end);
+	if (ret == KS_EMPTY_BIN)
 		return 0;
+	col_index = ret;
 
 	/*
 	 * Now loop over the intervals of the collection going backwards till
@@ -449,7 +449,7 @@ map_collection_back_request(const struct kshark_entry_collection *col,
 	 * each of those interest.
 	 */
 	req_count = 1;
-	while (col_index >= 0 && req_end <= col->break_points[col_index]) {
+	while (req_end <= col->break_points[col_index]) {
 		if (req_end >= col->resume_points[col_index]) {
 			/*
 			 * The last entry of the original request is inside
@@ -519,12 +519,14 @@ map_collection_front_request(const struct kshark_entry_collection *col,
 			     struct kshark_entry_request *req)
 {
 	size_t req_first, req_end;
-	ssize_t col_index;
+	size_t col_index;
 	int req_count;
+	ssize_t ret;
 
-	col_index = map_collection_request_init(col, req, true, &req_end);
-	if (col_index == KS_EMPTY_BIN)
+	ret = map_collection_request_init(col, req, true, &req_end);
+	if (ret == KS_EMPTY_BIN)
 		return 0;
+	col_index = ret;
 
 	/*
 	 * Now loop over the intervals of the collection going forwards till
diff --git a/src/libkshark-configio.c b/src/libkshark-configio.c
index 038cb22..88c2c9a 100644
--- a/src/libkshark-configio.c
+++ b/src/libkshark-configio.c
@@ -1114,7 +1114,8 @@ static bool kshark_event_filter_to_json(struct kshark_data_stream *stream,
 	json_object *jfilter_data, *jname;
 	struct kshark_hash_id *filter;
 	char *name_str;
-	int i, *ids;
+	int *ids;
+	size_t i;
 
 	filter = kshark_get_filter(stream, filter_type);
 	if (!filter)
@@ -1283,7 +1284,8 @@ static bool kshark_filter_array_to_json(struct kshark_hash_id *filter,
 					struct json_object *jobj)
 {
 	json_object *jfilter_data, *jpid = NULL;
-	int i, *ids;
+	int *ids;
+	size_t i;
 
 	/*
 	 * If this Json document already contains a description of the filter,
diff --git a/src/libkshark-hash.c b/src/libkshark-hash.c
index 89c021b..8782883 100644
--- a/src/libkshark-hash.c
+++ b/src/libkshark-hash.c
@@ -168,8 +168,7 @@ void kshark_hash_id_remove(struct kshark_hash_id *hash, int id)
 void kshark_hash_id_clear(struct kshark_hash_id *hash)
 {
 	struct kshark_hash_id_item *item, *next;
-	size_t size;
-	int i;
+	size_t i, size;
 
 	if (!hash || ! hash->hash)
 		return;
@@ -211,8 +210,8 @@ static int compare_ids(const void* a, const void* b)
 int *kshark_hash_ids(struct kshark_hash_id *hash)
 {
 	struct kshark_hash_id_item *item;
-	size_t size = hash_size(hash);
-	int count = 0, i;
+	size_t i, size = hash_size(hash);
+	int count = 0;
 	int *ids;
 
 	if (!hash->count)
diff --git a/src/libkshark-model.c b/src/libkshark-model.c
index e872784..c6dce5e 100644
--- a/src/libkshark-model.c
+++ b/src/libkshark-model.c
@@ -91,7 +91,7 @@ static bool ksmodel_histo_alloc(struct kshark_trace_histo *histo, size_t n)
 }
 
 static void ksmodel_set_in_range_bining(struct kshark_trace_histo *histo,
-					size_t n, int64_t min, int64_t max,
+					int n, int64_t min, int64_t max,
 					bool force_in_range)
 {
 	int64_t corrected_range, delta_range, range = max - min;
@@ -110,7 +110,7 @@ static void ksmodel_set_in_range_bining(struct kshark_trace_histo *histo,
 	}
 
 	/* The size of the bin must be >= 1, hence the range must be >= n. */
-	if (range < n) {
+	if (range < (int64_t) n) {
 		range = n;
 		max = min + n;
 	}
@@ -266,10 +266,10 @@ static size_t ksmodel_set_upper_edge(struct kshark_trace_histo *histo)
 }
 
 static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
-				      size_t bin, size_t last_row)
+				      int bin, size_t last_row)
 {
 	int64_t time_min, time_max;
-	size_t next_bin = bin + 1;
+	int next_bin = bin + 1;
 	ssize_t row;
 
 	/* Calculate the beginning and the end of the next bin. */
@@ -463,12 +463,12 @@ size_t ksmodel_bin_count(struct kshark_trace_histo *histo, int bin)
  * @param histo: Input location for the model descriptor.
  * @param n: Number of bins to shift.
  */
-void ksmodel_shift_forward(struct kshark_trace_histo *histo, size_t n)
+void ksmodel_shift_forward(struct kshark_trace_histo *histo, int n)
 {
 	size_t last_row = 0;
 	int bin;
 
-	if (!histo->data_size)
+	if (!histo->data_size || histo->n_bins <= 0)
 		return;
 
 	if (histo->map[UOB(histo)] == KS_EMPTY_BIN) {
@@ -541,12 +541,12 @@ void ksmodel_shift_forward(struct kshark_trace_histo *histo, size_t n)
  * @param histo: Input location for the model descriptor.
  * @param n: Number of bins to shift.
  */
-void ksmodel_shift_backward(struct kshark_trace_histo *histo, size_t n)
+void ksmodel_shift_backward(struct kshark_trace_histo *histo, int n)
 {
 	size_t last_row = 0;
 	int bin;
 
-	if (!histo->data_size)
+	if (!histo->data_size || histo->n_bins <= 0)
 		return;
 
 	if (histo->map[LOB(histo)] == KS_EMPTY_BIN) {
@@ -649,7 +649,7 @@ void ksmodel_jump_to(struct kshark_trace_histo *histo, int64_t ts)
 static void ksmodel_zoom(struct kshark_trace_histo *histo,
 			 double r, int mark, bool zoom_in)
 {
-	size_t range, min, max, delta_min;
+	int64_t range, min, max, delta_min;
 	double delta_tot;
 
 	if (!histo->data_size)
@@ -668,7 +668,7 @@ static void ksmodel_zoom(struct kshark_trace_histo *histo,
 	 * Avoid overzooming. If needed, adjust the Scale factor to a the value
 	 * which provides bin_size >= 5.
 	 */
-	if (zoom_in && (size_t) (range * (1. - r)) < histo->n_bins * 5)
+	if (zoom_in && (int64_t) (range * (1. - r)) < (int64_t) histo->n_bins * 5)
 		r = 1. - (histo->n_bins * 5.) / range;
 
 	/*
diff --git a/src/libkshark-model.h b/src/libkshark-model.h
index 8989ee0..bf4f1c4 100644
--- a/src/libkshark-model.h
+++ b/src/libkshark-model.h
@@ -85,9 +85,9 @@ void ksmodel_fill(struct kshark_trace_histo *histo,
 
 size_t ksmodel_bin_count(struct kshark_trace_histo *histo, int bin);
 
-void ksmodel_shift_forward(struct kshark_trace_histo *histo, size_t n);
+void ksmodel_shift_forward(struct kshark_trace_histo *histo, int n);
 
-void ksmodel_shift_backward(struct kshark_trace_histo *histo, size_t n);
+void ksmodel_shift_backward(struct kshark_trace_histo *histo, int n);
 
 void ksmodel_jump_to(struct kshark_trace_histo *histo, int64_t ts);
 
diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 4e572a1..ed508a9 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -239,7 +239,7 @@ static int get_next_pid(struct kshark_data_stream *stream,
 	ret = tep_read_number_field(get_sched_next(stream),
 				    record->data, &val);
 
-	return ret ? : val;
+	return ret ? : (int) val;
 }
 
 static void register_command(struct kshark_data_stream *stream,
@@ -312,7 +312,6 @@ static ssize_t get_records(struct kshark_context *kshark_ctx,
 		count = 0;
 		cpu_list[cpu] = NULL;
 		temp_next = &cpu_list[cpu];
-
 		rec = tracecmd_read_cpu_first(kshark_get_tep_input(stream), cpu);
 		while (rec) {
 			*temp_next = temp_rec = calloc(1, sizeof(*temp_rec));
diff --git a/src/libkshark.c b/src/libkshark.c
index 8443279..4909dd6 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -1370,14 +1370,15 @@ void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
 			      size_t n_entries)
 {
 	struct kshark_data_stream *stream;
-	int *stream_ids, i;
+	int *stream_ids, sd;
+	size_t i;
 
 	for (i = 0; i < n_entries; ++i)
 		set_all_visible(&data[i]->visible);
 
 	stream_ids = kshark_all_streams(kshark_ctx);
-	for (i = 0; i < kshark_ctx->n_streams; i++) {
-		stream = kshark_get_data_stream(kshark_ctx, stream_ids[i]);
+	for (sd = 0; sd < kshark_ctx->n_streams; sd++) {
+		stream = kshark_get_data_stream(kshark_ctx, stream_ids[sd]);
 		stream->filter_is_applied = false;
 	}
 
@@ -1902,10 +1903,13 @@ void kshark_set_clock_offset(struct kshark_context *kshark_ctx,
 	kshark_data_qsort(entries, size);
 }
 
-static int first_in_time_entry(struct kshark_entry_data_set *buffer, int n_buffers, size_t *count)
+static int first_in_time_entry(struct kshark_entry_data_set *buffer,
+			       size_t n_buffers,
+			       ssize_t *count)
 {
 	int64_t t_min = INT64_MAX;
-	int i, min = -1;
+	int min = -1;
+	size_t i;
 
 	for (i = 0; i < n_buffers; ++i) {
 		if (count[i] == buffer[i].n_rows)
@@ -1930,10 +1934,11 @@ static int first_in_time_entry(struct kshark_entry_data_set *buffer, int n_buffe
  *	    responsible for freeing the elements of the outputted array.
  */
 struct kshark_entry **
-kshark_merge_data_entries(struct kshark_entry_data_set *buffers, int n_buffers)
+kshark_merge_data_entries(struct kshark_entry_data_set *buffers, size_t n_buffers)
 {
 	struct kshark_entry **merged_data;
-	size_t i, tot = 0, count[n_buffers];
+	ssize_t count[n_buffers];
+	size_t i, tot = 0;
 	int i_first;
 
 	if (n_buffers < 2) {
@@ -2078,7 +2083,9 @@ ssize_t kshark_append_all_entries(struct kshark_context *kshark_ctx,
 				merged_data);
 }
 
-static int first_in_time_row(struct kshark_matrix_data_set *buffers, int n_buffers, size_t *count)
+static int first_in_time_row(struct kshark_matrix_data_set *buffers,
+			     int n_buffers,
+			     ssize_t *count)
 {
 	int64_t t_min = INT64_MAX;
 	int i, min = -1;
@@ -2107,10 +2114,11 @@ static int first_in_time_row(struct kshark_matrix_data_set *buffers, int n_buffe
  *	    matrix.
  */
 struct kshark_matrix_data_set
-kshark_merge_data_matrices(struct kshark_matrix_data_set *buffers, int n_buffers)
+kshark_merge_data_matrices(struct kshark_matrix_data_set *buffers, size_t n_buffers)
 {
 	struct kshark_matrix_data_set merged_data;
-	size_t i, tot = 0, count[n_buffers];
+	ssize_t count[n_buffers];
+	size_t i, tot = 0;
 	int i_first;
 	bool status;
 
diff --git a/src/libkshark.h b/src/libkshark.h
index 97d3227..7656ce9 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -764,7 +764,7 @@ struct kshark_entry_collection {
 	int *values;
 
 	/** The suze of the array of matching condition values. */
-	int n_val;
+	size_t n_val;
 
 	/**
 	 * Array of indexes defining the beginning of each individual data
@@ -1071,7 +1071,7 @@ struct kshark_entry_data_set {
 
 struct kshark_entry **
 kshark_merge_data_entries(struct kshark_entry_data_set *buffers,
-			  int n_buffers);
+			  size_t n_buffers);
 
 ssize_t kshark_load_all_entries(struct kshark_context *kshark_ctx,
 				struct kshark_entry ***data_rows);
@@ -1111,7 +1111,7 @@ struct kshark_matrix_data_set {
 
 struct kshark_matrix_data_set
 kshark_merge_data_matrices(struct kshark_matrix_data_set *buffers,
-			   int n_buffers);
+			   size_t n_buffers);
 
 /**
  * Structure used to store the data of a kshark_entry plus one additional
diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index c3a4f47..e7dd2b1 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -104,28 +104,28 @@ static void plugin_sched_swith_action(struct kshark_data_stream *stream,
 {
 	struct tep_record *record = (struct tep_record *) rec;
 	struct plugin_sched_context *plugin_ctx;
-	unsigned long long next_pid, prev_state;
+	unsigned long long next_pid_val, prev_state_val;
 	ks_num_field_t ks_field = 0;
-	int ret;
+	int ret, pid;
 
 	plugin_ctx = __get_context(stream->stream_id);
 	if (!plugin_ctx)
 		return;
 
 	ret = tep_read_number_field(plugin_ctx->sched_switch_next_field,
-				    record->data, &next_pid);
-
-	if (ret == 0 && next_pid >= 0) {
+				    record->data, &next_pid_val);
+	pid = next_pid_val;
+	if (ret == 0 && pid >= 0) {
 		plugin_sched_set_pid(&ks_field, entry->pid);
 
 		ret = tep_read_number_field(plugin_ctx->sched_switch_prev_state_field,
-					    record->data, &prev_state);
+					    record->data, &prev_state_val);
 
 		if (ret == 0)
-			plugin_sched_set_prev_state(&ks_field, prev_state);
+			plugin_sched_set_prev_state(&ks_field, prev_state_val);
 
 		kshark_data_container_append(plugin_ctx->ss_data, entry, ks_field);
-		entry->pid = next_pid;
+		entry->pid = pid;
 	}
 }
 
-- 
2.42.0

