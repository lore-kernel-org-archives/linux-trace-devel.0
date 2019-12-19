Return-Path: <SRS0=Ara6=2J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33EBC43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 11:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A557920716
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 11:35:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tXEB8kTz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfLSLfR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 06:35:17 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:44720 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbfLSLfR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 06:35:17 -0500
Received: by mail-lj1-f181.google.com with SMTP id u71so5838788lje.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Dec 2019 03:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wmZkbxAbT1HnojhOk2sgDr63ZMR3S/TDRr4L8PqNbto=;
        b=tXEB8kTz4/R3/9igCDkYgPVDpbmoFtaCQnKQ8cTAiJApbYEV5C+jdhaXnJNeasMHaf
         lobxXIP7Ews9rwbKhzTZDTUGPpano9tnklymlNgRnOCnRr6BMRBS5pbPyweO5V0bzvLo
         zL7gHQrzoXyCivKVaJa55B/n31BOwJK8y/Ewk/SUsQ/hBVJc8e84/4chNNPDKkzb8QLM
         7SL5UigixZo1+AHRFozTfdNM2HsTWR+Bzi/15FsvCsWPnyN5g2nlWtsJAIo3/7jD1FKq
         2sJFV9d+QRhSbcRAXvHRkcSJG8g2IQh0JEIDGMN5kswrDwuC4zuYIqdv3jjjp4LcCpEu
         sebA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wmZkbxAbT1HnojhOk2sgDr63ZMR3S/TDRr4L8PqNbto=;
        b=fJjGFx6wykhSDvFSu/xLOgu0VIIsbSN2UnTmEPzR7DUqRYhafjtjUatCEc4p8Yh2Ar
         CSVcUueaSh8zM0WpVc0xZhNAvhuKMOuMy9aHf8SNwJRxsN8CJldVijpoOhaweKh6n7kk
         5bF+TWyZqT1pP73Alph1spi02h75tGg9UsdaG8zJJ72MeqZsCBY5tjlRfkgEhY4BnsPt
         qGZaJiZGBuAPynvWXfdCQHtxiLbAnky31iWi/H9GSA77bE8sQtAol9m6YqJYzXfD9/gC
         PI2GIONWpcVCIgm5GMrzZZbBC2mRaEl4Qz7eBIauGgTotwiaIvZPdLlChR9W14p76hTo
         wx+A==
X-Gm-Message-State: APjAAAV2jpDdAgDH95T46XjcOsgkJBxGEl0zjOR4TG9HtmZYPELeLtll
        NXKGUxdg9nfsuq2LFTfIjmE=
X-Google-Smtp-Source: APXvYqwDDGiLH3j9GkincZ4IzMb0ayfIjnT/yIQLffXu+vMsPDDXH0CpWpgfsFiWgU6wQt08MSyT9g==
X-Received: by 2002:a2e:83cc:: with SMTP id s12mr5495020ljh.11.1576755312083;
        Thu, 19 Dec 2019 03:35:12 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d4sm2437022lfn.42.2019.12.19.03.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 03:35:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/6] trace-cmd: New libtracefs APIs for ftrace instances
Date:   Thu, 19 Dec 2019 13:35:00 +0200
Message-Id: <20191219113502.28964-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191219113502.28964-1-tz.stoyanov@gmail.com>
References: <20191219113502.28964-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The functionality related to ftrace instances is moved from
trace-cmd application to libtracefs. The following new
library APIs are introduced:
    struct tracefs_instance;
    struct tracefs_instance *tracefs_alloc_instance(const char *name);
    int tracefs_free_instance(struct tracefs_instance *instance);
    int tracefs_make_instance(struct tracefs_instance *instance);
    int tracefs_remove_instance(struct tracefs_instance *instance);
    char *tracefs_get_instance_name(struct tracefs_instance *instance);
    char *tracefs_get_instance_file(struct tracefs_instance *instance, const char *file);
    char *tracefs_get_instance_dir(struct tracefs_instance *instance);
    int tracefs_write_instance_file(struct tracefs_instance *instance,
				 const char *file, const char *str, const char *type);
    char *tracefs_read_instance_file(struct tracefs_instance *instance, char *file, int *psize);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h           |  17 ++
 lib/tracefs/Makefile                |   1 +
 lib/tracefs/include/tracefs-local.h |   1 +
 lib/tracefs/tracefs-instance.c      | 233 ++++++++++++++++++++++++
 lib/tracefs/tracefs-utils.c         |  40 +++++
 tracecmd/include/trace-local.h      |   5 +-
 tracecmd/trace-list.c               |   2 +-
 tracecmd/trace-record.c             | 267 +++++++++-------------------
 tracecmd/trace-show.c               |   2 +
 tracecmd/trace-stat.c               |  21 ++-
 10 files changed, 394 insertions(+), 195 deletions(-)
 create mode 100644 lib/tracefs/tracefs-instance.c

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index 6120dbe..86be707 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -19,4 +19,21 @@ char *tracefs_find_tracing_dir(void);
 
 int tracefs_write_file(const char *file, const char *str, const char *type);
 
+/* ftarce instances */
+struct tracefs_instance;
+
+struct tracefs_instance *tracefs_alloc_instance(const char *name);
+int tracefs_free_instance(struct tracefs_instance *instance);
+int tracefs_make_instance(struct tracefs_instance *instance);
+int tracefs_remove_instance(struct tracefs_instance *instance);
+char *tracefs_get_instance_name(struct tracefs_instance *instance);
+char *
+tracefs_get_instance_file(struct tracefs_instance *instance, const char *file);
+char *tracefs_get_instance_dir(struct tracefs_instance *instance);
+int tracefs_write_instance_file(struct tracefs_instance *instance,
+				const char *file, const char *str,
+				const char *type);
+char *tracefs_read_instance_file(struct tracefs_instance *instance,
+				 char *file, int *psize);
+
 #endif /* _TRACE_FS_H */
diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
index 86d7845..4030272 100644
--- a/lib/tracefs/Makefile
+++ b/lib/tracefs/Makefile
@@ -8,6 +8,7 @@ DEFAULT_TARGET = $(bdir)/libtracefs.a
 
 OBJS =
 OBJS += tracefs-utils.o
+OBJS += tracefs-instance.o
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
diff --git a/lib/tracefs/include/tracefs-local.h b/lib/tracefs/include/tracefs-local.h
index 231edd1..fe327a0 100644
--- a/lib/tracefs/include/tracefs-local.h
+++ b/lib/tracefs/include/tracefs-local.h
@@ -8,5 +8,6 @@
 
 /* Can be overridden */
 void warning(const char *fmt, ...);
+int str_read_file(const char *file, char **buffer);
 
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
new file mode 100644
index 0000000..12044cc
--- /dev/null
+++ b/lib/tracefs/tracefs-instance.c
@@ -0,0 +1,233 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2019, VMware Inc, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/stat.h>
+
+#include "tracefs.h"
+#include "tracefs-local.h"
+
+struct tracefs_instance {
+	char *name;
+};
+
+/**
+ * tracefs_alloc_instance - allocate a new ftrace instance
+ * @name: The name of the instance (instance will point to this)
+ *
+ * Returns a newly allocated instance, or NULL in case of an error.
+ */
+struct tracefs_instance *tracefs_alloc_instance(const char *name)
+{
+	struct tracefs_instance *instance;
+
+	instance = calloc(1, sizeof(*instance));
+	if (!instance)
+		return NULL;
+	if (name)
+		instance->name = strdup(name);
+
+	return instance;
+}
+
+/**
+ * tracefs_free_instance - Free an instance, previously allocated by
+			   tracefs_alloc_instance()
+ * @instance: Pointer to the instance to be freed
+ *
+ * Returns -1 in case of an error, or 0 otherwise.
+ */
+int tracefs_free_instance(struct tracefs_instance *instance)
+{
+	if (!instance)
+		return -1;
+
+	free(instance->name);
+	free(instance);
+	return 0;
+}
+
+/**
+ * tracefs_make_instance - Create a new ftrace instance
+ * @instance: Pointer to the instance to be created
+ *
+ * Returns 1 if the instance already exist, 0 if the instance
+ * is created successful or -1 in case of an error
+ */
+int tracefs_make_instance(struct tracefs_instance *instance)
+{
+	struct stat st;
+	char *path;
+	int ret;
+
+	path = tracefs_get_instance_dir(instance);
+	ret = stat(path, &st);
+	if (ret < 0) {
+		ret = mkdir(path, 0777);
+		if (ret < 0)
+			return ret;
+
+	} else
+		ret = 1;
+	tracefs_put_tracing_file(path);
+	return ret;
+}
+
+/**
+ * tracefs_remove_instance - Remove a ftrace instance
+ * @instance: Pointer to the instance to be removed
+ *
+ * Returns -1 in case of an error, or 0 otherwise.
+ */
+int tracefs_remove_instance(struct tracefs_instance *instance)
+{
+	char *path;
+	int ret;
+
+	if (!instance || !instance->name) {
+		warning("Cannot remove top instance");
+		return -1;
+	}
+
+	path = tracefs_get_instance_dir(instance);
+	ret = rmdir(path);
+	tracefs_put_tracing_file(path);
+
+	return ret;
+}
+
+/**
+ * tracefs_get_instance_file - return the path to an instance file.
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @file: name of file to return
+ *
+ * Returns the path of the @file for the given @instance, or NULL in
+ * case of an error.
+ *
+ * Must use tracefs_put_tracing_file() to free the returned string.
+ */
+char *
+tracefs_get_instance_file(struct tracefs_instance *instance, const char *file)
+{
+	char *path;
+	char *buf;
+	int ret;
+
+	if (instance && instance->name) {
+		ret = asprintf(&buf, "instances/%s/%s", instance->name, file);
+		if (ret < 0) {
+			warning("Failed to allocate name for %s/%s",
+				 instance->name, file);
+			return NULL;
+		}
+		path = tracefs_get_tracing_file(buf);
+		free(buf);
+	} else
+		path = tracefs_get_tracing_file(file);
+
+	return path;
+}
+
+/**
+ * tracefs_get_instance_dir - return the path to the instance directory.
+ * @instance: ftrace instance, can be NULL for the top instance
+ *
+ * Returns the full path to the instance directory
+ *
+ * Must use tracefs_put_tracing_file() to free the returned string.
+ */
+char *tracefs_get_instance_dir(struct tracefs_instance *instance)
+{
+	char *buf;
+	char *path;
+	int ret;
+
+	if (instance && instance->name) {
+		ret = asprintf(&buf, "instances/%s", instance->name);
+		if (ret < 0) {
+			warning("Failed to allocate path for instance %s",
+				 instance->name);
+			return NULL;
+		}
+		path = tracefs_get_tracing_file(buf);
+		free(buf);
+	} else
+		path = tracefs_find_tracing_dir();
+
+	return path;
+}
+
+/**
+ * tracefs_get_instance_name - return the name of an instance
+ * @instance: ftrace instance
+ *
+ * Returns the name of the given @instance.
+ * The returned string must *not* be freed.
+ */
+char *tracefs_get_instance_name(struct tracefs_instance *instance)
+{
+	if (instance)
+		return instance->name;
+	return NULL;
+}
+
+/**
+ * tracefs_write_instance_file - Write in trace file of specific instance.
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @file: name of the file
+ * @str: nul terminated string, that will be written in the file.
+ * @type: nul terminated string, describing the current write operation.
+ *	  Used for logging purposes.
+ *
+ * Returns the number of written bytes, or -1 in case of an error
+ */
+int tracefs_write_instance_file(struct tracefs_instance *instance,
+				 const char *file, const char *str,
+				 const char *type)
+{
+	struct stat st;
+	char *path;
+	int ret;
+
+	path = tracefs_get_instance_file(instance, file);
+	ret = stat(path, &st);
+	if (ret == 0)
+		ret = tracefs_write_file(path, str, type);
+	tracefs_put_tracing_file(path);
+
+	return ret;
+}
+
+/**
+ * tracefs_read_instance_file - Read from a trace file of specific instance.
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @file: name of the file
+ * @psize: returns the number of bytes read
+ *
+ * Returns a pointer to a nul terminated string, read from the file, or NULL in
+ * case of an error.
+ * The return string must be freed by free()
+ */
+char *tracefs_read_instance_file(struct tracefs_instance *instance,
+				  char *file, int *psize)
+{
+	char *buf = NULL;
+	int size = 0;
+	char *path;
+
+	path = tracefs_get_instance_file(instance, file);
+
+	size = str_read_file(path, &buf);
+
+	tracefs_put_tracing_file(path);
+	if (buf && psize)
+		*psize = size;
+
+	return buf;
+}
diff --git a/lib/tracefs/tracefs-utils.c b/lib/tracefs/tracefs-utils.c
index 42a3f46..2c0a438 100644
--- a/lib/tracefs/tracefs-utils.c
+++ b/lib/tracefs/tracefs-utils.c
@@ -219,3 +219,43 @@ int tracefs_write_file(const char *file, const char *str, const char *type)
 	}
 	return ret;
 }
+
+int str_read_file(const char *file, char **buffer)
+{
+	char stbuf[BUFSIZ];
+	char *buf = NULL;
+	int size = 0;
+	char *nbuf;
+	int fd;
+	int r;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		warning("File %s not found", file);
+		return -1;
+	}
+
+	do {
+		r = read(fd, stbuf, BUFSIZ);
+		if (r <= 0)
+			continue;
+		nbuf = realloc(buf, size+r+1);
+		if (!nbuf) {
+			warning("Failed to allocate file buffer");
+			size = -1;
+			break;
+		}
+		buf = nbuf;
+		memcpy(buf+size, stbuf, r);
+		size += r;
+	} while (r);
+
+	close(fd);
+	if (size > 0) {
+		buf[size] = '\0';
+		*buffer = buf;
+	} else
+		free(buf);
+
+	return size;
+}
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index fedc0b7..c7310e5 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -181,7 +181,7 @@ struct pid_addr_maps {
 
 struct buffer_instance {
 	struct buffer_instance	*next;
-	const char		*name;
+	struct tracefs_instance	*tracefs;
 	char			*cpumask;
 	struct event_list	*events;
 	struct event_list	**event_next;
@@ -225,6 +225,8 @@ struct buffer_instance {
 	bool			use_fifos;
 };
 
+void init_top_instance(void);
+
 extern struct buffer_instance top_instance;
 extern struct buffer_instance *buffer_instances;
 extern struct buffer_instance *first_instance;
@@ -238,7 +240,6 @@ extern struct buffer_instance *first_instance;
 
 struct buffer_instance *create_instance(const char *name);
 void add_instance(struct buffer_instance *instance, int cpu_count);
-char *get_instance_file(struct buffer_instance *instance, const char *file);
 void update_first_instance(struct buffer_instance *instance, int topt);
 
 void show_instance_file(struct buffer_instance *instance, const char *name);
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 86e3358..d5c0707 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -34,7 +34,7 @@ void show_instance_file(struct buffer_instance *instance, const char *name)
 {
 	char *path;
 
-	path = get_instance_file(instance, name);
+	path = tracefs_get_instance_file(instance->tracefs, name);
 	dump_file_content(path);
 	tracefs_put_tracing_file(path);
 }
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index be21f3d..c417277 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -174,7 +174,7 @@ static struct reset_file *reset_files;
 /* Triggers need to be cleared in a special way */
 static struct reset_file *reset_triggers;
 
-struct buffer_instance top_instance = { .flags = BUFFER_FL_KEEP };
+struct buffer_instance top_instance;
 struct buffer_instance *buffer_instances;
 struct buffer_instance *first_instance;
 
@@ -372,7 +372,11 @@ struct buffer_instance *create_instance(const char *name)
 	if (!instance)
 		return NULL;
 	memset(instance, 0, sizeof(*instance));
-	instance->name = name;
+	instance->tracefs = tracefs_alloc_instance(name);
+	if (!instance->tracefs) {
+		free(instance);
+		return NULL;
+	}
 
 	return instance;
 }
@@ -472,7 +476,7 @@ void tracecmd_stat_cpu_instance(struct buffer_instance *instance,
 		return;
 	snprintf(file, 40, "per_cpu/cpu%d/stats", cpu);
 
-	path = get_instance_file(instance, file);
+	path = tracefs_get_instance_file(instance->tracefs, file);
 	free(file);
 	fd = open(path, O_RDONLY);
 	tracefs_put_tracing_file(path);
@@ -511,10 +515,11 @@ static void reset_event_list(struct buffer_instance *instance)
 
 static char *get_temp_file(struct buffer_instance *instance, int cpu)
 {
-	const char *name = instance->name;
+	const char *name;
 	char *file = NULL;
 	int size;
 
+	name = tracefs_get_instance_name(instance->tracefs);
 	if (name) {
 		size = snprintf(file, 0, "%s.%s.cpu%d", output_file, name, cpu);
 		file = malloc(size + 1);
@@ -558,9 +563,10 @@ static void put_temp_file(char *file)
 
 static void delete_temp_file(struct buffer_instance *instance, int cpu)
 {
-	const char *name = instance->name;
+	const char *name;
 	char file[PATH_MAX];
 
+	name = tracefs_get_instance_name(instance->tracefs);
 	if (name)
 		snprintf(file, PATH_MAX, "%s.%s.cpu%d", output_file, name, cpu);
 	else
@@ -784,74 +790,6 @@ static int set_ftrace(int set, int use_proc)
 	return 0;
 }
 
-/**
- * get_instance_file - return the path to a instance file.
- * @instance: buffer instance for the file
- * @file: name of file to return
- *
- * Returns the path name of the @file for the given @instance.
- *
- * Must use tracefs_put_tracing_file() to free the returned string.
- */
-char *
-get_instance_file(struct buffer_instance *instance, const char *file)
-{
-	char *buf;
-	char *path;
-	int ret;
-
-	if (instance->name) {
-		ret = asprintf(&buf, "instances/%s/%s", instance->name, file);
-		if (ret < 0)
-			die("Failed to allocate name for %s/%s", instance->name, file);
-		path = tracefs_get_tracing_file(buf);
-		free(buf);
-	} else
-		path = tracefs_get_tracing_file(file);
-
-	return path;
-}
-
-static char *
-get_instance_dir(struct buffer_instance *instance)
-{
-	char *buf;
-	char *path;
-	int ret;
-
-	/* only works for instances */
-	if (!instance->name)
-		return NULL;
-
-	ret = asprintf(&buf, "instances/%s", instance->name);
-	if (ret < 0)
-		die("Failed to allocate for instance %s", instance->name);
-	path = tracefs_get_tracing_file(buf);
-	free(buf);
-
-	return path;
-}
-
-static int
-write_instance_file(struct buffer_instance *instance,
-		    const char *file, const char *str, const char *type)
-{
-	struct stat st;
-	char *path;
-	int ret;
-
-	path = get_instance_file(instance, file);
-	ret = stat(path, &st);
-	if (ret == 0) {
-		ret = tracefs_write_file(path, str, type);
-		if (ret < 0)
-			die("Failed to write file");
-	}
-	tracefs_put_tracing_file(path);
-
-	return ret;
-}
-
 static void __clear_trace(struct buffer_instance *instance)
 {
 	FILE *fp;
@@ -861,7 +799,7 @@ static void __clear_trace(struct buffer_instance *instance)
 		return;
 
 	/* reset the trace */
-	path = get_instance_file(instance, "trace");
+	path = tracefs_get_instance_file(instance->tracefs, "trace");
 	fp = fopen(path, "w");
 	if (!fp)
 		die("writing to '%s'", path);
@@ -895,8 +833,8 @@ static void clear_trace(void)
 
 static void reset_max_latency(struct buffer_instance *instance)
 {
-	 write_instance_file(instance,
-			     "tracing_max_latency", "0", "max_latency");
+	tracefs_write_instance_file(instance->tracefs,
+				    "tracing_max_latency", "0", "max_latency");
 }
 
 static void add_filter_pid(int pid, int exclude)
@@ -1342,7 +1280,8 @@ static void add_event_pid(const char *buf)
 	struct buffer_instance *instance;
 
 	for_all_instances(instance)
-		write_instance_file(instance, "set_event_pid", buf, "event_pid");
+		tracefs_write_instance_file(instance->tracefs,
+					    "set_event_pid", buf, "event_pid");
 }
 
 static void add_new_filter_pid(int pid)
@@ -1571,7 +1510,7 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 	if (is_guest(instance))
 		return;
 
-	path = get_instance_file(instance, "current_tracer");
+	path = tracefs_get_instance_file(instance->tracefs, "current_tracer");
 	fp = fopen(path, "w");
 	if (!fp) {
 		/*
@@ -1595,7 +1534,7 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 
 	/* Make sure func_stack_trace option is disabled */
 	/* First try instance file, then top level */
-	path = get_instance_file(instance, "options/func_stack_trace");
+	path = tracefs_get_instance_file(instance->tracefs, "options/func_stack_trace");
 	fp = fopen(path, "w");
 	if (!fp) {
 		tracefs_put_tracing_file(path);
@@ -1656,8 +1595,6 @@ static int set_option(const char *option)
 	return 0;
 }
 
-static char *read_instance_file(struct buffer_instance *instance, char *file, int *psize);
-
 static void disable_func_stack_trace_instance(struct buffer_instance *instance)
 {
 	struct stat st;
@@ -1670,13 +1607,14 @@ static void disable_func_stack_trace_instance(struct buffer_instance *instance)
 	if (is_guest(instance))
 		return;
 
-	path = get_instance_file(instance, "current_tracer");
+	path = tracefs_get_instance_file(instance->tracefs, "current_tracer");
 	ret = stat(path, &st);
 	tracefs_put_tracing_file(path);
 	if (ret < 0)
 		return;
 
-	content = read_instance_file(instance, "current_tracer", &size);
+	content = tracefs_read_instance_file(instance->tracefs,
+					     "current_tracer", &size);
 	cond = strstrip(content);
 	if (memcmp(cond, "function", size - (cond - content)) !=0)
 		goto out;
@@ -1829,7 +1767,7 @@ static int trace_check_file_exists(struct buffer_instance *instance, char *file)
 	char *path;
 	int ret;
 
-	path = get_instance_file(instance, file);
+	path = tracefs_get_instance_file(instance->tracefs, file);
 	ret = stat(path, &st);
 	tracefs_put_tracing_file(path);
 
@@ -1908,7 +1846,7 @@ reset_events_instance(struct buffer_instance *instance)
 	}
 
 	c = '0';
-	path = get_instance_file(instance, "events/enable");
+	path = tracefs_get_instance_file(instance->tracefs, "events/enable");
 	fd = open(path, O_WRONLY);
 	if (fd < 0)
 		die("opening to '%s'", path);
@@ -1916,7 +1854,7 @@ reset_events_instance(struct buffer_instance *instance)
 	close(fd);
 	tracefs_put_tracing_file(path);
 
-	path = get_instance_file(instance, "events/*/filter");
+	path = tracefs_get_instance_file(instance->tracefs, "events/*/filter");
 	globbuf.gl_offs = 0;
 	ret = glob(path, 0, NULL, &globbuf);
 	tracefs_put_tracing_file(path);
@@ -2182,7 +2120,7 @@ static int open_instance_fd(struct buffer_instance *instance,
 	int fd;
 	char *path;
 
-	path = get_instance_file(instance, file);
+	path = tracefs_get_instance_file(instance->tracefs, file);
 	fd = open(path, flags);
 	if (fd < 0) {
 		/* instances may not be created yet */
@@ -2491,7 +2429,7 @@ static void set_mask(struct buffer_instance *instance)
 	if (!instance->cpumask)
 		return;
 
-	path = get_instance_file(instance, "tracing_cpumask");
+	path = tracefs_get_instance_file(instance->tracefs, "tracing_cpumask");
 	if (!path)
 		die("could not allocate path");
 	reset_save_file(path, RESET_DEFAULT_PRIO);
@@ -2552,7 +2490,8 @@ static void set_clock(struct buffer_instance *instance)
 		return;
 
 	/* The current clock is in brackets, reset it when we are done */
-	content = read_instance_file(instance, "trace_clock", NULL);
+	content = tracefs_read_instance_file(instance->tracefs,
+					     "trace_clock", NULL);
 
 	/* check if first clock is set */
 	if (*content == '[')
@@ -2563,13 +2502,14 @@ static void set_clock(struct buffer_instance *instance)
 			die("Can not find clock in trace_clock");
 		str = strtok(NULL, "]");
 	}
-	path = get_instance_file(instance, "trace_clock");
+	path = tracefs_get_instance_file(instance->tracefs, "trace_clock");
 	add_reset_file(path, str, RESET_DEFAULT_PRIO);
 
 	free(content);
 	tracefs_put_tracing_file(path);
 
-	write_instance_file(instance, "trace_clock", instance->clock, "clock");
+	tracefs_write_instance_file(instance->tracefs,
+				    "trace_clock", instance->clock, "clock");
 }
 
 static void set_max_graph_depth(struct buffer_instance *instance, char *max_graph_depth)
@@ -2580,11 +2520,11 @@ static void set_max_graph_depth(struct buffer_instance *instance, char *max_grap
 	if (is_guest(instance))
 		return;
 
-	path = get_instance_file(instance, "max_graph_depth");
+	path = tracefs_get_instance_file(instance->tracefs, "max_graph_depth");
 	reset_save_file(path, RESET_DEFAULT_PRIO);
 	tracefs_put_tracing_file(path);
-	ret = write_instance_file(instance, "max_graph_depth", max_graph_depth,
-				  NULL);
+	ret = tracefs_write_instance_file(instance->tracefs, "max_graph_depth",
+					  max_graph_depth, NULL);
 	if (ret < 0)
 		die("could not write to max_graph_depth");
 }
@@ -2701,7 +2641,7 @@ static int expand_event_files(struct buffer_instance *instance,
 	if (ret < 0)
 		die("Failed to allocate event filter path for %s", file);
 
-	path = get_instance_file(instance, p);
+	path = tracefs_get_instance_file(instance->tracefs, p);
 
 	globbuf.gl_offs = 0;
 	ret = glob(path, 0, NULL, &globbuf);
@@ -3163,10 +3103,7 @@ create_recorder_instance_pipe(struct buffer_instance *instance,
 	unsigned flags = recorder_flags | TRACECMD_RECORD_BLOCK;
 	char *path;
 
-	if (instance->name)
-		path = get_instance_dir(instance);
-	else
-		path = tracefs_find_tracing_dir();
+	path = tracefs_get_instance_dir(instance->tracefs);
 
 	if (!path)
 		die("malloc");
@@ -3176,8 +3113,7 @@ create_recorder_instance_pipe(struct buffer_instance *instance,
 
 	recorder = tracecmd_create_buffer_recorder_fd(brass[1], cpu, flags, path);
 
-	if (instance->name)
-		tracefs_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	return recorder;
 }
@@ -3211,10 +3147,10 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 	if (brass)
 		return create_recorder_instance_pipe(instance, cpu, brass);
 
-	if (!instance->name)
+	if (!tracefs_get_instance_name(instance->tracefs))
 		return tracecmd_create_recorder_maxkb(file, cpu, recorder_flags, max_kb);
 
-	path = get_instance_dir(instance);
+	path = tracefs_get_instance_dir(instance->tracefs);
 
 	record = tracecmd_create_buffer_recorder_maxkb(file, cpu, recorder_flags,
 						       path, max_kb);
@@ -3268,8 +3204,8 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 		}
 		if (fd < 0)
 			die("Failed connecting to client");
-		if (instance->name && !is_agent(instance))
-			path = get_instance_dir(instance);
+		if (tracefs_get_instance_name(instance->tracefs) && !is_agent(instance))
+			path = tracefs_get_instance_dir(instance->tracefs);
 		else
 			path = tracefs_find_tracing_dir();
 		recorder = tracecmd_create_buffer_recorder_fd(fd, cpu, flags, path);
@@ -3580,9 +3516,11 @@ static void connect_to_agent(struct buffer_instance *instance)
 	unsigned int *ports;
 	int i, *fds = NULL;
 	bool use_fifos = false;
+	char *name;
 
+	name = tracefs_get_instance_name(instance->tracefs);
 	if (!no_fifos) {
-		nr_fifos = open_guest_fifos(instance->name, &fds);
+		nr_fifos = open_guest_fifos(name, &fds);
 		use_fifos = nr_fifos > 0;
 	}
 
@@ -3609,7 +3547,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 		if (nr_cpus != nr_fifos) {
 			warning("number of FIFOs (%d) for guest %s differs "
 				"from number of virtual CPUs (%d)",
-				nr_fifos, instance->name, nr_cpus);
+				nr_fifos, name, nr_cpus);
 			nr_cpus = nr_cpus < nr_fifos ? nr_cpus : nr_fifos;
 		}
 		free(ports);
@@ -3635,7 +3573,8 @@ static void setup_guest(struct buffer_instance *instance)
 	int fd;
 
 	/* Create a place to store the guest meta data */
-	file = get_guest_file(output_file, instance->name);
+	file = get_guest_file(output_file,
+			      tracefs_get_instance_name(instance->tracefs));
 	if (!file)
 		die("Failed to allocate memory");
 
@@ -3811,7 +3750,8 @@ add_buffer_stat(struct tracecmd_output *handle, struct buffer_instance *instance
 	int i;
 
 	trace_seq_init(&s);
-	trace_seq_printf(&s, "\nBuffer: %s\n\n", instance->name);
+	trace_seq_printf(&s, "\nBuffer: %s\n\n",
+			tracefs_get_instance_name(instance->tracefs));
 	tracecmd_add_option(handle, TRACECMD_OPTION_CPUSTAT,
 			    s.len+1, s.buffer);
 	trace_seq_destroy(&s);
@@ -3877,7 +3817,8 @@ static void print_stat(struct buffer_instance *instance)
 		return;
 
 	if (!is_top_instance(instance))
-		printf("\nBuffer: %s\n\n", instance->name);
+		printf("\nBuffer: %s\n\n",
+			tracefs_get_instance_name(instance->tracefs));
 
 	for (cpu = 0; cpu < instance->cpu_count; cpu++)
 		trace_seq_do_printf(&instance->s_print[cpu]);
@@ -3917,7 +3858,8 @@ static void write_guest_file(struct buffer_instance *instance)
 	char **temp_files;
 	int i, fd;
 
-	file = get_guest_file(output_file, instance->name);
+	file = get_guest_file(output_file,
+			      tracefs_get_instance_name(instance->tracefs));
 	if (!file)
 		die("Failed to allocate memory");
 
@@ -4033,7 +3975,7 @@ static void record_data(struct common_record_context *ctx)
 					continue;
 
 				buffer_options[i++] = tracecmd_add_buffer_option(handle,
-										 instance->name,
+										 tracefs_get_instance_name(instance->tracefs),
 										 cpus);
 				add_buffer_stat(handle, instance);
 			}
@@ -4080,7 +4022,7 @@ static int write_func_file(struct buffer_instance *instance,
 	if (!*list)
 		return 0;
 
-	path = get_instance_file(instance, file);
+	path = tracefs_get_instance_file(instance->tracefs, file);
 
 	fd = open(path, O_WRONLY | O_TRUNC);
 	if (fd < 0)
@@ -4124,7 +4066,7 @@ static int functions_filtered(struct buffer_instance *instance)
 	char *path;
 	int fd;
 
-	path = get_instance_file(instance, "set_ftrace_filter");
+	path = tracefs_get_instance_file(instance->tracefs, "set_ftrace_filter");
 	fd = open(path, O_RDONLY);
 	tracefs_put_tracing_file(path);
 	if (fd < 0) {
@@ -4132,7 +4074,7 @@ static int functions_filtered(struct buffer_instance *instance)
 			warning("Can not set set_ftrace_filter");
 		else
 			warning("Can not set set_ftrace_filter for %s",
-				instance->name);
+				tracefs_get_instance_name(instance->tracefs));
 		return 0;
 	}
 
@@ -4292,45 +4234,9 @@ static unsigned long long find_time_stamp(struct tep_handle *pevent)
 	return ts;
 }
 
-static char *read_instance_file(struct buffer_instance *instance, char *file, int *psize)
-{
-	char buffer[BUFSIZ];
-	char *path;
-	char *buf;
-	int size = 0;
-	int fd;
-	int r;
-
-	path = get_instance_file(instance, file);
-	fd = open(path, O_RDONLY);
-	tracefs_put_tracing_file(path);
-	if (fd < 0) {
-		warning("%s not found, --date ignored", file);
-		return NULL;
-	}
-	do {
-		r = read(fd, buffer, BUFSIZ);
-		if (r <= 0)
-			continue;
-		if (size)
-			buf = realloc(buf, size+r+1);
-		else
-			buf = malloc(r+1);
-		if (!buf)
-			die("Failed to allocate instance file buffer");
-		memcpy(buf+size, buffer, r);
-		size += r;
-	} while (r);
-
-	buf[size] = '\0';
-	if (psize)
-		*psize = size;
-	return buf;
-}
-
 static char *read_file(char *file, int *psize)
 {
-	return read_instance_file(&top_instance, file, psize);
+	return tracefs_read_instance_file(top_instance.tracefs, file, psize);
 }
 
 /*
@@ -4463,7 +4369,7 @@ static void set_buffer_size_instance(struct buffer_instance *instance)
 
 	snprintf(buf, BUFSIZ, "%d", buffer_size);
 
-	path = get_instance_file(instance, "buffer_size_kb");
+	path = tracefs_get_instance_file(instance->tracefs, "buffer_size_kb");
 	fd = open(path, O_WRONLY);
 	if (fd < 0) {
 		warning("can't open %s", path);
@@ -4524,7 +4430,7 @@ static void clear_instance_triggers(struct buffer_instance *instance)
 	enum event_iter_type type;
 	enum event_process processed = PROCESSED_NONE;
 
-	path = get_instance_file(instance, "events");
+	path = tracefs_get_instance_file(instance->tracefs, "events");
 	if (!path)
 		die("malloc");
 
@@ -4585,7 +4491,7 @@ static void clear_instance_filters(struct buffer_instance *instance)
 	enum event_iter_type type;
 	enum event_process processed = PROCESSED_NONE;
 
-	path = get_instance_file(instance, "events");
+	path = tracefs_get_instance_file(instance->tracefs, "events");
 	if (!path)
 		die("malloc");
 
@@ -4621,7 +4527,8 @@ static void reset_clock(void)
 	struct buffer_instance *instance;
 
 	for_all_instances(instance)
-		write_instance_file(instance, "trace_clock", "local", "clock");
+		tracefs_write_instance_file(instance->tracefs,
+					    "trace_clock", "local", "clock");
 }
 
 static void reset_cpu_mask(void)
@@ -4640,7 +4547,8 @@ static void reset_cpu_mask(void)
 		strcat(buf, ",ffffffff");
 
 	for_all_instances(instance)
-		write_instance_file(instance, "tracing_cpumask", buf, "cpumask");
+		tracefs_write_instance_file(instance->tracefs,
+					    "tracing_cpumask", buf, "cpumask");
 }
 
 static void reset_event_pid(void)
@@ -4669,7 +4577,7 @@ static void clear_func_filters(void)
 
 	for_all_instances(instance) {
 		for (i = 0; files[i]; i++) {
-			path = get_instance_file(instance, files[i]);
+			path = tracefs_get_instance_file(instance->tracefs, files[i]);
 			clear_func_filter(path);
 			tracefs_put_tracing_file(path);
 		}
@@ -4679,32 +4587,20 @@ static void clear_func_filters(void)
 static void make_instances(void)
 {
 	struct buffer_instance *instance;
-	struct stat st;
-	char *path;
-	int ret;
 
 	for_each_instance(instance) {
 		if (is_guest(instance))
 			continue;
-
-		path = get_instance_dir(instance);
-		ret = stat(path, &st);
-		if (ret < 0) {
-			ret = mkdir(path, 0777);
-			if (ret < 0)
-				die("mkdir %s", path);
-		} else
+		if (tracefs_make_instance(instance->tracefs) > 0) {
 			/* Don't delete instances that already exist */
 			instance->flags |= BUFFER_FL_KEEP;
-		tracefs_put_tracing_file(path);
+		}
 	}
 }
 
 void tracecmd_remove_instances(void)
 {
 	struct buffer_instance *instance;
-	char *path;
-	int ret;
 
 	for_each_instance(instance) {
 		/* Only delete what we created */
@@ -4714,11 +4610,7 @@ void tracecmd_remove_instances(void)
 			close(instance->tracing_on_fd);
 			instance->tracing_on_fd = 0;
 		}
-		path = get_instance_dir(instance);
-		ret = rmdir(path);
-		if (ret < 0)
-			die("rmdir %s", path);
-		tracefs_put_tracing_file(path);
+		tracefs_remove_instance(instance->tracefs);
 	}
 }
 
@@ -5012,7 +4904,8 @@ static int test_stacktrace_trigger(struct buffer_instance *instance)
 	int ret = 0;
 	int fd;
 
-	path = get_instance_file(instance, "events/sched/sched_switch/trigger");
+	path = tracefs_get_instance_file(instance->tracefs,
+					 "events/sched/sched_switch/trigger");
 
 	clear_trigger(path);
 
@@ -5194,6 +5087,15 @@ void update_first_instance(struct buffer_instance *instance, int topt)
 		first_instance = buffer_instances;
 }
 
+void init_top_instance(void)
+{
+	if (!top_instance.tracefs)
+		top_instance.tracefs = tracefs_alloc_instance(NULL);
+	top_instance.cpu_count = count_cpus();
+	top_instance.flags = BUFFER_FL_KEEP;
+	init_instance(&top_instance);
+}
+
 enum {
 	OPT_user		= 243,
 	OPT_procmap		= 244,
@@ -5218,7 +5120,7 @@ void trace_stop(int argc, char **argv)
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
 
-	init_instance(instance);
+	init_top_instance();
 
 	for (;;) {
 		int c;
@@ -5259,7 +5161,7 @@ void trace_restart(int argc, char **argv)
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
 
-	init_instance(instance);
+	init_top_instance();
 
 	for (;;) {
 		int c;
@@ -5301,7 +5203,7 @@ void trace_reset(int argc, char **argv)
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
 
-	init_instance(instance);
+	init_top_instance();
 
 	/* if last arg is -a, then -b and -d apply to all instances */
 	int last_specified_all = 0;
@@ -5386,9 +5288,8 @@ static void init_common_record_context(struct common_record_context *ctx,
 	memset(ctx, 0, sizeof(*ctx));
 	ctx->instance = &top_instance;
 	ctx->curr_cmd = curr_cmd;
-	init_instance(ctx->instance);
 	local_cpu_count = count_cpus();
-	ctx->instance->cpu_count = local_cpu_count;
+	init_top_instance();
 }
 
 #define IS_EXTRACT(ctx) ((ctx)->curr_cmd == CMD_extract)
diff --git a/tracecmd/trace-show.c b/tracecmd/trace-show.c
index 391d329..a6f2102 100644
--- a/tracecmd/trace-show.c
+++ b/tracecmd/trace-show.c
@@ -52,6 +52,8 @@ void trace_show(int argc, char **argv)
 		{NULL, 0, NULL, 0}
 	};
 
+	init_top_instance();
+
 	while ((c = getopt_long(argc-1, argv+1, "B:c:fsp",
 				long_options, &option_index)) >= 0) {
 		switch (c) {
diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 7a1d9bb..948118c 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -31,7 +31,7 @@ static int get_instance_file_fd(struct buffer_instance *instance,
 	char *path;
 	int fd;
 
-	path = get_instance_file(instance, file);
+	path = tracefs_get_instance_file(instance->tracefs, file);
 	fd = open(path, O_RDONLY);
 	tracefs_put_tracing_file(path);
 
@@ -348,7 +348,7 @@ static void report_events(struct buffer_instance *instance)
 
 	free(str);
 
-	path = get_instance_file(instance, "events");
+	path = tracefs_get_instance_file(instance->tracefs, "events");
 	if (!path)
 		die("malloc");
 
@@ -437,7 +437,7 @@ static void report_event_filters(struct buffer_instance *instance)
 	enum event_iter_type type;
 	enum event_process processed = PROCESSED_NONE;
 
-	path = get_instance_file(instance, "events");
+	path = tracefs_get_instance_file(instance->tracefs, "events");
 	if (!path)
 		die("malloc");
 
@@ -510,7 +510,7 @@ static void report_event_triggers(struct buffer_instance *instance)
 	enum event_iter_type type;
 	enum event_process processed = PROCESSED_NONE;
 
-	path = get_instance_file(instance, "events");
+	path = tracefs_get_instance_file(instance->tracefs, "events");
 	if (!path)
 		die("malloc");
 
@@ -599,7 +599,7 @@ static void report_graph_funcs(struct buffer_instance *instance)
 {
 	char *path;
 
-	path = get_instance_file(instance, "set_graph_function");
+	path = tracefs_get_instance_file(instance->tracefs, "set_graph_function");
 	if (!path)
 		die("malloc");
 
@@ -607,7 +607,7 @@ static void report_graph_funcs(struct buffer_instance *instance)
 	
 	tracefs_put_tracing_file(path);
 
-	path = get_instance_file(instance, "set_graph_notrace");
+	path = tracefs_get_instance_file(instance->tracefs, "set_graph_notrace");
 	if (!path)
 		die("malloc");
 
@@ -620,7 +620,7 @@ static void report_ftrace_filters(struct buffer_instance *instance)
 {
 	char *path;
 
-	path = get_instance_file(instance, "set_ftrace_filter");
+	path = tracefs_get_instance_file(instance->tracefs, "set_ftrace_filter");
 	if (!path)
 		die("malloc");
 
@@ -628,7 +628,7 @@ static void report_ftrace_filters(struct buffer_instance *instance)
 	
 	tracefs_put_tracing_file(path);
 
-	path = get_instance_file(instance, "set_ftrace_notrace");
+	path = tracefs_get_instance_file(instance->tracefs, "set_ftrace_notrace");
 	if (!path)
 		die("malloc");
 
@@ -858,7 +858,8 @@ static void stat_instance(struct buffer_instance *instance)
 	if (instance != &top_instance) {
 		if (instance != first_instance)
 			printf("---------------\n");
-		printf("Instance: %s\n", instance->name);
+		printf("Instance: %s\n",
+			tracefs_get_instance_name(instance->tracefs));
 	}
 
 	report_plugin(instance);
@@ -883,6 +884,8 @@ void trace_stat (int argc, char **argv)
 	int status;
 	int c;
 
+	init_top_instance();
+
 	for (;;) {
 		c = getopt(argc-1, argv+1, "tB:");
 		if (c == -1)
-- 
2.23.0

