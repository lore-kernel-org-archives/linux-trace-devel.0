Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3A6C63777
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 08:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CDF124656
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 08:19:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VODMwAA6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgKQITd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 03:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKQITd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 03:19:33 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4517DC0613CF
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Nov 2020 00:19:33 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id o15so22233638wru.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Nov 2020 00:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xmSf9+57/owZp1SjBDTzpJ7FS199nYH1HKTy9HrbKOY=;
        b=VODMwAA6akiwqoUJRH4QPQij2Ou+Dxpm8G0ICfSGqxVZqgY+cvEJwHZTMV3G6qq+aG
         4y1zgcZVPT8jSKgQqPWcALGsY6o6Cg0q5qREq1MTX5mzKoXZFRam6DI+GMbD0t+4oeww
         OlhfmJSjwy8HapS/sgbWQeIcRo6WTKmKoAsLL7oylVJ7FbM0MzSNTrkEEUAYtUtozs/l
         QA0QoXTmuDUpAt6lwZzlFsVbhCC7Rd7uLRNZbiXu/2Oa9PjvqclxmMEZjeyYR/jEVKNZ
         vHZEnkQ/H5UVrJRmGc7Vv50Z4rUjqghVNuqf3k9Q8t+w9102DZ/q1d7edbL8/Qu21IXY
         kvAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xmSf9+57/owZp1SjBDTzpJ7FS199nYH1HKTy9HrbKOY=;
        b=bjw4Ry07U1Ozn5wtyiydkQjIJIYNJry1Bn5ZECuJZ4CC2NCD24vqPFuLdJ6hTEUcsQ
         WhvvOw9qeD2MOeHVWn3VjXk/WXDJnWeGZw3C2KT7jm7Inexc0TTRjCRtrUNhOsrbnkvV
         u+qKqgpYgbwBO+iDkEwV0ZGqXt0XpMxEPpjAgY+hEB8pI+q2s3fVah1OTs5lAr131smY
         VctwpYiwMxQlIt9qPNieEAe/mZc41tMRy6htnyIT5varKcR5j0Dc/gTI3NQHFsMGhB2x
         nFVzh3VJMUeCFVISh3CIoWCuVJ6XtLa+PpvK8dTDb9jVcW8p0BL76rJtSbNeeA849j1U
         RSxg==
X-Gm-Message-State: AOAM532Z9xM6GB8x82L/3YmUBPnmJJjd9QOv/TkYWXLBp9doi4EfV47a
        BNlwLLR9hNi50cy+JHoOKrjAFlbERNQV0qJn
X-Google-Smtp-Source: ABdhPJzbqlqsIBa58E6xUqaxAUJSf53yVeBeV8LLiLFBO06LYM3z2x+HLdrO1k+3Lf6WNMkO2Nf5jg==
X-Received: by 2002:adf:ea91:: with SMTP id s17mr23920589wrm.349.1605601171921;
        Tue, 17 Nov 2020 00:19:31 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v2sm25786541wrm.96.2020.11.17.00.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 00:19:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] lib traceevent: Hide non API functions
Date:   Tue, 17 Nov 2020 10:19:29 +0200
Message-Id: <20201117081929.185883-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are internal library functions, which are not declared as a static.
They are used inside the library from different files. Hide them from
the library users, as they are not part of the API.
These functions are made hidden and are renamed without the prefix "tep_":
 tep_free_plugin_paths
 tep_peek_char
 tep_buffer_init
 tep_get_input_buf_ptr
 tep_get_input_buf
 tep_read_token
 tep_free_token
 tep_free_event
 tep_free_format_field
 __tep_parse_format

Link: https://lore.kernel.org/linux-trace-devel/e4afdd82deb5e023d53231bb13e08dca78085fb0.camel@decadent.org.uk/
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200930110733.280534-1-tz.stoyanov@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h   |   8 --
 lib/traceevent/event-parse-api.c   |   8 +-
 lib/traceevent/event-parse-local.h |  24 ++++--
 lib/traceevent/event-parse.c       | 125 ++++++++++++-----------------
 lib/traceevent/event-plugin.c      |   2 +-
 lib/traceevent/parse-filter.c      |  23 +++---
 6 files changed, 83 insertions(+), 107 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 9560267f..7cdbda24 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -579,14 +579,6 @@ void tep_ref(struct tep_handle *tep);
 void tep_unref(struct tep_handle *tep);
 int tep_get_ref(struct tep_handle *tep);
 
-/* access to the internal parser */
-void tep_buffer_init(const char *buf, unsigned long long size);
-enum tep_event_type tep_read_token(char **tok);
-void tep_free_token(char *token);
-int tep_peek_char(void);
-const char *tep_get_input_buf(void);
-unsigned long long tep_get_input_buf_ptr(void);
-
 /* for debugging */
 void tep_print_funcs(struct tep_handle *tep);
 void tep_print_printk(struct tep_handle *tep);
diff --git a/lib/traceevent/event-parse-api.c b/lib/traceevent/event-parse-api.c
index 4faf52a6..f8361e45 100644
--- a/lib/traceevent/event-parse-api.c
+++ b/lib/traceevent/event-parse-api.c
@@ -92,7 +92,7 @@ bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
 	return false;
 }
 
-unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data)
+__hidden unsigned short data2host2(struct tep_handle *tep, unsigned short data)
 {
 	unsigned short swap;
 
@@ -105,7 +105,7 @@ unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data)
 	return swap;
 }
 
-unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data)
+__hidden unsigned int data2host4(struct tep_handle *tep, unsigned int data)
 {
 	unsigned int swap;
 
@@ -120,8 +120,8 @@ unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data)
 	return swap;
 }
 
-unsigned long long
-tep_data2host8(struct tep_handle *tep, unsigned long long data)
+__hidden  unsigned long long
+data2host8(struct tep_handle *tep, unsigned long long data)
 {
 	unsigned long long swap;
 
diff --git a/lib/traceevent/event-parse-local.h b/lib/traceevent/event-parse-local.h
index d805a920..fd4bbcfb 100644
--- a/lib/traceevent/event-parse-local.h
+++ b/lib/traceevent/event-parse-local.h
@@ -15,6 +15,8 @@ struct event_handler;
 struct func_resolver;
 struct tep_plugins_dir;
 
+#define __hidden __attribute__((visibility ("hidden")))
+
 struct tep_handle {
 	int ref_count;
 
@@ -102,12 +104,20 @@ struct tep_print_parse {
 	struct tep_print_arg		*len_as_arg;
 };
 
-void tep_free_event(struct tep_event *event);
-void tep_free_format_field(struct tep_format_field *field);
-void tep_free_plugin_paths(struct tep_handle *tep);
-
-unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data);
-unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data);
-unsigned long long tep_data2host8(struct tep_handle *tep, unsigned long long data);
+void free_tep_event(struct tep_event *event);
+void free_tep_format_field(struct tep_format_field *field);
+void free_tep_plugin_paths(struct tep_handle *tep);
+
+unsigned short data2host2(struct tep_handle *tep, unsigned short data);
+unsigned int data2host4(struct tep_handle *tep, unsigned int data);
+unsigned long long data2host8(struct tep_handle *tep, unsigned long long data);
+
+/* access to the internal parser */
+int peek_char(void);
+void init_input_buf(const char *buf, unsigned long long size);
+unsigned long long get_input_buf_ptr(void);
+const char *get_input_buf(void);
+enum tep_event_type read_token(char **tok);
+void free_token(char *tok);
 
 #endif /* _PARSE_EVENTS_INT_H */
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 06fa3dd0..74f06418 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -54,19 +54,26 @@ static int show_warning = 1;
 			warning(fmt, ##__VA_ARGS__);		\
 	} while (0)
 
-static void init_input_buf(const char *buf, unsigned long long size)
+/**
+ * init_input_buf - init buffer for parsing
+ * @buf: buffer to parse
+ * @size: the size of the buffer
+ *
+ * Initializes the internal buffer that tep_read_token() will parse.
+ */
+__hidden void init_input_buf(const char *buf, unsigned long long size)
 {
 	input_buf = buf;
 	input_buf_siz = size;
 	input_buf_ptr = 0;
 }
 
-const char *tep_get_input_buf(void)
+__hidden const char *get_input_buf(void)
 {
 	return input_buf;
 }
 
-unsigned long long tep_get_input_buf_ptr(void)
+__hidden unsigned long long get_input_buf_ptr(void)
 {
 	return input_buf_ptr;
 }
@@ -100,26 +107,13 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 
 static void free_func_handle(struct tep_function_handler *func);
 
-/**
- * tep_buffer_init - init buffer for parsing
- * @buf: buffer to parse
- * @size: the size of the buffer
- *
- * For use with tep_read_token(), this initializes the internal
- * buffer that tep_read_token() will parse.
- */
-void tep_buffer_init(const char *buf, unsigned long long size)
-{
-	init_input_buf(buf, size);
-}
-
 void breakpoint(void)
 {
 	static int x;
 	x++;
 }
 
-struct tep_print_arg *alloc_arg(void)
+static struct tep_print_arg *alloc_arg(void)
 {
 	return calloc(1, sizeof(struct tep_print_arg));
 }
@@ -962,22 +956,17 @@ static int __read_char(void)
 	return input_buf[input_buf_ptr++];
 }
 
-static int __peek_char(void)
-{
-	if (input_buf_ptr >= input_buf_siz)
-		return -1;
-
-	return input_buf[input_buf_ptr];
-}
-
 /**
- * tep_peek_char - peek at the next character that will be read
+ * peek_char - peek at the next character that will be read
  *
  * Returns the next character read, or -1 if end of buffer.
  */
-int tep_peek_char(void)
+__hidden int peek_char(void)
 {
-	return __peek_char();
+	if (input_buf_ptr >= input_buf_siz)
+		return -1;
+
+	return input_buf[input_buf_ptr];
 }
 
 static int extend_token(char **tok, char *buf, int size)
@@ -1033,7 +1022,7 @@ static enum tep_event_type __read_token(char **tok)
 	case TEP_EVENT_OP:
 		switch (ch) {
 		case '-':
-			next_ch = __peek_char();
+			next_ch = peek_char();
 			if (next_ch == '>') {
 				buf[i++] = __read_char();
 				break;
@@ -1045,7 +1034,7 @@ static enum tep_event_type __read_token(char **tok)
 		case '>':
 		case '<':
 			last_ch = ch;
-			ch = __peek_char();
+			ch = peek_char();
 			if (ch != last_ch)
 				goto test_equal;
 			buf[i++] = __read_char();
@@ -1068,7 +1057,7 @@ static enum tep_event_type __read_token(char **tok)
 		return type;
 
  test_equal:
-		ch = __peek_char();
+		ch = peek_char();
 		if (ch == '=')
 			buf[i++] = __read_char();
 		goto out;
@@ -1122,7 +1111,7 @@ static enum tep_event_type __read_token(char **tok)
 		break;
 	}
 
-	while (get_type(__peek_char()) == type) {
+	while (get_type(peek_char()) == type) {
 		if (i == (BUFSIZ - 1)) {
 			buf[i] = 0;
 			tok_size += BUFSIZ;
@@ -1191,13 +1180,26 @@ static enum tep_event_type force_token(const char *str, char **tok)
 	return type;
 }
 
-static void free_token(char *tok)
+/**
+ * free_token - free a token returned by tep_read_token
+ * @token: the token to free
+ */
+__hidden void free_token(char *tok)
 {
 	if (tok)
 		free(tok);
 }
 
-static enum tep_event_type read_token(char **tok)
+/**
+ * read_token - access to utilities to use the tep parser
+ * @tok: The token to return
+ *
+ * This will parse tokens from the string given by
+ * tep_init_data().
+ *
+ * Returns the token type.
+ */
+__hidden enum tep_event_type read_token(char **tok)
 {
 	enum tep_event_type type;
 
@@ -1214,29 +1216,6 @@ static enum tep_event_type read_token(char **tok)
 	return TEP_EVENT_NONE;
 }
 
-/**
- * tep_read_token - access to utilities to use the tep parser
- * @tok: The token to return
- *
- * This will parse tokens from the string given by
- * tep_init_data().
- *
- * Returns the token type.
- */
-enum tep_event_type tep_read_token(char **tok)
-{
-	return read_token(tok);
-}
-
-/**
- * tep_free_token - free a token returned by tep_read_token
- * @token: the token to free
- */
-void tep_free_token(char *token)
-{
-	free_token(token);
-}
-
 /* no newline */
 static enum tep_event_type read_token_item(char **tok)
 {
@@ -3458,12 +3437,12 @@ unsigned long long tep_read_number(struct tep_handle *tep,
 	case 1:
 		return *(unsigned char *)ptr;
 	case 2:
-		return tep_data2host2(tep, *(unsigned short *)ptr);
+		return data2host2(tep, *(unsigned short *)ptr);
 	case 4:
-		return tep_data2host4(tep, *(unsigned int *)ptr);
+		return data2host4(tep, *(unsigned int *)ptr);
 	case 8:
 		memcpy(&val, (ptr), sizeof(unsigned long long));
-		return tep_data2host8(tep, val);
+		return data2host8(tep, val);
 	default:
 		/* BUG! */
 		return 0;
@@ -4236,7 +4215,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			f = tep_find_any_field(event, arg->string.string);
 			arg->string.offset = f->offset;
 		}
-		str_offset = tep_data2host4(tep, *(unsigned int *)(data + arg->string.offset));
+		str_offset = data2host4(tep, *(unsigned int *)(data + arg->string.offset));
 		str_offset &= 0xffff;
 		print_str_to_seq(s, format, len_arg, ((char *)data) + str_offset);
 		break;
@@ -4254,7 +4233,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			f = tep_find_any_field(event, arg->bitmask.bitmask);
 			arg->bitmask.offset = f->offset;
 		}
-		bitmask_offset = tep_data2host4(tep, *(unsigned int *)(data + arg->bitmask.offset));
+		bitmask_offset = data2host4(tep, *(unsigned int *)(data + arg->bitmask.offset));
 		bitmask_size = bitmask_offset >> 16;
 		bitmask_offset &= 0xffff;
 		print_bitmask_to_seq(tep, s, format, len_arg,
@@ -6796,7 +6775,7 @@ static int find_event_handle(struct tep_handle *tep, struct tep_event *event)
 }
 
 /**
- * __tep_parse_format - parse the event format
+ * parse_format - parse the event format
  * @buf: the buffer storing the event format string
  * @size: the size of @buf
  * @sys: the system the event belongs to
@@ -6808,9 +6787,9 @@ static int find_event_handle(struct tep_handle *tep, struct tep_event *event)
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum tep_errno __tep_parse_format(struct tep_event **eventp,
-				  struct tep_handle *tep, const char *buf,
-				  unsigned long size, const char *sys)
+static enum tep_errno parse_format(struct tep_event **eventp,
+				   struct tep_handle *tep, const char *buf,
+				   unsigned long size, const char *sys)
 {
 	struct tep_event *event;
 	int ret;
@@ -6925,7 +6904,7 @@ __parse_event(struct tep_handle *tep,
 	      const char *buf, unsigned long size,
 	      const char *sys)
 {
-	int ret = __tep_parse_format(eventp, tep, buf, size, sys);
+	int ret = parse_format(eventp, tep, buf, size, sys);
 	struct tep_event *event = *eventp;
 
 	if (event == NULL)
@@ -6943,7 +6922,7 @@ __parse_event(struct tep_handle *tep,
 	return 0;
 
 event_add_failed:
-	tep_free_event(event);
+	free_tep_event(event);
 	return ret;
 }
 
@@ -7536,7 +7515,7 @@ int tep_get_ref(struct tep_handle *tep)
 	return 0;
 }
 
-void tep_free_format_field(struct tep_format_field *field)
+__hidden void free_tep_format_field(struct tep_format_field *field)
 {
 	free(field->type);
 	if (field->alias != field->name)
@@ -7551,7 +7530,7 @@ static void free_format_fields(struct tep_format_field *field)
 
 	while (field) {
 		next = field->next;
-		tep_free_format_field(field);
+		free_tep_format_field(field);
 		field = next;
 	}
 }
@@ -7562,7 +7541,7 @@ static void free_formats(struct tep_format *format)
 	free_format_fields(format->fields);
 }
 
-void tep_free_event(struct tep_event *event)
+__hidden void free_tep_event(struct tep_event *event)
 {
 	free(event->name);
 	free(event->system);
@@ -7648,7 +7627,7 @@ void tep_free(struct tep_handle *tep)
 	}
 
 	for (i = 0; i < tep->nr_events; i++)
-		tep_free_event(tep->events[i]);
+		free_tep_event(tep->events[i]);
 
 	while (tep->handlers) {
 		handle = tep->handlers;
@@ -7659,7 +7638,7 @@ void tep_free(struct tep_handle *tep)
 	free(tep->events);
 	free(tep->sort_events);
 	free(tep->func_resolver);
-	tep_free_plugin_paths(tep);
+	free_tep_plugin_paths(tep);
 
 	free(tep);
 }
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 4a3f7d3f..07a860ff 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -677,7 +677,7 @@ int tep_add_plugin_path(struct tep_handle *tep, char *path,
 	return 0;
 }
 
-void tep_free_plugin_paths(struct tep_handle *tep)
+__hidden void free_tep_plugin_paths(struct tep_handle *tep)
 {
 	struct tep_plugins_dir *dir;
 
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index c271aeeb..368826bb 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -38,8 +38,8 @@ static void show_error(char *error_buf, const char *fmt, ...)
 	int len;
 	int i;
 
-	input = tep_get_input_buf();
-	index = tep_get_input_buf_ptr();
+	input = get_input_buf();
+	index = get_input_buf_ptr();
 	len = input ? strlen(input) : 0;
 
 	if (len) {
@@ -57,25 +57,20 @@ static void show_error(char *error_buf, const char *fmt, ...)
 	va_end(ap);
 }
 
-static void free_token(char *token)
-{
-	tep_free_token(token);
-}
-
-static enum tep_event_type read_token(char **tok)
+static enum tep_event_type filter_read_token(char **tok)
 {
 	enum tep_event_type type;
 	char *token = NULL;
 
 	do {
 		free_token(token);
-		type = tep_read_token(&token);
+		type = read_token(&token);
 	} while (type == TEP_EVENT_NEWLINE || type == TEP_EVENT_SPACE);
 
 	/* If token is = or ! check to see if the next char is ~ */
 	if (token &&
 	    (strcmp(token, "=") == 0 || strcmp(token, "!") == 0) &&
-	    tep_peek_char() == '~') {
+	    peek_char() == '~') {
 		/* append it */
 		*tok = malloc(3);
 		if (*tok == NULL) {
@@ -85,7 +80,7 @@ static enum tep_event_type read_token(char **tok)
 		sprintf(*tok, "%c%c", *token, '~');
 		free_token(token);
 		/* Now remove the '~' from the buffer */
-		tep_read_token(&token);
+		read_token(&token);
 		free_token(token);
 	} else
 		*tok = token;
@@ -959,7 +954,7 @@ process_filter(struct tep_event *event, struct tep_filter_arg **parg,
 
 	do {
 		free(token);
-		type = read_token(&token);
+		type = filter_read_token(&token);
 		switch (type) {
 		case TEP_EVENT_SQUOTE:
 		case TEP_EVENT_DQUOTE:
@@ -1185,7 +1180,7 @@ process_event(struct tep_event *event, const char *filter_str,
 {
 	int ret;
 
-	tep_buffer_init(filter_str, strlen(filter_str));
+	init_input_buf(filter_str, strlen(filter_str));
 
 	ret = process_filter(event, parg, error_str, 0);
 	if (ret < 0)
@@ -1243,7 +1238,7 @@ filter_event(struct tep_event_filter *filter, struct tep_event *event,
 static void filter_init_error_buf(struct tep_event_filter *filter)
 {
 	/* clear buffer to reset show error */
-	tep_buffer_init("", 0);
+	init_input_buf("", 0);
 	filter->error_buffer[0] = '\0';
 }
 
-- 
2.28.0

