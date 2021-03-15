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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0632C43333
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACCF964E64
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhCOGS6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbhCOGSi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:18:38 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCB1C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:38 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id e19so64291814ejt.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jitJb1ehxF5eagaw5HDd3rowc0DPUw+8KZGkRm3aCAs=;
        b=ko+HN6zs+GsFxkVtJjtkqLvOJvF2Hr7kkzVuDTNSAYxweTzRYCPx2IYytWVBdw9QPz
         ZcMYWOvZxx/H6BfRhvlY9bB0RgtPbN0x4vSooa97PTiG5MdcSS6Ok8CAcZt9nSDkmQvv
         wMY6KhMjUsQDimmUHnrzW+1YT9yjg9rF5/ZoH29XCYaTpjXzK037c0hSbRCo11Qornic
         UXbJs45LbAfk4Oc7uYHO8baOC/LXHZmIfx+v/u37cjZwn34zXnRK6SfV0C36O0wu6Kqt
         U9qsh3nWIOeX6bkQPRf116FbNsC65DV+yLRltTyZ3nAO5ntTa88HKo4vC++CkwFTgwud
         47KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jitJb1ehxF5eagaw5HDd3rowc0DPUw+8KZGkRm3aCAs=;
        b=CYgDS9UYFI1/OzuD1TOwlB+Eo2fDbtzYFcRPWNp0PjQb71B/0vgBvm+EWmQVeewaHW
         s+u7XavqbtzruRYjwTlQHayewRQwCKHoDMmcVx1z4+PXrA6M7mQl53wNfw3PSoLN/AWj
         ldDFSUNnst0TnclCFZ5uuW0GuxbQiOA/NLaDoXQWIGXFnPZq5t6VjlGdXIcdpdN2fMd9
         bz4nwNzGK1IsmA41dwP9QMD/VhtwumUZhslhfjQzHflXPQAghLThx3DyU3zEQfiwEnBd
         zw9yzn5QQYsrBxwcC6zzodQzbfvGXM5icFhzADq7QbHhPkF1MrVYaZow1PEHMsPuziub
         JK+g==
X-Gm-Message-State: AOAM531Ai8GOSMUbWt23b6ZyPo7x5h165E0LmwPta7zWuvqxSfv8JjtY
        dpqQHAGkP7goJrriNcPAXJQ24C2OrzE16A==
X-Google-Smtp-Source: ABdhPJxEZpMkzuG2GprB38+w4OY28jR+auOdmLDIxcQ3I1ZREHjjg5J9+6EjBts1OjgdMR+b0P7E7Q==
X-Received: by 2002:a17:906:ca02:: with SMTP id jt2mr21744731ejb.312.1615789116898;
        Sun, 14 Mar 2021 23:18:36 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id t6sm7468478edq.48.2021.03.14.23.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:18:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 01/12] trace-cmd: Add initial perf interface in trace-cmd library
Date:   Mon, 15 Mar 2021 08:18:21 +0200
Message-Id: <20210315061832.168495-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315061832.168495-1-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
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
index 2f553ed5..03d1a30c 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -17,6 +17,7 @@ OBJS += trace-util.o
 OBJS += trace-filter-hash.o
 OBJS += trace-msg.o
 OBJS += trace-plugin.o
+OBJS += trace-perf.o
 OBJS += trace-timesync.o
 
 # Additional util objects
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 37c9a82a..27a96c12 100644
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
+int trace_perf_open(struct trace_perf *perf);
+void trace_perf_close(struct trace_perf *perf);
+
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
2.29.2

