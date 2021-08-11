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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DFAC43214
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 12:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB51A60041
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 12:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237487AbhHKMMn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 08:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237498AbhHKMMm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 08:12:42 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495F2C0613D3
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Aug 2021 05:12:19 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id c9so2713577wri.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Aug 2021 05:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aN7mzu/MTj3+cF47VT4Edvs9x7wxfAW5P2w2A2tkPdo=;
        b=mnfeFOuSxRzjRgzOHFUOgteJx/P41Q38jDLhNRZ4xWhCdn4V37cjj/PekU5yl3mOn1
         bPQGqT5VCB2vBdELEXQgUUkBiuKmzYeJ5M8uq5x7t5hZZtWsHoFh969GTXNHZ63C/mYt
         sNOSgGVcOF7EWVHqbl6n2HsZn3Y/Y4/z4nXF1JKUmTdehHAillO7rjQImK29YLXpx10A
         6cFgFXH5pKM2gwZL8U6UJ3kZGKpx0jPDVWols/cXx7sD00nsrUbZhxB2lAoLflBIdmUq
         jQg+QLhdSOfp5K6oG7aYp5MEbD/Lsr6GSl566yAeF3UX4zZyyuWvy8R1U4OVSJn//ZjF
         JZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aN7mzu/MTj3+cF47VT4Edvs9x7wxfAW5P2w2A2tkPdo=;
        b=T6X4eipzYepZAd0GfgwdNFIvGs5TSFZGlvqU3B4CanHfjG5SW8MjzISuZ9Kxhnqg+j
         qOdftWFbHuU62YWjkkOhFX7OOw3vIhqegwmuCo2oTAjbOT/Zd3W4gNHcN0fUoN9gEV5x
         IPR4aUThNzW5gU+WsjNdDi0PrAVLh8fuMpCH70AOhyzHIKR+hHYFrqdg25QXOiyHonkj
         HjvXERBj/8njCU3Ha7AwmIJPS41AcQqeEu3VGhS2xRmSBsmaiMoGkf2x9v+YSe/uubmL
         KiktheVqI07M6qViuZP+5I4XMCEi9yQNb+VzweOLWE05X1Ne6PAexxRvFvyjgiRCsbaO
         Eepg==
X-Gm-Message-State: AOAM533RJRqKqKhGN7EaHEHReokkjD6/aTVr4Bggs3JzrhiNyNkN+Dfn
        p+ZYYApNx2I5G1GIUdDLjEI=
X-Google-Smtp-Source: ABdhPJxxtEIA1v4ZzMz/Kvubk/UBZj/OTl7iR/NcjnXUQgap50j431IIC3NT946V0Lm/esnJ2hOhBg==
X-Received: by 2002:a05:6000:251:: with SMTP id m17mr3662615wrz.68.1628683937938;
        Wed, 11 Aug 2021 05:12:17 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id k1sm27104011wrz.61.2021.08.11.05.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 05:12:17 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 4/5] libtraceevent: Optimize tep_print_fields()
Date:   Wed, 11 Aug 2021 15:12:02 +0300
Message-Id: <20210811121203.29123-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210811121203.29123-1-y.karadz@gmail.com>
References: <20210811121203.29123-1-y.karadz@gmail.com>
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
format of the previous field.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/event-parse.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 9399555..7831e74 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5392,14 +5392,15 @@ static void tep_print_field_raw(struct trace_seq *s, void *data,
 static int print_parse_data(struct tep_print_parse *parse, struct trace_seq *s,
 			    void *data, int size, struct tep_event *event);
 
-void tep_print_field(struct trace_seq *s, void *data,
-		     struct tep_format_field *field)
+void static inline _tep_print_field(struct trace_seq *s, void *data,
+				    struct tep_format_field *field,
+				    struct tep_print_parse **parse_ptr)
 {
 	struct tep_event *event = field->event;
 	struct tep_print_parse *parse;
 	bool has_0x;
 
-	parse = event->print_fmt.print_cache;
+	parse = parse_ptr ? *parse_ptr : event->print_fmt.print_cache;
 
 	if (event->flags & TEP_EVENT_FL_FAILED)
 		goto out;
@@ -5407,7 +5408,7 @@ void tep_print_field(struct trace_seq *s, void *data,
 	if (field->flags & (TEP_FIELD_IS_ARRAY || TEP_FIELD_IS_STRING))
 		goto out;
 
-	for (;parse; parse = parse->next) {
+	while (parse) {
 		if (parse->type == PRINT_FMT_STRING) {
 			int len = strlen(parse->format);
 
@@ -5417,21 +5418,29 @@ void tep_print_field(struct trace_seq *s, void *data,
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
+
+ next:
+		parse = parse->next ? parse->next :
+				      event->print_fmt.print_cache;
 	}
 
  out:
@@ -5439,15 +5448,22 @@ void tep_print_field(struct trace_seq *s, void *data,
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

