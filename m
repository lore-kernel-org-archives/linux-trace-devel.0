Return-Path: <SRS0=cF1r=MB=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731926AbeITAgl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Sep 2018 20:36:41 -0400
Message-Id: <20180919185724.586889128@goodmis.org>
Date: Wed, 19 Sep 2018 14:56:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH 13/15] tools/lib/traceevent: Rename struct plugin_list to struct
 tep_plugin_list
References: <20180919185643.358126338@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This renames struct plugin_list
to struct tep_plugin_list

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.h  |  8 ++++----
 tools/lib/traceevent/event-plugin.c | 18 +++++++++---------
 tools/perf/util/trace-event.h       |  4 ++--
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 1abf15882460..2a7b0a857f39 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -389,12 +389,12 @@ enum tep_errno {
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
@@ -403,7 +403,7 @@ int tep_plugin_add_options(const char *name,
 void tep_plugin_remove_options(struct tep_plugin_option *options);
 void tep_print_plugins(struct trace_seq *s,
 			const char *prefix, const char *suffix,
-			const struct plugin_list *list);
+			const struct tep_plugin_list *list);
 
 struct cmdline;
 struct cmdline_list;
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index ec16a103c0cc..46eb64eb0c2e 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
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
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 2da6eff0caaf..f024d73bfc40 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -11,11 +11,11 @@ struct perf_sample;
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
2.18.0
