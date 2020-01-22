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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02637C33CB6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCF112465B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F54xntWU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgAVPAK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 10:00:10 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35505 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgAVPAK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 10:00:10 -0500
Received: by mail-lj1-f195.google.com with SMTP id j1so7175018lja.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Jan 2020 07:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GFfy6wL/teGiwg0SM8LV1Kej7UWruPwH8gtWUyWMYXk=;
        b=F54xntWUqs4gbH85Kv0+yoz9uEZHohf6rYSvBWQ/WNmJGUNTztrSsgGbCYgDdL8su4
         2VJVdHpyxLDD1CiJnNxDfsSq9IQ2AwzuyWQ9spv6W0rhnonfzxCOdSB4Qj2LslK8u4xr
         7Sb6nhVzef9VxaPo6W0PzAidjU/+rfE/S+Xx1oG0GmiSpVihCcA59YcX4UvDeB38Ua1o
         txvz/bQCj99ZolMZqqoBSXx3g1Z8TRWK9/16clfSYDtoyaCRK3kjnctPB2sOESgQhUjO
         LuC9OBToahtrLgyg1C6E3uSEkxOgk/IlH84l8WCLfXycxtSt/HN4XqcQNgs92mO+MF1q
         qqBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GFfy6wL/teGiwg0SM8LV1Kej7UWruPwH8gtWUyWMYXk=;
        b=NZzJ55XLM7D2YQ69BO35sABEqU0YIYfKsR97ODarbQp2jJvzLt3+uLPH5v4t2A36+1
         aZF5MT7orSwIlACtgQPWHaE2srbXShK3n43SSxVlRXuKFHHwXKeaTrcd+/vQCF/lgPOg
         tweda4/6ACSk7Wj4snDI6mVWoZYgGpyzajX2IHUnnZM692MqZBRS3Jvsi57ZLLo5tsQ3
         I6N3pDtyrz6BHdKAb0ofxp+kxWdmECAGPICGbpaVVT+ZErHFeDy9hZSh6foxNUOSOUCx
         WFDEYzc3tq5nkDqWf9utcLA2ACRqyCcTlR46AMtCQGv0SkshAy1t+2ENUYuF3+T7DAZE
         cNiQ==
X-Gm-Message-State: APjAAAV6CXe+KYGByrk+LQyX3kOvb9JnL9WFB60EuUVvTxrLqP2029Kz
        R6hIvsK/exSZjfjmUOp7p+dlo599
X-Google-Smtp-Source: APXvYqy2q1Ht4m++an7bzyM5TYKxGWb+5L21lySCgPfGQn5dQ4Dxah8nesRoXfzP3IR2Eq0QA27cgA==
X-Received: by 2002:a2e:81c7:: with SMTP id s7mr20201514ljg.3.1579705206886;
        Wed, 22 Jan 2020 07:00:06 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l7sm20722803lfc.80.2020.01.22.07.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 07:00:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/7] trace-cmd,libtraceevent: Plugin options rework
Date:   Wed, 22 Jan 2020 16:59:56 +0200
Message-Id: <20200122150002.763233-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122150002.763233-1-tz.stoyanov@gmail.com>
References: <20200122150002.763233-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When registering a plugin option, the current API
allows to set an alias to the option's plugin.
This logic complicates the implementation, but is
not used by any existing plugin.
In order to simplify the libtracevent API, these
changes are introduced, related to plugin options:
  - Removed "plugin_alias" from options and all
    logic associated with it.
  - Renamed "file" field to "plugin", the new name
    describes more closely its purpose.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h         | 13 +-------
 lib/trace-cmd/trace-ftrace.c             |  4 +--
 lib/trace-cmd/trace-plugin.c             |  5 ---
 lib/traceevent/event-plugin.c            | 41 +++++++-----------------
 lib/traceevent/plugins/plugin_function.c |  6 ++--
 5 files changed, 17 insertions(+), 52 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 52bafa5..72f7aaf 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -56,9 +56,8 @@ typedef int (*tep_plugin_unload_func)(struct tep_handle *tep);
 struct tep_plugin_option {
 	struct tep_plugin_option	*next;
 	void				*handle;
-	char				*file;
+	char				*plugin;
 	char				*name;
-	char				*plugin_alias;
 	char				*description;
 	const char			*value;
 	void				*priv;
@@ -84,7 +83,6 @@ struct tep_plugin_option {
  *   struct tep_plugin_option TEP_PLUGIN_OPTIONS[] = {
  *	{
  *		.name = "option-name",
- *		.plugin_alias = "override-file-name", (optional)
  *		.description = "description of option to show users",
  *	},
  *	{
@@ -94,27 +92,18 @@ struct tep_plugin_option {
  *
  *   Array must end with .name = NULL;
  *
- *
- *   .plugin_alias is used to give a shorter name to access
- *   the vairable. Useful if a plugin handles more than one event.
- *
  *   If .value is not set, then it is considered a boolean and only
  *   .set will be processed. If .value is defined, then it is considered
  *   a string option and .set will be ignored.
- *
- * TEP_PLUGIN_ALIAS: (optional)
- *   The name to use for finding options (uses filename if not defined)
  */
 #define TEP_PLUGIN_LOADER tep_plugin_loader
 #define TEP_PLUGIN_UNLOADER tep_plugin_unloader
 #define TEP_PLUGIN_OPTIONS tep_plugin_options
-#define TEP_PLUGIN_ALIAS tep_plugin_alias
 #define _MAKE_STR(x)	#x
 #define MAKE_STR(x)	_MAKE_STR(x)
 #define TEP_PLUGIN_LOADER_NAME MAKE_STR(TEP_PLUGIN_LOADER)
 #define TEP_PLUGIN_UNLOADER_NAME MAKE_STR(TEP_PLUGIN_UNLOADER)
 #define TEP_PLUGIN_OPTIONS_NAME MAKE_STR(TEP_PLUGIN_OPTIONS)
-#define TEP_PLUGIN_ALIAS_NAME MAKE_STR(TEP_PLUGIN_ALIAS)
 
 enum tep_format_flags {
 	TEP_FIELD_IS_ARRAY	= 1,
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 20bf71f..f251ad1 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -12,14 +12,14 @@
 
 struct tep_plugin_option trace_ftrace_options[] = {
 	{
+		.plugin = "ftrace",
 		.name = "tailprint",
-		.plugin_alias = "fgraph",
 		.description =
 		"Print function name at function exit in function graph",
 	},
 	{
+		.plugin = "ftrace",
 		.name = "depth",
-		.plugin_alias = "fgraph",
 		.description =
 		"Show the depth of each entry",
 	},
diff --git a/lib/trace-cmd/trace-plugin.c b/lib/trace-cmd/trace-plugin.c
index 6bec18b..ce2f062 100644
--- a/lib/trace-cmd/trace-plugin.c
+++ b/lib/trace-cmd/trace-plugin.c
@@ -100,7 +100,6 @@ load_plugin(struct trace_plugin_context *trace, const char *path,
 	struct trace_plugin_list **plugin_list = data;
 	tracecmd_plugin_load_func func;
 	struct trace_plugin_list *list;
-	const char *alias;
 	char *plugin;
 	void *handle;
 	int ret;
@@ -118,10 +117,6 @@ load_plugin(struct trace_plugin_context *trace, const char *path,
 		goto out_free;
 	}
 
-	alias = dlsym(handle, TRACECMD_PLUGIN_ALIAS_NAME);
-	if (!alias)
-		alias = file;
-
 	func = dlsym(handle, TRACECMD_PLUGIN_LOADER_NAME);
 	if (!func) {
 		warning("could not find func '%s' in plugin '%s'\n%s\n",
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 30c1526..bbe87d4 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -113,11 +113,10 @@ char **tep_plugin_list_options(void)
 
 	for (reg = registered_options; reg; reg = reg->next) {
 		for (op = reg->options; op->name; op++) {
-			char *alias = op->plugin_alias ? op->plugin_alias : op->file;
 			char **temp = list;
 			int ret;
 
-			ret = asprintf(&name, "%s:%s", alias, op->name);
+			ret = asprintf(&name, "%s:%s", op->plugin, op->name);
 			if (ret < 0)
 				goto err;
 
@@ -163,20 +162,14 @@ update_option(const char *file, struct tep_plugin_option *option)
 	struct trace_plugin_options *op;
 	char *plugin;
 	int ret = 0;
+	char *p;
 
-	if (option->plugin_alias) {
-		plugin = strdup(option->plugin_alias);
-		if (!plugin)
-			return -1;
-	} else {
-		char *p;
-		plugin = strdup(file);
-		if (!plugin)
-			return -1;
-		p = strstr(plugin, ".");
-		if (p)
-			*p = '\0';
-	}
+	plugin = strdup(file);
+	if (!plugin)
+		return -1;
+	p = strstr(plugin, ".");
+	if (p)
+		*p = '\0';
 
 	/* first look for named options */
 	for (op = trace_plugin_options; op; op = op->next) {
@@ -274,16 +267,10 @@ find_registered_option(const char *plugin, const char *option)
 {
 	struct registered_plugin_options *reg;
 	struct tep_plugin_option *op;
-	const char *op_plugin;
 
 	for (reg = registered_options; reg; reg = reg->next) {
 		for (op = reg->options; op->name; op++) {
-			if (op->plugin_alias)
-				op_plugin = op->plugin_alias;
-			else
-				op_plugin = op->file;
-
-			if (plugin && strcmp(plugin, op_plugin) != 0)
+			if (plugin && strcmp(plugin, op->plugin) != 0)
 				continue;
 			if (strcmp(option, op->name) != 0)
 				continue;
@@ -404,8 +391,7 @@ void tep_plugin_print_options(struct trace_seq *s)
 		for (op = reg->options; op->name; op++) {
 			if (op != reg->options)
 				trace_seq_printf(s, "------------\n");
-			print_op_data(s, "file", op->file);
-			print_op_data(s, "plugin", op->plugin_alias);
+			print_op_data(s, "plugin", op->plugin);
 			print_op_data(s, "option", op->name);
 			print_op_data(s, "desc", op->description);
 			print_op_data(s, "value", op->value);
@@ -444,7 +430,6 @@ load_plugin(struct tep_handle *tep, const char *path,
 	struct tep_plugin_option *options;
 	tep_plugin_load_func func;
 	struct tep_plugin_list *list;
-	const char *alias;
 	char *plugin;
 	void *handle;
 	int ret;
@@ -462,14 +447,10 @@ load_plugin(struct tep_handle *tep, const char *path,
 		goto out_free;
 	}
 
-	alias = dlsym(handle, TEP_PLUGIN_ALIAS_NAME);
-	if (!alias)
-		alias = file;
-
 	options = dlsym(handle, TEP_PLUGIN_OPTIONS_NAME);
 	if (options) {
 		while (options->name) {
-			ret = update_option(alias, options);
+			ret = update_option(file, options);
 			if (ret < 0)
 				goto out_free;
 			options++;
diff --git a/lib/traceevent/plugins/plugin_function.c b/lib/traceevent/plugins/plugin_function.c
index 938b741..8c36920 100644
--- a/lib/traceevent/plugins/plugin_function.c
+++ b/lib/traceevent/plugins/plugin_function.c
@@ -22,21 +22,21 @@ static int cpus = -1;
 struct tep_plugin_option plugin_options[] =
 {
 	{
+		.plugin = "ftrace",
 		.name = "parent",
-		.plugin_alias = "ftrace",
 		.description =
 		"Print parent of functions for function events",
 	},
 	{
+		.plugin = "ftrace",
 		.name = "indent",
-		.plugin_alias = "ftrace",
 		.description =
 		"Try to show function call indents, based on parents",
 		.set = 1,
 	},
 	{
+		.plugin = "ftrace",
 		.name = "offset",
-		.plugin_alias = "ftrace",
 		.description =
 		"Show function names as well as their offsets",
 		.set = 0,
-- 
2.24.1

