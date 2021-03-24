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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CDDC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4B4961A0C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbhCXNEa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbhCXNEX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:23 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8D3C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:22 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v11so24356412wro.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mrWql2bkv1L+P0BBKY7vCuX2NHh8WUzf7IFlE+FdBVE=;
        b=iFaoa6Iu5CGQfJ5sQdQqaTv2VfMI9i9u7eR27t5XLOvt9zBLusDsvx2BTHdGRqytyz
         Y2iN1xO/+No98756T6dou2CNht8dA2fTSAw3Lew/8Z6C+vcat6/33qoboBkszQjRchZl
         Swp9x6qCsIVo0s9ST63oLCOVkZvC4BlG4STcD2V+cvQho22ZGks7YgjaAIkUC4RU79Lm
         FVui9zpRTxuacWh2vjSXlV8V8dcR09k2YV8CY3ESvATD1/3/trHg2bLl6lISPma9b9Gu
         6Lonf1iWuFl8qBwlmXUQ/8m/YDG2zyoO/rYoVRZ6dkfsxSjerZ4L2tdemp8N19j4LCPU
         HqJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mrWql2bkv1L+P0BBKY7vCuX2NHh8WUzf7IFlE+FdBVE=;
        b=mGD5txIQHtBEQyh5STRYdqHtGmbS6UKEnRl7R6D+OLNt/4fx/ZYHeDzlHV7De3663l
         rIT+ZvIexHMFfEjXlhxAiONB16Kch27KBCxVHCx/fiiY3wbKbmElHmM0aQwpQUFU2uIh
         Ayvmy7wo85514oRcX9WJ9hAjLDyJp21PF+MVTekoNtQ9h1AaxPRVSFpO6aKdgoUhXGu6
         CC/npSktRt7cpH+vv5uPdN9r5OrgIwfMmd+YPYaCliembbP/f93Q1YpaXmj9r9lB773+
         Euk+qkHvCGJM6vBq3k8mTNzYyJl4goyFHTaEFeUGOuve8G0Ih5uQspfmr8zIm+tuSoQE
         Hl8Q==
X-Gm-Message-State: AOAM5337gpm2ITqS7AL/wQCLO0VUsDS71EQgx+ZG3USrcLBP9RM6l+zP
        ld8BTrhRbTiChw7mPBmeqT0=
X-Google-Smtp-Source: ABdhPJxpisnOL2Rpw9xzZg+CVnRx7wl5oH3SGnYXgU370o3xxJ7RHmRlmW+uKPNEINFeZfiJN85WAA==
X-Received: by 2002:a5d:6cd2:: with SMTP id c18mr3428594wrc.330.1616591061268;
        Wed, 24 Mar 2021 06:04:21 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 01/23] trace-cmd: Add initial perf interface in trace-cmd library
Date:   Wed, 24 Mar 2021 15:03:56 +0200
Message-Id: <20210324130418.436206-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add new trace-cmd library internal APIs for working with perf. These
initial APIs offer only basic functionality - init, open and close a
perf session:
  trace_perf_init();
  trace_perf_close();
  trace_perf_open();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile                                      |   6 +
 lib/trace-cmd/Makefile                        |   3 +
 .../include/private/trace-cmd-private.h       |  17 +++
 lib/trace-cmd/trace-perf.c                    | 105 ++++++++++++++++++
 4 files changed, 131 insertions(+)
 create mode 100644 lib/trace-cmd/trace-perf.c

diff --git a/Makefile b/Makefile
index fae43ff8..1c684af8 100644
--- a/Makefile
+++ b/Makefile
@@ -298,6 +298,12 @@ ifeq ($(VSOCK_DEFINED), 1)
 CFLAGS += -DVSOCK
 endif
 
+PERF_DEFINED := $(shell if (echo "$(pound)include <linux/perf_event.h>" | $(CC) -E - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+export PERF_DEFINED
+ifeq ($(PERF_DEFINED), 1)
+CFLAGS += -DPERF
+endif
+
 CUNIT_INSTALLED := $(shell if (printf "$(pound)include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -o /dev/null -x c - -lcunit >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
 export CUNIT_INSTALLED
 
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 2f553ed5..aa92c8c0 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -17,6 +17,9 @@ OBJS += trace-util.o
 OBJS += trace-filter-hash.o
 OBJS += trace-msg.o
 OBJS += trace-plugin.o
+ifeq ($(PERF_DEFINED), 1)
+OBJS += trace-perf.o
+endif
 OBJS += trace-timesync.o
 
 # Additional util objects
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 6b32ce58..27f4c9c3 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -512,5 +512,22 @@ void *tracecmd_record_page(struct tracecmd_input *handle,
 			   struct tep_record *record);
 void *tracecmd_record_offset(struct tracecmd_input *handle,
 			     struct tep_record *record);
+#ifdef PERF
+
+#include <linux/perf_event.h>
+
+/* trace-cmd Perf */
+struct trace_perf {
+	int fd;
+	int cpu;
+	int pid;
+	int pages;
+	struct perf_event_attr pe;
+	struct perf_event_mmap_page *mmap;
+};
+int trace_perf_init(struct trace_perf *perf, int pages, int cpu, int pid);
+int trace_perf_open(struct trace_perf *perf);
+void trace_perf_close(struct trace_perf *perf);
+#endif
 
 #endif /* _TRACE_CMD_PRIVATE_H */
diff --git a/lib/trace-cmd/trace-perf.c b/lib/trace-cmd/trace-perf.c
new file mode 100644
index 00000000..2a24a244
--- /dev/null
+++ b/lib/trace-cmd/trace-perf.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2021, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <sys/mman.h>
+
+#include "trace-cmd-private.h"
+
+static void default_perf_init_pe(struct perf_event_attr *pe)
+{
+	pe->type = PERF_TYPE_SOFTWARE;
+	pe->sample_type = PERF_SAMPLE_CPU;
+	pe->size = sizeof(struct perf_event_attr);
+	pe->config = PERF_COUNT_HW_CPU_CYCLES;
+	pe->disabled = 1;
+	pe->exclude_kernel = 1;
+	pe->freq = 1;
+	pe->sample_freq = 1000;
+	pe->inherit = 1;
+	pe->mmap = 1;
+	pe->comm = 1;
+	pe->task = 1;
+	pe->precise_ip = 1;
+	pe->sample_id_all = 1;
+	pe->read_format = PERF_FORMAT_ID |
+			PERF_FORMAT_TOTAL_TIME_ENABLED |
+			PERF_FORMAT_TOTAL_TIME_RUNNING;
+}
+
+/**
+ * trace_perf_init - Initialize perf context
+ *
+ * @perf: structure, representing perf context, that will be initialized.
+ * @pages: Number of perf memory mapped pages.
+ * @cpu: CPU number, associated with this perf context.
+ * @pid: PID, associated with this perf context.
+ *
+ * The perf context in initialized with default values. The caller can set
+ * custom perf parameters in perf->pe, before calling trace_perf_open() API.
+ *
+ * Returns 0 on success, or -1 in case of an error.
+ *
+ */
+int trace_perf_init(struct trace_perf *perf, int pages, int cpu, int pid)
+{
+	if (!perf)
+		return -1;
+
+	memset(perf, 0, sizeof(struct trace_perf));
+	default_perf_init_pe(&perf->pe);
+	perf->cpu = cpu;
+	perf->pages = pages;
+	perf->pid = pid;
+	perf->fd = -1;
+
+	return 0;
+}
+
+/**
+ * trace_perf_close - Close perf session
+ *
+ * @perf: structure, representing context of a running perf session, opened
+ *	  with trace_perf_open()
+ *
+ */
+void trace_perf_close(struct trace_perf *perf)
+{
+	if (perf->fd >= 0)
+		close(perf->fd);
+	perf->fd = -1;
+	if (perf->mmap && perf->mmap != MAP_FAILED)
+		munmap(perf->mmap, (perf->pages + 1) * getpagesize());
+	perf->mmap = NULL;
+}
+
+/**
+ * trace_perf_open - Open perf session
+ *
+ * @perf: structure, representing perf context that will be opened. It must be
+ *	  initialized with trace_perf_init().
+ *
+ * Returns 0 on success, or -1 in case of an error. In case of success, the
+ * session must be closed with trace_perf_close()
+ */
+int trace_perf_open(struct trace_perf *perf)
+{
+	perf->fd = syscall(__NR_perf_event_open, &perf->pe, perf->pid, perf->cpu, -1, 0);
+	if (perf->fd < 0)
+		return -1;
+	fcntl(perf->fd, F_SETFL, O_NONBLOCK);
+
+	perf->mmap = mmap(NULL, (perf->pages + 1) * getpagesize(),
+			  PROT_READ | PROT_WRITE, MAP_SHARED, perf->fd, 0);
+	if (perf->mmap == MAP_FAILED)
+		goto error;
+
+	return 0;
+
+error:
+	trace_perf_close(perf);
+	return -1;
+}
-- 
2.30.2

