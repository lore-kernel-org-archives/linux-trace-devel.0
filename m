Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6901EC11F68
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5045F61420
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbhGBD5T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 23:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235017AbhGBD5R (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 23:57:17 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E6476141A;
        Fri,  2 Jul 2021 03:54:46 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lzAGL-000eHN-As; Thu, 01 Jul 2021 23:54:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v4 6/7] libtracefs: Implement tracefs_kprobe_clear_probe()
Date:   Thu,  1 Jul 2021 23:54:42 -0400
Message-Id: <20210702035443.154729-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702035443.154729-1-rostedt@goodmis.org>
References: <20210702035443.154729-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the function tracefs_kprobe_clear_probe() that will remove a single
kprobe. If the @force parameter is set, it will disable that probe in all
instances (including the top level instance) before removing it.

If the @event parameter is NULL, then it will clear all events that are
defined by the @system parameter. If the @system parameter is NULL,
then it will use the default "kprobes" group.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h     |   1 +
 src/tracefs-kprobes.c | 123 +++++++++++++++++++++++++++++++++---------
 2 files changed, 100 insertions(+), 24 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 3b57c596feab..2771fad6d0ef 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -221,4 +221,5 @@ int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format);
 char **tracefs_get_kprobes(void);
 int tracefs_kprobe_clear_all(bool force);
+int tracefs_kprobe_clear_probe(const char *system, const char *event, bool force);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index fe61a25baa10..7ca34fe6c7b7 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -209,18 +209,17 @@ static void disable_events(const char *system, const char *event,
 	return;
 }
 
-/**
- * tracefs_kprobe_clear_all - clear kprobe events
- * @force: Will attempt to disable all kprobe events and clear them
- *
- * Will remove all defined kprobe events. If any of them are enabled,
- * and @force is not set, then it will error with -1 and errno to be
- * EBUSY. If @force is set, then it will attempt to disable all the kprobe
- * events in all instances, and try again.
- *
- * Returns zero on success, -1 otherwise.
- */
-int tracefs_kprobe_clear_all(bool force)
+static int clear_kprobe(const char *system, const char *event)
+{
+	/* '-' + ':' + '/' + '\n' + '\0' = 5 bytes */
+	int len = strlen(system) + strlen(event) + 5;
+	char content[len];
+
+	sprintf(content, "-:%s/%s", system, event);
+	return tracefs_instance_file_append(NULL, KPROBE_EVENTS, content);
+}
+
+static int kprobe_clear_probes(const char *group, bool force)
 {
 	char **instance_list;
 	char **kprobe_list;
@@ -231,13 +230,6 @@ int tracefs_kprobe_clear_all(bool force)
 	int ret;
 	int i;
 
-	ret = tracefs_instance_file_clear(NULL, KPROBE_EVENTS);
-	if (!ret)
-		return 0;
-
-	if (!force)
-		return -1;
-
 	kprobe_list = tracefs_get_kprobes();
 	if (!kprobe_list)
 		return -1;
@@ -249,6 +241,13 @@ int tracefs_kprobe_clear_all(bool force)
 	 * top level.
 	 */
 
+	/*
+	 * If a system is defined, the default is to pass unless
+	 * an event fails to be removed. If a system is not defined,
+	 * the default is to fail, unless all are removed.
+	 */
+	ret = group ? 0 : -1;
+
 	for (i = 0; kprobe_list[i]; i++) {
 		kprobe = kprobe_list[i];
 
@@ -260,15 +259,91 @@ int tracefs_kprobe_clear_all(bool force)
 		if (!event)
 			goto out;
 
-		disable_events(system, event, instance_list);
+		/* Skip if this does not match a given system */
+		if (group && strcmp(system, group) != 0)
+			continue;
 
-		ret = tracefs_instance_file_clear(NULL, KPROBE_EVENTS);
-		/* On success stop the loop */
-		if (!ret)
-			goto out;
+		if (force)
+			disable_events(system, event, instance_list);
+
+		if (group) {
+			ret = clear_kprobe(system, event);
+			if (ret < 0)
+				goto out;
+		} else {
+			ret = tracefs_instance_file_clear(NULL, KPROBE_EVENTS);
+			/* On success stop the loop */
+			if (!ret)
+				goto out;
+		}
+
+		/* Set the default for whether a system is defined or not */
+		ret = group ? 0 : -1;
 	}
  out:
 	tracefs_list_free(instance_list);
 	tracefs_list_free(kprobe_list);
 	return ret;
 }
+
+/**
+ * tracefs_kprobe_clear_all - clear kprobe events
+ * @force: Will attempt to disable all kprobe events and clear them
+ *
+ * Will remove all defined kprobe events. If any of them are enabled,
+ * and @force is not set, then it will error with -1 and errno to be
+ * EBUSY. If @force is set, then it will attempt to disable all the kprobe
+ * events in all instances, and try again.
+ *
+ * Returns zero on success, -1 otherwise.
+ */
+int tracefs_kprobe_clear_all(bool force)
+{
+	if (tracefs_instance_file_clear(NULL, KPROBE_EVENTS) == 0)
+		return 0;
+
+	if (!force)
+		return -1;
+
+	/* Attempt to disable all kprobe events */
+	return kprobe_clear_probes(NULL, force);
+}
+
+/**
+ * tracefs_kprobe_clear_all - clear kprobe events
+ * @system: System to clear (NULL means default)
+ * @event: Name of probe to clear in system (NULL for all probes in system)
+ * @force: Will attempt to disable all kprobe events and clear them
+ *
+ * Will remove the kprobes that match the @system and @event. If @system
+ * is NULL, then "kprobes" is used and will ignore all other system
+ * groups of kprobes. The @event is NULL then all events under the given
+ * @system are removed, otherwise only the event that matches.
+ *
+ * Returns zero on success, -1 otherwise.
+ */
+int tracefs_kprobe_clear_probe(const char *system, const char *event, bool force)
+{
+	char **instance_list;
+	int ret;
+
+	if (!system)
+		system = "kprobes";
+
+	if (!event)
+		return kprobe_clear_probes(system, force);
+
+	/*
+	 * Since we know we are disabling a specific event, try
+	 * to disable it first before clearing it.
+	 */
+	if (force) {
+		instance_list = tracefs_instances(NULL);
+		disable_events(system, event, instance_list);
+		tracefs_list_free(instance_list);
+	}
+
+	ret = clear_kprobe(system, event);
+
+	return ret < 0 ? -1 : 0;
+}
-- 
2.30.2

