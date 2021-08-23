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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C3AC43214
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 09:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C041B61078
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 09:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbhHWJ5R (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 05:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235841AbhHWJ5Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 05:57:16 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA10C061575
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 02:56:34 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id d11so35691367eja.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 02:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dK10IrGqEdfcd4P06/H9hsX5lRFxqCCdsXrn6ekP5Ew=;
        b=YH5TOy5FzuZkXbux9T4jz8OES2WwpGfJN8WhVKg9XBEU/ZZ2ENAQiX1JkbhNtOfnle
         PUMGFv2iFnwSoKKa7B/uH6wwYsyQ1Z1+HcsDqxjxfFkkVvJ/1cfqvl0MfpjhGLUDj6fK
         SQXDZBwXQuGI9uVXWk3/FYXy0uJnXBtc01rYbg7TSckjrkZB8dgp6DT5DTckzPK/IIjf
         TAMK9wSb4sqDFV6YeLFgqWsRTZXr9NQRk96yB/xQnr124QZ9YCtmAalkAmgQTtH8ld1g
         a+EnmvC/MnsEbaAPGAZIqFcgEwgNRVP2emXXkP3N5+1RKw1qJ0tyQoTNtMNbteZ6XPrd
         EPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dK10IrGqEdfcd4P06/H9hsX5lRFxqCCdsXrn6ekP5Ew=;
        b=AIdqHMjA5ooEsWEvOtGLM/6z4ged3f82b5oQIgkhdMDbDwXtKerOIwiAeA22eR4P07
         D1gPG+fvSQFYvxj741hCEfyhXfDNLTyQnBAy8sDAHZb8JyxxffWDWCsfbNBVOBPtOsph
         Fe01rFfKIBh5zK/zSDFu7a1tRpwdABZIrkkm7b6G3343ijdzeRxZR0564AYri4OiWmFR
         p1NcQSjz0d3N72qP5FubQYOhJ/rtq0JFfW3a3j2pQiYq9SUqY5l6aqVm3Dp0LekJIJBt
         aOYr5XekrqsUUR12k36oyC6PVH0IRrJkTPHSh+lRQA3SKwMXNGCbPUB2i3yF7j7q32G+
         JoZw==
X-Gm-Message-State: AOAM530BHpZIkBzlctDGH/WfImyshqoUmSE1Bw0lvMGoatPVv9vJhwXD
        J6yWTIJOyzj+PjzZvLDfSUPk27av8j8=
X-Google-Smtp-Source: ABdhPJwuTMDR3nPVJjPBDBFeWz+pobWjNGrj1ytUZVvl4gzxoYLFliBzNjqnSxOseuIyQiyF6u1jiw==
X-Received: by 2002:a17:906:6b8b:: with SMTP id l11mr12329923ejr.508.1629712592810;
        Mon, 23 Aug 2021 02:56:32 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id y23sm7047831ejp.115.2021.08.23.02.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 02:56:32 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 3/4] libtraceevent: Add APIs for printing the fields of a record
Date:   Mon, 23 Aug 2021 12:56:17 +0300
Message-Id: <20210823095618.138887-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823095618.138887-1-y.karadz@gmail.com>
References: <20210823095618.138887-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new methods can print all unique data fielsd, or only a subset of
the fields of the trace event. The print format is derived from the
parsing tokens (tep_print_parse objects) of the event.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/event-parse.c | 49 +++++++++++++++++++++++++++++++++++++++++++----
 src/event-parse.h |  7 +++++++
 2 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 51cb30b..71a3ccd 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5455,20 +5455,61 @@ void tep_print_field(struct trace_seq *s, void *data,
 	print_field(s, data, field, NULL);
 }
 
-void tep_print_fields(struct trace_seq *s, void *data,
-		      int size __maybe_unused, struct tep_event *event)
+static inline void
+print_selected_fields(struct trace_seq *s, void *data,
+		      struct tep_event *event,
+		      unsigned long long ignore_mask)
 {
 	struct tep_print_parse *parse = event->print_fmt.print_cache;
 	struct tep_format_field *field;
+	unsigned long long field_mask = 1;
 
 	field = event->format.fields;
-	while (field) {
+	for(; field; field = field->next, field_mask <<= 1) {
+		if (field_mask & ignore_mask)
+			continue;
+
 		trace_seq_printf(s, " %s=", field->name);
 		print_field(s, data, field, &parse);
-		field = field->next;
 	}
 }
 
+void tep_print_fields(struct trace_seq *s, void *data,
+		      int size __maybe_unused, struct tep_event *event)
+{
+	print_selected_fields(s, data, event, 0);
+}
+
+/**
+ * tep_record_print_selected_fields - print the field name followed by the
+ * record's field value for a selected subset of record fields.
+ * @s: The seq to print to
+ * @record: The record to get the event from
+ * @event: The event that the field is for
+ */
+void tep_record_print_fields(struct trace_seq *s,
+			     struct tep_record *record,
+			     struct tep_event *event)
+{
+	print_selected_fields(s, record->data, event, 0);
+}
+
+/**
+ * tep_record_print_selected_fields - print the field name followed by the
+ * record's field value for a selected subset of record fields.
+ * @s: The seq to print to
+ * @record: The record to get the event from
+ * @event: The event that the field is for
+ * @ignore_mask: Bit mask defining the fields to be ignored
+ */
+void tep_record_print_selected_fields(struct trace_seq *s,
+				      struct tep_record *record,
+				      struct tep_event *event,
+				      unsigned long long ignore_mask)
+{
+	print_selected_fields(s, record->data, event, ignore_mask);
+}
+
 static int print_function(struct trace_seq *s, const char *format,
 			  void *data, int size, struct tep_event *event,
 			  struct tep_print_arg *arg)
diff --git a/src/event-parse.h b/src/event-parse.h
index d4a876f..08dcbd8 100644
--- a/src/event-parse.h
+++ b/src/event-parse.h
@@ -545,6 +545,13 @@ int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline);
 
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field);
+void tep_record_print_fields(struct trace_seq *s,
+			     struct tep_record *record,
+			     struct tep_event *event);
+void tep_record_print_selected_fields(struct trace_seq *s,
+				      struct tep_record *record,
+				      struct tep_event *event,
+				      unsigned long long ignore_mask);
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event *event);
 int tep_strerror(struct tep_handle *tep, enum tep_errno errnum,
-- 
2.30.2

