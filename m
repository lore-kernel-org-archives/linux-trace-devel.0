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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3226C4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 12:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA07360F56
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 12:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238889AbhHJM1j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 08:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238426AbhHJM1h (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 08:27:37 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EACC0613D3
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Aug 2021 05:27:15 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b7so29994814edu.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Aug 2021 05:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5FIdexv8kIQpY7C2sYTCUCSotp6gwupoLczMRISVSL0=;
        b=K1PfbdH0jrlqCamFD2kEKuj8s7jEVwwJudSGjFKV3xeA/wlqp2qKdebcNwfIyK0S9C
         ddc6ROft2yJV7N8vSsRJMwt9GFFC8pbRJyOtGLk4kEpXdkTvCy2Ubic2hyJJmjC+0xwQ
         gBJnYJ8E91a7DhYt0wAiIWgc8t3LWOt48ZW2Zw/YjxfePIZolWWAl2CT18cfNvqdUyG+
         7J+JLaZJW4apDorFkaO8VRxCSpyZYZUxSqpai+G344TZrPWP1jmbXNtNpaMjnfgNJd8o
         5ekKbn7PdrBOz3AE4FNmofTnD6F+/Q1pFRyC2QsGu6m0qhAK5RXkmGp6EGWWxIi3F6xM
         We/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5FIdexv8kIQpY7C2sYTCUCSotp6gwupoLczMRISVSL0=;
        b=VSk4OExmgS5m1RpC9/2IlXr/dPseMzsBnEJIXXP7osqd+J/RxacqVF4HGuu0JDDcD2
         2GXPB6C9wZsHMaVJvadsngmEt00HiEXMj0wZ75TR87xXuKWJoJ4IKSFvJInusszufg81
         IYkESbIqsWWHDL/MFJ3CerUia1bi32/b4g3Wv1Y+qj8xhqbsww4ItYhQEwtnRnOACqlb
         6Dyya9u3z29Rk/buCslzCIeD3JZVEQFhSWvntvv7rMh3JKUcCV3Ou3BcgJfdD7QRxfLP
         W460MkgBK3iMmYX1QFWQOS/PS6sn0fqvNiQlQCFJ2ScdUVk9GLN6qdphY+D47SQEuiHk
         DmSA==
X-Gm-Message-State: AOAM531lFu42hSStW2XOMJke3WCmR1mWNIAcJrizc4KfJdM6LbU/7wH5
        jAOtgCl9H4pGPPYVCXJC/XU=
X-Google-Smtp-Source: ABdhPJyrlD7x2LYaMY119PUQJDEVipbf62gFbMv/byK1TYkallRxh7TbCkORHX+L05FZJllZuhMhQg==
X-Received: by 2002:aa7:c2d4:: with SMTP id m20mr4678896edp.368.1628598433877;
        Tue, 10 Aug 2021 05:27:13 -0700 (PDT)
Received: from crow.. ([95.87.199.76])
        by smtp.gmail.com with ESMTPSA id ks20sm1074501ejb.101.2021.08.10.05.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 05:27:13 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 4/5] libtraceevent: Optimize tep_print_fields()
Date:   Tue, 10 Aug 2021 15:26:58 +0300
Message-Id: <20210810122659.145759-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810122659.145759-1-y.karadz@gmail.com>
References: <20210810122659.145759-1-y.karadz@gmail.com>
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
 src/event-parse.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 4b5e98b..c7043ec 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5392,14 +5392,15 @@ static void tep_print_field_raw(struct trace_seq *s, void *data,
 static int print_parse_data(struct tep_print_parse *parse, struct trace_seq *s,
 			    void *data, int size, struct tep_event *event);
 
-void tep_print_field(struct trace_seq *s, void *data,
-		     struct tep_format_field *field)
+void _tep_print_field(struct trace_seq *s, void *data,
+		      struct tep_format_field *field,
+		      struct tep_print_parse **parse_ptr)
 {
 	struct tep_event *event = field->event;
 	struct tep_print_parse *parse;
 	bool has_0x;
 
-	parse = event->print_fmt.print_cache;
+	parse = parse_ptr ? *parse_ptr : event->print_fmt.print_cache;
 
 	if (event->flags & TEP_EVENT_FL_FAILED)
 		goto out;
@@ -5434,6 +5435,10 @@ void tep_print_field(struct trace_seq *s, void *data,
 				 data + field->offset,
 				 field->size,
 				 event);
+
+		if (parse_ptr)
+			*parse_ptr = parse->next;
+
 		return;
 	}
 
@@ -5442,15 +5447,22 @@ void tep_print_field(struct trace_seq *s, void *data,
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

