Return-Path: <SRS0=GMWY=KZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37324 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728418AbeHJPrp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Aug 2018 11:47:45 -0400
Received: by mail-wm0-f65.google.com with SMTP id n11-v6so1875379wmc.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Aug 2018 06:17:50 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 04/14] tools/lib/traceevent: Rename enum event_type to enum tep_event_type, enum event_sort_type to enum tep_event_sort_type and add prefix TEP_ to all enum's members
Date: Fri, 10 Aug 2018 16:17:22 +0300
Message-Id: <20180810131732.24677-5-tz.stoyanov@gmail.com>
In-Reply-To: <20180810131732.24677-1-tz.stoyanov@gmail.com>
References: <20180810131732.24677-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This renames enum event_type
to enum tep_event_type, enum event_sort_type to enum tep_event_sort_type
and add prefix TEP_ to all enum's members

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.c  | 488 ++++++++++++++--------------
 tools/lib/traceevent/event-parse.h  |  34 +-
 tools/lib/traceevent/parse-filter.c |  36 +-
 3 files changed, 279 insertions(+), 279 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index f73263ab9e8e..02b37c03ea25 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -783,12 +783,12 @@ static int add_event(struct tep_handle *pevent, struct tep_event_format *event)
 	return 0;
 }
 
-static int event_item_type(enum event_type type)
+static int event_item_type(enum tep_event_type type)
 {
 	switch (type) {
-	case EVENT_ITEM ... EVENT_SQUOTE:
+	case TEP_EVENT_ITEM ... TEP_EVENT_SQUOTE:
 		return 1;
-	case EVENT_ERROR ... EVENT_DELIM:
+	case TEP_EVENT_ERROR ... TEP_EVENT_DELIM:
 	default:
 		return 0;
 	}
@@ -876,24 +876,24 @@ static void free_arg(struct print_arg *arg)
 	free(arg);
 }
 
-static enum event_type get_type(int ch)
+static enum tep_event_type get_type(int ch)
 {
 	if (ch == '\n')
-		return EVENT_NEWLINE;
+		return TEP_EVENT_NEWLINE;
 	if (isspace(ch))
-		return EVENT_SPACE;
+		return TEP_EVENT_SPACE;
 	if (isalnum(ch) || ch == '_')
-		return EVENT_ITEM;
+		return TEP_EVENT_ITEM;
 	if (ch == '\'')
-		return EVENT_SQUOTE;
+		return TEP_EVENT_SQUOTE;
 	if (ch == '"')
-		return EVENT_DQUOTE;
+		return TEP_EVENT_DQUOTE;
 	if (!isprint(ch))
-		return EVENT_NONE;
+		return TEP_EVENT_NONE;
 	if (ch == '(' || ch == ')' || ch == ',')
-		return EVENT_DELIM;
+		return TEP_EVENT_DELIM;
 
-	return EVENT_OP;
+	return TEP_EVENT_OP;
 }
 
 static int __read_char(void)
@@ -941,38 +941,38 @@ static int extend_token(char **tok, char *buf, int size)
 	return 0;
 }
 
-static enum event_type force_token(const char *str, char **tok);
+static enum tep_event_type force_token(const char *str, char **tok);
 
-static enum event_type __read_token(char **tok)
+static enum tep_event_type __read_token(char **tok)
 {
 	char buf[BUFSIZ];
 	int ch, last_ch, quote_ch, next_ch;
 	int i = 0;
 	int tok_size = 0;
-	enum event_type type;
+	enum tep_event_type type;
 
 	*tok = NULL;
 
 
 	ch = __read_char();
 	if (ch < 0)
-		return EVENT_NONE;
+		return TEP_EVENT_NONE;
 
 	type = get_type(ch);
-	if (type == EVENT_NONE)
+	if (type == TEP_EVENT_NONE)
 		return type;
 
 	buf[i++] = ch;
 
 	switch (type) {
-	case EVENT_NEWLINE:
-	case EVENT_DELIM:
+	case TEP_EVENT_NEWLINE:
+	case TEP_EVENT_DELIM:
 		if (asprintf(tok, "%c", ch) < 0)
-			return EVENT_ERROR;
+			return TEP_EVENT_ERROR;
 
 		return type;
 
-	case EVENT_OP:
+	case TEP_EVENT_OP:
 		switch (ch) {
 		case '-':
 			next_ch = __peek_char();
@@ -1015,8 +1015,8 @@ static enum event_type __read_token(char **tok)
 			buf[i++] = __read_char();
 		goto out;
 
-	case EVENT_DQUOTE:
-	case EVENT_SQUOTE:
+	case TEP_EVENT_DQUOTE:
+	case TEP_EVENT_SQUOTE:
 		/* don't keep quotes */
 		i--;
 		quote_ch = ch;
@@ -1028,7 +1028,7 @@ static enum event_type __read_token(char **tok)
 				tok_size += BUFSIZ;
 
 				if (extend_token(tok, buf, tok_size) < 0)
-					return EVENT_NONE;
+					return TEP_EVENT_NONE;
 				i = 0;
 			}
 			last_ch = ch;
@@ -1045,7 +1045,7 @@ static enum event_type __read_token(char **tok)
 		 * For strings (double quotes) check the next token.
 		 * If it is another string, concatinate the two.
 		 */
-		if (type == EVENT_DQUOTE) {
+		if (type == TEP_EVENT_DQUOTE) {
 			unsigned long long save_input_buf_ptr = input_buf_ptr;
 
 			do {
@@ -1058,8 +1058,8 @@ static enum event_type __read_token(char **tok)
 
 		goto out;
 
-	case EVENT_ERROR ... EVENT_SPACE:
-	case EVENT_ITEM:
+	case TEP_EVENT_ERROR ... TEP_EVENT_SPACE:
+	case TEP_EVENT_ITEM:
 	default:
 		break;
 	}
@@ -1070,7 +1070,7 @@ static enum event_type __read_token(char **tok)
 			tok_size += BUFSIZ;
 
 			if (extend_token(tok, buf, tok_size) < 0)
-				return EVENT_NONE;
+				return TEP_EVENT_NONE;
 			i = 0;
 		}
 		ch = __read_char();
@@ -1080,9 +1080,9 @@ static enum event_type __read_token(char **tok)
  out:
 	buf[i] = 0;
 	if (extend_token(tok, buf, tok_size + i + 1) < 0)
-		return EVENT_NONE;
+		return TEP_EVENT_NONE;
 
-	if (type == EVENT_ITEM) {
+	if (type == TEP_EVENT_ITEM) {
 		/*
 		 * Older versions of the kernel has a bug that
 		 * creates invalid symbols and will break the mac80211
@@ -1109,12 +1109,12 @@ static enum event_type __read_token(char **tok)
 	return type;
 }
 
-static enum event_type force_token(const char *str, char **tok)
+static enum tep_event_type force_token(const char *str, char **tok)
 {
 	const char *save_input_buf;
 	unsigned long long save_input_buf_ptr;
 	unsigned long long save_input_buf_siz;
-	enum event_type type;
+	enum tep_event_type type;
 	
 	/* save off the current input pointers */
 	save_input_buf = input_buf;
@@ -1139,13 +1139,13 @@ static void free_token(char *tok)
 		free(tok);
 }
 
-static enum event_type read_token(char **tok)
+static enum tep_event_type read_token(char **tok)
 {
-	enum event_type type;
+	enum tep_event_type type;
 
 	for (;;) {
 		type = __read_token(tok);
-		if (type != EVENT_SPACE)
+		if (type != TEP_EVENT_SPACE)
 			return type;
 
 		free_token(*tok);
@@ -1153,7 +1153,7 @@ static enum event_type read_token(char **tok)
 
 	/* not reached */
 	*tok = NULL;
-	return EVENT_NONE;
+	return TEP_EVENT_NONE;
 }
 
 /**
@@ -1165,7 +1165,7 @@ static enum event_type read_token(char **tok)
  *
  * Returns the token type.
  */
-enum event_type tep_read_token(char **tok)
+enum tep_event_type tep_read_token(char **tok)
 {
 	return read_token(tok);
 }
@@ -1180,13 +1180,13 @@ void tep_free_token(char *token)
 }
 
 /* no newline */
-static enum event_type read_token_item(char **tok)
+static enum tep_event_type read_token_item(char **tok)
 {
-	enum event_type type;
+	enum tep_event_type type;
 
 	for (;;) {
 		type = __read_token(tok);
-		if (type != EVENT_SPACE && type != EVENT_NEWLINE)
+		if (type != TEP_EVENT_SPACE && type != TEP_EVENT_NEWLINE)
 			return type;
 		free_token(*tok);
 		*tok = NULL;
@@ -1194,10 +1194,10 @@ static enum event_type read_token_item(char **tok)
 
 	/* not reached */
 	*tok = NULL;
-	return EVENT_NONE;
+	return TEP_EVENT_NONE;
 }
 
-static int test_type(enum event_type type, enum event_type expect)
+static int test_type(enum tep_event_type type, enum tep_event_type expect)
 {
 	if (type != expect) {
 		do_warning("Error: expected type %d but read %d",
@@ -1207,8 +1207,8 @@ static int test_type(enum event_type type, enum event_type expect)
 	return 0;
 }
 
-static int test_type_token(enum event_type type, const char *token,
-		    enum event_type expect, const char *expect_tok)
+static int test_type_token(enum tep_event_type type, const char *token,
+		    enum tep_event_type expect, const char *expect_tok)
 {
 	if (type != expect) {
 		do_warning("Error: expected type %d but read %d",
@@ -1224,9 +1224,9 @@ static int test_type_token(enum event_type type, const char *token,
 	return 0;
 }
 
-static int __read_expect_type(enum event_type expect, char **tok, int newline_ok)
+static int __read_expect_type(enum tep_event_type expect, char **tok, int newline_ok)
 {
-	enum event_type type;
+	enum tep_event_type type;
 
 	if (newline_ok)
 		type = read_token(tok);
@@ -1235,15 +1235,15 @@ static int __read_expect_type(enum event_type expect, char **tok, int newline_ok
 	return test_type(type, expect);
 }
 
-static int read_expect_type(enum event_type expect, char **tok)
+static int read_expect_type(enum tep_event_type expect, char **tok)
 {
 	return __read_expect_type(expect, tok, 1);
 }
 
-static int __read_expected(enum event_type expect, const char *str,
+static int __read_expected(enum tep_event_type expect, const char *str,
 			   int newline_ok)
 {
-	enum event_type type;
+	enum tep_event_type type;
 	char *token;
 	int ret;
 
@@ -1259,12 +1259,12 @@ static int __read_expected(enum event_type expect, const char *str,
 	return ret;
 }
 
-static int read_expected(enum event_type expect, const char *str)
+static int read_expected(enum tep_event_type expect, const char *str)
 {
 	return __read_expected(expect, str, 1);
 }
 
-static int read_expected_item(enum event_type expect, const char *str)
+static int read_expected_item(enum tep_event_type expect, const char *str)
 {
 	return __read_expected(expect, str, 0);
 }
@@ -1273,13 +1273,13 @@ static char *event_read_name(void)
 {
 	char *token;
 
-	if (read_expected(EVENT_ITEM, "name") < 0)
+	if (read_expected(TEP_EVENT_ITEM, "name") < 0)
 		return NULL;
 
-	if (read_expected(EVENT_OP, ":") < 0)
+	if (read_expected(TEP_EVENT_OP, ":") < 0)
 		return NULL;
 
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
+	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
 
 	return token;
@@ -1294,13 +1294,13 @@ static int event_read_id(void)
 	char *token;
 	int id;
 
-	if (read_expected_item(EVENT_ITEM, "ID") < 0)
+	if (read_expected_item(TEP_EVENT_ITEM, "ID") < 0)
 		return -1;
 
-	if (read_expected(EVENT_OP, ":") < 0)
+	if (read_expected(TEP_EVENT_OP, ":") < 0)
 		return -1;
 
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
+	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
 
 	id = strtoul(token, NULL, 0);
@@ -1370,7 +1370,7 @@ static unsigned int type_size(const char *name)
 static int event_read_fields(struct tep_event_format *event, struct tep_format_field **fields)
 {
 	struct tep_format_field *field = NULL;
-	enum event_type type;
+	enum tep_event_type type;
 	char *token;
 	char *last_token;
 	int count = 0;
@@ -1379,14 +1379,14 @@ static int event_read_fields(struct tep_event_format *event, struct tep_format_f
 		unsigned int size_dynamic = 0;
 
 		type = read_token(&token);
-		if (type == EVENT_NEWLINE) {
+		if (type == TEP_EVENT_NEWLINE) {
 			free_token(token);
 			return count;
 		}
 
 		count++;
 
-		if (test_type_token(type, token, EVENT_ITEM, "field"))
+		if (test_type_token(type, token, TEP_EVENT_ITEM, "field"))
 			goto fail;
 		free_token(token);
 
@@ -1396,16 +1396,16 @@ static int event_read_fields(struct tep_event_format *event, struct tep_format_f
 		 * Just ignore it.
 		 */
 		if (event->flags & EVENT_FL_ISFTRACE &&
-		    type == EVENT_ITEM && strcmp(token, "special") == 0) {
+		    type == TEP_EVENT_ITEM && strcmp(token, "special") == 0) {
 			free_token(token);
 			type = read_token(&token);
 		}
 
-		if (test_type_token(type, token, EVENT_OP, ":") < 0)
+		if (test_type_token(type, token, TEP_EVENT_OP, ":") < 0)
 			goto fail;
 
 		free_token(token);
-		if (read_expect_type(EVENT_ITEM, &token) < 0)
+		if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 			goto fail;
 
 		last_token = token;
@@ -1419,14 +1419,14 @@ static int event_read_fields(struct tep_event_format *event, struct tep_format_f
 		/* read the rest of the type */
 		for (;;) {
 			type = read_token(&token);
-			if (type == EVENT_ITEM ||
-			    (type == EVENT_OP && strcmp(token, "*") == 0) ||
+			if (type == TEP_EVENT_ITEM ||
+			    (type == TEP_EVENT_OP && strcmp(token, "*") == 0) ||
 			    /*
 			     * Some of the ftrace fields are broken and have
 			     * an illegal "." in them.
 			     */
 			    (event->flags & EVENT_FL_ISFTRACE &&
-			     type == EVENT_OP && strcmp(token, ".") == 0)) {
+			     type == TEP_EVENT_OP && strcmp(token, ".") == 0)) {
 
 				if (strcmp(token, "*") == 0)
 					field->flags |= TEP_FIELD_IS_POINTER;
@@ -1459,11 +1459,11 @@ static int event_read_fields(struct tep_event_format *event, struct tep_format_f
 		}
 		field->name = field->alias = last_token;
 
-		if (test_type(type, EVENT_OP))
+		if (test_type(type, TEP_EVENT_OP))
 			goto fail;
 
 		if (strcmp(token, "[") == 0) {
-			enum event_type last_type = type;
+			enum tep_event_type last_type = type;
 			char *brackets = token;
 			char *new_brackets;
 			int len;
@@ -1472,14 +1472,14 @@ static int event_read_fields(struct tep_event_format *event, struct tep_format_f
 
 			type = read_token(&token);
 
-			if (type == EVENT_ITEM)
+			if (type == TEP_EVENT_ITEM)
 				field->arraylen = strtoul(token, NULL, 0);
 			else
 				field->arraylen = 0;
 
 		        while (strcmp(token, "]") != 0) {
-				if (last_type == EVENT_ITEM &&
-				    type == EVENT_ITEM)
+				if (last_type == TEP_EVENT_ITEM &&
+				    type == TEP_EVENT_ITEM)
 					len = 2;
 				else
 					len = 1;
@@ -1500,7 +1500,7 @@ static int event_read_fields(struct tep_event_format *event, struct tep_format_f
 				field->arraylen = strtoul(token, NULL, 0);
 				free_token(token);
 				type = read_token(&token);
-				if (type == EVENT_NONE) {
+				if (type == TEP_EVENT_NONE) {
 					do_warning_event(event, "failed to find token");
 					goto fail;
 				}
@@ -1523,7 +1523,7 @@ static int event_read_fields(struct tep_event_format *event, struct tep_format_f
 			 * If the next token is not an OP, then it is of
 			 * the format: type [] item;
 			 */
-			if (type == EVENT_ITEM) {
+			if (type == TEP_EVENT_ITEM) {
 				char *new_type;
 				new_type = realloc(field->type,
 						   strlen(field->type) +
@@ -1563,60 +1563,60 @@ static int event_read_fields(struct tep_event_format *event, struct tep_format_f
 		if (field_is_long(field))
 			field->flags |= TEP_FIELD_IS_LONG;
 
-		if (test_type_token(type, token,  EVENT_OP, ";"))
+		if (test_type_token(type, token,  TEP_EVENT_OP, ";"))
 			goto fail;
 		free_token(token);
 
-		if (read_expected(EVENT_ITEM, "offset") < 0)
+		if (read_expected(TEP_EVENT_ITEM, "offset") < 0)
 			goto fail_expect;
 
-		if (read_expected(EVENT_OP, ":") < 0)
+		if (read_expected(TEP_EVENT_OP, ":") < 0)
 			goto fail_expect;
 
-		if (read_expect_type(EVENT_ITEM, &token))
+		if (read_expect_type(TEP_EVENT_ITEM, &token))
 			goto fail;
 		field->offset = strtoul(token, NULL, 0);
 		free_token(token);
 
-		if (read_expected(EVENT_OP, ";") < 0)
+		if (read_expected(TEP_EVENT_OP, ";") < 0)
 			goto fail_expect;
 
-		if (read_expected(EVENT_ITEM, "size") < 0)
+		if (read_expected(TEP_EVENT_ITEM, "size") < 0)
 			goto fail_expect;
 
-		if (read_expected(EVENT_OP, ":") < 0)
+		if (read_expected(TEP_EVENT_OP, ":") < 0)
 			goto fail_expect;
 
-		if (read_expect_type(EVENT_ITEM, &token))
+		if (read_expect_type(TEP_EVENT_ITEM, &token))
 			goto fail;
 		field->size = strtoul(token, NULL, 0);
 		free_token(token);
 
-		if (read_expected(EVENT_OP, ";") < 0)
+		if (read_expected(TEP_EVENT_OP, ";") < 0)
 			goto fail_expect;
 
 		type = read_token(&token);
-		if (type != EVENT_NEWLINE) {
+		if (type != TEP_EVENT_NEWLINE) {
 			/* newer versions of the kernel have a "signed" type */
-			if (test_type_token(type, token, EVENT_ITEM, "signed"))
+			if (test_type_token(type, token, TEP_EVENT_ITEM, "signed"))
 				goto fail;
 
 			free_token(token);
 
-			if (read_expected(EVENT_OP, ":") < 0)
+			if (read_expected(TEP_EVENT_OP, ":") < 0)
 				goto fail_expect;
 
-			if (read_expect_type(EVENT_ITEM, &token))
+			if (read_expect_type(TEP_EVENT_ITEM, &token))
 				goto fail;
 
 			if (strtoul(token, NULL, 0))
 				field->flags |= TEP_FIELD_IS_SIGNED;
 
 			free_token(token);
-			if (read_expected(EVENT_OP, ";") < 0)
+			if (read_expected(TEP_EVENT_OP, ";") < 0)
 				goto fail_expect;
 
-			if (read_expect_type(EVENT_NEWLINE, &token))
+			if (read_expect_type(TEP_EVENT_NEWLINE, &token))
 				goto fail;
 		}
 
@@ -1659,13 +1659,13 @@ static int event_read_format(struct tep_event_format *event)
 	char *token;
 	int ret;
 
-	if (read_expected_item(EVENT_ITEM, "format") < 0)
+	if (read_expected_item(TEP_EVENT_ITEM, "format") < 0)
 		return -1;
 
-	if (read_expected(EVENT_OP, ":") < 0)
+	if (read_expected(TEP_EVENT_OP, ":") < 0)
 		return -1;
 
-	if (read_expect_type(EVENT_NEWLINE, &token))
+	if (read_expect_type(TEP_EVENT_NEWLINE, &token))
 		goto fail;
 	free_token(token);
 
@@ -1686,14 +1686,14 @@ static int event_read_format(struct tep_event_format *event)
 	return -1;
 }
 
-static enum event_type
+static enum tep_event_type
 process_arg_token(struct tep_event_format *event, struct print_arg *arg,
-		  char **tok, enum event_type type);
+		  char **tok, enum tep_event_type type);
 
-static enum event_type
+static enum tep_event_type
 process_arg(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
-	enum event_type type;
+	enum tep_event_type type;
 	char *token;
 
 	type = read_token(&token);
@@ -1702,32 +1702,32 @@ process_arg(struct tep_event_format *event, struct print_arg *arg, char **tok)
 	return process_arg_token(event, arg, tok, type);
 }
 
-static enum event_type
+static enum tep_event_type
 process_op(struct tep_event_format *event, struct print_arg *arg, char **tok);
 
 /*
  * For __print_symbolic() and __print_flags, we need to completely
  * evaluate the first argument, which defines what to print next.
  */
-static enum event_type
+static enum tep_event_type
 process_field_arg(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
-	enum event_type type;
+	enum tep_event_type type;
 
 	type = process_arg(event, arg, tok);
 
-	while (type == EVENT_OP) {
+	while (type == TEP_EVENT_OP) {
 		type = process_op(event, arg, tok);
 	}
 
 	return type;
 }
 
-static enum event_type
+static enum tep_event_type
 process_cond(struct tep_event_format *event, struct print_arg *top, char **tok)
 {
 	struct print_arg *arg, *left, *right;
-	enum event_type type;
+	enum tep_event_type type;
 	char *token = NULL;
 
 	arg = alloc_arg();
@@ -1750,16 +1750,16 @@ process_cond(struct tep_event_format *event, struct print_arg *top, char **tok)
 	type = process_arg(event, left, &token);
 
  again:
-	if (type == EVENT_ERROR)
+	if (type == TEP_EVENT_ERROR)
 		goto out_free;
 
 	/* Handle other operations in the arguments */
-	if (type == EVENT_OP && strcmp(token, ":") != 0) {
+	if (type == TEP_EVENT_OP && strcmp(token, ":") != 0) {
 		type = process_op(event, left, &token);
 		goto again;
 	}
 
-	if (test_type_token(type, token, EVENT_OP, ":"))
+	if (test_type_token(type, token, TEP_EVENT_OP, ":"))
 		goto out_free;
 
 	arg->op.op = token;
@@ -1776,14 +1776,14 @@ process_cond(struct tep_event_format *event, struct print_arg *top, char **tok)
 	top->op.right = NULL;
 	free_token(token);
 	free_arg(arg);
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
-static enum event_type
+static enum tep_event_type
 process_array(struct tep_event_format *event, struct print_arg *top, char **tok)
 {
 	struct print_arg *arg;
-	enum event_type type;
+	enum tep_event_type type;
 	char *token = NULL;
 
 	arg = alloc_arg();
@@ -1791,12 +1791,12 @@ process_array(struct tep_event_format *event, struct print_arg *top, char **tok)
 		do_warning_event(event, "%s: not enough memory!", __func__);
 		/* '*tok' is set to top->op.op.  No need to free. */
 		*tok = NULL;
-		return EVENT_ERROR;
+		return TEP_EVENT_ERROR;
 	}
 
 	*tok = NULL;
 	type = process_arg(event, arg, &token);
-	if (test_type_token(type, token, EVENT_OP, "]"))
+	if (test_type_token(type, token, TEP_EVENT_OP, "]"))
 		goto out_free;
 
 	top->op.right = arg;
@@ -1810,7 +1810,7 @@ process_array(struct tep_event_format *event, struct print_arg *top, char **tok)
 out_free:
 	free_token(token);
 	free_arg(arg);
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
 static int get_op_prio(char *op)
@@ -1881,11 +1881,11 @@ static int set_op_prio(struct print_arg *arg)
 }
 
 /* Note, *tok does not get freed, but will most likely be saved */
-static enum event_type
+static enum tep_event_type
 process_op(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *left, *right = NULL;
-	enum event_type type;
+	enum tep_event_type type;
 	char *token;
 
 	/* the op is passed in via tok */
@@ -1987,7 +1987,7 @@ process_op(struct tep_event_format *event, struct print_arg *arg, char **tok)
 
 		/* could just be a type pointer */
 		if ((strcmp(arg->op.op, "*") == 0) &&
-		    type == EVENT_DELIM && (strcmp(token, ")") == 0)) {
+		    type == TEP_EVENT_DELIM && (strcmp(token, ")") == 0)) {
 			char *new_atom;
 
 			if (left->type != PRINT_ATOM) {
@@ -2013,7 +2013,7 @@ process_op(struct tep_event_format *event, struct print_arg *arg, char **tok)
 			goto out_warn_free;
 
 		type = process_arg_token(event, right, tok, type);
-		if (type == EVENT_ERROR) {
+		if (type == TEP_EVENT_ERROR) {
 			free_arg(right);
 			/* token was freed in process_arg_token() via *tok */
 			token = NULL;
@@ -2060,7 +2060,7 @@ process_op(struct tep_event_format *event, struct print_arg *arg, char **tok)
 		goto out_free;
 	}
 
-	if (type == EVENT_OP && strcmp(*tok, ":") != 0) {
+	if (type == TEP_EVENT_OP && strcmp(*tok, ":") != 0) {
 		int prio;
 
 		/* higher prios need to be closer to the root */
@@ -2079,21 +2079,21 @@ process_op(struct tep_event_format *event, struct print_arg *arg, char **tok)
 out_free:
 	free_token(token);
 	*tok = NULL;
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
-static enum event_type
+static enum tep_event_type
 process_entry(struct tep_event_format *event __maybe_unused, struct print_arg *arg,
 	      char **tok)
 {
-	enum event_type type;
+	enum tep_event_type type;
 	char *field;
 	char *token;
 
-	if (read_expected(EVENT_OP, "->") < 0)
+	if (read_expected(TEP_EVENT_OP, "->") < 0)
 		goto out_err;
 
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
+	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
 	field = token;
 
@@ -2119,14 +2119,14 @@ process_entry(struct tep_event_format *event __maybe_unused, struct print_arg *a
 	free_token(token);
  out_err:
 	*tok = NULL;
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
 static int alloc_and_process_delim(struct tep_event_format *event, char *next_token,
 				   struct print_arg **print_arg)
 {
 	struct print_arg *field;
-	enum event_type type;
+	enum tep_event_type type;
 	char *token;
 	int ret = 0;
 
@@ -2139,7 +2139,7 @@ static int alloc_and_process_delim(struct tep_event_format *event, char *next_to
 
 	type = process_arg(event, field, &token);
 
-	if (test_type_token(type, token, EVENT_DELIM, next_token)) {
+	if (test_type_token(type, token, TEP_EVENT_DELIM, next_token)) {
 		errno = EINVAL;
 		ret = -1;
 		free_arg(field);
@@ -2456,10 +2456,10 @@ static char *arg_eval (struct print_arg *arg)
 	return NULL;
 }
 
-static enum event_type
+static enum tep_event_type
 process_fields(struct tep_event_format *event, struct print_flag_sym **list, char **tok)
 {
-	enum event_type type;
+	enum tep_event_type type;
 	struct print_arg *arg = NULL;
 	struct print_flag_sym *field;
 	char *token = *tok;
@@ -2468,7 +2468,7 @@ process_fields(struct tep_event_format *event, struct print_flag_sym **list, cha
 	do {
 		free_token(token);
 		type = read_token_item(&token);
-		if (test_type_token(type, token, EVENT_OP, "{"))
+		if (test_type_token(type, token, TEP_EVENT_OP, "{"))
 			break;
 
 		arg = alloc_arg();
@@ -2478,13 +2478,13 @@ process_fields(struct tep_event_format *event, struct print_flag_sym **list, cha
 		free_token(token);
 		type = process_arg(event, arg, &token);
 
-		if (type == EVENT_OP)
+		if (type == TEP_EVENT_OP)
 			type = process_op(event, arg, &token);
 
-		if (type == EVENT_ERROR)
+		if (type == TEP_EVENT_ERROR)
 			goto out_free;
 
-		if (test_type_token(type, token, EVENT_DELIM, ","))
+		if (test_type_token(type, token, TEP_EVENT_DELIM, ","))
 			goto out_free;
 
 		field = calloc(1, sizeof(*field));
@@ -2505,7 +2505,7 @@ process_fields(struct tep_event_format *event, struct print_flag_sym **list, cha
 
 		free_token(token);
 		type = process_arg(event, arg, &token);
-		if (test_type_token(type, token, EVENT_OP, "}"))
+		if (test_type_token(type, token, TEP_EVENT_OP, "}"))
 			goto out_free_field;
 
 		value = arg_eval(arg);
@@ -2522,7 +2522,7 @@ process_fields(struct tep_event_format *event, struct print_flag_sym **list, cha
 
 		free_token(token);
 		type = read_token_item(&token);
-	} while (type == EVENT_DELIM && strcmp(token, ",") == 0);
+	} while (type == TEP_EVENT_DELIM && strcmp(token, ",") == 0);
 
 	*tok = token;
 	return type;
@@ -2534,14 +2534,14 @@ process_fields(struct tep_event_format *event, struct print_flag_sym **list, cha
 	free_token(token);
 	*tok = NULL;
 
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
-static enum event_type
+static enum tep_event_type
 process_flags(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *field;
-	enum event_type type;
+	enum tep_event_type type;
 	char *token = NULL;
 
 	memset(arg, 0, sizeof(*arg));
@@ -2556,10 +2556,10 @@ process_flags(struct tep_event_format *event, struct print_arg *arg, char **tok)
 	type = process_field_arg(event, field, &token);
 
 	/* Handle operations in the first argument */
-	while (type == EVENT_OP)
+	while (type == TEP_EVENT_OP)
 		type = process_op(event, field, &token);
 
-	if (test_type_token(type, token, EVENT_DELIM, ","))
+	if (test_type_token(type, token, TEP_EVENT_DELIM, ","))
 		goto out_free_field;
 	free_token(token);
 
@@ -2571,11 +2571,11 @@ process_flags(struct tep_event_format *event, struct print_arg *arg, char **tok)
 		type = read_token_item(&token);
 	}
 
-	if (test_type_token(type, token, EVENT_DELIM, ","))
+	if (test_type_token(type, token, TEP_EVENT_DELIM, ","))
 		goto out_free;
 
 	type = process_fields(event, &arg->flags.flags, &token);
-	if (test_type_token(type, token, EVENT_DELIM, ")"))
+	if (test_type_token(type, token, TEP_EVENT_DELIM, ")"))
 		goto out_free;
 
 	free_token(token);
@@ -2587,14 +2587,14 @@ process_flags(struct tep_event_format *event, struct print_arg *arg, char **tok)
 out_free:
 	free_token(token);
 	*tok = NULL;
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
-static enum event_type
+static enum tep_event_type
 process_symbols(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *field;
-	enum event_type type;
+	enum tep_event_type type;
 	char *token = NULL;
 
 	memset(arg, 0, sizeof(*arg));
@@ -2608,13 +2608,13 @@ process_symbols(struct tep_event_format *event, struct print_arg *arg, char **to
 
 	type = process_field_arg(event, field, &token);
 
-	if (test_type_token(type, token, EVENT_DELIM, ","))
+	if (test_type_token(type, token, TEP_EVENT_DELIM, ","))
 		goto out_free_field;
 
 	arg->symbol.field = field;
 
 	type = process_fields(event, &arg->symbol.symbols, &token);
-	if (test_type_token(type, token, EVENT_DELIM, ")"))
+	if (test_type_token(type, token, TEP_EVENT_DELIM, ")"))
 		goto out_free;
 
 	free_token(token);
@@ -2626,10 +2626,10 @@ process_symbols(struct tep_event_format *event, struct print_arg *arg, char **to
 out_free:
 	free_token(token);
 	*tok = NULL;
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
-static enum event_type
+static enum tep_event_type
 process_hex_common(struct tep_event_format *event, struct print_arg *arg,
 		   char **tok, enum print_arg_type type)
 {
@@ -2649,23 +2649,23 @@ process_hex_common(struct tep_event_format *event, struct print_arg *arg,
 	arg->hex.field = NULL;
 out:
 	*tok = NULL;
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
-static enum event_type
+static enum tep_event_type
 process_hex(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	return process_hex_common(event, arg, tok, PRINT_HEX);
 }
 
-static enum event_type
+static enum tep_event_type
 process_hex_str(struct tep_event_format *event, struct print_arg *arg,
 		char **tok)
 {
 	return process_hex_common(event, arg, tok, PRINT_HEX_STR);
 }
 
-static enum event_type
+static enum tep_event_type
 process_int_array(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	memset(arg, 0, sizeof(*arg));
@@ -2690,14 +2690,14 @@ process_int_array(struct tep_event_format *event, struct print_arg *arg, char **
 	arg->int_array.field = NULL;
 out:
 	*tok = NULL;
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
-static enum event_type
+static enum tep_event_type
 process_dynamic_array(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	struct tep_format_field *field;
-	enum event_type type;
+	enum tep_event_type type;
 	char *token;
 
 	memset(arg, 0, sizeof(*arg));
@@ -2709,7 +2709,7 @@ process_dynamic_array(struct tep_event_format *event, struct print_arg *arg, cha
 	 */
 	type = read_token(&token);
 	*tok = token;
-	if (type != EVENT_ITEM)
+	if (type != TEP_EVENT_ITEM)
 		goto out_free;
 
 	/* Find the field */
@@ -2721,13 +2721,13 @@ process_dynamic_array(struct tep_event_format *event, struct print_arg *arg, cha
 	arg->dynarray.field = field;
 	arg->dynarray.index = 0;
 
-	if (read_expected(EVENT_DELIM, ")") < 0)
+	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
 		goto out_free;
 
 	free_token(token);
 	type = read_token_item(&token);
 	*tok = token;
-	if (type != EVENT_OP || strcmp(token, "[") != 0)
+	if (type != TEP_EVENT_OP || strcmp(token, "[") != 0)
 		return type;
 
 	free_token(token);
@@ -2735,14 +2735,14 @@ process_dynamic_array(struct tep_event_format *event, struct print_arg *arg, cha
 	if (!arg) {
 		do_warning_event(event, "%s: not enough memory!", __func__);
 		*tok = NULL;
-		return EVENT_ERROR;
+		return TEP_EVENT_ERROR;
 	}
 
 	type = process_arg(event, arg, &token);
-	if (type == EVENT_ERROR)
+	if (type == TEP_EVENT_ERROR)
 		goto out_free_arg;
 
-	if (!test_type_token(type, token, EVENT_OP, "]"))
+	if (!test_type_token(type, token, TEP_EVENT_OP, "]"))
 		goto out_free_arg;
 
 	free_token(token);
@@ -2754,18 +2754,18 @@ process_dynamic_array(struct tep_event_format *event, struct print_arg *arg, cha
  out_free:
 	free_token(token);
 	*tok = NULL;
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
-static enum event_type
+static enum tep_event_type
 process_dynamic_array_len(struct tep_event_format *event, struct print_arg *arg,
 			  char **tok)
 {
 	struct tep_format_field *field;
-	enum event_type type;
+	enum tep_event_type type;
 	char *token;
 
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
+	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
 
 	arg->type = PRINT_DYNAMIC_ARRAY_LEN;
@@ -2778,7 +2778,7 @@ process_dynamic_array_len(struct tep_event_format *event, struct print_arg *arg,
 	arg->dynarray.field = field;
 	arg->dynarray.index = 0;
 
-	if (read_expected(EVENT_DELIM, ")") < 0)
+	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
 
 	type = read_token(&token);
@@ -2790,28 +2790,28 @@ process_dynamic_array_len(struct tep_event_format *event, struct print_arg *arg,
 	free_token(token);
  out_err:
 	*tok = NULL;
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
-static enum event_type
+static enum tep_event_type
 process_paren(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *item_arg;
-	enum event_type type;
+	enum tep_event_type type;
 	char *token;
 
 	type = process_arg(event, arg, &token);
 
-	if (type == EVENT_ERROR)
+	if (type == TEP_EVENT_ERROR)
 		goto out_free;
 
-	if (type == EVENT_OP)
+	if (type == TEP_EVENT_OP)
 		type = process_op(event, arg, &token);
 
-	if (type == EVENT_ERROR)
+	if (type == TEP_EVENT_ERROR)
 		goto out_free;
 
-	if (test_type_token(type, token, EVENT_DELIM, ")"))
+	if (test_type_token(type, token, TEP_EVENT_DELIM, ")"))
 		goto out_free;
 
 	free_token(token);
@@ -2822,7 +2822,7 @@ process_paren(struct tep_event_format *event, struct print_arg *arg, char **tok)
 	 * this was a typecast.
 	 */
 	if (event_item_type(type) ||
-	    (type == EVENT_DELIM && strcmp(token, "(") == 0)) {
+	    (type == TEP_EVENT_DELIM && strcmp(token, "(") == 0)) {
 
 		/* make this a typecast and contine */
 
@@ -2852,25 +2852,25 @@ process_paren(struct tep_event_format *event, struct print_arg *arg, char **tok)
  out_free:
 	free_token(token);
 	*tok = NULL;
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
 
-static enum event_type
+static enum tep_event_type
 process_str(struct tep_event_format *event __maybe_unused, struct print_arg *arg,
 	    char **tok)
 {
-	enum event_type type;
+	enum tep_event_type type;
 	char *token;
 
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
+	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
 
 	arg->type = PRINT_STRING;
 	arg->string.string = token;
 	arg->string.offset = -1;
 
-	if (read_expected(EVENT_DELIM, ")") < 0)
+	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
 
 	type = read_token(&token);
@@ -2882,24 +2882,24 @@ process_str(struct tep_event_format *event __maybe_unused, struct print_arg *arg
 	free_token(token);
  out_err:
 	*tok = NULL;
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
-static enum event_type
+static enum tep_event_type
 process_bitmask(struct tep_event_format *event __maybe_unused, struct print_arg *arg,
 		char **tok)
 {
-	enum event_type type;
+	enum tep_event_type type;
 	char *token;
 
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
+	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
 
 	arg->type = PRINT_BITMASK;
 	arg->bitmask.bitmask = token;
 	arg->bitmask.offset = -1;
 
-	if (read_expected(EVENT_DELIM, ")") < 0)
+	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
 
 	type = read_token(&token);
@@ -2911,7 +2911,7 @@ process_bitmask(struct tep_event_format *event __maybe_unused, struct print_arg
 	free_token(token);
  out_err:
 	*tok = NULL;
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
 static struct tep_function_handler *
@@ -2946,13 +2946,13 @@ static void remove_func_handler(struct tep_handle *pevent, char *func_name)
 	}
 }
 
-static enum event_type
+static enum tep_event_type
 process_func_handler(struct tep_event_format *event, struct tep_function_handler *func,
 		     struct print_arg *arg, char **tok)
 {
 	struct print_arg **next_arg;
 	struct print_arg *farg;
-	enum event_type type;
+	enum tep_event_type type;
 	char *token;
 	int i;
 
@@ -2967,12 +2967,12 @@ process_func_handler(struct tep_event_format *event, struct tep_function_handler
 		if (!farg) {
 			do_warning_event(event, "%s: not enough memory!",
 					 __func__);
-			return EVENT_ERROR;
+			return TEP_EVENT_ERROR;
 		}
 
 		type = process_arg(event, farg, &token);
 		if (i < (func->nr_args - 1)) {
-			if (type != EVENT_DELIM || strcmp(token, ",") != 0) {
+			if (type != TEP_EVENT_DELIM || strcmp(token, ",") != 0) {
 				do_warning_event(event,
 					"Error: function '%s()' expects %d arguments but event %s only uses %d",
 					func->name, func->nr_args,
@@ -2980,7 +2980,7 @@ process_func_handler(struct tep_event_format *event, struct tep_function_handler
 				goto err;
 			}
 		} else {
-			if (type != EVENT_DELIM || strcmp(token, ")") != 0) {
+			if (type != TEP_EVENT_DELIM || strcmp(token, ")") != 0) {
 				do_warning_event(event,
 					"Error: function '%s()' only expects %d arguments but event %s has more",
 					func->name, func->nr_args, event->name);
@@ -3001,10 +3001,10 @@ process_func_handler(struct tep_event_format *event, struct tep_function_handler
 err:
 	free_arg(farg);
 	free_token(token);
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
-static enum event_type
+static enum tep_event_type
 process_function(struct tep_event_format *event, struct print_arg *arg,
 		 char *token, char **tok)
 {
@@ -3057,12 +3057,12 @@ process_function(struct tep_event_format *event, struct print_arg *arg,
 
 	do_warning_event(event, "function %s not defined", token);
 	free_token(token);
-	return EVENT_ERROR;
+	return TEP_EVENT_ERROR;
 }
 
-static enum event_type
+static enum tep_event_type
 process_arg_token(struct tep_event_format *event, struct print_arg *arg,
-		  char **tok, enum event_type type)
+		  char **tok, enum tep_event_type type)
 {
 	char *token;
 	char *atom;
@@ -3070,7 +3070,7 @@ process_arg_token(struct tep_event_format *event, struct print_arg *arg,
 	token = *tok;
 
 	switch (type) {
-	case EVENT_ITEM:
+	case TEP_EVENT_ITEM:
 		if (strcmp(token, "REC") == 0) {
 			free_token(token);
 			type = process_entry(event, arg, &token);
@@ -3084,7 +3084,7 @@ process_arg_token(struct tep_event_format *event, struct print_arg *arg,
 		 * If the next token is a parenthesis, then this
 		 * is a function.
 		 */
-		if (type == EVENT_DELIM && strcmp(token, "(") == 0) {
+		if (type == TEP_EVENT_DELIM && strcmp(token, "(") == 0) {
 			free_token(token);
 			token = NULL;
 			/* this will free atom. */
@@ -3092,7 +3092,7 @@ process_arg_token(struct tep_event_format *event, struct print_arg *arg,
 			break;
 		}
 		/* atoms can be more than one token long */
-		while (type == EVENT_ITEM) {
+		while (type == TEP_EVENT_ITEM) {
 			char *new_atom;
 			new_atom = realloc(atom,
 					   strlen(atom) + strlen(token) + 2);
@@ -3100,7 +3100,7 @@ process_arg_token(struct tep_event_format *event, struct print_arg *arg,
 				free(atom);
 				*tok = NULL;
 				free_token(token);
-				return EVENT_ERROR;
+				return TEP_EVENT_ERROR;
 			}
 			atom = new_atom;
 			strcat(atom, " ");
@@ -3113,19 +3113,19 @@ process_arg_token(struct tep_event_format *event, struct print_arg *arg,
 		arg->atom.atom = atom;
 		break;
 
-	case EVENT_DQUOTE:
-	case EVENT_SQUOTE:
+	case TEP_EVENT_DQUOTE:
+	case TEP_EVENT_SQUOTE:
 		arg->type = PRINT_ATOM;
 		arg->atom.atom = token;
 		type = read_token_item(&token);
 		break;
-	case EVENT_DELIM:
+	case TEP_EVENT_DELIM:
 		if (strcmp(token, "(") == 0) {
 			free_token(token);
 			type = process_paren(event, arg, &token);
 			break;
 		}
-	case EVENT_OP:
+	case TEP_EVENT_OP:
 		/* handle single ops */
 		arg->type = PRINT_OP;
 		arg->op.op = token;
@@ -3133,16 +3133,16 @@ process_arg_token(struct tep_event_format *event, struct print_arg *arg,
 		type = process_op(event, arg, &token);
 
 		/* On error, the op is freed */
-		if (type == EVENT_ERROR)
+		if (type == TEP_EVENT_ERROR)
 			arg->op.op = NULL;
 
 		/* return error type if errored */
 		break;
 
-	case EVENT_ERROR ... EVENT_NEWLINE:
+	case TEP_EVENT_ERROR ... TEP_EVENT_NEWLINE:
 	default:
 		do_warning_event(event, "unexpected type %d", type);
-		return EVENT_ERROR;
+		return TEP_EVENT_ERROR;
 	}
 	*tok = token;
 
@@ -3151,13 +3151,13 @@ process_arg_token(struct tep_event_format *event, struct print_arg *arg,
 
 static int event_read_print_args(struct tep_event_format *event, struct print_arg **list)
 {
-	enum event_type type = EVENT_ERROR;
+	enum tep_event_type type = TEP_EVENT_ERROR;
 	struct print_arg *arg;
 	char *token;
 	int args = 0;
 
 	do {
-		if (type == EVENT_NEWLINE) {
+		if (type == TEP_EVENT_NEWLINE) {
 			type = read_token_item(&token);
 			continue;
 		}
@@ -3171,7 +3171,7 @@ static int event_read_print_args(struct tep_event_format *event, struct print_ar
 
 		type = process_arg(event, arg, &token);
 
-		if (type == EVENT_ERROR) {
+		if (type == TEP_EVENT_ERROR) {
 			free_token(token);
 			free_arg(arg);
 			return -1;
@@ -3180,10 +3180,10 @@ static int event_read_print_args(struct tep_event_format *event, struct print_ar
 		*list = arg;
 		args++;
 
-		if (type == EVENT_OP) {
+		if (type == TEP_EVENT_OP) {
 			type = process_op(event, arg, &token);
 			free_token(token);
-			if (type == EVENT_ERROR) {
+			if (type == TEP_EVENT_ERROR) {
 				*list = NULL;
 				free_arg(arg);
 				return -1;
@@ -3192,16 +3192,16 @@ static int event_read_print_args(struct tep_event_format *event, struct print_ar
 			continue;
 		}
 
-		if (type == EVENT_DELIM && strcmp(token, ",") == 0) {
+		if (type == TEP_EVENT_DELIM && strcmp(token, ",") == 0) {
 			free_token(token);
 			*list = arg;
 			list = &arg->next;
 			continue;
 		}
 		break;
-	} while (type != EVENT_NONE);
+	} while (type != TEP_EVENT_NONE);
 
-	if (type != EVENT_NONE && type != EVENT_ERROR)
+	if (type != TEP_EVENT_NONE && type != TEP_EVENT_ERROR)
 		free_token(token);
 
 	return args;
@@ -3209,20 +3209,20 @@ static int event_read_print_args(struct tep_event_format *event, struct print_ar
 
 static int event_read_print(struct tep_event_format *event)
 {
-	enum event_type type;
+	enum tep_event_type type;
 	char *token;
 	int ret;
 
-	if (read_expected_item(EVENT_ITEM, "print") < 0)
+	if (read_expected_item(TEP_EVENT_ITEM, "print") < 0)
 		return -1;
 
-	if (read_expected(EVENT_ITEM, "fmt") < 0)
+	if (read_expected(TEP_EVENT_ITEM, "fmt") < 0)
 		return -1;
 
-	if (read_expected(EVENT_OP, ":") < 0)
+	if (read_expected(TEP_EVENT_OP, ":") < 0)
 		return -1;
 
-	if (read_expect_type(EVENT_DQUOTE, &token) < 0)
+	if (read_expect_type(TEP_EVENT_DQUOTE, &token) < 0)
 		goto fail;
 
  concat:
@@ -3232,11 +3232,11 @@ static int event_read_print(struct tep_event_format *event)
 	/* ok to have no arg */
 	type = read_token_item(&token);
 
-	if (type == EVENT_NONE)
+	if (type == TEP_EVENT_NONE)
 		return 0;
 
 	/* Handle concatenation of print lines */
-	if (type == EVENT_DQUOTE) {
+	if (type == TEP_EVENT_DQUOTE) {
 		char *cat;
 
 		if (asprintf(&cat, "%s%s", event->print_fmt.format, token) < 0)
@@ -3248,7 +3248,7 @@ static int event_read_print(struct tep_event_format *event)
 		goto concat;
 	}
 			     
-	if (test_type_token(type, token, EVENT_DELIM, ","))
+	if (test_type_token(type, token, TEP_EVENT_DELIM, ","))
 		goto fail;
 
 	free_token(token);
@@ -5630,7 +5630,7 @@ static int events_system_cmp(const void *a, const void *b)
 	return events_id_cmp(a, b);
 }
 
-struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum event_sort_type sort_type)
+struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum tep_event_sort_type sort_type)
 {
 	struct tep_event_format **events;
 	int (*sort)(const void *a, const void *b);
@@ -5651,20 +5651,20 @@ struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum event_
 		pevent->sort_events = events;
 
 		/* the internal events are sorted by id */
-		if (sort_type == EVENT_SORT_ID) {
+		if (sort_type == TEP_EVENT_SORT_ID) {
 			pevent->last_type = sort_type;
 			return events;
 		}
 	}
 
 	switch (sort_type) {
-	case EVENT_SORT_ID:
+	case TEP_EVENT_SORT_ID:
 		sort = events_id_cmp;
 		break;
-	case EVENT_SORT_NAME:
+	case TEP_EVENT_SORT_NAME:
 		sort = events_name_cmp;
 		break;
-	case EVENT_SORT_SYSTEM:
+	case TEP_EVENT_SORT_SYSTEM:
 		sort = events_system_cmp;
 		break;
 	default:
@@ -5847,13 +5847,13 @@ static void parse_header_field(const char *field,
 	save_input_buf_ptr = input_buf_ptr;
 	save_input_buf_siz = input_buf_siz;
 
-	if (read_expected(EVENT_ITEM, "field") < 0)
+	if (read_expected(TEP_EVENT_ITEM, "field") < 0)
 		return;
-	if (read_expected(EVENT_OP, ":") < 0)
+	if (read_expected(TEP_EVENT_OP, ":") < 0)
 		return;
 
 	/* type */
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
+	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
 	free_token(token);
 
@@ -5861,42 +5861,42 @@ static void parse_header_field(const char *field,
 	 * If this is not a mandatory field, then test it first.
 	 */
 	if (mandatory) {
-		if (read_expected(EVENT_ITEM, field) < 0)
+		if (read_expected(TEP_EVENT_ITEM, field) < 0)
 			return;
 	} else {
-		if (read_expect_type(EVENT_ITEM, &token) < 0)
+		if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 			goto fail;
 		if (strcmp(token, field) != 0)
 			goto discard;
 		free_token(token);
 	}
 
-	if (read_expected(EVENT_OP, ";") < 0)
+	if (read_expected(TEP_EVENT_OP, ";") < 0)
 		return;
-	if (read_expected(EVENT_ITEM, "offset") < 0)
+	if (read_expected(TEP_EVENT_ITEM, "offset") < 0)
 		return;
-	if (read_expected(EVENT_OP, ":") < 0)
+	if (read_expected(TEP_EVENT_OP, ":") < 0)
 		return;
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
+	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
 	*offset = atoi(token);
 	free_token(token);
-	if (read_expected(EVENT_OP, ";") < 0)
+	if (read_expected(TEP_EVENT_OP, ";") < 0)
 		return;
-	if (read_expected(EVENT_ITEM, "size") < 0)
+	if (read_expected(TEP_EVENT_ITEM, "size") < 0)
 		return;
-	if (read_expected(EVENT_OP, ":") < 0)
+	if (read_expected(TEP_EVENT_OP, ":") < 0)
 		return;
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
+	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
 	*size = atoi(token);
 	free_token(token);
-	if (read_expected(EVENT_OP, ";") < 0)
+	if (read_expected(TEP_EVENT_OP, ";") < 0)
 		return;
 	type = read_token(&token);
-	if (type != EVENT_NEWLINE) {
+	if (type != TEP_EVENT_NEWLINE) {
 		/* newer versions of the kernel have a "signed" type */
-		if (type != EVENT_ITEM)
+		if (type != TEP_EVENT_ITEM)
 			goto fail;
 
 		if (strcmp(token, "signed") != 0)
@@ -5904,17 +5904,17 @@ static void parse_header_field(const char *field,
 
 		free_token(token);
 
-		if (read_expected(EVENT_OP, ":") < 0)
+		if (read_expected(TEP_EVENT_OP, ":") < 0)
 			return;
 
-		if (read_expect_type(EVENT_ITEM, &token))
+		if (read_expect_type(TEP_EVENT_ITEM, &token))
 			goto fail;
 
 		free_token(token);
-		if (read_expected(EVENT_OP, ";") < 0)
+		if (read_expected(TEP_EVENT_OP, ";") < 0)
 			return;
 
-		if (read_expect_type(EVENT_NEWLINE, &token))
+		if (read_expect_type(TEP_EVENT_NEWLINE, &token))
 			goto fail;
 	}
  fail:
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index bab6d58c2e8a..9f0065aebc16 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -343,22 +343,22 @@ enum {
 	EVENT_FL_FAILED		= 0x80000000
 };
 
-enum event_sort_type {
-	EVENT_SORT_ID,
-	EVENT_SORT_NAME,
-	EVENT_SORT_SYSTEM,
+enum tep_event_sort_type {
+	TEP_EVENT_SORT_ID,
+	TEP_EVENT_SORT_NAME,
+	TEP_EVENT_SORT_SYSTEM,
 };
 
-enum event_type {
-	EVENT_ERROR,
-	EVENT_NONE,
-	EVENT_SPACE,
-	EVENT_NEWLINE,
-	EVENT_OP,
-	EVENT_DELIM,
-	EVENT_ITEM,
-	EVENT_DQUOTE,
-	EVENT_SQUOTE,
+enum tep_event_type {
+	TEP_EVENT_ERROR,
+	TEP_EVENT_NONE,
+	TEP_EVENT_SPACE,
+	TEP_EVENT_NEWLINE,
+	TEP_EVENT_OP,
+	TEP_EVENT_DELIM,
+	TEP_EVENT_ITEM,
+	TEP_EVENT_DQUOTE,
+	TEP_EVENT_SQUOTE,
 };
 
 typedef unsigned long long (*tep_func_handler)(struct trace_seq *s,
@@ -496,7 +496,7 @@ struct tep_handle {
 	struct tep_event_format **events;
 	int nr_events;
 	struct tep_event_format **sort_events;
-	enum event_sort_type last_type;
+	enum tep_event_sort_type last_type;
 
 	int type_offset;
 	int type_size;
@@ -727,7 +727,7 @@ void tep_event_info(struct trace_seq *s, struct tep_event_format *event,
 int tep_strerror(struct tep_handle *pevent, enum tep_errno errnum,
 		    char *buf, size_t buflen);
 
-struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum event_sort_type);
+struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum tep_event_sort_type);
 struct tep_format_field **tep_event_common_fields(struct tep_event_format *event);
 struct tep_format_field **tep_event_fields(struct tep_event_format *event);
 
@@ -798,7 +798,7 @@ void tep_unref(struct tep_handle *pevent);
 
 /* access to the internal parser */
 void tep_buffer_init(const char *buf, unsigned long long size);
-enum event_type tep_read_token(char **tok);
+enum tep_event_type tep_read_token(char **tok);
 void tep_free_token(char *token);
 int tep_peek_char(void);
 const char *tep_get_input_buf(void);
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index e7133fc280a9..a637cc6ed64d 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -75,15 +75,15 @@ static void free_token(char *token)
 	tep_free_token(token);
 }
 
-static enum event_type read_token(char **tok)
+static enum tep_event_type read_token(char **tok)
 {
-	enum event_type type;
+	enum tep_event_type type;
 	char *token = NULL;
 
 	do {
 		free_token(token);
 		type = tep_read_token(&token);
-	} while (type == EVENT_NEWLINE || type == EVENT_SPACE);
+	} while (type == TEP_EVENT_NEWLINE || type == TEP_EVENT_SPACE);
 
 	/* If token is = or ! check to see if the next char is ~ */
 	if (token &&
@@ -93,7 +93,7 @@ static enum event_type read_token(char **tok)
 		*tok = malloc(3);
 		if (*tok == NULL) {
 			free_token(token);
-			return EVENT_ERROR;
+			return TEP_EVENT_ERROR;
 		}
 		sprintf(*tok, "%c%c", *token, '~');
 		free_token(token);
@@ -348,7 +348,7 @@ static void free_events(struct event_list *events)
 
 static enum tep_errno
 create_arg_item(struct tep_event_format *event, const char *token,
-		enum event_type type, struct filter_arg **parg, char *error_str)
+		enum tep_event_type type, struct filter_arg **parg, char *error_str)
 {
 	struct tep_format_field *field;
 	struct filter_arg *arg;
@@ -361,11 +361,11 @@ create_arg_item(struct tep_event_format *event, const char *token,
 
 	switch (type) {
 
-	case EVENT_SQUOTE:
-	case EVENT_DQUOTE:
+	case TEP_EVENT_SQUOTE:
+	case TEP_EVENT_DQUOTE:
 		arg->type = FILTER_ARG_VALUE;
 		arg->value.type =
-			type == EVENT_DQUOTE ? FILTER_STRING : FILTER_CHAR;
+			type == TEP_EVENT_DQUOTE ? FILTER_STRING : FILTER_CHAR;
 		arg->value.str = strdup(token);
 		if (!arg->value.str) {
 			free_arg(arg);
@@ -373,7 +373,7 @@ create_arg_item(struct tep_event_format *event, const char *token,
 			return TEP_ERRNO__MEM_ALLOC_FAILED;
 		}
 		break;
-	case EVENT_ITEM:
+	case TEP_EVENT_ITEM:
 		/* if it is a number, then convert it */
 		if (isdigit(token[0])) {
 			arg->type = FILTER_ARG_VALUE;
@@ -956,7 +956,7 @@ static enum tep_errno
 process_filter(struct tep_event_format *event, struct filter_arg **parg,
 	       char *error_str, int not)
 {
-	enum event_type type;
+	enum tep_event_type type;
 	char *token = NULL;
 	struct filter_arg *current_op = NULL;
 	struct filter_arg *current_exp = NULL;
@@ -974,9 +974,9 @@ process_filter(struct tep_event_format *event, struct filter_arg **parg,
 		free(token);
 		type = read_token(&token);
 		switch (type) {
-		case EVENT_SQUOTE:
-		case EVENT_DQUOTE:
-		case EVENT_ITEM:
+		case TEP_EVENT_SQUOTE:
+		case TEP_EVENT_DQUOTE:
+		case TEP_EVENT_ITEM:
 			ret = create_arg_item(event, token, type, &arg, error_str);
 			if (ret < 0)
 				goto fail;
@@ -1001,7 +1001,7 @@ process_filter(struct tep_event_format *event, struct filter_arg **parg,
 			arg = NULL;
 			break;
 
-		case EVENT_DELIM:
+		case TEP_EVENT_DELIM:
 			if (*token == ',') {
 				show_error(error_str, "Illegal token ','");
 				ret = TEP_ERRNO__ILLEGAL_TOKEN;
@@ -1068,7 +1068,7 @@ process_filter(struct tep_event_format *event, struct filter_arg **parg,
 			}
 			break;
 
-		case EVENT_OP:
+		case TEP_EVENT_OP:
 			op_type = process_op(token, &btype, &ctype, &etype);
 
 			/* All expect a left arg except for NOT */
@@ -1153,14 +1153,14 @@ process_filter(struct tep_event_format *event, struct filter_arg **parg,
 			if (ret < 0)
 				goto fail_syntax;
 			break;
-		case EVENT_NONE:
+		case TEP_EVENT_NONE:
 			break;
-		case EVENT_ERROR:
+		case TEP_EVENT_ERROR:
 			goto fail_alloc;
 		default:
 			goto fail_syntax;
 		}
-	} while (type != EVENT_NONE);
+	} while (type != TEP_EVENT_NONE);
 
 	if (!current_op && !current_exp)
 		goto fail_syntax;
-- 
2.17.1
