Return-Path: <SRS0=vwyE=AG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83ADC433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84BC2206B7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MdtdaLDK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403810AbgFYKFZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 06:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390894AbgFYKFY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 06:05:24 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA57C061573
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:05:24 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f18so5305573wml.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yhs7OK5kUlZvdh+Ur96B8akZc40NbvB3m427OJhYf3U=;
        b=MdtdaLDKqu+RncZrMLpq8YnqIAvY7CnUwljtA0ucsp+izLo/dnYQK2NadNvc1XYSly
         3qMu8Sy88m167aJ6fz65xufSKKFZFIjOqBi+hwUCPDOvJk4KZ7ngVHmsTlg7r+i7+shz
         WQ9b7ZkXN9CS9ulnPk86Esqxm9rgsnHT9iM0qhLBHFkqUekGAZS3/Y0um1GMQ8dcHVu3
         kOMONzCAb2CO94rF59tq/fZpAJhHZz6/8GLCN0NNNvKNjUhKZEhBua1Jw9kCpDODJ13A
         my1V5GoiPLsvWeVI6hyzXUypY1mnKuP1mXw18WYfcsMzBFZTg96UmIDf+Lx8f5Kwvoth
         +wQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yhs7OK5kUlZvdh+Ur96B8akZc40NbvB3m427OJhYf3U=;
        b=QDqfsBar4f4xcVDEOxcHIOzdObppdwIxcO8jGXPDm0VFYDMY5QbdNAn8gbwiFLXZIt
         WnV5fYlNb/5Ux5dEe7O6mctqpTS4C8MmO82A5x8dNOHjzW1aZSqbJVuyZ8GHrRrbK6dn
         fQddG5D/2eL7pTUvd2N5LVG7d8kdepWOx170h+I7HAa6D4IeLf6yDMQk/Ofsf0vENBcz
         bx7jy4EMSrusVgVpx3KnYP+xnmgV0KsEQPEdfZ49LpMayr8cZuRwTmwAGyTvs1WB9JKS
         wcslWxQ/x2RpAv+lPIcksejNzrASPcLHxCPvwVJ743I+jT+rxlRm59XoroitY6LhZPap
         5XJQ==
X-Gm-Message-State: AOAM533MhIuq400ylN3bjQIO3f1cjAR6Neq/OqGhR4P8bjVbPjSp7Dzi
        rFbgbXvgQWIaeRHTaAyLrRJW/bbuqNg=
X-Google-Smtp-Source: ABdhPJzbqS8vFXbp2KVk16vG4qR2A0Os2VrJlRco536d2AMe3UaSytQuAdb5y8rshniV64IJqJbMAQ==
X-Received: by 2002:a1c:7e49:: with SMTP id z70mr2455668wmc.24.1593079522719;
        Thu, 25 Jun 2020 03:05:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v7sm31268204wrp.45.2020.06.25.03.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 03:05:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 04/15] tools lib traceevent: Move plugin options from trace-cmd to libtraceevent.
Date:   Thu, 25 Jun 2020 13:05:11 +0300
Message-Id: <20200625100516.365338-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625100516.365338-1-tz.stoyanov@gmail.com>
References: <20200625100516.365338-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are two different implementations of plugin options, which work
in parallel - one in trace-cmd and the other one in libtraceevent. Both
have the same functionality and most of the implementation is the same,
duplicated. As currently there are only libtraceevent plugins,the
implementation plugin options should be in libtraceevent only.

Link: http://lore.kernel.org/linux-trace-devel/20190802110101.14759-3-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.h  |   2 +
 tools/lib/traceevent/event-plugin.c | 172 ++++++++++++++++++++++++++++
 2 files changed, 174 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 776c7c24ee79..02c0438527de 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -406,7 +406,9 @@ char **tep_plugin_list_options(void);
 void tep_plugin_free_options_list(char **list);
 int tep_plugin_add_options(const char *name,
 			   struct tep_plugin_option *options);
+int tep_plugin_add_option(const char *name, const char *val);
 void tep_plugin_remove_options(struct tep_plugin_option *options);
+void tep_plugin_print_options(struct trace_seq *s);
 void tep_print_plugins(struct trace_seq *s,
 			const char *prefix, const char *suffix,
 			const struct tep_plugin_list *list);
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index b53d9a53bcf9..e8f4329ba8e0 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -13,6 +13,7 @@
 #include <sys/stat.h>
 #include <unistd.h>
 #include <dirent.h>
+#include <errno.h>
 #include "event-parse.h"
 #include "event-parse-local.h"
 #include "event-utils.h"
@@ -247,6 +248,166 @@ void tep_plugin_remove_options(struct tep_plugin_option *options)
 	}
 }
 
+static void parse_option_name(char **option, char **plugin)
+{
+	char *p;
+
+	*plugin = NULL;
+
+	if ((p = strstr(*option, ":"))) {
+		*plugin = *option;
+		*p = '\0';
+		*option = strdup(p + 1);
+		if (!*option)
+			return;
+	}
+}
+
+static struct tep_plugin_option *
+find_registered_option(const char *plugin, const char *option)
+{
+	struct registered_plugin_options *reg;
+	struct tep_plugin_option *op;
+	const char *op_plugin;
+
+	for (reg = registered_options; reg; reg = reg->next) {
+		for (op = reg->options; op->name; op++) {
+			if (op->plugin_alias)
+				op_plugin = op->plugin_alias;
+			else
+				op_plugin = op->file;
+
+			if (plugin && strcmp(plugin, op_plugin) != 0)
+				continue;
+			if (strcmp(option, op->name) != 0)
+				continue;
+
+			return op;
+		}
+	}
+
+	return NULL;
+}
+
+static int process_option(const char *plugin, const char *option, const char *val)
+{
+	struct tep_plugin_option *op;
+
+	op = find_registered_option(plugin, option);
+	if (!op)
+		return 0;
+
+	return update_option_value(op, val);
+}
+
+/**
+ * tep_plugin_add_option - add an option/val pair to set plugin options
+ * @name: The name of the option (format: <plugin>:<option> or just <option>)
+ * @val: (optiona) the value for the option
+ *
+ * Modify a plugin option. If @val is given than the value of the option
+ * is set (note, some options just take a boolean, so @val must be either
+ * "1" or "0" or "true" or "false").
+ */
+int tep_plugin_add_option(const char *name, const char *val)
+{
+	struct trace_plugin_options *op;
+	char *option_str;
+	char *plugin;
+
+	option_str = strdup(name);
+	if (!option_str)
+		return -ENOMEM;
+
+	parse_option_name(&option_str, &plugin);
+
+	/* If the option exists, update the val */
+	for (op = trace_plugin_options; op; op = op->next) {
+		/* Both must be NULL or not NULL */
+		if ((!plugin || !op->plugin) && plugin != op->plugin)
+			continue;
+		if (plugin && strcmp(plugin, op->plugin) != 0)
+			continue;
+		if (strcmp(op->option, option_str) != 0)
+			continue;
+
+		/* update option */
+		free(op->value);
+		if (val) {
+			op->value = strdup(val);
+			if (!op->value)
+				goto out_free;
+		} else
+			op->value = NULL;
+
+		/* plugin and option_str don't get freed at the end */
+		free(plugin);
+		free(option_str);
+
+		plugin = op->plugin;
+		option_str = op->option;
+		break;
+	}
+
+	/* If not found, create */
+	if (!op) {
+		op = malloc(sizeof(*op));
+		if (!op)
+			return -ENOMEM;
+		memset(op, 0, sizeof(*op));
+		op->next = trace_plugin_options;
+		trace_plugin_options = op;
+
+		op->plugin = plugin;
+		op->option = option_str;
+
+		if (val) {
+			op->value = strdup(val);
+			if (!op->value)
+				goto out_free;
+		}
+	}
+
+	return process_option(plugin, option_str, val);
+ out_free:
+	free(option_str);
+	return -ENOMEM;
+}
+
+static void print_op_data(struct trace_seq *s, const char *name,
+			  const char *op)
+{
+	if (op)
+		trace_seq_printf(s, "%8s:\t%s\n", name, op);
+}
+
+/**
+ * tep_plugin_print_options - print out the registered plugin options
+ * @s: The trace_seq descriptor to write the plugin options into
+ *
+ * Writes a list of options into trace_seq @s.
+ */
+void tep_plugin_print_options(struct trace_seq *s)
+{
+	struct registered_plugin_options *reg;
+	struct tep_plugin_option *op;
+
+	for (reg = registered_options; reg; reg = reg->next) {
+		if (reg != registered_options)
+			trace_seq_printf(s, "============\n");
+		for (op = reg->options; op->name; op++) {
+			if (op != reg->options)
+				trace_seq_printf(s, "------------\n");
+			print_op_data(s, "file", op->file);
+			print_op_data(s, "plugin", op->plugin_alias);
+			print_op_data(s, "option", op->name);
+			print_op_data(s, "desc", op->description);
+			print_op_data(s, "value", op->value);
+			trace_seq_printf(s, "%8s:\t%d\n", "set", op->set);
+		}
+	}
+}
+
 /**
  * tep_print_plugins - print out the list of plugins loaded
  * @s: the trace_seq descripter to write to
@@ -273,6 +434,7 @@ load_plugin(struct tep_handle *tep, const char *path,
 	    const char *file, void *data)
 {
 	struct tep_plugin_list **plugin_list = data;
+	struct tep_plugin_option *options;
 	tep_plugin_load_func func;
 	struct tep_plugin_list *list;
 	const char *alias;
@@ -297,6 +459,16 @@ load_plugin(struct tep_handle *tep, const char *path,
 	if (!alias)
 		alias = file;
 
+	options = dlsym(handle, TEP_PLUGIN_OPTIONS_NAME);
+	if (options) {
+		while (options->name) {
+			ret = update_option(alias, options);
+			if (ret < 0)
+				goto out_free;
+			options++;
+		}
+	}
+
 	func = dlsym(handle, TEP_PLUGIN_LOADER_NAME);
 	if (!func) {
 		warning("could not find func '%s' in plugin '%s'\n%s\n",
-- 
2.26.2

