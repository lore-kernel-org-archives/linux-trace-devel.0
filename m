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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37324C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 128B461A21
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhCYGlc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhCYGlA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:00 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68A5C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:40:59 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v4so1067690wrp.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mrWql2bkv1L+P0BBKY7vCuX2NHh8WUzf7IFlE+FdBVE=;
        b=ZgJoOTOfR2lWLqg6MG6+/z+aGPOZ3tRjx1tIKW10PHSXA4n+urJ4nlUSRWndTQeXRn
         ZyYbtP8NUsXvQxwfXl3M3Z90T+eUId3wV16N6VRY84RTW3lQPgTSSCNa5j5FZVcfCbQD
         rOKwxVWlMHonFnQrgGuHOdblNxbmvZFDvL2ilJJyZXVl7FI90w9G/+qAISYPMaSxTzo5
         z1AZCTNXUtefHUMbQ9JWu/UKZukym+tIMGO+aUGKFaXDERkrnUvNqv19Fy1kAi3ExbCe
         TYQNKXwlgYiNZhQe4hCeBTg3lVS6MET8sAXjuMVNyR2H2wfmXT2296LjMsehvHmhxAeD
         26sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mrWql2bkv1L+P0BBKY7vCuX2NHh8WUzf7IFlE+FdBVE=;
        b=sXoYpei3z/OGlA4NoV+FlZoNywdjlBJ9wIHSooXpM9bX7t9CzORVaDvCwao7uUugdt
         qKa0MmSBVB1Lv1I2jp1KkN3SODLBCmt0IXR3th3tvtk7ltlpQ8Ayh4ymEXEABNi5jDQI
         9vGc9bGVhFfVx77CiSnuhCy5pqeTr7MzQhxFIoJK1FiUIcdS0WrK17qf/BFa0uoGLZ6P
         7qhE7X2Bp1YmMwxmIj+0kkcwdPI4cv99YiAhknO2sFFEuyFb20KPLMnMb12LD08Hdunb
         ygD5RKfKKCcv7M9E836tpRvqdZtvMe7uW/pS2tRHbqsJLeObVVy2PEtF71q1lJ0oeSU2
         I2qg==
X-Gm-Message-State: AOAM533cYI0F1H1trYCqhJsJRMV6XpkbPGOE4pm7dwA0bBA67WruDlrA
        2h3OEPJxKbKeetaOZDiVToF3b7h6mI31dg==
X-Google-Smtp-Source: ABdhPJwG4MirmsYYscDN2a7NZwau9K9pFkhAvQ2CV85i1UuNO85TwCW5LyvU/pXaeXPQlaOQMXttSA==
X-Received: by 2002:a05:6000:1acd:: with SMTP id i13mr7057201wry.48.1616654458342;
        Wed, 24 Mar 2021 23:40:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:40:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 01/23] trace-cmd: Add initial perf interface in trace-cmd library
Date:   Thu, 25 Mar 2021 08:40:33 +0200
Message-Id: <20210325064055.539554-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
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

