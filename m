Return-Path: <SRS0=XLZm=MI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730058.outbound.protection.outlook.com ([40.107.73.58]:63673
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726315AbeIZScP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Sep 2018 14:32:15 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 14/16] tools lib traceevent: Rename struct plugin_list to struct tep_plugin_list
Date: Wed, 26 Sep 2018 15:18:30 +0300
Message-Id: <20180926121832.16101-15-tstoyanov@vmware.com>
In-Reply-To: <20180926121832.16101-1-tstoyanov@vmware.com>
References: <20180926121832.16101-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This renames struct plugin_list
to struct tep_plugin_list

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180919185724.586889128@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/trace-cmd/trace-cmd.h    |  8 ++++----
 include/traceevent/event-parse.h |  8 ++++----
 lib/trace-cmd/trace-input.c      |  4 ++--
 lib/trace-cmd/trace-util.c       | 18 +++++++++---------
 lib/traceevent/event-plugin.c    | 18 +++++++++---------
 tracecmd/trace-check-events.c    |  2 +-
 tracecmd/trace-list.c            |  4 ++--
 7 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index f1c5703..684ddb7 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -25,9 +25,9 @@ void tracecmd_parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigne
 extern int tracecmd_disable_sys_plugins;
 extern int tracecmd_disable_plugins;
 
-struct plugin_list;
-struct plugin_list *tracecmd_load_plugins(struct tep_handle *pevent);
-void tracecmd_unload_plugins(struct plugin_list *list, struct tep_handle *pevent);
+struct tep_plugin_list;
+struct tep_plugin_list *tracecmd_load_plugins(struct tep_handle *pevent);
+void tracecmd_unload_plugins(struct tep_plugin_list *list, struct tep_handle *pevent);
 
 char **tracecmd_event_systems(const char *tracing_dir);
 char **tracecmd_system_events(const char *tracing_dir, const char *system);
@@ -346,7 +346,7 @@ void trace_util_free_options(struct tep_plugin_option *options);
 char **trace_util_find_plugin_files(const char *suffix);
 void trace_util_free_plugin_files(char **files);
 void trace_util_print_plugins(struct trace_seq *s, const char *prefix, const char *suffix,
-			      const struct plugin_list *list);
+			      const struct tep_plugin_list *list);
 void trace_util_print_plugin_options(struct trace_seq *s);
 char **trace_util_list_plugin_options(void);
 void trace_util_free_plugin_options_list(char **list);
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 6009e11..1e36cba 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -375,12 +375,12 @@ enum tep_errno {
 };
 #undef _PE
 
-struct plugin_list;
+struct tep_plugin_list;
 
 #define INVALID_PLUGIN_LIST_OPTION	((char **)((unsigned long)-1))
 
-struct plugin_list *tep_load_plugins(struct tep_handle *pevent);
-void tep_unload_plugins(struct plugin_list *plugin_list,
+struct tep_plugin_list *tep_load_plugins(struct tep_handle *pevent);
+void tep_unload_plugins(struct tep_plugin_list *plugin_list,
 			struct tep_handle *pevent);
 char **tep_plugin_list_options(void);
 void tep_plugin_free_options_list(char **list);
@@ -389,7 +389,7 @@ int tep_plugin_add_options(const char *name,
 void tep_plugin_remove_options(struct tep_plugin_option *options);
 void tep_print_plugins(struct trace_seq *s,
 			const char *prefix, const char *suffix,
-			const struct plugin_list *list);
+			const struct tep_plugin_list *list);
 
 struct cmdline;
 struct cmdline_list;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index af812c1..a37a1b7 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -85,8 +85,8 @@ struct input_buffer_instance {
 };
 
 struct tracecmd_input {
-	struct tep_handle		*pevent;
-	struct plugin_list	*plugin_list;
+	struct tep_handle	*pevent;
+	struct tep_plugin_list	*plugin_list;
 	struct tracecmd_input	*parent;
 	unsigned long		flags;
 	int			fd;
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 0760815..325a4a5 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -43,8 +43,8 @@ static struct trace_plugin_options {
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
-struct plugin_list {
-	struct plugin_list	*next;
+struct tep_plugin_list {
+	struct tep_plugin_list	*next;
 	char			*name;
 	void			*handle;
 };
@@ -164,7 +164,7 @@ void trace_util_remove_options(struct tep_plugin_option *options)
  */
 void trace_util_print_plugins(struct trace_seq *s,
 			      const char *prefix, const char *suffix,
-			      const struct plugin_list *list)
+			      const struct tep_plugin_list *list)
 {
 	while (list) {
 		trace_seq_printf(s, "%s%s%s", prefix, list->name, suffix);
@@ -592,9 +592,9 @@ static int update_option(const char *file, struct tep_plugin_option *option)
 static int load_plugin(struct tep_handle *pevent, const char *path,
 		       const char *file, void *data)
 {
-	struct plugin_list **plugin_list = data;
+	struct tep_plugin_list **plugin_list = data;
 	tep_plugin_load_func func;
-	struct plugin_list *list;
+	struct tep_plugin_list *list;
 	struct tep_plugin_option *options;
 	const char *alias;
 	char *plugin;
@@ -1548,9 +1548,9 @@ void trace_util_free_options(struct tep_plugin_option *options)
 	}
 }
 
-struct plugin_list *tracecmd_load_plugins(struct tep_handle *pevent)
+struct tep_plugin_list *tracecmd_load_plugins(struct tep_handle *pevent)
 {
-	struct plugin_list *list = NULL;
+	struct tep_plugin_list *list = NULL;
 
 	trace_util_load_plugins(pevent, ".so", load_plugin, &list);
 
@@ -1558,10 +1558,10 @@ struct plugin_list *tracecmd_load_plugins(struct tep_handle *pevent)
 }
 
 void
-tracecmd_unload_plugins(struct plugin_list *plugin_list, struct tep_handle *pevent)
+tracecmd_unload_plugins(struct tep_plugin_list *plugin_list, struct tep_handle *pevent)
 {
 	tep_plugin_unload_func func;
-	struct plugin_list *list;
+	struct tep_plugin_list *list;
 
 	while (plugin_list) {
 		list = plugin_list;
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index ec16a10..46eb64e 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -31,8 +31,8 @@ static struct trace_plugin_options {
 	char				*value;
 } *trace_plugin_options;
 
-struct plugin_list {
-	struct plugin_list	*next;
+struct tep_plugin_list {
+	struct tep_plugin_list	*next;
 	char			*name;
 	void			*handle;
 };
@@ -259,7 +259,7 @@ void tep_plugin_remove_options(struct tep_plugin_option *options)
  */
 void tep_print_plugins(struct trace_seq *s,
 		       const char *prefix, const char *suffix,
-		       const struct plugin_list *list)
+		       const struct tep_plugin_list *list)
 {
 	while (list) {
 		trace_seq_printf(s, "%s%s%s", prefix, list->name, suffix);
@@ -271,9 +271,9 @@ static void
 load_plugin(struct tep_handle *pevent, const char *path,
 	    const char *file, void *data)
 {
-	struct plugin_list **plugin_list = data;
+	struct tep_plugin_list **plugin_list = data;
 	tep_plugin_load_func func;
-	struct plugin_list *list;
+	struct tep_plugin_list *list;
 	const char *alias;
 	char *plugin;
 	void *handle;
@@ -417,20 +417,20 @@ load_plugins(struct tep_handle *pevent, const char *suffix,
 	free(path);
 }
 
-struct plugin_list*
+struct tep_plugin_list*
 tep_load_plugins(struct tep_handle *pevent)
 {
-	struct plugin_list *list = NULL;
+	struct tep_plugin_list *list = NULL;
 
 	load_plugins(pevent, ".so", load_plugin, &list);
 	return list;
 }
 
 void
-tep_unload_plugins(struct plugin_list *plugin_list, struct tep_handle *pevent)
+tep_unload_plugins(struct tep_plugin_list *plugin_list, struct tep_handle *pevent)
 {
 	tep_plugin_unload_func func;
-	struct plugin_list *list;
+	struct tep_plugin_list *list;
 
 	while (plugin_list) {
 		list = plugin_list;
diff --git a/tracecmd/trace-check-events.c b/tracecmd/trace-check-events.c
index 63c9918..3bd25ef 100644
--- a/tracecmd/trace-check-events.c
+++ b/tracecmd/trace-check-events.c
@@ -14,7 +14,7 @@ void trace_check_events(int argc, char **argv)
 	const char *tracing;
 	int ret, c;
 	struct tep_handle *pevent = NULL;
-	struct plugin_list *list = NULL;
+	struct tep_plugin_list *list = NULL;
 
 	while ((c = getopt(argc-1, argv+1, "+hN")) >= 0) {
 		switch (c) {
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 1eae38b..00c6073 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -308,7 +308,7 @@ static void show_buffers(void)
 static void show_plugin_options(void)
 {
 	struct tep_handle *pevent;
-	struct plugin_list *list;
+	struct tep_plugin_list *list;
 	struct trace_seq s;
 
 	tracecmd_ftrace_load_options();
@@ -336,7 +336,7 @@ void trace_option(int argc, char **argv)
 static void show_plugins(void)
 {
 	struct tep_handle *pevent;
-	struct plugin_list *list;
+	struct tep_plugin_list *list;
 	struct trace_seq s;
 
 	pevent = tep_alloc();
-- 
2.17.1
