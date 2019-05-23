Return-Path: <SRS0=hb2W=TX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B812CC282DD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9739E20665
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731171AbfEWPSp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 May 2019 11:18:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41642 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730741AbfEWPSp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 May 2019 11:18:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id u16so2841599wrn.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 May 2019 08:18:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RfT3uVJbbDvYX1cpJG/6qN0yVgOZWH62ygKrJSonUTQ=;
        b=bMR7hgdJrHi+f0mF+bVSR0pUvQg/dyBMZg/3ITM0ietczzL133pG69rADy0OFN++Kl
         74afpRX8O5zXRxsWPuVQ7ZN3lSx15m/HwbKCD9r+hysyGX46Ur6ChGqi08XmrZSfA+Ih
         3AsvQOPRD8Eujqs1MjLZMLuImoenmp/3JoTTvwFUE2+pHRWEAH74jNsMPZHW5n02TlS/
         7+0eAErp5Bftt3ykwBnpMQMMh3fWVa1zpnUogDwrsn61jMGUyvA+7Ny+7sHIvMlfbKVe
         Q1xzfRO+o4VidD+Nsm3lvq3corf6Q4uEHw3O82/fpfP0pQlMZKXJgZHjlO7+ZOyWZdfO
         ToLA==
X-Gm-Message-State: APjAAAUm5ZkPuyqyimOOyDkNgOA6aRhnOJhOAe0AZySndS8Wb9DOTtDe
        nbu6VWY35t0++E8hy5xwlWTv6yX6
X-Google-Smtp-Source: APXvYqzXnjMJp/2bVEU4XKQ9MSC2UGwQMX+fNuZfZtdS96UMj6Cu9CjBBQBHkU9CLAdtiOZ+G+50rA==
X-Received: by 2002:a5d:45c7:: with SMTP id b7mr37493449wrs.176.1558624722493;
        Thu, 23 May 2019 08:18:42 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x9sm12687071wmf.27.2019.05.23.08.18.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 08:18:42 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/5] kernel-shark: Add new dataloading method to be used by the NumPu interface
Date:   Thu, 23 May 2019 18:18:08 +0300
Message-Id: <20190523151812.31391-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190523151812.31391-1-ykaradzhov@vmware.com>
References: <20190523151812.31391-1-ykaradzhov@vmware.com>
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
 kernel-shark/src/libkshark.c | 155 +++++++++++++++++++++++++++++++++++
 kernel-shark/src/libkshark.h |   7 ++
 2 files changed, 162 insertions(+)

diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 175279c..ac634fd 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -957,6 +957,161 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 	return -ENOMEM;
 }
 
+static bool data_matrix_alloc(size_t n_rows, uint64_t **offset_array,
+					     uint8_t **cpu_array,
+					     uint64_t **ts_array,
+					     uint16_t **pid_array,
+					     int **event_array)
+{
+	if (offset_array)
+		*offset_array = NULL;
+
+	if (cpu_array)
+		*cpu_array = NULL;
+
+	if (ts_array)
+		*ts_array = NULL;
+
+	if (pid_array)
+		*pid_array = NULL;
+
+	if (event_array)
+		*event_array = NULL;
+
+	if (offset_array) {
+		*offset_array = calloc(n_rows, sizeof(**offset_array));
+		if (!*offset_array)
+			goto free_all;
+	}
+
+	if (cpu_array) {
+		*cpu_array = calloc(n_rows, sizeof(**cpu_array));
+		if (!*cpu_array)
+			goto free_all;
+	}
+
+	if (ts_array) {
+		*ts_array = calloc(n_rows, sizeof(**ts_array));
+		if (!*ts_array)
+			goto free_all;
+	}
+
+	if (pid_array) {
+		*pid_array = calloc(n_rows, sizeof(**pid_array));
+		if (!*pid_array)
+			goto free_all;
+	}
+
+	if (event_array) {
+		*event_array = calloc(n_rows, sizeof(**event_array));
+		if (!*event_array)
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
2.20.1

