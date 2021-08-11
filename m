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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2C3C432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 12:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BEBD60041
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 12:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbhHKMMo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 08:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237466AbhHKMMn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 08:12:43 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CA7C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Aug 2021 05:12:20 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id k38-20020a05600c1ca6b029025af5e0f38bso4245988wms.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Aug 2021 05:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W4Vh3v/PBBsbsJYbpaXK9DNgaUuDuK/o6GViHRy/bsA=;
        b=LvHD+K80Fz6qWWf/ReRmyBhDmIOJ/W2HbQvfBX2c7Jc0+5sEt1lw8J8bqj9hbLE0sC
         uuUkxrOvLqdnbLdxpyrlx/eINEUzbROgW52vk09OBMGiKLDONzKNjPCliPyK+MvjiDfF
         rNMdFdeZtnxgTnC2iVqWAzLuc1YcwknYIdWlDVYZyH35XXCuRPSjuuQjz1APyzmMXuhI
         aLQ0vudGyB/WE8xI9YB4TKp9hh83e5EDfelUZZsAb/FacyGoQVG4NU7EjhlD+AmpSCna
         nq3WoJSP0zwq4mUkPspsFQgnsBMYE9mtB6U+MPRxDHCnHn/STf/8pg41mMAM3D9BdXWu
         wlnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W4Vh3v/PBBsbsJYbpaXK9DNgaUuDuK/o6GViHRy/bsA=;
        b=Ph+a/qHFUFtFvc4nOEKiRHANEPB2vE+h7eFFD9bM35Wdo4j57RqcDtZTQyDG9TCL05
         9w/AqA/YykBTbfHq8ly6OV69VEp3ZDkcTbjW01ydHGmuEkMh8O3AHxxn7WGn2XFzUniR
         /3zyV/qyUEAugJTjGoEGwwTXbbW296osSms+HYzzveQT1lwAfeK7PTNJ9y6X8BI42JrQ
         J/bIDeef3EBbjI3mqK414+5HpX5TcN7tz2abvOGpbCA8Sja7Nq8JOUMDDPmNIeUhR98H
         ZWToBFr2dWAPh1mc8qeq5PQtYY+MKskyw5eRSAfsWN8DwaSYLA5TydDMJ9Nj/7QiqqDP
         cDTw==
X-Gm-Message-State: AOAM530/Yyyo9CQ88nVLtbNUo3XDgk3QvplsSy1iTYTHbikLjPHJJyWy
        BsZFHd6hVhriL8WPSkct0e4=
X-Google-Smtp-Source: ABdhPJzvkVZTVIjFs9cW+85HyVfjL80FVKI6jlyLXKqZ9RL8YbWdqpWo3s+pFmahOiyqo6VUo/62/g==
X-Received: by 2002:a1c:7dd0:: with SMTP id y199mr2513032wmc.148.1628683938652;
        Wed, 11 Aug 2021 05:12:18 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id k1sm27104011wrz.61.2021.08.11.05.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 05:12:18 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 5/5] libtraceevent: Add tep_print_selected_fields()
Date:   Wed, 11 Aug 2021 15:12:03 +0300
Message-Id: <20210811121203.29123-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210811121203.29123-1-y.karadz@gmail.com>
References: <20210811121203.29123-1-y.karadz@gmail.com>
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
index 7831e74..3b93138 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5454,20 +5454,38 @@ void tep_print_field(struct trace_seq *s, void *data,
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

