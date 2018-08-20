Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51203 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbeHTRvM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 13:51:12 -0400
Received: by mail-wm0-f68.google.com with SMTP id y2-v6so14544700wma.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Aug 2018 07:35:15 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 03/24] trace-cmd: Rename pevent plugin related APIs
Date: Mon, 20 Aug 2018 17:34:44 +0300
Message-Id: <20180820143505.11525-4-tz.stoyanov@gmail.com>
In-Reply-To: <20180820143505.11525-1-tz.stoyanov@gmail.com>
References: <20180820143505.11525-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
the pevent plugin related API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h    | 10 +++---
 include/traceevent/event-parse.h | 56 ++++++++++++++---------------
 lib/trace-cmd/trace-ftrace.c     |  6 ++--
 lib/trace-cmd/trace-util.c       | 62 ++++++++++++++++----------------
 lib/traceevent/event-parse.c     |  8 ++---
 lib/traceevent/event-plugin.c    | 24 ++++++-------
 plugins/plugin_cfg80211.c        |  4 +--
 plugins/plugin_function.c        | 12 +++----
 plugins/plugin_hrtimer.c         |  4 +--
 plugins/plugin_jbd2.c            |  4 +--
 plugins/plugin_kmem.c            |  4 +--
 plugins/plugin_kvm.c             |  4 +--
 plugins/plugin_mac80211.c        |  2 +-
 plugins/plugin_sched_switch.c    |  4 +--
 plugins/plugin_scsi.c            |  4 +--
 plugins/plugin_xen.c             |  4 +--
 16 files changed, 106 insertions(+), 106 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index ade21b1..1f5ef81 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -330,10 +330,10 @@ bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
 void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
 
 /* --- Plugin handling --- */
-extern struct pevent_plugin_option trace_ftrace_options[];
+extern struct tep_plugin_option trace_ftrace_options[];
 
-int trace_util_add_options(const char *name, struct pevent_plugin_option *options);
-void trace_util_remove_options(struct pevent_plugin_option *options);
+int trace_util_add_options(const char *name, struct tep_plugin_option *options);
+void trace_util_remove_options(struct tep_plugin_option *options);
 int trace_util_add_option(const char *name, const char *val);
 int trace_util_load_plugins(struct tep_handle *pevent, const char *suffix,
 			    int (*load_plugin)(struct tep_handle *pevent,
@@ -341,8 +341,8 @@ int trace_util_load_plugins(struct tep_handle *pevent, const char *suffix,
 					       const char *name,
 					       void *data),
 			    void *data);
-struct pevent_plugin_option *trace_util_read_plugin_options(void);
-void trace_util_free_options(struct pevent_plugin_option *options);
+struct tep_plugin_option *trace_util_read_plugin_options(void);
+void trace_util_free_options(struct tep_plugin_option *options);
 char **trace_util_find_plugin_files(const char *suffix);
 void trace_util_free_plugin_files(char **files);
 void trace_util_print_plugins(struct trace_seq *s, const char *prefix, const char *suffix,
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 3b99120..ada1efa 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -87,16 +87,16 @@ extern int trace_seq_do_printf(struct trace_seq *s);
 struct tep_handle;
 struct event_format;
 
-typedef int (*pevent_event_handler_func)(struct trace_seq *s,
-					 struct tep_record *record,
-					 struct event_format *event,
-					 void *context);
+typedef int (*tep_event_handler_func)(struct trace_seq *s,
+				      struct tep_record *record,
+				      struct event_format *event,
+				      void *context);
 
-typedef int (*pevent_plugin_load_func)(struct tep_handle *pevent);
-typedef int (*pevent_plugin_unload_func)(struct tep_handle *pevent);
+typedef int (*tep_plugin_load_func)(struct tep_handle *pevent);
+typedef int (*tep_plugin_unload_func)(struct tep_handle *pevent);
 
-struct pevent_plugin_option {
-	struct pevent_plugin_option	*next;
+struct tep_plugin_option {
+	struct tep_plugin_option	*next;
 	void				*handle;
 	char				*file;
 	char				*name;
@@ -110,20 +110,20 @@ struct pevent_plugin_option {
 /*
  * Plugin hooks that can be called:
  *
- * PEVENT_PLUGIN_LOADER:  (required)
+ * TEP_PLUGIN_LOADER:  (required)
  *   The function name to initialized the plugin.
  *
- *   int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
+ *   int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
  *
- * PEVENT_PLUGIN_UNLOADER:  (optional)
+ * TEP_PLUGIN_UNLOADER:  (optional)
  *   The function called just before unloading
  *
- *   int PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
+ *   int TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
  *
- * PEVENT_PLUGIN_OPTIONS:  (optional)
+ * TEP_PLUGIN_OPTIONS:  (optional)
  *   Plugin options that can be set before loading
  *
- *   struct pevent_plugin_option PEVENT_PLUGIN_OPTIONS[] = {
+ *   struct tep_plugin_option TEP_PLUGIN_OPTIONS[] = {
  *	{
  *		.name = "option-name",
  *		.plugin_alias = "override-file-name", (optional)
@@ -144,19 +144,19 @@ struct pevent_plugin_option {
  *   .set will be processed. If .value is defined, then it is considered
  *   a string option and .set will be ignored.
  *
- * PEVENT_PLUGIN_ALIAS: (optional)
+ * TEP_PLUGIN_ALIAS: (optional)
  *   The name to use for finding options (uses filename if not defined)
  */
-#define PEVENT_PLUGIN_LOADER pevent_plugin_loader
-#define PEVENT_PLUGIN_UNLOADER pevent_plugin_unloader
-#define PEVENT_PLUGIN_OPTIONS pevent_plugin_options
-#define PEVENT_PLUGIN_ALIAS pevent_plugin_alias
+#define TEP_PLUGIN_LOADER tep_plugin_loader
+#define TEP_PLUGIN_UNLOADER tep_plugin_unloader
+#define TEP_PLUGIN_OPTIONS tep_plugin_options
+#define TEP_PLUGIN_ALIAS tep_plugin_alias
 #define _MAKE_STR(x)	#x
 #define MAKE_STR(x)	_MAKE_STR(x)
-#define PEVENT_PLUGIN_LOADER_NAME MAKE_STR(PEVENT_PLUGIN_LOADER)
-#define PEVENT_PLUGIN_UNLOADER_NAME MAKE_STR(PEVENT_PLUGIN_UNLOADER)
-#define PEVENT_PLUGIN_OPTIONS_NAME MAKE_STR(PEVENT_PLUGIN_OPTIONS)
-#define PEVENT_PLUGIN_ALIAS_NAME MAKE_STR(PEVENT_PLUGIN_ALIAS)
+#define TEP_PLUGIN_LOADER_NAME MAKE_STR(TEP_PLUGIN_LOADER)
+#define TEP_PLUGIN_UNLOADER_NAME MAKE_STR(TEP_PLUGIN_UNLOADER)
+#define TEP_PLUGIN_OPTIONS_NAME MAKE_STR(TEP_PLUGIN_OPTIONS)
+#define TEP_PLUGIN_ALIAS_NAME MAKE_STR(TEP_PLUGIN_ALIAS)
 
 enum format_flags {
 	FIELD_IS_ARRAY		= 1,
@@ -313,7 +313,7 @@ struct event_format {
 	struct format		format;
 	struct print_fmt	print_fmt;
 	char			*system;
-	pevent_event_handler_func handler;
+	tep_event_handler_func	handler;
 	void			*context;
 };
 
@@ -427,8 +427,8 @@ void traceevent_unload_plugins(struct plugin_list *plugin_list,
 char **traceevent_plugin_list_options(void);
 void traceevent_plugin_free_options_list(char **list);
 int traceevent_plugin_add_options(const char *name,
-				  struct pevent_plugin_option *options);
-void traceevent_plugin_remove_options(struct pevent_plugin_option *options);
+				  struct tep_plugin_option *options);
+void traceevent_plugin_remove_options(struct tep_plugin_option *options);
 void traceevent_print_plugins(struct trace_seq *s,
 			      const char *prefix, const char *suffix,
 			      const struct plugin_list *list);
@@ -663,10 +663,10 @@ int pevent_print_func_field(struct trace_seq *s, const char *fmt,
 
 int pevent_register_event_handler(struct tep_handle *pevent, int id,
 				  const char *sys_name, const char *event_name,
-				  pevent_event_handler_func func, void *context);
+				  tep_event_handler_func func, void *context);
 int pevent_unregister_event_handler(struct tep_handle *pevent, int id,
 				    const char *sys_name, const char *event_name,
-				    pevent_event_handler_func func, void *context);
+				    tep_event_handler_func func, void *context);
 int pevent_register_print_function(struct tep_handle *pevent,
 				   pevent_func_handler func,
 				   enum pevent_func_arg_type ret_type,
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 3b87071..8c706f3 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -10,7 +10,7 @@
 
 #include "trace-cmd.h"
 
-struct pevent_plugin_option trace_ftrace_options[] = {
+struct tep_plugin_option trace_ftrace_options[] = {
 	{
 		.name = "tailprint",
 		.plugin_alias = "fgraph",
@@ -28,8 +28,8 @@ struct pevent_plugin_option trace_ftrace_options[] = {
 	}
 };
 
-static struct pevent_plugin_option *fgraph_tail = &trace_ftrace_options[0];
-static struct pevent_plugin_option *fgraph_depth = &trace_ftrace_options[1];
+static struct tep_plugin_option *fgraph_tail = &trace_ftrace_options[0];
+static struct tep_plugin_option *fgraph_depth = &trace_ftrace_options[1];
 
 static void find_long_size(struct tracecmd_ftrace *finfo)
 {
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index ed1c008..4a66457 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -30,7 +30,7 @@ int tracecmd_disable_plugins;
 
 static struct registered_plugin_options {
 	struct registered_plugin_options	*next;
-	struct pevent_plugin_option			*options;
+	struct tep_plugin_option			*options;
 } *registered_options;
 
 static struct trace_plugin_options {
@@ -63,7 +63,7 @@ struct plugin_list {
 char **trace_util_list_plugin_options(void)
 {
 	struct registered_plugin_options *reg;
-	struct pevent_plugin_option *op;
+	struct tep_plugin_option *op;
 	char **list = NULL;
 	char *name;
 	int count = 0;
@@ -101,7 +101,7 @@ void trace_util_free_plugin_options_list(char **list)
 }
 
 static int process_option(const char *plugin, const char *option, const char *val);
-static int update_option(const char *file, struct pevent_plugin_option *option);
+static int update_option(const char *file, struct tep_plugin_option *option);
 
 /**
  * trace_util_add_options - Add a set of options by a plugin
@@ -110,7 +110,7 @@ static int update_option(const char *file, struct pevent_plugin_option *option);
  *
  * Sets the options with the values that have been added by user.
  */
-int trace_util_add_options(const char *name, struct pevent_plugin_option *options)
+int trace_util_add_options(const char *name, struct tep_plugin_option *options)
 {
 	struct registered_plugin_options *reg;
 	int ret;
@@ -135,7 +135,7 @@ int trace_util_add_options(const char *name, struct pevent_plugin_option *option
  * trace_util_remove_options - remove plugin options that were registered
  * @options: Options to removed that were registered with trace_util_add_options
  */
-void trace_util_remove_options(struct pevent_plugin_option *options)
+void trace_util_remove_options(struct tep_plugin_option *options)
 {
 	struct registered_plugin_options **last;
 	struct registered_plugin_options *reg;
@@ -187,11 +187,11 @@ static void parse_option_name(char **option, char **plugin)
 	}
 }
 
-static struct pevent_plugin_option *
+static struct tep_plugin_option *
 find_registered_option(const char *plugin, const char *option)
 {
 	struct registered_plugin_options *reg;
-	struct pevent_plugin_option *op;
+	struct tep_plugin_option *op;
 	const char *op_plugin;
 
 	for (reg = registered_options; reg; reg = reg->next) {
@@ -213,10 +213,10 @@ find_registered_option(const char *plugin, const char *option)
 	return NULL;
 }
 
-static struct pevent_plugin_option *
+static struct tep_plugin_option *
 find_registered_option_parse(const char *name)
 {
-	struct pevent_plugin_option *option;
+	struct tep_plugin_option *option;
 	char *option_str;
 	char *plugin;
 
@@ -243,7 +243,7 @@ find_registered_option_parse(const char *name)
  */
 const char *trace_util_plugin_option_value(const char *name)
 {
-	struct pevent_plugin_option *option;
+	struct tep_plugin_option *option;
 
 	option = find_registered_option_parse(name);
 	if (!option)
@@ -345,7 +345,7 @@ static void print_op_data(struct trace_seq *s, const char *name,
 void trace_util_print_plugin_options(struct trace_seq *s)
 {
 	struct registered_plugin_options *reg;
-	struct pevent_plugin_option *op;
+	struct tep_plugin_option *op;
 
 	for (reg = registered_options; reg; reg = reg->next) {
 		if (reg != registered_options)
@@ -486,7 +486,7 @@ static void lower_case(char *str)
 		*str = tolower(*str);
 }
 
-static int update_option_value(struct pevent_plugin_option *op, const char *val)
+static int update_option_value(struct tep_plugin_option *op, const char *val)
 {
 	char *op_val;
 	int ret = 1;
@@ -530,7 +530,7 @@ static int update_option_value(struct pevent_plugin_option *op, const char *val)
 
 static int process_option(const char *plugin, const char *option, const char *val)
 {
-	struct pevent_plugin_option *op;
+	struct tep_plugin_option *op;
 
 	op = find_registered_option(plugin, option);
 	if (!op)
@@ -539,7 +539,7 @@ static int process_option(const char *plugin, const char *option, const char *va
 	return update_option_value(op, val);
 }
 
-static int update_option(const char *file, struct pevent_plugin_option *option)
+static int update_option(const char *file, struct tep_plugin_option *option)
 {
 	struct trace_plugin_options *op;
 	char *plugin;
@@ -593,9 +593,9 @@ static int load_plugin(struct tep_handle *pevent, const char *path,
 		       const char *file, void *data)
 {
 	struct plugin_list **plugin_list = data;
-	pevent_plugin_load_func func;
+	tep_plugin_load_func func;
 	struct plugin_list *list;
-	struct pevent_plugin_option *options;
+	struct tep_plugin_option *options;
 	const char *alias;
 	char *plugin;
 	void *handle;
@@ -612,11 +612,11 @@ static int load_plugin(struct tep_handle *pevent, const char *path,
 		goto out_free;
 	}
 
-	alias = dlsym(handle, PEVENT_PLUGIN_ALIAS_NAME);
+	alias = dlsym(handle, TEP_PLUGIN_ALIAS_NAME);
 	if (!alias)
 		alias = file;
 
-	options = dlsym(handle, PEVENT_PLUGIN_OPTIONS_NAME);
+	options = dlsym(handle, TEP_PLUGIN_OPTIONS_NAME);
 	if (options) {
 		while (options->name) {
 			ret = update_option(alias, options);
@@ -626,10 +626,10 @@ static int load_plugin(struct tep_handle *pevent, const char *path,
 		}
 	}
 
-	func = dlsym(handle, PEVENT_PLUGIN_LOADER_NAME);
+	func = dlsym(handle, TEP_PLUGIN_LOADER_NAME);
 	if (!func) {
 		warning("cound not find func '%s' in plugin '%s'\n%s\n",
-			PEVENT_PLUGIN_LOADER_NAME, plugin, dlerror());
+			TEP_PLUGIN_LOADER_NAME, plugin, dlerror());
 		goto out_free;
 	}
 
@@ -1453,14 +1453,14 @@ void trace_util_free_plugin_files(char **files)
 }
 
 struct plugin_option_read {
-	struct pevent_plugin_option	*options;
+	struct tep_plugin_option	*options;
 };
 
 static int append_option(struct plugin_option_read *options,
-			 struct pevent_plugin_option *option,
+			 struct tep_plugin_option *option,
 			 const char *alias, void *handle)
 {
-	struct pevent_plugin_option *op;
+	struct tep_plugin_option *op;
 
 	while (option->name) {
 		op = malloc(sizeof(*op));
@@ -1480,7 +1480,7 @@ static int read_options(struct tep_handle *pevent, const char *path,
 			 const char *file, void *data)
 {
 	struct plugin_option_read *options = data;
-	struct pevent_plugin_option *option;
+	struct tep_plugin_option *option;
 	const char *alias;
 	int unload = 0;
 	char *plugin;
@@ -1498,11 +1498,11 @@ static int read_options(struct tep_handle *pevent, const char *path,
 		goto out_free;
 	}
 
-	alias = dlsym(handle, PEVENT_PLUGIN_ALIAS_NAME);
+	alias = dlsym(handle, TEP_PLUGIN_ALIAS_NAME);
 	if (!alias)
 		alias = file;
 
-	option = dlsym(handle, PEVENT_PLUGIN_OPTIONS_NAME);
+	option = dlsym(handle, TEP_PLUGIN_OPTIONS_NAME);
 	if (!option) {
 		unload = 1;
 		goto out_unload;
@@ -1518,7 +1518,7 @@ static int read_options(struct tep_handle *pevent, const char *path,
 	return 0;
 }
 
-struct pevent_plugin_option *trace_util_read_plugin_options(void)
+struct tep_plugin_option *trace_util_read_plugin_options(void)
 {
 	struct plugin_option_read option = {
 		.options = NULL,
@@ -1531,9 +1531,9 @@ struct pevent_plugin_option *trace_util_read_plugin_options(void)
 	return option.options;
 }
 
-void trace_util_free_options(struct pevent_plugin_option *options)
+void trace_util_free_options(struct tep_plugin_option *options)
 {
-	struct pevent_plugin_option *op;
+	struct tep_plugin_option *op;
 	void *last_handle = NULL;
 
 	while (options) {
@@ -1560,13 +1560,13 @@ struct plugin_list *tracecmd_load_plugins(struct tep_handle *pevent)
 void
 tracecmd_unload_plugins(struct plugin_list *plugin_list, struct tep_handle *pevent)
 {
-	pevent_plugin_unload_func func;
+	tep_plugin_unload_func func;
 	struct plugin_list *list;
 
 	while (plugin_list) {
 		list = plugin_list;
 		plugin_list = list->next;
-		func = dlsym(list->handle, PEVENT_PLUGIN_UNLOADER_NAME);
+		func = dlsym(list->handle, TEP_PLUGIN_UNLOADER_NAME);
 		if (func)
 			func(pevent);
 		dlclose(list->handle);
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 9088b99..f00a02b 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -74,7 +74,7 @@ struct event_handler {
 	int				id;
 	const char			*sys_name;
 	const char			*event_name;
-	pevent_event_handler_func	func;
+	tep_event_handler_func		func;
 	void				*context;
 };
 
@@ -6619,7 +6619,7 @@ static struct event_format *pevent_search_event(struct tep_handle *pevent, int i
  */
 int pevent_register_event_handler(struct tep_handle *pevent, int id,
 				  const char *sys_name, const char *event_name,
-				  pevent_event_handler_func func, void *context)
+				  tep_event_handler_func func, void *context)
 {
 	struct event_format *event;
 	struct event_handler *handle;
@@ -6668,7 +6668,7 @@ int pevent_register_event_handler(struct tep_handle *pevent, int id,
 
 static int handle_matches(struct event_handler *handler, int id,
 			  const char *sys_name, const char *event_name,
-			  pevent_event_handler_func func, void *context)
+			  tep_event_handler_func func, void *context)
 {
 	if (id >= 0 && id != handler->id)
 		return 0;
@@ -6703,7 +6703,7 @@ static int handle_matches(struct event_handler *handler, int id,
  */
 int pevent_unregister_event_handler(struct tep_handle *pevent, int id,
 				    const char *sys_name, const char *event_name,
-				    pevent_event_handler_func func, void *context)
+				    tep_event_handler_func func, void *context)
 {
 	struct event_format *event;
 	struct event_handler *handle;
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index b2ef017..ccda700 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -20,7 +20,7 @@
 
 static struct registered_plugin_options {
 	struct registered_plugin_options	*next;
-	struct pevent_plugin_option		*options;
+	struct tep_plugin_option		*options;
 } *registered_options;
 
 static struct trace_plugin_options {
@@ -44,7 +44,7 @@ static void lower_case(char *str)
 		*str = tolower(*str);
 }
 
-static int update_option_value(struct pevent_plugin_option *op, const char *val)
+static int update_option_value(struct tep_plugin_option *op, const char *val)
 {
 	char *op_val;
 
@@ -97,7 +97,7 @@ static int update_option_value(struct pevent_plugin_option *op, const char *val)
 char **traceevent_plugin_list_options(void)
 {
 	struct registered_plugin_options *reg;
-	struct pevent_plugin_option *op;
+	struct tep_plugin_option *op;
 	char **list = NULL;
 	char *name;
 	int count = 0;
@@ -149,7 +149,7 @@ void traceevent_plugin_free_options_list(char **list)
 }
 
 static int
-update_option(const char *file, struct pevent_plugin_option *option)
+update_option(const char *file, struct tep_plugin_option *option)
 {
 	struct trace_plugin_options *op;
 	char *plugin;
@@ -208,7 +208,7 @@ update_option(const char *file, struct pevent_plugin_option *option)
  * Sets the options with the values that have been added by user.
  */
 int traceevent_plugin_add_options(const char *name,
-				  struct pevent_plugin_option *options)
+				  struct tep_plugin_option *options)
 {
 	struct registered_plugin_options *reg;
 
@@ -230,7 +230,7 @@ int traceevent_plugin_add_options(const char *name,
  * traceevent_plugin_remove_options - remove plugin options that were registered
  * @options: Options to removed that were registered with traceevent_plugin_add_options
  */
-void traceevent_plugin_remove_options(struct pevent_plugin_option *options)
+void traceevent_plugin_remove_options(struct tep_plugin_option *options)
 {
 	struct registered_plugin_options **last;
 	struct registered_plugin_options *reg;
@@ -271,7 +271,7 @@ load_plugin(struct tep_handle *pevent, const char *path,
 	    const char *file, void *data)
 {
 	struct plugin_list **plugin_list = data;
-	pevent_plugin_load_func func;
+	tep_plugin_load_func func;
 	struct plugin_list *list;
 	const char *alias;
 	char *plugin;
@@ -291,14 +291,14 @@ load_plugin(struct tep_handle *pevent, const char *path,
 		goto out_free;
 	}
 
-	alias = dlsym(handle, PEVENT_PLUGIN_ALIAS_NAME);
+	alias = dlsym(handle, TEP_PLUGIN_ALIAS_NAME);
 	if (!alias)
 		alias = file;
 
-	func = dlsym(handle, PEVENT_PLUGIN_LOADER_NAME);
+	func = dlsym(handle, TEP_PLUGIN_LOADER_NAME);
 	if (!func) {
 		warning("could not find func '%s' in plugin '%s'\n%s\n",
-			PEVENT_PLUGIN_LOADER_NAME, plugin, dlerror());
+			TEP_PLUGIN_LOADER_NAME, plugin, dlerror());
 		goto out_free;
 	}
 
@@ -428,13 +428,13 @@ traceevent_load_plugins(struct tep_handle *pevent)
 void
 traceevent_unload_plugins(struct plugin_list *plugin_list, struct tep_handle *pevent)
 {
-	pevent_plugin_unload_func func;
+	tep_plugin_unload_func func;
 	struct plugin_list *list;
 
 	while (plugin_list) {
 		list = plugin_list;
 		plugin_list = list->next;
-		func = dlsym(list->handle, PEVENT_PLUGIN_UNLOADER_NAME);
+		func = dlsym(list->handle, TEP_PLUGIN_UNLOADER_NAME);
 		if (func)
 			func(pevent);
 		dlclose(list->handle);
diff --git a/plugins/plugin_cfg80211.c b/plugins/plugin_cfg80211.c
index 959d94f..c189bbc 100644
--- a/plugins/plugin_cfg80211.c
+++ b/plugins/plugin_cfg80211.c
@@ -25,7 +25,7 @@ process___le16_to_cpup(struct trace_seq *s, unsigned long long *args)
 	return val ? (long long) le16toh(*val) : 0;
 }
 
-int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_print_function(pevent,
 				       process___le16_to_cpup,
@@ -36,7 +36,7 @@ int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_print_function(pevent, process___le16_to_cpup,
 					 "__le16_to_cpup");
diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index 058144e..5434a5f 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -18,7 +18,7 @@ static int cpus = -1;
 
 #define STK_BLK 10
 
-struct pevent_plugin_option plugin_options[] =
+struct tep_plugin_option plugin_options[] =
 {
 	{
 		.name = "parent",
@@ -45,9 +45,9 @@ struct pevent_plugin_option plugin_options[] =
 	}
 };
 
-static struct pevent_plugin_option *ftrace_parent = &plugin_options[0];
-static struct pevent_plugin_option *ftrace_indent = &plugin_options[1];
-static struct pevent_plugin_option *ftrace_offset = &plugin_options[2];
+static struct tep_plugin_option *ftrace_parent = &plugin_options[0];
+static struct tep_plugin_option *ftrace_indent = &plugin_options[1];
+static struct tep_plugin_option *ftrace_offset = &plugin_options[2];
 
 static void add_child(struct func_stack *stack, const char *child, int pos)
 {
@@ -168,7 +168,7 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
-int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_event_handler(pevent, -1, "ftrace", "function",
 				      function_handler, NULL);
@@ -178,7 +178,7 @@ int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	int i, x;
 
diff --git a/plugins/plugin_hrtimer.c b/plugins/plugin_hrtimer.c
index 176788c..fd067e0 100644
--- a/plugins/plugin_hrtimer.c
+++ b/plugins/plugin_hrtimer.c
@@ -46,7 +46,7 @@ static int timer_start_handler(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
-int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_event_handler(pevent, -1, "timer", "hrtimer_expire_entry",
 				      timer_expire_handler, NULL);
@@ -57,7 +57,7 @@ int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_event_handler(pevent, -1,
 					"timer", "hrtimer_expire_entry",
diff --git a/plugins/plugin_jbd2.c b/plugins/plugin_jbd2.c
index a29a0af..c942229 100644
--- a/plugins/plugin_jbd2.c
+++ b/plugins/plugin_jbd2.c
@@ -34,7 +34,7 @@ process_jiffies_to_msecs(struct trace_seq *s,
 	return jiffies;
 }
 
-int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_print_function(pevent,
 				       process_jbd2_dev_to_name,
@@ -52,7 +52,7 @@ int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_print_function(pevent, process_jbd2_dev_to_name,
 					 "jbd2_dev_to_name");
diff --git a/plugins/plugin_kmem.c b/plugins/plugin_kmem.c
index c913cc7..d4478f5 100644
--- a/plugins/plugin_kmem.c
+++ b/plugins/plugin_kmem.c
@@ -33,7 +33,7 @@ static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 	return 1;
 }
 
-int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_event_handler(pevent, -1, "kmem", "kfree",
 				      call_site_handler, NULL);
@@ -56,7 +56,7 @@ int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_event_handler(pevent, -1, "kmem", "kfree",
 					call_site_handler, NULL);
diff --git a/plugins/plugin_kvm.c b/plugins/plugin_kvm.c
index f5024db..686ba6a 100644
--- a/plugins/plugin_kvm.c
+++ b/plugins/plugin_kvm.c
@@ -438,7 +438,7 @@ process_is_writable_pte(struct trace_seq *s, unsigned long long *args)
 	return pte & PT_WRITABLE_MASK;
 }
 
-int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	init_disassembler();
 
@@ -479,7 +479,7 @@ int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_exit",
 					kvm_exit_handler, NULL);
diff --git a/plugins/plugin_mac80211.c b/plugins/plugin_mac80211.c
index b98803b..a830b25 100644
--- a/plugins/plugin_mac80211.c
+++ b/plugins/plugin_mac80211.c
@@ -176,7 +176,7 @@ static int drv_config(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
-int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_event_handler(pevent, -1, "mac80211", "drv_bss_info_changed",
 				      drv_bss_info_changed, NULL);
diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index 6c6e9f5..26fa5c8 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -117,7 +117,7 @@ static int sched_switch_handler(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
-int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_event_handler(pevent, -1, "sched", "sched_switch",
 				      sched_switch_handler, NULL);
@@ -131,7 +131,7 @@ int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_event_handler(pevent, -1, "sched", "sched_switch",
 					sched_switch_handler, NULL);
diff --git a/plugins/plugin_scsi.c b/plugins/plugin_scsi.c
index e430a49..bb9aea6 100644
--- a/plugins/plugin_scsi.c
+++ b/plugins/plugin_scsi.c
@@ -413,7 +413,7 @@ unsigned long long process_scsi_trace_parse_cdb(struct trace_seq *s,
 	return 0;
 }
 
-int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_print_function(pevent,
 				       process_scsi_trace_parse_cdb,
@@ -426,7 +426,7 @@ int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_print_function(pevent, process_scsi_trace_parse_cdb,
 					 "scsi_trace_parse_cdb");
diff --git a/plugins/plugin_xen.c b/plugins/plugin_xen.c
index 11dbddd..1973dd8 100644
--- a/plugins/plugin_xen.c
+++ b/plugins/plugin_xen.c
@@ -119,7 +119,7 @@ unsigned long long process_xen_hypercall_name(struct trace_seq *s,
 	return 0;
 }
 
-int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_print_function(pevent,
 				       process_xen_hypercall_name,
@@ -130,7 +130,7 @@ int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_print_function(pevent, process_xen_hypercall_name,
 					 "xen_hypercall_name");
-- 
2.17.1
