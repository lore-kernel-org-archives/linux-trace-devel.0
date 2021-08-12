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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAD6C04FE3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D5C16103A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235554AbhHLJAP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 05:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235565AbhHLJAN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 05:00:13 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B555C0613D3
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 01:59:48 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q11so7195480wrr.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 01:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=crsc3dqZeDy4sTG57qneVCoYVmUYscYcQDH1CTj/L00=;
        b=uL5MoaQrkpbNYB0lPZ3y490KlNgJSd/r8b9pOjVAi2IvwKxaNuTMcnN8QiTANRUfVp
         3Mr5px3E65/kUCmaHAf6n0JKDJ6A9lVDnpVukf5zvMH0Ii36pBvVR7gUZ1JFHOGK9n8M
         DCyidxLCM+4xDJm/psSZKKRTHRjuUvAY2vvfdTHbxaBe5Rw2N1t89KuYUFW5BDYtcHeJ
         C3Ob3khixwFHN+kR7nemACX/1scmYFf7GhYwP9TsoE4yo20nqMIquvJXHYfOyZc+o83S
         1rsTZIYb7f3lJVgRwhA52L14IL0Wn3NeTzpqi56SXXcY19jnXc/MjhoyNzrfheZ6Rt5/
         FQLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=crsc3dqZeDy4sTG57qneVCoYVmUYscYcQDH1CTj/L00=;
        b=bfZfR/2wFMWpeWn6Fq2V1LBbhfVPKImGC7EGNh/GRRU5XaXnHULTwYTIiND2Gk3mvN
         Chk1vKUESQZb5dwYlfzM1wC6i2RgFWt3WyrheHbFJTlV21y7mAJJ9lvaq7et7G+vm9mf
         +AQfK9GljbJhmkVAVIntVXyU/v/zAOzc2RGvPenjhkt8yJrSrUWAakwS6IgOmkSsEx1x
         WGvk43/v7mbvR6FR+2DRf0dt9WTxEiaOZxOE3sGIfwKBNN0AaNiIoaPQlKae1+5d7cbE
         CSyvCxaW5WpI4KUENlkt4dvJDmGazjaAhP+sCd48+SV3Pal9FAyTeSc8uJJhUbHNh6HM
         zkow==
X-Gm-Message-State: AOAM5311NPAtyYELBSVosW90HqwReJzLKYw71Tns1pgBKwLFyq6iXGoE
        zsM51eEJblgJ50eChEhmDDKxTcpdlqs=
X-Google-Smtp-Source: ABdhPJxtxiMSH5tk65SGoklbzysX/z9xk7q3OxJqDASuP9r5hNyTWGQTsGekVTK6gr02FqljKj0JYQ==
X-Received: by 2002:a5d:42cf:: with SMTP id t15mr531373wrr.275.1628758787186;
        Thu, 12 Aug 2021 01:59:47 -0700 (PDT)
Received: from crow.. ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id m10sm936683wro.63.2021.08.12.01.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 01:59:46 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 5/5] libtraceevent: Add tep_print_selected_fields()
Date:   Thu, 12 Aug 2021 11:59:29 +0300
Message-Id: <20210812085929.54832-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812085929.54832-1-y.karadz@gmail.com>
References: <20210812085929.54832-1-y.karadz@gmail.com>
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
 src/event-parse.c | 26 ++++++++++++++++++++++----
 src/event-parse.h |  3 +++
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 0795135..645506e 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5455,20 +5455,38 @@ void tep_print_field(struct trace_seq *s, void *data,
 	_tep_print_field(s, data, field, NULL);
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
+	for (;field; field = field->next, field_mask *= 2) {
+		if (field_mask & ignore_mask)
+			continue;
+
 		trace_seq_printf(s, " %s=", field->name);
 		_tep_print_field(s, data, field, &parse);
-		field = field->next;
 	}
 }
 
+void tep_print_selected_fields(struct trace_seq *s, void *data,
+			       struct tep_event *event,
+			       unsigned long long ignore_mask)
+{
+	print_selected_fields(s, data, event, ignore_mask);
+}
+
+void tep_print_fields(struct trace_seq *s, void *data,
+		      int size __maybe_unused, struct tep_event *event)
+{
+	print_selected_fields(s, data, event, 0);
+}
+
 static int print_function(struct trace_seq *s, const char *format,
 			  void *data, int size, struct tep_event *event,
 			  struct tep_print_arg *arg)
diff --git a/src/event-parse.h b/src/event-parse.h
index d4a876f..e3638cf 100644
--- a/src/event-parse.h
+++ b/src/event-parse.h
@@ -545,6 +545,9 @@ int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline);
 
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field);
+void tep_print_selected_fields(struct trace_seq *s, void *data,
+			       struct tep_event *event,
+			       unsigned long long ignore_mask);
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event *event);
 int tep_strerror(struct tep_handle *tep, enum tep_errno errnum,
-- 
2.30.2

