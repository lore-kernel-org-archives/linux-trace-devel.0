Return-Path: <SRS0=yn/p=LE=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36776 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbeHUQx7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Aug 2018 12:53:59 -0400
Received: by mail-wm0-f67.google.com with SMTP id w24-v6so2886262wmc.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Aug 2018 06:33:49 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/24] tools lib traceevent, perf tools: Rename 'enum pevent_flag' to 'enum tep_flag'
Date: Tue, 21 Aug 2018 16:33:16 +0300
Message-Id: <20180821133328.3249-13-tz.stoyanov@gmail.com>
In-Reply-To: <20180821133328.3249-1-tz.stoyanov@gmail.com>
References: <20180821133328.3249-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
pevent_get_page_size API and enum pevent_flag to enum tep_flag

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180808180701.623942406@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h | 10 +++++-----
 lib/traceevent/event-parse.c     |  2 +-
 lib/traceevent/event-plugin.c    |  4 ++--
 tracecmd/trace-read.c            |  4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 979ac97..3df714f 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -359,10 +359,10 @@ enum pevent_func_arg_type {
 	PEVENT_FUNC_ARG_MAX_TYPES
 };
 
-enum pevent_flag {
-	PEVENT_NSEC_OUTPUT		= 1,	/* output in NSECS */
-	PEVENT_DISABLE_SYS_PLUGINS	= 1 << 1,
-	PEVENT_DISABLE_PLUGINS		= 1 << 2,
+enum tep_flag {
+	TEP_NSEC_OUTPUT		= 1,	/* output in NSECS */
+	TEP_DISABLE_SYS_PLUGINS	= 1 << 1,
+	TEP_DISABLE_PLUGINS	= 1 << 2,
 };
 
 #define PEVENT_ERRORS 							      \
@@ -739,7 +739,7 @@ static inline void tep_set_long_size(struct tep_handle *pevent, int long_size)
 	pevent->long_size = long_size;
 }
 
-static inline int pevent_get_page_size(struct tep_handle *pevent)
+static inline int tep_get_page_size(struct tep_handle *pevent)
 {
 	return pevent->page_size;
 }
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 0dc3dc5..004ac88 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -5501,7 +5501,7 @@ void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 	}
 
 	if (use_usec_format) {
-		if (pevent->flags & PEVENT_NSEC_OUTPUT) {
+		if (pevent->flags & TEP_NSEC_OUTPUT) {
 			usecs = nsecs;
 			p = 9;
 		} else {
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 35b35dc..aeab162 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -376,7 +376,7 @@ load_plugins(struct tep_handle *pevent, const char *suffix,
 	char *envdir;
 	int ret;
 
-	if (pevent->flags & PEVENT_DISABLE_PLUGINS)
+	if (pevent->flags & TEP_DISABLE_PLUGINS)
 		return;
 
 	/*
@@ -384,7 +384,7 @@ load_plugins(struct tep_handle *pevent, const char *suffix,
 	 * check that first.
 	 */
 #ifdef PLUGIN_DIR
-	if (!(pevent->flags & PEVENT_DISABLE_SYS_PLUGINS))
+	if (!(pevent->flags & TEP_DISABLE_SYS_PLUGINS))
 		load_plugins_dir(pevent, suffix, PLUGIN_DIR,
 				 load_plugin, data);
 #endif
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index a61f6aa..74059a0 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -798,7 +798,7 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 		tep_print_event_time(pevent, &s, event, record,
 					use_trace_clock);
 		buf[0] = 0;
-		if (use_trace_clock && !(pevent->flags & PEVENT_NSEC_OUTPUT))
+		if (use_trace_clock && !(pevent->flags & TEP_NSEC_OUTPUT))
 			rec_ts = (rec_ts + 500) / 1000;
 		if (last_ts) {
 			diff_ts = rec_ts - last_ts;
@@ -1687,7 +1687,7 @@ void trace_report (int argc, char **argv)
 		pevent = tracecmd_get_pevent(handle);
 
 		if (nanosec)
-			pevent->flags |= PEVENT_NSEC_OUTPUT;
+			pevent->flags |= TEP_NSEC_OUTPUT;
 
 		if (raw)
 			pevent->print_raw = 1;
-- 
2.17.1
