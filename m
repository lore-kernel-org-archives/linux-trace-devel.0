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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D81F2C76191
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 12:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9056A21951
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 12:43:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AOhsqsX8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfGZMnS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:43:18 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:43424 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfGZMnS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 08:43:18 -0400
Received: by mail-wr1-f51.google.com with SMTP id p13so54264062wru.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jul 2019 05:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rV3yAii3O4kPT5xpODphZtUPwDBJ9ZYERo0bkPP99V8=;
        b=AOhsqsX86ZU+2fiEl9SX/3d2PJG1fulL0PI+KQT4mfS47TBc4TjL82HTITaPqfZDk+
         2ypgot8fvM/hFL4g7hsnpp05bshew8fesYHZKJWXJTiPQxlTJomN5u3Qqq9Jvhua/8Fu
         rzD6k0dC0eUrXDooZ/evO317pNZfAV/n18etGaaQ+iO997xNLypx+U77+x1iT7+3M/LF
         ywXYBP0V3t8RkVCtKUqxNOtNEHhvD9HY4tisoJCOwjU6EeEBA27jtWp2dwxGTCplyc2i
         M/jvAiKHqCoBKbirkAt6Mdb2ugYJkvgWkzRoHFH9zw6WTzPLjNbKZtlZHe6nZoqthJDc
         pqrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rV3yAii3O4kPT5xpODphZtUPwDBJ9ZYERo0bkPP99V8=;
        b=KnsnYx6AikQOJt6ytsrTbmxC9D2Q6pnpFO97ZSMZrFEOk2HN6jqcm+zfKWu54eKorH
         Ymg8z75M+0SV25PK2opJr205ix1f2vLhYsyTtY7OLw1b6LYu/C50nnU5VZc9tvuLzQks
         x2CDtOPre5IisA9ALAym9iJWe4EgIYa84IejK1SVjzfooJ1P6eMkZNUAvVcgRs0o7+jt
         oNWQk4Z3cZslyhEB/nfzdqUUFzvczoLDJyikobuIND5rtkVj/UBtrk1wwSLiTV7U3OrN
         ympMzNDrLOFIs/RUji4AbcLBOqyyH3c5PqYS8PI5TaB5LW//UsWfzqxa5Hm+MwqQcsw3
         Q9kA==
X-Gm-Message-State: APjAAAUVPAsHycM37Ddf4WJ2tQ7xAcV0UtsU/hKkjlalSLEHRXKAtB5u
        P1UB+HdB3KaaM47lvdgztvc=
X-Google-Smtp-Source: APXvYqz/BoxPAUVwTypWpnRLgasBHovvvd8CMNKZ6ZhA1QtpLhF8/ovwiMFjiwgwHaBdDXVygcTHGQ==
X-Received: by 2002:adf:ea4c:: with SMTP id j12mr105773690wrn.75.1564144994023;
        Fri, 26 Jul 2019 05:43:14 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o26sm105565833wro.53.2019.07.26.05.43.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 05:43:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] trace-cmd: Remove trace-cmd plugin handling routines
Date:   Fri, 26 Jul 2019 15:43:08 +0300
Message-Id: <20190726124308.18735-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190726124308.18735-1-tz.stoyanov@gmail.com>
References: <20190726124308.18735-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

Currently there are no trace-cmd related plugins, all of them
are designed to be used with libtraceeevnt. As both libtraceevent
and trace-cmd have logic for managing plugins, the one in trace-cmd
is redundant. Those redundant code is removed and replaced with calls
to libtraceeevnt plugin APIs. When trace-cmd has to load any plugins,
it uses libtraceeevnt to do the job.

Removed trace-cmd functions:
  tracecmd_load_plugins()
  tracecmd_unload_plugins()
  trace_util_load_plugins()
  trace_util_read_plugin_options()
  trace_util_free_options()
  trace_util_print_plugins()
  trace_util_free_plugin_options_list()

A new libtraceevent API is added:
  tep_load_plugins_hook() - the local static
function load_plugins() is exposed as API, as this
functionality is needed be trace-cmd.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h    |  18 --
 include/traceevent/event-parse.h |   6 +
 lib/trace-cmd/trace-input.c      |   9 +-
 lib/trace-cmd/trace-util.c       | 330 +------------------------------
 lib/traceevent/event-plugin.c    |  19 +-
 plugins/plugin_python.c          |   9 +-
 tracecmd/trace-check-events.c    |  10 +-
 tracecmd/trace-list.c            |  21 +-
 8 files changed, 54 insertions(+), 368 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index c06067e..94d4f02 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -25,10 +25,6 @@ void tracecmd_parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigne
 extern int tracecmd_disable_sys_plugins;
 extern int tracecmd_disable_plugins;
 
-struct tep_plugin_list;
-struct tep_plugin_list *tracecmd_load_plugins(struct tep_handle *pevent);
-void tracecmd_unload_plugins(struct tep_plugin_list *list, struct tep_handle *pevent);
-
 char **tracecmd_event_systems(const char *tracing_dir);
 char **tracecmd_system_events(const char *tracing_dir, const char *system);
 struct tep_handle *tracecmd_local_events(const char *tracing_dir);
@@ -334,22 +330,8 @@ int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd);
 bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
 void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
 
-/* --- Plugin handling --- */
-extern struct tep_plugin_option trace_ftrace_options[];
-
-int trace_util_load_plugins(struct tep_handle *pevent, const char *suffix,
-			    int (*load_plugin)(struct tep_handle *pevent,
-					       const char *path,
-					       const char *name,
-					       void *data),
-			    void *data);
-struct tep_plugin_option *trace_util_read_plugin_options(void);
-void trace_util_free_options(struct tep_plugin_option *options);
 char **trace_util_find_plugin_files(const char *suffix);
 void trace_util_free_plugin_files(char **files);
-void trace_util_print_plugins(struct trace_seq *s, const char *prefix, const char *suffix,
-			      const struct tep_plugin_list *list);
-void trace_util_free_plugin_options_list(char **list);
 
 /* Used for trace-cmd list */
 void tracecmd_ftrace_load_options(void);
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index a51b73f..99da5ef 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -382,6 +382,12 @@ struct tep_plugin_list;
 struct tep_plugin_list *tep_load_plugins(struct tep_handle *tep);
 void tep_unload_plugins(struct tep_plugin_list *plugin_list,
 			struct tep_handle *tep);
+void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
+			   void (*load_plugin)(struct tep_handle *tep,
+					       const char *path,
+					       const char *name,
+					       void *data),
+			   void *data);
 char **tep_plugin_list_options(void);
 void tep_plugin_free_options_list(char **list);
 int tep_plugin_add_options(const char *name,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 654101f..d28bfa8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2687,10 +2687,15 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
 	if (!handle->pevent)
 		goto failed_read;
 
+	if (tracecmd_disable_plugins)
+		tep_set_flag(handle->pevent, TEP_DISABLE_PLUGINS);
+	if (tracecmd_disable_sys_plugins)
+		tep_set_flag(handle->pevent, TEP_DISABLE_SYS_PLUGINS);
+
 	/* register default ftrace functions first */
 	tracecmd_ftrace_overrides(handle, &handle->finfo);
 
-	handle->plugin_list = tracecmd_load_plugins(handle->pevent);
+	handle->plugin_list = tep_load_plugins(handle->pevent);
 
 	tep_set_file_bigendian(handle->pevent, buf[0]);
 	tep_set_local_bigendian(handle->pevent, tracecmd_host_bigendian());
@@ -2852,7 +2857,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 		tracecmd_close(handle->parent);
 	else {
 		/* Only main handle frees plugins and pevent */
-		tracecmd_unload_plugins(handle->plugin_list, handle->pevent);
+		tep_unload_plugins(handle->plugin_list, handle->pevent);
 		tep_free(handle->pevent);
 	}
 	free(handle);
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 910c6c5..35e0d70 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -32,38 +32,6 @@ int tracecmd_disable_plugins;
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
-struct tep_plugin_list {
-	struct tep_plugin_list	*next;
-	char			*name;
-	void			*handle;
-};
-
-void trace_util_free_plugin_options_list(char **list)
-{
-	tracecmd_free_list(list);
-}
-
-/**
- * trace_util_print_plugins - print out the list of plugins loaded
- * @s: the trace_seq descripter to write to
- * @prefix: The prefix string to add before listing the option name
- * @suffix: The suffix string ot append after the option name
- * @list: The list of plugins (usually returned by tracecmd_load_plugins()
- *
- * Writes to the trace_seq @s the list of plugins (files) that is
- * returned by tracecmd_load_plugins(). Use @prefix and @suffix for formating:
- * @prefix = "  ", @suffix = "\n".
- */
-void trace_util_print_plugins(struct trace_seq *s,
-			      const char *prefix, const char *suffix,
-			      const struct tep_plugin_list *list)
-{
-	while (list) {
-		trace_seq_printf(s, "%s%s%s", prefix, list->name, suffix);
-		list = list->next;
-	}
-}
-
 void tracecmd_parse_cmdlines(struct tep_handle *pevent,
 			     char *file, int size __maybe_unused)
 {
@@ -179,56 +147,6 @@ void tracecmd_parse_ftrace_printk(struct tep_handle *pevent,
 	}
 }
 
-static int load_plugin(struct tep_handle *pevent, const char *path,
-		       const char *file, void *data)
-{
-	struct tep_plugin_list **plugin_list = data;
-	tep_plugin_load_func func;
-	struct tep_plugin_list *list;
-	const char *alias;
-	char *plugin;
-	void *handle;
-	int ret;
-
-	ret = asprintf(&plugin, "%s/%s", path, file);
-	if (ret < 0)
-		return -ENOMEM;
-
-	handle = dlopen(plugin, RTLD_NOW | RTLD_GLOBAL);
-	if (!handle) {
-		warning("cound not load plugin '%s'\n%s\n",
-			plugin, dlerror());
-		goto out_free;
-	}
-
-	alias = dlsym(handle, TEP_PLUGIN_ALIAS_NAME);
-	if (!alias)
-		alias = file;
-
-	func = dlsym(handle, TEP_PLUGIN_LOADER_NAME);
-	if (!func) {
-		warning("cound not find func '%s' in plugin '%s'\n%s\n",
-			TEP_PLUGIN_LOADER_NAME, plugin, dlerror());
-		goto out_free;
-	}
-
-	list = malloc(sizeof(*list));
-	if (!list)
-		goto out_free;
-	list->next = *plugin_list;
-	list->handle = handle;
-	list->name = plugin;
-	*plugin_list = list;
-
-	pr_stat("registering plugin: %s", plugin);
-	func(pevent);
-	return 0;
-
- out_free:
-	free(plugin);
-	return -1;
-}
-
 static int mount_debugfs(void)
 {
 	struct stat st;
@@ -859,57 +777,13 @@ char **tracecmd_local_plugins(const char *tracing_dir)
 	return plugins;
 }
 
-static void
-trace_util_load_plugins_dir(struct tep_handle *pevent, const char *suffix,
-			    const char *path,
-			    int (*load_plugin)(struct tep_handle *pevent,
-					       const char *path,
-					       const char *name,
-						void *data),
-			    void *data)
-{
-	struct dirent *dent;
-	struct stat st;
-	DIR *dir;
-	int ret;
-
-	ret = stat(path, &st);
-	if (ret < 0)
-		return;
-
-	if (!S_ISDIR(st.st_mode))
-		return;
-
-	dir = opendir(path);
-	if (!dir)
-		return;
-
-	while ((dent = readdir(dir))) {
-		const char *name = dent->d_name;
-
-		if (strcmp(name, ".") == 0 ||
-		    strcmp(name, "..") == 0)
-			continue;
-
-		/* Only load plugins that end in suffix */
-		if (strcmp(name + (strlen(name) - strlen(suffix)), suffix) != 0)
-			continue;
-
-		load_plugin(pevent, path, name, data);
-	}
-
-	closedir(dir);
-
-	return;
-}
-
 struct add_plugin_data {
 	int ret;
 	int index;
 	char **files;
 };
 
-static int add_plugin_file(struct tep_handle *pevent, const char *path,
+static void add_plugin_file(struct tep_handle *pevent, const char *path,
 			   const char *name, void *data)
 {
 	struct add_plugin_data *pdata = data;
@@ -918,7 +792,7 @@ static int add_plugin_file(struct tep_handle *pevent, const char *path,
 	int i;
 
 	if (pdata->ret)
-		return 0;
+		return;
 
 	size = pdata->index + 2;
 	ptr = realloc(pdata->files, sizeof(char *) * size);
@@ -932,7 +806,7 @@ static int add_plugin_file(struct tep_handle *pevent, const char *path,
 	pdata->files = ptr;
 	pdata->index++;
 	pdata->files[pdata->index] = NULL;
-	return 0;
+	return;
 
  out_free:
 	for (i = 0; i < pdata->index; i++)
@@ -940,79 +814,6 @@ static int add_plugin_file(struct tep_handle *pevent, const char *path,
 	free(pdata->files);
 	pdata->files = NULL;
 	pdata->ret = errno;
-	return -ENOMEM;
-}
-
-static char *trace_util_get_source_plugins_dir(void)
-{
-	char *p, path[PATH_MAX+1];
-	int ret;
-
-	ret = readlink("/proc/self/exe", path, PATH_MAX);
-	if (ret > PATH_MAX || ret < 0)
-		return NULL;
-	path[ret] = 0;
-
-	dirname(path);
-	p = strrchr(path, '/');
-	if (!p)
-		return NULL;
-	/* Check if we are in the the source tree */
-	if (strcmp(p, "/tracecmd") != 0)
-		return NULL;
-
-	strcpy(p, "/plugins");
-	return strdup(path);
-}
-
-
-int trace_util_load_plugins(struct tep_handle *pevent, const char *suffix,
-			    int (*load_plugin)(struct tep_handle *pevent,
-					       const char *path,
-					       const char *name,
-					       void *data),
-			    void *data)
-{
-	char *home;
-	char *path;
-	char *envdir;
-	int ret;
-
-	if (tracecmd_disable_plugins)
-		return -EBUSY;
-
-/* If a system plugin directory was defined, check that first */
-#ifdef PLUGIN_DIR
-	if (!tracecmd_disable_sys_plugins)
-		trace_util_load_plugins_dir(pevent, suffix, PLUGIN_DIR,
-					    load_plugin, data);
-#endif
-
-	/* Next let the environment-set plugin directory override the system defaults */
-	envdir = getenv("TRACE_CMD_PLUGIN_DIR");
-	if (envdir)
-		trace_util_load_plugins_dir(pevent, suffix, envdir, load_plugin, data);
-
-	/* Now let the home directory override the environment or system defaults */
-	home = getenv("HOME");
-
-	if (!home)
-		return -EINVAL;
-
-	ret = asprintf(&path, "%s/%s", home, LOCAL_PLUGIN_DIR);
-	if (ret < 0)
-		return -ENOMEM;
-
-	trace_util_load_plugins_dir(pevent, suffix, path, load_plugin, data);
-
-	free(path);
-
-	path = trace_util_get_source_plugins_dir();
-	if (path) {
-		trace_util_load_plugins_dir(pevent, suffix, path, load_plugin, data);
-		free(path);
-	}
-	return 0;
 }
 
 /**
@@ -1035,7 +836,7 @@ char **trace_util_find_plugin_files(const char *suffix)
 
 	memset(&pdata, 0, sizeof(pdata));
 
-	trace_util_load_plugins(NULL, suffix, add_plugin_file, &pdata);
+	tep_load_plugins_hook(NULL, suffix, add_plugin_file, &pdata);
 
 	if (pdata.ret)
 		return TRACECMD_ERROR(pdata.ret);
@@ -1062,129 +863,6 @@ void trace_util_free_plugin_files(char **files)
 	free(files);
 }
 
-struct plugin_option_read {
-	struct tep_plugin_option	*options;
-};
-
-static int append_option(struct plugin_option_read *options,
-			 struct tep_plugin_option *option,
-			 const char *alias, void *handle)
-{
-	struct tep_plugin_option *op;
-
-	while (option->name) {
-		op = malloc(sizeof(*op));
-		if (!op)
-			return -ENOMEM;
-		*op = *option;
-		op->next = options->options;
-		options->options = op;
-		op->file = strdup(alias);
-		op->handle = handle;
-		option++;
-	}
-	return 0;
-}
-
-static int read_options(struct tep_handle *pevent, const char *path,
-			 const char *file, void *data)
-{
-	struct plugin_option_read *options = data;
-	struct tep_plugin_option *option;
-	const char *alias;
-	int unload = 0;
-	char *plugin;
-	void *handle;
-	int ret;
-
-	ret = asprintf(&plugin, "%s/%s", path, file);
-	if (ret < 0)
-		return -ENOMEM;
-
-	handle = dlopen(plugin, RTLD_NOW | RTLD_GLOBAL);
-	if (!handle) {
-		warning("cound not load plugin '%s'\n%s\n",
-			plugin, dlerror());
-		goto out_free;
-	}
-
-	alias = dlsym(handle, TEP_PLUGIN_ALIAS_NAME);
-	if (!alias)
-		alias = file;
-
-	option = dlsym(handle, TEP_PLUGIN_OPTIONS_NAME);
-	if (!option) {
-		unload = 1;
-		goto out_unload;
-	}
-
-	append_option(options, option, alias, handle);
-
- out_unload:
-	if (unload)
-		dlclose(handle);
- out_free:
-	free(plugin);
-	return 0;
-}
-
-struct tep_plugin_option *trace_util_read_plugin_options(void)
-{
-	struct plugin_option_read option = {
-		.options = NULL,
-	};
-
-	append_option(&option, trace_ftrace_options, "ftrace", NULL);
-
-	trace_util_load_plugins(NULL, ".so", read_options, &option);
-
-	return option.options;
-}
-
-void trace_util_free_options(struct tep_plugin_option *options)
-{
-	struct tep_plugin_option *op;
-	void *last_handle = NULL;
-
-	while (options) {
-		op = options;
-		options = op->next;
-		if (op->handle && op->handle != last_handle) {
-			last_handle = op->handle;
-			dlclose(op->handle);
-		}
-		free(op->file);
-		free(op);
-	}
-}
-
-struct tep_plugin_list *tracecmd_load_plugins(struct tep_handle *pevent)
-{
-	struct tep_plugin_list *list = NULL;
-
-	trace_util_load_plugins(pevent, ".so", load_plugin, &list);
-
-	return list;
-}
-
-void
-tracecmd_unload_plugins(struct tep_plugin_list *plugin_list, struct tep_handle *pevent)
-{
-	tep_plugin_unload_func func;
-	struct tep_plugin_list *list;
-
-	while (plugin_list) {
-		list = plugin_list;
-		plugin_list = list->next;
-		func = dlsym(list->handle, TEP_PLUGIN_UNLOADER_NAME);
-		if (func)
-			func(pevent);
-		dlclose(list->handle);
-		free(list->name);
-		free(list);
-	}
-}
-
 char *tracecmd_get_tracing_file(const char *name)
 {
 	static const char *tracing;
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 43961d9..bc10205 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -538,20 +538,19 @@ load_plugins_dir(struct tep_handle *tep, const char *suffix,
 	closedir(dir);
 }
 
-static void
-load_plugins(struct tep_handle *tep, const char *suffix,
-	     void (*load_plugin)(struct tep_handle *tep,
-				 const char *path,
-				 const char *name,
-				 void *data),
-	     void *data)
+void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
+			   void (*load_plugin)(struct tep_handle *tep,
+					       const char *path,
+					       const char *name,
+					       void *data),
+			   void *data)
 {
 	char *home;
 	char *path;
 	char *envdir;
 	int ret;
 
-	if (tep->flags & TEP_DISABLE_PLUGINS)
+	if (tep && tep->flags & TEP_DISABLE_PLUGINS)
 		return;
 
 	/*
@@ -559,7 +558,7 @@ load_plugins(struct tep_handle *tep, const char *suffix,
 	 * check that first.
 	 */
 #ifdef PLUGIN_DIR
-	if (!(tep->flags & TEP_DISABLE_SYS_PLUGINS))
+	if (!tep || !(tep->flags & TEP_DISABLE_SYS_PLUGINS))
 		load_plugins_dir(tep, suffix, PLUGIN_DIR,
 				 load_plugin, data);
 #endif
@@ -596,7 +595,7 @@ tep_load_plugins(struct tep_handle *tep)
 {
 	struct tep_plugin_list *list = NULL;
 
-	load_plugins(tep, ".so", load_plugin, &list);
+	tep_load_plugins_hook(tep, ".so", load_plugin, &list);
 	return list;
 }
 
diff --git a/plugins/plugin_python.c b/plugins/plugin_python.c
index e725ad8..8a7dacd 100644
--- a/plugins/plugin_python.c
+++ b/plugins/plugin_python.c
@@ -20,7 +20,7 @@ static const char pyload[] =
 "finally:\n"
 "   file.close()\n";
 
-static int load_plugin(struct tep_handle *pevent, const char *path,
+static void load_plugin(struct tep_handle *pevent, const char *path,
 		       const char *name, void *data)
 {
 	PyObject *globals = data;
@@ -33,7 +33,7 @@ static int load_plugin(struct tep_handle *pevent, const char *path,
 	PyObject *res;
 
 	if (!full || !n)
-		return -ENOMEM;
+		return;
 
 	strcpy(full, path);
 	strcat(full, "/");
@@ -44,7 +44,7 @@ static int load_plugin(struct tep_handle *pevent, const char *path,
 
 	err = asprintf(&load, pyload, full, n);
 	if (err < 0)
-		return err;
+		return;
 
 	res = PyRun_String(load, Py_file_input, globals, globals);
 	if (!res) {
@@ -55,7 +55,6 @@ static int load_plugin(struct tep_handle *pevent, const char *path,
 
 	free(load);
 
-	return res ? 0 : -1;
 }
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
@@ -95,7 +94,7 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	Py_DECREF(py_pevent);
 	Py_DECREF(str);
 
-	trace_util_load_plugins(pevent, ".py", load_plugin, globals);
+	tep_load_plugins_hook(pevent, ".py", load_plugin, globals);
 
 	return 0;
 }
diff --git a/tracecmd/trace-check-events.c b/tracecmd/trace-check-events.c
index 5fd5d4a..b09fcd0 100644
--- a/tracecmd/trace-check-events.c
+++ b/tracecmd/trace-check-events.c
@@ -42,11 +42,17 @@ void trace_check_events(int argc, char **argv)
 	pevent = tep_alloc();
 	if (!pevent)
 		exit(EINVAL);
-	list = tracecmd_load_plugins(pevent);
+
+	if (tracecmd_disable_plugins)
+		tep_set_flag(pevent, TEP_DISABLE_PLUGINS);
+	if (tracecmd_disable_sys_plugins)
+		tep_set_flag(pevent, TEP_DISABLE_SYS_PLUGINS);
+
+	list = tep_load_plugins(pevent);
 	ret = tracecmd_fill_local_events(tracing, pevent, &parsing_failures);
 	if (ret || parsing_failures)
 		ret = EINVAL;
-	tracecmd_unload_plugins(list, pevent);
+	tep_unload_plugins(list, pevent);
 	tep_free(pevent);
 
 	return;
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 155e297..41d45d0 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -317,12 +317,17 @@ static void show_plugin_options(void)
 	if (!pevent)
 		die("Can not allocate pevent\n");
 
+	if (tracecmd_disable_plugins)
+		tep_set_flag(pevent, TEP_DISABLE_PLUGINS);
+	if (tracecmd_disable_sys_plugins)
+		tep_set_flag(pevent, TEP_DISABLE_SYS_PLUGINS);
+
 	trace_seq_init(&s);
 
-	list = tracecmd_load_plugins(pevent);
+	list = tep_load_plugins(pevent);
 	tep_plugin_print_options(&s);
 	trace_seq_do_printf(&s);
-	tracecmd_unload_plugins(list, pevent);
+	tep_unload_plugins(list, pevent);
 	tep_free(pevent);
 }
 
@@ -343,12 +348,18 @@ static void show_plugins(void)
 	if (!pevent)
 		die("Can not allocate pevent\n");
 
+	if (tracecmd_disable_plugins)
+		tep_set_flag(pevent, TEP_DISABLE_PLUGINS);
+	if (tracecmd_disable_sys_plugins)
+		tep_set_flag(pevent, TEP_DISABLE_SYS_PLUGINS);
+
 	trace_seq_init(&s);
 
-	list = tracecmd_load_plugins(pevent);
-	trace_util_print_plugins(&s, "  ", "\n", list);
+	list = tep_load_plugins(pevent);
+	tep_print_plugins(&s, "  ", "\n", list);
+
 	trace_seq_do_printf(&s);
-	tracecmd_unload_plugins(list, pevent);
+	tep_unload_plugins(list, pevent);
 	tep_free(pevent);
 }
 
-- 
2.21.0

