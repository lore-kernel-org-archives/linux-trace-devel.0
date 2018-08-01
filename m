Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41973 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389216AbeHAO2W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 10:28:22 -0400
Received: by mail-wr1-f66.google.com with SMTP id j5-v6so19991713wrr.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Aug 2018 05:42:44 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 15/24] tools/lib/traceevent, tools/perf: Rename traceevent_* APIs
Date: Wed,  1 Aug 2018 15:41:47 +0300
Message-Id: <20180801124156.20894-16-tz.stoyanov@gmail.com>
In-Reply-To: <20180801124156.20894-1-tz.stoyanov@gmail.com>
References: <20180801124156.20894-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: traceevent_plugin_list_options, traceevent_plugin_free_options_list,
traceevent_plugin_add_options, traceevent_plugin_remove_options,
traceevent_print_plugins

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.h     | 10 +++++-----
 tools/lib/traceevent/event-plugin.c    | 22 +++++++++++-----------
 tools/lib/traceevent/plugin_function.c |  4 ++--
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 3a4cd6824ff7..ad45c564e00b 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -438,12 +438,12 @@ struct plugin_list;
 struct plugin_list *tep_load_plugins(struct tep_handle *pevent);
 void tep_unload_plugins(struct plugin_list *plugin_list,
 			       struct tep_handle *pevent);
-char **traceevent_plugin_list_options(void);
-void traceevent_plugin_free_options_list(char **list);
-int traceevent_plugin_add_options(const char *name,
+char **tep_plugin_list_options(void);
+void tep_plugin_free_options_list(char **list);
+int tep_plugin_add_options(const char *name,
 				  struct tep_plugin_option *options);
-void traceevent_plugin_remove_options(struct tep_plugin_option *options);
-void traceevent_print_plugins(struct trace_seq *s,
+void tep_plugin_remove_options(struct tep_plugin_option *options);
+void tep_print_plugins(struct trace_seq *s,
 			      const char *prefix, const char *suffix,
 			      const struct plugin_list *list);
 
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index c837a73c03e6..acca45890cb0 100644
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
 
@@ -215,13 +215,13 @@ update_option(const char *file, struct tep_plugin_option *option)
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
+int tep_plugin_add_options(const char *name,
 				  struct tep_plugin_option *options)
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
@@ -270,7 +270,7 @@ void traceevent_plugin_remove_options(struct tep_plugin_option *options)
  * returned by tep_load_plugins(). Use @prefix and @suffix for formating:
  * @prefix = "  ", @suffix = "\n".
  */
-void traceevent_print_plugins(struct trace_seq *s,
+void tep_print_plugins(struct trace_seq *s,
 			      const char *prefix, const char *suffix,
 			      const struct plugin_list *list)
 {
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
2.17.1
