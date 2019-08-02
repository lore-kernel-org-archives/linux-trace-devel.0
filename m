Return-Path: <SRS0=4i+i=V6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A0FC32750
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Aug 2019 11:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFE172087E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Aug 2019 11:01:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M4RlNyHw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbfHBLBJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 07:01:09 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40124 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729419AbfHBLBJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 07:01:09 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so65952889wmj.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Aug 2019 04:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=irYH6v/bkKWfW2e45xE/2hDSHX8APebDZmcLY4XqWsc=;
        b=M4RlNyHwbFqPq3uk3emK8pW8k9XQ6usbXCvlltPrV4uGwrbIHfvrmzo1zuURXzRwdV
         kxLeBYTH4KKFLsTizjVc50p9Jl3A5Vh39rMlxxSFlCD216FUuM/+E99ToPn6HM6/uy+2
         Lz7iH65tyAX+A2nW7xHylDOKp9h9a+OMreUm/kW9PE7Low90rO9Jh89itFlwHFt79GsV
         tJ8ym58gK46XyOgeJhYxwcgPkjD4jASFf7uRYrOqvZ6sSkoSSHH6mx3knxKxJDGBxMW7
         ySehCwvnaxtjW/s9pFFm4WgO/844+GysWuiLT7ycIkEm0BAMExvALeUjWUna/HcKhhtc
         8Yzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=irYH6v/bkKWfW2e45xE/2hDSHX8APebDZmcLY4XqWsc=;
        b=D3qnYM2tpYXkhs1J2fTzuwTY5y80Y9GPV6gy5BUyTV8u8ynXls7LljzhpxH0WNUNCk
         5ZYK95vkGQIrwrKwOUvC8q+n/TTrEJPZRewt6tXwv41LxMUorNnhJLvQjHtrtbEowfHz
         0in6ZqUTHyhj3B5mu3VGx8Ig8n0aT/4Exl9BpJOdVhjKVorPSepxqYyXFr3IkErh5VUT
         mAY4kEsVjWIKYm1iLkFye+ZFVBeEHbAmKGYRO/AS4dnOmlntfAS7adorNKw2Bj9jwz7o
         +QC9jtTCsHV/Yu601NMlLudvlrlUjdTBEWE7IsQASJ28RmxfP+kJ7ob7IAVtovhUAgaU
         E8hw==
X-Gm-Message-State: APjAAAVBfUsT5VFXYN6PxQYj27fE6TkkzlIBGQ71rNc0OtUAcjZyOBAk
        rtenwFZv8CgI4fHTHifwZ2U=
X-Google-Smtp-Source: APXvYqzjyMx3xrLrOsBjHOvMZyNfF2mpIESBJiGC0/L/Y/MIboHq6M3JfuCwFqn4kpXP/OJcB45++Q==
X-Received: by 2002:a1c:f115:: with SMTP id p21mr3814480wmh.134.1564743666202;
        Fri, 02 Aug 2019 04:01:06 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r15sm79511433wrj.68.2019.08.02.04.01.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 04:01:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/6] trace-cmd: Move kernel_stack event handler to "function" plugin.
Date:   Fri,  2 Aug 2019 14:00:56 +0300
Message-Id: <20190802110101.14759-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190802110101.14759-1-tz.stoyanov@gmail.com>
References: <20190802110101.14759-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "kernel_stack" event handler does not depend on any trace-cmd
context, it can be used aside from the application. The code is
moved to libtraceevent "function" plugin.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-ftrace.c | 52 ------------------------------------
 plugins/plugin_function.c    | 41 ++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 52 deletions(-)

diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index ed68099..22e5213 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -31,17 +31,6 @@ struct tep_plugin_option trace_ftrace_options[] = {
 static struct tep_plugin_option *fgraph_tail = &trace_ftrace_options[0];
 static struct tep_plugin_option *fgraph_depth = &trace_ftrace_options[1];
 
-static void find_long_size(struct tracecmd_ftrace *finfo)
-{
-	finfo->long_size = tracecmd_long_size(finfo->handle);
-}
-
-#define long_size_check(handle)				\
-	do {						\
-		if (!finfo->long_size)				\
-			find_long_size(finfo);		\
-	} while (0)
-
 static int find_ret_event(struct tracecmd_ftrace *finfo, struct tep_handle *pevent)
 {
 	struct tep_event *event;
@@ -361,44 +350,6 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
-static int
-trace_stack_handler(struct trace_seq *s, struct tep_record *record,
-		    struct tep_event *event, void *context)
-{
-	struct tracecmd_ftrace *finfo = context;
-	struct tep_format_field *field;
-	unsigned long long addr;
-	const char *func;
-	void *data = record->data;
-
-	field = tep_find_any_field(event, "caller");
-	if (!field) {
-		trace_seq_printf(s, "<CANT FIND FIELD %s>", "caller");
-		return 0;
-	}
-
-	trace_seq_puts(s, "<stack trace>\n");
-
-	long_size_check(finfo);
-
-	for (data += field->offset; data < record->data + record->size;
-	     data += finfo->long_size) {
-		addr = tep_read_number(event->tep, data, finfo->long_size);
-
-		if ((finfo->long_size == 8 && addr == (unsigned long long)-1) ||
-		    ((int)addr == -1))
-			break;
-
-		func = tep_find_function(event->tep, addr);
-		if (func)
-			trace_seq_printf(s, "=> %s (%llx)\n", func, addr);
-		else
-			trace_seq_printf(s, "=> %llx\n", addr);
-	}
-
-	return 0;
-}
-
 /**
  * tracecmd_ftrace_load_options - load the ftrace options
  *
@@ -430,9 +381,6 @@ int tracecmd_ftrace_overrides(struct tracecmd_input *handle,
 	tep_register_event_handler(pevent, -1, "ftrace", "funcgraph_exit",
 				      fgraph_ret_handler, finfo);
 
-	tep_register_event_handler(pevent, -1, "ftrace", "kernel_stack",
-				      trace_stack_handler, finfo);
-
 	trace_util_add_options("ftrace", trace_ftrace_options);
 
 	/* Store the func ret id and event for later use */
diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index 91beb74..21ee531 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -169,11 +169,52 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
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
 	trace_util_add_options("ftrace", plugin_options);
 
 	return 0;
-- 
2.21.0

