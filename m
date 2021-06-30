Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA15C11F6E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 15:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43C8F61477
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 15:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbhF3PuC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 11:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235893AbhF3PuA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 11:50:00 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3040861493;
        Wed, 30 Jun 2021 15:47:31 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lycR0-000XoV-0b; Wed, 30 Jun 2021 11:47:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 1/4] libtracefs: Implement tracefs_instances()
Date:   Wed, 30 Jun 2021 11:47:26 -0400
Message-Id: <20210630154729.129873-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210630154729.129873-1-rostedt@goodmis.org>
References: <20210630154729.129873-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Implement tracefs_instances() that will take a regex (or NULL for all) and
return a list of instances in the system.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h      |  1 +
 src/tracefs-instance.c | 78 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index da8ad4189d4d..a21d2d2f22a6 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -44,6 +44,7 @@ int tracefs_instance_file_read_number(struct tracefs_instance *instance,
 int tracefs_instance_file_open(struct tracefs_instance *instance,
 			       const char *file, int mode);
 int tracefs_instances_walk(int (*callback)(const char *, void *), void *context);
+char **tracefs_instances(const char *regex);
 
 bool tracefs_instance_exists(const char *name);
 bool tracefs_file_exists(struct tracefs_instance *instance, const char *name);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 2aeb529903bd..d833fae0fb0c 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -14,6 +14,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <dirent.h>
+#include <regex.h>
 #include <limits.h>
 #include <pthread.h>
 #include "tracefs.h"
@@ -630,6 +631,83 @@ out:
 	return fret;
 }
 
+static inline bool match(const char *str, regex_t *re)
+{
+	if (!re)
+		return true;
+	return regexec(re, str, 0, NULL, 0) == 0;
+}
+
+struct instance_list {
+	regex_t		*re;
+	char		**list;
+	int		size;
+	int		failed;
+};
+
+static int build_list(const char *name, void *data)
+{
+	struct instance_list *list = data;
+	char **instances;
+	int ret = -1;
+
+	if (!match(name, list->re))
+		return 0;
+
+	instances = realloc(list->list, list->size + 2);
+	if (!instances)
+		goto out;
+
+	list->list = instances;
+	list->list[list->size] = strdup(name);
+	if (!list->list[list->size])
+		goto out;
+
+	list->size++;
+	ret = 0;
+
+ out:
+	list->failed = ret;
+	return ret;
+}
+
+/**
+ * tracefs_instances - return a list of instance names
+ * @regex: A regex of instances to filter on (NULL to match all)
+ *
+ * Returns a list of names of existing instances, that must be
+ * freed with tracefs_list_free(). Note, if there are no matches
+ * then an empty list will be returned (not NULL).
+ * NULL on error.
+ */
+char **tracefs_instances(const char *regex)
+{
+	struct instance_list list = { .re = NULL, .list = NULL };
+	regex_t re;
+	int ret;
+
+	if (regex) {
+		ret = regcomp(&re, regex, REG_ICASE|REG_NOSUB);
+		if (ret < 0)
+			return NULL;
+		list.re = &re;
+	}
+
+	ret = tracefs_instances_walk(build_list, &list);
+	if (ret < 0 || list.failed) {
+		tracefs_list_free(list.list);
+		list.list = NULL;
+	} else {
+		if (!list.list) {
+			/* No matches should produce an empty list */
+			list.list = malloc(sizeof(*list.list));
+			if (list.list)
+				list.list[0] = NULL;
+		}
+	}
+	return list.list;
+}
+
 /**
  * tracefs_get_clock - Get the current trace clock
  * @instance: ftrace instance, can be NULL for the top instance
-- 
2.30.2

