Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:40544 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbeHTRvY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 13:51:24 -0400
Received: by mail-wm0-f44.google.com with SMTP id y9-v6so14188098wma.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Aug 2018 07:35:28 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 14/24] trace-cmd: Rename pevent_function* APIs
Date: Mon, 20 Aug 2018 17:34:55 +0300
Message-Id: <20180820143505.11525-15-tz.stoyanov@gmail.com>
In-Reply-To: <20180820143505.11525-1-tz.stoyanov@gmail.com>
References: <20180820143505.11525-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_function_handler, pevent_func_handler, pevent_func_arg_type,
PEVENT_FUNC_ARG_VOID, PEVENT_FUNC_ARG_INT, PEVENT_FUNC_ARG_LONG,
PEVENT_FUNC_ARG_STRING, PEVENT_FUNC_ARG_PTRS, PEVENT_FUNC_ARG_MAX_TYPES

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h | 30 ++++++++--------
 lib/traceevent/event-parse.c     | 62 ++++++++++++++++----------------
 plugins/plugin_cfg80211.c        |  6 ++--
 plugins/plugin_jbd2.c            | 12 +++----
 plugins/plugin_kvm.c             |  6 ++--
 plugins/plugin_scsi.c            | 10 +++---
 plugins/plugin_xen.c             |  6 ++--
 7 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 4d4637d..89f4c64 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -255,10 +255,10 @@ struct print_arg_op {
 	struct print_arg	*right;
 };
 
-struct pevent_function_handler;
+struct tep_function_handler;
 
 struct print_arg_func {
-	struct pevent_function_handler	*func;
+	struct tep_function_handler	*func;
 	struct print_arg		*args;
 };
 
@@ -347,16 +347,16 @@ enum event_type {
 	EVENT_SQUOTE,
 };
 
-typedef unsigned long long (*pevent_func_handler)(struct trace_seq *s,
-					     unsigned long long *args);
+typedef unsigned long long (*tep_func_handler)(struct trace_seq *s,
+					       unsigned long long *args);
 
-enum pevent_func_arg_type {
-	PEVENT_FUNC_ARG_VOID,
-	PEVENT_FUNC_ARG_INT,
-	PEVENT_FUNC_ARG_LONG,
-	PEVENT_FUNC_ARG_STRING,
-	PEVENT_FUNC_ARG_PTR,
-	PEVENT_FUNC_ARG_MAX_TYPES
+enum tep_func_arg_type {
+	TEP_FUNC_ARG_VOID,
+	TEP_FUNC_ARG_INT,
+	TEP_FUNC_ARG_LONG,
+	TEP_FUNC_ARG_STRING,
+	TEP_FUNC_ARG_PTR,
+	TEP_FUNC_ARG_MAX_TYPES
 };
 
 enum tep_flag {
@@ -510,7 +510,7 @@ struct tep_handle {
 	struct format_field *bprint_buf_field;
 
 	struct event_handler *handlers;
-	struct pevent_function_handler *func_handlers;
+	struct tep_function_handler *func_handlers;
 
 	int parsing_failures;
 
@@ -668,11 +668,11 @@ int pevent_unregister_event_handler(struct tep_handle *pevent, int id,
 				    const char *sys_name, const char *event_name,
 				    tep_event_handler_func func, void *context);
 int pevent_register_print_function(struct tep_handle *pevent,
-				   pevent_func_handler func,
-				   enum pevent_func_arg_type ret_type,
+				   tep_func_handler func,
+				   enum tep_func_arg_type ret_type,
 				   char *name, ...);
 int pevent_unregister_print_function(struct tep_handle *pevent,
-				     pevent_func_handler func, char *name);
+				     tep_func_handler func, char *name);
 
 struct format_field *tep_find_common_field(struct event_format *event, const char *name);
 struct format_field *tep_find_field(struct event_format *event, const char *name);
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index b717eb8..5e4f493 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -80,14 +80,14 @@ struct event_handler {
 
 struct pevent_func_params {
 	struct pevent_func_params	*next;
-	enum pevent_func_arg_type	type;
+	enum tep_func_arg_type		type;
 };
 
-struct pevent_function_handler {
-	struct pevent_function_handler	*next;
-	enum pevent_func_arg_type	ret_type;
+struct tep_function_handler {
+	struct tep_function_handler	*next;
+	enum tep_func_arg_type		ret_type;
 	char				*name;
-	pevent_func_handler		func;
+	tep_func_handler		func;
 	struct pevent_func_params	*params;
 	int				nr_args;
 };
@@ -96,7 +96,7 @@ static unsigned long long
 process_defined_func(struct trace_seq *s, void *data, int size,
 		     struct event_format *event, struct print_arg *arg);
 
-static void free_func_handle(struct pevent_function_handler *func);
+static void free_func_handle(struct tep_function_handler *func);
 
 /**
  * pevent_buffer_init - init buffer for parsing
@@ -2900,10 +2900,10 @@ process_bitmask(struct event_format *event __maybe_unused, struct print_arg *arg
 	return EVENT_ERROR;
 }
 
-static struct pevent_function_handler *
+static struct tep_function_handler *
 find_func_handler(struct tep_handle *pevent, char *func_name)
 {
-	struct pevent_function_handler *func;
+	struct tep_function_handler *func;
 
 	if (!pevent)
 		return NULL;
@@ -2918,8 +2918,8 @@ find_func_handler(struct tep_handle *pevent, char *func_name)
 
 static void remove_func_handler(struct tep_handle *pevent, char *func_name)
 {
-	struct pevent_function_handler *func;
-	struct pevent_function_handler **next;
+	struct tep_function_handler *func;
+	struct tep_function_handler **next;
 
 	next = &pevent->func_handlers;
 	while ((func = *next)) {
@@ -2933,7 +2933,7 @@ static void remove_func_handler(struct tep_handle *pevent, char *func_name)
 }
 
 static enum event_type
-process_func_handler(struct event_format *event, struct pevent_function_handler *func,
+process_func_handler(struct event_format *event, struct tep_function_handler *func,
 		     struct print_arg *arg, char **tok)
 {
 	struct print_arg **next_arg;
@@ -2994,7 +2994,7 @@ static enum event_type
 process_function(struct event_format *event, struct print_arg *arg,
 		 char *token, char **tok)
 {
-	struct pevent_function_handler *func;
+	struct tep_function_handler *func;
 
 	if (strcmp(token, "__print_flags") == 0) {
 		free_token(token);
@@ -4118,7 +4118,7 @@ static unsigned long long
 process_defined_func(struct trace_seq *s, void *data, int size,
 		     struct event_format *event, struct print_arg *arg)
 {
-	struct pevent_function_handler *func_handle = arg->func.func;
+	struct tep_function_handler *func_handle = arg->func.func;
 	struct pevent_func_params *param;
 	unsigned long long *args;
 	unsigned long long ret;
@@ -4145,12 +4145,12 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 
 	for (i = 0; i < func_handle->nr_args; i++) {
 		switch (param->type) {
-		case PEVENT_FUNC_ARG_INT:
-		case PEVENT_FUNC_ARG_LONG:
-		case PEVENT_FUNC_ARG_PTR:
+		case TEP_FUNC_ARG_INT:
+		case TEP_FUNC_ARG_LONG:
+		case TEP_FUNC_ARG_PTR:
 			args[i] = eval_num_arg(data, size, event, farg);
 			break;
-		case PEVENT_FUNC_ARG_STRING:
+		case TEP_FUNC_ARG_STRING:
 			trace_seq_init(&str);
 			print_str_arg(&str, data, size, event, "%s", -1, farg);
 			trace_seq_terminate(&str);
@@ -6447,7 +6447,7 @@ int tep_print_func_field(struct trace_seq *s, const char *fmt,
 	return -1;
 }
 
-static void free_func_handle(struct pevent_function_handler *func)
+static void free_func_handle(struct tep_function_handler *func)
 {
 	struct pevent_func_params *params;
 
@@ -6468,24 +6468,24 @@ static void free_func_handle(struct pevent_function_handler *func)
  * @func: the function to process the helper function
  * @ret_type: the return type of the helper function
  * @name: the name of the helper function
- * @parameters: A list of enum pevent_func_arg_type
+ * @parameters: A list of enum tep_func_arg_type
  *
  * Some events may have helper functions in the print format arguments.
  * This allows a plugin to dynamically create a way to process one
  * of these functions.
  *
- * The @parameters is a variable list of pevent_func_arg_type enums that
- * must end with PEVENT_FUNC_ARG_VOID.
+ * The @parameters is a variable list of tep_func_arg_type enums that
+ * must end with TEP_FUNC_ARG_VOID.
  */
 int pevent_register_print_function(struct tep_handle *pevent,
-				   pevent_func_handler func,
-				   enum pevent_func_arg_type ret_type,
+				   tep_func_handler func,
+				   enum tep_func_arg_type ret_type,
 				   char *name, ...)
 {
-	struct pevent_function_handler *func_handle;
+	struct tep_function_handler *func_handle;
 	struct pevent_func_params **next_param;
 	struct pevent_func_params *param;
-	enum pevent_func_arg_type type;
+	enum tep_func_arg_type type;
 	va_list ap;
 	int ret;
 
@@ -6518,11 +6518,11 @@ int pevent_register_print_function(struct tep_handle *pevent,
 	next_param = &(func_handle->params);
 	va_start(ap, name);
 	for (;;) {
-		type = va_arg(ap, enum pevent_func_arg_type);
-		if (type == PEVENT_FUNC_ARG_VOID)
+		type = va_arg(ap, enum tep_func_arg_type);
+		if (type == TEP_FUNC_ARG_VOID)
 			break;
 
-		if (type >= PEVENT_FUNC_ARG_MAX_TYPES) {
+		if (type >= TEP_FUNC_ARG_MAX_TYPES) {
 			do_warning("Invalid argument type %d", type);
 			ret = TEP_ERRNO__INVALID_ARG_TYPE;
 			goto out_free;
@@ -6565,9 +6565,9 @@ int pevent_register_print_function(struct tep_handle *pevent,
  * Returns 0 if the handler was removed successully, -1 otherwise.
  */
 int pevent_unregister_print_function(struct tep_handle *pevent,
-				     pevent_func_handler func, char *name)
+				     tep_func_handler func, char *name)
 {
-	struct pevent_function_handler *func_handle;
+	struct tep_function_handler *func_handle;
 
 	func_handle = find_func_handler(pevent, name);
 	if (func_handle && func_handle->func == func) {
@@ -6805,7 +6805,7 @@ void tep_free(struct tep_handle *pevent)
 	struct cmdline_list *cmdlist, *cmdnext;
 	struct func_list *funclist, *funcnext;
 	struct printk_list *printklist, *printknext;
-	struct pevent_function_handler *func_handler;
+	struct tep_function_handler *func_handler;
 	struct event_handler *handle;
 	int i;
 
diff --git a/plugins/plugin_cfg80211.c b/plugins/plugin_cfg80211.c
index c189bbc..e0421e3 100644
--- a/plugins/plugin_cfg80211.c
+++ b/plugins/plugin_cfg80211.c
@@ -29,10 +29,10 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_print_function(pevent,
 				       process___le16_to_cpup,
-				       PEVENT_FUNC_ARG_INT,
+				       TEP_FUNC_ARG_INT,
 				       "__le16_to_cpup",
-				       PEVENT_FUNC_ARG_PTR,
-				       PEVENT_FUNC_ARG_VOID);
+				       TEP_FUNC_ARG_PTR,
+				       TEP_FUNC_ARG_VOID);
 	return 0;
 }
 
diff --git a/plugins/plugin_jbd2.c b/plugins/plugin_jbd2.c
index c942229..0dd1633 100644
--- a/plugins/plugin_jbd2.c
+++ b/plugins/plugin_jbd2.c
@@ -38,17 +38,17 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_print_function(pevent,
 				       process_jbd2_dev_to_name,
-				       PEVENT_FUNC_ARG_STRING,
+				       TEP_FUNC_ARG_STRING,
 				       "jbd2_dev_to_name",
-				       PEVENT_FUNC_ARG_INT,
-				       PEVENT_FUNC_ARG_VOID);
+				       TEP_FUNC_ARG_INT,
+				       TEP_FUNC_ARG_VOID);
 
 	pevent_register_print_function(pevent,
 				       process_jiffies_to_msecs,
-				       PEVENT_FUNC_ARG_LONG,
+				       TEP_FUNC_ARG_LONG,
 				       "jiffies_to_msecs",
-				       PEVENT_FUNC_ARG_LONG,
-				       PEVENT_FUNC_ARG_VOID);
+				       TEP_FUNC_ARG_LONG,
+				       TEP_FUNC_ARG_VOID);
 	return 0;
 }
 
diff --git a/plugins/plugin_kvm.c b/plugins/plugin_kvm.c
index 0244768..a7626ac 100644
--- a/plugins/plugin_kvm.c
+++ b/plugins/plugin_kvm.c
@@ -472,10 +472,10 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 
 	pevent_register_print_function(pevent,
 				       process_is_writable_pte,
-				       PEVENT_FUNC_ARG_INT,
+				       TEP_FUNC_ARG_INT,
 				       "is_writable_pte",
-				       PEVENT_FUNC_ARG_LONG,
-				       PEVENT_FUNC_ARG_VOID);
+				       TEP_FUNC_ARG_LONG,
+				       TEP_FUNC_ARG_VOID);
 	return 0;
 }
 
diff --git a/plugins/plugin_scsi.c b/plugins/plugin_scsi.c
index bb9aea6..ce38df7 100644
--- a/plugins/plugin_scsi.c
+++ b/plugins/plugin_scsi.c
@@ -417,12 +417,12 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_print_function(pevent,
 				       process_scsi_trace_parse_cdb,
-				       PEVENT_FUNC_ARG_STRING,
+				       TEP_FUNC_ARG_STRING,
 				       "scsi_trace_parse_cdb",
-				       PEVENT_FUNC_ARG_PTR,
-				       PEVENT_FUNC_ARG_PTR,
-				       PEVENT_FUNC_ARG_INT,
-				       PEVENT_FUNC_ARG_VOID);
+				       TEP_FUNC_ARG_PTR,
+				       TEP_FUNC_ARG_PTR,
+				       TEP_FUNC_ARG_INT,
+				       TEP_FUNC_ARG_VOID);
 	return 0;
 }
 
diff --git a/plugins/plugin_xen.c b/plugins/plugin_xen.c
index 1973dd8..2ffbd91 100644
--- a/plugins/plugin_xen.c
+++ b/plugins/plugin_xen.c
@@ -123,10 +123,10 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_print_function(pevent,
 				       process_xen_hypercall_name,
-				       PEVENT_FUNC_ARG_STRING,
+				       TEP_FUNC_ARG_STRING,
 				       "xen_hypercall_name",
-				       PEVENT_FUNC_ARG_INT,
-				       PEVENT_FUNC_ARG_VOID);
+				       TEP_FUNC_ARG_INT,
+				       TEP_FUNC_ARG_VOID);
 	return 0;
 }
 
-- 
2.17.1
