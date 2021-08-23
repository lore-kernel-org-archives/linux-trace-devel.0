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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0120CC432BE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 09:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFAA66137C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 09:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbhHWJ5Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 05:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235843AbhHWJ5Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 05:57:16 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9FCC061757
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 02:56:33 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r19so25285555eds.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 02:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lKVm56iNrg2ITtHMgmPFwOq6LiHp7d6R7+no24BD/RA=;
        b=um2NGM4LO27aGDmR7qg2jNm/kQgtTVDkcbenfugUGqeLBXLfIjC0gy1hXzp2rfpdr3
         CYm+OPEyvCsGzw4tGs+kBcPu9CzS68JOFkBkmt5z/wrI6qaqmzMuEz/1A8GDLxa+yZvK
         4+3WF3HkYieEYS95zkkB4bnzuFNXvVk1Ets763qNdCZzceYjMQjuYiz+Uls4ZVum1Mwj
         jsHHuYaKM488k9kyhuI4Rbojy5buo+h41RmcxU0ceEYXxfiQA5PHuLt6Fvc/VG52AB77
         tILHCJ7YmuSc/OPsLU1mH7W3FyujCnveHNURXbs5dhFZFGQBkLXIaVmC65vNPwPWQN9U
         JXHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lKVm56iNrg2ITtHMgmPFwOq6LiHp7d6R7+no24BD/RA=;
        b=Zxevnk3BJ7jJs+gm4Ii/RP9xiVDXAdx8GrpnNcdymTJG2cCLdyDuxpKx95RrkicvLF
         +MODif9zowhoNeVEcyXUN/9TbxSCUh58pYKZOXt7iTZ6yOJ2LZEOYLsW9v5KRMCK3hyd
         NkEU0emdSE+ElGrtdEEQ5tOq7wQQ1r24kDZp5wZsWPJJfgivcQGbctcnRdyyrSqn25UV
         x7VymWcGZit5vdWhXX2yEXkHC74FnWCxemTELxFbxZ1j+GKxcMr9qUKSaQGpx5t6BFbC
         8/sWlmx0N8XYmjE0hCOVPM2OoTxBnxDmV1fQwtaJO6vtvGB42ZF2krqycICJWzvZzc4J
         AJzQ==
X-Gm-Message-State: AOAM533pvgbFO80jSA7nhkMhW8oPHwQdV+1kgv6LJMHmlS2VmR6Ua8K0
        5i9dOU4VmK5r1xEiBOtC9aY=
X-Google-Smtp-Source: ABdhPJyuBQkV9xbcVbKW1eG+q0iwVoKlaWxTV5rRmyAjmP2/dc30xRGz3GEYBN2rzajDg6Z2KaRHJw==
X-Received: by 2002:a05:6402:d7:: with SMTP id i23mr36347754edu.291.1629712592134;
        Mon, 23 Aug 2021 02:56:32 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id y23sm7047831ejp.115.2021.08.23.02.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 02:56:31 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 2/4] libtraceevent: Optimize tep_print_fields()
Date:   Mon, 23 Aug 2021 12:56:16 +0300
Message-Id: <20210823095618.138887-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823095618.138887-1-y.karadz@gmail.com>
References: <20210823095618.138887-1-y.karadz@gmail.com>
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
index 6129a0c..51cb30b 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5391,22 +5391,25 @@ static void print_field_raw(struct trace_seq *s, void *data,
 static int print_parse_data(struct tep_print_parse *parse, struct trace_seq *s,
 			    void *data, int size, struct tep_event *event);
 
-void tep_print_field(struct trace_seq *s, void *data,
-		     struct tep_format_field *field)
+void static inline print_field(struct trace_seq *s, void *data,
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
 	print_field_raw(s, data, field);
 }
 
+void tep_print_field(struct trace_seq *s, void *data,
+		     struct tep_format_field *field)
+{
+	print_field(s, data, field, NULL);
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
+		print_field(s, data, field, &parse);
 		field = field->next;
 	}
 }
-- 
2.30.2

