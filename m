Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5A7C11F6C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A3776141E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbhGBDM7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 23:12:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234827AbhGBDM6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 23:12:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D322961411;
        Fri,  2 Jul 2021 03:10:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lz9ZR-000e8J-LE; Thu, 01 Jul 2021 23:10:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 2/7] libtracefs: Implement tracefs_kprobe_raw()
Date:   Thu,  1 Jul 2021 23:10:17 -0400
Message-Id: <20210702031022.154146-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702031022.154146-1-rostedt@goodmis.org>
References: <20210702031022.154146-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a function to facilitate creating a kprobe event. It has the "raw" in
its name because it still requires knowing the format of the kprobe. But
does handle the kprobe naming better and writing to the kprobe_event file.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h     |  4 +++
 src/Makefile          |  1 +
 src/tracefs-kprobes.c | 74 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+)
 create mode 100644 src/tracefs-kprobes.c

diff --git a/include/tracefs.h b/include/tracefs.h
index a21d2d2f22a6..bc504bcb0188 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -214,4 +214,8 @@ int tracefs_tracer_clear(struct tracefs_instance *instance);
 ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
 ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance, int flags);
 void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
+
+int tracefs_kprobe_raw(const char *system, const char *event,
+		       const char *addr, const char *format);
+
 #endif /* _TRACE_FS_H */
diff --git a/src/Makefile b/src/Makefile
index b4cff07efc50..0697a047f4bc 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -8,6 +8,7 @@ OBJS += tracefs-instance.o
 OBJS += tracefs-events.o
 OBJS += tracefs-tools.o
 OBJS += tracefs-marker.o
+OBJS += tracefs-kprobes.o
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
new file mode 100644
index 000000000000..78548030e5bb
--- /dev/null
+++ b/src/tracefs-kprobes.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2021 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
+ *
+ * Updates:
+ * Copyright (C) 2021, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <dirent.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <limits.h>
+
+#include "tracefs.h"
+#include "tracefs-local.h"
+
+#define KPROBE_EVENTS "kprobe_events"
+
+/**
+ * tracefs_kprobe_raw - Create a kprobe using raw format
+ * @system: The system name (NULL for the default kprobes)
+ * @event: The event to create (NULL to use @addr for the event)
+ * @addr: The function and offset (or address) to insert the probe
+ * @format: The raw format string to define the probe.
+ *
+ * Create a kprobe that will be in the @system group (or kprobes if
+ * @system is NULL). Have the name of @event (or @addr if @event is
+ * NULL). Will be inserted to @addr (function name, with or without
+ * offset, or a address). And the @format will define the raw format
+ * of the kprobe. See the Linux documentation file under:
+ * Documentation/trace/kprobetrace.rst
+ *
+ * Return 0 on success, or -1 on error.
+ *   If the syntex of @format was incorrect, running
+ *   tracefs_error_last(NULL) may show what went wrong.
+ *
+ * errno will be set to EBADMSG if addr or format is NULL.
+ */
+int tracefs_kprobe_raw(const char *system, const char *event,
+		       const char *addr, const char *format)
+{
+	struct stat st;
+	char *str;
+	int ret;
+
+	if (stat(KPROBE_EVENTS, &st) < 0)
+		return -1;
+
+	errno = EBADMSG;
+	if (!addr || !format)
+		return -1;
+
+	if (!event)
+		event = addr;
+
+	if (system)
+		ret = asprintf(&str, "p:%s/%s %s %s\n",
+			       system, event, addr, format);
+	else
+		ret = asprintf(&str, "p:%s %s %s\n",
+			       event, addr, format);
+
+	if (ret < 0)
+		return -1;
+
+	ret = tracefs_instance_file_append(NULL, KPROBE_EVENTS, str);
+	free(str);
+
+	return ret < 0 ? ret : 0;
+}
-- 
2.30.2

