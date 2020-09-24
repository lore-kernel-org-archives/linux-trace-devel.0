Return-Path: <SRS0=Qydk=DB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D741AC2D0E2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Sep 2020 07:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6930F2388A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Sep 2020 07:06:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RwFGZEZA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgIXHGP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Sep 2020 03:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbgIXHGP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Sep 2020 03:06:15 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB6EC0613CE
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Sep 2020 00:06:14 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id d4so2353487wmd.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Sep 2020 00:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qcEAUuxiMcA7VKajw8C9661M+PSPi7lLeMM7WdXBGWI=;
        b=RwFGZEZAM8+ies8G2Esw5fyF1PM81U055Ml/4HCxmjtWvJNrnpIfljdljXnBXTGWZ5
         6t7K9e9U0qTqgOZsg9kgkyd5aozQDVcVVPMpI/nndh2CrH9IwSWCBCzHpfdIsQWZd93a
         h8h7th1Z1goj6xnrm0fMG5uZZ8HP3sr85uWXsbYgeb3PfIZ2ZQMQuXgd0gE9mxD228Ah
         1MlcpCLzXfk5VcYcmpXPACzMpL5MinWHvuO+mfTrBE+ufi6lLVmxlaLDW2ArZec6dud6
         mUC+HckoB8yD10EaQYD6FOkJs0pCQ7eiduhAeXtXZ18d/zldL9ElnbfukiTvdmBySxhu
         JBfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qcEAUuxiMcA7VKajw8C9661M+PSPi7lLeMM7WdXBGWI=;
        b=QkKCr4Ia7Yy99GmcuSWJbD4Z90qbx4gsrwHEpXaipRjNa9ABlyjEQbmKKyN8cHzVb0
         7pPQDEhZRLvxxW9Fhek3DB0N3p+vFVZ5ZoX0C29GKcpzUjjrRF9xGtmG/09PpuLGd3Bd
         2zvrtaLm2rjdNXyPmmaVUrr+h5nNF8ZoDBPYNl3VyUFrPLe+5yrTXJ43MX44LNI75O9h
         Zul1NOdKibof1+QPXkE3xYMM9WsExu0PNoAzo83TUDKjCbNBoBWBHx6oCR+KbSIkm5gZ
         mNCtONkbdKKZez0IW87jHYvWiXkgVUKUyrFnpE9jQBtXVvsY7D5pLsI5r46WIunht5lu
         v9EA==
X-Gm-Message-State: AOAM533PhlpQzxaUreX5YK7ZFBvyK81wdDBmjE4o3lxka+iIWP3KRCGB
        vi3eHVXlN3w8u9yEyBy9k3I=
X-Google-Smtp-Source: ABdhPJwy8GixafSYNv9HV8fQiez9rrQbBtEEh/IUUc9eRmOy9efxVaLSKrNmAfUjeYOA5+yS9osblQ==
X-Received: by 2002:a1c:6607:: with SMTP id a7mr3149064wmc.142.1600931173285;
        Thu, 24 Sep 2020 00:06:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h2sm2434675wrp.69.2020.09.24.00.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 00:06:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] tools lib traceevent: Hide non API functions
Date:   Thu, 24 Sep 2020 10:06:09 +0300
Message-Id: <20200924070609.100771-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200924070609.100771-1-tz.stoyanov@gmail.com>
References: <20200924070609.100771-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are internal library functions, which are not decalred as a static.
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
 tep_free_plugin_paths

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse-api.c   |  8 +--
 tools/lib/traceevent/event-parse-local.h | 24 +++++--
 tools/lib/traceevent/event-parse.c       | 88 ++++++------------------
 tools/lib/traceevent/event-parse.h       |  8 ---
 tools/lib/traceevent/event-plugin.c      |  2 +-
 tools/lib/traceevent/parse-filter.c      | 23 +++----
 6 files changed, 52 insertions(+), 101 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
index 4faf52a65791..23c4a00ae45b 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -92,7 +92,7 @@ bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
 	return false;
 }
 
-unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data)
+__hidden unsigned short _data2host2(struct tep_handle *tep, unsigned short data)
 {
 	unsigned short swap;
 
@@ -105,7 +105,7 @@ unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data)
 	return swap;
 }
 
-unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data)
+__hidden unsigned int _data2host4(struct tep_handle *tep, unsigned int data)
 {
 	unsigned int swap;
 
@@ -120,8 +120,8 @@ unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data)
 	return swap;
 }
 
-unsigned long long
-tep_data2host8(struct tep_handle *tep, unsigned long long data)
+__hidden  unsigned long long
+_data2host8(struct tep_handle *tep, unsigned long long data)
 {
 	unsigned long long swap;
 
diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
index d805a920af6f..d9417437679a 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
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
+unsigned short _data2host2(struct tep_handle *tep, unsigned short data);
+unsigned int _data2host4(struct tep_handle *tep, unsigned int data);
+unsigned long long _data2host8(struct tep_handle *tep, unsigned long long data);
+
+/* access to the internal parser */
+int __peek_char(void);
+void init_input_buf(const char *buf, unsigned long long size);
+unsigned long long get_input_buf_ptr(void);
+const char *get_input_buf(void);
+enum tep_event_type read_token(char **tok);
+void free_token(char *tok);
 
 #endif /* _PARSE_EVENTS_INT_H */
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 5acc18b32606..8b07a52db5ca 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -54,19 +54,19 @@ static int show_warning = 1;
 			warning(fmt, ##__VA_ARGS__);		\
 	} while (0)
 
-static void init_input_buf(const char *buf, unsigned long long size)
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
@@ -100,26 +100,13 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 
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
@@ -962,7 +949,7 @@ static int __read_char(void)
 	return input_buf[input_buf_ptr++];
 }
 
-static int __peek_char(void)
+__hidden  int __peek_char(void)
 {
 	if (input_buf_ptr >= input_buf_siz)
 		return -1;
@@ -970,16 +957,6 @@ static int __peek_char(void)
 	return input_buf[input_buf_ptr];
 }
 
-/**
- * tep_peek_char - peek at the next character that will be read
- *
- * Returns the next character read, or -1 if end of buffer.
- */
-int tep_peek_char(void)
-{
-	return __peek_char();
-}
-
 static int extend_token(char **tok, char *buf, int size)
 {
 	char *newtok = realloc(*tok, size);
@@ -1191,13 +1168,13 @@ static enum tep_event_type force_token(const char *str, char **tok)
 	return type;
 }
 
-static void free_token(char *tok)
+__hidden void free_token(char *tok)
 {
 	if (tok)
 		free(tok);
 }
 
-static enum tep_event_type read_token(char **tok)
+__hidden enum tep_event_type read_token(char **tok)
 {
 	enum tep_event_type type;
 
@@ -1214,29 +1191,6 @@ static enum tep_event_type read_token(char **tok)
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
@@ -3459,12 +3413,12 @@ unsigned long long tep_read_number(struct tep_handle *tep,
 	case 1:
 		return *(unsigned char *)ptr;
 	case 2:
-		return tep_data2host2(tep, *(unsigned short *)ptr);
+		return _data2host2(tep, *(unsigned short *)ptr);
 	case 4:
-		return tep_data2host4(tep, *(unsigned int *)ptr);
+		return _data2host4(tep, *(unsigned int *)ptr);
 	case 8:
 		memcpy(&val, (ptr), sizeof(unsigned long long));
-		return tep_data2host8(tep, val);
+		return _data2host8(tep, val);
 	default:
 		/* BUG! */
 		return 0;
@@ -4190,7 +4144,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			f = tep_find_any_field(event, arg->string.string);
 			arg->string.offset = f->offset;
 		}
-		str_offset = tep_data2host4(tep, *(unsigned int *)(data + arg->string.offset));
+		str_offset = _data2host4(tep, *(unsigned int *)(data + arg->string.offset));
 		str_offset &= 0xffff;
 		print_str_to_seq(s, format, len_arg, ((char *)data) + str_offset);
 		break;
@@ -4208,7 +4162,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			f = tep_find_any_field(event, arg->bitmask.bitmask);
 			arg->bitmask.offset = f->offset;
 		}
-		bitmask_offset = tep_data2host4(tep, *(unsigned int *)(data + arg->bitmask.offset));
+		bitmask_offset = _data2host4(tep, *(unsigned int *)(data + arg->bitmask.offset));
 		bitmask_size = bitmask_offset >> 16;
 		bitmask_offset &= 0xffff;
 		print_bitmask_to_seq(tep, s, format, len_arg,
@@ -6762,9 +6716,9 @@ static int find_event_handle(struct tep_handle *tep, struct tep_event *event)
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum tep_errno __tep_parse_format(struct tep_event **eventp,
-				  struct tep_handle *tep, const char *buf,
-				  unsigned long size, const char *sys)
+__hidden enum tep_errno __tep_parse_format(struct tep_event **eventp,
+					   struct tep_handle *tep, const char *buf,
+					   unsigned long size, const char *sys)
 {
 	struct tep_event *event;
 	int ret;
@@ -6897,7 +6851,7 @@ __parse_event(struct tep_handle *tep,
 	return 0;
 
 event_add_failed:
-	tep_free_event(event);
+	free_tep_event(event);
 	return ret;
 }
 
@@ -7490,7 +7444,7 @@ int tep_get_ref(struct tep_handle *tep)
 	return 0;
 }
 
-void tep_free_format_field(struct tep_format_field *field)
+__hidden void free_tep_format_field(struct tep_format_field *field)
 {
 	free(field->type);
 	if (field->alias != field->name)
@@ -7505,7 +7459,7 @@ static void free_format_fields(struct tep_format_field *field)
 
 	while (field) {
 		next = field->next;
-		tep_free_format_field(field);
+		free_tep_format_field(field);
 		field = next;
 	}
 }
@@ -7516,7 +7470,7 @@ static void free_formats(struct tep_format *format)
 	free_format_fields(format->fields);
 }
 
-void tep_free_event(struct tep_event *event)
+__hidden void free_tep_event(struct tep_event *event)
 {
 	free(event->name);
 	free(event->system);
@@ -7602,7 +7556,7 @@ void tep_free(struct tep_handle *tep)
 	}
 
 	for (i = 0; i < tep->nr_events; i++)
-		tep_free_event(tep->events[i]);
+		free_tep_event(tep->events[i]);
 
 	while (tep->handlers) {
 		handle = tep->handlers;
@@ -7613,7 +7567,7 @@ void tep_free(struct tep_handle *tep)
 	free(tep->events);
 	free(tep->sort_events);
 	free(tep->func_resolver);
-	tep_free_plugin_paths(tep);
+	free_tep_plugin_paths(tep);
 
 	free(tep);
 }
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index c29b693e31ee..a67ad9a5b835 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -578,14 +578,6 @@ void tep_ref(struct tep_handle *tep);
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
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index e7c2acb8680f..e7f93d5fe4fd 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -676,7 +676,7 @@ int tep_add_plugin_path(struct tep_handle *tep, char *path,
 	return 0;
 }
 
-void tep_free_plugin_paths(struct tep_handle *tep)
+__hidden void free_tep_plugin_paths(struct tep_handle *tep)
 {
 	struct tep_plugins_dir *dir;
 
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index c271aeeb227d..862a224fabc9 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
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
+	    __peek_char() == '~') {
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
2.26.2

