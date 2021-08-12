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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58083C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FD596109F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbhHLJAM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 05:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235565AbhHLJAM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 05:00:12 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4BEC061765
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 01:59:46 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id x12so7181255wrr.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 01:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SIBLTYvJPHen1mAC44ubeKZgPZiJLiQt3s/cP7c8bhw=;
        b=GEMRSa9HF7GR0LwiwSR20McFGiRpjtFMPF0aAqdagFRAIwKYewNtm4EUFIqIPz3DtU
         vbWIxN2nigmzbuptFo6f6ghz3mA+ZHQR6P6lBzDPpCpswdNVf/BuZyGj3Q164V/lJ4Bs
         7TQLr+BzuoAw1TZIBxTtwm//nZX3b2XiK7A9hd9I43N2+MFp2OSS7C0MBtvMYVjhbm2g
         3uARdeJmJdH5uzvHppSDmZZrjvMRuTUxA9UvZ3sTOPbLFPQghppdGl1tpcO6cFaBASoV
         PT10jNaBFXxMUxmkGJ2d28fuzI2ynabf+P12AfFEO1qQ2yasxRjAVeP1TKCR18UHJBBt
         hY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SIBLTYvJPHen1mAC44ubeKZgPZiJLiQt3s/cP7c8bhw=;
        b=Mdes9levqFn9F7wNDfBh/CLwEyWhZLY1ABlX7xwh+QoqFg5uPYEviuhjn8QKosfDvo
         ofbIJB6rqArkIEiOI9lmTl/tgK+dquv5D/MGr76VRWghDE2OhmdVxfwiE2bnvgw6rbDa
         N+UjhoeS6Z1R/qXMnAjp8tIAxlUzBppY0xHmhRr921dxOAhRiaI8n7dqUfRLbWCzbhvd
         DDM/MxTecg9zyQjcB92bCL616QR9aanrXtb/jj9HGrpJwa3gHfn9/9oq+wg0KgTOrX+d
         ZLRV2TeioOUwuRNoTPYQUJA9tJghIm9P8x2yyZVSFOONeoYCFVPo0ie9+5QvopivC8SA
         FU/A==
X-Gm-Message-State: AOAM530ALoXeaHLZclhQ4rjmB8kZh0FiC5l62/T5n+fsglN9TBtZryDt
        hz3ij9nAzi21WW9W3jdkikS7BftA+oI=
X-Google-Smtp-Source: ABdhPJzcfqO47u5WpF7fNNBviCEVlCr3yDbIATLSYHw38cZph4xfQBvPzrWwfHB5TBM7yXNlryzxtA==
X-Received: by 2002:a5d:4885:: with SMTP id g5mr2843079wrq.29.1628758785626;
        Thu, 12 Aug 2021 01:59:45 -0700 (PDT)
Received: from crow.. ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id m10sm936683wro.63.2021.08.12.01.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 01:59:45 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 3/5] libtraceevent: Improve tep_print_field()
Date:   Thu, 12 Aug 2021 11:59:27 +0300
Message-Id: <20210812085929.54832-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812085929.54832-1-y.karadz@gmail.com>
References: <20210812085929.54832-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The existing method tep_print_fields() gets upgraded to use the
printing formats provided by the tokens.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/event-parse.c | 115 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 87 insertions(+), 28 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 02ec677..ff7337f 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3913,7 +3913,6 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 			arg->field.field = tep_find_any_field(event, arg->field.name);
 			if (!arg->field.field)
 				goto out_warning_field;
-			
 		}
 		/* must be a number */
 		val = tep_read_number(tep, data + arg->field.field->offset,
@@ -5326,8 +5325,8 @@ static int is_printable_array(char *p, unsigned int len)
 	return 1;
 }
 
-void tep_print_field(struct trace_seq *s, void *data,
-		     struct tep_format_field *field)
+static void tep_print_field_raw(struct trace_seq *s, void *data,
+			     struct tep_format_field *field)
 {
 	struct tep_handle *tep = field->event->tep;
 	unsigned int offset, len, i;
@@ -5389,6 +5388,56 @@ void tep_print_field(struct trace_seq *s, void *data,
 	}
 }
 
+static int print_parse_data(struct tep_print_parse *parse, struct trace_seq *s,
+			    void *data, int size, struct tep_event *event);
+
+void tep_print_field(struct trace_seq *s, void *data,
+		     struct tep_format_field *field)
+{
+	struct tep_event *event = field->event;
+	struct tep_print_parse *parse;
+	bool has_0x;
+
+	parse = event->print_fmt.print_cache;
+
+	if (event->flags & TEP_EVENT_FL_FAILED)
+		goto out;
+
+	if (field->flags & (TEP_FIELD_IS_ARRAY || TEP_FIELD_IS_STRING))
+		goto out;
+
+	for (;parse; parse = parse->next) {
+		if (parse->type == PRINT_FMT_STRING) {
+			int len = strlen(parse->format);
+
+			if (len > 1 &&
+			    strcmp(parse->format + (len -2), "0x") == 0)
+				has_0x = true;
+			else
+				has_0x = false;
+
+			continue;
+		}
+
+		if (!parse->arg ||
+		    parse->arg->type != TEP_PRINT_FIELD ||
+		    parse->arg->field.field != field) {
+			has_0x = false;
+			continue;
+		}
+
+		if (has_0x)
+			trace_seq_puts(s, "0x");
+
+		print_parse_data(parse, s, data, field->size, event);
+		return;
+	}
+
+ out:
+	/* Not found. */
+	tep_print_field_raw(s, data, field);
+}
+
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event *event)
 {
@@ -5908,35 +5957,45 @@ parse_args(struct tep_event *event, const char *format, struct tep_print_arg *ar
 	return parse_ret;
 }
 
-static void print_event_cache(struct tep_print_parse *parse, struct trace_seq *s,
-			      void *data, int size, struct tep_event *event)
+static int print_parse_data(struct tep_print_parse *parse, struct trace_seq *s,
+			    void *data, int size, struct tep_event *event)
 {
 	int len_arg;
 
+	if (parse->len_as_arg)
+		len_arg = eval_num_arg(data, size, event, parse->len_as_arg);
+
+	switch (parse->type) {
+	case PRINT_FMT_ARG_DIGIT:
+		print_arg_number(s, parse->format,
+				 parse->len_as_arg ? len_arg : -1, data,
+				 size, parse->ls, event, parse->arg);
+		break;
+	case PRINT_FMT_ARG_POINTER:
+		print_arg_pointer(s, parse->format,
+				  parse->len_as_arg ? len_arg : 1,
+				  data, size, event, parse->arg);
+		break;
+	case PRINT_FMT_ARG_STRING:
+		print_arg_string(s, parse->format,
+				 parse->len_as_arg ? len_arg : -1,
+				 data, size, event, parse->arg);
+		break;
+	case PRINT_FMT_STRING:
+	default:
+		trace_seq_printf(s, "%s", parse->format);
+		/* Return 1 on non field. */
+		return 1;
+	}
+	/* Return 0 on field being processed. */
+	return 0;
+}
+
+static void print_event_cache(struct tep_print_parse *parse, struct trace_seq *s,
+			      void *data, int size, struct tep_event *event)
+{
 	while (parse) {
-		if (parse->len_as_arg)
-			len_arg = eval_num_arg(data, size, event, parse->len_as_arg);
-		switch (parse->type) {
-		case PRINT_FMT_ARG_DIGIT:
-			print_arg_number(s, parse->format,
-					parse->len_as_arg ? len_arg : -1, data,
-					 size, parse->ls, event, parse->arg);
-			break;
-		case PRINT_FMT_ARG_POINTER:
-			print_arg_pointer(s, parse->format,
-					  parse->len_as_arg ? len_arg : 1,
-					  data, size, event, parse->arg);
-			break;
-		case PRINT_FMT_ARG_STRING:
-			print_arg_string(s, parse->format,
-					 parse->len_as_arg ? len_arg : -1,
-					 data, size, event, parse->arg);
-			break;
-		case PRINT_FMT_STRING:
-		default:
-			trace_seq_printf(s, "%s", parse->format);
-			break;
-		}
+		print_parse_data(parse, s, data, size, event);
 		parse = parse->next;
 	}
 }
-- 
2.30.2

