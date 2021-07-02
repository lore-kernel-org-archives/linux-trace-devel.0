Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A623C07E9A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 20:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46EF66142C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 20:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhGBUUE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 16:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232749AbhGBUUD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 16:20:03 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E360B6140E;
        Fri,  2 Jul 2021 20:17:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lzPbN-000i0Q-Pg; Fri, 02 Jul 2021 16:17:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v7 04/10] libtracefs: Implement tracefs_get_kprobes()
Date:   Fri,  2 Jul 2021 16:17:21 -0400
Message-Id: <20210702201727.169080-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702201727.169080-1-rostedt@goodmis.org>
References: <20210702201727.169080-1-rostedt@goodmis.org>
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

tracefs_get_kprobes() takes a type parameter to determine which kprobes to
return:

  TRACEFS_ALL_KPROBES	- return all that are found
  TRACEFS_KPROBE	- return only normal kprobes ("p:")
  TRACEFS_KRETPROBE	- return only kretprobes ("r:")

NULL is returned in the case of error (mainly a memory issue, or bad
parsing).

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h     |  7 ++++
 src/tracefs-kprobes.c | 93 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 64164c8c2b20..e8a2008d9714 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -215,8 +215,15 @@ ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int
 ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance, int flags);
 void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
 
+enum tracefs_kprobe_type {
+	TRACEFS_ALL_KPROBES,
+	TRACEFS_KPROBE,
+	TRACEFS_KRETPROBE,
+};
+
 int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format);
+char **tracefs_get_kprobes(enum tracefs_kprobe_type type);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 4970620b28f2..3bba3683f29b 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -103,3 +103,96 @@ int tracefs_kretprobe_raw(const char *system, const char *event,
 {
 	return insert_kprobe("r", system, event, addr, format);
 }
+
+/**
+ * tracefs_get_kprobes - return a list kprobes (by group/event name)
+ * @type: The type of kprobes to return.
+ *
+ * If @type is TRACEFS_ALL_KPROBES all kprobes in the kprobe_events
+ * are returned. Otherwise if it is TRACEFS_KPROBE, then only
+ * normal kprobes (p:) are returned, or if type is TRACEFS_KRETPROBE
+ * then only kretprobes (r:) are returned.
+ *
+ * Returns a list of strings that contain the kprobes that exist
+ * in the kprobe_events files. The strings returned are in the
+ * "group/event" format.
+ * The list must be freed with tracefs_list_free().
+ * If there are no kprobes, a list is still returned, but it contains
+ * only a NULL pointer.
+ * On error, NULL is returned.
+ */
+char **tracefs_get_kprobes(enum tracefs_kprobe_type type)
+{
+	char **list = NULL;
+	char *content;
+	char *saveptr;
+	char *event;
+	char *p;
+	int cnt = 0;
+
+	errno = 0;
+	content = tracefs_instance_file_read(NULL, KPROBE_EVENTS, NULL);
+	if (!content) {
+		if (errno)
+			return NULL;
+		/* content is NULL on empty file, return an empty list */
+		list = calloc(1, sizeof(*list));
+		return list;
+	}
+
+	p = strtok_r(content, ":", &saveptr);
+
+	while (p) {
+		char **tmp;
+
+		if (type != TRACEFS_ALL_KPROBES) {
+			switch (*p) {
+			case 'p':
+				if (type != TRACEFS_KPROBE)
+					goto next;
+				break;
+			case 'r':
+				if (type != TRACEFS_KRETPROBE)
+					goto next;
+				break;
+			default:
+				goto next;
+			}
+		}
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
+ next:
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

