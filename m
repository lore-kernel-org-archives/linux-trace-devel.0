Return-Path: <SRS0=ZY51=EL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D449DC00A89
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 780CB20825
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:34:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hm5spn72"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730906AbgKEJeH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 04:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730933AbgKEJeG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 04:34:06 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86679C0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Nov 2020 01:34:06 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id a71so790019edf.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Nov 2020 01:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8MWo7Q64odnsI14tOGkCEyEjZEkPhDrxcyT/EFF9qJE=;
        b=hm5spn72Qmkd1A8MUEkh94wVQ9KcdDBFJSHAt4Q0EU4TA1TugwDngOJZv6TcmCeFG2
         0/S0yvuhmyySIwHkjOY0aG862bVESdRNm14YS5bfm/9ZH4eGmIxsQu/cLcs40CDu/l+2
         dbnWm/ppHTav5OmOPFVvgjJ0jWa6GpdXS7KaZmueHODKR/zbmZiOp/kX8RnKFiECxMyS
         mImdW+dRNmUXLwn6CzELGj0vdovDTMUujWM+fZImniPDU4pJ0SehMwXUXhCp7TRuXgXd
         Gy7aB8umQ3uMZy//xwOqdwusKWH/WbQQ9sJJSfxQkUPXzvuFA7YiZ066h3m8hqbdk4sW
         OsOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8MWo7Q64odnsI14tOGkCEyEjZEkPhDrxcyT/EFF9qJE=;
        b=rWN7l1czF9TfJ6jDzY99/SA1seFKhjEV07PJFydqvoUEqEw3SrMfzQfD0BCghOD7g5
         NeUgeLMiiqUK31QW9Z62P229Fxslf2BHqrj/Wr7lYyZSjfpUnDZSWj9h8FFgUUJehsYy
         2bjK1ajmkKIDrl6K8uUmuRwLTJDlmm9ycJk2/MKNcI3tevH+HXGw/rQrJtmCldq70tbX
         2Ao5e/+ZI97rCSk6iWCHlzAx+D9Ftbn1xrsc+I0QkcI4tTdzA/SpHzc5R99zcCJgLYXb
         CcgnRlOtV+/xtQPqUysv08iEiCoN6eVijBCUIJhlAKQI9ouqBDl1X3mnLIZHbyjlx4IL
         +XRg==
X-Gm-Message-State: AOAM531rU/B4gOTdEtzLH9Wjt/mwliXBzudaypfdSn8jHvEhEF2QLuqg
        Cc/GYhuD1LnDuihHfU/j6R/qpaXtEW/Asfdq
X-Google-Smtp-Source: ABdhPJzJaJ4r7KyaziLsmWWLRUqIoZOdsDDCxMGljfL0NZXwkpFWXid5OvN/v1YsKkq3L64SlHhCnw==
X-Received: by 2002:a05:6402:1f1:: with SMTP id i17mr1594330edy.60.1604568845270;
        Thu, 05 Nov 2020 01:34:05 -0800 (PST)
Received: from localhost.localdomain ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 1sm586725ejt.107.2020.11.05.01.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 01:34:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/6] libtracefs: Add new tracefs API tracefs_instances_walk()
Date:   Thu,  5 Nov 2020 11:33:53 +0200
Message-Id: <20201105093354.532742-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201105093354.532742-1-tz.stoyanov@gmail.com>
References: <20201105093354.532742-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The logic for finding all configured ftrace instances is encapuslated in
a new tracefs_instances_walk() API. A user specified callback is
called for each ftrace instance in the system, excpet for the top level
one.
The implementation of "trace-cmd stat" is modified to use the new API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h           |  1 +
 lib/tracefs/include/tracefs-local.h |  1 +
 lib/tracefs/tracefs-events.c        | 14 ++++----
 lib/tracefs/tracefs-instance.c      | 52 +++++++++++++++++++++++++++++
 tracecmd/trace-stat.c               | 52 ++++++++---------------------
 utest/tracefs-utest.c               | 51 ++++++++++++++++++++++++++++
 6 files changed, 125 insertions(+), 46 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index d9ede08c..40781bb2 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -31,6 +31,7 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
 				const char *file, const char *str);
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
 				 char *file, int *psize);
+int tracefs_instances_walk(int (*callback)(const char *, void *), void *context);
 
 bool tracefs_instance_exists(const char *name);
 bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
diff --git a/lib/tracefs/include/tracefs-local.h b/lib/tracefs/include/tracefs-local.h
index fe327a0f..08b67fa9 100644
--- a/lib/tracefs/include/tracefs-local.h
+++ b/lib/tracefs/include/tracefs-local.h
@@ -9,5 +9,6 @@
 /* Can be overridden */
 void warning(const char *fmt, ...);
 int str_read_file(const char *file, char **buffer);
+char *trace_append_file(const char *dir, const char *name);
 
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/lib/tracefs/tracefs-events.c b/lib/tracefs/tracefs-events.c
index 19f98058..60797748 100644
--- a/lib/tracefs/tracefs-events.c
+++ b/lib/tracefs/tracefs-events.c
@@ -210,7 +210,7 @@ static char **add_list_string(char **list, const char *name, int len)
 	return list;
 }
 
-static char *append_file(const char *dir, const char *name)
+char *trace_append_file(const char *dir, const char *name)
 {
 	char *file;
 	int ret;
@@ -265,7 +265,7 @@ const char **tracefs_event_systems(const char *tracing_dir)
 	if (!tracing_dir)
 		return NULL;
 
-	events_dir = append_file(tracing_dir, "events");
+	events_dir = trace_append_file(tracing_dir, "events");
 	if (!events_dir)
 		return NULL;
 
@@ -290,14 +290,14 @@ const char **tracefs_event_systems(const char *tracing_dir)
 		    strcmp(name, "..") == 0)
 			continue;
 
-		sys = append_file(events_dir, name);
+		sys = trace_append_file(events_dir, name);
 		ret = stat(sys, &st);
 		if (ret < 0 || !S_ISDIR(st.st_mode)) {
 			free(sys);
 			continue;
 		}
 
-		enable = append_file(sys, "enable");
+		enable = trace_append_file(sys, "enable");
 
 		ret = stat(enable, &st);
 		if (ret >= 0)
@@ -358,7 +358,7 @@ const char **tracefs_system_events(const char *tracing_dir, const char *system)
 		    strcmp(name, "..") == 0)
 			continue;
 
-		event = append_file(system_dir, name);
+		event = trace_append_file(system_dir, name);
 		ret = stat(event, &st);
 		if (ret < 0 || !S_ISDIR(st.st_mode)) {
 			free(event);
@@ -400,7 +400,7 @@ const char **tracefs_tracers(const char *tracing_dir)
 	if (!tracing_dir)
 		return NULL;
 
-	available_tracers = append_file(tracing_dir, "available_tracers");
+	available_tracers = trace_append_file(tracing_dir, "available_tracers");
 	if (!available_tracers)
 		return NULL;
 
@@ -492,7 +492,7 @@ static int read_header(struct tep_handle *tep, const char *tracing_dir)
 	int len;
 	int ret = -1;
 
-	header = append_file(tracing_dir, "events/header_page");
+	header = trace_append_file(tracing_dir, "events/header_page");
 
 	ret = stat(header, &st);
 	if (ret < 0)
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index 8817a95b..777d5965 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -13,6 +13,7 @@
 #include <errno.h>
 #include <sys/stat.h>
 #include <fcntl.h>
+#include <dirent.h>
 #include <linux/limits.h>
 #include "tracefs.h"
 #include "tracefs-local.h"
@@ -325,3 +326,54 @@ bool tracefs_dir_exists(struct tracefs_instance *instance, char *name)
 {
 	return check_file_exists(instance, name, true);
 }
+
+/**
+ * tracefs_instances_walk - Iterate through all ftrace instances in the system
+ * @callback: user callback, called for each instance. Instance name is passed
+ *	      as input parameter. If the @callback returns non-zero,
+ *	      the iteration stops.
+ * @context: user context, passed to the @callback.
+ *
+ * Returns -1 in case of an error, 0 otherwise.
+ */
+int tracefs_instances_walk(int (*callback)(const char *, void *), void *context)
+{
+	struct dirent *dent;
+	char *path = NULL;
+	DIR *dir = NULL;
+	struct stat st;
+	int fret = -1;
+	int ret;
+
+	path = tracefs_get_tracing_file("instances");
+	if (!path)
+		return -1;
+	ret = stat(path, &st);
+	if (ret < 0 || !S_ISDIR(st.st_mode))
+		goto out;
+
+	dir = opendir(path);
+	if (!dir)
+		goto out;
+	fret = 0;
+	while ((dent = readdir(dir))) {
+		char *instance;
+
+		if (strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0)
+			continue;
+		instance = trace_append_file(path, dent->d_name);
+		ret = stat(instance, &st);
+		free(instance);
+		if (ret < 0 || !S_ISDIR(st.st_mode))
+			continue;
+		if (callback(dent->d_name, context))
+			break;
+	}
+
+out:
+	if (dir)
+		closedir(dir);
+	tracefs_put_tracing_file(path);
+	return fret;
+}
diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 5f79ff8a..e6678eab 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -7,7 +7,6 @@
 #include <sys/stat.h>
 #include <stdlib.h>
 #include <stdio.h>
-#include <dirent.h>
 #include <getopt.h>
 #include <unistd.h>
 #include <fcntl.h>
@@ -140,48 +139,23 @@ static void report_file(struct buffer_instance *instance,
 	free(str);
 }
 
-static void report_instances(void)
+static int report_instance(const char *name, void *data)
 {
-	struct dirent *dent;
-	bool first = true;
-	char *path = NULL;
-	DIR *dir = NULL;
-	struct stat st;
-	int ret;
-
-	path = tracefs_get_tracing_file("instances");
-	if (!path)
-		return;
-	ret = stat(path, &st);
-	if (ret < 0 || !S_ISDIR(st.st_mode))
-		goto out;
-
-	dir = opendir(path);
-	if (!dir)
-		goto out;
-
-	while ((dent = readdir(dir))) {
-		char *instance;
+	bool *first = (bool *)data;
 
-		if (strcmp(dent->d_name, ".") == 0 ||
-		    strcmp(dent->d_name, "..") == 0)
-			continue;
-		instance = append_file(path, dent->d_name);
-		ret = stat(instance, &st);
-		free(instance);
-		if (ret < 0 || !S_ISDIR(st.st_mode))
-			continue;
-		if (first) {
-			first = false;
-			printf("\nInstances:\n");
-		}
-		printf(" %s\n", dent->d_name);
+	if (*first) {
+		*first = false;
+		printf("\nInstances:\n");
 	}
+	printf(" %s\n", name);
+	return 0;
+}
 
-out:
-	if (dir)
-		closedir(dir);
-	tracefs_put_tracing_file(path);
+static void report_instances(void)
+{
+	bool first = true;
+
+	tracefs_instances_walk(report_instance, &first);
 }
 
 struct event_iter *trace_event_iter_alloc(const char *path)
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index e11a0066..04fc8a1b 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -456,6 +456,54 @@ static void test_local_events(void)
 	tracefs_list_free(systems);
 }
 
+struct test_walk_instance {
+	struct tracefs_instance *instance;
+	bool found;
+};
+#define WALK_COUNT 10
+int test_instances_walk_cb(const char *name, void *data)
+{
+	struct test_walk_instance *instances  = (struct test_walk_instance *)data;
+	int i;
+
+	CU_TEST(instances != NULL);
+	CU_TEST(name != NULL);
+
+	for (i = 0; i < WALK_COUNT; i++) {
+		if (!strcmp(name,
+			    tracefs_instance_get_name(instances[i].instance))) {
+			instances[i].found = true;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static void test_instances_walk(void)
+{
+	struct test_walk_instance instances[WALK_COUNT];
+	int i;
+
+	memset(instances, 0, WALK_COUNT * sizeof(struct test_walk_instance));
+	for (i = 0; i < WALK_COUNT; i++) {
+		CU_TEST(tracefs_instance_create(get_rand_str(), &(instances[i].instance)) >= 0);
+	}
+
+	CU_TEST(tracefs_instances_walk(test_instances_walk_cb, instances) == 0);
+	for (i = 0; i < WALK_COUNT; i++) {
+		CU_TEST(instances[i].found);
+		tracefs_instance_destroy(instances[i].instance);
+		instances[i].found = false;
+	}
+
+	CU_TEST(tracefs_instances_walk(test_instances_walk_cb, instances) == 0);
+	for (i = 0; i < WALK_COUNT; i++) {
+		CU_TEST(!instances[i].found);
+		tracefs_instance_free(instances[i].instance);
+	}
+}
+
 static int test_suite_destroy(void)
 {
 	tracefs_instance_destroy(test_instance);
@@ -499,4 +547,7 @@ void test_tracefs_lib(void)
 		    test_tracers);
 	CU_add_test(suite, "tracefs_local events API",
 		    test_local_events);
+	CU_add_test(suite, "tracefs_instances_walk API",
+		    test_instances_walk);
+
 }
-- 
2.28.0

