Return-Path: <SRS0=jb6J=WC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137C1C433FF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 06:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFF78216F4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 06:00:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O1RUMunK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731671AbfHFGAC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 02:00:02 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:42297 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFGAC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 02:00:02 -0400
Received: by mail-pl1-f170.google.com with SMTP id ay6so37444019plb.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Aug 2019 23:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xhx2/0fxiMu9tsontDpBSTjkk81/3TwfujZZsZK/I54=;
        b=O1RUMunKByd38dpAKwImbid+aPXTa5LgIjcapvi2Au4S5I913XD8x+XChuUXXGCfUn
         ztR6gwj5q0IjjfyyBDHPMzyOeFpM0Q6BR7OUp/F3WbRYlxSyNnfxrcW+X/aJF6qH6JVC
         CtSfFwwKaTASVVl2HPc10mmG5AHV5bNh/Zb5/rUU/JUxhrkQFtqLOtN0fiU6R3gl7uI/
         Kc9sN4elRYXKQa1g+9sHtUgZLiLSHxHwpXK2jF6g4tLV+VMvBPVB9WR3p4XhW3ts5x7f
         nD9Ii/XH90Hf4f6EqmVAK3ukftBzoxvv5K6CC5+2OK1PbuZ0/D7uy/g66OprfZ/sNnj/
         V3Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xhx2/0fxiMu9tsontDpBSTjkk81/3TwfujZZsZK/I54=;
        b=nHeBve6/TK+DscqrfDPvQnqFY1HWHbFcXcBSvuJUNdH0KmRtRiNdRJf+trqHZ7vdSw
         rAKzoTrnDPd8XOGIq60Z1H8ll1TMcYQPthIW029kqKvFWXXKUFRRFxmPWh1Lmz51C07+
         AMwNnNioVH6WcdgxQ3NSjqNCDy8n2MwFcEzjwZrCekPvaypv0BCaP90yIPHp3bqYMiav
         sJspXYs6gPakynt2wldxZkFTjY2Bz+yzzvylmdoJg2BrsOnXKUHFxLz+LcD6GWcSRImE
         Tf0+hoVnL48kCsTdZf6J1Zyc3VbnMbKemnFGdMCJ1MJGHeUHSawh+AXeAZNRWWWSyiEO
         ufRg==
X-Gm-Message-State: APjAAAVCVPssmmUG4c2aihzosbyvswFcYzLiAqbeOpGf4IEwNQI1L2Kv
        lkY96Jvv4C7PbC2nw86GMU8=
X-Google-Smtp-Source: APXvYqwQHkWH9WeZOKMYbW2WQi6RUACqHHWyZriqta5M1few3UqAGDo33+RX9PcqNlxrTZQ6nguItg==
X-Received: by 2002:a17:902:1a7:: with SMTP id b36mr1436852plb.115.1565071201488;
        Mon, 05 Aug 2019 23:00:01 -0700 (PDT)
Received: from localhost.localdomain ([175.223.3.169])
        by smtp.gmail.com with ESMTPSA id ev3sm19934057pjb.3.2019.08.05.22.59.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 23:00:00 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH 1/2] parse-event: rename filter_arg_boolean arg
Date:   Tue,  6 Aug 2019 14:59:49 +0900
Message-Id: <20190806055950.23842-2-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806055950.23842-1-sergey.senozhatsky@gmail.com>
References: <20190806055950.23842-1-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Rename 'bool' filter_arg_boolean arg to boolean

        swig -Wall -python -noproxy ctracecmd.i
        parse-events.h:676: Error: Syntax error in input(3).

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 parse-events.h |  2 +-
 parse-filter.c | 32 ++++++++++++++++----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/parse-events.h b/parse-events.h
index 3a4ef08..01be4f0 100644
--- a/parse-events.h
+++ b/parse-events.h
@@ -673,7 +673,7 @@ struct filter_arg_str {
 struct filter_arg {
 	enum filter_arg_type	type;
 	union {
-		struct filter_arg_boolean	bool;
+		struct filter_arg_boolean	boolean;
 		struct filter_arg_field		field;
 		struct filter_arg_value		value;
 		struct filter_arg_op		op;
diff --git a/parse-filter.c b/parse-filter.c
index 0d448cb..13f3422 100644
--- a/parse-filter.c
+++ b/parse-filter.c
@@ -359,7 +359,7 @@ create_arg_item(struct event_format *event,
 			if (strcmp(token, COMM) != 0) {
 				/* not a field, Make it false */
 				arg->type = FILTER_ARG_BOOLEAN;
-				arg->bool.value = FILTER_FALSE;
+				arg->boolean.value = FILTER_FALSE;
 				break;
 			}
 			/* If token is 'COMM' then it is special */
@@ -487,7 +487,7 @@ static int add_right(struct filter_arg *op, struct filter_arg *arg,
 				free_arg(left);
 				free_arg(arg);
 				op->type = FILTER_ARG_BOOLEAN;
-				op->bool.value = FILTER_FALSE;
+				op->boolean.value = FILTER_FALSE;
 				break;
 			}
 
@@ -772,7 +772,7 @@ enum filter_vals test_arg(struct filter_arg *parent, struct filter_arg *arg)
 
 		/* bad case */
 	case FILTER_ARG_BOOLEAN:
-		return FILTER_VAL_FALSE + arg->bool.value;
+		return FILTER_VAL_FALSE + arg->boolean.value;
 
 		/* good cases: */
 	case FILTER_ARG_STR:
@@ -871,7 +871,7 @@ static struct filter_arg *collapse_tree(struct filter_arg *arg)
 		free_arg(arg);
 		arg = allocate_arg();
 		arg->type = FILTER_ARG_BOOLEAN;
-		arg->bool.value = ret == FILTER_VAL_TRUE;
+		arg->boolean.value = ret == FILTER_VAL_TRUE;
 	}
 
 	return arg;
@@ -1116,7 +1116,7 @@ process_event(struct event_format *event, const char *filter_str,
 	if (!*parg) {
 		*parg = allocate_arg();
 		(*parg)->type = FILTER_ARG_BOOLEAN;
-		(*parg)->bool.value = FILTER_FALSE;
+		(*parg)->boolean.value = FILTER_FALSE;
 	}
 
 	return 0;
@@ -1139,7 +1139,7 @@ static int filter_event(struct event_filter *filter,
 		/* just add a TRUE arg */
 		arg = allocate_arg();
 		arg->type = FILTER_ARG_BOOLEAN;
-		arg->bool.value = FILTER_TRUE;
+		arg->boolean.value = FILTER_TRUE;
 	}
 
 	filter_type = add_filter_type(filter, event->id);
@@ -1369,9 +1369,9 @@ static int copy_filter_type(struct event_filter *filter,
 		arg = allocate_arg();
 		arg->type = FILTER_ARG_BOOLEAN;
 		if (strcmp(str, "TRUE") == 0)
-			arg->bool.value = 1;
+			arg->boolean.value = 1;
 		else
-			arg->bool.value = 0;
+			arg->boolean.value = 0;
 
 		filter_type = add_filter_type(filter, event->id);
 		filter_type->filter = arg;
@@ -1442,8 +1442,8 @@ int pevent_update_trivial(struct event_filter *dest, struct event_filter *source
 		arg = filter_type->filter;
 		if (arg->type != FILTER_ARG_BOOLEAN)
 			continue;
-		if ((arg->bool.value && type == FILTER_TRIVIAL_FALSE) ||
-		    (!arg->bool.value && type == FILTER_TRIVIAL_TRUE))
+		if ((arg->boolean.value && type == FILTER_TRIVIAL_FALSE) ||
+		    (!arg->boolean.value && type == FILTER_TRIVIAL_TRUE))
 			continue;
 
 		event = filter_type->event;
@@ -1497,10 +1497,10 @@ void pevent_filter_clear_trivial(struct event_filter *filter,
 			continue;
 		switch (type) {
 		case FILTER_TRIVIAL_FALSE:
-			if (filter_type->filter->bool.value)
+			if (filter_type->filter->boolean.value)
 				continue;
 		case FILTER_TRIVIAL_TRUE:
-			if (!filter_type->filter->bool.value)
+			if (!filter_type->filter->boolean.value)
 				continue;
 		default:
 			break;
@@ -1551,10 +1551,10 @@ int pevent_filter_event_has_trivial(struct event_filter *filter,
 
 	switch (type) {
 	case FILTER_TRIVIAL_FALSE:
-		return !filter_type->filter->bool.value;
+		return !filter_type->filter->boolean.value;
 
 	case FILTER_TRIVIAL_TRUE:
-		return filter_type->filter->bool.value;
+		return filter_type->filter->boolean.value;
 	default:
 		return 1;
 	}
@@ -1783,7 +1783,7 @@ static int test_filter(struct event_format *event,
 	switch (arg->type) {
 	case FILTER_ARG_BOOLEAN:
 		/* easy case */
-		return arg->bool.value;
+		return arg->boolean.value;
 
 	case FILTER_ARG_OP:
 		return test_op(event, arg, record);
@@ -2147,7 +2147,7 @@ static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
 	switch (arg->type) {
 	case FILTER_ARG_BOOLEAN:
 		str = malloc_or_die(6);
-		if (arg->bool.value)
+		if (arg->boolean.value)
 			strcpy(str, "TRUE");
 		else
 			strcpy(str, "FALSE");
-- 
2.22.0

