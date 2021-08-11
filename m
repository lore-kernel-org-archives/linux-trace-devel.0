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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D71C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 12:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D7F560041
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 12:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237482AbhHKMMn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 08:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237466AbhHKMMl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 08:12:41 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7D4C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Aug 2021 05:12:18 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id m36-20020a05600c3b24b02902e67543e17aso3681721wms.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Aug 2021 05:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a1rctMg0OfsquAGyMiM/bNxFekwE/wso2d1Z7nrnst0=;
        b=b/L9ZWuWiHYeG7EjvjqMrTG6lcCm3/FcouT872oYlr8H5p4qN23B370SpOogOPxECw
         RzvLWUkZXJufgVkvT6Rm+vkLvTiD+tW9wA5HPIvR61VOuY3aQ6rUMA3F0IboGFc2F2FR
         sdykcKthVqoNEflMYoqfBkVON9PRqAEHdJ00thZhusQDVFKmcHqZkPSDnH8qOVf5nlNf
         lNjIkReOxY/UtHVXlw+K/cDSPXWSOQazPTkOhsl2TnOkatpu7i6xdmAE5/Jf5cHpzgMB
         lAH5TuunRhNRrXmWOGcS+uV6Dhwq+vhM0JBDhV6fJZeNLhz/o+wu68buUVMefwEVMmed
         n59g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a1rctMg0OfsquAGyMiM/bNxFekwE/wso2d1Z7nrnst0=;
        b=f3bg1xS5IwkF/nr4LxzhWI1X/0KMbIvVo+sznpMaR7fECq4mgL6ml/CPZCYP1vNit/
         KvSSR3SK4LO0qv672A3Pohfw7uGisAYh05vx+Wfo5LrLvVDYtNY6IIDTuj538dzyBjXI
         t8o2xJTb9qOoaJ0g7u93mVvK62cgyKCrbINu8xG/TwcgqpQ/xgHdfJbIkFOdyMpLtn/3
         9Vq8y980vHOK3rOwNABu2MmUtTHRJt3+YLxwZZla8msUvhlwAKP8Xlv/+R35F0VWcA3v
         RRWq7uqWav92hX4oD/pZ1rRt0de9cpptc8n+rhQsVAFfxBtmDM1LYvdHCVAwnAvBMdxG
         DixQ==
X-Gm-Message-State: AOAM532ZbDoNlI6cPSVwF2eEyMIilqRkOqCCfJR/IRs31QyfNex64xma
        rF56SeABvg9Q56azgea5lJ0=
X-Google-Smtp-Source: ABdhPJx0UtE9Dcq/EK+d8TYaglKKf+kjP/esoeUjd+IA0fWaFJLkYxhVe1//ip9CVFNcSy35wxHTEQ==
X-Received: by 2002:a7b:cc14:: with SMTP id f20mr9546746wmh.38.1628683936941;
        Wed, 11 Aug 2021 05:12:16 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id k1sm27104011wrz.61.2021.08.11.05.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 05:12:16 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 3/5] libtraceevent: Improve tep_print_field()
Date:   Wed, 11 Aug 2021 15:12:01 +0300
Message-Id: <20210811121203.29123-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210811121203.29123-1-y.karadz@gmail.com>
References: <20210811121203.29123-1-y.karadz@gmail.com>
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
index 1a8cc54..9399555 100644
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
@@ -5390,6 +5389,56 @@ void tep_print_field(struct trace_seq *s, void *data,
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
@@ -5909,35 +5958,45 @@ parse_args(struct tep_event *event, const char *format, struct tep_print_arg *ar
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

