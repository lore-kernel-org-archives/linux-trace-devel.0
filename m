Return-Path: <SRS0=3OGB=5J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98677C54FCF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Mar 2020 20:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72ACE20B1F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Mar 2020 20:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgCXUKA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Mar 2020 16:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbgCXUJ7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Mar 2020 16:09:59 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B039820788;
        Tue, 24 Mar 2020 20:09:57 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jGps4-001hQA-KT; Tue, 24 Mar 2020 16:09:56 -0400
Message-Id: <20200324200956.515118403@goodmis.org>
User-Agent: quilt/0.65
Date:   Tue, 24 Mar 2020 16:08:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Jaewon Kim <jaewon31.kim@samsung.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/3] tools lib traceevent: Add append() function helper for appending
 strings
References: <20200324200845.763565368@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

There's several locations that open code realloc and strcat() to append text
to strings. Add an append() function that takes a delimiter and a string to
append to another string.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c | 98 ++++++++++++------------------
 1 file changed, 40 insertions(+), 58 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index e1bd2a93c6db..eec96c31ea9e 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1425,6 +1425,19 @@ static unsigned int type_size(const char *name)
 	return 0;
 }
 
+static int append(char **buf, const char *delim, const char *str)
+{
+	char *new_buf;
+
+	new_buf = realloc(*buf, strlen(*buf) + strlen(delim) + strlen(str) + 1);
+	if (!new_buf)
+		return -1;
+	strcat(new_buf, delim);
+	strcat(new_buf, str);
+	*buf = new_buf;
+	return 0;
+}
+
 static int event_read_fields(struct tep_event *event, struct tep_format_field **fields)
 {
 	struct tep_format_field *field = NULL;
@@ -1432,6 +1445,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 	char *token;
 	char *last_token;
 	int count = 0;
+	int ret;
 
 	do {
 		unsigned int size_dynamic = 0;
@@ -1490,24 +1504,15 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 					field->flags |= TEP_FIELD_IS_POINTER;
 
 				if (field->type) {
-					char *new_type;
-					new_type = realloc(field->type,
-							   strlen(field->type) +
-							   strlen(last_token) + 2);
-					if (!new_type) {
-						free(last_token);
-						goto fail;
-					}
-					field->type = new_type;
-					strcat(field->type, " ");
-					strcat(field->type, last_token);
+					ret = append(&field->type, " ", last_token);
 					free(last_token);
+					if (ret < 0)
+						goto fail;
 				} else
 					field->type = last_token;
 				last_token = token;
 				continue;
 			}
-
 			break;
 		}
 
@@ -1523,8 +1528,6 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 		if (strcmp(token, "[") == 0) {
 			enum tep_event_type last_type = type;
 			char *brackets = token;
-			char *new_brackets;
-			int len;
 
 			field->flags |= TEP_FIELD_IS_ARRAY;
 
@@ -1536,29 +1539,27 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 				field->arraylen = 0;
 
 		        while (strcmp(token, "]") != 0) {
+				const char *delim;
+
 				if (last_type == TEP_EVENT_ITEM &&
 				    type == TEP_EVENT_ITEM)
-					len = 2;
+					delim = " ";
 				else
-					len = 1;
+					delim = "";
+
 				last_type = type;
 
-				new_brackets = realloc(brackets,
-						       strlen(brackets) +
-						       strlen(token) + len);
-				if (!new_brackets) {
+				ret = append(&brackets, delim, token);
+				if (ret < 0) {
 					free(brackets);
 					goto fail;
 				}
-				brackets = new_brackets;
-				if (len == 2)
-					strcat(brackets, " ");
-				strcat(brackets, token);
 				/* We only care about the last token */
 				field->arraylen = strtoul(token, NULL, 0);
 				free_token(token);
 				type = read_token(&token);
 				if (type == TEP_EVENT_NONE) {
+					free(brackets);
 					do_warning_event(event, "failed to find token");
 					goto fail;
 				}
@@ -1566,13 +1567,11 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 
 			free_token(token);
 
-			new_brackets = realloc(brackets, strlen(brackets) + 2);
-			if (!new_brackets) {
+			ret = append(&brackets, "", "]");
+			if (ret < 0) {
 				free(brackets);
 				goto fail;
 			}
-			brackets = new_brackets;
-			strcat(brackets, "]");
 
 			/* add brackets to type */
 
@@ -1582,34 +1581,23 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 			 * the format: type [] item;
 			 */
 			if (type == TEP_EVENT_ITEM) {
-				char *new_type;
-				new_type = realloc(field->type,
-						   strlen(field->type) +
-						   strlen(field->name) +
-						   strlen(brackets) + 2);
-				if (!new_type) {
+				ret = append(&field->type, " ", field->name);
+				if (ret < 0) {
 					free(brackets);
 					goto fail;
 				}
-				field->type = new_type;
-				strcat(field->type, " ");
-				strcat(field->type, field->name);
+				ret = append(&field->type, "", brackets);
+
 				size_dynamic = type_size(field->name);
 				free_token(field->name);
-				strcat(field->type, brackets);
 				field->name = field->alias = token;
 				type = read_token(&token);
 			} else {
-				char *new_type;
-				new_type = realloc(field->type,
-						   strlen(field->type) +
-						   strlen(brackets) + 1);
-				if (!new_type) {
+				ret = append(&field->type, "", brackets);
+				if (ret < 0) {
 					free(brackets);
 					goto fail;
 				}
-				field->type = new_type;
-				strcat(field->type, brackets);
 			}
 			free(brackets);
 		}
@@ -2046,19 +2034,16 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 		/* could just be a type pointer */
 		if ((strcmp(arg->op.op, "*") == 0) &&
 		    type == TEP_EVENT_DELIM && (strcmp(token, ")") == 0)) {
-			char *new_atom;
+			int ret;
 
 			if (left->type != TEP_PRINT_ATOM) {
 				do_warning_event(event, "bad pointer type");
 				goto out_free;
 			}
-			new_atom = realloc(left->atom.atom,
-					    strlen(left->atom.atom) + 3);
-			if (!new_atom)
+			ret = append(&left->atom.atom, " ", "*");
+			if (ret < 0)
 				goto out_warn_free;
 
-			left->atom.atom = new_atom;
-			strcat(left->atom.atom, " *");
 			free(arg->op.op);
 			*arg = *left;
 			free(left);
@@ -3151,18 +3136,15 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 		}
 		/* atoms can be more than one token long */
 		while (type == TEP_EVENT_ITEM) {
-			char *new_atom;
-			new_atom = realloc(atom,
-					   strlen(atom) + strlen(token) + 2);
-			if (!new_atom) {
+			int ret;
+
+			ret = append(&atom, " ", token);
+			if (ret < 0) {
 				free(atom);
 				*tok = NULL;
 				free_token(token);
 				return TEP_EVENT_ERROR;
 			}
-			atom = new_atom;
-			strcat(atom, " ");
-			strcat(atom, token);
 			free_token(token);
 			type = read_token_item(&token);
 		}
-- 
2.25.1


