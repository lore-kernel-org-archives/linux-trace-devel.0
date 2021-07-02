Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C07CC07E96
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 20:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D0D361420
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 20:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhGBUhg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 16:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230157AbhGBUhf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 16:37:35 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C94BE613D1;
        Fri,  2 Jul 2021 20:35:02 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lzPsL-000i7Y-LW; Fri, 02 Jul 2021 16:35:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtracefs: Restructure how string lists work
Date:   Fri,  2 Jul 2021 16:34:59 -0400
Message-Id: <20210702203459.169473-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702203459.169473-1-rostedt@goodmis.org>
References: <20210702203459.169473-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the size of the string list to the allocated list, and return to the
user the address of the second element. That is:

  char **list;

  list[0] = (char *)size;
  list[1] = string1;
  list[2] = string2;
  [..]
  list[n] = NULL

The size will contain the number of strings in the list.

The users of this list will not have access to the size (they should not
know about it). This is why all tracefs strings must be freed with
tracefs_list_free() as this will handle the allocations correctly.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs-local.h |  1 +
 include/tracefs.h       |  4 ++-
 src/tracefs-events.c    | 41 +++++++++++++--------------
 src/tracefs-instance.c  |  9 +-----
 src/tracefs-kprobes.c   | 17 +++--------
 src/tracefs-tools.c     |  6 +---
 src/tracefs-utils.c     | 63 +++++++++++++++++++++++++++++++++++++++++
 7 files changed, 92 insertions(+), 49 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 73698e8014bd..92ad7e6d58e9 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -65,4 +65,5 @@ supported_opts_mask(struct tracefs_instance *instance);
 struct tracefs_options_mask *
 enabled_opts_mask(struct tracefs_instance *instance);
 
+char **trace_list_create_empty(void);
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/include/tracefs.h b/include/tracefs.h
index 1c8703ae7e26..04e2aec431ee 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -63,6 +63,9 @@ char *tracefs_error_last(struct tracefs_instance *instance);
 char *tracefs_error_all(struct tracefs_instance *instance);
 int tracefs_error_clear(struct tracefs_instance *instance);
 
+void tracefs_list_free(char **list);
+char **tracefs_list_add(char **list, const char *string);
+
 /**
  * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
  * @instance: ftrace instance, can be NULL for the top instance
@@ -87,7 +90,6 @@ int tracefs_binary_write(struct tracefs_instance *instance, void *data, int len)
 void tracefs_binary_close(struct tracefs_instance *instance);
 
 /* events */
-void tracefs_list_free(char **list);
 char **tracefs_event_systems(const char *tracing_dir);
 char **tracefs_system_events(const char *tracing_dir, const char *system);
 int tracefs_iterate_raw_events(struct tep_handle *tep,
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 77f4624776e2..59044822cdf6 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -256,22 +256,19 @@ out:
 	return ret;
 }
 
-static char **add_list_string(char **list, const char *name, int len)
+static int add_list_string(char ***list, const char *name)
 {
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
+	char **tmp;
 
-	list[len + 1] = NULL;
+	tmp = tracefs_list_add(*list, name);
+	if (!tmp) {
+		tracefs_list_free(*list);
+		*list = NULL;
+		return -1;
+	}
 
-	return list;
+	*list = tmp;
+	return 0;
 }
 
 __hidden char *trace_append_file(const char *dir, const char *name)
@@ -300,7 +297,6 @@ char **tracefs_event_systems(const char *tracing_dir)
 	char *events_dir;
 	struct stat st;
 	DIR *dir;
-	int len = 0;
 	int ret;
 
 	if (!tracing_dir)
@@ -344,9 +340,10 @@ char **tracefs_event_systems(const char *tracing_dir)
 		enable = trace_append_file(sys, "enable");
 
 		ret = stat(enable, &st);
-		if (ret >= 0)
-			systems = add_list_string(systems, name, len++);
-
+		if (ret >= 0) {
+			if (add_list_string(&systems, name) < 0)
+				goto out_free;
+		}
 		free(enable);
 		free(sys);
 	}
@@ -374,7 +371,6 @@ char **tracefs_system_events(const char *tracing_dir, const char *system)
 	char *system_dir = NULL;
 	struct stat st;
 	DIR *dir;
-	int len = 0;
 	int ret;
 
 	if (!tracing_dir)
@@ -410,7 +406,8 @@ char **tracefs_system_events(const char *tracing_dir, const char *system)
 			continue;
 		}
 
-		events = add_list_string(events, name, len++);
+		if (add_list_string(&events, name) < 0)
+			goto out_free;
 
 		free(event);
 	}
@@ -428,7 +425,7 @@ char **tracefs_system_events(const char *tracing_dir, const char *system)
  * @tracing_dir: The directory that contains the tracing directory
  *
  * Returns an allocate list of plugins. The array ends with NULL
- * Both the plugin names and array must be freed with free()
+ * Both the plugin names and array must be freed with tracefs_list_free()
  */
 char **tracefs_tracers(const char *tracing_dir)
 {
@@ -460,7 +457,6 @@ char **tracefs_tracers(const char *tracing_dir)
 	if (len <= 0)
 		goto out_free;
 
-	len = 0;
 	for (str = buf; ; str = NULL) {
 		plugin = strtok_r(str, " ", &saveptr);
 		if (!plugin)
@@ -478,7 +474,8 @@ char **tracefs_tracers(const char *tracing_dir)
 		    strcmp(plugin, "none") == 0)
 			continue;
 
-		plugins = add_list_string(plugins, plugin, len++);
+		if (add_list_string(&plugins, plugin) < 0)
+			break;
 	}
 	free(buf);
 
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index ba7667349be2..11fb580456ff 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -641,7 +641,6 @@ static inline bool match(const char *str, regex_t *re)
 struct instance_list {
 	regex_t		*re;
 	char		**list;
-	int		size;
 	int		failed;
 };
 
@@ -654,17 +653,11 @@ static int build_list(const char *name, void *data)
 	if (!match(name, list->re))
 		return 0;
 
-	instances = realloc(list->list, sizeof(*instances) * (list->size + 2));
+	instances = tracefs_list_add(list->list, name);
 	if (!instances)
 		goto out;
 
 	list->list = instances;
-	instances[list->size] = strdup(name);
-	if (!instances[list->size])
-		goto out;
-
-	list->size++;
-	instances[list->size] = NULL;
 	ret = 0;
 
  out:
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 2bc589a82627..6fdd8f90a6ca 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -181,7 +181,6 @@ char **tracefs_get_kprobes(enum tracefs_kprobe_type type)
 	char *saveptr;
 	char *event;
 	char *ktype;
-	int cnt = 0;
 	int ret;
 
 	errno = 0;
@@ -190,8 +189,7 @@ char **tracefs_get_kprobes(enum tracefs_kprobe_type type)
 		if (errno)
 			return NULL;
 		/* content is NULL on empty file, return an empty list */
-		list = calloc(1, sizeof(*list));
-		return list;
+		return trace_list_create_empty();
 	}
 
 	ret = parse_kprobe(content, &saveptr, &ktype, NULL, &event, NULL, NULL);
@@ -214,28 +212,21 @@ char **tracefs_get_kprobes(enum tracefs_kprobe_type type)
 			}
 		}
 
-		event = strdup(event);
-		if (!event)
-			goto fail;
-
-		tmp = realloc(list, sizeof(*list) * (cnt + 2));
+		tmp = tracefs_list_add(list, event);
 		if (!tmp)
 			goto fail;
-
 		list = tmp;
-		list[cnt++] = event;
-		list[cnt] = NULL;
  next:
 		ret = parse_kprobe(NULL, &saveptr, &ktype, NULL, &event, NULL, NULL);
 	}
 
 	if (!list)
-		list = calloc(1, sizeof(*list));
+		list = trace_list_create_empty();
  out:
 	free(content);
 	return list;
  fail:
-	free(list);
+	tracefs_list_free(list);
 	list = NULL;
 	goto out;
 }
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 42dc68cf164b..ca0ed58ab8cd 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -1238,7 +1238,6 @@ int tracefs_filter_functions(const char *filter, const char *module, char ***lis
 	struct func_filter func_filter;
 	struct func_list *func_list, *f;
 	char **funcs = NULL;
-	int cnt = 0;
 	int ret;
 
 	if (!filter)
@@ -1256,14 +1255,11 @@ int tracefs_filter_functions(const char *filter, const char *module, char ***lis
 	for (f = func_list; f; f = f->next) {
 		char **tmp;
 
-		tmp = realloc(funcs, sizeof(*funcs) * (cnt + 2));
+		tmp = tracefs_list_add(funcs, f->func);
 		if (!tmp) {
 			tracefs_list_free(funcs);
 			goto out;
 		}
-		tmp[cnt++] = f->func;
-		tmp[cnt] = NULL;
-		f->func = NULL;
 		funcs = tmp;
 	}
 
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index b29131ecf0c5..ec5ecb08ed2e 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -382,5 +382,68 @@ void tracefs_list_free(char **list)
 	for (i = 0; list[i]; i++)
 		free(list[i]);
 
+	/* The allocated list is before the user visible portion */
+	list--;
 	free(list);
 }
+
+
+__hidden char ** trace_list_create_empty(void)
+{
+	char **list;
+
+	list = calloc(2, sizeof(*list));
+
+	return list ? &list[1] : NULL;
+}
+
+/**
+ * tracefs_list_add - create or extend a string list
+ * @list: The list to add to (NULL to create a new one)
+ * @string: The string to append to @list.
+ *
+ * If @list is NULL, a new list is created with the first element
+ * a copy of @string, and the second element is NULL.
+ *
+ * If @list is not NULL, it is then reallocated to include
+ * a new element and a NULL terminator, and will return the new
+ * allocated array on success, and the one passed in should be
+ * ignored.
+ *
+ * Returns an allocated string array that must be freed with
+ * tracefs_list_free() on success. On failure, NULL is returned
+ * and the @list is untouched.
+ */
+char **tracefs_list_add(char **list, const char *string)
+{
+	unsigned long size = 0;
+	char *str = strdup(string);
+	char **new_list;
+
+	if (!str)
+		return NULL;
+
+	/*
+	 * The returned list is really the address of the
+	 * second entry of the list (&list[1]), the first
+	 * entry contains the number of strings in the list.
+	 */
+	if (list) {
+		list--;
+		size = *(unsigned long *)list;
+	}
+
+	new_list = realloc(list, sizeof(*list) * (size + 3));
+	if (!new_list) {
+		free(str);
+		return NULL;
+	}
+
+	list = new_list;
+	list[0] = (char *)(size + 1);
+	list++;
+	list[size++] = str;
+	list[size] = NULL;
+
+	return list;
+}
-- 
2.30.2

