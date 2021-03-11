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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB68C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE56064FAA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbhCKItS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhCKItP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 03:49:15 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDF3C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:15 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id h10so1527386edt.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GvCw2kCrHaFZU+7kJo7HSqTgG1Tcbm1RRAcazhN8K0w=;
        b=jrhNHc6LjWkTEE1UzMRGV/WNPFYO/B4DQqPzAF7hdQqd4g81dZvPkfnWxFNXwa8cnN
         CDlmmyBV9IVHH3t6lrhcE2ijdzqT+hiUVjjLFlcDWASOFGAmUJFKadtCSb6xhfXKA/S+
         pvjbXabzG92tu5z+Iyucb1rr8U8p4pWl1CfiBmkNAuY5QD4gNo6hhI8Rg0bBx4gmrhvm
         3FGYLvwOCL4tYf/ijnZfORZrgUCksM3OS7B/yfJvjlJtSjzMbDY0IeygHPJeMoriVVNb
         AlBeDc9XqWR90xjQkpYPcL0vOsV6wc/3NFHL778E+HDIQ9X56wOG7AeYuyGJzmhpGpq6
         RMBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GvCw2kCrHaFZU+7kJo7HSqTgG1Tcbm1RRAcazhN8K0w=;
        b=Ys7tB4bQ5/dtymqB9nsbBXF7ZPADhVMf9aNn8ziD1bLI/rUUF6NJ5Za+TCwgnjfhlX
         HwAcOD/rmDy8/sVcphKUi8R62m6Ib7ZLhQ+JbMg4L9B8mNLAL9+FR31wVf06F6IGchmX
         3c/h9ObMA0Ug0ps2iMUSKVfYLAOv/DfBDDdY37sdRLPSMlpoP43xhMTBG30gpUg4tDWZ
         Cj9u/uhq8WRoQzzYDMC1Io87dJw1omU7NKGSbM+JJjo9LbfSZoubKBJ9aVra+d7XyP4O
         SEHbAnzGK3jgGJ/BysKqt54vCQxD2NVT/OYq8JAZSkBxJemLwJRhJ/9oO9PDS4yeqC1y
         m4bA==
X-Gm-Message-State: AOAM530Kn8i5sPFXWJjGL9ecYIuev99QpjKtjnlFHxvKTovItNUeFBYG
        cZtkBNL50Uk9RkXiGfvCyQI=
X-Google-Smtp-Source: ABdhPJzBWDU8MaVGL2Yhpvwdpl8s1JPYRfJrvR/p0b8YgjoyaUZsDKzYYLzhMVjzDK0xitvwT5dLrg==
X-Received: by 2002:aa7:d416:: with SMTP id z22mr7342916edq.239.1615452553927;
        Thu, 11 Mar 2021 00:49:13 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id fi11sm901647ejb.73.2021.03.11.00.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 00:49:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v31 08/16] trace-cmd: Add initial perf interface in trace-cmd library
Date:   Thu, 11 Mar 2021 10:48:49 +0200
Message-Id: <20210311084857.1919805-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
References: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/Makefile                        |   1 +
 .../include/private/trace-cmd-private.h       |  14 +++
 lib/trace-cmd/trace-perf.c                    | 105 ++++++++++++++++++
 3 files changed, 120 insertions(+)
 create mode 100644 lib/trace-cmd/trace-perf.c

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index b1a07a04..ada65c44 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -18,6 +18,7 @@ OBJS += trace-filter-hash.o
 OBJS += trace-msg.o
 OBJS += trace-plugin.o
 OBJS += trace-timesync.o
+OBJS += trace-perf.o
 ifeq ($(VSOCK_DEFINED), 1)
 OBJS += trace-timesync-ptp.o
 OBJS += trace-timesync-kvm.o
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index cef8f645..0f682c18 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -8,6 +8,7 @@
 
 #include <fcntl.h> /* for iovec */
 #include <sys/types.h>
+#include <linux/perf_event.h> /* for perf types */
 #include "traceevent/event-parse.h"
 #include "trace-cmd/trace-cmd.h"
 
@@ -513,4 +514,17 @@ void *tracecmd_record_page(struct tracecmd_input *handle,
 void *tracecmd_record_offset(struct tracecmd_input *handle,
 			     struct tep_record *record);
 
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
+void trace_perf_close(struct trace_perf *perf);
+int trace_perf_open(struct trace_perf *perf);
+
 #endif /* _TRACE_CMD_PRIVATE_H */
diff --git a/lib/trace-cmd/trace-perf.c b/lib/trace-cmd/trace-perf.c
new file mode 100644
index 00000000..cd61794f
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
+			PERF_FORMAT_TOTAL_TIME_ENABLED|
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
2.29.2

