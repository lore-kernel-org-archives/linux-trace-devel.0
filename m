Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5991C11F69
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 14:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF9DD61436
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 14:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhGBOZQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 10:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233053AbhGBOZP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 10:25:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B96D461402;
        Fri,  2 Jul 2021 14:22:43 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lzK42-000gg6-Is; Fri, 02 Jul 2021 10:22:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v5 1/7] libtracefs: Implement tracefs_instances()
Date:   Fri,  2 Jul 2021 10:22:36 -0400
Message-Id: <20210702142242.163989-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702142242.163989-1-rostedt@goodmis.org>
References: <20210702142242.163989-1-rostedt@goodmis.org>
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
 src/tracefs-instance.c | 76 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

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
index 2aeb529903bd..ba7667349be2 100644
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
@@ -630,6 +631,81 @@ out:
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
+	instances = realloc(list->list, sizeof(*instances) * (list->size + 2));
+	if (!instances)
+		goto out;
+
+	list->list = instances;
+	instances[list->size] = strdup(name);
+	if (!instances[list->size])
+		goto out;
+
+	list->size++;
+	instances[list->size] = NULL;
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
+		/* No matches should produce an empty list */
+		if (!list.list)
+			list.list = calloc(1, sizeof(*list.list));
+	}
+	return list.list;
+}
+
 /**
  * tracefs_get_clock - Get the current trace clock
  * @instance: ftrace instance, can be NULL for the top instance
-- 
2.30.2

