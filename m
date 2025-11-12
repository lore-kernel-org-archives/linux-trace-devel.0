Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D81632BF20
	for <linux-trace-devel@vger.kernel.org>; Wed, 12 Nov 2025 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762958964; cv=none; b=HW9gCAIEOUk3o31EUV2OmjvLCmLWvG3r+hsIfLqW0kc0t2655B4X8htw+aUazY9tqc682Ls+NhNwRkGtPJXnf2v1qN67YhdCbTDMi+MmWz404iKAF88E3DfARuSN2Ni0Re7c9u8l+3sgWRyAdd/xLcFhrcjyZ4/tBuICg//eibQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762958964; c=relaxed/simple;
	bh=iiAA3MKSgXs10+EIH3GGzjENzlyZSauLpKRQMscXDxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyCO2DRCpkG7ZLGzq4CJBJBCRtsO6nfx4yA+NrZDgDZp3iMroeMWy1TerNBKU4/gc9MJtkNkcDjZj392l0KnIbc2WO4YHMfiFw7ygWE87JGLOgQVcQH8AO6TXv8m//PM//i2UKRKPVUDMrugl2keE3cbXiOf6K+P5woJwR+eH2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA382C4CEF1;
	Wed, 12 Nov 2025 14:49:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vJCAD-000000017qf-1EvO;
	Wed, 12 Nov 2025 09:49:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Metin Kaya <metin.kaya@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 1/2] libtraceevent: Have static library to hide hidden functions
Date: Wed, 12 Nov 2025 09:45:06 -0500
Message-ID: <20251112144912.268258-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251112144912.268258-1-rostedt@goodmis.org>
References: <20251112144912.268258-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When the static library uses the objects directly to be created, it makes
all the hidden functions visible to applications that link to it.

Check all the functions that are global and if they do not start with
"tep_" rename the symbol to start with "_tep_local_". This keeps the
source code clean and still adds the namespace for the hidden functions
within the objects.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/Makefile            |  13 +-
 src/event-parse-api.c   |   6 +-
 src/event-parse-local.h |  24 ++--
 src/event-parse.c       | 298 ++++++++++++++++++++--------------------
 src/event-plugin.c      |   2 +-
 src/parse-filter.c      |  22 +--
 6 files changed, 187 insertions(+), 178 deletions(-)

diff --git a/src/Makefile b/src/Makefile
index 53bb570182d2..c9e8498c2d05 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,7 +18,15 @@ DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
-$(LIBTRACEEVENT_STATIC): $(OBJS)
+# Make all global functions that do not start with "tep_" have a unique name.
+redefine_local = \
+	$(shell for f in a `nm ${LIBTRACEEVENT_SHARED} | grep ' t ' | cut -d' ' -f3 | sort -u`;  do \
+	 if [ "$${f#tep_}" = "$$f" ]; then echo --redefine-sym $$f=_tep_local_$$f; fi; done)
+
+$(LIBTRACEEVENT_STATIC): $(bdir)/.tmp.libtraceevent.a $(LIBTRACEEVENT_SHARED)
+	$(Q)objcopy $(call redefine_local) $< $@
+
+$(bdir)/.tmp.libtraceevent.a: $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
 $(LIBTRACEEVENT_SHARED): $(OBJS)
@@ -44,7 +52,8 @@ $(OBJS): | $(bdir)
 $(DEPS): | $(bdir)
 
 clean:
-	$(Q)$(call do_clean,$(OBJS) $(DEPS))
+	$(Q)$(call do_clean,$(OBJS) $(DEPS) $(bdir)/libtraceevent.o \
+	                    $(bdir)/.tmp.libtraceevent.a)
 
 dep_includes := $(wildcard $(DEPS))
 
diff --git a/src/event-parse-api.c b/src/event-parse-api.c
index 8a0e976ade45..fd03daf310ea 100644
--- a/src/event-parse-api.c
+++ b/src/event-parse-api.c
@@ -106,7 +106,7 @@ bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
 	return false;
 }
 
-__hidden unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data)
+__hidden unsigned short data2host2(struct tep_handle *tep, unsigned short data)
 {
 	unsigned short swap;
 
@@ -119,7 +119,7 @@ __hidden unsigned short tep_data2host2(struct tep_handle *tep, unsigned short da
 	return swap;
 }
 
-__hidden unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data)
+__hidden unsigned int data2host4(struct tep_handle *tep, unsigned int data)
 {
 	unsigned int swap;
 
@@ -135,7 +135,7 @@ __hidden unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data)
 }
 
 __hidden  unsigned long long
-tep_data2host8(struct tep_handle *tep, unsigned long long data)
+data2host8(struct tep_handle *tep, unsigned long long data)
 {
 	unsigned long long swap;
 
diff --git a/src/event-parse-local.h b/src/event-parse-local.h
index d9e9faf649d1..c6bfc611bfbd 100644
--- a/src/event-parse-local.h
+++ b/src/event-parse-local.h
@@ -108,20 +108,20 @@ struct tep_print_parse {
 	struct tep_print_arg		*len_as_arg;
 };
 
-void tep_free_event(struct tep_event *event);
-void tep_free_format_field(struct tep_format_field *field);
-void tep_free_plugin_paths(struct tep_handle *tep);
+void free_tep_event(struct tep_event *event);
+void free_tep_format_field(struct tep_format_field *field);
+void free_tep_plugin_paths(struct tep_handle *tep);
 
-unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data);
-unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data);
-unsigned long long tep_data2host8(struct tep_handle *tep, unsigned long long data);
+unsigned short data2host2(struct tep_handle *tep, unsigned short data);
+unsigned int data2host4(struct tep_handle *tep, unsigned int data);
+unsigned long long data2host8(struct tep_handle *tep, unsigned long long data);
 
 /* access to the internal parser */
-int tep_peek_char(struct tep_handle *tep);
-void tep_init_input_buf(struct tep_handle *tep, const char *buf, unsigned long long size);
-unsigned long long tep_get_input_buf_ptr(struct tep_handle *tep);
-const char *tep_get_input_buf(struct tep_handle *tep);
-enum tep_event_type tep_read_token(struct tep_handle *tep, char **tok);
-void tep_free_token(char *tok);
+int peek_char(struct tep_handle *tep);
+void init_input_buf(struct tep_handle *tep, const char *buf, unsigned long long size);
+unsigned long long get_input_buf_ptr(struct tep_handle *tep);
+const char *get_input_buf(struct tep_handle *tep);
+enum tep_event_type read_token(struct tep_handle *tep, char **tok);
+void free_token(char *tok);
 
 #endif /* _PARSE_EVENTS_INT_H */
diff --git a/src/event-parse.c b/src/event-parse.c
index aa16d83bb2ad..8daf91d8be83 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -52,26 +52,26 @@ static int show_warning = 1;
 	} while (0)
 
 /**
- * tep_init_input_buf - init buffer for parsing
+ * init_input_buf - init buffer for parsing
  * @buf: buffer to parse
  * @size: the size of the buffer
  *
  * Initializes the internal buffer that tep_read_token() will parse.
  */
-__hidden void tep_init_input_buf(struct tep_handle *tep, const char *buf,
-				 unsigned long long size)
+__hidden void init_input_buf(struct tep_handle *tep, const char *buf,
+		unsigned long long size)
 {
 	tep->input_buf = buf;
 	tep->input_buf_siz = size;
 	tep->input_buf_ptr = 0;
 }
 
-__hidden const char *tep_get_input_buf(struct tep_handle *tep)
+__hidden const char *get_input_buf(struct tep_handle *tep)
 {
 	return tep->input_buf;
 }
 
-__hidden unsigned long long tep_get_input_buf_ptr(struct tep_handle *tep)
+__hidden unsigned long long get_input_buf_ptr(struct tep_handle *tep)
 {
 	return tep->input_buf_ptr;
 }
@@ -1174,11 +1174,11 @@ static int __read_char(struct tep_handle *tep)
 }
 
 /**
- * tep_peek_char - peek at the next character that will be read
+ * peek_char - peek at the next character that will be read
  *
  * Returns the next character read, or -1 if end of buffer.
  */
-__hidden int tep_peek_char(struct tep_handle *tep)
+__hidden int peek_char(struct tep_handle *tep)
 {
 	if (tep->input_buf_ptr >= tep->input_buf_siz)
 		return -1;
@@ -1242,7 +1242,7 @@ static enum tep_event_type __read_token(struct tep_handle *tep, char **tok)
 	case TEP_EVENT_OP:
 		switch (ch) {
 		case '-':
-			next_ch = tep_peek_char(tep);
+			next_ch = peek_char(tep);
 			if (next_ch == '>') {
 				buf[i++] = __read_char(tep);
 				break;
@@ -1254,7 +1254,7 @@ static enum tep_event_type __read_token(struct tep_handle *tep, char **tok)
 		case '>':
 		case '<':
 			last_ch = ch;
-			ch = tep_peek_char(tep);
+			ch = peek_char(tep);
 			if (ch != last_ch)
 				goto test_equal;
 			buf[i++] = __read_char(tep);
@@ -1277,7 +1277,7 @@ static enum tep_event_type __read_token(struct tep_handle *tep, char **tok)
 		return type;
 
  test_equal:
-		ch = tep_peek_char(tep);
+		ch = peek_char(tep);
 		if (ch == '=')
 			buf[i++] = __read_char(tep);
 		goto out;
@@ -1337,7 +1337,7 @@ static enum tep_event_type __read_token(struct tep_handle *tep, char **tok)
 		break;
 	}
 
-	while (get_type(tep_peek_char(tep)) == type) {
+	while (get_type(peek_char(tep)) == type) {
 		if (i == (BUFSIZ - 1)) {
 			buf[i] = 0;
 			tok_size += BUFSIZ;
@@ -1395,7 +1395,7 @@ static enum tep_event_type force_token(struct tep_handle *tep, const char *str,
 	save_input_buf_ptr = tep->input_buf_ptr;
 	save_input_buf_siz = tep->input_buf_siz;
 
-	tep_init_input_buf(tep, str, strlen(str));
+	init_input_buf(tep, str, strlen(str));
 
 	type = __read_token(tep, tok);
 
@@ -1408,17 +1408,17 @@ static enum tep_event_type force_token(struct tep_handle *tep, const char *str,
 }
 
 /**
- * tep_free_token - free a token returned by tep_read_token
+ * free_token - free a token returned by tep_read_token
  * @token: the token to free
  */
-__hidden void tep_free_token(char *tok)
+__hidden void free_token(char *tok)
 {
 	if (tok)
 		free(tok);
 }
 
 /**
- * tep_read_token - access to utilities to use the tep parser
+ * read_token - access to utilities to use the tep parser
  * @tok: The token to return
  *
  * This will parse tokens from the string given by
@@ -1426,7 +1426,7 @@ __hidden void tep_free_token(char *tok)
  *
  * Returns the token type.
  */
-__hidden enum tep_event_type tep_read_token(struct tep_handle *tep, char **tok)
+__hidden enum tep_event_type read_token(struct tep_handle *tep, char **tok)
 {
 	enum tep_event_type type;
 
@@ -1435,7 +1435,7 @@ __hidden enum tep_event_type tep_read_token(struct tep_handle *tep, char **tok)
 		if (type != TEP_EVENT_SPACE)
 			return type;
 
-		tep_free_token(*tok);
+		free_token(*tok);
 	}
 
 	/* not reached */
@@ -1452,7 +1452,7 @@ static enum tep_event_type read_token_item(struct tep_handle *tep, char **tok)
 		type = __read_token(tep, tok);
 		if (type != TEP_EVENT_SPACE && type != TEP_EVENT_NEWLINE)
 			return type;
-		tep_free_token(*tok);
+		free_token(*tok);
 		*tok = NULL;
 	}
 
@@ -1496,7 +1496,7 @@ static int __read_expect_type(struct tep_handle *tep, enum tep_event_type expect
 	enum tep_event_type type;
 
 	if (newline_ok)
-		type = tep_read_token(tep, tok);
+		type = read_token(tep, tok);
 	else
 		type = read_token_item(tep, tok);
 	return test_type(type, expect);
@@ -1516,13 +1516,13 @@ static int __read_expected(struct tep_handle *tep, enum tep_event_type expect,
 	int ret;
 
 	if (newline_ok)
-		type = tep_read_token(tep, &token);
+		type = read_token(tep, &token);
 	else
 		type = read_token_item(tep, &token);
 
 	ret = test_type_token(type, token, expect, str);
 
-	tep_free_token(token);
+	free_token(token);
 
 	return ret;
 }
@@ -1555,7 +1555,7 @@ static char *event_read_name(struct tep_handle *tep)
 	return token;
 
  fail:
-	tep_free_token(token);
+	free_token(token);
 	return NULL;
 }
 
@@ -1574,11 +1574,11 @@ static int event_read_id(struct tep_handle *tep)
 		goto fail;
 
 	id = strtoul(token, NULL, 0);
-	tep_free_token(token);
+	free_token(token);
 	return id;
 
  fail:
-	tep_free_token(token);
+	free_token(token);
 	return -1;
 }
 
@@ -1672,9 +1672,9 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 	do {
 		unsigned int size_dynamic = 0;
 
-		type = tep_read_token(tep, &token);
+		type = read_token(tep, &token);
 		if (type == TEP_EVENT_NEWLINE) {
-			tep_free_token(token);
+			free_token(token);
 			return count;
 		}
 
@@ -1682,23 +1682,23 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 
 		if (test_type_token(type, token, TEP_EVENT_ITEM, "field"))
 			goto fail;
-		tep_free_token(token);
+		free_token(token);
 
-		type = tep_read_token(tep, &token);
+		type = read_token(tep, &token);
 		/*
 		 * The ftrace fields may still use the "special" name.
 		 * Just ignore it.
 		 */
 		if (event->flags & TEP_EVENT_FL_ISFTRACE &&
 		    type == TEP_EVENT_ITEM && strcmp(token, "special") == 0) {
-			tep_free_token(token);
-			type = tep_read_token(tep, &token);
+			free_token(token);
+			type = read_token(tep, &token);
 		}
 
 		if (test_type_token(type, token, TEP_EVENT_OP, ":") < 0)
 			goto fail;
 
-		tep_free_token(token);
+		free_token(token);
 		if (read_expect_type(tep, TEP_EVENT_ITEM, &token) < 0)
 			goto fail;
 
@@ -1712,7 +1712,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 
 		/* read the rest of the type */
 		for (;;) {
-			type = tep_read_token(tep, &token);
+			type = read_token(tep, &token);
 			if (type == TEP_EVENT_ITEM ||
 			    (type == TEP_EVENT_OP && strcmp(token, "*") == 0) ||
 			    /*
@@ -1750,7 +1750,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 					goto fail;
 
 				delim = " ";
-				while ((type = tep_read_token(tep, &token)) != TEP_EVENT_NONE) {
+				while ((type = read_token(tep, &token)) != TEP_EVENT_NONE) {
 					if (type == TEP_EVENT_DELIM) {
 						if (token[0] == '(')
 							depth++;
@@ -1789,7 +1789,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 
 			field->flags |= TEP_FIELD_IS_ARRAY;
 
-			type = tep_read_token(tep, &token);
+			type = read_token(tep, &token);
 
 			if (type == TEP_EVENT_ITEM)
 				field->arraylen = strtoul(token, NULL, 0);
@@ -1814,8 +1814,8 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 				}
 				/* We only care about the last token */
 				field->arraylen = strtoul(token, NULL, 0);
-				tep_free_token(token);
-				type = tep_read_token(tep, &token);
+				free_token(token);
+				type = read_token(tep, &token);
 				if (type == TEP_EVENT_NONE) {
 					free(brackets);
 					do_warning_event(event, "failed to find token");
@@ -1823,7 +1823,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 				}
 			}
 
-			tep_free_token(token);
+			free_token(token);
 
 			ret = append(&brackets, "", "]");
 			if (ret < 0) {
@@ -1833,7 +1833,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 
 			/* add brackets to type */
 
-			type = tep_read_token(tep, &token);
+			type = read_token(tep, &token);
 			/*
 			 * If the next token is not an OP, then it is of
 			 * the format: type [] item;
@@ -1847,9 +1847,9 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 				ret = append(&field->type, "", brackets);
 
 				size_dynamic = type_size(field->name);
-				tep_free_token(field->name);
+				free_token(field->name);
 				field->name = field->alias = token;
-				type = tep_read_token(tep, &token);
+				type = read_token(tep, &token);
 			} else {
 				ret = append(&field->type, "", brackets);
 				if (ret < 0) {
@@ -1871,7 +1871,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 
 		if (test_type_token(type, token,  TEP_EVENT_OP, ";"))
 			goto fail;
-		tep_free_token(token);
+		free_token(token);
 
 		if (read_expected(tep, TEP_EVENT_ITEM, "offset") < 0)
 			goto fail_expect;
@@ -1882,7 +1882,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 		if (read_expect_type(tep, TEP_EVENT_ITEM, &token))
 			goto fail;
 		field->offset = strtoul(token, NULL, 0);
-		tep_free_token(token);
+		free_token(token);
 
 		if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 			goto fail_expect;
@@ -1896,7 +1896,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 		if (read_expect_type(tep, TEP_EVENT_ITEM, &token))
 			goto fail;
 		field->size = strtoul(token, NULL, 0);
-		tep_free_token(token);
+		free_token(token);
 
 		/*
 		 * The old data format before dynamic arrays had dynamic
@@ -1911,13 +1911,13 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 		if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 			goto fail_expect;
 
-		type = tep_read_token(tep, &token);
+		type = read_token(tep, &token);
 		if (type != TEP_EVENT_NEWLINE) {
 			/* newer versions of the kernel have a "signed" type */
 			if (test_type_token(type, token, TEP_EVENT_ITEM, "signed"))
 				goto fail;
 
-			tep_free_token(token);
+			free_token(token);
 
 			if (read_expected(tep, TEP_EVENT_OP, ":") < 0)
 				goto fail_expect;
@@ -1928,7 +1928,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 			if (strtoul(token, NULL, 0))
 				field->flags |= TEP_FIELD_IS_SIGNED;
 
-			tep_free_token(token);
+			free_token(token);
 			if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 				goto fail_expect;
 
@@ -1936,7 +1936,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 				goto fail;
 		}
 
-		tep_free_token(token);
+		free_token(token);
 
 		if (field->flags & (TEP_FIELD_IS_ARRAY | TEP_FIELD_IS_DYNAMIC)) {
 			if (field->arraylen)
@@ -1961,7 +1961,7 @@ static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
 	return 0;
 
 fail:
-	tep_free_token(token);
+	free_token(token);
 fail_expect:
 	if (field) {
 		free(field->type);
@@ -1984,7 +1984,7 @@ static int event_read_format(struct tep_event *event)
 
 	if (read_expect_type(event->tep, TEP_EVENT_NEWLINE, &token))
 		goto fail;
-	tep_free_token(token);
+	free_token(token);
 
 	ret = event_read_fields(event->tep, event, &event->format.common_fields);
 	if (ret < 0)
@@ -1999,7 +1999,7 @@ static int event_read_format(struct tep_event *event)
 	return 0;
 
  fail:
-	tep_free_token(token);
+	free_token(token);
 	return -1;
 }
 
@@ -2013,7 +2013,7 @@ process_arg(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	enum tep_event_type type;
 	char *token;
 
-	type = tep_read_token(event->tep, &token);
+	type = read_token(event->tep, &token);
 	*tok = token;
 
 	return process_arg_token(event, arg, tok, type);
@@ -2101,7 +2101,7 @@ process_cond(struct tep_event *event, struct tep_print_arg *top, char **tok)
 out_free:
 	/* Top may point to itself */
 	top->op.right = NULL;
-	tep_free_token(token);
+	free_token(token);
 	free_arg(arg);
 	return TEP_EVENT_ERROR;
 }
@@ -2128,14 +2128,14 @@ process_array(struct tep_event *event, struct tep_print_arg *top, char **tok)
 
 	top->op.right = arg;
 
-	tep_free_token(token);
+	free_token(token);
 	type = read_token_item(event->tep, &token);
 	*tok = token;
 
 	return type;
 
 out_free:
-	tep_free_token(token);
+	free_token(token);
 	free_arg(arg);
 	return TEP_EVENT_ERROR;
 }
@@ -2524,7 +2524,7 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 out_warn_free:
 	do_warning_event(event, "%s: not enough memory!", __func__);
 out_free:
-	tep_free_token(token);
+	free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -2551,7 +2551,7 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 	if (test_type_token(type, token,  TEP_EVENT_OP, "->"))
 		goto out_free;
 
-	tep_free_token(token);
+	free_token(token);
 
 	if (read_expect_type(event->tep, TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
@@ -2570,13 +2570,13 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 		is_symbolic_field = 0;
 	}
 
-	type = tep_read_token(event->tep, &token);
+	type = read_token(event->tep, &token);
 	*tok = token;
 
 	return type;
 
  out_free:
-	tep_free_token(token);
+	free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -2615,7 +2615,7 @@ static int alloc_and_process_delim(struct tep_event *event, char *next_token,
 	*print_arg = field;
 
 out_free_token:
-	tep_free_token(token);
+	free_token(token);
 
 	return ret;
 out_error:
@@ -2943,7 +2943,7 @@ process_fields(struct tep_event *event, struct tep_print_flag_sym **list, char *
 	char *value;
 
 	do {
-		tep_free_token(token);
+		free_token(token);
 		type = read_token_item(event->tep, &token);
 		if (test_type_token(type, token, TEP_EVENT_OP, "{"))
 			break;
@@ -2952,7 +2952,7 @@ process_fields(struct tep_event *event, struct tep_print_flag_sym **list, char *
 		if (!arg)
 			goto out_free;
 
-		tep_free_token(token);
+		free_token(token);
 		type = process_arg(event, arg, &token);
 
 		if (type == TEP_EVENT_OP)
@@ -2980,7 +2980,7 @@ process_fields(struct tep_event *event, struct tep_print_flag_sym **list, char *
 		if (!arg)
 			goto out_free_field;
 
-		tep_free_token(token);
+		free_token(token);
 		type = process_arg(event, arg, &token);
 		if (test_type_token(type, token, TEP_EVENT_OP, "}"))
 			goto out_free_field;
@@ -2997,7 +2997,7 @@ process_fields(struct tep_event *event, struct tep_print_flag_sym **list, char *
 		*list = field;
 		list = &field->next;
 
-		tep_free_token(token);
+		free_token(token);
 		type = read_token_item(event->tep, &token);
 	} while (type == TEP_EVENT_DELIM && strcmp(token, ",") == 0);
 
@@ -3008,7 +3008,7 @@ out_free_field:
 	free_flag_sym(field);
 out_free:
 	free_arg(arg);
-	tep_free_token(token);
+	free_token(token);
 	*tok = NULL;
 
 	return TEP_EVENT_ERROR;
@@ -3038,7 +3038,7 @@ process_flags(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 	if (test_type_token(type, token, TEP_EVENT_DELIM, ","))
 		goto out_free_field;
-	tep_free_token(token);
+	free_token(token);
 
 	arg->flags.field = field;
 
@@ -3055,14 +3055,14 @@ process_flags(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	if (test_type_token(type, token, TEP_EVENT_DELIM, ")"))
 		goto out_free;
 
-	tep_free_token(token);
+	free_token(token);
 	type = read_token_item(event->tep, tok);
 	return type;
 
 out_free_field:
 	free_arg(field);
 out_free:
-	tep_free_token(token);
+	free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -3094,14 +3094,14 @@ process_symbols(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	if (test_type_token(type, token, TEP_EVENT_DELIM, ")"))
 		goto out_free;
 
-	tep_free_token(token);
+	free_token(token);
 	type = read_token_item(event->tep, tok);
 	return type;
 
 out_free_field:
 	free_arg(field);
 out_free:
-	tep_free_token(token);
+	free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -3184,7 +3184,7 @@ process_int_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, ch
 	 * The first item within the parenthesis is another field that holds
 	 * the index into where the array starts.
 	 */
-	type = tep_read_token(event->tep, &token);
+	type = read_token(event->tep, &token);
 	if (type != TEP_EVENT_ITEM)
 		return TEP_EVENT_ERROR;
 
@@ -3213,7 +3213,7 @@ process_int_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, ch
 
 	return read_token_item(event->tep, tok);
 out:
-	tep_free_token(token);
+	free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -3232,7 +3232,7 @@ process_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, char *
 	 * The item within the parenthesis is another field that holds
 	 * the index into where the array starts.
 	 */
-	type = tep_read_token(event->tep, &token);
+	type = read_token(event->tep, &token);
 	*tok = token;
 	if (type != TEP_EVENT_ITEM)
 		goto out_free;
@@ -3249,13 +3249,13 @@ process_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, char *
 	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
 		goto out_free;
 
-	tep_free_token(token);
+	free_token(token);
 	type = read_token_item(event->tep, &token);
 	*tok = token;
 	if (type != TEP_EVENT_OP || strcmp(token, "[") != 0)
 		return type;
 
-	tep_free_token(token);
+	free_token(token);
 	arg = alloc_arg();
 	if (!arg) {
 		do_warning_event(event, "%s: not enough memory!", __func__);
@@ -3270,14 +3270,14 @@ process_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, char *
 	if (!test_type_token(type, token, TEP_EVENT_OP, "]"))
 		goto out_free_arg;
 
-	tep_free_token(token);
+	free_token(token);
 	type = read_token_item(event->tep, tok);
 	return type;
 
  out_free_arg:
 	free_arg(arg);
  out_free:
-	tep_free_token(token);
+	free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -3306,14 +3306,14 @@ process_dynamic_array_len(struct tep_event *event, struct tep_print_arg *arg,
 	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
 
-	tep_free_token(token);
-	type = tep_read_token(event->tep, &token);
+	free_token(token);
+	type = read_token(event->tep, &token);
 	*tok = token;
 
 	return type;
 
  out_free:
-	tep_free_token(token);
+	free_token(token);
  out_err:
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
@@ -3344,14 +3344,14 @@ process_paren(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	 * and return.
 	 */
 	if (type == TEP_EVENT_ITEM && strcmp(token, ")") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		return process_entry(event, arg, tok);
 	}
 
 	if (test_type_token(type, token, TEP_EVENT_DELIM, ")"))
 		goto out_free;
 
-	tep_free_token(token);
+	free_token(token);
 	type = read_token_item(event->tep, &token);
 
 	/*
@@ -3387,7 +3387,7 @@ process_paren(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	return type;
 
  out_free:
-	tep_free_token(token);
+	free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -3410,13 +3410,13 @@ process_str(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
 
-	type = tep_read_token(event->tep, &token);
+	type = read_token(event->tep, &token);
 	*tok = token;
 
 	return type;
 
  out_free:
-	tep_free_token(token);
+	free_token(token);
  out_err:
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
@@ -3439,13 +3439,13 @@ process_bitmask(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
 
-	type = tep_read_token(event->tep, &token);
+	type = read_token(event->tep, &token);
 	*tok = token;
 
 	return type;
 
  out_free:
-	tep_free_token(token);
+	free_token(token);
  out_err:
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
@@ -3538,17 +3538,17 @@ process_func_handler(struct tep_event *event, struct tep_function_handler *func,
 
 		*next_arg = farg;
 		next_arg = &(farg->next);
-		tep_free_token(token);
+		free_token(token);
 	}
 
-	type = tep_read_token(event->tep, &token);
+	type = read_token(event->tep, &token);
 	*tok = token;
 
 	return type;
 
 err:
 	free_arg(farg);
-	tep_free_token(token);
+	free_token(token);
 	return TEP_EVENT_ERROR;
 }
 
@@ -3564,7 +3564,7 @@ process_builtin_expect(struct tep_event *event, struct tep_print_arg *arg, char
 	if (type != TEP_EVENT_DELIM || token[0] != ',')
 		goto out_free;
 
-	tep_free_token(token);
+	free_token(token);
 
 	/* We don't care what the second parameter is of the __builtin_expect() */
 	if (read_expect_type(event->tep, TEP_EVENT_ITEM, &token) < 0)
@@ -3573,12 +3573,12 @@ process_builtin_expect(struct tep_event *event, struct tep_print_arg *arg, char
 	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
 		goto out_free;
 
-	tep_free_token(token);
+	free_token(token);
 	type = read_token_item(event->tep, tok);
 	return type;
 
 out_free:
-	tep_free_token(token);
+	free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -3598,7 +3598,7 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 	/* We handle some sizeof types */
 	if (strcmp(token, "unsigned") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		type = read_token_item(event->tep, &token);
 
 		if (type == TEP_EVENT_ERROR)
@@ -3613,7 +3613,7 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 		arg->atom.atom = strdup("4");
 
 	} else if (strcmp(token, "long") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		type = read_token_item(event->tep, &token);
 
 		if (token && strcmp(token, "long") == 0) {
@@ -3652,12 +3652,12 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 	} else if (strcmp(token, "REC") == 0) {
 
-		tep_free_token(token);
+		free_token(token);
 		type = read_token_item(event->tep, &token);
 
 		if (test_type_token(type, token,  TEP_EVENT_OP, "->"))
 			goto error;
-		tep_free_token(token);
+		free_token(token);
 
 		if (read_expect_type(event->tep, TEP_EVENT_ITEM, &token) < 0)
 			goto error;
@@ -3677,16 +3677,16 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 	if (!token_has_paren) {
 		/* The token contains the last item before the parenthesis */
-		tep_free_token(token);
+		free_token(token);
 		type = read_token_item(event->tep, &token);
 	}
 	if (test_type_token(type, token,  TEP_EVENT_DELIM, ")"))
 		goto error;
 
-	tep_free_token(token);
+	free_token(token);
 	return read_token_item(event->tep, tok);
 error:
-	tep_free_token(token);
+	free_token(token);
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -3698,75 +3698,75 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
 	struct tep_function_handler *func;
 
 	if (strcmp(token, "__print_flags") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		is_flag_field = 1;
 		return process_flags(event, arg, tok);
 	}
 	if (strcmp(token, "__print_symbolic") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		is_symbolic_field = 1;
 		return process_symbols(event, arg, tok);
 	}
 	if (strcmp(token, "__print_hex") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		return process_hex(event, arg, tok);
 	}
 	if (strcmp(token, "__print_hex_str") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		return process_hex_str(event, arg, tok);
 	}
 	if (strcmp(token, "__print_array") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		return process_int_array(event, arg, tok);
 	}
 	if (strcmp(token, "__print_dynamic_array") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		return process_int_dynamic_array(event, arg, tok);
 	}
 	if (strcmp(token, "__get_str") == 0 ||
 	    strcmp(token, "__get_rel_str") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		return process_str(event, arg, tok);
 	}
 	if (strcmp(token, "__get_bitmask") == 0 ||
 	    strcmp(token, "__get_rel_bitmask") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		return process_bitmask(event, arg, tok);
 	}
 	if (strcmp(token, "__get_cpumask") == 0 ||
 	    strcmp(token, "__get_rel_cpumask") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		return process_cpumask(event, arg, tok);
 	}
 	if (strcmp(token, "__get_dynamic_array") == 0 ||
 	    strcmp(token, "__get_rel_dynamic_array") == 0 ||
 	    strcmp(token, "__get_sockaddr") == 0 ||
 	    strcmp(token, "__get_sockaddr_rel") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		return process_dynamic_array(event, arg, tok);
 	}
 	if (strcmp(token, "__get_dynamic_array_len") == 0 ||
 	    strcmp(token, "__get_rel_dynamic_array_len") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		return process_dynamic_array_len(event, arg, tok);
 	}
 	if (strcmp(token, "__builtin_expect") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		return process_builtin_expect(event, arg, tok);
 	}
 	if (strcmp(token, "sizeof") == 0) {
-		tep_free_token(token);
+		free_token(token);
 		return process_sizeof(event, arg, tok);
 	}
 
 	func = find_func_handler(event->tep, token);
 	if (func) {
-		tep_free_token(token);
+		free_token(token);
 		return process_func_handler(event, func, arg, tok);
 	}
 
 	do_warning_event(event, "function %s not defined", token);
-	tep_free_token(token);
+	free_token(token);
 	return TEP_EVENT_ERROR;
 }
 
@@ -3782,7 +3782,7 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 	switch (type) {
 	case TEP_EVENT_ITEM:
 		if (strcmp(token, "REC") == 0) {
-			tep_free_token(token);
+			free_token(token);
 			type = process_entry(event, arg, &token);
 			break;
 		}
@@ -3795,7 +3795,7 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 		 * is a function.
 		 */
 		if (type == TEP_EVENT_DELIM && strcmp(token, "(") == 0) {
-			tep_free_token(token);
+			free_token(token);
 			token = NULL;
 			/* this will free atom. */
 			type = process_function(event, arg, atom, &token);
@@ -3809,10 +3809,10 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 			if (ret < 0) {
 				free(atom);
 				*tok = NULL;
-				tep_free_token(token);
+				free_token(token);
 				return TEP_EVENT_ERROR;
 			}
-			tep_free_token(token);
+			free_token(token);
 			type = read_token_item(event->tep, &token);
 		}
 
@@ -3824,12 +3824,12 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 		arg->type = TEP_PRINT_ATOM;
 		/* Make characters into numbers */
 		if (asprintf(&arg->atom.atom, "%d", token[0]) < 0) {
-			tep_free_token(token);
+			free_token(token);
 			*tok = NULL;
 			arg->atom.atom = NULL;
 			return TEP_EVENT_ERROR;
 		}
-		tep_free_token(token);
+		free_token(token);
 		type = read_token_item(event->tep, &token);
 		break;
 	case TEP_EVENT_DQUOTE:
@@ -3839,7 +3839,7 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 		break;
 	case TEP_EVENT_DELIM:
 		if (strcmp(token, "(") == 0) {
-			tep_free_token(token);
+			free_token(token);
 			type = process_paren(event, arg, &token);
 			break;
 		}
@@ -3890,7 +3890,7 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
 		type = process_arg(event, arg, &token);
 
 		if (type == TEP_EVENT_ERROR) {
-			tep_free_token(token);
+			free_token(token);
 			free_arg(arg);
 			return -1;
 		}
@@ -3900,7 +3900,7 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
 
 		if (type == TEP_EVENT_OP) {
 			type = process_op(event, arg, &token);
-			tep_free_token(token);
+			free_token(token);
 
 			if (consolidate_op_arg(type, arg) < 0)
 				type = TEP_EVENT_ERROR;
@@ -3915,7 +3915,7 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
 		}
 
 		if (type == TEP_EVENT_DELIM && strcmp(token, ",") == 0) {
-			tep_free_token(token);
+			free_token(token);
 			*list = arg;
 			list = &arg->next;
 			continue;
@@ -3924,7 +3924,7 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
 	} while (type != TEP_EVENT_NONE);
 
 	if (type != TEP_EVENT_NONE && type != TEP_EVENT_ERROR)
-		tep_free_token(token);
+		free_token(token);
 
 	return args;
 }
@@ -3963,8 +3963,8 @@ static int event_read_print(struct tep_event *event)
 
 		if (asprintf(&cat, "%s%s", event->print_fmt.format, token) < 0)
 			goto fail;
-		tep_free_token(token);
-		tep_free_token(event->print_fmt.format);
+		free_token(token);
+		free_token(event->print_fmt.format);
 		event->print_fmt.format = NULL;
 		token = cat;
 		goto concat;
@@ -3973,7 +3973,7 @@ static int event_read_print(struct tep_event *event)
 	if (test_type_token(type, token, TEP_EVENT_DELIM, ","))
 		goto fail;
 
-	tep_free_token(token);
+	free_token(token);
 
 	ret = event_read_print_args(event, &event->print_fmt.args);
 	if (ret < 0)
@@ -3982,7 +3982,7 @@ static int event_read_print(struct tep_event *event)
 	return ret;
 
  fail:
-	tep_free_token(token);
+	free_token(token);
 	return -1;
 }
 
@@ -4068,12 +4068,12 @@ unsigned long long tep_read_number(struct tep_handle *tep,
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
@@ -7680,7 +7680,7 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 	/* type */
 	if (read_expect_type(tep, TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
-	tep_free_token(token);
+	free_token(token);
 
 	/*
 	 * If this is not a mandatory field, then test it first.
@@ -7693,7 +7693,7 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 			goto fail;
 		if (strcmp(token, field) != 0)
 			goto discard;
-		tep_free_token(token);
+		free_token(token);
 	}
 
 	if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
@@ -7705,7 +7705,7 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 	if (read_expect_type(tep, TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
 	*offset = atoi(token);
-	tep_free_token(token);
+	free_token(token);
 	if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 		return;
 	if (read_expected(tep, TEP_EVENT_ITEM, "size") < 0)
@@ -7715,10 +7715,10 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 	if (read_expect_type(tep, TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
 	*size = atoi(token);
-	tep_free_token(token);
+	free_token(token);
 	if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 		return;
-	type = tep_read_token(tep, &token);
+	type = read_token(tep, &token);
 	if (type != TEP_EVENT_NEWLINE) {
 		/* newer versions of the kernel have a "signed" type */
 		if (type != TEP_EVENT_ITEM)
@@ -7727,7 +7727,7 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 		if (strcmp(token, "signed") != 0)
 			goto fail;
 
-		tep_free_token(token);
+		free_token(token);
 
 		if (read_expected(tep, TEP_EVENT_OP, ":") < 0)
 			return;
@@ -7735,7 +7735,7 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 		if (read_expect_type(tep, TEP_EVENT_ITEM, &token))
 			goto fail;
 
-		tep_free_token(token);
+		free_token(token);
 		if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 			return;
 
@@ -7743,7 +7743,7 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 			goto fail;
 	}
  fail:
-	tep_free_token(token);
+	free_token(token);
 	return;
 
  discard:
@@ -7751,7 +7751,7 @@ static void parse_header_field(struct tep_handle *tep, const char *field,
 	tep->input_buf_siz = save_input_buf_siz;
 	*offset = 0;
 	*size = 0;
-	tep_free_token(token);
+	free_token(token);
 }
 
 /**
@@ -7783,7 +7783,7 @@ int tep_parse_header_page(struct tep_handle *tep, char *buf, unsigned long size,
 		tep->old_format = 1;
 		return -1;
 	}
-	tep_init_input_buf(tep, buf, size);
+	init_input_buf(tep, buf, size);
 
 	parse_header_field(tep, "timestamp", &tep->header_page_ts_offset,
 			   &tep->header_page_ts_size, 1);
@@ -7869,7 +7869,7 @@ static enum tep_errno parse_format(struct tep_event **eventp,
 	struct tep_event *event;
 	int ret;
 
-	tep_init_input_buf(tep, buf, size);
+	init_input_buf(tep, buf, size);
 
 	*eventp = event = alloc_event();
 	if (!event)
@@ -7998,7 +7998,7 @@ __parse_event(struct tep_handle *tep,
 	return 0;
 
 event_add_failed:
-	tep_free_event(event);
+	free_tep_event(event);
 	return ret;
 }
 
@@ -8601,7 +8601,7 @@ int tep_get_ref(struct tep_handle *tep)
 	return 0;
 }
 
-__hidden void tep_free_format_field(struct tep_format_field *field)
+__hidden void free_tep_format_field(struct tep_format_field *field)
 {
 	free(field->type);
 	if (field->alias != field->name)
@@ -8616,7 +8616,7 @@ static void free_format_fields(struct tep_format_field *field)
 
 	while (field) {
 		next = field->next;
-		tep_free_format_field(field);
+		free_tep_format_field(field);
 		field = next;
 	}
 }
@@ -8627,7 +8627,7 @@ static void free_formats(struct tep_format *format)
 	free_format_fields(format->fields);
 }
 
-__hidden void tep_free_event(struct tep_event *event)
+__hidden void free_tep_event(struct tep_event *event)
 {
 	free(event->name);
 	free(event->system);
@@ -8713,7 +8713,7 @@ void tep_free(struct tep_handle *tep)
 	}
 
 	for (i = 0; i < tep->nr_events; i++)
-		tep_free_event(tep->events[i]);
+		free_tep_event(tep->events[i]);
 
 	while (tep->handlers) {
 		handle = tep->handlers;
@@ -8724,7 +8724,7 @@ void tep_free(struct tep_handle *tep)
 	free(tep->events);
 	free(tep->sort_events);
 	free(tep->func_resolver);
-	tep_free_plugin_paths(tep);
+	free_tep_plugin_paths(tep);
 
 	free(tep);
 }
diff --git a/src/event-plugin.c b/src/event-plugin.c
index 236b96bceab4..3b14fd2c02e6 100644
--- a/src/event-plugin.c
+++ b/src/event-plugin.c
@@ -662,7 +662,7 @@ int tep_add_plugin_path(struct tep_handle *tep, char *path,
 	return 0;
 }
 
-__hidden void tep_free_plugin_paths(struct tep_handle *tep)
+__hidden void free_tep_plugin_paths(struct tep_handle *tep)
 {
 	struct tep_plugins_dir *dir;
 
diff --git a/src/parse-filter.c b/src/parse-filter.c
index 8045b10e7bcb..75b84a0cc4ae 100644
--- a/src/parse-filter.c
+++ b/src/parse-filter.c
@@ -38,8 +38,8 @@ static void show_error(struct tep_handle *tep, char *error_buf, const char *fmt,
 	int len;
 	int i;
 
-	input = tep_get_input_buf(tep);
-	index = tep_get_input_buf_ptr(tep);
+	input = get_input_buf(tep);
+	index = get_input_buf_ptr(tep);
 	len = input ? strlen(input) : 0;
 
 	if (len) {
@@ -63,25 +63,25 @@ static enum tep_event_type filter_read_token(struct tep_handle *tep, char **tok)
 	char *token = NULL;
 
 	do {
-		tep_free_token(token);
-		type = tep_read_token(tep, &token);
+		free_token(token);
+		type = read_token(tep, &token);
 	} while (type == TEP_EVENT_NEWLINE || type == TEP_EVENT_SPACE);
 
 	/* If token is = or ! check to see if the next char is ~ */
 	if (token &&
 	    (strcmp(token, "=") == 0 || strcmp(token, "!") == 0) &&
-	    tep_peek_char(tep) == '~') {
+	    peek_char(tep) == '~') {
 		/* append it */
 		*tok = malloc(3);
 		if (*tok == NULL) {
-			tep_free_token(token);
+			free_token(token);
 			return TEP_EVENT_ERROR;
 		}
 		sprintf(*tok, "%c%c", *token, '~');
-		tep_free_token(token);
+		free_token(token);
 		/* Now remove the '~' from the buffer */
-		tep_read_token(tep, &token);
-		tep_free_token(token);
+		read_token(tep, &token);
+		free_token(token);
 	} else
 		*tok = token;
 
@@ -1182,7 +1182,7 @@ process_event(struct tep_event *event, const char *filter_str,
 {
 	int ret;
 
-	tep_init_input_buf(event->tep, filter_str, strlen(filter_str));
+	init_input_buf(event->tep, filter_str, strlen(filter_str));
 
 	ret = process_filter(event, parg, error_str, 0);
 	if (ret < 0)
@@ -1240,7 +1240,7 @@ filter_event(struct tep_event_filter *filter, struct tep_event *event,
 static void filter_init_error_buf(struct tep_event_filter *filter)
 {
 	/* clear buffer to reset show error */
-	tep_init_input_buf(filter->tep, "", 0);
+	init_input_buf(filter->tep, "", 0);
 	filter->error_buffer[0] = '\0';
 }
 
-- 
2.51.0

