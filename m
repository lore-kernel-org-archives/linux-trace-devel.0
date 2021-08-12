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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A869EC432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C5D96103E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbhHLJAN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 05:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbhHLJAM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 05:00:12 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9C0C0613D5
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 01:59:47 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id i10-20020a05600c354ab029025a0f317abfso6516964wmq.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 01:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qYZPyw4p6o7JrMMISIi2KHjbnWHm2hnnIklxRm3d0KM=;
        b=rMheq6/MR6iQn3JrrUJss9Fzyah56n1jl6FgYKfTxTwc0JtaPosN0FPtDrX0wxlNNQ
         X25SviDuLPrphNtPuf4tbKa8TiESbSctNePC8RFDsBnzhfTmMz3zfwTfQGpF701iKi0t
         DATAuiDgm3veVZJhheZl+H9BP9dUQUGx3COEZa2eOEeL2MTT35Mur0nSBXLFKxW2ICv2
         pV6+NYdNSCpJBldS/EOxHHhtZmUMyGeFEMCGO0PLyeZZ0keLzT3L+ESfRupzahf8++on
         8YpjtMA0tCnMwfoPamPu5am/aeRwtqCWw5EM2r8HNNKbQ1Jeoa8sBXRrUq347pQO6NZ5
         /cXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qYZPyw4p6o7JrMMISIi2KHjbnWHm2hnnIklxRm3d0KM=;
        b=IrrzAHNsl3z6Ucsgg/bRm2CAVeyjtVlhQ02jGMcevyp7EUfCR8LckVGfp3rYA5BOX7
         MMmFBDqRbZRjzet8wmTXOkP8VGXKYqPb4ZqwhjrDCE4OudpYP0pzd9SGwQ2uIrJzAoXP
         bFH7ZAUzqhxljRIE3skFhCzNeC1jWwyHa3n9qtxIEYqG7tJTrV5G0vksgz1E6+47VMq9
         fKCO4ms00+OeS73+U8crKRCaaPV4fg2XJQYAZSwJJyTZRXK2n5EJzTtxv8PpAPoZXvml
         9FLe5nmksGXQdUNdMmC5DCWwFvmsUomPYEGFYg20TmN5EuoQ2WaZHIpyNbSCy1nSohF9
         u6Uw==
X-Gm-Message-State: AOAM530Hbqe5oBptNkuUq9836TPGVj3ohocurVR4FsJFo6l30AoMm38/
        22jPSkaIgudf/zqJq96ZD5k=
X-Google-Smtp-Source: ABdhPJyl9tMMVXiJZgw47aGsIbmcS+64HvPKZZF5xfhGR52OZ9cedbXCDn25KJkgTLGSAJyBrylmwg==
X-Received: by 2002:a7b:cf21:: with SMTP id m1mr14054634wmg.35.1628758786293;
        Thu, 12 Aug 2021 01:59:46 -0700 (PDT)
Received: from crow.. ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id m10sm936683wro.63.2021.08.12.01.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 01:59:46 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 4/5] libtraceevent: Optimize tep_print_fields()
Date:   Thu, 12 Aug 2021 11:59:28 +0300
Message-Id: <20210812085929.54832-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812085929.54832-1-y.karadz@gmail.com>
References: <20210812085929.54832-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The current implementation of tep_print_fields() loops over all
individual fields of the event and calls tep_print_field() for
each one. In the same time inside tep_print_field() we loop over
the list of all tokens of the printing format descriptor in order
to determine how the current field must be printed (its own
appropriate printing format). The problem is that in this second
loop over the tokens we always start from the very first token
and this can be quite inefficient for example in a case of a
kprobe that has a large number of fields. This patch optimizes
tep_print_fields(), allowing the traverse of the list of tokens
to continue from the place reached when we searched for the
format of the previous field. For most of the tracing events
the order of fields matches the order of the corresponding format
tokens, however this is not strictly guaranteed. This problem is
addressed by making the loop over the tokens circular.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/event-parse.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index ff7337f..0795135 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5391,22 +5391,25 @@ static void tep_print_field_raw(struct trace_seq *s, void *data,
 static int print_parse_data(struct tep_print_parse *parse, struct trace_seq *s,
 			    void *data, int size, struct tep_event *event);
 
-void tep_print_field(struct trace_seq *s, void *data,
-		     struct tep_format_field *field)
+void static inline _tep_print_field(struct trace_seq *s, void *data,
+				    struct tep_format_field *field,
+				    struct tep_print_parse **parse_ptr)
 {
 	struct tep_event *event = field->event;
+	struct tep_print_parse *start_parse;
 	struct tep_print_parse *parse;
 	bool has_0x;
 
-	parse = event->print_fmt.print_cache;
+	parse = parse_ptr ? *parse_ptr : event->print_fmt.print_cache;
 
-	if (event->flags & TEP_EVENT_FL_FAILED)
+	if (!parse || event->flags & TEP_EVENT_FL_FAILED)
 		goto out;
 
 	if (field->flags & (TEP_FIELD_IS_ARRAY || TEP_FIELD_IS_STRING))
 		goto out;
 
-	for (;parse; parse = parse->next) {
+	start_parse = parse;
+	do {
 		if (parse->type == PRINT_FMT_STRING) {
 			int len = strlen(parse->format);
 
@@ -5416,37 +5419,52 @@ void tep_print_field(struct trace_seq *s, void *data,
 			else
 				has_0x = false;
 
-			continue;
+			goto next;
 		}
 
 		if (!parse->arg ||
 		    parse->arg->type != TEP_PRINT_FIELD ||
 		    parse->arg->field.field != field) {
 			has_0x = false;
-			continue;
+			goto next;
 		}
 
 		if (has_0x)
 			trace_seq_puts(s, "0x");
 
 		print_parse_data(parse, s, data, field->size, event);
+
+		if (parse_ptr)
+			*parse_ptr = parse->next;
+
 		return;
-	}
+
+ next:
+		parse = parse->next ? parse->next :
+				      event->print_fmt.print_cache;
+	} while (parse != start_parse);
 
  out:
 	/* Not found. */
 	tep_print_field_raw(s, data, field);
 }
 
+void tep_print_field(struct trace_seq *s, void *data,
+		     struct tep_format_field *field)
+{
+	_tep_print_field(s, data, field, NULL);
+}
+
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event *event)
 {
+	struct tep_print_parse *parse = event->print_fmt.print_cache;
 	struct tep_format_field *field;
 
 	field = event->format.fields;
 	while (field) {
 		trace_seq_printf(s, " %s=", field->name);
-		tep_print_field(s, data, field);
+		_tep_print_field(s, data, field, &parse);
 		field = field->next;
 	}
 }
-- 
2.30.2

