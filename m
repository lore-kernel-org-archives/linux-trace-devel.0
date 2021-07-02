Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD698C11F69
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 18:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5DE661429
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 18:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhGBS6x (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 14:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230172AbhGBS6v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 14:58:51 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 990A861427;
        Fri,  2 Jul 2021 18:56:18 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lzOKn-000hgU-ID; Fri, 02 Jul 2021 14:56:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v6 06/10] libtracefs: Implement tracefs_kprobe_info()
Date:   Fri,  2 Jul 2021 14:56:12 -0400
Message-Id: <20210702185616.167778-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702185616.167778-1-rostedt@goodmis.org>
References: <20210702185616.167778-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add tracefs_kprobe_info() that returns the type of a given probe, and may
also return the content of the parsed kprobe_events file.

If @type is non NULL, it will hold the content of the kprobe before the
":'.

If @addr is non NULL, it will hold the content of the kprobe's address or
function that it is attached to.

If @format is non NULL, it will hold the format string of the kprobe.

It returns:

    TRACEFS_ALL_KPROBES if an error occurs or the kprobe is not found,
             or the probe is of an unknown type.
             Having @type set, can help debug an unknown type.
    TRACEFS_KPROBE if the type of kprobe found is a normal kprobe.
    TRACEFS_KRETPROBE if the type of kprobe found is a kretprobe.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h     |  2 ++
 src/tracefs-kprobes.c | 72 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index e8a2008d9714..f0ab7c96e4ab 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -226,4 +226,6 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format);
 char **tracefs_get_kprobes(enum tracefs_kprobe_type type);
+enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *event,
+					     char **type, char **addr, char **format);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 713715e96f4f..5442b6c17638 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -18,6 +18,7 @@
 #include "tracefs-local.h"
 
 #define KPROBE_EVENTS "kprobe_events"
+#define KPROBE_DEFAULT_GROUP "kprobes"
 
 static int insert_kprobe(const char *type, const char *system,
 			 const char *event, const char *addr,
@@ -238,3 +239,74 @@ char **tracefs_get_kprobes(enum tracefs_kprobe_type type)
 	list = NULL;
 	goto out;
 }
+
+/**
+ * tracefs_kprobe_info - return the type of kprobe specified.
+ * @group: The group the kprobe is in (NULL for the default "kprobes")
+ * @event: The name of the kprobe to find.
+ * @type: String to return kprobe type (before ':') NULL to ignore.
+ * @addr: String to return address kprobe is attached to. NULL to ignore.
+ * @format: String to return kprobe format. NULL to ignore.
+ *
+ * If @type, @addr, or @format is non NULL, then the returned string
+ * must be freed with free(). They will also be set to NULL, and
+ * even on error, they may contain strings to be freed. If they are
+ * not NULL, then they still need to be freed.
+ *
+ * Returns TRACEFS_ALL_KPROBES if an error occurs or the kprobe is not found,
+ *            or the probe is of an unknown type.
+ * TRACEFS_KPROBE if the type of kprobe found is a normal kprobe.
+ * TRACEFS_KRETPROBE if the type of kprobe found is a kretprobe.
+ */
+enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *event,
+					     char **type, char **addr, char **format)
+{
+	enum tracefs_kprobe_type rtype = TRACEFS_ALL_KPROBES;
+	char *saveptr;
+	char *content;
+	char *system;
+	char *probe;
+	char *ktype;
+	char *kaddr;
+	char *kfmt;
+	int ret;
+
+	if (!group)
+		group = KPROBE_DEFAULT_GROUP;
+
+	if (type)
+		*type = NULL;
+	if (addr)
+		*addr = NULL;
+	if (format)
+		*format = NULL;
+
+	content = tracefs_instance_file_read(NULL, KPROBE_EVENTS, NULL);
+	if (!content)
+		return rtype;
+
+	ret = parse_kprobe(content, &saveptr, &ktype, &system, &probe,
+			   &kaddr, &kfmt);
+
+	while (!ret) {
+
+		if (!strcmp(system, group) && !strcmp(probe, event)) {
+			if (type)
+				*type = strdup(ktype);
+			if (addr)
+				*addr = strdup(kaddr);
+			if (format)
+				*format = strdup(kfmt);
+
+			switch (*ktype) {
+			case 'p': rtype = TRACEFS_KPROBE; break;
+			case 'r': rtype = TRACEFS_KRETPROBE; break;
+			}
+			break;
+		}
+		ret = parse_kprobe(NULL, &saveptr, &ktype, &system, &probe,
+				   &kaddr, &kfmt);
+	}
+	free(content);
+	return rtype;
+}
-- 
2.30.2

