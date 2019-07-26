Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6069C7618B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 12:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75AC921951
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 12:43:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vSMgTZBn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfGZMnO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:43:14 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40884 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfGZMnN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 08:43:13 -0400
Received: by mail-wr1-f68.google.com with SMTP id r1so54297602wrl.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jul 2019 05:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=irYH6v/bkKWfW2e45xE/2hDSHX8APebDZmcLY4XqWsc=;
        b=vSMgTZBnebrioM963b7y1qQNs74OBJ4QHjcJ1c9PTg6Cq+0HZcwXpqPBFQahubxX1m
         1wSGXrhAVjQFtLVf3hDpYgywJdehxPe67ldr+5qN4fYEbjXct8YeThwEwzTYOaO09jef
         VSF8U5Er8sV6B+XNJiviCUAeER/waUsHNoMhPJRHbDwce2HRuUvoLehpFTmCVfqE8Hnw
         qGDQgOlur7Hd7lndZ8ChkD57qYuh2swbMF9GD6lvubTOA0E5fNKE8y965mpTHZB2z0xa
         97FwC0TolXlidohhj2ZAVB/Dx3CO4LOX55qpaJzpYN6H0hNkzpwHPzVF5pcGdcAhEOn7
         CZfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=irYH6v/bkKWfW2e45xE/2hDSHX8APebDZmcLY4XqWsc=;
        b=CGjATmUOkOVzYpYyF2gQDUgwSq/7wdBS//y7LG8x/F62UQ4lUG4ETd83wTxabDXowM
         tt2t54ehJS54D06WvmrVEMtcHoFEKZrhWBOZpHEEoP1kx2ixiniziMdaeDyLV7LKJYH8
         zJTdxpANVdEeVXzicy6dBqLiarNcJf+kfsmXybzK+Cs0+/TJw9HvZT1YnCUgaCa+lOWz
         ODrqvOKHIO/Qa2dmB/Nuz3K1nSySfhbc7/ZYzeFfpcRBp5vSeATP4wzVtLIcvNahz/Wh
         OdVRjvA0lG5pV7xzgBUZNk8VeY2E44X5gGeb54bw3eycaFCZxlhVN+UtBagIVTiz3kc4
         1XtQ==
X-Gm-Message-State: APjAAAXvhzaFeHbJ9drdt0oMyHtkNT+ivOv1+DfviymK2gWfwpU4zNaG
        QPhKa+HfTH2Aw5DCAsKIGM4=
X-Google-Smtp-Source: APXvYqxfcvQKlo9kKWGEWRChkd6PPgs2OeSz1akLGhSAZLPVd+GTQjLsApZe+kXJlUXtj4joKctJzA==
X-Received: by 2002:adf:ed0e:: with SMTP id a14mr102706587wro.259.1564144991354;
        Fri, 26 Jul 2019 05:43:11 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o26sm105565833wro.53.2019.07.26.05.43.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 05:43:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] trace-cmd: Move kernel_stack event handler to "function" plugin.
Date:   Fri, 26 Jul 2019 15:43:06 +0300
Message-Id: <20190726124308.18735-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190726124308.18735-1-tz.stoyanov@gmail.com>
References: <20190726124308.18735-1-tz.stoyanov@gmail.com>
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

