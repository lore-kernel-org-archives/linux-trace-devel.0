Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B061BC282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 16:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74C4120674
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 16:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbfDQQ0f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 12:26:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33520 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732305AbfDQQ0f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 12:26:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id q1so32801552wrp.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Apr 2019 09:26:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7qbJW/ZMsnmjHwwHE1zRdCORTexiO4TgGUgAJ44qfZ8=;
        b=oGNtd/PxubEPUyRStpl3e81jNuoZWAWdXBp+sdmowQNZMhiLIlPvf1PDFscKfa/7Xo
         qGsQQgVUBP/cESwEC5FGPZv2bNVu6RrvYmQy67yoU3U5VwOaruRLYEoJVu378gc44jYA
         SgHRJQLYBKYG9RrQ4aL/geg0rw+hBzFxhnPOfjvIFh4VSlQETG9J2Errf8Ep/+kEruQ+
         LU36HtecFhWAq/aeECfhaTUmPu5095nLA5VgfdsCGNMtz5ZrC4Uq/535k7NSnhhZMUHS
         6fGnSriT9OBbMBsg8YQxQTD3c5a0//lrxdJGDWmiLEmAsm0FWPdYIhQ85Kk0ZDf1AHYs
         fksw==
X-Gm-Message-State: APjAAAVDjhvfKyP3kAkqUVtDKBoUpYvKdYu2DL5Ru/ncWK+fY7Nv7dHm
        XQQiL2H4EaqGAqIgKjxiUUTh8NTN
X-Google-Smtp-Source: APXvYqxP7SXsDf+wMJFBJb4FWrhy4dO+0L6gcRRIVM0IIbyvL3IxQSs9L3ACEU/c/zNmi+tdSCOeEw==
X-Received: by 2002:adf:dccd:: with SMTP id x13mr512629wrm.326.1555518392871;
        Wed, 17 Apr 2019 09:26:32 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x18sm80323315wrw.14.2019.04.17.09.26.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 09:26:31 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] trace-cmd: Remove parsing_failures APIs from libtraceevent
Date:   Wed, 17 Apr 2019 19:26:30 +0300
Message-Id: <20190417162630.32240-1-tstoyanov@vmware.com>
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
parsing failures, if needed.
Introduced changes:
 - traceecent library: remove the parsing failures APIs and logic.
 - trace-cmd library:
	Added new parameter "int *parsing_failures" to tracecmd_fill_local_events().
	Added new parameter "int parsing_failures" to internal struct tracecmd_input
		and new API tracecmd_get_parsing_failures() to access it.
	Modified the logic in tracecmd_read_headers() to track failures while parsing
		the event files.
 - trace-cmd application:
	use the new trace-cmd library APIs to check the number of parsing failures.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h      |  4 +++-
 include/traceevent/event-parse.h   |  2 --
 lib/trace-cmd/trace-input.c        | 20 ++++++++++++++++++--
 lib/trace-cmd/trace-util.c         | 16 +++++++++-------
 lib/traceevent/event-parse-api.c   | 27 ---------------------------
 lib/traceevent/event-parse-local.h |  2 --
 tracecmd/trace-check-events.c      |  5 +++--
 tracecmd/trace-read.c              |  2 +-
 8 files changed, 34 insertions(+), 44 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index ca4452b..ceb03f4 100644
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
@@ -107,6 +108,7 @@ struct tracecmd_input *tracecmd_open_fd(int fd);
 void tracecmd_ref(struct tracecmd_input *handle);
 void tracecmd_close(struct tracecmd_input *handle);
 int tracecmd_read_headers(struct tracecmd_input *handle);
+int tracecmd_get_parsing_failures(struct tracecmd_input *handle);
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
index d5ee371..ba20ef1 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -96,6 +96,7 @@ struct tracecmd_input {
 	char *			cpustats;
 	char *			uname;
 	struct input_buffer_instance	*buffers;
+	int			parsing_failures;
 
 	struct tracecmd_ftrace	finfo;
 
@@ -413,7 +414,7 @@ static int read_ftrace_file(struct tracecmd_input *handle,
 			printf("%.*s\n", (int)size, buf);
 	} else {
 		if (tep_parse_event(pevent, buf, size, "ftrace"))
-			tep_set_parsing_failures(pevent, 1);
+			handle->parsing_failures++;
 	}
 	free(buf);
 
@@ -447,7 +448,7 @@ static int read_event_file(struct tracecmd_input *handle,
 		}
 	} else {
 		if (tep_parse_event(pevent, buf, size, system))
-			tep_set_parsing_failures(pevent, 1);
+			handle->parsing_failures++;
 	}
 	free(buf);
 
@@ -704,6 +705,19 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 
 static int read_and_parse_cmdlines(struct tracecmd_input *handle);
 
+/**
+ * tracecmd_get_parsing_failures - get the count of parsing failures
+ * @handle: input handle for the trace.dat file
+ *
+ * This returns the count of failures while parsing the event files
+ */
+int tracecmd_get_parsing_failures(struct tracecmd_input *handle)
+{
+	if (handle)
+		return handle->parsing_failures;
+	return 0;
+}
+
 /**
  * tracecmd_read_headers - read the header information from trace.dat
  * @handle: input handle for the trace.dat file
@@ -716,6 +730,8 @@ int tracecmd_read_headers(struct tracecmd_input *handle)
 {
 	int ret;
 
+	handle->parsing_failures = 0;
+
 	ret = read_header_files(handle);
 	if (ret < 0)
 		return -1;
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
index a0e05f5..5fd5d4a 100644
--- a/tracecmd/trace-check-events.c
+++ b/tracecmd/trace-check-events.c
@@ -13,6 +13,7 @@ void trace_check_events(int argc, char **argv)
 {
 	const char *tracing;
 	int ret, c;
+	int parsing_failures = 0;
 	struct tep_handle *pevent = NULL;
 	struct tep_plugin_list *list = NULL;
 
@@ -42,8 +43,8 @@ void trace_check_events(int argc, char **argv)
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
index 52fa1bd..a7ffcc5 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1717,7 +1717,7 @@ void trace_report (int argc, char **argv)
 
 		ret = tracecmd_read_headers(handle);
 		if (check_event_parsing) {
-			if (ret || tep_get_parsing_failures(pevent))
+			if (ret || tracecmd_get_parsing_failures(handle))
 				exit(EINVAL);
 			else
 				exit(0);
-- 
2.20.1

