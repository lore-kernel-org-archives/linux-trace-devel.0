Return-Path: <SRS0=JRVv=X5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A748C47404
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 15:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 667CF207FF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 15:07:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V8j9r0ci"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389559AbfJDPHO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:07:14 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55057 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389086AbfJDPHO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Oct 2019 11:07:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id p7so6204745wmp.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 04 Oct 2019 08:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zLiGAS06ydjDGU5S1D2MZgDpsjtnaq1eso3B+bh0XyI=;
        b=V8j9r0cinpAXgKhBYRYWqyXDoVkDJARemHwgd4P4PUtfh4e+9+Htu8EThUTZtPfHWP
         2mzpmW3BHLotJtHrXUQCTf3EJRn1t9OuSvajmj4HJ7wN8E3WCghKhw3FWKGDFq5sPEqs
         7r2t9KBN7aw/8yZqpN0Qib1RfbvBnD6emUeLwQWSz5uZHu9E+plIRSFg6RVZBqXVV0Jo
         CW+7SKGuKJObBuhx2nNBcjHAjkaujsxv1HSWPl7wEC2kQ4hnFeEefEkid+3aZqKFLCSn
         wi2Uqyev31VKqTCZOHQs4xOxDYjzcRjH446xLFmibiEadPPKltOvGl9ETWpMVqXcuFZD
         +HFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zLiGAS06ydjDGU5S1D2MZgDpsjtnaq1eso3B+bh0XyI=;
        b=mKmmNc0E8PPxi8a/gZMpUhoIcHQw8DmfClGveurgkeKxBulXco4DddkrVUpbdIX+fC
         k6sXd8Mg/yPIxTSz6GZ3SlQf1xik/iCeApNgZrzjPvV/TI5xUj5tOLuwctwlQJzzs/6b
         7RWbfDuLkqvLBC+NVcwBiryJkbf6Y6YKbL6l6lU3jAtahszJnGjhdJz1gbi9kjnQ4Ceq
         jnqo2ZhPY6u8Rsy/D4w/aKJTiLDGRYc/BdUPKaQL7uxl9p5zoBiAg0l5THoqEDVcbOkm
         +9EPCtcFBvxmLGoHqP3pYzwfN759420aJ7TyWr5XcoXlQGAM7Ft++dwtnmlYACRHJdCo
         zT7w==
X-Gm-Message-State: APjAAAUAQUaEbAOVQ2O8lRZEjFbIOo6pA2tVPq/8RO9mQfzN3j/Lob06
        vlRkZr2vxRsyQd5pOsAc6P8xuqf/
X-Google-Smtp-Source: APXvYqykYA4aSdXGHiws0ZqWbrYXsiCrvEOykHpxi8Zit0N82yGsqIrHoEl4C7QJIjVwsDvP1dd2XA==
X-Received: by 2002:a1c:600b:: with SMTP id u11mr10397589wmb.147.1570201630944;
        Fri, 04 Oct 2019 08:07:10 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a7sm12291471wra.43.2019.10.04.08.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 08:07:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 1/2] trace-cmd: Load libtraceevent plugins from build folder, if exists.
Date:   Fri,  4 Oct 2019 18:07:05 +0300
Message-Id: <20191004150706.7957-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191004150706.7957-1-tz.stoyanov@gmail.com>
References: <20191004150706.7957-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a development version of trace-cmd is built and run on the machine,
by default it loads only installed plugins, from system directories.
Thus, the development plugins will not be loaded. To simplify the development
process, a new logic is added:
  At plugins load time, check the location of trace-cmd application and look
  for "plugins" directory around it. If found, load plugins from it. Those
  plugins will be loaded last, so in case of duplication the "development"
  plugins win.
A two new APIs are introduced to libtraceevent, in order to accomplish this
logic:
 tep_load_plugins_dir() - loads tep plugins from a specific directory.
 tep_plugins_append() - Append two plugin lists.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h    |  2 ++
 include/traceevent/event-parse.h |  3 +++
 lib/trace-cmd/trace-input.c      |  7 +----
 lib/trace-cmd/trace-util.c       | 46 ++++++++++++++++++++++++++++++++
 lib/traceevent/event-plugin.c    | 38 ++++++++++++++++++++++++++
 tracecmd/trace-check-events.c    |  7 +----
 tracecmd/trace-list.c            | 14 ++--------
 7 files changed, 93 insertions(+), 24 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 4090eba..f692783 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -24,6 +24,8 @@ void tracecmd_parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigne
 extern int tracecmd_disable_sys_plugins;
 extern int tracecmd_disable_plugins;
 
+struct tep_plugin_list *trace_load_tep_plugins(struct tep_handle *tep);
+
 char **tracecmd_event_systems(const char *tracing_dir);
 char **tracecmd_system_events(const char *tracing_dir, const char *system);
 struct tep_handle *tracecmd_local_events(const char *tracing_dir);
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 5dff952..10320d5 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -380,6 +380,9 @@ struct tep_plugin_list;
 #define INVALID_PLUGIN_LIST_OPTION	((char **)((unsigned long)-1))
 
 struct tep_plugin_list *tep_load_plugins(struct tep_handle *tep);
+struct tep_plugin_list *tep_load_plugins_dir(struct tep_handle *tep, char *path);
+void tep_plugins_append(struct tep_plugin_list *list1,
+			struct tep_plugin_list *list2);
 void tep_unload_plugins(struct tep_plugin_list *plugin_list,
 			struct tep_handle *tep);
 void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 6102eb3..bdeb2bc 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2886,15 +2886,10 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
 	if (!handle->pevent)
 		goto failed_read;
 
-	if (tracecmd_disable_plugins)
-		tep_set_flag(handle->pevent, TEP_DISABLE_PLUGINS);
-	if (tracecmd_disable_sys_plugins)
-		tep_set_flag(handle->pevent, TEP_DISABLE_SYS_PLUGINS);
-
 	/* register default ftrace functions first */
 	tracecmd_ftrace_overrides(handle, &handle->finfo);
 
-	handle->plugin_list = tep_load_plugins(handle->pevent);
+	handle->plugin_list = trace_load_tep_plugins(handle->pevent);
 
 	tep_set_file_bigendian(handle->pevent, buf[0]);
 	tep_set_local_bigendian(handle->pevent, tracecmd_host_bigendian());
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 8aa3b6c..303337d 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -860,6 +860,52 @@ void trace_util_free_plugin_files(char **files)
 	free(files);
 }
 
+static char *get_source_plugins_dir(void)
+{
+	char *p, path[PATH_MAX+1];
+	int ret;
+
+	ret = readlink("/proc/self/exe", path, PATH_MAX);
+	if (ret > PATH_MAX || ret < 0)
+		return NULL;
+
+	dirname(path);
+	p = strrchr(path, '/');
+	if (!p)
+		return NULL;
+	/* Check if we are in the the source tree */
+	if (strcmp(p, "/tracecmd") != 0)
+		return NULL;
+
+	strcpy(p, "/lib/traceevent/plugins");
+	return strdup(path);
+}
+
+struct tep_plugin_list*
+trace_load_tep_plugins(struct tep_handle *tep)
+{
+	struct tep_plugin_list *list_dev;
+	struct tep_plugin_list *list;
+	char *path;
+
+	if (tracecmd_disable_plugins)
+		tep_set_flag(tep, TEP_DISABLE_PLUGINS);
+	if (tracecmd_disable_sys_plugins)
+		tep_set_flag(tep, TEP_DISABLE_SYS_PLUGINS);
+
+	list = tep_load_plugins(tep);
+
+	path = get_source_plugins_dir();
+	if (path) {
+		list_dev = tep_load_plugins_dir(tep, path);
+		tep_plugins_append(list_dev, list);
+		list = list_dev;
+		free(path);
+	}
+
+	return list;
+}
+
 char *tracecmd_get_tracing_file(const char *name)
 {
 	static const char *tracing;
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 6ea4ac0..ce9d53c 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -599,6 +599,44 @@ tep_load_plugins(struct tep_handle *tep)
 	return list;
 }
 
+/**
+ * tep_load_plugins_dir - load traceevent plugins from a directory
+ * @tep: Trace event handler.
+ * @path: Path to a directory. All files with extension .so in that
+ *	  directory will be loaded as plugins.
+ *
+ * Returns a list of loaded plugins
+ */
+struct tep_plugin_list*
+tep_load_plugins_dir(struct tep_handle *tep, char *path)
+{
+	struct tep_plugin_list *list = NULL;
+
+	if (tep && tep->flags & TEP_DISABLE_PLUGINS)
+		return NULL;
+
+	load_plugins_dir(tep, ".so", path, load_plugin, &list);
+	return list;
+}
+
+/**
+ * tep_plugins_append - Concatenate two plugin lists.
+ * @list1: The first plugin list.
+ * @list2: The second plugin list.
+ *
+ * The second plugin list (list2) is appended to the first one (list1).
+ */
+void tep_plugins_append(struct tep_plugin_list *list1,
+			struct tep_plugin_list *list2)
+{
+	struct tep_plugin_list *list = list1;
+
+	while (list && list->next)
+		list = list->next;
+	if (list)
+		list->next = list2;
+}
+
 void
 tep_unload_plugins(struct tep_plugin_list *plugin_list, struct tep_handle *tep)
 {
diff --git a/tracecmd/trace-check-events.c b/tracecmd/trace-check-events.c
index b09fcd0..eb840c6 100644
--- a/tracecmd/trace-check-events.c
+++ b/tracecmd/trace-check-events.c
@@ -43,12 +43,7 @@ void trace_check_events(int argc, char **argv)
 	if (!pevent)
 		exit(EINVAL);
 
-	if (tracecmd_disable_plugins)
-		tep_set_flag(pevent, TEP_DISABLE_PLUGINS);
-	if (tracecmd_disable_sys_plugins)
-		tep_set_flag(pevent, TEP_DISABLE_SYS_PLUGINS);
-
-	list = tep_load_plugins(pevent);
+	list = trace_load_tep_plugins(pevent);
 	ret = tracecmd_fill_local_events(tracing, pevent, &parsing_failures);
 	if (ret || parsing_failures)
 		ret = EINVAL;
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 65099a5..840eeac 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -317,14 +317,9 @@ static void show_plugin_options(void)
 	if (!pevent)
 		die("Can not allocate pevent\n");
 
-	if (tracecmd_disable_plugins)
-		tep_set_flag(pevent, TEP_DISABLE_PLUGINS);
-	if (tracecmd_disable_sys_plugins)
-		tep_set_flag(pevent, TEP_DISABLE_SYS_PLUGINS);
-
 	trace_seq_init(&s);
 
-	list = tep_load_plugins(pevent);
+	list = trace_load_tep_plugins(pevent);
 	tep_plugin_print_options(&s);
 	trace_seq_do_printf(&s);
 	tep_unload_plugins(list, pevent);
@@ -348,14 +343,9 @@ static void show_plugins(void)
 	if (!pevent)
 		die("Can not allocate pevent\n");
 
-	if (tracecmd_disable_plugins)
-		tep_set_flag(pevent, TEP_DISABLE_PLUGINS);
-	if (tracecmd_disable_sys_plugins)
-		tep_set_flag(pevent, TEP_DISABLE_SYS_PLUGINS);
-
 	trace_seq_init(&s);
 
-	list = tep_load_plugins(pevent);
+	list = trace_load_tep_plugins(pevent);
 	tep_print_plugins(&s, "  ", "\n", list);
 
 	trace_seq_do_printf(&s);
-- 
2.21.0

