Return-Path: <SRS0=AbPd=64=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C8AC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 May 2020 07:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA3E0206B6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 May 2020 07:12:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qxnkj5RB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgENHMs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 May 2020 03:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgENHMs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 May 2020 03:12:48 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA241C061A0C
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 May 2020 00:12:47 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id z22so1729423lfd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 May 2020 00:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ky22I7a1QQ3fpcvuvt7oAfbwXlRZw0yIpzRa2X5tVe4=;
        b=qxnkj5RBYqHp73vcmOtdgUuJpCh8bSHHEDRylVR86qI2LZyQONLQvnUJotLWh3aaJq
         lI7IC/i2WEC5nWm87IY9zRwiYQJx2TlfNr5KfEHukwgY4aY6f5dMU9O7w6fhHMoJwBC0
         ewsupsF2mNlnDOa0ZYOSA+jVtYC6Xfx71LxfZZzyKQIPdtXhwhdWxCmsX1+l1Z0HpJEI
         iXjxQc9Vt+qxucmk9f1FTaklqlsxnF07OGIQM2JH78UsCk12TEkQMYvBcSmRxs6YLjJH
         DBIlDwtFIGjibos3IuSqAoBrfjHVeI5p4zyDEqY6ya2FUpyc5wOfuHirdHCh+abd9+Ll
         uVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ky22I7a1QQ3fpcvuvt7oAfbwXlRZw0yIpzRa2X5tVe4=;
        b=NmCH/RX/5MHnY4Zo/62dCNZjybnt7F1qZIvpJK46bKeuMA6o1hlIRQI5xwsOtyEj6G
         EsUsP5H2W1ur48z2RkxxgCyG5lHKlHPphLLtAn/2LlEczO4qQXAyhN7CSnvxY1VNHj2S
         qLqe+aSlJdBBgA0NvsaNS9LTqjVZnar4eqFD3Oil894mDayP7UvLSppYYOvcVDkul0lE
         z0C/J1u3PYxyNDS5eUnt/k/UEhqK9zavLowqslBmQUVeOIdiTeExCkZt8TCtTObZzGbH
         fScwo5XcyF2hAgiRrGx3huBkTbQLouMVF9Ftzb90MEAmiitMoQf+A0WkEqbHl/yuQ77W
         QWjw==
X-Gm-Message-State: AOAM5302kPZGcfkh2p/pCkO2UFpcY4lE/ep4evExlthoS2wBcIabbPvP
        7/QImrv1vJd9bEDdjcPy3Dg=
X-Google-Smtp-Source: ABdhPJyzYcKNFQlLo67Rz+UwfhMxDj0ZUIqjhgkMwIZsSwjRRpFiDc2n4g0iRS6TuO8utTmLoI8aDA==
X-Received: by 2002:ac2:4286:: with SMTP id m6mr2280201lfh.84.1589440366082;
        Thu, 14 May 2020 00:12:46 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b28sm942832ljo.1.2020.05.14.00.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 00:12:45 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Optimize pretty_print() function
Date:   Thu, 14 May 2020 10:12:43 +0300
Message-Id: <20200514071243.2396492-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Each time the pretty_print() function is called to print an event,
the event's format string is parsed. As this format string does not
change, this parsing can be done only once - when the event struct
is initialized.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
The patch depends on:
  [PATCH v3] trace-cmd: Add support for more printk format specifiers

 include/traceevent/event-parse.h   |   3 +
 lib/traceevent/event-parse-local.h |  17 +
 lib/traceevent/event-parse.c       | 676 ++++++++++++++++++++---------
 3 files changed, 498 insertions(+), 198 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index cfab6005..9560267f 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -259,9 +259,12 @@ struct tep_print_arg {
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
diff --git a/lib/traceevent/event-parse-local.h b/lib/traceevent/event-parse-local.h
index 96a0b0ca..e71296a6 100644
--- a/lib/traceevent/event-parse-local.h
+++ b/lib/traceevent/event-parse-local.h
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
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 707e6786..3821b4da 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -5161,13 +5161,25 @@ static int print_function(struct trace_seq *s, const char *format,
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
@@ -5203,231 +5215,495 @@ static int print_pointer(struct trace_seq *s, const char *format, int plen,
 
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
+		/* MF */
+		if (format[1] == 'F')
+			ret++;
+		/* fall through */
+	case 'm':
+		/* [mM]R */
+		if (format[1] == 'R')
+			ret++;
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
+			if (format[index] == 'c') {
+				ret++;
+				index++;
+			}
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
+	struct tep_print_parse *parg = NULL, *last;
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
+
+	last = *parse;
+	if (last) {
+		while (last->next)
+			last = last->next;
+		last->next = parg;
+	} else
+		*parse = parg;
+
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
+	if (*format != '%')
+		return ret;
+	format++;
+
+	/* %% */
+	if (*format == '%')
+		return ret;
+	ret++;
+
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
+			if (!arg) {
+				do_warning_event(event, "no argument match");
+				event->flags |= TEP_EVENT_FL_FAILED;
+				goto out_failed;
+			}
+			len_arg = *arg;
+			*arg = (*arg)->next;
+			break;
+		case 'p':
+			if (!*arg)
+				goto out_failed;
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
+			if (!arg) {
+				do_warning_event(event, "no argument match");
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
+			if (!arg) {
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
+	return ret;
+out_failed:
+	return -1;
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
-
-				val = eval_num_arg(data, size, event, arg);
-				arg = arg->next;
+		} else
+			trace_seq_putc(&s, *format);
 
-				if (tep->long_size == 8 && ls == 1 &&
-				    sizeof(long) != 8) {
-					char *p;
+		ret++;
+	}
+	trace_seq_terminate(&s);
+	parse_arg_add(parse, s.buffer, PRINT_FMT_STING, NULL, NULL, 0);
+	trace_seq_destroy(&s);
 
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
+	return ret;
+}
 
-				len = ((unsigned long)ptr + 1) -
-					(unsigned long)saveptr;
+static struct tep_print_parse *
+parse_args(struct tep_event *event, const char *format, struct tep_print_arg *arg)
+{
+	struct tep_print_parse *parse = NULL;
+	int ret;
+	int len;
 
-				/* should never happen */
-				if (len > 31) {
-					do_warning_event(event, "bad format!");
-					event->flags |= TEP_EVENT_FL_FAILED;
-					len = 31;
-				}
+	len = strlen(format);
+	while (*format) {
+		if (*format == '%' && *(format + 1) != '%')
+			ret = parse_arg_format(&parse, event, format, &arg);
+		else
+			ret = parse_arg_string(&parse, format);
+		len -= ret;
+		if (len > 0)
+			format += ret;
+		else
+			break;
+	}
+	return parse;
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
 	}
 
-	if (args) {
+	if (event->flags & TEP_EVENT_FL_ISBPRINT) {
+		bprint_fmt = get_bprint_format(data, size, event);
+		args = make_bprint_args(bprint_fmt, data, size, event);
+		parse = parse_args(event, bprint_fmt, args);
+	}
+
+	print_event_cache(parse, s, data, size, event);
+
+	if (event->flags & TEP_EVENT_FL_ISBPRINT) {
+		free_parse_args(parse);
 		free_args(args);
 		free(bprint_fmt);
 	}
@@ -6526,9 +6802,13 @@ enum tep_errno __tep_parse_format(struct tep_event **eventp,
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
@@ -7195,7 +7475,7 @@ void tep_free_event(struct tep_event *event)
 
 	free(event->print_fmt.format);
 	free_args(event->print_fmt.args);
-
+	free_parse_args(event->print_fmt.print_cache);
 	free(event);
 }
 
-- 
2.26.2

