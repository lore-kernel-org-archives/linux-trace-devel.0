Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A99C282DA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 12:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6BDB2064A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 12:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfDOM62 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 08:58:28 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50443 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbfDOM62 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 08:58:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id z11so20644035wmi.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 05:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ijbYBW3hm+omLn7uBZlkxdK1ZF+CDuXaQ5oHkn4qARM=;
        b=rlCx3e/UMp3dI16/Z6Mqrc+P8VvH2kQDeoeBxbaG6m9NFJpUML+cnImPKq0DALlTBj
         cL83EzMZRhKYMKOLh2vaupWEC4xKyMRXc278AGjGw36yTkmIxxTa4Yppzv5Oml4HvNku
         X+v6oe6G6iWMnmMeKFHafChCaHEzlxzoB7vuu8d/MAGsWVt0ee0I1h9Uj0Nc8XC7PCr/
         JfTXqytQPWVf0PAwdOvDWJ3LSoz7j/MT/hxgVLqAewTDYKIsi521PCJCBN9wJiSUzaWV
         x8DG1CuUDddcLEThcIlbb8dMKvA5ISfrX69izE18/7eoTsXIJGNn70pO+oqTJCa6sxvQ
         a+FQ==
X-Gm-Message-State: APjAAAX4y0ljj8tSgZisjMKctPsg/vorIPwR1TQE11hlFlriyk9K82ow
        riyMAE3RXx4fuaQocdc4JdX8UE7C
X-Google-Smtp-Source: APXvYqwIvGWR00tnzZFaGaf9e6b0JbQkIhdUhmfkiKscvBkyWMRHDi9oMwgWQIY35vZxsS90lLxsQg==
X-Received: by 2002:a1c:40c3:: with SMTP id n186mr22533166wma.3.1555333105091;
        Mon, 15 Apr 2019 05:58:25 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d3sm37292462wmf.46.2019.04.15.05.58.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Apr 2019 05:58:24 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: remove parsing_failures APIs from libtraceevent
Date:   Mon, 15 Apr 2019 15:58:22 +0300
Message-Id: <20190415125823.4011-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The application, which uses libtraceevent, should track itself the number of
failures while parsing the event files. The libtraceevent APIs return error
in case of such failure. The application can check for it and track the
parcing failures, if needed.
The patch changes:
 - traceecent library: remove the parsing failures APIs and logic.
 - trace-cmd library:
	added new parameter "int *parsing_failures" to tracecmd_fill_local_events().
	implemented new API tracecmd_read_headers_failures(), which returns
		the number of failures while parsing the event files.
 - trace-cmd application:
	use the new trace-cmd library APIs to track the number of parsing failures.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h      |  5 +-
 include/traceevent/event-parse.h   |  2 -
 lib/trace-cmd/trace-input.c        | 76 +++++++++++++++++++++---------
 lib/trace-cmd/trace-util.c         | 16 ++++---
 lib/traceevent/event-parse-api.c   | 27 -----------
 lib/traceevent/event-parse-local.h |  2 -
 tracecmd/trace-check-events.c      |  6 +--
 tracecmd/trace-read.c              |  7 +--
 8 files changed, 73 insertions(+), 68 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index ca4452b..c0eb7e1 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -32,7 +32,8 @@ void tracecmd_unload_plugins(struct tep_plugin_list *list, struct tep_handle *pe
 char **tracecmd_event_systems(const char *tracing_dir);
 char **tracecmd_system_events(const char *tracing_dir, const char *system);
 struct tep_handle *tracecmd_local_events(const char *tracing_dir);
-int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *pevent);
+int tracecmd_fill_local_events(const char *tracing_dir,
+			       struct tep_handle *pevent, int *parsing_failures);
 char **tracecmd_local_plugins(const char *tracing_dir);
 
 char **tracecmd_add_list(char **list, const char *name, int len);
@@ -107,6 +108,8 @@ struct tracecmd_input *tracecmd_open_fd(int fd);
 void tracecmd_ref(struct tracecmd_input *handle);
 void tracecmd_close(struct tracecmd_input *handle);
 int tracecmd_read_headers(struct tracecmd_input *handle);
+int tracecmd_read_headers_failures(struct tracecmd_input *handle,
+				   int *parsing_failures);
 int tracecmd_long_size(struct tracecmd_input *handle);
 int tracecmd_page_size(struct tracecmd_input *handle);
 int tracecmd_cpus(struct tracecmd_input *handle);
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index bded403..5e0fd19 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -557,8 +557,6 @@ void tep_set_local_bigendian(struct tep_handle *tep, enum tep_endian endian);
 bool tep_is_latency_format(struct tep_handle *tep);
 void tep_set_latency_format(struct tep_handle *tep, int lat);
 int tep_get_header_page_size(struct tep_handle *tep);
-void tep_set_parsing_failures(struct tep_handle *tep, int parsing_failures);
-int tep_get_parsing_failures(struct tep_handle *tep);
 int tep_get_header_timestamp_size(struct tep_handle *tep);
 bool tep_is_old_format(struct tep_handle *tep);
 void tep_set_print_raw(struct tep_handle *tep, int print_raw);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index d5ee371..565675f 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -395,7 +395,8 @@ static int regex_event_buf(const char *file, int size, regex_t *epreg)
 
 static int read_ftrace_file(struct tracecmd_input *handle,
 			    unsigned long long size,
-			    int print, regex_t *epreg)
+			    int print, regex_t *epreg,
+			    int *parsing_failures)
 {
 	struct tep_handle *pevent = handle->pevent;
 	char *buf;
@@ -412,8 +413,9 @@ static int read_ftrace_file(struct tracecmd_input *handle,
 		if (print || regex_event_buf(buf, size, epreg))
 			printf("%.*s\n", (int)size, buf);
 	} else {
-		if (tep_parse_event(pevent, buf, size, "ftrace"))
-			tep_set_parsing_failures(pevent, 1);
+		if (tep_parse_event(pevent, buf, size, "ftrace") &&
+		    parsing_failures)
+			(*parsing_failures)++;
 	}
 	free(buf);
 
@@ -423,7 +425,7 @@ static int read_ftrace_file(struct tracecmd_input *handle,
 static int read_event_file(struct tracecmd_input *handle,
 			   char *system, unsigned long long size,
 			   int print, int *sys_printed,
-			   regex_t *epreg)
+			   regex_t *epreg, int *parsing_failures)
 {
 	struct tep_handle *pevent = handle->pevent;
 	char *buf;
@@ -446,8 +448,9 @@ static int read_event_file(struct tracecmd_input *handle,
 			printf("%.*s\n", (int)size, buf);
 		}
 	} else {
-		if (tep_parse_event(pevent, buf, size, system))
-			tep_set_parsing_failures(pevent, 1);
+		if (tep_parse_event(pevent, buf, size, system) &&
+		    parsing_failures)
+			(*parsing_failures)++;
 	}
 	free(buf);
 
@@ -497,7 +500,8 @@ static int make_preg_files(const char *regex, regex_t *system,
 	return ret;
 }
 
-static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
+static int read_ftrace_files(struct tracecmd_input *handle, const char *regex,
+			     int *parsing_failures)
 {
 	unsigned long long size;
 	regex_t spreg;
@@ -542,7 +546,8 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 	for (i = 0; i < count; i++) {
 		if (read8(handle, &size) < 0)
 			return -1;
-		ret = read_ftrace_file(handle, size, print_all, ereg);
+		ret = read_ftrace_file(handle, size, print_all,
+				       ereg, parsing_failures);
 		if (ret < 0)
 			return -1;
 	}
@@ -558,7 +563,8 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 	return 0;
 }
 
-static int read_event_files(struct tracecmd_input *handle, const char *regex)
+static int read_event_files(struct tracecmd_input *handle, const char *regex,
+			    int *parsing_failures)
 {
 	unsigned long long size;
 	char *system;
@@ -625,7 +631,7 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 
 			ret = read_event_file(handle, system, size,
 					      print_all, &sys_printed,
-					      reg);
+					      reg, parsing_failures);
 			if (ret < 0)
 				goto failed;
 		}
@@ -704,27 +710,23 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 
 static int read_and_parse_cmdlines(struct tracecmd_input *handle);
 
-/**
- * tracecmd_read_headers - read the header information from trace.dat
- * @handle: input handle for the trace.dat file
- *
- * This reads the trace.dat file for various information. Like the
- * format of the ring buffer, event formats, ftrace formats, kallsyms
- * and printk.
- */
-int tracecmd_read_headers(struct tracecmd_input *handle)
+static int _tracecmd_read_headers(struct tracecmd_input *handle,
+				  int *parsing_failures)
 {
 	int ret;
 
+	if (parsing_failures)
+		*parsing_failures = 0;
+
 	ret = read_header_files(handle);
 	if (ret < 0)
 		return -1;
 
-	ret = read_ftrace_files(handle, NULL);
+	ret = read_ftrace_files(handle, NULL, parsing_failures);
 	if (ret < 0)
 		return -1;
 
-	ret = read_event_files(handle, NULL);
+	ret = read_event_files(handle, NULL, parsing_failures);
 	if (ret < 0)
 		return -1;
 
@@ -744,6 +746,34 @@ int tracecmd_read_headers(struct tracecmd_input *handle)
 	return 0;
 }
 
+/**
+ * tracecmd_read_headers - read the header information from trace.dat
+ * @handle: input handle for the trace.dat file
+ *
+ * This reads the trace.dat file for various information. Like the
+ * format of the ring buffer, event formats, ftrace formats, kallsyms
+ * and printk.
+ */
+int tracecmd_read_headers(struct tracecmd_input *handle)
+{
+	return _tracecmd_read_headers(handle, NULL);
+}
+
+/**
+ * tracecmd_read_headers_failures - read the header information from trace.dat
+ * @handle: input handle for the trace.dat file
+ * @parsing_failures: return number of failures while parsing the event files
+ *
+ * This reads the trace.dat file for various information. Like the
+ * format of the ring buffer, event formats, ftrace formats, kallsyms
+ * and printk.
+ */
+int tracecmd_read_headers_failures(struct tracecmd_input *handle,
+				   int *parsing_failures)
+{
+	return _tracecmd_read_headers(handle, parsing_failures);
+}
+
 static unsigned long long calc_page_offset(struct tracecmd_input *handle,
 					   unsigned long long offset)
 {
@@ -2508,11 +2538,11 @@ void tracecmd_print_events(struct tracecmd_input *handle, const char *regex)
 		lseek64(handle->fd, handle->header_files_start, SEEK_SET);
 		read_header_files(handle);
 	}
-	ret = read_ftrace_files(handle, regex);
+	ret = read_ftrace_files(handle, regex, NULL);
 	if (ret < 0)
 		return;
 
-	read_event_files(handle, regex);
+	read_event_files(handle, regex, NULL);
 	return;
 }
 
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b5aea39..8d21fb2 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -1134,7 +1134,7 @@ struct tep_handle *tracecmd_local_events(const char *tracing_dir)
 	if (!pevent)
 		return NULL;
 
-	if (tracecmd_fill_local_events(tracing_dir, pevent)) {
+	if (tracecmd_fill_local_events(tracing_dir, pevent, NULL)) {
 		tep_free(pevent);
 		pevent = NULL;
 	}
@@ -1146,19 +1146,23 @@ struct tep_handle *tracecmd_local_events(const char *tracing_dir)
  * tracecmd_fill_local_events - Fill a pevent with the events on system
  * @tracing_dir: The directory that contains the events.
  * @pevent: Allocated pevent which will be filled
+ * @parsing_failures: return number of failures while parsing the event files
  *
  * Returns whether the operation succeeded
  */
-int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *pevent)
+int tracecmd_fill_local_events(const char *tracing_dir,
+			       struct tep_handle *pevent, int *parsing_failures)
 {
 	struct dirent *dent;
 	char *events_dir;
 	struct stat st;
 	DIR *dir;
-	int ret, failure = 0;
+	int ret;
 
 	if (!tracing_dir)
 		return -1;
+	if (parsing_failures)
+		*parsing_failures = 0;
 
 	events_dir = append_file(tracing_dir, "events");
 	if (!events_dir)
@@ -1201,8 +1205,8 @@ int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *peven
 
 		free(sys);
 
-		if (ret)
-			failure = 1;
+		if (ret && parsing_failures)
+			(*parsing_failures)++;
 	}
 
 	closedir(dir);
@@ -1212,8 +1216,6 @@ int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *peven
  out_free:
 	free(events_dir);
 
-	tep_set_parsing_failures(pevent, failure);
-
 	return ret;
 }
 
diff --git a/lib/traceevent/event-parse-api.c b/lib/traceevent/event-parse-api.c
index 8ef496b..9885878 100644
--- a/lib/traceevent/event-parse-api.c
+++ b/lib/traceevent/event-parse-api.c
@@ -329,33 +329,6 @@ void tep_set_latency_format(struct tep_handle *tep, int lat)
 		tep->latency_format = lat;
 }
 
-/**
- * tep_set_parsing_failures - set parsing failures flag
- * @tep: a handle to the tep_handle
- * @parsing_failures: the new value of the parsing_failures flag
- *
- * This sets flag "parsing_failures" to the given count
- */
-void tep_set_parsing_failures(struct tep_handle *tep, int parsing_failures)
-{
-	if (tep)
-		tep->parsing_failures = parsing_failures;
-}
-
-/**
- * tep_get_parsing_failures - get the parsing failures flag
- * @tep: a handle to the tep_handle
- *
- * This returns value of flag "parsing_failures"
- * If @tep is NULL, 0 is returned.
- */
-int tep_get_parsing_failures(struct tep_handle *tep)
-{
-	if (tep)
-		return tep->parsing_failures;
-	return 0;
-}
-
 /**
  * tep_is_old_format - get if an old kernel is used
  * @tep: a handle to the tep_handle
diff --git a/lib/traceevent/event-parse-local.h b/lib/traceevent/event-parse-local.h
index 6e16cdb..09aa142 100644
--- a/lib/traceevent/event-parse-local.h
+++ b/lib/traceevent/event-parse-local.h
@@ -83,8 +83,6 @@ struct tep_handle {
 	struct event_handler *handlers;
 	struct tep_function_handler *func_handlers;
 
-	int parsing_failures;
-
 	/* cache */
 	struct tep_event *last_event;
 
diff --git a/tracecmd/trace-check-events.c b/tracecmd/trace-check-events.c
index a0e05f5..f443df1 100644
--- a/tracecmd/trace-check-events.c
+++ b/tracecmd/trace-check-events.c
@@ -12,7 +12,7 @@
 void trace_check_events(int argc, char **argv)
 {
 	const char *tracing;
-	int ret, c;
+	int ret, c, parsing_failures = 0;
 	struct tep_handle *pevent = NULL;
 	struct tep_plugin_list *list = NULL;
 
@@ -42,8 +42,8 @@ void trace_check_events(int argc, char **argv)
 	if (!pevent)
 		exit(EINVAL);
 	list = tracecmd_load_plugins(pevent);
-	ret = tracecmd_fill_local_events(tracing, pevent);
-	if (ret || tep_get_parsing_failures(pevent))
+	ret = tracecmd_fill_local_events(tracing, pevent, &parsing_failures);
+	if (ret || parsing_failures)
 		ret = EINVAL;
 	tracecmd_unload_plugins(list, pevent);
 	tep_free(pevent);
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 52fa1bd..fe116cc 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1417,6 +1417,7 @@ void trace_report (int argc, char **argv)
 	unsigned long long tsoffset = 0;
 	unsigned long long ts2secs = 0;
 	unsigned long long ts2sc;
+	int parsing_failures;
 	int show_stat = 0;
 	int show_funcs = 0;
 	int show_endian = 0;
@@ -1714,10 +1715,10 @@ void trace_report (int argc, char **argv)
 			tracecmd_print_events(handle, print_event);
 			return;
 		}
-
-		ret = tracecmd_read_headers(handle);
+		parsing_failures = 0;
+		ret = tracecmd_read_headers_failures(handle, &parsing_failures);
 		if (check_event_parsing) {
-			if (ret || tep_get_parsing_failures(pevent))
+			if (ret || parsing_failures)
 				exit(EINVAL);
 			else
 				exit(0);
-- 
2.20.1

