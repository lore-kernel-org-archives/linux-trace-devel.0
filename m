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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB2DC56202
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2366522248
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ga2ZboB9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgKLOYe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 09:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbgKLOYe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 09:24:34 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553D4C0613D4
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:34 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id d142so5424696wmd.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cv98HewIX3qAcPa9tMIGyhr88fw/mAKSXjzhPvGzMV8=;
        b=Ga2ZboB9ppYIz1Z1R2rdvgAYgSJwCK0rL9utYnhuw5PYsMt1baWFfE3GYRuMqwWJx4
         vt78+5E7ErUeValIDHlybA8QAT6z7riRGGlWfsb+DeETHUvT5AleuXKvj+znUXZZgIMg
         xXc2PDWSLKVDV6KJsxFenE2gT9zWHmtuXmz4cL/gaxV6M1BbLY+eRuBVfgU7eL0MWM4K
         DAyJnnUMmqErTAhnb0h2p9tpboNitVDJmuWhZ2EqIUk8PVp2Uh77FumOoIWXE+knV2ZN
         Do8ILoq6cx9coSz6OQm8jDeX11GJu5CuOKzSa8+L1MW9jm8mPyh7+Y5jDKHsozw+eijI
         3YiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cv98HewIX3qAcPa9tMIGyhr88fw/mAKSXjzhPvGzMV8=;
        b=JRGU0wJCRfTQhX4H5bJ2XrD+qK+8uerQHNfwoGXG1ojetx6E+3eGvtGWuny/OWdYVU
         B0ok293Jo/HiTHwwRtiI0Bc2Us6MoxLNZGVv7oNelbjQH3tg41+/mvAULZkpU1XA2Q8p
         stZBt+gLnp8b1GYX0tbuyGl1ZmfAcqNlrd/WLAN+7pq3PCAA679G925ac6Dy5fTNGDJf
         4HjQoUDh2uQrUNmTLlTJ9Zh4v7ZEsfWUR0gT7vY/bCD4KH4rkMtoxM2T/a1pEBzO9JCI
         FgRcHvMG/XducihkagAuy1F+vUovE8rSGiTGqCF47f/vzDuNami2uFKjGh8iHHoH3XTW
         HclA==
X-Gm-Message-State: AOAM530cvoi8S8GAYw2iWE/qBn9tNxz19wCzm08EkgVWt0wkLSLf7cz1
        vDt6+9vzCivpfGC9TsWpB+ti6eUGdWk=
X-Google-Smtp-Source: ABdhPJyBDZTX+CnEWualwvmcrc62CfMuniXksYRZzUjmQ+EkE1bgNcZLV+kLlqaSkV0QlT7wnhJE+g==
X-Received: by 2002:a7b:cf22:: with SMTP id m2mr9800268wmg.179.1605191072958;
        Thu, 12 Nov 2020 06:24:32 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id h15sm6950685wrw.15.2020.11.12.06.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 06:24:32 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 14/20] kernel-shark: Provide merging of multiple data streams
Date:   Thu, 12 Nov 2020 16:23:52 +0200
Message-Id: <20201112142358.36821-15-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112142358.36821-1-y.karadz@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
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
index 8d40e42c..831eee24 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
@@ -8,6 +8,10 @@ message(STATUS "datafilter")
 add_executable(dfilter          datafilter.c)
 target_link_libraries(dfilter   kshark)
 
+message(STATUS "multibufferload")
+add_executable(mbload          multibufferload.c)
+target_link_libraries(mbload   kshark)
+
 # message(STATUS "datahisto")
 # add_executable(dhisto          datahisto.c)
 # target_link_libraries(dhisto   kshark)
diff --git a/examples/multibufferload.c b/examples/multibufferload.c
new file mode 100644
index 00000000..70b2733a
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
index 473f1cd7..d4b8af72 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -1777,3 +1777,258 @@ kshark_get_entry_back(const struct kshark_entry_request *req,
 
 	return get_entry(req, data, index, req->first, end, -1);
 }
+
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
+	status = kshark_data_matrix_alloc(tot, &merged_data.event_array,
+					       &merged_data.cpu_array,
+					       &merged_data.pid_array,
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
index 8aa11996..8f7900f1 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -990,12 +990,59 @@ struct kshark_config_doc *kshark_open_config_file(const char *file_name,
 
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
 bool kshark_data_matrix_alloc(size_t n_rows, int16_t **event_array,
 					     int16_t **cpu_array,
 					     int32_t **pid_array,
 					     int64_t **offset_array,
 					     int64_t **ts_array);
 
+/** Structure representing a data set made of data columns (arrays). */
+struct kshark_matrix_data_set {
+	/** Event Id column. */
+	int16_t *event_array;
+
+	/** CPU Id column. */
+	int16_t *cpu_array;
+
+	/** PID column. */
+	int32_t *pid_array;
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

