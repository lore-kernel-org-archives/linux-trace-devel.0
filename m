Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2951C63707
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Jan 2023 18:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbjAFSjg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 13:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbjAFSje (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 13:39:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A1B7CDDB
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 10:39:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37E6F61F22
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 18:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D3AC43398;
        Fri,  6 Jan 2023 18:39:32 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pDrcp-0003L6-0G;
        Fri, 06 Jan 2023 13:39:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 06/10] trace-cmd: Have trace_stream_read() use poll()
Date:   Fri,  6 Jan 2023 13:39:26 -0500
Message-Id: <20230106183930.12565-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230106183930.12565-1-rostedt@goodmis.org>
References: <20230106183930.12565-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Replace the select() that is used in trace_stream_read() with poll() as that
is the more robust function, as select() is limited to fds that are less than
1024, and today's kernels can have fds bigger than that.

As a side-effect, since poll() uses milliseconds for its timeout, the
granularity of the timeout is no longer microseconds, even though that is
what is passed in on the command line. We may need to changes this.

If 1us is passed in, it will be rounded up to 1ms. But zero and negative
numbers shall remain the same.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  2 +-
 tracecmd/trace-record.c        | 13 +++++--------
 tracecmd/trace-stream.c        | 34 +++++++++++++++-------------------
 3 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 023afb3baad1..ae208fb6b593 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -137,7 +137,7 @@ struct tracecmd_input *
 trace_stream_init(struct buffer_instance *instance, int cpu, int fd, int cpus,
 		  struct hook_list *hooks,
 		  tracecmd_handle_init_func handle_init, int global);
-int trace_stream_read(struct pid_record_data *pids, int nr_pids, struct timeval *tv);
+int trace_stream_read(struct pid_record_data *pids, int nr_pids, long sleep_us);
 
 void trace_show_data(struct tracecmd_input *handle, struct tep_record *record);
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 83ae8e60d7cb..03f990e3b2d1 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -73,7 +73,7 @@ static int rt_prio;
 static int keep;
 
 static int latency;
-static int sleep_time = 1000;
+static long sleep_time = 1000;
 static int recorder_threads;
 static struct pid_record_data *pids;
 static int buffers;
@@ -798,8 +798,7 @@ static void stop_threads(enum trace_type type)
 	/* Flush out the pipes */
 	if (type & TRACE_TYPE_STREAM) {
 		do {
-			struct timeval tv = { 0, 0 };
-			ret = trace_stream_read(pids, recorder_threads, &tv);
+			ret = trace_stream_read(pids, recorder_threads, 0);
 		} while (ret > 0);
 	}
 }
@@ -1307,7 +1306,6 @@ static void update_task_filter(void)
 
 static pid_t trace_waitpid(enum trace_type type, pid_t pid, int *status, int options)
 {
-	struct timeval tv = { 1, 0 };
 	int ret;
 
 	if (type & TRACE_TYPE_STREAM)
@@ -1319,7 +1317,7 @@ static pid_t trace_waitpid(enum trace_type type, pid_t pid, int *status, int opt
 			return ret;
 
 		if (type & TRACE_TYPE_STREAM)
-			trace_stream_read(pids, recorder_threads, &tv);
+			trace_stream_read(pids, recorder_threads, sleep_time);
 	} while (1);
 }
 
@@ -1640,14 +1638,13 @@ static inline void ptrace_attach(struct buffer_instance *instance, int pid) { }
 
 static void trace_or_sleep(enum trace_type type, bool pwait)
 {
-	struct timeval tv = { 1 , 0 };
 	int i;
 
 	if (pwait)
 		ptrace_wait(type);
 	else if (type & TRACE_TYPE_STREAM) {
 		/* Returns zero if it did not read anything (and did a sleep) */
-		if (trace_stream_read(pids, recorder_threads, &tv) > 0)
+		if (trace_stream_read(pids, recorder_threads, sleep_time) > 0)
 			return;
 		/* Force a flush if nothing was read (including on errors) */
 		for (i = 0; i < recorder_threads; i++) {
@@ -7021,7 +7018,7 @@ static void record_trace(int argc, char **argv,
 			trace_or_sleep(type, pwait);
 		/* Streams need to be flushed one more time */
 		if (type & TRACE_TYPE_STREAM)
-			trace_stream_read(pids, recorder_threads, NULL);
+			trace_stream_read(pids, recorder_threads, -1);
 	}
 
 	tell_guests_to_stop(ctx);
diff --git a/tracecmd/trace-stream.c b/tracecmd/trace-stream.c
index d83513f8aa89..ec6a10f7a6fa 100644
--- a/tracecmd/trace-stream.c
+++ b/tracecmd/trace-stream.c
@@ -4,6 +4,7 @@
  *
  */
 #include <stdio.h>
+#include <poll.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <errno.h>
@@ -83,17 +84,19 @@ trace_stream_init(struct buffer_instance *instance, int cpu, int fd, int cpus,
 	return NULL;
 }
 
-int trace_stream_read(struct pid_record_data *pids, int nr_pids, struct timeval *tv)
+int trace_stream_read(struct pid_record_data *pids, int nr_pids, long sleep_us)
 {
-	struct tep_record *record;
-	struct pid_record_data *pid;
 	struct pid_record_data *last_pid;
-	fd_set rfds;
-	int top_rfd = 0;
-	int nr_fd;
+	struct pid_record_data *pid;
+	struct tep_record *record;
+	struct pollfd pollfd[nr_pids];
+	long sleep_ms = sleep_us > 0 ? (sleep_us + 999) / 1000 : sleep_us;
 	int ret;
 	int i;
 
+	if (!nr_pids)
+		return 0;
+
 	last_pid = NULL;
 
  again:
@@ -118,25 +121,18 @@ int trace_stream_read(struct pid_record_data *pids, int nr_pids, struct timeval
 		return 1;
 	}
 
-	nr_fd = 0;
-	FD_ZERO(&rfds);
-
 	for (i = 0; i < nr_pids; i++) {
 		/* Do not process closed pipes */
-		if (pids[i].closed)
+		if (pids[i].closed) {
+			memset(pollfd + i, 0, sizeof(*pollfd));
 			continue;
-		nr_fd++;
-		if (pids[i].brass[0] > top_rfd)
-			top_rfd = pids[i].brass[0];
+		}
 
-		FD_SET(pids[i].brass[0], &rfds);
+		pollfd[i].fd = pids[i].brass[0];
+		pollfd[i].events = POLLIN;
 	}
 
-	if (!nr_fd)
-		return 0;
-
-	ret = select(top_rfd + 1, &rfds, NULL, NULL, tv);
-
+	ret = poll(pollfd, nr_pids, sleep_ms);
 	if (ret > 0)
 		goto again;
 
-- 
2.35.1

