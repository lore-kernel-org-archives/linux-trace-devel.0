Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90CBBC4320A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 09:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7959E6137B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 09:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhHWJ5Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 05:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235808AbhHWJ5P (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 05:57:15 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3482C061757
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 02:56:32 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id d11so35691221eja.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 02:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eDFIT2pmq3gGUvLlGfimEKq5mRLiux/wJen4AyI8UUg=;
        b=dmvxSEPCMvSiwIU8dyeIeRR1FtzHnDxjt40zijMg5a3nQ1EHqWVo5woJ4hdaU1lilQ
         M3LDEW/YRJnqTmrkGNnS8mICUN1iQnJ1LxpUNy5/H+O/7si4gU1p0ylNVhdKMzlZWlKa
         1mL4MlTQ79dQ2i1ReJFW7NK2Ym++WXr+uoDGX2tkedKrfe6w+l+RNFg0b4qfB8+UZg5Q
         ZaDIS5ClzW6QAEDiOrKR7bXKCCjODbF05oiE4uxjpJWdERxxSwlg35xkZesPc9xXgKAX
         y3auCiEj0gAzApIe5EWR0TbBMBVn85znC0Fzx56o2gK7/EMVyfdskSV0Y2xD8i5Df9Ch
         unBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eDFIT2pmq3gGUvLlGfimEKq5mRLiux/wJen4AyI8UUg=;
        b=YLPYpS0aSwjVAlX04YzNmhtrlR0Rgr9BXj+nASxRGPai8yRJ0QGMX2ZZmpeUlXP1R1
         /rKfruEsROeUNdqbujLG4jyqTSeGlDGwDmAHMXSImkQOChH1Jc0VZsk+Fv8a1eJP9Dlj
         NsSdZCkqfqgRAba+YaB8Gfw6LndgYwaT67lJVUDUnLnfWOgL18qbO9wIFLUP2t+V4HjW
         IuZoOiuXBoaCa6QubFAT/aKEm31U2MekU4oarca4G8nHTE0z5lAPWbHIFBJtUCms9v2x
         +NHwyGff9Xsi5YPL16bwVwPcI+AJdwRzzR8UxnRzQ0Oo3q80GhciLJOT9GAVX8h2wbDa
         0ItA==
X-Gm-Message-State: AOAM532k3KazkoQcQR91r5JgPy+ivSQEZpvSRUg0kd/nTcrZkGP2Hq2U
        fSoU6DTOiFFWMAJqqgaP+vI=
X-Google-Smtp-Source: ABdhPJyZ+HhjrNMusPcdP7hlFX4cnZ5ZqaDpbW38NZZHhwm6ssVcXDohZu0+2YdWR6Ko0ke6XOrBfA==
X-Received: by 2002:a17:907:d09:: with SMTP id gn9mr35259689ejc.447.1629712591362;
        Mon, 23 Aug 2021 02:56:31 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id y23sm7047831ejp.115.2021.08.23.02.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 02:56:30 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 1/4] libtraceevent: Improve tep_print_field()
Date:   Mon, 23 Aug 2021 12:56:15 +0300
Message-Id: <20210823095618.138887-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823095618.138887-1-y.karadz@gmail.com>
References: <20210823095618.138887-1-y.karadz@gmail.com>
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
index 02ec677..6129a0c 100644
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
+static void print_field_raw(struct trace_seq *s, void *data,
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
+	print_field_raw(s, data, field);
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

