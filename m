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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8700C4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 12:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DF8460EFF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 12:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbhHJM1g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 08:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238426AbhHJM1g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 08:27:36 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF66C0613D3
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Aug 2021 05:27:14 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x14so7418201edr.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Aug 2021 05:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=neJ0xz0p2IS59Gud5ojL4LMOc7U15Rrk/m7vcJ8w8oM=;
        b=lucSAFHIdqptXSafhAASMkwdgIcHz0rjWJZm7zpejQj6hVyXFGPZVYt26jj8HeNSUO
         uLmX/sNdUj599gc1wKrLQvdVDzWk4ytcgkNTH2kxaQxIDsGiub2eBKnSI/YDxepZ/TJa
         3PTXr2BsctOpPpMDZoUGdK8X4MKJQ/f3o8PVq+VCSzZdhaz7MuTHkm1Sb8sb5FlL4m3g
         0wUP8ch6GxsGYJxCFvntmHm3IK8LTTuLX1eZa8UgZ17fxsnWJe75XEdKwe7FtRV0H+FW
         Ak+x2EpStDDEqdWkMAjfq95YOTnapJ5KwoR0e5mnzeZIBPUYpEqUsffhNh6/S4zsIU5a
         AC6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=neJ0xz0p2IS59Gud5ojL4LMOc7U15Rrk/m7vcJ8w8oM=;
        b=ctHne5WoSt+TQsmkIYYUbELpydGJC4Wi1dj9PKu1wwMlfimZuM1w+WQ7FEj9DtSNi5
         qJ7SjkKqg5fgkHKNlzky8AU9fSq6fq7LZn4BKPH8u12dS0YFMv58q/POvhZDaqkErbZQ
         1C5qo70VIKuyhsgvBVp85Jc92dPKQHaegwQ8ezlPaiueJU4+WGDoB2/o4+x8ujzw73Cp
         HOh8llJ9dYCgcw5KXzf7NJ4jNtB7CF+P3y4+aSZY2Q+jDKHGP7Z1iB6OiqZTtFHdLPJz
         9q4HlAcwDTKD7CdzUb1EILyA6PrwNimGWeaxIix/1aZDyGtVvE9CZRSzWFB7qiCOh/Bn
         AHPg==
X-Gm-Message-State: AOAM53274Ara3GqxbcvJ6nnQdZy0gJZon42rC5EgoK403r4hd3IsIgxZ
        mTJB78lmfdof7VVVh5GcpAs=
X-Google-Smtp-Source: ABdhPJyxKty9SUmnoUYaoVQmshMPdwiAckHql4GvK4kI6wJMBQruc+0xRRZyt+EpVOLRtT3j24DT4Q==
X-Received: by 2002:a05:6402:2749:: with SMTP id z9mr4568909edd.58.1628598433133;
        Tue, 10 Aug 2021 05:27:13 -0700 (PDT)
Received: from crow.. ([95.87.199.76])
        by smtp.gmail.com with ESMTPSA id ks20sm1074501ejb.101.2021.08.10.05.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 05:27:12 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 3/5] libtraceevent: Improve tep_print_field()
Date:   Tue, 10 Aug 2021 15:26:57 +0300
Message-Id: <20210810122659.145759-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810122659.145759-1-y.karadz@gmail.com>
References: <20210810122659.145759-1-y.karadz@gmail.com>
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
 src/event-parse.c | 118 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 90 insertions(+), 28 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 1a8cc54..4b5e98b 100644
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
@@ -5390,6 +5389,59 @@ void tep_print_field(struct trace_seq *s, void *data,
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
+		print_parse_data(parse, s,
+				 data + field->offset,
+				 field->size,
+				 event);
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
@@ -5909,35 +5961,45 @@ parse_args(struct tep_event *event, const char *format, struct tep_print_arg *ar
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

