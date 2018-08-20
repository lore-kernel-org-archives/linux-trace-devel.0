Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:51156 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbeHTRvZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 13:51:25 -0400
Received: by mail-wm0-f65.google.com with SMTP id s12-v6so14562445wmc.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Aug 2018 07:35:28 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 13/24] trace-cmd: Rename enunm pevent_errno to enum tep_errno
Date: Mon, 20 Aug 2018 17:34:54 +0300
Message-Id: <20180820143505.11525-14-tz.stoyanov@gmail.com>
In-Reply-To: <20180820143505.11525-1-tz.stoyanov@gmail.com>
References: <20180820143505.11525-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
enum pevent_errno to enum tep_errno

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h |  48 +++++-----
 lib/traceevent/event-parse.c     |  60 ++++++-------
 lib/traceevent/parse-filter.c    | 150 +++++++++++++++----------------
 3 files changed, 129 insertions(+), 129 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 3df714f..4d4637d 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -365,7 +365,7 @@ enum tep_flag {
 	TEP_DISABLE_PLUGINS	= 1 << 2,
 };
 
-#define PEVENT_ERRORS 							      \
+#define TEP_ERRORS 							      \
 	_PE(MEM_ALLOC_FAILED,	"failed to allocate memory"),		      \
 	_PE(PARSE_EVENT_FAILED,	"failed to parse event"),		      \
 	_PE(READ_ID_FAILED,	"failed to read event id"),		      \
@@ -397,10 +397,10 @@ enum tep_flag {
 	_PE(FILTER_MISS,	"record does not match to filter")
 
 #undef _PE
-#define _PE(__code, __str) PEVENT_ERRNO__ ## __code
-enum pevent_errno {
-	PEVENT_ERRNO__SUCCESS			= 0,
-	PEVENT_ERRNO__FILTER_MATCH		= PEVENT_ERRNO__SUCCESS,
+#define _PE(__code, __str) TEP_ERRNO__ ## __code
+enum tep_errno {
+	TEP_ERRNO__SUCCESS			= 0,
+	TEP_ERRNO__FILTER_MATCH			= TEP_ERRNO__SUCCESS,
 
 	/*
 	 * Choose an arbitrary negative big number not to clash with standard
@@ -409,11 +409,11 @@ enum pevent_errno {
 	 *
 	 * http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/errno.h.html
 	 */
-	__PEVENT_ERRNO__START			= -100000,
+	__TEP_ERRNO__START			= -100000,
 
-	PEVENT_ERRORS,
+	TEP_ERRORS,
 
-	__PEVENT_ERRNO__END,
+	__TEP_ERRNO__END,
 };
 #undef _PE
 
@@ -630,12 +630,12 @@ void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
 int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
 			  int long_size);
 
-enum pevent_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
-				  unsigned long size, const char *sys);
-enum pevent_errno tep_parse_format(struct tep_handle *pevent,
-				   struct event_format **eventp,
-				   const char *buf,
-				   unsigned long size, const char *sys);
+enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
+			       unsigned long size, const char *sys);
+enum tep_errno tep_parse_format(struct tep_handle *pevent,
+				struct event_format **eventp,
+				const char *buf,
+				unsigned long size, const char *sys);
 void pevent_free_format(struct event_format *event);
 void pevent_free_format_field(struct format_field *field);
 
@@ -712,7 +712,7 @@ void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct event_format *event);
 void tep_event_info(struct trace_seq *s, struct event_format *event,
 		       struct tep_record *record);
-int pevent_strerror(struct tep_handle *pevent, enum pevent_errno errnum,
+int pevent_strerror(struct tep_handle *pevent, enum tep_errno errnum,
 		    char *buf, size_t buflen);
 
 struct event_format **pevent_list_events(struct tep_handle *pevent, enum event_sort_type);
@@ -930,10 +930,10 @@ struct event_filter {
 struct event_filter *pevent_filter_alloc(struct tep_handle *pevent);
 
 /* for backward compatibility */
-#define FILTER_NONE		PEVENT_ERRNO__NO_FILTER
-#define FILTER_NOEXIST		PEVENT_ERRNO__FILTER_NOT_FOUND
-#define FILTER_MISS		PEVENT_ERRNO__FILTER_MISS
-#define FILTER_MATCH		PEVENT_ERRNO__FILTER_MATCH
+#define FILTER_NONE		TEP_ERRNO__NO_FILTER
+#define FILTER_NOEXIST		TEP_ERRNO__FILTER_NOT_FOUND
+#define FILTER_MISS		TEP_ERRNO__FILTER_MISS
+#define FILTER_MATCH		TEP_ERRNO__FILTER_MATCH
 
 enum filter_trivial_type {
 	FILTER_TRIVIAL_FALSE,
@@ -941,13 +941,13 @@ enum filter_trivial_type {
 	FILTER_TRIVIAL_BOTH,
 };
 
-enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
-					       const char *filter_str);
+enum tep_errno pevent_filter_add_filter_str(struct event_filter *filter,
+					    const char *filter_str);
 
-enum pevent_errno pevent_filter_match(struct event_filter *filter,
-				      struct tep_record *record);
+enum tep_errno pevent_filter_match(struct event_filter *filter,
+				   struct tep_record *record);
 
-int pevent_filter_strerror(struct event_filter *filter, enum pevent_errno err,
+int pevent_filter_strerror(struct event_filter *filter, enum tep_errno err,
 			   char *buf, size_t buflen);
 
 int pevent_event_filtered(struct event_filter *filter,
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 004ac88..b717eb8 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -6021,9 +6021,9 @@ static int find_event_handle(struct tep_handle *pevent, struct event_format *eve
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum pevent_errno __pevent_parse_format(struct event_format **eventp,
-					struct tep_handle *pevent, const char *buf,
-					unsigned long size, const char *sys)
+enum tep_errno __pevent_parse_format(struct event_format **eventp,
+				     struct tep_handle *pevent, const char *buf,
+				     unsigned long size, const char *sys)
 {
 	struct event_format *event;
 	int ret;
@@ -6032,12 +6032,12 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
 
 	*eventp = event = alloc_event();
 	if (!event)
-		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		return TEP_ERRNO__MEM_ALLOC_FAILED;
 
 	event->name = event_read_name();
 	if (!event->name) {
 		/* Bad event? */
-		ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		ret = TEP_ERRNO__MEM_ALLOC_FAILED;
 		goto event_alloc_failed;
 	}
 
@@ -6050,7 +6050,7 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
 		
 	event->id = event_read_id();
 	if (event->id < 0) {
-		ret = PEVENT_ERRNO__READ_ID_FAILED;
+		ret = TEP_ERRNO__READ_ID_FAILED;
 		/*
 		 * This isn't an allocation error actually.
 		 * But as the ID is critical, just bail out.
@@ -6060,7 +6060,7 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
 
 	event->system = strdup(sys);
 	if (!event->system) {
-		ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		ret = TEP_ERRNO__MEM_ALLOC_FAILED;
 		goto event_alloc_failed;
 	}
 
@@ -6069,7 +6069,7 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
 
 	ret = event_read_format(event);
 	if (ret < 0) {
-		ret = PEVENT_ERRNO__READ_FORMAT_FAILED;
+		ret = TEP_ERRNO__READ_FORMAT_FAILED;
 		goto event_parse_failed;
 	}
 
@@ -6084,7 +6084,7 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
 	show_warning = 1;
 
 	if (ret < 0) {
-		ret = PEVENT_ERRNO__READ_PRINT_FAILED;
+		ret = TEP_ERRNO__READ_PRINT_FAILED;
 		goto event_parse_failed;
 	}
 
@@ -6098,14 +6098,14 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
 			arg = alloc_arg();
 			if (!arg) {
 				event->flags |= EVENT_FL_FAILED;
-				return PEVENT_ERRNO__OLD_FTRACE_ARG_FAILED;
+				return TEP_ERRNO__OLD_FTRACE_ARG_FAILED;
 			}
 			arg->type = PRINT_FIELD;
 			arg->field.name = strdup(field->name);
 			if (!arg->field.name) {
 				event->flags |= EVENT_FL_FAILED;
 				free_arg(arg);
-				return PEVENT_ERRNO__OLD_FTRACE_ARG_FAILED;
+				return TEP_ERRNO__OLD_FTRACE_ARG_FAILED;
 			}
 			arg->field.field = field;
 			*list = arg;
@@ -6128,7 +6128,7 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
 	return ret;
 }
 
-static enum pevent_errno
+static enum tep_errno
 __pevent_parse_event(struct tep_handle *pevent,
 		     struct event_format **eventp,
 		     const char *buf, unsigned long size,
@@ -6141,7 +6141,7 @@ __pevent_parse_event(struct tep_handle *pevent,
 		return ret;
 
 	if (pevent && add_event(pevent, event)) {
-		ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		ret = TEP_ERRNO__MEM_ALLOC_FAILED;
 		goto event_add_failed;
 	}
 
@@ -6171,10 +6171,10 @@ event_add_failed:
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum pevent_errno tep_parse_format(struct tep_handle *pevent,
-				   struct event_format **eventp,
-				   const char *buf,
-				   unsigned long size, const char *sys)
+enum tep_errno tep_parse_format(struct tep_handle *pevent,
+				struct event_format **eventp,
+				const char *buf,
+				unsigned long size, const char *sys)
 {
 	return __pevent_parse_event(pevent, eventp, buf, size, sys);
 }
@@ -6193,8 +6193,8 @@ enum pevent_errno tep_parse_format(struct tep_handle *pevent,
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum pevent_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
-				  unsigned long size, const char *sys)
+enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
+			       unsigned long size, const char *sys)
 {
 	struct event_format *event = NULL;
 	return __pevent_parse_event(pevent, &event, buf, size, sys);
@@ -6203,12 +6203,12 @@ enum pevent_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
 #undef _PE
 #define _PE(code, str) str
 static const char * const pevent_error_str[] = {
-	PEVENT_ERRORS
+	TEP_ERRORS
 };
 #undef _PE
 
 int pevent_strerror(struct tep_handle *pevent __maybe_unused,
-		    enum pevent_errno errnum, char *buf, size_t buflen)
+		    enum tep_errno errnum, char *buf, size_t buflen)
 {
 	int idx;
 	const char *msg;
@@ -6218,11 +6218,11 @@ int pevent_strerror(struct tep_handle *pevent __maybe_unused,
 		return 0;
 	}
 
-	if (errnum <= __PEVENT_ERRNO__START ||
-	    errnum >= __PEVENT_ERRNO__END)
+	if (errnum <= __TEP_ERRNO__START ||
+	    errnum >= __TEP_ERRNO__END)
 		return -1;
 
-	idx = errnum - __PEVENT_ERRNO__START - 1;
+	idx = errnum - __TEP_ERRNO__START - 1;
 	msg = pevent_error_str[idx];
 	snprintf(buf, buflen, "%s", msg);
 
@@ -6503,7 +6503,7 @@ int pevent_register_print_function(struct tep_handle *pevent,
 	func_handle = calloc(1, sizeof(*func_handle));
 	if (!func_handle) {
 		do_warning("Failed to allocate function handler");
-		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		return TEP_ERRNO__MEM_ALLOC_FAILED;
 	}
 
 	func_handle->ret_type = ret_type;
@@ -6512,7 +6512,7 @@ int pevent_register_print_function(struct tep_handle *pevent,
 	if (!func_handle->name) {
 		do_warning("Failed to allocate function name");
 		free(func_handle);
-		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		return TEP_ERRNO__MEM_ALLOC_FAILED;
 	}
 
 	next_param = &(func_handle->params);
@@ -6524,14 +6524,14 @@ int pevent_register_print_function(struct tep_handle *pevent,
 
 		if (type >= PEVENT_FUNC_ARG_MAX_TYPES) {
 			do_warning("Invalid argument type %d", type);
-			ret = PEVENT_ERRNO__INVALID_ARG_TYPE;
+			ret = TEP_ERRNO__INVALID_ARG_TYPE;
 			goto out_free;
 		}
 
 		param = malloc(sizeof(*param));
 		if (!param) {
 			do_warning("Failed to allocate function param");
-			ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
+			ret = TEP_ERRNO__MEM_ALLOC_FAILED;
 			goto out_free;
 		}
 		param->type = type;
@@ -6640,7 +6640,7 @@ int pevent_register_event_handler(struct tep_handle *pevent, int id,
 	handle = calloc(1, sizeof(*handle));
 	if (!handle) {
 		do_warning("Failed to allocate event handler");
-		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		return TEP_ERRNO__MEM_ALLOC_FAILED;
 	}
 
 	handle->id = id;
@@ -6655,7 +6655,7 @@ int pevent_register_event_handler(struct tep_handle *pevent, int id,
 		free((void *)handle->event_name);
 		free((void *)handle->sys_name);
 		free(handle);
-		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		return TEP_ERRNO__MEM_ALLOC_FAILED;
 	}
 
 	handle->func = func;
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index bfdaec1..2241523 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -254,7 +254,7 @@ static int event_match(struct event_format *event,
 		!regexec(ereg, event->name, 0, NULL, 0);
 }
 
-static enum pevent_errno
+static enum tep_errno
 find_event(struct tep_handle *pevent, struct event_list **events,
 	   char *sys_name, char *event_name)
 {
@@ -275,26 +275,26 @@ find_event(struct tep_handle *pevent, struct event_list **events,
 
 	ret = asprintf(&reg, "^%s$", event_name);
 	if (ret < 0)
-		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		return TEP_ERRNO__MEM_ALLOC_FAILED;
 
 	ret = regcomp(&ereg, reg, REG_ICASE|REG_NOSUB);
 	free(reg);
 
 	if (ret)
-		return PEVENT_ERRNO__INVALID_EVENT_NAME;
+		return TEP_ERRNO__INVALID_EVENT_NAME;
 
 	if (sys_name) {
 		ret = asprintf(&reg, "^%s$", sys_name);
 		if (ret < 0) {
 			regfree(&ereg);
-			return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+			return TEP_ERRNO__MEM_ALLOC_FAILED;
 		}
 
 		ret = regcomp(&sreg, reg, REG_ICASE|REG_NOSUB);
 		free(reg);
 		if (ret) {
 			regfree(&ereg);
-			return PEVENT_ERRNO__INVALID_EVENT_NAME;
+			return TEP_ERRNO__INVALID_EVENT_NAME;
 		}
 	}
 
@@ -314,9 +314,9 @@ find_event(struct tep_handle *pevent, struct event_list **events,
 		regfree(&sreg);
 
 	if (!match)
-		return PEVENT_ERRNO__EVENT_NOT_FOUND;
+		return TEP_ERRNO__EVENT_NOT_FOUND;
 	if (fail)
-		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		return TEP_ERRNO__MEM_ALLOC_FAILED;
 
 	return 0;
 }
@@ -332,7 +332,7 @@ static void free_events(struct event_list *events)
 	}
 }
 
-static enum pevent_errno
+static enum tep_errno
 create_arg_item(struct event_format *event, const char *token,
 		enum event_type type, struct filter_arg **parg, char *error_str)
 {
@@ -342,7 +342,7 @@ create_arg_item(struct event_format *event, const char *token,
 	arg = allocate_arg();
 	if (arg == NULL) {
 		show_error(error_str, "failed to allocate filter arg");
-		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		return TEP_ERRNO__MEM_ALLOC_FAILED;
 	}
 
 	switch (type) {
@@ -356,7 +356,7 @@ create_arg_item(struct event_format *event, const char *token,
 		if (!arg->value.str) {
 			free_arg(arg);
 			show_error(error_str, "failed to allocate string filter arg");
-			return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+			return TEP_ERRNO__MEM_ALLOC_FAILED;
 		}
 		break;
 	case EVENT_ITEM:
@@ -388,7 +388,7 @@ create_arg_item(struct event_format *event, const char *token,
 	default:
 		free_arg(arg);
 		show_error(error_str, "expected a value but found %s", token);
-		return PEVENT_ERRNO__UNEXPECTED_TYPE;
+		return TEP_ERRNO__UNEXPECTED_TYPE;
 	}
 	*parg = arg;
 	return 0;
@@ -440,7 +440,7 @@ create_arg_cmp(enum filter_cmp_type ctype)
 	return arg;
 }
 
-static enum pevent_errno
+static enum tep_errno
 add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 {
 	struct filter_arg *left;
@@ -473,7 +473,7 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 			break;
 		default:
 			show_error(error_str, "Illegal rvalue");
-			return PEVENT_ERRNO__ILLEGAL_RVALUE;
+			return TEP_ERRNO__ILLEGAL_RVALUE;
 		}
 
 		/*
@@ -520,7 +520,7 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 			if (left->type != FILTER_ARG_FIELD) {
 				show_error(error_str,
 					   "Illegal lvalue for string comparison");
-				return PEVENT_ERRNO__ILLEGAL_LVALUE;
+				return TEP_ERRNO__ILLEGAL_LVALUE;
 			}
 
 			/* Make sure this is a valid string compare */
@@ -539,13 +539,13 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 					show_error(error_str,
 						   "RegEx '%s' did not compute",
 						   str);
-					return PEVENT_ERRNO__INVALID_REGEX;
+					return TEP_ERRNO__INVALID_REGEX;
 				}
 				break;
 			default:
 				show_error(error_str,
 					   "Illegal comparison for string");
-				return PEVENT_ERRNO__ILLEGAL_STRING_CMP;
+				return TEP_ERRNO__ILLEGAL_STRING_CMP;
 			}
 
 			op->type = FILTER_ARG_STR;
@@ -554,7 +554,7 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 			op->str.val = strdup(str);
 			if (!op->str.val) {
 				show_error(error_str, "Failed to allocate string filter");
-				return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+				return TEP_ERRNO__MEM_ALLOC_FAILED;
 			}
 			/*
 			 * Need a buffer to copy data for tests
@@ -562,7 +562,7 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 			op->str.buffer = malloc(op->str.field->size + 1);
 			if (!op->str.buffer) {
 				show_error(error_str, "Failed to allocate string filter");
-				return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+				return TEP_ERRNO__MEM_ALLOC_FAILED;
 			}
 			/* Null terminate this buffer */
 			op->str.buffer[op->str.field->size] = 0;
@@ -581,7 +581,7 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 			case FILTER_CMP_NOT_REGEX:
 				show_error(error_str,
 					   "Op not allowed with integers");
-				return PEVENT_ERRNO__ILLEGAL_INTEGER_CMP;
+				return TEP_ERRNO__ILLEGAL_INTEGER_CMP;
 
 			default:
 				break;
@@ -602,7 +602,7 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 
  out_fail:
 	show_error(error_str, "Syntax error");
-	return PEVENT_ERRNO__SYNTAX_ERROR;
+	return TEP_ERRNO__SYNTAX_ERROR;
 }
 
 static struct filter_arg *
@@ -615,7 +615,7 @@ rotate_op_right(struct filter_arg *a, struct filter_arg *b)
 	return arg;
 }
 
-static enum pevent_errno add_left(struct filter_arg *op, struct filter_arg *arg)
+static enum tep_errno add_left(struct filter_arg *op, struct filter_arg *arg)
 {
 	switch (op->type) {
 	case FILTER_ARG_EXP:
@@ -634,11 +634,11 @@ static enum pevent_errno add_left(struct filter_arg *op, struct filter_arg *arg)
 		/* left arg of compares must be a field */
 		if (arg->type != FILTER_ARG_FIELD &&
 		    arg->type != FILTER_ARG_BOOLEAN)
-			return PEVENT_ERRNO__INVALID_ARG_TYPE;
+			return TEP_ERRNO__INVALID_ARG_TYPE;
 		op->num.left = arg;
 		break;
 	default:
-		return PEVENT_ERRNO__INVALID_ARG_TYPE;
+		return TEP_ERRNO__INVALID_ARG_TYPE;
 	}
 	return 0;
 }
@@ -751,7 +751,7 @@ enum filter_vals {
 	FILTER_VAL_TRUE,
 };
 
-static enum pevent_errno
+static enum tep_errno
 reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
 		struct filter_arg *arg, char *error_str)
 {
@@ -761,7 +761,7 @@ reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
 	if (parent->type != FILTER_ARG_OP &&
 	    arg->type != FILTER_ARG_OP) {
 		show_error(error_str, "can not reparent other than OP");
-		return PEVENT_ERRNO__REPARENT_NOT_OP;
+		return TEP_ERRNO__REPARENT_NOT_OP;
 	}
 
 	/* Get the sibling */
@@ -773,7 +773,7 @@ reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
 		other_child = old_child->op.right;
 	} else {
 		show_error(error_str, "Error in reparent op, find other child");
-		return PEVENT_ERRNO__REPARENT_FAILED;
+		return TEP_ERRNO__REPARENT_FAILED;
 	}
 
 	/* Detach arg from old_child */
@@ -794,7 +794,7 @@ reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
 		ptr = &parent->op.left;
 	else {
 		show_error(error_str, "Error in reparent op");
-		return PEVENT_ERRNO__REPARENT_FAILED;
+		return TEP_ERRNO__REPARENT_FAILED;
 	}
 
 	*ptr = arg;
@@ -803,7 +803,7 @@ reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
 	return 0;
 }
 
-/* Returns either filter_vals (success) or pevent_errno (failfure) */
+/* Returns either filter_vals (success) or tep_errno (failfure) */
 static int test_arg(struct filter_arg *parent, struct filter_arg *arg,
 		    char *error_str)
 {
@@ -898,7 +898,7 @@ static int test_arg(struct filter_arg *parent, struct filter_arg *arg,
 		return rval;
 	default:
 		show_error(error_str, "bad arg in filter tree");
-		return PEVENT_ERRNO__BAD_FILTER_ARG;
+		return TEP_ERRNO__BAD_FILTER_ARG;
 	}
 	return FILTER_VAL_NORM;
 }
@@ -923,7 +923,7 @@ static int collapse_tree(struct filter_arg *arg,
 			arg->boolean.value = ret == FILTER_VAL_TRUE;
 		} else {
 			show_error(error_str, "Failed to allocate filter arg");
-			ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
+			ret = TEP_ERRNO__MEM_ALLOC_FAILED;
 		}
 		break;
 
@@ -938,7 +938,7 @@ static int collapse_tree(struct filter_arg *arg,
 	return ret;
 }
 
-static enum pevent_errno
+static enum tep_errno
 process_filter(struct event_format *event, struct filter_arg **parg,
 	       char *error_str, int not)
 {
@@ -952,7 +952,7 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 	enum filter_op_type btype;
 	enum filter_exp_type etype;
 	enum filter_cmp_type ctype;
-	enum pevent_errno ret;
+	enum tep_errno ret;
 
 	*parg = NULL;
 
@@ -990,7 +990,7 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 		case EVENT_DELIM:
 			if (*token == ',') {
 				show_error(error_str, "Illegal token ','");
-				ret = PEVENT_ERRNO__ILLEGAL_TOKEN;
+				ret = TEP_ERRNO__ILLEGAL_TOKEN;
 				goto fail;
 			}
 
@@ -998,22 +998,22 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 				if (left_item) {
 					show_error(error_str,
 						   "Open paren can not come after item");
-					ret = PEVENT_ERRNO__INVALID_PAREN;
+					ret = TEP_ERRNO__INVALID_PAREN;
 					goto fail;
 				}
 				if (current_exp) {
 					show_error(error_str,
 						   "Open paren can not come after expression");
-					ret = PEVENT_ERRNO__INVALID_PAREN;
+					ret = TEP_ERRNO__INVALID_PAREN;
 					goto fail;
 				}
 
 				ret = process_filter(event, &arg, error_str, 0);
-				if (ret != PEVENT_ERRNO__UNBALANCED_PAREN) {
+				if (ret != TEP_ERRNO__UNBALANCED_PAREN) {
 					if (ret == 0) {
 						show_error(error_str,
 							   "Unbalanced number of '('");
-						ret = PEVENT_ERRNO__UNBALANCED_PAREN;
+						ret = TEP_ERRNO__UNBALANCED_PAREN;
 					}
 					goto fail;
 				}
@@ -1050,7 +1050,7 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 				else
 					*parg = current_exp;
 				free(token);
-				return PEVENT_ERRNO__UNBALANCED_PAREN;
+				return TEP_ERRNO__UNBALANCED_PAREN;
 			}
 			break;
 
@@ -1077,7 +1077,7 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 			case OP_NONE:
 				show_error(error_str,
 					   "Unknown op token %s", token);
-				ret = PEVENT_ERRNO__UNKNOWN_TOKEN;
+				ret = TEP_ERRNO__UNKNOWN_TOKEN;
 				goto fail;
 			}
 
@@ -1165,11 +1165,11 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 
  fail_alloc:
 	show_error(error_str, "failed to allocate filter arg");
-	ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
+	ret = TEP_ERRNO__MEM_ALLOC_FAILED;
 	goto fail;
  fail_syntax:
 	show_error(error_str, "Syntax error");
-	ret = PEVENT_ERRNO__SYNTAX_ERROR;
+	ret = TEP_ERRNO__SYNTAX_ERROR;
  fail:
 	free_arg(current_op);
 	free_arg(current_exp);
@@ -1178,7 +1178,7 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 	return ret;
 }
 
-static enum pevent_errno
+static enum tep_errno
 process_event(struct event_format *event, const char *filter_str,
 	      struct filter_arg **parg, char *error_str)
 {
@@ -1194,7 +1194,7 @@ process_event(struct event_format *event, const char *filter_str,
 	if (!*parg) {
 		*parg = allocate_arg();
 		if (*parg == NULL)
-			return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+			return TEP_ERRNO__MEM_ALLOC_FAILED;
 
 		(*parg)->type = FILTER_ARG_BOOLEAN;
 		(*parg)->boolean.value = FILTER_FALSE;
@@ -1203,13 +1203,13 @@ process_event(struct event_format *event, const char *filter_str,
 	return 0;
 }
 
-static enum pevent_errno
+static enum tep_errno
 filter_event(struct event_filter *filter, struct event_format *event,
 	     const char *filter_str, char *error_str)
 {
 	struct filter_type *filter_type;
 	struct filter_arg *arg;
-	enum pevent_errno ret;
+	enum tep_errno ret;
 
 	if (filter_str) {
 		ret = process_event(event, filter_str, &arg, error_str);
@@ -1220,7 +1220,7 @@ filter_event(struct event_filter *filter, struct event_format *event,
 		/* just add a TRUE arg */
 		arg = allocate_arg();
 		if (arg == NULL)
-			return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+			return TEP_ERRNO__MEM_ALLOC_FAILED;
 
 		arg->type = FILTER_ARG_BOOLEAN;
 		arg->boolean.value = FILTER_TRUE;
@@ -1228,7 +1228,7 @@ filter_event(struct event_filter *filter, struct event_format *event,
 
 	filter_type = add_filter_type(filter, event->id);
 	if (filter_type == NULL)
-		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		return TEP_ERRNO__MEM_ALLOC_FAILED;
 
 	if (filter_type->filter)
 		free_arg(filter_type->filter);
@@ -1253,7 +1253,7 @@ static void filter_init_error_buf(struct event_filter *filter)
  * negative error code.  Use pevent_filter_strerror() to see
  * actual error message in case of error.
  */
-enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
+enum tep_errno pevent_filter_add_filter_str(struct event_filter *filter,
 					       const char *filter_str)
 {
 	struct tep_handle *pevent = filter->pevent;
@@ -1265,7 +1265,7 @@ enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
 	char *event_name = NULL;
 	char *sys_name = NULL;
 	char *sp;
-	enum pevent_errno rtn = 0; /* PEVENT_ERRNO__SUCCESS */
+	enum tep_errno rtn = 0; /* TEP_ERRNO__SUCCESS */
 	int len;
 	int ret;
 
@@ -1291,7 +1291,7 @@ enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
 		if (this_event == NULL) {
 			/* This can only happen when events is NULL, but still */
 			free_events(events);
-			return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+			return TEP_ERRNO__MEM_ALLOC_FAILED;
 		}
 		memcpy(this_event, filter_str, len);
 		this_event[len] = 0;
@@ -1308,7 +1308,7 @@ enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
 			/* This can only happen when events is NULL, but still */
 			free_events(events);
 			free(this_event);
-			return PEVENT_ERRNO__FILTER_NOT_FOUND;
+			return TEP_ERRNO__FILTER_NOT_FOUND;
 		}
 
 		/* Find this event */
@@ -1365,10 +1365,10 @@ static void free_filter_type(struct filter_type *filter_type)
  *
  * Returns 0 if message was filled successfully, -1 if error
  */
-int pevent_filter_strerror(struct event_filter *filter, enum pevent_errno err,
+int pevent_filter_strerror(struct event_filter *filter, enum tep_errno err,
 			   char *buf, size_t buflen)
 {
-	if (err <= __PEVENT_ERRNO__START || err >= __PEVENT_ERRNO__END)
+	if (err <= __TEP_ERRNO__START || err >= __TEP_ERRNO__END)
 		return -1;
 
 	if (strlen(filter->error_buffer) > 0) {
@@ -1683,7 +1683,7 @@ int pevent_filter_event_has_trivial(struct event_filter *filter,
 }
 
 static int test_filter(struct event_format *event, struct filter_arg *arg,
-		       struct tep_record *record, enum pevent_errno *err);
+		       struct tep_record *record, enum tep_errno *err);
 
 static const char *
 get_comm(struct event_format *event, struct tep_record *record)
@@ -1734,11 +1734,11 @@ get_value(struct event_format *event,
 
 static unsigned long long
 get_arg_value(struct event_format *event, struct filter_arg *arg,
-	      struct tep_record *record, enum pevent_errno *err);
+	      struct tep_record *record, enum tep_errno *err);
 
 static unsigned long long
 get_exp_value(struct event_format *event, struct filter_arg *arg,
-	      struct tep_record *record, enum pevent_errno *err)
+	      struct tep_record *record, enum tep_errno *err)
 {
 	unsigned long long lval, rval;
 
@@ -1786,14 +1786,14 @@ get_exp_value(struct event_format *event, struct filter_arg *arg,
 	case FILTER_EXP_NOT:
 	default:
 		if (!*err)
-			*err = PEVENT_ERRNO__INVALID_EXP_TYPE;
+			*err = TEP_ERRNO__INVALID_EXP_TYPE;
 	}
 	return 0;
 }
 
 static unsigned long long
 get_arg_value(struct event_format *event, struct filter_arg *arg,
-	      struct tep_record *record, enum pevent_errno *err)
+	      struct tep_record *record, enum tep_errno *err)
 {
 	switch (arg->type) {
 	case FILTER_ARG_FIELD:
@@ -1802,7 +1802,7 @@ get_arg_value(struct event_format *event, struct filter_arg *arg,
 	case FILTER_ARG_VALUE:
 		if (arg->value.type != FILTER_NUMBER) {
 			if (!*err)
-				*err = PEVENT_ERRNO__NOT_A_NUMBER;
+				*err = TEP_ERRNO__NOT_A_NUMBER;
 		}
 		return arg->value.val;
 
@@ -1811,13 +1811,13 @@ get_arg_value(struct event_format *event, struct filter_arg *arg,
 
 	default:
 		if (!*err)
-			*err = PEVENT_ERRNO__INVALID_ARG_TYPE;
+			*err = TEP_ERRNO__INVALID_ARG_TYPE;
 	}
 	return 0;
 }
 
 static int test_num(struct event_format *event, struct filter_arg *arg,
-		    struct tep_record *record, enum pevent_errno *err)
+		    struct tep_record *record, enum tep_errno *err)
 {
 	unsigned long long lval, rval;
 
@@ -1852,7 +1852,7 @@ static int test_num(struct event_format *event, struct filter_arg *arg,
 
 	default:
 		if (!*err)
-			*err = PEVENT_ERRNO__ILLEGAL_INTEGER_CMP;
+			*err = TEP_ERRNO__ILLEGAL_INTEGER_CMP;
 		return 0;
 	}
 }
@@ -1908,7 +1908,7 @@ static const char *get_field_str(struct filter_arg *arg, struct tep_record *reco
 }
 
 static int test_str(struct event_format *event, struct filter_arg *arg,
-		    struct tep_record *record, enum pevent_errno *err)
+		    struct tep_record *record, enum tep_errno *err)
 {
 	const char *val;
 
@@ -1933,13 +1933,13 @@ static int test_str(struct event_format *event, struct filter_arg *arg,
 
 	default:
 		if (!*err)
-			*err = PEVENT_ERRNO__ILLEGAL_STRING_CMP;
+			*err = TEP_ERRNO__ILLEGAL_STRING_CMP;
 		return 0;
 	}
 }
 
 static int test_op(struct event_format *event, struct filter_arg *arg,
-		   struct tep_record *record, enum pevent_errno *err)
+		   struct tep_record *record, enum tep_errno *err)
 {
 	switch (arg->op.type) {
 	case FILTER_OP_AND:
@@ -1955,13 +1955,13 @@ static int test_op(struct event_format *event, struct filter_arg *arg,
 
 	default:
 		if (!*err)
-			*err = PEVENT_ERRNO__INVALID_OP_TYPE;
+			*err = TEP_ERRNO__INVALID_OP_TYPE;
 		return 0;
 	}
 }
 
 static int test_filter(struct event_format *event, struct filter_arg *arg,
-		       struct tep_record *record, enum pevent_errno *err)
+		       struct tep_record *record, enum tep_errno *err)
 {
 	if (*err) {
 		/*
@@ -1995,7 +1995,7 @@ static int test_filter(struct event_format *event, struct filter_arg *arg,
 
 	default:
 		if (!*err)
-			*err = PEVENT_ERRNO__INVALID_ARG_TYPE;
+			*err = TEP_ERRNO__INVALID_ARG_TYPE;
 		return 0;
 	}
 }
@@ -2025,38 +2025,38 @@ int pevent_event_filtered(struct event_filter *filter, int event_id)
  * @filter: filter struct with filter information
  * @record: the record to test against the filter
  *
- * Returns: match result or error code (prefixed with PEVENT_ERRNO__)
+ * Returns: match result or error code (prefixed with TEP_ERRNO__)
  * FILTER_MATCH - filter found for event and @record matches
  * FILTER_MISS  - filter found for event and @record does not match
  * FILTER_NOT_FOUND - no filter found for @record's event
  * NO_FILTER - if no filters exist
  * otherwise - error occurred during test
  */
-enum pevent_errno pevent_filter_match(struct event_filter *filter,
-				      struct tep_record *record)
+enum tep_errno pevent_filter_match(struct event_filter *filter,
+				   struct tep_record *record)
 {
 	struct tep_handle *pevent = filter->pevent;
 	struct filter_type *filter_type;
 	int event_id;
 	int ret;
-	enum pevent_errno err = 0;
+	enum tep_errno err = 0;
 
 	filter_init_error_buf(filter);
 
 	if (!filter->filters)
-		return PEVENT_ERRNO__NO_FILTER;
+		return TEP_ERRNO__NO_FILTER;
 
 	event_id = pevent_data_type(pevent, record);
 
 	filter_type = find_filter_type(filter, event_id);
 	if (!filter_type)
-		return PEVENT_ERRNO__FILTER_NOT_FOUND;
+		return TEP_ERRNO__FILTER_NOT_FOUND;
 
 	ret = test_filter(filter_type->event, filter_type->filter, record, &err);
 	if (err)
 		return err;
 
-	return ret ? PEVENT_ERRNO__FILTER_MATCH : PEVENT_ERRNO__FILTER_MISS;
+	return ret ? TEP_ERRNO__FILTER_MATCH : TEP_ERRNO__FILTER_MISS;
 }
 
 static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
-- 
2.17.1
