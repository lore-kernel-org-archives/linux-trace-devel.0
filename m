Return-Path: <SRS0=bY76=V5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6D6C19759
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Aug 2019 07:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 414512087E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Aug 2019 07:50:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LvWQeqDM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbfHAHuJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 03:50:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35435 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbfHAHuI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 03:50:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id y4so72472817wrm.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 01 Aug 2019 00:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KIDTiwBZp6uyn1radIMFS0FNBFUxTWHrcyHwA1r0/YY=;
        b=LvWQeqDMc6NatGQQfyoaqblEoqmkJ62Bvssy4UZn/FCtA/zc3/homnceEAnpLE3TGN
         1QybIogx/ZdvljsalaD2zouF10LDAIPcEksaS444vv2vFYwrYmH7bSF5LkKKxS4J9BUh
         lGZi62oxxsloDRFwJjujOY2rWkQGwGnhiO4Nruvo33ja9loRiqG8jIhC/0bbittOauQR
         tIoiT6u2orUZn9lIjY/5BInLnr1y0eDKsYGUPN8KVkuA9jyMQtAXGkQGgLE0AmLJoPwB
         V/0/Wkka/YhFkLSnH8fGrubw2qzv/gpX7mXWhyRXlAQYNLc4pnSYTOtPrFAe8be7HwPY
         3vNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KIDTiwBZp6uyn1radIMFS0FNBFUxTWHrcyHwA1r0/YY=;
        b=lxr2dMmmHVEKl6eziR1XJJrU44Wfc3apJFxR3JK2i5Dn8C247T609WIBp9ornq4yUE
         TgwCqvxbVNTjJ3R3aWKmjwVcEpz9OZd5qK6QbGY3/sAZ1sIRdROhdYZB0gYL/67jxG2h
         Cf7s5rlwRqB4z3z/zRAjQU8RAWEOyvt1JVZb6/9a5F6hVqmZ5Hv12NoJu1T/LuoLwW5l
         sJ/AtKYxruhGaHzC4EGCa/My8N1Sf3cIGxbcEB1qYdrAFM7Xk+Cltj/DStIo9cStPHI5
         Oqbe9TUMIqL27sYKUteWN2Km9m44wkv5vPH4rABA92xkYzD+k8Ga+M2bpNwprFQ4vOC+
         wz/Q==
X-Gm-Message-State: APjAAAVgk/4MmesdSQBI5Or6zlErtwxRX2ZpoFZXHECc3ZXewbsOXmYt
        b25RWu0CCniqIVNQTHPCG68S3pgB2Xs=
X-Google-Smtp-Source: APXvYqz9sb4V72IUsY6TxM2bUBImc2y+zX8fJPqa1Pvuz1ado6G34NNLG9WqmqcSLoNaTm5o42xblw==
X-Received: by 2002:adf:ed4a:: with SMTP id u10mr53485928wro.284.1564645803896;
        Thu, 01 Aug 2019 00:50:03 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u2sm4033483wmc.3.2019.08.01.00.50.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 00:50:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 1/3] tools/lib/traceevent, tools/perf: Changes in tep_print_event_* APIs
Date:   Thu,  1 Aug 2019 10:49:57 +0300
Message-Id: <20190801074959.22023-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801074959.22023-1-tz.stoyanov@gmail.com>
References: <20190801074959.22023-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

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
 TEP_PRINT_INFO, "%s" - event information.
 TEP_PRINT_INFO_RAW, "%s" - event information, in raw format.

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
 tools/lib/traceevent/event-parse.c       | 322 +++++++++++++----------
 tools/lib/traceevent/event-parse.h       |  29 +-
 tools/perf/builtin-kmem.c                |   3 +-
 tools/perf/util/sort.c                   |   3 +-
 tools/perf/util/trace-event-parse.c      |   2 +-
 7 files changed, 203 insertions(+), 200 deletions(-)

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
index b36b536a9fcb..0f2bc23efdca 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5170,24 +5170,20 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
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
@@ -5195,6 +5191,7 @@ void tep_data_latency_format(struct tep_handle *tep,
 	int softirq;
 	void *data = record->data;
 
+	trace_seq_init(&sq);
 	lat_flags = parse_common_flags(tep, data);
 	pc = parse_common_pc(tep, data);
 	/* lock_depth may not always exist */
@@ -5222,7 +5219,7 @@ void tep_data_latency_format(struct tep_handle *tep,
 	hardirq = lat_flags & TRACE_FLAG_HARDIRQ;
 	softirq = lat_flags & TRACE_FLAG_SOFTIRQ;
 
-	trace_seq_printf(s, "%c%c%c",
+	trace_seq_printf(&sq, "%c%c%c",
 	       (lat_flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
 	       (lat_flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
 	       'X' : '.',
@@ -5232,24 +5229,32 @@ void tep_data_latency_format(struct tep_handle *tep,
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
 
@@ -5410,21 +5415,16 @@ int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline)
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
 
@@ -5439,20 +5439,6 @@ void tep_event_info(struct trace_seq *s, struct tep_event *event,
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
@@ -5476,129 +5462,195 @@ tep_find_event_by_record(struct tep_handle *tep, struct tep_record *record)
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
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 642f68ab5fb2..cf7f302eb44a 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -442,18 +442,18 @@ int tep_register_print_string(struct tep_handle *tep, const char *fmt,
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
@@ -525,8 +525,6 @@ tep_find_event_by_name(struct tep_handle *tep, const char *sys, const char *name
 struct tep_event *
 tep_find_event_by_record(struct tep_handle *tep, struct tep_record *record);
 
-void tep_data_latency_format(struct tep_handle *tep,
-			     struct trace_seq *s, struct tep_record *record);
 int tep_data_type(struct tep_handle *tep, struct tep_record *rec);
 int tep_data_pid(struct tep_handle *tep, struct tep_record *rec);
 int tep_data_preempt_count(struct tep_handle *tep, struct tep_record *rec);
@@ -541,8 +539,6 @@ void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field);
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event *event);
-void tep_event_info(struct trace_seq *s, struct tep_event *event,
-		    struct tep_record *record);
 int tep_strerror(struct tep_handle *tep, enum tep_errno errnum,
 		 char *buf, size_t buflen);
 
@@ -566,12 +562,9 @@ bool tep_is_file_bigendian(struct tep_handle *tep);
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
index 9e5e60898083..6f9b15ee252e 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -749,7 +749,8 @@ static int parse_gfp_flags(struct perf_evsel *evsel, struct perf_sample *sample,
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
index b3982e1bb4c5..3c5fef614d89 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -110,7 +110,7 @@ void event_format__fprintf(struct tep_event *event,
 	record.data = data;
 
 	trace_seq_init(&s);
-	tep_event_info(&s, event, &record);
+	tep_print_event(event->tep, &s, &record, "%s", TEP_PRINT_INFO);
 	trace_seq_do_fprintf(&s, fp);
 	trace_seq_destroy(&s);
 }
-- 
2.21.0

