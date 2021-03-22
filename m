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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D917C433E3
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDBC461969
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhCVJ74 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 05:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhCVJ7v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 05:59:51 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC886C061756
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:49 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id ce10so20170022ejb.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=09RpGejqRrze5SeuipDniSUDcgkfl3OwifqJlL8SHX4=;
        b=oUWtQVGD6jGu5sNReRTsdZTkLOCAL+oOASj5aogtr/T2LC+0iVKqIslnlg51xrugNZ
         gzQzKkoLFbOvPKXH4VygcMgkJ+9NZSBE9epm7OgfDQAwIB7xyUE8HF39qw9Fr3VsWBd4
         Yx8x8+Jcdt1hYvkBrAtLYw4EV5TZTsdg1Q3nJf8xFQ6qsIFKEJBXkQMqM+uD8Yl0aG4C
         LaODm7zWKjhu9q4mIjn1dGynAwUVz7aHyhqegy9sM58Ixo8/yUCp+5Ns3FXM7pmX4TlK
         exnYkC0NXbEx/0bUDI/6TuMS5TykFE78bgSthqiMw44PTDl0+zNCljLy2b8Rru+FBetK
         Fi4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=09RpGejqRrze5SeuipDniSUDcgkfl3OwifqJlL8SHX4=;
        b=ZpzjSpVBTBMAs7rRA1HU8W8eLPCOwQS6MW3AXw7VjkpMTczbVqiwylt15gJAX3n7MW
         eUl2jTKwgZz+H8ufoEygGfFwQ1W4RwwceQOHDYRRIWAIrFZ+Ni9T0UXUgkaFzizj/x6Z
         s8X1Cu8aOVVbdyj8B8mdPrP6Wf/d38oNpSK5omg3MBYWwKJKdp3tEvPYQPY3ZNQirj29
         Fa4l2FrHoZfpIgunhqlxY4lufsxjuCl0ymGAB8uZpXArKxKsRGV7quLFeCfdv+YhjIwR
         fMaSNt5voEHyUhqqmh1qzSN9vlApxrr0/RAF7EwqErJKSykqOdM2AL8kCtXo29ln9SIx
         mULA==
X-Gm-Message-State: AOAM532Xnl5jcCUH388h1P1bsGgJNODj6o02lNd6cYEix2jJ41b5rdaS
        lkP+9DOZ5F2E4FUGzmhBHW4=
X-Google-Smtp-Source: ABdhPJyeL6ITNvxAR2nSOwurmIm1+Z49c1b6N+9BP2lbdelKPEfafRaEG8TovdJXSEodsLSRAQy4vA==
X-Received: by 2002:a17:907:9862:: with SMTP id ko2mr17992322ejc.222.1616407188467;
        Mon, 22 Mar 2021 02:59:48 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.02.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:59:47 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 01/18] trace-cmd: Add initial perf interface in trace-cmd library
Date:   Mon, 22 Mar 2021 11:59:28 +0200
Message-Id: <20210322095945.259300-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
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
index 00000000..f3ee692d
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
+	if (perf->mmap)
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

