Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 167F3C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Dec 2022 10:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiLPK2J (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Dec 2022 05:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiLPK2G (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Dec 2022 05:28:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06EB2A949
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Dec 2022 02:28:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 428F662043
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Dec 2022 10:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E626BC433EF;
        Fri, 16 Dec 2022 10:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671186481;
        bh=wd9eR+4QtDRsw6C4r/62dJHt0Tsy4uW8GWevrvHnYWw=;
        h=From:To:Cc:Subject:Date:From;
        b=YNgderAei2fgbuRCuyvPopQHVR6jmlgRUInJfqYkiNp55O7whwf6PxhSvH5Qrwl44
         /yXZkTt4W7Qhy8W1AYwNOKHUFAMtXdxNC8aL8isnHa5A3AWGNWSvht4Ea/ExdqT9gs
         9faVIna1rXMzIssA255B0sFnyHmNA0cJEuCbv6lrGHwSysdCDtDd/EhthbRGSQk+ja
         xIoHok0MUOSpbVuSTeJ2j8UauhagMgiXSuHN+NO8/iT22X6P/riwjrxgnw8ZllOSDM
         QeGZXEc32lvEglhG78HAb1EZCMu354Z3N2i/pETAjfbfKbUIXbs/tZBhr5Z0QVHHkX
         TqhSaCWGFg/iw==
From:   Felipe Balbi <balbi@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, Felipe Balbi <balbi@kernel.org>
Subject: [PATCH] Remove global input buffer
Date:   Fri, 16 Dec 2022 12:27:53 +0200
Message-Id: <20221216102754.257174-1-balbi@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When using the library with multiple threads, the global input buffer
pointer gets modified concurrently by each thread. An easy fix for the
problems that arise is to give each struct tep_handle its own input
buffer pointer.

Signed-off-by: Felipe Balbi <balbi@kernel.org>
---
 src/event-parse-local.h |  14 +-
 src/event-parse.c       | 368 ++++++++++++++++++++--------------------
 src/parse-filter.c      | 118 ++++++-------
 3 files changed, 254 insertions(+), 246 deletions(-)

diff --git a/src/event-parse-local.h b/src/event-parse-local.h
index fd4bbcfbb849..c6bfc611bfbd 100644
--- a/src/event-parse-local.h
+++ b/src/event-parse-local.h
@@ -85,6 +85,10 @@ struct tep_handle {
 	struct tep_event *last_event;
 
 	struct tep_plugins_dir *plugins_dir;
+
+	const char *input_buf;
+	unsigned long long input_buf_ptr;
+	unsigned long long input_buf_siz;
 };
 
 enum tep_print_parse_type {
@@ -113,11 +117,11 @@ unsigned int data2host4(struct tep_handle *tep, unsigned int data);
 unsigned long long data2host8(struct tep_handle *tep, unsigned long long data);
 
 /* access to the internal parser */
-int peek_char(void);
-void init_input_buf(const char *buf, unsigned long long size);
-unsigned long long get_input_buf_ptr(void);
-const char *get_input_buf(void);
-enum tep_event_type read_token(char **tok);
+int peek_char(struct tep_handle *tep);
+void init_input_buf(struct tep_handle *tep, const char *buf, unsigned long long size);
+unsigned long long get_input_buf_ptr(struct tep_handle *tep);
+const char *get_input_buf(struct tep_handle *tep);
+enum tep_event_type read_token(struct tep_handle *tep, char **tok);
 void free_token(char *tok);
 
 #endif /* _PARSE_EVENTS_INT_H */
diff --git a/src/event-parse.c b/src/event-parse.c
index 65937675a67f..b37d81a89bf8 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -28,10 +28,6 @@
 #include "event-utils.h"
 #include "trace-seq.h"
 
-static const char *input_buf;
-static unsigned long long input_buf_ptr;
-static unsigned long long input_buf_siz;
-
 static int is_flag_field;
 static int is_symbolic_field;
 
@@ -62,21 +58,22 @@ static int show_warning = 1;
  *
  * Initializes the internal buffer that tep_read_token() will parse.
  */
-__hidden void init_input_buf(const char *buf, unsigned long long size)
+__hidden void init_input_buf(struct tep_handle *tep, const char *buf,
+		unsigned long long size)
 {
-	input_buf = buf;
-	input_buf_siz = size;
-	input_buf_ptr = 0;
+	tep->input_buf = buf;
+	tep->input_buf_siz = size;
+	tep->input_buf_ptr = 0;
 }
 
-__hidden const char *get_input_buf(void)
+__hidden const char *get_input_buf(struct tep_handle *tep)
 {
-	return input_buf;
+	return tep->input_buf;
 }
 
-__hidden unsigned long long get_input_buf_ptr(void)
+__hidden unsigned long long get_input_buf_ptr(struct tep_handle *tep)
 {
-	return input_buf_ptr;
+	return tep->input_buf_ptr;
 }
 
 struct event_handler {
@@ -1168,12 +1165,12 @@ static enum tep_event_type get_type(int ch)
 	return TEP_EVENT_OP;
 }
 
-static int __read_char(void)
+static int __read_char(struct tep_handle *tep)
 {
-	if (input_buf_ptr >= input_buf_siz)
+	if (tep->input_buf_ptr >= tep->input_buf_siz)
 		return -1;
 
-	return input_buf[input_buf_ptr++];
+	return tep->input_buf[tep->input_buf_ptr++];
 }
 
 /**
@@ -1181,12 +1178,12 @@ static int __read_char(void)
  *
  * Returns the next character read, or -1 if end of buffer.
  */
-__hidden int peek_char(void)
+__hidden int peek_char(struct tep_handle *tep)
 {
-	if (input_buf_ptr >= input_buf_siz)
+	if (tep->input_buf_ptr >= tep->input_buf_siz)
 		return -1;
 
-	return input_buf[input_buf_ptr];
+	return tep->input_buf[tep->input_buf_ptr];
 }
 
 static int extend_token(char **tok, char *buf, int size)
@@ -1208,9 +1205,10 @@ static int extend_token(char **tok, char *buf, int size)
 	return 0;
 }
 
-static enum tep_event_type force_token(const char *str, char **tok);
+static enum tep_event_type force_token(struct tep_handle *tep, const char *str,
+		char **tok);
 
-static enum tep_event_type __read_token(char **tok)
+static enum tep_event_type __read_token(struct tep_handle *tep, char **tok)
 {
 	char buf[BUFSIZ];
 	int ch, last_ch, quote_ch, next_ch;
@@ -1221,7 +1219,7 @@ static enum tep_event_type __read_token(char **tok)
 	*tok = NULL;
 
 
-	ch = __read_char();
+	ch = __read_char(tep);
 	if (ch < 0)
 		return TEP_EVENT_NONE;
 
@@ -1242,9 +1240,9 @@ static enum tep_event_type __read_token(char **tok)
 	case TEP_EVENT_OP:
 		switch (ch) {
 		case '-':
-			next_ch = peek_char();
+			next_ch = peek_char(tep);
 			if (next_ch == '>') {
-				buf[i++] = __read_char();
+				buf[i++] = __read_char(tep);
 				break;
 			}
 			/* fall through */
@@ -1254,10 +1252,10 @@ static enum tep_event_type __read_token(char **tok)
 		case '>':
 		case '<':
 			last_ch = ch;
-			ch = peek_char();
+			ch = peek_char(tep);
 			if (ch != last_ch)
 				goto test_equal;
-			buf[i++] = __read_char();
+			buf[i++] = __read_char(tep);
 			switch (last_ch) {
 			case '>':
 			case '<':
@@ -1277,9 +1275,9 @@ static enum tep_event_type __read_token(char **tok)
 		return type;
 
  test_equal:
-		ch = peek_char();
+		ch = peek_char(tep);
 		if (ch == '=')
-			buf[i++] = __read_char();
+			buf[i++] = __read_char(tep);
 		goto out;
 
 	case TEP_EVENT_DQUOTE:
@@ -1299,7 +1297,7 @@ static enum tep_event_type __read_token(char **tok)
 				i = 0;
 			}
 			last_ch = ch;
-			ch = __read_char();
+			ch = __read_char(tep);
 			buf[i++] = ch;
 			/* the '\' '\' will cancel itself */
 			if (ch == '\\' && last_ch == '\\')
@@ -1314,14 +1312,14 @@ static enum tep_event_type __read_token(char **tok)
 		 * If it is another string, concatinate the two.
 		 */
 		if (type == TEP_EVENT_DQUOTE) {
-			unsigned long long save_input_buf_ptr = input_buf_ptr;
+			unsigned long long save_input_buf_ptr = tep->input_buf_ptr;
 
 			do {
-				ch = __read_char();
+				ch = __read_char(tep);
 			} while (isspace(ch));
 			if (ch == '"')
 				goto concat;
-			input_buf_ptr = save_input_buf_ptr;
+			tep->input_buf_ptr = save_input_buf_ptr;
 		}
 
 		goto out;
@@ -1332,7 +1330,7 @@ static enum tep_event_type __read_token(char **tok)
 		break;
 	}
 
-	while (get_type(peek_char()) == type) {
+	while (get_type(peek_char(tep)) == type) {
 		if (i == (BUFSIZ - 1)) {
 			buf[i] = 0;
 			tok_size += BUFSIZ;
@@ -1341,7 +1339,7 @@ static enum tep_event_type __read_token(char **tok)
 				return TEP_EVENT_NONE;
 			i = 0;
 		}
-		ch = __read_char();
+		ch = __read_char(tep);
 		buf[i++] = ch;
 	}
 
@@ -1362,22 +1360,23 @@ static enum tep_event_type __read_token(char **tok)
 		if (strcmp(*tok, "LOCAL_PR_FMT") == 0) {
 			free(*tok);
 			*tok = NULL;
-			return force_token("\"%s\" ", tok);
+			return force_token(tep, "\"%s\" ", tok);
 		} else if (strcmp(*tok, "STA_PR_FMT") == 0) {
 			free(*tok);
 			*tok = NULL;
-			return force_token("\" sta:%pM\" ", tok);
+			return force_token(tep, "\" sta:%pM\" ", tok);
 		} else if (strcmp(*tok, "VIF_PR_FMT") == 0) {
 			free(*tok);
 			*tok = NULL;
-			return force_token("\" vif:%p(%d)\" ", tok);
+			return force_token(tep, "\" vif:%p(%d)\" ", tok);
 		}
 	}
 
 	return type;
 }
 
-static enum tep_event_type force_token(const char *str, char **tok)
+static enum tep_event_type force_token(struct tep_handle *tep, const char *str,
+		char **tok)
 {
 	const char *save_input_buf;
 	unsigned long long save_input_buf_ptr;
@@ -1385,18 +1384,18 @@ static enum tep_event_type force_token(const char *str, char **tok)
 	enum tep_event_type type;
 	
 	/* save off the current input pointers */
-	save_input_buf = input_buf;
-	save_input_buf_ptr = input_buf_ptr;
-	save_input_buf_siz = input_buf_siz;
+	save_input_buf = tep->input_buf;
+	save_input_buf_ptr = tep->input_buf_ptr;
+	save_input_buf_siz = tep->input_buf_siz;
 
-	init_input_buf(str, strlen(str));
+	init_input_buf(tep, str, strlen(str));
 
-	type = __read_token(tok);
+	type = __read_token(tep, tok);
 
 	/* reset back to original token */
-	input_buf = save_input_buf;
-	input_buf_ptr = save_input_buf_ptr;
-	input_buf_siz = save_input_buf_siz;
+	tep->input_buf = save_input_buf;
+	tep->input_buf_ptr = save_input_buf_ptr;
+	tep->input_buf_siz = save_input_buf_siz;
 
 	return type;
 }
@@ -1420,12 +1419,12 @@ __hidden void free_token(char *tok)
  *
  * Returns the token type.
  */
-__hidden enum tep_event_type read_token(char **tok)
+__hidden enum tep_event_type read_token(struct tep_handle *tep, char **tok)
 {
 	enum tep_event_type type;
 
 	for (;;) {
-		type = __read_token(tok);
+		type = __read_token(tep, tok);
 		if (type != TEP_EVENT_SPACE)
 			return type;
 
@@ -1438,12 +1437,12 @@ __hidden enum tep_event_type read_token(char **tok)
 }
 
 /* no newline */
-static enum tep_event_type read_token_item(char **tok)
+static enum tep_event_type read_token_item(struct tep_handle *tep, char **tok)
 {
 	enum tep_event_type type;
 
 	for (;;) {
-		type = __read_token(tok);
+		type = __read_token(tep, tok);
 		if (type != TEP_EVENT_SPACE && type != TEP_EVENT_NEWLINE)
 			return type;
 		free_token(*tok);
@@ -1484,33 +1483,35 @@ static int test_type_token(enum tep_event_type type, const char *token,
 	return 0;
 }
 
-static int __read_expect_type(enum tep_event_type expect, char **tok, int newline_ok)
+static int __read_expect_type(struct tep_handle *tep, enum tep_event_type expect,
+		char **tok, int newline_ok)
 {
 	enum tep_event_type type;
 
 	if (newline_ok)
-		type = read_token(tok);
+		type = read_token(tep, tok);
 	else
-		type = read_token_item(tok);
+		type = read_token_item(tep, tok);
 	return test_type(type, expect);
 }
 
-static int read_expect_type(enum tep_event_type expect, char **tok)
+static int read_expect_type(struct tep_handle *tep, enum tep_event_type expect,
+		char **tok)
 {
-	return __read_expect_type(expect, tok, 1);
+	return __read_expect_type(tep, expect, tok, 1);
 }
 
-static int __read_expected(enum tep_event_type expect, const char *str,
-			   int newline_ok)
+static int __read_expected(struct tep_handle *tep, enum tep_event_type expect,
+		const char *str, int newline_ok)
 {
 	enum tep_event_type type;
 	char *token;
 	int ret;
 
 	if (newline_ok)
-		type = read_token(&token);
+		type = read_token(tep, &token);
 	else
-		type = read_token_item(&token);
+		type = read_token_item(tep, &token);
 
 	ret = test_type_token(type, token, expect, str);
 
@@ -1519,27 +1520,29 @@ static int __read_expected(enum tep_event_type expect, const char *str,
 	return ret;
 }
 
-static int read_expected(enum tep_event_type expect, const char *str)
+static int read_expected(struct tep_handle *tep, enum tep_event_type expect,
+		const char *str)
 {
-	return __read_expected(expect, str, 1);
+	return __read_expected(tep, expect, str, 1);
 }
 
-static int read_expected_item(enum tep_event_type expect, const char *str)
+static int read_expected_item(struct tep_handle *tep, enum tep_event_type expect,
+		const char *str)
 {
-	return __read_expected(expect, str, 0);
+	return __read_expected(tep, expect, str, 0);
 }
 
-static char *event_read_name(void)
+static char *event_read_name(struct tep_handle *tep)
 {
 	char *token;
 
-	if (read_expected(TEP_EVENT_ITEM, "name") < 0)
+	if (read_expected(tep, TEP_EVENT_ITEM, "name") < 0)
 		return NULL;
 
-	if (read_expected(TEP_EVENT_OP, ":") < 0)
+	if (read_expected(tep, TEP_EVENT_OP, ":") < 0)
 		return NULL;
 
-	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+	if (read_expect_type(tep, TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
 
 	return token;
@@ -1549,18 +1552,18 @@ static char *event_read_name(void)
 	return NULL;
 }
 
-static int event_read_id(void)
+static int event_read_id(struct tep_handle *tep)
 {
 	char *token;
 	int id;
 
-	if (read_expected_item(TEP_EVENT_ITEM, "ID") < 0)
+	if (read_expected_item(tep, TEP_EVENT_ITEM, "ID") < 0)
 		return -1;
 
-	if (read_expected(TEP_EVENT_OP, ":") < 0)
+	if (read_expected(tep, TEP_EVENT_OP, ":") < 0)
 		return -1;
 
-	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+	if (read_expect_type(tep, TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
 
 	id = strtoul(token, NULL, 0);
@@ -1648,7 +1651,8 @@ static int append(char **buf, const char *delim, const char *str)
 	return 0;
 }
 
-static int event_read_fields(struct tep_event *event, struct tep_format_field **fields)
+static int event_read_fields(struct tep_handle *tep, struct tep_event *event,
+		struct tep_format_field **fields)
 {
 	struct tep_format_field *field = NULL;
 	enum tep_event_type type;
@@ -1661,7 +1665,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 	do {
 		unsigned int size_dynamic = 0;
 
-		type = read_token(&token);
+		type = read_token(tep, &token);
 		if (type == TEP_EVENT_NEWLINE) {
 			free_token(token);
 			return count;
@@ -1673,7 +1677,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 			goto fail;
 		free_token(token);
 
-		type = read_token(&token);
+		type = read_token(tep, &token);
 		/*
 		 * The ftrace fields may still use the "special" name.
 		 * Just ignore it.
@@ -1681,14 +1685,14 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 		if (event->flags & TEP_EVENT_FL_ISFTRACE &&
 		    type == TEP_EVENT_ITEM && strcmp(token, "special") == 0) {
 			free_token(token);
-			type = read_token(&token);
+			type = read_token(tep, &token);
 		}
 
 		if (test_type_token(type, token, TEP_EVENT_OP, ":") < 0)
 			goto fail;
 
 		free_token(token);
-		if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+		if (read_expect_type(tep, TEP_EVENT_ITEM, &token) < 0)
 			goto fail;
 
 		last_token = token;
@@ -1701,7 +1705,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 
 		/* read the rest of the type */
 		for (;;) {
-			type = read_token(&token);
+			type = read_token(tep, &token);
 			if (type == TEP_EVENT_ITEM ||
 			    (type == TEP_EVENT_OP && strcmp(token, "*") == 0) ||
 			    /*
@@ -1739,7 +1743,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 					goto fail;
 
 				delim = " ";
-				while ((type = read_token(&token)) != TEP_EVENT_NONE) {
+				while ((type = read_token(tep, &token)) != TEP_EVENT_NONE) {
 					if (type == TEP_EVENT_DELIM) {
 						if (token[0] == '(')
 							depth++;
@@ -1778,7 +1782,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 
 			field->flags |= TEP_FIELD_IS_ARRAY;
 
-			type = read_token(&token);
+			type = read_token(tep, &token);
 
 			if (type == TEP_EVENT_ITEM)
 				field->arraylen = strtoul(token, NULL, 0);
@@ -1804,7 +1808,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 				/* We only care about the last token */
 				field->arraylen = strtoul(token, NULL, 0);
 				free_token(token);
-				type = read_token(&token);
+				type = read_token(tep, &token);
 				if (type == TEP_EVENT_NONE) {
 					free(brackets);
 					do_warning_event(event, "failed to find token");
@@ -1822,7 +1826,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 
 			/* add brackets to type */
 
-			type = read_token(&token);
+			type = read_token(tep, &token);
 			/*
 			 * If the next token is not an OP, then it is of
 			 * the format: type [] item;
@@ -1838,7 +1842,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 				size_dynamic = type_size(field->name);
 				free_token(field->name);
 				field->name = field->alias = token;
-				type = read_token(&token);
+				type = read_token(tep, &token);
 			} else {
 				ret = append(&field->type, "", brackets);
 				if (ret < 0) {
@@ -1862,27 +1866,27 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 			goto fail;
 		free_token(token);
 
-		if (read_expected(TEP_EVENT_ITEM, "offset") < 0)
+		if (read_expected(tep, TEP_EVENT_ITEM, "offset") < 0)
 			goto fail_expect;
 
-		if (read_expected(TEP_EVENT_OP, ":") < 0)
+		if (read_expected(tep, TEP_EVENT_OP, ":") < 0)
 			goto fail_expect;
 
-		if (read_expect_type(TEP_EVENT_ITEM, &token))
+		if (read_expect_type(tep, TEP_EVENT_ITEM, &token))
 			goto fail;
 		field->offset = strtoul(token, NULL, 0);
 		free_token(token);
 
-		if (read_expected(TEP_EVENT_OP, ";") < 0)
+		if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 			goto fail_expect;
 
-		if (read_expected(TEP_EVENT_ITEM, "size") < 0)
+		if (read_expected(tep, TEP_EVENT_ITEM, "size") < 0)
 			goto fail_expect;
 
-		if (read_expected(TEP_EVENT_OP, ":") < 0)
+		if (read_expected(tep, TEP_EVENT_OP, ":") < 0)
 			goto fail_expect;
 
-		if (read_expect_type(TEP_EVENT_ITEM, &token))
+		if (read_expect_type(tep, TEP_EVENT_ITEM, &token))
 			goto fail;
 		field->size = strtoul(token, NULL, 0);
 		free_token(token);
@@ -1897,10 +1901,10 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 		if ((field->flags & TEP_FIELD_IS_DYNAMIC) && field->size == 2)
 			field->flags |= TEP_FIELD_IS_STRING | TEP_FIELD_IS_ARRAY;
 
-		if (read_expected(TEP_EVENT_OP, ";") < 0)
+		if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 			goto fail_expect;
 
-		type = read_token(&token);
+		type = read_token(tep, &token);
 		if (type != TEP_EVENT_NEWLINE) {
 			/* newer versions of the kernel have a "signed" type */
 			if (test_type_token(type, token, TEP_EVENT_ITEM, "signed"))
@@ -1908,20 +1912,20 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 
 			free_token(token);
 
-			if (read_expected(TEP_EVENT_OP, ":") < 0)
+			if (read_expected(tep, TEP_EVENT_OP, ":") < 0)
 				goto fail_expect;
 
-			if (read_expect_type(TEP_EVENT_ITEM, &token))
+			if (read_expect_type(tep, TEP_EVENT_ITEM, &token))
 				goto fail;
 
 			if (strtoul(token, NULL, 0))
 				field->flags |= TEP_FIELD_IS_SIGNED;
 
 			free_token(token);
-			if (read_expected(TEP_EVENT_OP, ";") < 0)
+			if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 				goto fail_expect;
 
-			if (read_expect_type(TEP_EVENT_NEWLINE, &token))
+			if (read_expect_type(tep, TEP_EVENT_NEWLINE, &token))
 				goto fail;
 		}
 
@@ -1965,22 +1969,22 @@ static int event_read_format(struct tep_event *event)
 	char *token;
 	int ret;
 
-	if (read_expected_item(TEP_EVENT_ITEM, "format") < 0)
+	if (read_expected_item(event->tep, TEP_EVENT_ITEM, "format") < 0)
 		return -1;
 
-	if (read_expected(TEP_EVENT_OP, ":") < 0)
+	if (read_expected(event->tep, TEP_EVENT_OP, ":") < 0)
 		return -1;
 
-	if (read_expect_type(TEP_EVENT_NEWLINE, &token))
+	if (read_expect_type(event->tep, TEP_EVENT_NEWLINE, &token))
 		goto fail;
 	free_token(token);
 
-	ret = event_read_fields(event, &event->format.common_fields);
+	ret = event_read_fields(event->tep, event, &event->format.common_fields);
 	if (ret < 0)
 		return ret;
 	event->format.nr_common = ret;
 
-	ret = event_read_fields(event, &event->format.fields);
+	ret = event_read_fields(event->tep, event, &event->format.fields);
 	if (ret < 0)
 		return ret;
 	event->format.nr_fields = ret;
@@ -2002,7 +2006,7 @@ process_arg(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	enum tep_event_type type;
 	char *token;
 
-	type = read_token(&token);
+	type = read_token(event->tep, &token);
 	*tok = token;
 
 	return process_arg_token(event, arg, tok, type);
@@ -2108,7 +2112,7 @@ process_array(struct tep_event *event, struct tep_print_arg *top, char **tok)
 	top->op.right = arg;
 
 	free_token(token);
-	type = read_token_item(&token);
+	type = read_token_item(event->tep, &token);
 	*tok = token;
 
 	return type;
@@ -2403,7 +2407,7 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 			goto out_free;
 		}
 
-		type = read_token_item(&token);
+		type = read_token_item(event->tep, &token);
 		*tok = token;
 
 		/* could just be a type pointer */
@@ -2509,7 +2513,7 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 	char *field;
 	char *token;
 
-	type = read_token_item(&token);
+	type = read_token_item(event->tep, &token);
 	/*
 	 * Check if REC happens to be surrounded by parenthesis, and
 	 * return if that's the case, as "(REC)->" is valid.
@@ -2525,7 +2529,7 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 
 	free_token(token);
 
-	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+	if (read_expect_type(event->tep, TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
 	field = token;
 
@@ -2542,7 +2546,7 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 		is_symbolic_field = 0;
 	}
 
-	type = read_token(&token);
+	type = read_token(event->tep, &token);
 	*tok = token;
 
 	return type;
@@ -2916,7 +2920,7 @@ process_fields(struct tep_event *event, struct tep_print_flag_sym **list, char *
 
 	do {
 		free_token(token);
-		type = read_token_item(&token);
+		type = read_token_item(event->tep, &token);
 		if (test_type_token(type, token, TEP_EVENT_OP, "{"))
 			break;
 
@@ -2970,7 +2974,7 @@ process_fields(struct tep_event *event, struct tep_print_flag_sym **list, char *
 		list = &field->next;
 
 		free_token(token);
-		type = read_token_item(&token);
+		type = read_token_item(event->tep, &token);
 	} while (type == TEP_EVENT_DELIM && strcmp(token, ",") == 0);
 
 	*tok = token;
@@ -3014,10 +3018,10 @@ process_flags(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 	arg->flags.field = field;
 
-	type = read_token_item(&token);
+	type = read_token_item(event->tep, &token);
 	if (event_item_type(type)) {
 		arg->flags.delim = token;
-		type = read_token_item(&token);
+		type = read_token_item(event->tep, &token);
 	}
 
 	if (test_type_token(type, token, TEP_EVENT_DELIM, ","))
@@ -3028,7 +3032,7 @@ process_flags(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 		goto out_free;
 
 	free_token(token);
-	type = read_token_item(tok);
+	type = read_token_item(event->tep, tok);
 	return type;
 
 out_free_field:
@@ -3067,7 +3071,7 @@ process_symbols(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 		goto out_free;
 
 	free_token(token);
-	type = read_token_item(tok);
+	type = read_token_item(event->tep, tok);
 	return type;
 
 out_free_field:
@@ -3091,7 +3095,7 @@ process_hex_common(struct tep_event *event, struct tep_print_arg *arg,
 	if (alloc_and_process_delim(event, ")", &arg->hex.size))
 		goto free_field;
 
-	return read_token_item(tok);
+	return read_token_item(event->tep, tok);
 
 free_field:
 	free_arg(arg->hex.field);
@@ -3129,7 +3133,7 @@ process_int_array(struct tep_event *event, struct tep_print_arg *arg, char **tok
 	if (alloc_and_process_delim(event, ")", &arg->int_array.el_size))
 		goto free_size;
 
-	return read_token_item(tok);
+	return read_token_item(event->tep, tok);
 
 free_size:
 	free_arg(arg->int_array.count);
@@ -3156,7 +3160,7 @@ process_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, char *
 	 * The item within the parenthesis is another field that holds
 	 * the index into where the array starts.
 	 */
-	type = read_token(&token);
+	type = read_token(event->tep, &token);
 	*tok = token;
 	if (type != TEP_EVENT_ITEM)
 		goto out_free;
@@ -3170,11 +3174,11 @@ process_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, char *
 	arg->dynarray.field = field;
 	arg->dynarray.index = 0;
 
-	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
+	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
 		goto out_free;
 
 	free_token(token);
-	type = read_token_item(&token);
+	type = read_token_item(event->tep, &token);
 	*tok = token;
 	if (type != TEP_EVENT_OP || strcmp(token, "[") != 0)
 		return type;
@@ -3195,7 +3199,7 @@ process_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, char *
 		goto out_free_arg;
 
 	free_token(token);
-	type = read_token_item(tok);
+	type = read_token_item(event->tep, tok);
 	return type;
 
  out_free_arg:
@@ -3214,7 +3218,7 @@ process_dynamic_array_len(struct tep_event *event, struct tep_print_arg *arg,
 	enum tep_event_type type;
 	char *token;
 
-	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+	if (read_expect_type(event->tep, TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
 
 	arg->type = TEP_PRINT_DYNAMIC_ARRAY_LEN;
@@ -3227,11 +3231,11 @@ process_dynamic_array_len(struct tep_event *event, struct tep_print_arg *arg,
 	arg->dynarray.field = field;
 	arg->dynarray.index = 0;
 
-	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
+	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
 
 	free_token(token);
-	type = read_token(&token);
+	type = read_token(event->tep, &token);
 	*tok = token;
 
 	return type;
@@ -3276,7 +3280,7 @@ process_paren(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 		goto out_free;
 
 	free_token(token);
-	type = read_token_item(&token);
+	type = read_token_item(event->tep, &token);
 
 	/*
 	 * If the next token is an item or another open paren, then
@@ -3318,13 +3322,12 @@ process_paren(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 
 static enum tep_event_type
-process_str(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
-	    char **tok)
+process_str(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 {
 	enum tep_event_type type;
 	char *token;
 
-	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+	if (read_expect_type(event->tep, TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
 
 	arg->type = TEP_PRINT_STRING;
@@ -3332,10 +3335,10 @@ process_str(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 	arg->string.offset = -1;
 	arg->string.field = NULL;
 
-	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
+	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
 
-	type = read_token(&token);
+	type = read_token(event->tep, &token);
 	*tok = token;
 
 	return type;
@@ -3348,13 +3351,12 @@ process_str(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 }
 
 static enum tep_event_type
-process_bitmask(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
-		char **tok)
+process_bitmask(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 {
 	enum tep_event_type type;
 	char *token;
 
-	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+	if (read_expect_type(event->tep, TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
 
 	arg->type = TEP_PRINT_BITMASK;
@@ -3362,10 +3364,10 @@ process_bitmask(struct tep_event *event __maybe_unused, struct tep_print_arg *ar
 	arg->bitmask.offset = -1;
 	arg->bitmask.field = NULL;
 
-	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
+	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
 
-	type = read_token(&token);
+	type = read_token(event->tep, &token);
 	*tok = token;
 
 	return type;
@@ -3467,7 +3469,7 @@ process_func_handler(struct tep_event *event, struct tep_function_handler *func,
 		free_token(token);
 	}
 
-	type = read_token(&token);
+	type = read_token(event->tep, &token);
 	*tok = token;
 
 	return type;
@@ -3493,14 +3495,14 @@ process_builtin_expect(struct tep_event *event, struct tep_print_arg *arg, char
 	free_token(token);
 
 	/* We don't care what the second parameter is of the __builtin_expect() */
-	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+	if (read_expect_type(event->tep, TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
 
-	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
+	if (read_expected(event->tep, TEP_EVENT_DELIM, ")") < 0)
 		goto out_free;
 
 	free_token(token);
-	type = read_token_item(tok);
+	type = read_token_item(event->tep, tok);
 	return type;
 
 out_free:
@@ -3518,14 +3520,14 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	bool ok = false;
 	int ret;
 
-	type = read_token_item(&token);
+	type = read_token_item(event->tep, &token);
 
 	arg->type = TEP_PRINT_ATOM;
 
 	/* We handle some sizeof types */
 	if (strcmp(token, "unsigned") == 0) {
 		free_token(token);
-		type = read_token_item(&token);
+		type = read_token_item(event->tep, &token);
 
 		if (type == TEP_EVENT_ERROR)
 			goto error;
@@ -3539,7 +3541,7 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 	} else if (strcmp(token, "long") == 0) {
 		free_token(token);
-		type = read_token_item(&token);
+		type = read_token_item(event->tep, &token);
 
 		if (token && strcmp(token, "long") == 0) {
 			arg->atom.atom = strdup("8");
@@ -3561,13 +3563,13 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	} else if (strcmp(token, "REC") == 0) {
 
 		free_token(token);
-		type = read_token_item(&token);
+		type = read_token_item(event->tep, &token);
 
 		if (test_type_token(type, token,  TEP_EVENT_OP, "->"))
 			goto error;
 		free_token(token);
 
-		if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+		if (read_expect_type(event->tep, TEP_EVENT_ITEM, &token) < 0)
 			goto error;
 
 		field = tep_find_any_field(event, token);
@@ -3585,13 +3587,13 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 	if (!ok) {
 		free_token(token);
-		type = read_token_item(tok);
+		type = read_token_item(event->tep, tok);
 	}
 	if (test_type_token(type, token,  TEP_EVENT_DELIM, ")"))
 		goto error;
 
 	free_token(token);
-	return read_token_item(tok);
+	return read_token_item(event->tep, tok);
 error:
 	free_token(token);
 	*tok = NULL;
@@ -3691,7 +3693,7 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 		}
 		atom = token;
 		/* test the next token */
-		type = read_token_item(&token);
+		type = read_token_item(event->tep, &token);
 
 		/*
 		 * If the next token is a parenthesis, then this
@@ -3716,7 +3718,7 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 				return TEP_EVENT_ERROR;
 			}
 			free_token(token);
-			type = read_token_item(&token);
+			type = read_token_item(event->tep, &token);
 		}
 
 		arg->type = TEP_PRINT_ATOM;
@@ -3727,7 +3729,7 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 	case TEP_EVENT_SQUOTE:
 		arg->type = TEP_PRINT_ATOM;
 		arg->atom.atom = token;
-		type = read_token_item(&token);
+		type = read_token_item(event->tep, &token);
 		break;
 	case TEP_EVENT_DELIM:
 		if (strcmp(token, "(") == 0) {
@@ -3768,7 +3770,7 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
 
 	do {
 		if (type == TEP_EVENT_NEWLINE) {
-			type = read_token_item(&token);
+			type = read_token_item(event->tep, &token);
 			continue;
 		}
 
@@ -3827,16 +3829,16 @@ static int event_read_print(struct tep_event *event)
 	char *token;
 	int ret;
 
-	if (read_expected_item(TEP_EVENT_ITEM, "print") < 0)
+	if (read_expected_item(event->tep, TEP_EVENT_ITEM, "print") < 0)
 		return -1;
 
-	if (read_expected(TEP_EVENT_ITEM, "fmt") < 0)
+	if (read_expected(event->tep, TEP_EVENT_ITEM, "fmt") < 0)
 		return -1;
 
-	if (read_expected(TEP_EVENT_OP, ":") < 0)
+	if (read_expected(event->tep, TEP_EVENT_OP, ":") < 0)
 		return -1;
 
-	if (read_expect_type(TEP_EVENT_DQUOTE, &token) < 0)
+	if (read_expect_type(event->tep, TEP_EVENT_DQUOTE, &token) < 0)
 		goto fail;
 
  concat:
@@ -3844,7 +3846,7 @@ static int event_read_print(struct tep_event *event)
 	event->print_fmt.args = NULL;
 
 	/* ok to have no arg */
-	type = read_token_item(&token);
+	type = read_token_item(event->tep, &token);
 
 	if (type == TEP_EVENT_NONE)
 		return 0;
@@ -7516,7 +7518,7 @@ static void print_args(struct tep_print_arg *args)
 	}
 }
 
-static void parse_header_field(const char *field,
+static void parse_header_field(struct tep_handle *tep, const char *field,
 			       int *offset, int *size, int mandatory)
 {
 	unsigned long long save_input_buf_ptr;
@@ -7524,16 +7526,16 @@ static void parse_header_field(const char *field,
 	char *token;
 	int type;
 
-	save_input_buf_ptr = input_buf_ptr;
-	save_input_buf_siz = input_buf_siz;
+	save_input_buf_ptr = tep->input_buf_ptr;
+	save_input_buf_siz = tep->input_buf_siz;
 
-	if (read_expected(TEP_EVENT_ITEM, "field") < 0)
+	if (read_expected(tep, TEP_EVENT_ITEM, "field") < 0)
 		return;
-	if (read_expected(TEP_EVENT_OP, ":") < 0)
+	if (read_expected(tep, TEP_EVENT_OP, ":") < 0)
 		return;
 
 	/* type */
-	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+	if (read_expect_type(tep, TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
 	free_token(token);
 
@@ -7541,39 +7543,39 @@ static void parse_header_field(const char *field,
 	 * If this is not a mandatory field, then test it first.
 	 */
 	if (mandatory) {
-		if (read_expected(TEP_EVENT_ITEM, field) < 0)
+		if (read_expected(tep, TEP_EVENT_ITEM, field) < 0)
 			return;
 	} else {
-		if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+		if (read_expect_type(tep, TEP_EVENT_ITEM, &token) < 0)
 			goto fail;
 		if (strcmp(token, field) != 0)
 			goto discard;
 		free_token(token);
 	}
 
-	if (read_expected(TEP_EVENT_OP, ";") < 0)
+	if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 		return;
-	if (read_expected(TEP_EVENT_ITEM, "offset") < 0)
+	if (read_expected(tep, TEP_EVENT_ITEM, "offset") < 0)
 		return;
-	if (read_expected(TEP_EVENT_OP, ":") < 0)
+	if (read_expected(tep, TEP_EVENT_OP, ":") < 0)
 		return;
-	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+	if (read_expect_type(tep, TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
 	*offset = atoi(token);
 	free_token(token);
-	if (read_expected(TEP_EVENT_OP, ";") < 0)
+	if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 		return;
-	if (read_expected(TEP_EVENT_ITEM, "size") < 0)
+	if (read_expected(tep, TEP_EVENT_ITEM, "size") < 0)
 		return;
-	if (read_expected(TEP_EVENT_OP, ":") < 0)
+	if (read_expected(tep, TEP_EVENT_OP, ":") < 0)
 		return;
-	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+	if (read_expect_type(tep, TEP_EVENT_ITEM, &token) < 0)
 		goto fail;
 	*size = atoi(token);
 	free_token(token);
-	if (read_expected(TEP_EVENT_OP, ";") < 0)
+	if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 		return;
-	type = read_token(&token);
+	type = read_token(tep, &token);
 	if (type != TEP_EVENT_NEWLINE) {
 		/* newer versions of the kernel have a "signed" type */
 		if (type != TEP_EVENT_ITEM)
@@ -7584,17 +7586,17 @@ static void parse_header_field(const char *field,
 
 		free_token(token);
 
-		if (read_expected(TEP_EVENT_OP, ":") < 0)
+		if (read_expected(tep, TEP_EVENT_OP, ":") < 0)
 			return;
 
-		if (read_expect_type(TEP_EVENT_ITEM, &token))
+		if (read_expect_type(tep, TEP_EVENT_ITEM, &token))
 			goto fail;
 
 		free_token(token);
-		if (read_expected(TEP_EVENT_OP, ";") < 0)
+		if (read_expected(tep, TEP_EVENT_OP, ";") < 0)
 			return;
 
-		if (read_expect_type(TEP_EVENT_NEWLINE, &token))
+		if (read_expect_type(tep, TEP_EVENT_NEWLINE, &token))
 			goto fail;
 	}
  fail:
@@ -7602,8 +7604,8 @@ static void parse_header_field(const char *field,
 	return;
 
  discard:
-	input_buf_ptr = save_input_buf_ptr;
-	input_buf_siz = save_input_buf_siz;
+	tep->input_buf_ptr = save_input_buf_ptr;
+	tep->input_buf_siz = save_input_buf_siz;
 	*offset = 0;
 	*size = 0;
 	free_token(token);
@@ -7638,15 +7640,15 @@ int tep_parse_header_page(struct tep_handle *tep, char *buf, unsigned long size,
 		tep->old_format = 1;
 		return -1;
 	}
-	init_input_buf(buf, size);
+	init_input_buf(tep, buf, size);
 
-	parse_header_field("timestamp", &tep->header_page_ts_offset,
+	parse_header_field(tep, "timestamp", &tep->header_page_ts_offset,
 			   &tep->header_page_ts_size, 1);
-	parse_header_field("commit", &tep->header_page_size_offset,
+	parse_header_field(tep, "commit", &tep->header_page_size_offset,
 			   &tep->header_page_size_size, 1);
-	parse_header_field("overwrite", &tep->header_page_overwrite,
+	parse_header_field(tep, "overwrite", &tep->header_page_overwrite,
 			   &ignore, 0);
-	parse_header_field("data", &tep->header_page_data_offset,
+	parse_header_field(tep, "data", &tep->header_page_data_offset,
 			   &tep->header_page_data_size, 1);
 
 	return 0;
@@ -7723,13 +7725,13 @@ static enum tep_errno parse_format(struct tep_event **eventp,
 	struct tep_event *event;
 	int ret;
 
-	init_input_buf(buf, size);
+	init_input_buf(tep, buf, size);
 
 	*eventp = event = alloc_event();
 	if (!event)
 		return TEP_ERRNO__MEM_ALLOC_FAILED;
 
-	event->name = event_read_name();
+	event->name = event_read_name(tep);
 	if (!event->name) {
 		/* Bad event? */
 		ret = TEP_ERRNO__MEM_ALLOC_FAILED;
@@ -7743,7 +7745,7 @@ static enum tep_errno parse_format(struct tep_event **eventp,
 			event->flags |= TEP_EVENT_FL_ISBPRINT;
 	}
 		
-	event->id = event_read_id();
+	event->id = event_read_id(tep);
 	if (event->id < 0) {
 		ret = TEP_ERRNO__READ_ID_FAILED;
 		/*
diff --git a/src/parse-filter.c b/src/parse-filter.c
index 5df177070d53..e448ee2b6799 100644
--- a/src/parse-filter.c
+++ b/src/parse-filter.c
@@ -30,7 +30,7 @@ struct event_list {
 	struct tep_event	*event;
 };
 
-static void show_error(char *error_buf, const char *fmt, ...)
+static void show_error(struct tep_handle *tep, char *error_buf, const char *fmt, ...)
 {
 	unsigned long long index;
 	const char *input;
@@ -38,8 +38,8 @@ static void show_error(char *error_buf, const char *fmt, ...)
 	int len;
 	int i;
 
-	input = get_input_buf();
-	index = get_input_buf_ptr();
+	input = get_input_buf(tep);
+	index = get_input_buf_ptr(tep);
 	len = input ? strlen(input) : 0;
 
 	if (len) {
@@ -57,20 +57,20 @@ static void show_error(char *error_buf, const char *fmt, ...)
 	va_end(ap);
 }
 
-static enum tep_event_type filter_read_token(char **tok)
+static enum tep_event_type filter_read_token(struct tep_handle *tep, char **tok)
 {
 	enum tep_event_type type;
 	char *token = NULL;
 
 	do {
 		free_token(token);
-		type = read_token(&token);
+		type = read_token(tep, &token);
 	} while (type == TEP_EVENT_NEWLINE || type == TEP_EVENT_SPACE);
 
 	/* If token is = or ! check to see if the next char is ~ */
 	if (token &&
 	    (strcmp(token, "=") == 0 || strcmp(token, "!") == 0) &&
-	    peek_char() == '~') {
+	    peek_char(tep) == '~') {
 		/* append it */
 		*tok = malloc(3);
 		if (*tok == NULL) {
@@ -80,7 +80,7 @@ static enum tep_event_type filter_read_token(char **tok)
 		sprintf(*tok, "%c%c", *token, '~');
 		free_token(token);
 		/* Now remove the '~' from the buffer */
-		read_token(&token);
+		read_token(tep, &token);
 		free_token(token);
 	} else
 		*tok = token;
@@ -337,7 +337,7 @@ create_arg_item(struct tep_event *event, const char *token,
 
 	arg = allocate_arg();
 	if (arg == NULL) {
-		show_error(error_str, "failed to allocate filter arg");
+		show_error(event->tep, error_str, "failed to allocate filter arg");
 		return TEP_ERRNO__MEM_ALLOC_FAILED;
 	}
 
@@ -351,7 +351,7 @@ create_arg_item(struct tep_event *event, const char *token,
 		arg->value.str = strdup(token);
 		if (!arg->value.str) {
 			free_arg(arg);
-			show_error(error_str, "failed to allocate string filter arg");
+			show_error(event->tep, error_str, "failed to allocate string filter arg");
 			return TEP_ERRNO__MEM_ALLOC_FAILED;
 		}
 		break;
@@ -383,7 +383,7 @@ create_arg_item(struct tep_event *event, const char *token,
 		break;
 	default:
 		free_arg(arg);
-		show_error(error_str, "expected a value but found %s", token);
+		show_error(event->tep, error_str, "expected a value but found %s", token);
 		return TEP_ERRNO__UNEXPECTED_TYPE;
 	}
 	*parg = arg;
@@ -437,7 +437,8 @@ create_arg_cmp(enum tep_filter_cmp_type ctype)
 }
 
 static enum tep_errno
-add_right(struct tep_filter_arg *op, struct tep_filter_arg *arg, char *error_str)
+add_right(struct tep_handle *tep, struct tep_filter_arg *op,
+		struct tep_filter_arg *arg, char *error_str)
 {
 	struct tep_filter_arg *left;
 	char *str;
@@ -468,7 +469,7 @@ add_right(struct tep_filter_arg *op, struct tep_filter_arg *arg, char *error_str
 		case TEP_FILTER_ARG_FIELD:
 			break;
 		default:
-			show_error(error_str, "Illegal rvalue");
+			show_error(tep, error_str, "Illegal rvalue");
 			return TEP_ERRNO__ILLEGAL_RVALUE;
 		}
 
@@ -514,7 +515,7 @@ add_right(struct tep_filter_arg *op, struct tep_filter_arg *arg, char *error_str
 
 			/* Left arg must be a field */
 			if (left->type != TEP_FILTER_ARG_FIELD) {
-				show_error(error_str,
+				show_error(tep, error_str,
 					   "Illegal lvalue for string comparison");
 				return TEP_ERRNO__ILLEGAL_LVALUE;
 			}
@@ -532,14 +533,14 @@ add_right(struct tep_filter_arg *op, struct tep_filter_arg *arg, char *error_str
 			case TEP_FILTER_CMP_NOT_REGEX:
 				ret = regcomp(&op->str.reg, str, REG_ICASE|REG_NOSUB);
 				if (ret) {
-					show_error(error_str,
+					show_error(tep, error_str,
 						   "RegEx '%s' did not compute",
 						   str);
 					return TEP_ERRNO__INVALID_REGEX;
 				}
 				break;
 			default:
-				show_error(error_str,
+				show_error(tep, error_str,
 					   "Illegal comparison for string");
 				return TEP_ERRNO__ILLEGAL_STRING_CMP;
 			}
@@ -549,7 +550,7 @@ add_right(struct tep_filter_arg *op, struct tep_filter_arg *arg, char *error_str
 			op->str.field = left->field.field;
 			op->str.val = strdup(str);
 			if (!op->str.val) {
-				show_error(error_str, "Failed to allocate string filter");
+				show_error(tep, error_str, "Failed to allocate string filter");
 				return TEP_ERRNO__MEM_ALLOC_FAILED;
 			}
 			/*
@@ -557,7 +558,7 @@ add_right(struct tep_filter_arg *op, struct tep_filter_arg *arg, char *error_str
 			 */
 			op->str.buffer = malloc(op->str.field->size + 1);
 			if (!op->str.buffer) {
-				show_error(error_str, "Failed to allocate string filter");
+				show_error(tep, error_str, "Failed to allocate string filter");
 				return TEP_ERRNO__MEM_ALLOC_FAILED;
 			}
 			/* Null terminate this buffer */
@@ -575,7 +576,7 @@ add_right(struct tep_filter_arg *op, struct tep_filter_arg *arg, char *error_str
 			switch (op->num.type) {
 			case TEP_FILTER_CMP_REGEX:
 			case TEP_FILTER_CMP_NOT_REGEX:
-				show_error(error_str,
+				show_error(tep, error_str,
 					   "Op not allowed with integers");
 				return TEP_ERRNO__ILLEGAL_INTEGER_CMP;
 
@@ -597,7 +598,7 @@ add_right(struct tep_filter_arg *op, struct tep_filter_arg *arg, char *error_str
 	return 0;
 
  out_fail:
-	show_error(error_str, "Syntax error");
+	show_error(tep, error_str, "Syntax error");
 	return TEP_ERRNO__SYNTAX_ERROR;
 }
 
@@ -748,15 +749,16 @@ enum filter_vals {
 };
 
 static enum tep_errno
-reparent_op_arg(struct tep_filter_arg *parent, struct tep_filter_arg *old_child,
-		struct tep_filter_arg *arg, char *error_str)
+reparent_op_arg(struct tep_handle *tep, struct tep_filter_arg *parent,
+		struct tep_filter_arg *old_child, struct tep_filter_arg *arg,
+		char *error_str)
 {
 	struct tep_filter_arg *other_child;
 	struct tep_filter_arg **ptr;
 
 	if (parent->type != TEP_FILTER_ARG_OP &&
 	    arg->type != TEP_FILTER_ARG_OP) {
-		show_error(error_str, "can not reparent other than OP");
+		show_error(tep, error_str, "can not reparent other than OP");
 		return TEP_ERRNO__REPARENT_NOT_OP;
 	}
 
@@ -768,7 +770,7 @@ reparent_op_arg(struct tep_filter_arg *parent, struct tep_filter_arg *old_child,
 		ptr = &old_child->op.left;
 		other_child = old_child->op.right;
 	} else {
-		show_error(error_str, "Error in reparent op, find other child");
+		show_error(tep, error_str, "Error in reparent op, find other child");
 		return TEP_ERRNO__REPARENT_FAILED;
 	}
 
@@ -789,7 +791,7 @@ reparent_op_arg(struct tep_filter_arg *parent, struct tep_filter_arg *old_child,
 	else if (parent->op.left == old_child)
 		ptr = &parent->op.left;
 	else {
-		show_error(error_str, "Error in reparent op");
+		show_error(tep, error_str, "Error in reparent op");
 		return TEP_ERRNO__REPARENT_FAILED;
 	}
 
@@ -800,8 +802,8 @@ reparent_op_arg(struct tep_filter_arg *parent, struct tep_filter_arg *old_child,
 }
 
 /* Returns either filter_vals (success) or tep_errno (failfure) */
-static int test_arg(struct tep_filter_arg *parent, struct tep_filter_arg *arg,
-		    char *error_str)
+static int test_arg(struct tep_handle *tep, struct tep_filter_arg *parent,
+		struct tep_filter_arg *arg, char *error_str)
 {
 	int lval, rval;
 
@@ -818,47 +820,47 @@ static int test_arg(struct tep_filter_arg *parent, struct tep_filter_arg *arg,
 		return FILTER_VAL_NORM;
 
 	case TEP_FILTER_ARG_EXP:
-		lval = test_arg(arg, arg->exp.left, error_str);
+		lval = test_arg(tep, arg, arg->exp.left, error_str);
 		if (lval != FILTER_VAL_NORM)
 			return lval;
-		rval = test_arg(arg, arg->exp.right, error_str);
+		rval = test_arg(tep, arg, arg->exp.right, error_str);
 		if (rval != FILTER_VAL_NORM)
 			return rval;
 		return FILTER_VAL_NORM;
 
 	case TEP_FILTER_ARG_NUM:
-		lval = test_arg(arg, arg->num.left, error_str);
+		lval = test_arg(tep, arg, arg->num.left, error_str);
 		if (lval != FILTER_VAL_NORM)
 			return lval;
-		rval = test_arg(arg, arg->num.right, error_str);
+		rval = test_arg(tep, arg, arg->num.right, error_str);
 		if (rval != FILTER_VAL_NORM)
 			return rval;
 		return FILTER_VAL_NORM;
 
 	case TEP_FILTER_ARG_OP:
 		if (arg->op.type != TEP_FILTER_OP_NOT) {
-			lval = test_arg(arg, arg->op.left, error_str);
+			lval = test_arg(tep, arg, arg->op.left, error_str);
 			switch (lval) {
 			case FILTER_VAL_NORM:
 				break;
 			case FILTER_VAL_TRUE:
 				if (arg->op.type == TEP_FILTER_OP_OR)
 					return FILTER_VAL_TRUE;
-				rval = test_arg(arg, arg->op.right, error_str);
+				rval = test_arg(tep, arg, arg->op.right, error_str);
 				if (rval != FILTER_VAL_NORM)
 					return rval;
 
-				return reparent_op_arg(parent, arg, arg->op.right,
+				return reparent_op_arg(tep, parent, arg, arg->op.right,
 						       error_str);
 
 			case FILTER_VAL_FALSE:
 				if (arg->op.type == TEP_FILTER_OP_AND)
 					return FILTER_VAL_FALSE;
-				rval = test_arg(arg, arg->op.right, error_str);
+				rval = test_arg(tep, arg, arg->op.right, error_str);
 				if (rval != FILTER_VAL_NORM)
 					return rval;
 
-				return reparent_op_arg(parent, arg, arg->op.right,
+				return reparent_op_arg(tep, parent, arg, arg->op.right,
 						       error_str);
 
 			default:
@@ -866,7 +868,7 @@ static int test_arg(struct tep_filter_arg *parent, struct tep_filter_arg *arg,
 			}
 		}
 
-		rval = test_arg(arg, arg->op.right, error_str);
+		rval = test_arg(tep, arg, arg->op.right, error_str);
 		switch (rval) {
 		case FILTER_VAL_NORM:
 		default:
@@ -878,7 +880,7 @@ static int test_arg(struct tep_filter_arg *parent, struct tep_filter_arg *arg,
 			if (arg->op.type == TEP_FILTER_OP_NOT)
 				return FILTER_VAL_FALSE;
 
-			return reparent_op_arg(parent, arg, arg->op.left,
+			return reparent_op_arg(tep, parent, arg, arg->op.left,
 					       error_str);
 
 		case FILTER_VAL_FALSE:
@@ -887,25 +889,25 @@ static int test_arg(struct tep_filter_arg *parent, struct tep_filter_arg *arg,
 			if (arg->op.type == TEP_FILTER_OP_NOT)
 				return FILTER_VAL_TRUE;
 
-			return reparent_op_arg(parent, arg, arg->op.left,
+			return reparent_op_arg(tep, parent, arg, arg->op.left,
 					       error_str);
 		}
 
 		return rval;
 	default:
-		show_error(error_str, "bad arg in filter tree");
+		show_error(tep, error_str, "bad arg in filter tree");
 		return TEP_ERRNO__BAD_FILTER_ARG;
 	}
 	return FILTER_VAL_NORM;
 }
 
 /* Remove any unknown event fields */
-static int collapse_tree(struct tep_filter_arg *arg,
+static int collapse_tree(struct tep_handle *tep, struct tep_filter_arg *arg,
 			 struct tep_filter_arg **arg_collapsed, char *error_str)
 {
 	int ret;
 
-	ret = test_arg(arg, arg, error_str);
+	ret = test_arg(tep, arg, arg, error_str);
 	switch (ret) {
 	case FILTER_VAL_NORM:
 		break;
@@ -918,7 +920,7 @@ static int collapse_tree(struct tep_filter_arg *arg,
 			arg->type = TEP_FILTER_ARG_BOOLEAN;
 			arg->boolean.value = ret == FILTER_VAL_TRUE;
 		} else {
-			show_error(error_str, "Failed to allocate filter arg");
+			show_error(tep, error_str, "Failed to allocate filter arg");
 			ret = TEP_ERRNO__MEM_ALLOC_FAILED;
 		}
 		break;
@@ -954,7 +956,7 @@ process_filter(struct tep_event *event, struct tep_filter_arg **parg,
 
 	do {
 		free(token);
-		type = filter_read_token(&token);
+		type = filter_read_token(event->tep, &token);
 		switch (type) {
 		case TEP_EVENT_SQUOTE:
 		case TEP_EVENT_DQUOTE:
@@ -965,7 +967,7 @@ process_filter(struct tep_event *event, struct tep_filter_arg **parg,
 			if (!left_item)
 				left_item = arg;
 			else if (current_exp) {
-				ret = add_right(current_exp, arg, error_str);
+				ret = add_right(event->tep, current_exp, arg, error_str);
 				if (ret < 0)
 					goto fail;
 				left_item = NULL;
@@ -985,20 +987,20 @@ process_filter(struct tep_event *event, struct tep_filter_arg **parg,
 
 		case TEP_EVENT_DELIM:
 			if (*token == ',') {
-				show_error(error_str, "Illegal token ','");
+				show_error(event->tep, error_str, "Illegal token ','");
 				ret = TEP_ERRNO__ILLEGAL_TOKEN;
 				goto fail;
 			}
 
 			if (*token == '(') {
 				if (left_item) {
-					show_error(error_str,
+					show_error(event->tep, error_str,
 						   "Open paren can not come after item");
 					ret = TEP_ERRNO__INVALID_PAREN;
 					goto fail;
 				}
 				if (current_exp) {
-					show_error(error_str,
+					show_error(event->tep, error_str,
 						   "Open paren can not come after expression");
 					ret = TEP_ERRNO__INVALID_PAREN;
 					goto fail;
@@ -1007,7 +1009,7 @@ process_filter(struct tep_event *event, struct tep_filter_arg **parg,
 				ret = process_filter(event, &arg, error_str, 0);
 				if (ret != TEP_ERRNO__UNBALANCED_PAREN) {
 					if (ret == 0) {
-						show_error(error_str,
+						show_error(event->tep, error_str,
 							   "Unbalanced number of '('");
 						ret = TEP_ERRNO__UNBALANCED_PAREN;
 					}
@@ -1024,7 +1026,7 @@ process_filter(struct tep_event *event, struct tep_filter_arg **parg,
 				}
 
 				if (current_op)
-					ret = add_right(current_op, arg, error_str);
+					ret = add_right(event->tep, current_op, arg, error_str);
 				else
 					current_exp = arg;
 
@@ -1071,7 +1073,7 @@ process_filter(struct tep_event *event, struct tep_filter_arg **parg,
 					goto fail_syntax;
 				break;
 			case OP_NONE:
-				show_error(error_str,
+				show_error(event->tep, error_str,
 					   "Unknown op token %s", token);
 				ret = TEP_ERRNO__UNKNOWN_TOKEN;
 				goto fail;
@@ -1096,14 +1098,14 @@ process_filter(struct tep_event *event, struct tep_filter_arg **parg,
 				if (arg == NULL)
 					goto fail_alloc;
 				if (current_op)
-					ret = add_right(current_op, arg, error_str);
+					ret = add_right(event->tep, current_op, arg, error_str);
 				if (ret < 0)
 					goto fail;
 				current_exp = arg;
 				ret = process_filter(event, &arg, error_str, 1);
 				if (ret < 0)
 					goto fail;
-				ret = add_right(current_exp, arg, error_str);
+				ret = add_right(event->tep, current_exp, arg, error_str);
 				if (ret < 0)
 					goto fail;
 				break;
@@ -1118,7 +1120,7 @@ process_filter(struct tep_event *event, struct tep_filter_arg **parg,
 					goto fail_alloc;
 
 				if (current_op)
-					ret = add_right(current_op, arg, error_str);
+					ret = add_right(event->tep,current_op, arg, error_str);
 				if (ret < 0)
 					goto fail;
 				ret = add_left(arg, left_item);
@@ -1150,7 +1152,7 @@ process_filter(struct tep_event *event, struct tep_filter_arg **parg,
 	if (!current_op)
 		current_op = current_exp;
 
-	ret = collapse_tree(current_op, parg, error_str);
+	ret = collapse_tree(event->tep, current_op, parg, error_str);
 	/* collapse_tree() may free current_op, and updates parg accordingly */
 	current_op = NULL;
 	if (ret < 0)
@@ -1160,11 +1162,11 @@ process_filter(struct tep_event *event, struct tep_filter_arg **parg,
 	return 0;
 
  fail_alloc:
-	show_error(error_str, "failed to allocate filter arg");
+	show_error(event->tep, error_str, "failed to allocate filter arg");
 	ret = TEP_ERRNO__MEM_ALLOC_FAILED;
 	goto fail;
  fail_syntax:
-	show_error(error_str, "Syntax error");
+	show_error(event->tep, error_str, "Syntax error");
 	ret = TEP_ERRNO__SYNTAX_ERROR;
  fail:
 	free_arg(current_op);
@@ -1180,7 +1182,7 @@ process_event(struct tep_event *event, const char *filter_str,
 {
 	int ret;
 
-	init_input_buf(filter_str, strlen(filter_str));
+	init_input_buf(event->tep, filter_str, strlen(filter_str));
 
 	ret = process_filter(event, parg, error_str, 0);
 	if (ret < 0)
@@ -1238,7 +1240,7 @@ filter_event(struct tep_event_filter *filter, struct tep_event *event,
 static void filter_init_error_buf(struct tep_event_filter *filter)
 {
 	/* clear buffer to reset show error */
-	init_input_buf("", 0);
+	init_input_buf(filter->tep, "", 0);
 	filter->error_buffer[0] = '\0';
 }
 
-- 
2.38.1

