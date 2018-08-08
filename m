Return-Path: <SRS0=PkBc=KX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:42562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728400AbeHHSde (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Aug 2018 14:33:34 -0400
Message-Id: <20180808161310.577410495@goodmis.org>
Date: Wed, 08 Aug 2018 11:56:12 -0400
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
Subject: [RFC][PATCH 24/24] tools/lib/traceevent: Rename static variables and functions in
 event-parse.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
static variables and functions in event-parse.c: pevent_func_params,
__pevent_parse_format, __pevent_parse_event, pevent_error_str, pevent_search_event

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c | 54 +++++++++++++++---------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index f723c088acca..6313e32680ff 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -92,9 +92,9 @@ struct event_handler {
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
@@ -102,7 +102,7 @@ struct tep_function_handler {
 	enum tep_func_arg_type		ret_type;
 	char				*name;
 	tep_func_handler		func;
-	struct pevent_func_params	*params;
+	struct func_params		*params;
 	int				nr_args;
 };
 
@@ -1161,7 +1161,7 @@ static enum event_type read_token(char **tok)
  * @tok: The token to return
  *
  * This will parse tokens from the string given by
- * pevent_init_data().
+ * tep_init_data().
  *
  * Returns the token type.
  */
@@ -4133,7 +4133,7 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 		     struct event_format *event, struct print_arg *arg)
 {
 	struct tep_function_handler *func_handle = arg->func.func;
-	struct pevent_func_params *param;
+	struct func_params *param;
 	unsigned long long *args;
 	unsigned long long ret;
 	struct print_arg *farg;
@@ -6023,7 +6023,7 @@ static int find_event_handle(struct tep_handle *pevent, struct event_format *eve
 }
 
 /**
- * __pevent_parse_format - parse the event format
+ * __tep_parse_format - parse the event format
  * @buf: the buffer storing the event format string
  * @size: the size of @buf
  * @sys: the system the event belongs to
@@ -6035,9 +6035,9 @@ static int find_event_handle(struct tep_handle *pevent, struct event_format *eve
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
@@ -6143,12 +6143,12 @@ enum tep_errno __pevent_parse_format(struct event_format **eventp,
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
@@ -6190,7 +6190,7 @@ enum tep_errno tep_parse_format(struct tep_handle *pevent,
 				const char *buf,
 				unsigned long size, const char *sys)
 {
-	return __pevent_parse_event(pevent, eventp, buf, size, sys);
+	return __parse_event(pevent, eventp, buf, size, sys);
 }
 
 /**
@@ -6211,12 +6211,12 @@ enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
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
@@ -6237,7 +6237,7 @@ int tep_strerror(struct tep_handle *pevent __maybe_unused,
 		return -1;
 
 	idx = errnum - __TEP_ERRNO__START - 1;
-	msg = pevent_error_str[idx];
+	msg = tep_error_str[idx];
 	snprintf(buf, buflen, "%s", msg);
 
 	return 0;
@@ -6463,7 +6463,7 @@ int tep_print_func_field(struct trace_seq *s, const char *fmt,
 
 static void free_func_handle(struct tep_function_handler *func)
 {
-	struct pevent_func_params *params;
+	struct func_params *params;
 
 	free(func->name);
 
@@ -6497,8 +6497,8 @@ int tep_register_print_function(struct tep_handle *pevent,
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
@@ -6591,9 +6591,9 @@ int tep_unregister_print_function(struct tep_handle *pevent,
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
 
@@ -6638,7 +6638,7 @@ int tep_register_event_handler(struct tep_handle *pevent, int id,
 	struct event_format *event;
 	struct event_handler *handle;
 
-	event = pevent_search_event(pevent, id, sys_name, event_name);
+	event = search_event(pevent, id, sys_name, event_name);
 	if (event == NULL)
 		goto not_found;
 
@@ -6723,7 +6723,7 @@ int tep_unregister_event_handler(struct tep_handle *pevent, int id,
 	struct event_handler *handle;
 	struct event_handler **next;
 
-	event = pevent_search_event(pevent, id, sys_name, event_name);
+	event = search_event(pevent, id, sys_name, event_name);
 	if (event == NULL)
 		goto not_found;
 
-- 
2.18.0
