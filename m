Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586A1C11F6C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47A416142C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhGBD5T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 23:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235066AbhGBD5S (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 23:57:18 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6234261423;
        Fri,  2 Jul 2021 03:54:46 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lzAGL-000eHH-9C; Thu, 01 Jul 2021 23:54:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v4 4/7] libtracefs: Implement tracefs_get_kprobes()
Date:   Thu,  1 Jul 2021 23:54:40 -0400
Message-Id: <20210702035443.154729-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702035443.154729-1-rostedt@goodmis.org>
References: <20210702035443.154729-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the function tracefs_get_kprobes() that returns a list of kprobes that
are registered. The list contains strings that are of the format
"group/event" (i.e. "kprobes/open"). The last element in the list is a
NULL pointer. In the case that there are no kprobes, the list will return
a single entry of a NULL pointer.

NULL is returned in the case of error (mainly a memory issue, or bad
parsing).

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h     |  1 +
 src/tracefs-kprobes.c | 66 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 64164c8c2b20..5f59c480d572 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -219,4 +219,5 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format);
+char **tracefs_get_kprobes(void);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 4970620b28f2..e875d6e8a65f 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -103,3 +103,69 @@ int tracefs_kretprobe_raw(const char *system, const char *event,
 {
 	return insert_kprobe("r", system, event, addr, format);
 }
+
+/**
+ * tracefs_get_kprobes - return a list kprobes (by group/event name)
+ *
+ * Returns a list of strings that contain the kprobes that exist
+ * in the kprobe_events files. The strings returned are in the
+ * "group/event" format.
+ * The list must be freed with tracefs_list_free().
+ * If there are no kprobes, a list is still returned, but it contains
+ * only a NULL pointer.
+ * On error, NULL is returned.
+ */
+char **tracefs_get_kprobes(void)
+{
+	char **list = NULL;
+	char *content;
+	char *saveptr;
+	char *event;
+	char *p;
+	int cnt = 0;
+
+	content = tracefs_instance_file_read(NULL, KPROBE_EVENTS, NULL);
+	if (!content)
+		return NULL;
+
+	p = strtok_r(content, ":", &saveptr);
+
+	while (p) {
+		char **tmp;
+
+		/* Failed parsing always return a failure */
+		p = strtok_r(NULL, " ", &saveptr);
+		if (!p)
+			break;
+
+		event = strdup(p);
+		if (!event)
+			goto fail;
+
+		tmp = realloc(list, sizeof(*list) * (cnt + 2));
+		if (!tmp)
+			goto fail;
+
+		list = tmp;
+		list[cnt++] = event;
+		list[cnt] = NULL;
+
+		p = strtok_r(NULL, "\n", &saveptr);
+		/* Could be end of content */
+		if (!p)
+			break;
+
+		/* p is NULL on end of content */
+		p = strtok_r(NULL, ":", &saveptr);
+	}
+
+	if (!list)
+		list = calloc(1, sizeof(*list));
+ out:
+	free(content);
+	return list;
+ fail:
+	free(list);
+	list = NULL;
+	goto out;
+}
-- 
2.30.2

