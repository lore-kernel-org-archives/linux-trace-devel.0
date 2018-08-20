Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:40895 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbeHTRvT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 13:51:19 -0400
Received: by mail-wm0-f67.google.com with SMTP id y9-v6so14187947wma.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Aug 2018 07:35:25 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 11/24] trace-cmd: Rename pevent_traceevent_* APIs
Date: Mon, 20 Aug 2018 17:34:52 +0300
Message-Id: <20180820143505.11525-12-tz.stoyanov@gmail.com>
In-Reply-To: <20180820143505.11525-1-tz.stoyanov@gmail.com>
References: <20180820143505.11525-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: traceevent_host_bigendian, traceevent_load_plugins and traceevent_unload_plugins

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
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
