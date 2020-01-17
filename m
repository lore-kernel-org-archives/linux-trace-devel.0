Return-Path: <SRS0=5V0s=3G=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB2BC33CB6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jan 2020 13:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECBED2072E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jan 2020 13:55:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ucTBfowe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgAQNzy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jan 2020 08:55:54 -0500
Received: from mail-lj1-f176.google.com ([209.85.208.176]:36728 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbgAQNzy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 08:55:54 -0500
Received: by mail-lj1-f176.google.com with SMTP id r19so26565344ljg.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jan 2020 05:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=21WzK31KLgIoTmE5fsUo1wFfOIx2PiWLYUX3LC88q9o=;
        b=ucTBfoweC/koZNpKSTQ61+B4NxzWBValrkbEbyjeUWs5KWjZ/M8okRxYCk5UP7HqiJ
         4sVnsjkIQrbfuiTS1ml9jhndSDVT4Q+RN8VatovsKZ2j5OhodY/UwwvFhANGrJpUM/Xd
         FsOCuWkkscTig7tOtklXCGD0GBYgA1pq9xEKz+tiXjmEVlLAmz87txT3giimGGk9b71b
         sCeQmtY/HYY9MSxjTzdxlZrVSfFLWyea+PTr05zKCliBwIdGAn11Hx5qgT/rcCgEgupx
         roieQ0HEmCz383gMFhk2nhZlkm8IuZqkQlixtWFB4VHCPI/oNmhpUISpiqct0vZ18pUA
         Z0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=21WzK31KLgIoTmE5fsUo1wFfOIx2PiWLYUX3LC88q9o=;
        b=DfX3+439Q+2fmTGlMqRuVjwCY6XsOuUl3DWMnkMrV94nkC80lVeFYqClymapMOh5eN
         7vX+f2kyEeXMcux+liUnC9xNvr9ODvpPGMYt5IMDRA1GDL2dEwszN10dqea00W0OUa26
         bbdpZ6YqrKYU/TIxDNjth4ZttnabxYr/0DehocLoYLVokZk02tjDY15NN2kX4vPtewGM
         7hj1xKXFkV7pegLvZlmeiFE/QIqcXR9wr9dvgNIM0RLASrdLuh6kC2hqyFIdncq/qTkP
         jt/k0jHDofBqPvxTjNxgbpSeT6rw16AV7GMkJraTIlco4Kkg4+4JizZbwLRJ7TqbYOQ2
         lwmA==
X-Gm-Message-State: APjAAAVfgNnxZngI/UFl39I9DTud+X9/0yq9iD7SdgBebauqgYGoWxwv
        ywTW11l3I05aipbnfForPDvM2vpg
X-Google-Smtp-Source: APXvYqyokWJPFuiXR7X2R8arNwQUg27KwjWACj5RFXb66qpUCc7ieC/1/Q2v2V7f91dLkZoVH4iH4w==
X-Received: by 2002:a2e:9804:: with SMTP id a4mr5535183ljj.10.1579269351270;
        Fri, 17 Jan 2020 05:55:51 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 21sm12422562ljv.19.2020.01.17.05.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 05:55:50 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/5] trace-cmd,kernel-shark: New libtracefs APIs for ftrace events and systems
Date:   Fri, 17 Jan 2020 15:55:42 +0200
Message-Id: <20200117135544.598235-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117135544.598235-1-tz.stoyanov@gmail.com>
References: <20200117135544.598235-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The functionality related to ftrace events and systems
is moved from trace-cmd application and libtracecmd to libtracefs.

The following libtracecmd APIs are removed:
  tracecmd_read_page_record();
  tracecmd_event_systems();
  tracecmd_system_events();
  tracecmd_local_plugins();
  tracecmd_add_list();
  tracecmd_free_list();

The following new library APIs are introduced:
  tracefs_read_page_record();
  tracefs_event_systems();
  tracefs_system_events();
  tracefs_local_plugins();
  tracefs_iterate_raw_events();
  tracefs_list_free();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h        |   8 -
 include/tracefs/tracefs.h            |  16 +
 kernel-shark/src/KsCaptureDialog.cpp |   2 +-
 lib/trace-cmd/trace-input.c          |  95 ------
 lib/trace-cmd/trace-util.c           | 265 ----------------
 lib/tracefs/Makefile                 |   1 +
 lib/tracefs/tracefs-events.c         | 442 +++++++++++++++++++++++++++
 tracecmd/trace-record.c              | 107 ++-----
 8 files changed, 484 insertions(+), 452 deletions(-)
 create mode 100644 lib/tracefs/tracefs-events.c

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 66736ae..30bb144 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -24,15 +24,10 @@ void tracecmd_parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigne
 extern int tracecmd_disable_sys_plugins;
 extern int tracecmd_disable_plugins;
 
-char **tracecmd_event_systems(const char *tracing_dir);
-char **tracecmd_system_events(const char *tracing_dir, const char *system);
 struct tep_handle *tracecmd_local_events(const char *tracing_dir);
 int tracecmd_fill_local_events(const char *tracing_dir,
 			       struct tep_handle *pevent, int *parsing_failures);
-char **tracecmd_local_plugins(const char *tracing_dir);
 
-char **tracecmd_add_list(char **list, const char *name, int len);
-void tracecmd_free_list(char **list);
 int *tracecmd_add_id(int *list, int id, int len);
 
 enum {
@@ -143,9 +138,6 @@ void tracecmd_print_stats(struct tracecmd_input *handle);
 void tracecmd_print_uname(struct tracecmd_input *handle);
 void tracecmd_print_version(struct tracecmd_input *handle);
 
-struct tep_record *
-tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
-			  struct tep_record *last_record);
 struct tep_record *
 tracecmd_peek_data(struct tracecmd_input *handle, int cpu);
 
diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index bdeb8e8..d86482b 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -33,4 +33,20 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
 				 char *file, int *psize);
 
+/* events */
+struct tep_record *
+tracefs_read_page_record(struct tep_handle *tep, void *page, int size,
+			  struct tep_record *last_record);
+void tracefs_list_free(char **list);
+char **tracefs_event_systems(const char *tracing_dir);
+char **tracefs_system_events(const char *tracing_dir, const char *system);
+int tracefs_iterate_raw_events(struct tep_handle *tep,
+				struct tracefs_instance *instance,
+				int (*callback)(struct tep_event *,
+						struct tep_record *,
+						int, void *),
+				void *callback_context);
+
+char **tracefs_tracers(const char *tracing_dir);
+
 #endif /* _TRACE_FS_H */
diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index 548b6fb..529fa77 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -204,7 +204,7 @@ QStringList KsCaptureControl::_getPlugins()
 	QStringList pluginList;
 	char **all_plugins;
 
-	all_plugins = tracecmd_local_plugins(tracefs_get_tracing_dir());
+	all_plugins = tracefs_tracers(tracefs_get_tracing_dir());
 
 	if (!all_plugins)
 		return pluginList;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 3b187e3..67c7236 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1663,101 +1663,6 @@ tracecmd_translate_data(struct tracecmd_input *handle,
 	return record;
 }
 
-/**
- * tracecmd_read_page_record - read a record off of a page
- * @pevent: pevent used to parse the page
- * @page: the page to read
- * @size: the size of the page
- * @last_record: last record read from this page.
- *
- * If a ring buffer page is available, and the need to parse it
- * without having a handle, then this function can be used.
- *
- * The @pevent needs to be initialized to have the page header information
- * already available.
- *
- * The @last_record is used to know where to read the next record from.
- * If @last_record is NULL, the first record on the page will be read.
- *
- * Returns:
- *  A newly allocated record that must be freed with free_record() if
- *  a record is found. Otherwise NULL is returned if the record is bad
- *  or no more records exist.
- */
-struct tep_record *
-tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
-			  struct tep_record *last_record)
-{
-	unsigned long long ts;
-	struct kbuffer *kbuf;
-	struct tep_record *record = NULL;
-	enum kbuffer_long_size long_size;
-	enum kbuffer_endian endian;
-	void *ptr;
-
-	if (tep_is_file_bigendian(pevent))
-		endian = KBUFFER_ENDIAN_BIG;
-	else
-		endian = KBUFFER_ENDIAN_LITTLE;
-
-	if (tep_get_header_page_size(pevent) == 8)
-		long_size = KBUFFER_LSIZE_8;
-	else
-		long_size = KBUFFER_LSIZE_4;
-
-	kbuf = kbuffer_alloc(long_size, endian);
-	if (!kbuf)
-		return NULL;
-
-	kbuffer_load_subbuffer(kbuf, page);
-	if (kbuffer_subbuffer_size(kbuf) > size) {
-		warning("tracecmd_read_page_record: page_size > size");
-		goto out_free;
-	}
-
-	if (last_record) {
-		if (last_record->data < page || last_record->data >= (page + size)) {
-			warning("tracecmd_read_page_record: bad last record (size=%u)",
-				last_record->size);
-			goto out_free;
-		}
-
-		ptr = kbuffer_read_event(kbuf, &ts);
-		while (ptr < last_record->data) {
-			ptr = kbuffer_next_event(kbuf, NULL);
-			if (!ptr)
-				break;
-			if (ptr == last_record->data)
-				break;
-		}
-		if (ptr != last_record->data) {
-			warning("tracecmd_read_page_record: could not find last_record");
-			goto out_free;
-		}
-		ptr = kbuffer_next_event(kbuf, &ts);
-	} else
-		ptr = kbuffer_read_event(kbuf, &ts);
-
-	if (!ptr)
-		goto out_free;
-
-	record = malloc(sizeof(*record));
-	if (!record)
-		return NULL;
-	memset(record, 0, sizeof(*record));
-
-	record->ts = ts;
-	record->size = kbuffer_event_size(kbuf);
-	record->record_size = kbuffer_curr_size(kbuf);
-	record->cpu = 0;
-	record->data = ptr;
-	record->ref_count = 1;
-
- out_free:
-	kbuffer_free(kbuf);
-	return record;
-}
-
 /**
  * tracecmd_peek_data - return the record at the current location.
  * @handle: input handle for the trace.dat file
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 1394469..1554e88 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -153,56 +153,6 @@ static char *append_file(const char *dir, const char *name)
 	return ret < 0 ? NULL : file;
 }
 
-/**
- * tracecmd_add_list - add an new string to a string list.
- * @list: list to add the string to (may be NULL)
- * @name: the string to add
- * @len: current length of list of strings.
- *
- * The typical usage is:
- *
- *    systems = tracecmd_add_list(systems, name, len++);
- *
- * Returns the new allocated list with an allocated name added.
- * The list will end with NULL.
- */
-char **tracecmd_add_list(char **list, const char *name, int len)
-{
-	if (!list)
-		list = malloc(sizeof(*list) * 2);
-	else
-		list = realloc(list, sizeof(*list) * (len + 2));
-	if (!list)
-		return NULL;
-
-	list[len] = strdup(name);
-	if (!list[len])
-		return NULL;
-
-	list[len + 1] = NULL;
-
-	return list;
-}
-
-/**
- * tracecmd_free_list - free a list created with tracecmd_add_list.
- * @list: The list to free.
- *
- * Frees the list as well as the names within the list.
- */
-void tracecmd_free_list(char **list)
-{
-	int i;
-
-	if (!list)
-		return;
-
-	for (i = 0; list[i]; i++)
-		free(list[i]);
-
-	free(list);
-}
-
 /**
  * tracecmd_add_id - add an int to the event id list
  * @list: list to add the id to
@@ -233,160 +183,6 @@ int *tracecmd_add_id(int *list, int id, int len)
 	return list;
 }
 
-/**
- * tracecmd_event_systems - return list of systems for tracing
- * @tracing_dir: directory holding the "events" directory
- *
- * Returns an allocated list of system names. Both the names and
- * the list must be freed with free().
- * The list returned ends with a "NULL" pointer.
- */
-char **tracecmd_event_systems(const char *tracing_dir)
-{
-	struct dirent *dent;
-	char **systems = NULL;
-	char *events_dir;
-	struct stat st;
-	DIR *dir;
-	int len = 0;
-	int ret;
-
-	if (!tracing_dir)
-		return NULL;
-
-	events_dir = append_file(tracing_dir, "events");
-	if (!events_dir)
-		return NULL;
-
-	/*
-	 * Search all the directories in the events directory,
- 	 * and collect the ones that have the "enable" file.
-	 */
-	ret = stat(events_dir, &st);
-	if (ret < 0 || !S_ISDIR(st.st_mode))
-		goto out_free;
-
-	dir = opendir(events_dir);
-	if (!dir)
-		goto out_free;
-
-	while ((dent = readdir(dir))) {
-		const char *name = dent->d_name;
-		char *enable;
-		char *sys;
-
-		if (strcmp(name, ".") == 0 ||
-		    strcmp(name, "..") == 0)
-			continue;
-
-		sys = append_file(events_dir, name);
-		ret = stat(sys, &st);
-		if (ret < 0 || !S_ISDIR(st.st_mode)) {
-			free(sys);
-			continue;
-		}
-
-		enable = append_file(sys, "enable");
-
-		ret = stat(enable, &st);
-		if (ret >= 0)
-			systems = tracecmd_add_list(systems, name, len++);
-
-		free(enable);
-		free(sys);
-	}
-
-	closedir(dir);
-
- out_free:
-	free(events_dir);
-	return systems;
-}
-
-/**
- * tracecmd_system_events - return list of events for system
- * @tracing_dir: directory holding the "events" directory
- * @system: the system to return the events for
- *
- * Returns an allocated list of event names. Both the names and
- * the list must be freed with free().
- * The list returned ends with a "NULL" pointer.
- */
-char **tracecmd_system_events(const char *tracing_dir, const char *system)
-{
-	struct dirent *dent;
-	char **events = NULL;
-	char *events_dir;
-	char *system_dir;
-	struct stat st;
-	DIR *dir;
-	int len = 0;
-	int ret;
-
-	if (!tracing_dir || !system)
-		return NULL;
-
-	events_dir = append_file(tracing_dir, "events");
-	if (!events_dir)
-		return NULL;
-
-	/*
-	 * Search all the directories in the systems directory,
-	 * and collect the ones that have the "enable" file.
-	 */
-	ret = stat(events_dir, &st);
-	if (ret < 0 || !S_ISDIR(st.st_mode))
-		goto out_free;
-
-	system_dir = append_file(events_dir, system);
-	if (!system_dir)
-		goto out_free;
-
-	ret = stat(system_dir, &st);
-	if (ret < 0 || !S_ISDIR(st.st_mode))
-		goto out_free_sys;
-
-	dir = opendir(system_dir);
-	if (!dir)
-		goto out_free_sys;
-
-	while ((dent = readdir(dir))) {
-		const char *name = dent->d_name;
-		char *enable;
-		char *event;
-
-		if (strcmp(name, ".") == 0 ||
-		    strcmp(name, "..") == 0)
-			continue;
-
-		event = append_file(system_dir, name);
-		ret = stat(event, &st);
-		if (ret < 0 || !S_ISDIR(st.st_mode)) {
-			free(event);
-			continue;
-		}
-
-		enable = append_file(event, "enable");
-
-		ret = stat(enable, &st);
-		if (ret >= 0)
-			events = tracecmd_add_list(events, name, len++);
-
-		free(enable);
-		free(event);
-	}
-
-	closedir(dir);
-
- out_free_sys:
-	free(system_dir);
-
- out_free:
-	free(events_dir);
-
-	return events;
-}
-
 static int read_file(const char *file, char **buffer)
 {
 	char *buf;
@@ -604,67 +400,6 @@ int tracecmd_fill_local_events(const char *tracing_dir,
 	return ret;
 }
 
-/**
- * tracecmd_local_plugins - returns an array of available tracer plugins
- * @tracing_dir: The directory that contains the tracing directory
- *
- * Returns an allocate list of plugins. The array ends with NULL.
- * Both the plugin names and array must be freed with free().
- */
-char **tracecmd_local_plugins(const char *tracing_dir)
-{
-	char *available_tracers;
-	struct stat st;
-	char **plugins = NULL;
-	char *buf;
-	char *str, *saveptr;
-	char *plugin;
-	int slen;
-	int len;
-	int ret;
-
-	if (!tracing_dir)
-		return NULL;
-
-	available_tracers = append_file(tracing_dir, "available_tracers");
-	if (!available_tracers)
-		return NULL;
-
-	ret = stat(available_tracers, &st);
-	if (ret < 0)
-		goto out_free;
-
-	len = read_file(available_tracers, &buf);
-	if (len < 0)
-		goto out_free;
-
-	len = 0;
-	for (str = buf; ; str = NULL) {
-		plugin = strtok_r(str, " ", &saveptr);
-		if (!plugin)
-			break;
-		if (!(slen = strlen(plugin)))
-			continue;
-
-		/* chop off any newlines */
-		if (plugin[slen - 1] == '\n')
-			plugin[slen - 1] = '\0';
-
-		/* Skip the non tracers */
-		if (strcmp(plugin, "nop") == 0 ||
-		    strcmp(plugin, "none") == 0)
-			continue;
-
-		plugins = tracecmd_add_list(plugins, plugin, len++);
-	}
-	free(buf);
-
- out_free:
-	free(available_tracers);
-
-	return plugins;
-}
-
 struct add_plugin_data {
 	int ret;
 	int index;
diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
index 4030272..5763e06 100644
--- a/lib/tracefs/Makefile
+++ b/lib/tracefs/Makefile
@@ -9,6 +9,7 @@ DEFAULT_TARGET = $(bdir)/libtracefs.a
 OBJS =
 OBJS += tracefs-utils.o
 OBJS += tracefs-instance.o
+OBJS += tracefs-events.o
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
diff --git a/lib/tracefs/tracefs-events.c b/lib/tracefs/tracefs-events.c
new file mode 100644
index 0000000..3469431
--- /dev/null
+++ b/lib/tracefs/tracefs-events.c
@@ -0,0 +1,442 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * Updates:
+ * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <dirent.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include "kbuffer.h"
+#include "tracefs.h"
+#include "tracefs-local.h"
+
+static struct kbuffer *
+page_to_kbuf(struct tep_handle *tep, void *page, int size)
+{
+	enum kbuffer_long_size long_size;
+	enum kbuffer_endian endian;
+	struct kbuffer *kbuf;
+
+	if (tep_is_file_bigendian(tep))
+		endian = KBUFFER_ENDIAN_BIG;
+	else
+		endian = KBUFFER_ENDIAN_LITTLE;
+
+	if (tep_get_header_page_size(tep) == 8)
+		long_size = KBUFFER_LSIZE_8;
+	else
+		long_size = KBUFFER_LSIZE_4;
+
+	kbuf = kbuffer_alloc(long_size, endian);
+	if (!kbuf)
+		return NULL;
+
+	kbuffer_load_subbuffer(kbuf, page);
+	if (kbuffer_subbuffer_size(kbuf) > size) {
+		warning("%s: page_size > size", __func__);
+		kbuffer_free(kbuf);
+		kbuf = NULL;
+	}
+
+	return kbuf;
+}
+
+static int read_kbuf_record(struct kbuffer *kbuf, struct tep_record *record)
+{
+	unsigned long long ts;
+	void *ptr;
+
+	ptr = kbuffer_read_event(kbuf, &ts);
+	if (!ptr || !record)
+		return -1;
+
+	memset(record, 0, sizeof(*record));
+	record->ts = ts;
+	record->size = kbuffer_event_size(kbuf);
+	record->record_size = kbuffer_curr_size(kbuf);
+	record->cpu = 0;
+	record->data = ptr;
+	record->ref_count = 1;
+
+	kbuffer_next_event(kbuf, NULL);
+
+	return 0;
+}
+
+static int
+get_events_in_page(struct tep_handle *tep, void *page,
+		   int size, int cpu,
+		   int (*callback)(struct tep_event *,
+				   struct tep_record *,
+				   int, void *),
+		   void *callback_context)
+{
+	struct tep_record record;
+	struct tep_event *event;
+	struct kbuffer *kbuf;
+	int id, cnt = 0;
+	int ret;
+
+	if (size <= 0)
+		return 0;
+
+	kbuf = page_to_kbuf(tep, page, size);
+	if (!kbuf)
+		return 0;
+
+	ret = read_kbuf_record(kbuf, &record);
+	while (!ret) {
+		id = tep_data_type(tep, &record);
+		event = tep_find_event(tep, id);
+		if (event) {
+			cnt++;
+			if (callback &&
+			    callback(event, &record, cpu, callback_context))
+				break;
+		}
+		ret = read_kbuf_record(kbuf, &record);
+	}
+
+	kbuffer_free(kbuf);
+
+	return cnt;
+}
+
+/*
+ * tracefs_iterate_raw_events - Iterate through events in trace_pipe_raw,
+ *				per CPU trace buffers
+ * @tep: a handle to the trace event parser context
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @callback: A user function, called for each record from the file
+ * @callback_context: A custom context, passed to the user callback function
+ *
+ * If the @callback returns non-zero, the iteration stops - in that case all
+ * records from the current page will be lost from future reads
+ *
+ * Returns -1 in case of an error, or 0 otherwise
+ */
+int tracefs_iterate_raw_events(struct tep_handle *tep,
+				struct tracefs_instance *instance,
+				int (*callback)(struct tep_event *,
+						struct tep_record *,
+						int, void *),
+				void *callback_context)
+{
+	unsigned int p_size;
+	struct dirent *dent;
+	char file[PATH_MAX];
+	void *page = NULL;
+	struct stat st;
+	char *path;
+	DIR *dir;
+	int ret;
+	int cpu;
+	int fd;
+	int r;
+
+	if (!tep || !callback)
+		return -1;
+
+	p_size = getpagesize();
+	path = tracefs_instance_get_file(instance, "per_cpu");
+	if (!path)
+		return -1;
+	dir = opendir(path);
+	if (!dir) {
+		ret = -1;
+		goto error;
+	}
+	page = malloc(p_size);
+	if (!page) {
+		ret = -1;
+		goto error;
+	}
+	while ((dent = readdir(dir))) {
+		const char *name = dent->d_name;
+
+		if (strlen(name) < 4 || strncmp(name, "cpu", 3) != 0)
+			continue;
+		cpu = atoi(name + 3);
+		sprintf(file, "%s/%s", path, name);
+		ret = stat(file, &st);
+		if (ret < 0 || !S_ISDIR(st.st_mode))
+			continue;
+
+		sprintf(file, "%s/%s/trace_pipe_raw", path, name);
+		fd = open(file, O_RDONLY | O_NONBLOCK);
+		if (fd < 0)
+			continue;
+		do {
+			r = read(fd, page, p_size);
+			if (r > 0)
+				get_events_in_page(tep, page, r, cpu,
+						   callback, callback_context);
+		} while (r > 0);
+		close(fd);
+	}
+	ret = 0;
+
+error:
+	if (dir)
+		closedir(dir);
+	free(page);
+	tracefs_put_tracing_file(path);
+	return ret;
+}
+
+static char **add_list_string(char **list, const char *name, int len)
+{
+	if (!list)
+		list = malloc(sizeof(*list) * 2);
+	else
+		list = realloc(list, sizeof(*list) * (len + 2));
+	if (!list)
+		return NULL;
+
+	list[len] = strdup(name);
+	if (!list[len])
+		return NULL;
+
+	list[len + 1] = NULL;
+
+	return list;
+}
+
+static char *append_file(const char *dir, const char *name)
+{
+	char *file;
+	int ret;
+
+	ret = asprintf(&file, "%s/%s", dir, name);
+
+	return ret < 0 ? NULL : file;
+}
+
+/**
+ * tracefs_list_free - free list if strings, returned by APIs
+ *			tracefs_event_systems()
+ *			tracefs_system_events()
+ *
+ *@list pointer to a list of strings, the last one must be NULL
+ */
+void tracefs_list_free(char **list)
+{
+	int i;
+
+	if (!list)
+		return;
+
+	for (i = 0; list[i]; i++)
+		free(list[i]);
+
+	free(list);
+}
+
+/**
+ * tracefs_event_systems - return list of systems for tracing
+ * @tracing_dir: directory holding the "events" directory
+ *		 if NULL, top tracing directory is used
+ *
+ * Returns an allocated list of system names. Both the names and
+ * the list must be freed with tracefs_list_free()
+ * The list returned ends with a "NULL" pointer
+ */
+char **tracefs_event_systems(const char *tracing_dir)
+{
+	struct dirent *dent;
+	char **systems = NULL;
+	char *events_dir;
+	struct stat st;
+	DIR *dir;
+	int len = 0;
+	int ret;
+
+	if (!tracing_dir)
+		tracing_dir = tracefs_get_tracing_dir();
+
+	if (!tracing_dir)
+		return NULL;
+
+	events_dir = append_file(tracing_dir, "events");
+	if (!events_dir)
+		return NULL;
+
+	/*
+	 * Search all the directories in the events directory,
+	 * and collect the ones that have the "enable" file.
+	 */
+	ret = stat(events_dir, &st);
+	if (ret < 0 || !S_ISDIR(st.st_mode))
+		goto out_free;
+
+	dir = opendir(events_dir);
+	if (!dir)
+		goto out_free;
+
+	while ((dent = readdir(dir))) {
+		const char *name = dent->d_name;
+		char *enable;
+		char *sys;
+
+		if (strcmp(name, ".") == 0 ||
+		    strcmp(name, "..") == 0)
+			continue;
+
+		sys = append_file(events_dir, name);
+		ret = stat(sys, &st);
+		if (ret < 0 || !S_ISDIR(st.st_mode)) {
+			free(sys);
+			continue;
+		}
+
+		enable = append_file(sys, "enable");
+
+		ret = stat(enable, &st);
+		if (ret >= 0)
+			systems = add_list_string(systems, name, len++);
+
+		free(enable);
+		free(sys);
+	}
+
+	closedir(dir);
+
+ out_free:
+	free(events_dir);
+	return systems;
+}
+
+/**
+ * tracefs_system_events - return list of events for system
+ * @tracing_dir: directory holding the "events" directory
+ * @system: the system to return the events for
+ *
+ * Returns an allocated list of event names. Both the names and
+ * the list must be freed with tracefs_list_free()
+ * The list returned ends with a "NULL" pointer
+ */
+char **tracefs_system_events(const char *tracing_dir, const char *system)
+{
+	struct dirent *dent;
+	char **events = NULL;
+	char *system_dir = NULL;
+	struct stat st;
+	DIR *dir;
+	int len = 0;
+	int ret;
+
+	if (!tracing_dir)
+		tracing_dir = tracefs_get_tracing_dir();
+
+	if (!tracing_dir || !system)
+		return NULL;
+
+	asprintf(&system_dir, "%s/events/%s", tracing_dir, system);
+	if (!system_dir)
+		return NULL;
+
+	ret = stat(system_dir, &st);
+	if (ret < 0 || !S_ISDIR(st.st_mode))
+		goto out_free;
+
+	dir = opendir(system_dir);
+	if (!dir)
+		goto out_free;
+
+	while ((dent = readdir(dir))) {
+		const char *name = dent->d_name;
+		char *event;
+
+		if (strcmp(name, ".") == 0 ||
+		    strcmp(name, "..") == 0)
+			continue;
+
+		event = append_file(system_dir, name);
+		ret = stat(event, &st);
+		if (ret < 0 || !S_ISDIR(st.st_mode)) {
+			free(event);
+			continue;
+		}
+
+		events = add_list_string(events, name, len++);
+
+		free(event);
+	}
+
+	closedir(dir);
+
+ out_free:
+	free(system_dir);
+
+	return events;
+}
+
+/**
+ * tracefs_tracers - returns an array of available tracers
+ * @tracing_dir: The directory that contains the tracing directory
+ *
+ * Returns an allocate list of plugins. The array ends with NULL
+ * Both the plugin names and array must be freed with free()
+ */
+char **tracefs_tracers(const char *tracing_dir)
+{
+	char *available_tracers;
+	struct stat st;
+	char **plugins = NULL;
+	char *buf;
+	char *str, *saveptr;
+	char *plugin;
+	int slen;
+	int len;
+	int ret;
+
+	if (!tracing_dir)
+		return NULL;
+
+	available_tracers = append_file(tracing_dir, "available_tracers");
+	if (!available_tracers)
+		return NULL;
+
+	ret = stat(available_tracers, &st);
+	if (ret < 0)
+		goto out_free;
+
+	len = str_read_file(available_tracers, &buf);
+	if (len < 0)
+		goto out_free;
+
+	len = 0;
+	for (str = buf; ; str = NULL) {
+		plugin = strtok_r(str, " ", &saveptr);
+		if (!plugin)
+			break;
+		slen = strlen(plugin);
+		if (!slen)
+			continue;
+
+		/* chop off any newlines */
+		if (plugin[slen - 1] == '\n')
+			plugin[slen - 1] = '\0';
+
+		/* Skip the non tracers */
+		if (strcmp(plugin, "nop") == 0 ||
+		    strcmp(plugin, "none") == 0)
+			continue;
+
+		plugins = add_list_string(plugins, plugin, len++);
+	}
+	free(buf);
+
+ out_free:
+	free(available_tracers);
+
+	return plugins;
+}
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 80ca03f..f7d3017 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4164,96 +4164,35 @@ static void add_func(struct func_list **list, const char *mod, const char *func)
 	*list = item;
 }
 
-static unsigned long long
-find_ts_in_page(struct tep_handle *pevent, void *page, int size)
+static int find_ts(struct tep_event *event, struct tep_record *record,
+		   int cpu, void *context)
 {
+	unsigned long long *ts = (unsigned long long *)context;
 	struct tep_format_field *field;
-	struct tep_record *last_record = NULL;
-	struct tep_record *record;
-	struct tep_event *event;
-	unsigned long long ts = 0;
-	int id;
 
-	if (size <= 0)
-		return 0;
+	if (!ts)
+		return -1;
 
-	while (!ts) {
-		record = tracecmd_read_page_record(pevent, page, size,
-						   last_record);
-		if (!record)
-			break;
-		free_record(last_record);
-		id = tep_data_type(pevent, record);
-		event = tep_find_event(pevent, id);
-		if (event) {
-			/* Make sure this is our event */
-			field = tep_find_field(event, "buf");
-			/* the trace_marker adds a '\n' */
-			if (field && strcmp(STAMP"\n", record->data + field->offset) == 0)
-				ts = record->ts;
-		}
-		last_record = record;
+	field = tep_find_field(event, "buf");
+	if (field && strcmp(STAMP"\n", record->data + field->offset) == 0) {
+		*ts = record->ts;
+		return 1;
 	}
-	free_record(last_record);
 
-	return ts;
+	return 0;
 }
 
-static unsigned long long find_time_stamp(struct tep_handle *pevent)
+static unsigned long long find_time_stamp(struct tep_handle *tep)
 {
-	struct dirent *dent;
 	unsigned long long ts = 0;
-	void *page;
-	char *path;
-	char *file;
-	DIR *dir;
-	int len;
-	int fd;
-	int r;
-
-	path = tracefs_get_tracing_file("per_cpu");
-	if (!path)
-		return 0;
-
-	dir = opendir(path);
-	if (!dir)
-		goto out;
 
-	len = strlen(path);
-	file = malloc(len + strlen("trace_pipe_raw") + 32);
-	page = malloc(page_size);
-	if (!file || !page)
-		die("Failed to allocate time_stamp info");
+	if (!tracefs_iterate_raw_events(tep, NULL, find_ts, &ts))
+		return ts;
 
-	while ((dent = readdir(dir))) {
-		const char *name = dent->d_name;
-
-		if (strncmp(name, "cpu", 3) != 0)
-			continue;
-
-		sprintf(file, "%s/%s/trace_pipe_raw", path, name);
-		fd = open(file, O_RDONLY | O_NONBLOCK);
-		if (fd < 0)
-			continue;
-		do {
-			r = read(fd, page, page_size);
-			ts = find_ts_in_page(pevent, page, r);
-			if (ts)
-				break;
-		} while (r > 0);
-		close(fd);
-		if (ts)
-			break;
-	}
-	free(file);
-	free(page);
-	closedir(dir);
-
- out:
-	tracefs_put_tracing_file(path);
-	return ts;
+	return 0;
 }
 
+
 static char *read_file(char *file, int *psize)
 {
 	return tracefs_instance_file_read(top_instance.tracefs, file, psize);
@@ -4271,7 +4210,7 @@ static char *get_date_to_ts(void)
 	unsigned long long min_stamp;
 	unsigned long long min_ts;
 	unsigned long long ts;
-	struct tep_handle *pevent;
+	struct tep_handle *tep;
 	struct timespec start;
 	struct timespec end;
 	char *date2ts = NULL;
@@ -4283,16 +4222,18 @@ static char *get_date_to_ts(void)
 	int i;
 
 	/* Set up a pevent to read the raw format */
-	pevent = tep_alloc();
-	if (!pevent) {
+	tep = tep_alloc();
+	if (!tep) {
 		warning("failed to alloc pevent, --date ignored");
 		return NULL;
 	}
 
+	tep_set_file_bigendian(tep, tracecmd_host_bigendian());
+
 	buf = read_file("events/header_page", &size);
 	if (!buf)
 		goto out_pevent;
-	ret = tep_parse_header_page(pevent, buf, size, sizeof(unsigned long));
+	ret = tep_parse_header_page(tep, buf, size, sizeof(unsigned long));
 	free(buf);
 	if (ret < 0) {
 		warning("Can't parse header page, --date ignored");
@@ -4303,7 +4244,7 @@ static char *get_date_to_ts(void)
 	buf = read_file("events/ftrace/print/format", &size);
 	if (!buf)
 		goto out_pevent;
-	ret = tep_parse_event(pevent, buf, size, "ftrace");
+	ret = tep_parse_event(tep, buf, size, "ftrace");
 	free(buf);
 	if (ret < 0) {
 		warning("Can't parse print event, --date ignored");
@@ -4328,7 +4269,7 @@ static char *get_date_to_ts(void)
 		clock_gettime(CLOCK_REALTIME, &end);
 
 		tracecmd_disable_tracing();
-		ts = find_time_stamp(pevent);
+		ts = find_time_stamp(tep);
 		if (!ts)
 			continue;
 
@@ -4365,7 +4306,7 @@ static char *get_date_to_ts(void)
 	snprintf(date2ts, 19, "0x%llx", diff/1000);
 
  out_pevent:
-	tep_free(pevent);
+	tep_free(tep);
 
 	return date2ts;
 }
-- 
2.24.1

