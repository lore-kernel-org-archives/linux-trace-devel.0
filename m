Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFD1C4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 12:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A599960F41
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 12:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbhHDM4A (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Aug 2021 08:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236732AbhHDMz7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Aug 2021 08:55:59 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098CDC061798
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Aug 2021 05:55:47 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id b11so2136296wrx.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Aug 2021 05:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vqNfWsbkxSHdSuSMBnWNRmUdplBTkyS0Te7pBSPTcvY=;
        b=UNPhJVkyOZRm4AHAQYrolDWqQA6AC/rfomyGOZLhqAFPE873AFA2/pt4s/pug7l00I
         SlB+A7fsHZMKDtibHDzii7pDLsDa/PRj4mTaeq509mFM+A/lsCWfxYONexmT6G/9Bo+V
         QWqDqLBNHMsp4Zc3aqQit0cQBTf9Rysr+QaGoBgK9BDwJI15uHo6bFAaDZEh6WG6WJZT
         82yNZYNIaRGFLjVhRmnVCt14byXN2TSgqdSdRFtuNF1hc4u9Sw/meXCuF0RDiTIG8NIn
         YkPoRT6ftraP3eTX8C++TAMMn5XFd7uCe/nNjW/ltG4oKxjG/VMiGDItA6Vqw6oChNK2
         Jsmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vqNfWsbkxSHdSuSMBnWNRmUdplBTkyS0Te7pBSPTcvY=;
        b=dZYZ4qhQNqwsrKT3owociJ/G2VMDW6K+onXwcQuaV9E5AySow4+H6ZWi8r/8VH9DnS
         8eSf+Pj6HqbVtL2hPpYPCZhewESiZaDH0CSsl7ErAOnrAbPqG2AG/DIZQ5w3LdaOU699
         DVE0qryxv6JkoBQPArz6UxtLSvWYDKWylMvTkILYNjIWbo3+el+ozUtQyqyS1BUESZJH
         z7/ZXHylS4AUMGQEZilfSqnOQYS1ONszGs2OH2qVf7M0nFvYFB5Q7YZtZNG1ALb9mSsU
         EaJvjf/qsrW+Cp/SbARKqPTu14bdXclscMpXPR5acZ0F9OmiFRHYut0jsMxEXUna1xfO
         6dOQ==
X-Gm-Message-State: AOAM530GA1daMKIvjxnCHgEgGbsJCKwpVHLKbLR1LlIyPnq9kv5LfVN+
        TwtMUA4Gzww05RZ9zF2aQk4=
X-Google-Smtp-Source: ABdhPJyyRmezcru7sGwRZMhS6S50l1cnc95vc6/uu9newUYf4Rq6IzZqMq2Bem25kUsi2Uh5F4OKiQ==
X-Received: by 2002:a5d:65c1:: with SMTP id e1mr28507518wrw.320.1628081745642;
        Wed, 04 Aug 2021 05:55:45 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id q20sm2214982wmj.27.2021.08.04.05.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 05:55:45 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/2] libtraceevent: Keep the pointer to the field in args (WiP)
Date:   Wed,  4 Aug 2021 15:55:26 +0300
Message-Id: <20210804125526.19774-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210804125526.19774-1-y.karadz@gmail.com>
References: <20210804125526.19774-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

In order to have tep_print_field() print the field closer to the way it
is printed via the "pretty_print" method, all field args, must keep a
pointer to the field it represents.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---

Hi Steven,

This version is still WORK IN PROGRESS! 

Changes in c2:

 A kprobe that is defined as:
 "p:open do_sys_openat2 file=+0($arg2):string flags=+0($arg3):x64 mode=+8($arg3):x64"

 will have the following printing format:
 "print fmt: "(%lx) file=\"%s\" flags=0x%Lx mode=0x%Lx", REC->__probe_ip, __get_str(file), REC->flags, REC->mode"

 In v2 I am trying to add propper handling of the "file" fieled
 (via "__get_str") of this particular probe. A solution for the general
 case still needs to be developed.

 Any ideas?
 
Thanks!
Yordan


 src/event-parse.c | 60 +++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 26 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index b0790d7..64ebed3 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2334,12 +2334,12 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 	arg->type = TEP_PRINT_FIELD;
 	arg->field.name = field;
 
+	arg->field.field = tep_find_any_field(event, arg->field.name);
+
 	if (is_flag_field) {
-		arg->field.field = tep_find_any_field(event, arg->field.name);
 		arg->field.field->flags |= TEP_FIELD_IS_FLAG;
 		is_flag_field = 0;
 	} else if (is_symbolic_field) {
-		arg->field.field = tep_find_any_field(event, arg->field.name);
 		arg->field.field->flags |= TEP_FIELD_IS_SYMBOLIC;
 		is_symbolic_field = 0;
 	}
@@ -3103,7 +3103,7 @@ process_paren(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 static enum tep_event_type
 process_str(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
-	    char **tok)
+	    char **field, char **tok)
 {
 	enum tep_event_type type;
 	char *token;
@@ -3111,6 +3111,7 @@ process_str(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
 
+	*field = token;
 	arg->type = TEP_PRINT_STRING;
 	arg->string.string = token;
 	arg->string.offset = -1;
@@ -3285,59 +3286,66 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
 		 char *token, char **tok)
 {
 	struct tep_function_handler *func;
+	int ret = TEP_EVENT_ERROR;
+	char *field = NULL;
 
 	if (strcmp(token, "__print_flags") == 0) {
-		free_token(token);
 		is_flag_field = 1;
-		return process_flags(event, arg, tok);
+		ret = process_flags(event, arg, tok);
+		goto done;
 	}
 	if (strcmp(token, "__print_symbolic") == 0) {
-		free_token(token);
 		is_symbolic_field = 1;
-		return process_symbols(event, arg, tok);
+		ret = process_symbols(event, arg, tok);
+		goto done;
 	}
 	if (strcmp(token, "__print_hex") == 0) {
-		free_token(token);
-		return process_hex(event, arg, tok);
+		ret = process_hex(event, arg, tok);
+		goto done;
 	}
 	if (strcmp(token, "__print_hex_str") == 0) {
-		free_token(token);
-		return process_hex_str(event, arg, tok);
+		ret = process_hex_str(event, arg, tok);
+		goto done;
 	}
 	if (strcmp(token, "__print_array") == 0) {
-		free_token(token);
-		return process_int_array(event, arg, tok);
+		ret = process_int_array(event, arg, tok);
+		goto done;
 	}
 	if (strcmp(token, "__get_str") == 0) {
-		free_token(token);
-		return process_str(event, arg, tok);
+		ret = process_str(event, arg, &field, tok);
+		goto done;
 	}
 	if (strcmp(token, "__get_bitmask") == 0) {
-		free_token(token);
-		return process_bitmask(event, arg, tok);
+		ret = process_bitmask(event, arg, tok);
+		goto done;
 	}
 	if (strcmp(token, "__get_dynamic_array") == 0) {
-		free_token(token);
-		return process_dynamic_array(event, arg, tok);
+		ret = process_dynamic_array(event, arg, tok);
+		goto done;
 	}
 	if (strcmp(token, "__get_dynamic_array_len") == 0) {
-		free_token(token);
-		return process_dynamic_array_len(event, arg, tok);
+		ret = process_dynamic_array_len(event, arg, tok);
+		goto done;
 	}
 	if (strcmp(token, "__builtin_expect") == 0) {
-		free_token(token);
-		return process_builtin_expect(event, arg, tok);
+		ret = process_builtin_expect(event, arg, tok);
+		goto done;
 	}
 
 	func = find_func_handler(event->tep, token);
 	if (func) {
-		free_token(token);
-		return process_func_handler(event, func, arg, tok);
+		ret = process_func_handler(event, func, arg, tok);
+		goto done;
 	}
 
 	do_warning_event(event, "function %s not defined", token);
+
+ done:
+	if (field)
+		arg->field.field = tep_find_any_field(event, field);
+
 	free_token(token);
-	return TEP_EVENT_ERROR;
+	return ret;
 }
 
 static enum tep_event_type
-- 
2.30.2

