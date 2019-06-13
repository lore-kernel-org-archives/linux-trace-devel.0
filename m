Return-Path: <SRS0=Le/E=UM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A6DC31E45
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC32B206BB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfFMPg5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:36:57 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:38124 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbfFMKPK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 06:15:10 -0400
Received: by mail-wm1-f43.google.com with SMTP id s15so9498577wmj.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jun 2019 03:15:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2PCzvGayseg/qnXiLurWADitimt/637xy3GA2smDUzQ=;
        b=rTzQQ4VA4YJYDfie+dfmOA+CE78iM/wtqwdDt/SYF3dEP9Azc60caqGI2jSjx5mFxb
         M4O8VpudYrmorFjptZwAYw3UGy7s8tVnzAlBa3v8/dd5KA0TF8XVjPun2Hj/fAF9cnTv
         2rtDOJt4veIivnHv3Iyj/ZZAU0+cpBE950Tf4a8fbp4DtLKq9Pqy+FrMajMG1vW4F7C3
         EGO+Y2qcjKUKexLvLBaE/kzxuzaSDpkQEjP63y51ZzhMcHgyKfKTQ8m/6XNF1IyaS21U
         Bnel14Rf8U/+/j/Q+L5SAVtPYqOWKcjbswCXIgx9cAfVVE2ddHWkTdvxRbrWc2Sb6cfN
         5Zvw==
X-Gm-Message-State: APjAAAX+vo26IgCyMqHHewNxSvuP6rffuIWvHcpn0kgZrb/HGo4pS0di
        T3Rn6AWUcl4wBjCAL/j8YB4=
X-Google-Smtp-Source: APXvYqxOI6t3tqA8s5jkmEj30nGyqZ0zfjUjDVB79xYtwLevAK1dcdNnNO8syMd8hnWAIKTlkz3BCw==
X-Received: by 2002:a1c:b782:: with SMTP id h124mr3089001wmf.20.1560420905670;
        Thu, 13 Jun 2019 03:15:05 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t63sm3106418wmt.6.2019.06.13.03.15.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 03:15:05 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] tools/lib/traceevent, tools/perf: Changes in tep_print_event_* APIs
Date:   Thu, 13 Jun 2019 13:15:01 +0300
Message-Id: <20190613101503.22105-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613101503.22105-1-tstoyanov@vmware.com>
References: <20190613101503.22105-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Libtraceevent APIs for printing various trace events information are
complicated, there are complex extra parameters. To control the way
event information is printed, the user should call a set of functions
in a specific sequence.
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
 TEP_PRINT_INFO, "%s" - event information. If any width is specified in
   the format string, the event information will be printed in raw format.

Example:
  tep_print_event(tep, s, record, "%16s-%-5d [%03d] %s %6.1000d %s %s",
		  TEP_PRINT_COMM, TEP_PRINT_PID, TEP_PRINT_CPU,
		  TEP_PRINT_LATENCY, TEP_PRINT_TIME, TEP_PRINT_NAME, TEP_PRINT_INFO);
Output:
	ls-11314 [005] d.h. 185207.366383 function __wake_up

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-api.c   |  40 ---
 tools/lib/traceevent/event-parse-local.h |   4 -
 tools/lib/traceevent/event-parse.c       | 297 ++++++++++++++---------
 tools/lib/traceevent/event-parse.h       |  28 +--
 tools/perf/builtin-kmem.c                |   3 +-
 tools/perf/util/sort.c                   |   3 +-
 tools/perf/util/trace-event-parse.c      |   2 +-
 7 files changed, 193 insertions(+), 184 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
index 988587840c80..4faf52a65791 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
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
diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
index 09aa142f7fdd..6e58ee1fe7c8 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
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
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index b36b536a9fcb..b3dfcc39f606 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5174,14 +5174,15 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
  * tep_data_latency_format - parse the data for the latency format
  * @tep: a handle to the trace event parser context
  * @s: the trace_seq to write to
+ * @format: a printf format string
  * @record: the record to read from
  *
  * This parses out the Latency format (interrupts disabled,
  * need rescheduling, in hard/soft interrupt, preempt count
  * and lock depth) and places it into the trace_seq.
  */
-void tep_data_latency_format(struct tep_handle *tep,
-			     struct trace_seq *s, struct tep_record *record)
+static void tep_data_latency_format(struct tep_handle *tep, struct trace_seq *s,
+				    char *format, struct tep_record *record)
 {
 	static int check_lock_depth = 1;
 	static int check_migrate_disable = 1;
@@ -5193,6 +5194,8 @@ void tep_data_latency_format(struct tep_handle *tep,
 	int migrate_disable = 0;
 	int hardirq;
 	int softirq;
+	char lat_str[32];
+	char str[8];
 	void *data = record->data;
 
 	lat_flags = parse_common_flags(tep, data);
@@ -5222,7 +5225,7 @@ void tep_data_latency_format(struct tep_handle *tep,
 	hardirq = lat_flags & TRACE_FLAG_HARDIRQ;
 	softirq = lat_flags & TRACE_FLAG_SOFTIRQ;
 
-	trace_seq_printf(s, "%c%c%c",
+	snprintf(lat_str, 32, "%c%c%c",
 	       (lat_flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
 	       (lat_flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
 	       'X' : '.',
@@ -5232,24 +5235,27 @@ void tep_data_latency_format(struct tep_handle *tep,
 	       hardirq ? 'h' : softirq ? 's' : '.');
 
 	if (pc)
-		trace_seq_printf(s, "%x", pc);
+		snprintf(str, 8, "%x", pc);
 	else
-		trace_seq_putc(s, '.');
+		snprintf(str, 8, ".");
+	strcat(lat_str, str);
 
 	if (migrate_disable_exists) {
 		if (migrate_disable < 0)
-			trace_seq_putc(s, '.');
+			snprintf(str, 8, ".");
 		else
-			trace_seq_printf(s, "%d", migrate_disable);
+			snprintf(str, 8, "%d", migrate_disable);
+		strcat(lat_str, str);
 	}
 
 	if (lock_depth_exists) {
 		if (lock_depth < 0)
-			trace_seq_putc(s, '.');
+			snprintf(str, 8, ".");
 		else
-			trace_seq_printf(s, "%d", lock_depth);
+			snprintf(str, 8, "%d", lock_depth);
+		strcat(lat_str, str);
 	}
-
+	trace_seq_printf(s, format, lat_str);
 	trace_seq_terminate(s);
 }
 
@@ -5413,18 +5419,20 @@ int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline)
 /**
  * tep_event_info - parse the data into the print format
  * @s: the trace_seq to write to
+ * @format: printf format string. If any precision is specified in the string,
+ *	    print in raw data format
  * @event: the handle to the event
  * @record: the record to read from
  *
  * This parses the raw @data using the given @event information and
  * writes the print format into the trace_seq.
  */
-void tep_event_info(struct trace_seq *s, struct tep_event *event,
-		    struct tep_record *record)
+static void tep_event_info(struct trace_seq *s, char *format,
+			   struct tep_event *event, struct tep_record *record)
 {
 	int print_pretty = 1;
 
-	if (event->tep->print_raw || (event->flags & TEP_EVENT_FL_PRINTRAW))
+	if (isdigit(*(format+1)) || (event->flags & TEP_EVENT_FL_PRINTRAW))
 		tep_print_fields(s, record->data, record->size, event);
 	else {
 
@@ -5439,20 +5447,6 @@ void tep_event_info(struct trace_seq *s, struct tep_event *event,
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
@@ -5477,128 +5471,193 @@ tep_find_event_by_record(struct tep_handle *tep, struct tep_record *record)
 }
 
 /**
- * tep_print_event_task - Write the event task comm, pid and CPU
+ * tep_print_event_time - Write the event timestamp
  * @tep: a handle to the trace event parser context
  * @s: the trace_seq to write to
+ * @format: a printf format string.
+ *	    Time divisor and precision can be specified as part of this format
+ *	    string: "%precision.divisord". Example:
+ *	    "%3.1000d" - divide the time by 1000 and print the first 3 digits
+ *	     before the dot. Thus, the timestamp "123456000" will be printed as
+ *	     "123.456"
  * @event: the handle to the record's event
  * @record: The record to get the event from
  *
- * Writes the tasks comm, pid and CPU to @s.
+ * Writes the timestamp of the record into @s.
  */
-void tep_print_event_task(struct tep_handle *tep, struct trace_seq *s,
-			  struct tep_event *event,
-			  struct tep_record *record)
+static void tep_print_event_time(struct tep_handle *tep, struct trace_seq *s,
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
+		printf("%12llu\n", time);
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
+static void tep_print_string(struct tep_handle *tep, struct trace_seq *s,
+			     struct tep_record *record, struct tep_event *event,
+			     const char *arg, struct print_event_type *type)
 {
-	void *data = record->data;
 	const char *comm;
 	int pid;
 
-	pid = parse_common_pid(tep, data);
-	comm = find_cmdline(tep, pid);
-
-	if (tep->latency_format)
-		trace_seq_printf(s, "%8.8s-%-5d %3d", comm, pid, record->cpu);
-	else
-		trace_seq_printf(s, "%16s-%-5d [%03d]", comm, pid, record->cpu);
+	if (strncmp(arg, TEP_PRINT_LATENCY, strlen(TEP_PRINT_LATENCY)) == 0) {
+		tep_data_latency_format(tep, s, type->format, record);
+	} else if (strncmp(arg, TEP_PRINT_COMM, strlen(TEP_PRINT_COMM)) == 0) {
+		pid = parse_common_pid(tep, record->data);
+		comm = find_cmdline(tep, pid);
+		trace_seq_printf(s, type->format, comm);
+	} else if (strncmp(arg, TEP_PRINT_INFO, strlen(TEP_PRINT_INFO)) == 0) {
+		tep_event_info(s, type->format, event, record);
+	} else if  (strncmp(arg, TEP_PRINT_NAME, strlen(TEP_PRINT_NAME)) == 0) {
+		trace_seq_printf(s, type->format, event->name);
+	}
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
+static void tep_print_int(struct tep_handle *tep, struct trace_seq *s,
+			  struct tep_record *record, struct tep_event *event,
+			  int arg, struct print_event_type *type)
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
+		return tep_print_event_time(tep, s, type->format, event, record);
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
 
 	event = tep_find_event_by_record(tep, record);
-	if (!event) {
-		int i;
-		int type = trace_parse_common_type(tep, record->data);
-
-		do_warning("ug! no event found for type %d", type);
-		trace_seq_printf(s, "[UNKNOWN TYPE %d]", type);
-		for (i = 0; i < record->size; i++)
-			trace_seq_printf(s, " %02x",
-					 ((unsigned char *)record->data)[i]);
-		return;
-	}
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
+			tep_print_string(tep, s, record, event,
+					 va_arg(args, char*), &type);
+			break;
+		case EVENT_TYPE_INT:
+			tep_print_int(tep, s, record, event,
+				      va_arg(args, int), &type);
+			break;
+		case EVENT_TYPE_UNKNOWN:
+		default:
+			break;
+		}
+		str = current;
 
-	tep_print_event_task(tep, s, event, record);
-	tep_print_event_time(tep, s, event, record, use_trace_clock);
-	tep_print_event_data(tep, s, event, record);
+	}
+	va_end(args);
+	free(format);
 }
 
 static int events_id_cmp(const void *a, const void *b)
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 642f68ab5fb2..5ed5107a4ec4 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -442,18 +442,17 @@ int tep_register_print_string(struct tep_handle *tep, const char *fmt,
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
@@ -525,8 +524,6 @@ tep_find_event_by_name(struct tep_handle *tep, const char *sys, const char *name
 struct tep_event *
 tep_find_event_by_record(struct tep_handle *tep, struct tep_record *record);
 
-void tep_data_latency_format(struct tep_handle *tep,
-			     struct trace_seq *s, struct tep_record *record);
 int tep_data_type(struct tep_handle *tep, struct tep_record *rec);
 int tep_data_pid(struct tep_handle *tep, struct tep_record *rec);
 int tep_data_preempt_count(struct tep_handle *tep, struct tep_record *rec);
@@ -541,8 +538,6 @@ void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field);
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event *event);
-void tep_event_info(struct trace_seq *s, struct tep_event *event,
-		    struct tep_record *record);
 int tep_strerror(struct tep_handle *tep, enum tep_errno errnum,
 		 char *buf, size_t buflen);
 
@@ -566,12 +561,9 @@ bool tep_is_file_bigendian(struct tep_handle *tep);
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
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index b80eee455111..4f12569b4693 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -748,7 +748,8 @@ static int parse_gfp_flags(struct perf_evsel *evsel, struct perf_sample *sample,
 	}
 
 	trace_seq_init(&seq);
-	tep_event_info(&seq, evsel->tp_format, &record);
+	tep_print_event(evsel->tp_format->tep,
+			&seq, &record, "%s", TEP_PRINT_INFO);
 
 	str = strtok_r(seq.buffer, " ", &pos);
 	while (str) {
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 5d2518e89fc4..55a20bbbe236 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -711,7 +711,8 @@ static char *get_trace_output(struct hist_entry *he)
 		tep_print_fields(&seq, he->raw_data, he->raw_size,
 				 evsel->tp_format);
 	} else {
-		tep_event_info(&seq, evsel->tp_format, &rec);
+		tep_print_event(evsel->tp_format->tep,
+				&seq, &rec, "%s", TEP_PRINT_INFO);
 	}
 	/*
 	 * Trim the buffer, it starts at 4KB and we're not going to
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 863955e4094e..282b3a85fde3 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -126,7 +126,7 @@ void event_format__fprintf(struct tep_event *event,
 	record.data = data;
 
 	trace_seq_init(&s);
-	tep_event_info(&s, event, &record);
+	tep_print_event(event->tep, &s, &record, "%s", TEP_PRINT_INFO);
 	trace_seq_do_fprintf(&s, fp);
 	trace_seq_destroy(&s);
 }
-- 
2.21.0

