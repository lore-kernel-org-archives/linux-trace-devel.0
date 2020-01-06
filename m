Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC770C33C9B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 15:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8242920731
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 15:41:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Za6/tj63"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgAFPlK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 10:41:10 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38619 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgAFPlK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 10:41:10 -0500
Received: by mail-lj1-f193.google.com with SMTP id w1so29399080ljh.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Jan 2020 07:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FvnnnTVtTieDZClA9wX6X2MhOgxSCvE/gG61ey0anVI=;
        b=Za6/tj63diKSWbI8844gF8HyQe3iiju98LPFSTpPPI/tjrI3qwviZA0yIjdwbtHTTI
         ITw5N9GHFZovdxsgb/EWFKuXKAzDn24ueSmFO8LGJAsnnayx2RkO5KiWrjOGRK54Dp9v
         houub6ArC6t5HLaEUHq8Nz83j62su+3g9vIDOZRJiXPHERGlCjBTFVDoF/Pbf5ALvdRG
         nOTy1KjoRuVlg4M+6ArDbWPiISlNU7rPjLcjcUq3pH7boTlM47ZMToBIeSIotVbnuybD
         y8bDpd4lGj1C9fdZJ8b9Mjcy10UYFF8E+YDNDNf6DLV8/FmKXIB3jVMhVRhX5752CDLh
         m/fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FvnnnTVtTieDZClA9wX6X2MhOgxSCvE/gG61ey0anVI=;
        b=Tn49/n6bJxIFaYiCr4wu20H4e5LPysELB3uwsExSoIXuUgS8EG2JFlUCI1KcW25l2G
         0zCuzYCKUJ+IExjeeWtMZCzHuZewUI09A4nC7f1eyKq2MqWSZ8oHptsL4U9iTltmnQhn
         Cpnbfc+O+RhAcxw1r8XxV+eQGksK/zYzguxMaOexQEDeSHc4atNAVg5KqmhrBP2kFNxa
         JS/3HXtt1/rJ/wS0sfRPC3edkchQM9vDeggU94MSH74pKYkRdda0EvjyscUU5ESaujbT
         cinCPX+O/8LwqTZbU3iEuWSFSBZw+yee+wZKaeeO6O4WnwY6PBZCaDMyeYtbfbESIaHe
         uxKg==
X-Gm-Message-State: APjAAAUcnrZbCTRwDJupU2ekbf9zHs4uGNmB8inFgNdBqkm1QPE7D0kB
        oD9JKtPPsG+B3SHddzDZ17w=
X-Google-Smtp-Source: APXvYqwVMsSZwXxtCEVjYbDxdmYVs+L2qzLmLJ/V5ppGgUQ3ib4J7LS1eJxiRXlYVeOHrenS7J2OmA==
X-Received: by 2002:a2e:8e85:: with SMTP id z5mr47228336ljk.212.1578325265053;
        Mon, 06 Jan 2020 07:41:05 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u25sm29257677lfk.46.2020.01.06.07.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 07:41:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/5] trace-cmd: New libtracefs APIs for ftrace instances
Date:   Mon,  6 Jan 2020 17:40:56 +0200
Message-Id: <20200106154058.60660-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200106154058.60660-1-tz.stoyanov@gmail.com>
References: <20200106154058.60660-1-tz.stoyanov@gmail.com>
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
 lib/tracefs/tracefs-instance.c      | 267 ++++++++++++++++++++++++++++
 lib/tracefs/tracefs-utils.c         |  43 +++++
 tracecmd/include/trace-local.h      |   5 +-
 tracecmd/trace-list.c               |   2 +-
 tracecmd/trace-record.c             | 264 +++++++++------------------
 tracecmd/trace-show.c               |   2 +
 tracecmd/trace-stat.c               |  21 ++-
 10 files changed, 431 insertions(+), 192 deletions(-)
 create mode 100644 lib/tracefs/tracefs-instance.c

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index e844c75..6b27ff7 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -17,4 +17,21 @@ const char *tracefs_get_tracing_dir(void);
 /* tracefs_find_tracing_dir must be freed */
 char *tracefs_find_tracing_dir(void);
 
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
index 0000000..14e8eed
--- /dev/null
+++ b/lib/tracefs/tracefs-instance.c
@@ -0,0 +1,267 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * Updates:
+ * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/stat.h>
+#include <fcntl.h>
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
+static int write_file(const char *file, const char *str, const char *type)
+{
+	char buf[BUFSIZ];
+	int ret;
+	int fd;
+
+	fd = open(file, O_WRONLY | O_TRUNC);
+	if (fd < 0) {
+		warning("Failed to open '%s'", file);
+		return -1;
+	}
+	ret = write(fd, str, strlen(str));
+	close(fd);
+	if (ret < 0 && type) {
+		/* write failed */
+		fd = open(file, O_RDONLY);
+		if (fd < 0) {
+			warning("Failed to write in '%s'", file);
+			return -1;
+		}
+
+		while ((ret = read(fd, buf, BUFSIZ)) > 0)
+			fprintf(stderr, "%.*s", ret, buf);
+		warning("Failed %s of %s\n", type, file);
+		close(fd);
+	}
+	return ret;
+}
+
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
+		ret = write_file(path, str, type);
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
index 0ef16fc..bdab130 100644
--- a/lib/tracefs/tracefs-utils.c
+++ b/lib/tracefs/tracefs-utils.c
@@ -10,6 +10,9 @@
 #include <sys/mount.h>
 #include <sys/stat.h>
 #include <linux/limits.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
 
 #include "tracefs.h"
 
@@ -181,3 +184,43 @@ void tracefs_put_tracing_file(char *name)
 {
 	free(name);
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
index 5355813..62f67d5 100644
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
@@ -784,54 +790,6 @@ static int set_ftrace(int set, int use_proc)
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
 static int write_file(const char *file, const char *str, const char *type)
 {
 	char buf[BUFSIZ];
@@ -857,23 +815,6 @@ static int write_file(const char *file, const char *str, const char *type)
 	return ret;
 }
 
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
-	if (ret == 0)
-		ret = write_file(path, str, type);
-	tracefs_put_tracing_file(path);
-
-	return ret;
-}
-
 static void __clear_trace(struct buffer_instance *instance)
 {
 	FILE *fp;
@@ -883,7 +824,7 @@ static void __clear_trace(struct buffer_instance *instance)
 		return;
 
 	/* reset the trace */
-	path = get_instance_file(instance, "trace");
+	path = tracefs_get_instance_file(instance->tracefs, "trace");
 	fp = fopen(path, "w");
 	if (!fp)
 		die("writing to '%s'", path);
@@ -917,8 +858,8 @@ static void clear_trace(void)
 
 static void reset_max_latency(struct buffer_instance *instance)
 {
-	 write_instance_file(instance,
-			     "tracing_max_latency", "0", "max_latency");
+	tracefs_write_instance_file(instance->tracefs,
+				    "tracing_max_latency", "0", "max_latency");
 }
 
 static void add_filter_pid(int pid, int exclude)
@@ -1364,7 +1305,8 @@ static void add_event_pid(const char *buf)
 	struct buffer_instance *instance;
 
 	for_all_instances(instance)
-		write_instance_file(instance, "set_event_pid", buf, "event_pid");
+		tracefs_write_instance_file(instance->tracefs,
+					    "set_event_pid", buf, "event_pid");
 }
 
 static void add_new_filter_pid(int pid)
@@ -1593,7 +1535,7 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 	if (is_guest(instance))
 		return;
 
-	path = get_instance_file(instance, "current_tracer");
+	path = tracefs_get_instance_file(instance->tracefs, "current_tracer");
 	fp = fopen(path, "w");
 	if (!fp) {
 		/*
@@ -1617,7 +1559,7 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 
 	/* Make sure func_stack_trace option is disabled */
 	/* First try instance file, then top level */
-	path = get_instance_file(instance, "options/func_stack_trace");
+	path = tracefs_get_instance_file(instance->tracefs, "options/func_stack_trace");
 	fp = fopen(path, "w");
 	if (!fp) {
 		tracefs_put_tracing_file(path);
@@ -1678,8 +1620,6 @@ static int set_option(const char *option)
 	return 0;
 }
 
-static char *read_instance_file(struct buffer_instance *instance, char *file, int *psize);
-
 static void disable_func_stack_trace_instance(struct buffer_instance *instance)
 {
 	struct stat st;
@@ -1692,13 +1632,14 @@ static void disable_func_stack_trace_instance(struct buffer_instance *instance)
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
@@ -1851,7 +1792,7 @@ static int trace_check_file_exists(struct buffer_instance *instance, char *file)
 	char *path;
 	int ret;
 
-	path = get_instance_file(instance, file);
+	path = tracefs_get_instance_file(instance->tracefs, file);
 	ret = stat(path, &st);
 	tracefs_put_tracing_file(path);
 
@@ -1930,7 +1871,7 @@ reset_events_instance(struct buffer_instance *instance)
 	}
 
 	c = '0';
-	path = get_instance_file(instance, "events/enable");
+	path = tracefs_get_instance_file(instance->tracefs, "events/enable");
 	fd = open(path, O_WRONLY);
 	if (fd < 0)
 		die("opening to '%s'", path);
@@ -1938,7 +1879,7 @@ reset_events_instance(struct buffer_instance *instance)
 	close(fd);
 	tracefs_put_tracing_file(path);
 
-	path = get_instance_file(instance, "events/*/filter");
+	path = tracefs_get_instance_file(instance->tracefs, "events/*/filter");
 	globbuf.gl_offs = 0;
 	ret = glob(path, 0, NULL, &globbuf);
 	tracefs_put_tracing_file(path);
@@ -2199,7 +2140,7 @@ static int open_instance_fd(struct buffer_instance *instance,
 	int fd;
 	char *path;
 
-	path = get_instance_file(instance, file);
+	path = tracefs_get_instance_file(instance->tracefs, file);
 	fd = open(path, flags);
 	if (fd < 0) {
 		/* instances may not be created yet */
@@ -2508,7 +2449,7 @@ static void set_mask(struct buffer_instance *instance)
 	if (!instance->cpumask)
 		return;
 
-	path = get_instance_file(instance, "tracing_cpumask");
+	path = tracefs_get_instance_file(instance->tracefs, "tracing_cpumask");
 	if (!path)
 		die("could not allocate path");
 	reset_save_file(path, RESET_DEFAULT_PRIO);
@@ -2569,7 +2510,8 @@ static void set_clock(struct buffer_instance *instance)
 		return;
 
 	/* The current clock is in brackets, reset it when we are done */
-	content = read_instance_file(instance, "trace_clock", NULL);
+	content = tracefs_read_instance_file(instance->tracefs,
+					     "trace_clock", NULL);
 
 	/* check if first clock is set */
 	if (*content == '[')
@@ -2580,13 +2522,14 @@ static void set_clock(struct buffer_instance *instance)
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
@@ -2597,11 +2540,11 @@ static void set_max_graph_depth(struct buffer_instance *instance, char *max_grap
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
@@ -2718,7 +2661,7 @@ static int expand_event_files(struct buffer_instance *instance,
 	if (ret < 0)
 		die("Failed to allocate event filter path for %s", file);
 
-	path = get_instance_file(instance, p);
+	path = tracefs_get_instance_file(instance->tracefs, p);
 
 	globbuf.gl_offs = 0;
 	ret = glob(path, 0, NULL, &globbuf);
@@ -3180,10 +3123,7 @@ create_recorder_instance_pipe(struct buffer_instance *instance,
 	unsigned flags = recorder_flags | TRACECMD_RECORD_BLOCK;
 	char *path;
 
-	if (instance->name)
-		path = get_instance_dir(instance);
-	else
-		path = tracefs_find_tracing_dir();
+	path = tracefs_get_instance_dir(instance->tracefs);
 
 	if (!path)
 		die("malloc");
@@ -3193,8 +3133,7 @@ create_recorder_instance_pipe(struct buffer_instance *instance,
 
 	recorder = tracecmd_create_buffer_recorder_fd(brass[1], cpu, flags, path);
 
-	if (instance->name)
-		tracefs_put_tracing_file(path);
+	tracefs_put_tracing_file(path);
 
 	return recorder;
 }
@@ -3228,10 +3167,10 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 	if (brass)
 		return create_recorder_instance_pipe(instance, cpu, brass);
 
-	if (!instance->name)
+	if (!tracefs_get_instance_name(instance->tracefs))
 		return tracecmd_create_recorder_maxkb(file, cpu, recorder_flags, max_kb);
 
-	path = get_instance_dir(instance);
+	path = tracefs_get_instance_dir(instance->tracefs);
 
 	record = tracecmd_create_buffer_recorder_maxkb(file, cpu, recorder_flags,
 						       path, max_kb);
@@ -3285,8 +3224,8 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
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
@@ -3597,9 +3536,11 @@ static void connect_to_agent(struct buffer_instance *instance)
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
 
@@ -3626,7 +3567,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 		if (nr_cpus != nr_fifos) {
 			warning("number of FIFOs (%d) for guest %s differs "
 				"from number of virtual CPUs (%d)",
-				nr_fifos, instance->name, nr_cpus);
+				nr_fifos, name, nr_cpus);
 			nr_cpus = nr_cpus < nr_fifos ? nr_cpus : nr_fifos;
 		}
 		free(ports);
@@ -3652,7 +3593,8 @@ static void setup_guest(struct buffer_instance *instance)
 	int fd;
 
 	/* Create a place to store the guest meta data */
-	file = get_guest_file(output_file, instance->name);
+	file = get_guest_file(output_file,
+			      tracefs_get_instance_name(instance->tracefs));
 	if (!file)
 		die("Failed to allocate memory");
 
@@ -3828,7 +3770,8 @@ add_buffer_stat(struct tracecmd_output *handle, struct buffer_instance *instance
 	int i;
 
 	trace_seq_init(&s);
-	trace_seq_printf(&s, "\nBuffer: %s\n\n", instance->name);
+	trace_seq_printf(&s, "\nBuffer: %s\n\n",
+			tracefs_get_instance_name(instance->tracefs));
 	tracecmd_add_option(handle, TRACECMD_OPTION_CPUSTAT,
 			    s.len+1, s.buffer);
 	trace_seq_destroy(&s);
@@ -3894,7 +3837,8 @@ static void print_stat(struct buffer_instance *instance)
 		return;
 
 	if (!is_top_instance(instance))
-		printf("\nBuffer: %s\n\n", instance->name);
+		printf("\nBuffer: %s\n\n",
+			tracefs_get_instance_name(instance->tracefs));
 
 	for (cpu = 0; cpu < instance->cpu_count; cpu++)
 		trace_seq_do_printf(&instance->s_print[cpu]);
@@ -3934,7 +3878,8 @@ static void write_guest_file(struct buffer_instance *instance)
 	char **temp_files;
 	int i, fd;
 
-	file = get_guest_file(output_file, instance->name);
+	file = get_guest_file(output_file,
+			      tracefs_get_instance_name(instance->tracefs));
 	if (!file)
 		die("Failed to allocate memory");
 
@@ -4050,7 +3995,7 @@ static void record_data(struct common_record_context *ctx)
 					continue;
 
 				buffer_options[i++] = tracecmd_add_buffer_option(handle,
-										 instance->name,
+										 tracefs_get_instance_name(instance->tracefs),
 										 cpus);
 				add_buffer_stat(handle, instance);
 			}
@@ -4097,7 +4042,7 @@ static int write_func_file(struct buffer_instance *instance,
 	if (!*list)
 		return 0;
 
-	path = get_instance_file(instance, file);
+	path = tracefs_get_instance_file(instance->tracefs, file);
 
 	fd = open(path, O_WRONLY | O_TRUNC);
 	if (fd < 0)
@@ -4141,7 +4086,7 @@ static int functions_filtered(struct buffer_instance *instance)
 	char *path;
 	int fd;
 
-	path = get_instance_file(instance, "set_ftrace_filter");
+	path = tracefs_get_instance_file(instance->tracefs, "set_ftrace_filter");
 	fd = open(path, O_RDONLY);
 	tracefs_put_tracing_file(path);
 	if (fd < 0) {
@@ -4149,7 +4094,7 @@ static int functions_filtered(struct buffer_instance *instance)
 			warning("Can not set set_ftrace_filter");
 		else
 			warning("Can not set set_ftrace_filter for %s",
-				instance->name);
+				tracefs_get_instance_name(instance->tracefs));
 		return 0;
 	}
 
@@ -4309,45 +4254,9 @@ static unsigned long long find_time_stamp(struct tep_handle *pevent)
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
@@ -4480,7 +4389,7 @@ static void set_buffer_size_instance(struct buffer_instance *instance)
 
 	snprintf(buf, BUFSIZ, "%d", buffer_size);
 
-	path = get_instance_file(instance, "buffer_size_kb");
+	path = tracefs_get_instance_file(instance->tracefs, "buffer_size_kb");
 	fd = open(path, O_WRONLY);
 	if (fd < 0) {
 		warning("can't open %s", path);
@@ -4541,7 +4450,7 @@ static void clear_instance_triggers(struct buffer_instance *instance)
 	enum event_iter_type type;
 	enum event_process processed = PROCESSED_NONE;
 
-	path = get_instance_file(instance, "events");
+	path = tracefs_get_instance_file(instance->tracefs, "events");
 	if (!path)
 		die("malloc");
 
@@ -4602,7 +4511,7 @@ static void clear_instance_filters(struct buffer_instance *instance)
 	enum event_iter_type type;
 	enum event_process processed = PROCESSED_NONE;
 
-	path = get_instance_file(instance, "events");
+	path = tracefs_get_instance_file(instance->tracefs, "events");
 	if (!path)
 		die("malloc");
 
@@ -4638,7 +4547,8 @@ static void reset_clock(void)
 	struct buffer_instance *instance;
 
 	for_all_instances(instance)
-		write_instance_file(instance, "trace_clock", "local", "clock");
+		tracefs_write_instance_file(instance->tracefs,
+					    "trace_clock", "local", "clock");
 }
 
 static void reset_cpu_mask(void)
@@ -4657,7 +4567,8 @@ static void reset_cpu_mask(void)
 		strcat(buf, ",ffffffff");
 
 	for_all_instances(instance)
-		write_instance_file(instance, "tracing_cpumask", buf, "cpumask");
+		tracefs_write_instance_file(instance->tracefs,
+					    "tracing_cpumask", buf, "cpumask");
 }
 
 static void reset_event_pid(void)
@@ -4686,7 +4597,7 @@ static void clear_func_filters(void)
 
 	for_all_instances(instance) {
 		for (i = 0; files[i]; i++) {
-			path = get_instance_file(instance, files[i]);
+			path = tracefs_get_instance_file(instance->tracefs, files[i]);
 			clear_func_filter(path);
 			tracefs_put_tracing_file(path);
 		}
@@ -4696,32 +4607,20 @@ static void clear_func_filters(void)
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
@@ -4731,11 +4630,7 @@ void tracecmd_remove_instances(void)
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
 
@@ -5029,7 +4924,8 @@ static int test_stacktrace_trigger(struct buffer_instance *instance)
 	int ret = 0;
 	int fd;
 
-	path = get_instance_file(instance, "events/sched/sched_switch/trigger");
+	path = tracefs_get_instance_file(instance->tracefs,
+					 "events/sched/sched_switch/trigger");
 
 	clear_trigger(path);
 
@@ -5211,6 +5107,15 @@ void update_first_instance(struct buffer_instance *instance, int topt)
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
@@ -5235,7 +5140,7 @@ void trace_stop(int argc, char **argv)
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
 
-	init_instance(instance);
+	init_top_instance();
 
 	for (;;) {
 		int c;
@@ -5276,7 +5181,7 @@ void trace_restart(int argc, char **argv)
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
 
-	init_instance(instance);
+	init_top_instance();
 
 	for (;;) {
 		int c;
@@ -5318,7 +5223,7 @@ void trace_reset(int argc, char **argv)
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
 
-	init_instance(instance);
+	init_top_instance();
 
 	/* if last arg is -a, then -b and -d apply to all instances */
 	int last_specified_all = 0;
@@ -5403,9 +5308,8 @@ static void init_common_record_context(struct common_record_context *ctx,
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
2.24.1

