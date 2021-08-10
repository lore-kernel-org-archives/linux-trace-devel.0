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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83308C432BE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 12:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 668D560EFF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 12:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbhHJM1k (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 08:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238569AbhHJM1i (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 08:27:38 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40A1C061798
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Aug 2021 05:27:15 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gs8so35018087ejc.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Aug 2021 05:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ImsrmsEqDUTvMFQimgbLeDRfz8nF2nNQfxQWuqrQWgc=;
        b=oEAotYf+XEgk7/NIJcshlEYDOXSkk4l3kwhyhbqB8ZfeqoO9sCWf6KpHx0SUW/IE3F
         XhvhnUEQ5M4DanxQ0kpuiXVX2YZ4JQxZvutJfjAuHBRrrFUJykOL2ZtWoAZZWQwVcZEg
         I7sc0XJl8qOdA48M8wJZKMlKB/pwvWTI0sqBXHblIffQdXlPbsnuaKx/PFVD12v3QJit
         9M0ojtiCKuuJckCFRuIS+0Al0OV2f3PzVNRnsf0JjY0YYGbrL8MIxFu5Mxy8NboR7RRk
         57rKWpvHX+IQJJsBgBLNfkwcYXVolDEKdzN4qBprVbT49kpArEcnmpQJbH9QRzVPbToW
         XC5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ImsrmsEqDUTvMFQimgbLeDRfz8nF2nNQfxQWuqrQWgc=;
        b=NQpKz8i5HAgrRVMR3b5r7wrPhRHmu1dbBaV5POnOEBoarl813lNRfoxJUW+wQ0+sKq
         gApHTIzHRItQHDQU83qdGDORL0gpoyVNZwXDdbK4KfYcJcnJq4ozv/0w5JsP4zxOXOL7
         Ygr7VWVbctfN/Quz5f8lqKyt811QPepCCzF9NmY5ejan+AW6cWQt/ALn9I+P0iJLPd8P
         OAJngnmJAOIXti5goh4rXv+z+BB06wPuxOJnN2ILp2vZz0FWbT6sLLihklmE268kc4Y4
         nwYa8r4sW8TgLGQVoEUEBNrr4ElYL6R+ltdWXBYXzAEIxtpMmWa6KPlRqXoevU7/+U4k
         QPWg==
X-Gm-Message-State: AOAM5315CFVUHZL8y2kTISDFRsvh/mphQNB6oyfSQHEkMEStPBEBNmr6
        Ia4XCOdWmz9mcbDvht8v7vY=
X-Google-Smtp-Source: ABdhPJydT1CfnLwrQx/59fcWINYrbLJg5NDxL+G46ue8qVJ/uSmKqXrnmJmr7EJZY8lFJlxqI0qtQA==
X-Received: by 2002:a17:906:180a:: with SMTP id v10mr27224450eje.112.1628598434648;
        Tue, 10 Aug 2021 05:27:14 -0700 (PDT)
Received: from crow.. ([95.87.199.76])
        by smtp.gmail.com with ESMTPSA id ks20sm1074501ejb.101.2021.08.10.05.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 05:27:14 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 5/5] libtraceevent: Add tep_print_selected_fields()
Date:   Tue, 10 Aug 2021 15:26:59 +0300
Message-Id: <20210810122659.145759-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810122659.145759-1-y.karadz@gmail.com>
References: <20210810122659.145759-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new method can print only a subset of the unique data fields of
the trace event. The print format is derived from the parsing tokens
(tep_print_parse objects) of the event.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/event-parse.c | 18 ++++++++++++++----
 src/event-parse.h |  3 +++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index c7043ec..bc03daf 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5453,20 +5453,30 @@ void tep_print_field(struct trace_seq *s, void *data,
 	_tep_print_field(s, data, field, NULL);
 }
 
-void tep_print_fields(struct trace_seq *s, void *data,
-		      int size __maybe_unused, struct tep_event *event)
+void tep_print_selected_fields(struct trace_seq *s, void *data,
+			       struct tep_event *event,
+			       int ignore_mask)
 {
 	struct tep_print_parse *parse = event->print_fmt.print_cache;
 	struct tep_format_field *field;
+	int field_mask = 1;
 
 	field = event->format.fields;
-	while (field) {
+	for (;field; field = field->next, field_mask *= 2) {
+		if (field_mask & ignore_mask)
+			continue;
+
 		trace_seq_printf(s, " %s=", field->name);
 		_tep_print_field(s, data, field, &parse);
-		field = field->next;
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
index d4a876f..c8f3251 100644
--- a/src/event-parse.h
+++ b/src/event-parse.h
@@ -545,6 +545,9 @@ int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline);
 
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field);
+void tep_print_selected_fields(struct trace_seq *s, void *data,
+			       struct tep_event *event,
+			       int ignore_mask);
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event *event);
 int tep_strerror(struct tep_handle *tep, enum tep_errno errnum,
-- 
2.30.2

