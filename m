Return-Path: <SRS0=/uS6=LK=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38810 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbeH0MDy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Aug 2018 08:03:54 -0400
Received: by mail-wm0-f66.google.com with SMTP id t25-v6so7390068wmi.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Aug 2018 01:18:18 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 15/24] tools lib traceevent, perf tools: Rename traceevent_plugin_* APIs
Date: Mon, 27 Aug 2018 11:17:50 +0300
Message-Id: <20180827081759.17297-16-tz.stoyanov@gmail.com>
In-Reply-To: <20180827081759.17297-1-tz.stoyanov@gmail.com>
References: <20180827081759.17297-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "traceevent_". This changes
APIs: traceevent_plugin_list_options, traceevent_plugin_free_options_list,
traceevent_plugin_add_options, traceevent_plugin_remove_options,
traceevent_print_plugins

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180808180702.089951638@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/traceevent/event-parse.h | 16 ++++++++--------
 lib/traceevent/event-plugin.c    | 28 ++++++++++++++--------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 89f4c64..5a630cc 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -424,14 +424,14 @@ struct plugin_list;
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
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index aeab162..f17e250 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -83,7 +83,7 @@ static int update_option_value(struct tep_plugin_option *op, const char *val)
 }
 
 /**
- * traceevent_plugin_list_options - get list of plugin options
+ * tep_plugin_list_options - get list of plugin options
  *
  * Returns an array of char strings that list the currently registered
  * plugin options in the format of <plugin>:<option>. This list can be
@@ -92,9 +92,9 @@ static int update_option_value(struct tep_plugin_option *op, const char *val)
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
@@ -132,7 +132,7 @@ char **traceevent_plugin_list_options(void)
 	return INVALID_PLUGIN_LIST_OPTION;
 }
 
-void traceevent_plugin_free_options_list(char **list)
+void tep_plugin_free_options_list(char **list)
 {
 	int i;
 
@@ -201,14 +201,14 @@ update_option(const char *file, struct tep_plugin_option *option)
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
 
@@ -227,10 +227,10 @@ int traceevent_plugin_add_options(const char *name,
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
@@ -246,7 +246,7 @@ void traceevent_plugin_remove_options(struct tep_plugin_option *options)
 }
 
 /**
- * traceevent_print_plugins - print out the list of plugins loaded
+ * tep_print_plugins - print out the list of plugins loaded
  * @s: the trace_seq descripter to write to
  * @prefix: The prefix string to add before listing the option name
  * @suffix: The suffix string ot append after the option name
@@ -256,9 +256,9 @@ void traceevent_plugin_remove_options(struct tep_plugin_option *options)
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
-- 
2.17.1
