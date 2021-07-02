Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD26C11F68
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D718D61420
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235071AbhGBD5S (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 23:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235055AbhGBD5R (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 23:57:17 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FEDA61413;
        Fri,  2 Jul 2021 03:54:46 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lzAGL-000eHK-9y; Thu, 01 Jul 2021 23:54:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v4 5/7] libtracefs: Implement tracefs_kprobe_clear_all() to remove all kprobes
Date:   Thu,  1 Jul 2021 23:54:41 -0400
Message-Id: <20210702035443.154729-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702035443.154729-1-rostedt@goodmis.org>
References: <20210702035443.154729-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

A call to tracefs_kprobe_clear_all() will attempt to disable all kprobes. If
any kprobe is set, and the @force parameter is set, it will fail with
errno set to EBUSY. If @force is set, then it will attempt to disable all
the defined kprobe events and then clear it.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h     |   1 +
 src/tracefs-kprobes.c | 103 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 5f59c480d572..3b57c596feab 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -220,4 +220,5 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format);
 char **tracefs_get_kprobes(void);
+int tracefs_kprobe_clear_all(bool force);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index e875d6e8a65f..fe61a25baa10 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -169,3 +169,106 @@ char **tracefs_get_kprobes(void)
 	list = NULL;
 	goto out;
 }
+
+struct instance_list {
+	struct instance_list	*next;
+	struct tracefs_instance	*instance;
+};
+
+static void disable_events(const char *system, const char *event,
+			   char **list)
+{
+	struct tracefs_instance *instance;
+	int i;
+
+	/*
+	 * Note, this will not fail even on error.
+	 * That is because even if something fails, it may still
+	 * work enough to clear the kprobes. If that's the case
+	 * the clearing after the loop will succeed and the function
+	 * is a success, even though other parts had failed. If
+	 * one of the kprobe events is enabled in one of the
+	 * instances that fail, then the clearing will fail too
+	 * and the function will return an error.
+	 */
+
+	tracefs_event_disable(NULL, system, event);
+	/* No need to test results */
+
+	if (!list)
+		return;
+
+	for (i = 0; list[i]; i++) {
+		instance = tracefs_instance_alloc(NULL, list[i]);
+		/* If this fails, try the next one */
+		if (!instance)
+			continue;
+		tracefs_event_disable(instance, system, event);
+		tracefs_instance_free(instance);
+	}
+	return;
+}
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
+	char **instance_list;
+	char **kprobe_list;
+	char *saveptr;
+	char *system;
+	char *kprobe;
+	char *event;
+	int ret;
+	int i;
+
+	ret = tracefs_instance_file_clear(NULL, KPROBE_EVENTS);
+	if (!ret)
+		return 0;
+
+	if (!force)
+		return -1;
+
+	kprobe_list = tracefs_get_kprobes();
+	if (!kprobe_list)
+		return -1;
+
+	instance_list = tracefs_instances(NULL);
+	/*
+	 * Even if the above failed and instance_list is NULL,
+	 * keep going, as the enabled event may simply be in the
+	 * top level.
+	 */
+
+	for (i = 0; kprobe_list[i]; i++) {
+		kprobe = kprobe_list[i];
+
+		system = strtok_r(kprobe, "/", &saveptr);
+		if (!system)
+			goto out;
+
+		event = strtok_r(NULL," ", &saveptr);
+		if (!event)
+			goto out;
+
+		disable_events(system, event, instance_list);
+
+		ret = tracefs_instance_file_clear(NULL, KPROBE_EVENTS);
+		/* On success stop the loop */
+		if (!ret)
+			goto out;
+	}
+ out:
+	tracefs_list_free(instance_list);
+	tracefs_list_free(kprobe_list);
+	return ret;
+}
-- 
2.30.2

