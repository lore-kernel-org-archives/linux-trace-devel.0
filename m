Return-Path: <SRS0=XgcI=BB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD229C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 01:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99CEE207DD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 01:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731669AbgGVBR5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 Jul 2020 21:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731570AbgGVBR4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Jul 2020 21:17:56 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B1C521702;
        Wed, 22 Jul 2020 01:17:54 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jy3OL-005sAv-Ga; Tue, 21 Jul 2020 21:17:53 -0400
Message-ID: <20200722011753.377499000@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 21 Jul 2020 21:16:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 07/23 v3] tools lib traceevent: Optimize pretty_print() function
References: <20200722011628.925541477@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

Each time the pretty_print() function is called to print an event,
the event's format string is parsed. As this format string does not
change, this parsing can be done only once - when the event struct
is initialized.

Link: https://lore.kernel.org/linux-trace-devel/20200529134929.537110-1-tz.stoyanov@gmail.com
Link: http://lore.kernel.org/linux-trace-devel/20200625100516.365338-8-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse-local.h |  17 +
 tools/lib/traceevent/event-parse.c       | 672 ++++++++++++++++-------
 tools/lib/traceevent/event-parse.h       |   3 +
 3 files changed, 495 insertions(+), 197 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
index 96a0b0ca0675..e71296a62236 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -85,6 +85,23 @@ struct tep_handle {
 	struct tep_plugins_dir *plugins_dir;
 };
 
+enum tep_print_parse_type {
+	PRINT_FMT_STING,
+	PRINT_FMT_ARG_DIGIT,
+	PRINT_FMT_ARG_POINTER,
+	PRINT_FMT_ARG_STRING,
+};
+
+struct tep_print_parse {
+	struct tep_print_parse	*next;
+
+	char				*format;
+	int				ls;
+	enum tep_print_parse_type	type;
+	struct tep_print_arg		*arg;
+	struct tep_print_arg		*len_as_arg;
+};
+
 void tep_free_event(struct tep_event *event);
 void tep_free_format_field(struct tep_format_field *field);
 void tep_free_plugin_paths(struct tep_handle *tep);
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 3990024d2a98..ee16be96697b 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5215,13 +5215,25 @@ static int print_function(struct trace_seq *s, const char *format,
 	return 0;
 }
 
-static int print_pointer(struct trace_seq *s, const char *format, int plen,
-			 void *data, int size,
-			 struct tep_event *event, struct tep_print_arg *arg)
+static int print_arg_pointer(struct trace_seq *s, const char *format, int plen,
+			     void *data, int size,
+			     struct tep_event *event, struct tep_print_arg *arg)
 {
 	unsigned long long val;
 	int ret = 1;
 
+	if (arg->type == TEP_PRINT_BSTRING) {
+		trace_seq_puts(s, arg->string.string);
+		return 0;
+	}
+	while (*format) {
+		if (*format == 'p') {
+			format++;
+			break;
+		}
+		format++;
+	}
+
 	switch (*format) {
 	case 'F':
 	case 'f':
@@ -5254,231 +5266,493 @@ static int print_pointer(struct trace_seq *s, const char *format, int plen,
 
 }
 
-static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_event *event)
+static int print_arg_number(struct trace_seq *s, const char *format, int plen,
+			    void *data, int size, int ls,
+			    struct tep_event *event, struct tep_print_arg *arg)
 {
-	struct tep_handle *tep = event->tep;
-	struct tep_print_fmt *print_fmt = &event->print_fmt;
-	struct tep_print_arg *arg = print_fmt->args;
-	struct tep_print_arg *args = NULL;
-	const char *ptr = print_fmt->format;
 	unsigned long long val;
-	const char *saveptr;
+
+	val = eval_num_arg(data, size, event, arg);
+
+	switch (ls) {
+	case -2:
+		if (plen >= 0)
+			trace_seq_printf(s, format, plen, (char)val);
+		else
+			trace_seq_printf(s, format, (char)val);
+		break;
+	case -1:
+		if (plen >= 0)
+			trace_seq_printf(s, format, plen, (short)val);
+		else
+			trace_seq_printf(s, format, (short)val);
+		break;
+	case 0:
+		if (plen >= 0)
+			trace_seq_printf(s, format, plen, (int)val);
+		else
+			trace_seq_printf(s, format, (int)val);
+		break;
+	case 1:
+		if (plen >= 0)
+			trace_seq_printf(s, format, plen, (long)val);
+		else
+			trace_seq_printf(s, format, (long)val);
+		break;
+	case 2:
+		if (plen >= 0)
+			trace_seq_printf(s, format, plen, (long long)val);
+		else
+			trace_seq_printf(s, format, (long long)val);
+		break;
+	default:
+		do_warning_event(event, "bad count (%d)", ls);
+		event->flags |= TEP_EVENT_FL_FAILED;
+	}
+	return 0;
+}
+
+
+static void print_arg_string(struct trace_seq *s, const char *format, int plen,
+			     void *data, int size,
+			     struct tep_event *event, struct tep_print_arg *arg)
+{
 	struct trace_seq p;
-	char *bprint_fmt = NULL;
-	char format[32];
-	int len_as_arg;
-	int len_arg = 0;
-	int len;
-	int ls;
-	int ret;
 
-	if (event->flags & TEP_EVENT_FL_FAILED) {
-		trace_seq_printf(s, "[FAILED TO PARSE]");
-		tep_print_fields(s, data, size, event);
-		return;
+	/* Use helper trace_seq */
+	trace_seq_init(&p);
+	print_str_arg(&p, data, size, event,
+		      format, plen, arg);
+	trace_seq_terminate(&p);
+	trace_seq_puts(s, p.buffer);
+	trace_seq_destroy(&p);
+}
+
+static int parse_arg_format_pointer(const char *format)
+{
+	int ret = 0;
+	int index;
+	int loop;
+
+	switch (*format) {
+	case 'F':
+	case 'S':
+	case 'f':
+	case 's':
+		ret++;
+		break;
+	case 'M':
+	case 'm':
+		/* [mM]R , [mM]F */
+		switch (format[1]) {
+		case 'R':
+		case 'F':
+			ret++;
+			break;
+		}
+		ret++;
+		break;
+	case 'I':
+	case 'i':
+		index = 2;
+		loop = 1;
+		switch (format[1]) {
+		case 'S':
+			/*[S][pfs]*/
+			while (loop) {
+				switch (format[index]) {
+				case 'p':
+				case 'f':
+				case 's':
+					ret++;
+					index++;
+					break;
+				default:
+					loop = 0;
+					break;
+				}
+			}
+			/* fall through */
+		case '4':
+			/* [4S][hnbl] */
+			switch (format[index]) {
+			case 'h':
+			case 'n':
+			case 'l':
+			case 'b':
+				ret++;
+				index++;
+				break;
+			}
+			if (format[1] == '4') {
+				ret++;
+				break;
+			}
+			/* fall through */
+		case '6':
+			/* [6S]c */
+			if (format[index] == 'c')
+				ret++;
+			ret++;
+			break;
+		}
+		ret++;
+		break;
+	case 'U':
+		switch (format[1]) {
+		case 'L':
+		case 'l':
+		case 'B':
+		case 'b':
+			ret++;
+			break;
+		}
+		ret++;
+		break;
+	case 'h':
+		switch (format[1]) {
+		case 'C':
+		case 'D':
+		case 'N':
+			ret++;
+			break;
+		}
+		ret++;
+		break;
+	default:
+		break;
 	}
 
-	if (event->flags & TEP_EVENT_FL_ISBPRINT) {
-		bprint_fmt = get_bprint_format(data, size, event);
-		args = make_bprint_args(bprint_fmt, data, size, event);
-		arg = args;
-		ptr = bprint_fmt;
+	return ret;
+}
+
+static void free_parse_args(struct tep_print_parse *arg)
+{
+	struct tep_print_parse *del;
+
+	while (arg) {
+		del = arg;
+		arg = del->next;
+		free(del->format);
+		free(del);
 	}
+}
 
-	for (; *ptr; ptr++) {
-		ls = 0;
-		if (*ptr == '\\') {
-			ptr++;
-			switch (*ptr) {
+static int parse_arg_add(struct tep_print_parse **parse, char *format,
+			 enum tep_print_parse_type type,
+			 struct tep_print_arg *arg,
+			 struct tep_print_arg *len_as_arg,
+			 int ls)
+{
+	struct tep_print_parse *parg = NULL;
+
+	parg = calloc(1, sizeof(*parg));
+	if (!parg)
+		goto error;
+	parg->format = strdup(format);
+	if (!parg->format)
+		goto error;
+	parg->type = type;
+	parg->arg = arg;
+	parg->len_as_arg = len_as_arg;
+	parg->ls = ls;
+	*parse = parg;
+	return 0;
+error:
+	if (parg) {
+		free(parg->format);
+		free(parg);
+	}
+	return -1;
+}
+
+static int parse_arg_format(struct tep_print_parse **parse,
+			    struct tep_event *event,
+			    const char *format, struct tep_print_arg **arg)
+{
+	struct tep_print_arg *len_arg = NULL;
+	char print_format[32];
+	const char *start = format;
+	int ret = 0;
+	int ls = 0;
+	int res;
+	int len;
+
+	format++;
+	ret++;
+	for (; *format; format++) {
+		switch (*format) {
+		case '#':
+			/* FIXME: need to handle properly */
+			break;
+		case 'h':
+			ls--;
+			break;
+		case 'l':
+			ls++;
+			break;
+		case 'L':
+			ls = 2;
+			break;
+		case '.':
+		case 'z':
+		case 'Z':
+		case '0' ... '9':
+		case '-':
+			break;
+		case '*':
+			/* The argument is the length. */
+			if (!*arg) {
+				do_warning_event(event, "no argument match");
+				event->flags |= TEP_EVENT_FL_FAILED;
+				goto out_failed;
+			}
+			if (len_arg) {
+				do_warning_event(event, "argument already matched");
+				event->flags |= TEP_EVENT_FL_FAILED;
+				goto out_failed;
+			}
+			len_arg = *arg;
+			*arg = (*arg)->next;
+			break;
+		case 'p':
+			if (!*arg) {
+				do_warning_event(event, "no argument match");
+				event->flags |= TEP_EVENT_FL_FAILED;
+				goto out_failed;
+			}
+			res = parse_arg_format_pointer(format + 1);
+			if (res > 0) {
+				format += res;
+				ret += res;
+			}
+			len = ((unsigned long)format + 1) -
+				(unsigned long)start;
+			/* should never happen */
+			if (len > 31) {
+				do_warning_event(event, "bad format!");
+				event->flags |= TEP_EVENT_FL_FAILED;
+				len = 31;
+			}
+			memcpy(print_format, start, len);
+			print_format[len] = 0;
+
+			parse_arg_add(parse, print_format,
+				      PRINT_FMT_ARG_POINTER, *arg, len_arg, ls);
+			*arg = (*arg)->next;
+			ret++;
+			return ret;
+		case 'd':
+		case 'u':
+		case 'i':
+		case 'x':
+		case 'X':
+		case 'o':
+			if (!*arg) {
+				do_warning_event(event, "no argument match");
+				event->flags |= TEP_EVENT_FL_FAILED;
+				goto out_failed;
+			}
+
+			len = ((unsigned long)format + 1) -
+				(unsigned long)start;
+
+			/* should never happen */
+			if (len > 30) {
+				do_warning_event(event, "bad format!");
+				event->flags |= TEP_EVENT_FL_FAILED;
+				len = 31;
+			}
+			memcpy(print_format, start, len);
+			print_format[len] = 0;
+
+			if (event->tep->long_size == 8 && ls == 1 &&
+			    sizeof(long) != 8) {
+				char *p;
+
+				/* make %l into %ll */
+				if (ls == 1 && (p = strchr(print_format, 'l')))
+					memmove(p+1, p, strlen(p)+1);
+				ls = 2;
+			}
+			if (ls < -2 || ls > 2) {
+				do_warning_event(event, "bad count (%d)", ls);
+				event->flags |= TEP_EVENT_FL_FAILED;
+			}
+			parse_arg_add(parse, print_format,
+				      PRINT_FMT_ARG_DIGIT, *arg, len_arg, ls);
+			*arg = (*arg)->next;
+			ret++;
+			return ret;
+		case 's':
+			if (!*arg) {
+				do_warning_event(event, "no matching argument");
+				event->flags |= TEP_EVENT_FL_FAILED;
+				goto out_failed;
+			}
+
+			len = ((unsigned long)format + 1) -
+				(unsigned long)start;
+
+			/* should never happen */
+			if (len > 31) {
+				do_warning_event(event, "bad format!");
+				event->flags |= TEP_EVENT_FL_FAILED;
+				len = 31;
+			}
+
+			memcpy(print_format, start, len);
+			print_format[len] = 0;
+
+			parse_arg_add(parse, print_format,
+					PRINT_FMT_ARG_STRING, *arg, len_arg, 0);
+			*arg = (*arg)->next;
+			ret++;
+			return ret;
+		default:
+			snprintf(print_format, 32, ">%c<", *format);
+			parse_arg_add(parse, print_format,
+					PRINT_FMT_STING, NULL, NULL, 0);
+			ret++;
+			return ret;
+		}
+		ret++;
+	}
+
+out_failed:
+	return ret;
+
+}
+
+static int parse_arg_string(struct tep_print_parse **parse, const char *format)
+{
+	struct trace_seq s;
+	int ret = 0;
+
+	trace_seq_init(&s);
+	for (; *format; format++) {
+		if (*format == '\\') {
+			format++;
+			ret++;
+			switch (*format) {
 			case 'n':
-				trace_seq_putc(s, '\n');
+				trace_seq_putc(&s, '\n');
 				break;
 			case 't':
-				trace_seq_putc(s, '\t');
+				trace_seq_putc(&s, '\t');
 				break;
 			case 'r':
-				trace_seq_putc(s, '\r');
+				trace_seq_putc(&s, '\r');
 				break;
 			case '\\':
-				trace_seq_putc(s, '\\');
+				trace_seq_putc(&s, '\\');
 				break;
 			default:
-				trace_seq_putc(s, *ptr);
+				trace_seq_putc(&s, *format);
 				break;
 			}
-
-		} else if (*ptr == '%') {
-			saveptr = ptr;
-			len_as_arg = 0;
- cont_process:
-			ptr++;
-			switch (*ptr) {
-			case '%':
-				trace_seq_putc(s, '%');
-				break;
-			case '#':
-				/* FIXME: need to handle properly */
-				goto cont_process;
-			case 'h':
-				ls--;
-				goto cont_process;
-			case 'l':
-				ls++;
-				goto cont_process;
-			case 'L':
-				ls = 2;
-				goto cont_process;
-			case '*':
-				/* The argument is the length. */
-				if (!arg) {
-					do_warning_event(event, "no argument match");
-					event->flags |= TEP_EVENT_FL_FAILED;
-					goto out_failed;
-				}
-				len_arg = eval_num_arg(data, size, event, arg);
-				len_as_arg = 1;
-				arg = arg->next;
-				goto cont_process;
-			case '.':
-			case 'z':
-			case 'Z':
-			case '0' ... '9':
-			case '-':
-				goto cont_process;
-			case 'p':
-				if (arg->type == TEP_PRINT_BSTRING) {
-					if (isalnum(ptr[1]))
-						ptr++;
-					trace_seq_puts(s, arg->string.string);
-					arg = arg->next;
-					break;
-				}
-				ret = print_pointer(s, ptr + 1,
-						    len_as_arg ? len_arg : 1,
-						    data, size,
-						    event, arg);
-				arg = arg->next;
-				if (ret > 0)
-					ptr += ret;
+		} else if (*format == '%') {
+			if (*(format + 1) == '%') {
+				trace_seq_putc(&s, '%');
+				format++;
+				ret++;
+			} else
 				break;
-			case 'd':
-			case 'u':
-			case 'i':
-			case 'x':
-			case 'X':
-			case 'o':
-				if (!arg) {
-					do_warning_event(event, "no argument match");
-					event->flags |= TEP_EVENT_FL_FAILED;
-					goto out_failed;
-				}
-
-				len = ((unsigned long)ptr + 1) -
-					(unsigned long)saveptr;
-
-				/* should never happen */
-				if (len > 31) {
-					do_warning_event(event, "bad format!");
-					event->flags |= TEP_EVENT_FL_FAILED;
-					len = 31;
-				}
-
-				memcpy(format, saveptr, len);
-				format[len] = 0;
+		} else
+			trace_seq_putc(&s, *format);
 
-				val = eval_num_arg(data, size, event, arg);
-				arg = arg->next;
+		ret++;
+	}
+	trace_seq_terminate(&s);
+	parse_arg_add(parse, s.buffer, PRINT_FMT_STING, NULL, NULL, 0);
+	trace_seq_destroy(&s);
 
-				if (tep->long_size == 8 && ls == 1 &&
-				    sizeof(long) != 8) {
-					char *p;
+	return ret;
+}
 
-					/* make %l into %ll */
-					if (ls == 1 && (p = strchr(format, 'l')))
-						memmove(p+1, p, strlen(p)+1);
-					ls = 2;
-				}
-				switch (ls) {
-				case -2:
-					if (len_as_arg)
-						trace_seq_printf(s, format, len_arg, (char)val);
-					else
-						trace_seq_printf(s, format, (char)val);
-					break;
-				case -1:
-					if (len_as_arg)
-						trace_seq_printf(s, format, len_arg, (short)val);
-					else
-						trace_seq_printf(s, format, (short)val);
-					break;
-				case 0:
-					if (len_as_arg)
-						trace_seq_printf(s, format, len_arg, (int)val);
-					else
-						trace_seq_printf(s, format, (int)val);
-					break;
-				case 1:
-					if (len_as_arg)
-						trace_seq_printf(s, format, len_arg, (long)val);
-					else
-						trace_seq_printf(s, format, (long)val);
-					break;
-				case 2:
-					if (len_as_arg)
-						trace_seq_printf(s, format, len_arg,
-								 (long long)val);
-					else
-						trace_seq_printf(s, format, (long long)val);
-					break;
-				default:
-					do_warning_event(event, "bad count (%d)", ls);
-					event->flags |= TEP_EVENT_FL_FAILED;
-				}
-				break;
-			case 's':
-				if (!arg) {
-					do_warning_event(event, "no matching argument");
-					event->flags |= TEP_EVENT_FL_FAILED;
-					goto out_failed;
-				}
+static struct tep_print_parse *
+parse_args(struct tep_event *event, const char *format, struct tep_print_arg *arg)
+{
+	struct tep_print_parse *parse_ret = NULL;
+	struct tep_print_parse **parse = NULL;
+	int ret;
+	int len;
 
-				len = ((unsigned long)ptr + 1) -
-					(unsigned long)saveptr;
+	len = strlen(format);
+	while (*format) {
+		if (!parse_ret)
+			parse = &parse_ret;
+		if (*format == '%' && *(format + 1) != '%')
+			ret = parse_arg_format(parse, event, format, &arg);
+		else
+			ret = parse_arg_string(parse, format);
+		if (*parse)
+			parse = &((*parse)->next);
 
-				/* should never happen */
-				if (len > 31) {
-					do_warning_event(event, "bad format!");
-					event->flags |= TEP_EVENT_FL_FAILED;
-					len = 31;
-				}
+		len -= ret;
+		if (len > 0)
+			format += ret;
+		else
+			break;
+	}
+	return parse_ret;
+}
 
-				memcpy(format, saveptr, len);
-				format[len] = 0;
-				if (!len_as_arg)
-					len_arg = -1;
-				/* Use helper trace_seq */
-				trace_seq_init(&p);
-				print_str_arg(&p, data, size, event,
-					      format, len_arg, arg);
-				trace_seq_terminate(&p);
-				trace_seq_puts(s, p.buffer);
-				trace_seq_destroy(&p);
-				arg = arg->next;
-				break;
-			default:
-				trace_seq_printf(s, ">%c<", *ptr);
+static void print_event_cache(struct tep_print_parse *parse, struct trace_seq *s,
+			      void *data, int size, struct tep_event *event)
+{
+	int len_arg;
 
-			}
-		} else
-			trace_seq_putc(s, *ptr);
+	while (parse) {
+		if (parse->len_as_arg)
+			len_arg = eval_num_arg(data, size, event, parse->len_as_arg);
+		switch (parse->type) {
+		case PRINT_FMT_ARG_DIGIT:
+			print_arg_number(s, parse->format,
+					parse->len_as_arg ? len_arg : -1, data,
+					 size, parse->ls, event, parse->arg);
+			break;
+		case PRINT_FMT_ARG_POINTER:
+			print_arg_pointer(s, parse->format,
+					  parse->len_as_arg ? len_arg : 1,
+					  data, size, event, parse->arg);
+			break;
+		case PRINT_FMT_ARG_STRING:
+			print_arg_string(s, parse->format,
+					 parse->len_as_arg ? len_arg : -1,
+					 data, size, event, parse->arg);
+			break;
+		case PRINT_FMT_STING:
+		default:
+			trace_seq_printf(s, "%s", parse->format);
+			break;
+		}
+		parse = parse->next;
 	}
+}
+
+static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_event *event)
+{
+	struct tep_print_parse *parse = event->print_fmt.print_cache;
+	struct tep_print_arg *args = NULL;
+	char *bprint_fmt = NULL;
 
 	if (event->flags & TEP_EVENT_FL_FAILED) {
-out_failed:
 		trace_seq_printf(s, "[FAILED TO PARSE]");
+		tep_print_fields(s, data, size, event);
+		return;
+	}
+
+	if (event->flags & TEP_EVENT_FL_ISBPRINT) {
+		bprint_fmt = get_bprint_format(data, size, event);
+		args = make_bprint_args(bprint_fmt, data, size, event);
+		parse = parse_args(event, bprint_fmt, args);
 	}
 
-	if (args) {
+	print_event_cache(parse, s, data, size, event);
+
+	if (event->flags & TEP_EVENT_FL_ISBPRINT) {
+		free_parse_args(parse);
 		free_args(args);
 		free(bprint_fmt);
 	}
@@ -6577,9 +6851,13 @@ enum tep_errno __tep_parse_format(struct tep_event **eventp,
 			*list = arg;
 			list = &arg->next;
 		}
-		return 0;
 	}
 
+	if (!(event->flags & TEP_EVENT_FL_ISBPRINT))
+		event->print_fmt.print_cache = parse_args(event,
+							  event->print_fmt.format,
+							  event->print_fmt.args);
+
 	return 0;
 
  event_parse_failed:
@@ -7246,7 +7524,7 @@ void tep_free_event(struct tep_event *event)
 
 	free(event->print_fmt.format);
 	free_args(event->print_fmt.args);
-
+	free_parse_args(event->print_fmt.print_cache);
 	free(event);
 }
 
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 91f462f5a606..ac162472268b 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -272,9 +272,12 @@ struct tep_print_arg {
 	};
 };
 
+struct tep_print_parse;
+
 struct tep_print_fmt {
 	char			*format;
 	struct tep_print_arg	*args;
+	struct tep_print_parse	*print_cache;
 };
 
 struct tep_event {
-- 
2.26.2


