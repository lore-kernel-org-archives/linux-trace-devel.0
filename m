Return-Path: <SRS0=hXpH=AN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB7BC433E5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 726F420702
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:50:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PSUuxhYs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgGBRuC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 13:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbgGBRt7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 13:49:59 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A810EC08C5C1
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Jul 2020 10:49:59 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s10so29479207wrw.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Jul 2020 10:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AO0rqh9LvR1SLCmlfVTZOByM+aU7lXTEh8gvSds/9/Q=;
        b=PSUuxhYsccKfjQFf8jQgH796VXlDvRHG+GyOX0DFIcyBp/vL94XIlsQ+j5/VzO1IgT
         yWU2H31A6pgnqKXD1wuliQQJcy5+y7hkyEhVyYf5aLFhZu3/7LB5sQX9D25xonUAaUGT
         tuQrCKeq00Ubqc9jDaxwpdW1SbqngewG+GxiK9UAbdXzH6VmJXHhu2HfqwHC5ZISRUCK
         4tfLkrCw9Tcy71vhjvMuZrOeprTaCCHU/0Vp2UtMAcvFzf/D0geW+yeT7TerNNU9hQcp
         5hLQLqQixFkPgQvZA07RZehaCQs0UK4FYHlTHtRzo9Z4AxeibAJZqfpvsM3gaHh+m4eH
         KeKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AO0rqh9LvR1SLCmlfVTZOByM+aU7lXTEh8gvSds/9/Q=;
        b=BwBS1PwL5ZWzCKStT0O48+KI456XU3esEzgyqQtdLXX00UtaG4JLK9jKjII2dTaD9L
         1tpsyeMDgc8EXylOPHPbMHdJowXVSKzAWSuQYJgTNxSPeeVLlRAwzELQBZePRiEU92eH
         NldgCceN2TXVc0EFxOBO+ORkdqO9JZaHPZSZpHi0gKlKIFbR831cJA1cb/okp1mxb4Vk
         obWZZe66zbbBvJiEJtOqgIDntcubsiToH8yn3JE4mltVlCmh0eHdW5nSjk4g80KvTMQK
         G9hQV7cI1mSK398kNEY8gHlBesriwA2xQuu/ZbD+y3U2Cf97igHmSq59H+6+M7KcvC7Y
         YOMQ==
X-Gm-Message-State: AOAM530N2v+FTT9JEx2UX7z1WL5eGrVEEau2jWGtTRKFNyx99vIIMzNj
        uEEuwHlpOpx7w2rYtfqPhLnMf4oj/jM=
X-Google-Smtp-Source: ABdhPJyQ1GpjQUfpqFnDcsTTK4p9AQrKTTveO3S8Ltk0Wr0+J83Ku/Dbrdf0y4CyZ5Ug/ZMPDz67yw==
X-Received: by 2002:adf:cc85:: with SMTP id p5mr32117274wrj.273.1593712198460;
        Thu, 02 Jul 2020 10:49:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g82sm9289319wma.37.2020.07.02.10.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:49:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 13/15] tools lib traceevent: Add builtin handler for trace_marker_raw
Date:   Thu,  2 Jul 2020 20:49:48 +0300
Message-Id: <20200702174950.123454-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702174950.123454-1-tz.stoyanov@gmail.com>
References: <20200702174950.123454-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

When something is written into trace_marker_raw, it goes in as a binary. But
the printk_fmt() of the event that is created (raw_data)'s format file only
prints the first byte of data:

  print fmt: "id:%04x %08x", REC->id, (int)REC->buf[0]

This is no very useful if we want to see the full data output.

Implement the processing of the raw_data event like it is in the kernel.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../lib/traceevent/plugins/plugin_function.c  | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/lib/traceevent/plugins/plugin_function.c b/tools/lib/traceevent/plugins/plugin_function.c
index c7d321968f39..7e8e29b43d1c 100644
--- a/tools/lib/traceevent/plugins/plugin_function.c
+++ b/tools/lib/traceevent/plugins/plugin_function.c
@@ -222,6 +222,44 @@ trace_stack_handler(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
+static int
+trace_raw_data_handler(struct trace_seq *s, struct tep_record *record,
+		    struct tep_event *event, void *context)
+{
+	struct tep_format_field *field;
+	unsigned long long id;
+	int long_size;
+	void *data = record->data;
+
+	if (tep_get_field_val(s, event, "id", record, &id, 1))
+		return trace_seq_putc(s, '!');
+
+	trace_seq_printf(s, "# %llx", id);
+
+	field = tep_find_any_field(event, "buf");
+	if (!field) {
+		trace_seq_printf(s, "<CANT FIND FIELD %s>", "buf");
+		return 0;
+	}
+
+	long_size = tep_get_long_size(event->tep);
+
+	for (data += field->offset; data < record->data + record->size;
+	     data += long_size) {
+		int size = sizeof(long);
+		int left = (record->data + record->size) - data;
+		int i;
+
+		if (size > left)
+			size = left;
+
+		for (i = 0; i < size; i++)
+			trace_seq_printf(s, " %02x", *(unsigned char *)(data + i));
+	}
+
+	return 0;
+}
+
 int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
 	tep_register_event_handler(tep, -1, "ftrace", "function",
@@ -230,6 +268,9 @@ int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 	tep_register_event_handler(tep, -1, "ftrace", "kernel_stack",
 				      trace_stack_handler, NULL);
 
+	tep_register_event_handler(tep, -1, "ftrace", "raw_data",
+				      trace_raw_data_handler, NULL);
+
 	tep_plugin_add_options("ftrace", plugin_options);
 
 	return 0;
-- 
2.26.2

