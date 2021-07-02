Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD01C11F6A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2465961420
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbhGBD5S (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 23:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235054AbhGBD5R (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 23:57:17 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FF5D61422;
        Fri,  2 Jul 2021 03:54:46 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lzAGL-000eHE-8G; Thu, 01 Jul 2021 23:54:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v4 3/7] libtracefs: Implement tracefs_kretprobe_raw()
Date:   Thu,  1 Jul 2021 23:54:39 -0400
Message-Id: <20210702035443.154729-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702035443.154729-1-rostedt@goodmis.org>
References: <20210702035443.154729-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add an interface that is similar to tracefs_kprobe_raw() but creates a
"kretprobe". The difference between a kprobe and a kretprobe is that a
kretprobe comes at the end of a function.

See Documentation/trace/kprobetrace.rst in the Linux kernel source code
for more information. Note, kprobes are started with "p" and kretprobe
lines start with an "r".

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h     |  3 +-
 src/tracefs-kprobes.c | 85 ++++++++++++++++++++++++++++++-------------
 2 files changed, 61 insertions(+), 27 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index bc504bcb0188..64164c8c2b20 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -217,5 +217,6 @@ void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
 
 int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
-
+int tracefs_kretprobe_raw(const char *system, const char *event,
+			  const char *addr, const char *format);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index d50191d55181..4970620b28f2 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -19,28 +19,9 @@
 
 #define KPROBE_EVENTS "kprobe_events"
 
-/**
- * tracefs_kprobe_raw - Create a kprobe using raw format
- * @system: The system name (NULL for the default kprobes)
- * @event: The event to create (NULL to use @addr for the event)
- * @addr: The function and offset (or address) to insert the probe
- * @format: The raw format string to define the probe.
- *
- * Create a kprobe that will be in the @system group (or kprobes if
- * @system is NULL). Have the name of @event (or @addr if @event is
- * NULL). Will be inserted to @addr (function name, with or without
- * offset, or a address). And the @format will define the raw format
- * of the kprobe. See the Linux documentation file under:
- * Documentation/trace/kprobetrace.rst
- *
- * Return 0 on success, or -1 on error.
- *   If the syntex of @format was incorrect, running
- *   tracefs_error_last(NULL) may show what went wrong.
- *
- * errno will be set to EBADMSG if addr or format is NULL.
- */
-int tracefs_kprobe_raw(const char *system, const char *event,
-		       const char *addr, const char *format)
+static int insert_kprobe(const char *type, const char *system,
+			 const char *event, const char *addr,
+			 const char *format)
 {
 	char *str;
 	int ret;
@@ -56,11 +37,11 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 		event = addr;
 
 	if (system)
-		ret = asprintf(&str, "p:%s/%s %s %s\n",
-			       system, event, addr, format);
+		ret = asprintf(&str, "%s:%s/%s %s %s\n",
+			       type, system, event, addr, format);
 	else
-		ret = asprintf(&str, "p:%s %s %s\n",
-			       event, addr, format);
+		ret = asprintf(&str, "%s:%s %s %s\n",
+			       type, event, addr, format);
 
 	if (ret < 0)
 		return -1;
@@ -70,3 +51,55 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 
 	return ret < 0 ? ret : 0;
 }
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
+	return insert_kprobe("p", system, event, addr, format);
+}
+
+/**
+ * tracefs_kretprobe_raw - Create a kretprobe using raw format
+ * @system: The system name (NULL for the default kprobes)
+ * @event: The event to create (NULL to use @addr for the event)
+ * @addr: The function and offset (or address) to insert the retprobe
+ * @format: The raw format string to define the retprobe.
+ *
+ * Create a kretprobe that will be in the @system group (or kprobes if
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
+int tracefs_kretprobe_raw(const char *system, const char *event,
+			  const char *addr, const char *format)
+{
+	return insert_kprobe("r", system, event, addr, format);
+}
-- 
2.30.2

