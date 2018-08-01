Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41960 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730355AbeHAO2S (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 10:28:18 -0400
Received: by mail-wr1-f67.google.com with SMTP id j5-v6so19991428wrr.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Aug 2018 05:42:40 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 11/24] tools/lib/traceevent, tools/perf: Rename traceevent_* APIs
Date: Wed,  1 Aug 2018 15:41:43 +0300
Message-Id: <20180801124156.20894-12-tz.stoyanov@gmail.com>
In-Reply-To: <20180801124156.20894-1-tz.stoyanov@gmail.com>
References: <20180801124156.20894-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: traceevent_host_bigendian, traceevent_load_plugins and traceevent_unload_plugins

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.h  | 6 +++---
 tools/lib/traceevent/event-plugin.c | 8 ++++----
 tools/perf/util/trace-event.c       | 6 +++---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 9bf6db18680f..58eae964e485 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -435,8 +435,8 @@ struct plugin_list;
 
 #define INVALID_PLUGIN_LIST_OPTION	((char **)((unsigned long)-1))
 
-struct plugin_list *traceevent_load_plugins(struct tep_handle *pevent);
-void traceevent_unload_plugins(struct plugin_list *plugin_list,
+struct plugin_list *tep_load_plugins(struct tep_handle *pevent);
+void tep_unload_plugins(struct plugin_list *plugin_list,
 			       struct tep_handle *pevent);
 char **traceevent_plugin_list_options(void);
 void traceevent_plugin_free_options_list(char **list);
@@ -597,7 +597,7 @@ __data2host8(struct tep_handle *pevent, unsigned long long data)
 	__data2host8(pevent, __val);				\
 })
 
-static inline int traceevent_host_bigendian(void)
+static inline int tep_host_bigendian(void)
 {
 	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
 	unsigned int val;
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index 8c91c8f0abd9..39859cee7712 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -264,10 +264,10 @@ void traceevent_plugin_remove_options(struct tep_plugin_option *options)
  * @s: the trace_seq descripter to write to
  * @prefix: The prefix string to add before listing the option name
  * @suffix: The suffix string ot append after the option name
- * @list: The list of plugins (usually returned by traceevent_load_plugins()
+ * @list: The list of plugins (usually returned by tep_load_plugins()
  *
  * Writes to the trace_seq @s the list of plugins (files) that is
- * returned by traceevent_load_plugins(). Use @prefix and @suffix for formating:
+ * returned by tep_load_plugins(). Use @prefix and @suffix for formating:
  * @prefix = "  ", @suffix = "\n".
  */
 void traceevent_print_plugins(struct trace_seq *s,
@@ -431,7 +431,7 @@ load_plugins(struct tep_handle *pevent, const char *suffix,
 }
 
 struct plugin_list*
-traceevent_load_plugins(struct tep_handle *pevent)
+tep_load_plugins(struct tep_handle *pevent)
 {
 	struct plugin_list *list = NULL;
 
@@ -440,7 +440,7 @@ traceevent_load_plugins(struct tep_handle *pevent)
 }
 
 void
-traceevent_unload_plugins(struct plugin_list *plugin_list, struct tep_handle *pevent)
+tep_unload_plugins(struct plugin_list *plugin_list, struct tep_handle *pevent)
 {
 	tep_plugin_unload_func func;
 	struct plugin_list *list;
diff --git a/tools/perf/util/trace-event.c b/tools/perf/util/trace-event.c
index 679c93644a08..3102e8be81f5 100644
--- a/tools/perf/util/trace-event.c
+++ b/tools/perf/util/trace-event.c
@@ -31,7 +31,7 @@ int trace_event__init(struct trace_event *t)
 	struct tep_handle *pevent = tep_alloc();
 
 	if (pevent) {
-		t->plugin_list = traceevent_load_plugins(pevent);
+		t->plugin_list = tep_load_plugins(pevent);
 		t->pevent  = pevent;
 	}
 
@@ -40,7 +40,7 @@ int trace_event__init(struct trace_event *t)
 
 static int trace_event__init2(void)
 {
-	int be = traceevent_host_bigendian();
+	int be = tep_host_bigendian();
 	struct tep_handle *pevent;
 
 	if (trace_event__init(&tevent))
@@ -65,7 +65,7 @@ int trace_event__register_resolver(struct machine *machine,
 
 void trace_event__cleanup(struct trace_event *t)
 {
-	traceevent_unload_plugins(t->plugin_list, t->pevent);
+	tep_unload_plugins(t->plugin_list, t->pevent);
 	tep_free(t->pevent);
 }
 
-- 
2.17.1
