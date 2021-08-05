Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FA8C4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Aug 2021 13:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ADBF61155
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Aug 2021 13:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbhHENev (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Aug 2021 09:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbhHENev (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 09:34:51 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570B9C061765
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Aug 2021 06:34:36 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id z4so6571120wrv.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Aug 2021 06:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EuIVbYOfQxc46N7AlV5nvC8pq53FlnNcRnKiJ6o61uE=;
        b=BrCXcZjxxcf/leJuVRW4S+X46aoqdjthGZGLRXoLJoZv6sHo5f03mVsQVoARdx0tZ9
         73vgChnTwHkOWJ2MhclhDLLVskQD25kLyWz+FpOmaJEdXWT0vbNWpURSbVQqV8QdDmpB
         TgyaZJT1vH9PfLbFVreQvksX6o91vMbQ39svurmx0ipEWaBwmv8x+r8DdvCy7nqHMCAk
         BKEQ+2//tnRipGWVUGOMsa4ljNDwlZgspZna5yTmx3aOTghCPZRIuNvTNnGxLk+gAjSa
         uHFeDg5nkiTt1tqU+E7VyfYwbPSYYPa4k1OKFogNMEpUD9MX1ne0GEOeJWCU1ZZKlHqC
         XZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EuIVbYOfQxc46N7AlV5nvC8pq53FlnNcRnKiJ6o61uE=;
        b=Ae0s0ntdTga0KEaS68KKNYnKD2dlF3XDrkOoSiEcUWS5t+iKz1O4kRLfGuPE0dWqbU
         2J25wgY9LreFGrjvh4aRT1va1M7vP4VyV8U7CoWzkpCyQTBkoBM/g2YemKP5S4rOOl6o
         mWbPvsnbF6TpGd9l45gwFp04zxh/VzBOaUWa+66M9JKiDX9SuTxMCvzVRwW6BmmYvR/H
         mMS9P/MtXxLhnm4iKzqtHjMGk67Itp2CaQM3lPPWu5Nw2V0hbUQAglMK+XwWOQ5F3JzC
         XnOfN978y0aQYCETmicHXO4joOfHAl9WB+tdR2EmMug6+8CZmoIBJ9WBu308NArWYjrq
         rvvw==
X-Gm-Message-State: AOAM533FSCmIxVGVsoCOz/C5ptvxtSg7sZLAScTwAnrIpFNL0da3yaY9
        zy4TomemB+IMSypG4SgrDe4JXcKoW40=
X-Google-Smtp-Source: ABdhPJycpWGdcvb2EroF7qMFHnXTQSH1ZgE9qXq3Yl1cI4YG9gYN9z7ot2pRsxoSH/kjXEcMSG/dbg==
X-Received: by 2002:adf:ee0c:: with SMTP id y12mr5343301wrn.394.1628170474964;
        Thu, 05 Aug 2021 06:34:34 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id x12sm6397950wrt.35.2021.08.05.06.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 06:34:34 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 2/2] libtraceevent: Keep the pointer to the field in args
Date:   Thu,  5 Aug 2021 16:34:19 +0300
Message-Id: <20210805133419.50802-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210805133419.50802-1-y.karadz@gmail.com>
References: <20210805133419.50802-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

In order to have tep_print_field() print the field closer to the way it
is printed via the "pretty_print" method, all field args, must keep a
pointer to the field it represents.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/event-parse.c | 60 +++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 26 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index fd6d916..331eb9f 100644
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

