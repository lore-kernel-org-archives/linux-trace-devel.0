Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F923C2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF9A22465B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d26Mx0EO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgAVPAO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 10:00:14 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39658 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVPAO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 10:00:14 -0500
Received: by mail-lj1-f195.google.com with SMTP id o11so6853675ljc.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Jan 2020 07:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yQK/ew4P9/ik9t+81/pBL+7ZeC8YM+7P18kcUY2BQ2c=;
        b=d26Mx0EO3SGa/By2Q8gwo64wfqE6fKOeeMrztcwSdM071gKb+2Rahp9LXIvtcdjzsL
         e2or606G8CU1pyBaqDAFYqBnivTQwLFso5bnxrmJtXIC968OQ6558Oz+JdPU1qk8Og6T
         CNuQ35J+qZuMI5n/xNgOpTvpGgGPdj0HlKXw1VnTLuyMMei89cGhA+j9RbYiQMnyMCt2
         eNa5P8grLcVJKnuAXQ2TEwrzZozBB2NM2ttpssfuSOgSVszwWpaVQc0Sl6PKeTg+8OdS
         ynz1yTxPBmo0fMYoBQ34IWi2+gonvZ6GBx7hNsXWc+dQF2Xqa7WFAECLQgLxEnrbs0lJ
         xgxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yQK/ew4P9/ik9t+81/pBL+7ZeC8YM+7P18kcUY2BQ2c=;
        b=bncfnL+2v8cfV6wU8gpERel4RmepiwsuFwycDBqFj5Z/qiedv7JUJ68E948jcEL0Ri
         olrokmGstuyB+GvqOYmSqgh+jnYEg+gRm5MspHN431hcbzclfUQascz96vd5JHIxMNjd
         MjcDUaklHRNjFYw4+0bcQylNRiI9qBRcu8SvcKXHwolNqOM8vvTpVu1RQuzDeDCCvHEY
         3tjznssCFecSShxNrkF0/DL7LE+PP2gNwgkDYlK4yBa73m9b4hNa+L21XSqquD8jqQe4
         CXytAA985qPan9eg50fQZt7iaDdIE+Y6+6+0xTkd1yqEUM50cbNU3jZois5cVIoCtq5n
         LKJw==
X-Gm-Message-State: APjAAAWv0s9W6cqbTrGhcogV76F9z2XYi/kSsfXl9i6itnjSjWOO68c4
        Ovspu7qTcxszxX9B+pAZVQs=
X-Google-Smtp-Source: APXvYqy2ZXkwyu539JyrkEOc7H+5k4DJK4BYxtmsJ4M1s2svNEdH3ZW7DchnvJZ+F7QSmSv1SQo23w==
X-Received: by 2002:a2e:909a:: with SMTP id l26mr19423838ljg.209.1579705211648;
        Wed, 22 Jan 2020 07:00:11 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l7sm20722803lfc.80.2020.01.22.07.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 07:00:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/7] trace-cmd,libtraceevent: Remove API for plugin options print
Date:   Wed, 22 Jan 2020 17:00:00 +0200
Message-Id: <20200122150002.763233-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122150002.763233-1-tz.stoyanov@gmail.com>
References: <20200122150002.763233-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The functionality for printing registered plugin
options is moved from libtraceevent to the application.
A more generic walk API is introduced.

Removed APIs:
	tep_plugin_list_options()
	tep_plugin_free_options_list()
	tep_plugin_print_options()

Added API
	tep_plugin_walk_options()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h |  9 ++-
 lib/traceevent/event-plugin.c    | 98 ++++----------------------------
 tracecmd/trace-list.c            | 43 +++++++++++++-
 3 files changed, 58 insertions(+), 92 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index cb1b46e..3b4f3a5 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -346,8 +346,6 @@ enum tep_errno {
 
 struct tep_plugin_list;
 
-#define INVALID_PLUGIN_LIST_OPTION	((char **)((unsigned long)-1))
-
 enum tep_plugin_load_priority {
 	TEP_PLUGIN_FIRST,
 	TEP_PLUGIN_LAST,
@@ -364,13 +362,14 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 					       const char *name,
 					       void *data),
 			   void *data);
-char **tep_plugin_list_options(void);
-void tep_plugin_free_options_list(char **list);
 int tep_plugin_add_options(const char *name,
 			   struct tep_plugin_option *options);
 int tep_plugin_add_option(const char *name, const char *val);
 void tep_plugin_remove_options(struct tep_plugin_option *options);
-void tep_plugin_print_options(struct trace_seq *s);
+void tep_plugin_walk_options(int (*callback)(struct tep_plugin_option *op,
+					     void *context),
+			     void *context);
+
 void tep_print_plugins(struct trace_seq *s,
 			const char *prefix, const char *suffix,
 			const struct tep_plugin_list *list);
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index a33cf09..191b27b 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -91,71 +91,6 @@ static int update_option_value(struct tep_plugin_option *op, const char *val)
 	return 0;
 }
 
-/**
- * tep_plugin_list_options - get list of plugin options
- *
- * Returns an array of char strings that list the currently registered
- * plugin options in the format of <plugin>:<option>. This list can be
- * used by toggling the option.
- *
- * Returns NULL if there's no options registered. On error it returns
- * INVALID_PLUGIN_LIST_OPTION
- *
- * Must be freed with tep_plugin_free_options_list().
- */
-char **tep_plugin_list_options(void)
-{
-	struct registered_plugin_options *reg;
-	struct tep_plugin_option *op;
-	char **list = NULL;
-	char *name;
-	int count = 0;
-
-	for (reg = registered_options; reg; reg = reg->next) {
-		for (op = reg->options; op->name; op++) {
-			char **temp = list;
-			int ret;
-
-			ret = asprintf(&name, "%s:%s", op->plugin, op->name);
-			if (ret < 0)
-				goto err;
-
-			list = realloc(list, count + 2);
-			if (!list) {
-				list = temp;
-				free(name);
-				goto err;
-			}
-			list[count++] = name;
-			list[count] = NULL;
-		}
-	}
-	return list;
-
- err:
-	while (--count >= 0)
-		free(list[count]);
-	free(list);
-
-	return INVALID_PLUGIN_LIST_OPTION;
-}
-
-void tep_plugin_free_options_list(char **list)
-{
-	int i;
-
-	if (!list)
-		return;
-
-	if (list == INVALID_PLUGIN_LIST_OPTION)
-		return;
-
-	for (i = 0; list[i]; i++)
-		free(list[i]);
-
-	free(list);
-}
-
 static int
 update_option(const char *file, struct tep_plugin_option *option)
 {
@@ -377,40 +312,31 @@ int tep_plugin_add_option(const char *name, const char *val)
 	return -ENOMEM;
 }
 
-static void print_op_data(struct trace_seq *s, const char *name,
-			  const char *op)
-{
-	if (op)
-		trace_seq_printf(s, "%8s:\t%s\n", name, op);
-}
-
 /**
- * tep_plugin_print_options - print out the registered plugin options
- * @s: The trace_seq descriptor to write the plugin options into
+ * tep_plugin_walk_options - walk through all registered plugin options
+ * @callback: a user function, called on each registered plugin option
+ * @context: user data, passed to @callback function
  *
- * Writes a list of options into trace_seq @s.
+ * If the @callback returns non zero, the iteration stops.
  */
-void tep_plugin_print_options(struct trace_seq *s)
+void tep_plugin_walk_options(int (*callback)(struct tep_plugin_option *op,
+					     void *context),
+			     void *context)
 {
 	struct registered_plugin_options *reg;
 	struct tep_plugin_option *op;
 
+	if (!callback)
+		return;
+
 	for (reg = registered_options; reg; reg = reg->next) {
-		if (reg != registered_options)
-			trace_seq_printf(s, "============\n");
 		for (op = reg->options; op->name; op++) {
-			if (op != reg->options)
-				trace_seq_printf(s, "------------\n");
-			print_op_data(s, "plugin", op->plugin);
-			print_op_data(s, "option", op->name);
-			print_op_data(s, "desc", op->description);
-			print_op_data(s, "value", op->value);
-			trace_seq_printf(s, "%8s:\t%d\n", "set", op->set);
+			if (callback(op, context))
+				break;
 		}
 	}
 }
 
-
 /**
  * tep_print_plugins - print out the list of plugins loaded
  * @s: the trace_seq descripter to write to
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 6b59117..496a83b 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -304,6 +304,47 @@ static void show_buffers(void)
 		printf("No buffer instances defined\n");
 }
 
+struct plugin_options_context {
+	struct trace_seq *s;
+	char *plugin;
+};
+
+static void print_op_data(struct trace_seq *s, const char *name,
+			  const char *op)
+{
+	if (op)
+		trace_seq_printf(s, "%8s:\t%s\n", name, op);
+}
+
+static int print_options_walk(struct tep_plugin_option *op, void *context)
+{
+	struct plugin_options_context *data = (struct plugin_options_context *)context;
+
+	if (!data->plugin || strcmp(data->plugin, op->plugin)) {
+		trace_seq_printf(data->s, "============\n");
+		free(data->plugin);
+		data->plugin = strdup(op->plugin);
+	}
+	print_op_data(data->s, "plugin", op->plugin);
+	print_op_data(data->s, "option", op->name);
+	print_op_data(data->s, "desc", op->description);
+	print_op_data(data->s, "value", op->value);
+	trace_seq_printf(data->s, "%8s:\t%d\n", "set", op->set);
+	trace_seq_printf(data->s, "------------\n");
+
+	return 0;
+}
+
+static void plugin_options_print(struct trace_seq *s)
+{
+	struct plugin_options_context context;
+
+	memset(&context, 0, sizeof(context));
+	context.s = s;
+	tep_plugin_walk_options(print_options_walk, &context);
+	free(context.plugin);
+}
+
 
 static void show_plugin_options(void)
 {
@@ -320,7 +361,7 @@ static void show_plugin_options(void)
 	trace_seq_init(&s);
 
 	list = trace_load_plugins(pevent);
-	tep_plugin_print_options(&s);
+	plugin_options_print(&s);
 	trace_seq_do_printf(&s);
 	tep_unload_plugins(list, pevent);
 	tep_free(pevent);
-- 
2.24.1

