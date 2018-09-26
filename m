Return-Path: <SRS0=XLZm=MI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730062.outbound.protection.outlook.com ([40.107.73.62]:58268
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727411AbeIZSbu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Sep 2018 14:31:50 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 06/16] tools lib traceevent: Add prefix TEP_ to all EVENT_FL_* flags
Date: Wed, 26 Sep 2018 15:18:22 +0300
Message-Id: <20180926121832.16101-7-tstoyanov@vmware.com>
In-Reply-To: <20180926121832.16101-1-tstoyanov@vmware.com>
References: <20180926121832.16101-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This adds prefix TEP_
to all members of nameless enum EVENT_FL_*

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180919185723.116643250@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h | 18 +++++++-------
 lib/traceevent/event-parse.c     | 42 ++++++++++++++++----------------
 tracecmd/trace-read.c            |  4 +--
 3 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index df28163..dc1f1fa 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -276,15 +276,15 @@ struct tep_event_format {
 };
 
 enum {
-	EVENT_FL_ISFTRACE	= 0x01,
-	EVENT_FL_ISPRINT	= 0x02,
-	EVENT_FL_ISBPRINT	= 0x04,
-	EVENT_FL_ISFUNCENT	= 0x10,
-	EVENT_FL_ISFUNCRET	= 0x20,
-	EVENT_FL_NOHANDLE	= 0x40,
-	EVENT_FL_PRINTRAW	= 0x80,
-
-	EVENT_FL_FAILED		= 0x80000000
+	TEP_EVENT_FL_ISFTRACE	= 0x01,
+	TEP_EVENT_FL_ISPRINT	= 0x02,
+	TEP_EVENT_FL_ISBPRINT	= 0x04,
+	TEP_EVENT_FL_ISFUNCENT	= 0x10,
+	TEP_EVENT_FL_ISFUNCRET	= 0x20,
+	TEP_EVENT_FL_NOHANDLE	= 0x40,
+	TEP_EVENT_FL_PRINTRAW	= 0x80,
+
+	TEP_EVENT_FL_FAILED	= 0x80000000
 };
 
 enum tep_event_sort_type {
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 1696dd9..a651c33 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -1382,7 +1382,7 @@ static int event_read_fields(struct tep_event_format *event, struct tep_format_f
 		 * The ftrace fields may still use the "special" name.
 		 * Just ignore it.
 		 */
-		if (event->flags & EVENT_FL_ISFTRACE &&
+		if (event->flags & TEP_EVENT_FL_ISFTRACE &&
 		    type == TEP_EVENT_ITEM && strcmp(token, "special") == 0) {
 			free_token(token);
 			type = read_token(&token);
@@ -1412,7 +1412,7 @@ static int event_read_fields(struct tep_event_format *event, struct tep_format_f
 			     * Some of the ftrace fields are broken and have
 			     * an illegal "." in them.
 			     */
-			    (event->flags & EVENT_FL_ISFTRACE &&
+			    (event->flags & TEP_EVENT_FL_ISFTRACE &&
 			     type == TEP_EVENT_OP && strcmp(token, ".") == 0)) {
 
 				if (strcmp(token, "*") == 0)
@@ -1963,7 +1963,7 @@ process_op(struct tep_event_format *event, struct print_arg *arg, char **tok)
 		arg->op.right = NULL;
 
 		if (set_op_prio(arg) == -1) {
-			event->flags |= EVENT_FL_FAILED;
+			event->flags |= TEP_EVENT_FL_FAILED;
 			/* arg->op.op (= token) will be freed at out_free */
 			arg->op.op = NULL;
 			goto out_free;
@@ -2042,7 +2042,7 @@ process_op(struct tep_event_format *event, struct print_arg *arg, char **tok)
 
 	} else {
 		do_warning_event(event, "unknown op '%s'", token);
-		event->flags |= EVENT_FL_FAILED;
+		event->flags |= TEP_EVENT_FL_FAILED;
 		/* the arg is now the left side */
 		goto out_free;
 	}
@@ -4884,13 +4884,13 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 	int len;
 	int ls;
 
-	if (event->flags & EVENT_FL_FAILED) {
+	if (event->flags & TEP_EVENT_FL_FAILED) {
 		trace_seq_printf(s, "[FAILED TO PARSE]");
 		tep_print_fields(s, data, size, event);
 		return;
 	}
 
-	if (event->flags & EVENT_FL_ISBPRINT) {
+	if (event->flags & TEP_EVENT_FL_ISBPRINT) {
 		bprint_fmt = get_bprint_format(data, size, event);
 		args = make_bprint_args(bprint_fmt, data, size, event);
 		arg = args;
@@ -4945,7 +4945,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 				/* The argument is the length. */
 				if (!arg) {
 					do_warning_event(event, "no argument match");
-					event->flags |= EVENT_FL_FAILED;
+					event->flags |= TEP_EVENT_FL_FAILED;
 					goto out_failed;
 				}
 				len_arg = eval_num_arg(data, size, event, arg);
@@ -4998,7 +4998,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 			case 'u':
 				if (!arg) {
 					do_warning_event(event, "no argument match");
-					event->flags |= EVENT_FL_FAILED;
+					event->flags |= TEP_EVENT_FL_FAILED;
 					goto out_failed;
 				}
 
@@ -5008,7 +5008,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 				/* should never happen */
 				if (len > 31) {
 					do_warning_event(event, "bad format!");
-					event->flags |= EVENT_FL_FAILED;
+					event->flags |= TEP_EVENT_FL_FAILED;
 					len = 31;
 				}
 
@@ -5074,13 +5074,13 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 					break;
 				default:
 					do_warning_event(event, "bad count (%d)", ls);
-					event->flags |= EVENT_FL_FAILED;
+					event->flags |= TEP_EVENT_FL_FAILED;
 				}
 				break;
 			case 's':
 				if (!arg) {
 					do_warning_event(event, "no matching argument");
-					event->flags |= EVENT_FL_FAILED;
+					event->flags |= TEP_EVENT_FL_FAILED;
 					goto out_failed;
 				}
 
@@ -5090,7 +5090,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 				/* should never happen */
 				if (len > 31) {
 					do_warning_event(event, "bad format!");
-					event->flags |= EVENT_FL_FAILED;
+					event->flags |= TEP_EVENT_FL_FAILED;
 					len = 31;
 				}
 
@@ -5115,7 +5115,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 			trace_seq_putc(s, *ptr);
 	}
 
-	if (event->flags & EVENT_FL_FAILED) {
+	if (event->flags & TEP_EVENT_FL_FAILED) {
 out_failed:
 		trace_seq_printf(s, "[FAILED TO PARSE]");
 	}
@@ -5391,11 +5391,11 @@ void tep_event_info(struct trace_seq *s, struct tep_event_format *event,
 {
 	int print_pretty = 1;
 
-	if (event->pevent->print_raw || (event->flags & EVENT_FL_PRINTRAW))
+	if (event->pevent->print_raw || (event->flags & TEP_EVENT_FL_PRINTRAW))
 		tep_print_fields(s, record->data, record->size, event);
 	else {
 
-		if (event->handler && !(event->flags & EVENT_FL_NOHANDLE))
+		if (event->handler && !(event->flags & TEP_EVENT_FL_NOHANDLE))
 			print_pretty = event->handler(s, record, event,
 						      event->context);
 
@@ -6043,10 +6043,10 @@ enum tep_errno __tep_parse_format(struct tep_event_format **eventp,
 	}
 
 	if (strcmp(sys, "ftrace") == 0) {
-		event->flags |= EVENT_FL_ISFTRACE;
+		event->flags |= TEP_EVENT_FL_ISFTRACE;
 
 		if (strcmp(event->name, "bprint") == 0)
-			event->flags |= EVENT_FL_ISBPRINT;
+			event->flags |= TEP_EVENT_FL_ISBPRINT;
 	}
 		
 	event->id = event_read_id();
@@ -6089,7 +6089,7 @@ enum tep_errno __tep_parse_format(struct tep_event_format **eventp,
 		goto event_parse_failed;
 	}
 
-	if (!ret && (event->flags & EVENT_FL_ISFTRACE)) {
+	if (!ret && (event->flags & TEP_EVENT_FL_ISFTRACE)) {
 		struct tep_format_field *field;
 		struct print_arg *arg, **list;
 
@@ -6098,13 +6098,13 @@ enum tep_errno __tep_parse_format(struct tep_event_format **eventp,
 		for (field = event->format.fields; field; field = field->next) {
 			arg = alloc_arg();
 			if (!arg) {
-				event->flags |= EVENT_FL_FAILED;
+				event->flags |= TEP_EVENT_FL_FAILED;
 				return TEP_ERRNO__OLD_FTRACE_ARG_FAILED;
 			}
 			arg->type = PRINT_FIELD;
 			arg->field.name = strdup(field->name);
 			if (!arg->field.name) {
-				event->flags |= EVENT_FL_FAILED;
+				event->flags |= TEP_EVENT_FL_FAILED;
 				free_arg(arg);
 				return TEP_ERRNO__OLD_FTRACE_ARG_FAILED;
 			}
@@ -6118,7 +6118,7 @@ enum tep_errno __tep_parse_format(struct tep_event_format **eventp,
 	return 0;
 
  event_parse_failed:
-	event->flags |= EVENT_FL_FAILED;
+	event->flags |= TEP_EVENT_FL_FAILED;
 	return ret;
 
  event_alloc_failed:
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 38b5b1b..9c23bbf 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1750,8 +1750,8 @@ void trace_report (int argc, char **argv)
 			return;
 		}
 
-		set_event_flags(pevent, nohandler_events, EVENT_FL_NOHANDLE);
-		set_event_flags(pevent, raw_events, EVENT_FL_PRINTRAW);
+		set_event_flags(pevent, nohandler_events, TEP_EVENT_FL_NOHANDLE);
+		set_event_flags(pevent, raw_events, TEP_EVENT_FL_PRINTRAW);
 	}
 
 	if (latency_format)
-- 
2.17.1
