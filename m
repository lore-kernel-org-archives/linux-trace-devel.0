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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6555C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 08:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7E7161131
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 08:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhIIIID (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Sep 2021 04:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhIIIIB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Sep 2021 04:08:01 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D27C061575
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Sep 2021 01:06:52 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id eb14so1459941edb.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Sep 2021 01:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a1H6Ftx2grzx8WinZ9s3RVdbM7aApDYQSrkOOlpBqOQ=;
        b=ef62f97z1p6Y8rtilGSvhMWesQaHYocd2LFV8k3TVDNbYfG4rBBfUEHC7FXRYSD2Hx
         YPOW92iyNhqKScRvr31MYmYLrCE0hWHW5qiQ3BkcoDP4DdveRsSbPC+CI3pTBEASJyBp
         ThcvqVKM1BSIkhkL02Ws5rokqmwRJK3aitY3JzuYp0QwtFMPXA0n5PMCRfdv9GUCubt+
         okPOukc+R8gUOkHLdWVGtyU9KdnozFadtKReoXhIyDfTKuKukkD/sak5tEUtn/jbkdpb
         gNCAhlwJM7LEqnOUmQA4AhnWn5vrFuHbFYo8ijC3VRM7Fe3zwd+Pm2hsptZNj3kiZAjn
         wjJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a1H6Ftx2grzx8WinZ9s3RVdbM7aApDYQSrkOOlpBqOQ=;
        b=qZwN2DcPIRrqWNM4Ci7oyJtu5MsFMo64Jy2djUjh4MYprsP03vTjBjpiyCu0JsOGO+
         C9phfXgJi/0gWcQ/p9lRAZsL4Xi6pSriC4mnPUnuh8ataRRWORyn4Oe7wPjz0XF27w0x
         zQA+/mKnxTFpRRMCJIqnLXy5rQZkn4DMd4MtJFU10UaBA2QS50UBcXx0JSu7YaSdNmuO
         RcQw0vETIAUaCUyyxk3ttuJ30oVESmj/gnv1FqXMGA+5iNlvvy9DZRW2jNlzKK6tBrey
         hijDndR5p8iiNhMse9vX73kx6usuwPl+rW+1Q2TIagO0jdS2pknVgrnCrlQya0sN8MlT
         EVEQ==
X-Gm-Message-State: AOAM530NDnSIo9/4RHk3cDIKmNH0u5PbEYPg17wdWJ4pfwZQYFNBrgiJ
        rFtSRSYVEIX58EdHTuq3S/zd4R2gO3g=
X-Google-Smtp-Source: ABdhPJy7cFpFoNwTzcRk9Fi5c6pnRC3tbWGdyGAV5wVun5MaVbrAU0srGvh8b7NlXk4ygAdJ2oClZg==
X-Received: by 2002:aa7:c790:: with SMTP id n16mr1883403eds.223.1631174810698;
        Thu, 09 Sep 2021 01:06:50 -0700 (PDT)
Received: from crow.. ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id l8sm491821ejn.103.2021.09.09.01.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 01:06:50 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 1/2] libtraceevent: Add APIs for printing the fields of a record
Date:   Thu,  9 Sep 2021 11:06:37 +0300
Message-Id: <20210909080638.259024-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909080638.259024-1-y.karadz@gmail.com>
References: <20210909080638.259024-1-y.karadz@gmail.com>
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
 src/event-parse.c | 51 +++++++++++++++++++++++++++++++++++++++++++----
 src/event-parse.h |  7 +++++++
 2 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 51cb30b..8057fb5 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5455,20 +5455,63 @@ void tep_print_field(struct trace_seq *s, void *data,
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
+ * tep_record_print_fields - print the field name followed by the
+ * record's field value.
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
+ * @select_mask: Bit mask defining the fields to print
+ */
+void tep_record_print_selected_fields(struct trace_seq *s,
+				      struct tep_record *record,
+				      struct tep_event *event,
+				      unsigned long long select_mask)
+{
+	unsigned long long ignore_mask = ~select_mask;
+
+	print_selected_fields(s, record->data, event, ignore_mask);
+}
+
 static int print_function(struct trace_seq *s, const char *format,
 			  void *data, int size, struct tep_event *event,
 			  struct tep_print_arg *arg)
diff --git a/src/event-parse.h b/src/event-parse.h
index d4a876f..0833893 100644
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
+				      unsigned long long select_mask);
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event *event);
 int tep_strerror(struct tep_handle *tep, enum tep_errno errnum,
-- 
2.30.2

