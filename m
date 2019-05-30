Return-Path: <SRS0=Uv3S=T6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FF5C28CC0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 May 2019 13:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 183A92596C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 May 2019 13:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfE3NO4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 May 2019 09:14:56 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36266 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfE3NO4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 May 2019 09:14:56 -0400
Received: by mail-pg1-f196.google.com with SMTP id a3so2026098pgb.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 May 2019 06:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E0QtKTkX83ecoTU+lkiNCsXhacNxgzBf0zZeRLm5dTM=;
        b=HHXMJV8Q/szh0+9wYqyWfwxNZxTiDctzu74mz7aVvKI5PGYlG9V1VyMjSMC1KPnCB6
         WtJX0KFPZRRZqLqyugjyeaWgmRC9Tm36lpcKoj5JgEykaSFTyAvLGf2+XrXPOLRX7KkA
         IZPSn8mfXrP1jw3D6qQKQYq+TosQWwTEckgP3ZvW+K1oRLs8EcuMLVBjIj94MskSrWMc
         RTUG137OLKkQPN8U+2Qwtfy+Dn/m4ZL9G7iRptYBGwPeqrjoBjAhmPFG+OnJfN+5FExm
         QEKEjnj7U5f8q6LU4m9AimyQ/iKJNFvis//HikpfHpHb35eaQ/HZDXpxqWPya/uCJgn7
         3Lvw==
X-Gm-Message-State: APjAAAXvG+chuHzme/X5E2FxIaxmCCKBqyGMCUCGrXIG8eUK98Bj1/+J
        Q+RCLsD+BAVWgwu/ajnyts8KUsVn
X-Google-Smtp-Source: APXvYqwOykT2elNf8sAdetNzaQYQKaO5pfzVv0adRbm6GxwDYLSTXdCdcMQUH7RLkPIizJ5e7cql0A==
X-Received: by 2002:a63:f44b:: with SMTP id p11mr3714793pgk.225.1559222095592;
        Thu, 30 May 2019 06:14:55 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d19sm2419627pjs.22.2019.05.30.06.14.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 06:14:54 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/2] kernel-shark: Add new dataloading method to be used by the NumPu interface
Date:   Thu, 30 May 2019 16:13:29 +0300
Message-Id: <20190530131330.21701-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190530131330.21701-1-ykaradzhov@vmware.com>
References: <20190530131330.21701-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new function loads the content of the trace data file into a
table / matrix, made of columns / arrays of data having various integer
types. Later those arrays will be wrapped as NumPy arrays.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark.c | 139 +++++++++++++++++++++++++++++++++++
 kernel-shark/src/libkshark.h |   7 ++
 2 files changed, 146 insertions(+)

diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 175279c..608d570 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -957,6 +957,145 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 	return -ENOMEM;
 }
 
+static inline void free_ptr(void *ptr)
+{
+	if (ptr)
+		free(*(void **)ptr);
+}
+
+static bool data_matrix_alloc(size_t n_rows, uint64_t **offset_array,
+					     uint16_t **cpu_array,
+					     uint64_t **ts_array,
+					     uint16_t **pid_array,
+					     int **event_array)
+{
+	if (offset_array) {
+		*offset_array = calloc(n_rows, sizeof(**offset_array));
+		if (!*offset_array)
+			return false;
+	}
+
+	if (cpu_array) {
+		*cpu_array = calloc(n_rows, sizeof(**cpu_array));
+		if (!*cpu_array)
+			goto free_offset;
+	}
+
+	if (ts_array) {
+		*ts_array = calloc(n_rows, sizeof(**ts_array));
+		if (!*ts_array)
+			goto free_cpu;
+	}
+
+	if (pid_array) {
+		*pid_array = calloc(n_rows, sizeof(**pid_array));
+		if (!*pid_array)
+			goto free_ts;
+	}
+
+	if (event_array) {
+		*event_array = calloc(n_rows, sizeof(**event_array));
+		if (!*event_array)
+			goto free_pid;
+	}
+
+	return true;
+
+ free_pid:
+	free_ptr(pid_array);
+ free_ts:
+	free_ptr(ts_array);
+ free_cpu:
+	free_ptr(cpu_array);
+ free_offset:
+	free_ptr(offset_array);
+
+	fprintf(stderr, "Failed to allocate memory during data loading.\n");
+	return false;
+}
+
+/**
+ * @brief Load the content of the trace data file into a table / matrix made
+ *	  of columns / arrays of data. The user is responsible for freeing the
+ *	  elements of the outputted array
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param offset_array: Output location for the array of record offsets.
+ * @param cpu_array: Output location for the array of CPU Ids.
+ * @param ts_array: Output location for the array of timestamps.
+ * @param pid_array: Output location for the array of Process Ids.
+ * @param event_array: Output location for the array of Event Ids.
+ *
+ * @returns The size of the outputted arrays in the case of success, or a
+ *	    negative error code on failure.
+ */
+size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
+			       uint64_t **offset_array,
+			       uint16_t **cpu_array,
+			       uint64_t **ts_array,
+			       uint16_t **pid_array,
+			       int **event_array)
+{
+	enum rec_type type = REC_ENTRY;
+	struct rec_list **rec_list;
+	size_t count, total = 0;
+	bool status;
+	int n_cpus;
+
+	total = get_records(kshark_ctx, &rec_list, type);
+	if (total < 0)
+		goto fail;
+
+	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+
+	status = data_matrix_alloc(total, offset_array,
+					  cpu_array,
+					  ts_array,
+					  pid_array,
+					  event_array);
+	if (!status)
+		goto fail_free;
+
+	for (count = 0; count < total; count++) {
+		int next_cpu;
+
+		next_cpu = pick_next_cpu(rec_list, n_cpus, type);
+		if (next_cpu >= 0) {
+			struct rec_list *rec = rec_list[next_cpu];
+			struct kshark_entry *e = &rec->entry;
+
+			if (offset_array)
+				(*offset_array)[count] = e->offset;
+
+			if (cpu_array)
+				(*cpu_array)[count] = e->cpu;
+
+			if (ts_array)
+				(*ts_array)[count] = e->ts;
+
+			if (pid_array)
+				(*pid_array)[count] = e->pid;
+
+			if (event_array)
+				(*event_array)[count] = e->event_id;
+
+			rec_list[next_cpu] = rec_list[next_cpu]->next;
+			free(rec);
+		}
+	}
+
+	/* There should be no entries left in rec_list. */
+	free_rec_list(rec_list, n_cpus, type);
+	return total;
+
+ fail_free:
+	free_rec_list(rec_list, n_cpus, type);
+
+ fail:
+	fprintf(stderr, "Failed to allocate memory during data loading.\n");
+	return -ENOMEM;
+}
+
 static const char *kshark_get_latency(struct tep_handle *pe,
 				      struct tep_record *record)
 {
diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
index c218b61..27f7942 100644
--- a/kernel-shark/src/libkshark.h
+++ b/kernel-shark/src/libkshark.h
@@ -149,6 +149,13 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 				 struct tep_record ***data_rows);
 
+size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
+			       uint64_t **offset_array,
+			       uint16_t **cpu_array,
+			       uint64_t **ts_array,
+			       uint16_t **pid_array,
+			       int **event_array);
+
 ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids);
 
 void kshark_close(struct kshark_context *kshark_ctx);
-- 
2.20.1

