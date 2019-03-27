Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4829C4360F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 16:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EB4620700
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 16:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbfC0QDs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 12:03:48 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34607 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbfC0QDs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 12:03:48 -0400
Received: by mail-pf1-f193.google.com with SMTP id b3so8550169pfd.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Mar 2019 09:03:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S4vA5wGkuKQVJQjjTTVBOBVpJVgygzrAd4O1sEikO9o=;
        b=mCpAuuFZ4wRXkHwgsmCuPhBYHOTCq+0dBiqFj2rGKTSYZzlTDRWGCEy/CU9Mo6KaMe
         S/Ij4gNvXAnzrQJtI8PTzN8V1ZT46VPDKevDZheL/uyxJdi5KqwBIeFs0Tsj9RvGO+yP
         bkrRQFnU7XW5sQIwKrWoGFJuaDaQTJSC4egHpMM9clQOL5CMzAYoHUH62RdNdNPujO41
         O0xkoIYMMJT/9dv6OpErq0j8F8w2QyHH9HU4Bw+5SObIdYeFsRUHP9/UCwWywo4mfzxc
         57Nglb6bHHxA0XL0g6MqnLLH+nvZcG6e+qLpo4CG4IdpEaXgxUpFEOvXoW56EcYnr3dG
         jQ7Q==
X-Gm-Message-State: APjAAAWDXh7F7JQIk3NPLjUVGJS93RMGjtqvpV3z3PwLXckKAgRcY7YA
        wjkgPotfLB72eHHeEMN1taA=
X-Google-Smtp-Source: APXvYqx3rvZC5ySmfbKGti36DwCN23zJOIpqOr4fILagvVzvP21mxEqi17hpO//+dSG1WPb915SOIg==
X-Received: by 2002:a62:174c:: with SMTP id 73mr36156740pfx.33.1553702627345;
        Wed, 27 Mar 2019 09:03:47 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id p88sm36150806pfa.80.2019.03.27.09.03.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Mar 2019 09:03:46 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: [RFC 2/7] kernel-shark: Add new dataloading method to be used by the NumPu interface
Date:   Wed, 27 Mar 2019 18:03:18 +0200
Message-Id: <20190327160323.31654-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327160323.31654-1-ykaradzhov@vmware.com>
References: <20190327160323.31654-1-ykaradzhov@vmware.com>
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
 kernel-shark/src/libkshark.c | 128 +++++++++++++++++++++++++++++++++++
 kernel-shark/src/libkshark.h |   7 ++
 2 files changed, 135 insertions(+)

diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index a886f80..20b1594 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -959,6 +959,134 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 	return -ENOMEM;
 }
 
+static bool data_matrix_alloc(size_t n_rows, uint64_t **offset_array,
+					     uint8_t **cpu_array,
+					     uint64_t **ts_array,
+					     uint16_t **pid_array,
+					     int **event_array)
+{
+	if (offset_array) {
+		*offset_array = calloc(n_rows, sizeof(**offset_array));
+		if (!offset_array)
+			goto free_all;
+	}
+
+	if (cpu_array) {
+		*cpu_array = calloc(n_rows, sizeof(**cpu_array));
+		if (!cpu_array)
+			goto free_all;
+	}
+
+	if (ts_array) {
+		*ts_array = calloc(n_rows, sizeof(**ts_array));
+		if (!ts_array)
+			goto free_all;
+	}
+
+	if (pid_array) {
+		*pid_array = calloc(n_rows, sizeof(**pid_array));
+		if (!pid_array)
+			goto free_all;
+	}
+
+	if (event_array) {
+		*event_array = calloc(n_rows, sizeof(**event_array));
+		if (!event_array)
+			goto free_all;
+	}
+
+	return true;
+
+ free_all:
+	fprintf(stderr, "Failed to allocate memory during data loading.\n");
+
+	if (offset_array)
+		free(offset_array);
+
+	if (cpu_array)
+		free(cpu_array);
+
+	if (ts_array)
+		free(ts_array);
+
+	if (pid_array)
+		free(pid_array);
+
+	if (event_array)
+		free(event_array);
+
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
+			       uint8_t **cpu_array,
+			       uint64_t **ts_array,
+			       uint16_t **pid_array,
+			       int **event_array)
+{
+	enum rec_type type = REC_RECORD;
+	struct rec_list **rec_list;
+	struct tep_record *rec;
+	size_t count, total = 0;
+	bool status;
+	int n_cpus;
+
+	total = get_records(kshark_ctx, &rec_list, REC_RECORD);
+	if (total < 0)
+		goto fail;
+
+	status = data_matrix_alloc(total, offset_array,
+					  cpu_array,
+					  ts_array,
+					  pid_array,
+					  event_array);
+	if (!status)
+		goto fail;
+
+	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+
+	for (count = 0; count < total; count++) {
+		int next_cpu;
+
+		next_cpu = pick_next_cpu(rec_list, n_cpus, type);
+		if (next_cpu >= 0) {
+			rec = rec_list[next_cpu]->rec;
+
+			(*offset_array)[count] = rec->offset;
+			(*cpu_array)[count] = rec->cpu;
+			(*ts_array)[count] = rec->ts;
+			(*pid_array)[count] = tep_data_pid(kshark_ctx->pevent, rec);
+			(*event_array)[count] = tep_data_type(kshark_ctx->pevent, rec);
+
+			rec_list[next_cpu] = rec_list[next_cpu]->next;
+		}
+	}
+
+	free_rec_list(rec_list, n_cpus, type);
+
+	return total;
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
index c218b61..92ade41 100644
--- a/kernel-shark/src/libkshark.h
+++ b/kernel-shark/src/libkshark.h
@@ -149,6 +149,13 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 				 struct tep_record ***data_rows);
 
+size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
+			       uint64_t **offset_array,
+			       uint8_t **cpu_array,
+			       uint64_t **ts_array,
+			       uint16_t **pid_array,
+			       int **event_array);
+
 ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids);
 
 void kshark_close(struct kshark_context *kshark_ctx);
-- 
2.19.1

