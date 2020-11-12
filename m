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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29ACC63697
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 09:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70CEB216FD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 09:11:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TodEHioR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgKLJLU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 04:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgKLJLS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 04:11:18 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68343C0617A6
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 01:11:18 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id w24so4798867wmi.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 01:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E42KLOsCAiXAVDeRSY+okN01PbKdve++P5NlZXX6yMM=;
        b=TodEHioRfJ0xJ6xdUh0Iy/KxIKdIGShW9ZC7sj9h0dzSngWPuDrnMZAmCL2P/VeqF2
         5CY7ESFytpaTpMPXFVCiOO+U8FuhxMPoaIeBSP+UV8EJqNIhfDU8EXeILf2r1V/Vvbs3
         /fRP0FVPX5/RhgMjbl6tPVzYyYy6Z1U473CJ1768efBQlmqxMaqA+IZwF3NpnnwAjv+P
         4z0JBYx+MbBwL3s6fK9VYAH2KYUedB4iAhQTHSAGVgy93t821m6mI9TKIwhhKEggsveD
         6pHT0jim7L5c4b8iLgg1dXaWODDmlwiHUrmNY2dR76oyyG+Crqax25201h8TKtwu/Ecc
         72FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E42KLOsCAiXAVDeRSY+okN01PbKdve++P5NlZXX6yMM=;
        b=cDrXtKlCrsj+X894SoRIzSwZsJ7z5y48naxz1RKX/MNsH+77d/IUYE9pi/TvHSb9zz
         dNWW0TXP/aj52orMfTxPcLZAREw7TnTcSTBO4neTbnkzJuG4HogfSy4AxrTVxFrddcpP
         GtFy4yuros/X8O77JR+6C9aJquNqul7ULO1GRUKmt/kAyMSpl5zzeLMpu2w6jm4ABlaK
         4kHlCj3fo7ttBFb3YR7KklNfYBrtyHutgVA65nP0xw/6eSjM9KUHJZERbdQeccA1dWF/
         L+LAkJnfKxP/d8O9uZuQe3WutEeCJ0eIw4MGEG/oaqYvVJtNZUb5Z+14GLWWhsYRik2A
         OAlg==
X-Gm-Message-State: AOAM531H/fK1ieGq+dzMoN2xgrvIwPPV17xutSTpFlf6d4tKQcfUA9+Q
        1BBIsFB8px/cB0Mxj7Yo5kj1T20hfPW+3HQH
X-Google-Smtp-Source: ABdhPJxqnGmC3Kms+X9cfyFuZHMGSE487lOjbRK1RS6EMiv9Z5Pi0TOgdNmfaKX6qeaGwaMI1FfYwQ==
X-Received: by 2002:a1c:5f45:: with SMTP id t66mr8636974wmb.20.1605172277072;
        Thu, 12 Nov 2020 01:11:17 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r18sm6705718wrj.50.2020.11.12.01.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 01:11:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 5/6] libtracefs: Add new tracefs API tracefs_instances_walk()
Date:   Thu, 12 Nov 2020 11:11:08 +0200
Message-Id: <20201112091109.1239169-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201112091109.1239169-1-tz.stoyanov@gmail.com>
References: <20201112091109.1239169-1-tz.stoyanov@gmail.com>
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
index 1c0958cf..7b6d9417 100644
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
@@ -342,3 +343,57 @@ bool tracefs_dir_exists(struct tracefs_instance *instance, char *name)
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

