Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39620 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389121AbeHAO2J (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 10:28:09 -0400
Received: by mail-wr1-f67.google.com with SMTP id h10-v6so19962351wre.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Aug 2018 05:42:31 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 06/24] tools/lib/traceevent, tools/perf: Rename pevent parse APIs
Date: Wed,  1 Aug 2018 15:41:38 +0300
Message-Id: <20180801124156.20894-7-tz.stoyanov@gmail.com>
In-Reply-To: <20180801124156.20894-1-tz.stoyanov@gmail.com>
References: <20180801124156.20894-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_parse_event, pevent_parse_format, pevent_parse_header_page

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.c  | 12 ++++++------
 tools/lib/traceevent/event-parse.h  |  6 +++---
 tools/perf/util/trace-event-parse.c |  4 ++--
 tools/perf/util/trace-event-read.c  |  2 +-
 tools/perf/util/trace-event.c       |  2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 6610519c5a7f..fb6eac674149 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5930,7 +5930,7 @@ static void parse_header_field(const char *field,
 }
 
 /**
- * pevent_parse_header_page - parse the data stored in the header page
+ * tep_parse_header_page - parse the data stored in the header page
  * @pevent: the handle to the pevent
  * @buf: the buffer storing the header page format string
  * @size: the size of @buf
@@ -5941,7 +5941,7 @@ static void parse_header_field(const char *field,
  *
  * /sys/kernel/debug/tracing/events/header_page
  */
-int pevent_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
+int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
 			     int long_size)
 {
 	int ignore;
@@ -6171,7 +6171,7 @@ __pevent_parse_event(struct tep_handle *pevent,
 }
 
 /**
- * pevent_parse_format - parse the event format
+ * tep_parse_format - parse the event format
  * @pevent: the handle to the pevent
  * @eventp: returned format
  * @buf: the buffer storing the event format string
@@ -6185,7 +6185,7 @@ __pevent_parse_event(struct tep_handle *pevent,
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum pevent_errno pevent_parse_format(struct tep_handle *pevent,
+enum pevent_errno tep_parse_format(struct tep_handle *pevent,
 				      struct event_format **eventp,
 				      const char *buf,
 				      unsigned long size, const char *sys)
@@ -6194,7 +6194,7 @@ enum pevent_errno pevent_parse_format(struct tep_handle *pevent,
 }
 
 /**
- * pevent_parse_event - parse the event format
+ * tep_parse_event - parse the event format
  * @pevent: the handle to the pevent
  * @buf: the buffer storing the event format string
  * @size: the size of @buf
@@ -6207,7 +6207,7 @@ enum pevent_errno pevent_parse_format(struct tep_handle *pevent,
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum pevent_errno pevent_parse_event(struct tep_handle *pevent, const char *buf,
+enum pevent_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
 				     unsigned long size, const char *sys)
 {
 	struct event_format *event = NULL;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 41b12ffb2338..7c90ddac77c5 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -639,12 +639,12 @@ void pevent_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 void pevent_print_event(struct tep_handle *pevent, struct trace_seq *s,
 			struct tep_record *record, bool use_trace_clock);
 
-int pevent_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
+int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
 			     int long_size);
 
-enum pevent_errno pevent_parse_event(struct tep_handle *pevent, const char *buf,
+enum pevent_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
 				     unsigned long size, const char *sys);
-enum pevent_errno pevent_parse_format(struct tep_handle *pevent,
+enum pevent_errno tep_parse_format(struct tep_handle *pevent,
 				      struct event_format **eventp,
 				      const char *buf,
 				      unsigned long size, const char *sys);
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0a769a340fc9..f8b91f3813ca 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -180,13 +180,13 @@ void parse_saved_cmdline(struct tep_handle *pevent,
 
 int parse_ftrace_file(struct tep_handle *pevent, char *buf, unsigned long size)
 {
-	return pevent_parse_event(pevent, buf, size, "ftrace");
+	return tep_parse_event(pevent, buf, size, "ftrace");
 }
 
 int parse_event_file(struct tep_handle *pevent,
 		     char *buf, unsigned long size, char *sys)
 {
-	return pevent_parse_event(pevent, buf, size, sys);
+	return tep_parse_event(pevent, buf, size, sys);
 }
 
 struct event_format *trace_find_next_event(struct tep_handle *pevent,
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 43ba127979e9..b0ba65681558 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -235,7 +235,7 @@ static int read_header_files(struct tep_handle *pevent)
 		return -1;
 	}
 
-	if (!pevent_parse_header_page(pevent, header_page, size,
+	if (!tep_parse_header_page(pevent, header_page, size,
 				      pevent_get_long_size(pevent))) {
 		/*
 		 * The commit field in the page is of type long,
diff --git a/tools/perf/util/trace-event.c b/tools/perf/util/trace-event.c
index 116fffa788b9..eed1c11c1915 100644
--- a/tools/perf/util/trace-event.c
+++ b/tools/perf/util/trace-event.c
@@ -93,7 +93,7 @@ tp_format(const char *sys, const char *name)
 	if (err)
 		return ERR_PTR(err);
 
-	pevent_parse_format(pevent, &event, data, size, sys);
+	tep_parse_format(pevent, &event, data, size, sys);
 
 	free(data);
 	return event;
-- 
2.17.1
