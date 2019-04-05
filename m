Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042BCC4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D11A620651
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbfDEKOY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 06:14:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38957 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730532AbfDEKOY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 06:14:24 -0400
Received: by mail-wr1-f66.google.com with SMTP id j9so7290413wrn.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Apr 2019 03:14:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w0s6RXdKuB++gDGLAFJEMu4PJF/xmUizO9dB2y2q1LQ=;
        b=Xnvq4WYFFf1BUb21tpJ3x61MoW3zkuzDSHOVOkaT2RcIZ20TTyZvWWg6zvgm1SH3EQ
         7P2wJtQbZZLyqoTqoQmBpYC3BJv65rz3wEQ63Be7gRzYTzHgvdEOzDImcwKZgFM6aeb1
         9B2qgL7thG5KY0yGwIjAJvdRDAtACtg1sLbNrFPl4gbw1PFurk2kZHLJDsYxaUgh3ooc
         IKBwVcPKApG8MgjpRq3v9oELOHBqV5TGm9Nr6oHUhiM+gPELyjlkuMt0DentbeV0Jn3U
         yuxLKpJsiX2p3mCmk1KYuvFpggebqAm2+vRH1XcmbId7QcEV+eUeIitqb+gIM75ioDB7
         uqhg==
X-Gm-Message-State: APjAAAVmhSeVXsGbR/u55yGMSGPAikh5mrI/AebsZEIUsbYqvQvLhc2X
        6O/+8uqCHNG9HYEgzE1sbnM=
X-Google-Smtp-Source: APXvYqwsd3x5cTLcj4WP4f5Tdn9b5qxOCDWROsfD4xIp3BXvjRmk/MrRr60p64bfwrvjjg8r2pPhqg==
X-Received: by 2002:adf:e6c6:: with SMTP id y6mr7949173wrm.225.1554459261877;
        Fri, 05 Apr 2019 03:14:21 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a187sm1851124wma.32.2019.04.05.03.14.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Apr 2019 03:14:21 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [RFC v2 1/6] kernel-shark: Add new dataloading method to be used by the NumPu interface
Date:   Fri,  5 Apr 2019 13:14:06 +0300
Message-Id: <20190405101411.25466-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190405101411.25466-1-ykaradzhov@vmware.com>
References: <20190405101411.25466-1-ykaradzhov@vmware.com>
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
 kernel-shark/src/libkshark.c | 136 +++++++++++++++++++++++++++++++++++
 kernel-shark/src/libkshark.h |   7 ++
 2 files changed, 143 insertions(+)

diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index a886f80..98086a9 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -959,6 +959,142 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
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
+		free(*offset_array);
+
+	if (cpu_array)
+		free(*cpu_array);
+
+	if (ts_array)
+		free(*ts_array);
+
+	if (pid_array)
+		free(*pid_array);
+
+	if (event_array)
+		free(*event_array);
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
+			struct kshark_entry *e = &rec_list[next_cpu]->entry;
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
+			free(e);
+		}
+	}
+
+	free_rec_list(rec_list, n_cpus, type);
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

