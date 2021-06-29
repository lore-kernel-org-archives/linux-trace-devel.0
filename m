Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24D2C11F67
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jun 2021 20:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 864DF61D4B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jun 2021 20:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbhF2U5i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Jun 2021 16:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235520AbhF2U5h (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 16:57:37 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7DCC61D05
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Jun 2021 20:55:09 +0000 (UTC)
Date:   Tue, 29 Jun 2021 16:55:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Implement tracefs_error_last/all()
Message-ID: <20210629165508.166371da@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a helper function that will read an instance error_log file, and
either return the entire content of the error log (tracefs_error_all()) or
just the last error (tracefs_error_last()).

Also add tracefs_error_clear() to clear the error log.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h   |   4 ++
 src/tracefs-utils.c | 112 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 447821e..b478684 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -58,6 +58,10 @@ int tracefs_trace_off_fd(int fd);
 int tracefs_event_enable(struct tracefs_instance *instance, const char *system, const char *event);
 int tracefs_event_disable(struct tracefs_instance *instance, const char *system, const char *event);
 
+char *tracefs_error_last(struct tracefs_instance *instance);
+char *tracefs_error_all(struct tracefs_instance *instance);
+int tracefs_error_clear(struct tracefs_instance *instance);
+
 /**
  * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
  * @instance: ftrace instance, can be NULL for the top instance
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 9e37e75..2028bee 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -23,6 +23,8 @@
 #define TRACEFS_PATH "/sys/kernel/tracing"
 #define DEBUGFS_PATH "/sys/kernel/debug"
 
+#define ERROR_LOG "error_log"
+
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
@@ -253,3 +255,113 @@ __hidden int str_read_file(const char *file, char **buffer, bool warn)
 
 	return size;
 }
+
+/**
+ * tracefs_error_all - return the content of the error log
+ * @instance: The instance to read the error log from (NULL for top level)
+ *
+ * Return NULL if the log is empty, or on error (where errno will be
+ * set. Otherwise the content of the entire log is returned in a string
+ * that must be freed with free().
+ */
+char *tracefs_error_all(struct tracefs_instance *instance)
+{
+	char *content;
+	char *path;
+	int size;
+
+	errno = 0;
+
+	path = tracefs_instance_get_file(instance, ERROR_LOG);
+	if (!path)
+		return NULL;
+	size = str_read_file(path, &content, false);
+	tracefs_put_tracing_file(path);
+
+	if (size <= 0)
+		return NULL;
+
+	return content;
+}
+
+enum line_states {
+	START,
+	CARROT,
+};
+
+/**
+ * tracefs_error_last - return the last error logged
+ * @instance: The instance to read the error log from (NULL for top level)
+ *
+ * Return NULL if the log is empty, or on error (where errno will be
+ * set. Otherwise a string containing the content of the last error shown
+* in the log that must be freed with free().
+ */
+char *tracefs_error_last(struct tracefs_instance *instance)
+{
+	enum line_states state = START;
+	char *content;
+	char *ret;
+	bool done = false;
+	int size;
+	int i;
+
+	content = tracefs_error_all(instance);
+	if (!content)
+		return NULL;
+
+	size = strlen(content);
+	if (!size) /* Should never happen */
+		return content;
+
+	for (i = size - 1; i > 0; i--) {
+		switch (state) {
+		case START:
+			if (content[i] == '\n') {
+				/* Remove extra new lines */
+				content[i] = '\0';
+				break;
+			}
+			if (content[i] == '^')
+				state = CARROT;
+			break;
+		case CARROT:
+			if (content[i] == '\n') {
+				/* Remember last new line */
+				size = i;
+				break;
+			}
+			if (content[i] == '^') {
+				/* Go just passed the last newline */
+				i = size + 1;
+				done = true;
+			}
+			break;
+		}
+		if (done)
+			break;
+	}
+
+	if (i) {
+		ret = strdup(content + i);
+		free(content);
+	} else {
+		ret = content;
+	}
+
+	return ret;
+}
+
+/**
+ * tracefs_error_clear - clear the error log of an instance
+ * @instance: The instance to clear (NULL for top level)
+ *
+ * Clear the content of the error log.
+ *
+ * Returns 0 on success, -1 otherwise.
+ */
+int tracefs_error_clear(struct tracefs_instance *instance)
+{
+	return tracefs_instance_file_clear(instance, ERROR_LOG);
+}
+
-- 
2.29.2

