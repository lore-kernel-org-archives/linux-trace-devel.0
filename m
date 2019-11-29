Return-Path: <SRS0=Qwo8=ZV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4611BC432C0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E664C217BA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BEe6NzCE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfK2KRq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Nov 2019 05:17:46 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40188 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfK2KRq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Nov 2019 05:17:46 -0500
Received: by mail-lj1-f195.google.com with SMTP id s22so12374931ljs.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Nov 2019 02:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8BtKYTA6xxHKi5JJuPFRfKVPOtDulvCy35nEYDQfeZ0=;
        b=BEe6NzCE9/FddN9XALVh72pGrk+7pzq0HZDDJlwLywdtxZqWaTX5ckkpmIyUwLfNuX
         SAr64NzuxkspSSy7+hOOa/v9tXIIjJXcqP2OeG7pOKUez9ioWhWSuHv3WPQgmDX+Z+YS
         ggsne+jfkfU8jiE6i4Fzb7c11IdbFBRyZDFWSI/ffGt1+ulAMgTtUC/vLXsogcpurjLj
         F59DR1Ff8YJiUunENB/sx8eFk7hitr39pdh1KEV3lfOJ/ZSXMYE5Ij/7ZDhIfq2GB5gm
         m7HUeHvfQC7VMDdzyQ01jQchVvnnQc0452M9smbqB1k4lbyXwIMOoBvED9oVgO5c47Qe
         9XGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8BtKYTA6xxHKi5JJuPFRfKVPOtDulvCy35nEYDQfeZ0=;
        b=Xh4ja+n5K2nJNcU83SBGRyZYO2sex0BHZb58imQ7Ubm56P1cQ5JeyZrNSu6rDTCHAN
         lBY8nGVGA99G9SuMaLQAeAKJthAZTPV23IbIzlEdN7S/HTbNxCKeeocI306Scj0P4RCc
         5t3WFiqAwv9FmMeslEsRRyph87a6Xey5JwqUFlKN1ZSnid3o3B9myg+/Ohtf1FAM17Y8
         39K5RfZ7wlN9DUk5+jSaYug+Xtv1nHR1ItqFyhXn9gBLZxlHMSs6yiPIkGOuCH+Q3HJh
         UshTaje6mqRn7rKoUUiH/+/vlH5VQ3W9EZvVJbfv4bofHRB9qS8HLMkvW3v6k5HB9vjc
         2hNg==
X-Gm-Message-State: APjAAAXTFm8S0w2By70guQJgOXKq9lcDVGJbU6eFpvintm3ByjBmfTPm
        gTuWbJSEz8RBtKDvhbDZC3M=
X-Google-Smtp-Source: APXvYqxkzzSCHA+JvL8+fZNNqTVfNBzFgCTE+vTek6j915+OAP5s7wSkd8ZqVNKqCkipnVXyzCcPCg==
X-Received: by 2002:a05:651c:1066:: with SMTP id y6mr37914987ljm.96.1575022661541;
        Fri, 29 Nov 2019 02:17:41 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x29sm11367935lfg.45.2019.11.29.02.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 02:17:40 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v16 04/18] trace-cmd: Add new library APIs for ftrace instances.
Date:   Fri, 29 Nov 2019 12:17:19 +0200
Message-Id: <20191129101733.375808-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191129101733.375808-1-tz.stoyanov@gmail.com>
References: <20191129101733.375808-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

In order to reuse the code, the functionality related to
ftrace instances is moved from trace-cmd application to
libtracecmd. The following new library APIs are introduced:

library structure, representing a ftrace instance:
	struct tracecmd_instance {
        	char    *name;
	        char    *clock;
	};

APIs for creating and deleting ftrace instances:
	struct tracecmd_instance *tracecmd_create_instance(const char *name);
	void tracecmd_free_instance(struct tracecmd_instance *instance);
	int tracecmd_make_instance(struct tracecmd_instance *instance);
	void tracecmd_remove_instance(struct tracecmd_instance *instance);

APIs for reading and writing ftrace files, instance aware:
	char *tracecmd_get_instance_file(struct tracecmd_instance *instance, const char *file);
	char *tracecmd_get_instance_dir(struct tracecmd_instance *instance);
	int tracecmd_write_instance_file(struct tracecmd_instance *instance,
	                                 const char *file, const char *str,
        	                         const char *type);
	int tracecmd_write_file(const char *file, const char *str, const char *type);
	char *tracecmd_read_instance_file(struct tracecmd_instance *instance,
        	                          char *file, int *psize);

API for setting ftrace clock, instance aware:
	void tracecmd_set_clock(struct tracecmd_instance *instance, char **old_clock);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h           |  24 ++
 lib/trace-cmd/Makefile                  |   1 +
 lib/trace-cmd/include/trace-cmd-local.h |  33 +--
 lib/trace-cmd/trace-instance.c          | 265 ++++++++++++++++++
 lib/trace-cmd/trace-util.c              |  71 ++++-
 tracecmd/include/trace-local.h          |   6 +-
 tracecmd/trace-list.c                   |   2 +-
 tracecmd/trace-record.c                 | 341 +++++++-----------------
 tracecmd/trace-show.c                   |   2 +
 tracecmd/trace-stat.c                   |  20 +-
 10 files changed, 472 insertions(+), 293 deletions(-)
 create mode 100644 lib/trace-cmd/trace-instance.c

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 7f9cb73..5287d23 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -356,6 +356,30 @@ int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
 				 unsigned int **ports, bool *use_fifos);
+/* --- ftrace instances --- */
+
+struct tracecmd_instance {
+	char	*name;
+	char	*clock;
+};
+
+struct tracecmd_instance *tracecmd_create_instance(const char *name);
+void tracecmd_free_instance(struct tracecmd_instance *instance);
+int tracecmd_make_instance(struct tracecmd_instance *instance);
+void tracecmd_remove_instance(struct tracecmd_instance *instance);
+char *
+tracecmd_get_instance_file(struct tracecmd_instance *instance, const char *file);
+char *tracecmd_get_instance_dir(struct tracecmd_instance *instance);
+int tracecmd_write_instance_file(struct tracecmd_instance *instance,
+				 const char *file, const char *str,
+				 const char *type);
+
+int tracecmd_write_file(const char *file, const char *str, const char *type);
+char *tracecmd_read_instance_file(struct tracecmd_instance *instance,
+				  char *file, int *psize);
+
+void tracecmd_set_clock(struct tracecmd_instance *instance, char **old_clock);
+
 
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 3b4b5aa..18c7013 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -13,6 +13,7 @@ OBJS += trace-input.o
 OBJS += trace-output.o
 OBJS += trace-recorder.o
 OBJS += trace-util.o
+OBJS += trace-instance.o
 OBJS += trace-filter-hash.o
 OBJS += trace-msg.o
 
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 09574db..eef4d39 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -18,36 +18,7 @@
 #define STR(x)	_STR(x)
 #define FILE_VERSION_STRING STR(FILE_VERSION)
 
-static ssize_t __do_write(int fd, const void *data, size_t size)
-{
-	ssize_t tot = 0;
-	ssize_t w;
-
-	do {
-		w = write(fd, data + tot, size - tot);
-		tot += w;
-
-		if (!w)
-			break;
-		if (w < 0)
-			return w;
-	} while (tot != size);
-
-	return tot;
-}
-
-static ssize_t
-__do_write_check(int fd, const void *data, size_t size)
-{
-	ssize_t ret;
-
-	ret = __do_write(fd, data, size);
-	if (ret < 0)
-		return ret;
-	if (ret != size)
-		return -1;
-
-	return 0;
-}
+ssize_t __do_write_check(int fd, const void *data, size_t size);
+void __noreturn die(const char *fmt, ...); /* Can be overriden */
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-instance.c b/lib/trace-cmd/trace-instance.c
new file mode 100644
index 0000000..1175b8c
--- /dev/null
+++ b/lib/trace-cmd/trace-instance.c
@@ -0,0 +1,265 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2019, VMware, Tzvetomir Stoyanov tz.stoyanov@gmail.com>
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <time.h>
+#include <poll.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/stat.h>
+
+#include "trace-cmd.h"
+#include "trace-cmd-local.h"
+
+/**
+ * tracecmd_put_tracing_file - Free tracing file / dir, created by
+ *		tracecmd_get_instance_dir() or tracecmd_get_instance_file()
+ *		APIs.
+ *@name: The name of the tracing file or dir
+ */
+void tracecmd_put_tracing_file(char *name)
+{
+	free(name);
+}
+
+/**
+ * tracecmd_create_instance - allocate a new ftrace instance
+ * @name: The name of the instance (instance will point to this)
+ *
+ * Returns a newly allocated instance. Note that @name will not be
+ * copied, and the instance buffer will point to the string itself.
+ */
+struct tracecmd_instance *tracecmd_create_instance(const char *name)
+{
+	struct tracecmd_instance *instance;
+
+	instance = malloc(sizeof(*instance));
+	if (!instance)
+		return NULL;
+	memset(instance, 0, sizeof(*instance));
+	if (name)
+		instance->name = strdup(name);
+
+	return instance;
+}
+
+/**
+ * tracecmd_free_instance - Free an instance struct, previously allocated by
+ *			    tracecmd_create_instance().
+ *@instance: Pointer to the instance to be freed
+ *
+ */
+void tracecmd_free_instance(struct tracecmd_instance *instance)
+{
+	if (!instance)
+		return;
+
+	free(instance->name);
+	free(instance);
+}
+
+/**
+ * tracecmd_make_instance - Create a new ftrace instance
+ * @instance: Pointer to the instance to be created
+ *
+ * Returns -1 in case of an erro, or 0 otherwise.
+ */
+int tracecmd_make_instance(struct tracecmd_instance *instance)
+{
+	struct stat st;
+	char *path;
+	int ret;
+
+	path = tracecmd_get_instance_dir(instance);
+	ret = stat(path, &st);
+	if (ret < 0) {
+		ret = mkdir(path, 0777);
+		if (ret < 0)
+			return ret;
+
+	} else
+		ret = 1;
+	tracecmd_put_tracing_file(path);
+	return ret;
+}
+
+/**
+ * tracecmd_remove_instance - Remove a ftrace instance
+ * @instance: Pointer to the instance to be removed
+ *
+ */
+void tracecmd_remove_instance(struct tracecmd_instance *instance)
+{
+	char *path;
+
+	path = tracecmd_get_instance_dir(instance);
+	rmdir(path);
+	tracecmd_put_tracing_file(path);
+}
+
+/**
+ * tracecmd_get_instance_file - return the path to a instance file.
+ * @instance: buffer instance for the file, can be NULL for the top instance
+ * @file: name of file to return
+ *
+ * Returns the path name of the @file for the given @instance.
+ *
+ * Must use tracecmd_put_tracing_file() to free the returned string.
+ */
+char *
+tracecmd_get_instance_file(struct tracecmd_instance *instance, const char *file)
+{
+	char *path;
+	char *buf;
+	int ret;
+
+	if (instance && instance->name) {
+		ret = asprintf(&buf, "instances/%s/%s", instance->name, file);
+		if (ret < 0)
+			die("Failed to allocate name for %s/%s", instance->name, file);
+		path = tracecmd_get_tracing_file(buf);
+		free(buf);
+	} else
+		path = tracecmd_get_tracing_file(file);
+
+	return path;
+}
+
+/**
+ * tracecmd_get_instance_file - return the path to a instance file.
+ * @instance: buffer instance for the file, can be NULL for the top instance
+ * @file: name of file to return
+ *
+ * Returns the path name of the @file for the given @instance.
+ *
+ * Must use tracecmd_put_tracing_file() to free the returned string.
+ */
+char *tracecmd_get_instance_dir(struct tracecmd_instance *instance)
+{
+	char *buf;
+	char *path;
+	int ret;
+
+	if (instance->name) {
+		ret = asprintf(&buf, "instances/%s", instance->name);
+		if (ret < 0)
+			die("Failed to allocate for instance %s", instance->name);
+		path = tracecmd_get_tracing_file(buf);
+		free(buf);
+	} else
+		path = tracecmd_find_tracing_dir();
+
+	return path;
+}
+
+/**
+ * tracecmd_write_instance_file - Write in trace file of specific instance.
+ * @instance: buffer instance for the file, can be NULL for the top instance
+ * @file: name of the file
+ * @str: Null terminated string, that will be written in the file.
+ * @type: Null terminated string, describing the current write operation.
+ *	  Used for logging purposes.
+ *
+ * Returns the number of written bytes, or -1 in case of an error
+ */
+int tracecmd_write_instance_file(struct tracecmd_instance *instance,
+				 const char *file, const char *str,
+				 const char *type)
+{
+	struct stat st;
+	char *path;
+	int ret;
+
+	path = tracecmd_get_instance_file(instance, file);
+	ret = stat(path, &st);
+	if (ret == 0)
+		ret = tracecmd_write_file(path, str, type);
+	tracecmd_put_tracing_file(path);
+
+	return ret;
+}
+
+/**
+ * tracecmd_read_instance_file - Read from a trace file of specific instance.
+ * @instance: buffer instance for the file, can be NULL for the top instance
+ * @file: name of the file
+ * @psize: Returns the number of bytes read.
+ *
+ * Returns a pointer to a NULL terminated string, read from the file, or NULL in
+ * case of an error.
+ */
+char *tracecmd_read_instance_file(struct tracecmd_instance *instance,
+				  char *file, int *psize)
+{
+	char buffer[BUFSIZ];
+	int size = 0;
+	char *path;
+	char *buf;
+	int fd;
+	int r;
+
+	path = tracecmd_get_instance_file(instance, file);
+	fd = open(path, O_RDONLY);
+	tracecmd_put_tracing_file(path);
+	if (fd < 0) {
+		warning("File %s not found", file);
+		return NULL;
+	}
+	do {
+		r = read(fd, buffer, BUFSIZ);
+		if (r <= 0)
+			continue;
+		if (size)
+			buf = realloc(buf, size+r+1);
+		else
+			buf = malloc(r+1);
+		if (!buf)
+			die("Failed to allocate instance file buffer");
+		memcpy(buf+size, buffer, r);
+		size += r;
+	} while (r);
+
+	buf[size] = '\0';
+	if (psize)
+		*psize = size;
+	return buf;
+}
+
+/**
+ * tracecmd_set_clock - Set the clock of ftrace event's timestamps, per instance.
+ * @instance: Pointer to ftrace instance, containing the desired clock.
+ * @old_clock: Optional, return the newly allocated string with the old clock.
+ *
+ */
+void tracecmd_set_clock(struct tracecmd_instance *instance, char **old_clock)
+{
+	char *content;
+	char *str;
+
+	if (!instance->clock)
+		return;
+
+	/* The current clock is in brackets, reset it when we are done */
+	content = tracecmd_read_instance_file(instance, "trace_clock", NULL);
+
+	/* check if first clock is set */
+	if (*content == '[')
+		str = strtok(content+1, "]");
+	else {
+		str = strtok(content, "[");
+		if (!str)
+			die("Can not find clock in trace_clock");
+		str = strtok(NULL, "]");
+	}
+	if (old_clock)
+		*old_clock = strdup(str);
+
+	free(content);
+	tracecmd_write_instance_file(instance,
+				     "trace_clock", instance->clock, "clock");
+}
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 49a80ae..4c70d9a 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -918,11 +918,6 @@ char *tracecmd_get_tracing_file(const char *name)
 	return file;
 }
 
-void tracecmd_put_tracing_file(char *name)
-{
-	free(name);
-}
-
 void __noreturn __vdie(const char *fmt, va_list ap)
 {
 	int ret = errno;
@@ -967,6 +962,38 @@ void __weak *malloc_or_die(unsigned int size)
 	return data;
 }
 
+
+static ssize_t __do_write(int fd, const void *data, size_t size)
+{
+	ssize_t tot = 0;
+	ssize_t w;
+
+	do {
+		w = write(fd, data + tot, size - tot);
+		tot += w;
+
+		if (!w)
+			break;
+		if (w < 0)
+			return w;
+	} while (tot != size);
+
+	return tot;
+}
+
+ssize_t
+__do_write_check(int fd, const void *data, size_t size)
+{
+	ssize_t ret;
+
+	ret = __do_write(fd, data, size);
+	if (ret < 0)
+		return ret;
+	if (ret != size)
+		return -1;
+
+	return 0;
+}
 #define LOG_BUF_SIZE 1024
 static void __plog(const char *prefix, const char *fmt, va_list ap, FILE *fp)
 {
@@ -1084,3 +1111,37 @@ int tracecmd_stack_tracer_status(int *status)
 	*status = num;
 	return 1; /* full success */
 }
+
+/*
+ * tracecmd_write_file - Write in trace file
+ * @file: Full name of the trace file.
+ * @str: Null terminated string, that will be written in the file.
+ * @type: Null terminated string, describing the current write operation.
+ *	  Used for logging purposes.
+ *
+ * Returns the number of written bytes, or -1 in case of an error
+ */
+int tracecmd_write_file(const char *file, const char *str, const char *type)
+{
+	char buf[BUFSIZ];
+	int ret;
+	int fd;
+
+	fd = open(file, O_WRONLY | O_TRUNC);
+	if (fd < 0)
+		die("opening to '%s'", file);
+	ret = write(fd, str, strlen(str));
+	close(fd);
+	if (ret < 0 && type) {
+		/* write failed */
+		fd = open(file, O_RDONLY);
+		if (fd < 0)
+			die("writing to '%s'", file);
+		/* the filter has the error */
+		while ((ret = read(fd, buf, BUFSIZ)) > 0)
+			fprintf(stderr, "%.*s", ret, buf);
+		die("Failed %s of %s\n", type, file);
+		close(fd);
+	}
+	return ret;
+}
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index fedc0b7..3a05e9c 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -181,7 +181,7 @@ struct pid_addr_maps {
 
 struct buffer_instance {
 	struct buffer_instance	*next;
-	const char		*name;
+	struct tracecmd_instance	*ftrace;
 	char			*cpumask;
 	struct event_list	*events;
 	struct event_list	**event_next;
@@ -195,7 +195,6 @@ struct buffer_instance {
 	struct func_list	*filter_funcs;
 	struct func_list	*notrace_funcs;
 
-	const char		*clock;
 	unsigned int		*client_ports;
 
 	struct trace_seq	*s_save;
@@ -225,6 +224,8 @@ struct buffer_instance {
 	bool			use_fifos;
 };
 
+void init_top_instance(void);
+
 extern struct buffer_instance top_instance;
 extern struct buffer_instance *buffer_instances;
 extern struct buffer_instance *first_instance;
@@ -238,7 +239,6 @@ extern struct buffer_instance *first_instance;
 
 struct buffer_instance *create_instance(const char *name);
 void add_instance(struct buffer_instance *instance, int cpu_count);
-char *get_instance_file(struct buffer_instance *instance, const char *file);
 void update_first_instance(struct buffer_instance *instance, int topt);
 
 void show_instance_file(struct buffer_instance *instance, const char *name);
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 65099a5..e0782ed 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -33,7 +33,7 @@ void show_instance_file(struct buffer_instance *instance, const char *name)
 {
 	char *path;
 
-	path = get_instance_file(instance, name);
+	path = tracecmd_get_instance_file(instance->ftrace, name);
 	dump_file_content(path);
 	tracecmd_put_tracing_file(path);
 }
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 80b2234..13a7cda 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -173,7 +173,7 @@ static struct reset_file *reset_files;
 /* Triggers need to be cleared in a special way */
 static struct reset_file *reset_triggers;
 
-struct buffer_instance top_instance = { .flags = BUFFER_FL_KEEP };
+struct buffer_instance top_instance;
 struct buffer_instance *buffer_instances;
 struct buffer_instance *first_instance;
 
@@ -191,7 +191,7 @@ static inline int no_top_instance(void)
 	return first_instance != &top_instance;
 }
 
-static void init_instance(struct buffer_instance *instance)
+void tracecmd_init_instance(struct buffer_instance *instance)
 {
 	instance->event_next = &instance->events;
 }
@@ -318,7 +318,7 @@ static void reset_save_file_cond(const char *file, int prio,
  */
 void add_instance(struct buffer_instance *instance, int cpu_count)
 {
-	init_instance(instance);
+	tracecmd_init_instance(instance);
 	instance->next = buffer_instances;
 	if (first_instance == buffer_instances)
 		first_instance = instance;
@@ -371,7 +371,12 @@ struct buffer_instance *create_instance(const char *name)
 	if (!instance)
 		return NULL;
 	memset(instance, 0, sizeof(*instance));
-	instance->name = name;
+
+	instance->ftrace = tracecmd_create_instance(name);
+	if (!instance->ftrace) {
+		free(instance);
+		return NULL;
+	}
 
 	return instance;
 }
@@ -471,7 +476,7 @@ void tracecmd_stat_cpu_instance(struct buffer_instance *instance,
 		return;
 	snprintf(file, 40, "per_cpu/cpu%d/stats", cpu);
 
-	path = get_instance_file(instance, file);
+	path = tracecmd_get_instance_file(instance->ftrace, file);
 	free(file);
 	fd = open(path, O_RDONLY);
 	tracecmd_put_tracing_file(path);
@@ -505,12 +510,12 @@ static void add_event(struct buffer_instance *instance, struct event_list *event
 static void reset_event_list(struct buffer_instance *instance)
 {
 	instance->events = NULL;
-	init_instance(instance);
+	tracecmd_init_instance(instance);
 }
 
 static char *get_temp_file(struct buffer_instance *instance, int cpu)
 {
-	const char *name = instance->name;
+	const char *name = instance->ftrace->name;
 	char *file = NULL;
 	int size;
 
@@ -557,7 +562,7 @@ static void put_temp_file(char *file)
 
 static void delete_temp_file(struct buffer_instance *instance, int cpu)
 {
-	const char *name = instance->name;
+	const char *name = instance->ftrace->name;
 	char file[PATH_MAX];
 
 	if (name)
@@ -783,96 +788,6 @@ static int set_ftrace(int set, int use_proc)
 	return 0;
 }
 
-/**
- * get_instance_file - return the path to a instance file.
- * @instance: buffer instance for the file
- * @file: name of file to return
- *
- * Returns the path name of the @file for the given @instance.
- *
- * Must use tracecmd_put_tracing_file() to free the returned string.
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
-		path = tracecmd_get_tracing_file(buf);
-		free(buf);
-	} else
-		path = tracecmd_get_tracing_file(file);
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
-	path = tracecmd_get_tracing_file(buf);
-	free(buf);
-
-	return path;
-}
-
-static int write_file(const char *file, const char *str, const char *type)
-{
-	char buf[BUFSIZ];
-	int fd;
-	int ret;
-
-	fd = open(file, O_WRONLY | O_TRUNC);
-	if (fd < 0)
-		die("opening to '%s'", file);
-	ret = write(fd, str, strlen(str));
-	close(fd);
-	if (ret < 0 && type) {
-		/* write failed */
-		fd = open(file, O_RDONLY);
-		if (fd < 0)
-			die("writing to '%s'", file);
-		/* the filter has the error */
-		while ((ret = read(fd, buf, BUFSIZ)) > 0)
-			fprintf(stderr, "%.*s", ret, buf);
-		die("Failed %s of %s\n", type, file);
-		close(fd);
-	}
-	return ret;
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
-	if (ret == 0)
-		ret = write_file(path, str, type);
-	tracecmd_put_tracing_file(path);
-
-	return ret;
-}
-
 static void __clear_trace(struct buffer_instance *instance)
 {
 	FILE *fp;
@@ -882,7 +797,7 @@ static void __clear_trace(struct buffer_instance *instance)
 		return;
 
 	/* reset the trace */
-	path = get_instance_file(instance, "trace");
+	path = tracecmd_get_instance_file(instance->ftrace, "trace");
 	fp = fopen(path, "w");
 	if (!fp)
 		die("writing to '%s'", path);
@@ -916,8 +831,8 @@ static void clear_trace(void)
 
 static void reset_max_latency(struct buffer_instance *instance)
 {
-	 write_instance_file(instance,
-			     "tracing_max_latency", "0", "max_latency");
+	tracecmd_write_instance_file(instance->ftrace,
+				     "tracing_max_latency", "0", "max_latency");
 }
 
 static void add_filter_pid(int pid, int exclude)
@@ -1363,7 +1278,8 @@ static void add_event_pid(const char *buf)
 	struct buffer_instance *instance;
 
 	for_all_instances(instance)
-		write_instance_file(instance, "set_event_pid", buf, "event_pid");
+		tracecmd_write_instance_file(instance->ftrace,
+					     "set_event_pid", buf, "event_pid");
 }
 
 static void add_new_filter_pid(int pid)
@@ -1592,7 +1508,7 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 	if (is_guest(instance))
 		return;
 
-	path = get_instance_file(instance, "current_tracer");
+	path = tracecmd_get_instance_file(instance->ftrace, "current_tracer");
 	fp = fopen(path, "w");
 	if (!fp) {
 		/*
@@ -1616,7 +1532,7 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 
 	/* Make sure func_stack_trace option is disabled */
 	/* First try instance file, then top level */
-	path = get_instance_file(instance, "options/func_stack_trace");
+	path = tracecmd_get_instance_file(instance->ftrace, "options/func_stack_trace");
 	fp = fopen(path, "w");
 	if (!fp) {
 		tracecmd_put_tracing_file(path);
@@ -1677,8 +1593,6 @@ static int set_option(const char *option)
 	return 0;
 }
 
-static char *read_instance_file(struct buffer_instance *instance, char *file, int *psize);
-
 static void disable_func_stack_trace_instance(struct buffer_instance *instance)
 {
 	struct stat st;
@@ -1691,13 +1605,13 @@ static void disable_func_stack_trace_instance(struct buffer_instance *instance)
 	if (is_guest(instance))
 		return;
 
-	path = get_instance_file(instance, "current_tracer");
+	path = tracecmd_get_instance_file(instance->ftrace, "current_tracer");
 	ret = stat(path, &st);
 	tracecmd_put_tracing_file(path);
 	if (ret < 0)
 		return;
 
-	content = read_instance_file(instance, "current_tracer", &size);
+	content = tracecmd_read_instance_file(instance->ftrace, "current_tracer", &size);
 	cond = strstrip(content);
 	if (memcmp(cond, "function", size - (cond - content)) !=0)
 		goto out;
@@ -1850,7 +1764,7 @@ static int trace_check_file_exists(struct buffer_instance *instance, char *file)
 	char *path;
 	int ret;
 
-	path = get_instance_file(instance, file);
+	path = tracecmd_get_instance_file(instance->ftrace, file);
 	ret = stat(path, &st);
 	tracecmd_put_tracing_file(path);
 
@@ -1929,7 +1843,7 @@ reset_events_instance(struct buffer_instance *instance)
 	}
 
 	c = '0';
-	path = get_instance_file(instance, "events/enable");
+	path = tracecmd_get_instance_file(instance->ftrace, "events/enable");
 	fd = open(path, O_WRONLY);
 	if (fd < 0)
 		die("opening to '%s'", path);
@@ -1937,7 +1851,7 @@ reset_events_instance(struct buffer_instance *instance)
 	close(fd);
 	tracecmd_put_tracing_file(path);
 
-	path = get_instance_file(instance, "events/*/filter");
+	path = tracecmd_get_instance_file(instance->ftrace, "events/*/filter");
 	globbuf.gl_offs = 0;
 	ret = glob(path, 0, NULL, &globbuf);
 	tracecmd_put_tracing_file(path);
@@ -2009,7 +1923,7 @@ static int find_trigger(const char *file, char *buf, int size, int fields)
 
 static void write_filter(const char *file, const char *filter)
 {
-	write_file(file, filter, "filter");
+	tracecmd_write_file(file, filter, "filter");
 }
 
 static void clear_filter(const char *file)
@@ -2019,12 +1933,12 @@ static void clear_filter(const char *file)
 
 static void write_trigger(const char *file, const char *trigger)
 {
-	write_file(file, trigger, "trigger");
+	tracecmd_write_file(file, trigger, "trigger");
 }
 
 static void write_func_filter(const char *file, const char *trigger)
 {
-	write_file(file, trigger, "function filter");
+	tracecmd_write_file(file, trigger, "function filter");
 }
 
 static void clear_trigger(const char *file)
@@ -2117,7 +2031,7 @@ static void update_reset_files(void)
 		reset_files = reset->next;
 
 		if (!keep)
-			write_file(reset->path, reset->reset, "reset");
+			tracecmd_write_file(reset->path, reset->reset, "reset");
 		free(reset->path);
 		free(reset->reset);
 		free(reset);
@@ -2198,7 +2112,7 @@ static int open_instance_fd(struct buffer_instance *instance,
 	int fd;
 	char *path;
 
-	path = get_instance_file(instance, file);
+	path = tracecmd_get_instance_file(instance->ftrace, file);
 	fd = open(path, flags);
 	if (fd < 0) {
 		/* instances may not be created yet */
@@ -2227,7 +2141,7 @@ static int open_tracing_on(struct buffer_instance *instance)
 	return fd;
 }
 
-static void write_tracing_on(struct buffer_instance *instance, int on)
+void write_tracing_on(struct buffer_instance *instance, int on)
 {
 	int ret;
 	int fd;
@@ -2507,7 +2421,7 @@ static void set_mask(struct buffer_instance *instance)
 	if (!instance->cpumask)
 		return;
 
-	path = get_instance_file(instance, "tracing_cpumask");
+	path = tracecmd_get_instance_file(instance->ftrace, "tracing_cpumask");
 	if (!path)
 		die("could not allocate path");
 	reset_save_file(path, RESET_DEFAULT_PRIO);
@@ -2555,39 +2469,6 @@ void tracecmd_enable_events(void)
 	enable_events(first_instance);
 }
 
-static void set_clock(struct buffer_instance *instance)
-{
-	char *path;
-	char *content;
-	char *str;
-
-	if (is_guest(instance))
-		return;
-
-	if (!instance->clock)
-		return;
-
-	/* The current clock is in brackets, reset it when we are done */
-	content = read_instance_file(instance, "trace_clock", NULL);
-
-	/* check if first clock is set */
-	if (*content == '[')
-		str = strtok(content+1, "]");
-	else {
-		str = strtok(content, "[");
-		if (!str)
-			die("Can not find clock in trace_clock");
-		str = strtok(NULL, "]");
-	}
-	path = get_instance_file(instance, "trace_clock");
-	add_reset_file(path, str, RESET_DEFAULT_PRIO);
-
-	free(content);
-	tracecmd_put_tracing_file(path);
-
-	write_instance_file(instance, "trace_clock", instance->clock, "clock");
-}
-
 static void set_max_graph_depth(struct buffer_instance *instance, char *max_graph_depth)
 {
 	char *path;
@@ -2596,16 +2477,16 @@ static void set_max_graph_depth(struct buffer_instance *instance, char *max_grap
 	if (is_guest(instance))
 		return;
 
-	path = get_instance_file(instance, "max_graph_depth");
+	path = tracecmd_get_instance_file(instance->ftrace, "max_graph_depth");
 	reset_save_file(path, RESET_DEFAULT_PRIO);
 	tracecmd_put_tracing_file(path);
-	ret = write_instance_file(instance, "max_graph_depth", max_graph_depth,
-				  NULL);
+	ret = tracecmd_write_instance_file(instance->ftrace,
+					   "max_graph_depth", max_graph_depth,
+					   NULL);
 	if (ret < 0)
 		die("could not write to max_graph_depth");
 }
 
-
 /**
  * create_event - create and event descriptor
  * @instance: instance to use
@@ -2717,7 +2598,7 @@ static int expand_event_files(struct buffer_instance *instance,
 	if (ret < 0)
 		die("Failed to allocate event filter path for %s", file);
 
-	path = get_instance_file(instance, p);
+	path = tracecmd_get_instance_file(instance->ftrace, p);
 
 	globbuf.gl_offs = 0;
 	ret = glob(path, 0, NULL, &globbuf);
@@ -3179,10 +3060,7 @@ create_recorder_instance_pipe(struct buffer_instance *instance,
 	unsigned flags = recorder_flags | TRACECMD_RECORD_BLOCK;
 	char *path;
 
-	if (instance->name)
-		path = get_instance_dir(instance);
-	else
-		path = tracecmd_find_tracing_dir();
+	path = tracecmd_get_instance_dir(instance->ftrace);
 
 	if (!path)
 		die("malloc");
@@ -3192,7 +3070,7 @@ create_recorder_instance_pipe(struct buffer_instance *instance,
 
 	recorder = tracecmd_create_buffer_recorder_fd(brass[1], cpu, flags, path);
 
-	if (instance->name)
+	if (instance->ftrace->name)
 		tracecmd_put_tracing_file(path);
 
 	return recorder;
@@ -3227,10 +3105,10 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 	if (brass)
 		return create_recorder_instance_pipe(instance, cpu, brass);
 
-	if (!instance->name)
+	if (!instance->ftrace->name)
 		return tracecmd_create_recorder_maxkb(file, cpu, recorder_flags, max_kb);
 
-	path = get_instance_dir(instance);
+	path = tracecmd_get_instance_dir(instance->ftrace);
 
 	record = tracecmd_create_buffer_recorder_maxkb(file, cpu, recorder_flags,
 						       path, max_kb);
@@ -3284,8 +3162,8 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 		}
 		if (fd < 0)
 			die("Failed connecting to client");
-		if (instance->name && !is_agent(instance))
-			path = get_instance_dir(instance);
+		if (instance->ftrace->name && !is_agent(instance))
+			path = tracecmd_get_instance_dir(instance->ftrace);
 		else
 			path = tracecmd_find_tracing_dir();
 		recorder = tracecmd_create_buffer_recorder_fd(fd, cpu, flags, path);
@@ -3598,7 +3476,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 	bool use_fifos = false;
 
 	if (!no_fifos) {
-		nr_fifos = open_guest_fifos(instance->name, &fds);
+		nr_fifos = open_guest_fifos(instance->ftrace->name, &fds);
 		use_fifos = nr_fifos > 0;
 	}
 
@@ -3625,7 +3503,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 		if (nr_cpus != nr_fifos) {
 			warning("number of FIFOs (%d) for guest %s differs "
 				"from number of virtual CPUs (%d)",
-				nr_fifos, instance->name, nr_cpus);
+				nr_fifos, instance->ftrace->name, nr_cpus);
 			nr_cpus = nr_cpus < nr_fifos ? nr_cpus : nr_fifos;
 		}
 		free(ports);
@@ -3651,7 +3529,7 @@ static void setup_guest(struct buffer_instance *instance)
 	int fd;
 
 	/* Create a place to store the guest meta data */
-	file = get_guest_file(output_file, instance->name);
+	file = get_guest_file(output_file, instance->ftrace->name);
 	if (!file)
 		die("Failed to allocate memory");
 
@@ -3827,7 +3705,7 @@ add_buffer_stat(struct tracecmd_output *handle, struct buffer_instance *instance
 	int i;
 
 	trace_seq_init(&s);
-	trace_seq_printf(&s, "\nBuffer: %s\n\n", instance->name);
+	trace_seq_printf(&s, "\nBuffer: %s\n\n", instance->ftrace->name);
 	tracecmd_add_option(handle, TRACECMD_OPTION_CPUSTAT,
 			    s.len+1, s.buffer);
 	trace_seq_destroy(&s);
@@ -3893,7 +3771,7 @@ static void print_stat(struct buffer_instance *instance)
 		return;
 
 	if (!is_top_instance(instance))
-		printf("\nBuffer: %s\n\n", instance->name);
+		printf("\nBuffer: %s\n\n", instance->ftrace->name);
 
 	for (cpu = 0; cpu < instance->cpu_count; cpu++)
 		trace_seq_do_printf(&instance->s_print[cpu]);
@@ -3933,7 +3811,7 @@ static void write_guest_file(struct buffer_instance *instance)
 	char **temp_files;
 	int i, fd;
 
-	file = get_guest_file(output_file, instance->name);
+	file = get_guest_file(output_file, instance->ftrace->name);
 	if (!file)
 		die("Failed to allocate memory");
 
@@ -4049,7 +3927,7 @@ static void record_data(struct common_record_context *ctx)
 					continue;
 
 				buffer_options[i++] = tracecmd_add_buffer_option(handle,
-										 instance->name,
+										 instance->ftrace->name,
 										 cpus);
 				add_buffer_stat(handle, instance);
 			}
@@ -4096,7 +3974,7 @@ static int write_func_file(struct buffer_instance *instance,
 	if (!*list)
 		return 0;
 
-	path = get_instance_file(instance, file);
+	path = tracecmd_get_instance_file(instance->ftrace, file);
 
 	fd = open(path, O_WRONLY | O_TRUNC);
 	if (fd < 0)
@@ -4140,7 +4018,7 @@ static int functions_filtered(struct buffer_instance *instance)
 	char *path;
 	int fd;
 
-	path = get_instance_file(instance, "set_ftrace_filter");
+	path = tracecmd_get_instance_file(instance->ftrace, "set_ftrace_filter");
 	fd = open(path, O_RDONLY);
 	tracecmd_put_tracing_file(path);
 	if (fd < 0) {
@@ -4148,7 +4026,7 @@ static int functions_filtered(struct buffer_instance *instance)
 			warning("Can not set set_ftrace_filter");
 		else
 			warning("Can not set set_ftrace_filter for %s",
-				instance->name);
+				instance->ftrace->name);
 		return 0;
 	}
 
@@ -4308,45 +4186,10 @@ static unsigned long long find_time_stamp(struct tep_handle *pevent)
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
-	tracecmd_put_tracing_file(path);
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
 
 static char *read_file(char *file, int *psize)
 {
-	return read_instance_file(&top_instance, file, psize);
+	return tracecmd_read_instance_file(top_instance.ftrace, file, psize);
 }
 
 /*
@@ -4479,7 +4322,7 @@ static void set_buffer_size_instance(struct buffer_instance *instance)
 
 	snprintf(buf, BUFSIZ, "%d", buffer_size);
 
-	path = get_instance_file(instance, "buffer_size_kb");
+	path = tracecmd_get_instance_file(instance->ftrace, "buffer_size_kb");
 	fd = open(path, O_WRONLY);
 	if (fd < 0) {
 		warning("can't open %s", path);
@@ -4540,7 +4383,7 @@ static void clear_instance_triggers(struct buffer_instance *instance)
 	enum event_iter_type type;
 	enum event_process processed = PROCESSED_NONE;
 
-	path = get_instance_file(instance, "events");
+	path = tracecmd_get_instance_file(instance->ftrace, "events");
 	if (!path)
 		die("malloc");
 
@@ -4601,7 +4444,7 @@ static void clear_instance_filters(struct buffer_instance *instance)
 	enum event_iter_type type;
 	enum event_process processed = PROCESSED_NONE;
 
-	path = get_instance_file(instance, "events");
+	path = tracecmd_get_instance_file(instance->ftrace, "events");
 	if (!path)
 		die("malloc");
 
@@ -4637,7 +4480,8 @@ static void reset_clock(void)
 	struct buffer_instance *instance;
 
 	for_all_instances(instance)
-		write_instance_file(instance, "trace_clock", "local", "clock");
+		tracecmd_write_instance_file(instance->ftrace,
+					    "trace_clock", "local", "clock");
 }
 
 static void reset_cpu_mask(void)
@@ -4656,7 +4500,8 @@ static void reset_cpu_mask(void)
 		strcat(buf, ",ffffffff");
 
 	for_all_instances(instance)
-		write_instance_file(instance, "tracing_cpumask", buf, "cpumask");
+		tracecmd_write_instance_file(instance->ftrace,
+					     "tracing_cpumask", buf, "cpumask");
 }
 
 static void reset_event_pid(void)
@@ -4685,7 +4530,7 @@ static void clear_func_filters(void)
 
 	for_all_instances(instance) {
 		for (i = 0; files[i]; i++) {
-			path = get_instance_file(instance, files[i]);
+			path = tracecmd_get_instance_file(instance->ftrace, files[i]);
 			clear_func_filter(path);
 			tracecmd_put_tracing_file(path);
 		}
@@ -4695,32 +4540,20 @@ static void clear_func_filters(void)
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
+		if (tracecmd_make_instance(instance->ftrace) > 0) {
 			/* Don't delete instances that already exist */
 			instance->flags |= BUFFER_FL_KEEP;
-		tracecmd_put_tracing_file(path);
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
@@ -4730,11 +4563,7 @@ void tracecmd_remove_instances(void)
 			close(instance->tracing_on_fd);
 			instance->tracing_on_fd = 0;
 		}
-		path = get_instance_dir(instance);
-		ret = rmdir(path);
-		if (ret < 0)
-			die("rmdir %s", path);
-		tracecmd_put_tracing_file(path);
+		tracecmd_remove_instance(instance->ftrace);
 	}
 }
 
@@ -5028,7 +4857,7 @@ static int test_stacktrace_trigger(struct buffer_instance *instance)
 	int ret = 0;
 	int fd;
 
-	path = get_instance_file(instance, "events/sched/sched_switch/trigger");
+	path = tracecmd_get_instance_file(instance->ftrace, "events/sched/sched_switch/trigger");
 
 	clear_trigger(path);
 
@@ -5210,6 +5039,15 @@ void update_first_instance(struct buffer_instance *instance, int topt)
 		first_instance = buffer_instances;
 }
 
+void init_top_instance(void)
+{
+	if (!top_instance.ftrace)
+		top_instance.ftrace = tracecmd_create_instance(NULL);
+	top_instance.cpu_count = count_cpus();
+	top_instance.flags = BUFFER_FL_KEEP;
+	tracecmd_init_instance(&top_instance);
+}
+
 enum {
 	OPT_user		= 243,
 	OPT_procmap		= 244,
@@ -5234,7 +5072,7 @@ void trace_stop(int argc, char **argv)
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
 
-	init_instance(instance);
+	init_top_instance();
 
 	for (;;) {
 		int c;
@@ -5275,7 +5113,7 @@ void trace_restart(int argc, char **argv)
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
 
-	init_instance(instance);
+	init_top_instance();
 
 	for (;;) {
 		int c;
@@ -5317,7 +5155,7 @@ void trace_reset(int argc, char **argv)
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
 
-	init_instance(instance);
+	init_top_instance();
 
 	/* if last arg is -a, then -b and -d apply to all instances */
 	int last_specified_all = 0;
@@ -5402,9 +5240,8 @@ static void init_common_record_context(struct common_record_context *ctx,
 	memset(ctx, 0, sizeof(*ctx));
 	ctx->instance = &top_instance;
 	ctx->curr_cmd = curr_cmd;
-	init_instance(ctx->instance);
 	local_cpu_count = count_cpus();
-	ctx->instance->cpu_count = local_cpu_count;
+	init_top_instance();
 }
 
 #define IS_EXTRACT(ctx) ((ctx)->curr_cmd == CMD_extract)
@@ -5642,7 +5479,7 @@ static void parse_record_options(int argc,
 			}
 			break;
 		case 'C':
-			ctx->instance->clock = optarg;
+			ctx->instance->ftrace->clock = optarg;
 			break;
 		case 'v':
 			neg_event = 1;
@@ -5964,6 +5801,23 @@ static bool has_local_instances(void)
 	return false;
 }
 
+static void set_clock(struct buffer_instance *instance)
+{
+	char *old_clock = NULL;
+	char *path;
+
+	if (is_guest(instance))
+		return;
+
+	tracecmd_set_clock(instance->ftrace, &old_clock);
+	if (old_clock) {
+		path = tracecmd_get_instance_file(instance->ftrace, "trace_clock");
+		if (path)
+			add_reset_file(path, old_clock, RESET_DEFAULT_PRIO);
+		free(old_clock);
+		tracecmd_put_tracing_file(path);
+	}
+}
 /*
  * This function contains common code for the following commands:
  * record, start, stream, profile.
@@ -6015,7 +5869,6 @@ static void record_trace(int argc, char **argv,
 
 	for_all_instances(instance)
 		set_clock(instance);
-
 	/* Record records the date first */
 	if (ctx->date &&
 	    ((IS_RECORD(ctx) && has_local_instances()) || IS_RECORD_AGENT(ctx)))
diff --git a/tracecmd/trace-show.c b/tracecmd/trace-show.c
index 96bfe77..ca0f4cf 100644
--- a/tracecmd/trace-show.c
+++ b/tracecmd/trace-show.c
@@ -51,6 +51,8 @@ void trace_show(int argc, char **argv)
 		{NULL, 0, NULL, 0}
 	};
 
+	init_top_instance();
+
 	while ((c = getopt_long(argc-1, argv+1, "B:c:fsp",
 				long_options, &option_index)) >= 0) {
 		switch (c) {
diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 538f4ad..32aebc5 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -30,7 +30,7 @@ static int get_instance_file_fd(struct buffer_instance *instance,
 	char *path;
 	int fd;
 
-	path = get_instance_file(instance, file);
+	path = tracecmd_get_instance_file(instance->ftrace, file);
 	fd = open(path, O_RDONLY);
 	tracecmd_put_tracing_file(path);
 
@@ -347,7 +347,7 @@ static void report_events(struct buffer_instance *instance)
 
 	free(str);
 
-	path = get_instance_file(instance, "events");
+	path = tracecmd_get_instance_file(instance->ftrace, "events");
 	if (!path)
 		die("malloc");
 
@@ -436,7 +436,7 @@ static void report_event_filters(struct buffer_instance *instance)
 	enum event_iter_type type;
 	enum event_process processed = PROCESSED_NONE;
 
-	path = get_instance_file(instance, "events");
+	path = tracecmd_get_instance_file(instance->ftrace, "events");
 	if (!path)
 		die("malloc");
 
@@ -509,7 +509,7 @@ static void report_event_triggers(struct buffer_instance *instance)
 	enum event_iter_type type;
 	enum event_process processed = PROCESSED_NONE;
 
-	path = get_instance_file(instance, "events");
+	path = tracecmd_get_instance_file(instance->ftrace, "events");
 	if (!path)
 		die("malloc");
 
@@ -598,7 +598,7 @@ static void report_graph_funcs(struct buffer_instance *instance)
 {
 	char *path;
 
-	path = get_instance_file(instance, "set_graph_function");
+	path = tracecmd_get_instance_file(instance->ftrace, "set_graph_function");
 	if (!path)
 		die("malloc");
 
@@ -606,7 +606,7 @@ static void report_graph_funcs(struct buffer_instance *instance)
 	
 	tracecmd_put_tracing_file(path);
 
-	path = get_instance_file(instance, "set_graph_notrace");
+	path = tracecmd_get_instance_file(instance->ftrace, "set_graph_notrace");
 	if (!path)
 		die("malloc");
 
@@ -619,7 +619,7 @@ static void report_ftrace_filters(struct buffer_instance *instance)
 {
 	char *path;
 
-	path = get_instance_file(instance, "set_ftrace_filter");
+	path = tracecmd_get_instance_file(instance->ftrace, "set_ftrace_filter");
 	if (!path)
 		die("malloc");
 
@@ -627,7 +627,7 @@ static void report_ftrace_filters(struct buffer_instance *instance)
 	
 	tracecmd_put_tracing_file(path);
 
-	path = get_instance_file(instance, "set_ftrace_notrace");
+	path = tracecmd_get_instance_file(instance->ftrace, "set_ftrace_notrace");
 	if (!path)
 		die("malloc");
 
@@ -857,7 +857,7 @@ static void stat_instance(struct buffer_instance *instance)
 	if (instance != &top_instance) {
 		if (instance != first_instance)
 			printf("---------------\n");
-		printf("Instance: %s\n", instance->name);
+		printf("Instance: %s\n", instance->ftrace->name);
 	}
 
 	report_plugin(instance);
@@ -882,6 +882,8 @@ void trace_stat (int argc, char **argv)
 	int status;
 	int c;
 
+	init_top_instance();
+
 	for (;;) {
 		c = getopt(argc-1, argv+1, "tB:");
 		if (c == -1)
-- 
2.23.0

