Return-Path: <SRS0=PkBc=KX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:42044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728400AbeHHSdc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Aug 2018 14:33:32 -0400
Message-Id: <20180808161309.182490125@goodmis.org>
Date: Wed, 08 Aug 2018 11:56:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [RFC][PATCH 15/24] tools/lib/traceevent, tools/perf: Rename traceevent_plugin_* APIs
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "traceevent_". This changes
APIs: traceevent_plugin_list_options, traceevent_plugin_free_options_list,
traceevent_plugin_add_options, traceevent_plugin_remove_options,
traceevent_print_plugins

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.h     | 16 +++++++--------
 tools/lib/traceevent/event-plugin.c    | 28 +++++++++++++-------------
 tools/lib/traceevent/plugin_function.c |  4 ++--
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 81f34132fc47..ec327849a7dc 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -438,14 +438,14 @@ struct plugin_list;
 struct plugin_list *tep_load_plugins(struct tep_handle *pevent);
 void tep_unload_plugins(struct plugin_list *plugin_list,
 			struct tep_handle *pevent);
-char **traceevent_plugin_list_options(void);
-void traceevent_plugin_free_options_list(char **list);
-int traceevent_plugin_add_options(const char *name,
-				  struct tep_plugin_option *options);
-void traceevent_plugin_remove_options(struct tep_plugin_option *options);
-void traceevent_print_plugins(struct trace_seq *s,
-			      const char *prefix, const char *suffix,
-			      const struct plugin_list *list);
+char **tep_plugin_list_options(void);
+void tep_plugin_free_options_list(char **list);
+int tep_plugin_add_options(const char *name,
+			   struct tep_plugin_option *options);
+void tep_plugin_remove_options(struct tep_plugin_option *options);
+void tep_print_plugins(struct trace_seq *s,
+			const char *prefix, const char *suffix,
+			const struct plugin_list *list);
 
 struct cmdline;
 struct cmdline_list;
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index c837a73c03e6..8e324ed46547 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -97,7 +97,7 @@ static int update_option_value(struct tep_plugin_option *op, const char *val)
 }
 
 /**
- * traceevent_plugin_list_options - get list of plugin options
+ * tep_plugin_list_options - get list of plugin options
  *
  * Returns an array of char strings that list the currently registered
  * plugin options in the format of <plugin>:<option>. This list can be
@@ -106,9 +106,9 @@ static int update_option_value(struct tep_plugin_option *op, const char *val)
  * Returns NULL if there's no options registered. On error it returns
  * INVALID_PLUGIN_LIST_OPTION
  *
- * Must be freed with traceevent_plugin_free_options_list().
+ * Must be freed with tep_plugin_free_options_list().
  */
-char **traceevent_plugin_list_options(void)
+char **tep_plugin_list_options(void)
 {
 	struct registered_plugin_options *reg;
 	struct tep_plugin_option *op;
@@ -146,7 +146,7 @@ char **traceevent_plugin_list_options(void)
 	return INVALID_PLUGIN_LIST_OPTION;
 }
 
-void traceevent_plugin_free_options_list(char **list)
+void tep_plugin_free_options_list(char **list)
 {
 	int i;
 
@@ -215,14 +215,14 @@ update_option(const char *file, struct tep_plugin_option *option)
 }
 
 /**
- * traceevent_plugin_add_options - Add a set of options by a plugin
+ * tep_plugin_add_options - Add a set of options by a plugin
  * @name: The name of the plugin adding the options
  * @options: The set of options being loaded
  *
  * Sets the options with the values that have been added by user.
  */
-int traceevent_plugin_add_options(const char *name,
-				  struct tep_plugin_option *options)
+int tep_plugin_add_options(const char *name,
+			   struct tep_plugin_option *options)
 {
 	struct registered_plugin_options *reg;
 
@@ -241,10 +241,10 @@ int traceevent_plugin_add_options(const char *name,
 }
 
 /**
- * traceevent_plugin_remove_options - remove plugin options that were registered
- * @options: Options to removed that were registered with traceevent_plugin_add_options
+ * tep_plugin_remove_options - remove plugin options that were registered
+ * @options: Options to removed that were registered with tep_plugin_add_options
  */
-void traceevent_plugin_remove_options(struct tep_plugin_option *options)
+void tep_plugin_remove_options(struct tep_plugin_option *options)
 {
 	struct registered_plugin_options **last;
 	struct registered_plugin_options *reg;
@@ -260,7 +260,7 @@ void traceevent_plugin_remove_options(struct tep_plugin_option *options)
 }
 
 /**
- * traceevent_print_plugins - print out the list of plugins loaded
+ * tep_print_plugins - print out the list of plugins loaded
  * @s: the trace_seq descripter to write to
  * @prefix: The prefix string to add before listing the option name
  * @suffix: The suffix string ot append after the option name
@@ -270,9 +270,9 @@ void traceevent_plugin_remove_options(struct tep_plugin_option *options)
  * returned by tep_load_plugins(). Use @prefix and @suffix for formating:
  * @prefix = "  ", @suffix = "\n".
  */
-void traceevent_print_plugins(struct trace_seq *s,
-			      const char *prefix, const char *suffix,
-			      const struct plugin_list *list)
+void tep_print_plugins(struct trace_seq *s,
+		       const char *prefix, const char *suffix,
+		       const struct plugin_list *list)
 {
 	while (list) {
 		trace_seq_printf(s, "%s%s%s", prefix, list->name, suffix);
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index 342be570ee8c..57165da1bd51 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -168,7 +168,7 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	pevent_register_event_handler(pevent, -1, "ftrace", "function",
 				      function_handler, NULL);
 
-	traceevent_plugin_add_options("ftrace", plugin_options);
+	tep_plugin_add_options("ftrace", plugin_options);
 
 	return 0;
 }
@@ -186,7 +186,7 @@ void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 		free(fstack[i].stack);
 	}
 
-	traceevent_plugin_remove_options(plugin_options);
+	tep_plugin_remove_options(plugin_options);
 
 	free(fstack);
 	fstack = NULL;
-- 
2.18.0
