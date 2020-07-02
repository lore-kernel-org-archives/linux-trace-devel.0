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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BA8C433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EA3020702
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sxLb1jGU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgGBRt7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 13:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727985AbgGBRt6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 13:49:58 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBA1C08C5C1
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Jul 2020 10:49:58 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f18so21454076wrs.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Jul 2020 10:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h7Ck6dWhaMy9XxuQAS45jH4/gGQNVyX8Ys6+xcSHVKI=;
        b=sxLb1jGUV2gJ/dspoPKiorJf2dNfhu9DOcc0nemHyGw3eQrMO+6Og+FGrtbSkVXQ84
         QXZLHYsbYYC3HCEVz6/lUl/VJ/ArNRMPy94w2ZRz3iV7+RJ5ejZdcF9+s2U6dwv9dZ1g
         IyV2oCQ0S0PIQhHsIQwckvR8KTDsZ4O94vegkW+ZJteGtV+bdS4UR7JN2umRjdRIww1e
         bB2LgMRpQ2o0kEQpcCKUXTzXbw7jIOZzJNXwFiMnEnoFydwW4Pdry6JWAIXdfYb1uDfy
         Naq59v/ZGtM+r3RUd0CvmNBmzrBhvQ+PhRoG4/Iu7DWf+RkQCqScq8q8nRrvPF5LpX+X
         LROw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h7Ck6dWhaMy9XxuQAS45jH4/gGQNVyX8Ys6+xcSHVKI=;
        b=WOU4bWXJHabKUS2yAPzU2wdadeiA8GG4hOgBEcNaG3FW9Rb0QvWBVLi/+OGEu5KTH3
         I1yRcNa1Ty/AwICi/cs5tLKCMp6ZB37E9tFTMglcss9aOTmdJaa7Uv9pZq3daI6PhqXy
         inkVCafEOVTlxDRPITWqEIQ9C7PTOorV7ZIopCKXYLgSa/1qfudtaS+V5Cfa6UMvtFT+
         069dHzfkIhp8/H5xXlHQIJsIzM4IhMXCe7gUiJLfSPPJqEl7uMcy0paFgoBtEPabiy/M
         EQjWPPzStubdxiC4K/OacLgkKb9wqeMmABouc5ZyQdavn7tEL03yAH11Mp5ZqbNiDrIr
         EcPA==
X-Gm-Message-State: AOAM531ffbpKtzI635hay8Ox/d3Uoc6TO63coLcLL2KjDCwfu2L3D+2p
        gkBqO1lPZSlnMYhR3sz1ZSB04+MF/fk=
X-Google-Smtp-Source: ABdhPJxmkNxoMqHv5s/noQmQmiQl3SiXuYw/m3ULYYo1jj22QWybCM4fgy+uzsfiVcANQcRsiHG0vQ==
X-Received: by 2002:adf:f445:: with SMTP id f5mr33294675wrp.339.1593712197240;
        Thu, 02 Jul 2020 10:49:57 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g82sm9289319wma.37.2020.07.02.10.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:49:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 12/15] tools lib traceevent: Move kernel_stack event handler to "function" plugin.
Date:   Thu,  2 Jul 2020 20:49:47 +0300
Message-Id: <20200702174950.123454-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702174950.123454-1-tz.stoyanov@gmail.com>
References: <20200702174950.123454-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "kernel_stack" event handler does not depend on any trace-cmd
context, it can be used aside from the application. The code is
moved to libtraceevent "function" plugin.

Link: http://lore.kernel.org/linux-trace-devel/20190726124308.18735-2-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../lib/traceevent/plugins/plugin_function.c  | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/lib/traceevent/plugins/plugin_function.c b/tools/lib/traceevent/plugins/plugin_function.c
index cafddd6be983..c7d321968f39 100644
--- a/tools/lib/traceevent/plugins/plugin_function.c
+++ b/tools/lib/traceevent/plugins/plugin_function.c
@@ -184,11 +184,52 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
+static int
+trace_stack_handler(struct trace_seq *s, struct tep_record *record,
+		    struct tep_event *event, void *context)
+{
+	struct tep_format_field *field;
+	unsigned long long addr;
+	const char *func;
+	int long_size;
+	void *data = record->data;
+
+	field = tep_find_any_field(event, "caller");
+	if (!field) {
+		trace_seq_printf(s, "<CANT FIND FIELD %s>", "caller");
+		return 0;
+	}
+
+	trace_seq_puts(s, "<stack trace >\n");
+
+	long_size = tep_get_long_size(event->tep);
+
+	for (data += field->offset; data < record->data + record->size;
+	     data += long_size) {
+		addr = tep_read_number(event->tep, data, long_size);
+
+		if ((long_size == 8 && addr == (unsigned long long)-1) ||
+		    ((int)addr == -1))
+			break;
+
+		func = tep_find_function(event->tep, addr);
+		if (func)
+			trace_seq_printf(s, "=> %s (%llx)\n", func, addr);
+		else
+			trace_seq_printf(s, "=> %llx\n", addr);
+	}
+
+	return 0;
+}
+
 int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
 	tep_register_event_handler(tep, -1, "ftrace", "function",
 				   function_handler, NULL);
 
+	tep_register_event_handler(tep, -1, "ftrace", "kernel_stack",
+				      trace_stack_handler, NULL);
+
 	tep_plugin_add_options("ftrace", plugin_options);
 
 	return 0;
-- 
2.26.2

