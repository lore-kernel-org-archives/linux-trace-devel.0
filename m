Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44080 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbeHTRvN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 13:51:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id r16-v6so13166286wrt.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Aug 2018 07:35:19 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 06/24] trace-cmd: Rename pevent parse APIs
Date: Mon, 20 Aug 2018 17:34:47 +0300
Message-Id: <20180820143505.11525-7-tz.stoyanov@gmail.com>
In-Reply-To: <20180820143505.11525-1-tz.stoyanov@gmail.com>
References: <20180820143505.11525-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_parse_event, pevent_parse_format, pevent_parse_header_page

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h | 18 +++++++++---------
 lib/trace-cmd/trace-blk-hack.c   |  2 +-
 lib/trace-cmd/trace-input.c      |  6 +++---
 lib/trace-cmd/trace-util.c       |  4 ++--
 lib/traceevent/event-parse.c     | 22 +++++++++++-----------
 tracecmd/trace-record.c          |  4 ++--
 6 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index db910b5..93b040e 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -627,15 +627,15 @@ void pevent_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 void pevent_print_event(struct tep_handle *pevent, struct trace_seq *s,
 			struct tep_record *record, bool use_trace_clock);
 
-int pevent_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
-			     int long_size);
-
-enum pevent_errno pevent_parse_event(struct tep_handle *pevent, const char *buf,
-				     unsigned long size, const char *sys);
-enum pevent_errno pevent_parse_format(struct tep_handle *pevent,
-				      struct event_format **eventp,
-				      const char *buf,
-				      unsigned long size, const char *sys);
+int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
+			  int long_size);
+
+enum pevent_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
+				  unsigned long size, const char *sys);
+enum pevent_errno tep_parse_format(struct tep_handle *pevent,
+				   struct event_format **eventp,
+				   const char *buf,
+				   unsigned long size, const char *sys);
 void pevent_free_format(struct event_format *event);
 void pevent_free_format_field(struct format_field *field);
 
diff --git a/lib/trace-cmd/trace-blk-hack.c b/lib/trace-cmd/trace-blk-hack.c
index 9dec648..2883c68 100644
--- a/lib/trace-cmd/trace-blk-hack.c
+++ b/lib/trace-cmd/trace-blk-hack.c
@@ -139,7 +139,7 @@ int tracecmd_blk_hack(struct tracecmd_input *handle)
 
 	/* Parse this event */
 	l += r;
-	pevent_parse_event(pevent, buf, l, "ftrace");
+	tep_parse_event(pevent, buf, l, "ftrace");
 
 	return 0;
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ad6fc90..ef55177 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -333,7 +333,7 @@ static int read_header_files(struct tracecmd_input *handle)
 	if (do_read_check(handle, header, size))
 		goto failed_read;
 
-	pevent_parse_header_page(pevent, header, size, handle->long_size);
+	tep_parse_header_page(pevent, header, size, handle->long_size);
 	free(header);
 
 	/*
@@ -421,7 +421,7 @@ static int read_ftrace_file(struct tracecmd_input *handle,
 		if (print || regex_event_buf(buf, size, epreg))
 			printf("%.*s\n", (int)size, buf);
 	} else {
-		if (pevent_parse_event(pevent, buf, size, "ftrace"))
+		if (tep_parse_event(pevent, buf, size, "ftrace"))
 			pevent->parsing_failures = 1;
 	}
 	free(buf);
@@ -455,7 +455,7 @@ static int read_event_file(struct tracecmd_input *handle,
 			printf("%.*s\n", (int)size, buf);
 		}
 	} else {
-		if (pevent_parse_event(pevent, buf, size, system))
+		if (tep_parse_event(pevent, buf, size, system))
 			pevent->parsing_failures = 1;
 	}
 	free(buf);
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 2058dc3..7d4a2a4 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -1077,7 +1077,7 @@ static int load_events(struct tep_handle *pevent, const char *system,
 		if (len < 0)
 			goto free_format;
 
-		ret = pevent_parse_event(pevent, buf, len, system);
+		ret = tep_parse_event(pevent, buf, len, system);
 		free(buf);
  free_format:
 		free(format);
@@ -1109,7 +1109,7 @@ static int read_header(struct tep_handle *pevent, const char *events_dir)
 	if (len < 0)
 		goto out;
 
-	pevent_parse_header_page(pevent, buf, len, sizeof(long));
+	tep_parse_header_page(pevent, buf, len, sizeof(long));
 
 	free(buf);
 
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 9142f28..49689b2 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -5916,7 +5916,7 @@ static void parse_header_field(const char *field,
 }
 
 /**
- * pevent_parse_header_page - parse the data stored in the header page
+ * tep_parse_header_page - parse the data stored in the header page
  * @pevent: the handle to the pevent
  * @buf: the buffer storing the header page format string
  * @size: the size of @buf
@@ -5927,8 +5927,8 @@ static void parse_header_field(const char *field,
  *
  * /sys/kernel/debug/tracing/events/header_page
  */
-int pevent_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
-			     int long_size)
+int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
+			  int long_size)
 {
 	int ignore;
 
@@ -6157,7 +6157,7 @@ event_add_failed:
 }
 
 /**
- * pevent_parse_format - parse the event format
+ * tep_parse_format - parse the event format
  * @pevent: the handle to the pevent
  * @eventp: returned format
  * @buf: the buffer storing the event format string
@@ -6171,16 +6171,16 @@ event_add_failed:
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum pevent_errno pevent_parse_format(struct tep_handle *pevent,
-				      struct event_format **eventp,
-				      const char *buf,
-				      unsigned long size, const char *sys)
+enum pevent_errno tep_parse_format(struct tep_handle *pevent,
+				   struct event_format **eventp,
+				   const char *buf,
+				   unsigned long size, const char *sys)
 {
 	return __pevent_parse_event(pevent, eventp, buf, size, sys);
 }
 
 /**
- * pevent_parse_event - parse the event format
+ * tep_parse_event - parse the event format
  * @pevent: the handle to the pevent
  * @buf: the buffer storing the event format string
  * @size: the size of @buf
@@ -6193,8 +6193,8 @@ enum pevent_errno pevent_parse_format(struct tep_handle *pevent,
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum pevent_errno pevent_parse_event(struct tep_handle *pevent, const char *buf,
-				     unsigned long size, const char *sys)
+enum pevent_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
+				  unsigned long size, const char *sys)
 {
 	struct event_format *event = NULL;
 	return __pevent_parse_event(pevent, &event, buf, size, sys);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5e57f4a..6952492 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3506,7 +3506,7 @@ static char *get_date_to_ts(void)
 	buf = read_file("events/header_page", &size);
 	if (!buf)
 		goto out_pevent;
-	ret = pevent_parse_header_page(pevent, buf, size, sizeof(unsigned long));
+	ret = tep_parse_header_page(pevent, buf, size, sizeof(unsigned long));
 	free(buf);
 	if (ret < 0) {
 		warning("Can't parse header page, --date ignored");
@@ -3517,7 +3517,7 @@ static char *get_date_to_ts(void)
 	buf = read_file("events/ftrace/print/format", &size);
 	if (!buf)
 		goto out_pevent;
-	ret = pevent_parse_event(pevent, buf, size, "ftrace");
+	ret = tep_parse_event(pevent, buf, size, "ftrace");
 	free(buf);
 	if (ret < 0) {
 		warning("Can't parse print event, --date ignored");
-- 
2.17.1
