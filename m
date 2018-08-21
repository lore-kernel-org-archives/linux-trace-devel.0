Return-Path: <SRS0=yn/p=LE=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37665 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbeHUQx6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Aug 2018 12:53:58 -0400
Received: by mail-wm0-f67.google.com with SMTP id n11-v6so2877457wmc.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Aug 2018 06:33:47 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/24] tools lib traceevent, perf tools: Rename traceevent_* APIs
Date: Tue, 21 Aug 2018 16:33:15 +0300
Message-Id: <20180821133328.3249-12-tz.stoyanov@gmail.com>
In-Reply-To: <20180821133328.3249-1-tz.stoyanov@gmail.com>
References: <20180821133328.3249-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "traceevent_". This
changes APIs: traceevent_host_bigendian, traceevent_load_plugins and
traceevent_unload_plugins

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180808180701.484691639@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h | 8 ++++----
 lib/traceevent/event-plugin.c    | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index ea5b9f5..979ac97 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -421,9 +421,9 @@ struct plugin_list;
 
 #define INVALID_PLUGIN_LIST_OPTION	((char **)((unsigned long)-1))
 
-struct plugin_list *traceevent_load_plugins(struct tep_handle *pevent);
-void traceevent_unload_plugins(struct plugin_list *plugin_list,
-			       struct tep_handle *pevent);
+struct plugin_list *tep_load_plugins(struct tep_handle *pevent);
+void tep_unload_plugins(struct plugin_list *plugin_list,
+			struct tep_handle *pevent);
 char **traceevent_plugin_list_options(void);
 void traceevent_plugin_free_options_list(char **list);
 int traceevent_plugin_add_options(const char *name,
@@ -585,7 +585,7 @@ __data2host8(struct tep_handle *pevent, unsigned long long data)
 	__data2host8(pevent, __val);				\
 })
 
-static inline int traceevent_host_bigendian(void)
+static inline int tep_host_bigendian(void)
 {
 	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
 	unsigned int val;
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index ccda700..35b35dc 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -250,10 +250,10 @@ void traceevent_plugin_remove_options(struct tep_plugin_option *options)
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
@@ -417,7 +417,7 @@ load_plugins(struct tep_handle *pevent, const char *suffix,
 }
 
 struct plugin_list*
-traceevent_load_plugins(struct tep_handle *pevent)
+tep_load_plugins(struct tep_handle *pevent)
 {
 	struct plugin_list *list = NULL;
 
@@ -426,7 +426,7 @@ traceevent_load_plugins(struct tep_handle *pevent)
 }
 
 void
-traceevent_unload_plugins(struct plugin_list *plugin_list, struct tep_handle *pevent)
+tep_unload_plugins(struct plugin_list *plugin_list, struct tep_handle *pevent)
 {
 	tep_plugin_unload_func func;
 	struct plugin_list *list;
-- 
2.17.1
