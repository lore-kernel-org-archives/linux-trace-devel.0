Return-Path: <SRS0=vwyE=AG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2BDC433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:04:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 077B320702
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:04:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VhRwS3nd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389860AbgFYKEq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 06:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390025AbgFYKEp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 06:04:45 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D079AC0613ED
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:04:44 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 17so5303632wmo.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hoQ8WMMh1qm+t9KJLjlaOckcPjrvtFzWy0CAWrNYZes=;
        b=VhRwS3ndrWTv8ahOKfoitnmeBG+ydKCP8xGwPwvExpYiu9GnCQTzH4+484+wCI5cnI
         AUrzrVsiwDZxltMWQabKGKL3E9ay1/+qSmdnDmIdIihZWuffkaG0jSbCLyQYc362xNhV
         iikrI5A1fcbnHrtRaamsazWLa4W1MvmYofup/Vmt7urKyi8eIarGWm7CQBtaBegU+OoS
         J89GzxTuNJAEqg+MysENJgGZ89T1TKxkjzq2e0hcPy2YHRZPksHlkJePL4VTwaKnSQtA
         itqpZeMuvSEaRdobzpOk39wIORAPDzuNY09ujVsgaJqBYo6uWPlyoRkYOXg4+rpGLqns
         SoTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hoQ8WMMh1qm+t9KJLjlaOckcPjrvtFzWy0CAWrNYZes=;
        b=stf3vpJ1/WVGS1YvoOx8eZIPA/xR9SlrnM1FNIo867OLw6YInkKtIzOQ3qBo+I8EQT
         73beyfa4wxAQlAF0m1fK028WFP+uT6UeXN8NBpP9EWaCGwUlLU1zCmAzPc+xyJO6jFHN
         URWaPsIzS92l+fJTqyO1m8/3wu48X+e/zy1L57CQphzxi1MjYX7KLLhyBeHlHwVh+A6c
         jFLGmPxjdVXqQgFBJHv/g7prY5tLVFTEsuGbNv00Ez4QCJBqJupLoebFvNyKX/txFK5R
         6fTlbnmTBU6/5IAVT3eiHOOc55VT+dxvxwSEVEzINbr+sbsjpu1/QtZNLjfsdzivzGqu
         bYpw==
X-Gm-Message-State: AOAM533gsGu7DAR2V+ehwMgt8PskTAAkRMRUWxm4bTdqxJfBjna4vjHv
        6n2hFKM2IdL8pfhSXD5ocNU=
X-Google-Smtp-Source: ABdhPJxO7E4HsgGsAyM8scMyBtIXm4x8S5Y8+0EWXJxjcS9vtoPbreVe2I7P8p78CUEm+FpXrjPAdQ==
X-Received: by 2002:a05:600c:2202:: with SMTP id z2mr2630667wml.13.1593079483511;
        Thu, 25 Jun 2020 03:04:43 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm7519008wmf.33.2020.06.25.03.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 03:04:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] trace-cmd traceevent: Add append() function helper for appending strings
Date:   Thu, 25 Jun 2020 13:04:38 +0300
Message-Id: <20200625100440.365196-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625100440.365196-1-tz.stoyanov@gmail.com>
References: <20200625100440.365196-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

There's several locations that open code realloc and strcat() to append
text to strings. Add an append() function that takes a delimiter and a
string to append to another string.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jaewon Lim <jaewon31.kim@samsung.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kees Kook <keescook@chromium.org>
Cc: linux-mm@kvack.org
Cc: linux-trace-devel@vger.kernel.org
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Link: http://lore.kernel.org/lkml/20200324200956.515118403@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-parse.c | 98 +++++++++++++++---------------------
 1 file changed, 40 insertions(+), 58 deletions(-)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index d8115d7a..6249dacd 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
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
2.26.2

