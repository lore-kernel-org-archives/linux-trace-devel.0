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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C8DC7618B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 12:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4CEB21951
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 12:43:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oM7A7XyQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfGZMnR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:43:17 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:52654 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfGZMnR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 08:43:17 -0400
Received: by mail-wm1-f47.google.com with SMTP id s3so47888786wms.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jul 2019 05:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=op5qMTCmnobHOHUOYgemlbsXJr25MTo6R85Nb11EB5E=;
        b=oM7A7XyQdnrPnTYd0apikbCIepXtezwplBu5oKy6ejNwi0vn3zhqH7RYs2xSmuRye4
         z6J/z3sIbBSb96lzwg4W0w5ZNgLikWeMMg+JivPPupaL9nOILS1V2QX4/CcVVDh9CN91
         oaByYf0++V2ZwPwnMGQ1hsrTpBMFg92fUlWSSC/7cEJfHOprX8p96xFVfdf/m6PJyQza
         GaFqE+PAS4Ep5r3mc60EEzhEjlLtqkNCskq/2Vym86gIFInx3dGPh34Ws00LGMMcZ8R6
         QQ3frseD6DtErnqAVNgEI6e9m6TrI6JFT0JM2avavrts7WnvADG87AvyvRW42qmIc1++
         b1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=op5qMTCmnobHOHUOYgemlbsXJr25MTo6R85Nb11EB5E=;
        b=iJO3uGLamqcNVs4zIfoRWKUWMLs2nsSVUCHA+K1eLyZdSX1v0azmnNotVrGkf+aX2D
         64prh2V4vskGqIeButi3arNpblklK2mho1MEaWdYht26W6F0+z/KhO/UWqUKmBcdBxgQ
         +Zo7VsIiuap7JSs2Rryu/Ji5+96BFq/AhZemAkQJGnu11664aWFuEm1Rfj6bjGxxP2YV
         hAuBpZpQcnIJYybbqsKHtGhk9mBVbEJAyejzlNgE/irPoXshVAPHBZo2G6fF7/XOErp1
         /Tzteryvl/aLrGM6KEMV/Z72T8F4f29hugO0A0RWniXPsFkJxOW7SM54ep6PEx9UjCDv
         tbow==
X-Gm-Message-State: APjAAAXGOJovSjm+lwBGpGn7IXIgm2pU8Mc1pKhhvd9k2OO115Xr14Hn
        yd8XuRhyvmoTRoyeiWbTliI=
X-Google-Smtp-Source: APXvYqxUXPvB9m8j5tuQ+8XoU2+lMTmilSjZSJHF9P22AAvNzrCvAKmDfEgaQEX+N/40mAOFuxY24w==
X-Received: by 2002:a7b:ce18:: with SMTP id m24mr82538669wmc.126.1564144993028;
        Fri, 26 Jul 2019 05:43:13 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o26sm105565833wro.53.2019.07.26.05.43.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 05:43:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] trace-cmd: Move plugin options from trace-cmd to libtraceevent.
Date:   Fri, 26 Jul 2019 15:43:07 +0300
Message-Id: <20190726124308.18735-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190726124308.18735-1-tz.stoyanov@gmail.com>
References: <20190726124308.18735-1-tz.stoyanov@gmail.com>
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

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h    |   6 -
 include/traceevent/event-parse.h |   2 +
 kernel-shark/src/libkshark.c     |   4 +-
 lib/trace-cmd/trace-ftrace.c     |   4 +-
 lib/trace-cmd/trace-util.c       | 422 -------------------------------
 lib/traceevent/event-plugin.c    | 173 +++++++++++++
 plugins/plugin_function.c        |   4 +-
 tracecmd/trace-list.c            |   2 +-
 tracecmd/trace-read.c            |   2 +-
 9 files changed, 183 insertions(+), 436 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 6f62ab9..c06067e 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -337,9 +337,6 @@ void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
 
-int trace_util_add_options(const char *name, struct tep_plugin_option *options);
-void trace_util_remove_options(struct tep_plugin_option *options);
-int trace_util_add_option(const char *name, const char *val);
 int trace_util_load_plugins(struct tep_handle *pevent, const char *suffix,
 			    int (*load_plugin)(struct tep_handle *pevent,
 					       const char *path,
@@ -352,10 +349,7 @@ char **trace_util_find_plugin_files(const char *suffix);
 void trace_util_free_plugin_files(char **files);
 void trace_util_print_plugins(struct trace_seq *s, const char *prefix, const char *suffix,
 			      const struct tep_plugin_list *list);
-void trace_util_print_plugin_options(struct trace_seq *s);
-char **trace_util_list_plugin_options(void);
 void trace_util_free_plugin_options_list(char **list);
-const char *trace_util_plugin_option_value(const char *name);
 
 /* Used for trace-cmd list */
 void tracecmd_ftrace_load_options(void);
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 65cabd9..a51b73f 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -386,7 +386,9 @@ char **tep_plugin_list_options(void);
 void tep_plugin_free_options_list(char **list);
 int tep_plugin_add_options(const char *name,
 			   struct tep_plugin_option *options);
+int tep_plugin_add_option(const char *name, const char *val);
 void tep_plugin_remove_options(struct tep_plugin_option *options);
+void tep_plugin_print_options(struct trace_seq *s);
 void tep_print_plugins(struct trace_seq *s,
 			const char *prefix, const char *suffix,
 			const struct tep_plugin_list *list);
diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 4201fa0..47ec9c2 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -160,8 +160,8 @@ bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
 	 * Turn off function trace indent and turn on show parent
 	 * if possible.
 	 */
-	trace_util_add_option("ftrace:parent", "1");
-	trace_util_add_option("ftrace:indent", "0");
+	tep_plugin_add_option("ftrace:parent", "1");
+	tep_plugin_add_option("ftrace:indent", "0");
 
 	return true;
 }
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 22e5213..20bf71f 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -359,7 +359,7 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
  */
 void tracecmd_ftrace_load_options(void)
 {
-	trace_util_add_options("ftrace", trace_ftrace_options);
+	tep_plugin_add_options("ftrace", trace_ftrace_options);
 }
 
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle,
@@ -381,7 +381,7 @@ int tracecmd_ftrace_overrides(struct tracecmd_input *handle,
 	tep_register_event_handler(pevent, -1, "ftrace", "funcgraph_exit",
 				      fgraph_ret_handler, finfo);
 
-	trace_util_add_options("ftrace", trace_ftrace_options);
+	tep_plugin_add_options("ftrace", trace_ftrace_options);
 
 	/* Store the func ret id and event for later use */
 	event = tep_find_event_by_name(pevent, "ftrace", "funcgraph_exit");
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 7c74bae..910c6c5 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -29,18 +29,6 @@
 int tracecmd_disable_sys_plugins;
 int tracecmd_disable_plugins;
 
-static struct registered_plugin_options {
-	struct registered_plugin_options	*next;
-	struct tep_plugin_option			*options;
-} *registered_options;
-
-static struct trace_plugin_options {
-	struct trace_plugin_options	*next;
-	char				*plugin;
-	char				*option;
-	char				*value;
-} *trace_plugin_options;
-
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
@@ -50,108 +38,11 @@ struct tep_plugin_list {
 	void			*handle;
 };
 
-/**
- * trace_util_list_plugin_options - get list of plugin options
- *
- * Returns an array of char strings that list the currently registered
- * plugin options in the format of <plugin>:<option>. This list can be
- * used by toggling the option.
- *
- * Returns NULL if there's no options registered.
- *
- * Must be freed with trace_util_free_plugin_options_list().
- */
-char **trace_util_list_plugin_options(void)
-{
-	struct registered_plugin_options *reg;
-	struct tep_plugin_option *op;
-	char **list = NULL;
-	char *name;
-	int count = 0;
-
-	for (reg = registered_options; reg; reg = reg->next) {
-		for (op = reg->options; op->name; op++) {
-			char *alias = op->plugin_alias ? op->plugin_alias : op->file;
-			int ret;
-
-			ret = asprintf(&name, "%s:%s", alias, op->name);
-			if (ret < 0) {
-				warning("Failed to allocate plugin option %s:%s",
-					alias, op->name);
-				break;
-			}
-
-			list = realloc(list, count + 2);
-			if (!list) {
-				warning("Failed to allocate plugin list for %s", name);
-				free(name);
-				break;
-			}
-			list[count++] = name;
-			list[count] = NULL;
-		}
-	}
-	if (!count)
-		return NULL;
-	return list;
-}
-
 void trace_util_free_plugin_options_list(char **list)
 {
 	tracecmd_free_list(list);
 }
 
-static int process_option(const char *plugin, const char *option, const char *val);
-static int update_option(const char *file, struct tep_plugin_option *option);
-
-/**
- * trace_util_add_options - Add a set of options by a plugin
- * @name: The name of the plugin adding the options
- * @options: The set of options being loaded
- *
- * Sets the options with the values that have been added by user.
- */
-int trace_util_add_options(const char *name, struct tep_plugin_option *options)
-{
-	struct registered_plugin_options *reg;
-	int ret;
-
-	reg = malloc(sizeof(*reg));
-	if (!reg)
-		return -ENOMEM;
-	reg->next = registered_options;
-	reg->options = options;
-	registered_options = reg;
-
-	while (options->name) {
-		ret = update_option("ftrace", options);
-		if (ret < 0)
-			return ret;
-		options++;
-	}
-	return 0;
-}
-
-/**
- * trace_util_remove_options - remove plugin options that were registered
- * @options: Options to removed that were registered with trace_util_add_options
- */
-void trace_util_remove_options(struct tep_plugin_option *options)
-{
-	struct registered_plugin_options **last;
-	struct registered_plugin_options *reg;
-
-	for (last = &registered_options; *last; last = &(*last)->next) {
-		if ((*last)->options == options) {
-			reg = *last;
-			*last = reg->next;
-			free(reg);
-			return;
-		}
-	}
-			
-}
-
 /**
  * trace_util_print_plugins - print out the list of plugins loaded
  * @s: the trace_seq descripter to write to
@@ -173,197 +64,6 @@ void trace_util_print_plugins(struct trace_seq *s,
 	}
 }
 
-static void parse_option_name(char **option, char **plugin)
-{
-	char *p;
-
-	*plugin = NULL;
-
-	if ((p = strstr(*option, ":"))) {
-		*plugin = *option;
-		*p = '\0';
-		*option = strdup(p + 1);
-		if (!*option)
-			return;
-	}
-}
-
-static struct tep_plugin_option *
-find_registered_option(const char *plugin, const char *option)
-{
-	struct registered_plugin_options *reg;
-	struct tep_plugin_option *op;
-	const char *op_plugin;
-
-	for (reg = registered_options; reg; reg = reg->next) {
-		for (op = reg->options; op->name; op++) {
-			if (op->plugin_alias)
-				op_plugin = op->plugin_alias;
-			else
-				op_plugin = op->file;
-
-			if (plugin && strcmp(plugin, op_plugin) != 0)
-				continue;
-			if (strcmp(option, op->name) != 0)
-				continue;
-
-			return op;
-		}
-	}
-
-	return NULL;
-}
-
-static struct tep_plugin_option *
-find_registered_option_parse(const char *name)
-{
-	struct tep_plugin_option *option;
-	char *option_str;
-	char *plugin;
-
-	option_str = strdup(name);
-	if (!option_str)
-		return NULL;
-
-	parse_option_name(&option_str, &plugin);
-	option = find_registered_option(plugin, option_str);
-	free(option_str);
-	free(plugin);
-
-	return option;
-}
-
-/**
- * trace_util_plugin_option_value - return a plugin option value
- * @name: The name of the plugin option to find (format: <plugin>:<option>)
- *
- * Returns the value char string of the option. If the option is only
- * boolean, then it returns "1" if set, and "0" if not.
- *
- * Returns NULL if the option is not found.
- */
-const char *trace_util_plugin_option_value(const char *name)
-{
-	struct tep_plugin_option *option;
-
-	option = find_registered_option_parse(name);
-	if (!option)
-		return NULL;
-
-	if (option->value)
-		return option->value;
-
-	return option->set ? "1" : "0";
-}
-
-/**
- * trace_util_add_option - add an option/val pair to set plugin options
- * @name: The name of the option (format: <plugin>:<option> or just <option>)
- * @val: (optiona) the value for the option
- *
- * Modify a plugin option. If @val is given than the value of the option
- * is set (note, some options just take a boolean, so @val must be either
- * "1" or "0" or "true" or "false").
- */
-int trace_util_add_option(const char *name, const char *val)
-{
-	struct trace_plugin_options *op;
-	char *option_str;
-	char *plugin;
-	
-	option_str = strdup(name);
-	if (!option_str)
-		return -ENOMEM;
-
-	parse_option_name(&option_str, &plugin);
-
-	/* If the option exists, update the val */
-	for (op = trace_plugin_options; op; op = op->next) {
-		/* Both must be NULL or not NULL */
-		if ((!plugin || !op->plugin) && plugin != op->plugin)
-			continue;
-		if (plugin && strcmp(plugin, op->plugin) != 0)
-			continue;
-		if (strcmp(op->option, option_str) != 0)
-			continue;
-
-		/* update option */
-		free(op->value);
-		if (val) {
-			op->value = strdup(val);
-			if (!op->value)
-				goto out_free;
-		} else
-			op->value = NULL;
-
-		/* plugin and option_str don't get freed at the end */
-		free(plugin);
-		free(option_str);
-
-		plugin = op->plugin;
-		option_str = op->option;
-		break;
-	}
-
-	/* If not found, create */
-	if (!op) {
-		op = malloc(sizeof(*op));
-		if (!op)
-			return -ENOMEM;
-		memset(op, 0, sizeof(*op));
-		op->next = trace_plugin_options;
-		trace_plugin_options = op;
-
-		op->plugin = plugin;
-		op->option = option_str;
-
-		if (val) {
-			op->value = strdup(val);
-			if (!op->value)
-				goto out_free;
-		}
-	}
-
-	return process_option(plugin, option_str, val);
- out_free:
-	free(option_str);
-	return -ENOMEM;
-}
-
-static void print_op_data(struct trace_seq *s, const char *name,
-			  const char *op)
-{
-	if (op)
-		trace_seq_printf(s, "%8s:\t%s\n", name, op);
-}
-
-/**
- * trace_util_print_plugin_options - print out the registered plugin options
- * @s: The trace_seq descriptor to write the plugin options into
- * 
- * Writes a list of options into trace_seq @s.
- */
-void trace_util_print_plugin_options(struct trace_seq *s)
-{
-	struct registered_plugin_options *reg;
-	struct tep_plugin_option *op;
-
-	for (reg = registered_options; reg; reg = reg->next) {
-		if (reg != registered_options)
-			trace_seq_printf(s, "============\n");
-		for (op = reg->options; op->name; op++) {
-			if (op != reg->options)
-				trace_seq_printf(s, "------------\n");
-			print_op_data(s, "file", op->file);
-			print_op_data(s, "plugin", op->plugin_alias);
-			print_op_data(s, "option", op->name);
-			print_op_data(s, "desc", op->description);
-			print_op_data(s, "value", op->value);
-			trace_seq_printf(s, "%8s:\t%d\n", "set", op->set);
-		}
-	}
-}
-
 void tracecmd_parse_cmdlines(struct tep_handle *pevent,
 			     char *file, int size __maybe_unused)
 {
@@ -479,124 +179,12 @@ void tracecmd_parse_ftrace_printk(struct tep_handle *pevent,
 	}
 }
 
-static void lower_case(char *str)
-{
-	if (!str)
-		return;
-	for (; *str; str++)
-		*str = tolower(*str);
-}
-
-static int update_option_value(struct tep_plugin_option *op, const char *val)
-{
-	char *op_val;
-	int ret = 1;
-
-	if (!val) {
-		/* toggle, only if option is boolean */
-		if (op->value)
-			/* Warn? */
-			return 0;
-		op->set ^= 1;
-		return 1;
-	}
-
-	/*
-	 * If the option has a value then it takes a string
-	 * otherwise the option is a boolean.
-	 */
-	if (op->value) {
-		op->value = val;
-		return 1;
-	}
-
-	/* Option is boolean, must be either "1", "0", "true" or "false" */
-
-	op_val = strdup(val);
-	if (!op_val)
-		return -ENOMEM;
-	lower_case(op_val);
-
-	if (strcmp(val, "1") == 0 || strcmp(val, "true") == 0)
-		op->set = 1;
-	else if (strcmp(val, "0") == 0 || strcmp(val, "false") == 0)
-		op->set = 0;
-	else
-		/* Warn on else? */
-		ret = 0;
-	free(op_val);
-
-	return ret;
-}
-
-static int process_option(const char *plugin, const char *option, const char *val)
-{
-	struct tep_plugin_option *op;
-
-	op = find_registered_option(plugin, option);
-	if (!op)
-		return 0;
-
-	return update_option_value(op, val);
-}
-
-static int update_option(const char *file, struct tep_plugin_option *option)
-{
-	struct trace_plugin_options *op;
-	char *plugin;
-
-	if (option->plugin_alias) {
-		plugin = strdup(option->plugin_alias);
-		if (!plugin)
-			return -ENOMEM;
-	} else {
-		char *p;
-		plugin = strdup(file);
-		if (!plugin)
-			return -ENOMEM;
-		p = strstr(plugin, ".");
-		if (p)
-			*p = '\0';
-	}
-
-	/* first look for named options */
-	for (op = trace_plugin_options; op; op = op->next) {
-		if (!op->plugin)
-			continue;
-		if (strcmp(op->plugin, plugin) != 0)
-			continue;
-		if (strcmp(op->option, option->name) != 0)
-			continue;
-
-		option->value = op->value;
-		option->set ^= 1;
-		goto out;
-	}
-
-	/* first look for unnamed options */
-	for (op = trace_plugin_options; op; op = op->next) {
-		if (op->plugin)
-			continue;
-		if (strcmp(op->option, option->name) != 0)
-			continue;
-
-		option->value = op->value;
-		option->set ^= 1;
-		break;
-	}
-
- out:
-	free(plugin);
-	return 0;
-}
-
 static int load_plugin(struct tep_handle *pevent, const char *path,
 		       const char *file, void *data)
 {
 	struct tep_plugin_list **plugin_list = data;
 	tep_plugin_load_func func;
 	struct tep_plugin_list *list;
-	struct tep_plugin_option *options;
 	const char *alias;
 	char *plugin;
 	void *handle;
@@ -617,16 +205,6 @@ static int load_plugin(struct tep_handle *pevent, const char *path,
 	if (!alias)
 		alias = file;
 
-	options = dlsym(handle, TEP_PLUGIN_OPTIONS_NAME);
-	if (options) {
-		while (options->name) {
-			ret = update_option(alias, options);
-			if (ret < 0)
-				goto out_free;
-			options++;
-		}
-	}
-
 	func = dlsym(handle, TEP_PLUGIN_LOADER_NAME);
 	if (!func) {
 		warning("cound not find func '%s' in plugin '%s'\n%s\n",
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 8ca28de..43961d9 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -13,6 +13,7 @@
 #include <sys/stat.h>
 #include <unistd.h>
 #include <dirent.h>
+#include <errno.h>
 #include "event-parse.h"
 #include "event-parse-local.h"
 #include "event-utils.h"
@@ -247,6 +248,167 @@ void tep_plugin_remove_options(struct tep_plugin_option *options)
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
+
 /**
  * tep_print_plugins - print out the list of plugins loaded
  * @s: the trace_seq descripter to write to
@@ -273,6 +435,7 @@ load_plugin(struct tep_handle *tep, const char *path,
 	    const char *file, void *data)
 {
 	struct tep_plugin_list **plugin_list = data;
+	struct tep_plugin_option *options;
 	tep_plugin_load_func func;
 	struct tep_plugin_list *list;
 	const char *alias;
@@ -297,6 +460,16 @@ load_plugin(struct tep_handle *tep, const char *path,
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
diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index 21ee531..80fdfc3 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -215,7 +215,7 @@ int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 	tep_register_event_handler(tep, -1, "ftrace", "kernel_stack",
 				      trace_stack_handler, NULL);
 
-	trace_util_add_options("ftrace", plugin_options);
+	tep_plugin_add_options("ftrace", plugin_options);
 
 	return 0;
 }
@@ -233,7 +233,7 @@ void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 		free(fstack[i].stack);
 	}
 
-	trace_util_remove_options(plugin_options);
+	tep_plugin_remove_options(plugin_options);
 
 	free(fstack);
 	fstack = NULL;
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 00c6073..155e297 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -320,7 +320,7 @@ static void show_plugin_options(void)
 	trace_seq_init(&s);
 
 	list = tracecmd_load_plugins(pevent);
-	trace_util_print_plugin_options(&s);
+	tep_plugin_print_options(&s);
 	trace_seq_do_printf(&s);
 	tracecmd_unload_plugins(list, pevent);
 	tep_free(pevent);
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index d22c723..f8d20ee 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1337,7 +1337,7 @@ static void process_plugin_option(char *option)
 		*p = '\0';
 		val = p+1;
 	}
-	trace_util_add_option(name, val);
+	tep_plugin_add_option(name, val);
 }
 
 static void set_event_flags(struct tep_handle *pevent, struct event_str *list,
-- 
2.21.0

