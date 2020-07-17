Return-Path: <SRS0=fBth=A4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C5D1C433E1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 08:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 567B720704
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 08:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uIDQZMo6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgGQIDc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 04:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgGQIDb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 04:03:31 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F06AC061755
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jul 2020 01:03:31 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o18so9809972eje.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jul 2020 01:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vMhGwmsxFWtY6CtejlfNV162dcJqXI6kNUOhT/ewJzY=;
        b=uIDQZMo6zPuT53/XqS2lYPNYFkf2MbOpxjGUauPOntFc3/Z5//6N2XlSCs0Mmnkc0j
         csnCfGctl/DEOnYlgXHzuJiuA7RHH/GATWU4FuhkrRgVkiU2S/oJ+dcwiN322utsJKJI
         FEcGtmg8pi3VEMLiXMwRMRm2Wk5ZwMo6bmh3JCG8neq+5R7mC4LmyqPtxwfEAbp/+oWu
         fTciofdkIJuQZDji56y4goML6WDzqffG7rpLZce8Zs06YyDCxW1pGuyVOtRE5JzPkDau
         D0MC6TlZ0V7z2v8RxpPtsbrPO1S5qNhEvxeRjbsf67lN01cSaG1Vc08CFjinTZpP/Fj8
         Mczg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vMhGwmsxFWtY6CtejlfNV162dcJqXI6kNUOhT/ewJzY=;
        b=tmhEfNvGuazqERqD8iJOYfcLaQZ3YUc+8nCbETuCVFBfEp20wPrmAiV4OHVCzGqC5e
         /T7fTKh8j3ImOxxydrV7tTa4/ckRCe1MtbzqF2injVP6h6GPrLqGleVc4XeOROJdzDhn
         Pd3VFpUHyYphzVVtqc1wxw5b5d+RNRVmAkxOjkdC5iZrYG7K+K+NUy1eJn6n53pei2CX
         QAuh08MFvI5tK1OfZ65UjaZcwptqTiET0IH23sJ5vAjeJjG4OyCKPvgKDxfF7AVcFKuD
         94vHGhg5rwavQ5f5YY5ebkYlTVuJWIhH0F0gJkv9gJTb6oASzdXMaBQ7BoIXHtVL86Ly
         fD5w==
X-Gm-Message-State: AOAM530QGVkgBTRpqGbwv+lByr1x4PVf8ZwiQyFnn8qBe6WqodTVlhw2
        zEsowEcX+2o3H4YWQJaVnAA=
X-Google-Smtp-Source: ABdhPJwzSGLAScnV1l90XteFsvtsJZenwxOdV7rRyhj+NSEnzeJKMjjIWekTfY0RsCapveiKgb7MMA==
X-Received: by 2002:a17:906:b74e:: with SMTP id fx14mr7182349ejb.202.1594973010165;
        Fri, 17 Jul 2020 01:03:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s13sm7186074ejd.117.2020.07.17.01.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 01:03:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Add new tracefs API tracefs_instances_walk()
Date:   Fri, 17 Jul 2020 11:03:25 +0300
Message-Id: <20200717080326.82151-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200717080326.82151-1-tz.stoyanov@gmail.com>
References: <20200717080326.82151-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The logic for finding all configured ftrace instances is encapuslated in
the new tracefs_instances_walk() API. A user specified callback is
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
 5 files changed, 74 insertions(+), 46 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index 8ee7ba6e..0dd8046f 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -32,6 +32,7 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
 				const char *file, const char *str);
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
 				 char *file, int *psize);
+int tracefs_instances_walk(int (*callback)(const char *, void *), void *context);
 
 bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
 bool tracefs_dir_exists(struct tracefs_instance *instance, char *name);
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
index 8e825f50..564a5ab2 100644
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
 
@@ -497,7 +497,7 @@ static int read_header(struct tep_handle *tep, const char *tracing_dir)
 	int len;
 	int ret = -1;
 
-	header = append_file(tracing_dir, "events/header_page");
+	header = trace_append_file(tracing_dir, "events/header_page");
 
 	ret = stat(header, &st);
 	if (ret < 0)
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index 50e88534..befc0333 100644
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
@@ -291,3 +292,54 @@ bool tracefs_dir_exists(struct tracefs_instance *instance, char *name)
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
index 260d0c37..c242dae2 100644
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
-- 
2.26.2

