Return-Path: <SRS0=hXpH=AN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C827C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DC3321531
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgGBRMC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 13:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgGBRMC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 13:12:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE2F0208C7;
        Thu,  2 Jul 2020 17:12:00 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jr2kf-004Aqp-Mx; Thu, 02 Jul 2020 13:11:57 -0400
Message-ID: <20200702171157.567123615@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 02 Jul 2020 13:10:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 5/9] tools lib traceevent: Introduced new traceevent API, for adding new
 plugins directories.
References: <20200702171016.178196716@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

Implement new traceevent plugin API, which can be used to add new plugins
directories:
enum tep_plugin_load_priority {
	TEP_PLUGIN_FIRST,
	TEP_PLUGIN_LAST,
};
int tep_add_plugin_path(struct tep_handle *tep, char *path,
			enum tep_plugin_load_priority prio);

It adds the "path" as new plugin directory, in the context of
the handler "tep". The tep_load_plugins() API searches for plugins
in this new location. Depending of the priority "prio", the plugins
from this directory are loaded before (TEP_PLUGIN_FIRST) or after
(TEP_PLUGIN_LAST) the ordinary libtraceevent plugin locations.

Link: http://lore.kernel.org/linux-trace-devel/20191007114947.17104-2-tz.stoyanov@gmail.com
Link: http://lore.kernel.org/linux-trace-devel/20200625100516.365338-6-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse-local.h |  5 +-
 tools/lib/traceevent/event-parse.c       |  1 +
 tools/lib/traceevent/event-parse.h       |  7 +++
 tools/lib/traceevent/event-plugin.c      | 70 ++++++++++++++++++++++++
 4 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
index cee469803a34..96a0b0ca0675 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -13,6 +13,7 @@ struct func_map;
 struct func_list;
 struct event_handler;
 struct func_resolver;
+struct tep_plugins_dir;
 
 struct tep_handle {
 	int ref_count;
@@ -47,7 +48,6 @@ struct tep_handle {
 	struct printk_list *printklist;
 	unsigned int printk_count;
 
-
 	struct tep_event **events;
 	int nr_events;
 	struct tep_event **sort_events;
@@ -81,10 +81,13 @@ struct tep_handle {
 
 	/* cache */
 	struct tep_event *last_event;
+
+	struct tep_plugins_dir *plugins_dir;
 };
 
 void tep_free_event(struct tep_event *event);
 void tep_free_format_field(struct tep_format_field *field);
+void tep_free_plugin_paths(struct tep_handle *tep);
 
 unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data);
 unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data);
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index e1bd2a93c6db..064c100d2d5a 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -7065,6 +7065,7 @@ void tep_free(struct tep_handle *tep)
 	free(tep->events);
 	free(tep->sort_events);
 	free(tep->func_resolver);
+	tep_free_plugin_paths(tep);
 
 	free(tep);
 }
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 02c0438527de..91f462f5a606 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -393,6 +393,13 @@ struct tep_plugin_list;
 
 #define INVALID_PLUGIN_LIST_OPTION	((char **)((unsigned long)-1))
 
+enum tep_plugin_load_priority {
+	TEP_PLUGIN_FIRST,
+	TEP_PLUGIN_LAST,
+};
+
+int tep_add_plugin_path(struct tep_handle *tep, char *path,
+			enum tep_plugin_load_priority prio);
 struct tep_plugin_list *tep_load_plugins(struct tep_handle *tep);
 void tep_unload_plugins(struct tep_plugin_list *plugin_list,
 			struct tep_handle *tep);
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index e8f4329ba8e0..1d4f1809cf17 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -39,6 +39,12 @@ struct tep_plugin_list {
 	void			*handle;
 };
 
+struct tep_plugins_dir {
+	struct tep_plugins_dir		*next;
+	char				*path;
+	enum tep_plugin_load_priority	prio;
+};
+
 static void lower_case(char *str)
 {
 	if (!str)
@@ -544,6 +550,7 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 					       void *data),
 			   void *data)
 {
+	struct tep_plugins_dir *dir = NULL;
 	char *home;
 	char *path;
 	char *envdir;
@@ -552,6 +559,15 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 	if (tep && tep->flags & TEP_DISABLE_PLUGINS)
 		return;
 
+	if (tep)
+		dir = tep->plugins_dir;
+	while (dir) {
+		if (dir->prio == TEP_PLUGIN_FIRST)
+			load_plugins_dir(tep, suffix, dir->path,
+					 load_plugin, data);
+		dir = dir->next;
+	}
+
 	/*
 	 * If a system plugin directory was defined,
 	 * check that first.
@@ -586,6 +602,15 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 
 	load_plugins_dir(tep, suffix, path, load_plugin, data);
 
+	if (tep)
+		dir = tep->plugins_dir;
+	while (dir) {
+		if (dir->prio == TEP_PLUGIN_LAST)
+			load_plugins_dir(tep, suffix, dir->path,
+					 load_plugin, data);
+		dir = dir->next;
+	}
+
 	free(path);
 }
 
@@ -598,6 +623,51 @@ tep_load_plugins(struct tep_handle *tep)
 	return list;
 }
 
+/**
+ * tep_add_plugin_path - Add a new plugin directory.
+ * @tep: Trace event handler.
+ * @path: Path to a directory. All files with extension .so in that
+ *	  directory will be loaded as plugins.
+ *@prio: Load priority of the plugins in that directory.
+ *
+ * Returns -1 in case of an error, 0 otherwise.
+ */
+int tep_add_plugin_path(struct tep_handle *tep, char *path,
+			enum tep_plugin_load_priority prio)
+{
+	struct tep_plugins_dir *dir;
+
+	if (!tep || !path)
+		return -1;
+
+	dir = calloc(1, sizeof(*dir));
+	if (!dir)
+		return -1;
+
+	dir->path = strdup(path);
+	dir->prio = prio;
+	dir->next = tep->plugins_dir;
+	tep->plugins_dir = dir;
+
+	return 0;
+}
+
+void tep_free_plugin_paths(struct tep_handle *tep)
+{
+	struct tep_plugins_dir *dir;
+
+	if (!tep)
+		return;
+
+	dir = tep->plugins_dir;
+	while (dir) {
+		tep->plugins_dir = tep->plugins_dir->next;
+		free(dir->path);
+		free(dir);
+		dir = tep->plugins_dir;
+	}
+}
+
 void
 tep_unload_plugins(struct tep_plugin_list *plugin_list, struct tep_handle *tep)
 {
-- 
2.26.2


