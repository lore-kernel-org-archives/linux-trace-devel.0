Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E744C11F66
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 03:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B92561CBE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 03:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhGGDNx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 23:13:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230038AbhGGDNw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 23:13:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C123361CAD;
        Wed,  7 Jul 2021 03:11:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m0xxv-00130Z-L4; Tue, 06 Jul 2021 23:11:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/4] libtracefs: Implement functions to work on event directory files
Date:   Tue,  6 Jul 2021 23:11:08 -0400
Message-Id: <20210707031110.249759-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210707031110.249759-1-rostedt@goodmis.org>
References: <20210707031110.249759-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the following functions:

 tracefs_event_get_file() to easily put together a path to a file in the
            event directory.

 tracefs_event_file_read() to easily read the content from a file in the
            event directory.

 tracefs_event_file_write() to easily write content to a file in the
            event directory.

 tracefs_event_file_append() to easily append content to a file in the
            event directory.

 tracefs_event_file_clear() to easily clear the content of a file in the
            event directory.

 tracefs_event_file_exists() to easily know if a file exists in the
            event directory.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h    |  19 +++++
 src/tracefs-events.c | 182 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 201 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 6b9a76c4c40a..afbfd4eb01d6 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -102,6 +102,25 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 				void *callback_context);
 void tracefs_iterate_stop(struct tracefs_instance *instance);
 
+char *tracefs_event_get_file(struct tracefs_instance *instance,
+			     const char *system, const char *event,
+			     const char *file);
+char *tracefs_event_file_read(struct tracefs_instance *instance,
+			      const char *system, const char *event,
+			      const char *file, int *psize);
+int tracefs_event_file_write(struct tracefs_instance *instance,
+			     const char *system, const char *event,
+			     const char *file, const char *str);
+int tracefs_event_file_append(struct tracefs_instance *instance,
+			      const char *system, const char *event,
+			      const char *file, const char *str);
+int tracefs_event_file_clear(struct tracefs_instance *instance,
+			     const char *system, const char *event,
+			     const char *file);
+bool tracefs_event_file_exists(struct tracefs_instance *instance,
+			       const char *system, const char *event,
+			       const char *file);
+
 char **tracefs_tracers(const char *tracing_dir);
 
 struct tep_handle *tracefs_local_events(const char *tracing_dir);
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 4bfd8e451ef5..7febc2a0f24d 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -302,6 +302,188 @@ __hidden char *trace_append_file(const char *dir, const char *name)
 	return ret < 0 ? NULL : file;
 }
 
+static int event_file(char **path, const char *system,
+		      const char *event, const char *file)
+{
+	if (!system || !event || !file)
+		return -1;
+
+	return asprintf(path, "events/%s/%s/%s",
+			system, event, file);
+}
+
+/**
+ * tracefs_event_get_file - return a file in an event directory
+ * @instance: The instance the event is in (NULL for top level)
+ * @system: The system name that the event file is in
+ * @event: The event name of the event
+ * @file: The name of the file in the event directory.
+ *
+ * Returns a path to a file in the event director.
+ * or NULL on error. The path returned must be freed with
+ * tracefs_put_tracing_file().
+ */
+char *tracefs_event_get_file(struct tracefs_instance *instance,
+			     const char *system, const char *event,
+			     const char *file)
+{
+	char *instance_path;
+	char *path;
+	int ret;
+
+	ret = event_file(&path, system, event, file);
+	if (ret < 0)
+		return NULL;
+
+	instance_path = tracefs_instance_get_file(instance, path);
+	free(path);
+
+	return instance_path;
+}
+
+/**
+ * tracefs_event_file_read - read the content from an event file
+ * @instance: The instance the event is in (NULL for top level)
+ * @system: The system name that the event file is in
+ * @event: The event name of the event
+ * @file: The name of the file in the event directory.
+ * @psize: the size of the content read.
+ *
+ * Reads the content of the event file that is passed via the
+ * arguments and returns the content.
+ *
+ * Return a string containing the content of the file or NULL
+ * on error. The string returned must be freed with free().
+ */
+char *tracefs_event_file_read(struct tracefs_instance *instance,
+			      const char *system, const char *event,
+			      const char *file, int *psize)
+{
+	char *content;
+	char *path;
+	int ret;
+
+	ret = event_file(&path, system, event, file);
+	if (ret < 0)
+		return NULL;
+
+	content = tracefs_instance_file_read(instance, path, psize);
+	free(path);
+	return content;
+}
+
+/**
+ * tracefs_event_file_write - write to an event file
+ * @instance: The instance the event is in (NULL for top level)
+ * @system: The system name that the event file is in
+ * @event: The event name of the event
+ * @file: The name of the file in the event directory.
+ * @str: The string to write into the file
+ *
+ * Writes the content of @str to a file in the instance directory.
+ * The content of the file will be overwritten by @str.
+ *
+ * Return 0 on success, and -1 on error.
+ */
+int tracefs_event_file_write(struct tracefs_instance *instance,
+			     const char *system, const char *event,
+			     const char *file, const char *str)
+{
+	char *path;
+	int ret;
+
+	ret = event_file(&path, system, event, file);
+	if (ret < 0)
+		return -1;
+
+	ret = tracefs_instance_file_write(instance, path, str);
+	free(path);
+	return ret;
+}
+
+/**
+ * tracefs_event_file_append - write to an event file
+ * @instance: The instance the event is in (NULL for top level)
+ * @system: The system name that the event file is in
+ * @event: The event name of the event
+ * @file: The name of the file in the event directory.
+ * @str: The string to write into the file
+ *
+ * Writes the content of @str to a file in the instance directory.
+ * The content of @str will be appended to the content of the file.
+ * The current content should not be lost.
+ *
+ * Return 0 on success, and -1 on error.
+ */
+int tracefs_event_file_append(struct tracefs_instance *instance,
+			      const char *system, const char *event,
+			      const char *file, const char *str)
+{
+	char *path;
+	int ret;
+
+	ret = event_file(&path, system, event, file);
+	if (ret < 0)
+		return -1;
+
+	ret = tracefs_instance_file_append(instance, path, str);
+	free(path);
+	return ret;
+}
+
+/**
+ * tracefs_event_file_clear - clear an event file
+ * @instance: The instance the event is in (NULL for top level)
+ * @system: The system name that the event file is in
+ * @event: The event name of the event
+ * @file: The name of the file in the event directory.
+ *
+ * Clears the content of the event file. That is, it is opened
+ * with O_TRUNC and then closed.
+ *
+ * Return 0 on success, and -1 on error.
+ */
+int tracefs_event_file_clear(struct tracefs_instance *instance,
+			     const char *system, const char *event,
+			     const char *file)
+{
+	char *path;
+	int ret;
+
+	ret = event_file(&path, system, event, file);
+	if (ret < 0)
+		return -1;
+
+	ret = tracefs_instance_file_clear(instance, path);
+	free(path);
+	return ret;
+}
+
+/**
+ * tracefs_event_file_exits - test if a file exists
+ * @instance: The instance the event is in (NULL for top level)
+ * @system: The system name that the event file is in
+ * @event: The event name of the event
+ * @file: The name of the file in the event directory.
+ *
+ * Return true if the file exists, false if it odes not or
+ * an error occurred.
+ */
+bool tracefs_event_file_exists(struct tracefs_instance *instance,
+			       const char *system, const char *event,
+			       const char *file)
+{
+	char *path;
+	bool ret;
+
+	if (event_file(&path, system, event, file) < 0)
+		return false;
+
+	ret = tracefs_file_exists(instance, path);
+	free(path);
+	return ret;
+}
+
 /**
  * tracefs_event_systems - return list of systems for tracing
  * @tracing_dir: directory holding the "events" directory
-- 
2.30.2

