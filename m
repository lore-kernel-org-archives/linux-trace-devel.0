Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4869C11F65
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 21:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 816AD61476
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 21:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbhF3VUf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 17:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhF3VUf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 17:20:35 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84E626146D
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jun 2021 21:18:05 +0000 (UTC)
Date:   Wed, 30 Jun 2021 17:18:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Implement tracefs_kretprobe_raw()
Message-ID: <20210630171803.3771559c@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
 include/tracefs.h     |  2 ++
 src/tracefs-kprobes.c | 79 ++++++++++++++++++++++++++++++-------------
 2 files changed, 58 insertions(+), 23 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index d7980c7..f9ce077 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -217,6 +217,8 @@ void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
 
 int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
+int tracefs_kretprobe_raw(const char *system, const char *event,
+			  const char *addr, const char *format);
 int tracefs_kprobe_clear(bool force);
 int tracefs_kprobe_clear_probe(const char *system, const char *event, bool force);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 6f3fbac..e1282d5 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -20,6 +20,36 @@
 
 #define KPROBE_EVENTS "kprobe_events"
 
+static int insert_kprobe(const char *type, const char *system,
+			 const char *event, const char *addr,
+			 const char *format)
+{
+	char *str;
+	int ret;
+
+	errno = EBADMSG;
+	if (!addr || !format)
+		return -1;
+
+	if (!event)
+		event = addr;
+
+	if (system)
+		ret = asprintf(&str, "%s:%s/%s %s %s\n",
+			       type, system, event, addr, format);
+	else
+		ret = asprintf(&str, "%s:%s %s %s\n",
+			       type, event, addr, format);
+
+	if (ret < 0)
+		return -1;
+
+	ret = tracefs_instance_file_append(NULL, KPROBE_EVENTS, str);
+	free(str);
+
+	return ret < 0 ? ret : 0;
+}
+
 /**
  * tracefs_kprobe_raw - Create a kprobe using raw format
  * @system: The system name (NULL for the default kprobes)
@@ -43,30 +73,33 @@
 int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format)
 {
-	char *str;
-	int ret;
-
-	errno = EBADMSG;
-	if (!addr || !format)
-		return -1;
-
-	if (!event)
-		event = addr;
-
-	if (system)
-		ret = asprintf(&str, "p:%s/%s %s %s\n",
-			       system, event, addr, format);
-	else
-		ret = asprintf(&str, "p:%s %s %s\n",
-			       event, addr, format);
-
-	if (ret < 0)
-		return -1;
-
-	ret = tracefs_instance_file_append(NULL, KPROBE_EVENTS, str);
-	free(str);
+	return insert_kprobe("p", system, event, addr, format);
+}
 
-	return ret < 0 ? ret : 0;
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
 }
 
 struct instance_list {
-- 
2.31.1

