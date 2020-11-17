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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58DADC6379D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC30124655
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PqdivUwP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgKQHqI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 02:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgKQHqI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 02:46:08 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195C5C0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:08 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id a3so2270299wmb.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a0BXJFLP9r760PeySqozYiXxxNG+9OaFqqkDaZ9tHkc=;
        b=PqdivUwPGSKL3k4Nb04+Euj9YGULQ6Ean1/WeeP6HVNMOiDk6b1sCn2CzOQfSyxdM5
         HmLIybBJEPreUqPEAWpdihg1dMZ/UhF6WX8Vn+tENlWxXCSmXgndOowWbjQGxZ/V3yOu
         u6TiTHgs7IT1Sc2mUScibVAph/L2OIsR5g5wC8RVrZ7A09jzvY3bA4QszKyZclIkkhG2
         ERZhQPyLZTuQhJtBaVH/Y1Us1iJGxZT9bU5QDLB2XkT+nyIpRR8gz2m8hjQveRN8a2wX
         KIEA/lU8eARP53lti4ws1HHGXWxWKBqrqJg6djeqrG/OaZGT1NPQNYYOyCfiug5b2baj
         AieQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a0BXJFLP9r760PeySqozYiXxxNG+9OaFqqkDaZ9tHkc=;
        b=Tp/hhNreKReuyFY9P6HBC/4R+ieQRSRsbF2L9p8MJpuKBWRbbdUvOu56IkURwCL3N9
         zHgLWl8mpT//JDu9xeEyh7d5N2e1FeoOWfMWgYziB8QP1O6s46Y1UOhqutC4I/MiR7Wj
         xFgIDZTK6LILZHa93k5Cdtn4ARlTAYqvU/m0c2iwuIrk0HjSVWEuKi9TD9wBcgHZ2ZRO
         pRANOQ9umw90VooO0bkKadB0zMfevw5SUywLks/hgHR9XNJtzvIAy5doVPT1x/BzX0wx
         xwNMCtAbdR5Ck1IW3ulT4TXyg29xOIYAO+4LhuIxQD4sOVIK3B02l6jbDocfZvqfNsEM
         4Jmg==
X-Gm-Message-State: AOAM531POU7CoPPGKpIt4DUE8dZROTzBt5ox1J6SDpH86hUdmxHnxM8k
        pTMCXN9cVFuwAXbhOtKBDfx09eaEjlkP8SvB
X-Google-Smtp-Source: ABdhPJwKTmxX60rDnpCBFiGPBMwtfuRo/vyjDVPjkM28rq3pLVrYTmqgb/xQ5z7YpuDQ3OtP+6mCAA==
X-Received: by 2002:a1c:bc08:: with SMTP id m8mr3011032wmf.137.1605599166796;
        Mon, 16 Nov 2020 23:46:06 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d3sm25752046wre.91.2020.11.16.23.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 23:46:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 6/8] libtracefs: Add new tracefs API tracefs_instances_walk()
Date:   Tue, 17 Nov 2020 09:45:55 +0200
Message-Id: <20201117074557.180602-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117074557.180602-1-tz.stoyanov@gmail.com>
References: <20201117074557.180602-1-tz.stoyanov@gmail.com>
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
 lib/tracefs/tracefs-instance.c      | 55 +++++++++++++++++++++++++++++
 tracecmd/trace-stat.c               | 52 +++++++--------------------
 utest/tracefs-utest.c               | 52 +++++++++++++++++++++++++++
 6 files changed, 129 insertions(+), 46 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index 388d8f94..bcf3dd64 100644
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
index 6b796382..f2c6046c 100644
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
@@ -265,7 +265,7 @@ char **tracefs_event_systems(const char *tracing_dir)
 	if (!tracing_dir)
 		return NULL;
 
-	events_dir = append_file(tracing_dir, "events");
+	events_dir = trace_append_file(tracing_dir, "events");
 	if (!events_dir)
 		return NULL;
 
@@ -290,14 +290,14 @@ char **tracefs_event_systems(const char *tracing_dir)
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
@@ -359,7 +359,7 @@ char **tracefs_system_events(const char *tracing_dir, const char *system)
 		    strcmp(name, "..") == 0)
 			continue;
 
-		event = append_file(system_dir, name);
+		event = trace_append_file(system_dir, name);
 		ret = stat(event, &st);
 		if (ret < 0 || !S_ISDIR(st.st_mode)) {
 			free(event);
@@ -401,7 +401,7 @@ char **tracefs_tracers(const char *tracing_dir)
 	if (!tracing_dir)
 		return NULL;
 
-	available_tracers = append_file(tracing_dir, "available_tracers");
+	available_tracers = trace_append_file(tracing_dir, "available_tracers");
 	if (!available_tracers)
 		return NULL;
 
@@ -493,7 +493,7 @@ static int read_header(struct tep_handle *tep, const char *tracing_dir)
 	int len;
 	int ret = -1;
 
-	header = append_file(tracing_dir, "events/header_page");
+	header = trace_append_file(tracing_dir, "events/header_page");
 
 	ret = stat(header, &st);
 	if (ret < 0)
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index d7a29e7d..d05e08b1 100644
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
@@ -363,3 +364,57 @@ bool tracefs_dir_exists(struct tracefs_instance *instance, char *name)
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
+ * Returns -1 in case of an error, 1 if the iteration was stopped because of the
+ * callback return value or 0 otherwise.
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
+		if (callback(dent->d_name, context)) {
+			fret = 1;
+			break;
+		}
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
index 31031661..c42fea12 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -462,6 +462,55 @@ static void test_local_events(void)
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
+		instances[i].instance = tracefs_instance_create(get_rand_str());
+		CU_TEST(instances[i].instance != NULL);
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
@@ -505,4 +554,7 @@ void test_tracefs_lib(void)
 		    test_tracers);
 	CU_add_test(suite, "tracefs_local events API",
 		    test_local_events);
+	CU_add_test(suite, "tracefs_instances_walk API",
+		    test_instances_walk);
+
 }
-- 
2.28.0

