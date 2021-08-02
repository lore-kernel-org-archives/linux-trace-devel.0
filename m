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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D52ECC432BE
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Aug 2021 11:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC4DD60F36
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Aug 2021 11:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhHBL1m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 07:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbhHBL1j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 07:27:39 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0527EC06175F
        for <linux-trace-devel@vger.kernel.org>; Mon,  2 Aug 2021 04:27:29 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l11-20020a7bcf0b0000b0290253545c2997so10783697wmg.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Aug 2021 04:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zdc3J8aV9M6R2/TLVs0oSC0JDrFlkTJ1jgg4jwxKl3U=;
        b=H2q3H26+6OjSg9aFxAvG0vVqe+czSZCaolO+HND+81V1YDFOHE4FWK2glB8LFpddSe
         vzwwF7d9fgAOmN+7aSfmCFS4AUn7YG60HnWMYJFpapL1af5SNO/gfMvvsFm5B9v3toes
         DJkhpRHZRtJGwGocbvGh7uTbLalobzK1DdijG9SRp2NYNDy50VF5uRqRY3na1ssTK0Ie
         Sq6FKoWZxr7VjOgPORVpkeHTJHz+uFOuH2XH67UWf6h9elYuoLSGvNtOhEKXj9idRjxT
         prQXAIzOy9vxh9veoGTDrVj2G4Ljv+3r+gWrybqSxJ66ousai11mQRFpKUblooCjBAH5
         ROaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zdc3J8aV9M6R2/TLVs0oSC0JDrFlkTJ1jgg4jwxKl3U=;
        b=mxM1hYzJdhsAmg2H6EGEVZUjlSw4H2rZSS6WA4vExxOXTetTPziYeoTBgYX3HdTuE2
         IF8nhcoUKwLo5j6mNIV6YfjgO1EKF5M78OwUef2ZmcDC3azBR9d+LFmae9oue6aOaj43
         E4mFU9UklcDwWFZDDy1HU4hHaldv9YWeyABBzumj0dxEBgyipW+rJ3WlTb6eP46ZjIKa
         R370QDiMnKX4e9GPdCLYeSbsCXtg7Wu18o3NPIhzonckPtdc3izaWSC8fKw5IBjEhh9K
         B9qdXi6aLUJ3lpdX1Tru1tyOi8nnunHx5e+/LO2/U5rTIL3wNkb37S6itMiF83I8UQt+
         dcZg==
X-Gm-Message-State: AOAM533/wUKaVjdmh0jdWisGkraPA7PepCipZJQFbblNZAUhnaG0Bmb+
        J616W6vZ14d3Um3REUgddNE=
X-Google-Smtp-Source: ABdhPJyLQr5mt3WKJiC7ZnRK9UnnAaIKBuB6qGiYUG4FiS1YSV3CaZS/ifGI7MutTP7W4TPgIL9r+A==
X-Received: by 2002:a1c:20ce:: with SMTP id g197mr16777438wmg.46.1627903647579;
        Mon, 02 Aug 2021 04:27:27 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id u23sm5696848wmc.24.2021.08.02.04.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 04:27:27 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH] libtraceevent: Add tep_print_selected_fields()
Date:   Mon,  2 Aug 2021 14:27:14 +0300
Message-Id: <20210802112714.67631-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new method can print only a subset of the unique data fields of
the trace event. The print format is derived from the parsing tokens
(tep_print_parse objects) of the event. As a byproduct of this change
the existing method tep_print_fields() gets upgraded to use the
formats provided by the tokens.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/event-parse.c | 87 ++++++++++++++++++++++++++++++++++++++++++-----
 src/event-parse.h |  3 ++
 2 files changed, 81 insertions(+), 9 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index f42ae38..7302f3d 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3585,6 +3585,8 @@ tep_find_field(struct tep_event *event, const char *name)
 	return format;
 }
 
+
+
 /**
  * tep_find_any_field - find any field by name
  * @event: handle for the event
@@ -5333,6 +5335,19 @@ static int is_printable_array(char *p, unsigned int len)
 	return 1;
 }
 
+static void dynamic_offset(struct tep_handle *tep,
+			   struct tep_format_field *field,
+			   void *data,
+			   unsigned int *offset,
+			   unsigned int *len)
+{
+	unsigned long long val;
+
+	val = tep_read_number(tep, data + field->offset, field->size);
+	*offset = val & SHRT_MAX;
+	*len = val >> 16;
+}
+
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field)
 {
@@ -5343,12 +5358,9 @@ void tep_print_field(struct trace_seq *s, void *data,
 	if (field->flags & TEP_FIELD_IS_ARRAY) {
 		offset = field->offset;
 		len = field->size;
-		if (field->flags & TEP_FIELD_IS_DYNAMIC) {
-			val = tep_read_number(tep, data + offset, len);
-			offset = val;
-			len = offset >> 16;
-			offset &= 0xffff;
-		}
+		if (field->flags & TEP_FIELD_IS_DYNAMIC)
+			dynamic_offset(tep, field, data, &offset, &len);
+
 		if (field->flags & TEP_FIELD_IS_STRING &&
 		    is_printable_array(data + offset, len)) {
 			trace_seq_printf(s, "%s", (char *)data + offset);
@@ -5398,19 +5410,76 @@ void tep_print_field(struct trace_seq *s, void *data,
 	}
 }
 
-void tep_print_fields(struct trace_seq *s, void *data,
-		      int size __maybe_unused, struct tep_event *event)
+static struct tep_print_parse *parse_format_next(struct tep_print_parse *parse)
+{
+	while (parse) {
+		if (strncmp(parse->format, "%", 1) == 0)
+			break;
+
+		parse = parse->next;
+	}
+
+	return parse;
+}
+
+static void tep_print_fmt_field(struct trace_seq *s, void *data,
+				const char *format,
+				struct tep_format_field *field)
+{
+	struct tep_handle *tep = field->event->tep;
+	unsigned int len, offset;
+	unsigned long long val;
+
+	if (field->flags & TEP_FIELD_IS_DYNAMIC) {
+		dynamic_offset(tep, field, data, &offset, &len);
+		if (len)
+			trace_seq_printf(s, format, (char *)data + offset);
+		else
+			trace_seq_printf(s, format, "(nil)");
+	} else {
+		val = tep_read_number(tep, data + field->offset, field->size);
+		trace_seq_printf(s, format, val);
+	}
+}
+
+void tep_print_selected_fields(struct trace_seq *s, void *data,
+			       struct tep_event *event,
+			       int ignore_mask)
 {
 	struct tep_format_field *field;
+	struct tep_print_parse *parse;
+	unsigned int len;
+	int field_mask = 1;
 
+	parse = event->print_fmt.print_cache;
 	field = event->format.fields;
 	while (field) {
+		parse = parse_format_next(parse);
+
+		if (field_mask & ignore_mask)
+			goto next;
+
 		trace_seq_printf(s, " %s=", field->name);
-		tep_print_field(s, data, field);
+
+		len = strlen(parse->format);
+		if (len > 0 && parse->format[len - 1] == 'x')
+			trace_seq_printf(s, "0x");
+
+		tep_print_fmt_field(s, data, parse->format, field);
+
+ next:
 		field = field->next;
+		parse = parse->next;
+		field_mask *= 2;
 	}
 }
 
+void tep_print_fields(struct trace_seq *s, void *data,
+		      int size __maybe_unused, struct tep_event *event)
+{
+	tep_print_selected_fields(s, data, event, 0);
+}
+
 static int print_function(struct trace_seq *s, const char *format,
 			  void *data, int size, struct tep_event *event,
 			  struct tep_print_arg *arg)
diff --git a/src/event-parse.h b/src/event-parse.h
index d4a876f..fe0fbf4 100644
--- a/src/event-parse.h
+++ b/src/event-parse.h
@@ -547,6 +547,9 @@ void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field);
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event *event);
+void tep_print_selected_fields(struct trace_seq *s, void *data,
+			       struct tep_event *event,
+			       int ignore_mask);
 int tep_strerror(struct tep_handle *tep, enum tep_errno errnum,
 		 char *buf, size_t buflen);
 
-- 
2.30.2

