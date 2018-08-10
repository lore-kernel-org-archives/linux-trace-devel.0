Return-Path: <SRS0=GMWY=KZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38162 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728415AbeHJPr4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Aug 2018 11:47:56 -0400
Received: by mail-wr1-f65.google.com with SMTP id v14-v6so8277155wro.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Aug 2018 06:18:03 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 14/14] tools/lib/traceevent: Rename struct plugin_list to struct tep_plugin_list
Date: Fri, 10 Aug 2018 16:17:32 +0300
Message-Id: <20180810131732.24677-15-tz.stoyanov@gmail.com>
In-Reply-To: <20180810131732.24677-1-tz.stoyanov@gmail.com>
References: <20180810131732.24677-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This renames struct plugin_list
to struct tep_plugin_list

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.h  |  8 ++++----
 tools/lib/traceevent/event-plugin.c | 18 +++++++++---------
 tools/perf/util/trace-event.h       |  4 ++--
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 4b0ab69f6b3a..c8d911bed12a 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -431,12 +431,12 @@ enum tep_errno {
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
@@ -445,7 +445,7 @@ int tep_plugin_add_options(const char *name,
 void tep_plugin_remove_options(struct tep_plugin_option *options);
 void tep_print_plugins(struct trace_seq *s,
 			const char *prefix, const char *suffix,
-			const struct plugin_list *list);
+			const struct tep_plugin_list *list);
 
 struct cmdline;
 struct cmdline_list;
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index 8e324ed46547..f6a9f9363c8d 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -44,8 +44,8 @@ static struct trace_plugin_options {
 	char				*value;
 } *trace_plugin_options;
 
-struct plugin_list {
-	struct plugin_list	*next;
+struct tep_plugin_list {
+	struct tep_plugin_list	*next;
 	char			*name;
 	void			*handle;
 };
@@ -272,7 +272,7 @@ void tep_plugin_remove_options(struct tep_plugin_option *options)
  */
 void tep_print_plugins(struct trace_seq *s,
 		       const char *prefix, const char *suffix,
-		       const struct plugin_list *list)
+		       const struct tep_plugin_list *list)
 {
 	while (list) {
 		trace_seq_printf(s, "%s%s%s", prefix, list->name, suffix);
@@ -284,9 +284,9 @@ static void
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
@@ -430,20 +430,20 @@ load_plugins(struct tep_handle *pevent, const char *suffix,
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
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index dfbe0db9212d..c47e0200688a 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -10,11 +10,11 @@ struct perf_sample;
 union perf_event;
 struct perf_tool;
 struct thread;
-struct plugin_list;
+struct tep_plugin_list;
 
 struct trace_event {
 	struct tep_handle	*pevent;
-	struct plugin_list	*plugin_list;
+	struct tep_plugin_list	*plugin_list;
 };
 
 int trace_event__init(struct trace_event *t);
-- 
2.17.1
