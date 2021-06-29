Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD09C11F68
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jun 2021 20:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFABF61D62
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jun 2021 20:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbhF2U4K (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Jun 2021 16:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235559AbhF2U4J (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 16:56:09 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E306F6128B;
        Tue, 29 Jun 2021 20:53:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lyKjj-000UT9-UJ; Tue, 29 Jun 2021 16:53:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] libtracefs: Implement tracefs_kprobe_clear() to remove all kprobes
Date:   Tue, 29 Jun 2021 16:53:25 -0400
Message-Id: <20210629205326.117059-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210629205326.117059-1-rostedt@goodmis.org>
References: <20210629205326.117059-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

A call to tracefs_kprobe_clear() will attempt to disable all kprobes. If
any kprobe is set, and the @force parameter is set, it will fail with
errno set to EBUSY. If @force is set, then it will attempt to disable all
the defined kprobe events and then clear it.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h     |   2 +-
 src/tracefs-kprobes.c | 136 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 47b05b3f55e7..54c461e85a2b 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -212,5 +212,5 @@ void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
 
 int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
-
+int tracefs_kprobe_clear(bool force);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index e4b28cff9f08..48a4f090f041 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -68,3 +68,139 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 
 	return ret < 0 ? ret : 0;
 }
+
+struct instance_list {
+	struct instance_list	*next;
+	struct tracefs_instance	*instance;
+};
+
+static int disable_events(const char *system, const char *event,
+			  struct instance_list *list)
+{
+	int ret;
+
+	ret = tracefs_event_disable(NULL, system, event);
+	if (ret < 0)
+		return ret;
+
+	while (list) {
+		ret = tracefs_event_disable(list->instance, system, event);
+		if (ret < 0)
+			return ret;
+		list = list->next;
+	}
+
+	return 0;
+}
+
+static int build_instances(const char *name, void *data)
+{
+	struct instance_list ***ptr_next = (struct instance_list ***)data;
+	struct instance_list **next = *ptr_next;
+	struct tracefs_instance *instance;
+	struct instance_list *list;
+
+	instance = tracefs_instance_alloc(NULL, name);
+	if (!instance)
+		return -1;
+
+	list = malloc(sizeof(*list));
+	if (!list) {
+		tracefs_instance_free(instance);
+		return -1;
+	}
+
+	list->instance = instance;
+	list->next = *next;
+	*next = list;
+	*ptr_next = &list->next;
+	return 0;
+}
+
+static void free_instance_list(struct instance_list *list)
+{
+	struct instance_list *n;
+
+	while (list) {
+		n = list->next;
+		tracefs_instance_free(list->instance);
+		free(list);
+		list = n;
+	}
+}
+
+/**
+ * tracefs_kprobe_clear - clear kprobe events
+ * @force: Will attempt to disable all kprobe events and clear them
+ *
+ * Will remove all defined kprobe events. If any of them are enabled,
+ * and @force is not set, then it will error with -1 and errno to be
+ * EBUSY. If @force is set, then it will attempt to disable all the kprobe
+ * events in all instances, and try again.
+ *
+ * Returns zero on success, -1 otherwise.
+ */
+int tracefs_kprobe_clear(bool force)
+{
+	struct instance_list *list = NULL;
+	struct instance_list **plist = &list;
+	char *content;
+	char *saveptr;
+	char *system;
+	char *event;
+	char *p;
+	int ret;
+
+	ret = tracefs_instance_file_clear(NULL, KPROBE_EVENTS);
+	if (!ret)
+		return 0;
+
+	if (!force)
+		return -1;
+
+	/* Attempt to disable all kprobe events */
+	content = tracefs_instance_file_read(NULL, KPROBE_EVENTS, NULL);
+	if (!content)
+		return -1;
+
+	ret = tracefs_instances_walk(build_instances, &plist);
+	if (ret < 0)
+		goto out;
+
+	ret = -1;
+	p = strtok_r(content, ":", &saveptr);
+	if (!p)
+		goto out;
+
+	for (;;) {
+		p = strtok_r(NULL, "/", &saveptr);
+		if (!p)
+			goto out;
+
+		system = p;
+
+		p = strtok_r(NULL," ", &saveptr);
+		if (!p)
+			goto out;
+		event = p;
+
+		if (disable_events(system, event, list) < 0)
+			goto out;
+
+		ret = tracefs_instance_file_clear(NULL, KPROBE_EVENTS);
+		/* On success stop the loop */
+		if (!ret)
+			goto out;
+
+		ret = -1;
+		p = strtok_r(NULL, "\n", &saveptr);
+		if (!p)
+			goto out;
+
+		p = strtok_r(NULL, ":", &saveptr);
+	}
+ out:
+	free(content);
+	free_instance_list(list);
+	return ret;
+}
-- 
2.30.2

