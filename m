Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32995 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389121AbeHAO2T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 10:28:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id g6-v6so19988943wrp.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Aug 2018 05:42:41 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 12/24] tools/lib/traceevent, tools/perf: Rename enum pevent_flag
Date: Wed,  1 Aug 2018 15:41:44 +0300
Message-Id: <20180801124156.20894-13-tz.stoyanov@gmail.com>
In-Reply-To: <20180801124156.20894-1-tz.stoyanov@gmail.com>
References: <20180801124156.20894-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
pevent_get_page_size API and enum pevent_flag

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.c  |  2 +-
 tools/lib/traceevent/event-parse.h  | 10 +++++-----
 tools/lib/traceevent/event-plugin.c |  4 ++--
 tools/perf/builtin-kmem.c           |  2 +-
 tools/perf/util/trace-event-read.c  |  2 +-
 tools/perf/util/trace-event.c       |  2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 175f207aa94e..4366a821d2c7 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5515,7 +5515,7 @@ void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 	}
 
 	if (use_usec_format) {
-		if (pevent->flags & PEVENT_NSEC_OUTPUT) {
+		if (pevent->flags & TEP_NSEC_OUTPUT) {
 			usecs = nsecs;
 			p = 9;
 		} else {
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 58eae964e485..7f0f69ebb952 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -373,10 +373,10 @@ enum pevent_func_arg_type {
 	PEVENT_FUNC_ARG_MAX_TYPES
 };
 
-enum pevent_flag {
-	PEVENT_NSEC_OUTPUT		= 1,	/* output in NSECS */
-	PEVENT_DISABLE_SYS_PLUGINS	= 1 << 1,
-	PEVENT_DISABLE_PLUGINS		= 1 << 2,
+enum tep_flag {
+	TEP_NSEC_OUTPUT		= 1,	/* output in NSECS */
+	TEP_DISABLE_SYS_PLUGINS	= 1 << 1,
+	TEP_DISABLE_PLUGINS		= 1 << 2,
 };
 
 #define PEVENT_ERRORS 							      \
@@ -751,7 +751,7 @@ static inline void tep_set_long_size(struct tep_handle *pevent, int long_size)
 	pevent->long_size = long_size;
 }
 
-static inline int pevent_get_page_size(struct tep_handle *pevent)
+static inline int tep_get_page_size(struct tep_handle *pevent)
 {
 	return pevent->page_size;
 }
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index 39859cee7712..c837a73c03e6 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -390,7 +390,7 @@ load_plugins(struct tep_handle *pevent, const char *suffix,
 	char *envdir;
 	int ret;
 
-	if (pevent->flags & PEVENT_DISABLE_PLUGINS)
+	if (pevent->flags & TEP_DISABLE_PLUGINS)
 		return;
 
 	/*
@@ -398,7 +398,7 @@ load_plugins(struct tep_handle *pevent, const char *suffix,
 	 * check that first.
 	 */
 #ifdef PLUGIN_DIR
-	if (!(pevent->flags & PEVENT_DISABLE_SYS_PLUGINS))
+	if (!(pevent->flags & TEP_DISABLE_SYS_PLUGINS))
 		load_plugins_dir(pevent, suffix, PLUGIN_DIR,
 				 load_plugin, data);
 #endif
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 73c073ade71c..b63bca4b0c2a 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -1974,7 +1974,7 @@ int cmd_kmem(int argc, const char **argv)
 			goto out_delete;
 		}
 
-		kmem_page_size = pevent_get_page_size(evsel->tp_format->pevent);
+		kmem_page_size = tep_get_page_size(evsel->tp_format->pevent);
 		symbol_conf.use_callchain = true;
 	}
 
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 68a8ceded9fa..5df69956484f 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -439,7 +439,7 @@ ssize_t trace_report(int fd, struct trace_event *tevent, bool __repipe)
 
 	pevent = tevent->pevent;
 
-	tep_set_flag(pevent, PEVENT_NSEC_OUTPUT);
+	tep_set_flag(pevent, TEP_NSEC_OUTPUT);
 	tep_set_file_bigendian(pevent, file_bigendian);
 	tep_set_host_bigendian(pevent, host_bigendian);
 
diff --git a/tools/perf/util/trace-event.c b/tools/perf/util/trace-event.c
index 3102e8be81f5..58bb72f266f3 100644
--- a/tools/perf/util/trace-event.c
+++ b/tools/perf/util/trace-event.c
@@ -47,7 +47,7 @@ static int trace_event__init2(void)
 		return -1;
 
 	pevent = tevent.pevent;
-	tep_set_flag(pevent, PEVENT_NSEC_OUTPUT);
+	tep_set_flag(pevent, TEP_NSEC_OUTPUT);
 	tep_set_file_bigendian(pevent, be);
 	tep_set_host_bigendian(pevent, be);
 	tevent_initialized = true;
-- 
2.17.1
