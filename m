Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86DCF17C61
	for <linux-trace-devel@vger.kernel.org>; Mon, 28 Oct 2024 12:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730118086; cv=none; b=rHXHyLt2jT5SLwxbfDNmFNeBi0DhWs4TfUfWw96MpLcn2aYkdIXcZhVPNNustFfX0nOnerwAzSNg5Voi9zOhT5ooHLjfCQS1KYKz/hN77eSw8rEdxv3N6Qzw4RDaywNrMOLlb45lNh/FVL5HlwrOp0N0wusHBoRnR/jIoWmvpo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730118086; c=relaxed/simple;
	bh=8G2CtQemT+Dn/dCc4qVR5RwF+9uXpmZBtolDjA342P0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cl84nOiZKM7d7L7qmtLzbfcNDlBOwja7nWEvlY1zWe3IpIDPzxLApRystBv4sa6wv/aLBcYUoLVrsY0y3an8gGVFjtclodyEEn6QnXBzXRxy9wiOzKnYRlj6rBHgVk8S4NSDy54ioiUfbpMBwmj7ElT2yN8Xs1zOB1wO75T2Rns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B318497;
	Mon, 28 Oct 2024 05:21:48 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 98E193F73B;
	Mon, 28 Oct 2024 05:21:17 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com,
	Douglas Raillard <douglas.raillard@arm.com>
Subject: [PATCH] libtraceevent: Rename private functions to prevent static build failures
Date: Mon, 28 Oct 2024 12:21:05 +0000
Message-Id: <20241028122105.1594296-1-metin.kaya@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Building trace-cmd statically fails because of duplicated symbols for
strstrip() function which is implemented both in trace-cmd and
libtracefs. The __hidden attribute does not resolve these conflicts for
static builds due to the lack of namespacing support in C. Refer to the
associated Bugzilla page [1] for further details.

Although strstrip() breakage is out of libtraceevent's scope for now,
proactively take a preventive action to fix the underlying issue
comprehensively across the libtraceevent, libtracefs, and trace-cmd
packages. Follow the recommendation on [1] and prepend "traceevent_"
prefix to all private functions (tagged with __hidden attribute).

Future __hidden functions should follow this prefixing schemed to avoid
new naming conflicts.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=217768

Cc: Douglas Raillard <douglas.raillard@arm.com>
Signed-off-by: Metin Kaya <metin.kaya@arm.com>
---
 src/event-parse-api.c   |   6 +-
 src/event-parse-local.h |  24 ++--
 src/event-parse.c       | 290 ++++++++++++++++++++--------------------
 src/event-plugin.c      |   2 +-
 src/parse-filter.c      |  22 +--
 5 files changed, 172 insertions(+), 172 deletions(-)

diff --git a/src/event-parse-api.c b/src/event-parse-api.c
index fd03daf..7db0c7d 100644
--- a/src/event-parse-api.c
+++ b/src/event-parse-api.c
@@ -106,7 +106,7 @@ bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
 	return false;
 }
 
-__hidden unsigned short data2host2(struct tep_handle *tep, unsigned short data)
+__hidden unsigned short traceevent_data2host2(struct tep_handle *tep, unsigned short data)
 {
 	unsigned short swap;
 
@@ -119,7 +119,7 @@ __hidden unsigned short data2host2(struct tep_handle *tep, unsigned short data)
 	return swap;
 }
 
-__hidden unsigned int data2host4(struct tep_handle *tep, unsigned int data)
+__hidden unsigned int traceevent_data2host4(struct tep_handle *tep, unsigned int data)
 {
 	unsigned int swap;
 
@@ -135,7 +135,7 @@ __hidden unsigned int data2host4(struct tep_handle *tep, unsigned int data)
 }
 
 __hidden  unsigned long long
-data2host8(struct tep_handle *tep, unsigned long long data)
+traceevent_data2host8(struct tep_handle *tep, unsigned long long data)
 {
 	unsigned long long swap;
 
diff --git a/src/event-parse-local.h b/src/event-parse-local.h
index c6bfc61..8ddcb89 100644
--- a/src/event-parse-local.h
+++ b/src/event-parse-local.h
@@ -108,20 +108,20 @@ struct tep_print_parse {
 	struct tep_print_arg		*len_as_arg;
 };
 
-void free_tep_event(struct tep_event *event);
-void free_tep_format_field(struct tep_format_field *field);
-void free_tep_plugin_paths(struct tep_handle *tep);
+void traceevent_free_tep_event(struct tep_event *event);
+void traceevent_free_tep_format_field(struct tep_format_field *field);
+void traceevent_free_tep_plugin_paths(struct tep_handle *tep);
 
-unsigned short data2host2(struct tep_handle *tep, unsigned short data);
-unsigned int data2host4(struct tep_handle *tep, unsigned int data);
-unsigned long long data2host8(struct tep_handle *tep, unsigned long long data);
+unsigned short traceevent_data2host2(struct tep_handle *tep, unsigned short data);
+unsigned int traceevent_data2host4(struct tep_handle *tep, unsigned int data);
+unsigned long long traceevent_data2host8(struct tep_handle *tep, unsigned long long data);
 
 /* access to the internal parser */
-int peek_char(struct tep_handle *tep);
-void init_input_buf(struct tep_handle *tep, const char *buf, unsigned long long size);
-unsigned long long get_input_buf_ptr(struct tep_handle *tep);
-const char *get_input_buf(struct tep_handle *tep);
-enum tep_event_type read_token(struct tep_handle *tep, char **tok);
-void free_token(char *tok);
+int traceevent_peek_char(struct tep_handle *tep);
+void traceevent_init_input_buf(struct tep_handle *tep, const char *buf, unsigned long long size);
+unsigned long long traceevent_get_input_buf_ptr(struct tep_handle *tep);
+const char *traceevent_get_input_buf(struct tep_handle *tep);
+enum tep_event_type traceevent_read_token(struct tep_handle *tep, char **tok);
+void traceevent_free_token(char *tok);
 
 #endif /* _PARSE_EVENTS_INT_H */
diff --git a/src/event-parse.c b/src/event-parse.c
index 0427061..9740dee 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -52,13 +52,13 @@ static int show_warning = 1;
 	} while (0)
 
 /**
- * init_input_buf - init buffer for parsing
+ * traceevent_init_input_buf - init buffer for parsing
  * @buf: buffer to parse
  * @size: the size of the buffer
  *
  * Initializes the internal buffer that tep_read_token() will parse.
  */
-__hidden void init_input_buf(struct tep_handle *tep, const char *buf,
+__hidden void traceevent_init_input_buf(struct tep_handle *tep, const char *buf,
 		unsigned long long size)
 {
 	tep->input_buf = buf;
@@ -66,12 +66,12 @@ __hidden void init_input_buf(struct tep_handle *tep, const char *buf,
 	tep->input_buf_ptr = 0;
 }
 
-__hidden const char *get_input_buf(struct tep_handle *tep)
+__hidden const char *traceevent_get_input_buf(struct tep_handle *tep)
 {
 	return tep->input_buf;
 }
 
-__hidden unsigned long long get_input_buf_ptr(struct tep_handle *tep)
+__hidden unsigned long long traceevent_get_input_buf_ptr(struct tep_handle *tep)
 {
 	return tep->input_buf_ptr;
 }
@@ -1174,11 +1174,11 @@ static int __read_char(struct tep_handle *tep)
 }
 
 /**
- * peek_char - peek at the next character that will be read
+ * traceevent_peek_char - peek at the next character that will be read
  *
  * Returns the next character read, or -1 if end of buffer.
  */
-__hidden int peek_char(struct tep_handle *tep)
+__hidden int traceevent_peek_char(struct tep_handle *tep)
 {
 	if (tep->input_buf_ptr >= tep->input_buf_siz)
 		return -1;
@@ -1242,7 +1242,7 @@ static enum tep_event_type __read_token(struct tep_handle *tep, char **tok)
 	case TEP_EVENT_OP:
 		switch (ch) {
 		case '-':
-			next_ch = peek_char(tep);
+			next_ch = traceevent_peek_char(tep);
 			if (next_ch == '>') {
 				buf[i++] = __read_char(tep);
 				break;
@@ -1254,7 +1254,7 @@ static enum tep_event_type __read_token(struct tep_handle *tep, char **tok)
 		case '>':
 		case '<':
 			last_ch = ch;
-			ch = peek_char(tep);
+			ch = traceevent_peek_char(tep);
 			if (ch != last_ch)
 				goto test_equal;
 			buf[i++] = __read_char(tep);
@@ -1277,7 +1277,7 @@ static enum tep_event_type __read_token(struct tep_handle *tep, char **tok)
 		return type;
 
  test_equal:
-		ch = peek_char(tep);
+		ch = traceevent_peek_char(tep);
 		if (ch == '=')
 			buf[i++] = __read_char(tep);
 		goto out;
@@ -1337,7 +1337,7 @@ static enum tep_event_type __read_token(struct tep_handle *tep, char **tok)
 		break;
 	}
 
-	while (get_type(peek_char(tep)) == type) {
+	while (get_type(traceevent_peek_char(tep)) == type) {
 		if (i == (BUFSIZ - 1)) {
 			buf[i] = 0;
 			tok_size += BUFSIZ;
@@ -1395,7 +1395,7 @@ static enum tep_event_type force_token(struct tep_handle *tep, const char *str,
 	save_input_buf_ptr = tep->input_buf_ptr;
 	save_input_buf_siz = tep->input_buf_siz;
 
-	init_input_buf(tep, str, strlen(str));
+	traceevent_init_input_buf(tep, str, strlen(str));
 
 	type = __read_token(tep, tok);
 
@@ -1408,17 +1408,17 @@ static enum tep_event_type force_token(struct tep_handle *tep, const char *str,
 }
 
 /**
- * free_token - free a token returned by tep_read_token
+ * traceevent_free_token - free a token returned by tep_read_token
  * @token: the token to free
  */
-__hidden void free_token(char *tok)
+__hidden void traceevent_free_token(char *tok)
 {
 	if (tok)
 		free(tok);
 }
 
 /**
- * read_token - access to utilities to use the tep parser
+ * traceevent_read_token - access to utilities to use the tep parser
  * @tok: The token to return
  *
  * This will parse tokens from the string given by
@@ -1426,7 +1426,7 @@ __hidden void free_token(char *tok)
  *
  * Returns the token type.
  */
-__hidden enum tep_event_type read_token(struct tep_handle *tep, char **tok)
+__hidden enum tep_event_type traceevent_read_token(struct tep_handle *tep, char **tok)
 {
 	enum tep_event_type type;
 
@@ -1435,7 +1435,7 @@ __hidden enum tep_event_type read_token(struct tep_handle *tep, char **tok)
 		if (type != TEP_EVENT_SPACE)
 			return type;
 
-		free_token(*tok);
+		traceevent_free_token(*tok);
 	}
 
 	/* not reached */
@@ -1452,7 +1452,7 @@ static enum tep_event_type read_token_item(struct tep_handle *tep, char **tok)
 		type = __read_token(tep, tok);
 		if (type != TEP_EVENT_SPACE && type != TEP_EVENT_NEWLINE)
 			return type;
-		free_token(*tok);
+		traceevent_free_token(*tok);
 		*tok = NULL;
 	}
 
@@ -1496,7 +1496,7 @@ static int __read_expect_type(struct tep_handle *tep, enum tep_event_type expect
 	enum tep_event_type type;
 
 	if (newline_ok)
-		type = read_token(tep, tok);
+		type = traceevent_read_token(tep, tok);
 	else
 		type = read_token_item(tep, tok);
 	return test_type(type, expect);
@@ -1516,13 +1516,13 @@ static int __read_expected(struct tep_handle *tep, enum tep_event_type expect,
 	int ret;
 
 	if (newline_ok)
-		type = read_token(tep, &token);
+		type = traceevent_read_token(tep, &token);
 	else
 		type = read_token_item(tep, &token);
 
 	ret = test_type_token(type, token, expect, str);
 
-	free_token(token);
+	traceevent_free_token(token);
 
 	return ret;
 }
@@ -1555,7 +1555,7 @@ static char *event_read_name(struct tep_handle *tep)
 	return token;
 
  fail:
-	free_token(token);
+	traceevent_free_token(token);
 	return NULL;
 }
 
@@ -1574,11 +1574,11 @@ static int event_read_id(struct tep_handle *tep)
 		goto fail;
 
 	id = strtoul(token, NULL, 0);
-	free_token(token);
+	traceevent_free_token(token);
 	return id;
 
  fail:
-	free_token(token);
+	traceevent_free_token(token);
 	return -1;
 }
 
@@ -1672,9 +1672,9 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 	do {
 		unsigned int size_dynamic = 0;
 
-		type = read_token(tep, &token);
+		type = traceevent_read_token(tep, &token);
 		if (type == TEP_EVENT_NEWLINE) {
-			free_token(token);
+			traceevent_free_token(token);
 			return count;
 		}
 
@@ -1682,23 +1682,23 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 
 		if (test_type_token(type, token, TEP_EVENT_ITEM, "field"))
 			goto fail;
-		free_token(token);
+		traceevent_free_token(token);
 
-		type = read_token(tep, &token);
+		type = traceevent_read_token(tep, &token);
 		/*
 		 * The ftrace fields may still use the "special" name.
 		 * Just ignore it.
 		 */
 		if (event->flags & TEP_EVENT_FL_ISFTRACE &&
 		    type == TEP_EVENT_ITEM && strcmp(token, "special") == 0) {
-			free_token(token);
-			type = read_token(tep, &token);
+			traceevent_free_token(token);
+			type = traceevent_read_token(tep, &token);
 		}
 
 		if (test_type_token(type, token, TEP_EVENT_OP, ":") < 0)
 			goto fail;
 
-		free_token(token);
+		traceevent_free_token(token);
 		if (read_expect_type(tep, TEP_EVENT_ITEM, &token) < 0)
 			goto fail;
 
@@ -1712,7 +1712,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 
 		/* read the rest of the type */
 		for (;;) {
-			type = read_token(tep, &token);
+			type = traceevent_read_token(tep, &token);
 			if (type == TEP_EVENT_ITEM ||
 			    (type == TEP_EVENT_OP && strcmp(token, "*") == 0) ||
 			    /*
@@ -1750,7 +1750,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 					goto fail;
 
 				delim = " ";
-				while ((type = read_token(tep, &token)) != TEP_EVENT_NONE) {
+				while ((type = traceevent_read_token(tep, &token)) != TEP_EVENT_NONE) {
 					if (type == TEP_EVENT_DELIM) {
 						if (token[0] == '(')
 							depth++;
@@ -1789,7 +1789,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 
 			field->flags |= TEP_FIELD_IS_ARRAY;
 
-			type = read_token(tep, &token);
+			type = traceevent_read_token(tep, &token);
 
 			if (type == TEP_EVENT_ITEM)
 				field->arraylen = strtoul(token, NULL, 0);
@@ -1814,8 +1814,8 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 				}
 				/* We only care about the last token */
 				field->arraylen = strtoul(token, NULL, 0);
-				free_token(token);
-				type = read_token(tep, &token);
+				traceevent_free_token(token);
+				type = traceevent_read_token(tep, &token);
 				if (type == TEP_EVENT_NONE) {
 					free(brackets);
 					do_warning_event(event, "failed to find token");
@@ -1823,7 +1823,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 				}
 			}
 
-			free_token(token);
+			traceevent_free_token(token);
 
 			ret = append(&brackets, "", "]");
 			if (ret < 0) {
@@ -1833,7 +1833,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 
 			/* add brackets to type */
 
-			type = read_token(tep, &token);
+			type = traceevent_read_token(tep, &token);
 			/*
 			 * If the next token is not an OP, then it is of
 			 * the format: type [] item;
@@ -1847,9 +1847,9 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 				ret = append(&field->type, "", brackets);
 
 				size_dynamic = type_size(field->name);
-				free_token(field->name);
+				traceevent_free_token(field->name);
 				field->name = field->alias = token;
-				type = read_token(tep, &token);
+				type = traceevent_read_token(tep, &token);
 			} else {
 				ret = append(&field->type, "", brackets);
 				if (ret < 0) {
@@ -1871,7 +1871,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 
 		if (test_type_token(type, token,  TEP_EVENT_OP, ";"))
 			goto fail;
-		free_token(token);
+		traceevent_free_token(token);
 
 		if (read_expected(tep, TEP_EVENT_ITEM, "offset") < 0)
 			goto fail_expect;
@@ -1882,7 +1882,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 		if (read_expect_type(tep, TEP_EVENT_ITEM, &token))
 			goto fail;
 		field->offset = strtoul(token, NULL, 0);
-		free_token(token);
+		traceevent_free_token(token);
 
 		if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 			goto fail_expect;
@@ -1896,7 +1896,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 		if (read_expect_type(tep, TEP_EVENT_ITEM, &token))
 			goto fail;
 		field->size = strtoul(token, NULL, 0);
-		free_token(token);
+		traceevent_free_token(token);
 
 		/*
 		 * The old data format before dynamic arrays had dynamic
@@ -1911,13 +1911,13 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 		if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 			goto fail_expect;
 
-		type = read_token(tep, &token);
+		type = traceevent_read_token(tep, &token);
 		if (type != TEP_EVENT_NEWLINE) {
 			/* newer versions of the kernel have a "signed" type */
 			if (test_type_token(type, token, TEP_EVENT_ITEM, "signed"))
 				goto fail;
 
-			free_token(token);
+			traceevent_free_token(token);
 
 			if (read_expected(tep, TEP_EVENT_OP, ":") < 0)
 				goto fail_expect;
@@ -1928,7 +1928,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 			if (strtoul(token, NULL, 0))
 				field->flags |= TEP_FIELD_IS_SIGNED;
 
-			free_token(token);
+			traceevent_free_token(token);
 			if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 				goto fail_expect;
 
@@ -1936,7 +1936,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 				goto fail;
 		}
 
-		free_token(token);
+		traceevent_free_token(token);
 
 		if (field->flags & (TEP_FIELD_IS_ARRAY | TEP_FIELD_IS_DYNAMIC)) {
 			if (field->arraylen)
@@ -1961,7 +1961,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 	return 0;
 
 fail:
-	free_token(token);
+	traceevent_free_token(token);
 fail_expect:
 	if (field) {
 		free(field->type);
@@ -1984,7 +1984,7 @@ static int event_read_format(struct tep_event *event)
 
 	if (read_expect_type(event->tep, TEP_EVENT_NEWLINE, &token))
 		goto fail;
-	free_token(token);
+	traceevent_free_token(token);
 
 	ret = event_read_fields(event->tep, event, &event->format.common_fields);
 	if (ret < 0)
@@ -1999,7 +1999,7 @@ static int event_read_format(struct tep_event *event)
 	return 0;
 
  fail:
-	free_token(token);
+	traceevent_free_token(token);
 	return -1;
 }
 
@@ -2013,7 +2013,7 @@ process_arg(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	enum tep_event_type type;
 	char *token;
 
-	type = read_token(event->tep, &token);
+	type = traceevent_read_token(event->tep, &token);
 	*tok = token;
 
 	return process_arg_token(event, arg, tok, type);
@@ -2091,7 +2091,7 @@ process_cond(struct tep_event *event, struct tep_print_arg *top, char **tok)
 out_free:
 	/* Top may point to itself */
 	top->op.right = NULL;
-	free_token(token);
+	traceevent_free_token(token);
 	free_arg(arg);
 	return TEP_EVENT_ERROR;
 }
@@ -2118,14 +2118,14 @@ process_array(struct tep_event *event, struct tep_print_arg *top, char **tok)
 
 	top->op.right = arg;
 
-	free_token(token);
+	traceevent_free_token(token);
 	type = read_token_item(event->tep, &token);
 	*tok = token;
 
 	return type;
 
 out_free:
-	free_token(token);
+	traceevent_free_token(token);
 	free_arg(arg);
 	return TEP_EVENT_ERROR;
 }
@@ -2510,7 +2510,7 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 out_warn_free:
 	do_warning_event(event, "%s: not enough memory!", __func__);
 out_free:
-	free_token(token);
+	traceevent_free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -2537,7 +2537,7 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 	if (test_type_token(type, token,  TEP_EVENT_OP, "->"))
 		goto out_free;
 
-	free_token(token);
+	traceevent_free_token(token);
 
 	if (read_expect_type(event->tep, TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
@@ -2556,13 +2556,13 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 		is_symbolic_field = 0;
 	}
 
-	type = read_token(event->tep, &token);
+	type = traceevent_read_token(event->tep, &token);
 	*tok = token;
 
 	return type;
 
  out_free:
-	free_token(token);
+	traceevent_free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -2601,7 +2601,7 @@ static int alloc_and_process_delim(struct tep_event *event, char *next_token,
 	*print_arg = field;
 
 out_free_token:
-	free_token(token);
+	traceevent_free_token(token);
 
 	return ret;
 out_error:
@@ -2929,7 +2929,7 @@ process_fields(struct tep_event *event, struct tep_print_flag_sym **list, char *
 	char *value;
 
 	do {
-		free_token(token);
+		traceevent_free_token(token);
 		type = read_token_item(event->tep, &token);
 		if (test_type_token(type, token, TEP_EVENT_OP, "{"))
 			break;
@@ -2938,7 +2938,7 @@ process_fields(struct tep_event *event, struct tep_print_flag_sym **list, char *
 		if (!arg)
 			goto out_free;
 
-		free_token(token);
+		traceevent_free_token(token);
 		type = process_arg(event, arg, &token);
 
 		if (type == TEP_EVENT_OP)
@@ -2966,7 +2966,7 @@ process_fields(struct tep_event *event, struct tep_print_flag_sym **list, char *
 		if (!arg)
 			goto out_free_field;
 
-		free_token(token);
+		traceevent_free_token(token);
 		type = process_arg(event, arg, &token);
 		if (test_type_token(type, token, TEP_EVENT_OP, "}"))
 			goto out_free_field;
@@ -2983,7 +2983,7 @@ process_fields(struct tep_event *event, struct tep_print_flag_sym **list, char *
 		*list = field;
 		list = &field->next;
 
-		free_token(token);
+		traceevent_free_token(token);
 		type = read_token_item(event->tep, &token);
 	} while (type == TEP_EVENT_DELIM && strcmp(token, ",") == 0);
 
@@ -2994,7 +2994,7 @@ out_free_field:
 	free_flag_sym(field);
 out_free:
 	free_arg(arg);
-	free_token(token);
+	traceevent_free_token(token);
 	*tok = NULL;
 
 	return TEP_EVENT_ERROR;
@@ -3024,7 +3024,7 @@ process_flags(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 	if (test_type_token(type, token, TEP_EVENT_DELIM, ","))
 		goto out_free_field;
-	free_token(token);
+	traceevent_free_token(token);
 
 	arg->flags.field = field;
 
@@ -3041,14 +3041,14 @@ process_flags(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	if (test_type_token(type, token, TEP_EVENT_DELIM, ")"))
 		goto out_free;
 
-	free_token(token);
+	traceevent_free_token(token);
 	type = read_token_item(event->tep, tok);
 	return type;
 
 out_free_field:
 	free_arg(field);
 out_free:
-	free_token(token);
+	traceevent_free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -3080,14 +3080,14 @@ process_symbols(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	if (test_type_token(type, token, TEP_EVENT_DELIM, ")"))
 		goto out_free;
 
-	free_token(token);
+	traceevent_free_token(token);
 	type = read_token_item(event->tep, tok);
 	return type;
 
 out_free_field:
 	free_arg(field);
 out_free:
-	free_token(token);
+	traceevent_free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -3170,7 +3170,7 @@ process_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, char *
 	 * The item within the parenthesis is another field that holds
 	 * the index into where the array starts.
 	 */
-	type = read_token(event->tep, &token);
+	type = traceevent_read_token(event->tep, &token);
 	*tok = token;
 	if (type != TEP_EVENT_ITEM)
 		goto out_free;
@@ -3187,13 +3187,13 @@ process_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, char *
 	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
 		goto out_free;
 
-	free_token(token);
+	traceevent_free_token(token);
 	type = read_token_item(event->tep, &token);
 	*tok = token;
 	if (type != TEP_EVENT_OP || strcmp(token, "[") != 0)
 		return type;
 
-	free_token(token);
+	traceevent_free_token(token);
 	arg = alloc_arg();
 	if (!arg) {
 		do_warning_event(event, "%s: not enough memory!", __func__);
@@ -3208,14 +3208,14 @@ process_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, char *
 	if (!test_type_token(type, token, TEP_EVENT_OP, "]"))
 		goto out_free_arg;
 
-	free_token(token);
+	traceevent_free_token(token);
 	type = read_token_item(event->tep, tok);
 	return type;
 
  out_free_arg:
 	free_arg(arg);
  out_free:
-	free_token(token);
+	traceevent_free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -3244,14 +3244,14 @@ process_dynamic_array_len(struct tep_event *event, struct tep_print_arg *arg,
 	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
 
-	free_token(token);
-	type = read_token(event->tep, &token);
+	traceevent_free_token(token);
+	type = traceevent_read_token(event->tep, &token);
 	*tok = token;
 
 	return type;
 
  out_free:
-	free_token(token);
+	traceevent_free_token(token);
  out_err:
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
@@ -3282,14 +3282,14 @@ process_paren(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	 * and return.
 	 */
 	if (type == TEP_EVENT_ITEM && strcmp(token, ")") == 0) {
-		free_token(token);
+		traceevent_free_token(token);
 		return process_entry(event, arg, tok);
 	}
 
 	if (test_type_token(type, token, TEP_EVENT_DELIM, ")"))
 		goto out_free;
 
-	free_token(token);
+	traceevent_free_token(token);
 	type = read_token_item(event->tep, &token);
 
 	/*
@@ -3325,7 +3325,7 @@ process_paren(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	return type;
 
  out_free:
-	free_token(token);
+	traceevent_free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -3348,13 +3348,13 @@ process_str(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
 
-	type = read_token(event->tep, &token);
+	type = traceevent_read_token(event->tep, &token);
 	*tok = token;
 
 	return type;
 
  out_free:
-	free_token(token);
+	traceevent_free_token(token);
  out_err:
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
@@ -3377,13 +3377,13 @@ process_bitmask(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
 
-	type = read_token(event->tep, &token);
+	type = traceevent_read_token(event->tep, &token);
 	*tok = token;
 
 	return type;
 
  out_free:
-	free_token(token);
+	traceevent_free_token(token);
  out_err:
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
@@ -3476,17 +3476,17 @@ process_func_handler(struct tep_event *event, struct tep_function_handler *func,
 
 		*next_arg = farg;
 		next_arg = &(farg->next);
-		free_token(token);
+		traceevent_free_token(token);
 	}
 
-	type = read_token(event->tep, &token);
+	type = traceevent_read_token(event->tep, &token);
 	*tok = token;
 
 	return type;
 
 err:
 	free_arg(farg);
-	free_token(token);
+	traceevent_free_token(token);
 	return TEP_EVENT_ERROR;
 }
 
@@ -3502,7 +3502,7 @@ process_builtin_expect(struct tep_event *event, struct tep_print_arg *arg, char
 	if (type != TEP_EVENT_DELIM || token[0] != ',')
 		goto out_free;
 
-	free_token(token);
+	traceevent_free_token(token);
 
 	/* We don't care what the second parameter is of the __builtin_expect() */
 	if (read_expect_type(event->tep, TEP_EVENT_ITEM, &token) < 0)
@@ -3511,12 +3511,12 @@ process_builtin_expect(struct tep_event *event, struct tep_print_arg *arg, char
 	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
 		goto out_free;
 
-	free_token(token);
+	traceevent_free_token(token);
 	type = read_token_item(event->tep, tok);
 	return type;
 
 out_free:
-	free_token(token);
+	traceevent_free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -3536,7 +3536,7 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 	/* We handle some sizeof types */
 	if (strcmp(token, "unsigned") == 0) {
-		free_token(token);
+		traceevent_free_token(token);
 		type = read_token_item(event->tep, &token);
 
 		if (type == TEP_EVENT_ERROR)
@@ -3551,7 +3551,7 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 		arg->atom.atom = strdup("4");
 
 	} else if (strcmp(token, "long") == 0) {
-		free_token(token);
+		traceevent_free_token(token);
 		type = read_token_item(event->tep, &token);
 
 		if (token && strcmp(token, "long") == 0) {
@@ -3590,12 +3590,12 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 	} else if (strcmp(token, "REC") == 0) {
 
-		free_token(token);
+		traceevent_free_token(token);
 		type = read_token_item(event->tep, &token);
 
 		if (test_type_token(type, token,  TEP_EVENT_OP, "->"))
 			goto error;
-		free_token(token);
+		traceevent_free_token(token);
 
 		if (read_expect_type(event->tep, TEP_EVENT_ITEM, &token) < 0)
 			goto error;
@@ -3615,16 +3615,16 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 	if (!token_has_paren) {
 		/* The token contains the last item before the parenthesis */
-		free_token(token);
+		traceevent_free_token(token);
 		type = read_token_item(event->tep, &token);
 	}
 	if (test_type_token(type, token,  TEP_EVENT_DELIM, ")"))
 		goto error;
 
-	free_token(token);
+	traceevent_free_token(token);
 	return read_token_item(event->tep, tok);
 error:
-	free_token(token);
+	traceevent_free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -3636,71 +3636,71 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
 	struct tep_function_handler *func;
 
 	if (strcmp(token, "__print_flags") == 0) {
-		free_token(token);
+		traceevent_free_token(token);
 		is_flag_field = 1;
 		return process_flags(event, arg, tok);
 	}
 	if (strcmp(token, "__print_symbolic") == 0) {
-		free_token(token);
+		traceevent_free_token(token);
 		is_symbolic_field = 1;
 		return process_symbols(event, arg, tok);
 	}
 	if (strcmp(token, "__print_hex") == 0) {
-		free_token(token);
+		traceevent_free_token(token);
 		return process_hex(event, arg, tok);
 	}
 	if (strcmp(token, "__print_hex_str") == 0) {
-		free_token(token);
+		traceevent_free_token(token);
 		return process_hex_str(event, arg, tok);
 	}
 	if (strcmp(token, "__print_array") == 0) {
-		free_token(token);
+		traceevent_free_token(token);
 		return process_int_array(event, arg, tok);
 	}
 	if (strcmp(token, "__get_str") == 0 ||
 	    strcmp(token, "__get_rel_str") == 0) {
-		free_token(token);
+		traceevent_free_token(token);
 		return process_str(event, arg, tok);
 	}
 	if (strcmp(token, "__get_bitmask") == 0 ||
 	    strcmp(token, "__get_rel_bitmask") == 0) {
-		free_token(token);
+		traceevent_free_token(token);
 		return process_bitmask(event, arg, tok);
 	}
 	if (strcmp(token, "__get_cpumask") == 0 ||
 	    strcmp(token, "__get_rel_cpumask") == 0) {
-		free_token(token);
+		traceevent_free_token(token);
 		return process_cpumask(event, arg, tok);
 	}
 	if (strcmp(token, "__get_dynamic_array") == 0 ||
 	    strcmp(token, "__get_rel_dynamic_array") == 0 ||
 	    strcmp(token, "__get_sockaddr") == 0 ||
 	    strcmp(token, "__get_sockaddr_rel") == 0) {
-		free_token(token);
+		traceevent_free_token(token);
 		return process_dynamic_array(event, arg, tok);
 	}
 	if (strcmp(token, "__get_dynamic_array_len") == 0 ||
 	    strcmp(token, "__get_rel_dynamic_array_len") == 0) {
-		free_token(token);
+		traceevent_free_token(token);
 		return process_dynamic_array_len(event, arg, tok);
 	}
 	if (strcmp(token, "__builtin_expect") == 0) {
-		free_token(token);
+		traceevent_free_token(token);
 		return process_builtin_expect(event, arg, tok);
 	}
 	if (strcmp(token, "sizeof") == 0) {
-		free_token(token);
+		traceevent_free_token(token);
 		return process_sizeof(event, arg, tok);
 	}
 
 	func = find_func_handler(event->tep, token);
 	if (func) {
-		free_token(token);
+		traceevent_free_token(token);
 		return process_func_handler(event, func, arg, tok);
 	}
 
 	do_warning_event(event, "function %s not defined", token);
-	free_token(token);
+	traceevent_free_token(token);
 	return TEP_EVENT_ERROR;
 }
 
@@ -3716,7 +3716,7 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 	switch (type) {
 	case TEP_EVENT_ITEM:
 		if (strcmp(token, "REC") == 0) {
-			free_token(token);
+			traceevent_free_token(token);
 			type = process_entry(event, arg, &token);
 			break;
 		}
@@ -3729,7 +3729,7 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 		 * is a function.
 		 */
 		if (type == TEP_EVENT_DELIM && strcmp(token, "(") == 0) {
-			free_token(token);
+			traceevent_free_token(token);
 			token = NULL;
 			/* this will free atom. */
 			type = process_function(event, arg, atom, &token);
@@ -3743,10 +3743,10 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 			if (ret < 0) {
 				free(atom);
 				*tok = NULL;
-				free_token(token);
+				traceevent_free_token(token);
 				return TEP_EVENT_ERROR;
 			}
-			free_token(token);
+			traceevent_free_token(token);
 			type = read_token_item(event->tep, &token);
 		}
 
@@ -3758,12 +3758,12 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 		arg->type = TEP_PRINT_ATOM;
 		/* Make characters into numbers */
 		if (asprintf(&arg->atom.atom, "%d", token[0]) < 0) {
-			free_token(token);
+			traceevent_free_token(token);
 			*tok = NULL;
 			arg->atom.atom = NULL;
 			return TEP_EVENT_ERROR;
 		}
-		free_token(token);
+		traceevent_free_token(token);
 		type = read_token_item(event->tep, &token);
 		break;
 	case TEP_EVENT_DQUOTE:
@@ -3773,7 +3773,7 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 		break;
 	case TEP_EVENT_DELIM:
 		if (strcmp(token, "(") == 0) {
-			free_token(token);
+			traceevent_free_token(token);
 			type = process_paren(event, arg, &token);
 			break;
 		}
@@ -3824,7 +3824,7 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
 		type = process_arg(event, arg, &token);
 
 		if (type == TEP_EVENT_ERROR) {
-			free_token(token);
+			traceevent_free_token(token);
 			free_arg(arg);
 			return -1;
 		}
@@ -3834,7 +3834,7 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
 
 		if (type == TEP_EVENT_OP) {
 			type = process_op(event, arg, &token);
-			free_token(token);
+			traceevent_free_token(token);
 
 			if (consolidate_op_arg(type, arg) < 0)
 				type = TEP_EVENT_ERROR;
@@ -3849,7 +3849,7 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
 		}
 
 		if (type == TEP_EVENT_DELIM && strcmp(token, ",") == 0) {
-			free_token(token);
+			traceevent_free_token(token);
 			*list = arg;
 			list = &arg->next;
 			continue;
@@ -3858,7 +3858,7 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
 	} while (type != TEP_EVENT_NONE);
 
 	if (type != TEP_EVENT_NONE && type != TEP_EVENT_ERROR)
-		free_token(token);
+		traceevent_free_token(token);
 
 	return args;
 }
@@ -3897,8 +3897,8 @@ static int event_read_print(struct tep_event *event)
 
 		if (asprintf(&cat, "%s%s", event->print_fmt.format, token) < 0)
 			goto fail;
-		free_token(token);
-		free_token(event->print_fmt.format);
+		traceevent_free_token(token);
+		traceevent_free_token(event->print_fmt.format);
 		event->print_fmt.format = NULL;
 		token = cat;
 		goto concat;
@@ -3907,7 +3907,7 @@ static int event_read_print(struct tep_event *event)
 	if (test_type_token(type, token, TEP_EVENT_DELIM, ","))
 		goto fail;
 
-	free_token(token);
+	traceevent_free_token(token);
 
 	ret = event_read_print_args(event, &event->print_fmt.args);
 	if (ret < 0)
@@ -3916,7 +3916,7 @@ static int event_read_print(struct tep_event *event)
 	return ret;
 
  fail:
-	free_token(token);
+	traceevent_free_token(token);
 	return -1;
 }
 
@@ -4002,12 +4002,12 @@ unsigned long long tep_read_number(struct tep_handle *tep,
 	case 1:
 		return *(unsigned char *)ptr;
 	case 2:
-		return data2host2(tep, *(unsigned short *)ptr);
+		return traceevent_data2host2(tep, *(unsigned short *)ptr);
 	case 4:
-		return data2host4(tep, *(unsigned int *)ptr);
+		return traceevent_data2host4(tep, *(unsigned int *)ptr);
 	case 8:
 		memcpy(&val, (ptr), sizeof(unsigned long long));
-		return data2host8(tep, val);
+		return traceevent_data2host8(tep, val);
 	default:
 		/* BUG! */
 		return 0;
@@ -7607,7 +7607,7 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 	/* type */
 	if (read_expect_type(tep, TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
-	free_token(token);
+	traceevent_free_token(token);
 
 	/*
 	 * If this is not a mandatory field, then test it first.
@@ -7620,7 +7620,7 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 			goto fail;
 		if (strcmp(token, field) != 0)
 			goto discard;
-		free_token(token);
+		traceevent_free_token(token);
 	}
 
 	if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
@@ -7632,7 +7632,7 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 	if (read_expect_type(tep, TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
 	*offset = atoi(token);
-	free_token(token);
+	traceevent_free_token(token);
 	if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 		return;
 	if (read_expected(tep, TEP_EVENT_ITEM, "size") < 0)
@@ -7642,10 +7642,10 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 	if (read_expect_type(tep, TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
 	*size = atoi(token);
-	free_token(token);
+	traceevent_free_token(token);
 	if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 		return;
-	type = read_token(tep, &token);
+	type = traceevent_read_token(tep, &token);
 	if (type != TEP_EVENT_NEWLINE) {
 		/* newer versions of the kernel have a "signed" type */
 		if (type != TEP_EVENT_ITEM)
@@ -7654,7 +7654,7 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 		if (strcmp(token, "signed") != 0)
 			goto fail;
 
-		free_token(token);
+		traceevent_free_token(token);
 
 		if (read_expected(tep, TEP_EVENT_OP, ":") < 0)
 			return;
@@ -7662,7 +7662,7 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 		if (read_expect_type(tep, TEP_EVENT_ITEM, &token))
 			goto fail;
 
-		free_token(token);
+		traceevent_free_token(token);
 		if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 			return;
 
@@ -7670,7 +7670,7 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 			goto fail;
 	}
  fail:
-	free_token(token);
+	traceevent_free_token(token);
 	return;
 
  discard:
@@ -7678,7 +7678,7 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 	tep->input_buf_siz = save_input_buf_siz;
 	*offset = 0;
 	*size = 0;
-	free_token(token);
+	traceevent_free_token(token);
 }
 
 /**
@@ -7710,7 +7710,7 @@ int tep_parse_header_page(struct tep_handle *tep, char *buf, unsigned long size,
 		tep->old_format = 1;
 		return -1;
 	}
-	init_input_buf(tep, buf, size);
+	traceevent_init_input_buf(tep, buf, size);
 
 	parse_header_field(tep, "timestamp", &tep->header_page_ts_offset,
 			   &tep->header_page_ts_size, 1);
@@ -7795,7 +7795,7 @@ static enum tep_errno parse_format(struct tep_event **eventp,
 	struct tep_event *event;
 	int ret;
 
-	init_input_buf(tep, buf, size);
+	traceevent_init_input_buf(tep, buf, size);
 
 	*eventp = event = alloc_event();
 	if (!event)
@@ -7923,7 +7923,7 @@ __parse_event(struct tep_handle *tep,
 	return 0;
 
 event_add_failed:
-	free_tep_event(event);
+	traceevent_free_tep_event(event);
 	return ret;
 }
 
@@ -8518,7 +8518,7 @@ int tep_get_ref(struct tep_handle *tep)
 	return 0;
 }
 
-__hidden void free_tep_format_field(struct tep_format_field *field)
+__hidden void traceevent_free_tep_format_field(struct tep_format_field *field)
 {
 	free(field->type);
 	if (field->alias != field->name)
@@ -8533,7 +8533,7 @@ static void free_format_fields(struct tep_format_field *field)
 
 	while (field) {
 		next = field->next;
-		free_tep_format_field(field);
+		traceevent_free_tep_format_field(field);
 		field = next;
 	}
 }
@@ -8544,7 +8544,7 @@ static void free_formats(struct tep_format *format)
 	free_format_fields(format->fields);
 }
 
-__hidden void free_tep_event(struct tep_event *event)
+__hidden void traceevent_free_tep_event(struct tep_event *event)
 {
 	free(event->name);
 	free(event->system);
@@ -8630,7 +8630,7 @@ void tep_free(struct tep_handle *tep)
 	}
 
 	for (i = 0; i < tep->nr_events; i++)
-		free_tep_event(tep->events[i]);
+		traceevent_free_tep_event(tep->events[i]);
 
 	while (tep->handlers) {
 		handle = tep->handlers;
@@ -8641,7 +8641,7 @@ void tep_free(struct tep_handle *tep)
 	free(tep->events);
 	free(tep->sort_events);
 	free(tep->func_resolver);
-	free_tep_plugin_paths(tep);
+	traceevent_free_tep_plugin_paths(tep);
 
 	free(tep);
 }
diff --git a/src/event-plugin.c b/src/event-plugin.c
index c944204..87c984b 100644
--- a/src/event-plugin.c
+++ b/src/event-plugin.c
@@ -678,7 +678,7 @@ int tep_add_plugin_path(struct tep_handle *tep, char *path,
 	return 0;
 }
 
-__hidden void free_tep_plugin_paths(struct tep_handle *tep)
+__hidden void traceevent_free_tep_plugin_paths(struct tep_handle *tep)
 {
 	struct tep_plugins_dir *dir;
 
diff --git a/src/parse-filter.c b/src/parse-filter.c
index 75b84a0..3096b97 100644
--- a/src/parse-filter.c
+++ b/src/parse-filter.c
@@ -38,8 +38,8 @@ static void show_error(struct tep_handle *tep, char *error_buf, const char *fmt,
 	int len;
 	int i;
 
-	input = get_input_buf(tep);
-	index = get_input_buf_ptr(tep);
+	input = traceevent_get_input_buf(tep);
+	index = traceevent_get_input_buf_ptr(tep);
 	len = input ? strlen(input) : 0;
 
 	if (len) {
@@ -63,25 +63,25 @@ static enum tep_event_type filter_read_token(struct tep_handle *tep, char **tok)
 	char *token = NULL;
 
 	do {
-		free_token(token);
-		type = read_token(tep, &token);
+		traceevent_free_token(token);
+		type = traceevent_read_token(tep, &token);
 	} while (type == TEP_EVENT_NEWLINE || type == TEP_EVENT_SPACE);
 
 	/* If token is = or ! check to see if the next char is ~ */
 	if (token &&
 	    (strcmp(token, "=") == 0 || strcmp(token, "!") == 0) &&
-	    peek_char(tep) == '~') {
+	    traceevent_peek_char(tep) == '~') {
 		/* append it */
 		*tok = malloc(3);
 		if (*tok == NULL) {
-			free_token(token);
+			traceevent_free_token(token);
 			return TEP_EVENT_ERROR;
 		}
 		sprintf(*tok, "%c%c", *token, '~');
-		free_token(token);
+		traceevent_free_token(token);
 		/* Now remove the '~' from the buffer */
-		read_token(tep, &token);
-		free_token(token);
+		traceevent_read_token(tep, &token);
+		traceevent_free_token(token);
 	} else
 		*tok = token;
 
@@ -1182,7 +1182,7 @@ process_event(struct tep_event *event, const char *filter_str,
 {
 	int ret;
 
-	init_input_buf(event->tep, filter_str, strlen(filter_str));
+	traceevent_init_input_buf(event->tep, filter_str, strlen(filter_str));
 
 	ret = process_filter(event, parg, error_str, 0);
 	if (ret < 0)
@@ -1240,7 +1240,7 @@ filter_event(struct tep_event_filter *filter, struct tep_event *event,
 static void filter_init_error_buf(struct tep_event_filter *filter)
 {
 	/* clear buffer to reset show error */
-	init_input_buf(filter->tep, "", 0);
+	traceevent_init_input_buf(filter->tep, "", 0);
 	filter->error_buffer[0] = '\0';
 }
 

base-commit: bd47bd544c9ebc9f44bd88c2b2f2049230741058
-- 
2.34.1

