Return-Path: <SRS0=yn/p=LE=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39454 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbeHUQyN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Aug 2018 12:54:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id o37-v6so7003152wrf.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Aug 2018 06:34:02 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 22/24] tools lib traceevent: Rename internal parser related APIs
Date: Tue, 21 Aug 2018 16:33:26 +0300
Message-Id: <20180821133328.3249-23-tz.stoyanov@gmail.com>
In-Reply-To: <20180821133328.3249-1-tz.stoyanov@gmail.com>
References: <20180821133328.3249-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_buffer_init, pevent_read_token, pevent_free_token,
pevent_peek_char, pevent_get_input_buf, pevent_get_input_buf_ptr

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180808180703.275281085@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h | 12 ++++++------
 lib/traceevent/event-parse.c     | 24 ++++++++++++------------
 lib/traceevent/parse-filter.c    | 16 ++++++++--------
 3 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 328d0d3..1da291e 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -785,12 +785,12 @@ void pevent_ref(struct tep_handle *pevent);
 void pevent_unref(struct tep_handle *pevent);
 
 /* access to the internal parser */
-void pevent_buffer_init(const char *buf, unsigned long long size);
-enum event_type pevent_read_token(char **tok);
-void pevent_free_token(char *token);
-int pevent_peek_char(void);
-const char *pevent_get_input_buf(void);
-unsigned long long pevent_get_input_buf_ptr(void);
+void tep_buffer_init(const char *buf, unsigned long long size);
+enum event_type tep_read_token(char **tok);
+void tep_free_token(char *token);
+int tep_peek_char(void);
+const char *tep_get_input_buf(void);
+unsigned long long tep_get_input_buf_ptr(void);
 
 /* for debugging */
 void tep_print_funcs(struct tep_handle *pevent);
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 8264309..b41608e 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -59,12 +59,12 @@ static void init_input_buf(const char *buf, unsigned long long size)
 	input_buf_ptr = 0;
 }
 
-const char *pevent_get_input_buf(void)
+const char *tep_get_input_buf(void)
 {
 	return input_buf;
 }
 
-unsigned long long pevent_get_input_buf_ptr(void)
+unsigned long long tep_get_input_buf_ptr(void)
 {
 	return input_buf_ptr;
 }
@@ -99,14 +99,14 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 static void free_func_handle(struct tep_function_handler *func);
 
 /**
- * pevent_buffer_init - init buffer for parsing
+ * tep_buffer_init - init buffer for parsing
  * @buf: buffer to parse
  * @size: the size of the buffer
  *
- * For use with pevent_read_token(), this initializes the internal
- * buffer that pevent_read_token() will parse.
+ * For use with tep_read_token(), this initializes the internal
+ * buffer that tep_read_token() will parse.
  */
-void pevent_buffer_init(const char *buf, unsigned long long size)
+void tep_buffer_init(const char *buf, unsigned long long size)
 {
 	init_input_buf(buf, size);
 }
@@ -899,11 +899,11 @@ static int __peek_char(void)
 }
 
 /**
- * pevent_peek_char - peek at the next character that will be read
+ * tep_peek_char - peek at the next character that will be read
  *
  * Returns the next character read, or -1 if end of buffer.
  */
-int pevent_peek_char(void)
+int tep_peek_char(void)
 {
 	return __peek_char();
 }
@@ -1143,7 +1143,7 @@ static enum event_type read_token(char **tok)
 }
 
 /**
- * pevent_read_token - access to utilites to use the pevent parser
+ * tep_read_token - access to utilites to use the pevent parser
  * @tok: The token to return
  *
  * This will parse tokens from the string given by
@@ -1151,16 +1151,16 @@ static enum event_type read_token(char **tok)
  *
  * Returns the token type.
  */
-enum event_type pevent_read_token(char **tok)
+enum event_type tep_read_token(char **tok)
 {
 	return read_token(tok);
 }
 
 /**
- * pevent_free_token - free a token returned by pevent_read_token
+ * tep_free_token - free a token returned by tep_read_token
  * @token: the token to free
  */
-void pevent_free_token(char *token)
+void tep_free_token(char *token)
 {
 	free_token(token);
 }
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index a1d0e3a..1ff488d 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -37,8 +37,8 @@ static void show_error(char *error_buf, const char *fmt, ...)
 	int len;
 	int i;
 
-	input = pevent_get_input_buf();
-	index = pevent_get_input_buf_ptr();
+	input = tep_get_input_buf();
+	index = tep_get_input_buf_ptr();
 	len = input ? strlen(input) : 0;
 
 	if (len) {
@@ -58,7 +58,7 @@ static void show_error(char *error_buf, const char *fmt, ...)
 
 static void free_token(char *token)
 {
-	pevent_free_token(token);
+	tep_free_token(token);
 }
 
 static enum event_type read_token(char **tok)
@@ -68,13 +68,13 @@ static enum event_type read_token(char **tok)
 
 	do {
 		free_token(token);
-		type = pevent_read_token(&token);
+		type = tep_read_token(&token);
 	} while (type == EVENT_NEWLINE || type == EVENT_SPACE);
 
 	/* If token is = or ! check to see if the next char is ~ */
 	if (token &&
 	    (strcmp(token, "=") == 0 || strcmp(token, "!") == 0) &&
-	    pevent_peek_char() == '~') {
+	    tep_peek_char() == '~') {
 		/* append it */
 		*tok = malloc(3);
 		if (*tok == NULL) {
@@ -84,7 +84,7 @@ static enum event_type read_token(char **tok)
 		sprintf(*tok, "%c%c", *token, '~');
 		free_token(token);
 		/* Now remove the '~' from the buffer */
-		pevent_read_token(&token);
+		tep_read_token(&token);
 		free_token(token);
 	} else
 		*tok = token;
@@ -1184,7 +1184,7 @@ process_event(struct event_format *event, const char *filter_str,
 {
 	int ret;
 
-	pevent_buffer_init(filter_str, strlen(filter_str));
+	tep_buffer_init(filter_str, strlen(filter_str));
 
 	ret = process_filter(event, parg, error_str, 0);
 	if (ret < 0)
@@ -1240,7 +1240,7 @@ filter_event(struct event_filter *filter, struct event_format *event,
 static void filter_init_error_buf(struct event_filter *filter)
 {
 	/* clear buffer to reset show error */
-	pevent_buffer_init("", 0);
+	tep_buffer_init("", 0);
 	filter->error_buffer[0] = '\0';
 }
 
-- 
2.17.1
