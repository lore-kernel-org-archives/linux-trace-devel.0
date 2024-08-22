Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14494125AC
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Aug 2024 21:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724362174; cv=none; b=dnIas38uTVWZ2bvOl7hWdH1L3wIEWvrYVR33oAoQFUtDQYiiR2yP8y8xCfuJhPnEsuEnfTlj6wyvGLwxqEDtPvKYl3DL4PaQAy/rwXkLBi4pTFFsCsGqQfrzyTlgV5i1lRfoRxSAixT+YXwjN4VmFGhkxtyfIHuINaoUug0Kx00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724362174; c=relaxed/simple;
	bh=ZUmFVUp9LobZeeAQj1V5SPPiscGr6RNY1k0dObvZd9o=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=WXgibsdviOOsNAVgqgAjHN/5aXYBak8XM/0P+ZIDb+GyCq9hdtAGK2FY40Ka72i8TJFNkQ382S11fmN8ke4DZxDCRT/b9mLlTFc8gfWfsSjgM70cyi+kffledjET7Nr4f4RTQn3LcCZ/DHXHV4PiAl0rY1FaqZIMKwNovH713Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E62C32782
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Aug 2024 21:29:32 +0000 (UTC)
Date: Thu, 22 Aug 2024 17:30:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Print function pointer address when
 TEP_EVENT_FL_PRINTRAW is specified
Message-ID: <20240822173003.773f498e@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When the TEP_EVENT_FL_PRINTRAW flag is specified in print_event_info(),
print function pointer addresses and not just the function pointer itself.

That is, instead of having just:

    ip=trace_printk_irq_work

Print:

    ip=trace_printk_irq_work (0xffffffffc06d0028)

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index ba4a15337d80..ddeb3b9909c0 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -6001,11 +6001,11 @@ static void print_field_raw(struct trace_seq *s, void *data, int size,
 }
 
 static int print_parse_data(struct tep_print_parse *parse, struct trace_seq *s,
-			    void *data, int size, struct tep_event *event);
+			    void *data, int size, struct tep_event *event, bool raw);
 
 static inline void print_field(struct trace_seq *s, void *data, int size,
 				    struct tep_format_field *field,
-				    struct tep_print_parse **parse_ptr)
+				    struct tep_print_parse **parse_ptr, bool raw)
 {
 	struct tep_event *event = field->event;
 	struct tep_print_parse *start_parse;
@@ -6049,7 +6049,7 @@ static inline void print_field(struct trace_seq *s, void *data, int size,
 		if (has_0x)
 			trace_seq_puts(s, "0x");
 
-		print_parse_data(parse, s, data, size, event);
+		print_parse_data(parse, s, data, size, event, raw);
 
 		if (parse_ptr)
 			*parse_ptr = parse->next;
@@ -6081,7 +6081,7 @@ static inline void print_field(struct trace_seq *s, void *data, int size,
 void tep_print_field_content(struct trace_seq *s, void *data, int size,
 			     struct tep_format_field *field)
 {
-	print_field(s, data, size, field, NULL);
+	print_field(s, data, size, field, NULL, false);
 }
 
 /** DEPRECATED **/
@@ -6089,13 +6089,13 @@ void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field)
 {
 	/* unsafe to use, should pass in size */
-	print_field(s, data, 4096, field, NULL);
+	print_field(s, data, 4096, field, NULL, false);
 }
 
 static inline void
 print_selected_fields(struct trace_seq *s, void *data, int size,
 		      struct tep_event *event,
-		      unsigned long long ignore_mask)
+		      unsigned long long ignore_mask, bool raw)
 {
 	struct tep_print_parse *parse = event->print_fmt.print_cache;
 	struct tep_format_field *field;
@@ -6107,14 +6107,14 @@ print_selected_fields(struct trace_seq *s, void *data, int size,
 			continue;
 
 		trace_seq_printf(s, " %s=", field->name);
-		print_field(s, data, size, field, &parse);
+		print_field(s, data, size, field, &parse, raw);
 	}
 }
 
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size, struct tep_event *event)
 {
-	print_selected_fields(s, data, size, event, 0);
+	print_selected_fields(s, data, size, event, 0, false);
 }
 
 /**
@@ -6128,7 +6128,7 @@ void tep_record_print_fields(struct trace_seq *s,
 			     struct tep_record *record,
 			     struct tep_event *event)
 {
-	print_selected_fields(s, record->data, record->size, event, 0);
+	print_selected_fields(s, record->data, record->size, event, 0, false);
 }
 
 /**
@@ -6146,12 +6146,12 @@ void tep_record_print_selected_fields(struct trace_seq *s,
 {
 	unsigned long long ignore_mask = ~select_mask;
 
-	print_selected_fields(s, record->data, record->size, event, ignore_mask);
+	print_selected_fields(s, record->data, record->size, event, ignore_mask, false);
 }
 
 static int print_function(struct trace_seq *s, const char *format,
 			  void *data, int size, struct tep_event *event,
-			  struct tep_print_arg *arg)
+			  struct tep_print_arg *arg, bool raw)
 {
 	struct func_map *func;
 	unsigned long long val;
@@ -6162,11 +6162,17 @@ static int print_function(struct trace_seq *s, const char *format,
 		trace_seq_puts(s, func->func);
 		if (*format == 'F' || *format == 'S')
 			trace_seq_printf(s, "+0x%llx", val - func->addr);
-	} else {
+	}
+
+	if (!func || raw) {
+		if (raw)
+			trace_seq_puts(s, " (");
 		if (event->tep->long_size == 4)
 			trace_seq_printf(s, "0x%lx", (long)val);
 		else
 			trace_seq_printf(s, "0x%llx", (long long)val);
+		if (raw)
+			trace_seq_puts(s, ")");
 	}
 
 	return 0;
@@ -6174,7 +6180,8 @@ static int print_function(struct trace_seq *s, const char *format,
 
 static int print_arg_pointer(struct trace_seq *s, const char *format, int plen,
 			     void *data, int size,
-			     struct tep_event *event, struct tep_print_arg *arg)
+			     struct tep_event *event, struct tep_print_arg *arg,
+			     bool raw)
 {
 	unsigned long long val;
 	int ret = 1;
@@ -6196,7 +6203,7 @@ static int print_arg_pointer(struct trace_seq *s, const char *format, int plen,
 	case 'f':
 	case 'S':
 	case 's':
-		ret += print_function(s, format, data, size, event, arg);
+		ret += print_function(s, format, data, size, event, arg, raw);
 		break;
 	case 'M':
 	case 'm':
@@ -6660,7 +6667,7 @@ parse_args(struct tep_event *event, const char *format, struct tep_print_arg *ar
 }
 
 static int print_parse_data(struct tep_print_parse *parse, struct trace_seq *s,
-			    void *data, int size, struct tep_event *event)
+			    void *data, int size, struct tep_event *event, bool raw)
 {
 	int len_arg;
 
@@ -6676,7 +6683,7 @@ static int print_parse_data(struct tep_print_parse *parse, struct trace_seq *s,
 	case PRINT_FMT_ARG_POINTER:
 		print_arg_pointer(s, parse->format,
 				  parse->len_as_arg ? len_arg : 1,
-				  data, size, event, parse->arg);
+				  data, size, event, parse->arg, raw);
 		break;
 	case PRINT_FMT_ARG_STRING:
 		print_arg_string(s, parse->format,
@@ -6697,7 +6704,7 @@ static void print_event_cache(struct tep_print_parse *parse, struct trace_seq *s
 			      void *data, int size, struct tep_event *event)
 {
 	while (parse) {
-		print_parse_data(parse, s, data, size, event);
+		print_parse_data(parse, s, data, size, event, false);
 		parse = parse->next;
 	}
 }
@@ -7004,7 +7011,7 @@ static void print_event_info(struct trace_seq *s, char *format, bool raw,
 	int print_pretty = 1;
 
 	if (raw || (event->flags & TEP_EVENT_FL_PRINTRAW))
-		tep_print_fields(s, record->data, record->size, event);
+		print_selected_fields(s, record->data, record->size, event, 0, true);
 	else {
 
 		if (event->handler && !(event->flags & TEP_EVENT_FL_NOHANDLE))
-- 
2.43.0

