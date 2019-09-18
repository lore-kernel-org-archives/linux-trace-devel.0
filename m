Return-Path: <SRS0=S2sz=XN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A57C4CECD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 02:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ECAD214AF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 02:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfIRCFf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 22:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbfIRCFe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 22:05:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD8DC218AC;
        Wed, 18 Sep 2019 02:05:31 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1iAPLW-0000rz-U7; Tue, 17 Sep 2019 22:05:30 -0400
Message-Id: <20190918020530.818038260@goodmis.org>
User-Agent: quilt/0.65
Date:   Tue, 17 Sep 2019 22:03:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Patrick McLean <chutzpah@gentoo.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/5] libtraceevent, perf tools: Changes in tep_print_event_* APIs
References: <20190918020334.344561631@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Libtraceevent APIs for printing various trace events information are
complicated, there are complex extra parameters. To control the way
event information is printed, the user should call a set of functions in
a specific sequence.

These APIs are reimplemented to provide a more simple interface for
printing event information.

Removed APIs:

 	tep_print_event_task()
	tep_print_event_time()
	tep_print_event_data()
	tep_event_info()
	tep_is_latency_format()
	tep_set_latency_format()
	tep_data_latency_format()
	tep_set_print_raw()

A new API for printing event information is introduced:
   void tep_print_event(struct tep_handle *tep, struct trace_seq *s,
		        struct tep_record *record, const char *fmt, ...);
where "fmt" is a printf-like format string, followed by the event
fields to be printed. Supported fields:
 TEP_PRINT_PID, "%d" - event PID
 TEP_PRINT_CPU, "%d" - event CPU
 TEP_PRINT_COMM, "%s" - event command string
 TEP_PRINT_NAME, "%s" - event name
 TEP_PRINT_LATENCY, "%s" - event latency
 TEP_PRINT_TIME, %d - event time stamp. A divisor and precision
   can be specified as part of this format string:
   "%precision.divisord". Example:
   "%3.1000d" - divide the time by 1000 and print the first 3 digits
   before the dot. Thus, the time stamp "123456000" will be printed as
   "123.456"
 TEP_PRINT_INFO, "%s" - event information.
 TEP_PRINT_INFO_RAW, "%s" - event information, in raw format.

Example:
  tep_print_event(tep, s, record, "%16s-%-5d [%03d] %s %6.1000d %s %s",
		  TEP_PRINT_COMM, TEP_PRINT_PID, TEP_PRINT_CPU,
		  TEP_PRINT_LATENCY, TEP_PRINT_TIME, TEP_PRINT_NAME, TEP_PRINT_INFO);
Output:
	ls-11314 [005] d.h. 185207.366383 function __wake_up

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Cc: Patrick McLean <chutzpah@gentoo.org>
Link: http://lore.kernel.org/linux-trace-devel/20190801074959.22023-2-tz.stoyanov@gmail.com
Link: http://lore.kernel.org/lkml/20190805204355.041132030@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[ Added support for trace-cmd trace-read.c ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/traceevent/event-parse.h   |  29 +--
 lib/traceevent/event-parse-api.c   |  40 ----
 lib/traceevent/event-parse-local.h |   4 -
 lib/traceevent/event-parse.c       | 322 +++++++++++++++++------------
 tracecmd/trace-read.c              |  78 ++++---
 5 files changed, 250 insertions(+), 223 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 99da5ef89c83..5dff952d1ea1 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -436,18 +436,18 @@ int tep_register_print_string(struct tep_handle *tep, const char *fmt,
 			      unsigned long long addr);
 bool tep_is_pid_registered(struct tep_handle *tep, int pid);
 
-void tep_print_event_task(struct tep_handle *tep, struct trace_seq *s,
-			  struct tep_event *event,
-			  struct tep_record *record);
-void tep_print_event_time(struct tep_handle *tep, struct trace_seq *s,
-			  struct tep_event *event,
-			  struct tep_record *record,
-			  bool use_trace_clock);
-void tep_print_event_data(struct tep_handle *tep, struct trace_seq *s,
-			  struct tep_event *event,
-			  struct tep_record *record);
+#define TEP_PRINT_INFO		"INFO"
+#define TEP_PRINT_INFO_RAW	"INFO_RAW"
+#define TEP_PRINT_COMM		"COMM"
+#define TEP_PRINT_LATENCY	"LATENCY"
+#define TEP_PRINT_NAME		"NAME"
+#define TEP_PRINT_PID		1U
+#define TEP_PRINT_TIME		2U
+#define TEP_PRINT_CPU		3U
+
 void tep_print_event(struct tep_handle *tep, struct trace_seq *s,
-		     struct tep_record *record, bool use_trace_clock);
+		     struct tep_record *record, const char *fmt, ...)
+	__attribute__ ((format (printf, 4, 5)));
 
 int tep_parse_header_page(struct tep_handle *tep, char *buf, unsigned long size,
 			  int long_size);
@@ -520,8 +520,6 @@ tep_find_event_by_name(struct tep_handle *tep, const char *sys, const char *name
 struct tep_event *
 tep_find_event_by_record(struct tep_handle *tep, struct tep_record *record);
 
-void tep_data_latency_format(struct tep_handle *tep,
-			     struct trace_seq *s, struct tep_record *record);
 int tep_data_type(struct tep_handle *tep, struct tep_record *rec);
 int tep_data_pid(struct tep_handle *tep, struct tep_record *rec);
 int tep_data_preempt_count(struct tep_handle *tep, struct tep_record *rec);
@@ -536,8 +534,6 @@ void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field);
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event *event);
-void tep_event_info(struct trace_seq *s, struct tep_event *event,
-		    struct tep_record *record);
 int tep_strerror(struct tep_handle *tep, enum tep_errno errnum,
 		 char *buf, size_t buflen);
 
@@ -562,12 +558,9 @@ bool tep_is_file_bigendian(struct tep_handle *tep);
 void tep_set_file_bigendian(struct tep_handle *tep, enum tep_endian endian);
 bool tep_is_local_bigendian(struct tep_handle *tep);
 void tep_set_local_bigendian(struct tep_handle *tep, enum tep_endian endian);
-bool tep_is_latency_format(struct tep_handle *tep);
-void tep_set_latency_format(struct tep_handle *tep, int lat);
 int tep_get_header_page_size(struct tep_handle *tep);
 int tep_get_header_timestamp_size(struct tep_handle *tep);
 bool tep_is_old_format(struct tep_handle *tep);
-void tep_set_print_raw(struct tep_handle *tep, int print_raw);
 void tep_set_test_filters(struct tep_handle *tep, int test_filters);
 
 struct tep_handle *tep_alloc(void);
diff --git a/lib/traceevent/event-parse-api.c b/lib/traceevent/event-parse-api.c
index 988587840c80..4faf52a65791 100644
--- a/lib/traceevent/event-parse-api.c
+++ b/lib/traceevent/event-parse-api.c
@@ -302,33 +302,6 @@ void tep_set_local_bigendian(struct tep_handle *tep, enum tep_endian endian)
 		tep->host_bigendian = endian;
 }
 
-/**
- * tep_is_latency_format - get if the latency output format is configured
- * @tep: a handle to the tep_handle
- *
- * This returns true if the latency output format is configured
- * If @tep is NULL, false is returned.
- */
-bool tep_is_latency_format(struct tep_handle *tep)
-{
-	if (tep)
-		return (tep->latency_format);
-	return false;
-}
-
-/**
- * tep_set_latency_format - set the latency output format
- * @tep: a handle to the tep_handle
- * @lat: non zero for latency output format
- *
- * This sets the latency output format
-  */
-void tep_set_latency_format(struct tep_handle *tep, int lat)
-{
-	if (tep)
-		tep->latency_format = lat;
-}
-
 /**
  * tep_is_old_format - get if an old kernel is used
  * @tep: a handle to the tep_handle
@@ -344,19 +317,6 @@ bool tep_is_old_format(struct tep_handle *tep)
 	return false;
 }
 
-/**
- * tep_set_print_raw - set a flag to force print in raw format
- * @tep: a handle to the tep_handle
- * @print_raw: the new value of the print_raw flag
- *
- * This sets a flag to force print in raw format
- */
-void tep_set_print_raw(struct tep_handle *tep, int print_raw)
-{
-	if (tep)
-		tep->print_raw = print_raw;
-}
-
 /**
  * tep_set_test_filters - set a flag to test a filter string
  * @tep: a handle to the tep_handle
diff --git a/lib/traceevent/event-parse-local.h b/lib/traceevent/event-parse-local.h
index 09aa142f7fdd..6e58ee1fe7c8 100644
--- a/lib/traceevent/event-parse-local.h
+++ b/lib/traceevent/event-parse-local.h
@@ -28,8 +28,6 @@ struct tep_handle {
 	enum tep_endian file_bigendian;
 	enum tep_endian host_bigendian;
 
-	int latency_format;
-
 	int old_format;
 
 	int cpus;
@@ -70,8 +68,6 @@ struct tep_handle {
 	int ld_offset;
 	int ld_size;
 
-	int print_raw;
-
 	int test_filters;
 
 	int flags;
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 3e83636076b2..d1085aab9c43 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -5212,24 +5212,20 @@ out_failed:
 	}
 }
 
-/**
- * tep_data_latency_format - parse the data for the latency format
- * @tep: a handle to the trace event parser context
- * @s: the trace_seq to write to
- * @record: the record to read from
- *
+/*
  * This parses out the Latency format (interrupts disabled,
  * need rescheduling, in hard/soft interrupt, preempt count
  * and lock depth) and places it into the trace_seq.
  */
-void tep_data_latency_format(struct tep_handle *tep,
-			     struct trace_seq *s, struct tep_record *record)
+static void data_latency_format(struct tep_handle *tep, struct trace_seq *s,
+				char *format, struct tep_record *record)
 {
 	static int check_lock_depth = 1;
 	static int check_migrate_disable = 1;
 	static int lock_depth_exists;
 	static int migrate_disable_exists;
 	unsigned int lat_flags;
+	struct trace_seq sq;
 	unsigned int pc;
 	int lock_depth = 0;
 	int migrate_disable = 0;
@@ -5237,6 +5233,7 @@ void tep_data_latency_format(struct tep_handle *tep,
 	int softirq;
 	void *data = record->data;
 
+	trace_seq_init(&sq);
 	lat_flags = parse_common_flags(tep, data);
 	pc = parse_common_pc(tep, data);
 	/* lock_depth may not always exist */
@@ -5264,7 +5261,7 @@ void tep_data_latency_format(struct tep_handle *tep,
 	hardirq = lat_flags & TRACE_FLAG_HARDIRQ;
 	softirq = lat_flags & TRACE_FLAG_SOFTIRQ;
 
-	trace_seq_printf(s, "%c%c%c",
+	trace_seq_printf(&sq, "%c%c%c",
 	       (lat_flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
 	       (lat_flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
 	       'X' : '.',
@@ -5274,24 +5271,32 @@ void tep_data_latency_format(struct tep_handle *tep,
 	       hardirq ? 'h' : softirq ? 's' : '.');
 
 	if (pc)
-		trace_seq_printf(s, "%x", pc);
+		trace_seq_printf(&sq, "%x", pc);
 	else
-		trace_seq_putc(s, '.');
+		trace_seq_printf(&sq, ".");
 
 	if (migrate_disable_exists) {
 		if (migrate_disable < 0)
-			trace_seq_putc(s, '.');
+			trace_seq_printf(&sq, ".");
 		else
-			trace_seq_printf(s, "%d", migrate_disable);
+			trace_seq_printf(&sq, "%d", migrate_disable);
 	}
 
 	if (lock_depth_exists) {
 		if (lock_depth < 0)
-			trace_seq_putc(s, '.');
+			trace_seq_printf(&sq, ".");
 		else
-			trace_seq_printf(s, "%d", lock_depth);
+			trace_seq_printf(&sq, "%d", lock_depth);
 	}
 
+	if (sq.state == TRACE_SEQ__MEM_ALLOC_FAILED) {
+		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;
+		return;
+	}
+
+	trace_seq_terminate(&sq);
+	trace_seq_puts(s, sq.buffer);
+	trace_seq_destroy(&sq);
 	trace_seq_terminate(s);
 }
 
@@ -5452,21 +5457,16 @@ int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline)
 	return cmdline->pid;
 }
 
-/**
- * tep_event_info - parse the data into the print format
- * @s: the trace_seq to write to
- * @event: the handle to the event
- * @record: the record to read from
- *
+/*
  * This parses the raw @data using the given @event information and
  * writes the print format into the trace_seq.
  */
-void tep_event_info(struct trace_seq *s, struct tep_event *event,
-		    struct tep_record *record)
+static void print_event_info(struct trace_seq *s, char *format, bool raw,
+			     struct tep_event *event, struct tep_record *record)
 {
 	int print_pretty = 1;
 
-	if (event->tep->print_raw || (event->flags & TEP_EVENT_FL_PRINTRAW))
+	if (raw || (event->flags & TEP_EVENT_FL_PRINTRAW))
 		tep_print_fields(s, record->data, record->size, event);
 	else {
 
@@ -5481,20 +5481,6 @@ void tep_event_info(struct trace_seq *s, struct tep_event *event,
 	trace_seq_terminate(s);
 }
 
-static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
-{
-	if (!trace_clock || !use_trace_clock)
-		return true;
-
-	if (!strcmp(trace_clock, "local") || !strcmp(trace_clock, "global")
-	    || !strcmp(trace_clock, "uptime") || !strcmp(trace_clock, "perf")
-	    || !strncmp(trace_clock, "mono", 4))
-		return true;
-
-	/* trace_clock is setting in tsc or counter mode */
-	return false;
-}
-
 /**
  * tep_find_event_by_record - return the event from a given record
  * @tep: a handle to the trace event parser context
@@ -5518,129 +5504,195 @@ tep_find_event_by_record(struct tep_handle *tep, struct tep_record *record)
 	return tep_find_event(tep, type);
 }
 
-/**
- * tep_print_event_task - Write the event task comm, pid and CPU
- * @tep: a handle to the trace event parser context
- * @s: the trace_seq to write to
- * @event: the handle to the record's event
- * @record: The record to get the event from
- *
- * Writes the tasks comm, pid and CPU to @s.
+/*
+ * Writes the timestamp of the record into @s. Time divisor and precision can be
+ * specified as part of printf @format string. Example:
+ *	"%3.1000d" - divide the time by 1000 and print the first 3 digits
+ *	before the dot. Thus, the timestamp "123456000" will be printed as
+ *	"123.456"
  */
-void tep_print_event_task(struct tep_handle *tep, struct trace_seq *s,
-			  struct tep_event *event,
-			  struct tep_record *record)
+static void print_event_time(struct tep_handle *tep, struct trace_seq *s,
+				 char *format, struct tep_event *event,
+				 struct tep_record *record)
+{
+	unsigned long long time;
+	char *divstr;
+	int prec = 0, pr;
+	int div = 0;
+	int p10 = 1;
+
+	if (isdigit(*(format + 1)))
+		prec = atoi(format + 1);
+	divstr = strchr(format, '.');
+	if (divstr && isdigit(*(divstr + 1)))
+		div = atoi(divstr + 1);
+	time = record->ts;
+	if (div)
+		time /= div;
+	pr = prec;
+	while (pr--)
+		p10 *= 10;
+
+	if (p10 > 1 && p10 < time)
+		trace_seq_printf(s, "%5llu.%0*llu", time / p10, prec, time % p10);
+	else
+		trace_seq_printf(s, "%12llu\n", time);
+}
+
+struct print_event_type {
+	enum {
+		EVENT_TYPE_INT = 1,
+		EVENT_TYPE_STRING,
+		EVENT_TYPE_UNKNOWN,
+	} type;
+	char format[32];
+};
+
+static void print_string(struct tep_handle *tep, struct trace_seq *s,
+			 struct tep_record *record, struct tep_event *event,
+			 const char *arg, struct print_event_type *type)
 {
-	void *data = record->data;
 	const char *comm;
 	int pid;
 
-	pid = parse_common_pid(tep, data);
-	comm = find_cmdline(tep, pid);
+	if (strncmp(arg, TEP_PRINT_LATENCY, strlen(TEP_PRINT_LATENCY)) == 0) {
+		data_latency_format(tep, s, type->format, record);
+	} else if (strncmp(arg, TEP_PRINT_COMM, strlen(TEP_PRINT_COMM)) == 0) {
+		pid = parse_common_pid(tep, record->data);
+		comm = find_cmdline(tep, pid);
+		trace_seq_printf(s, type->format, comm);
+	} else if (strncmp(arg, TEP_PRINT_INFO_RAW, strlen(TEP_PRINT_INFO_RAW)) == 0) {
+		print_event_info(s, type->format, true, event, record);
+	} else if (strncmp(arg, TEP_PRINT_INFO, strlen(TEP_PRINT_INFO)) == 0) {
+		print_event_info(s, type->format, false, event, record);
+	} else if  (strncmp(arg, TEP_PRINT_NAME, strlen(TEP_PRINT_NAME)) == 0) {
+		trace_seq_printf(s, type->format, event->name);
+	} else {
+		trace_seq_printf(s, "[UNKNOWN TEP TYPE %s]", arg);
+	}
 
-	if (tep->latency_format)
-		trace_seq_printf(s, "%8.8s-%-5d %3d", comm, pid, record->cpu);
-	else
-		trace_seq_printf(s, "%16s-%-5d [%03d]", comm, pid, record->cpu);
 }
 
-/**
- * tep_print_event_time - Write the event timestamp
- * @tep: a handle to the trace event parser context
- * @s: the trace_seq to write to
- * @event: the handle to the record's event
- * @record: The record to get the event from
- * @use_trace_clock: Set to parse according to the @tep->trace_clock
- *
- * Writes the timestamp of the record into @s.
- */
-void tep_print_event_time(struct tep_handle *tep, struct trace_seq *s,
-			  struct tep_event *event,
-			  struct tep_record *record,
-			  bool use_trace_clock)
+static void print_int(struct tep_handle *tep, struct trace_seq *s,
+		      struct tep_record *record, struct tep_event *event,
+		      int arg, struct print_event_type *type)
 {
-	unsigned long secs;
-	unsigned long usecs;
-	unsigned long nsecs;
-	int p;
-	bool use_usec_format;
+	int param;
 
-	use_usec_format = is_timestamp_in_us(tep->trace_clock, use_trace_clock);
-	if (use_usec_format) {
-		secs = record->ts / NSEC_PER_SEC;
-		nsecs = record->ts - secs * NSEC_PER_SEC;
+	switch (arg) {
+	case TEP_PRINT_CPU:
+		param = record->cpu;
+		break;
+	case TEP_PRINT_PID:
+		param = parse_common_pid(tep, record->data);
+		break;
+	case TEP_PRINT_TIME:
+		return print_event_time(tep, s, type->format, event, record);
+	default:
+		return;
 	}
+	trace_seq_printf(s, type->format, param);
+}
 
-	if (tep->latency_format) {
-		tep_data_latency_format(tep, s, record);
-	}
+static int tep_print_event_param_type(char *format,
+				      struct print_event_type *type)
+{
+	char *str = format + 1;
+	int i = 1;
 
-	if (use_usec_format) {
-		if (tep->flags & TEP_NSEC_OUTPUT) {
-			usecs = nsecs;
-			p = 9;
-		} else {
-			usecs = (nsecs + 500) / NSEC_PER_USEC;
-			/* To avoid usecs larger than 1 sec */
-			if (usecs >= USEC_PER_SEC) {
-				usecs -= USEC_PER_SEC;
-				secs++;
-			}
-			p = 6;
+	type->type = EVENT_TYPE_UNKNOWN;
+	while (*str) {
+		switch (*str) {
+		case 'd':
+		case 'u':
+		case 'i':
+		case 'x':
+		case 'X':
+		case 'o':
+			type->type = EVENT_TYPE_INT;
+			break;
+		case 's':
+			type->type = EVENT_TYPE_STRING;
+			break;
 		}
-
-		trace_seq_printf(s, " %5lu.%0*lu:", secs, p, usecs);
-	} else
-		trace_seq_printf(s, " %12llu:", record->ts);
+		str++;
+		i++;
+		if (type->type != EVENT_TYPE_UNKNOWN)
+			break;
+	}
+	memset(type->format, 0, 32);
+	memcpy(type->format, format, i < 32 ? i : 31);
+	return i;
 }
 
 /**
- * tep_print_event_data - Write the event data section
+ * tep_print_event - Write various event information
  * @tep: a handle to the trace event parser context
  * @s: the trace_seq to write to
- * @event: the handle to the record's event
  * @record: The record to get the event from
- *
- * Writes the parsing of the record's data to @s.
+ * @format: a printf format string. Supported event fileds:
+ *	TEP_PRINT_PID, "%d" - event PID
+ *	TEP_PRINT_CPU, "%d" - event CPU
+ *	TEP_PRINT_COMM, "%s" - event command string
+ *	TEP_PRINT_NAME, "%s" - event name
+ *	TEP_PRINT_LATENCY, "%s" - event latency
+ *	TEP_PRINT_TIME, %d - event time stamp. A divisor and precision
+ *			can be specified as part of this format string:
+ *			"%precision.divisord". Example:
+ *			"%3.1000d" - divide the time by 1000 and print the first
+ *			3 digits before the dot. Thus, the time stamp
+ *			"123456000" will be printed as "123.456"
+ *	TEP_PRINT_INFO, "%s" - event information. If any width is specified in
+ *			the format string, the event information will be printed
+ *			in raw format.
+ * Writes the specified event information into @s.
  */
-void tep_print_event_data(struct tep_handle *tep, struct trace_seq *s,
-			  struct tep_event *event,
-			  struct tep_record *record)
-{
-	static const char *spaces = "                    "; /* 20 spaces */
-	int len;
-
-	trace_seq_printf(s, " %s: ", event->name);
-
-	/* Space out the event names evenly. */
-	len = strlen(event->name);
-	if (len < 20)
-		trace_seq_printf(s, "%.*s", 20 - len, spaces);
-
-	tep_event_info(s, event, record);
-}
-
 void tep_print_event(struct tep_handle *tep, struct trace_seq *s,
-		     struct tep_record *record, bool use_trace_clock)
-{
+		     struct tep_record *record, const char *fmt, ...)
+{
+	struct print_event_type type;
+	char *format = strdup(fmt);
+	char *current = format;
+	char *str = format;
+	int offset;
+	va_list args;
 	struct tep_event *event;
 
-	event = tep_find_event_by_record(tep, record);
-	if (!event) {
-		int i;
-		int type = trace_parse_common_type(tep, record->data);
-
-		do_warning("ug! no event found for type %d", type);
-		trace_seq_printf(s, "[UNKNOWN TYPE %d]", type);
-		for (i = 0; i < record->size; i++)
-			trace_seq_printf(s, " %02x",
-					 ((unsigned char *)record->data)[i]);
+	if (!format)
 		return;
-	}
 
-	tep_print_event_task(tep, s, event, record);
-	tep_print_event_time(tep, s, event, record, use_trace_clock);
-	tep_print_event_data(tep, s, event, record);
+	event = tep_find_event_by_record(tep, record);
+	va_start(args, fmt);
+	while (*current) {
+		current = strchr(str, '%');
+		if (!current) {
+			trace_seq_puts(s, str);
+			break;
+		}
+		memset(&type, 0, sizeof(type));
+		offset = tep_print_event_param_type(current, &type);
+		*current = '\0';
+		trace_seq_puts(s, str);
+		current += offset;
+		switch (type.type) {
+		case EVENT_TYPE_STRING:
+			print_string(tep, s, record, event,
+				     va_arg(args, char*), &type);
+			break;
+		case EVENT_TYPE_INT:
+			print_int(tep, s, record, event,
+				  va_arg(args, int), &type);
+			break;
+		case EVENT_TYPE_UNKNOWN:
+		default:
+			trace_seq_printf(s, "[UNKNOWN TYPE]");
+			break;
+		}
+		str = current;
+
+	}
+	va_end(args);
+	free(format);
 }
 
 static int events_id_cmp(const void *a, const void *b)
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 01d904964edf..4958fa81c834 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -100,6 +100,9 @@ static int no_softirqs;
 
 static int tsdiff;
 
+static int latency_format;
+static const char *format_type = TEP_PRINT_INFO;
+
 static struct tep_format_field *wakeup_task;
 static struct tep_format_field *wakeup_success;
 static struct tep_format_field *wakeup_new_task;
@@ -125,6 +128,35 @@ static struct hook_list *last_hook;
 #define WAKEUP_HASH_SIZE 1024
 static struct trace_hash wakeup_hash;
 
+static void print_event_name(struct trace_seq *s, struct tep_event *event)
+{
+	static const char *spaces = "                    "; /* 20 spaces */
+	int len;
+
+	trace_seq_printf(s, " %s: ", event->name);
+
+	/* Space out the event names evenly. */
+	len = strlen(event->name);
+	if (len < 20)
+		trace_seq_printf(s, "%.*s", 20 - len, spaces);
+}
+
+static void print_event(struct trace_seq *s, struct tracecmd_input *handle,
+			struct tep_record *record)
+{
+	struct tep_handle *tep = tracecmd_get_pevent(handle);
+	struct tep_event *event;
+	const char *lfmt = latency_format ? "%8.8s-%-5d %3d" : "%16s-%-5d [%03d]";
+	const char *tfmt = tracecmd_get_flags(handle) & TRACECMD_FL_IN_USECS ? " %6.1000d:" : "%12d:";
+
+	event = tep_find_event_by_record(tep, record);
+	tep_print_event(tep, s, record, lfmt, TEP_PRINT_COMM,
+			TEP_PRINT_PID, TEP_PRINT_CPU);
+	tep_print_event(tep, s, record, tfmt, TEP_PRINT_TIME);
+	print_event_name(s, event);
+	tep_print_event(tep, s, record, "%s", format_type);
+}
+
 /* Debug variables for testing tracecmd_read_at */
 #define TEST_READ_AT 0
 #if TEST_READ_AT
@@ -134,22 +166,18 @@ static int test_read_at_copy = 100;
 static int test_read_at_index;
 static void show_test(struct tracecmd_input *handle)
 {
-	struct tep_handle *pevent;
 	struct tep_record *record;
 	struct trace_seq s;
-	int cpu;
 
 	if (!test_read_at_offset) {
 		printf("\nNO RECORD COPIED\n");
 		return;
 	}
 
-	pevent = tracecmd_get_pevent(handle);
-
-	record = tracecmd_read_at(handle, test_read_at_offset, &cpu);
+	record = tracecmd_read_at(handle, test_read_at_offset, NULL);
 	printf("\nHERE'S THE COPY RECORD\n");
 	trace_seq_init(&s);
-	tep_print_event(pevent, &s, cpu, record->data, record->size, record->ts);
+	print_event(&s, handle, record);
 	trace_seq_do_printf(&s);
 	trace_seq_destroy(&s);
 	printf("\n");
@@ -176,7 +204,6 @@ static int test_at_timestamp_cpu = -1;
 static int test_at_timestamp_index;
 static void show_test(struct tracecmd_input *handle)
 {
-	struct tep_handle *pevent;
 	struct tep_record *record;
 	struct trace_seq s;
 	int cpu = test_at_timestamp_cpu;
@@ -186,8 +213,6 @@ static void show_test(struct tracecmd_input *handle)
 		return;
 	}
 
-	pevent = tracecmd_get_pevent(handle);
-
 	if (tracecmd_set_cpu_to_timestamp(handle, cpu, test_at_timestamp_ts))
 		return;
 
@@ -196,7 +221,7 @@ static void show_test(struct tracecmd_input *handle)
 	       (void *)(record->offset & ~(page_size - 1)),
 	       (void *)record->offset);
 	trace_seq_init(&s);
-	tep_print_event(pevent, &s, cpu, record->data, record->size, record->ts);
+	print_event(&s, handle, record);
 	trace_seq_do_printf(&s);
 	trace_seq_destroy(&s);
 	printf("\n");
@@ -221,13 +246,10 @@ static void test_save(struct tep_record *record, int cpu)
 #define DO_TEST
 static void show_test(struct tracecmd_input *handle)
 {
-	struct tep_handle *pevent;
 	struct tep_record *record;
 	struct trace_seq s;
 	int cpu = 0;
 
-	pevent = tracecmd_get_pevent(handle);
-
 	record = tracecmd_read_cpu_first(handle, cpu);
 	if (!record) {
 		printf("No first record?\n");
@@ -237,7 +259,7 @@ static void show_test(struct tracecmd_input *handle)
 	printf("\nHERE'S THE FIRST RECORD with offset %p\n",
 	       (void *)record->offset);
 	trace_seq_init(&s);
-	tep_print_event(pevent, &s, cpu, record->data, record->size, record->ts);
+	print_event(&s, handle, record);
 	trace_seq_do_printf(&s);
 	trace_seq_destroy(&s);
 	printf("\n");
@@ -253,7 +275,7 @@ static void show_test(struct tracecmd_input *handle)
 	printf("\nHERE'S THE LAST RECORD with offset %p\n",
 	       (void *)record->offset);
 	trace_seq_init(&s);
-	tep_print_event(pevent, &s, cpu, record->data, record->size, record->ts);
+	print_event(&s, handle, record);
 	trace_seq_do_printf(&s);
 	trace_seq_destroy(&s);
 	printf("\n");
@@ -268,6 +290,9 @@ static void test_save(struct tep_record *record, int cpu)
 #ifndef DO_TEST
 static void show_test(struct tracecmd_input *handle)
 {
+	/* quiet the compiler */
+	if (0)
+		print_event(NULL, NULL, NULL);
 }
 static void test_save(struct tep_record *record, int cpu)
 {
@@ -756,6 +781,8 @@ static void finish_wakeup(void)
 void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 {
 	tracecmd_show_data_func func = tracecmd_get_show_data_func(handle);
+	const char *lfmt = latency_format ? "%8.8s-%-5d %3d" : "%16s-%-5d [%03d]";
+	const char *tfmt = tracecmd_get_flags(handle) & TRACECMD_FL_IN_USECS ? " %6.1000d:" : "%12d:";
 	struct tep_handle *pevent;
 	struct tep_event *event;
 	struct trace_seq s;
@@ -776,6 +803,8 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 	}
 
 	pevent = tracecmd_get_pevent(handle);
+	event = tep_find_event_by_record(pevent, record);
+	use_trace_clock = tracecmd_get_use_trace_clock(handle);
 
 	trace_seq_init(&s);
 	if (record->missed_events > 0)
@@ -793,11 +822,11 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 			trace_seq_putc(&s, '\n');
 		}
 	}
-	use_trace_clock = tracecmd_get_use_trace_clock(handle);
-	event = tep_find_event_by_record(pevent, record);
-	tep_print_event_task(pevent, &s, event, record);
-	tep_print_event_time(pevent, &s, event, record,
-			     use_trace_clock);
+
+	tep_print_event(pevent, &s, record, lfmt, TEP_PRINT_COMM,
+			TEP_PRINT_PID, TEP_PRINT_CPU);
+	tep_print_event(pevent, &s, record, tfmt, TEP_PRINT_TIME);
+
 	if (tsdiff) {
 		unsigned long long rec_ts = record->ts;
 
@@ -813,7 +842,8 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 		trace_seq_printf(&s, " %-8s", buf);
 	}
 
-	tep_print_event_data(pevent, &s, event, record);
+	print_event_name(&s, event);
+	tep_print_event(pevent, &s, record, "%s", format_type);
 
 	if (s.len && *(s.buffer + s.len - 1) == '\n')
 		s.len--;
@@ -1433,7 +1463,6 @@ void trace_report (int argc, char **argv)
 	int show_printk = 0;
 	int show_uname = 0;
 	int show_version = 0;
-	int latency_format = 0;
 	int show_events = 0;
 	int print_events = 0;
 	int nanosec = 0;
@@ -1703,7 +1732,7 @@ void trace_report (int argc, char **argv)
 			tep_set_flag(pevent, TEP_NSEC_OUTPUT);
 
 		if (raw)
-			tep_set_print_raw(pevent, 1);
+			format_type = TEP_PRINT_INFO_RAW;
 
 		if (test_filters_mode)
 			tep_set_test_filters(pevent, 1);
@@ -1767,9 +1796,6 @@ void trace_report (int argc, char **argv)
 		set_event_flags(pevent, raw_events, TEP_EVENT_FL_PRINTRAW);
 	}
 
-	if (latency_format)
-		tep_set_latency_format(pevent, latency_format);
-
 	otype = OUTPUT_NORMAL;
 
 	if (show_stat)
-- 
2.20.1


