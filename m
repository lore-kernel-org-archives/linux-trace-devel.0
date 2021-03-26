Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F57AC433E3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Mar 2021 16:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F5E361A2D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Mar 2021 16:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhCZQul (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Mar 2021 12:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230204AbhCZQuQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Mar 2021 12:50:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCFAD61A33
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Mar 2021 16:50:15 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lPpf4-0026Tr-Ru
        for linux-trace-devel@vger.kernel.org; Fri, 26 Mar 2021 12:50:14 -0400
Message-ID: <20210326165014.748976294@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 26 Mar 2021 12:48:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] trace-cmd: Remove libtracefs code
References: <20210326164843.976844292@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Now that there is an external libtraceevent repository at:

  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/

Force the use of that repository, and remove the need to have duplicate
updates.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                            |  42 +-
 lib/tracefs/Makefile                |  70 ----
 lib/tracefs/include/tracefs-local.h |  30 --
 lib/tracefs/tracefs-events.c        | 626 ----------------------------
 lib/tracefs/tracefs-instance.c      | 455 --------------------
 lib/tracefs/tracefs-utils.c         | 230 ----------
 6 files changed, 16 insertions(+), 1437 deletions(-)
 delete mode 100644 lib/tracefs/Makefile
 delete mode 100644 lib/tracefs/include/tracefs-local.h
 delete mode 100644 lib/tracefs/tracefs-events.c
 delete mode 100644 lib/tracefs/tracefs-instance.c
 delete mode 100644 lib/tracefs/tracefs-utils.c

diff --git a/Makefile b/Makefile
index 84545f712769..2a09707a7130 100644
--- a/Makefile
+++ b/Makefile
@@ -225,19 +225,10 @@ export LIBTRACECMD_STATIC LIBTRACECMD_SHARED
 export LIBTRACECMD_SHARED_VERSION LIBTRACECMD_SHARED_SO
 
 LIBTRACEEVENT=libtraceevent
-
 LIBTRACEFS=libtracefs
-LIBTRACEFS_DIR = $(obj)/lib/tracefs
-LIBTRACEFS_STATIC = $(LIBTRACEFS_DIR)/libtracefs.a
 
 TEST_LIBTRACEEVENT = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y")
-
-# In the special case (debugging), that the local versions of the
-# libraries need to be built, adding "LOCAL_LIBS=1" to the make
-# command line will skip the check if they are installed.
-ifneq ("$(origin LOCAL_LIBS)", "command line")
 TEST_LIBTRACEFS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEFS) > /dev/null 2>&1 && echo y")
-endif
 
 ifeq ("$(TEST_LIBTRACEEVENT)", "y")
 LIBTRACEEVENT_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT)")
@@ -262,9 +253,17 @@ ifeq ("$(TEST_LIBTRACEFS)", "y")
 LIBTRACEFS_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEFS)")
 LIBTRACEFS_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEFS)")
 else
-LIBTRACEFS_CFLAGS = -I$(src)/include/tracefs
-LIBTRACEFS_LDLAGS = -L$(LIBTRACEFS_DIR) -ltracefs
-LIBTRACEFS_STATIC_BUILD = $(LIBTRACEFS_STATIC)
+.PHONY: warning
+warning:
+	@echo "********************************************"
+	@echo "** NOTICE: libtracefs not found on system"
+	@echo "**"
+	@echo "** Consider installing the latest libtracefs from your"
+	@echo "** distribution, or from source:"
+	@echo "**"
+	@echo "**  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/ "
+	@echo "**"
+	@echo "********************************************"
 endif
 
 export LIBTRACEFS_CFLAGS LIBTRACEFS_LDLAGS
@@ -273,7 +272,7 @@ TRACE_LIBS = -L$(LIBTRACECMD_DIR) -ltracecmd	\
 	     $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS)
 
 export LIBS TRACE_LIBS
-export LIBTRACECMD_DIR LIBTRACEFS_DIR
+export LIBTRACECMD_DIR
 export Q SILENT VERBOSE EXT
 
 # Include the utils
@@ -369,7 +368,7 @@ $(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template $(BUILD_PREFIX)
 $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
 	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) -D_LIBDIR=$(libdir) ..
 
-trace-cmd: force $(LIBTRACECMD_STATIC) $(LIBTRACEFS_STATIC_BUILD) \
+trace-cmd: force $(LIBTRACECMD_STATIC) \
 	force $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir
 	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
 
@@ -379,26 +378,18 @@ $(LIBTRACECMD_STATIC): force
 $(LIBTRACECMD_SHARED): force
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd libtracecmd.so
 
-$(LIBTRACEFS_STATIC): force
-	$(Q)$(MAKE) -C $(src)/lib/tracefs libtracefs
-
 libtracecmd.a: $(LIBTRACECMD_STATIC)
 libtracecmd.so: $(LIBTRACECMD_SHARED)
-libtracefs.a: $(LIBTRACEFS_STATIC)
-
-libs: $(LIBTRACECMD_SHARED) $(LIBTRACEFS_STATIC_BUILD) $(PKG_CONFIG_FILE)
-
-libtracefs_nowarn: force
-	$(Q)$(MAKE) -C $(src)/lib/tracefs $@
 
+libs: $(LIBTRACECMD_SHARED) $(PKG_CONFIG_FILE)
 
-gui: force $(CMD_TARGETS) libtracefs_nowarn
+gui: force $(CMD_TARGETS)
 	$(MAKE) $(kshark-dir)/build/Makefile
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
 	@echo "gui build complete"
 	@echo "  kernelshark located at $(kshark-dir)/bin"
 
-test: force $(LIBTRACEFS_STATIC_BUILD) $(LIBTRACECMD_STATIC)
+test: force $(LIBTRACECMD_STATIC)
 ifneq ($(CUNIT_INSTALLED),1)
 	$(error CUnit framework not installed, cannot build unit tests))
 endif
@@ -492,7 +483,6 @@ clean:
 	$(RM) *.o *~ *.a *.so .*.d
 	$(RM) tags TAGS cscope* $(PKG_CONFIG_SOURCE_FILE)
 	$(MAKE) -C $(src)/lib/trace-cmd clean
-	$(MAKE) -C $(src)/lib/tracefs clean
 	$(MAKE) -C $(src)/lib/trace-cmd/plugins clean
 	$(MAKE) -C $(src)/utest clean
 	$(MAKE) -C $(src)/python clean
diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
deleted file mode 100644
index 74cb8829979f..000000000000
--- a/lib/tracefs/Makefile
+++ /dev/null
@@ -1,70 +0,0 @@
-# SPDX-License-Identifier: LGPL-2.1
-
-include $(src)/scripts/utils.mk
-
-bdir:=$(obj)/lib/tracefs
-
-DEFAULT_TARGET = $(bdir)/libtracefs.a
-
-LIBTRACEEVENT_CFLAGS = -I$(src)/include/traceevent -I$(src)/lib/traceevent/include
-LIBTRACEFS_CFLAGS = -I$(src)/include/tracefs -I$(src)/lib/tracefs/include
-
-CFLAGS += -I$(bdir)/include
-
-CFLAGS := $(LIBTRACEEVENT_CFLAGS) $(LIBTRACEFS_CFLAGS) $(CFLAGS)
-
-OBJS =
-OBJS += tracefs-utils.o
-OBJS += tracefs-instance.o
-OBJS += tracefs-events.o
-
-OBJS := $(OBJS:%.o=$(bdir)/%.o)
-DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
-
-all: $(DEFAULT_TARGET)
-
-$(bdir):
-	@mkdir -p $(bdir)
-
-$(OBJS): | $(bdir)
-$(DEPS): | $(bdir)
-
-LIBS = -L$(obj)/lib/traceevent -ltraceevent
-
-.PHONY: warning
-warning:
-	@echo "********************************************"
-	@echo "** NOTICE: libtracefs not found on system"
-	@echo "**"
-	@echo "** Building obsolete local version of libtracefs"
-	@echo "** Consider installing the latest libtracefs"
-	@echo "**"
-	@echo "**  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/ "
-	@echo "**"
-	@echo "********************************************"
-
-$(bdir)/libtracefs.a: $(OBJS)
-	$(Q)$(call do_build_static_lib)
-
-libtracefs: $(bdir)/libtracefs.a warning
-
-libtracefs_nowarn: $(bdir)/libtracefs.a
-
-$(bdir)/%.o: %.c
-	$(Q)$(call do_fpic_compile)
-
-$(DEPS): $(bdir)/.%.d: %.c
-	$(Q)$(CC) -M -MT $(bdir)/$*.o $(CPPFLAGS) $(CFLAGS) $< > $@
-
-$(OBJS): $(bdir)/%.o : $(bdir)/.%.d
-
-dep_includes := $(wildcard $(DEPS))
-
-ifneq ($(dep_includes),)
-  include $(dep_includes)
-endif
-
-clean:
-	$(RM) $(bdir)/*.a $(bdir)/*.o $(bdir)/.*.d
-
-.PHONY: clean
diff --git a/lib/tracefs/include/tracefs-local.h b/lib/tracefs/include/tracefs-local.h
deleted file mode 100644
index c222fe4fa8b7..000000000000
--- a/lib/tracefs/include/tracefs-local.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
-/*
- * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
- *
- */
-#ifndef _TRACE_FS_LOCAL_H
-#define _TRACE_FS_LOCAL_H
-
-#define __hidden __attribute__((visibility ("hidden")))
-
-/* Can be overridden */
-void warning(const char *fmt, ...);
-int str_read_file(const char *file, char **buffer);
-char *trace_append_file(const char *dir, const char *name);
-
-char *trace_find_tracing_dir(void);
-
-#ifndef ACCESSPERMS
-#define ACCESSPERMS (S_IRWXU|S_IRWXG|S_IRWXO) /* 0777 */
-#endif
-
-#ifndef ALLPERMS
-#define ALLPERMS (S_ISUID|S_ISGID|S_ISVTX|S_IRWXU|S_IRWXG|S_IRWXO) /* 07777 */
-#endif
-
-#ifndef DEFFILEMODE
-#define DEFFILEMODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH) /* 0666*/
-#endif
-
-#endif /* _TRACE_FS_LOCAL_H */
diff --git a/lib/tracefs/tracefs-events.c b/lib/tracefs/tracefs-events.c
deleted file mode 100644
index 826b6fc73bb9..000000000000
--- a/lib/tracefs/tracefs-events.c
+++ /dev/null
@@ -1,626 +0,0 @@
-// SPDX-License-Identifier: LGPL-2.1
-/*
- * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
- *
- * Updates:
- * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
- *
- */
-#include <stdio.h>
-#include <stdlib.h>
-#include <dirent.h>
-#include <unistd.h>
-#include <errno.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <limits.h>
-
-#include "kbuffer.h"
-#include "tracefs.h"
-#include "tracefs-local.h"
-
-static struct kbuffer *
-page_to_kbuf(struct tep_handle *tep, void *page, int size)
-{
-	enum kbuffer_long_size long_size;
-	enum kbuffer_endian endian;
-	struct kbuffer *kbuf;
-
-	if (tep_is_file_bigendian(tep))
-		endian = KBUFFER_ENDIAN_BIG;
-	else
-		endian = KBUFFER_ENDIAN_LITTLE;
-
-	if (tep_get_header_page_size(tep) == 8)
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
-		warning("%s: page_size > size", __func__);
-		kbuffer_free(kbuf);
-		kbuf = NULL;
-	}
-
-	return kbuf;
-}
-
-static int read_kbuf_record(struct kbuffer *kbuf, struct tep_record *record)
-{
-	unsigned long long ts;
-	void *ptr;
-
-	ptr = kbuffer_read_event(kbuf, &ts);
-	if (!ptr || !record)
-		return -1;
-
-	memset(record, 0, sizeof(*record));
-	record->ts = ts;
-	record->size = kbuffer_event_size(kbuf);
-	record->record_size = kbuffer_curr_size(kbuf);
-	record->cpu = 0;
-	record->data = ptr;
-	record->ref_count = 1;
-
-	kbuffer_next_event(kbuf, NULL);
-
-	return 0;
-}
-
-static int
-get_events_in_page(struct tep_handle *tep, void *page,
-		   int size, int cpu,
-		   int (*callback)(struct tep_event *,
-				   struct tep_record *,
-				   int, void *),
-		   void *callback_context)
-{
-	struct tep_record record;
-	struct tep_event *event;
-	struct kbuffer *kbuf;
-	int id, cnt = 0;
-	int ret;
-
-	if (size <= 0)
-		return 0;
-
-	kbuf = page_to_kbuf(tep, page, size);
-	if (!kbuf)
-		return 0;
-
-	ret = read_kbuf_record(kbuf, &record);
-	while (!ret) {
-		id = tep_data_type(tep, &record);
-		event = tep_find_event(tep, id);
-		if (event) {
-			cnt++;
-			if (callback &&
-			    callback(event, &record, cpu, callback_context))
-				break;
-		}
-		ret = read_kbuf_record(kbuf, &record);
-	}
-
-	kbuffer_free(kbuf);
-
-	return cnt;
-}
-
-/*
- * tracefs_iterate_raw_events - Iterate through events in trace_pipe_raw,
- *				per CPU trace buffers
- * @tep: a handle to the trace event parser context
- * @instance: ftrace instance, can be NULL for the top instance
- * @cpus: Iterate only through the buffers of CPUs, set in the mask.
- *	  If NULL, iterate through all CPUs.
- * @cpu_size: size of @cpus set
- * @callback: A user function, called for each record from the file
- * @callback_context: A custom context, passed to the user callback function
- *
- * If the @callback returns non-zero, the iteration stops - in that case all
- * records from the current page will be lost from future reads
- *
- * Returns -1 in case of an error, or 0 otherwise
- */
-int tracefs_iterate_raw_events(struct tep_handle *tep,
-				struct tracefs_instance *instance,
-				cpu_set_t *cpus, int cpu_size,
-				int (*callback)(struct tep_event *,
-						struct tep_record *,
-						int, void *),
-				void *callback_context)
-{
-	unsigned int p_size;
-	struct dirent *dent;
-	char file[PATH_MAX];
-	void *page = NULL;
-	struct stat st;
-	char *path;
-	DIR *dir;
-	int ret;
-	int cpu;
-	int fd;
-	int r;
-
-	if (!tep || !callback)
-		return -1;
-
-	p_size = getpagesize();
-	path = tracefs_instance_get_file(instance, "per_cpu");
-	if (!path)
-		return -1;
-	dir = opendir(path);
-	if (!dir) {
-		ret = -1;
-		goto error;
-	}
-	page = malloc(p_size);
-	if (!page) {
-		ret = -1;
-		goto error;
-	}
-	while ((dent = readdir(dir))) {
-		const char *name = dent->d_name;
-
-		if (strlen(name) < 4 || strncmp(name, "cpu", 3) != 0)
-			continue;
-		cpu = atoi(name + 3);
-		if (cpus && !CPU_ISSET_S(cpu, cpu_size, cpus))
-			continue;
-		sprintf(file, "%s/%s", path, name);
-		ret = stat(file, &st);
-		if (ret < 0 || !S_ISDIR(st.st_mode))
-			continue;
-
-		sprintf(file, "%s/%s/trace_pipe_raw", path, name);
-		fd = open(file, O_RDONLY | O_NONBLOCK);
-		if (fd < 0)
-			continue;
-		do {
-			r = read(fd, page, p_size);
-			if (r > 0)
-				get_events_in_page(tep, page, r, cpu,
-						   callback, callback_context);
-		} while (r > 0);
-		close(fd);
-	}
-	ret = 0;
-
-error:
-	if (dir)
-		closedir(dir);
-	free(page);
-	tracefs_put_tracing_file(path);
-	return ret;
-}
-
-static char **add_list_string(char **list, const char *name, int len)
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
-__hidden char *trace_append_file(const char *dir, const char *name)
-{
-	char *file;
-	int ret;
-
-	ret = asprintf(&file, "%s/%s", dir, name);
-
-	return ret < 0 ? NULL : file;
-}
-
-/**
- * tracefs_list_free - free list if strings, returned by APIs
- *			tracefs_event_systems()
- *			tracefs_system_events()
- *
- *@list pointer to a list of strings, the last one must be NULL
- */
-void tracefs_list_free(char **list)
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
-/**
- * tracefs_event_systems - return list of systems for tracing
- * @tracing_dir: directory holding the "events" directory
- *		 if NULL, top tracing directory is used
- *
- * Returns an allocated list of system names. Both the names and
- * the list must be freed with tracefs_list_free()
- * The list returned ends with a "NULL" pointer
- */
-char **tracefs_event_systems(const char *tracing_dir)
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
-		tracing_dir = tracefs_tracing_dir();
-
-	if (!tracing_dir)
-		return NULL;
-
-	events_dir = trace_append_file(tracing_dir, "events");
-	if (!events_dir)
-		return NULL;
-
-	/*
-	 * Search all the directories in the events directory,
-	 * and collect the ones that have the "enable" file.
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
-		sys = trace_append_file(events_dir, name);
-		ret = stat(sys, &st);
-		if (ret < 0 || !S_ISDIR(st.st_mode)) {
-			free(sys);
-			continue;
-		}
-
-		enable = trace_append_file(sys, "enable");
-
-		ret = stat(enable, &st);
-		if (ret >= 0)
-			systems = add_list_string(systems, name, len++);
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
- * tracefs_system_events - return list of events for system
- * @tracing_dir: directory holding the "events" directory
- * @system: the system to return the events for
- *
- * Returns an allocated list of event names. Both the names and
- * the list must be freed with tracefs_list_free()
- * The list returned ends with a "NULL" pointer
- */
-char **tracefs_system_events(const char *tracing_dir, const char *system)
-{
-	struct dirent *dent;
-	char **events = NULL;
-	char *system_dir = NULL;
-	struct stat st;
-	DIR *dir;
-	int len = 0;
-	int ret;
-
-	if (!tracing_dir)
-		tracing_dir = tracefs_tracing_dir();
-
-	if (!tracing_dir || !system)
-		return NULL;
-
-	asprintf(&system_dir, "%s/events/%s", tracing_dir, system);
-	if (!system_dir)
-		return NULL;
-
-	ret = stat(system_dir, &st);
-	if (ret < 0 || !S_ISDIR(st.st_mode))
-		goto out_free;
-
-	dir = opendir(system_dir);
-	if (!dir)
-		goto out_free;
-
-	while ((dent = readdir(dir))) {
-		const char *name = dent->d_name;
-		char *event;
-
-		if (strcmp(name, ".") == 0 ||
-		    strcmp(name, "..") == 0)
-			continue;
-
-		event = trace_append_file(system_dir, name);
-		ret = stat(event, &st);
-		if (ret < 0 || !S_ISDIR(st.st_mode)) {
-			free(event);
-			continue;
-		}
-
-		events = add_list_string(events, name, len++);
-
-		free(event);
-	}
-
-	closedir(dir);
-
- out_free:
-	free(system_dir);
-
-	return events;
-}
-
-/**
- * tracefs_tracers - returns an array of available tracers
- * @tracing_dir: The directory that contains the tracing directory
- *
- * Returns an allocate list of plugins. The array ends with NULL
- * Both the plugin names and array must be freed with free()
- */
-char **tracefs_tracers(const char *tracing_dir)
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
-	available_tracers = trace_append_file(tracing_dir, "available_tracers");
-	if (!available_tracers)
-		return NULL;
-
-	ret = stat(available_tracers, &st);
-	if (ret < 0)
-		goto out_free;
-
-	len = str_read_file(available_tracers, &buf);
-	if (len < 0)
-		goto out_free;
-
-	len = 0;
-	for (str = buf; ; str = NULL) {
-		plugin = strtok_r(str, " ", &saveptr);
-		if (!plugin)
-			break;
-		slen = strlen(plugin);
-		if (!slen)
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
-		plugins = add_list_string(plugins, plugin, len++);
-	}
-	free(buf);
-
- out_free:
-	free(available_tracers);
-
-	return plugins;
-}
-
-static int load_events(struct tep_handle *tep,
-		       const char *tracing_dir, const char *system)
-{
-	int ret = 0, failure = 0;
-	char **events = NULL;
-	struct stat st;
-	int len = 0;
-	int i;
-
-	events = tracefs_system_events(tracing_dir, system);
-	if (!events)
-		return -ENOENT;
-
-	for (i = 0; events[i]; i++) {
-		char *format;
-		char *buf;
-
-		ret = asprintf(&format, "%s/events/%s/%s/format",
-			       tracing_dir, system, events[i]);
-		if (ret < 0) {
-			failure = -ENOMEM;
-			break;
-		}
-
-		ret = stat(format, &st);
-		if (ret < 0)
-			goto next_event;
-
-		len = str_read_file(format, &buf);
-		if (len < 0)
-			goto next_event;
-
-		ret = tep_parse_event(tep, buf, len, system);
-		free(buf);
-next_event:
-		free(format);
-		if (ret)
-			failure = ret;
-	}
-
-	tracefs_list_free(events);
-	return failure;
-}
-
-static int read_header(struct tep_handle *tep, const char *tracing_dir)
-{
-	struct stat st;
-	char *header;
-	char *buf;
-	int len;
-	int ret = -1;
-
-	header = trace_append_file(tracing_dir, "events/header_page");
-
-	ret = stat(header, &st);
-	if (ret < 0)
-		goto out;
-
-	len = str_read_file(header, &buf);
-	if (len < 0)
-		goto out;
-
-	tep_parse_header_page(tep, buf, len, sizeof(long));
-
-	free(buf);
-
-	ret = 0;
- out:
-	free(header);
-	return ret;
-}
-
-static bool contains(const char *name, const char * const *names)
-{
-	if (!names)
-		return false;
-	for (; *names; names++)
-		if (strcmp(name, *names) == 0)
-			return true;
-	return false;
-}
-
-static int fill_local_events_system(const char *tracing_dir,
-				    struct tep_handle *tep,
-				    const char * const *sys_names,
-				    int *parsing_failures)
-{
-	char **systems = NULL;
-	int ret;
-	int i;
-
-	if (!tracing_dir)
-		tracing_dir = tracefs_tracing_dir();
-	if (!tracing_dir)
-		return -1;
-
-	systems = tracefs_event_systems(tracing_dir);
-	if (!systems)
-		return -1;
-
-	ret = read_header(tep, tracing_dir);
-	if (ret < 0) {
-		ret = -1;
-		goto out;
-	}
-
-	if (parsing_failures)
-		*parsing_failures = 0;
-
-	for (i = 0; systems[i]; i++) {
-		if (sys_names && !contains(systems[i], sys_names))
-			continue;
-		ret = load_events(tep, tracing_dir, systems[i]);
-		if (ret && parsing_failures)
-			(*parsing_failures)++;
-	}
-	/* always succeed because parsing failures are not critical */
-	ret = 0;
-out:
-	tracefs_list_free(systems);
-	return ret;
-}
-
-/**
- * tracefs_local_events_system - create a tep from the events of the specified subsystem.
- *
- * @tracing_dir: The directory that contains the events.
- * @sys_name: Array of system names, to load the events from.
- * The last element from the array must be NULL
- *
- * Returns a tep structure that contains the tep local to
- * the system.
- */
-struct tep_handle *tracefs_local_events_system(const char *tracing_dir,
-					       const char * const *sys_names)
-{
-	struct tep_handle *tep = NULL;
-
-	tep = tep_alloc();
-	if (!tep)
-		return NULL;
-
-	if (fill_local_events_system(tracing_dir, tep, sys_names, NULL)) {
-		tep_free(tep);
-		tep = NULL;
-	}
-
-	return tep;
-}
-
-/**
- * tracefs_local_events - create a tep from the events on system
- * @tracing_dir: The directory that contains the events.
- *
- * Returns a tep structure that contains the teps local to
- * the system.
- */
-struct tep_handle *tracefs_local_events(const char *tracing_dir)
-{
-	return tracefs_local_events_system(tracing_dir, NULL);
-}
-
-/**
- * tracefs_fill_local_events - Fill a tep with the events on system
- * @tracing_dir: The directory that contains the events.
- * @tep: Allocated tep handler which will be filled
- * @parsing_failures: return number of failures while parsing the event files
- *
- * Returns whether the operation succeeded
- */
-int tracefs_fill_local_events(const char *tracing_dir,
-			       struct tep_handle *tep, int *parsing_failures)
-{
-	return fill_local_events_system(tracing_dir, tep,
-					NULL, parsing_failures);
-}
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
deleted file mode 100644
index bf3de7cc2d57..000000000000
--- a/lib/tracefs/tracefs-instance.c
+++ /dev/null
@@ -1,455 +0,0 @@
-// SPDX-License-Identifier: LGPL-2.1
-/*
- * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
- *
- * Updates:
- * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
- *
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <errno.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <dirent.h>
-#include <linux/limits.h>
-#include "tracefs.h"
-#include "tracefs-local.h"
-
-#define FLAG_INSTANCE_NEWLY_CREATED	(1 << 0)
-struct tracefs_instance {
-	char	*name;
-	int	flags;
-};
-
-/**
- * instance_alloc - allocate a new ftrace instance
- * @name: The name of the instance (instance will point to this)
- *
- * Returns a newly allocated instance, or NULL in case of an error.
- */
-static struct tracefs_instance *instance_alloc(const char *name)
-{
-	struct tracefs_instance *instance;
-
-	instance = calloc(1, sizeof(*instance));
-	if (instance && name) {
-		instance->name = strdup(name);
-		if (!instance->name) {
-			free(instance);
-			instance = NULL;
-		}
-	}
-
-	return instance;
-}
-
-/**
- * tracefs_instance_free - Free an instance, previously allocated by
-			   tracefs_instance_create()
- * @instance: Pointer to the instance to be freed
- *
- */
-void tracefs_instance_free(struct tracefs_instance *instance)
-{
-	if (!instance)
-		return;
-	free(instance->name);
-	free(instance);
-}
-
-static mode_t get_trace_file_permissions(char *name)
-{
-	mode_t rmode = 0;
-	struct stat st;
-	char *path;
-	int ret;
-
-	path = tracefs_get_tracing_file(name);
-	if (!path)
-		return 0;
-	ret = stat(path, &st);
-	if (ret)
-		goto out;
-	rmode = st.st_mode & ACCESSPERMS;
-out:
-	tracefs_put_tracing_file(path);
-	return rmode;
-}
-
-/**
- * tracefs_instance_is_new - Check if the instance is newly created by the library
- * @instance: Pointer to an ftrace instance
- *
- * Returns true, if the ftrace instance is newly created by the library or
- * false otherwise.
- */
-bool tracefs_instance_is_new(struct tracefs_instance *instance)
-{
-	if (instance && (instance->flags & FLAG_INSTANCE_NEWLY_CREATED))
-		return true;
-	return false;
-}
-
-/**
- * tracefs_instance_create - Create a new ftrace instance
- * @name: Name of the instance to be created
- *
- * Allocates and initializes a new instance structure. If the instance does not
- * exist in the system, create it.
- * Returns a pointer to a newly allocated instance, or NULL in case of an error.
- * The returned instance must be freed by tracefs_instance_free().
- */
-struct tracefs_instance *tracefs_instance_create(const char *name)
-{
-	struct tracefs_instance *inst = NULL;
-	struct stat st;
-	mode_t mode;
-	char *path;
-	int ret;
-
-	inst = instance_alloc(name);
-	if (!inst)
-		return NULL;
-
-	path = tracefs_instance_get_dir(inst);
-	ret = stat(path, &st);
-	if (ret < 0) {
-		/* Cannot create the top instance, if it does not exist! */
-		if (!name)
-			goto error;
-		mode = get_trace_file_permissions("instances");
-		if (mkdir(path, mode))
-			goto error;
-		inst->flags |= FLAG_INSTANCE_NEWLY_CREATED;
-	}
-	tracefs_put_tracing_file(path);
-	return inst;
-
-error:
-	tracefs_instance_free(inst);
-	return NULL;
-}
-
-/**
- * tracefs_instance_destroy - Remove a ftrace instance
- * @instance: Pointer to the instance to be removed
- *
- * Returns -1 in case of an error, or 0 otherwise.
- */
-int tracefs_instance_destroy(struct tracefs_instance *instance)
-{
-	char *path;
-	int ret = -1;
-
-	if (!instance || !instance->name) {
-		warning("Cannot remove top instance");
-		return -1;
-	}
-
-	path = tracefs_instance_get_dir(instance);
-	if (path)
-		ret = rmdir(path);
-	tracefs_put_tracing_file(path);
-
-	return ret;
-}
-
-/**
- * tracefs_instance_get_file - return the path to an instance file.
- * @instance: ftrace instance, can be NULL for the top instance
- * @file: name of file to return
- *
- * Returns the path of the @file for the given @instance, or NULL in
- * case of an error.
- *
- * Must use tracefs_put_tracing_file() to free the returned string.
- */
-char *
-tracefs_instance_get_file(struct tracefs_instance *instance, const char *file)
-{
-	char *path;
-	char *buf;
-	int ret;
-
-	if (instance && instance->name) {
-		ret = asprintf(&buf, "instances/%s/%s", instance->name, file);
-		if (ret < 0)
-			return NULL;
-		path = tracefs_get_tracing_file(buf);
-		free(buf);
-	} else
-		path = tracefs_get_tracing_file(file);
-
-	return path;
-}
-
-/**
- * tracefs_instance_get_dir - return the path to the instance directory.
- * @instance: ftrace instance, can be NULL for the top instance
- *
- * Returns the full path to the instance directory
- *
- * Must use tracefs_put_tracing_file() to free the returned string.
- */
-char *tracefs_instance_get_dir(struct tracefs_instance *instance)
-{
-	char *buf;
-	char *path;
-	int ret;
-
-	if (instance && instance->name) {
-		ret = asprintf(&buf, "instances/%s", instance->name);
-		if (ret < 0) {
-			warning("Failed to allocate path for instance %s",
-				 instance->name);
-			return NULL;
-		}
-		path = tracefs_get_tracing_file(buf);
-		free(buf);
-	} else
-		path = trace_find_tracing_dir();
-
-	return path;
-}
-
-/**
- * tracefs_instance_get_name - return the name of an instance
- * @instance: ftrace instance
- *
- * Returns the name of the given @instance.
- * The returned string must *not* be freed.
- */
-const char *tracefs_instance_get_name(struct tracefs_instance *instance)
-{
-	if (instance)
-		return instance->name;
-	return NULL;
-}
-
-static int write_file(const char *file, const char *str)
-{
-	int ret;
-	int fd;
-
-	fd = open(file, O_WRONLY | O_TRUNC);
-	if (fd < 0) {
-		warning("Failed to open '%s'", file);
-		return -1;
-	}
-	ret = write(fd, str, strlen(str));
-	close(fd);
-	return ret;
-}
-
-
-/**
- * tracefs_instance_file_write - Write in trace file of specific instance.
- * @instance: ftrace instance, can be NULL for the top instance
- * @file: name of the file
- * @str: nul terminated string, that will be written in the file.
- *
- * Returns the number of written bytes, or -1 in case of an error
- */
-int tracefs_instance_file_write(struct tracefs_instance *instance,
-				 const char *file, const char *str)
-{
-	struct stat st;
-	char *path;
-	int ret;
-
-	path = tracefs_instance_get_file(instance, file);
-	if (!path)
-		return -1;
-	ret = stat(path, &st);
-	if (ret == 0)
-		ret = write_file(path, str);
-	tracefs_put_tracing_file(path);
-
-	return ret;
-}
-
-/**
- * tracefs_instance_file_read - Read from a trace file of specific instance.
- * @instance: ftrace instance, can be NULL for the top instance
- * @file: name of the file
- * @psize: returns the number of bytes read
- *
- * Returns a pointer to a nul terminated string, read from the file, or NULL in
- * case of an error.
- * The return string must be freed by free()
- */
-char *tracefs_instance_file_read(struct tracefs_instance *instance,
-				  char *file, int *psize)
-{
-	char *buf = NULL;
-	int size = 0;
-	char *path;
-
-	path = tracefs_instance_get_file(instance, file);
-	if (!path)
-		return NULL;
-
-	size = str_read_file(path, &buf);
-
-	tracefs_put_tracing_file(path);
-	if (buf && psize)
-		*psize = size;
-
-	return buf;
-}
-
-static bool check_file_exists(struct tracefs_instance *instance,
-			     char *name, bool dir)
-{
-	char file[PATH_MAX];
-	struct stat st;
-	char *path;
-	int ret;
-
-	path = tracefs_instance_get_dir(instance);
-	if (name)
-		snprintf(file, PATH_MAX, "%s/%s", path, name);
-	else
-		snprintf(file, PATH_MAX, "%s", path);
-	tracefs_put_tracing_file(path);
-	ret = stat(file, &st);
-	if (ret < 0)
-		return false;
-
-	return !dir == !S_ISDIR(st.st_mode);
-}
-
-/**
- * tracefs_instance_exists - Check an instance with given name exists
- * @name: name of the instance
- *
- * Returns true if the instance exists, false otherwise
- *
- */
-bool tracefs_instance_exists(const char *name)
-{
-	char file[PATH_MAX];
-
-	if (!name)
-		return false;
-	snprintf(file, PATH_MAX, "instances/%s", name);
-	return check_file_exists(NULL, file, true);
-}
-
-/**
- * tracefs_file_exists - Check if a file with given name exists in given instance
- * @instance: ftrace instance, can be NULL for the top instance
- * @name: name of the file
- *
- * Returns true if the file exists, false otherwise
- *
- * If a directory with the given name exists, false is returned.
- */
-bool tracefs_file_exists(struct tracefs_instance *instance, char *name)
-{
-	return check_file_exists(instance, name, false);
-}
-
-/**
- * tracefs_dir_exists - Check if a directory with given name exists in given instance
- * @instance: ftrace instance, can be NULL for the top instance
- * @name: name of the directory
- *
- * Returns true if the directory exists, false otherwise
- */
-bool tracefs_dir_exists(struct tracefs_instance *instance, char *name)
-{
-	return check_file_exists(instance, name, true);
-}
-
-/**
- * tracefs_instances_walk - Iterate through all ftrace instances in the system
- * @callback: user callback, called for each instance. Instance name is passed
- *	      as input parameter. If the @callback returns non-zero,
- *	      the iteration stops.
- * @context: user context, passed to the @callback.
- *
- * Returns -1 in case of an error, 1 if the iteration was stopped because of the
- * callback return value or 0 otherwise.
- */
-int tracefs_instances_walk(int (*callback)(const char *, void *), void *context)
-{
-	struct dirent *dent;
-	char *path = NULL;
-	DIR *dir = NULL;
-	struct stat st;
-	int fret = -1;
-	int ret;
-
-	path = tracefs_get_tracing_file("instances");
-	if (!path)
-		return -1;
-	ret = stat(path, &st);
-	if (ret < 0 || !S_ISDIR(st.st_mode))
-		goto out;
-
-	dir = opendir(path);
-	if (!dir)
-		goto out;
-	fret = 0;
-	while ((dent = readdir(dir))) {
-		char *instance;
-
-		if (strcmp(dent->d_name, ".") == 0 ||
-		    strcmp(dent->d_name, "..") == 0)
-			continue;
-		instance = trace_append_file(path, dent->d_name);
-		ret = stat(instance, &st);
-		free(instance);
-		if (ret < 0 || !S_ISDIR(st.st_mode))
-			continue;
-		if (callback(dent->d_name, context)) {
-			fret = 1;
-			break;
-		}
-	}
-
-out:
-	if (dir)
-		closedir(dir);
-	tracefs_put_tracing_file(path);
-	return fret;
-}
-
-/**
- * tracefs_get_clock - Get the current trace clock
- * @instance: ftrace instance, can be NULL for the top instance
- *
- * Returns the current trace clock of the given instance, or NULL in
- * case of an error.
- * The return string must be freed by free()
- */
-char *tracefs_get_clock(struct tracefs_instance *instance)
-{
-	char *all_clocks = NULL;
-	char *ret = NULL;
-	int bytes = 0;
-	char *clock;
-	char *cont;
-
-	all_clocks  = tracefs_instance_file_read(instance, "trace_clock", &bytes);
-	if (!all_clocks || !bytes)
-		goto out;
-
-	clock = strstr(all_clocks, "[");
-	if (!clock)
-		goto out;
-	clock++;
-	cont = strstr(clock, "]");
-	if (!cont)
-		goto out;
-	*cont = '\0';
-
-	ret = strdup(clock);
-out:
-	free(all_clocks);
-	return ret;
-}
diff --git a/lib/tracefs/tracefs-utils.c b/lib/tracefs/tracefs-utils.c
deleted file mode 100644
index acfcacf7ca10..000000000000
--- a/lib/tracefs/tracefs-utils.c
+++ /dev/null
@@ -1,230 +0,0 @@
-// SPDX-License-Identifier: LGPL-2.1
-/*
- * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
- *
- * Updates:
- * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
- *
- */
-#include <stdlib.h>
-#include <sys/mount.h>
-#include <sys/stat.h>
-#include <linux/limits.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <unistd.h>
-
-#include "tracefs.h"
-#include "tracefs-local.h"
-
-#define TRACEFS_PATH "/sys/kernel/tracing"
-#define DEBUGFS_PATH "/sys/kernel/debug"
-
-#define _STR(x) #x
-#define STR(x) _STR(x)
-
-void __attribute__((weak)) warning(const char *fmt, ...)
-{
-}
-
-static int mount_tracefs(void)
-{
-	struct stat st;
-	int ret;
-
-	/* make sure debugfs exists */
-	ret = stat(TRACEFS_PATH, &st);
-	if (ret < 0)
-		return -1;
-
-	ret = mount("nodev", TRACEFS_PATH,
-		    "tracefs", 0, NULL);
-
-	return ret;
-}
-
-static int mount_debugfs(void)
-{
-	struct stat st;
-	int ret;
-
-	/* make sure debugfs exists */
-	ret = stat(DEBUGFS_PATH, &st);
-	if (ret < 0)
-		return -1;
-
-	ret = mount("nodev", DEBUGFS_PATH,
-		    "debugfs", 0, NULL);
-
-	return ret;
-}
-
-/**
- * trace_find_tracing_dir - Find tracing directory
- *
- * Returns string containing the full path to the system's tracing directory.
- * The string must be freed by free()
- */
-char *trace_find_tracing_dir(void)
-{
-	char *debug_str = NULL;
-	char fspath[PATH_MAX+1];
-	char *tracing_dir;
-	char type[100];
-	int use_debug = 0;
-	FILE *fp;
-
-	fp = fopen("/proc/mounts", "r");
-	if (!fp) {
-		warning("Can't open /proc/mounts for read");
-		return NULL;
-	}
-
-	while (fscanf(fp, "%*s %"
-		      STR(PATH_MAX)
-		      "s %99s %*s %*d %*d\n",
-		      fspath, type) == 2) {
-		if (strcmp(type, "tracefs") == 0)
-			break;
-		if (!debug_str && strcmp(type, "debugfs") == 0) {
-			debug_str = strdup(fspath);
-			if (!debug_str) {
-				fclose(fp);
-				return NULL;
-			}
-		}
-	}
-	fclose(fp);
-
-	if (strcmp(type, "tracefs") != 0) {
-		if (mount_tracefs() < 0) {
-			if (debug_str) {
-				strncpy(fspath, debug_str, PATH_MAX);
-				fspath[PATH_MAX] = 0;
-			} else {
-				if (mount_debugfs() < 0) {
-					warning("debugfs not mounted, please mount");
-					free(debug_str);
-					return NULL;
-				}
-				strcpy(fspath, DEBUGFS_PATH);
-			}
-			use_debug = 1;
-		} else
-			strcpy(fspath, TRACEFS_PATH);
-	}
-	free(debug_str);
-
-	if (use_debug) {
-		int ret;
-
-		ret = asprintf(&tracing_dir, "%s/tracing", fspath);
-		if (ret < 0)
-			return NULL;
-	} else {
-		tracing_dir = strdup(fspath);
-		if (!tracing_dir)
-			return NULL;
-	}
-
-	return tracing_dir;
-}
-
-/**
- * tracefs_tracing_dir - Get tracing directory
- *
- * Returns string containing the full path to the system's tracing directory.
- * The returned string must *not* be freed.
- */
-const char *tracefs_tracing_dir(void)
-{
-	static const char *tracing_dir;
-
-	if (tracing_dir)
-		return tracing_dir;
-
-	tracing_dir = trace_find_tracing_dir();
-	return tracing_dir;
-}
-
-/**
- * tracefs_get_tracing_file - Get tracing file
- * @name: tracing file name
- *
- * Returns string containing the full path to a tracing file in
- * the system's tracing directory.
- *
- * Must use tracefs_put_tracing_file() to free the returned string.
- */
-char *tracefs_get_tracing_file(const char *name)
-{
-	static const char *tracing;
-	char *file;
-	int ret;
-
-	if (!name)
-		return NULL;
-
-	if (!tracing) {
-		tracing = trace_find_tracing_dir();
-		if (!tracing)
-			return NULL;
-	}
-
-	ret = asprintf(&file, "%s/%s", tracing, name);
-	if (ret < 0)
-		return NULL;
-
-	return file;
-}
-
-/**
- * tracefs_put_tracing_file - Free tracing file or directory name
- *
- * Frees tracing file or directory, returned by
- * tracefs_get_tracing_file() API
- */
-void tracefs_put_tracing_file(char *name)
-{
-	free(name);
-}
-
-__hidden int str_read_file(const char *file, char **buffer)
-{
-	char stbuf[BUFSIZ];
-	char *buf = NULL;
-	int size = 0;
-	char *nbuf;
-	int fd;
-	int r;
-
-	fd = open(file, O_RDONLY);
-	if (fd < 0) {
-		warning("File %s not found", file);
-		return -1;
-	}
-
-	do {
-		r = read(fd, stbuf, BUFSIZ);
-		if (r <= 0)
-			continue;
-		nbuf = realloc(buf, size+r+1);
-		if (!nbuf) {
-			warning("Failed to allocate file buffer");
-			size = -1;
-			break;
-		}
-		buf = nbuf;
-		memcpy(buf+size, stbuf, r);
-		size += r;
-	} while (r > 0);
-
-	close(fd);
-	if (r == 0 && size > 0) {
-		buf[size] = '\0';
-		*buffer = buf;
-	} else
-		free(buf);
-
-	return size;
-}
-- 
2.30.1


