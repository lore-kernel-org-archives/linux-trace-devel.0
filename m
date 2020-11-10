Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EDFEC388F7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F03C6206B6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:23:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T4hX8ApS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgKJMXA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Nov 2020 07:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730299AbgKJMXA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 07:23:00 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5BFC0613D1
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Nov 2020 04:22:59 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id t9so9103807edq.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Nov 2020 04:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cfn963nJpA6E9tfpm0TcCK0uMckilv0ho0usJvczeUs=;
        b=T4hX8ApSvnsj8rZ1CiImYa5xXqApRfDFDYxqcoln97GvTp7FXQtIvx0XQNQgrVD+gU
         Gk/Ncdevg/Boti76cNCp4LCg5Z/kLTzbA8ZzPhtqwj3fyh1RaY0r1QUzwMQ6ZHLjdjeE
         ji2CjBiyOyaGNHiQC4sO3d1pfdLKscLYR0UOPUbfn4ebXO6euaBBcW/MsfokJYkxZ2kC
         LFRlDxJuyqw05KkccCgl59x9vQTnhBCU8Ihs21FfQybznXnzuetHBeJRM+KtnCD4kxIf
         PswRCjgdb9PQ8GtekiXD4rbklXo8iiYFQ97BnN54bXkYkAY75KDwjV8wAi68XZbTj5Fp
         wijQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cfn963nJpA6E9tfpm0TcCK0uMckilv0ho0usJvczeUs=;
        b=eA+pS092i1ppblOQ21lH5KIMF3h4U8N51/PQ0AAh9jF4aCac9j2Yn3yv8iX4nR4Vsg
         b5JdpbNekcMFRMmvrxAZdDa0VFYLlTwlfm2c/Psl7VoFbxF3uXvXzeaK/AtrM+8vdJRz
         7H1QPls6JNSpdLkoLXV7u5eeKoGqRNK3K8ZFX+a+vwQdn9E9TRZEHh3umktc5lHxOugi
         fWn0/jCdUGl8lhpAhj4ZqunTczLnDTDIPyni+IyoEHl7Pkxp8S11JL1ytTi83s9b1RA+
         6ncTa4qXS8GIEtPWWYVaqFliXpiKibtsVyuUqT1pWMZk8GPEW5h3xnoSeSp90CuF8/u9
         xnBA==
X-Gm-Message-State: AOAM530BgLxlrsCgI0QFB7eR+TcktcSkqxtmfvxGQ4OU69fhHlkajmPi
        ddqyjhuXXZla65c0HXiJFYrFmtnbLigLauaA
X-Google-Smtp-Source: ABdhPJxHqf4OKIqO/LlBBwks9ZbGZEF4cnwUtyl0/FOObbv5EUFx3HJ+uGaosMlUbuAnllaLvAVwYQ==
X-Received: by 2002:a05:6402:1a33:: with SMTP id be19mr20959914edb.47.1605010978582;
        Tue, 10 Nov 2020 04:22:58 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h9sm10204156ejk.118.2020.11.10.04.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 04:22:57 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 5/6] libtracefs: Add new tracefs API tracefs_instances_walk()
Date:   Tue, 10 Nov 2020 14:22:48 +0200
Message-Id: <20201110122249.911664-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110122249.911664-1-tz.stoyanov@gmail.com>
References: <20201110122249.911664-1-tz.stoyanov@gmail.com>
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
index 63f1944a..e796462a 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -32,6 +32,7 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
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
index 655c6d20..5ff313c7 100644
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
@@ -342,3 +343,54 @@ bool tracefs_dir_exists(struct tracefs_instance *instance, char *name)
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
index e24fb38b..7e9fe738 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -463,6 +463,54 @@ static void test_local_events(void)
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
@@ -506,4 +554,7 @@ void test_tracefs_lib(void)
 		    test_tracers);
 	CU_add_test(suite, "tracefs_local events API",
 		    test_local_events);
+	CU_add_test(suite, "tracefs_instances_walk API",
+		    test_instances_walk);
+
 }
-- 
2.28.0

