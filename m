Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF16C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A30120651
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730631AbfDEKOZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 06:14:25 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40342 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730400AbfDEKOZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 06:14:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id z24so6580840wmi.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Apr 2019 03:14:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x2aUn2l83Fgam7I29pdgCJ/ZgIzJ2hmyoGJ360ySsYE=;
        b=XCbiSluI1Nn6AUsswq2/8N/57ASB/wCf5bGzNV9bjs5BnRQolsX0dwaF20+XICj3i5
         FOgsww/Wt/jKGihwky+/HZCDF+hC6X4hianpALQeEw4//kFKR/Wq05WsRjBAX5DXcyGt
         ALXWR2F9uFjaCtplQTNNlzkKyrCCacYsQKy20sZRhfK+g01OPS6qJD8/xEKkldbKlHRm
         3XpQcgzlypSGZmMlFXL9Eh2yKQBSN5AsSMklTNnUqVfKN0T4SMNGwcW5DfORyCB7Em+F
         TSl4HckOJZMP0o3zxjwLKqbCv0VxpM/i7Pjinva2/IPteKwcbUibeo9pmY30F1C1NiFP
         3fDA==
X-Gm-Message-State: APjAAAU9/Ya+L7uIzuHKql1yM0j+jVDO+tihKHTPv7RHvsxUsg7gRxuG
        IB5seDon+3piuoBujmVmY/Yk2bja//I=
X-Google-Smtp-Source: APXvYqwB5LAddQrpLRqz60lvPHe/DA3sWD7eE82YrpX9ZTwRm8ptRJAuKLk39u2mRylWYFqqTpykfg==
X-Received: by 2002:a1c:4e04:: with SMTP id g4mr7527169wmh.127.1554459263029;
        Fri, 05 Apr 2019 03:14:23 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a187sm1851124wma.32.2019.04.05.03.14.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Apr 2019 03:14:22 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [RFC v2 3/6] kernel-shark: Add the core components of the NumPy API
Date:   Fri,  5 Apr 2019 13:14:08 +0300
Message-Id: <20190405101411.25466-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190405101411.25466-1-ykaradzhov@vmware.com>
References: <20190405101411.25466-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The NumPy API is meant to operate on top of the C API-s of trace-cmd and
KernelShark and to provide only the minimum of basic functionalities needed
in order to processor the tracing data. The NumPy API itself is made of two
layers. A bottom-one written in C and a top-one which implements the
interface, written in Cython (C-Python). This patch introduces the C layer.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-py.c | 175 ++++++++++++++++++++++++++++++++
 1 file changed, 175 insertions(+)
 create mode 100644 kernel-shark/src/libkshark-py.c

diff --git a/kernel-shark/src/libkshark-py.c b/kernel-shark/src/libkshark-py.c
new file mode 100644
index 0000000..a1dd450
--- /dev/null
+++ b/kernel-shark/src/libkshark-py.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2019 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+ /**
+ *  @file    libkshark-py.c
+ *  @brief   Python API for processing of FTRACE (trace-cmd) data.
+ */
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-model.h"
+
+bool kspy_open(const char *fname)
+{
+	struct kshark_context *kshark_ctx = NULL;
+
+	if (!kshark_instance(&kshark_ctx))
+		return false;
+
+	return kshark_open(kshark_ctx, fname);
+}
+
+void kspy_close(void)
+{
+	struct kshark_context *kshark_ctx = NULL;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	kshark_close(kshark_ctx);
+	kshark_free(kshark_ctx);
+}
+
+static int compare(const void * a, const void * b)
+{
+  return ( *(int*)a - *(int*)b );
+}
+
+size_t kspy_get_tasks(int **pids, char ***names)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	const char *comm;
+	ssize_t i, n;
+	int ret;
+
+	if (!kshark_instance(&kshark_ctx))
+		return 0;
+
+	n = kshark_get_task_pids(kshark_ctx, pids);
+	if (n == 0)
+		return 0;
+
+	qsort(*pids, n, sizeof(**pids), compare);
+
+	*names = calloc(n, sizeof(char*));
+	if (!(*names))
+		goto fail;
+
+	for (i = 0; i < n; ++i) {
+		comm = tep_data_comm_from_pid(kshark_ctx->pevent, (*pids)[i]);
+		ret = asprintf(&(*names)[i], "%s", comm);
+		if (ret < 1)
+			goto fail;
+	}
+
+	return n;
+
+  fail:
+	free(*pids);
+	free(*names);
+	return 0;
+}
+
+size_t kspy_trace2matrix(uint64_t **offset_array,
+			 uint8_t **cpu_array,
+			 uint64_t **ts_array,
+			 uint16_t **pid_array,
+			 int **event_array)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	size_t total = 0;
+
+	if (!kshark_instance(&kshark_ctx))
+		return false;
+
+	total = kshark_load_data_matrix(kshark_ctx, offset_array,
+					cpu_array,
+					ts_array,
+					pid_array,
+					event_array);
+
+	return total;
+}
+
+int kspy_get_event_id(const char *sys, const char *evt)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct tep_event *event;
+
+	if (!kshark_instance(&kshark_ctx))
+		return -1;
+
+	event = tep_find_event_by_name(kshark_ctx->pevent, sys, evt);
+
+	return event->id;
+}
+
+uint64_t kspy_read_event_field(uint64_t offset, int id, const char *field)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct tep_format_field *evt_field;
+	struct tep_record *record;
+	struct tep_event *event;
+	unsigned long long val;
+	int ret;
+
+	if (!kshark_instance(&kshark_ctx))
+		return 0;
+
+	event = tep_find_event(kshark_ctx->pevent, id);
+	if (!event)
+		return 0;
+
+	evt_field = tep_find_any_field(event, field);
+	if (!evt_field)
+		return 0;
+
+	record = tracecmd_read_at(kshark_ctx->handle, offset, NULL);
+	if (!record)
+		return 0;
+
+	ret = tep_read_number_field(evt_field, record->data, &val);
+	free_record(record);
+
+	if (ret != 0)
+		return 0;
+
+	return val;
+}
+
+void kspy_new_session_file(const char *data_file, const char *session_file)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct kshark_trace_histo histo;
+	struct kshark_config_doc *session;
+	struct kshark_config_doc *filters;
+	struct kshark_config_doc *markers;
+	struct kshark_config_doc *model;
+	struct kshark_config_doc *file;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	session = kshark_config_new("kshark.config.session",
+				    KS_CONFIG_JSON);
+
+	file = kshark_export_trace_file(data_file, KS_CONFIG_JSON);
+	kshark_config_doc_add(session, "Data", file);
+
+	filters = kshark_export_all_filters(kshark_ctx, KS_CONFIG_JSON);
+	kshark_config_doc_add(session, "Filters", filters);
+
+	ksmodel_init(&histo);
+	model = kshark_export_model(&histo, KS_CONFIG_JSON);
+	kshark_config_doc_add(session, "Model", model);
+
+	markers = kshark_config_new("kshark.config.markers", KS_CONFIG_JSON);
+	kshark_config_doc_add(session, "Markers", markers);
+
+	kshark_save_config_file(session_file, session);
+	kshark_free_config_doc(session);
+}
-- 
2.19.1

