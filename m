Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37412 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbeHTRve (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 13:51:34 -0400
Received: by mail-wm0-f68.google.com with SMTP id n11-v6so14086080wmc.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Aug 2018 07:35:40 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 24/24] trace-cmd: Rename static variables and functions in event-parse.c
Date: Mon, 20 Aug 2018 17:35:05 +0300
Message-Id: <20180820143505.11525-25-tz.stoyanov@gmail.com>
In-Reply-To: <20180820143505.11525-1-tz.stoyanov@gmail.com>
References: <20180820143505.11525-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
static variables and functions in event-parse.c: pevent_func_params,
__pevent_parse_format, __pevent_parse_event, pevent_error_str, pevent_search_event

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-parse.c | 54 ++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 51932b8..ce1e202 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -78,9 +78,9 @@ struct event_handler {
 	void				*context;
 };
 
-struct pevent_func_params {
-	struct pevent_func_params	*next;
-	enum tep_func_arg_type		type;
+struct func_params {
+	struct func_params	*next;
+	enum tep_func_arg_type	type;
 };
 
 struct tep_function_handler {
@@ -88,7 +88,7 @@ struct tep_function_handler {
 	enum tep_func_arg_type		ret_type;
 	char				*name;
 	tep_func_handler		func;
-	struct pevent_func_params	*params;
+	struct func_params		*params;
 	int				nr_args;
 };
 
@@ -1147,7 +1147,7 @@ static enum event_type read_token(char **tok)
  * @tok: The token to return
  *
  * This will parse tokens from the string given by
- * pevent_init_data().
+ * tep_init_data().
  *
  * Returns the token type.
  */
@@ -4119,7 +4119,7 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 		     struct event_format *event, struct print_arg *arg)
 {
 	struct tep_function_handler *func_handle = arg->func.func;
-	struct pevent_func_params *param;
+	struct func_params *param;
 	unsigned long long *args;
 	unsigned long long ret;
 	struct print_arg *farg;
@@ -6009,7 +6009,7 @@ static int find_event_handle(struct tep_handle *pevent, struct event_format *eve
 }
 
 /**
- * __pevent_parse_format - parse the event format
+ * __tep_parse_format - parse the event format
  * @buf: the buffer storing the event format string
  * @size: the size of @buf
  * @sys: the system the event belongs to
@@ -6021,9 +6021,9 @@ static int find_event_handle(struct tep_handle *pevent, struct event_format *eve
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum tep_errno __pevent_parse_format(struct event_format **eventp,
-				     struct tep_handle *pevent, const char *buf,
-				     unsigned long size, const char *sys)
+enum tep_errno __tep_parse_format(struct event_format **eventp,
+				  struct tep_handle *pevent, const char *buf,
+				  unsigned long size, const char *sys)
 {
 	struct event_format *event;
 	int ret;
@@ -6129,12 +6129,12 @@ enum tep_errno __pevent_parse_format(struct event_format **eventp,
 }
 
 static enum tep_errno
-__pevent_parse_event(struct tep_handle *pevent,
-		     struct event_format **eventp,
-		     const char *buf, unsigned long size,
-		     const char *sys)
+__parse_event(struct tep_handle *pevent,
+	      struct event_format **eventp,
+	      const char *buf, unsigned long size,
+	      const char *sys)
 {
-	int ret = __pevent_parse_format(eventp, pevent, buf, size, sys);
+	int ret = __tep_parse_format(eventp, pevent, buf, size, sys);
 	struct event_format *event = *eventp;
 
 	if (event == NULL)
@@ -6176,7 +6176,7 @@ enum tep_errno tep_parse_format(struct tep_handle *pevent,
 				const char *buf,
 				unsigned long size, const char *sys)
 {
-	return __pevent_parse_event(pevent, eventp, buf, size, sys);
+	return __parse_event(pevent, eventp, buf, size, sys);
 }
 
 /**
@@ -6197,12 +6197,12 @@ enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
 			       unsigned long size, const char *sys)
 {
 	struct event_format *event = NULL;
-	return __pevent_parse_event(pevent, &event, buf, size, sys);
+	return __parse_event(pevent, &event, buf, size, sys);
 }
 
 #undef _PE
 #define _PE(code, str) str
-static const char * const pevent_error_str[] = {
+static const char * const tep_error_str[] = {
 	TEP_ERRORS
 };
 #undef _PE
@@ -6223,7 +6223,7 @@ int tep_strerror(struct tep_handle *pevent __maybe_unused,
 		return -1;
 
 	idx = errnum - __TEP_ERRNO__START - 1;
-	msg = pevent_error_str[idx];
+	msg = tep_error_str[idx];
 	snprintf(buf, buflen, "%s", msg);
 
 	return 0;
@@ -6449,7 +6449,7 @@ int tep_print_func_field(struct trace_seq *s, const char *fmt,
 
 static void free_func_handle(struct tep_function_handler *func)
 {
-	struct pevent_func_params *params;
+	struct func_params *params;
 
 	free(func->name);
 
@@ -6483,8 +6483,8 @@ int tep_register_print_function(struct tep_handle *pevent,
 				char *name, ...)
 {
 	struct tep_function_handler *func_handle;
-	struct pevent_func_params **next_param;
-	struct pevent_func_params *param;
+	struct func_params **next_param;
+	struct func_params *param;
 	enum tep_func_arg_type type;
 	va_list ap;
 	int ret;
@@ -6577,9 +6577,9 @@ int tep_unregister_print_function(struct tep_handle *pevent,
 	return -1;
 }
 
-static struct event_format *pevent_search_event(struct tep_handle *pevent, int id,
-						const char *sys_name,
-						const char *event_name)
+static struct event_format *search_event(struct tep_handle *pevent, int id,
+					 const char *sys_name,
+					 const char *event_name)
 {
 	struct event_format *event;
 
@@ -6624,7 +6624,7 @@ int tep_register_event_handler(struct tep_handle *pevent, int id,
 	struct event_format *event;
 	struct event_handler *handle;
 
-	event = pevent_search_event(pevent, id, sys_name, event_name);
+	event = search_event(pevent, id, sys_name, event_name);
 	if (event == NULL)
 		goto not_found;
 
@@ -6709,7 +6709,7 @@ int tep_unregister_event_handler(struct tep_handle *pevent, int id,
 	struct event_handler *handle;
 	struct event_handler **next;
 
-	event = pevent_search_event(pevent, id, sys_name, event_name);
+	event = search_event(pevent, id, sys_name, event_name);
 	if (event == NULL)
 		goto not_found;
 
-- 
2.17.1
