Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B903DC4727C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4877C208FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:42:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pTMThh85"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgI2NmK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729038AbgI2NmJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 09:42:09 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A22BC0613D0
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:42:09 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id e17so4679541wme.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S9DRIeXk1oRU1ZcDmaa3GSTTjuF8tliwbLqmYBGahos=;
        b=pTMThh85Y2v7vQr+BpysUZldF35DjBiSPcjuTmMP18zRMT3bc4a5mlAUm03h7yosXS
         zk3kQ1PIJlsN5LY9LYNzqmhXe2uSiWUogM4EKdCTWGR8RBabDNkLmnkKb1qpaZ32uuSt
         0rJGh+VTQYQPCRctwCldzv2mou2kUUyuvl9I1FzjMtUt1XZh7ocrxNJWNETjM3nntAx7
         8YsqauLCvaOwOgoIIatb1AXIBL6mOWLZ991Fh6IS75bwv6gS4q0zyypxjHOOiboLu4Ku
         +GOWcpokIQTY9ne321XCpzzmDmeAHp9WfVbPrBKsN/QS4pQjO27dTte01OVFiz0iB59V
         vA0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S9DRIeXk1oRU1ZcDmaa3GSTTjuF8tliwbLqmYBGahos=;
        b=PKCfO9P3SGudlIsT5uB4tdZwc/vWGp+fzpOcy+DT+eUIH938Q3v9g/4livAnpTMAzm
         nfCBbeOc89/IAqr+gByaFelu6kmq3LYDzmyaJqsnzhoet5ZH32JwBs2GUDMbdDsMCpOy
         OD4aouVtWLMsQhdx2BsR1F83Woxj+fOubfe4iI8G/qnIqP9GyMmZvhgl3YeKLg8ePHD9
         DUmAMUIguEKPSigSnSJUOECnSd9PL2JEGQkaa5Fvy4iUWsiuestJLJIx0hnYiqXnBhUE
         b6lO7JjGbkjZ/fXW4zj3eFNirInGHr93/rY4oCVX7StedchaV7mp83Ik7/JDfseCoAda
         oY1w==
X-Gm-Message-State: AOAM533UZbdLfsCGCL6jd/qDuPBNeU7U/q5orALYLSDW8snz89O7Onsx
        VIwI6KvKuOXA1y8Gxgh9zXQ=
X-Google-Smtp-Source: ABdhPJy5Woamo0wx/UzJxRZyg5MxaPJHsCXTh8+4fsbGX5wmb4HwT+fnXbUV5G9A0v8YGneTyon2Zg==
X-Received: by 2002:a1c:4885:: with SMTP id v127mr4951590wma.129.1601386927460;
        Tue, 29 Sep 2020 06:42:07 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id b84sm6162792wmd.0.2020.09.29.06.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 06:42:06 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 09/15] kernel-shark: Provide merging of multiple data streams
Date:   Tue, 29 Sep 2020 16:41:17 +0300
Message-Id: <20200929134123.178688-10-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929134123.178688-1-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The C API provides loading of the trace data in two different forms.
The firs one is an array of kshark_entries and is being used by the
KernelShark GUI. The second is a matrix-like structure that has all
the fields of the kshark_entry stored in separate arrays, forming the
columns of the matrix. The second form of the data is used by
trace-cruncher. In this patch we add methods for merging of several
data streams into a single data set. Both kshark_entries and matrix
forms of the data are supported. This patch includes a simple example
that demonstrate how to open a file that contains multiple buffers.
Each buffers is loaded into a separate Data stream and those streams
are merged together.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/CMakeLists.txt    |   4 +
 examples/multibufferload.c |  60 +++++++++
 src/libkshark.c            | 255 +++++++++++++++++++++++++++++++++++++
 src/libkshark.h            |  47 +++++++
 4 files changed, 366 insertions(+)
 create mode 100644 examples/multibufferload.c

diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
index 8d40e42..0dc3f27 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
@@ -4,6 +4,10 @@ message(STATUS "dataload")
 add_executable(dload          dataload.c)
 target_link_libraries(dload   kshark)
 
+message(STATUS "multibufferload")
+add_executable(mbload          multibufferload.c)
+target_link_libraries(mbload   kshark)
+
 message(STATUS "datafilter")
 add_executable(dfilter          datafilter.c)
 target_link_libraries(dfilter   kshark)
diff --git a/examples/multibufferload.c b/examples/multibufferload.c
new file mode 100644
index 0000000..70b2733
--- /dev/null
+++ b/examples/multibufferload.c
@@ -0,0 +1,60 @@
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "libkshark.h"
+#include "libkshark-tepdata.h"
+
+const char *default_file = "trace.dat";
+
+void put_entry(struct kshark_entry *e)
+{
+	char *entry_str = kshark_dump_entry(e);
+	puts(entry_str);
+	free(entry_str);
+}
+
+int main(int argc, char **argv)
+{
+	struct kshark_context *kshark_ctx;
+	struct kshark_entry **data = NULL;
+	ssize_t r, n_rows;
+	int sd;
+
+	/* Create a new kshark session. */
+	kshark_ctx = NULL;
+	if (!kshark_instance(&kshark_ctx))
+		return 1;
+
+	/* Open a trace data file produced by trace-cmd. */
+	if (argc > 1)
+		sd = kshark_open(kshark_ctx, argv[1]);
+	else
+		sd = kshark_open(kshark_ctx, default_file);
+
+	if (sd < 0) {
+		kshark_free(kshark_ctx);
+		return 1;
+	}
+
+	/* Initialize data streams for all buffers in this file. */
+	kshark_tep_init_all_buffers(kshark_ctx, sd);
+
+	/* Load all buffers. */
+	n_rows = kshark_load_all_entries(kshark_ctx, &data);
+
+	/* Print to the screen the first 20 entries. */
+	for (r = 0; r < 20; ++r)
+		put_entry(data[r]);
+
+	/* Free the memory. */
+	for (r = 0; r < n_rows; ++r)
+		free(data[r]);
+	free(data);
+
+	kshark_close_all(kshark_ctx);
+
+	/* Close the session. */
+	kshark_free(kshark_ctx);
+
+	return 0;
+}
diff --git a/src/libkshark.c b/src/libkshark.c
index 3a988df..02927d2 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -1184,6 +1184,182 @@ kshark_get_entry_back(const struct kshark_entry_request *req,
 	return get_entry(req, data, index, req->first, end, -1);
 }
 
+static int first_in_time_entry(struct kshark_entry_data_set *buffer, int n_buffers, size_t *count)
+{
+	int64_t t_min = INT64_MAX;
+	int i, min = -1;
+
+	for (i = 0; i < n_buffers; ++i) {
+		if (count[i] == buffer[i].n_rows)
+			continue;
+
+		if (t_min > buffer[i].data[count[i]]->ts) {
+			t_min = buffer[i].data[count[i]]->ts;
+			min = i;
+		}
+	}
+
+	return min;
+}
+
+/**
+ * @brief Merge trace data streams.
+ *
+ * @param buffers: Input location for the data-sets to be merged.
+ * @param n_buffers: The number of the data-sets to be merged.
+ *
+ * @returns Merged and sorted in time trace data entries. The user is
+ *	    responsible for freeing the elements of the outputted array.
+ */
+struct kshark_entry **
+kshark_merge_data_entries(struct kshark_entry_data_set *buffers, int n_buffers)
+{
+	struct kshark_entry **merged_data;
+	size_t i, tot = 0, count[n_buffers];
+	int i_first;
+
+	if (n_buffers < 2) {
+		fputs("kshark_merge_data_entries needs multipl data sets.\n",
+		      stderr);
+		return NULL;
+	}
+
+	for (i = 0; i < n_buffers; ++i) {
+		count[i] = 0;
+		if (buffers[i].n_rows > 0)
+			tot += buffers[i].n_rows;
+	}
+
+	merged_data = calloc(tot, sizeof(*merged_data));
+	if (!merged_data) {
+		fputs("Failed to allocate memory for mergeing data entries.\n",
+		      stderr);
+		return NULL;
+	}
+
+	for (i = 0; i < tot; ++i) {
+		i_first = first_in_time_entry(buffers, n_buffers, count);
+		assert(i_first >= 0);
+		merged_data[i] = buffers[i_first].data[count[i_first]];
+		++count[i_first];
+	}
+
+	return merged_data;
+}
+
+static ssize_t load_all_entries(struct kshark_context *kshark_ctx,
+				struct kshark_entry **loaded_rows,
+				ssize_t n_loaded,
+				int sd_first_new, int n_streams,
+				struct kshark_entry ***data_rows)
+{
+	int i, j = 0, n_data_sets;
+	ssize_t data_size = 0;
+
+	if (n_streams <= 0 || sd_first_new < 0)
+		return data_size;
+
+	n_data_sets = n_streams - sd_first_new;
+	if (loaded_rows && n_loaded > 0)
+		++n_data_sets;
+
+	struct kshark_entry_data_set buffers[n_data_sets];
+	memset(buffers, 0, sizeof(buffers));
+
+	if (loaded_rows && n_loaded > 0) {
+		/* Add the data that is already loaded. */
+		data_size = buffers[n_data_sets - 1].n_rows = n_loaded;
+		buffers[n_data_sets - 1].data = loaded_rows;
+	}
+
+	/* Add the data of the new streams. */
+	for (i = sd_first_new; i < n_streams; ++i) {
+		buffers[j].data = NULL;
+		buffers[j].n_rows = kshark_load_entries(kshark_ctx, i,
+							&buffers[j].data);
+
+		if (buffers[j].n_rows < 0) {
+			/* Loading failed. */
+			data_size = buffers[j].n_rows;
+			goto error;
+		}
+
+		data_size += buffers[j++].n_rows;
+	}
+
+	if (n_data_sets == 1) {
+		*data_rows = buffers[0].data;
+	} else {
+		/* Merge all streams. */
+		*data_rows = kshark_merge_data_entries(buffers, n_data_sets);
+	}
+
+ error:
+	for (i = 1; i < n_data_sets; ++i)
+		free(buffers[i].data);
+
+	return data_size;
+}
+
+/**
+ * @brief Load the content of the all opened data file into an array of
+ *	  kshark_entries.
+ *	  If one or more filters are set, the "visible" fields of each entry
+ *	  is updated according to the criteria provided by the filters. The
+ *	  field "filter_mask" of the session's context is used to control the
+ *	  level of visibility/invisibility of the filtered entries.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param data_rows: Output location for the trace data. The user is
+ *		     responsible for freeing the elements of the outputted
+ *		     array.
+ *
+ * @returns The size of the outputted data in the case of success, or a
+ *	    negative error code on failure.
+ */
+ssize_t kshark_load_all_entries(struct kshark_context *kshark_ctx,
+				struct kshark_entry ***data_rows)
+{
+	return load_all_entries(kshark_ctx,
+				NULL, 0,
+				0,
+				kshark_ctx->n_streams,
+				data_rows);
+}
+
+/**
+ * @brief Append the content of the all opened data file into an array of
+ *	  kshark_entries.
+ *	  If one or more filters are set, the "visible" fields of each entry
+ *	  is updated according to the criteria provided by the filters. The
+ *	  field "filter_mask" of the session's context is used to control the
+ *	  level of visibility/invisibility of the filtered entries.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param prior_data: Input location for the already loaded trace data.
+ * @param n_prior_rows: The size of the already loaded trace data.
+ * @param sd_first_new: Data stream identifier of the first data stream to be
+ *			appended.
+ * @param merged_data: Output location for the trace data. The user is
+ *		       responsible for freeing the elements of the outputted
+ *		       array.
+ * @returns The size of the outputted data in the case of success, or a
+ *	    negative error code on failure.
+ */
+ssize_t kshark_append_all_entries(struct kshark_context *kshark_ctx,
+				  struct kshark_entry **prior_data,
+				  ssize_t n_prior_rows,
+				  int sd_first_new,
+				  struct kshark_entry ***merged_data)
+{
+	return load_all_entries(kshark_ctx,
+				prior_data,
+				n_prior_rows,
+			        sd_first_new,
+				kshark_ctx->n_streams,
+				merged_data);
+}
+
 static inline void free_ptr(void *ptr)
 {
 	if (ptr)
@@ -1254,3 +1430,82 @@ bool kshark_data_matrix_alloc(size_t n_rows, int16_t **cpu_array,
 	fprintf(stderr, "Failed to allocate memory during data loading.\n");
 	return false;
 }
+
+static int first_in_time_row(struct kshark_matrix_data_set *buffers, int n_buffers, size_t *count)
+{
+	int64_t t_min = INT64_MAX;
+	int i, min = -1;
+
+	for (i = 0; i < n_buffers; ++i) {
+		if (count[i] == buffers[i].n_rows)
+			continue;
+
+		if (t_min > buffers[i].ts_array[count[i]]) {
+			t_min = buffers[i].ts_array[count[i]];
+			min = i;
+		}
+	}
+
+	return min;
+}
+
+/**
+ * @brief Merge trace data streams.
+ *
+ * @param buffers: Input location for the data-sets to be merged.
+ * @param n_buffers: The number of the data-sets to be merged.
+ *
+ * @returns Merged and sorted in time trace data matrix. The user is
+ *	    responsible for freeing the columns (arrays) of the outputted
+ *	    matrix.
+ */
+struct kshark_matrix_data_set
+kshark_merge_data_matrices(struct kshark_matrix_data_set *buffers, int n_buffers)
+{
+	struct kshark_matrix_data_set merged_data;
+	size_t i, tot = 0, count[n_buffers];
+	int i_first;
+	bool status;
+
+	merged_data.n_rows = -1;
+	if (n_buffers < 2) {
+		fputs("kshark_merge_data_matrices needs multipl data sets.\n",
+		      stderr);
+		goto end;
+	}
+
+	for (i = 0; i < n_buffers; ++i) {
+		count[i] = 0;
+		if (buffers[i].n_rows > 0)
+			tot += buffers[i].n_rows;
+	}
+
+	status = kshark_data_matrix_alloc(tot, &merged_data.cpu_array,
+					       &merged_data.pid_array,
+					       &merged_data.event_array,
+					       &merged_data.offset_array,
+					       &merged_data.ts_array);
+	if (!status) {
+		fputs("Failed to allocate memory for mergeing data matrices.\n",
+		      stderr);
+		goto end;
+	}
+
+	merged_data.n_rows = tot;
+
+	for (i = 0; i < tot; ++i) {
+		i_first = first_in_time_row(buffers, n_buffers, count);
+		assert(i_first >= 0);
+
+		merged_data.cpu_array[i] = buffers[i_first].cpu_array[count[i_first]];
+		merged_data.pid_array[i] = buffers[i_first].pid_array[count[i_first]];
+		merged_data.event_array[i] = buffers[i_first].event_array[count[i_first]];
+		merged_data.offset_array[i] = buffers[i_first].offset_array[count[i_first]];
+		merged_data.ts_array[i] = buffers[i_first].ts_array[count[i_first]];
+
+		++count[i_first];
+	}
+
+ end:
+	return merged_data;
+}
diff --git a/src/libkshark.h b/src/libkshark.h
index d7539e2..6878d6d 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -1096,12 +1096,59 @@ struct kshark_config_doc *kshark_open_config_file(const char *file_name,
 
 struct kshark_config_doc *kshark_json_to_conf(struct json_object *jobj);
 
+/** Structure representing a data set made of KernelShark entries. */
+struct kshark_entry_data_set {
+	/** Array of entries pointers. */
+	struct kshark_entry **data;
+
+	/** The size of the data set. */
+	ssize_t n_rows;
+};
+
+struct kshark_entry **
+kshark_merge_data_entries(struct kshark_entry_data_set *buffers,
+			  int n_buffers);
+
+ssize_t kshark_load_all_entries(struct kshark_context *kshark_ctx,
+				struct kshark_entry ***data_rows);
+
+ssize_t kshark_append_all_entries(struct kshark_context *kshark_ctx,
+				  struct kshark_entry **prior_data,
+				  ssize_t n_prior_rows,
+				  int first_streams,
+				  struct kshark_entry ***merged_data);
+
 bool kshark_data_matrix_alloc(size_t n_rows, int16_t **cpu_array,
 					     int32_t **pid_array,
 					     int32_t **event_array,
 					     int64_t **offset_array,
 					     int64_t **ts_array);
 
+/** Structure representing a data set made of data columns (arrays). */
+struct kshark_matrix_data_set {
+	/** CPU Id column. */
+	int16_t *cpu_array;
+
+	/** PID column. */
+	int32_t *pid_array;
+
+	/** Event Id column. */
+	int32_t *event_array;
+
+	/** Record offset column. */
+	int64_t *offset_array;
+
+	/** Timestamp column. */
+	int64_t *ts_array;
+
+	/** The size of the data set. */
+	ssize_t n_rows;
+};
+
+struct kshark_matrix_data_set
+kshark_merge_data_matrices(struct kshark_matrix_data_set *buffers,
+			   int n_buffers);
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.25.1

